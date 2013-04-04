      SUBROUTINE LC0050(FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,COMPOR,CRIT,
     &           INSTAM,INSTAP,NEPS,EPSM,DEPS,NSIG,SIGM,NVI,VIM,OPTION,
     &           ANGMAS,NWKIN,WKIN,ICOMP,
     &           STRESS,STATEV,NDSDE,DSIDEP,NWKOUT,WKOUT,CODRET)

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
C TOLE CRP_21
C ======================================================================
C     BUT: INTERFACE POUR ROUTINE D'INTEGRATION LOI DE COMPORTEMENT UMAT
C       IN   FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C            KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
C            NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
C            IMATE    ADRESSE DU MATERIAU CODE
C            COMPOR    COMPORTEMENT DE L ELEMENT
C                COMPOR(1) = RELATION DE COMPORTEMENT (UMAT)
C                COMPOR(2) = NB DE VARIABLES INTERNES
C                COMPOR(3) = TYPE DE DEFORMATION(PETIT,GDEF_LOG)
C            CRIT    CRITERES  LOCAUX, INUTILISES PAR UMAT
C            INSTAM   INSTANT T
C            INSTAP   INSTANT T+DT
C            EPSM   DEFORMATION TOTALE A T EVENTUELLEMENT TOURNEE
C                   DANS LE REPERE COROTATIONNEL SI GDEF_LOG
C            DEPS   INCREMENT DE DEFORMATION EVENTUELLEMENT TOURNEE
C                   DANS LE REPERE COROTATIONNEL SI GDEF_LOG
C            SIGM   CONTRAINTE A T EVENTUELLEMENT TOURNEE...
C            VIM    VARIABLES INTERNES A T + INDICATEUR ETAT T
C ATTENTION : SI MODELE CINEMATIQUE ET GDEF, MODIFIER AUSSI VICIN0.F
C            OPTION     OPTION DE CALCUL A FAIRE
C                          'RIGI_MECA_TANG'> DSIDEP(T)
C                          'FULL_MECA'     > DSIDEP(T+DT) , SIG(T+DT)
C                          'RAPH_MECA'     > SIG(T+DT)
C            ANGMAS  ANGLES DE ROTATION DU REPERE LOCAL, CF. MASSIF
C       OUT  STRESS    CONTRAINTE A T+DT
C !!!!        ATTENTION : ZONE MEMOIRE NON DEFINIE SI RIGI_MECA_TANG
C       OUT  STATEV  VARIABLES INTERNES A T+DT
C !!!!        ATTENTION : ZONE MEMOIRE NON DEFINIE SI RIGI_MECA_TANG
C        IN  WKIN  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
C            TYPMOD  TYPE DE MODELISATION (3D, AXIS, D_PLAN)
C            ICOMP   NUMERO DU SOUS-PAS DE TEMPS (CF. REDECE.F)
C            NVI     NOMBRE TOTAL DE VARIABLES INTERNES (+9 SI GDEF_HYP)
C       OUT  DSIDEP  MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C       OUT  CODRET  CODE-RETOUR = 0 SI OK, =1 SINON
C ======================================================================
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      INTEGER       IMATE,NDIM,KPG,KSP,CODRET,ICOMP,NVI,IRET,NPROP2
      INTEGER       NPROPS,NTENS,NDI,NSHR,I,NSTATV,NPT,NOEL,LAYER,NPRED
      INTEGER       KSPT,KSTEP,KINC,IDBG,J,IFM,NIV,NWKIN,NWKOUT,IRET2
      PARAMETER     ( NPROPS = 197)
      PARAMETER     ( NPRED = 6)
      INTEGER       CODREL(NPROPS+3),NEPS,NSIG,NDSDE,IADZI,IAZK24
      REAL*8        CRIT(*),ANGMAS(*),TM,TP,TREF,PROPL(NPROPS+3)
      REAL*8        INSTAM,INSTAP,DROT(3,3),DSTRAN(9),PROPS(NPROPS+3)
      REAL*8        EPSM(6),DEPS(6),WKIN(NWKIN),WKOUT(NWKOUT),EPSTHM
      REAL*8        SIGM(6),STRESS(6),DEPSTH(6),SSE,SPD,SCD,TIME(2)
      REAL*8        VIM(*),STATEV(NVI),BENDOM,KDESSM,BENDOP,KDESSP
      REAL*8        PREDEF(NPRED),DPRED(NPRED),VRCM,VRCP,VALREB(2)
      REAL*8        HYDRM,HYDRP,SECHM,SECHP,SREF,EPSBP,EPSBM,EPSTHP
      REAL*8        DDSDDE(36),R8NNEM,DFGRD0(3,3),DFGRD1(3,3),XYZ(3)
      REAL*8        DDSDDT(6),DRPLDE(6),CELENT,STRAN(9),DSIDEP(6,6)
      REAL*8        DTIME,TEMP,DTEMP,COORDS(3),RPL,PNEWDT,DRPLDT,REP(4)
      REAL*8        DEPST1,EPSTH1,EPSTH(6),RAC2,USRAC2,DROTT(3,3)
      CHARACTER*16  COMPOR(*),OPTION
      CHARACTER*8   TYPMOD(*),NOMRES(NPROPS),NOMREB(2),LVARC(NPRED)
      CHARACTER*(*) FAMI
      CHARACTER*80  CMNAME
      COMMON/TDIM/  NTENS  , NDI
C     POUR TECAEL
      CHARACTER*128 NOMLIB
      CHARACTER*16 NOMSUB
      CHARACTER*2  K2
      INTEGER II,DIMAKI,NBCOEF,ICODRB(2)
C     DIMAKI = DIMENSION MAX DE LA LISTE DES RELATIONS KIT
      PARAMETER (DIMAKI=9)
      DATA IDBG/1/
      DATA NOMRES/'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10',
     &'C11','C12','C13','C14','C15','C16','C17','C18','C19','C20','C21',
     &'C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32',
     &'C33','C34','C35','C36','C37','C38','C39','C40','C41','C42','C43',
     &'C44','C45','C46','C47','C48','C49','C50','C51','C52','C53','C54',
     &'C55','C56','C57','C58','C59','C60','C61','C62','C63','C64','C65',
     &'C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76',
     &'C77','C78','C79','C80','C81','C82','C83','C84','C85','C86','C87',
     &'C88','C89','C90','C91','C92','C93','C94','C95','C96','C97','C98',
     &'C99','C100','C101','C102','C103','C104','C105','C106','C107',
     &'C108','C109','C110','C111','C112','C113','C114','C115','C116',
     &'C117','C118','C119','C120','C121','C122','C123','C124','C125',
     &'C126','C127','C128','C129','C130','C131','C132','C133','C134',
     &'C135','C136','C137','C138','C139','C140','C141','C142','C143',
     &'C144','C145','C146','C147','C148','C149','C150','C151','C152',
     &'C153','C154','C155','C156','C157','C158','C159','C160','C161',
     &'C162','C163','C164','C165','C166','C167','C168','C169','C170',
     &'C171','C172','C173','C174','C175','C176','C177','C178','C179',
     &'C180','C181','C182','C183','C184','C185','C186','C187','C188',
     &'C189','C190','C191','C192','C193','C194','C195','C196','C197'/
      DATA LVARC/'SECH','HYDR','IRRA','NEUT1','NEUT2','CORR'/

C     NTENS  :  NB TOTAL DE COMPOSANTES TENSEURS
C     NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
C ======================================================================

C     NUMERO D'ELEMENT SEULEMENT SI ON N'EST PAS DANS CALC_POINT_MAT
      NOEL=0
      IF (COMPOR(1)(9:14).NE.'OP0033') THEN
C        NUMERO D'ELEMENT
         CALL TECAEL(IADZI,IAZK24)
         NOEL=ZI(IADZI)
      ENDIF

      NTENS=2*NDIM
      NDI=3
      NSHR=NTENS-NDI
      CODRET=0
      RAC2=SQRT(2.D0)
      USRAC2=RAC2*0.5D0

C     IMPRESSIONS EVENTUELLES EN DEBUG
      CALL INFNIV(IFM,NIV)

C     PARAMETRES UMAT STOCKES DANS 'KIT1-KIT9'
      DO 10 II=1,DIMAKI-1
         NOMLIB(16*(II-1)+1:16*II) = COMPOR(7+II)
   10 CONTINUE
      NOMSUB = COMPOR(7+DIMAKI)

C     LECTURE DES PROPRIETES MATERIAU (MOT-CLE UMAT DE DEFI_MATERIAU)
      CALL R8INIR(NPROPS, R8NNEM(), PROPS, 1)

C     LECTURE DU PREMIER PARAMETRE NB, FACULTATIF     
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','UMAT',0,' ',0.D0,
     &            1,'NB_VALE',PROPL(1),CODREL, 0)
      IF (CODREL(1).EQ.0) THEN
         NBCOEF=NINT(PROPL(1))
      ELSE
         NBCOEF=NPROPS
      ENDIF
C     lecture des autres parametres    
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','UMAT',0,' ',0.D0,
     &            NBCOEF,NOMRES,PROPL,CODREL, 0)
C     COMPTAGE DU NOMBRE DE PROPRIETES
C     CODREL(I)=0 SI LE PARAMETRE EXISTE, 1 SINON
      NPROP2=0
      IF ((NIV.GE.2).AND.(IDBG.EQ.1)) THEN
         WRITE(IFM,*)' '
         WRITE(IFM,*)'COEFFICIENTS MATERIAU'
      ENDIF
      DO 20 I=1,NBCOEF
         IF (CODREL(I).EQ.0) THEN
            NPROP2=NPROP2+1
            PROPS(NPROP2)=PROPL(I)
            IF ((NIV.GE.2).AND.(IDBG.EQ.1)) THEN
               WRITE(IFM,*) NOMRES(I),PROPS(NPROP2)
            ENDIF
         ENDIF
   20 CONTINUE

C APPEL DE RCVARC POUR LE CALCUL DE LA TEMPERATURE
C RAISON: PASSAGE A UMAT DE LA TEMPERATURE
      CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TM,IRET)
      IF (IRET.NE.0) TM=0.D0
      CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TP,IRET)
      IF (IRET.NE.0) TP=0.D0
      CALL RCVARC(' ','TEMP','REF',FAMI,KPG,KSP,TREF,IRET)
      IF (IRET.NE.0) TREF=0.D0
C     CALCUL DES DEFORMATIONS DE DILATATION THERMIQUE
      CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS',1,DEPST1,IRET)
      IF (IRET.NE.0) DEPST1=0.D0
      CALL VERIFT(FAMI,KPG,KSP,'-',IMATE,'ELAS',1,EPSTH1,IRET)
      IF (IRET.NE.0) EPSTH1=0.D0

C APPEL DE RCVARC POUR EXTRAIRE TOUTES LES VARIABLES DE COMMANDE
      CALL R8INIR(NPRED, R8NNEM(), PREDEF, 1)
      CALL R8INIR(NPRED, R8NNEM(), DPRED, 1)
C     SECHAGE 
      CALL RCVARC(' ',LVARC(1),'-',FAMI,KPG,KSP,VRCM,IRET)
      IF (IRET.EQ.0) THEN
         PREDEF(1)=VRCM
         CALL RCVARC('F',LVARC(1),'+',FAMI,KPG,KSP,VRCP,IRET2)
         DPRED(1)=VRCP-VRCM         
C        RETRAIT DESSICATION
         NOMREB(1)='K_DESSIC'
         CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',0,' ',0.D0,1,
     &               NOMREB,VALREB,ICODRB,1)
         KDESSM = VALREB(1)
         CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',0.D0,1,
     &               NOMREB,VALREB,ICODRB,1)
         KDESSP = VALREB(1)
         CALL RCVARC(' ','SECH','REF',FAMI,KPG,KSP,SREF,IRET2)
         IF (IRET2.NE.0) SREF=0.D0
         SECHM=PREDEF(1)
         SECHP=PREDEF(1)+DPRED(1)
         EPSBM=-KDESSM*(SREF-SECHM)
         EPSBP=-KDESSP*(SREF-SECHP)
         EPSTHM=EPSTH1+EPSBM
         EPSTHP=EPSTH1+DEPST1+EPSBP
         DEPST1=EPSTHP-EPSTHM
         EPSTH1=EPSTHM
      ENDIF
C     HYDRATATION      
      CALL RCVARC(' ',LVARC(2),'-',FAMI,KPG,KSP,VRCM,IRET)
      IF (IRET.EQ.0) THEN
         PREDEF(2)=VRCM
         CALL RCVARC('F',LVARC(2),'+',FAMI,KPG,KSP,VRCP,IRET2)
         DPRED(2)=VRCP-VRCM
C        RETRAIT ENDOGENE
         NOMREB(1)='B_ENDOGE'
         CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',0,' ',0.D0,1,
     &               NOMREB,VALREB,ICODRB,1)
         BENDOM = VALREB(1)
         CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',0.D0,1,
     &               NOMREB,VALREB,ICODRB,1)
         BENDOP = VALREB(1)
         HYDRM=PREDEF(2)
         HYDRP=PREDEF(2)+DPRED(2)
         EPSBM=-BENDOM*HYDRM
         EPSBP=-BENDOP*HYDRP
         EPSTHM=EPSTH1+EPSBM
         EPSTHP=EPSTH1+DEPST1+EPSBP
         DEPST1=EPSTHP-EPSTHM
         EPSTH1=EPSTHM
      ENDIF
      DO 30 I=3,NPRED
         CALL RCVARC(' ',LVARC(I),'-',FAMI,KPG,KSP,VRCM,IRET)
         IF (IRET.EQ.0) THEN
            PREDEF(I)=VRCM
            CALL RCVARC('F',LVARC(I),'+',FAMI,KPG,KSP,VRCP,IRET2)
            DPRED(I)=VRCP-VRCM
         ENDIF
   30 CONTINUE
   
      
C CAS DES GRANDES DEFORMATIONS : ON VEUT F- ET F+

      IF (NEPS.EQ.9) THEN

         CALL DCOPY(NEPS,EPSM,1,DFGRD0,1)
         IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &        OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
            CALL PMAT(3,DEPS,DFGRD0,DFGRD1)
         ELSE
            CALL DCOPY(NEPS,DFGRD0,1,DFGRD1,1)
         ENDIF
         CALL R8INIR(NEPS, 0.D0, STRAN, 1)
         CALL R8INIR(NEPS, 0.D0, DSTRAN, 1)

      ELSEIF (NEPS.EQ.6) THEN

C PETITES DEFORMATIONS : DEFORMATION - DEFORMATION THERMIQUE
         CALL R8INIR(NEPS, 0.D0, DEPSTH, 1)
         CALL R8INIR(NDI, DEPST1, DEPSTH, 1)
         IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &        OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
            CALL DCOPY(NEPS,DEPS,1,DSTRAN,1)
            CALL DAXPY(NEPS,-1.D0,DEPSTH,1,DSTRAN,1)
C TRAITEMENT DES COMPOSANTES 4,5,6 : DANS UMAT, GAMMAXY,XZ,YZ
            CALL DSCAL(3,RAC2,DSTRAN(4),1)
         ELSE
            CALL R8INIR(NEPS, 0.D0, DSTRAN, 1)
         ENDIF

         CALL R8INIR(NEPS, 0.D0, EPSTH, 1)
         CALL R8INIR(NDI,   EPSTH1, EPSTH, 1)
         CALL DCOPY(NEPS,EPSM,1,STRAN,1)
         CALL DAXPY(NEPS,-1.D0,EPSTH,1,STRAN,1)
         CALL DSCAL(3,RAC2,STRAN(4),1)

         CALL R8INIR(9, 0.D0, DFGRD0, 1)
         CALL R8INIR(9, 0.D0, DFGRD1, 1)
      ELSE
         CALL ASSERT(.FALSE.)
      ENDIF

      IF (COMPOR(3).EQ.'GDEF_LOG') THEN
         NSTATV=NVI-6
      ELSE
         NSTATV=NVI
      ENDIF

      TIME(1)=INSTAP-INSTAM
      TIME(2)=INSTAM
      DTIME=INSTAP-INSTAM
      TEMP=TM
      DTEMP=TP-TM
      CMNAME=COMPOR(1)

      CALL R8INIR(3, R8NNEM(), COORDS, 1)
      CALL MATROT ( ANGMAS , DROTT )
      
      DO 100,I = 1,3
        DO 90,J = 1,3
          DROT(J,I) = DROTT(I,J)
   90   CONTINUE
  100 CONTINUE
      
      CELENT=WKIN(1)
      NPT=KPG
      LAYER=1
      KSPT=KSP
      KSTEP=ICOMP
      KINC=1
C     initialisations des arguments inutilises
      SSE=0.D0
      SPD=0.D0
      SCD=0.D0
      RPL=0.D0
      CALL R8INIR(6, 0.D0, DDSDDT, 1)
      CALL R8INIR(6, 0.D0, DRPLDE, 1)
      DRPLDT=0.D0

      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
       IF ((NIV.GE.2).AND.(IDBG.EQ.1)) THEN
          WRITE(IFM,*)' '
          WRITE(IFM,*)'AVANT APPEL UMAT, INSTANT=',TIME(2)+DTIME
          WRITE(IFM,*)'     NOM LIBRAIRIE : '//NOMLIB
          WRITE(IFM,*)'       NOM ROUTINE : '//NOMSUB
          WRITE(IFM,*)'NUMERO ELEMENT=',NOEL
          WRITE(IFM,*)'DEFORMATIONS INSTANT PRECEDENT STRAN='
          WRITE(IFM,'(6(1X,E11.4))') (STRAN(I),I=1,NTENS)
          WRITE(IFM,*)'ACCROISSEMENT DE DEFORMATIONS DSTRAN='
          WRITE(IFM,'(6(1X,E11.4))') (DSTRAN(I),I=1,NTENS)
          WRITE(IFM,*)'CONTRAINTES INSTANT PRECEDENT STRESS='
          WRITE(IFM,'(6(1X,E11.4))') (SIGM(I),I=1,NTENS)
          WRITE(IFM,*)'NVI=',NSTATV,' VARIABLES INTERNES STATEV='
          WRITE(IFM,'(10(1X,E11.4))') (VIM(I),I=1,NSTATV)
          WRITE(IFM,*)'TEMPERATURE ET INCREMENT'
          WRITE(IFM,'(2(1X,E11.4))') TEMP,DTEMP
          WRITE(IFM,*) 'VARIABLES DE COMMANDE ET INCREMENTS'
          DO 70 I=1,NPRED
             WRITE(IFM,'(A8,2(1X,E11.4))') LVARC(I),PREDEF(I),DPRED(I)
   70     CONTINUE
       ENDIF
      ENDIF

      PNEWDT=1.D0
      DDSDDE=0.D0
      IF ( OPTION(1:9) .EQ. 'RIGI_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
           DDSDDE(1)=1.D0
      ENDIF
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN

         CALL DCOPY(NSIG,SIGM,1,STRESS,1)
         CALL DSCAL(3,USRAC2,STRESS(4),1)

         CALL LCEQVN( NSTATV ,VIM , STATEV )

         CALL UMATWP(NOMLIB, NOMSUB,
     &    STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     &    RPL,DDSDDT,DRPLDE,DRPLDT,
     &    STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     &    NDI,NSHR,NTENS,NSTATV,PROPS,NPROP2,COORDS,DROT,PNEWDT,
     &    CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,KSTEP,KINC)

      ELSEIF ( OPTION(1:9).EQ. 'RIGI_MECA' ) THEN
         IF (COMPOR(1).EQ.'UMAT') THEN
            CALL UMATWP(NOMLIB, NOMSUB,
     &      SIGM,VIM,DDSDDE,SSE,SPD,SCD,
     &      RPL,DDSDDT,DRPLDE,DRPLDT,
     &      STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     &      NDI,NSHR,NTENS,NSTATV,PROPS,NPROP2,COORDS,DROT,PNEWDT,
     &      CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,KSTEP,KINC)
         ELSEIF (COMPOR(1).EQ.'MFRONT') THEN
C           MATRICE DE PREDICTION OU SECANTE ELASTIQUE POUR MFRONT      
            REP(1)=1.D0
            REP(2)=ANGMAS(1)
            REP(3)=ANGMAS(2)
            REP(4)=ANGMAS(3)
            K2=' '
            CALL DMATMC(FAMI,K2,IMATE,0.D0,'+',KPG,KSP,REP,XYZ,NTENS,
     &                  DDSDDE)
         ENDIF
      ENDIF

      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
         IF ((NIV.GE.2).AND.(IDBG.EQ.1)) THEN
             WRITE(IFM,*)' '
             WRITE(IFM,*)'APRES APPEL UMAT, STRESS='
             WRITE(IFM,'(6(1X,E11.4))') (STRESS(I),I=1,NTENS)
             WRITE(IFM,*)'APRES APPEL UMAT, STATEV='
             WRITE(IFM,'(10(1X,E11.4))')(STATEV(I),I=1,NSTATV)
          ENDIF
      ENDIF

      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
         CALL DSCAL(3,RAC2,STRESS(4),1)
      ENDIF

      IF ( OPTION(1:9) .EQ. 'RIGI_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
         CALL R8INIR(36, 0.D0, DSIDEP, 1)
         CALL LCICMA (DDSDDE,NTENS,NTENS,NTENS,NTENS,1,1,DSIDEP,6,6,1,1)
           DO 40 I=1,6
           DO 40 J=4,6
             DSIDEP(I,J) = DSIDEP(I,J)*RAC2
 40        CONTINUE
           DO 50 I=4,6
           DO 50 J=1,6
             DSIDEP(I,J) = DSIDEP(I,J)*RAC2
 50        CONTINUE
         IF ((NIV.GE.2).AND.(IDBG.EQ.1)) THEN
            WRITE(IFM,*)'APRES APPEL UMAT,OPERATEUR TANGENT DSIDEP='
            DO 60 I=1,6
               WRITE(IFM,'(6(1X,E11.4))') (DSIDEP(I,J),J=1,6)
 60        CONTINUE
         ENDIF
      ENDIF

      IF (PNEWDT.LT.0.99D0) CODRET=1
      IDBG=0

      END
