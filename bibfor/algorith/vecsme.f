      SUBROUTINE VECSME(MODELZ,CARELZ,MATE,COMPLZ,NUMEDD,CNCHTP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2006   AUTEUR CIBHHPD L.SALMONA 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) MODELZ,CARELZ,COMPLZ,MATE,CNCHTP
      CHARACTER*14 COMPLU
      CHARACTER*24 MODELE,CARELE,NUMEDD

C ----------------------------------------------------------------------
C     CALCUL DU  VECTEUR ASSEMBLE DU CHARGEMENT SECHAGE

C IN  MODELZ  : NOM DU MODELE
C IN  CARELZ  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : MATERIAU
C IN  COMPLU  : SD VARI_COM
C IN  NUMEDD  : NOM DE LA NUMEROTATION
C VAR CNCHTP  : VECTEUR ASSEMBLE DU CHARGEMENT SECHAGE

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*1 TYPRES
      CHARACTER*8 VECEL,LPAIN(15),LPAOUT(1)
      CHARACTER*8 K8BID,NOMA,REPK,NOMGD,NEWNOM
      CHARACTER*16 OPTION
      CHARACTER*24 CHGEOM,CHMATE,CHCARA(15),CHTIME,CHTREF
      CHARACTER*19 CHVREF
      CHARACTER*24 LIGRMO,LCHIN(15),LCHOUT(1)
      CHARACTER*24 VECHSP,CNCHSP,TEMPLU,VRCPLU,SECPLU
      LOGICAL EXIGEO,EXICAR,EXITRF,EXISRF,EXISEC
      LOGICAL EXITEM
      COMPLEX*16 CBID
      DATA CNCHSP/' '/
      DATA TYPRES/'R'/


      CALL JEMARQ()
      NEWNOM = '.0000000'
      MODELE = MODELZ
      CARELE = CARELZ
      COMPLU = COMPLZ
      CHVREF='&&VECSME.VREF'


C    EXTRACTION DES VARIABLES DE COMMANDES
      CALL NMVCEX('INST',COMPLU,CHTIME)
      CALL NMVCEX('TEMP',COMPLU,TEMPLU)
      CALL NMVCEX('TOUT',COMPLU,VRCPLU)

      VECEL = '&&VECSME'
      CALL DETRSD('VECT_ELEM',VECEL)
      VECHSP = VECEL//'.LISTE_RESU'
      CALL MEMARE('V',VECEL,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
      CALL WKVECT(VECHSP,'V V K24',1,JLVE)


      LIGRMO = MODELE(1:8)//'.MODELE'

      CALL MEGEOM(MODELE(1:8),SECPLU,EXIGEO,CHGEOM)
      CALL DISMOI('F','ELAS_F_TEMP',MATE,'CHAM_MATER',IBID,REPK,IERD)
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)
      NOMA = CHGEOM(1:8)
C    TEMPERATURE DE REFERENCE      
      CALL METREF(MATE,NOMA,EXITRF,CHTREF)

      IF (REPK.EQ.'OUI') THEN
        IF (.NOT.EXITRF) THEN
          CALL UTMESS('A','VECSME',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                ' IL N''Y A PAS DE TEMPERATURE DE REFERENCE'//
     &                ' ON PRENDRA DONC LA VALEUR 0')
        END IF
      END IF

C    VARIABLE DE COMMANDE DE REFERENCE      
      CALL VRCREF(MODELE(1:8),MATE(1:8),CARELE(1:8),CHVREF)

      LPAIN(1) = 'PTEREF'
      LCHIN(1) = CHTREF
      LPAIN(2) = 'PGEOMER'
      LCHIN(2) = CHGEOM
C     -- ON TESTE LA NATURE DU CHAMP DE TEMPERATURE :
      CALL DISMOI('F','NOM_GD',TEMPLU,'CHAMP',IBID,NOMGD,IERD)
      IF (NOMGD.EQ.'TEMP_R') THEN
        LPAIN(3) = 'PTEMPER'
      ELSE IF (NOMGD.EQ.'TEMP_F') THEN
        LPAIN(3) = 'PTEMPEF'
      ELSE
        CALL UTMESS('F','VECSME','GRANDEUR INCONNUE.')
      END IF
      LCHIN(3) = TEMPLU
      LPAIN(4) = 'PTEMPSR'
      LCHIN(4) = CHTIME
      LPAIN(5) = 'PMATERC'
      LCHIN(5) = MATE
      LPAIN(6) = 'PCACOQU'
      LCHIN(6) = CHCARA(7)
      LPAIN(7) = 'PCAGNPO'
      LCHIN(7) = CHCARA(6)
      LPAIN(8) = 'PCADISM'
      LCHIN(8) = CHCARA(3)
      LPAIN(9) = 'PCAORIE'
      LCHIN(9) = CHCARA(1)
      LPAIN(10) = 'PCAGNBA'
      LCHIN(10) = CHCARA(11)
      LPAIN(11) = 'PCAARPO'
      LCHIN(11) = CHCARA(9)
      LPAIN(12) = 'PCAMASS'
      LCHIN(12) = CHCARA(12)
      LPAIN(13) = 'PVARCPR'
      LCHIN(13) = VRCPLU
      LPAIN(15) = 'PVARCRR'
      LCHIN(15) = CHVREF      
      OPTION = 'CHAR_MECA_SECH_R'

      LPAOUT(1) = 'PVECTUR'
      LCHOUT(1) = '&&VECSME.???????'
      CALL GCNCO2(NEWNOM)
      LCHOUT(1) (10:16) = NEWNOM(2:8)
      CALL CORICH('E',LCHOUT(1),-1,IBID)
      CALL CALCUL('S',OPTION,LIGRMO,15,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
      ZK24(JLVE) = LCHOUT(1)
      CALL JEECRA(VECHSP,'LONUTI',1,K8BID)

      CALL ASASVE(VECHSP,NUMEDD,TYPRES,CNCHSP)

C ----- SOMMATION DES CHAMPS DE DEFORMATION THERMIQUE


      EXITEM = TEMPLU .NE. ' '

      CALL JEEXIN(CNCHTP,IRET)
      IF (IRET.EQ.0) THEN
        CNCHTP = CNCHSP
      ELSE IF (.NOT.EXITEM) THEN
        CNCHTP = CNCHSP
      ELSE
        CALL JEVEUO(CNCHTP,'L',JTP)
        CALL JELIRA(ZK24(JTP) (1:19)//'.VALE','LONMAX',LONCH,K8BID)
        CALL JEVEUO(ZK24(JTP) (1:19)//'.VALE','E',JCHTP)
        CALL JEVEUO(CNCHSP,'L',JSP)
        CALL JEVEUO(ZK24(JSP) (1:19)//'.VALE','E',JCHSP)
        DO 10 I = 1,LONCH
          ZR(JCHTP+I-1) = ZR(JCHTP+I-1) + ZR(JCHSP+I-1)
   10   CONTINUE
      END IF

   20 CONTINUE

      CALL JEDEMA()
      END
