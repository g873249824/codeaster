      SUBROUTINE MTEMP2 ( MAILLA, TEMPE, EXITIM, TIME, NOPASE,
     &                    THVRAI, CHTEMP )
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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
C-----------------------------------------------------------------------
C     BUT:
C     ON CONSTRUIT UN CHAMP DE TEMPERATURE OU SA DERIVEE LAGRANGIENNE
C     AVEC LE CONCEPT : TEMPE ET LE TEMPS TIME,
C     SOIT PAR INTERPOLATION, SOIT PAR SIMPLE RECOPIE
C     SI L'INSTANT EST VOISIN D'UN PAS DE TEMPS CALCULE.
C
C     SI ON CONSTRUIT UN FAUX CHAMP DE TEMPERATURE, ON LE CREE COMME LA
C     TEMPERATURE DE REFERENCE (POUR EVITER DES DILATATIONS PAR DEFAUT)
C
C     IN:
C        MAILLA : NOM UTILISATEUR DU MAILLAGE
C        TEMPE  : / NOM UTILISATEUR D'1 EVOL_THER
C                 / NOM UTILISATEUR D'1 CHAMP_GD_TEMP_R
C        EXITIM : VRAI SI ON DONNE UNE VALEUR DU TEMPS TIME
C        TIME   : VALEUR REELLE DU TEMPS
C                 (CE NOM PEUT ETRE BLANC, DANS CE CAS, SI ON DOIT
C                  CREER UNE CARTE DE TEMPERATURE ON LE FAIT A 0.0)
C        NOPASE : NOM DU PARAMETRE SENSIBLE LE CAS ECHEANT
C
C     OUT:
C        THVRAI : VRAI SI ON TROUVE 1 CHAMP DE TEMPERATURE
C                 FAUX SI ON CREE 1 CHAMP DE TEMPERATURE ARBITRAIRE.
C        CHTEMP : NOM DU CHAMP DE TEMPERATURE TROUVE (OU CREE).
C
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       11/12/00 (OB): TOILETTAGE FORTRAN, CREATION.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*(*) TEMPE
      CHARACTER*8 MAILLA
      CHARACTER*(*) CHTEMP
      CHARACTER*(*) NOPASE
      LOGICAL THVRAI,EXITIM
      REAL*8 TIME
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR,TIME2
      REAL*8 VALR
      COMPLEX*16 ZC,CBID
      LOGICAL ZL
      CHARACTER*8 ZK8,K8BID
      CHARACTER*16 ZK16,TYSD
      CHARACTER*24 ZK24
      CHARACTER*24 VALK(2)
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80

C -------------------------------------------------------------------

C DECLARATION VARIABLES LOCALES
C
C
      INTEGER NBCHAM,IERD,ICORET,IRET,IBID
      INTEGER VALI
      CHARACTER*1 BASE
      CHARACTER*19 CH19
      CHARACTER*16 NOMCHA,TABTYP(4)


      BASE   = 'V'

C     -- SI LE CHAMP CHTEMP EXISTE DEJA , ON LE DETRUIT:
      CALL DETRSD('CHAMP_GD',CHTEMP(1:19))

      IF (TEMPE(1:8).NE.'        ') THEN
        THVRAI = .TRUE.

        CALL GETTCO(TEMPE(1:8),TYSD)
C
C            DANS LE CAS D'UN CALCUL DERIVE
C            REMARQUE : IL FAUT APPLIQUER GETTCO SUR LA STRUCTURE
C            PREMIERE CAR LE TYPE DES STRUCTURES DERIVEES EST INCONNU
C            PAR GETTCO, FONCTION SUPERVISEUR
C
        IF ( NOPASE.NE.' ' ) THEN
          K8BID = TEMPE
          CALL PSRENC ( K8BID, NOPASE, TEMPE, IRET )
          IF ( IRET.NE.0 ) THEN
            VALK(1) = TEMPE
C                     12345678   9012345678901234
            VALK(2) = NOPASE  //'                '
            CALL U2MESK('F','SENSIBILITE_3', 2 ,VALK)
          ENDIF
        ENDIF


         IF (TYSD(1:9).EQ.'EVOL_THER') THEN
C           ----------------------------
            CALL DISMOI('F','NB_CHAMP_MAX',TEMPE(1:8),'RESULTAT',NBCHAM,
     &                  K8BID,IERD)
            IF (NBCHAM.GT.0) THEN
               IF ( .NOT.EXITIM ) THEN
                 CALL U2MESS('I','CALCULEL3_64')
                  TIME2 = 0.0D0
                  IF (NBCHAM.GT.1) THEN
                     CALL U2MESS('F','CALCULEL3_75')
                  END IF
               ELSE
                  TIME2 = TIME
               END IF

C DETERMINATION DU TYPE DE CHAMP A RECUPERER
               NOMCHA = 'TEMP'

C              RECUPERATION DU CHAMP DE TEMPERATURE DANS TEMPE:
C              ------------------------------------------------
               CALL RSINCH(TEMPE(1:8),NOMCHA,'INST',TIME2,CHTEMP(1:19),
     &                     'CONSTANT','CONSTANT',1,BASE,ICORET)
               IF (ICORET.GE.10) THEN
                 VALK (1) = TEMPE(1:8)
                 VALK (2) = NOMCHA
                 VALR = TIME2
                 VALI = ICORET
                 CALL U2MESG('F', 'CALCULEL6_16',2,VALK,1,VALI,1,VALR)
               END IF

            ELSE
              CALL U2MESK('F','CALCULEL3_76',1,TEMPE(1:8))
            END IF

         ELSE IF ((TYSD(1:5).EQ.'CHAM_') .OR.
     &            (TYSD(1:6).EQ.'CARTE_')) THEN
C           -----------------------------------
            TABTYP(1)='CARTE#TEMP_F'
            TABTYP(2)='CARTE#TEMP_R'
            TABTYP(3)='NOEU#TEMP_R'
            TABTYP(4)='ELXX#TEMP_R'
            CALL CHPVE2('F',TEMPE,4,TABTYP,IRET)
            CH19 = TEMPE(1:8)
            CALL COPISD('CHAMP_GD','V',CH19,CHTEMP(1:19))
            CALL JEDETR(CHTEMP(1:19)//'.TITR')

         ELSE
           CALL U2MESS('F','UTILITAI_67')
         END IF
      ELSE

         THVRAI = .FALSE.

C        CREATION D'UN CHAMP BIDON (CARTE NULLE)
C        ------------------------------------------------------------

         CALL MECACT('V',CHTEMP(1:19),'MAILLA',MAILLA,'TEMP_R',1,
     &   'TEMP',IBID,0.0D0,CBID,'  ')
      END IF
C
      END
