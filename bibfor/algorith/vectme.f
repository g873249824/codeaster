      SUBROUTINE VECTME(MODELZ,CARELZ,MATE,COMPLZ,VECELZ)
C MODIF ALGORITH  DATE 28/08/2006   AUTEUR CIBHHPD L.SALMONA 
C ======================================================================
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) MODELZ,CARELZ,COMPLZ,VECELZ,MATE
      CHARACTER*24 MODELE,CARELE
      CHARACTER*14 COMPLU

C ----------------------------------------------------------------------
C     CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS THERMIQUES

C IN  MODELZ  : NOM DU MODELE
C IN  CARELZ  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : MATERIAU
C IN  COMPLU  : SD VARI_COM A L'INSTANT T+
C OUT/JXOUT  VECELZ  : VECT_ELEM RESULTAT.

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
      CHARACTER*8 VECELE,LPAIN(18),PAOUT
      CHARACTER*8 K8B,NOMA,REPK,NOMGD,NEWNOM
      CHARACTER*16 OPTION
      CHARACTER*24 CHGEOM,CHMATE,CHCARA(15),CHTIME,CHTREF,PHAPLU
      CHARACTER*19 RESUEL
      CHARACTER*24 LIGRMO,LCHIN(18),TEMPLU,VRCPLU,SECPLU
      CHARACTER*19 CHVREF
      LOGICAL EXIGEO,EXICAR,EXITRF
      LOGICAL EXITEM
      INTEGER IRET
      COMPLEX*16 CBID

      CALL JEMARQ()
      NEWNOM = '.0000000'
      MODELE = MODELZ
      CARELE = CARELZ
      COMPLU = COMPLZ
      CHVREF='&&VECTME.VREF'

C     -- EXTRACTION DES VARIABLES DE COMMANDE
      CALL NMVCEX('TEMP',COMPLU,TEMPLU)
      CALL NMVCEX('TOUT',COMPLU,VRCPLU)
      CALL NMVCEX('PHAS',COMPLU,PHAPLU)
      CALL NMVCEX('INST',COMPLU,CHTIME)

C     -- EXISTENCE D'UN VRAI CHAMP DE TEMPERATURE
      EXITEM = TEMPLU .NE. ' '
      IF (EXITEM) CALL NMVCDE('TEMP',COMPLU,EXITEM)

C    VARIABLE DE COMMANDE DE REFERENCE      
      CALL VRCREF(MODELE(1:8),MATE(1:8),CARELE(1:8),CHVREF)

      VECELE = '&&VEMTPP'
      RESUEL = '&&VECTME.???????'


C     -- ALLOCATION DU VECT_ELEM RESULTAT :
C     -------------------------------------
      CALL DETRSD('VECT_ELEM',VECELE)
      CALL MEMARE('V',VECELE,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
      CALL WKVECT(VECELE//'.LISTE_RESU','V V K24',1,JLVE)
      CALL JEECRA(VECELE//'.LISTE_RESU','LONUTI',0,K8B)
      IF (.NOT.EXITEM) GO TO 10



      LIGRMO = MODELE(1:8)//'.MODELE'

      CALL MEGEOM(MODELE(1:8),TEMPLU,EXIGEO,CHGEOM)
      CALL DISMOI('F','ELAS_F_TEMP',MATE,'CHAM_MATER',IBID,REPK,IERD)
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)
      NOMA = CHGEOM(1:8)
      CALL METREF(MATE,NOMA,EXITRF,CHTREF)

      IF ((REPK.EQ.'OUI') .AND. (.NOT.EXITRF)) THEN
        CALL UTMESS('A','VECTME','LE MATERIAU DEPEND DE LA TEMPERATURE'
     &              //' IL N''Y A PAS DE TEMPERATURE DE REFERENCE'//
     &              ' ON PRENDRA DONC LA VALEUR 0')
      END IF

      LCHIN(1) = CHTREF
      PAOUT = 'PVECTUR'
      LPAIN(2) = 'PGEOMER'
      LCHIN(2) = CHGEOM

C     -- ON TESTE LA NATURE DU CHAMP DE TEMPERATURE :
      CALL DISMOI('F','NOM_GD',TEMPLU,'CHAMP',IBID,NOMGD,IERD)
      IF (NOMGD.EQ.'TEMP_R') THEN
        LPAIN(3) = 'PTEMPER'
      ELSE IF (NOMGD.EQ.'TEMP_F') THEN
        LPAIN(3) = 'PTEMPEF'
      ELSE
        CALL UTMESS('F','VECTME','GRANDEUR INCONNUE.')
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
      LPAIN(14) = 'PVARCRR'
      LCHIN(14) = CHVREF
      LPAIN(15) = 'PCAGEPO'
      LCHIN(15) = CHCARA(5)
      LPAIN(16) = 'PPHASRR'
      LCHIN(16) = PHAPLU
      LPAIN(17) = 'PNBSP_I'
      LCHIN(17) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(18) = 'PFIBRES'
      LCHIN(18) = CHCARA(1) (1:8)//'.CAFIBR'
      OPTION = 'CHAR_MECA_TEMP_R'
      LPAIN(1) = 'PTEREF'

      CALL GCNCO2(NEWNOM)
      RESUEL(10:16) = NEWNOM(2:8)
      CALL CORICH('E',RESUEL,-1,IBID)
      CALL CALCUL('S',OPTION,LIGRMO,18,LCHIN,LPAIN,1,RESUEL,PAOUT,'V')
      ZK24(JLVE) = RESUEL
      CALL JEECRA(VECELE//'.LISTE_RESU','LONUTI',1,K8B)

   10 CONTINUE

      VECELZ = VECELE//'.LISTE_RESU'

      CALL JEDEMA()
      END
