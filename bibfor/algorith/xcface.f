      SUBROUTINE XCFACE(ELREF,LSN,LST,JGRLSN,IGEOM,ENR,
     &                  PINTER,NINTER,AINTER,NFACE,NPTF,CFACE)
      IMPLICIT NONE

      REAL*8        LSN(*),LST(*)
      INTEGER       JGRLSN,IGEOM,NINTER,NFACE,CFACE(5,3),NPTF
      CHARACTER*8   ELREF
      CHARACTER*24  PINTER,AINTER
      CHARACTER*16  ENR
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C                     TROUVER LES PTS D'INTERSECTION ENTRE LES ARETES
C                      ET LE PLAN DE FISSURE ET D�COUPAGE EN FACETTES
C
C     ENTREE
C       ELREF    : ELEMENT DE REFERENCE
C       LSN      : VALEURS DE LA LEVEL SET NORMALE
C       LST      : VALEURS DE LA LEVEL SET TANGENTE
C       JGRLSN   : ADRESSE DU GRADIENT DE LA LEVEL SET NORMALE
C       IGEOM    : ADRESSE DES COORDONNEES DES NOEUDS DE L'ELT PARENT
C       ENR      : VALEUR DE L'ATTRIBUT DE L'ELEMENT
C
C     SORTIE
C       PINTER  : COORDONNEES DES POINTS D'INTERSECTION
C       NINTER  : NOMBRE DE POINTS D'INTERSECTION
C       AINTER  : INFOS ARETE ASSOCIEE AU POINTS D'INTERSECTION
C       NFACE   : NOMBRE DE FACETTES
C       CFACE   : CONNECTIVITE DES NOEUDS DES FACETTES
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      REAL*8          A(3),B(3),C(3),LSNA,LSNB,PADIST,LONGAR,TAMPOR(4)
      REAL*8          ALPHA,BAR(3),OA(3),M(3),AM(3),ND(3),PS,PS1,LAMBDA
      REAL*8          H(3),OH(3),NOH,COS,NOA,TRIGOM,R3(3),THETA(6),EPS
      REAL*8          R8PI,DDOT,AB(2),LSTA,LSTB,LSTC,ABPRIM(2),PREC
      REAL*8          R8PREM
      INTEGER         J,AR(12,3),NBAR,NTA,NTB,NA,NB,JPTINT,INS,JAINT
      INTEGER         IA,I,IPT,IBID,PP,PD,TAMPOI,NNO,K
      INTEGER         IADZI,IAZK24,NDIM,PTMAX,IFM
      CHARACTER*8     TYPMA,ELP
      INTEGER         ZXAIN,XXMMVD
      LOGICAL         LLIN,ISMALI
C ----------------------------------------------------------------------

      CALL JEMARQ()

      EPS=-1.0D-10
C   PREC PERMET D"EVITER LES ERREURS DE PR�CISION CONDUISANT
C   A IA=IN=0 POUR LES MAILLES DU FRONT
      PREC = 1000*R8PREM()

      ZXAIN = XXMMVD('ZXAIN')
      CALL ELREF1(ELP)
      CALL ELREF4(' ','RIGI',NDIM,NNO,IBID,IBID,IBID,IBID,IBID,IBID)

      IF (NDIM .EQ. 3) THEN
         PTMAX=6
      ELSEIF (NDIM .EQ. 2) THEN
         PTMAX=2
      ENDIF

C     1) RECHERCHE DES POINTS D'INTERSECTION
C     --------------------------------------

C     CREATION DU VECTEUR DES COORDONNEES DES POINTS D'INTERSECTION
      CALL WKVECT(PINTER,'V V R',PTMAX*NDIM,JPTINT)

C     VECTEUR REEL � ZXAIN COMPOSANTES, POUR CHAQUE PT D'INTER :
C     - NUM�RO ARETE CORRESPONDANTE         (0 SI C'EST UN NOEUD SOMMET)
C     - NUM�RO NOEUD SI NOEUD SOMMET        (0 SINON)
C     - LONGUEUR DE L'ARETE
C     - POSITION DU PT SUR L'ARETE          (0 SI C'EST UN NOEUD SOMMET)
C     - ARETE VITALE                        (0 SI NON)
      CALL WKVECT(AINTER,'V V R',PTMAX*ZXAIN,JAINT)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)
      LLIN = ISMALI(TYPMA)

C     ATTENTION : POUR LES ELEMENTS QUADRATIQUES
C     PAS DE CONTACT CAR CES ELEMENTS NE PORTENT PAS DE DDLS LSGS_C...
C     ILS FAUT DONC LES REPERER, ALORS NINTER = -1 (CA SERT DANS XDELCO)
      IF (ELP.EQ.'H20'.OR.ELP.EQ.'P15'.OR.ELP.EQ.'T10') THEN
        NINTER=-1
        NFACE=0
        GOTO 999
      ENDIF

      IPT=0
C     COMPTEUR DE POINT INTERSECTION = NOEUD SOMMENT
      INS=0
      CALL CONARE(TYPMA,AR,NBAR)

C     BOUCLE SUR LES ARETES POUR DETERMINER LES POINTS D'INTERSECTION
      DO 100 IA=1,NBAR

C       NUM NO DE L'ELEMENT
        NA=AR(IA,1)
        NB=AR(IA,2)
        LSNA=LSN(NA)
        LSNB=LSN(NB)
        LSTA=LST(NA)
        LSTB=LST(NB)
        DO 110 I=1,NDIM
          A(I)=ZR(IGEOM-1+NDIM*(NA-1)+I)
          B(I)=ZR(IGEOM-1+NDIM*(NB-1)+I)
 110    CONTINUE
        IF (NDIM.LT.3) THEN
              A(3)=0.D0
              B(3)=0.D0
              C(3)=0.D0
        ENDIF
        LONGAR=PADIST(NDIM,A,B)

        IF ((ENR.EQ.'XHC').OR. (ENR.EQ.'XHTC')) THEN
          IF ((LSNA*LSNB).LE.0.D0) THEN
            IF ((LSNA.EQ.0.D0).AND.(LSTA.LE.PREC)) THEN
C             ON AJOUTE A LA LISTE LE POINT A
              IF (LSTA.GE.0.D0.AND.LLIN) THEN
               CALL XAJPIN(JPTINT,PTMAX,IPT,INS,A,LONGAR,
     &                     JAINT,0,0,0.D0)
              ELSE
               CALL XAJPIN(JPTINT,PTMAX,IPT,INS,A,LONGAR,
     &                     JAINT,0,NA,0.D0)
              ENDIF
            ENDIF
            IF (LSNB.EQ.0.D0.AND.LSTB.LE.PREC) THEN
C             ON AJOUTE A LA LISTE LE POINT B
              IF (LSTB.GE.0.D0.AND.LLIN) THEN
               CALL XAJPIN(JPTINT,PTMAX,IPT,INS,B,LONGAR,
     &                     JAINT,0,0,0.D0)
              ELSE
               CALL XAJPIN(JPTINT,PTMAX,IPT,INS,B,LONGAR,
     &                     JAINT,0,NB,0.D0)
              ENDIF
            ENDIF
            IF (LSNA.NE.0.D0.AND.LSNB.NE.0.D0) THEN
C             INTERPOLATION DES COORDONN??ES DE C
              DO 130 I=1,NDIM
                C(I)=A(I)-LSNA/(LSNB-LSNA)*(B(I)-A(I))
 130          CONTINUE
C             POSITION DU PT D'INTERSECTION SUR L'ARETE
              ALPHA=PADIST(NDIM,A,C)
              LSTC=LSTA-(LSNA/(LSNB-LSNA))*(LSTB-LSTA)
              IF (LSTC.LE.PREC) THEN
                IF (LSTC.GE.0.D0.AND.LLIN) THEN
                  CALL XAJPIN(JPTINT,PTMAX,IPT,IBID,C,LONGAR,
     &                        JAINT,0,0,0.D0)
                ELSE
                  CALL XAJPIN(JPTINT,PTMAX,IPT,IBID,C,LONGAR,
     &                        JAINT,IA,0,ALPHA)
                ENDIF
              ENDIF
            ENDIF
          ENDIF

        ELSE
          IF ((LSNA*LSNB).LE.0.D0) THEN
            IF ((LSNA.EQ.0.D0).AND.(LSTA.LE.0.D0)) THEN
C             ON AJOUTE A LA LISTE LE POINT A
              CALL XAJPIN(JPTINT,PTMAX,IPT,INS,A,LONGAR,
     &                    JAINT,0,NA,0.D0)
            ENDIF
            IF (LSNB.EQ.0.D0.AND.LSTB.LE.0.D0) THEN
C             ON AJOUTE A LA LISTE LE POINT B
              CALL XAJPIN(JPTINT,PTMAX,IPT,INS,B,LONGAR,
     &                    JAINT,0,NB,0.D0)
            ENDIF
            IF (LSNA.NE.0.D0.AND.LSNB.NE.0.D0) THEN
C             INTERPOLATION DES COORDONN�ES DE C
              DO 140 I=1,NDIM
                C(I)=A(I)-LSNA/(LSNB-LSNA)*(B(I)-A(I))
 140          CONTINUE
C             POSITION DU PT D'INTERSECTION SUR L'ARETE
              ALPHA=PADIST(NDIM,A,C)
              LSTC=LSTA-(LSNA/(LSNB-LSNA))*(LSTB-LSTA)

C             CAS OU LE FRONT EST EXCATEMENT SUR L'ARETE 
C             IF (LSTC.LE.PREC.AND.LSTC.GT.0.D0) THEN
              IF (LSTC.LE.PREC) THEN
                IF (LSTC.GT.0.D0) LSTC=0.D0               
                CALL XAJPIN(JPTINT,PTMAX,IPT,IBID,C,LONGAR,
     &                      JAINT,IA,0,
     &                      ALPHA)
              ENDIF
            ENDIF
          ENDIF
        ENDIF
   
 100  CONTINUE

C     RECHERCHE SPECIFIQUE POUR LES ELEMENTS EN FOND DE FISSURE
      CALL XCFACF(JPTINT,PTMAX,IPT,JAINT,LSN,LST,IGEOM,NNO,NDIM,
     &                                                    LLIN,TYPMA)

      NINTER=IPT

C     2) DECOUPAGE EN FACETTES TRIANGULAIRES DE LA SURFACE DEFINIE
C     ------------------------------------------------------------

C                  (BOOK IV 09/09/04)

C     CAS 3D
      IF (NDIM .EQ. 3) THEN

        IF (NINTER.LT.3) GOTO 500

        DO 200 I=1,5
         DO 201 J=1,3
           CFACE(I,J)=0
 201     CONTINUE
 200    CONTINUE

C       NORMALE A LA FISSURE (MOYENNE DE LA NORMALE AUX NOEUDS)
        CALL VECINI(3,0.D0,ND)
        DO 210 I=1,NNO
         DO 211 J=1,3
           ND(J)=ND(J)+ZR(JGRLSN-1+3*(I-1)+J)/NNO
 211     CONTINUE
 210    CONTINUE

C       PROJECTION ET NUMEROTATION DES POINTS COMME DANS XORIFF
        CALL VECINI(3,0.D0,BAR)
        DO 220 I=1,NINTER
         DO 221 J=1,3
           BAR(J)=BAR(J)+ZR(JPTINT-1+(I-1)*3+J)/NINTER
 221     CONTINUE
 220    CONTINUE
        DO 230 J=1,3
         A(J)=ZR(JPTINT-1+(1-1)*3+J)
         OA(J)=A(J)-BAR(J)
 230    CONTINUE
        NOA=SQRT(OA(1)*OA(1) + OA(2)*OA(2)  +  OA(3)*OA(3))

C       BOUCLE SUR LES POINTS D'INTERSECTION POUR CALCULER L'ANGLE THETA
        DO 240 I=1,NINTER
         DO 241 J=1,3
           M(J)=ZR(JPTINT-1+(I-1)*3+J)
           AM(J)=M(J)-A(J)
 241     CONTINUE
         PS=DDOT(3,AM,1,ND,1)

         PS1=DDOT(3,ND,1,ND,1)
         LAMBDA=-PS/PS1
         DO 242 J=1,3
           H(J)=M(J)+LAMBDA*ND(J)
           OH(J)=H(J)-BAR(J)
 242     CONTINUE
         PS=DDOT(3,OA,1,OH,1)

         NOH=SQRT(OH(1)*OH(1) + OH(2)*OH(2)  +  OH(3)*OH(3))
         COS=PS/(NOA*NOH)

         THETA(I)=TRIGOM('ACOS',COS)
C        SIGNE DE THETA (06/01/2004)
         CALL PROVEC(OA,OH,R3)
         PS=DDOT(3,R3,1,ND,1)
         IF (PS.LT.EPS) THETA(I) = -1 * THETA(I) + 2 * R8PI()

 240    CONTINUE

C       TRI SUIVANT THETA CROISSANT
        DO 250 PD=1,NINTER-1
         PP=PD
         DO 251 I=PP,NINTER
           IF (THETA(I).LT.THETA(PP)) PP=I
 251     CONTINUE
         TAMPOR(1)=THETA(PP)
         THETA(PP)=THETA(PD)
         THETA(PD)=TAMPOR(1)
         DO 252 K=1,3
           TAMPOR(K)=ZR(JPTINT-1+3*(PP-1)+K)
           ZR(JPTINT-1+3*(PP-1)+K)=ZR(JPTINT-1+3*(PD-1)+K)
           ZR(JPTINT-1+3*(PD-1)+K)=TAMPOR(K)
 252     CONTINUE
         DO 253 K=1,ZXAIN
           TAMPOR(K)=ZR(JAINT-1+ZXAIN*(PP-1)+K)
           ZR(JAINT-1+ZXAIN*(PP-1)+K)=ZR(JAINT-1+ZXAIN*(PD-1)+K)
           ZR(JAINT-1+ZXAIN*(PD-1)+K)=TAMPOR(K)
 253     CONTINUE
 250    CONTINUE

 500    CONTINUE

C       NOMBRE DE POINTS D'INTERSECTION IMPOSSIBLE.
        CALL ASSERT(NINTER.LE.6) 
        IF (NINTER.EQ.6) THEN
          NFACE=4
          NPTF=3
          CFACE(1,1)=1
          CFACE(1,2)=2
          CFACE(1,3)=3
          CFACE(2,1)=1
          CFACE(2,2)=3
          CFACE(2,3)=5
          CFACE(3,1)=1
          CFACE(3,2)=5
          CFACE(3,3)=6
          CFACE(4,1)=3
          CFACE(4,2)=4
          CFACE(4,3)=5
        ELSEIF (NINTER.EQ.5) THEN
          NFACE=3
          NPTF=3
          CFACE(1,1)=1
          CFACE(1,2)=2
          CFACE(1,3)=3
          CFACE(2,1)=1
          CFACE(2,2)=3
          CFACE(2,3)=4
          CFACE(3,1)=1
          CFACE(3,2)=4
          CFACE(3,3)=5
        ELSEIF (NINTER.EQ.4) THEN
          NFACE=2
          NPTF=3
          CFACE(1,1)=1
          CFACE(1,2)=2
          CFACE(1,3)=3
          CFACE(2,1)=1
          CFACE(2,2)=3
          CFACE(2,3)=4
        ELSEIF (NINTER.EQ.3) THEN
          NFACE=1
          NPTF=3
          CFACE(1,1)=1
          CFACE(1,2)=2
          CFACE(1,3)=3
        ELSE
          NPTF=0
          NFACE=0
        ENDIF

C     CAS 2D
      ELSEIF (NDIM .EQ. 2) THEN

        DO 800 I=1,5
         DO 801 J=1,3
           CFACE(I,J)=0
 801     CONTINUE
 800    CONTINUE
        IF (NINTER .EQ. 2) THEN
C       NORMALE A LA FISSURE (MOYENNE DE LA NORMALE AUX NOEUDS)
        CALL VECINI(2,0.D0,ND)
        DO 810 I=1,NNO
         DO 811 J=1,2
           ND(J)=ND(J)+ZR(JGRLSN-1+2*(I-1)+J)/NNO
 811     CONTINUE
 810    CONTINUE

        DO 841 J=1,2
           A(J)=ZR(JPTINT-1+J)
           B(J)=ZR(JPTINT-1+2+J)
           AB(J)=B(J)-A(J)
 841    CONTINUE

        ABPRIM(1)=-AB(2)
        ABPRIM(2)=AB(1)

        IF (DDOT(2,ABPRIM,1,ND,1) .LT. 0.D0) THEN
         DO 852 K=1,2
           TAMPOR(K)=ZR(JPTINT-1+K)
           ZR(JPTINT-1+K)=ZR(JPTINT-1+2+K)
           ZR(JPTINT-1+2+K)=TAMPOR(K)
 852     CONTINUE
         DO 853 K=1,4
           TAMPOR(K)=ZR(JAINT-1+K)
           ZR(JAINT-1+K)=ZR(JAINT-1+ZXAIN+K)
           ZR(JAINT-1+ZXAIN+K)=TAMPOR(K)
 853     CONTINUE
        ENDIF
          NFACE=1
          NPTF=2
          CFACE(1,1)=1
          CFACE(1,2)=2
        ELSE
          NPTF=0
          NFACE=0
        ENDIF

      ELSE
C       PROBLEME DE DIMENSION : NI 2D, NI 3D
        CALL ASSERT(NDIM.EQ.2 .OR. NDIM.EQ.3)
      ENDIF

 999  CONTINUE

      CALL JEDEMA()
      END
