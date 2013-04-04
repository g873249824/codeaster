      SUBROUTINE LC0008(FAMI,   KPG,    KSP,    NDIM,   IMATE,
     &                  COMPOR, CRIT,   INSTAM, INSTAP, EPSM,
     &                  DEPS,   SIGM,   VIM,    OPTION, ANGMAS,
     &                  SIGP,   VIP,    TAMPON, TYPMOD, ICOMP,
     &                  NVI,    DSIDEP, CODRET)
      IMPLICIT NONE
      INTEGER         IMATE,NDIM,KPG,KSP
      INTEGER         ICOMP,NVI
      INTEGER         CODRET
      REAL*8          ANGMAS(*),TAMPON(*)
      REAL*8          CRIT(*),INSTAM,INSTAP,SIGM(*)
      REAL*8          EPSM(6),  DEPS(6)
      REAL*8          SIGP(6)
      REAL*8          VIM(*),   VIP(*)
      REAL*8          DSIDEP(6,6)
      CHARACTER*16    COMPOR(6),   OPTION
      CHARACTER*8     TYPMOD(2)
      CHARACTER*(*)   FAMI
C
C TOLE CRP_21
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2013   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PROIX J-M.PROIX
C ======================================================================
C.......................................................................
C
C     BUT: LOI D'ENDOMMAGEMENT DE MAZARS

C          RELATION : 'MAZARS'
C
C       IN      FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C       IN      KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
C       IN      NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
C               TYPMOD  TYPE DE MODELISATION
C               IMATE    ADRESSE DU MATERIAU CODE
C               CRIT    CRITERES  LOCAUX
C                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                                 (ITER_INTE_MAXI == ITECREL)
C                       CRIT(2) = TYPE DE JACOBIEN A T+DT
C                                 (TYPE_MATR_COMP == MACOMP)
C                                 0 = EN VITESSE     > SYMETRIQUE
C                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
C                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                                 (RESI_INTE_RELA == RESCREL)
C                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
C                                 (ITER_INTE_PAS == ITEDEC)
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C               EPSM   DEFORMATION TOTALE A T
C               DEPS   INCREMENT DE DEFORMATION TOTALE
C               VIM    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C    ATTENTION  VIM    VARIABLES INTERNES A T MODIFIEES SI REDECOUPAGE
C               OPTION     OPTION DE CALCUL A FAIRE
C                             'RIGI_MECA_TANG'> DSIDEP(T)
C                             'FULL_MECA'     > DSIDEP(T+DT) , SIG(T+DT)
C                             'RAPH_MECA'     > SIG(T+DT)
C               TAMPON  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
C                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
C                       FIXEE EN DUR)
C       OUT     SIGP    CONTRAINTE A T+DT
C               VIP    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
C               DSIDEP    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C               CODRET    CODE RETOUR
C
      REAL*8      TP,TM,TREF
      INTEGER     IRET
      LOGICAL     CPLANE,COUP
C
C     NORMALEMENT, LES VERIF ONT ETE FAITES AVANT POUR INTERDIRE
C     GRAD_VARI
C     SIMO_MIEHE
C     EXPLICITE
C     GRAD_EPSI ET AXIS
C
C     FORMULATION NON-LOCALE AVEC REGULARISATION DES DEFORMATIONS
      IF (TYPMOD(2).EQ.'GRADEPSI') THEN
         CALL LCMZGE(FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,EPSM,
     &               DEPS,VIM,OPTION,SIGP,VIP,
     &               DSIDEP,TAMPON)
C
C     FORMULATION LOCALE
      ELSE
         CALL RCVARC(' ','TEMP','-'  ,FAMI,KPG,KSP,TM  ,IRET)
         CALL RCVARC(' ','TEMP','+'  ,FAMI,KPG,KSP,TP  ,IRET)
         CALL RCVARC(' ','TEMP','REF',FAMI,KPG,KSP,TREF,IRET)

         CPLANE = (TYPMOD(1).EQ.'C_PLAN  ').AND.
     &            (COMPOR(1)(1:9).EQ.'MAZARS_GC')
         IF ( CPLANE ) THEN
C           PAS DE COUPLAGE UMLV EN CP
            COUP = (OPTION(6:9).EQ.'COUP')
            IF ( COUP ) CALL U2MESK('F','ALGORITH4_10',1,COMPOR(1))
            CALL LCMZCP(FAMI, KPG,    KSP,  NDIM, IMATE,
     &                  EPSM, DEPS,   VIM,  TM,   TP,
     &                  TREF, OPTION, SIGP, VIP,  DSIDEP)
         ELSE
            CALL LCMAZA(FAMI, KPG, KSP, NDIM, TYPMOD,
     &                  IMATE, COMPOR, EPSM, DEPS, VIM,
     &                  TM, TP,  TREF, OPTION, SIGP,
     &                  VIP, DSIDEP)
         ENDIF
      ENDIF
      END
