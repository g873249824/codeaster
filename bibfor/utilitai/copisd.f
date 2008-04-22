      SUBROUTINE COPISD(TYPESD,BASE,SD1,SD2)
      IMPLICIT NONE
      CHARACTER*(*) TYPESD,BASE,SD1,SD2
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 22/04/2008   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET

C   BUT:
C   DUPLIQUER UNE STRUCTURE DE DONNEES SOUS UN AUTRE NOM.
C   (SI SD2 EXISTE DEJA, ON L'ECRASE)

C     IN:
C     TYPESD  : TYPE DE LA SD A DUPPLIQUER
C               ' '(INCONNU)      'CHAMP' (OU 'CHAMP_GD')
C               'FONCTION'  (POUR FONCTIONS ET NAPPES)
C               'CORRESP_2_MAILLA'
C               'CHAM_NO_S'       'CHAM_ELEM_S'
C               'VARI_COM'        'TABLE'
C               'RESULTAT'        'NUME_DDL'
C               'MAILLAGE'        'LIGREL'
C               'MATR_ASSE_GENE'  'MATR_ASSE'
C               'PROF_CHNO'       'MATR_ELEM'
C               'VECT_ELEM'
C     BASE     : 'G' , 'V' , ... : BASE DE CREATION DE SD2
C     SD1 (K*) : NOM DE LA SD A DUPPLIQUER
C     SD2 (K*) : NOM DE LA SD A CREER

C     OUT:
C     SD2 EST CREEE ET A LE MEME CONTENU QUE SD1

C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER       IRET, IRES, I, NBTU, JLTN1, JLTN2
      CHARACTER*1   BAS2
      CHARACTER*8   K8B, MAIL1, MAIL2
      CHARACTER*14  COM1, COM2, NU1, NU2
      CHARACTER*16  TYP2SD, CORR1, CORR2
      CHARACTER*19  CH1, CH2, SDR1, K191, K192
      CHARACTER*24  O1, O2, NOMSD

C DEB-------------------------------------------------------------------

      CALL JEMARQ
      BAS2 = BASE

C ----------------------------------------------------------------------
C     SUPRESSION DE SD2 :
      CALL DETRSD(TYPESD,SD2)

C ----------------------------------------------------------------------
      IF (TYPESD.EQ.' ') THEN
C     -----------------------
C       -- TYPESD INCONNU => ON UTILISE JEDUPC => COUTEUX EN CPU
        CALL JEDUPC(' ',SD1,1,BASE,SD2,.TRUE.)

C ----------------------------------------------------------------------
      ELSE IF ((TYPESD.EQ.'CHAMP') .OR. (TYPESD.EQ.'CHAMP_GD')) THEN
C     ----------------------------------------------------------------
        CH1 = SD1
        CH2 = SD2
        CALL COPICH(BAS2,CH1,CH2)

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'VARI_COM') THEN
C     -----------------------------------
        COM1 = SD1
        COM2 = SD2

        CALL EXISD('CHAMP',COM1//'.TEMP',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.TEMP',COM2//'.TEMP')
        CALL EXISD('CHAMP',COM1//'.HYDR',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.HYDR',COM2//'.HYDR')
        CALL EXISD('CHAMP',COM1//'.SECH',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.SECH',COM2//'.SECH')
        CALL EXISD('CHAMP',COM1//'.PHAS',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.PHAS',COM2//'.PHAS')
        CALL EXISD('CHAMP',COM1//'.EPAN',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.EPAN',COM2//'.EPAN')
        CALL EXISD('CHAMP',COM1//'.INST',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.INST',COM2//'.INST')
        CALL EXISD('CHAMP',COM1//'.TOUT',IRET)
        IF (IRET.GT.0) CALL COPICH(BAS2,COM1//'.TOUT',COM2//'.TOUT')

        CALL JEDUP1(COM1//'.EXISTENCE',BAS2,COM2//'.EXISTENCE')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'FONCTION') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2

        CALL JEDUP1(K191//'.PARA',BAS2,K192//'.PARA')
        CALL JEDUP1(K191//'.PROL',BAS2,K192//'.PROL')
        CALL JEDUP1(K191//'.VALE',BAS2,K192//'.VALE')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'CORRESP_2_MAILLA') THEN
C        ---------------------------------
        CORR1 = SD1
        CORR2 = SD2
        CALL JEDUP1(CORR1//'.PJEF_NO',BAS2,CORR2//'.PJEF_NO')
        CALL JEDUP1(CORR1//'.PJEF_NU',BAS2,CORR2//'.PJEF_NU')
        CALL JEDUP1(CORR1//'.PJEF_NB',BAS2,CORR2//'.PJEF_NB')
        CALL JEDUP1(CORR1//'.PJEF_CF',BAS2,CORR2//'.PJEF_CF')
        CALL JEDUP1(CORR1//'.PJEF_M1',BAS2,CORR2//'.PJEF_M1')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'CHAM_NO_S') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.CNSD',BAS2,K192//'.CNSD')
        CALL JEDUP1(K191//'.CNSK',BAS2,K192//'.CNSK')
        CALL JEDUP1(K191//'.CNSC',BAS2,K192//'.CNSC')
        CALL JEDUP1(K191//'.CNSL',BAS2,K192//'.CNSL')
        CALL JEDUP1(K191//'.CNSV',BAS2,K192//'.CNSV')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'CHAM_ELEM_S') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.CESD',BAS2,K192//'.CESD')
        CALL JEDUP1(K191//'.CESK',BAS2,K192//'.CESK')
        CALL JEDUP1(K191//'.CESC',BAS2,K192//'.CESC')
        CALL JEDUP1(K191//'.CESL',BAS2,K192//'.CESL')
        CALL JEDUP1(K191//'.CESV',BAS2,K192//'.CESV')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'PROF_CHNO') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.DEEQ',BAS2,K192//'.DEEQ')
        CALL JEDUP1(K191//'.NUEQ',BAS2,K192//'.NUEQ')
        CALL JEDUP1(K191//'.PRNO',BAS2,K192//'.PRNO')
        CALL JEDUP1(K191//'.LILI',BAS2,K192//'.LILI')
        CALL JEDUP1(K191//'.LPRN',BAS2,K192//'.LPRN')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'NUME_EQUA') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL COPIS2('PROF_CHNO',BAS2,K191,K192)
        CALL JEDUP1(K191//'.DELG',BAS2,K192//'.DELG')
        CALL JEDUP1(K191//'.NEQU',BAS2,K192//'.NEQU')
        CALL JEDUP1(K191//'.REFN',BAS2,K192//'.REFN')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'STOCKAGE') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.SCBL',BAS2,K192//'.SCBL')
        CALL JEDUP1(K191//'.SCDI',BAS2,K192//'.SCDI')
        CALL JEDUP1(K191//'.SCDE',BAS2,K192//'.SCDE')
        CALL JEDUP1(K191//'.SCHC',BAS2,K192//'.SCHC')
        CALL JEDUP1(K191//'.SCIB',BAS2,K192//'.SCIB')

        CALL JEDUP1(K191//'.SMDI',BAS2,K192//'.SMDI')
        CALL JEDUP1(K191//'.SMDE',BAS2,K192//'.SMDE')
        CALL JEDUP1(K191//'.SMHC',BAS2,K192//'.SMHC')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'NUME_DDL') THEN
C     -----------------------------------
        NU1 = SD1
        NU2 = SD2
        CALL COPIS2('NUME_EQUA',BAS2,NU1//'.NUME',NU2//'.NUME')
        CALL COPIS2('STOCKAGE',BAS2,NU1//'.SLCS',NU2//'.SLCS')
        CALL COPIS2('STOCKAGE',BAS2,NU1//'.SMOS',NU2//'.SMOS')
        CALL JEDUP1(NU1//'.NSLV',BAS2,NU2//'.NSLV')

C --------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'MATR_ASSE_GENE' .OR.
     &         TYPESD.EQ.'MATR_ASSE') THEN
C     ---------------------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.CCID',BAS2,K192//'.CCID')
        CALL JEDUP1(K191//'.CCJJ',BAS2,K192//'.CCJJ')
        CALL JEDUP1(K191//'.CCLL',BAS2,K192//'.CCLL')
        CALL JEDUP1(K191//'.CCVA',BAS2,K192//'.CCVA')
        CALL JEDUP1(K191//'.CONL',BAS2,K192//'.CONL')
        CALL JEDUP1(K191//'.DESC',BAS2,K192//'.DESC')
        CALL JEDUP1(K191//'.DIGS',BAS2,K192//'.DIGS')
        CALL JEDUP1(K191//'.LIME',BAS2,K192//'.LIME')
        CALL JEDUP1(K191//'.REFA',BAS2,K192//'.REFA')
        CALL JEDUP1(K191//'.UALF',BAS2,K192//'.UALF')
        CALL JEDUP1(K191//'.VALF',BAS2,K192//'.VALF')
        CALL JEDUP1(K191//'.WALF',BAS2,K192//'.WALF')
        CALL JEDUP1(K191//'.VALM',BAS2,K192//'.VALM')

C --------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'TABLE') THEN
C     -----------------------------------
        CALL EXISD(TYPESD,SD1,IRET)
        IF (IRET.EQ.0) THEN
          SDR1 = SD1
          CALL U2MESK('F','UTILITAI_40',1,SDR1)
        END IF

        CALL TBCOPI(BASE,SD1,SD2)

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'RESULTAT') THEN
C     -----------------------------------
        CALL EXISD(TYPESD,SD1,IRET)
        IF (IRET.EQ.0) THEN
          SDR1 = SD1
          CALL U2MESK('F','UTILITAI_40',1,SDR1)
        END IF

        CALL RSCOPI(BASE,SD1,SD2)

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'LIGREL') THEN
C     -----------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.LGNS',BAS2,K192//'.LGNS')
        CALL JEDUP1(K191//'.LIEL',BAS2,K192//'.LIEL')
        CALL JEDUP1(K191//'.NEMA',BAS2,K192//'.NEMA')
        CALL JEDUP1(K191//'.LGRF',BAS2,K192//'.LGRF')
        CALL JEDUP1(K191//'.NBNO',BAS2,K192//'.NBNO')
        CALL JEDUP1(K191//'.PRNM',BAS2,K192//'.PRNM')
        CALL JEDUP1(K191//'.PRNS',BAS2,K192//'.PRNS')
        CALL JEDUP1(K191//'.REPA',BAS2,K192//'.REPE')
        CALL JEDUP1(K191//'.SSSA',BAS2,K192//'.SSSA')

C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'MAILLAGE') THEN
C     -----------------------------------
        MAIL1 = SD1
        MAIL2 = SD2
        CALL COPICH(BAS2,MAIL1//'.COORDO',MAIL2//'.COORDO')
        CALL COPICH(BAS2,MAIL1//'.ABS_CURV',MAIL2//'.ABS_CURV')
C
        CALL JEDUP1(MAIL1//'.DIME',BAS2,MAIL2//'.DIME')
        CALL JEDUP1(MAIL1//'.NOMNOE',BAS2,MAIL2//'.NOMNOE')
        CALL JEDUP1(MAIL1//'.GROUPENO',BAS2,MAIL2//'.GROUPENO')
        CALL JEDUP1(MAIL1//'.NOMMAI',BAS2,MAIL2//'.NOMMAI')
        CALL JEDUP1(MAIL1//'.TYPMAIL',BAS2,MAIL2//'.TYPMAIL')
        CALL JEDUP1(MAIL1//'.CONNEX',BAS2,MAIL2//'.CONNEX')
        CALL JEDUP1(MAIL1//'.GROUPEMA',BAS2,MAIL2//'.GROUPEMA')
        CALL JEDUP1(MAIL1//'.NOMACR',BAS2,MAIL2//'.NOMACR')
        CALL JEDUP1(MAIL1//'.PARA_R',BAS2,MAIL2//'.PARA_R')
        CALL JEDUP1(MAIL1//'.SUPMAIL',BAS2,MAIL2//'.SUPMAIL')
        CALL JEDUP1(MAIL1//'.TYPL',BAS2,MAIL2//'.TYPL')
        CALL JEDUP1(MAIL1//'.TITR',BAS2,MAIL2//'.TITR')
C
        CALL JEEXIN ( MAIL1//'           .LTNT', IRET )
        IF ( IRET .NE. 0 ) THEN
          CALL JEDUP1(MAIL1//'           .LTNS',BAS2,
     &                MAIL2//'           .LTNS')
          CALL JEDUP1(MAIL1//'           .LTNT',BAS2,
     &                MAIL2//'           .LTNT')
          CALL JELIRA ( MAIL1//'           .LTNT', 'LONUTI', NBTU, K8B)
          CALL JEVEUO ( MAIL1//'           .LTNS', 'L', JLTN1 )
          CALL JEVEUO ( MAIL2//'           .LTNS', 'E', JLTN2 )
          K192(1:8) = MAIL2
          DO 10 I = 1 , NBTU
             K191 = ZK24(JLTN1+I-1)
             K192(9:19) = K191(9:19)
             CALL EXISD ( 'TABLE', K191, IRET )
             IF ( IRET .NE. 0 ) THEN
                CALL TBCOPI ( BAS2, K191, K192 )
             ELSE
                CALL U2MESK('F','UTILITAI_41',1,K191)
             ENDIF
             ZK24(JLTN2+I-1) = K192
 10       CONTINUE
        ENDIF

C       -- OBJETS QUE JE NE CONNAIS PAS !! (JP) :
        CALL JEDUP1(MAIL1//'           .FORM',BAS2,
     &              MAIL2//'           .FORM')
        CALL JEDUP1(MAIL1//'.ADAPTATION',BAS2,MAIL2//'.ADAPTATION')

        CALL JEDUP1(MAIL1//'           .TITR',BAS2,
     &              MAIL2//'           .TITR')
C ----------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'MATR_ELEM' .OR. TYPESD.EQ.'VECT_ELEM') THEN
C     ---------------------------------------------------------------
        K191 = SD1
        K192 = SD2
        CALL JEDUP1(K191//'.RELR',BAS2,K192//'.RELR')
        CALL JEEXIN(K191//'.RERR',IRET)
        IF (IRET.NE.0)THEN
           CALL JEDUP1(K191//'.RERR',BAS2,K192//'.RERR')
        ENDIF
        IF(TYPESD.EQ.'VECT_ELEM')THEN
           CALL JEEXIN(K191//'.RELC',IRET)
           IF(IRET.NE.0)THEN
              CALL JEDUP1(K191//'.RELC',BAS2,K192//'.RELC')
           ENDIF
        ENDIF
        CALL JEEXIN(K191//'.TITR',IRET)
        IF(IRET.NE.0)THEN
           CALL JEDUP1(K191//'.TITR',BAS2,K192//'.TITR')
        ENDIF

C ----------------------------------------------------------------------
      ELSE
        TYP2SD = TYPESD
        CALL U2MESK('F','UTILITAI_42',1,TYP2SD)
      END IF

      CALL JEDEMA
      END
