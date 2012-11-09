      SUBROUTINE NMVGME(MODELE,LIGREL,CARELE,CHARGE,ICHA,INSTAN,
     &                  RESUFV,DEPMOI,DEPDEL,VITES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE FLEJOU J-L.FLEJOU
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*(*) MODELE,CARELE,RESUFV(1),LIGREL,CHARGE
      CHARACTER*(*) DEPMOI,DEPDEL,VITES
      REAL*8 INSTAN
      INTEGER ICHA
C ----------------------------------------------------------------------
C   CALCUL DU SECOND MEMBRE ELEMENTAIRE CORRESPONDANT A EVOL_CHAR
C   POUR LA CHARGE CHARGE(ICHA)
C   SI IL N'Y A PAS DE EVOL_CHAR DANS CHARGE(ICHA):
C                             RESUFV N'EST PAS CALCULE

C IN  MODELE      : NOM DU MODELE
C IN  LIGREL      : (SOUS)-LIGREL DU MODELE
C IN  CARELE      : NOM DU CARA_ELEM
C IN  CHARGE      : LISTE DES CHARGES
C IN  ICHA        : NUMERO DE LA CHARGE
C IN  INSTAN      : INSTANT DE LA DETERMINATION
C IN/JXOUT RESUFV : RESUELEM CORRESPONDANT AU CALCUL DE EVOL_CHAR
C                       RESULTATS POSSIBLE
C                            1 - VITESSE

      REAL*8 VALR

      LOGICAL EXIGEO,EXICAR
      INTEGER IBID,IER,JCHAR,JFNOE,NBCHAM
      INTEGER VALI
      CHARACTER*8 FNOCAL,K8BID
      CHARACTER*16 TYSD,OPTION
      CHARACTER*19 CHFNOE
      CHARACTER*24 CHGEOM,NOM24,CHCARA(18)
      CHARACTER*24 VALK

      CHARACTER*8  LPAIN(7),PAOUT
      CHARACTER*19 LCHIN(7)

      CHARACTER*8   NOMA1,NOMA2,MADEF
      CHARACTER*19  RESU,NUAGE1,NUAGE2,METHOD,RESU1
      INTEGER       NBEQUA,KVALE,NBNO,DIME,NX

      INTEGER NBLIC
      CHARACTER*8 LICMP(3)
      DATA LICMP/'DX','DY','DZ'/

      CALL JEMARQ()
      CHFNOE = '&&NMVGME.FNOE_CALC'

C     - 1. DETERMINATION DU CHAMP A L'INSTANT T
C     -----------------------------------------
      CALL JEVEUO(CHARGE,'L',JCHAR)

      NOM24 = ZK24(JCHAR+ICHA-1) (1:8)//'.CHME.EVOL.CHAR'
      CALL JEEXIN(NOM24,IER)
      IF (IER.EQ.0) GOTO 10

C -----------------------------------------------------
      CALL JEVEUO(NOM24,'L',JFNOE)
      FNOCAL = ZK8(JFNOE)

      CALL GETTCO(FNOCAL,TYSD)

      IF (TYSD.NE.'EVOL_CHAR') THEN
        CALL U2MESK('F','ALGORITH7_15',1,FNOCAL)
      ENDIF

C     ----------------------------------
      CALL DISMOI('F','NB_CHAMP_MAX',FNOCAL,'RESULTAT',NBCHAM,
     &            K8BID,IER)

      IF ( NBCHAM .LE. 0 ) THEN
        CALL U2MESK('F','ALGORITH7_16',1,FNOCAL)
      END IF


C 1 - VITESSE
C     OPTION CHAR_MECA_SR1D1D
C     -----------------------
      OPTION=' '
      CALL RSINCH(FNOCAL,'VITE_VENT','INST',INSTAN,CHFNOE,
     &            'EXCLU','EXCLU',0,'V',IER)
      IF ( IER.LE.2 ) THEN
        OPTION = 'CHAR_MECA_SR1D1D'
        GOTO 110
      ELSEIF (IER.EQ.11 .OR. IER.EQ.12 .OR. IER.EQ.20 ) THEN
        VALK = FNOCAL
        VALR = INSTAN
        VALI = IER
        CALL U2MESG('F', 'ALGORITH13_68',1,VALK,1,VALI,1,VALR)
      ENDIF

      GOTO 10
C     CALCUL DES OPTIONS : CHAR_MECA_SR1D1D
C     -------------------------------------
110   CONTINUE
      IF ( OPTION .EQ. 'CHAR_MECA_SR1D1D' ) THEN
        CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
        CALL MECARA(CARELE,EXICAR,CHCARA)

C       NOM DE CONCEPT
        RESU   = '&&MNVGME.RESU_PROJE'

C       VERIF AVANT DE COMMENCER
        CALL JELIRA(CHFNOE//'.VALE','LONMAX',NBEQUA,K8BID)
        CALL DISMOI('F','NOM_MAILLA',CHFNOE,'CHAMP',IBID,NOMA1,IER)

C       -- DETERMINATION DE LA DIMENSION DE L'ESPACE :
        CALL DISMOI('F','Z_CST' ,NOMA1,'MAILLAGE',IBID,K8BID,IER)
        NX=3
        IF (K8BID.EQ.'OUI') NX=2

        CALL JEVEUO(NOMA1//'.DIME','E',KVALE)
        NBNO = ZI(KVALE)
        DIME = ZI(KVALE+5)
        IF ( NBNO * DIME .NE. NBEQUA ) THEN
           CALL U2MESS('F','ALGORITH8_77')
        ENDIF

C       NOM DE CONCEPT MAILLAGE GEOMETRIE DEFORMEE UNIQUE
C       FABRIQUE A PARTIR DU MAILLAGE SOUS JACENT AU MODELE
        MADEF = '.0000000'
        CALL GCNCON('.',MADEF)
        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA2,IER)
        CALL COPISD(' ','V',NOMA2,MADEF)
        CALL VTGPLD('CUMU',NOMA2//'.COORDO' ,1.D0  ,DEPMOI,'V'   ,
     &              MADEF//'.COORDO1')
        CALL VTGPLD('CUMU',MADEF//'.COORDO1',1.D0  ,DEPDEL,'V'   ,
     &              MADEF//'.COORDO')
        CALL DETRSD('CHAMP_GD',MADEF//'.COORDO1')

C       CREATION D'UN CHAM_NO POUR SERVIR DE MODELE
C         ==> CHAMP DE VITESSES AVEC MISE A ZERO
C         ==> MAILLAGE DEFORME DE LA STRUCTURE
        NBLIC = 3
        CALL CNOCRE(MADEF,'DEPL_R',0,IBID,NBLIC,LICMP,IBID,'V',' ',RESU)

        NUAGE1 = '&&NUAGE1'
        NUAGE2 = '&&NUAGE2'
        CALL CHPNUA ( NX,CHFNOE,' ',NUAGE1 )
        CALL CHPNUA ( NX,RESU,' ',NUAGE2 )

C       PROJECTION AVEC LA METHODE NUAGE
        METHOD = 'NUAGE_DEG_1'
        CALL PRONUA ( METHOD , NUAGE1 , NUAGE2 )
        CALL NUACHP ( NUAGE2 ,' ', RESU )
        CALL DETRSD ( 'NUAGE', NUAGE1 )
        CALL DETRSD ( 'NUAGE', NUAGE2 )

C       LA PROJECTION EST FAITE SUR LE MAILLAGE DEFORME
C       ON REMET DANS RESU LE NOM DU MAILLAGE INITIAL
        CALL JEVEUO(RESU//'.REFE','E',KVALE)
        ZK24(KVALE) = NOMA2
CCC        CALL DETRSD('MAILLAGE',MADEF)
        CALL JEDETC('V',MADEF,1)

C       CONSTRUCTION DU CHAMP DE VITESSE RELATIVE
        NOM24 = VITES(1:19)//'.VALE'
        CALL JEEXIN(NOM24,IER)
        IF ( IER .GT. 0 ) THEN
          RESU1 = '.0000000'
          CALL GCNCON('.',RESU1)
          CALL COPISD('CHAMP_GD','V',RESU,RESU1)
          CALL BARYCH(RESU1,VITES(1:19),1.0D0,-1.0D0,RESU,'V')
          CALL DETRSD('CHAMP_GD',RESU1)
        ENDIF

        LPAIN(1) = 'PGEOMER'
        LCHIN(1) =  CHGEOM
        LPAIN(2) = 'PVITER'
        LCHIN(2) =  RESU
        LPAIN(3) = 'PVENTCX'
        LCHIN(3) =  CHCARA(14)
        LPAIN(4) = 'PDEPLMR'
        LCHIN(4) =  DEPMOI
        LPAIN(5) = 'PDEPLPR'
        LCHIN(5) =  DEPDEL
        LPAIN(6) = 'PCAGNPO'
        LCHIN(6) =  CHCARA(6)
        LPAIN(7) = 'PCAORIE'
        LCHIN(7) =  CHCARA(1)

        PAOUT    = 'PVECTUR'

        CALL CORICH('E',RESUFV(1),ICHA,IBID)
      CALL CALCUL('S',OPTION,LIGREL,7,LCHIN,LPAIN,1,RESUFV(1),PAOUT,'V',
     &                 'OUI')
      ENDIF

   10 CONTINUE
      CALL JEDEMA()
      END
