      SUBROUTINE THACLM(NEWCAL,TYSD,KNUM,KCHA,PHENO,RESUCO,RESUC1,
     &                  CONCEP,NBORDR,MODELE,MATE,CARA,NCHAR,CTYP)
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C ------------------------------------------------------------------
C COMMANDE DE CALC_ELEM SPECIFIQUE A LA THERMIQUE ET A L'ACCOUSTIQUE
C ------------------------------------------------------------------
C IN  NEWCAL : TRUE POUR UN NOUVEAU CONCEPT RESULTAT, FALSE SINON
C IN  TYSD   : TYPE DU CONCEPT ATTACHE A RESUCO
C IN  KNUM   : NOM D'OBJET DES NUMERO D'ORDRE
C IN  KCHA   : NOM JEVEUX OU SONT STOCKEES LES CHARGES
C IN  PHENO  : PHENOMENE (MECA,THER,ACOU)
C IN  RESUCO : NOM DE CONCEPT RESULTAT
C IN  RESUC1 : NOM DE CONCEPT DE LA COMMANDE CALC_ELEM
C IN  CONCEP : TYPE DU CONCEPT ATTACHE A RESUC1
C IN  NBORDR : NOMBRE DE NUMERO D'ORDRE
C IN  MODELE : NOM DU MODELE
C IN  MATE   : NOM DU CHAMP MATERIAU
C IN  CARA   : NOM DU CHAMP DES CARACTERISTIQUES ELEMENTAIRES
C IN  NCHAR  : NOMBRE DE CHARGES
C IN  CTYP   : TYPE DE CHARGE
C ----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      INTEGER NBORDR,NCHAR
      INTEGER VALI
      CHARACTER*4 CTYP
      CHARACTER*8 RESUCO,RESUC1,MODELE,CARA
      CHARACTER*16 TYSD,PHENO,CONCEP
      CHARACTER*19 KNUM,KCHA
      CHARACTER*24 MATE
      LOGICAL NEWCAL
C
C     --- VARIABLES LOCALES ---
      INTEGER IAUX,JORDR,IORDR,JCHA,IRET1,IRET,BUFIN1,IAD,IOROLD
      INTEGER IFM,NIV,LINST,NIVEAU
      INTEGER NUORD,NH,NBAC,NBPA,JPA,NBPARA
      INTEGER IADIN,IADOU,IBID,IOPT,NBOPT
      INTEGER JOPT,J,III,L1,L2,L3,L4,L5,IERD,LREFE
      INTEGER LMAT,IE,LVALE,IOCC,NBCHRE,N1,L6,IPUIS,N2
      REAL*8 VALTHE,INSOLD,INST,COEF,PHASE
      CHARACTER*4 BUFCH,TYPE
      CHARACTER*6 NOMPRO
      PARAMETER(NOMPRO='THACLM')
      CHARACTER*8 MA,K8B
      CHARACTER*8 NOMA,PSOURC
      CHARACTER*16 OPTION,NOMCMD,K16B
      CHARACTER*19 CARTEF,NOMGDF,CARTEH,NOMGDH,CARTET,NOMGDT,CARTES
      CHARACTER*19 NOMGDS,LERES1,MASSE
      CHARACTER*19 CHDYNR,REFE
      CHARACTER*24 CHCARA(18),CHELEM,CHTEMM,CHTEMP
      CHARACTER*24 CHFLUM,CHSOUR,CHFLUP,CHERRE,CHERRN
      CHARACTER*24 CHGEOM,CHHARM,CHNUMC,NOMPAR
      CHARACTER*24 LESOPT,BLAN24
      CHARACTER*24 SOP,LIGREL,LIGRMO
      LOGICAL EXICAR,EVOL,EXIPOU,EXIPLA
      REAL*8 ZERO,UN
      PARAMETER(ZERO=0.D0,UN=1.D0)
      COMPLEX*16 CCOEF
      INTEGER      IARG

      CALL JEMARQ()
      CALL GETRES(K8B,K16B,NOMCMD)
      CALL JERECU('V')

C          '123456789012345678901234'
      BLAN24='                        '
      K8B='        '
      NH=0
      CHGEOM=BLAN24
      CHTEMP=BLAN24
      CHNUMC=BLAN24
      CHHARM=BLAN24
      CHDYNR=' '
      CHELEM=BLAN24
      SOP=BLAN24
      COEF=UN
      LESOPT='&&'//NOMPRO//'.LES_OPTION     '

      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

      CALL GETVTX ( ' ', 'OPTION', 1,IARG,0, K8B, N2 )
      NBOPT = -N2
      CALL WKVECT ( LESOPT, 'V V K16', NBOPT, JOPT )
      CALL GETVTX (' ', 'OPTION'  , 1,IARG, NBOPT, ZK16(JOPT), N2)
      CALL MODOPT(RESUCO,MODELE,LESOPT,NBOPT)
      CALL JEVEUO(LESOPT,'L',JOPT)

      CALL JEVEUO(KCHA,'L',JCHA)
      CALL JEVEUO(KNUM,'L',JORDR)

      IF (NEWCAL) THEN
        CALL RSCRSD('G',RESUC1,TYSD,NBORDR)
        CALL TITRE
      ENDIF

      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGRMO,IERD)

      CALL EXLIMA(' ',0,'V',MODELE,LIGREL)

      EXIPOU=.FALSE.
      CALL DISMOI('F','EXI_POUX',LIGREL,'LIGREL',IBID,K8B,IERD)
      IF (K8B(1:3).EQ.'OUI')EXIPOU=.TRUE.


C=======================================================================
C                   SPECIAL POUTRE A LA POUX (1)
C=======================================================================
      IF (EXIPOU) THEN
        IF (CONCEP.EQ.'MODE_ACOU') THEN
          REFE=RESUCO
          CALL JEVEUO(REFE//'.REFD','L',LREFE)
          MASSE=ZK24(LREFE+1)(1:19)
          CALL MTDSCR(MASSE)
          CALL JEVEUO(MASSE(1:19)//'.&INT','E',LMAT)
          CALL DISMOI('C','SUR_OPTION',MASSE,'MATR_ASSE',IBID,SOP,IE)
          CHDYNR='&&'//NOMPRO//'.M.GAMMA'
          CALL VTCREM(CHDYNR,MASSE,'V','R')
          CALL JEVEUO(CHDYNR//'.VALE','E',LVALE)
        ENDIF
C --- VERIFIE L'UNICITE DE LA CHARGE REPARTIE
        IOCC=0
        CALL COCHRE(ZK8(JCHA),NCHAR,NBCHRE,IOCC)
        IF (NBCHRE.GT.1) THEN
          CALL U2MESS('A','CALCULEL2_92')
          GOTO 190

        ENDIF
        DO 10 III=1,NCHAR
          CALL GETVID('EXCIT','FONC_MULT',III,IARG,1,K8B,L1)
          CALL GETVID('EXCIT','FONC_MULT_C',III,IARG,1,K8B,L2)
          CALL GETVR8('EXCIT','COEF_MULT',III,IARG,1,COEF,L3)
          CALL GETVC8('EXCIT','COEF_MULT_C',III,IARG,1,CCOEF,L4)
          CALL GETVR8('EXCIT','PHAS_DEG',III,IARG,1,PHASE,L5)
          CALL GETVIS('EXCIT','PUIS_PULS',III,IARG,1,IPUIS,L6)
          IF (L1.NE.0 .OR. L2.NE.0 .OR. L3.NE.0 .OR. L4.NE.0 .OR.
     &        L5.NE.0 .OR. L6.NE.0) THEN
            IF (NBCHRE.EQ.0) THEN
              CALL U2MESS('A','CALCULEL2_93')
            ENDIF
          ENDIF
   10   CONTINUE
      ENDIF

C=======================================================================
C     ON VERIFIE QUE CARA_ELEM, NIVE_COUCHE ET NUME_COUCHE ONT ETE
C     RENSEIGNES POUR LES COQUES
C=======================================================================
      EXIPLA=.FALSE.
      CALL DISMOI('F','EXI_COQ1D',MODELE,'MODELE',IBID,K8B,IERD)
      IF (K8B(1:3).EQ.'OUI')EXIPLA=.TRUE.
      CALL DISMOI('F','EXI_COQ3D',MODELE,'MODELE',IBID,K8B,IERD)
      IF (K8B(1:3).EQ.'OUI')EXIPLA=.TRUE.
      CALL DISMOI('F','EXI_PLAQUE',MODELE,'MODELE',IBID,K8B,IERD)
      IF (K8B(1:3).EQ.'OUI')EXIPLA=.TRUE.
      IF (EXIPLA) THEN
        CALL GETVID(' ','CARA_ELEM',1,IARG,1,K8B,N1)
        IF (N1.EQ.0 .AND. CARA.EQ.' ') THEN
          CALL U2MESS('A','CALCULEL2_94')
          GOTO 190

        ENDIF
      ENDIF

C=====================================================
C        PHENOMENE THERMIQUE
C====================================================

      IF (PHENO(1:4).EQ.'THER') THEN

        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IERD)
        CHNUMC='&&'//NOMPRO//'.NUMC'
        CALL MECHN2(NOMA,CHNUMC)

        LERES1=RESUC1


        IF (NEWCAL) THEN
          CALL RSCRSD('G',LERES1,TYSD,NBORDR)
          CALL TITRE
        ENDIF

C============ DEBUT DE LA BOUCLE SUR LES OPTIONS A CALCULER ============
        DO 120 IOPT=1,NBOPT
          OPTION=ZK16(JOPT+IOPT-1)
C
          CALL JEVEUO(KNUM,'L',JORDR)

C    -------------------------------------------------------------------
C    -- OPTIONS "FLUX_ELNO","FLUX_ELGA","SOUR_ELGA","DURT_ELNO"
C    -------------------------------------------------------------------
        CALL CALCOP(OPTION,LESOPT,RESUCO,RESUC1,KNUM,NBORDR,
     &              KCHA,NCHAR,CTYP,TYSD,NBCHRE,IOCC,SOP,IRET)
          IF (IRET.EQ.0)GOTO 120

          NUORD=ZI(JORDR)
          CALL MEDOM1(MODELE,MATE,CARA,KCHA,NCHAR,CTYP,RESUCO,NUORD)
          CALL JEVEUO(KCHA,'L',JCHA)
C
          CALL MECHAM(OPTION,MODELE,NCHAR,ZK8(JCHA),CARA,NH,CHGEOM,
     &                CHCARA,CHHARM,IRET)
          IF (IRET.NE.0)GOTO 190

C    ------------------------------------------------------------------
C    -- OPTION "ERTH_ELEM"
C    ------------------------------------------------------------------

          IF (OPTION.EQ.'ERTH_ELEM') THEN

C PAR DECRET EDA DU 22/08/01 ON SUPPRIME LE PARAMETRE NIVEAU ET ON LE
C FIXE A 2 (15 VALEURS DE PARAMETRES).
            NIVEAU=2

C RECUPERATION NIVEAU AFFICHAGE
            CALL INFNIV(IFM,NIV)

C VERIFICATION DU PERIMETRE D'UTILISATION
            CALL GETVTX(' ','TOUT',1,IARG,1,BUFCH,BUFIN1)
            IF (BUFCH.NE.'OUI') CALL U2MESK('A','CALCULEL4_97',1,OPTION)

C BOUCLE SUR LES INSTANTS CHOISIS PAR LE USER
            IOROLD=0
            INSOLD=ZERO
            CHTEMM=' '
            CHTEMP=' '
            CHFLUM=' '
            CHFLUP=' '

C PREPARATION DES CALCULS D'INDICATEUR (CONNECTIVITE INVERSE, CHARGE)
            CALL JEVEUO(KCHA,'L',JCHA)
            CALL RESTH2(MODELE,LIGRMO,ZK8(JCHA),NCHAR,MA,CARTEF,NOMGDF,
     &                  CARTEH,NOMGDH,CARTET,NOMGDT,CARTES,NOMGDS,
     &                  CHGEOM,CHSOUR,PSOURC)

            IF (NIV.GE.1) THEN
              WRITE (IFM,*)
              WRITE (IFM,*)
     &          '*********************************************'
              WRITE (IFM,*)'  CALCUL DE CARTES D''ERREURS EN RESIDU'
              WRITE (IFM,*)'       POUR LE PROBLEME THERMIQUE'
              WRITE (IFM,*)
              WRITE (IFM,*)'  OPTION DE CALCUL   ERTH_ELEM'
              WRITE (IFM,*)'  MODELE                ',MODELE
              WRITE (IFM,*)'  SD EVOL_THER DONNEE   ',RESUCO
              WRITE (IFM,*)'             RESULTAT   ',RESUC1
              WRITE (IFM,*)
              WRITE (IFM,*)
     &          '* CONTRAIREMENT AUX CALCULS THERMIQUES, POUR *'
              WRITE (IFM,*)
     &          '* UN TYPE DE CHARGEMENT DONNE, ON NE RETIENT *'
              WRITE (IFM,*)
     &          '* QUE LA DERNIERE OCCURENCE DE AFFE_CHAR_THER*'
              WRITE (IFM,*)'  LISTE DES CHARGEMENTS :'
              DO 20 BUFIN1=1,NCHAR
                WRITE (IFM,*)'                        ',
     &            ZK8(JCHA+BUFIN1-1)
   20         CONTINUE
              WRITE (IFM,*)'  CL DE FLUX RETENUE      ',NOMGDF
              WRITE (IFM,*)'  CL D''ECHANGE RETENUE    ',NOMGDH
              WRITE (IFM,*)'  SOURCE RETENUE          ',NOMGDS
              WRITE (IFM,*)'  MATERIAU PRIS EN COMPTE ',MATE(1:8)
              WRITE (IFM,*)'  NOMBRE DE NUMERO D''ORDRE ',NBORDR
            ENDIF

C BOUCLE SUR LES PAS DE TEMPS
            DO 30,IAUX=1,NBORDR
              CALL JEMARQ()
              CALL JERECU('V')
              IORDR=ZI(JORDR+IAUX-1)
              CALL MEDOM1(MODELE,MATE,CARA,KCHA,NCHAR,CTYP,RESUCO,IORDR)
              CALL MECARA(CARA,EXICAR,CHCARA)
C RECUPERATION DU PARM_THETA CORRESPONDANT A IORDR
              CALL JENONU(JEXNOM(RESUCO//'           .NOVA',
     &                    'PARM_THETA'),IAD)
              IF (IAD.EQ.0) THEN
                VALTHE=0.57D0
                CALL U2MESK('A','CALCULEL4_98',1,RESUCO)
              ELSE
                CALL RSADPA(RESUCO,'L',1,'PARM_THETA',IORDR,0,IAD,K8B)
                VALTHE=ZR(IAD)
                IF ((VALTHE.GT.1.D0) .OR. (VALTHE.LT.0.D0)) THEN
                  CALL U2MESK('F','INDICATEUR_5',1,RESUCO)
                ENDIF
              ENDIF
              IF (NIV.GE.1) THEN
                WRITE (IFM,*)'   PARAM-THETA/IORDR ',VALTHE,IORDR
                IF (IAUX.EQ.NBORDR) THEN
                  WRITE (IFM,*)'*************************************'//
     &              '*********'
                  WRITE (IFM,*)
                ENDIF
              ENDIF

C CALCUL DU CRITERE D'EVOLUTION LEVOL (TRUE=TRANSITOIRE)
C CAS PARTICULIER DE L'INSTANT INITIAL D'UN CALCUL TRANSITOIRE
C ON ESTIME SON ERREUR COMME EN STATIONNAIRE
              IF (IAUX.EQ.1) THEN
                EVOL=.FALSE.
              ELSE
                EVOL=.TRUE.
              ENDIF
              IF (EVOL .AND. (IORDR-1.NE.IOROLD))
     &          CALL U2MESS('A','CALCULEL2_78')

C RECUPERATION DU NOM DES CHAMP_GD = RESUCO('FLUX_ELNO',I)
C ET RESUCO('TEMP',I) POUR I=IORDR. POUR IORDR-1 ILS SONT STOCKES
C DANS CHFLUM/CHTEMM DEPUIS LA DERNIERE ITERATION.
C RESUCO = NOM USER DE LA SD DESIGNEE PAR LE MOT-CLE RESULTAT
              CALL RSEXC2(1,1,RESUCO,'TEMP',IORDR,CHTEMP,OPTION,IRET)
              IF (IRET.GT.0) THEN
                VALI=IORDR
                CALL U2MESG('F','CALCULEL6_46',0,' ',1,VALI,0,0.D0)
              ENDIF
              CALL RSEXC2(1,1,RESUCO,'FLUX_ELNO',IORDR,CHFLUP,
     &                    OPTION,IRET)
              IF (IRET.GT.0) THEN
                VALI=IORDR
                CALL U2MESG('F','CALCULEL6_47',0,' ',1,VALI,0,0.D0)
              ENDIF

C RECUPERATION DE L'INSTANT CORRESPONDANT A IORDR
              CALL RSADPA(RESUCO,'L',1,'INST',IORDR,0,LINST,K8B)
              INST=ZR(LINST)

C IMPRESSIONS NIVEAU 2 POUR DIAGNOSTIC...
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*)NOMPRO,' **********'
                WRITE (IFM,*)'EVOL/I/IORDR',EVOL,IAUX,IORDR
                WRITE (IFM,*)'INST/INSOLD',INST,INSOLD
                WRITE (IFM,*)'CHTEMM/CHTEMP',CHTEMM,' / ',CHTEMP
                WRITE (IFM,*)'CHFLUM/CHFLUP',CHFLUM,' / ',CHFLUP
              ENDIF

C RECUPERATION DU NOM DU CHAMP_GD = RESUC1('ERTH_ELEM',IORDR)
C RESUC1 = NOM USER DE LA SD CORRESPONDANT AU RESULTAT DE CALC_ELEM
              CALL RSEXC1(LERES1,OPTION,IORDR,CHELEM)
C PREPARATION DES DONNEES/LANCEMENT DU CALCUL DES INDICATEURS
              CALL RESTHE(LIGRMO,EVOL,CHTEMM,CHTEMP,CHFLUM,CHFLUP,MATE,
     &                    VALTHE,INSOLD,INST,CHELEM,NIVEAU,IFM,NIV,MA,
     &                    CARTEF,NOMGDF,CARTEH,NOMGDH,CARTET,NOMGDT,
     &                    CARTES,NOMGDS,CHGEOM,CHSOUR,PSOURC,IAUX)
C CALCUL DE L'ESTIMATEUR GLOBAL
              CALL ERGLTH(CHELEM,INST,NIVEAU,IORDR,RESUCO)
C NOTATION DE LA SD RESULTAT LERES1
              CALL RSNOCH(LERES1,OPTION,IORDR)

C INIT. POUR LE NUMERO D'ORDRE SUIVANT
              IF (NBORDR.NE.1 .AND. IAUX.NE.NBORDR) THEN
                CHTEMM=CHTEMP
                CHFLUM=CHFLUP
                IOROLD = IORDR
                INSOLD=INST
              ENDIF
              CALL JEDEMA()
   30       CONTINUE
C DESTRUCTION DES OBJETS JEVEUX VOLATILES
            CALL JEDETR(CARTEF//'.PTMA')
            CALL JEDETR(CARTEH//'.PTMA')
            CALL JEDETR(CARTET//'.PTMA')
            CALL JEDETR(CARTEF//'.PTMS')
            CALL JEDETR(CARTEH//'.PTMS')
            CALL JEDETR(CARTET//'.PTMS')

C    ------------------------------------------------------------------
C    -- OPTION "ERTH_ELNO"
C    ------------------------------------------------------------------

          ELSEIF (OPTION.EQ.'ERTH_ELNO') THEN

            DO 50,IAUX=1,NBORDR
              CALL JEMARQ()
              CALL JERECU('V')
              IORDR=ZI(JORDR+IAUX-1)
C RECUPERATION DU NOM DU CHAMP_GD = RESUCO('ERTH_ELEM',IORDR)
              CALL RSEXC2(1,1,RESUCO,'ERTH_ELEM',IORDR,CHERRE,OPTION,
     &                    IRET1)
              IF (IRET1.GT.0)GOTO 40
C RECUPERATION DU NOM DU CHAMP_GD = RESUC1('ERTH_ELNO',IORDR)
C RESUC1 = NOM USER DE LA SD CORRESPONDANT AU RESULTAT DE CALC_ELEM
              CALL RSEXC1(LERES1,OPTION,IORDR,CHERRN)
              CALL RESLGN(LIGRMO,OPTION,CHERRE,CHERRN)
C NOTATION DE LA SD RESULTAT LERES1
              CALL RSNOCH(LERES1,OPTION,IORDR)
   40         CONTINUE
              CALL JEDEMA()
   50       CONTINUE

C    ------------------------------------------------------------------
          ELSE
            CALL U2MESK('A','CALCULEL3_22',1,OPTION)
          ENDIF

  120   CONTINUE
C       ====== FIN DE LA BOUCLE SUR LES OPTIONS A CALCULER =======

        IF (NEWCAL) THEN
          NOMPAR='&&'//NOMPRO//'.NOMS_PARA '
          CALL RSNOPA(RESUCO,2,NOMPAR,NBAC,NBPA)
          NBPARA=NBAC+NBPA
          CALL JEVEUO(NOMPAR,'L',JPA)
          DO 140,IAUX=1,NBORDR
            IORDR=ZI(JORDR+IAUX-1)
            DO 130 J=1,NBPARA
              CALL RSADPA(RESUCO,'L',1,ZK16(JPA+J-1),IORDR,1,IADIN,TYPE)
              CALL RSADPA(LERES1,'E',1,ZK16(JPA+J-1),IORDR,1,IADOU,TYPE)
              IF (TYPE(1:1).EQ.'I') THEN
                ZI(IADOU)=ZI(IADIN)
              ELSEIF (TYPE(1:1).EQ.'R') THEN
                ZR(IADOU)=ZR(IADIN)
              ELSEIF (TYPE(1:1).EQ.'C') THEN
                ZC(IADOU)=ZC(IADIN)
              ELSEIF (TYPE(1:3).EQ.'K80') THEN
                ZK80(IADOU)=ZK80(IADIN)
              ELSEIF (TYPE(1:3).EQ.'K32') THEN
                ZK32(IADOU)=ZK32(IADIN)
              ELSEIF (TYPE(1:3).EQ.'K24') THEN
                ZK24(IADOU)=ZK24(IADIN)
              ELSEIF (TYPE(1:3).EQ.'K16') THEN
                ZK16(IADOU)=ZK16(IADIN)
              ELSEIF (TYPE(1:2).EQ.'K8') THEN
                ZK8(IADOU)=ZK8(IADIN)
              ENDIF
  130       CONTINUE
  140     CONTINUE
        ENDIF

C=====================================================
C        PHENOMENE ACOUSTIQUE
C====================================================

      ELSEIF (PHENO(1:4).EQ.'ACOU') THEN

        LERES1=RESUCO

C      ======== DEBUT DE LA BOUCLE SUR LES OPTIONS A CALCULER ======
        DO 180 IOPT=1,NBOPT

          OPTION=ZK16(JOPT+IOPT-1)
C
          CALL JEVEUO(KNUM,'L',JORDR)

C    -------------------------------------------------------------------
C    -- OPTIONS "PRAC_ELNO","INTE_ELNO"
C    -------------------------------------------------------------------
        CALL CALCOP(OPTION,LESOPT,RESUCO,RESUC1,KNUM,NBORDR,
     &              KCHA,NCHAR,CTYP,TYSD,NBCHRE,IOCC,SOP,IRET)
          IF (IRET.EQ.0)GOTO 180

  180   CONTINUE

      ENDIF

  190 CONTINUE

      CALL JEDEMA()

      END
