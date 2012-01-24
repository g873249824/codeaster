      SUBROUTINE MMMBCA(NOMA  ,SDDYNA,DEFICO,RESOCO,VALINC,
     &                  MMCVCA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/01/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8   NOMA
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  VALINC(*)
      CHARACTER*19  SDDYNA
      LOGICAL       MMCVCA
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE)
C
C ALGO. DES CONTRAINTES ACTIVES POUR LE CONTACT METHODE CONTINUE
C
C ----------------------------------------------------------------------
C
C
C  POUR LES POINTS POSTULES CONTACTANTS ON REGARDE LE SIGNE DE LAMBDA
C  POUR LES POINTS POSTULES NON CONTACTANTS ON REGARDE L'INTEPENETRATION
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  SDDYNA : SD POUR DYNAMIQUE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C OUT MMCVCA : INDICATEUR DE CONVERGENCE POUR BOUCLE DES
C              CONTRAINTES ACTIVES
C               .TRUE. SI LA BOUCLE DES CONTRAINTES ACTIVES A CONVERGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32  JEXNUM,JEXNOM
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
      INTEGER      NCMPU
      PARAMETER    (NCMPU=1)
C
      INTEGER      NCMPMX,GD,IBID
      CHARACTER*8  K8BID,NOMGD
      INTEGER      CFMMVD,ZTABF
      INTEGER      IFM,NIV
      INTEGER      CFDISI,MMINFI
      INTEGER      JDECME,POSMAE,NUMMAE,NUMMAM,POSNOE
      INTEGER      XSINI,XSEND,XS,XSNEW
      INTEGER      IZONE,IMAE,IPTC,IPTM,INOE
      INTEGER      NDIMG,NZOCO
      INTEGER      NTPC,NNE,NPTM,NBMAE
      REAL*8       KSIPR1,KSIPR2,KSIPC1,KSIPC2
      REAL*8       GEOMP(3),GEOME(3)
      REAL*8       VITPM(3),VITPE(3)
      REAL*8       NORM(3),TAU1(3),TAU2(3),MCON(9)
      REAL*8       COORME(27),FF(9)
      REAL*8       LAMBDC,COEFAC
      REAL*8       NOOR,R8PREM
      REAL*8       JEU,JEUVIT,DIST,JEUUSU
      CHARACTER*8  NOMMAI,ALIASE
      CHARACTER*19 CNSPLU,CNSLBD,NEWGEO
      CHARACTER*24 TABFIN,JEUSUP,FLIFLO,MDECOL,APJEU
      INTEGER      JTABF ,JJSUP ,JFLIP ,JMDECO,JAPJEU
      CHARACTER*19 OLDGEO,CHAVIT
      CHARACTER*19 DEPPLU,VITPLU,USUFIX
      INTEGER      JVALVX
      LOGICAL      LGLISS,LVITES,SCOTCH,LUSURE
      LOGICAL      NDYNLO,MMINFL,CFDISL,LGLINI,LVERI,LEXIG
      INTEGER      FLINBR,FLIPOI,FLIMAI,FLIMAX
      INTEGER      VALI(2)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... ACTIVATION/DESACTIVATION'
      ENDIF
C
C --- FONCTIONNALITES ACTIVEES
C
      LEXIG  = CFDISL(DEFICO,'EXIS_GLISSIERE')
C
C --- ACCES OBJETS
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      JEUSUP = RESOCO(1:14)//'.JSUPCO'
      APJEU  = RESOCO(1:14)//'.APJEU'
      CALL JEVEUO(TABFIN,'E',JTABF )
      CALL JEVEUO(JEUSUP,'E',JJSUP )
      CALL JEVEUO(APJEU ,'E',JAPJEU)
      ZTABF = CFMMVD('ZTABF')
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
C
C --- INDICATEUR DE DECOLLEMENT POUR LE THETA-SCHEMA
C
      MDECOL = RESOCO(1:14)//'.MDECOL'
      CALL JEVEUO(MDECOL,'E',JMDECO)
      SCOTCH = ZL(JMDECO+1-1)
C
C --- REACTUALISATION DE LA GEOMETRIE
C
      OLDGEO = NOMA//'.COORDO'
      NEWGEO = RESOCO(1:14)//'.NEWG'
      CALL VTGPLD(OLDGEO,1.0D0,DEPPLU,'V',NEWGEO)
C
C --- POUR LA FORMULATION VITESSE, ON CREEE UN CHAMP DE VITESSE
C
      LVITES = NDYNLO(SDDYNA,'FORMUL_VITE')
      CHAVIT = '&&MMMBCA.ACTUVIT'
      IF (LVITES) THEN
        CALL VTGPLK(OLDGEO,1.0D0,VITPLU,'V',CHAVIT)
      ENDIF
C
C --- INITIALISATIONS
C
      NDIMG  = CFDISI(DEFICO,'NDIM' )
      NZOCO  = CFDISI(DEFICO,'NZOCO')
      NTPC   = CFDISI(DEFICO,'NTPC')
      MMCVCA = .TRUE.
      POSNOE = 0
C
C --- ACCES SD POUR LE FLIP-FLOP
C
      FLINBR = 0
      FLIPOI = 0
      FLIMAI = 0
      FLIMAX = CFDISI(DEFICO,'FLIP_FLOP_IMAX')
      FLIFLO = RESOCO(1:14)//'.FLIPFLOP '
      CALL JEVEUO(FLIFLO,'E',JFLIP)
C
C --- TRANSFORMATION DEPPLU EN CHAM_NO_S ET REDUCTION SUR LES LAGRANGES
C
      CNSPLU = '&&MMMBCA.CNSPLU'
      CALL CNOCNS(DEPPLU,'V',CNSPLU)
      CNSLBD = '&&MMMBCA.CNSLBD'
      CALL CNSRED(CNSPLU,0,IBID,1,'LAGS_C','V',CNSLBD)
C
C --- ACCES USUFIX
C
      LUSURE = CFDISL(DEFICO,'EXIS_USURE')
      IF ( LUSURE) THEN
        NOMGD  = 'NEUT_R'
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
        CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K8BID)
        USUFIX = RESOCO(1:14)//'.USUF'
        CALL JEVEUO(USUFIX//'.VALE','L',JVALVX)
      END IF
C
C --- BOUCLE SUR LES ZONES
C
      IPTC   = 1
      DO 10 IZONE = 1,NZOCO
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C
        LGLISS = MMINFL(DEFICO,'GLISSIERE_ZONE'   ,IZONE )
        LUSURE = MMINFL(DEFICO,'USURE'            ,IZONE )
        CALL CFMMCO(DEFICO,RESOCO,IZONE,'COEF_AUGM_CONT','L',
     &              COEFAC)
        LVERI  = MMINFL(DEFICO,'VERIF' ,IZONE )
        NBMAE  = MMINFI(DEFICO,'NBMAE' ,IZONE )
        JDECME = MMINFI(DEFICO,'JDECME',IZONE )
C
C ----- MODE VERIF: ON SAUTE LES POINTS
C
        IF (LVERI) THEN
          GOTO 25
        ENDIF
C
C ----- BOUCLE SUR LES MAILLES ESCLAVES
C
        DO 20 IMAE = 1,NBMAE
C
C ------- NUMERO ABSOLU DE LA MAILLE ESCLAVE
C
          POSMAE = JDECME + IMAE
          CALL CFNUMM(DEFICO,1     ,POSMAE,NUMMAE)
C
C ------- COORDONNNEES DES NOEUDS DE LA MAILLE ESCLAVE
C
          CALL MCOMCE(NOMA  ,NEWGEO,NUMMAE,COORME,ALIASE,
     &                NNE   )
C
C ------- MULTIPLICATEURS DE CONTACT SUR LES NOEUDS ESCLAVES
C
          CALL CALLAM(DEFICO,CNSLBD,POSMAE,MCON  )
C
C ------- NOMBRE DE POINTS SUR LA MAILLE ESCLAVE
C
          CALL MMINFM(POSMAE,DEFICO,'NPTM',NPTM  )
C
C ------- BOUCLE SUR LES POINTS
C
          DO 30 IPTM = 1,NPTM
C
C --------- COORDONNEES ACTUALISEES DU POINT DE CONTACT
C
            KSIPC1    = ZR(JTABF+ZTABF*(IPTC-1)+3 )
            KSIPC2    = ZR(JTABF+ZTABF*(IPTC-1)+4 )
            CALL MCOPCE(NDIMG ,ALIASE,NNE   ,KSIPC1,KSIPC2,
     &                  COORME,GEOME)
C
C --------- COORDONNEES ACTUALISEES DE LA PROJECTION DU POINT DE CONTACT
C
            KSIPR1    = ZR(JTABF+ZTABF*(IPTC-1)+5 )
            KSIPR2    = ZR(JTABF+ZTABF*(IPTC-1)+6 )
            NUMMAM    = NINT(ZR(JTABF+ZTABF*(IPTC-1)+2))
            CALL MCOPCO(NOMA  ,NEWGEO,NDIMG ,NUMMAM,KSIPR1,
     &                  KSIPR2,GEOMP )
C
C --------- TANGENTES AU POINT DE CONTACT PROJETE SUR MAILLE MAITRE
C
            TAU1(1)   = ZR(JTABF+ZTABF*(IPTC-1)+7 )
            TAU1(2)   = ZR(JTABF+ZTABF*(IPTC-1)+8 )
            TAU1(3)   = ZR(JTABF+ZTABF*(IPTC-1)+9 )
            TAU2(1)   = ZR(JTABF+ZTABF*(IPTC-1)+10)
            TAU2(2)   = ZR(JTABF+ZTABF*(IPTC-1)+11)
            TAU2(3)   = ZR(JTABF+ZTABF*(IPTC-1)+12)
C
C --------- CALCUL DE LA NORMALE
C
            CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR  )
            IF (NOOR.LE.R8PREM()) THEN
              CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAM),NOMMAI)
              CALL U2MESG('F','CONTACT3_23',1,NOMMAI,0,0,3,GEOMP)
            ENDIF
C
C --------- INDICATEUR DE CONTACT (XS=0: PAS DE CONTACT)
C --------- ON SAUVE L'ETAT INITIAL DE CE POINT DANS XSINI
C
            XS     = NINT(ZR(JTABF+ZTABF*(IPTC-1)+22))
            XSINI  = XS
C
C --------- CALCUL DU JEU ACTUALISE AU POINT DE CONTACT
C
            CALL MMNEWJ(NDIMG ,GEOME ,GEOMP ,NORM  ,JEU   )
C
C --------- CALCUL DU JEU USE AU POINT DE CONTACT
C
            JEUUSU = 0.D0
            IF (LUSURE) THEN
              JEUUSU = -ABS(ZR(JVALVX+(IPTC-1)))
              JVALVX = JVALVX + (NCMPMX - NCMPU)
            ENDIF
C
C --------- CALCUL DU JEU FICTIF AU POINT DE CONTACT
C
            CALL CFDIST(DEFICO,'CONTINUE',IZONE ,POSNOE,POSMAE,
     &                  GEOME ,DIST      )
            ZR(JJSUP+IPTC-1)  = DIST
C
C --------- JEU TOTAL
C
            ZR(JAPJEU+IPTC-1) = JEU+DIST+JEUUSU
            JEU = ZR(JAPJEU+IPTC-1)
C
C --------- NOEUDS EXCLUS -> ON SORT DIRECT
C
            IF (ZR(JTABF+ZTABF*(IPTC-1)+18) .EQ. 1.D0) THEN
              ZR(JTABF+ZTABF*(IPTC-1)+22) = 0.D0
              XSINI  = 0
              GOTO 19
            END IF
C
C --------- MULTIPLICATEUR DE LAGRANGE DE CONTACT DU POINT
C
            LAMBDC = 0.D0
            CALL MMNONF(NDIMG ,NNE   ,ALIASE,KSIPC1,KSIPC2,
     &                  FF    )

            DO 61 INOE = 1,NNE
              LAMBDC = FF(INOE)*MCON(INOE) + LAMBDC
   61       CONTINUE
C
C --------- FORMULATION EN VITESSE
C
            IF (LVITES) THEN
C
C ----------- COORDONNEES ACTUALISEES DU POINT DE CONTACT ET DU PROJETE
C
              CALL MCOPCO(NOMA  ,CHAVIT,NDIMG ,NUMMAE,KSIPC1,
     &                    KSIPC2,VITPE )
              CALL MCOPCO(NOMA  ,CHAVIT,NDIMG ,NUMMAM,KSIPR1,
     &                    KSIPR2,VITPM )
C
C ----------- CALCUL DU GAP DES VITESSES NORMALES
C
              CALL MMMJEV(NDIMG ,NORM  ,VITPE ,VITPM, JEUVIT)

            ENDIF
C
C --------- GLISSIERE ACTIVEE
C
            LGLINI = NINT(ZR(JTABF+ZTABF*(IPTC-1)+17)).EQ.1
C
C --------- ALGORITHME DES CONTRAINTES ACTIVES (PC: POINT DE CONTACT)
C
            CALL MMALGO(XS    ,LVITES,LGLINI,JEU   ,JEUVIT,
     &                  LAMBDC,COEFAC,MMCVCA,SCOTCH,XSNEW )
            ZR(JTABF+ZTABF*(IPTC-1)+22) = XSNEW
C
C --------- TRAITEMENT DU FLIP_FLOP
C
            IF (FLIMAX .GE. 0) THEN
              XSEND  = NINT(ZR(JTABF+ZTABF*(IPTC-1)+22))
              IF (XSEND .NE. XSINI) THEN
                ZI(JFLIP+IPTC-1) = ZI(JFLIP+IPTC-1) + 1
              END IF
              IF (ZI(JFLIP+IPTC-1) .GT. FLINBR) THEN
                FLINBR = ZI(JFLIP+IPTC-1)
                FLIPOI = IPTC
                FLIMAI = NUMMAE
              ENDIF
            ENDIF
C
C --------- AFFICHAGE ETAT DU CONTACT
C
   19       CONTINUE
            IF (NIV.GE.2) THEN
              XS     = NINT(ZR(JTABF+ZTABF*(IPTC-1)+22))
              CALL MMIMP4(IFM   ,NOMA  ,NUMMAE,IPTM  ,XSINI ,
     &                    XS    ,LVITES,LGLISS,JEU   ,JEUVIT,
     &                    LAMBDC)
            ENDIF
C
C --------- LIAISON DE CONTACT SUIVANTE
C
            IPTC   = IPTC + 1
  30      CONTINUE
  20    CONTINUE
  25    CONTINUE
  10  CONTINUE
C
C --- GESTION DE LA GLISSIERE
C
      IF (MMCVCA.AND.LEXIG) THEN
        CALL MMGLIS(DEFICO,RESOCO)
      ENDIF
C
C --- SI FLIP-FLOP: ON FORCE LE PASSAGE A L'ITERATION SUIVANTE
C
      IF (FLIMAX .GT. 0) THEN
        IF (FLINBR .GE. FLIMAX) THEN
          CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',FLIMAI),NOMMAI)
          VALI(1) = FLINBR
          VALI(2) = FLIPOI
          CALL U2MESG('I','CONTACT3_28',1,NOMMAI,2,VALI,0,0.D0)
          MMCVCA = .TRUE.
        ENDIF
      ENDIF
C
      IF (MMCVCA) THEN
       CALL JERAZO(FLIFLO,NTPC  ,1)
      ENDIF
C
C --- SAUVEGARDE DECOLLEMENT POUR LE THETA-SCHEMA
C
      ZL(JMDECO+1-1) =  SCOTCH
C
      CALL JEDETR(NEWGEO)
      CALL JEDETR(CHAVIT)
      CALL DETRSD('CHAM_NO_S',CNSPLU)
      CALL DETRSD('CHAM_NO_S',CNSLBD)
C
      CALL JEDEMA()
      END
