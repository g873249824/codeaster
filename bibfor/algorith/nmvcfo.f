      SUBROUTINE NMVCFO(MODELZ,LISCHA,NUMEDD,MATE,CARELE,COMPOR,COMREF,
     &                  COMPLU,CNVCFO)

C MODIF ALGORITH  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
      CHARACTER*(*) MODELZ
      CHARACTER*19  CNVCFO,LISCHA
      CHARACTER*24  NUMEDD, MATE, COMREF, CARELE, COMPOR
      CHARACTER*24  COMPLU

C ----------------------------------------------------------------------
C    ESTIMATION D'UNE FORCE DE REFERENCE LIEE A L'ACTION DES V. COM.
C ----------------------------------------------------------------------
C
C IN       MODELE K8  MODELE
C IN       LISCHA K19 INFORMATION SUR LES CHARGEMENTS
C IN       NUMEDD K24 NUME_DDL
C IN       MATE   K24 CHAMP MATERIAU
C IN       CARELE K24 CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24 VARI_COM DE REFERENCE
C IN       COMPLU K24 VARI_COM EN T+ (TEMPERATURE POUR LES POUTRES)
C IN       COMPOR K24 COMPOR POUR LES POUTRES MULTIFIBRES (POU_D_EM)
C IN/JXOUT CNVCFO K19 FORCE DE REFERENCE (DFINT/DA * A)
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
      LOGICAL      EXIGEO, EXICAR,LBID
      INTEGER      NBRENV, NBR, IRET, IBID
      INTEGER      JVCP,JINF,NCHAR,NUMCHT
      CHARACTER*6  MASQUE
      CHARACTER*8  VECEL, LPAIN(20), LPAOUT(1), PARTPP, NOMGD, K8BID
      CHARACTER*8  MODELE
      CHARACTER*16 OPTION
      CHARACTER*24 CHVREF
      CHARACTER*24 VRCPLU, SECPLU, PHAPLU, INSPLU
      CHARACTER*24 LIGRMO, CHGEOM, CHCARA(17), LCHIN(20), LCHOUT(1)

      DATA  VECEL /'&&VEVCFO'/
C ----------------------------------------------------------------------
      CALL JEMARQ()
      MODELE=MODELZ


C -- PREPARATION DES VECT_ELEM

      NBRENV = 4
      MASQUE = '.VEXXX'
      CALL JEEXIN(VECEL // '.LISTE_RESU',IRET)
      IF (IRET.EQ.0) THEN
        CALL MEMARE('V',VECEL,MODELE,MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(VECEL // '.LISTE_RESU','V V K24',NBRENV,JVCP)
      ELSE
        CALL JEVEUO(VECEL // '.LISTE_RESU','E',JVCP)
      END IF


C -- EXTRACTION DES VARIABLES DE COMMANDE

      CALL NMVCEX('TOUT',COMREF,CHVREF)
      CALL NMVCEX('TOUT',COMPLU,VRCPLU)
      CALL NMVCEX('INST',COMPLU,INSPLU)
C    VARIABLES DE COMMANDE PRESENTES

      CALL NMVCD2('TEMP',MATE,EXITEM,LBID)
      CALL JEVEUO (LISCHA//'.INFC','L',JINF)
      NCHAR = ZI(JINF)
      NUMCHT = ZI(JINF-1+2+2*NCHAR)
      EXITEM=EXITEM.OR.(NUMCHT.GT.0)
      CALL NMVCD2('HYDR',MATE,EXIHYD,LBID)
      CALL NMVCD2('SECH',MATE,EXISEC,LBID)
      CALL NMVCD2('EPSA',MATE,EXIEPA,LBID)


C -- CHAMPS DES OPTIONS

      LIGRMO = MODELE//'.MODELE'
      CALL MEGEOM(MODELE,' ' , EXIGEO, CHGEOM)
      CALL MECARA(CARELE(1:8), EXICAR, CHCARA)

      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  =  CHGEOM
      LPAIN(2)  = 'PMATERC'
      LCHIN(2)  =  MATE
      LPAIN(3)  = 'PCACOQU'
      LCHIN(3)  =  CHCARA(7)
      LPAIN(4)  = 'PCAGNPO'
      LCHIN(4)  =  CHCARA(6)
      LPAIN(5)  = 'PCAORIE'
      LCHIN(5)  =  CHCARA(1)
      LPAIN(6)  = 'PCAGNBA'
      LCHIN(6)  =  CHCARA(11)
      LPAIN(7)  = 'PCAARPO'
      LCHIN(7)  =  CHCARA(9)
      LPAIN(8)  = 'PCAMASS'
      LCHIN(8)  =  CHCARA(12)
      LPAIN(9) = 'PCAGEPO'
      LCHIN(9) =  CHCARA(5)
      LPAIN(10)  = 'PTEMPSR'
      LCHIN(10)  =  INSPLU
      LPAIN(11)  = 'PVARCPR'
      LCHIN(11)  =  VRCPLU
      LPAIN(12)  = 'PVARCRR'
      LCHIN(12)  =  CHVREF
      LPAIN(13)  = ' '
      LCHIN(13)  = ' '
      LPAIN(14)  = 'PNBSP_I'
      LCHIN(14)  = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(15) = 'PFIBRES'
      LCHIN(15) =  CHCARA(1) (1:8)//'.CAFIBR'
      LPAIN(16) = 'PCOMPOR'
      LCHIN(16) =  COMPOR


C -- CALCUL DES OPTIONS EN T+

      NBR = 0

C    THERMIQUE
      IF (EXITEM) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL // MASQUE
        OPTION = 'CHAR_MECA_TEMP_R'
       CALL CALCUL('S',OPTION,LIGRMO,16,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    HYDRATATION
      IF (EXIHYD) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL // MASQUE
        OPTION = 'CHAR_MECA_HYDR_R'
       CALL CALCUL('S',OPTION,LIGRMO,16,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    SECHAGE
      IF (EXISEC) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL // MASQUE
        OPTION = 'CHAR_MECA_SECH_R'
       CALL CALCUL('S',OPTION,LIGRMO,16,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF

C    DEFORMATION ANELASTIQUE
      IF (EXIEPA) THEN
        NBR = NBR+1
        CALL CODENT (NBR,'D0',MASQUE(4:6))
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  VECEL // MASQUE
        OPTION = 'CHAR_MECA_EPSA_R'
       CALL CALCUL('S',OPTION,LIGRMO,16,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JVCP-1 + NBR) = LCHOUT(1)
      END IF


C -- ASSEMBLAGE

      CALL JEECRA(VECEL // '.LISTE_RESU','LONUTI',NBR,K8BID)
      CALL ASSVEC ('V',CNVCFO,1,VECEL,1.D0,NUMEDD,' ','ZERO',1)


      CALL JEDEMA()
      END
