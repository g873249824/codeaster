      SUBROUTINE OP0151(IER)
        IMPLICIT REAL*8 (A-H,O-Z)
        INTEGER         IER
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/12/2006   AUTEUR PELLET J.PELLET 
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
C       ----------------------------------------------------------------
C       C A L C _ F A T I G U E
C       ----------------------------------------------------------------
C       CREATION D UN CHAM_ELEM D ISODOMMAGE A LA FATIGUE
C       D UN MATERIAU SOUMIS A UN CYCLAGE EN CONTRAINTES
C       A PARTIR D'UN CHAM_ELEM DE GRANDEUR 1D EQUIVALENTE
C       ----------------------------------------------------------------
C       ATTENTION : LE CHAM_ELEM EN SORTIE EST CONSTRUIT ARTIFICIELEMENT
C                   SANS PASSER PAR LA ROUTINE CALCUL
C                   A PARTIR DU CHAM_ELEM DANS LA SD RESULTAT
C                   DE TYPE EVOL_NOLI , EVOL_ELAS , DYNA_TRANS, CREE
C                   PAR CALC_ELEM (OPTIONS SIGM(EPSI)_EQUI_ELNO(ELGA))
C                   LA COHERENCE DU CHAMP EST DONC LIEE A CE DERNIER
C                   (MEMES ELEMENTS/GREL POUR LE CALCUL DE L OPTION ...)
C
C       IMPLANTE  : ACTUELLEMENT  :
C                  - CALCUL DU DOMMAGE A PARTIR DE   = /CONTRAINTE
C                                                      /DEFORMATION
C                  - POINTS DE CALCUL DU DOMMAGE     = /NOEUDS
C                                                      /POINTS DE GAUSS
C                  - COMPOSANTES GRANDEUR EQUIVALENTE= VMIS_SG....
C                  - METHODE  D'EXTRACTION DES PICS  = RAINFLOW
C                  - METHODE  DE COMPTAGE DES CYCLES = RAINFLOW
C                  - METHODE  DE CALCUL   DU DOMMAGE = /WOHLER
C                                                      /MANSON_COFFIN
C                                                      /TAHERI_MANSON
C                                                      /TAHERI_MIXTE
C                  - OPTIONS OUT                     = /DOMA_ELNO_SIGM
C                                                      /DOMA_ELGA_SIGM
C                                                      /DOMA_ELGA_EPSI
C                                                      /DOMA_ELNO_EPSI
C                                                      /DOMA_ELGA_EPME
C                                                      /DOMA_ELNO_EPME
C       ----------------------------------------------------------------
C       ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------
        INTEGER          ZI
        COMMON  /IVARJE/ ZI(1)
        REAL*8           ZR
        COMMON  /RVARJE/ ZR(1)
        COMPLEX*16       ZC
        COMMON  /CVARJE/ ZC(1)
        LOGICAL          ZL
        COMMON  /LVARJE/ ZL(1)
        CHARACTER*8      ZK8
        CHARACTER*16            ZK16
        CHARACTER*24                    ZK24
        CHARACTER*32                            ZK32
        CHARACTER*80                                    ZK80
        COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
        CHARACTER*32       JEXNOM,JEXNUM
C       ---------------------------------------------------------------
        CHARACTER*2     CODRET,FB,CODWO,CODBA,CODHS,CODMA
        CHARACTER*8     NOMU,NOMRES,NOMMAI,K8B,NOMMAT
        CHARACTER*8     NOMFON,NOMNAP,CARA
        CHARACTER*16    CONCEP,CMD,PHENO,PHENOM,TYPCAL,NOMCRI,NOMMET
        CHARACTER*16    PROAXE,NOMSYM,TYPCHA,NOMOPT,NOMGDE,NOMTE
        CHARACTER*16    MEXPIC,MCOMPT,MDOMAG
        CHARACTER*16    TYPEQ,TYPOI,TYPDG,OPTION
        CHARACTER*19    NOMSD,CHELEM,CHELRS,LIGREL
        CHARACTER*24    NOMLOC
        CHARACTER*24 VALK(3)
C
        CHARACTER*72    KVAL
        COMPLEX*16      CVAL
        INTEGER         IVAL,NVAL,IMPR,IFR,IFM,NGM
        INTEGER         NBPT,NBORD,NBCMP,NUMCMP(6),NTCMP
        INTEGER         IVDMG,NUMSYM
        INTEGER         NUMLOC,NUMGD,NBGREL,DEBUG1,IMOLO1
C
C       ---------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
C
      NOMFON = ' '
      NOMNAP = ' '
C
C ----- DONNEES UTILISATEUR
C
      CALL GETRES(NOMU,CONCEP,CMD)
C
C ---   TYPE DE CALCUL
      CALL GETVTX(' ','TYPE_CALCUL',1,1,1,TYPCAL,NVAL)
      IF (TYPCAL(1:13) .EQ. 'FATIGUE_MULTI') THEN
C
C ---   TYPE DU CHARGEMENT APPLIQUE (PERIODIQUE OU NON_PERIODIQUE)
C
        CALL GETVTX(' ','TYPE_CHARGE',1,1,1,TYPCHA,NVAL)
C
C ---   NOM DE L'OPTION (CALCUL AUX POINTS DE GAUSS OU AUX NOEUDS
C                        CHAM_NO)
        CALL GETVTX(' ','OPTION',1,1,1,NOMOPT,NVAL)
C
C ---   STRUCTURE RESULTAT CONTENANT LES CHAM_ELEMS DE SIGMA
C       OU LES CHAM_NOS DE SIGMA
        CALL GETVID(' ','RESULTAT',1,1,1,NOMRES,NVAL)
        NOMSD = NOMRES
C
C ---   NOM DU CRITERE
        CALL GETVTX(' ','CRITERE',1,1,1,NOMCRI,NVAL)
C
C ---   NOM DE LA METHODE PERMETTANT DE DETERMINER LE CERCLE CIRCONSCRIT
        CALL GETVTX(' ','METHODE',1,1,1,NOMMET,NVAL)
        IF (NVAL .EQ. 0) THEN
          NOMMET = '        '
        ENDIF
C
C ---   PROJECTION SUR UN AXE OU SUR DEUX AXES
C       (CHARGEMENT NON_PERIODIQUE UNIQUEMENT)
        CALL GETVTX(' ','PROJECTION',1,1,1,PROAXE,NVAL)
        IF (NVAL .EQ. 0) THEN
          PROAXE = '        '
        ENDIF
C
C ---   NOM DU MAILLAGE
        CALL GETVID(' ','MAILLAGE',1,1,1,NOMMAI,NVAL)
        IF (NVAL .EQ. 0) THEN
          NOMMAI = '        '
        ENDIF
C
        IF (NOMOPT .EQ. 'DOMA_ELGA') THEN
C
C ---   CONSTRUCTION DES PAQUETS DE MAILLES
          CALL PAQMAI(NOMRES, NOMU, NOMMAI, NOMMET, NOMCRI,
     &                TYPCHA, PROAXE)
C
        ELSEIF (NOMOPT .EQ. 'DOMA_NOEUD') THEN
C
C ---   CONSTRUCTION DES PAQUETS DE NOEUDS
          CALL PAQNOE(NOMRES, NOMU, NOMMAI, NOMMET, NOMCRI,
     &                TYPCHA, PROAXE)
        ENDIF
C
        GOTO 7777
      ENDIF
C
C ---   STRUCTURE RESULTAT CONTENANT LES CHAM_ELEMS DE SIGMA EQUIVALENT
      CALL GETVID('HISTOIRE','RESULTAT',1,1,1,NOMRES,NVAL)
      NOMSD = NOMRES
C
C ---   CHAMP : NOM DE L'OPTION RESULTANTE
C   'DOMA_ELNO_SIGM'/'DOMA_ELGA_SIGM'/'DOMA_ELNO_EPSI'/'DOMA_ELGA_EPSI
C   'DOMA_ELNO_EPME'/'DOMA_ELGA_EPME'
C
      CALL GETVTX(' ','OPTION',1,1,1,NOMOPT,NVAL)
C
C ---   NOM DE LA METHODE DE CALCUL DU DOMMAGE
C
      CALL GETVTX(' ','DOMMAGE',1,1,1,MDOMAG,NVAL)
      CALL GETVID(' ','MATER',1,1,1,NOMMAT,NVAL)

      IF(MDOMAG.EQ.'WOHLER') THEN
        IF( NOMOPT(11:14).NE.'SIGM' ) THEN
          CALL U2MESK('F','PREPOST3_96',1,NOMOPT)
        ENDIF
        PHENO = 'FATIGUE'
        CALL RCCOME (NOMMAT,PHENO,PHENOM,CODRET)
        IF(CODRET.EQ.'NO') CALL U2MESS('F','PREPOST_46')
        CARA = 'WOHLER'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODWO)
        CARA = 'A_BASQUI'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODBA)
        CARA = 'A0'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODHS)
        IF(CODWO.NE.'OK'.AND.CODBA.NE.'OK'.AND.CODHS.NE.'OK')
     &     CALL U2MESS('F','PREPOST3_97')
      ELSEIF(MDOMAG.EQ.'MANSON_COFFIN') THEN
        IF(NOMOPT(11:14).NE.'EPSI'.AND.NOMOPT(11:14).NE.'EPME') THEN
          CALL U2MESK('F','PREPOST3_98',1,NOMOPT)
        ENDIF
        PHENO = 'FATIGUE'
        CALL RCCOME (NOMMAT,PHENO,PHENOM,CODRET)
        IF(CODRET.EQ.'NO') CALL U2MESS('F','PREPOST_46')
        CARA = 'MANSON_C'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODMA)
        IF(CODMA.NE.'OK')
     &    CALL U2MESS('F','PREPOST3_99')
      ELSEIF(MDOMAG.EQ.'TAHERI_MANSON') THEN
        IF(NOMOPT(11:14).NE.'EPSI'.AND.NOMOPT(11:14).NE.'EPME') THEN
          CALL U2MESK('F','PREPOST4_1',1,NOMOPT)
        ENDIF
        PHENO = 'FATIGUE'
        CALL RCCOME (NOMMAT,PHENO,PHENOM,CODRET)
        IF(CODRET.EQ.'NO') CALL U2MESS('F','PREPOST_46')
        CARA = 'MANSON_C'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODMA)
        IF(CODMA.NE.'OK')
     &     CALL U2MESS('F','PREPOST3_99')
        CALL GETVID(' ','TAHERI_NAPPE',1,1,1,NOMNAP,NVAL)
        IF(NVAL.EQ.0) THEN
          CALL U2MESS('F','PREPOST4_2')
        ENDIF
        CALL GETVID(' ','TAHERI_FONC',1,1,1,NOMFON,NVAL)
          IF(NVAL.EQ.0) THEN
            CALL U2MESS('F','PREPOST4_3')
          ENDIF
      ELSEIF(MDOMAG.EQ.'TAHERI_MIXTE') THEN
        IF(NOMOPT(11:14).NE.'EPSI'.AND.NOMOPT(11:14).NE.'EPME') THEN
          CALL U2MESK('F','PREPOST4_4',1,NOMOPT)
        ENDIF
        PHENO = 'FATIGUE'
        CALL RCCOME (NOMMAT,PHENO,PHENOM,CODRET)
        IF(CODRET.EQ.'NO') CALL U2MESS('F','PREPOST_46')
        CARA = 'MANSON_C'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODMA)
        IF(CODMA.NE.'OK')
     &     CALL U2MESS('F','PREPOST3_99')
        CARA = 'WOHLER'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODWO)
        CARA = 'A_BASQUI'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODBA)
        CARA = 'A0'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODHS)
        IF(CODWO.NE.'OK'.AND.CODBA.NE.'OK'.AND.CODHS.NE.'OK')
     &     CALL U2MESS('F','PREPOST3_97')
        CALL GETVID(' ','TAHERI_NAPPE',1,1,1,NOMNAP,NVAL)
        IF(NVAL.EQ.0) THEN
          CALL U2MESS('F','PREPOST4_2')
        ENDIF
C
      ENDIF
C
C       NOM DE LA GRANDEUR EQUIVALENTE
C
      CALL GETVTX('HISTOIRE','EQUI_GD',1,1,1,NOMGDE,NVAL)
C
C ---   IMPRESSIONS
      CALL GETVIS(' ' ,'INFO',1,1,1,IMPR,NVAL)
C
C
C ---   NOMBRE DE NUMEROS D ORDRE DE POINTS (NOEUDS/PG) DE CMPS ...
C       ---------------------------------------------------------------
C
C       NOM SYMBOLIQUE DE L OPTION IN UTILISEE (GRANDEUR EQUIVALENTE)
C       (EQUI_ELNO_SIGM  EQUI_ELGA_SIGM  EQUI_ELGA_EPSI EQUI_ELNO_EPSI
C        EQUI_ELNO_EPME  EQUI_ELGA_EPME  )
C       ET NOMBRE TOTAL DE COMPOSANTES DE CETTE OPTION
C
      NOMSYM = 'EQUI_'//NOMOPT(6:14)
C
      IF(NOMOPT(11:14).EQ.'SIGM') THEN
        NTCMP = 6
      ELSEIF(NOMOPT(11:14).EQ.'EPSI') THEN
        NTCMP = 5
      ELSEIF(NOMOPT(11:14).EQ.'EPME') THEN
        NTCMP = 5
      ENDIF
C
C       TYPE DE GRANDEUR EQUIVALENTE UTILISEE LE POUR CALCUL DU DOMMAGE
C       ET NOMBRE DE COMPOSANTES DE CETTE GRANDEUR
C       VMIS_SIG   = CMP NUMERO 6       DE  L OPTION EQUI_...._SIGM
C       INVA_2_SG  = CMP NUMERO 5       DE  L OPTION EQUI_...._EPSI
C       INVA_2_SG  = CMP NUMERO 5       DE  L OPTION EQUI_...._EPME
C
      IF(NOMGDE(1:7).EQ.'VMIS_SG') THEN
        NUMCMP(1) = 6
        NBCMP     = 1
      ELSEIF(NOMGDE(1:9).EQ.'INVA_2_SG') THEN
        NUMCMP(1) = 5
        NBCMP     = 1
      ENDIF
C
      CALL JELIRA(NOMSD//'.ORDR','LONUTI',NBORD,K8B)
C
      CALL JENONU(JEXNOM(NOMSD//'.DESC',NOMSYM),NUMSYM)
        IF(NUMSYM.EQ.0) THEN
           VALK(1) = NOMSYM
           VALK(2) = NOMSD
           CALL U2MESK('F','PREPOST4_5', 2 ,VALK)
        ENDIF
      CALL JEVEUO(JEXNUM(NOMSD//'.TACH',NUMSYM),'L',IVCH)
      CHELRS = ZK24(IVCH)(1:19)
      IF(CHELRS.EQ.' ') THEN
         VALK(1) = CHELRS
         VALK(2) = NOMSYM
         VALK(3) = NOMSD
         CALL U2MESK('F','PREPOST4_6', 3 ,VALK)
      ENDIF
      CALL JEVEUO ( CHELRS//'.CELK','L',JCELK )
      LIGREL=ZK24(JCELK-1+1)
      CALL JELIRA ( CHELRS//'.CELV','LONMAX',NVAL,K8B )
C
C  -      IL Y A NTCMP COMPOSANTES DANS L OPTION XXXX_EQUI_YYYY
      NBPT = NVAL / NTCMP
C
      IF(IMPR.GE.2) THEN
        CALL UTSAUT()
        CALL UTDEBM('I','OP0151','PARAMETRES DE CALCUL DU DOMMAGE')
        CALL UTIMPI('L','NOMBRE DE NUMEROS D''ORDRE  = ',1,NBORD)
        CALL UTIMPI('L','NOMBRE DE POINTS DE CALCUL = ',1,NBPT)
      ENDIF
C
C ----- CALCUL DU VECTEUR DOMMAGE EN CHAQUE NOEUD/PG
C       ----------------------------------------------------------------
C
      CALL WKVECT( '&&OP0151.DOMMAGE' , 'V V R', NBPT , IVDMG )
C
      MEXPIC = 'RAINFLOW'
      MCOMPT = 'RAINFLOW'
      IF(MDOMAG(1:6).EQ.'TAHERI') MCOMPT = 'TAHERI'
C
      IF(IMPR.GE.2) THEN
        TYPEQ = NOMGDE
        IF(NOMOPT(11:14).EQ.'SIGM') TYPDG = 'CONTRAINTE'
        IF(NOMOPT(11:14).EQ.'EPSI') TYPDG = 'DEFORMATION'
        IF(NOMOPT(11:14).EQ.'EPME') TYPDG = 'DEFORMATION'
        IF(NOMOPT(6:9).EQ.'ELNO')   TYPOI = 'NOEUDS'
        IF(NOMOPT(6:9).EQ.'ELGA')   TYPOI = 'POINTS DE GAUSS'
        CALL UTIMPK('L','CALCUL     DU      DOMMAGE      EN',1,TYPDG)
        CALL UTIMPK('L','POINTS  DE   CALCUL  DU    DOMMAGE',1,TYPOI)
        CALL UTIMPK('L','COMPOSANTE(S) GRANDEUR EQUIVALENTE',1,TYPEQ)
        CALL UTIMPK('L','METHODE  D EXTRACTION  DES    PICS',1,MEXPIC)
        CALL UTIMPK('L','METHODE  DE  COMPTAGE  DES  CYCLES',1,MCOMPT)
        CALL UTIMPK('L','METHODE  DE  CALCUL    DU  DOMMAGE',1,MDOMAG)
        CALL UTFINM()
      ENDIF
C
      CALL FGVDMG(NOMSYM,NOMSD,NOMMAT,NOMNAP,NOMFON,MEXPIC,MCOMPT,
     &            MDOMAG,NBORD,NBPT,NTCMP,NBCMP,NUMCMP,
     &            IMPR,ZR(IVDMG))
C
      IF(IMPR.GE.2) THEN
        IFM = IUNIFI('MESSAGE')
        CALL JEIMPO(IFM,'&&OP0151.DOMMAGE',' ','DOMMAGE')
      ENDIF
C
C ----- TRANSFORMATION DU VECTEUR DOMMAGE EN UN VRAI CHAM_ELEM
C       ----------------------------------------------------------------
C       ON ALLOUE LE CHAM_ELEM AVEC LA ROUTINE ALCHML
C       PUIS ON RECOPIE DANS .CELV LES VALEURS CALCULEES
C
      CHELEM = NOMU

      OPTION='TOU_INI_'//NOMOPT(6:9)
      CALL ALCHML(LIGREL,OPTION,'PDOMMAG','G',CHELEM,IRET,' ')
      IF (IRET.NE.0) CALL U2MESS('F','CALCULEL_2')


      CALL JEVEUO(CHELEM//'.CELV','E',JCELV)
      CALL JELIRA(CHELEM//'.CELV','LONMAX',IBID,K8B)
      IF (IBID.NE.NBPT) CALL U2MESS('F','CALCULEL_8')
      DO 222  I = 1,NBPT
        ZR(JCELV+I-1) = ZR(IVDMG+I-1)
 222  CONTINUE

 7777 CONTINUE
C
      CALL JEDEMA()
      END
