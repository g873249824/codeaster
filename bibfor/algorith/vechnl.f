      SUBROUTINE VECHNL(TYPCAL,MODELE,CHARGE,INFCHA,CARELE,INST,CHTN,
     &                  VAPRIN,VAPRMO,LOSTAT,NOPASE,TYPESE,LVECHN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C CALCUL DES VECTEURS ELEMENTAIRES TERMES D EVOLUTION
C POUR LES CHARGES NON LINEAIRES ( FLUXNL, RAYONNEMENT )

C IN  TYPCAL  : TYPE DU CALCUL :
C               'THER', POUR UN CALCUL STANDARD
C               'SENS', POUR UN CALCUL DE SENSIBILITE
C IN  MODELE : NOM DU MODELE
C IN  CHARGE : LISTE DES CHARGES
C IN  INFCHA : INFORMATIONS SUR LES CHARGES
C IN  CARELE : CHAMP DE CARA_ELEM
C IN  INST   : CARTE CONTENANT LA VALEUR DU TEMPS ET AUTRES PARAMETRES
C IN  CHTN   : ITERE A L INSTANT PRECEDENT DU CHAMP DE TEMPERATURE
C IN  LOSTAT : CRITERE DE STATIONNARITE
C POUR LE CALCUL STD:
C IN  NOPASE : SANS OBJET
C IN  TYPESE : SANS OBJET
C IN  VAPRIN : SANS OBJET
C IN  VAPRMO : SANS OBJET
C POUR UN CALCUL DE SENSIBILITE
C IN  VAPRIN : VARIABLE PRINCIPALE (TEMPERATURE) A L'INSTANT COURANT
C IN  VAPRMO : VARIABLE PRINCIPALE (TEMPERATURE) A L'INSTANT PRECEDENT
C IN  NOPASE : PARAMETRE SENSIBLE
C IN  TYPESE : TYPE DE SENSIBILITE
C                0 : CALCUL STANDARD, NON DERIVE
C                SINON : DERIVE (VOIR NTTYSE)
C OUT LVECHN : VECT_ELEM
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       11/03/02 (OB): MODIFICATIONS POUR INSERER LES SECONDS MEMBRES
C                      INTRODUITS PAR LES CHARGEMENTS DES PB DERIVES.
C                      + MODIDS FORMELLES...
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C 0.1. ==> ARGUMENTS

      INTEGER TYPESE
      CHARACTER*4 TYPCAL
      CHARACTER*24 MODELE,CHARGE,INFCHA,CARELE,INST,CHTN,LVECHN
      CHARACTER*(*) NOPASE,VAPRIN,VAPRMO
      LOGICAL       LOSTAT

C 0.2. ==> COMMUNS
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

C 0.3. ==> VARIABLES LOCALES
      CHARACTER*1 C1
      CHARACTER*8 LPAIN(7),LPAOUT(1),K8BID,NEWNOM,NOMCHA,NOMCHS,NOMCH2
      CHARACTER*16 OPTION
      CHARACTER*24 LIGRMO,LCHIN(7),LCHOUT(1),CHGEOM,CHCARA(18)
      INTEGER IRET,IFM,NIV,EXICHA,NCHIN,I,NCHAR,JCHAR,JINF,
     &        ICHA,IBID,JLVN
      LOGICAL EXIGEO,EXICAR,LSENS

C====
C 1.1 PREALABLES LIES AUX OPTIONS
C====
      CALL JEMARQ()
      IF (TYPCAL.NE.'THER' .AND. TYPCAL.NE.'SENS') CALL ASSERT(.FALSE.)
      CALL INFNIV(IFM,NIV)

C LOGICAL INDICATEUR D'UN CALCUL DE SENSIBILITE (TYPESE.GT.0)
      IF (TYPCAL.EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE
        LSENS = .FALSE.
      END IF
      DO 10 I = 1,6
        LPAIN(I) = '        '
        LCHIN(I) = '                        '
   10 CONTINUE
C====
C 1.2 PREALABLES LIES AUX CHARGES
C====

      NEWNOM = '.0000000'
      LIGRMO = MODELE(1:8)//'.MODELE'
C TEST D'EXISTENCE DE L'OBJET JEVEUX CHARGE
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.NE.0) THEN
C LECTURE DU NBRE DE CHARGE NCHAR DANS L'OBJET JEVEUX CHARGE
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
C LECTURE DES ADRESSES JEVEUX DES CHARGES ET DES INFOS AFFERENTES
        CALL JEVEUO(CHARGE,'L',JCHAR)
        CALL JEVEUO(INFCHA,'L',JINF)
      ELSE
        NCHAR = 0
      END IF

C====
C 2.1 PREPARATION DES CALCULS ELEMENTAIRES
C====

      CALL MEGEOM(MODELE,'      ',EXIGEO,CHGEOM)
      CALL MECARA(CARELE,EXICAR,CHCARA)
      CALL JEEXIN(LVECHN,IRET)
      IF (IRET.EQ.0) THEN
        CALL WKVECT(LVECHN,'V V K24',2*NCHAR,JLVN)
        CALL JEECRA(LVECHN,'LONUTI',0,K8BID)
      END IF
C
C PAS DE CHARGE ==> EXIT
      IF (NCHAR.EQ.0) GO TO 70

C CHAMP LOCAL RESULTAT
      LPAOUT(1) = 'PVECTTR'
      LCHOUT(1) = '&&VECHNL.???????'
C ... LA CARTE DES NOEUDS (X Y Z)
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
C ... LA CARTE DES INSTANTS (INST DELTAT THETA KHI  R RHO)
      LPAIN(3) = 'PTEMPSR'
      LCHIN(3) = INST
C ... LE CHAM_NO T- OU (DT/DS)-
      LPAIN(4) = 'PTEMPER'
      LCHIN(4) = CHTN

C====
C 2.2 IMPRESSIONS NIVEAU 2 POUR DIAGNOSTICS...
C====

      IF (NIV.EQ.2) THEN
        WRITE (IFM,*) '*******************************************'
        WRITE (IFM,*) ' CALCUL DE SECOND MEMBRE THERMIQUE: VECHNL'
        WRITE (IFM,*)
        WRITE (IFM,*) ' TYPE DE CALCUL   :',TYPCAL
        IF (LSENS) WRITE (IFM,*) ' TYPESE/NOPASE    :',TYPESE,' ',NOPASE
        WRITE (IFM,*) ' LIGREL/MODELE    :',LIGRMO
        WRITE (IFM,*) ' OBJ JEVEUX CHARGE:',CHARGE
        WRITE (IFM,*) '            INFOCH:',INFCHA
        WRITE (IFM,*) ' NBRE DE CHARGES  :',NCHAR
        WRITE (IFM,*) ' BOUCLE SUR LES CHARGES DE TYPE NEUMANN NON-LIN'
      END IF

C====
C 3. BOUCLE SUR LES AFFE_CHAR_THER ==================================
C====

      IF (NCHAR.GT.0) THEN
        DO 60 ICHA = 1,NCHAR

C NOM DE LA CHARGE
          NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
          IF (NIV.EQ.2) THEN
            WRITE (IFM,*) ' '
            WRITE (IFM,*) '   CHARGE         :',NOMCHA
          END IF

C====
C 3.1 EST-CE UN CALCUL DE SENSIBILITE SENSIBLE ?
C     LE CHARGEMENT CONSIDERE LUI EST IL SENSIBLE (EXICHA NUL) ?
C====
          EXICHA = -1
          IF (LSENS) THEN
C LE PARAMETRE SENSIBLE NOPASE EST T'IL CONCERNE PAS CE CHARGEMENT DE
C BASE NOMCHA. SI OUI, ILS CONSTITUENT LE CHARGEMENT DERIVE NOMCHS ET
C EXICHA = 0.
            CALL PSGENC(NOMCHA,NOPASE,NOMCHS,EXICHA)
            IF (NIV.EQ.2) WRITE (IFM,*) '   EXICHA/NOMCHS  :',EXICHA,
     &          ' ',NOMCHS

            IF (EXICHA.EQ.0) THEN
C ON CONSTRUIT LES SECONDS MEMBRES ELEM DU PB DERIVE
              NOMCH2 = NOMCHS
            ELSE
C ON NE CONSTRUIT RIEN: CALCUL INSENSIBLE A CE CHARGEMENT
C ON EFFECTUERA EVENTUELLEMENT L'ASSEMBLAGE DU TERME COMPLEMENTAIRE
              EXICHA = -1
            END IF
          ELSE
C ON CONSTRUIT LES SECONDS MEMBRES ELEM DU PB STD
            EXICHA = 0
            NOMCH2 = NOMCHA
          END IF

          IF (EXICHA.EQ.0) THEN

C====
C 3.2 TEST D'EXISTENCE DE LA CL DE FLUX NON-LINEAIRE
C====
            IRET = 0
            LPAIN(2) = 'PFLUXNL'
            LCHIN(2) = NOMCH2(1:8)//'.CHTH.FLUNL.DESC'
            CALL JEEXIN(LCHIN(2),IRET)

            IF (IRET.NE.0) THEN
              IF (TYPESE.EQ.9) THEN
                OPTION = 'CHAR_SENS_FLUNL'
C CALCUL DE SENSIBILITE PAR RAPPORT AU FLUX NON-LINEAIRE: CONSTRUCTION
C DU SECOND MEMBRE IDOINE. LE FAIT DE NE PAS PRENDRE (DT/DS)-
C PERMET DE PARAMETRER L'OPTION CHAR_SENS_FLUNL.
                NCHIN = 3
              ELSE
                OPTION = 'CHAR_THER_FLUNL'
C CALCUL DU SECOND MEMBRE DU PB STD
                NCHIN = 4
              END IF
C====
C 3.2.1 PRETRAITEMENTS POUR TENIR COMPTE DE FONC_MULT
C====
              CALL GCNCO2(NEWNOM)
              LCHOUT(1) (10:16) = NEWNOM(2:8)
              CALL CORICH('E',LCHOUT(1),-1,IBID)

C====
C 3.2.2 LANCEMENT DES CALCULS ELEMENTAIRES
C====
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*) '     OPTION         :',OPTION
                DO 20 I = 1,NCHIN
                  WRITE (IFM,*) '     LPAIN/LCHIN    :',LPAIN(I),' ',
     &              LCHIN(I)
   20           CONTINUE
              END IF
              CALL CALCUL('S',OPTION,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,
     &                    LPAOUT,'V','OUI')

C INCREMENTATION DE LONUTI ET STOCKAGE DU RESULTAT
              CALL REAJRE(LVECHN,LCHOUT(1),'V')
C FIN DU IF IRET POUR FLUX_NL
            END IF

C====
C 3.3 TEST D'EXISTENCE DE LA CL DE RAYONNEMENT
C====
            IRET = 0
            LPAIN(2) = 'PRAYONF'
            LCHIN(2) = NOMCH2(1:8)//'.CHTH.RAYO .DESC'
            CALL JEEXIN(LCHIN(2),IRET)

            IF (IRET.NE.0) THEN
              IF (TYPESE.EQ.10) THEN
                OPTION = 'CHAR_SENS_RAYO_F'
C CALCUL DE SENSIBILITE PAR RAPPORT A UNE DES CARACTERISTIQUES DU
C RAYONNEMENT: CONSTRUCTION DU SECOND MEMBRE IDOINE. LE FAIT
C DE REMPLACER (DT/DS)- PAR  T+ (ET EVENTUELLEMENT T- EN TRANSITOIRE)
C PERMET DE PARAMETRER L'OPTION CHAR_SENS_RAYO_F.
                LCHIN(4) = ' '
                LPAIN(5) = 'PRAYONS'
                LCHIN(5) = NOMCHA(1:8)//'.CHTH.RAYO .DESC'
                LPAIN(6) = 'PVAPRIN'
                LCHIN(6) = VAPRIN
                IF (.NOT.LOSTAT) THEN
                  LPAIN(7) = 'PVAPRMO'
                  LCHIN(7) = VAPRMO
                  NCHIN = 7
                ELSE
                  NCHIN = 6
                END IF
              ELSE
C CALCUL DU SECOND MEMBRE DU PB STD
                NCHIN = 4
                C1 = 'R'
                IF (ZI(JINF+NCHAR+ICHA).GT.1) C1 = 'F'
                OPTION = 'CHAR_THER_RAYO_'//C1
                LPAIN(2) = 'PRAYON'//C1
                LCHIN(2) = NOMCH2(1:8)//'.CHTH.RAYO'
              END IF

C====
C 3.3.1 PRETRAITEMENTS POUR TENIR COMPTE DE FONC_MULT
C====
              CALL GCNCO2(NEWNOM)
              LCHOUT(1) (10:16) = NEWNOM(2:8)
              CALL CORICH('E',LCHOUT(1),-1,IBID)

C====
C 3.3.2 LANCEMENT DES CALCULS ELEMENTAIRES
C====
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*) '     OPTION         :',OPTION
                DO 30 I = 1,NCHIN
                  WRITE (IFM,*) '     LPAIN/LCHIN    :',LPAIN(I),' ',
     &              LCHIN(I)
   30           CONTINUE
              END IF
              CALL CALCUL('S',OPTION,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,
     &                    LPAOUT,'V','OUI')

C INCREMENTATION DE LONUTI ET STOCKAGE DU RESULTAT
              CALL REAJRE(LVECHN,LCHOUT(1),'V')
C FIN DU IF IRET POUR RAYONNEMENT
            END IF

C FIN DU IF EXICHA
          END IF

C====
C 4. EN SENSIBILITE TRANSITOIRE, CALCUL EVENTUEL TERMES COMPLEMENTAIRES
C    DU A LA PRESENCE DE FLUX NON-LINEAIRE ET DE RAYONNEMENT (ALTER EGO
C    EN NON-LINEAIRE DE LA CONDITION D'ECHANGE EN LINEAIRE)
C====
          IF (LSENS .AND. (.NOT.LOSTAT)) THEN

C====
C 4.1 EVENTUEL TERME COMPLENTAIRE DU A UN FLUX NON-LINEAIRE
C====
            LPAIN(2) = 'PFLUXNL'
            LCHIN(2) = NOMCHA(1:8)//'.CHTH.FLUNL.DESC'
            CALL JEEXIN(LCHIN(2),IRET)
            IF (IRET.NE.0) THEN
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*)
     &            '-->  CALCUL COMPLEMENTAIRE EN SENSIBILITE'
                WRITE (IFM,*) '-->  FLUX NON LINEAIRE :'
              END IF
              OPTION = 'CHAR_SENS_FLUNL'
C TERME COMPLEMENTAIRE DE SENSIBILITE PAR RAPPORT AU FLUX NON-LINEAIRE:
C CONSTRUCTION DU SECOND MEMBRE IDOINE. LE FAIT DE PRENDRE  (DT/DS)-
C PERMET DE PARAMETRER L'OPTION CHAR_SENS_FLUNL.
C ON Y RAJOUTE T- POUR EVALUER LA DERIVEE DU FLUX
              LPAIN(5) = 'PVAPRMO'
              LCHIN(5) = VAPRMO
              NCHIN = 5

C====
C 4.1.1 PRETRAITEMENTS POUR TENIR COMPTE DE FONC_MULT
C====
              CALL GCNCO2(NEWNOM)
              LCHOUT(1) (10:16) = NEWNOM(2:8)
              CALL CORICH('E',LCHOUT(1),-1,IBID)
C====
C 4.1.2 LANCEMENT DES CALCULS ELEMENTAIRES
C====
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*) '     OPTION         :',OPTION
                DO 40 I = 1,NCHIN
                  WRITE (IFM,*) '     LPAIN/LCHIN    :',LPAIN(I),' ',
     &              LCHIN(I)
   40           CONTINUE
              END IF
              CALL CALCUL('S',OPTION,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,
     &                    LPAOUT,'V','OUI')

C INCREMENTATION DE LONUTI ET STOCKAGE DU RESULTAT
              CALL REAJRE(LVECHN,LCHOUT(1),'V')
C FIN DU IF IRET POUR FLUX_NL
            END IF

C====
C 4.2 EVENTUEL TERME COMPLENTAIRE DU A UN RAYONNEMENT
C====
            LPAIN(2) = 'PRAYONF'
            LCHIN(2) = NOMCHA(1:8)//'.CHTH.RAYO .DESC'
            CALL JEEXIN(LCHIN(2),IRET)
            IF (IRET.NE.0) THEN
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*)
     &            '-->  CALCUL COMPLEMENTAIRE EN SENSIBILITE'
                WRITE (IFM,*) '-->  RAYONNEMENT :'
              END IF
              OPTION = 'CHAR_SENS_RAYO_F'
C TERME COMPLEMENTAIRE DE SENSIBILITE PAR RAPPORT AU RAYONNEMENT:
C CONSTRUCTION DU SECOND MEMBRE IDOINE. LE FAIT DE PRENDRE (DT/DS)-
C PERMET DE PARAMETRER L'OPTION CHAR_SENS_RAYO_F.
C ON Y RAJOUTE T- POUR EVALUER LE TERME DE RAYONNEMENT
              LCHIN(4) = CHTN
              LPAIN(5) = 'PVAPRMO'
              LCHIN(5) = VAPRMO
              NCHIN = 5

C====
C 4.2.1 PRETRAITEMENTS POUR TENIR COMPTE DE FONC_MULT
C====
              CALL GCNCO2(NEWNOM)
              LCHOUT(1) (10:16) = NEWNOM(2:8)
              CALL CORICH('E',LCHOUT(1),-1,IBID)
C====
C 4.2.2 LANCEMENT DES CALCULS ELEMENTAIRES
C====
              IF (NIV.EQ.2) THEN
                WRITE (IFM,*) '     OPTION         :',OPTION
                DO 50 I = 1,NCHIN
                  WRITE (IFM,*) '     LPAIN/LCHIN    :',LPAIN(I),' ',
     &              LCHIN(I)
   50           CONTINUE
              END IF
              CALL CALCUL('S',OPTION,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,
     &                    LPAOUT,'V','OUI')

C INCREMENTATION DE LONUTI ET STOCKAGE DU RESULTAT
              CALL REAJRE(LVECHN,LCHOUT(1),'V')
            END IF
          END IF
C====
C 5. FIN DE BOUCLE SUR LES CHARGES
C====
   60   CONTINUE
C FIN DU IF NCHAR
      END IF

C SORTIE DE SECOURS EN CAS D'ABSENCE DE CHARGE
   70 CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
