      SUBROUTINE XGELEM(ELREFP,NDIM,COORSE,IGEOM,JHEAVT,IT,ISE,NFH,
     &                 DDLC,DDLM,NFE,BASLOC,NNOP,IDEPL,
     &                 LSN,LST,IGTHET,NFISS,JFISNO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/09/2010   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20

      IMPLICIT NONE
      CHARACTER*8   ELREFP
      CHARACTER*24  COORSE
      INTEGER       IGEOM,NDIM,NFH,DDLC,NFE,NNOP,DDLM
      INTEGER       IDEPL,NFISS,JFISNO,JHEAVT,IT,ISE
      REAL*8        BASLOC(3*NDIM*NNOP),LSN(NNOP),LST(NNOP)


C    - FONCTION REALISEE:  CALCUL DU TAUX DE RESTITUTION D'ENERGIE 
C                          PAR LA METHODE ENERGETIQUE G-THETA
C                          POUR LES ELEMENTS X-FEM (2D ET 3D)
C
C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NFISS   : NOMBRE DE FISSURES "VUES" PAR L'�L�MENT
C IN  JFISNO  : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDES
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE AUX NOEUDS
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  DEPL    : D�PLACEMENTS
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS

C OUT IGTHET  : G

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER  ITHET,IMATE,ICOMP,IGTHET,JCOORS
      INTEGER  IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
      INTEGER  I,J,K,KPG,N,INO,IRET,CPT,IG,IN,NSEMAX(3)
      INTEGER  NDIMB,NNO,NNOS,NPGBIS,DDLD,DDLS,MATCOD,M,IRETT
      REAL*8   R8PREM
      REAL*8   XG(NDIM),FE(4),HE(NFISS)
      REAL*8   DGDGL(4,3),XE(NDIM),FF(NNOP),DFDI(NNOP,NDIM),F(3,3)
      REAL*8   EPS(6),E1(3),E2(3),NORME,E3(3),P(3,3)
      REAL*8   INVP(3,3),RG,TG,RBID1(4)
      REAL*8   DGDPO(4,2),DGDLO(4,3)
      REAL*8   GRAD(NDIM,NDIM),DUDM(3,3),POIDS,RBID2(4)
      REAL*8   DTDM(3,3),LSNG,LSTG,RBID3(4)
      REAL*8   RBID,R6BID(6)
      REAL*8   R2BID(2),TTHE
      REAL*8   DEPLA(3),THETA(3),TGUDM(3),TPN(27),TREF
      REAL*8   CRIT(3)
      REAL*8   ENERGI(2),SIGL(6),PROD,PROD2,RAC2,SR(3,3),TCLA,DIVT
      CHARACTER*8  ELRESE(6),FAMI(6),TYPMOD(2)
      CHARACTER*16 COMPOR(4),OPRUPT
      LOGICAL  GRDEPL,CP, LTEATT,ISMALI
      INTEGER  IRESE,DDLI,NNOI,INDENI,IBID,NNOPS,FISNO(NNOP,NFISS),IFISS

      DATA    NSEMAX / 2 , 3 , 6 /
      DATA    ELRESE /'SE2','TR3','TE4','SE3','TR6','TE4'/
      DATA    FAMI   /'BID','XINT','XINT','BID','XINT','XINT'/

      CALL JEMARQ()

      GRDEPL=.FALSE.

      IF (.NOT.ISMALI(ELREFP).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF
      
      TYPMOD(2) = ' '
      CP  = .FALSE.
      OPRUPT = 'RUPTURE'
      RAC2   = SQRT(2.D0)
      TCLA  = 0.D0
      TTHE  = 0.D0

      IF (LTEATT(' ','C_PLAN','OUI')) THEN
        TYPMOD(1) = 'C_PLAN'
        CP  = .TRUE.
      ELSEIF (LTEATT(' ','D_PLAN','OUI')) THEN
        TYPMOD(1) = 'D_PLAN'
      ENDIF

C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET
      DDLD=NDIM*(1+NFH+NFE)

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLS=DDLD+DDLC

C     ELEMENT DE REFERENCE PARENT : RECUP DE NNOPS
      CALL ELREF4(' ','RIGI',IBID,IBID,NNOPS,IBID,IBID,IBID,IBID,IBID)

      CALL JEVECH('PTHETAR','L',ITHET)
      CALL JEVECH('PMATERC','L',IMATE)
      MATCOD = ZI(IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMP)      
      DO 11 I = 1,4
        COMPOR(I)= ZK16(ICOMP+I-1)
11    CONTINUE


C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)

C     SOUS-ELEMENT DE REFERENCE 
      CALL ELREF5(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),NDIMB,NNO,NNOS,
     &            NPGBIS,IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO)
      CALL ASSERT(NDIM.EQ.NDIMB)

C     TEMPERATURE DE REF
      CALL RCVARC(' ','TEMP','REF','RIGI',1,1,TREF,IRETT)
      IF (IRETT.NE.0) TREF = 0.D0

C     TEMPERATURE AUX NOEUDS PARENT
      DO 30 INO = 1,NNOP
        CALL RCVARC(' ','TEMP','+','NOEU',INO,1,TPN(INO),IRET)
        IF (IRET.NE.0) TPN(INO) = 0.D0
 30   CONTINUE

C     FONCTION HEAVYSIDE CSTE SUR LE SS-�LT ET PAR FISSURE

      DO 70 IFISS = 1,NFISS
        HE(IFISS) = ZI(JHEAVT-1+(NSEMAX(NDIM)*(IT-1)+ISE-1)*NFISS+IFISS)
  70  CONTINUE

C     RECUPERATION DE LA CONNECTIVIT� FISSURE - DDL HEAVISIDES
C     ATTENTION !!! FISNO PEUT ETRE SURDIMENTIONN�
      IF (NFISS.EQ.1) THEN
        DO 40 INO = 1, NNOP
          FISNO(INO,1) = 1
  40    CONTINUE
      ELSE
        DO 50 IG = 1, NFH
C    ON REMPLIT JUSQU'A NFH <= NFISS
          DO 60 INO = 1, NNOP
            FISNO(INO,IG) = ZI(JFISNO-1+(INO-1)*NFH+IG)
  60      CONTINUE
  50    CONTINUE
      ENDIF  
C     ------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS DU SOUS-T�TRA
C     ------------------------------------------------------------------

      DO 10 KPG=1,NPGBIS

C       INITIALISATIONS
        CALL VECINI(9,0.D0,DTDM)
        CALL VECINI(9,0.D0,DUDM)


C       COORDONN�ES DU PT DE GAUSS DANS LE REP�RE R�EL : XG
        CALL VECINI(NDIM,0.D0,XG)
        DO 101 I=1,NDIM
          DO 102 N=1,NNO
            XG(I) = XG(I) + ZR(IVF-1+NNO*(KPG-1)+N) 
     &                                * ZR(JCOORS-1+NDIM*(N-1)+I)
 102      CONTINUE
 101    CONTINUE

C       CALCUL DES FF
        CALL REEREF(ELREFP,NNOP,NNOPS,IGEOM,XG,IDEPL,GRDEPL,NDIM,HE,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'NON',
     &              XE,FF,DFDI,F,EPS,GRAD)

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SS-ELT -> SS-ELT REF
C       ON ENVOIE DFDM3D/DFDM2D AVEC LES COORD DU SS-ELT
        IF (NDIM.EQ.3) CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                      RBID1,RBID2,RBID3,POIDS)
        IF (NDIM.EQ.2) CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                      RBID1,RBID2,POIDS)

C       --------------------------------------
C       1) COORDONN�ES POLAIRES ET BASE LOCALE
C       --------------------------------------

C       BASE LOCALE ET LEVEL SETS AU POINT DE GAUSS
        CALL VECINI(3,0.D0,E1)
        CALL VECINI(3,0.D0,E2)
        LSNG=0.D0
        LSTG=0.D0
        DO 100 INO=1,NNOP
          LSNG = LSNG + LSN(INO) * FF(INO)
          LSTG = LSTG + LST(INO) * FF(INO)
          DO 110 I=1,NDIM
            E1(I) = E1(I) + BASLOC(3*NDIM*(INO-1)+I+NDIM)   * FF(INO)
            E2(I) = E2(I) + BASLOC(3*NDIM*(INO-1)+I+2*NDIM) * FF(INO)
 110      CONTINUE
 100    CONTINUE

C       NORMALISATION DE LA BASE
        CALL NORMEV(E1,NORME)
        CALL NORMEV(E2,NORME)
        CALL PROVEC(E1,E2,E3)

C       CALCUL DE LA MATRICE DE PASSAGE P TQ 'GLOBAL' = P * 'LOCAL'
        CALL VECINI(9,0.D0,P)
        DO 120 I=1,NDIM
          P(I,1)=E1(I)
          P(I,2)=E2(I)
          P(I,3)=E3(I)
 120    CONTINUE

C       CALCUL DE L'INVERSE DE LA MATRICE DE PASSAGE : INV=TRANSPOSE(P)
        DO 130 I=1,3
          DO 131 J=1,3
            INVP(I,J)=P(J,I)
 131      CONTINUE
 130    CONTINUE

C       COORDONN�ES POLAIRES DU POINT
        RG=SQRT(LSNG**2+LSTG**2)

        IF (RG.GT.R8PREM()) THEN
C         LE POINT N'EST PAS SUR LE FOND DE FISSURE
          TG = HE(1) * ABS(ATAN2(LSNG,LSTG))
          IRET=1
        ELSE
C         LE POINT EST SUR LE FOND DE FISSURE :
C         L'ANGLE N'EST PAS D�FINI, ON LE MET � Z�RO
C         ON NE FERA PAS LE CALCUL DES D�RIV�ES
          TG=0.D0
          IRET=0
        ENDIF
C       ON A PAS PU CALCULER LES DERIVEES DES FONCTIONS SINGULIERES
C       CAR ON SE TROUVE SUR LE FOND DE FISSURE
        CALL ASSERT(IRET.NE.0)
        
C       ---------------------------------------------
C       2) CALCUL DU DEPLACEMENT ET DE SA DERIVEE (DUDM)
C       ---------------------------------------------

C       FONCTIONS D'ENRICHISSEMENT
        FE(1)=SQRT(RG)*SIN(TG/2.D0)
        FE(2)=SQRT(RG)*COS(TG/2.D0)
        FE(3)=SQRT(RG)*SIN(TG/2.D0)*SIN(TG)
        FE(4)=SQRT(RG)*COS(TG/2.D0)*SIN(TG)

        CALL VECINI(NDIM,0.D0,DEPLA)

C       CALCUL DE L'APPROXIMATION DU DEPLACEMENT
        DO 200 IN=1,NNOP
            IF (IN.LE.NNOPS) THEN
              NNOI=0
              DDLI=DDLS
            ELSEIF (IN.GT.NNOPS) THEN
              NNOI=NNOPS
              DDLI=DDLM
            ENDIF
            INDENI = DDLS*NNOI+DDLI*(IN-NNOI-1)

          CPT=0
C         DDLS CLASSIQUES
          DO 201 I=1,NDIM
            CPT=CPT+1
            DEPLA(I) = DEPLA(I) + FF(IN)*ZR(IDEPL-1+INDENI+CPT)
 201      CONTINUE
C         DDLS HEAVISIDE
          DO 202 IG=1,NFH
            DO 203 I=1,NDIM            
              CPT=CPT+1
              DEPLA(I) = DEPLA(I) + HE(FISNO(IN,IG)) * FF(IN) *
     &                    ZR(IDEPL-1+INDENI+CPT)
 203        CONTINUE
 202      CONTINUE
C         DDL ENRICHIS EN FOND DE FISSURE
          DO 204 IG=1,NFE
            DO 205 I=1,NDIM
              CPT=CPT+1
              DEPLA(I) = DEPLA(I) + FE(IG) * FF(IN)
     &                * ZR(IDEPL-1+INDENI+CPT)
 205        CONTINUE
 204      CONTINUE
 200    CONTINUE        

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE
        DGDPO(1,1)=1.D0/(2.D0*SQRT(RG))*SIN(TG/2.D0)
        DGDPO(1,2)=SQRT(RG)/2.D0*COS(TG/2.D0)
        DGDPO(2,1)=1.D0/(2.D0*SQRT(RG))*COS(TG/2.D0)
        DGDPO(2,2)=-SQRT(RG)/2.D0*SIN(TG/2.D0)
        DGDPO(3,1)=1.D0/(2.D0*SQRT(RG))*SIN(TG/2.D0)*SIN(TG)
        DGDPO(3,2)=SQRT(RG) *
     &            (COS(TG/2.D0)*SIN(TG)/2.D0 + SIN(TG/2.D0)*COS(TG))
        DGDPO(4,1)=1.D0/(2.D0*SQRT(RG))*COS(TG/2.D0)*SIN(TG)
        DGDPO(4,2)=SQRT(RG) *
     &            (-SIN(TG/2.D0)*SIN(TG)/2.D0 + COS(TG/2.D0)*COS(TG))

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE LOCALE
        DO 210 I=1,4
          DGDLO(I,1)=DGDPO(I,1)*COS(TG)-DGDPO(I,2)*SIN(TG)/RG
          DGDLO(I,2)=DGDPO(I,1)*SIN(TG)+DGDPO(I,2)*COS(TG)/RG
          DGDLO(I,3)=0.D0
 210    CONTINUE

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE GLOBALE
        DO 220 I=1,4
          DO 221 J=1,3
            DGDGL(I,J)=0.D0
            DO 222 K=1,3
              DGDGL(I,J)=DGDGL(I,J)+DGDLO(I,K)*INVP(K,J)
 222        CONTINUE
 221      CONTINUE
 220    CONTINUE

C       CALCUL DU GRAD DE U AU POINT DE GAUSS
        CALL REEREF(ELREFP,NNOP,NNOPS,IGEOM,XG,IDEPL,GRDEPL,NDIM,HE,
     &               FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'OUI',
     &               XE,FF,DFDI,F,EPS,GRAD)

C       ON RECOPIE GRAD DANS DUDM (CAR PB DE DIMENSIONNEMENT SI 2D)
        DO 230 I=1,NDIM
          DO 231 J=1,NDIM
            DUDM(I,J)=GRAD(I,J)
 231      CONTINUE
 230    CONTINUE

C       ------------------------------------------------
C       3) CALCUL DU CHAMP THETA ET DE SA DERIVEE (DTDM)
C       ------------------------------------------------
C
        DO 300 I=1,NDIM

          THETA(I)=0.D0
          DO 301 INO=1,NNOP
            THETA(I) = THETA(I) +  FF(INO) * ZR(ITHET-1+NDIM*(INO-1)+I)
 301      CONTINUE 

          DO 310 J=1,NDIM
             DO 311 INO=1,NNOP
               DTDM(I,J) = DTDM(I,J) + ZR(ITHET-1+NDIM*(INO-1)+I)
     &                               * DFDI(INO,J)
 311        CONTINUE
 310      CONTINUE
 300    CONTINUE
 
        DIVT = 0.D0
        DO 437 I=1,NDIM
          DIVT  = DIVT + DTDM(I,I)
437     CONTINUE

C       --------------------------------------------------
C       4) CALCUL DU CHAMP DE TEMPERATURE ET DE SA DERIVEE
C       --------------------------------------------------
C
        DO 400 I=1,NDIM
          TGUDM(I)=0.D0
           DO 401 INO=1,NNOP
             TGUDM(I) = TGUDM(I) + DFDI(INO,I) * TPN(INO)
 401      CONTINUE
 400    CONTINUE
C       --------------------------------------------------
C       5) CALCUL DE LA CONTRAINTE ET DE L ENERGIE
C       --------------------------------------------------
C
        CRIT(1) = 300
        CRIT(2) = 0.D0
        CRIT(3) = 1.D-3
        CALL NMELNL('RIGI',KPG,1,'+',NDIM,TYPMOD,MATCOD,COMPOR,CRIT,
     &                OPRUPT,EPS,SIGL,RBID,RBID,ENERGI,.FALSE.,
     &                RBID,R6BID,R2BID,R6BID)

        
C TRAITEMENTS DEPENDANT DE LA MODELISATION
        IF(CP) THEN
          DUDM(3,3)= EPS(3)
        ENDIF

C 
C       --------------------------------------------------
C 6) TERME THERMOELAS. CLASSIQUE F.SIG:(GRAD(U).GRAD(THET))-ENER*DIVT
C       --------------------------------------------------
C        
        SR(1,1)= SIGL(1)
        SR(2,2)= SIGL(2)
        SR(3,3)= SIGL(3)
        SR(1,2)= SIGL(4)/RAC2
        SR(2,1)= SR(1,2)
        SR(1,3)= SIGL(5)/RAC2
        SR(3,1)= SR(1,3)
        SR(2,3)= SIGL(6)/RAC2
        SR(3,2)= SR(2,3)
        
        PROD  = 0.D0
        PROD2 = 0.D0
        DO 490 I=1,NDIM
          DO 480 J=1,NDIM
            DO 475 K=1,NDIM
              DO 470 M=1,NDIM
                PROD =PROD+F(I,J)*SR(J,K)*DUDM(I,M)*DTDM(M,K)
470           CONTINUE
475         CONTINUE
480       CONTINUE
490     CONTINUE
        PROD2 = POIDS*( PROD - ENERGI(1)*DIVT)
        TCLA  = TCLA + PROD2


C =======================================================
C TERME THERMIQUE :   -(D(ENER)/DT)(GRAD(T).THETA)
C =======================================================
        IF (IRETT.EQ.0) THEN
          PROD = 0.D0
          PROD2 = 0.D0
          DO 500 I=1,NDIM
            PROD = PROD + TGUDM(I)*THETA(I)
500       CONTINUE
          PROD2 = - POIDS*PROD*ENERGI(2)
          TTHE = TTHE + PROD2
        ELSE
          TTHE = 0.D0
        ENDIF   


 10   CONTINUE

C     ------------------------------------------------------------------
C     FIN DE LA BOUCLE SUR LES POINTS DE GAUSS DU SOUS-T�TRA
C     ------------------------------------------------------------------
      ZR(IGTHET) = ZR(IGTHET)+TCLA + TTHE 
      CALL JEDEMA()
      END
