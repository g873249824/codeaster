      SUBROUTINE NMGPFI(OPTION,TYPMOD,
     &                   NDIM,NNO,NPG,IW,VFF,IDFF,GEOMI,DFF,
     &                   COMPOR,MATE,LGPG,CRIT,ANGMAS,
     &                   INSTM,INSTP,TM,TP,TREF,
     &                   DEPLM,DEPLD,SIGM,VIM, 
     &                   SIGP,VIP,FINT,MATR,CODRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR MICHEL S.MICHEL 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21

       IMPLICIT NONE
       INTEGER       NDIM,NNO,NPG,MATE,LGPG,CODRET,IW,IDFF
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  OPTION, COMPOR(*)
       REAL*8        GEOMI(*),DFF(NNO,*),CRIT(*),INSTM,INSTP
       REAL*8        VFF(NNO,NPG)
       REAL*8        ANGMAS(3),TM(NNO),TP(NNO),TREF
       REAL*8        DEPLM(*), DEPLD(*),SIGM(2*NDIM,NPG)
       REAL*8        VIM(LGPG,NPG),SIGP(2*NDIM,NPG),VIP(LGPG,NPG)
       REAL*8        MATR(*), FINT(*)

C ----------------------------------------------------------------------
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_*, RAPH_MECA ET FULL_MECA_*
C           EN GRANDES DEFORMATIONS 2D (D_PLAN ET AXI) ET 3D
C ----------------------------------------------------------------------
C IN  OPTION  : OPTION DE CALCUL
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : PTR. POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  IDFF    : PTR. DERIVEE DES FONCTIONS DE FORME ELEMENT DE REF.
C IN  GEOMI   : COORDONNEES DES NOEUDS (CONFIGURATION INITIALE)
C MEM DFF     : ESPACE MEMOIRE POUR LA DERIVEE DES FONCTIONS DE FORME
C               DIM :(NNO,3) EN 3D, (NNO,4) EN AXI, (NNO,2) EN D_PLAN
C IN  COMPOR  : COMPORTEMENT
C IN  MATE    : MATERIAU CODE
C IN  LGPG    : DIMENSION DU VECTEUR DES VAR. INTERNES POUR 1 PT GAUSS
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  INSTM   : VALEUR DE L'INSTANT T-
C IN  INSTP   : VALEUR DE L'INSTANT T+
C IN  TM      : TEMPERATURE AUX NOEUDS EN T-
C IN  TP      : TEMPERATURE AUX NOEUDS EN T+
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPLM   : DEPLACEMENT EN T-
C IN  DEPLD   : INCREMENT DE DEPLACEMENT ENTRE T- ET T+
C IN  SIGM    : CONTRAINTES DE CAUCHY EN T-
C IN  VIM     : VARIABLES INTERNES EN T-
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA_*)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA_*)
C OUT FINT    : FORCES INTERIEURES (RAPH_MECA ET FULL_MECA_*)
C OUT MATR    : MATR. DE RIGIDITE NON SYM. (RIGI_MECA_* ET FULL_MECA_*)
C OUT IRET    : CODE RETOUR DE L'INTEGRATION DE LA LDC
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL GRAND, AXI, RESI, RIGI
      INTEGER LIJ(3,3),VIJ(3,3),IA,JA,NA,IB,JB,NB,G,KK,OS,IJA,I,J
      INTEGER NDDL,NDU,VU(3,27)
      INTEGER COD(27)
      REAL*8 TMG,TPG,TAMPON(10)
      REAL*8 GEOMM(3*27),GEOMP(3*27),R,W
      REAL*8 JM,JD,JP,FM(3,3),FD(3,3),COEF
      REAL*8 SIGMAM(6),TAUP(6),DSIDEP(6,3,3)
      REAL*8 DDOT,R8VIDE,RAC2,RBID,TBID(6),T1,T2

      PARAMETER (GRAND = .TRUE.)
      DATA    VIJ  / 1, 4, 5,
     &               4, 2, 6,
     &               5, 6, 3 /
C ----------------------------------------------------------------------

C - INITIALISATION ET VERIFICATIONS

      RBID = R8VIDE()
      RAC2 = SQRT(2.D0)
      CALL R8INIR(6,RBID,TBID,1)
      
      IF (NNO.GT.27) CALL U2MESS('F','ALGORITH7_99')
      IF (TYPMOD(1).EQ.'C_PLAN') CALL U2MESS('F','ALGORITH8_1')
     
      AXI  = TYPMOD(1).EQ.'AXIS'
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'

      NDDL = NDIM*NNO
      NDU  = NDIM
      IF (AXI) NDU = 3
      CALL NMGPIN(NDIM,NNO,AXI,VU)

C    DETERMINATION DES CONFIGURATIONS EN T- (GEOMM) ET T+ (GEOMP)
      CALL DCOPY(NDDL,GEOMI,1,GEOMM,1)
      CALL DAXPY(NDDL,1.D0,DEPLM,1,GEOMM,1)
      CALL DCOPY(NDDL,GEOMM,1,GEOMP,1)
      CALL DAXPY(NDDL,1.D0,DEPLD,1,GEOMP,1)
 
C    MISE A ZERO

      CALL R8INIR(6 ,0.D0,TAUP,1)
      CALL R8INIR(54,0.D0,DSIDEP,1)
      CALL R8INIR(10,0.D0,TAMPON,1)
      DO 9 I=1,27
        COD(I)=0
   9  CONTINUE


C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 10 G=1,NPG

C      VARIABLES DE COMMANDE A INTERPOLER
        TMG = DDOT(NNO,VFF(1,G),1,TM,1)
        TPG = DDOT(NNO,VFF(1,G),1,TP,1)
        
C      CALCUL DES DEFORMATIONS
        CALL DFDMIP(NDIM,NNO,AXI,GEOMI,G,IW,VFF(1,G),IDFF,R,W,DFF)
        CALL NMEPSI(NDIM,NNO,AXI,GRAND,VFF(1,G),R,DFF,DEPLM,FM,TBID)
        CALL DFDMIP(NDIM,NNO,AXI,GEOMM,G,IW,VFF(1,G),IDFF,R,RBID,DFF)
        CALL NMEPSI(NDIM,NNO,AXI,GRAND,VFF(1,G),R,DFF,DEPLD,FD,TBID)
        CALL DFDMIP(NDIM,NNO,AXI,GEOMP,G,IW,VFF(1,G),IDFF,R,RBID,DFF)
        CALL NMMALU(NNO,AXI,R,VFF(1,G),DFF,LIJ)
        
        JM = FM(1,1)*(FM(2,2)*FM(3,3)-FM(2,3)*FM(3,2))
     &     - FM(2,1)*(FM(1,2)*FM(3,3)-FM(1,3)*FM(3,2))
     &     + FM(3,1)*(FM(1,2)*FM(2,3)-FM(1,3)*FM(2,2))
        JD = FD(1,1)*(FD(2,2)*FD(3,3)-FD(2,3)*FD(3,2))
     &     - FD(2,1)*(FD(1,2)*FD(3,3)-FD(1,3)*FD(3,2))
     &     + FD(3,1)*(FD(1,2)*FD(2,3)-FD(1,3)*FD(2,2))
        JP = JM*JD


C      PERTINENCE DES GRANDEURS        
        IF (JD.LE.1.D-2 .OR. JD.GT.1.D2) THEN
          CODRET = 1
          GOTO 9999
        END IF

C -   APPEL A LA LOI DE COMPORTEMENT

C      POUR LES LOIS QUI NE RESPECTENT PAS ENCORE LA NOUVELLE INTERFACE
C      ET QUI ONT ENCORE BESOIN DES CONTRAINTES EN T-
        CALL R8INIR(6,0.D0,SIGMAM,1)       
        CALL DCOPY(NDIM*2,SIGM(1,G),1,SIGMAM,1)
        
        COD(G) = 0       
        CALL NMCOMP('RIGI',G,1,3,TYPMOD,MATE,COMPOR,CRIT,
     &             INSTM,INSTP,TMG,TPG,TREF,
     &             FM,FD,SIGMAM,VIM(1,G),OPTION,
     &             ANGMAS,TAMPON,
     &             TAUP,VIP(1,G),DSIDEP,COD(G))
        
        IF(COD(G).EQ.1) THEN
          CODRET = 1
          IF (.NOT. RESI) CALL U2MESS('F','ALGORITH11_88')
          GOTO 9999
        ENDIF
        
C      SUPPRESSION DES RACINES DE 2
        IF (RESI) CALL DSCAL(3,1/RAC2,TAUP(4),1)
        
C      MATRICE TANGENTE SANS LES RACINES DE 2
        IF (RIGI) THEN
          COEF=1.D0/RAC2
          CALL DSCAL(9,COEF,DSIDEP(4,1,1),6)
          CALL DSCAL(9,COEF,DSIDEP(5,1,1),6)
          CALL DSCAL(9,COEF,DSIDEP(6,1,1),6)
        END IF
        

C - CONTRAINTE ET FORCES INTERIEURES

        IF (RESI) THEN

C        CONTRAINTE DE CAUCHY A PARTIR DE KIRCHHOFF
          CALL DCOPY(2*NDIM,TAUP,1,SIGP(1,G),1)
          COEF=1.D0/JP
          CALL DSCAL(2*NDIM,COEF,SIGP(1,G),1)

C        VECTEUR FINT
          DO 300 NA=1,NNO
          DO 310 IA=1,NDU
            KK = VU(IA,NA)
            T1 = 0
            DO 320 JA = 1,NDU
              T2 = TAUP(VIJ(IA,JA))
              T1 = T1 + T2*DFF(NA,LIJ(IA,JA))
 320        CONTINUE
            FINT(KK) = FINT(KK) + W*T1
 310      CONTINUE
 300      CONTINUE
        END IF


C - MATRICE TANGENTE (NON SYMETRIQUE)
C  REM : ON DUPLIQUE LES CAS 2D ET 3D POUR EVITER DE PERDRE TROP EN 
C         TERME DE TEMPS DE CALCULS 
       
        IF (RIGI) THEN

     
          IF (.NOT. RESI) THEN
            CALL DCOPY(2*NDIM,SIGM(1,G),1,TAUP,1)
            CALL DSCAL(2*NDIM,JM,TAUP,1)
          END IF
          
          IF (NDU.EQ.3) THEN          
             DO 500 NA = 1,NNO
             DO 510 IA = 1,3
               OS = (VU(IA,NA) - 1)*NDDL
               
               DO 520 NB = 1,NNO
               DO 530 IB = 1,3
                 KK = OS + VU(IB,NB)
                 T1 = 0.D0
                 DO 550 JA = 1,3
                 DO 560 JB = 1,3
                   IJA = VIJ(IA,JA)
                   T2 = DSIDEP(IJA,IB,JB)
                   T1 =  T1 + DFF(NA,LIJ(IA,JA))*T2*DFF(NB,LIJ(IB,JB))
 560             CONTINUE
 550             CONTINUE
 
C               RIGIDITE GEOMETRIQUE
                 DO 570 JB = 1,3
                   T1 = T1 - DFF(NA,LIJ(IA,IB))*DFF(NB,LIJ(IB,JB))
     &                       *TAUP(VIJ(IA,JB))
 570             CONTINUE
                 MATR(KK) = MATR(KK) + W*T1
 530           CONTINUE
 520           CONTINUE
 
 510         CONTINUE
 500         CONTINUE
 
          ELSEIF (NDU.EQ.2) THEN
          
             DO 600 NA = 1,NNO
             DO 610 IA = 1,2
               OS = (VU(IA,NA) - 1)*NDDL
               
               DO 620 NB = 1,NNO
               DO 630 IB = 1,2
                 KK = OS + VU(IB,NB)
                 T1 = 0.D0
                 DO 650 JA = 1,2
                 DO 660 JB = 1,2
                   IJA = VIJ(IA,JA)
                   T2 = DSIDEP(IJA,IB,JB)
                   T1 =  T1 + DFF(NA,LIJ(IA,JA))*T2*DFF(NB,LIJ(IB,JB))
 660             CONTINUE
 650             CONTINUE
 
C               RIGIDITE GEOMETRIQUE
                 DO 670 JB = 1,2
                   T1 = T1 - DFF(NA,LIJ(IA,IB))*DFF(NB,LIJ(IB,JB))
     &                       *TAUP(VIJ(IA,JB))
 670             CONTINUE
                 MATR(KK) = MATR(KK) + W*T1
 630           CONTINUE
 620           CONTINUE
 
 610         CONTINUE
 600         CONTINUE
   
           END IF

        END IF

 10   CONTINUE

C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NPG,CODRET)

 9999 CONTINUE
      END
