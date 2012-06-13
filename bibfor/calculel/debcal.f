      SUBROUTINE DEBCAL(NOMOP,LIGREL,NIN,LCHIN,LPAIN,NOUT,LCHOUT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 

C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C RESPONSABLE                            VABHHTS J.PELLET
      IMPLICIT NONE
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMOP
      CHARACTER*19 LIGREL
      INTEGER NIN,NOUT
      CHARACTER*19 LCHIN(NIN),LCHOUT(NOUT)
      CHARACTER*8 LPAIN(NIN)
C ----------------------------------------------------------------------

C     BUT :
C      1. VERIFIER LES "ENTREES" DE CALCUL.
C      2. INITIALISER CERTAINS OBJETS POUR LE CALCUL AINSI QUE LES
C       COMMUNS CONTENANT LES ADRESSES DES OBJETS DES CATALOGUES.

C     ENTREES:
C        NOMOP  :  NOM D'1 OPTION
C        LIGREL :  NOM DU LIGREL SUR LEQUEL ON DOIT FAIRE LE DEBCAL
C        NIN    :  NOMBRE DE CHAMPS PARAMETRES "IN"
C        NOUT   :  NOMBRE DE CHAMPS PARAMETRES "OUT"
C        LCHIN  :  LISTE DES NOMS DES CHAMPS "IN"
C        LCHOUT :  LISTE DES NOMS DES CHAMPS "OUT"
C        LPAIN  :  LISTE DES NOMS DES PARAMETRES "IN"

C     SORTIES:
C       ALLOCATION D'OBJETS DE TRAVAIL ET MISE A JOUR DE COMMONS

C ----------------------------------------------------------------------
      INTEGER DESC,IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO
      INTEGER I,IAOPDS,IAOPPA,NPARIO,IAMLOC,ILMLOC,NPARIN
      INTEGER IADSGD
      INTEGER IACHII,IACHIK,IACHIX
      INTEGER IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
      INTEGER IBID,IERD,NBPARA,IRET,J
      INTEGER IER,JPAR,INDIK8,IGD,NEC,NBEC,NCMPMX,III,NUM
      INTEGER IAREFE,IANBNO,JPROLI,ISNNEM,IANUEQ,IRET1
      INTEGER IRET2,GRDEUR
      CHARACTER*8 K8BI,TYPSCA,SCALAI
      CHARACTER*4 KNUM,TYCH
      CHARACTER*8 NOMPAR,MA,MA2,K8BI1,K8BI2
      CHARACTER*19 CHIN,CHOU,LIGRE2
      CHARACTER*24 NOPRNO,KBI2,OBJDES,VALK(5)
C---------------- COMMUNS POUR CALCUL ----------------------------------
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII05/IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX


      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
C-----------------------------------------------------------------------
      CALL DISMOI('F','NOM_MAILLA',LIGREL,'LIGREL',IBID,MA,IERD)


C     -- VERIFICATION QUE LES CHAMPS "IN" ONT DES NOMS LICITES:
C     ---------------------------------------------------------
      DO 10,I=1,NIN
        NOMPAR=LPAIN(I)
        CALL CHLICI(NOMPAR,8)
        IF (NOMPAR.NE.' ') THEN
          CALL CHLICI(LCHIN(I),19)
        ENDIF
   10 CONTINUE


C     -- VERIFICATION DE L'EXISTENCE DES CHAMPS "IN"
C     ---------------------------------------------------
      CALL WKVECT('&&CALCUL.LCHIN_EXI','V V L',MAX(1,NIN),IACHIX)
      NBOBTR=NBOBTR+1
      ZK24(IAOBTR-1+NBOBTR)='&&CALCUL.LCHIN_EXI'
      DO 20,I=1,NIN
        CHIN=LCHIN(I)
        ZL(IACHIX-1+I)=.TRUE.
        IF (LPAIN(I)(1:1).EQ.' ') THEN
          ZL(IACHIX-1+I)=.FALSE.
        ELSEIF (CHIN(1:1).EQ.' ') THEN
          ZL(IACHIX-1+I)=.FALSE.
        ELSE
          CALL JEEXIN(CHIN//'.DESC',IRET1)
          CALL JEEXIN(CHIN//'.CELD',IRET2)
          IF ((IRET1+IRET2).EQ.0)ZL(IACHIX-1+I)=.FALSE.
        ENDIF
   20 CONTINUE


C     -- ON VERIFIE QUE LES CHAMPS "IN" ONT UN MAILLAGE SOUS-JACENT
C        IDENTIQUE AU MAILLAGE ASSOCIE AU LIGREL :
C     -------------------------------------------------------------
      DO 30,I=1,NIN
        CHIN=LCHIN(I)
        IF (.NOT.(ZL(IACHIX-1+I)))GOTO 30
        CALL DISMOI('F','NOM_MAILLA',CHIN,'CHAMP',IBID,MA2,IERD)
        IF (MA2.NE.MA) THEN
          VALK(1)=CHIN
          VALK(2)=LIGREL
          VALK(3)=MA2
          VALK(4)=MA
          CALL U2MESK('F','CALCULEL2_27',4,VALK)
        ENDIF
   30 CONTINUE


C     -- VERIFICATION QUE LES CHAMPS "OUT" SONT DIFFERENTS
C        DES CHAMPS "IN"
C     ---------------------------------------------------
      DO 50,I=1,NOUT
        CHOU=LCHOUT(I)
        DO 40,J=1,NIN
          CHIN=LCHIN(J)
          IF (.NOT.ZL(IACHIX-1+J))GOTO 40
          IF (CHIN.EQ.CHOU) CALL U2MESK('F','CALCULEL2_28',1,CHOU)
   40   CONTINUE
   50 CONTINUE


C     INITIALISATION DU COMMON CAII04 :
C     ---------------------------------
      CALL WKVECT('&&CALCUL.LCHIN_I','V V I',MAX(1,11*NIN),IACHII)
      NBOBTR=NBOBTR+1
      ZK24(IAOBTR-1+NBOBTR)='&&CALCUL.LCHIN_I'
      CALL WKVECT('&&CALCUL.LCHIN_K8','V V K8',MAX(1,2*NIN),IACHIK)
      NBOBTR=NBOBTR+1
      ZK24(IAOBTR-1+NBOBTR)='&&CALCUL.LCHIN_K8'
      NBPARA = ZI(IAOPDS-1+2) + ZI(IAOPDS-1+3)
      DO 60,I=1,NIN
        CHIN=LCHIN(I)

C        -- SI LE CHAMP EST BLANC OU S'IL N'EXISTE PAS
C           , ON NE FAIT RIEN :
        IF (CHIN(1:1).EQ.' ')GOTO 60
        CALL JEEXIN(CHIN//'.DESC',IRET1)
        IF (IRET1.GT.0)OBJDES=CHIN//'.DESC'
        CALL JEEXIN(CHIN//'.CELD',IRET2)
        IF (IRET2.GT.0)OBJDES=CHIN//'.CELD'
        IF ((IRET1+IRET2).EQ.0)GOTO 60
        NOMPAR=LPAIN(I)

C        -- SI LE PARAMETRE EST INCONNU POUR L'OPTION CALCULEE, ON NE
C        -- FAIT RIEN:
        JPAR=INDIK8(ZK8(IAOPPA),NOMPAR,1,NBPARA)
        IF (JPAR.EQ.0)GOTO 60

        CALL DISMOI('F','TYPE_CHAMP',CHIN,'CHAMP',IBID,TYCH,IER)

C        -- SI LE CHAMP EST UN RESUELEM DE TYPE "VOISIN_VF"
C           ON NE SAIT PAS ENCORE FAIRE ...
        CALL ASSERT(.NOT.(EVFINI.EQ.1.AND.TYCH.EQ.'RESL'))

C        -- SI LE CHAMP EST UN CHAM_ELEM( OU UN RESUELEM)
C           ET QU'IL N'A PAS ETE CALCULE AVEC LE LIGREL DE CALCUL,
C           ON LE TRANSPORTE SUR CE LIGREL
C           (ET ON MODIFIE SON NOM DANS LCHIN)
        IF ((TYCH(1:2).EQ.'EL') .OR. (TYCH.EQ.'RESL')) THEN
          CALL DISMOI('F','NOM_LIGREL',CHIN,'CHAMP',IBID,LIGRE2,IER)
          IF (LIGRE2.NE.LIGREL) THEN
            CALL CODENT(I,'G',KNUM)
            LCHIN(I)='&&CALCUL.CHML.'//KNUM
C           -- ATTENTION, POUR CHLIGR, IL FAUT IACTIF=0
            CALL MECOEL(0)
            CALL CHLIGR(CHIN,LIGREL,NOMOP,NOMPAR,'V',LCHIN(I))
            CALL MECOEL(1)

            CALL JEEXIN(LCHIN(I)(1:19)//'.CELD',IBID)
            CHIN=LCHIN(I)
            OBJDES(1:19)=CHIN
            NBOBTR=NBOBTR+1
            ZK24(IAOBTR-1+NBOBTR)=LCHIN(I)//'.CELD'
            NBOBTR=NBOBTR+1
            IF (TYCH(1:2).EQ.'EL') THEN
              ZK24(IAOBTR-1+NBOBTR)=LCHIN(I)//'.CELK'
            ELSE
              ZK24(IAOBTR-1+NBOBTR)=LCHIN(I)//'.NOLI'
            ENDIF
            NBOBTR=NBOBTR+1
            ZK24(IAOBTR-1+NBOBTR)=LCHIN(I)//'.CELV'
          ENDIF
        ENDIF


        IGD=GRDEUR(NOMPAR)
        ZI(IACHII-1+11*(I-1)+1)=IGD

        NEC=NBEC(IGD)
        ZI(IACHII-1+11*(I-1)+2)=NEC

        TYPSCA=SCALAI(IGD)
        ZK8(IACHIK-1+2*(I-1)+2)=TYPSCA

        CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',IGD),'LONMAX',NCMPMX,K8BI)
        ZI(IACHII-1+11*(I-1)+3)=NCMPMX

        CALL JELIRA(OBJDES,'DOCU',IBID,K8BI)
        ZK8(IACHIK-1+2*(I-1)+1)=K8BI

        CALL JEVEUO(OBJDES,'L',DESC)
        ZI(IACHII-1+11*(I-1)+4)=DESC

C         -- SI LA GRANDEUR ASSOCIEE AU CHAMP N'EST PAS CELLE ASSOCIEE
C            AU PARAMETRE, ON ARRETE TOUT :
        IF (IGD.NE.ZI(DESC)) THEN
          CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',IGD),K8BI1)
          CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(DESC)),K8BI2)
          VALK(1)=CHIN
          VALK(2)=K8BI2
          VALK(3)=NOMPAR
          VALK(4)=K8BI1
          VALK(5)=NOMOP
          CALL U2MESK('F','CALCULEL2_29',5,VALK)
        ENDIF

        CALL JEEXIN(CHIN//'.VALE',IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(CHIN//'.VALE','L',III)
          ZI(IACHII-1+11*(I-1)+5)=III
        ENDIF

        CALL JEEXIN(CHIN//'.CELV',IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(CHIN//'.CELV','L',III)
          ZI(IACHII-1+11*(I-1)+5)=III
        ENDIF

C        -- POUR LES CARTES :
        IF (ZK8(IACHIK-1+2*(I-1)+1)(1:4).EQ.'CART') THEN

C           -- SI LA CARTE N'EST PAS CONSTANTE, ON L'ETEND:
          IF (.NOT.(ZI(DESC-1+2).EQ.1.AND.ZI(DESC-1+4).EQ.1)) THEN
            CALL ETENCA(CHIN,LIGREL,IRET)
            IF (IRET.GT.0)GOTO 70
            CALL JEEXIN(CHIN//'.PTMA',IRET)
            IF (IRET.GT.0) THEN
              CALL JEVEUO(CHIN//'.PTMA','L',III)
              ZI(IACHII-1+11*(I-1)+6)=III
              NBOBTR=NBOBTR+1
              ZK24(IAOBTR-1+NBOBTR)=CHIN//'.PTMA'
            ENDIF
            CALL JEEXIN(CHIN//'.PTMS',IRET)
            IF (IRET.GT.0) THEN
              CALL JEVEUO(CHIN//'.PTMS','L',III)
              ZI(IACHII-1+11*(I-1)+7)=III
              NBOBTR=NBOBTR+1
              ZK24(IAOBTR-1+NBOBTR)=CHIN//'.PTMS'
            ENDIF
          ENDIF
        ENDIF

C        -- POUR LES CHAM_NO A PROFIL_NOEUD:
        IF (ZK8(IACHIK-1+2*(I-1)+1)(1:4).EQ.'CHNO') THEN
          NUM=ZI(DESC-1+2)
          IF (NUM.GT.0) THEN
            CALL JEVEUO(CHIN//'.REFE','L',IAREFE)
            NOPRNO=ZK24(IAREFE-1+2)(1:19)//'.PRNO'
            CALL JEVEUO(JEXNUM(NOPRNO,1),'L',III)
            ZI(IACHII-1+11*(I-1)+8)=III
            CALL JEVEUO(LIGREL//'.NBNO','L',IANBNO)
            IF (ZI(IANBNO-1+1).GT.0) THEN
              CALL JENONU(JEXNOM(NOPRNO(1:19)//'.LILI',
     &                    LIGREL//'      '),JPROLI)
              IF (JPROLI.EQ.0) THEN
                ZI(IACHII-1+11*(I-1)+9)=ISNNEM()
              ELSE
                CALL JEVEUO(JEXNUM(NOPRNO,JPROLI),'L',III)
                ZI(IACHII-1+11*(I-1)+9)=III
              ENDIF
            ENDIF
            CALL JEVEUO(NOPRNO(1:19)//'.NUEQ','L',IANUEQ)
            ZI(IACHII-1+11*(I-1)+10)=IANUEQ
            ZI(IACHII-1+11*(I-1)+11)=1
          ENDIF
        ENDIF
   60 CONTINUE

      GOTO 80

C     -- SORTIE ERREUR:
   70 CONTINUE
      CHIN=LCHIN(I)
      CALL U2MESK('F','CALCULEL2_30',1,CHIN)

C     -- SORTIE NORMALE:
   80 CONTINUE

      END
