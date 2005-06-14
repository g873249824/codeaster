      SUBROUTINE NMZMAT (NDIM,   TYPMOD, COMPOR, CRIT,   INSTAM,
     &                   INSTAP, TM,     TP,     TREF,   EPSM,
     &                   DEPS,   SIGM,   VIM,    OPTION, ANGMAS,
     &                   SIGP,   VIP,    DSIDEP, CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/04/2005   AUTEUR MCOURTOI M.COURTOIS 
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
C
C ----------------------------------------------------------------------
C     INTEGRATION DU COMPORTEMENT EN UTILISANT LA BIBLIOTHEQUE ZMAT
C ----------------------------------------------------------------------
C     ROUTINE INTERFACE : Zaster.c (EN C++ DANS libzAster.so)
C
C ARGUMENTS DE ZASTER (SIMPLEMENT DEDUITS DE CEUX DE NMZMAT) :
C IN :
C  IEL     (I) : NUMERO DE L'ELEMENT
C  MODELE  (I) : TYPE DE MODELE (1:3D, 2:AXIS, 3:D_PLAN, 4:C_PLAN)
C  NVAR    (I) : NOMBRE DE VARIABLES INTERNES
C  NDEF    (I) : GRDES DEFORMATIONS (2:SIMO_MIEHE, 1:PETIT)
C  NUNIT   (I) : NUMERO DE L'UNITE LOGIQUE QUI CONTIENT LES DONNEES
C                POUR LE COMPORTEMENT ZMAT
C  INSTAM (R8) : INSTANT DU CALCUL PRECEDENT
C  INSTAP (R8) : INSTANT DU CALCUL
C  TM     (R8) : TEMPERATURE A L'INSTANT PRECEDENT
C  TP     (R8) : INSTANT DU CALCUL
C  TREF   (R8) : TEMPERATURE REFERENCE POUR LES CONTRAINTES THERMIQUES
C  EPSM  (R8*) : DEFORMATIONS A L'INSTANT DU CALCUL PRECEDENT
C  DEPS  (R8*) : INCREMENT DE DEFORMATION TOTALE :
C                   DEPS(T) = DEPS(MECANIQUE(T)) + DEPS(DILATATION(T))
C  SIGM  (R8*) : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT
C  VIM   (R8*) : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C  NOPT    (I) : OPTION (1:RIGI_MECA_TANG, 2:FULL_MECA , 3:RAPH_MECA)
C  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C
C IN/OUT :
C  VIP   (R8*) : VARIABLES INTERNES
C                IN  : ESTIMATION (ITERATION PRECEDENTE OU LAG. AUGM.)
C                OUT : EN T+
C
C OUT :
C  SIGP   (R8*) : CONTRAINTES A L'INSTANT DU CALCUL
C  DSIDEP (R8*) : MATRICE CARREE
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
      INTEGER            NDIM,CODRET,I,NUNIT
      CHARACTER*8        TYPMOD(*)
      CHARACTER*16       COMPOR(*), OPTION
      REAL*8             CRIT(*), INSTAM, INSTAP, TM, TP, TREF
      REAL*8             EPSM(*), DEPS(*), DSIDEP(*)
      REAL*8             SIGM(*), VIM(*), SIGP(*), VIP(*)
      REAL*8             ANGMAS(3)
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNOM,JEXNUM
C
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      INTEGER            IZI,IZK
      INTEGER MODELE,NVAR,NDEF,NOPT
C
C     MODELE=1 EN 3D,2 EN AXIS, 3 EN D_PLAN, 4 EN C_PLAN
      IF (TYPMOD(1).EQ.'3D') THEN
         MODELE=1
      ELSEIF (TYPMOD(1).EQ.'AXIS') THEN
        MODELE=2
      ELSEIF (TYPMOD(1).EQ.'D_PLAN') THEN
        MODELE=3
      ELSE
        MODELE=4
      ENDIF
      READ (COMPOR(6),'(I16)') NUNIT
      READ (COMPOR(2),'(I16)') NVAR
      IF (COMPOR(3).EQ.'SIMO_MIEHE') THEN
         NDEF=2
      ELSE
         NDEF=1
      ENDIF

      IF(OPTION.EQ.'RIGI_MECA_TANG') THEN
         NOPT=1
      ELSE IF(OPTION.EQ.'FULL_MECA') THEN
         NOPT=2
      ELSE
         NOPT=3
      ENDIF
      CALL TECAEL(IZI,IZK)
      CALL ZASTER(ZI(IZI),MODELE,NVAR,NDEF,NUNIT,INSTAM,INSTAP,
     &       TM,TP,TREF,EPSM,DEPS,SIGM,VIM,NOPT,ANGMAS,SIGP,VIP,
     &       DSIDEP,CODRET)
      END
