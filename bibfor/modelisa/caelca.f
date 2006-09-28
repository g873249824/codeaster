      SUBROUTINE CAELCA(MODELE,CHMAT,CAELEM,IRANA1,
     &                  ICABL,NBNOCA,NUMACA,
     &                  RELAX,EA,RH1000,MU0,FPRG,FRCO,FRLI,SA)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C  DESCRIPTION : RECUPERATION DES CARACTlERISTIQUES ELEMENTAIRES
C  -----------   D'UN CABLE
C                APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
C
C  IN     : MODELE : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT MODELE ASSOCIE A L'ETUDE
C  IN     : CHMAT  : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT CHAM_MATER ASSOCIE A L'ETUDE
C  IN     : CAELEM : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT CARA_ELEM ASSOCIE A L'ETUDE
C  IN     : IRANA1 : INTEGER , SCALAIRE
C                    RANG DE LA COMPOSANTE <A1> DE LA GRANDEUR <CAGNBA>
C  IN     : ICABL  : INTEGER , SCALAIRE
C                    NUMERO DU CABLE
C  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
C                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
C  IN     : NUMACA : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
C                    NUMEROS DES MAILLES APPARTENANT AUX CABLES
C                    CE VECTEUR EST COMPLETE LORS DU PASSAGE PREALABLE
C                    DANS LA ROUTINE TOPOCA
C  IN/OUT : RELAX  : LOGICAL , SCALAIRE
C                    INDICATEUR DE PRISE EN COMPTE DES PERTES DE TENSION
C                    PAR RELAXATION DE L'ACIER
C                    SI RH1000 = 0  => RELAX = .FALSE.
C  OUT    : EA     : REAL*8 , SCALAIRE
C                    VALEUR DU MODULE D'YOUNG DE L'ACIER
C  OUT    : RH1000 : REAL*8 , SCALAIRE
C                    VALEUR DE LA RELAXATION A 1000 HEURES EN %
C  OUT    : MU0    : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE RELAXATION DE L'ACIER
C                    PRECONTRAINT
C  OUT    : FPRG  : REAL*8 , SCALAIRE
C                    VALEUR DE LA CONTRAINTE LIMITE ELASTIQUE DE L'ACIER
C  OUT    : FRCO   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN COURBE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  OUT    : FRLI   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN LIGNE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  OUT    : SA     : REAL*8 , SCALAIRE
C                    VALEUR DE L'AIRE DE LA SECTION DROITE DU CABLE
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM, JEXNUM, JEXATR
C     ----- FIN   COMMUNS NORMALISES  JEVEUX  --------------------------
C
C ARGUMENTS
C ---------
      CHARACTER*8   MODELE, CHMAT, CAELEM
      INTEGER       IRANA1, ICABL, NBNOCA(*)
      CHARACTER*19  NUMACA
      LOGICAL       RELAX
      REAL*8        EA, RH1000, MU0, FPRG, FRCO, FRLI, SA
C
C VARIABLES LOCALES
C -----------------
      INTEGER       IAS, IASMAX, ICMP, ICODE, ICSTE, IDECMA, IMAIL,
     &              IRANV, IRET, JDESC, JMODMA, JNUMAC, JPTMA, JTABL,
     &              JVALK, JVALR, LONUTI, NBCSTE, NBEC, NBNO, NCABA,
     &              NTYELE, NUMAIL, NBCMP, IER, IDEBGD
      REAL*8        EPS, RBID
      LOGICAL       TROUV1, TROUV2, TROUV3, TROUV4, TROUV5
      CHARACTER*1   K1B
      CHARACTER*3   K3CAB, K3MAI
      CHARACTER*8   ACIER, K8B
      CHARACTER*19  CARTE, NOMRC
      CHARACTER*24  CADESC, CAPTMA, CAVALK, CAVALR, MODMAI, RCVALK,
     &              RCVALR
C
      REAL*8        R8PREM
C
      CHARACTER*8   BPELA(5), YOUNG
      CHARACTER*16  NOMELE
C
      DATA          NOMELE /'MECA_BARRE      '/
      DATA          BPELA  /'RELAX_10','MU0_RELA','F_PRG',
     &                      'FROT_COU','FROT_LIN'/
      DATA          YOUNG  /'E       '/
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
C
      EPS = 1.0D+02 * R8PREM()
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   VERIFICATION DU TYPE DES ELEMENTS
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      NBNO = NBNOCA(ICABL)
C
      CALL JELIRA(NUMACA,'LONUTI',LONUTI,K1B)
      IDECMA = LONUTI - NBNO + 1
      CALL JEVEUO(NUMACA,'L',JNUMAC)
C
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMELE),NTYELE)
      MODMAI = MODELE//'.MAILLE'
      CALL JEVEUO(MODMAI,'L',JMODMA)
C
      DO 10 IMAIL = 1, NBNO-1
         NUMAIL = ZI(JNUMAC+IDECMA+IMAIL-1)
         IF ( ZI(JMODMA+NUMAIL-1).NE.NTYELE ) THEN
            WRITE(K3CAB,'(I3)') ICABL
            CALL U2MESK('F','MODELISA2_48',1,K3CAB)
         ENDIF
  10  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   RECUPERATION DES CARACTERISTIQUES DU MATERIAU ACIER
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C 2.1 RECUPERATION DU MATERIAU ACIER CONSTITUANT LE CABLE
C ---
      CARTE = CHMAT//'.CHAMP_MAT '
      CAVALK = CARTE//'.VALE'
      CAPTMA = CARTE//'.PTMA'
      CALL JEVEUO(CAVALK,'L',JVALK)
      CALL JEVEUO(CAPTMA,'L',JPTMA)
C
      NUMAIL = ZI(JNUMAC+IDECMA)
      IAS = ZI(JPTMA+NUMAIL-1)
      IF ( IAS.EQ.0 ) THEN
         WRITE(K3MAI,'(I3)') NUMAIL
         WRITE(K3CAB,'(I3)') ICABL
         CALL UTMESS('F','CAELCA','LES CARACTERISTIQUES '//
     &               'MATERIELLES N ONT PAS ETE AFFECTEES A LA '//
     &               'MAILLE NO'//K3MAI//' APPARTENANT AU CABLE NO'//
     &                K3CAB)
C        CALL U2MESK('F','MODELISA2_49', 2 ,VALK)
      ENDIF
C
      CALL DISMOI('F','NB_CMP_MAX','NEUT_F','GRANDEUR',NBCMP,K8B,IER)
C.... NBCMP COMPOSANTES POUR LA GRANDEUR NEUT_F QUI COMPOSE LA CARTE
C.... => ACCES  AU NOM DU MATERIAU ASSOCIE A UNE MAILLE
C
      IDEBGD=NBCMP*(IAS-1)+1
      ACIER = ZK8(JVALK+IDEBGD-1)
C
C.... ON VERIFIE QUE LE MEME MATERIAU A ETE AFFECTE A TOUTES LES MAILLES
C.... DU CABLE
C.... N.B. LE PASSAGE PREALABLE DANS LA ROUTINE TOPOCA GARANTIT NBNO > 2
C
      DO 20 IMAIL = 2, NBNO-1
         NUMAIL = ZI(JNUMAC+IDECMA+IMAIL-1)
         IAS = ZI(JPTMA+NUMAIL-1)
         IF ( IAS.EQ.0 ) THEN
            WRITE(K3MAI,'(I3)') NUMAIL
            WRITE(K3CAB,'(I3)') ICABL
            CALL UTMESS('F','CAELCA','LES CARACTERISTIQUES '//
     &                  'MATERIELLES N ONT PAS ETE AFFECTEES A LA '//
     &                  'MAILLE NO'//K3MAI//' APPARTENANT AU CABLE NO'//
     &                   K3CAB)
C        CALL U2MESK('F','MODELISA2_49', 2 ,VALK)
         ENDIF
         IDEBGD=NBCMP*(IAS-1)+1
         K8B = ZK8(JVALK+IDEBGD-1)
CC         K8B = ZK8(JVALK+IAS-1)
         IF ( K8B.NE.ACIER ) THEN
            WRITE(K3CAB,'(I3)') ICABL
            CALL U2MESK('F','MODELISA2_50',1,K3CAB)
         ENDIF
  20  CONTINUE
C
C 2.2 RELATION DE COMPORTEMENT <ELAS> DU MATERIAU ACIER
C ---
      NOMRC = ACIER//'.ELAS      '
      RCVALK = NOMRC//'.VALK'
      CALL JEEXIN(RCVALK,IRET)
      IF ( IRET.EQ.0 ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_51',1,K3CAB)
      ENDIF
      RCVALR = NOMRC//'.VALR'
      CALL JEVEUO(RCVALK,'L',JVALK)
      CALL JEVEUO(RCVALR,'L',JVALR)
      CALL JELIRA(RCVALR,'LONMAX',NBCSTE,K1B)
C
      TROUV1 = .FALSE.
      DO 30 ICSTE = 1, NBCSTE
         IF ( ZK8(JVALK+ICSTE-1).EQ.YOUNG ) THEN
            TROUV1 = .TRUE.
            EA = ZR(JVALR+ICSTE-1)
            GO TO 31
         ENDIF
  30  CONTINUE
C
  31  CONTINUE
      IF ( .NOT. TROUV1 ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_52',1,K3CAB)
      ENDIF
      IF ( EA.LE.0.0D0 ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_53',1,K3CAB)
      ENDIF
C
C 2.3 RELATION DE COMPORTEMENT <BPEL_ACIER> DU MATERIAU ACIER
C ---
      NOMRC =  ACIER//'.BPEL_ACIER'
      RCVALK = NOMRC//'.VALK'
      CALL JEEXIN(RCVALK,IRET)
      IF ( IRET.EQ.0 ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_54',1,K3CAB)
      ENDIF
      RCVALR = NOMRC//'.VALR'
      CALL JEVEUO(RCVALK,'L',JVALK)
      CALL JEVEUO(RCVALR,'L',JVALR)
      CALL JELIRA(RCVALR,'LONMAX',NBCSTE,K1B)
C
      TROUV1 = .FALSE.
      TROUV2 = .FALSE.
      TROUV3 = .FALSE.
      TROUV4 = .FALSE.
      TROUV5 = .FALSE.
      DO 40 ICSTE = 1, NBCSTE
         IF ( ZK8(JVALK+ICSTE-1).EQ.BPELA(1) ) THEN
            TROUV1 = .TRUE.
            RH1000 = ZR(JVALR+ICSTE-1)
         ENDIF
         IF ( ZK8(JVALK+ICSTE-1).EQ.BPELA(2) ) THEN
            TROUV2 = .TRUE.
            MU0 = ZR(JVALR+ICSTE-1)
         ENDIF
         IF ( ZK8(JVALK+ICSTE-1).EQ.BPELA(3) ) THEN
            TROUV3 = .TRUE.
            FPRG = ZR(JVALR+ICSTE-1)
         ENDIF
         IF ( ZK8(JVALK+ICSTE-1).EQ.BPELA(4) ) THEN
            TROUV4 = .TRUE.
            FRCO = ZR(JVALR+ICSTE-1)
         ENDIF
         IF ( ZK8(JVALK+ICSTE-1).EQ.BPELA(5) ) THEN
            TROUV5 = .TRUE.
            FRLI = ZR(JVALR+ICSTE-1)
         ENDIF
         IF ( TROUV1 .AND. TROUV2 .AND. TROUV3 .AND. TROUV4 .AND.
     &        TROUV5 ) GO TO 41
  40  CONTINUE
C
  41  CONTINUE
      IF ( .NOT. ( TROUV1 .AND. TROUV2 .AND. TROUV3 .AND. TROUV4 .AND.
     &             TROUV5 ) ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_55',1,K3CAB)
      ENDIF
      IF ( ( RH1000.LT.0.0D0 ) .OR. ( MU0 .LT.0.0D0 ) .OR.
     &     ( FPRG .LE.0.0D0 ) .OR. ( FRCO.LT.0.0D0 ) .OR.
     &     ( FRLI  .LT.0.0D0 ) ) THEN
         WRITE(K3CAB,'(I3)') ICABL
         CALL U2MESK('F','MODELISA2_56',1,K3CAB)
      ENDIF
C
      IF ( RH1000.EQ.0.0D0 ) RELAX = .FALSE.
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 3   RECUPERATION DE L'AIRE DE LA SECTION DROITE DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      CARTE = CAELEM//'.CARGENBA  '
      CADESC = CARTE//'.DESC'
      CAVALR = CARTE//'.VALE'
      CAPTMA = CARTE//'.PTMA'
      CALL JEVEUO(CADESC,'L',JDESC)
      CALL JEVEUO(CAVALR,'L',JVALR)
      CALL JEVEUO(CAPTMA,'L',JPTMA)
C
      IASMAX = ZI(JDESC+1)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP','CAGNBA'),'LONMAX',NCABA,K1B)
      CALL WKVECT('&&CAELCA.TEMP.TABL','V V I',NCABA,JTABL)
      CALL DISMOI('F','NB_EC','CAGNBA','GRANDEUR',NBEC,K8B,IRET)
C
C.... EXTRACTION DE LA VALEUR DE L'AIRE DE LA SECTION DROITE AFFECTEE
C.... A LA PREMIERE MAILLE APPARTENANT AU CABLE
C
      NUMAIL = ZI(JNUMAC+IDECMA)
      IAS = ZI(JPTMA+NUMAIL-1)
      IF ( IAS.EQ.0 ) THEN
         WRITE(K3MAI,'(I3)') NUMAIL
         WRITE(K3CAB,'(I3)') ICABL
         CALL UTMESS('F','CAELCA','LES CARACTERISTIQUES GEOMETRIQUES '//
     &               'N ONT PAS ETE AFFECTEES A LA MAILLE NO'//K3MAI//
     &               ' APPARTENANT AU CABLE NO'//K3CAB)
C        CALL U2MESK('F','MODELISA2_57', 2 ,VALK)
      ENDIF
C
      ICODE = ZI(JDESC+3+2*IASMAX+NBEC*(IAS-1))
      CALL DEC2PN(ICODE,ZI(JTABL),NCABA)
      IRANV = 0
      DO 50 ICMP = 1, IRANA1
         IF ( ZI(JTABL+ICMP-1).EQ.1 ) IRANV = IRANV + 1
  50  CONTINUE
      IF ( IRANV.EQ.0 ) THEN
         WRITE(K3MAI,'(I3)') NUMAIL
         WRITE(K3CAB,'(I3)') ICABL
         CALL UTMESS('F','CAELCA','L AIRE DE LA SECTION DROITE N A '//
     &               'PAS ETE AFFECTEE A LA MAILLE NO'//K3MAI//
     &               ' APPARTENANT AU CABLE NO'//K3CAB)
C        CALL U2MESK('F','MODELISA2_58', 2 ,VALK)
      ENDIF
C
      SA = ZR(JVALR+NCABA*(IAS-1)+IRANV-1)
C
      IF ( SA.LE.0.0D0 ) THEN
         WRITE(K3MAI,'(I3)') NUMAIL
         WRITE(K3CAB,'(I3)') ICABL
         CALL UTMESS('F','CAELCA','VALEUR INVALIDE POUR L AIRE DE LA '//
     &               'SECTION DROITE AFFECTEE A LA MAILLE NO'//K3MAI//
     &               ' APPARTENANT AU CABLE NO'//K3CAB)
C        CALL U2MESK('F','MODELISA2_59', 2 ,VALK)
      ENDIF
C
C.... ON VERIFIE QUE LA MEME AIRE DE SECTION DROITE A ETE AFFECTEE
C.... A TOUTES LES MAILLES DU CABLE
C.... N.B. LE PASSAGE PREALABLE DANS LA ROUTINE TOPOCA GARANTIT NBNO > 2
C
      DO 60 IMAIL = 2, NBNO-1
C
         NUMAIL = ZI(JNUMAC+IDECMA+IMAIL-1)
         IAS = ZI(JPTMA+NUMAIL-1)
C
         IF ( IAS.EQ.0 ) THEN
            WRITE(K3MAI,'(I3)') NUMAIL
            WRITE(K3CAB,'(I3)') ICABL
            CALL UTMESS('F','CAELCA','LES CARACTERISTIQUES '//
     &                  'GEOMETRIQUES N ONT PAS ETE AFFECTEES A LA '//
     &                  'MAILLE NO'//K3MAI//' APPARTENANT AU CABLE NO'//
     &                   K3CAB)
C        CALL U2MESK('F','MODELISA2_57', 2 ,VALK)
         ENDIF
C
         ICODE = ZI(JDESC+3+2*IASMAX+NBEC*(IAS-1))
         CALL DEC2PN(ICODE,ZI(JTABL),NCABA)
         IRANV = 0
         DO 70 ICMP = 1, IRANA1
            IF ( ZI(JTABL+ICMP-1).EQ.1 ) IRANV = IRANV + 1
  70     CONTINUE
         IF ( IRANV.EQ.0 ) THEN
            WRITE(K3MAI,'(I3)') NUMAIL
            WRITE(K3CAB,'(I3)') ICABL
            CALL UTMESS('F','CAELCA','L AIRE DE LA SECTION DROITE '//
     &                  'N A PAS ETE AFFECTEE A LA MAILLE NO'//K3MAI//
     &                  ' APPARTENANT AU CABLE NO'//K3CAB)
C        CALL U2MESK('F','MODELISA2_58', 2 ,VALK)
         ENDIF
         RBID = ZR(JVALR+NCABA*(IAS-1)+IRANV-1)
         IF ( DBLE(ABS(RBID-SA))/SA.GT.EPS ) THEN
            WRITE(K3CAB,'(I3)') ICABL
            CALL U2MESK('F','MODELISA2_60',1,K3CAB)
         ENDIF
C
  60  CONTINUE
C
      CALL JEDETC('V','&&CAELCA',1)
      CALL JEDEMA()
C
C --- FIN DE CAELCA.
      END
