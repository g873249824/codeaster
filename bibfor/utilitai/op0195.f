      SUBROUTINE OP0195(IER)
      IMPLICIT  NONE
      INTEGER IER
C     -----------------------------------------------------------------
C MODIF UTILITAI  DATE 16/09/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
C     COMMANDE CREA_CHAMP
C     -----------------------------------------------------------------
      INTEGER N1,IB,IFM,NIV,IRET,I11,I12,TEST,IBID
      CHARACTER*3 PROL0
      CHARACTER*4 TYCHR
      CHARACTER*8 KBID,MO,MA,CHOU,NOMGD,NOMGD2,NOMPAR,MA2,NOPAR2,TA
      CHARACTER*8 TSCA
      CHARACTER*16 TYCHR1,OPERA,OPTIO2,TYPCO,OPTION
      CHARACTER*19 LIGREL,CARTEM,CELMOD,PRCHN1,CNS1,CH1,PRCHN2,CHIN
      CHARACTER*8 NU1
C     -----------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*24 VALK(2)
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM,JEXNUM
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)


C 1- CALCUL DE:
C      OPERA: OPERATION A EFFECTUER
C      MO: MODELE (OU ' ')
C      MA: MAILLAGE (OU ' ')
C      CHOU  : CHAMP RESULTAT
C      TYCHR : TYPE DU CHAMP RESULTAT (CART/NOEU/ELNO/ELGA/ELEM)
C      NOMGD : GRANDEUR ASSOCIEE A CHOU
C      PROL0 :/'OUI' POUR PROLONGER PAR ZERO LE CHAM_ELEM RESULTAT
C      OPTION: OPTION PERMETTANT D'ALLOUER UN CHAM_ELEM "MODELE"

C     ------------------------------------------------------------------

      CALL GETVTX(' ','OPERATION',0,1,1,OPERA,IB)

      CALL GETVID(' ','MODELE',0,1,1,MO,N1)
      IF (N1.EQ.0) MO = ' '
      CALL GETVID(' ','MAILLAGE',0,1,1,MA,N1)
      IF (N1.EQ.0) MA = ' '
      IF (MO.NE.' ') THEN
        CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IB,MA2,IB)
        IF ((MA.NE.' ') .AND. (MA.NE.MA2)) CALL U2MESS('F',
     &      'UTILITAI3_21')
        MA = MA2
      ENDIF

      CALL GETRES(CHOU,TYPCO,KBID)
      CALL EXISD('CHAMP',CHOU,TEST)
      IF ((TEST.EQ.1) .AND. (OPERA.NE.'ASSE')) THEN
        CALL U2MESS('F','UTILITAI3_43')
      ENDIF
      CALL GETVTX(' ','TYPE_CHAM',0,1,1,TYCHR1,IB)
      TYCHR = TYCHR1(1:4)
      NOMGD = TYCHR1(6:13)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IB,TSCA,IB)

      PROL0=' '
      CALL GETVTX(' ','PROL_ZERO',0,1,1,PROL0,IB)
C     IF ((PROL0.EQ.'NON').AND.(TSCA.EQ.'R')) PROL0='NAN'

      CALL GETVTX(' ','OPTION',0,1,1,OPTION,N1)
      IF (N1.EQ.0) OPTION = ' '


C 2.  CALCUL DE LIGREL,CELMOD  + QUELQUES VERIFICATIONS   :
C     -------------------------------------------------------------
      LIGREL = ' '
      CELMOD = ' '

      IF (TYCHR(1:2).EQ.'EL') THEN
        IF ((OPERA.EQ.'AFFE') .OR. (OPERA.EQ.'ASSE') .OR.
     &      (OPERA.EQ.'DISC')) THEN
          IF (MO.EQ.' ') CALL U2MESS('F','UTILITAI3_22')
          LIGREL = MO//'.MODELE'

C         -- CALCUL D'UN CHAM_ELEM "MODELE" : CELMOD
C         ---------------------------------------------------
          IF (OPTION.EQ.' ') THEN
            OPTIO2 = 'TOU_INI_'//TYCHR
C           -- SI OPERATION 'ASSE', IL Y A PEUT-ETRE UNE MEILLEURE
C              OPTION A CHOISIR PAR DEFAUT QUE TOU_INI_ELXX
            IF (OPERA.EQ.'ASSE') THEN
              CALL GETVID('ASSE','CHAM_GD',1,1,1,CHIN,IB)
              CALL JEEXIN(CHIN//'.CELK',IRET)
              CALL DISMOI('F','NOM_GD',CHIN,'CHAMP',IB,NOMGD2,IB)
              IF (IRET.NE.0.AND.NOMGD.EQ.NOMGD2) THEN
                CALL DISMOI('F','NOM_OPTION',CHIN,'CHAM_ELEM',IB,OPTIO2,
     &                      IB)
              ENDIF
            ENDIF

          ELSE
            OPTIO2 = OPTION
          ENDIF
          NOMPAR = NOPAR2(OPTIO2,NOMGD,'OUT')
          CELMOD = '&&OP0195.CELMOD'
          CALL ALCHML(LIGREL,OPTIO2,NOMPAR,'V',CELMOD,IB,' ')
          IF (IB.NE.0) CALL U2MESK('F','UTILITAI3_23',1,OPTIO2)

C         VERIFICATION DU TYPE DE CELMOD : ELGA/ELNO/ELEM :
          CALL JEVEUO(CELMOD//'.CELK','L',IB)
          IF (ZK24(IB-1+3).NE.TYCHR) THEN
            VALK(1) = OPTIO2
            VALK(2) = TYCHR
            CALL U2MESK('F','UTILITAI3_24',2,VALK)
          ENDIF
        ENDIF
      ENDIF



C 3.  TRAITEMENT DU MOT CLE OPERATION :
C     -------------------------------------------------------------


      IF (OPERA.EQ.'NORMALE') THEN
C     -----------------------------------------
        IF (TYCHR.EQ.'NOEU') THEN
          IF (NOMGD.NE.'GEOM_R') CALL U2MESK('F','UTILITAI3_25',1,OPERA)
          CALL CNONOR(MO,NOMGD,'G',CHOU)

        ELSE
          VALK(1) = OPERA
          VALK(2) = TYCHR
          CALL U2MESK('F','UTILITAI3_26',2,VALK)
        ENDIF



      ELSEIF (OPERA.EQ.'AFFE') THEN
C     -----------------------------------------
        IF (TYCHR.EQ.'NOEU') THEN
          CALL CNOAFF(MA,NOMGD,'G',CHOU)

        ELSEIF (TYCHR.EQ.'CART') THEN
          CALL CARAFF(MA,NOMGD,'G',CHOU)

        ELSEIF (TYCHR(1:2).EQ.'EL') THEN
          CARTEM = '&&OP0195.CARTEM'
          CALL CARAFF(MA,NOMGD,'V',CARTEM)
          CALL CHPCHD(CARTEM,TYCHR,CELMOD,PROL0,'G',CHOU)
          CALL DETRSD('CHAMP_GD',CARTEM)
        ENDIF


      ELSEIF (OPERA.EQ.'ASSE') THEN
C     -----------------------------------------
        CALL CHPASS(TYCHR,MA,CELMOD,NOMGD,PROL0,CHOU)


      ELSEIF (OPERA.EQ.'EVAL') THEN
C     -----------------------------------------
        CALL CHPEVA(CHOU)


      ELSEIF (OPERA(1:3).EQ.'R2C') THEN
C     -----------------------------------------
        CALL CHCORE(CHOU)


      ELSEIF (OPERA(1:3).EQ.'C2R') THEN
C     -----------------------------------------
        CALL CHRECO(CHOU)


      ELSEIF (OPERA.EQ.'DISC') THEN
C     -----------------------------------------
        CALL GETVID(' ','CHAM_GD',0,1,1,CHIN,IB)
        CALL DISMOI('F','NOM_GD',CHIN,'CHAMP',IB,NOMGD2,IB)
        IF (NOMGD.NE.NOMGD2) THEN
C          -- EXCEPTION : NOMGD='VARI_R' ET NOMGD2='VAR2_R'
          IF (.NOT. (NOMGD.EQ.'VARI_R'.AND.NOMGD2.EQ.'VAR2_R')) THEN
            VALK(1) = CHIN
            VALK(2) = TYCHR1
            CALL U2MESK('F','UTILITAI3_27',2,VALK)
          ENDIF
        ENDIF
        CALL CHPCHD(CHIN,TYCHR,CELMOD,PROL0,'G',CHOU)


      ELSEIF (OPERA.EQ.'EXTR') THEN
C     -----------------------------------------
        CALL GETVID(' ','TABLE',0,1,1,TA,N1)
        IF (N1.EQ.0) THEN
          CALL CHPREC(CHOU)

        ELSE
          CALL U195TB(CHOU)
        ENDIF
      ENDIF



C 4.  SI ON A CREE UN CHAM_NO, ON PEUT IMPOSER SA NUMEROTATION :
C --------------------------------------------------------------
      IF (TYCHR.EQ.'NOEU') THEN
        CALL GETVID(' ','CHAM_NO',0,1,1,CH1,I11)
        CALL GETVID(' ','NUME_DDL',0,1,1,NU1,I12)
        IF ((I11+I12).GT.0) THEN
          PRCHN1 = ' '
          IF (I11.GT.0) CALL DISMOI('F','PROF_CHNO',CH1,'CHAM_NO',IB,
     &                              PRCHN1,IB)
          IF (I12.GT.0) CALL DISMOI('F','PROF_CHNO',NU1,'NUME_DDL',IB,
     &                              PRCHN1,IB)

          CALL DISMOI('F','PROF_CHNO',CHOU,'CHAM_NO',IB,PRCHN2,IB)
          IF (PRCHN1.NE.PRCHN2) THEN
            CNS1 = '&&OP0195.CNS1'
            CALL CNOCNS(CHOU,'V',CNS1)
            IF (PRCHN2(1:8).EQ.CHOU(1:8)) CALL DETRSD('PROF_CHNO',
     &          PRCHN2)
            CALL CNSCNO(CNS1,PRCHN1,'NON','G',CHOU,'F',IBID)
            CALL DETRSD('CHAM_NO_S',CNS1)
          ENDIF
        ENDIF
      ENDIF


C 5.  VERIFICATION PROL_ZERO :
C ----------------------------------------------
      IF ((TYCHR(1:2).EQ.'EL').AND.(PROL0.EQ.'NAN')) THEN
        CALL CELVER(CHOU,'PAS_NAN','COOL',IRET)
        IF (IRET.NE.0) CALL U2MESK('A','CALCULEL4_1',1,CHOU)
      ENDIF


C 6.  SI INFO:2    ON IMPRIME LE CHAMP RESULTAT :
C ----------------------------------------------
      IF (NIV.EQ.2) CALL IMPRSD('CHAMP',CHOU,IFM,
     &                      'CHAMP RESULTAT DE LA COMMANDE CREA_CHAMP :'
     &                          )


C 7.  AJOUT DU TITRE :
C -----------------------------------------------------
      CALL TITRE()

C
      CALL JEDEMA()

      END
