      SUBROUTINE NMVCPR(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &                  COMPOR, VALMOI, COMPLU, CNVCPR)

C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE MABBAS M.ABBAS

      IMPLICIT NONE
      CHARACTER*8   MODELE
      CHARACTER*19  CNVCPR
      CHARACTER*24  NUMEDD, MATE, COMREF, CARELE, COMPOR, VALMOI
      CHARACTER*24  COMPLU

C ----------------------------------------------------------------------
C         SECOND MEMBRE : VARIATION DES VARIABLES DE COMMANDE
C ----------------------------------------------------------------------
C
C IN       MODELE K8  MODELE
C IN       NUMEDD K24 NUME_DDL
C IN       MATE   K24 CHAMP MATERIAU
C IN       CARELE K24 CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24 VARI_COM DE REFERENCE
C IN       COMPOR K24 COMPORTEMENT
C IN       VALMOI K24 ETAT EN T-
C IN       COMPLU K24 VARI_COM EN T+ (TEMPERATURE POUR LES POUTRES)
C IN/JXOUT CNVCPR K19 VARIATION F_INT PAR RAPPORT AUX VARI_COM
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      LOGICAL      EXITEM, EXIHYD, EXISEC, EXIEPA, EXIPHA
      LOGICAL      EXIGEO, EXICAR, LBID,EXIPH1,EXIPH2
      INTEGER      NBRENV, NBR, IRET, IBID
      INTEGER      JVCP, JVCM
      REAL*8       X(2)
      CHARACTER*6  MASQUE
      CHARACTER*8  VECEL(2), LPAIN(23), LPAOUT(1), PARTPM, PARTPP, NOMGD
      CHARACTER*8  K8BID
      CHARACTER*16 OPTION
      CHARACTER*24 DEPMOI, SIGMOI, VARMOI, COMMOI, CHTREF, CHVREF
      CHARACTER*24 TEMPLU, VRCPLU, PHAPLU, INSPLU
      CHARACTER*24 TEMMOI, VRCMOI, INSMOI
      CHARACTER*24 LIGRMO, CHGEOM, CHCARA(16), LCHIN(23), LCHOUT(1)
      CHARACTER*24 K24BID

      DATA  VECEL /'&&VEVCOM','&&VEVCOP'/
C ----------------------------------------------------------------------


      CALL JEMARQ()
      CALL DESAGG (VALMOI, DEPMOI, SIGMOI, VARMOI, COMMOI,
     &                     K24BID, K24BID, K24BID, K24BID)

      CHVREF='&&NMVCPR.VREF'
C -- PREPARATION DES VECT_ELEM

      NBRENV = 5
      MASQUE = '.VEXXX'
      CALL JEEXIN(VECEL(1) // '.LISTE_RESU',IRET)
      IF (IRET.EQ.0) THEN
        CALL MEMARE('V',VECEL(1),MODELE,MATE,CARELE,'CHAR_MECA')
        CALL MEMARE('V',VECEL(2),MODELE,MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(VECEL(1) // '.LISTE_RESU','V V K24',NBRENV,JVCP)
        CALL WKVECT(VECEL(2) // '.LISTE_RESU','V V K24',NBRENV,JVCM)
      ELSE
        CALL JEVEUO(VECEL(1) // '.LISTE_RESU','E',JVCP)
        CALL JEVEUO(VECEL(2) // '.LISTE_RESU','E',JVCM)
      END IF


C -- EXTRACTION DES VARIABLES DE COMMANDE

      CALL NMVCEX('TEMP',COMREF,CHTREF)
      CALL NMVCEX('TOUT',COMREF,CHVREF)

      CALL NMVCEX('TEMP',COMPLU,TEMPLU)
      CALL NMVCEX('TOUT',COMPLU,VRCPLU)
      CALL NMVCEX('INST',COMPLU,INSPLU)

      CALL NMVCEX('TEMP',COMMOI,TEMMOI)
      CALL NMVCEX('TOUT',COMMOI,VRCMOI)
      CALL NMVCEX('INST',COMMOI,INSMOI)

C    VARIABLES DE COMMANDE PRESENTES
      EXITEM = TEMPLU .NE. ' '
      IF (EXITEM) CALL NMVCDE('TEMP',COMPLU,EXITEM)
      CALL NMVCD2('HYDR',MATE,EXIHYD,LBID)
      CALL NMVCD2('SECH',MATE,EXISEC,LBID)
      CALL NMVCD2('EPSA',MATE,EXIEPA,LBID)
      CALL NMVCD2('META_ZIRC',MATE,EXIPH1,LBID)
      CALL NMVCD2('META_ACIER',MATE,EXIPH2,LBID)
      EXIPHA = EXITEM .AND. (EXIPH1.OR.EXIPH2)


C -- LECTURE DES CHAMPS COMMUNS AUX OPTIONS

      LIGRMO = MODELE //'.MODELE'
      CALL MEGEOM(MODELE,' ' , EXIGEO, CHGEOM)
      CALL MECARA(CARELE(1:8), EXICAR, CHCARA)

      LPAIN(1)  = 'PTEREF'
      LCHIN(1)  =  CHTREF
      LPAIN(2)  = 'PVARCRR'
      LCHIN(2)  =  CHVREF
      LPAIN(3)  = 'PGEOMER'
      LCHIN(3)  =  CHGEOM
      LPAIN(4)  = 'PMATERC'
      LCHIN(4)  =  MATE
      LPAIN(5)  = 'PCACOQU'
      LCHIN(5)  =  CHCARA(7)
      LPAIN(6)  = 'PCAGNPO'
      LCHIN(6)  =  CHCARA(6)
      LPAIN(7)  = 'PCADISM'
      LCHIN(7)  =  CHCARA(3)
      LPAIN(8)  = 'PCAORIE'
      LCHIN(8)  =  CHCARA(1)
      LPAIN(9)  = 'PCAGNBA'
      LCHIN(9)  =  CHCARA(11)
      LPAIN(10)  = 'PCAARPO'
      LCHIN(10)  =  CHCARA(9)
      LPAIN(11) = 'PCAMASS'
      LCHIN(11) =  CHCARA(12)
      LPAIN(12) = 'PCAGEPO'
      LCHIN(12) =  CHCARA(5)
      LPAIN(13) = 'PCONTMR'
      LCHIN(13) =  SIGMOI
      LPAIN(14) = 'PVARIPR'
      LCHIN(14) =  VARMOI
      LPAIN(15) = 'PCOMPOR'
      LCHIN(15) =  COMPOR


C -- ON TESTE LA NATURE DU CHAMP DE TEMPERATURE (FONCTION OU CHAMP)

      CALL DISMOI('F','NOM_GD',TEMMOI,'CHAMP',IBID,NOMGD,IRET)
      IF (NOMGD.EQ.'TEMP_R') THEN
         PARTPM  = 'PTEMPER'
      ELSE IF (NOMGD.EQ.'TEMP_F') THEN
         PARTPM  = 'PTEMPEF'
      ELSE
         CALL U2MESS('F','ALGORITH8_60')
      END IF

      CALL DISMOI('F','NOM_GD',TEMPLU,'CHAMP',IBID,NOMGD,IRET)
      IF (NOMGD.EQ.'TEMP_R') THEN
         PARTPP  = 'PTEMPER'
      ELSE IF (NOMGD.EQ.'TEMP_F') THEN
         PARTPP  = 'PTEMPEF'
      ELSE
         CALL U2MESS('F','ALGORITH8_60')
      END IF


C -- CALCUL DES OPTIONS EN T+

      NBR = 0

      LPAIN(16)  = 'PTEMPSR'
      LCHIN(16)  =  INSPLU
      LPAIN(17)  =  PARTPP
      LCHIN(17)  =  TEMPLU
      LPAIN(18)  = 'PVARCPR'
      LCHIN(18)  =  VRCPLU
      LPAIN(19)  =  'PNBSP_I'
      LCHIN(19)  =  CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(20) = 'PFIBRES'
      LCHIN(20) =  CHCARA(1) (1:8)//'.CAFIBR'

C    THERMIQUE
      IF (EXITEM) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(1) // MASQUE
        OPTION = 'CHAR_MECA_TEMP_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    HYDRATATION
      IF (EXIHYD) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(1) // MASQUE
        OPTION = 'CHAR_MECA_HYDR_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    SECHAGE
      IF (EXISEC) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(1) // MASQUE
        OPTION = 'CHAR_MECA_SECH_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    DEFORMATION ANELASTIQUE
      IF (EXIEPA) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(1) // MASQUE
        OPTION = 'CHAR_MECA_EPSA_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    PHASE (DEJA INCREMENTAL)
      IF (EXIPHA) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(1) // MASQUE
        OPTION = 'CHAR_MECA_META_Z'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

      CALL JEECRA(VECEL(1) // '.LISTE_RESU','LONUTI',NBR,K8BID)


C -- CALCUL DES OPTIONS EN T-

      NBR = 0

      LPAIN(16)  = 'PTEMPSR'
      LCHIN(16)  =  INSMOI
      LPAIN(17)  =  PARTPM
      LCHIN(17)  =  TEMMOI
      LPAIN(18)  = 'PVARCPR'
      LCHIN(18)  =  VRCMOI
      LPAIN(19)  =  'PNBSP_I'
      LCHIN(19)  =  CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(20) = 'PFIBRES'
      LCHIN(20) =  CHCARA(1) (1:8)//'.CAFIBR'

C    THERMIQUE
      IF (EXITEM) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(2) // MASQUE
        OPTION = 'CHAR_MECA_TEMP_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCM-1 + NBR) = LCHOUT(1)
      END IF

C    HYDRATATION
      IF (EXIHYD) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(2) // MASQUE
        OPTION = 'CHAR_MECA_HYDR_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCM-1 + NBR) = LCHOUT(1)
      END IF

C    SECHAGE
      IF (EXISEC) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(2) // MASQUE
        OPTION = 'CHAR_MECA_SECH_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCM-1 + NBR) = LCHOUT(1)
      END IF

C    DEFORMATION ANELASTIQUE
      IF (EXIEPA) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL(2) // MASQUE
        OPTION = 'CHAR_MECA_EPSA_R'
       CALL CALCUL('S',OPTION,LIGRMO,20,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCM-1 + NBR) = LCHOUT(1)
      END IF
      CALL JEECRA(VECEL(2) // '.LISTE_RESU','LONUTI',NBR,K8BID)


C -- ASSEMBLAGE

      X(1) =  1
      X(2) = -1
      CALL ASSVEC ('V',CNVCPR,2,VECEL,X,NUMEDD,' ','ZERO',1)

      CALL JEDEMA()
      END
