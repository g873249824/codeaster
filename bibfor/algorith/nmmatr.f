      SUBROUTINE NMMATR(PHASEZ, MODELE, NUMEDD, MATE,  CARELE,
     &                  COMREF, COMPOR, LISCHA, MEDIRI, RESOCZ,
     &                  METHOD, SOLVEU, PARMET, CARCRI, PARTPS,
     &                  NUMINS, ITERAT, VALMOI, POUGD,  DEPDEZ,
     &                  VALPLU, MATRIX, OPTION, DEFICO, STADYN,
     &                  PREMIE, CMD,    DEPENT, VITENT, RIGID,
     &                  LAMORT,MEMASS, MASSE,  AMORT,  COEDEP,
     &                  COEVIT,COEACC, LICCVG)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/03/2007   AUTEUR DEVESA G.DEVESA 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21

      IMPLICIT NONE
      INTEGER NUMINS,ITERAT, LICCVG,ICONTX
      REAL*8 PARMET(*),COEVIT,COEACC,COEDEP
      CHARACTER*(*) DEPDEZ,RESOCZ,PHASEZ
      CHARACTER*10 PHASE
      CHARACTER*14 RESOCO
      CHARACTER*16 METHOD(6),OPTION,CMD
      CHARACTER*19 LISCHA,SOLVEU,PARTPS,MATRIX(2)
      CHARACTER*24 MODELE,NUMEDD,MATE,CARELE,COMREF,COMPOR
      CHARACTER*24 CARCRI,VALMOI,POUGD,DEPDEL,VALPLU,MASSE
      CHARACTER*24 MEDIRI,DEFICO,MAESCL,STADYN
      CHARACTER*24 DEPENT,VITENT,RIGID,MEMASS,MEAMOR,AMORT
      LOGICAL LAMORT,PREMIE
C ----------------------------------------------------------------------
C  METHODE DE NEWTON : DECISION DE REASSEMBLAGE ET CHOIX DE LA MATRICE
C ----------------------------------------------------------------------

C IN       PHASE  K10  PHASE DE 'PREDICTION' OU 'CORRECTION' OU :
C                      'FORCES_INT' : TANT QUE FULL_MECA EXISTE
C                      'FLAMBEMENT' : FLAMBEMENT SEUL DE LA RIGIDITE TGT
C IN       MODELE K24  MODELE
C IN       NUMEDD K24  NUME_DDL
C IN       MATE   K24  CHAMP MATERIAU
C IN       CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24  VARI_COM DE REFERENCE
C IN       COMPOR K24  COMPORTEMENT
C IN       LISCHA K19  L_CHARGES
C IN       MEDIRI K24  MATRICES ELEMENTAIRES DE DIRICHLET (B)
C IN       RIGID  K24  MATRICE DE RIGIDITE ASSEMBLEE (POUR LA DYNAMIQUE)
C                      POUR LA STATIQUE ELLE EST DANS MATASS
C IN       RESOCO K24  SD CONTACT
C IN       METHOD K16  INFORMATIONS SUR LES METHODES DE RESOLUTION
C                      VOIR DETAIL DES COMPOSANTES DANS NMLECT
C IN       SOLVEU K19  SOLVEUR
C IN       PARMET  R8  PARAMETRES DES METHODES DE RESOLUTION
C                      VOIR DETAIL DES COMPOSANTES DANS NMLECT
C IN       CARCRI K24  PARAMETRES DES METHODES D'INTEGRATION LOCALES
C                      VOIR DETAIL DES COMPOSANTES DANS NMLECT
C IN       PARTPS K19  SD DISC_INST
C IN       NUMINS  I   NUMERO D'INSTANT
C IN       ITERAT  I   NUMERO D'ITERATION
C IN       OLDDEP K24  ANCIEN INCREMENT DE TEMPS (PAS PRECEDENT)
C IN       VALMOI K24  ETAT EN T-
C IN       POUGD  K24  DONNES POUR POUTRES GRANDES DEFORMATIONS
C IN       DEPDEL K24  INCREMENT DE DEPLACEMENT
C IN       VALPLU K24  ETAT EN T+
C OUT      MATRIX K19  MATRICE ASSEMBLEE
C                      (1) : MATASS (PREDICTION, CORRECTION)
C                      (2) : MAPREC (PREDICTION, CORRECTION)
C OUT      OPTION K16  NOM D'OPTION PASSE A MERIMO ('CORRECTION')
C OUT   LICCVG  I   CODE RETOUR (INDIQUE SI LA MATRICE EST SINGULIERE)
C                   O -> MATRICE INVERSIBLE
C                   1 -> MATRICE SINGULIERE
C                   2 -> MATRICE PRESQUE SINGULIERE
C                   3 -> ON NE SAIT PAS SI LA MATRICE EST SINGULIERE
C ----------------------------------------------------------------------
C REMARQUE :
C LORSQU'ON AURA COMPLETEMENT SEPARE LE CALCUL DES EFFORTS INTERIEURS
C DU CALCUL DES MATRICES TANGENTES (PLUS D'OPTION FULL_MECA), LA PHASE
C 'FORCES_INT' N'AURA PLUS LIEU D'ETRE. POUR L'INSTANT, ELLE NE
C S'ALIMENTE QUE DES PARAMETRES METHOD, PARMET ET ITERAT POUR FOURNIR
C OPTION EN SORTIE. DE PLUS, LORS DU CALCUL DE LA MATRICE POUR LES
C CORRECTIONS DE NEWTON, LES MATRICES ELEMENTAIRES ONT DEJA ETE
C CALCULEES LORS DE L'ETAPE DES FORCES INTERIEURES ET SONT FOURNIES VIA
C UN ARGUMENT SOUTERRAIN (LE NOM DE L'OBJET JEVEUX EST CONSIDERE COMME
C IDENTIQUE DANS NMFINT ET NMMATR POUR LA VARIABLE MERIGI). A TERME, LE
C CALCUL DE CES MATRICES ELEMENTAIRES AURA EGALEMENT LIEU DANS CETTE
C ROUTINE, CE QUI NE POSERA PLUS LE PROBLEME DE CET ARGUMENT SOUTERRAIN.
C ----------------------------------------------------------------------
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL REASMA,TABRET(0:10)
      INTEGER REINCR,REITER,IERR,IECPCO,MATTAN,IBID,IRET
      REAL*8 INSTAM,INSTAP,DIINST,PASMIN
      REAL*8 UN,COEF2(3)
      CHARACTER*8 NOMDDL,K8B
      CHARACTER*16 METCOR,METPRE
      CHARACTER*19 MAPREC
      CHARACTER*24 DEPMOI,K24BID,K24BLA
      CHARACTER*24 MERIGI,MESUIV,VERESI,VEDIRI
      CHARACTER*24 LIMAT(3)
      CHARACTER*4 TYPCST(3)
      INTEGER IACHAR,JINFC,IACHA2,I,NBCHAR,NBMAT
      INTEGER IAREFE,NBSS,IRES
      DATA VERESI,VEDIRI/'&&RESIDU.LISTE_RESU','&&DIRICH.LISTE_RESU'/
      DATA MERIGI,MESUIV/'&&MEMRIG.LISTE_RESU','&&MATGME.LISTE_RESU'/
      DATA MEAMOR/'&&MEAMOR'/
      DATA NOMDDL/'        '/
      DATA K24BLA/' '/


C ----------------------------------------------------------------------
      CALL JEMARQ()
      MAPREC = '&&NMMATR.MAPREC'
      PHASE  = PHASEZ
      RESOCO = RESOCZ
      DEPDEL = DEPDEZ
      LICCVG = 0

      UN       = 1.D0
      COEF2(1) = UN
      COEF2(2) = COEACC/COEDEP
      COEF2(3) = COEVIT/COEDEP
      TYPCST(1) = 'R'
      TYPCST(2) = 'R'
      TYPCST(3) = 'R'

C -- TRAITEMENT DE L'ADHERENCE CONTACT / NEWTON
C -- SI PAS DE FROTTEMENT->MATRIX(1) = '&&OP0070.MATASS'
C -- SI FROTTEMENT       ->MATRIX(1) = '&&NMASFR.MATANG'
      IF(PHASE.EQ.'FLAMBEMENT') THEN
         PHASE='PREDICTION'
      ENDIF

C -- INCREMENT DE DEPLACEMENT NUL EN PREDICTION

      IF (PHASE.EQ.'PREDICTION') DEPDEL = '&&CNPART.ZERO'


C ======================================================================
C                   REASSEMBLAGE OU NON DE LA MATRICE
C ======================================================================

      REINCR = NINT(PARMET(1))
      REITER = NINT(PARMET(2))

C -- PASSAGE A LA MATRICE ELASTIQUE EN-DESSOUS DE PAS_MINI_ELAS

      METCOR = METHOD(2)
      METPRE = METHOD(5)

      INSTAM = DIINST(PARTPS, NUMINS-1)
      INSTAP = DIINST(PARTPS, NUMINS  )
      PASMIN = PARMET(3)
      IF (ABS(INSTAP-INSTAM) .LT. PASMIN) THEN
        REINCR = 1
        REITER = NINT(PARMET(4))
        METPRE = 'SECANTE'
        METCOR = 'SECANTE'

      END IF

C -- PHASE DE CORRECTION

      IF (PHASE.EQ.'CORRECTION' .OR. PHASE.EQ.'FORCES_INT') THEN

C      CORRECTION TANGENTE
        IF ((METCOR.EQ.'TANGENTE').OR.(METCOR.EQ.'SECANTE')) THEN
          REASMA = .FALSE.
          IF (REITER.NE.0) REASMA = MOD(ITERAT+1,REITER) .EQ. 0

C SI CONTACT/FROTTEMENT, ON FORCE LE REASSEMBLAGE A LA
C PREMIERE ITERATION
        CALL CFDISC(DEFICO,RESOCO,IBID,IBID,IBID,MATTAN)
        IF (MATTAN.EQ.1) THEN
             REASMA = .TRUE.
        ENDIF
C      CORRECTION ELASTIQUE
        ELSE
          REASMA = .FALSE.
        END IF

        IF (REASMA) THEN
          IF (METCOR.EQ.'TANGENTE') THEN
            OPTION = 'FULL_MECA'
          ELSE
            OPTION = 'FULL_MECA_ELAS'
          ENDIF
        ELSE
          OPTION = 'RAPH_MECA'
        END IF

C -- PHASE DE PREDICTION

      ELSE IF (PHASE.EQ.'PREDICTION') THEN

C      PREDICTION TANGENTE
        IF (METPRE.EQ.'TANGENTE') THEN
          OPTION = 'RIGI_MECA_TANG'

        ELSE IF (METPRE.EQ.'SECANTE') THEN
          OPTION = 'RIGI_MECA_ELAS'

C      PREDICTION ELASTIQUE OU EXTRAPOLATION
        ELSE
          OPTION = 'RIGI_MECA'
        END IF

        IF ((REINCR.EQ.0) .AND. (NUMINS.NE.1)) REASMA = .FALSE.
        IF (NUMINS.EQ.1) REASMA = .TRUE.
        IF ((REINCR.NE.0) .AND. (NUMINS.NE.1)) THEN
          REASMA = MOD(NUMINS-1,REINCR) .EQ. 0
        END IF

      ELSE
        CALL U2MESS('F','ALGORITH8_18')
      END IF

      IF (PHASE.EQ.'FORCES_INT') GO TO 9999


C ======================================================================
C               CALCUL DES MATRICES TANGENTES ELEMENTAIRES
C ======================================================================
      IF (REASMA) THEN

        IF (PHASE.EQ.'PREDICTION') THEN
          IF (CMD(1:4).EQ.'STAT') THEN
            CALL MERIMO(MODELE,CARELE,MATE,COMREF,COMPOR,LISCHA,CARCRI,
     &                  DEPDEL,POUGD,K24BLA,K24BLA,K24BLA,VALMOI,VALPLU,
     &                  OPTION,MERIGI,VERESI,VEDIRI,ITERAT+1,TABRET)
          ELSE
            CALL MERIMO(MODELE,CARELE,MATE,COMREF,COMPOR,LISCHA,CARCRI,
     &                  DEPDEL,POUGD,STADYN,DEPENT,VITENT,VALMOI,VALPLU,
     &                  OPTION,MERIGI,VERESI,VEDIRI,ITERAT+1,TABRET)
          END IF
        END IF
      END IF


C ======================================================================
C                         ASSEMBLAGE DES MATRICES
C ======================================================================

      IF (REASMA) THEN



C === CAS DE LA DYNAMIQUE ===

        IF (CMD(1:4).EQ.'DYNA') THEN

C -- CALCUL DE LA MATRICE DE RIGIDITE
          CALL ASMARI(MERIGI,MEDIRI,NUMEDD,SOLVEU,LISCHA,
     &                K24BID,RIGID)
          CALL MTDSCR(RIGID)

C -- CALCUL DES MATRICES ELEMENTAIRES D AMORTISSEMENT
          IF (LAMORT) THEN
            CALL JEVEUO(LISCHA//'.INFC','L',JINFC)
            NBCHAR = ZI(JINFC)
            CALL JEVEUO(LISCHA//'.LCHA','L',IACHAR)
            CALL WKVECT('&&NMMATR.LISTE_CHARGE','V V K8',NBCHAR,IACHA2)
            DO 20,I = 1,NBCHAR
              ZK8(IACHA2-1+I) = ZK24(IACHAR-1+I) (1:8)
   20       CONTINUE
            CALL MEAMME('AMOR_MECA',MODELE,NBCHAR,ZK8(IACHA2),MATE,
     &                  CARELE,.TRUE.,INSTAM,MERIGI,MEMASS,MEAMOR)
            CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8B,IRET)
            IF (NBSS.GT.0) THEN
C              WRITE(6,*) 'LAMORT ',LAMORT
              CALL JEVEUO(MEAMOR(1:8)//'.REFE_RESU','E',IAREFE)
              ZK24(IAREFE-1+3) (1:3) = 'OUI'
            END IF
            CALL JEDETR('&&NMMATR.LISTE_CHARGE')
            CALL ASMAAM(MEAMOR,NUMEDD,SOLVEU,LISCHA,AMORT)
            CALL MTDSCR(AMORT)
          END IF

C -- AU PREMIER PASSAGE, INITIALISATION DES MATRICES MATASS
C -- ET MASSE
        MAESCL = DEFICO(1:16)//'.MAESCL'
        CALL JEEXIN(MAESCL,IECPCO)

C -- ASSEMBLAGE DE LA MATRICE DE MASSE ( PAS POUR LA METHODE
C -- CONTINUE)
        IF (IECPCO.GT.0) GO TO 25
          IF (PREMIE) THEN
            PREMIE = .FALSE.
            CALL ASMAMA(MEMASS,' ',NUMEDD,SOLVEU,LISCHA,
     &                  MASSE)
            CALL MTDSCR(MASSE)
          END IF
   25       CONTINUE

          LIMAT(1) = RIGID
          LIMAT(2) = MASSE
          LIMAT(3) = AMORT

C -- CALCUL DE LA MATRICE MATASS
          IF (LAMORT) THEN
            NBMAT = 3
          ELSE
            NBMAT = 2
          END IF

          CALL DETRSD('MATR_ASSE',MATRIX(1))
          CALL MTDEFS(MATRIX(1),RIGID,'V','R')
          CALL MTCMBL(NBMAT,TYPCST,COEF2,LIMAT,MATRIX(1),NOMDDL,' ')

C   NECESSAIRE POUR LA PRISE EN COMPTE DE MACRO-ELEMENT STATIQUE
          CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8B,IRET)
          IF (NBSS.GT.0) THEN
            CALL JEEXIN('&&SSRIGI.REFE_RESU',IRES)
            IF (IRES.EQ.0) THEN
              CALL MEMARE('V','&&SSRIGI',MODELE(1:8),MATE,CARELE,
     &                    'RIGI_MECA')
              CALL JEVEUO('&&SSRIGI.REFE_RESU','E',IAREFE)
              ZK24(IAREFE-1+3) (1:3) = 'OUI'
              CALL ASMATR(1,'&&SSRIGI',' ',NUMEDD,SOLVEU,LISCHA,'ZERO',
     &                    'V',1,'&&ASRSST')
              CALL MTDSCR('&&ASRSST')
            END IF
          END IF
C   FIN MACRO-ELEMENT STATIQUE

C === CAS DE LA STATIQUE ===

        ELSE

          CALL ASMARI(MERIGI,MEDIRI,NUMEDD,SOLVEU,LISCHA,
     &                K24BID,MATRIX(1))
C   NECESSAIRE POUR LA PRISE EN COMPTE DE MACRO-ELEMENT STATIQUE
          CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8B,IRET)
          IF (NBSS.GT.0) THEN
            CALL JEEXIN('&&SSRIGI.REFE_RESU',IRES)
            IF (IRES.EQ.0) THEN
              CALL MEMARE('V','&&SSRIGI',MODELE(1:8),MATE,CARELE,
     &                    'RIGI_MECA')
              CALL JEVEUO('&&SSRIGI.REFE_RESU','E',IAREFE)
              ZK24(IAREFE-1+3) (1:3) = 'OUI'
              CALL ASMATR(1,'&&SSRIGI',' ',NUMEDD,SOLVEU,LISCHA,'ZERO',
     &                    'V',1,'&&ASRSST')
              CALL MTDSCR('&&ASRSST')
            END IF
          ENDIF
C   FIN MACRO-ELEMENT STATIQUE


C      PRISE EN COMPTE DE LA MATRICE TANGENTE DES FORCES SUIVEUSES
C      (PAS DE FORCES SUIVEUSES PILOTEES)
C          IF (PHASE.NE.'PREDICTION' .OR. METPRE.NE.'EXTRAPOL') THEN
          IF (PHASE.NE.'PREDICTION' .OR. METPRE.NE.'EXTRAPOL'
     &    .OR.PHASEZ.EQ.'FLAMBEMENT') THEN
            INSTAM = DIINST(PARTPS,NUMINS-1)
            INSTAP = DIINST(PARTPS,NUMINS)
            CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,K24BID,
     &                  K24BID,K24BID,K24BID)
            CALL MECGME(MODELE,CARELE,MATE,LISCHA//'.LCHA',
     &                  LISCHA//'.INFC',INSTAP,DEPMOI,DEPDEL,MESUIV,
     &                  INSTAM,COMPOR,CARCRI)
            CALL ASCOMA(MESUIV,INSTAP,NUMEDD,SOLVEU,LISCHA,
     &                  MATRIX(1))
          END IF

        END IF

C      PRISE EN COMPTE DE LA MATRICE TANGENTE DU FROTTEMENT

        RESOCO = RESOCZ
        MAESCL = DEFICO(1:16)//'.MAESCL'
        CALL JEEXIN(MAESCL,IECPCO)
        CALL JEEXIN(DEFICO(1:16)//'.XFEM',ICONTX)

        IF (IECPCO.GT.0.OR.ICONTX.GT.0) GO TO 30
        IF (PHASE.EQ.'CORRECTION') THEN
          CALL NMASFR(DEFICO,RESOCO,MATRIX(1))
        ENDIF
   30   CONTINUE

C-------- CALCUL DE FLAMBEMENT NON LINEAIRE----ON NE FACTORISE PAS


        IF (PHASEZ.EQ.'FLAMBEMENT') THEN
            MATRIX(2) = MAPREC
            GOTO 9999
         ENDIF

C      FACTORISATION

        CALL PRERES(SOLVEU,'V',LICCVG,MAPREC,MATRIX(1))

        IF (PHASE.EQ.'PREDICTION') THEN
          CALL NMIMPR('IMPR','MATR_ASSE',METPRE,0.D0,0)
        ELSE IF (PHASE.EQ.'CORRECTION') THEN
          CALL NMIMPR('IMPR','MATR_ASSE',METCOR,0.D0,0)
        ENDIF

      ELSE
        CALL NMIMPR('IMPR','MATR_ASSE','                ',0.D0,0)
      END IF


      MATRIX(2) = MAPREC

9999  CONTINUE


      CALL JEDEMA()
      END
