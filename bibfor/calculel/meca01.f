      SUBROUTINE MECA01 ( OPTIO0, NBORDR, JORDR ,
     &                    NCHAR , JCHA  , KCHA  , CTYP  ,
     &                    TBGRCA, RESUCO, RESUC1, LERES1,
     &                    NOMA  , MODELE, LIGRMO, MATE  , CARA,
     &                    TYPESE, CODRET )
C
C TOLE CRP_20
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/03/2008   AUTEUR MEUNIER S.MEUNIER 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C ----------------------------------------------------------------------
C COMMANDE DE CALC_ELEM SPECIFIQUE AUX INDICATEURS D'ERREUR
C ----------------------------------------------------------------------
C IN  OPTIO0 : OPTION A TRAITER
C IN  NBORDR : NOMBRE DE NUMEROS D'ORDRE
C IN  JORDR  : ADRESSES DES NUMEROS D'ORDRES
C IN  NCHAR  : NOMBRE DE CHARGES
C IN  JCHA   : ADRESSES DES CHARGES
C IN  KCHA   : NOM JEVEUX OU SONT STOCKEES LES CHARGES
C IN  CTYP   : TYPE DE CHARGE
C IN  TBGRCA : TABLEAU DES GRANDEURS CARACTERISTIQUES (HM)
C IN  RESUCO : NOM DE CONCEPT RESULTAT
C IN  RESUC1 : NOM DE CONCEPT DE LA COMMANDE CALC_ELEM
C IN  LERES1 : NOM DE CONCEPT RESULTAT A ENRICHIR
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  LIGRMO : LISTE DES GROUPES DU MODELE
C IN  MATE   : NOM DU CHAMP MATERIAU
C IN  CARA   : NOM DU CHAMP DES CARACTERISTIQUES ELEMENTAIRES
C IN  TYPESE : TYPE DE SENSIBILITE
C OUT CODRET : CODE DE RETOUR AVEC 0 SI TOUT VA BIEN
C              1 : ERREUR LIEE A LA SENSIBILITE
C              2 : PROBLEMES DE DONNEES
C              3 : PROBLEMES DE RESULTATS
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C     --- ARGUMENTS ---

      INTEGER NBORDR, JORDR, NCHAR, JCHA
      INTEGER TYPESE
      INTEGER CODRET
      REAL*8      TBGRCA(3)
      CHARACTER*4 CTYP
      CHARACTER*8 NOMA, RESUCO, RESUC1, MODELE, CARA
      CHARACTER*19 KCHA
      CHARACTER*19 LERES1
      CHARACTER*24 LIGRMO
      CHARACTER*24 MATE
      CHARACTER*(*) OPTIO0
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32   JEXNOM
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C     --- VARIABLES LOCALES ---

      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'MECA01' )

      INTEGER NPASS, IORDR,JFIN,JAUX,TABIDO(5)
      INTEGER N1, N2, NP, ND, NCHARP, NCHARD, JCHAP, JCHAD
      INTEGER IRET, IRET1, IERD,IAD
      INTEGER IAINST
      INTEGER IAUX, IBID
      INTEGER VALI
      INTEGER LXLGUT

      REAL*8 RBID,RUNDF,R8VIDE,THETA,DELTAT
      REAL*8 TIME, ERP, ERD, S, LONGC, PRESC

      CHARACTER*1 K1BID
      CHARACTER*8 K8B
      CHARACTER*8 CTYPE, SAVCAR(2)
      CHARACTER*8 RESUP, RESUD
      CHARACTER*16 OPTION, OPTIOP, OPTIOD
      CHARACTER*19 KCHAP, KCHAD, TABP, TABD
      CHARACTER*24 BLAN24,K24B
      CHARACTER*24 CHS
      CHARACTER*24 CHDEPP, CHSGPN, CHSGDN
      CHARACTER*24 CHSIG , CHSIGP, CHSIGD, CHSIGN
      CHARACTER*24 CHSIGM , CHDEPM, CHERRM
      CHARACTER*24 CHCARA(15), CHELEM, CHTIME
      CHARACTER*24 CHERRE, CHERRN
      CHARACTER*24 LIGRCH, LIGRCP, LIGRCD, LIGREL
      CHARACTER*24 CHVOIS
      CHARACTER*24 VALK(2)

      COMPLEX*16 CBID, VALC

      LOGICAL EXICAR
      LOGICAL YATHM,PERMAN
C
C====
C 1. PREALABLES
C====
C
      CODRET = 0
      RUNDF  = R8VIDE()
C
C 1.1. ==> VERIFICATIONS
C 1.1.1. ==> L'OPTION
C
      IAUX = LXLGUT(OPTIO0)
      IF ( IAUX.GT.16 ) THEN
        CALL U2MESK ( 'F', 'INDICATEUR_98', 1, OPTIO0(1:IAUX) )
      ELSE
C                 1234567890123456
        OPTION = '                '
        OPTION(1:IAUX) = OPTIO0(1:IAUX)
      ENDIF
C
C 1.1.2. ==> PAS DE SENSIBILITE
C
      IF ( TYPESE.NE.0 ) THEN
        CODRET = 1
        GOTO 9999
      ENDIF
C
C 1.2. ==> INITIALISATIONS
C               123456789012345678901234
      BLAN24 = '                        '
      SAVCAR(1) = '????????'
      SAVCAR(2) = '????????'
C               12   345678   9012345678901234
      KCHAP  = '&&'//NOMPRO//'.CHARGESP  '
      KCHAD  = '&&'//NOMPRO//'.CHARGESD  '
      CHSIGP = BLAN24
      CHSIGD = BLAN24
      NCHARP = 0
      NCHARD = 0
C
C====
C 2. OPTION "ERRE_ELEM_SIGM"
C====
C
      IF ( OPTION.EQ.'ERRE_ELEM_SIGM' ) THEN
C
C 2.1. ==> PREALABLES
C ---- VERIFICATION DU PERIMETRE D'UTILISATION
        CALL GETVTX(' ','GROUP_MA',1,1,1,K8B,N1)
        CALL GETVTX(' ','MAILLE'  ,1,1,1,K8B,N2)
        IF ( N1+N2.NE.0 ) THEN
          CALL U2MESK('A','INDICATEUR_1',1,OPTION)
          GOTO 9999
        ENDIF
C
C--- RECHERCHE DES VOISINS
C--- (CHGEOM RECHERCHE A PARTIR DU MODELE ET PAS DES CHARGES)
        CALL RESLO2(MODELE,LIGRMO,ZK8(JCHA),CHVOIS,TABIDO)
C --- EST-CE DE LA THM ?
        CALL EXITHM ( MODELE, YATHM, PERMAN )
C
C --- POUR DE LA THM EN TRANSITOIRE, ON DEVRA RECUPERER LES INFORMATIONS
C     DU PAS DE TEMPS PRECEDENT
        JFIN = 1
        IF ( YATHM ) THEN
          IF ( .NOT. PERMAN ) THEN
            JFIN = 2
          ENDIF
        ENDIF
C
C--- INITIALISATIONS  : DEPLACEMENTS ET CONTRAINTES
C
        CHDEPM = ' '
        CHDEPP = ' '
        CHSIGM = ' '
        CHSIGP = ' '
C
C 2.2. ==> BOUCLE SUR LES NUMEROS D'ORDRE
C
        DO 10 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
          CALL JERECU('V')
          IORDR = ZI(JORDR+IAUX-1)

C 2.2.1 ==> SAISIT ET VERIFIE LA COHERENCE DES DONNEES MECANIQUES
C           RECUPERE LES CHARGES POUR LE NUMERO D'ORDRE IORDR
          CALL MEDOM2(MODELE,MATE,CARA,KCHA,NCHAR,CTYP,
     &                RESUCO,IORDR,NBORDR,NPASS,LIGREL)
          CALL JEVEUO(KCHA,'L',JCHA)
          CALL MECARA(CARA,EXICAR,CHCARA)
          CALL MECHC1(SAVCAR,MODELE,MATE,EXICAR,CHCARA)

C--- RECUPERATION DES INSTANTS CORRESPONDANT A IORDR ET IORDR-1
          DO 20 , JAUX = 1 , JFIN
C
            IBID = IORDR+1-JAUX
C
            IF ( IBID.LT.0 ) THEN
              CALL U2MESK('F','INDICATEUR_3',1,NOMPRO)
            ENDIF
C
            CALL RSADPA(RESUCO,'L',1,'INST',IBID,0,IAINST,K8B)
C
            IF ( JAUX.EQ.1 ) THEN
              TIME   = ZR(IAINST)
              DELTAT = RUNDF
              THETA  = RUNDF
            ELSE
              DELTAT = TIME - ZR(IAINST)

C - --RECUPERATION DU PARM_THETA CORRESPONDANT A IORDR
              CALL JENONU(JEXNOM(RESUCO//'           .NOVA',
     &                    'PARM_THETA'),IAD)
              IF (IAD.EQ.0) THEN
                THETA = 0.57D0
                CALL U2MESK('A','INDICATEUR_4',1,RESUCO)
              ELSE
                CALL RSADPA(RESUCO,'L',1,'PARM_THETA',IORDR,0,
     &                      IAD,K8B)
                THETA = ZR(IAD)
                IF ((THETA.GT.1.D0) .OR. (THETA.LT.0.D0)) THEN
                     THETA = 1.D0
                  CALL U2MESK('A','INDICATEUR_5',1,RESUCO)
                ENDIF
              ENDIF
C - --
            ENDIF
 20       CONTINUE

C--- CREATION DE LA CARTE DES INSTANTS
          CALL MECHTI(NOMA,TIME,DELTAT,THETA,CHTIME)
C
C 2.2.2 ==> RECUPERATION DES CHAMPS DE CONTRAINTES AUX NOEUDS
          DO 30 , JAUX = 1 , JFIN
C VERIFIE L'EXISTENCE DU CHAMP
C S'IL EXISTE ON RECUPERE SON NOM SYMBOLIQUE
            IBID = IORDR+1-JAUX
            CALL RSEXC2(1,3,RESUCO,'SIGM_ELNO_DEPL',IBID,K24B,
     &                  OPTION,IRET)
            CALL RSEXC2(2,3,RESUCO,'SIEF_ELNO_ELGA',IBID,K24B,
     &                  OPTION,IRET)
            CALL RSEXC2(3,3,RESUCO,'SIRE_ELNO_DEPL',IBID,K24B,
     &                  OPTION,IRET)

C--- SI AUCUN CHAMP N'EXISTE, ON SORT
            IF ( IRET.GT.0 ) GO TO 2299

C 2.2.3. ==> VERIFIE SI LE CHAMP EST CALCULE SUR TOUT LE MODELE
            CALL DISMOI('F','NOM_LIGREL',K24B,'CHAM_ELEM',IBID,
     &                  LIGRCH,IERD)
            IF ( LIGRCH.NE.LIGRMO ) THEN
              CALL CODENT(IBID,'G',K8B)
              VALK(1) = OPTION
              VALK(2) = K8B
              CALL U2MESK('A','INDICATEUR_2',2,VALK)
              GOTO 2299
            ENDIF
C--- ARCHIVAGE DU NOM DU CHAMP DE CONTRAINTES
            IF ( JAUX.EQ.1 ) THEN
              CHSIGP = K24B
            ELSE
              CHSIGM = K24B
            ENDIF
C
 30       CONTINUE
C
C ---------------------------------------------------------------------
C 2.2.4 ==> POUR DE LA THM : ON RECUPERE ...
C ---------------------------------------------------------------------
          IF ( YATHM ) THEN
C -----------------------------
C 2.2.4.1. LES CHAMPS DE DEPLACEMENTS
C -----------------------------
            DO 40 , JAUX = 1 , JFIN
C
              IBID = IORDR+1-JAUX
              CALL RSEXC2(1,1,RESUCO,'DEPL',IBID,K24B,OPTION,IRET1)
              IF ( IRET1.GT.0 ) THEN
                CALL CODENT(IBID,'G',K8B)
                VALK(1) = RESUCO
                VALK(2) = K8B
                CALL U2MESK('A','CALCULEL3_11', 2 ,VALK)
                GO TO 2299
              ENDIF
              IF ( JAUX.EQ.1 ) THEN
                CHDEPP = K24B
              ELSE
                CHDEPM = K24B
              ENDIF
 40         CONTINUE
C ---------------------------------------
C 2.2.4.2. LES GRANDEURS CARACTERISTIQUES
C ---------------------------------------
C
            LONGC = TBGRCA(1)
            PRESC = TBGRCA(2)
            IF ( LONGC.LE.0.D0 .OR. PRESC.LE.0.D0 ) THEN
              CALL U2MESS('F','INDICATEUR_28')
            ENDIF
C -----------------------------
C 2.2.4.1. LE CHAMP D'ESTIMATEURS A L'INSTANT PRECEDENT
C -----------------------------
C
            IF ( .NOT. PERMAN ) THEN
C
              IF ( IORDR.EQ. 1) THEN
C
C INSTANT INITIAL : CREATION D'UN CHAM_ELEM NUL
C                         12   345678   9012345678901234
                CHERRM = '&&'//NOMPRO//'_ERREUR_M       '
                CALL ALCHML(LIGREL,OPTION,'PERREM','V',CHERRM,IRET,' ')
                IF (IRET.NE.0) THEN
                  CALL U2MESS('A','CALCULEL5_4')
                  GO TO 2299
                END IF
C
              ELSE
C SINON, ON RECUPERE LE CHAMP DE L'INSTANT PRECEDENT
                IBID = IORDR - 1
                CALL RSEXC2(1,1,RESUCO,'ERRE_ELEM_SIGM',IBID,K24B,
     &                      OPTION,IRET1)
                IF ( IRET1.GT.0 ) THEN
                  CALL CODENT(IBID,'G',K8B)
                  VALK(1) = RESUCO
                  VALK(2) = K8B
                  CALL U2MESK('F','INDICATEUR_24', 2 ,VALK)
                  GO TO 2299
                ENDIF
                CHERRM = K24B
              ENDIF
C
            ENDIF
C
          ENDIF

C 2.2.7. ==> RECUPERE LE NOM SYMBOLIQUE DU CHAMP DE L'OPTION CALCULEE
C            POUR LE NUMERO D'ORDRE IORDR
          CALL RSEXC1(LERES1,OPTION,IORDR,CHELEM)

C 2.2.8. ==> CALCULE L'ESTIMATEUR D'ERREUR EN RESIDU LOCAL
C
          CALL RESLOC(MODELE   , LIGRMO, YATHM , TBGRCA,
     &                PERMAN   , CHTIME, MATE  ,
     &                CHSIGM   , CHSIGP, CHDEPM, CHDEPP, CHERRM,
     &                ZK8(JCHA), NCHAR , TABIDO, CHVOIS, CHELEM)

C 2.2.9. ==> VERIFIE L'EXISTENCE DU CHAMP CHELEM
          CALL EXISD('CHAMP_GD',CHELEM,IRET)

C--- SI LE CHAMP N'EXISTE PAS, ON SORT
          IF ( IRET.EQ.0 ) THEN
            CODRET = 2
            CALL JEDEMA
            GOTO 9999
          ENDIF

C 2.2.10. ==> CALCUL DE L'ESTIMATEUR GLOBAL A PARTIR DES ESTIMATEURS
C             LOCAUX
          CALL ERGLOB(CHELEM,YATHM ,PERMAN,OPTION,IORDR,
     &                TIME  ,RESUCO,LERES1)

C 2.2.11. ==> NOTE LE NOM D'UN CHAMP19 DANS UNE SD_RESULTAT
          CALL RSNOCH ( LERES1,OPTION,IORDR,' ')
C
 2299   CONTINUE
C
        CALL JEDEMA()
C
 10   CONTINUE
C
C====
C 3. OPTION "ERRE_ELNO_ELEM"
C====
C
      ELSE IF ( OPTION.EQ.'ERRE_ELNO_ELEM' ) THEN
C
        DO 11 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
C
          CALL JERECU('V')
          IORDR = ZI(JORDR+IAUX-1)
          CALL RSEXC2(1,1,RESUCO,'ERRE_ELEM_SIGM',IORDR,CHERRE,
     &                OPTION,IRET1)
C
          IF (IRET1.EQ.0) THEN
            CALL RSEXC1(LERES1,OPTION,IORDR,CHERRN)
            CALL RESLGN(LIGRMO,OPTION,CHERRE,CHERRN)
            CALL RSNOCH(LERES1,OPTION,IORDR,' ')
          ENDIF
C
          CALL JEDEMA()
C
 11     CONTINUE
C
C====
C 4. OPTION "QIRE_ELEM_SIGM"
C====
C
      ELSE IF ( OPTION.EQ.'QIRE_ELEM_SIGM' ) THEN

C 4.1. ==> PREALABLES
C 4.1.1. ==> RECUPERE LES NOMS DES SD RESULTAT
        CALL GETVID(' ','RESULTAT' ,1,1,1,RESUP,NP)
        CALL GETVID(' ','RESU_DUAL',1,1,1,RESUD,ND)

C 4.1.2. ==> RECHERCHE DES VOISINS
        CALL RESLO2(MODELE,LIGRMO,ZK8(JCHA),CHVOIS,TABIDO)
C 4.1.3. ==>  RECUPERE LES NOMS SYMBOLIQUES DES TABLES
        TABP=' '
        TABD=' '
        CALL LTNOTB(RESUP,'ESTI_GLOB',TABP)
        CALL LTNOTB(RESUD,'ESTI_GLOB',TABD)

C 4.2. ==> BOUCLE SUR LES NUMEROS D'ORDRE
C
        DO 12 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
          IORDR = ZI(JORDR+IAUX-1)
C
C 4.2.1. ==> CALCULE LE COEFFICIENT S
C----- RECUPERE ERRE_ABSO DANS LA TABLE A PARTIR DU NUMERO D'ORDRE
          CALL TBLIVA (TABP,1,'NUME_ORDR',IORDR,RBID,CBID,K1BID,'EGAL',
     &                 0.D0,'ERRE_ABSO',CTYPE,VALI,ERP,VALC,VALK,IRET)
          CALL TBLIVA (TABD,1,'NUME_ORDR',IORDR,RBID,CBID,K1BID,'EGAL',
     &                 0.D0,'ERRE_ABSO',CTYPE,VALI,ERD,VALC,VALK,IRET)
          S=SQRT(ERD/ERP)
C----- CREE UNE CARTE CONSTANTE
          CHS='&&OP0069.CH_NEUT_R'
          CALL MECACT('V',CHS,'MODELE',LIGRMO,'NEUT_R',1,'X1',IBID,S,
     &          CBID,K1BID)

C 4.2.2. ==> SAISIE ET VERIFIE LA COHERENCE DES DONNEES MECANIQUES
          CALL MEDOM2(MODELE,MATE,CARA,KCHAP,NCHARP,CTYP,
     &                RESUP,IORDR,NBORDR,NPASS,LIGREL)
          CALL MEDOM2(MODELE,MATE,CARA,KCHAD,NCHARD,CTYP,
     &                RESUD,IORDR,NBORDR,NPASS,LIGREL)
          CALL JEVEUO(KCHAP,'L',JCHAP)
          CALL JEVEUO(KCHAD,'L',JCHAD)

C 4.2.3. ==> VERIFIE L'EXISTENCE DU CHAMP DANS LE RESUPRIM
C          S'IL EXISTE RECUPERE SON NOM SYMBOLIQUE
          CALL RSEXC2(1,3,RESUP,'SIGM_ELNO_DEPL',IORDR,CHSIGP,
     &                OPTION,IRET)
          CALL RSEXC2(2,3,RESUP,'SIEF_ELNO_ELGA',IORDR,CHSIGP,
     &                OPTION,IRET)
          CALL RSEXC2(3,3,RESUP,'SIRE_ELNO_DEPL',IORDR,CHSIGP,
     &                OPTION,IRET)

C         SI AUCUN CHAMP N'EXISTE, ON SORT
          IF (IRET.GT.0) GO TO 4299

C 4.2.4. ==> VERIFIE L'EXISTENCE DU CHAMP DANS LE RESUDUAL
C         S'IL EXISTE RECUPERE SON NOM SYMBOLIQUE
          CALL RSEXC2(1,3,RESUD,'SIGM_ELNO_DEPL',IORDR,CHSIGD,
     &                OPTION,IRET)
          CALL RSEXC2(2,3,RESUD,'SIEF_ELNO_ELGA',IORDR,CHSIGD,
     &                OPTION,IRET)
          CALL RSEXC2(3,3,RESUD,'SIRE_ELNO_DEPL',IORDR,CHSIGD,
     &                OPTION,IRET)

C         SI AUCUN CHAMP N'EXISTE, ON SORT
          IF (IRET.GT.0) GO TO 4299

C 4.2.5. ==> RECUPERE LE NOM DE L'OPTION CALCULEE POUR CHACUN DES CHAMPS
          CALL DISMOI('F','NOM_OPTION',CHSIGP,'CHAM_ELEM',IBID,
     &                                        OPTIOP,IERD)
          CALL DISMOI('F','NOM_OPTION',CHSIGD,'CHAM_ELEM',IBID,
     &                                        OPTIOD,IERD)

C 4.2.6. ==> VERIFIE SI LE CHAMP EST CALCULE SUR TOUT LE MODELE
          CALL DISMOI('F','NOM_LIGREL',CHSIGP,'CHAM_ELEM',IBID,
     &                                        LIGRCP,IERD)
          CALL DISMOI('F','NOM_LIGREL',CHSIGD,'CHAM_ELEM',IBID,
     &                                        LIGRCD,IERD)
          IF ( LIGRCP.NE.LIGRMO .OR. LIGRCD.NE.LIGRMO ) THEN
             CALL CODENT(IORDR,'G',K8B)
             VALK(1)=OPTION
             VALK(2)=K8B
             CALL U2MESK('A','INDICATEUR_2',2,VALK)
             GOTO 4299
          ENDIF

C 4.2.7. ==> RECUPERE L'ADRESSE JEVEUX DE L'INSTANT DE CALCUL
C          POUR LE NUMERO D'ORDRE IORDR
          CALL RSADPA(RESUCO,'L',1,'INST',IORDR,0,IAINST,K8B)
          TIME = ZR(IAINST)

C 4.2.8. ==> CREE UNE CARTE D'INSTANTS
          CALL MECHTI(NOMA,TIME,RUNDF,RUNDF,CHTIME)

C 4.2.9. ==> RECUPERE LE NOM SYMBOLIQUE DU CHAMP DE L'OPTION CALCULEE
C           POUR LE NUMERO D'ORDRE IORDR
          CALL RSEXC1(LERES1,OPTION,IORDR,CHELEM)

C 4.2.10. ==> CALCULE L'ESTIMATEUR D'ERREUR EN RESIDU LOCAL
C
          CALL QIRES1( MODELE    ,LIGRMO    ,CHTIME,CHSIGP,CHSIGD,
     &                 ZK8(JCHAP),ZK8(JCHAD),NCHARP,NCHARD,CHS,
     &                 MATE      ,CHVOIS    ,TABIDO,CHELEM        )
C
C 4.2.11. ==> VERIFIE L'EXISTENCE DU CHAMP CHELEM
          CALL EXISD('CHAMP_GD',CHELEM,IRET)

C--- SI LE CHAMP N'EXISTE PAS, ON SORT
          IF ( IRET.EQ.0 ) THEN
            CODRET = 2
            CALL JEDEMA
            GOTO 9999
          ENDIF

C 4.2.12. ==> CALCUL DE L'ESTIMATEUR GLOBAL A PARTIR DES ESTIMATEURS
C             LOCAUX
          CALL ERGLOB(CHELEM,.FALSE.,.FALSE.,OPTION,IORDR,
     &                TIME  ,RESUCO ,LERES1)

C 4.2.13. ==> NOTE LE NOM D'UN CHAMP19 DANS UNE SD_RESULTAT
          CALL RSNOCH(LERES1,OPTION,IORDR,' ')
C
 4299     CONTINUE
C
          CALL JEDEMA()
C
   12   CONTINUE
C
C====
C 5. OPTION "QIRE_ELNO_ELEM"
C====
C
      ELSE IF ( OPTION.EQ.'QIRE_ELNO_ELEM' ) THEN
C
        DO 13 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
C
          IORDR = ZI(JORDR+IAUX-1)
          CALL RSEXC2(1,1,RESUCO,'QIRE_ELEM_SIGM',IORDR,CHERRE,
     &                OPTION,IRET1)
C
          IF (IRET1.EQ.0) THEN
            CALL RSEXC1(LERES1,OPTION,IORDR,CHERRN)
            CALL RESLGN(LIGRMO,OPTION,CHERRE,CHERRN)
            CALL RSNOCH(LERES1,OPTION,IORDR,' ')
          ENDIF
C
          CALL JEDEMA()
C
 13     CONTINUE
C
C====
C 6. OPTIONS "QIZ1_ELEM_SIGM" ET "QIZ2_ELEM_SIGM"
C====
C
      ELSE IF ( OPTION.EQ.'QIZ1_ELEM_SIGM' .OR.
     &          OPTION.EQ.'QIZ2_ELEM_SIGM' ) THEN

C 6.1. ==> RECUPERE LES NOMS DES SD RESULTAT
        CALL GETVID(' ','RESULTAT' ,1,1,1,RESUP,NP)
        CALL GETVID(' ','RESU_DUAL',1,1,1,RESUD,ND)

C 6.2. ==> BOUCLE SUR LES NUMEROS D'ORDRE
C
        DO 14 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
C
          IORDR = ZI(JORDR+IAUX-1)

C 6.2.1. ==> SAISIT ET VERIFIE LA COHERENCE DES DONNEES MECANIQUES
          CALL MEDOM2(MODELE,MATE,CARA,KCHAP,NCHARP,CTYP,
     &                RESUP,IORDR,NBORDR,NPASS,LIGREL)
          CALL MEDOM2(MODELE,MATE,CARA,KCHAP,NCHARP,CTYP,
     &                RESUD,IORDR,NBORDR,NPASS,LIGREL)
          CALL JEVEUO(KCHAP,'L',JCHAP)
          CALL JEVEUO(KCHAD,'L',JCHAD)

C 6.2.2. ==> RECUPERE SON NOM SYMBOLIQUE DU CHAMP DE CONTRAINTES LISSE
C            DANS LE RESUPRIM
          CALL RSEXC2(1,1,RESUP,'SIGM_NO'//OPTION(8:9)//'_ELGA  ',
     &                    IORDR,CHSGPN,OPTION,IRET)

C 6.2.3. ==>  RECUPERE SON NOM SYMBOLIQUE DU CHAMP DE CONTRAINTES LISSE
C             DANS LE RESUDUAL
          CALL RSEXC2(1,1,RESUD,'SIGM_NO'//OPTION(8:9)//'_ELGA  ',
     &                IORDR,CHSGDN,OPTION,IRET)

C 6.2.4. ==> RECUPERE SON NOM SYMBOLIQUE DU CHAMP DE CONTRAINTES CALCULE
C            DANS LE RESUPRIM
          CALL RSEXC2(1,2,RESUP,'SIEF_ELGA',IORDR,CHSIGP,OPTION,
     &                IRET)
          CALL RSEXC2(2,2,RESUP,'SIEF_ELGA_DEPL',IORDR,CHSIGP,
     &                OPTION,IRET)
          IF ( IRET.GT.0 ) GO TO 6299

C 6.2.5 ==> RECUPERE SON NOM SYMBOLIQUE DU CHAMP DE CONTRAINTES CALCULE
C           DANS LE RESUDUAL
          CALL RSEXC2(1,2,RESUD,'SIEF_ELGA',IORDR,CHSIGD,
     &                OPTION,IRET)
          CALL RSEXC2(2,2,RESUD,'SIEF_ELGA_DEPL',IORDR,CHSIGD,
     &                OPTION,IRET)
          IF (IRET.GT.0) GO TO 6299

C 6.2.6 ==> CALCUL
          CALL RSEXC1(RESUC1,OPTION,IORDR,CHELEM)

          CALL QINTZZ(MODELE,LIGRMO,MATE,CHSIGP,CHSIGD,
     &              CHSGPN,CHSGDN,CHELEM)
C
C 6.2.7. ==> CALCUL DE L'ESTIMATEUR GLOBAL A PARTIR DES ESTIMATEURS
C             LOCAUX
          CALL ERGLOB(CHELEM,.FALSE.,.FALSE.,OPTION,IORDR,
     &                TIME  ,RESUCO ,LERES1)
          CALL ERNOZZ(MODELE,CHSIGP,MATE,CHSGPN,OPTION,LIGRMO,
     &                IORDR,TIME,RESUCO,LERES1,CHELEM)

C 6.2.8. ==> NOTE LE NOM D'UN CHAMP19 DANS UNE SD_RESULTAT
          CALL RSNOCH(LERES1,OPTION,IORDR,' ')
C
 6299     CONTINUE
C
          CALL JEDEMA()
C
 14     CONTINUE
C
C====
C 7. OPTIONS "ERZ1_ELEM_SIGM" ET "ERZ2_ELEM_SIGM"
C====
C
      ELSE IF ( OPTION.EQ.'ERZ1_ELEM_SIGM' .OR.
     &          OPTION.EQ.'ERZ2_ELEM_SIGM' ) THEN
C
        DO 15 , IAUX = 1 , NBORDR
C
          CALL JEMARQ()
          CALL JERECU('V')
C
          IORDR = ZI(JORDR+IAUX-1)
          CALL MEDOM2(MODELE,MATE,CARA,KCHA,NCHAR,CTYP,
     &                RESUCO,IORDR,NBORDR,NPASS,LIGREL)
          CALL JEVEUO(KCHA,'L',JCHA)
          CALL MECARA(CARA,EXICAR,CHCARA)
          CALL MECHC1(SAVCAR,MODELE,MATE,EXICAR,CHCARA)
          CALL RSEXC2(1,2,RESUCO,'SIEF_ELGA',IORDR,CHSIG,OPTION,
     &                IRET)
          CALL RSEXC2(2,2,RESUCO,'SIEF_ELGA_DEPL',IORDR,CHSIG,
     &                OPTION,IRET)
          IF (IRET.GT.0) THEN
            CALL U2MESK('A','CALCULEL3_7',1,OPTION)
            CODRET = 3
            GO TO 9999
          END IF
C
          CALL RSEXC2(1,1,RESUCO,'SIGM_NO'//OPTION(3:4)//'_ELGA  ',
     &                IORDR,CHSIGN,OPTION,IRET)
C
          IF ( IRET.EQ.0 ) THEN
            CALL RSEXC1(LERES1,OPTION,IORDR,CHELEM)
            CALL ERNOZZ(MODELE,CHSIG,MATE,CHSIGN,OPTION,LIGRMO,
     &                  IORDR,TIME,RESUCO,LERES1,CHELEM)
            CALL RSNOCH(LERES1,OPTION,IORDR,' ')
          ENDIF
C
          CALL JEDEMA()
C
 15     CONTINUE
C
C====
C N. OPTION NE CORRESPONDANT PAS AUX INDICATEURS D'ERREUR
C====
C
      ELSE
C
C                 123456   890123456789
        VALK(1) = NOMPRO//'            '
        VALK(2) = OPTION//         '   '
        CALL U2MESK ( 'F', 'INDICATEUR_99', 2, VALK )
C
      ENDIF
C
 9999 CONTINUE
C
      END
