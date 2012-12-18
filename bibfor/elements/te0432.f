      SUBROUTINE TE0432(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/12/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          POUR LES GRILLES MEMBRANES EXCENTREES OU NON
C                          EN DYNAMIQUE
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER CODRES(2)
      CHARACTER*4 FAMI
      CHARACTER*1 STOPZ(3)
      INTEGER NNO,NPG,I,IMATUU,NDIM,NNOS,JGANO
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER IRET,IRETD,IRETV
      INTEGER KPG,N,J,KKD,M,K
      INTEGER KK,NDDL
      INTEGER IACCE, IVECT, L, NVEC,IVITE,IFREQ,IECIN,IDEPL
      REAL*8 DFF(2,8),P(3,6),TREF
      REAL*8 DIR11(3),VFF(8),B(6,8),JAC,RHO
      REAL*8 DENSIT,VECN(3)
      REAL*8 DISTN,PGL(3,3),MASDEP(48)
      REAL*8 AEXC(3,3,8,8), A(6,6,8,8),COEF,MATV(1176),MATP(48,48)
      REAL*8 DIAG(3,8),WGT,ALFAM(3),SOMME(3),MASVIT(48),DDOT,ECIN
      LOGICAL LEXC,LDIAG


      LEXC = (NOMTE(1:4).EQ.'MEGC')
      LDIAG = (OPTION(1:10).EQ.'MASS_MECA_')


C - FONCTIONS DE FORMES ET POINTS DE GAUSS
      FAMI = 'MASS'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      CALL RCVARC(' ','TEMP','REF',FAMI,1,1,TREF,IRET)
      CALL R8INIR(8*8*6*6,0.D0,A,1)
      CALL R8INIR(8*8*3*3,0.D0,AEXC,1)

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      IF (OPTION.EQ.'MASS_MECA') THEN

      ELSEIF (OPTION.EQ.'M_GAMMA') THEN
        CALL JEVECH('PACCELR','L',IACCE)
      ELSEIF (OPTION.EQ.'ECIN_ELEM') THEN
        STOPZ(1)='O'
        STOPZ(2)='N'
        STOPZ(3)='O'
        CALL TECACH(STOPZ,'PVITESR',1,IVITE,IRETV)
        IF (IRETV.NE.0) THEN
          CALL TECACH(STOPZ,'PDEPLAR',1,IDEPL,IRETD)
          IF (IRETD.EQ.0) THEN
            CALL JEVECH('POMEGA2','L',IFREQ)
          ELSE
            CALL U2MESK('F','ELEMENTS2_1',1,OPTION)
          ENDIF
        ENDIF
      ENDIF

C PARAMETRES EN SORTIE

      IF (OPTION(1:9).EQ.'MASS_MECA') THEN
        CALL JEVECH('PMATUUR','E',IMATUU)
      ELSEIF (OPTION.EQ.'M_GAMMA') THEN
        CALL JEVECH('PVECTUR','E',IVECT)
      ELSEIF (OPTION.EQ.'ECIN_ELEM') THEN
        CALL JEVECH('PENERCR','E',IECIN)
      ENDIF


C - INITIALISATION CODES RETOURS
C       DO 1955 KPG=1,NPG
C          COD(KPG)=0
C 1955  CONTINUE


C - LECTURE DES CARACTERISTIQUES DE GRILLE ET
C   CALCUL DE LA DIRECTION D'ARMATURE

      CALL CARGRI(LEXC,DENSIT,DISTN,DIR11)


C --- SI EXCENTREE : RECUPERATION DE LA NORMALE ET DE L'EXCENTREMENT

      IF (LEXC) THEN

        IF (NOMTE.EQ.'MEGCTR3') THEN
          CALL DXTPGL(ZR(IGEOM),PGL)
        ELSEIF (NOMTE.EQ.'MEGCQU4') THEN
          CALL DXQPGL(ZR(IGEOM),PGL,'S',IRET)
        ENDIF

        DO 8 I=1,3
          VECN(I)=DISTN*PGL(3,I)
8       CONTINUE

        NDDL=6

      ELSE

        NDDL  = 3

      ENDIF
C
C - CALCUL POUR CHAQUE POINT DE GAUSS : ON CALCULE D'ABORD LA
C      CONTRAINTE ET/OU LA RIGIDITE SI NECESSAIRE PUIS
C      ON JOUE AVEC B
C
      WGT = 0.D0
      DO 800 KPG=1,NPG

C - MISE SOUS FORME DE TABLEAU DES VALEURS DES FONCTIONS DE FORME
C   ET DES DERIVEES DE FONCTION DE FORME

        DO 11 N=1,NNO
          VFF(N)  =ZR(IVF+(KPG-1)*NNO+N-1)
          DFF(1,N)=ZR(IDFDE+(KPG-1)*NNO*2+(N-1)*2)
          DFF(2,N)=ZR(IDFDE+(KPG-1)*NNO*2+(N-1)*2+1)
11      CONTINUE

C - MASS_MECA

        CALL RCVALB(FAMI,KPG,1,'+',ZI(IMATE),' ','ELAS',0,' ',0.D0,1,
     &                 'RHO',RHO,CODRES, 1)


C - CALCUL DE LA MATRICE "B" : DEPL NODAL -> EPS11 ET DU JACOBIEN

        CALL NMGRIB(NNO,ZR(IGEOM),DFF,DIR11,LEXC,VECN,B,JAC,P)
        WGT = WGT + RHO*ZR(IPOIDS+KPG-1)*JAC*DENSIT

        DO 130 N=1,NNO
          DO 130 I=1,N
            COEF = RHO*ZR(IPOIDS+KPG-1)*JAC*DENSIT*VFF(N)*VFF(I)
            A(1,1,N,I) = A(1,1,N,I) + COEF
            A(2,2,N,I) = A(2,2,N,I) + COEF
            A(3,3,N,I) = A(3,3,N,I) + COEF
130     CONTINUE

        IF (LEXC) THEN
          DO 135 I=1,3
            DO 135 J=1,3
              DO 135 N=1,NNO
                DO 135 M=1,N
                  AEXC(I,J,N,M) = A(I,J,N,M)
135       CONTINUE
          CALL R8INIR(8*8*6*6,0.D0,A,1)
          DO 140 I=1,6
            DO 140 J=1,6
              DO 140 N=1,NNO
                DO 140 M=1,N
                  DO 140 K=1,3
                    A(I,J,N,M) = A(I,J,N,M)+P(K,I)*P(K,J)
     &                                *AEXC(K,K,N,M)
140       CONTINUE
        ENDIF

800   CONTINUE

C - RANGEMENT DES RESULTATS
C -------------------------
      IF (LDIAG) THEN

C-- CALCUL DE LA TRACE EN TRANSLATION SUIVANT X

        CALL R8INIR(3*8,0.D0,DIAG,1)
        CALL R8INIR(3,0.D0,SOMME,1)
        DO 180 I=1,3
          DO 181 J = 1,NNO
            SOMME(I) = SOMME(I) + A(I,I,J,J)
181       CONTINUE
          ALFAM(I) = WGT/SOMME(I)
180     CONTINUE

C-- CALCUL DU FACTEUR DE DIAGONALISATION

C        ALFA = WGT/TRACE

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

        DO 190 J = 1,NNO
          DO 190 I = 1,3
            DIAG(I,J) = A(I,I,J,J)*ALFAM(I)
190     CONTINUE

        DO 195 K = 1,NDDL
          DO 195 L = 1,NDDL
            DO 195 I = 1,NNO
              DO 195 J = 1,NNO
                A(K,L,I,J) = 0.D0
195     CONTINUE
        DO 196 K=1,3
          DO 196 I=1,NNO
            A(K,K,I,I) = DIAG(K,I)
196     CONTINUE
        IF (NDDL.EQ.6) THEN
          DO 197 I=1,NNO
            A(4,4,I,I) = A(4,4,I,I) * ALFAM(1)
            A(5,5,I,I) = A(4,4,I,I) * ALFAM(2)
            A(6,6,I,I) = A(4,4,I,I) * ALFAM(3)
197       CONTINUE
        ENDIF
      ENDIF


      IF (OPTION(1:9).EQ.'MASS_MECA') THEN
        DO 200 K = 1,NDDL
          DO 200 L = 1,NDDL
            DO 200 I = 1,NNO
              KKD = ((NDDL*(I-1)+K-1)* (NDDL*(I-1)+K))/2
              DO 200 J = 1,I
                KK = KKD + NDDL * (J-1) + L
                ZR(IMATUU+KK-1) = A(K,L,I,J)
200     CONTINUE

      ELSE IF (OPTION.EQ.'M_GAMMA'.OR.
     &         OPTION.EQ.'ECIN_ELEM') THEN
        NVEC = NDDL*NNO*(NDDL*NNO+1)/2
        DO 210 K = 1,NVEC
          MATV(K) = 0.0D0
210     CONTINUE
        DO 220 K = 1,NDDL
          DO 220 L = 1,NDDL
            DO 220 I = 1,NNO
              KKD = ((NDDL*(I-1)+K-1)* (NDDL*(I-1)+K))/2
              DO 220 J = 1,I
                KK = KKD + NDDL* (J-1) + L
                MATV(KK) = A(K,L,I,J)
220     CONTINUE
        CALL VECMA(MATV,NVEC,MATP,NDDL*NNO)
        IF (OPTION.EQ.'M_GAMMA') THEN
          CALL PMAVEC('ZERO',NDDL*NNO,MATP,ZR(IACCE),ZR(IVECT))
        ELSEIF (OPTION.EQ.'ECIN_ELEM') THEN
          IF (IRETV.EQ.0) THEN
            CALL PMAVEC('ZERO',NDDL*NNO,MATP,ZR(IVITE),MASVIT)
            ECIN = .5D0*DDOT(NDDL*NNO,ZR(IVITE),1,MASVIT,1)
          ELSE
            CALL PMAVEC('ZERO',NDDL*NNO,MATP,ZR(IDEPL),MASDEP)
            ECIN = .5D0*DDOT(NDDL*NNO,ZR(IDEPL),1,MASDEP,1)*ZR(IFREQ)
          ENDIF
          ZR(IECIN) = ECIN
        ENDIF

      ENDIF

      END
