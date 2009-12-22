      SUBROUTINE XMELE1(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &                  CHELEM,CHELE2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*8   MODELE
      INTEGER       NFISS
      CHARACTER*19  CHELEM,CHELE2
      CHARACTER*19  LIGREL
      CHARACTER*24  DEFICO
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
C
C CREATION DU CHAM_ELEM PINDCOI (STATUT DU CONTACT)
C CREATION DU CHAM_ELEM PMEMCON (MEMOIRE DU CONTACT)
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  NFISS  : NOMBRE TOTAL DE FISSURES
C IN  LIGREL : NOM DU LIGREL DES MAILLES TARDIVES
C IN  CHELEM : NOM DU CHAM_ELEM POUR STATUT DE CONTACT
C IN  CHELEM : NOM DU CHAM_ELEM POUR MEMOIRE DU CONTACT (GLISSIERE)
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C

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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER       IFM,NIV
      CHARACTER*8   K8BID
      INTEGER       IBID,IAD,IGRP,ISPT,I,IMA,IFIS,IZONE
      INTEGER       NBMA,NBSPG,NMAENR,XXCONI
      CHARACTER*8   NOMFIS
      INTEGER       JCESL,JCESV,JCESD,JMOFIS
      CHARACTER*24  XINDIC,GRP(3)
      INTEGER       JINDIC,JGRP
      LOGICAL       MMINFL,LCINIT
      CHARACTER*19  CHELSI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM  > CREATION DU CHAM_ELEM PINDCOI '
      ENDIF
C
C --- INITIALISATIONS
C
      NBSPG    = 60
      CHELSI   = '&&XMELE1.CES'
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IBID)
C
C --- CREATION DU CHAM_ELEM VIERGE
C
      CALL XMCHBA(NOMA  ,NBMA  ,LIGREL,'PINDCOI','RIGI_CONT',
     &            CHELEM)
C
C --- CONVERSION CHAM_ELEM -> CHAM_ELEM_S
C
      CALL CELCES(CHELEM,'V',CHELSI)
C
C --- ACCES AU CHAM_ELEM_S
C
      CALL JEVEUO(CHELSI//'.CESD','L',JCESD)
      CALL JEVEUO(CHELSI//'.CESL','E',JCESL)
      CALL JEVEUO(CHELSI//'.CESV','E',JCESV)
      CALL JEVEUO(MODELE//'.FISS','L',JMOFIS)
C
C --- ENRICHISSEMENT DU CHAM_ELEM_S POUR LA MULTIFISSURATION
C
      DO 110 IFIS = 1, NFISS
C
C --- ACCES FISSURE COURANTE
C
        NOMFIS = ZK8(JMOFIS-1 + IFIS)
        GRP(1) = NOMFIS(1:8)//'.MAILFISS  .HEAV'
        GRP(2) = NOMFIS(1:8)//'.MAILFISS  .CTIP'
        GRP(3) = NOMFIS(1:8)//'.MAILFISS  .HECT'
C
C --- ZONE DE CONTACT IZONE CORRESPONDANTE
C
        IZONE  = XXCONI(DEFICO,NOMFIS,'MAIT')
C
C --- CONTACT INIT
C
        LCINIT = MMINFL(DEFICO,'CONTACT_INIT',IZONE )
C
C --- SI CONTACT_INIT
C
        IF (LCINIT) THEN
C
C --- ACCES AU CHAMP INDICATEUR
C
          XINDIC = NOMFIS(1:8)//'.MAILFISS .INDIC'
          CALL JEVEUO(XINDIC,'L',JINDIC)
C
C --- ON COPIE LES CHAMPS CORRESP. AUX ELEM. HEAV, CTIP ET HECT
C
          DO 1000 IGRP = 1,3
            IF (ZI(JINDIC-1+2*(IGRP-1)+1).EQ.1) THEN
              CALL JEVEUO(GRP(IGRP),'L',JGRP)
              NMAENR = ZI(JINDIC-1+2*IGRP)
              DO 120 I = 1,NMAENR
                IMA = ZI(JGRP-1+I)
                DO 121 ISPT = 1,NBSPG
                  CALL CESEXI('C',JCESD,JCESL,IMA,1,ISPT,1,IAD)
                  IF (IAD.EQ.0) THEN
                    GOTO 120
                  ENDIF
                  ZI(JCESV-1+IAD) = 1
 121            CONTINUE
 120          CONTINUE
            ENDIF
 1000     CONTINUE
        ENDIF
 110  CONTINUE
C
C --- CONVERSION CHAM_ELEM_S -> CHAM_ELEM
C
      CALL CESCEL(CHELSI,LIGREL,'RIGI_CONT','PINDCOI','OUI',IBID,'V',
     &            CHELEM,'F',IBID)
C
C --- ON DUPLIQUE LE CHAMP INDCO POUR CREER LE CHAMP DE MEMOIRE
C --- DE CONTACT IL SERA INITIALISÉ DONC AVEC LES STATUTS
C --- CONTACT_INI
C
      CALL CESCEL(CHELSI,LIGREL,'XCVBCA','PMEMCON','OUI',IBID,'V',
     &            CHELE2,'F',IBID)
C
C --- DESTRUCTION DU CHAM_ELEM_S
C
      CALL DETRSD('CHAM_ELEM_S',CHELSI)
C
      CALL JEDEMA()
C
      END
