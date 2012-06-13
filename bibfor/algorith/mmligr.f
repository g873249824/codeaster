      SUBROUTINE MMLIGR(NOMA,NOMO,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMA,NOMO
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CREATION OBJETS - LIGREL)
C
C CREATION DU LIGREL POUR LES ELEMENTS TARDIFS DE CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C
C
C
C
      INTEGER      NBTYP
      PARAMETER   (NBTYP=40)
C
      INTEGER      CFDISI,CFMMVD,ZTABF
      INTEGER      ICO,JCO,IPTC,ITYP,INO,IBID,IZONE
      INTEGER      JLGRF,JTYNMA,IACNX1,ILCNX1
      INTEGER      NUMMAM,NUMMAE
      INTEGER      JNBNO,LONG,JAD,ITYTE,ITYMA
      INTEGER      NNDEL,NTPC,NBNOM,NBNOE,NBGREL,NNDTOT
      INTEGER      COMPTC(NBTYP), COMPTF(NBTYP)
      CHARACTER*8  K8BID
      CHARACTER*16 NOMTM,NOMTE
      CHARACTER*16 MMELTM,MMELTC,MMELTF
      CHARACTER*24 TABFIN,CRNUDD
      INTEGER      JTABF,JCRNUD
      INTEGER      IFM,NIV
      CHARACTER*19 LIGRCF
      CHARACTER*24 TYPELT
      CHARACTER*24 NOSDCO
      INTEGER      JNOSDC
      LOGICAL      LAPPAR,LAXIS,CFDISL,LFROT,MMINFL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- ACCES OBJETS
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CRNUDD = RESOCO(1:14)//'.NUDD'
      NOSDCO = RESOCO(1:14)//'.NOSDCO'
      CALL JEVEUO(NOSDCO,'L',JNOSDC)
      CALL JEVEUO(CRNUDD,'L',JCRNUD)
      CALL JEVEUO(TABFIN,'L',JTABF)
C
      ZTABF = CFMMVD('ZTABF')
C
C --- INITIALISATIONS
C
      NTPC   = CFDISI(DEFICO,'NTPC')
      TYPELT = '&&MMLIGR.TYPNEMA'
      LAXIS  = CFDISL(DEFICO,'AXISYMETRIQUE')
C
C --- LIGREL DES ELEMENTS TARDIFS DE CONTACT/FROTTEMENT
C
      LIGRCF = ZK24(JNOSDC+2-1)(1:19)
C
C --- REAPPARIEMENT OU PAS ?
C
      LAPPAR = ZL(JCRNUD)
      IF (LAPPAR) THEN
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<CONTACT> CREATION DU LIGREL DES'//
     &          ' ELEMENTS DE CONTACT'
        ENDIF
      ELSE
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<CONTACT> PAS DE CREATION DU LIGREL DES'//
     &        ' ELEMENTS DE CONTACT'
        ENDIF
        GOTO 999
      ENDIF
C
C --- DESTRUCTION DU LIGREL S'IL EXISTE
C
      CALL DETRSD('LIGREL',LIGRCF)
C
C --- ACCES MAILLAGE
C
      CALL JEVEUO(NOMA//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',ILCNX1)
C
C --- LISTE DES ELEMENTS DE CONTACT
C
      CALL MMLIGE(NOMA  ,DEFICO,RESOCO,TYPELT,NBTYP ,
     &            COMPTC,COMPTF,NNDTOT,NBGREL)
      CALL JEVEUO(TYPELT,'L',JTYNMA)
C
C --- PAS DE NOEUDS TARDIFS
C
      CALL WKVECT(LIGRCF//'.NBNO','V V I',1,JNBNO)
      ZI(JNBNO-1+1) = 0
C
C --- CREATION DE L'OBJET .NEMA
C
      CALL JECREC(LIGRCF//'.NEMA','V V I','NU','CONTIG','VARIABLE',NTPC)
      CALL JEECRA(LIGRCF//'.NEMA','LONT',NNDTOT,K8BID)
      DO 50 IPTC = 1,NTPC
C
C --- VERIF NOMBRE DE NOEUDS SUR ELEMENT DE CONTACT
C
        NNDEL  = ZI(JTYNMA-1+2*(IPTC-1)+2)
        NUMMAE = NINT(ZR(JTABF+ZTABF*(IPTC-1)+1))
        NUMMAM = NINT(ZR(JTABF+ZTABF*(IPTC-1)+2))
        NBNOE  = ZI(ILCNX1+NUMMAE) - ZI(ILCNX1-1+NUMMAE)
        NBNOM  = ZI(ILCNX1+NUMMAM) - ZI(ILCNX1-1+NUMMAM)
        IF (NNDEL.NE.(NBNOM+NBNOE)) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- CREATION DE L'ELEMENT DE CONTACT DANS LE LIGREL
C
        CALL JECROC(JEXNUM(LIGRCF//'.NEMA',IPTC))
        CALL JEECRA(JEXNUM(LIGRCF//'.NEMA',IPTC),'LONMAX',NNDEL+1,K8BID)
        CALL JEVEUO(JEXNUM(LIGRCF//'.NEMA',IPTC),'E',JAD)
        ZI(JAD-1+NNDEL+1) = ZI(JTYNMA-1+2*(IPTC-1)+1)
C
C --- RECOPIE DES NUMEROS DE NOEUDS DE LA MAILLE ESCLAVE
C
        DO 30 INO = 1,NBNOE
          ZI(JAD-1+INO) = ZI(IACNX1+ZI(ILCNX1-1+NUMMAE)-2+INO)
   30   CONTINUE
C
C --- RECOPIE DES NUMEROS DE NOEUDS DE LA MAILLE MAITRE
C
        DO 40 INO = 1,NBNOM
          ZI(JAD-1+NBNOE+INO) = ZI(IACNX1+ZI(ILCNX1-1+NUMMAM)-2+INO)
   40   CONTINUE

   50 CONTINUE
C
C --- LONGUEUR TOTALE DU LIEL
C
      LONG = NBGREL
      DO 70 ITYP = 1,NBTYP
        LONG = LONG + COMPTC(ITYP) + COMPTF(ITYP)
   70 CONTINUE
C
C --- CREATION DE L'OBJET .LIEL
C
      IF (NBGREL.EQ.0) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        CALL JECREC(LIGRCF//'.LIEL','V V I','NU','CONTIG','VARIABLE',
     &              NBGREL)
      ENDIF

      CALL JEECRA(LIGRCF//'.LIEL','LONT',LONG,K8BID)
      ICO = 0
      DO 90 ITYP = 1,NBTYP
        IF (COMPTC(ITYP).NE.0) THEN
          ICO = ICO + 1
          CALL JECROC(JEXNUM(LIGRCF//'.LIEL',ICO))
          CALL JEECRA(JEXNUM(LIGRCF//'.LIEL',ICO),'LONMAX',
     &                COMPTC(ITYP)+1,K8BID)
          CALL JEVEUO(JEXNUM(LIGRCF//'.LIEL',ICO),'E',JAD)

          NOMTE  = MMELTC(ITYP)
          NOMTM  = MMELTM(ITYP)

C         --- MODIF NOM SI AXISYMETRIQUE

          IF (LAXIS) THEN
            IF (NOMTM(1:3).EQ.'SEG') THEN
              NOMTE(7:7) = 'A'
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
          ENDIF

          CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMTE),ITYTE)
          CALL JENONU(JEXNOM('&CATA.TM.NOMTM',NOMTM),ITYMA)

          ZI(JAD-1+COMPTC(ITYP)+1) = ITYTE

          JCO = 0
          DO 80 IPTC = 1,NTPC
            IF (ZI(JTYNMA-1+2* (IPTC-1)+1).EQ.ITYMA) THEN
              IZONE  = NINT(ZR(JTABF+ZTABF*(IPTC-1)+13))
              LFROT  = MMINFL(DEFICO,'FROTTEMENT_ZONE',IZONE)
              IF (.NOT.LFROT) THEN
                JCO = JCO + 1
                ZI(JAD-1+JCO) = -IPTC
              ENDIF
            ENDIF
   80     CONTINUE
          CALL ASSERT(JCO.EQ.COMPTC(ITYP))
        ENDIF
        IF (COMPTF(ITYP).NE.0) THEN
          ICO = ICO + 1
          CALL JECROC(JEXNUM(LIGRCF//'.LIEL',ICO))
          CALL JEECRA(JEXNUM(LIGRCF//'.LIEL',ICO),'LONMAX',
     &                COMPTF(ITYP)+1,K8BID)
          CALL JEVEUO(JEXNUM(LIGRCF//'.LIEL',ICO),'E',JAD)

          NOMTE  = MMELTF(ITYP)
          NOMTM  = MMELTM(ITYP)

C         --- MODIF NOM SI AXISYMETRIQUE

          IF (LAXIS) THEN
            IF (NOMTM(1:3).EQ.'SEG') THEN
              NOMTE(7:7) = 'A'
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
          ENDIF

          CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMTE),ITYTE)
          CALL JENONU(JEXNOM('&CATA.TM.NOMTM',NOMTM),ITYMA)

          ZI(JAD-1+COMPTF(ITYP)+1) = ITYTE

          JCO = 0
          DO 85 IPTC = 1,NTPC
            IF (ZI(JTYNMA-1+2* (IPTC-1)+1).EQ.ITYMA) THEN
              IZONE  = NINT(ZR(JTABF+ZTABF*(IPTC-1)+13))
              LFROT  = MMINFL(DEFICO,'FROTTEMENT_ZONE',IZONE)
              IF (LFROT) THEN
                JCO = JCO + 1
                ZI(JAD-1+JCO) = -IPTC
              ENDIF
            ENDIF
   85     CONTINUE
          CALL ASSERT(JCO.EQ.COMPTF(ITYP))
        ENDIF
   90 CONTINUE
      CALL ASSERT(ICO.EQ.NBGREL)
C
C --- INITIALISATION DU LIGREL
C
      CALL JEDUPO(NOMO//'.MODELE    .LGRF','V',LIGRCF//'.LGRF',
     &               .FALSE.)
      CALL ADALIG(LIGRCF)
      CALL INITEL(LIGRCF)
C
C --- IMPRESSIONS
C
      IF (NIV.GE.2) CALL MMIMP2(IFM,NOMA,LIGRCF,JTABF)
C
C --- MENAGE
C
      CALL JEDETR(TYPELT)
  999 CONTINUE
C
      CALL JEDEMA()
      END
