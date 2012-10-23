      SUBROUTINE NMFLAM(OPTION,MODELE,NUMEDD,NUMFIX,CARELE,
     &                  COMPOR,SOLVEU,NUMINS,MATE  ,COMREF,
     &                  LISCHA,DEFICO,RESOCO,PARMET,FONACT,
     &                  CARCRI,SDIMPR,SDSTAT,SDDISC,SDTIME,
     &                  SDDYNA,SDPOST,VALINC,SOLALG,MEELEM,
     &                  MEASSE,VEELEM,SDERRO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/10/2012   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'
      INTEGER      NUMINS
      REAL*8       PARMET(*)
      CHARACTER*16 OPTION
      CHARACTER*19 MEELEM(*)
      CHARACTER*24 RESOCO,DEFICO
      CHARACTER*24 SDIMPR,SDSTAT,SDTIME,SDERRO
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA,SDPOST
      CHARACTER*24 MODELE,NUMEDD,NUMFIX,CARELE,COMPOR
      CHARACTER*19 VEELEM(*),MEASSE(*)
      CHARACTER*19 SOLALG(*),VALINC(*)
      CHARACTER*24 MATE
      CHARACTER*24 CARCRI,COMREF
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DE MODES
C
C ----------------------------------------------------------------------
C
C
C IN  OPTION : TYPE DE CALCUL
C              'FLAMBSTA' MODES DE FLAMBEMENT EN STATIQUE
C              'FLAMBDYN' MODES DE FLAMBEMENT EN DYNAMIQUE
C              'VIBRDYNA' MODES VIBRATOIRES
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  DEFICO : SD DEFINITION CONTACT
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  MEELEM : MATRICES ELEMENTAIRES (POUR NMFLMA)
C IN  MEASSE : MATRICE ASSEMBLEE (POUR NMFLMA)
C IN  VEELEM : VECTEUR ELEMENTAIRE (POUR NMFLMA)
C IN  SDERRO : SD ERREUR
C
C ----------------------------------------------------------------------
C
      LOGICAL      LINSTA
      INTEGER      NFREQ,NFREQC
      INTEGER      I,ISLVK,LJEVEU,IBID,IRET
      INTEGER      DEFO,LDCCVG,NUMORD
      INTEGER      NDDLE ,NSTA,LJEVE2,CDSP
      REAL*8       BANDE(2),R8BID,R8VIDE
      REAL*8       FREQM,FREQV,FREQA,FREQR,R8MAEM
      REAL*8       CSTA
      CHARACTER*4  MOD45
      CHARACTER*8  SDMODE,SDSTAB
      CHARACTER*8  SYME
      CHARACTER*16 K16BID,OPTMOD,VARACC,TYPMAT,MODRIG
      CHARACTER*19 MATGEO,MATAS2,VECMOD,CHAMP
      CHARACTER*19 CHAMP2,VECMO2
      CHARACTER*24 K24BID,DDLEXC,DDLSTA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL JEVEUO(SOLVEU(1:19)//'.SLVK','E',ISLVK)
      MATGEO = '&&NMFLAM.MAGEOM'
      MATAS2 = '&&NMFLAM.MATASS'
      LINSTA = .FALSE.
C
C --- NOM DE LA SD DE STOCKAGE DES MODES
C
      SDMODE  = '&&NM45BI'
      SDSTAB  = '&&NM45SI'
C
C --- RECUPERATION DES OPTIONS
C
      CALL NMFLAL(OPTION,COMPOR,SDPOST,MOD45  ,DEFO  ,
     &            NFREQ ,CDSP, TYPMAT,OPTMOD,BANDE  ,
     &            NDDLE ,DDLEXC,NSTA,DDLSTA,MODRIG)
C
C --- ON FORCE LA MATRICE TANGENTE EN SYMETRIQUE A CAUSE DE SORENSEN
C
      SYME   = ZK24(ISLVK+5-1)(1:8)
      ZK24(ISLVK+5-1) = 'OUI'
C
C --- CALCUL DE LA MATRICE TANGENTE ASSEMBLEE ET DE LA MATRICE GEOM.
C
      CALL NMFLMA(TYPMAT,MOD45 ,DEFO  ,PARMET,MODELE,
     &            MATE  ,CARELE,SDDISC,SDDYNA,FONACT,
     &            NUMINS,VALINC,SOLALG,LISCHA,COMREF,
     &            DEFICO,RESOCO,SOLVEU,NUMEDD,NUMFIX,
     &            COMPOR,CARCRI,SDSTAT,SDTIME,MEELEM,
     &            MEASSE,VEELEM,NDDLE ,DDLEXC,MODRIG,
     &            LDCCVG,MATAS2,MATGEO)
      CALL ASSERT(LDCCVG.EQ.0)
C
C --- RETABLISSEMENTS VALEURS
C
      ZK24(ISLVK+5-1) = SYME(1:3)
C
C --- CALCUL DES MODES PROPRES
C
C  ON DIFFERENCIE NFREQ (DONNEE UTILISATEUR) DE NFREQC
C  QUI EST LE NB DE FREQ TROUVEES PAR L'ALGO DANS NMOP45
C
      NFREQC = NFREQ
      CALL NMOP45(MATAS2,MATGEO,DEFO  ,OPTMOD,NFREQC,
     &            CDSP,BANDE ,MOD45 ,DDLEXC,NDDLE ,
     &            SDMODE,SDSTAB,DDLSTA,NSTA)
      IF (NFREQC.EQ.0) THEN
        FREQR  = R8VIDE()
        NUMORD = -1
        GOTO 999
      ENDIF
C
C --- SELECTION DU MODE DE PLUS PETITE FREQUENCE
C
      IF ( MOD45 .EQ. 'VIBR' ) THEN
        VARACC = 'FREQ'
      ELSEIF ( MOD45 .EQ. 'FLAM' ) THEN
        VARACC = 'CHAR_CRIT'
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      FREQM  = R8MAEM()
      NUMORD = 0
      DO 60 I = 1,NFREQC
        CALL RSADPA(SDMODE,'L',1,VARACC,I,0,LJEVEU,K16BID)
        FREQV = ZR(LJEVEU)
        FREQA = ABS(FREQV)
        IF (FREQA.LT.FREQM) THEN
          NUMORD = I
          FREQM  = FREQA
          FREQR  = FREQV
        END IF
   60 CONTINUE
      IF (NSTA.NE.0) THEN
        CALL RSADPA(SDSTAB,'L',1,'CHAR_STAB',1,0,LJEVE2,K16BID)
        CSTA = ZR(LJEVE2)
      ENDIF
C
C --- NOM DU MODE
C
      IF ( MOD45 .EQ. 'VIBR' ) THEN
        CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_VIBR',
     &              IBID             ,R8BID ,VECMOD)
      ELSEIF ( MOD45 .EQ. 'FLAM' ) THEN
        CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_FLAM',
     &              IBID             ,R8BID ,VECMOD)
        IF (NSTA.NE.0) THEN
          CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_STAB',
     &                IBID             ,R8BID ,VECMO2)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- RECUPERATION DES MODES DANS LA SD MODE
C
      CALL RSEXCH('F',SDMODE,'DEPL',NUMORD,CHAMP ,IRET)
      CALL COPISD('CHAMP_GD','V',CHAMP,VECMOD)
      IF (NSTA.NE.0) THEN
        CALL RSEXCH('F',SDSTAB,'DEPL',1,CHAMP2 ,IRET)
        CALL COPISD('CHAMP_GD','V',CHAMP2,VECMO2)
      ENDIF
C
C --- AFFICHAGE DES MODES
C
      IF ( MOD45 .EQ. 'VIBR' ) THEN
        CALL U2MESG('I','MECANONLINE6_10',0,' ',1,NUMORD,1,FREQR)
      ELSEIF ( MOD45 .EQ. 'FLAM' ) THEN
        CALL U2MESG('I','MECANONLINE6_11',0,' ',1,NUMORD,1,FREQR)
        IF (NSTA.NE.0) THEN
          CALL U2MESG('I','MECANONLINE6_12',0,' ',1,1,1,CSTA)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- DETECTION INSTABILITE SI DEMANDE
C
      IF ( MOD45 .EQ. 'FLAM' ) THEN
        CALL NMFLIN(SDPOST,MATAS2,FREQR ,LINSTA)
        CALL NMCREL(SDERRO,'CRIT_STAB',LINSTA)
      ENDIF
C
C --- ARRET
C
 999  CONTINUE
C
C --- MODE SELECTIONNE ECRIT DANS SDPOST
C
      IF ( MOD45 .EQ. 'VIBR' ) THEN
        CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_FREQ_VIBR',
     &              IBID             ,FREQR ,K24BID)
        CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_NUME_VIBR',
     &              NUMORD           ,R8BID ,K24BID)
      ELSEIF ( MOD45 .EQ. 'FLAM' ) THEN
        CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_FREQ_FLAM',
     &              IBID             ,FREQR ,K24BID)
        CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_NUME_FLAM',
     &              NUMORD           ,R8BID ,K24BID)
        IF (NSTA.NE.0) THEN
          CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_FREQ_STAB',
     &                IBID             ,CSTA  ,K24BID)
          CALL NMECSD('POST_TRAITEMENT',SDPOST,'SOLU_NUME_STAB',
     &                1                ,R8BID ,K24BID)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- DESTRUCTION DE LA SD DE STOCKAGE DES MODES
C
      CALL JEDETC('G',SDMODE,1)
      CALL JEDETC('G',SDSTAB,1)

      CALL JEDEMA()
      END
