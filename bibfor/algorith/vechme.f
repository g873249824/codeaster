      SUBROUTINE VECHME(STOP  ,MODELZ,CHARGZ,INFCHZ,INST  ,
     &                  CARELE,MATE  ,VRCPLU,LIGREZ,VECELZ)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE PELLET J.PELLET
C
      IMPLICIT      NONE 
      INCLUDE 'jeveux.h'
      CHARACTER*(*) MODELZ,CHARGZ,INFCHZ,CARELE,MATE
      CHARACTER*(*) VRCPLU,VECELZ,LIGREZ
      CHARACTER*1   STOP
      REAL*8        INST(3)
C
C ----------------------------------------------------------------------
C
C  CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
C  DE NEUMANN NON SUIVEURS ET NON PILOTABLES (CONSTANTS).
C
C ----------------------------------------------------------------------
C
C  PRODUIT UN VECT_ELEM DEVANT ETRE ASSEMBLE PAR LA ROUTINE ASASVE
C
C IN  STOP   : COMPORTEMENT DE CALCUL
C IN  MODELE : NOM DU MODELE
C IN  CHARGE : LISTE DES CHARGES
C IN  INFCHA : INFORMATIONS SUR LES CHARGEMENTS
C IN  INST   : TABLEAU DONNANT T+, DELTAT ET THETA (POUR LE THM)
C IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE   : MATERIAU CODE
C IN  TEMPLU : CHAMP DE TEMPERATURE A L'INSTANT T+
C IN  LIGREZ : (SOUS-)LIGREL DE MODELE POUR CALCUL REDUIT
C                  SI ' ', ON PREND LE LIGREL DU MODELE
C OUT VECELE : VECT_ELEM RESULTAT.
C
C ATTENTION :
C -----------
C   LE VECT_ELEM (VECELZ) RESULTAT A 1 PARTICULARITE :
C   1) CERTAINS RESUELEM NE SONT PAS DES RESUELEM MAIS DES
C      CHAM_NO (.VEASS)
      INTEGER NCHINX
      PARAMETER (NCHINX=42)
      INTEGER NBCHMX
      PARAMETER (NBCHMX=17)
      INTEGER JLCHIN,ISIGI
      INTEGER IER,JCHAR,JINF
      INTEGER IBID,IRET,NCHAR,K,ICHA,II,IEXIS
      INTEGER NUMCHM,NCHIN
      CHARACTER*5 SUFFIX
      CHARACTER*6 NOMLIG(NBCHMX),NOMPAF(NBCHMX),NOMPAR(NBCHMX)
      CHARACTER*6 NOMOPF(NBCHMX),NOMOPR(NBCHMX)
      CHARACTER*7 NOMCMP(3)
      CHARACTER*8 NOMCHA,K8BID
      CHARACTER*8 LPAIN(NCHINX),LPAOUT,NEWNOM,MODELE
      CHARACTER*16 OPTION
      CHARACTER*24 CHGEOM,CHCARA(18),CHTIME,LIGREL
      CHARACTER*24 LIGRMO,LIGRCH
      CHARACTER*19 LCHOUT,RESUFV(3),VECELE
      CHARACTER*24 LCHIN(NCHINX)
      CHARACTER*24 CHARGE,INFCHA
      LOGICAL EXIGEO,EXICAR,BIDON,LXFEM
      COMPLEX*16 CBID
C
      DATA NOMLIG/'.FORNO','.F3D3D','.F2D3D','.F1D3D','.F2D2D','.F1D2D',
     &     '.F1D1D','.PESAN','.ROTAT','.PRESS','.FELEC','.FCO3D',
     &     '.FCO2D','.EPSIN','.FLUX','.VEASS','.SIINT'/
      DATA NOMOPF/'FORC_F','FF3D3D','FF2D3D','FF1D3D','FF2D2D','FF1D2D',
     &     'FF1D1D','PESA_R','ROTA_R','PRES_F','FRELEC','FFCO3D',
     &     'FFCO2D','EPSI_F','FLUX_F','      ',' '/
      DATA NOMPAF/'FORNOF','FF3D3D','FF2D3D','FF1D3D','FF2D2D','FF1D2D',
     &     'FF1D1D','PESANR','ROTATR','PRESSF','FRELEC','FFCO3D',
     &     'FFCO2D','EPSINF','FLUXF','      ',' '/
      DATA NOMOPR/'FORC_R','FR3D3D','FR2D3D','FR1D3D','FR2D2D','FR1D2D',
     &     'FR1D1D','PESA_R','ROTA_R','PRES_R','FRELEC','FRCO3D',
     &     'FRCO2D','EPSI_R','FLUX_R','      ',' '/
      DATA NOMPAR/'FORNOR','FR3D3D','FR2D3D','FR1D3D','FR2D2D','FR1D2D',
     &     'FR1D1D','PESANR','ROTATR','PRESSR','FRELEC','FRCO3D',
     &     'FRCO2D','EPSINR','FLUXR','      ',' '/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NEWNOM = '.0000000'
      MODELE = MODELZ
      CHARGE = CHARGZ
      INFCHA = INFCHZ
      LIGRMO = LIGREZ
      DO 10 II = 1,NCHINX
        LCHIN(II) = ' '
        LPAIN(II) = ' '
   10 CONTINUE
      CALL EXIXFE(MODELE,IER)
      LXFEM = IER.NE.0
      IF (LIGRMO.EQ.' ') LIGRMO = MODELE(1:8)//'.MODELE'
      LPAOUT = 'PVECTUR'
      LCHOUT = '&&VECHME.???????'
C
C --- CALCUL DU NOM DU RESULTAT :
C
      VECELE = VECELZ
      IF (VECELE.EQ.' ') VECELE = '&&VEMCHA'
C
C --- DETECTION DE LA PRESENCE DE CHARGES
C
      BIDON = .TRUE.
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
        IF (NCHAR.NE.0) THEN
          BIDON = .FALSE.
          CALL JEVEUO(CHARGE,'L',JCHAR)
          CALL JEVEUO(INFCHA,'L',JINF)
        ENDIF
      ENDIF
C
C --- ALLOCATION DU VECT_ELEM RESULTAT :
C
      CALL DETRSD('VECT_ELEM',VECELE)
      CALL MEMARE('V',VECELE,MODELE,MATE,CARELE,'CHAR_MECA')
      CALL REAJRE(VECELE,' ','V')
      IF (BIDON) GOTO 99
C
C --- CARTES GEOMETRIE ET CARA_ELEM
C
      CALL MEGEOM(MODELE,ZK24(JCHAR) (1:8),EXIGEO,CHGEOM)
      CALL MECARA(CARELE,EXICAR,CHCARA)
C
C --- CARTE INSTANTS
C
      CHTIME = '&&VECHME.CH_INST_R'
      NOMCMP(1) = 'INST   '
      NOMCMP(2) = 'DELTAT '
      NOMCMP(3) = 'THETA  '
      CALL MECACT('V',CHTIME,'LIGREL',LIGRMO,'INST_R  ',3,NOMCMP,IBID,
     &            INST,CBID,K8BID)
C
C --- CHAMPS IN
C
      LPAIN(2)  = 'PGEOMER'
      LCHIN(2)  = CHGEOM
      LPAIN(3)  = 'PTEMPSR'
      LCHIN(3)  = CHTIME
      LPAIN(4)  = 'PMATERC'
      LCHIN(4)  = MATE
      LPAIN(5)  = 'PCACOQU'
      LCHIN(5)  = CHCARA(7)
      LPAIN(6)  = 'PCAGNPO'
      LCHIN(6)  = CHCARA(6)
      LPAIN(7)  = 'PCADISM'
      LCHIN(7)  = CHCARA(3)
      LPAIN(8)  = 'PCAORIE'
      LCHIN(8)  = CHCARA(1)
      LPAIN(9)  = 'PCACABL'
      LCHIN(9)  = CHCARA(10)
      LPAIN(10) = 'PCAARPO'
      LCHIN(10) = CHCARA(9)
      LPAIN(11) = 'PCAGNBA'
      LCHIN(11) = CHCARA(11)
      LCHIN(12) = VRCPLU
      LPAIN(12) = 'PVARCPR '
      LPAIN(13) = 'PCAMASS'
      LCHIN(13) = CHCARA(12)
      LPAIN(14) = 'PCAGEPO'
      LCHIN(14) = CHCARA(5)
      LPAIN(15) = 'PNBSP_I'
      LCHIN(15) = CHCARA(16)
      LPAIN(16) = 'PFIBRES'
      LCHIN(16) = CHCARA(17)
      LPAIN(17) = 'PCINFDI'
      LCHIN(17) = CHCARA(15)
      LPAIN(18) = 'PCOMPOR'
      LCHIN(18) =  MATE(1:8)//'.COMPOR'
      NCHIN    = 18
      IF (LXFEM) THEN
        LPAIN(NCHIN + 1) = 'PPINTTO'
        LCHIN(NCHIN + 1) = MODELE(1:8)//'.TOPOSE.PIN'
        LPAIN(NCHIN + 2) = 'PCNSETO'
        LCHIN(NCHIN + 2) = MODELE(1:8)//'.TOPOSE.CNS'
        LPAIN(NCHIN + 3) = 'PHEAVTO'
        LCHIN(NCHIN + 3) = MODELE(1:8)//'.TOPOSE.HEA'
        LPAIN(NCHIN + 4) = 'PLONCHA'
        LCHIN(NCHIN + 4) = MODELE(1:8)//'.TOPOSE.LON'
        LPAIN(NCHIN + 5) = 'PLSN'
        LCHIN(NCHIN + 5) = MODELE(1:8)//'.LNNO'
        LPAIN(NCHIN + 6) = 'PLST'
        LCHIN(NCHIN + 6) = MODELE(1:8)//'.LTNO'
        LPAIN(NCHIN + 7) = 'PSTANO'
        LCHIN(NCHIN + 7) = MODELE(1:8)//'.STNO'
        LPAIN(NCHIN + 8) = 'PPMILTO'
        LCHIN(NCHIN + 8) = MODELE(1:8)//'.TOPOSE.PMI'
        LPAIN(NCHIN + 9) = 'PFISNO'
        LCHIN(NCHIN + 9) = MODELE(1:8)//'.FISSNO'
        NCHIN = NCHIN + 9
      ENDIF
C
C --- CALCUL
C
      DO 70 ICHA = 1,NCHAR
        NUMCHM = ZI(JINF+NCHAR+ICHA)
        IF (NUMCHM.GT.0) THEN
          NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
          LIGRCH = NOMCHA//'.CHME.LIGRE'
C
C ------- LE LIGREL UTILISE DANS CALCUL EST LE LIGREL DU MODELE
C ------- SAUF POUR LES FORCES NODALES
C
          DO 40 K = 1,NBCHMX
            IF (NOMLIG(K).EQ.'.FORNO') THEN
              LIGREL = LIGRCH
            ELSE
              LIGREL = LIGRMO
            END IF
            IF (NOMLIG(K).EQ.'.VEASS') THEN
              SUFFIX = '     '
            ELSE
              SUFFIX = '.DESC'
            END IF
            LCHIN(1) = NOMCHA//'.CHME'//NOMLIG(K)//SUFFIX
            CALL JEEXIN(LCHIN(1),IRET)
            IF (IRET.NE.0) THEN
              IF (NUMCHM.EQ.1) THEN
                OPTION = 'CHAR_MECA_'//NOMOPR(K)
                LPAIN(1) = 'P'//NOMPAR(K)
              ELSE IF (NUMCHM.EQ.2) THEN
                OPTION = 'CHAR_MECA_'//NOMOPF(K)
                LPAIN(1) = 'P'//NOMPAF(K)
              ELSE IF (NUMCHM.EQ.3) THEN
                OPTION = 'CHAR_MECA_'//NOMOPF(K)
                LPAIN(1) = 'P'//NOMPAF(K)
              ELSE IF (NUMCHM.EQ.55) THEN
                OPTION = 'FORC_NODA'
                CALL JEVEUO(LIGRCH(1:13)//'.SIINT.VALE','L',ISIGI)
                LPAIN(1) = 'PCONTMR'
                LCHIN(1) = ZK8(ISIGI)
                NCHIN = NCHIN + 1
                LPAIN(NCHIN) = 'PDEPLMR'
                LCHIN(NCHIN) = ' '
              ELSE IF (NUMCHM.GE.4) THEN
                GOTO 40
              END IF
C
              NCHIN = 28
C
C ----------- POUR LES ELEMENTS DE BORD XFEM
C
              IF (LXFEM) THEN
                IF (OPTION.EQ.'CHAR_MECA_PRES_R'.OR.
     &              OPTION.EQ.'CHAR_MECA_PRES_F') THEN
                  LPAIN(NCHIN + 1) = 'PPINTER'
                  LCHIN(NCHIN + 1) = MODELE(1:8)//'.TOPOFAC.OE'
                  LPAIN(NCHIN + 2) = 'PAINTER'
                  LCHIN(NCHIN + 2) = MODELE(1:8)//'.TOPOFAC.AI'
                  LPAIN(NCHIN + 3) = 'PCFACE'
                  LCHIN(NCHIN + 3) = MODELE(1:8)//'.TOPOFAC.CF'
                  LPAIN(NCHIN + 4) = 'PLONGCO'
                  LCHIN(NCHIN + 4) = MODELE(1:8)//'.TOPOFAC.LO'
                  LPAIN(NCHIN + 5) = 'PBASECO'
                  LCHIN(NCHIN + 5) = MODELE(1:8)//'.TOPOFAC.BA'
                  NCHIN = NCHIN + 5
                ENDIF
              ENDIF
C
C ----------- GENERATION NOM DU RESU_ELEM EN SORTIE
C
              CALL GCNCO2(NEWNOM)
              LCHOUT(10:16) = NEWNOM(2:8)
              CALL CORICH('E',LCHOUT,ICHA,IBID)
C
C ----------- SI .VEASS, IL N'Y A PAS DE CALCUL A LANCER
C
              IF (NOMLIG(K).EQ.'.VEASS') THEN
                CALL JEVEUO(LCHIN(1),'L',JLCHIN)
                CALL COPISD('CHAMP_GD','V',ZK8(JLCHIN),LCHOUT)
              ELSE
                write(6,*) 'RR: ',NCHIN,NCHINX
                CALL ASSERT(NCHIN.LE.NCHINX)
                CALL CALCUL(STOP,OPTION,LIGREL,NCHIN,LCHIN,LPAIN,1,
     &                      LCHOUT,LPAOUT,'V','OUI')
              ENDIF
C
C ----------- RECOPIE DU CHAMP (S'IL EXISTE) DANS LE VECT_ELEM
C
              CALL EXISD('CHAMP_GD',LCHOUT,IEXIS)
              CALL ASSERT((IEXIS.GT.0).OR.(STOP.EQ.'C'))
              CALL REAJRE(VECELE,LCHOUT,'V')
C
            ENDIF
   40     CONTINUE
        ENDIF
C
C ----- TRAITEMENT DE AFFE_CHAR_MECA/EVOL_CHAR
C
        DO 50 II = 1,3
          RESUFV(II) = LCHOUT
          CALL GCNCO2(NEWNOM)
          RESUFV(II) (10:16) = NEWNOM(2:8)
   50   CONTINUE
        CALL NMDEPR(MODELZ,LIGRMO,CARELE,CHARGZ,ICHA,INST(1),
     &              RESUFV)
        DO 60 II = 1,3
          CALL REAJRE(VECELE,RESUFV(II),'V')
   60   CONTINUE
   70 CONTINUE
   99 CONTINUE
C
      VECELZ = VECELE//'.RELR'
      CALL JEDEMA()
      END
