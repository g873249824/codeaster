      SUBROUTINE SEMOCO(LRAIDE,LAMOR,LMASSE,NEQ,MXRESF,NBMODE,
     &                  FREQ,VECT,
     &                  NBPARI,NBPARR,NBPARK,NBPARA,NOPARA,
     &                  RESUI,RESUK)

C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/12/2008   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C SENSIBILITE MODES COMPLEXES
C HYPOTHESES : MODES SIMPLES, DERIVEE AMOR NULLE
C-----------------------------------------------------------------------

      IMPLICIT NONE

C PARAMETRES D'APPELS
      INTEGER LRAIDE,LAMOR,LMASSE,NEQ,MXRESF,NBMODE,RESUI(MXRESF,*)
      INTEGER NBPARI,NBPARR,NBPARK,NBPARA
      REAL*8 FREQ(MXRESF,*)
      COMPLEX*16 VECT(NEQ,*)
      CHARACTER*(*) NOPARA(*)
      CHARACTER*24 RESUK(MXRESF,*)

C ENTREES :
C LRAIDE : DESCRIPTEUR MATRICE RAIDEUR
C LAMOR : DESCRIPTEUR MATRICE AMORTISSEMENT
C LMASSE : DESCRIPTEUR MATRICE MASSE
C NEQ : NOMBRE DE DDL
C MXRESF : PARAMETRE DE DIMENSIONNEMENT DE RESUI E RESUK
C NBMODE : NOMBRE DE MODES CALCULES
C FREQ : FREQUENCES PROPRES ET VALEURS PROPRES
C VECT : VECTEURS PROPRES
C NBPARI,NBPARR,NBPARK,NBPARA,NOPARA : PARAMETRES CALCUL MODAL
C RESUI : VECTEUR ENTIER CALCUL MODAL
C RESUK : VECTEUR CHAR CALCUL MODAL

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C VARIABLES LOCALES

      LOGICAL SECAL
      INTEGER IAUX,JAUX,NBPASE,IRET,TYPESE,IBID
      INTEGER IEQ,NRPASE,NUMODE,NPARR,NCHAR,NBNO
      INTEGER JDVEC,LDVEC,LDVAL,INEG,IPREC,ILGCON,LXLGUT,JDVEM
      INTEGER JVALE,JVECTC,MULT,IMODE,LRESUK,LRESUI,JTRAV
      REAL*8 R8BID,TEMPS,R8DEPI,OMEGA2,DIFF,EPSCR,R8VIDE,UNDF
      COMPLEX*16 CDVAL,CBID
      CHARACTER*1 VTYP
      CHARACTER*4 TYPCAL
      CHARACTER*6 NOMPRO
      CHARACTER*8  BASENO,NOMRES,NOPASE,RESULT,MAILLA,NOMGD,BLAN8
      CHARACTER*13 INPSCO
      CHARACTER*14 VECTC,VTRAV
      CHARACTER*16 TYPCON,NOMCMD,NOMSY,DRESUI,DRESUK
      CHARACTER*19 LIGRMO,RAIDE,INFCHA,MASSE,K19BID
      CHARACTER*21 DVALPR,DVECPR
      CHARACTER*22 DVECTK,DVECTM
      CHARACTER*24 STYPSE,MODELE,VECHMP,VACHMP,K24BID,INFOCH,NUMEDD
      CHARACTER*24 MATE,CARELE,LCHAR,VAPRIN,PRCHNO,CHAMNO,CHARGE

      PARAMETER (NOMPRO = 'SEMOCO')

      CALL JEMARQ()
      VECHMP = ' '

      UNDF = R8VIDE()

      CALL GETRES(NOMRES,TYPCON,NOMCMD)

      CALL GETVID(' ','MATR_A',1,1,1,RAIDE,IRET)
      CALL GETVID(' ','MATR_B',1,1,1,MASSE,IRET)

      CALL DISMOI('F','NOM_MODELE',RAIDE,'MATR_ASSE',IBID,MODELE,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,NUMEDD,IRET)
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)
      CALL DISMOI('F','NB_NO_MAILLA',MAILLA,'MAILLAGE',NBNO,K24BID,IRET)
      CALL DISMOI('F','NOM_GD',NUMEDD,'NUME_DDL',IBID,NOMGD,IRET)

C GRANDEUR COMPLEXE
      IRET = LXLGUT(NOMGD)
      NOMGD = NOMGD(1:IRET-2)//'_C'
      VTYP = 'C'

      PRCHNO = NUMEDD(1:14)//'.NUME'
      BASENO = '&&'//NOMPRO
      INPSCO = BASENO//'_PSCO'
      LIGRMO = MODELE(1:8)//'.MODELE'

C SORTIE EN ERREUR FATALE SI PB DANS PSLECT (IAUX = 1)
      IAUX = 1
      JAUX = 1
      CALL PSLECT(' ',JAUX,BASENO,NOMRES,IAUX,NBPASE,INPSCO,IRET)

      BLAN8  = '        '

      CALL NMDOME(MODELE,MATE,CARELE,INFCHA,NBPASE,INPSCO,
     &               BLAN8,IBID)

C VARIABLES NECESSAIRES POUR STOCKAGE DE LA SD RESULTATS
      INEG = 0
      IPREC = 0
      IF (TYPCON.EQ.'MODE_ACOU') THEN
        NOMSY = 'PRES'
        NPARR = 7
      ELSE
        NOMSY = 'DEPL'
        NPARR = NBPARR
      ENDIF

C  BOUCLE SUR LES PARAMETRES SENSIBLES
      DO 100 NRPASE = 1,NBPASE

C -- NOM DU PARAMETRE DU PARAMETRE SENSIBLE, JAUX = 1
        JAUX = 1
        CALL PSNSLE(INPSCO,NRPASE,JAUX,NOPASE)

C -- NOM DU CONCEPT RESULTAT, JAUX = 3
        JAUX = 3
        CALL PSNSLE(INPSCO,NRPASE,JAUX,RESULT)

        CALL METYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)

C -- REPERAGE DU TYPE DE DERIVATION (TYPESE)
C             0 : CALCUL STANDARD
C            -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C             1 : DERIVEE SANS INFLUENCE
C             2 : DERIVEE DE LA CL DE DIRICHLET
C             3 : PARAMETRE MATERIAU
C             4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C             5 : FORCE
C             N : AUTRES DERIVEES

        SECAL = .FALSE.

        DVALPR = BASENO//'_D_VAL_PROPRE'
        DVECPR = BASENO//'_D_VEC_PROPRE'
        CALL WKVECT(DVALPR,'V V R',NBPARR*MXRESF,LDVAL)
        CALL WKVECT(DVECPR,'V V C',NEQ*MXRESF,LDVEC)

        DRESUI = BASENO//'_D_RESUI'
        DRESUK = BASENO//'_D_RESUK'
        CALL WKVECT(DRESUI,'V V I',NBPARI*MXRESF,LRESUI)
        CALL WKVECT(DRESUK,'V V K24',NBPARK*MXRESF,LRESUK)

C INITIALISATION PARAMETRES SUR LES DERIVEES DES MODES PROPRES

        DO 110 NUMODE = 1,NBMODE
          DO 111 IEQ = 1,NBPARR
            ZR(LDVAL-1+MXRESF*(IEQ-1)+NUMODE) = UNDF
111       CONTINUE
          DO 112 IEQ = 1,NBPARI
            ZI(LRESUI-1+MXRESF*(IEQ-1)+NUMODE) = RESUI(NUMODE,IEQ)
112       CONTINUE
          DO 113 IEQ = 1,NBPARK
            ZK24(LRESUK-1+MXRESF*(IEQ-1)+NUMODE) = RESUK(NUMODE,IEQ)
113       CONTINUE
110     CONTINUE

C  BOUCLE SUR LES MODES
        DO 120 NUMODE = 1,NBMODE

C  STOCKAGE DU VECTEUR PROPRE NUMODE DANS VAPRIN

          DVECTK = BASENO//'_DK_S_DP_VECT'
          CALL WKVECT(DVECTK,'V V C',NEQ,JDVEC)
          DVECTM = BASENO//'_DM_S_DP_VECT'
          CALL WKVECT(DVECTM,'V V C',NEQ,JDVEM)
C   INITIALISATION DES VECTEURS DERIVEE
          DO 121 IEQ = 1,NEQ
            ZC(JDVEC-1+IEQ) = DCMPLX(0.D0,0.D0)
            ZC(JDVEM-1+IEQ) = DCMPLX(0.D0,0.D0)
121       CONTINUE

          JAUX = 4
          CALL PSNSLE(INPSCO,0,JAUX,VAPRIN)
          CALL JEEXIN(VAPRIN(1:19)//'.REFE',IRET)
          IF (IRET.EQ.0) CALL VTCREM(VAPRIN(1:19),MASSE,'V',VTYP)
          CALL JEVEUO(VAPRIN(1:19)//'.VALE','E',JVALE)
          DO 221 IEQ = 1, NEQ
            ZC(JVALE-1+IEQ) = VECT(IEQ,NUMODE)
221       CONTINUE

C -- DERIVATION EULERIENNE

          IF (TYPESE.EQ.-1) THEN
            SECAL = .FALSE.
C NON TRAITE POUR L INSTANT
          ENDIF

C -- LES DERIVEES SANS INFLUENCE

          IF (TYPESE.EQ.1) THEN
            SECAL = .TRUE.
            DO 122 IEQ = 1,NEQ
              ZC(JDVEC-1+IEQ) = DCMPLX(0.D0,0.D0)
              ZC(JDVEM-1+IEQ) = DCMPLX(0.D0,0.D0)
122         CONTINUE
          ENDIF

C -- LES DIRICHLETS

          IF (TYPESE.EQ.2) THEN
            SECAL = .TRUE.
            CALL PSNSLE(INPSCO,NRPASE,11,VECHMP)
            TEMPS = 0.D0
            CHARGE = '&&BIDON'
            CALL VEDIME(MODELE,CHARGE,INFOCH,TEMPS,VTYP,
     &                  TYPESE,NOPASE,VECHMP)
            CALL ASASVE(VECHMP,NUMEDD,VTYP,VACHMP)
            CALL JEVEUO(VACHMP,'L',IRET)
            CALL JEVEUO(ZK24(IRET)(1:19)//'.VALE','E',JDVEC)
          ENDIF

C -- LES PARAMETRES MATERIAUX (ATTENTION VERSION TEMPORAIRE)
C ON NE TRAITE PAS POUR L INSTANT LA DERIVEE DE MASSE NI AMOR
C PAR RAPPORT AU PARAMETRE MATERIAU

          IF (TYPESE.EQ.3) THEN
            SECAL = .TRUE.
            TYPCAL = 'DYNK'
            NCHAR = 0
            LCHAR = K24BID
            CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,
     &                  CARELE(1:8),R8BID,VAPRIN,K24BID,
     &                  K19BID,K24BID,LIGRMO,
     &                  NOPASE,VECHMP)
            VACHMP = K24BID
            CALL ASASVE(VECHMP,NUMEDD,VTYP,VACHMP)
            CALL JEVEUO(VACHMP,'L',IRET)
            CALL JEVEUO(ZK24(IRET)(1:19)//'.VALE','E',JDVEC)
          ENDIF

C -- LES CARACTERISTIQUES ELEMENTAIRES

          IF (TYPESE.EQ.4) THEN
            SECAL = .TRUE.
            TYPCAL = 'DYNK'
            NCHAR = 0
            LCHAR = K24BID
            CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,
     &                  CARELE(1:8),R8BID,VAPRIN,K24BID,
     &                  K19BID,K24BID,LIGRMO,
     &                  NOPASE,VECHMP)
            VACHMP = K24BID
            CALL ASASVE(VECHMP,NUMEDD,VTYP,VACHMP)
            CALL JEVEUO(VACHMP,'L',IRET)
            CALL JEVEUO(ZK24(IRET)(1:19)//'.VALE','E',JDVEC)


C           ATTENTION : LE BLOC SUIVANT VA ECRASER VACHMP.
C           IL FAUT DONC RECOPIER DANS UN OBJET TEMPORAIRE :
            CALL JEDETR('&&SEMOCO.TMP1')
            CALL JEDUPO(ZK24(IRET)(1:19)//'.VALE','V','&&SEMOCO.TMP1',
     &           .FALSE.)
            CALL JEVEUO('&&SEMOCO.TMP1','E',JDVEC)


C ET POUR LA DERIVATION PAR RAPPORT A LA MASSE
            TYPCAL = 'DYNM'
            CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,
     &                  CARELE(1:8),R8BID,VAPRIN,K24BID,
     &                  K19BID,K24BID,LIGRMO,
     &                  NOPASE,VECHMP)
            VACHMP = K24BID
            CALL ASASVE(VECHMP,NUMEDD,VTYP,VACHMP)
            CALL JEVEUO(VACHMP,'L',IRET)
            CALL JEVEUO(ZK24(IRET)(1:19)//'.VALE','E',JDVEM)
          ENDIF

C -- CHARGEMENTS DE NEUMANN

          IF (TYPESE.EQ.5) THEN
            SECAL = .FALSE.
C PAS DE CHARGEMENT DE NEUMANN DANS LES CALCULS MODAUX
          ENDIF

          IF (.NOT.SECAL) THEN
            CALL U2MESI('F','SENSIBILITE_1', 1 , TYPESE)
          ENDIF

          DO 123 IEQ = 1,NEQ
            ZC(JDVEC-1+IEQ) = -ZC(JDVEC-1+IEQ)
            ZC(JDVEM-1+IEQ) = -ZC(JDVEM-1+IEQ)
123       CONTINUE

C ALARME SI FORTE PROBABILITE MODES MULTIPLES

C EPSCR : SEUIL DE DETECTION DE MODES MULTIPLES
C         VALEUR A AFFINER SI BESOIN

          EPSCR = 1.D-8
          OMEGA2 = FREQ(NUMODE,2)
          MULT = 0
          DO 124 IMODE = 1,NBMODE
            IF (OMEGA2 .LT. EPSCR) THEN
              DIFF = ABS(OMEGA2-FREQ(IMODE,2))
            ELSE
              DIFF = ABS(OMEGA2-FREQ(IMODE,2))/OMEGA2
            ENDIF
            IF (DIFF .LT. EPSCR) MULT = MULT+1
124       CONTINUE
          IF (MULT .GT. 1) THEN
            CALL U2MESI('F','SENSIBILITE_12',1,MULT)
          ENDIF

          VECTC = BASENO//'_VECTC'
          CALL WKVECT(VECTC,'V V C',NEQ,JVECTC)

          DO 125 IEQ = 1,NEQ
            ZC(JVECTC-1+IEQ) = VECT(IEQ,NUMODE)
125       CONTINUE

          VTRAV = BASENO//'_VTRAV'
          CALL WKVECT(VTRAV,'V V C',NEQ,JTRAV)

          CALL CASEMO(LRAIDE,LAMOR,LMASSE,NEQ,MXRESF,NBMODE,
     &        FREQ,ZC(JVECTC),
     &        NUMODE,ZC(JDVEC),ZC(JDVEM),CDVAL,ZC(JTRAV))

          DO 135 IEQ = 1,NEQ
            ZC(LDVEC-1+(NUMODE-1)*NEQ+IEQ) = ZC(JTRAV-1+IEQ)
135       CONTINUE

          CALL JEDETR(VTRAV)

C CALCUL DERIVEE FREQUENCE (CDVAL : DERIVEE DE LAMBDA)

          R8BID = FREQ(NUMODE,3)
          CBID = CDVAL/DCMPLX(-R8BID,SQRT(1.D0-R8BID*R8BID))
          ZR(LDVAL-1+NUMODE) = DBLE(CBID)/R8DEPI()

          CALL JEDETR(DVECTK)
          CALL JEDETR(DVECTM)
          CALL JEDETR(VECTC)

C FIN BOUCLE SUR LES MODES
120     CONTINUE

C CREATION DE LA STRUCTURE DE DONNEES RESULTATS

C RSCRSD N APPRECIE PAS LES MODE_MECA_C
        ILGCON = LXLGUT(TYPCON)
        IF (TYPCON(ILGCON-1:ILGCON) .EQ. '_C') ILGCON = ILGCON-2
        CALL RSCRSD('G',RESULT,TYPCON(:ILGCON),NBMODE)

        DO 130 NUMODE=1,NBMODE
          CALL RSEXCH(RESULT,NOMSY,NUMODE,CHAMNO,IRET)
          CALL CRCHNO(CHAMNO,PRCHNO,NOMGD,MAILLA,'G',
     &                VTYP,NBNO,NEQ)
130     CONTINUE


        CALL VPSTOR(INEG,VTYP,RESULT,NBMODE,NEQ,R8BID,ZC(LDVEC),
     &              MXRESF,NBPARI,NPARR,NBPARK,NOPARA,'    ',
     &              ZI(LRESUI),ZR(LDVAL),ZK24(LRESUK),IPREC)

        CALL JEDETR(DVALPR)
        CALL JEDETR(DVECPR)
        CALL JEDETR(DRESUI)
        CALL JEDETR(DRESUK)

C FIN BOUCLE SUR PARAMETRES SENSIBLES
100   CONTINUE

      CALL JEDETC('V',BASENO,1)

      CALL JEDEMA()
C
      END
