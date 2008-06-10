      SUBROUTINE ARLCP1(MAIL  ,NOMARL,TYPMAI,QUADRA,NOMC  ,
     &                  NOM1  ,NOM2  ,CINE1 ,CINE2 ,NORM  ,
     &                  TANG  ,LCARA ,DIME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C TOLE CRP_20
C
      IMPLICIT NONE
      CHARACTER*16 TYPMAI
      CHARACTER*8  MAIL
      CHARACTER*8  NOMARL
      CHARACTER*10 NOM1,NOM2,NOMC
      CHARACTER*10 NORM,TANG
      CHARACTER*8  CINE1,CINE2
      REAL*8       LCARA
      CHARACTER*10 QUADRA
      INTEGER      DIME

C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CALCUL DES MATRICES DE COUPLAGE ELEMENTAIRE ARLEQUIN
C ASSEMBLAGE DANS LES MATRICES ARLEQUIN MORSES
C ANCIENNE VERSION
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM DU MAILLAGE
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NOM1   : NOM DE LA SD DE STOCKAGE PREMIER GROUPE
C IN  NOM2   : NOM DE LA SD DE STOCKAGE SECOND GROUPE
C IN  NORM   : NOM DE LA SD POUR STOCKAGE DES NORMALES
C IN  TANG   : NOM DE L'OBJET TANGENTES LISSEES
C IN  TYPMAI : SD CONTENANT NOM DES TYPES ELEMENTS (&&CATA.NOMTM)
C IN  LCARA  : LONGUEUR CARACTERISTIQUE POUR TERME DE COUPLAGE (PONDERA
C              TION DES TERMES DE COUPLAGE)
C IN  NOMC   : NOM DE LA SD POUR LES MAILLES DE COLLAGE
C IN  QUADRA : SD DES QUADRATURES A CALCULER
C IN  CINE1  : CINEMATIQUE DU PREMIER GROUPE
C IN  CINE2  : CINEMATIQUE DU SECOND GROUPE
C IN  DIME   : DIMENSION DE L'ESPACE GLOBAL (2 OU 3)
C
C
C SD DE SORTIE
C NOM*.MORSE.VALE : VECTEUR DE VALEUR DE LA MATRICE ARLEQUIN MORSE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXATR
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
C
      INTEGER       NNM,NGM
      PARAMETER     (NNM = 27)
      PARAMETER     (NGM = 64)
C
      REAL*8        PRECCP
      INTEGER       ITEMCP
C
      REAL*8        ARLGER
      INTEGER       ARLGEI
C
      CHARACTER*24  NOMCOL
      CHARACTER*16  NOMMO1,NOMMO2
      CHARACTER*8   TMS,TM1,TM2,K8BID,NOMMA1,NOMMA2
      INTEGER       NFAM,NMA
      INTEGER       JCOLM,JNORM,JTANG
      INTEGER       VALI(2),IMA1,IMA2,NUMMA1,NUMMA2,FAMIL
      INTEGER       NG,NT,NC,NN1,NN2,NNS
      INTEGER       IAS,J,K
      INTEGER       IFAM,IMA
      INTEGER       IJ1(NNM*NNM),IJ2(NNM*NNM)
      REAL*8        WG(NGM),WJACG(NGM)
      REAL*8        FG(NGM*NNM),F1(NGM*NNM),F2(NGM*NNM)
      REAL*8        DF1(3*NGM*NNM),DF2(3*NGM*NNM),DFG(3*NGM*NNM)
      REAL*8        NO1(3*NNM),NO2(3*NNM)
      REAL*8        L1(10*NNM*NNM),L2(10*NNM*NNM)
      INTEGER       JCOOR,JCONX,JCUMU
      INTEGER       P,P1,P2,IRET
      INTEGER       JTRAVR,JTRAVI,JTRAVL
      INTEGER       JCINO
      INTEGER       JMINO1,JMCUM1,JMVAL1
      INTEGER       JMINO2,JMCUM2,JMVAL2
      REAL*8        H1,H2
      LOGICAL       LMATEL,LINCL1,LINCL2,LINCLU,LSSMAI
      INTEGER       JQNUME,JQTYPM,JQCUMU,JQMAMA,JQLIMA
      INTEGER       JQDEB,JQFIN
      INTEGER       IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- PARAMETRES DE NEWTON POUR PROJECTION POINT SUR MAILLE DE REFERENCE
C
      PRECCP = ARLGER(NOMARL,'PRECCP')
      ITEMCP = ARLGEI(NOMARL,'ITEMCP')
C
C --- INITIALISATION COLLAGE
C
      NOMCOL = NOMC(1:10)//'.MAILLE'
      CALL JEVEUO(NOMCOL(1:24),'E',JCOLM)
      CALL JELIRA(NOMCOL(1:24),'LONMAX',NMA,K8BID)
      DO 10 IMA = 1, NMA
        ZL(JCOLM-1+IMA) = .FALSE.
 10   CONTINUE
C
C --- NUMERO D'ASSEMBLAGE
C
      IAS = 0
      IF (CINE1.EQ.'COQUE   ') IAS = IOR(IAS,1)
      IF (CINE2.EQ.'COQUE   ') IAS = IOR(IAS,2)
C
C --- LECTURE DONNEES MAILLAGE
C
      CALL JEVEUO(MAIL(1:8)//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(MAIL(1:8)//'.CONNEX','L',JCONX)
      CALL JEVEUO(JEXATR(MAIL(1:8)//'.CONNEX','LONCUM'),'L',JCUMU)
C
C --- LECTURE DONNEES NORMALES ET TANGENTES
C
      IF (IAS.NE.0) THEN
        CALL JEVEUO(NORM,'L',JNORM)
        CALL JEVEUO(TANG,'L',JTANG)
      ELSE
        JNORM = JCOOR
      ENDIF
C
C --- LECTURE DONNEES QUADRATURES
C
      CALL JELIRA(QUADRA(1:10)//'.NUMERO','LONMAX',NFAM,K8BID)
      CALL JEVEUO(QUADRA(1:10)//'.NUMERO','L',JQNUME)
      CALL JEVEUO(QUADRA(1:10)//'.TYPEMA','L',JQTYPM)
      CALL JEVEUO(QUADRA(1:10)//'.LIMAMA','L',JQLIMA)
      CALL JEVEUO(JEXATR(QUADRA(1:10)//'.LIMAMA','LONCUM'),'L',JQCUMU)
      CALL JEVEUO(QUADRA(1:10)//'.MAMA'  ,'L',JQMAMA)
C
C --- LECTURE DONNEES ZONE COLLAGE
C
      CALL JEVEUO(NOMC(1:10)//'.INO','L',JCINO)
      CALL JELIRA(NOMC(1:10)//'.INO','LONMAX',NC,K8BID)
C
C --- LECTURE DONNEES MATRICES MORSES
C
      NOMMO1 = NOM1(1:10)//'.MORSE'
      CALL JEVEUO(NOMMO1(1:16)//'.INO','L',JMINO1)
      CALL JEVEUO(JEXATR(NOMMO1(1:16)//'.INO','LONCUM'),'L',JMCUM1)
      CALL JEVEUO(NOMMO1(1:16)//'.VALE','E',JMVAL1)
C
      NOMMO2 = NOM2(1:10)//'.MORSE'
      CALL JEVEUO(NOMMO2(1:16)//'.INO','L',JMINO2)
      CALL JEVEUO(JEXATR(NOMMO2(1:16)//'.INO','LONCUM'),'L',JMCUM2)
      CALL JEVEUO(NOMMO2(1:16)//'.VALE','E',JMVAL2)
C
C --- LECTURE DONNEES TEMPORAIRES ARLEQUIN
C
      CALL JEVEUO(NOMARL(1:8)//'.TRAVR','E',JTRAVR)
      CALL JEVEUO(NOMARL(1:8)//'.TRAVI','E',JTRAVI)
      CALL JEVEUO(NOMARL(1:8)//'.TRAVL','E',JTRAVL)
C
C --- INTEGRATION
C
      DO 30 IFAM = 1, NFAM
C
C --- TYPE DE LA MAILLE SUPPORT INTEGRATION
C
        TMS    = ZK8(JQTYPM+IFAM-1)
C
C --- FAMILLE D'INTEGRATION
C
        FAMIL  = ZI(JQNUME+IFAM-1)
C
C --- INFORMATIONS SUR LE SCHEMA D'INTEGRATION DE LA MAILLE SUPPORT
C
        CALL ARLSUI(TMS, FAMIL, NNS, NG ,WG ,FG    ,
     &              DFG)
C
C --- COUPLE DE MAILLES DE LA FAMILLE
C
        JQDEB   = ZI(JQCUMU+IFAM-1)
        JQFIN   = ZI(JQCUMU+IFAM)
C
        DO 50 J = JQDEB, JQFIN-1
C
C --- ACCES AU COUPLE
C
          IMA1 = ZI(JQMAMA + 2*(ZI(JQLIMA+J-1)-1))
          IMA2 = ZI(JQMAMA + 2*(ZI(JQLIMA+J-1)-1)+1)
C
C --- TYPE D'INTEGRATION
C
          CALL ARLTII(IMA1  ,IMA2   ,
     &                LINCL1,LINCL2,LINCLU,LSSMAI)
C
C --- INFOS ET COORD. SOMMETS DE LA MAILLE M1
C
          CALL ARLGRC(MAIL     ,TYPMAI   ,NOM1     ,DIME  ,IMA1 ,
     &                ZI(JCONX),ZI(JCUMU),ZR(JCOOR),ZR(JNORM),
     &                NUMMA1   ,NOMMA1   ,TM1      ,H1       ,
     &                NN1      ,NO1)
C
C --- INFOS ET COORD. SOMMETS DE LA MAILLE M2
C
          CALL ARLGRC(MAIL     ,TYPMAI   ,NOM2     ,DIME  ,IMA2 ,
     &                ZI(JCONX),ZI(JCUMU),ZR(JCOOR),ZR(JNORM),
     &                NUMMA2   ,NOMMA2   ,TM2      ,H2       ,
     &                NN2      ,NO2)
C
C --- MISE A ZERO DES MATRICES DE COUPLAGE ELEMENTAIRES
C
          DO 60 K = 1, 10*NNM*NNM
            L1(K) = 0.D0
            L2(K) = 0.D0
 60       CONTINUE
C
          LMATEL = .TRUE.
C
C --- INTEGRATION STANDARD
C
          IF (LINCLU) THEN
C
C --- INTEGRATION SUR MA1
C
            IF (LINCL1) THEN
C
C --- FCT. FORME ET DERIV FCT. FORME
C
              CALL INTINC(DIME  ,PRECCP,ITEMCP,NNS   ,
     &                    WG    ,NG    ,FG    ,DFG   ,
     &                    NN1   ,NN2   ,NO1   ,NO2   ,
     &                    TM2   ,H2    ,F2    ,
     &                    WJACG ,DF1   ,DF2   ,IRET)

              IF (IRET.NE.0) THEN
                GOTO 140
              ENDIF
C
C --- MATRICE ELEMENTAIRE
C
              CALL ARLTE(DIME  ,NG    ,WJACG    ,
     &                   FG    ,DF1   ,NN1   ,L1    ,
     &                   F2    ,DF2   ,NN2   ,L2)
C
C --- INTEGRATION SUR MA2
C
            ELSEIF (LINCL2) THEN
C
C --- FCT. FORME ET DERIV FCT. FORME
C
              CALL INTINC(DIME  ,PRECCP,ITEMCP,NNS   ,
     &                    WG    ,NG    ,FG    ,DFG   ,
     &                    NN2   ,NN1   ,NO2   ,NO1   ,
     &                    TM1   ,H1    ,F1    ,
     &                    WJACG ,DF2   ,DF1   ,IRET)

              IF (IRET.NE.0) THEN
                GOTO 140
              ENDIF
C
C --- MATRICE ELEMENTAIRE
C
             CALL ARLTE(DIME  ,NG    ,WJACG    ,
     &                  F1    ,DF1   ,NN1   ,L1    ,
     &                  FG    ,DF2   ,NN2   ,L2)

            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF

          ELSEIF (LSSMAI) THEN
C
C --- CALCUL DE L'INTERSECTION
C
            CALL INTMAM(DIME  ,NOMARL,
     &                  NOMMA1,TM1   ,NO1,NN1,H1,
     &                  NOMMA2,TM2   ,NO2,NN2,H2,
     &                  ZR(JTRAVR),ZI(JTRAVI),ZL(JTRAVL),NT)

            LMATEL = NT.GT.0
            P      = JTRAVI

            DO 90 K = 1, NT
C
C --- INTEGRATION PAR SOUS-MAILLES
C
              CALL INTSMA(DIME  ,PRECCP,ITEMCP,
     &                    TMS   ,WG    ,NG    ,FG    ,
     &                    ZR(JTRAVR)   ,ZI(P) ,
     &                    TM1   ,NO1   ,NN1   ,H1    ,F1    ,DF1   ,
     &                    TM2   ,NO2   ,NN2   ,H2    ,F2    ,DF2   ,
     &                    WJACG    ,IRET)
C
C --- MATRICE ELEMENTAIRE
C
              CALL ARLTE(DIME  ,NG    ,WJACG    ,
     &                   F1    ,DF1   ,NN1   ,L1    ,
     &                   F2    ,DF2   ,NN2   ,L2)

              P = P + DIME + 1
 90         CONTINUE
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
C
C --- DEBOGUAGE
C
          IF (NIV.GE.2) THEN
            CALL ARLTIM(6     ,DIME  ,NNM   ,LINCLU,LINCL1,
     &                  NUMMA1,NUMMA2,L1    ,L2    ,TM1,
     &                  TM2   ,H1    ,H2    ,NG    ,NT)
          ENDIF
C
C --- SI PAS DE MATRICE ELEM. CALCULEES -> ON N'ASSEMBLE PAS
C
          IF (.NOT.LMATEL) THEN
            GOTO 50
          ENDIF
C
C --- ASSEMBLAGE DES MATRICES ELEMENTAIRES
C
          ZL(JCOLM+NUMMA1-1) = .TRUE.
          ZL(JCOLM+NUMMA2-1) = .TRUE.

          CALL ARLAS0(NUMMA1  ,NUMMA1  ,ZI(JCONX) ,ZI(JCUMU),
     &                ZI(JCINO),NC    ,ZI(JMINO1) ,ZI(JMCUM1),
     &                IJ1)
          CALL ARLAS0(NUMMA1  ,NUMMA2  ,ZI(JCONX) ,ZI(JCUMU),
     &                ZI(JCINO),NC    ,ZI(JMINO2) ,ZI(JMCUM2),
     &                IJ2)

          GOTO (110,120,130) IAS

          CALL ARLAS1(DIME  ,LCARA ,NN1   ,NN1   ,IJ1   ,
     &                L1    ,ZR(JMVAL1))
          CALL ARLAS1(DIME  ,LCARA ,NN1   ,NN2   ,IJ2   ,
     &                L2    ,ZR(JMVAL2))

          GOTO 50

 110      CONTINUE

          P1 = JCONX-1+ZI(JCUMU-1+NUMMA1)

          CALL ARLAS4(DIME  ,LCARA ,NN1   ,NN1      ,IJ1 ,
     &                ZI(P1),ZI(P1),ZR(JNORM),ZR(JTANG),L1  ,
     &                ZR(JMVAL1))
          CALL ARLAS2(DIME  ,LCARA ,NN1   ,NN2   ,IJ2   ,
     &                ZI(P1),ZR(JTANG),L2,ZR(JMVAL2))
          GOTO 50

 120      CONTINUE

          P2 = JCONX-1+ZI(JCUMU-1+NUMMA2)

          CALL ARLAS1(DIME  ,LCARA ,NN1   ,NN1   ,IJ1   ,
     &                L1    ,ZR(JMVAL1))
          CALL ARLAS3(DIME  ,LCARA ,NN1   ,NN2   ,IJ2   ,
     &                ZI(P2),ZR(JNORM),L2,ZR(JMVAL2))
          GOTO 50

 130      CONTINUE

          P1 = JCONX-1+ZI(JCUMU-1+NUMMA1)
          P2 = JCONX-1+ZI(JCUMU-1+NUMMA2)

          CALL ARLAS4(DIME  ,LCARA ,NN1      ,NN1      ,IJ1 ,
     &                ZI(P1),ZI(P1),ZR(JNORM),ZR(JTANG),L1  ,
     &                ZR(JMVAL1))

          CALL ARLAS4(DIME  ,LCARA ,NN1      ,NN2      ,IJ2 ,
     &                ZI(P1),ZI(P2),ZR(JNORM),ZR(JTANG),L2  ,
     &                ZR(JMVAL2))

 50     CONTINUE

 30   CONTINUE

      IRET = 0

 140  CONTINUE
C
      IF (IRET.NE.0) THEN
        VALI(1) = NUMMA1
        VALI(2) = NUMMA2
        CALL U2MESI('F','ARLEQUIN_16',2,VALI)
      ENDIF
C
      CALL JEDEMA()

      END
