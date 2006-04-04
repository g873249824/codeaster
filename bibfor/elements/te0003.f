      SUBROUTINE TE0003(OPTION,NOMTE)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE BOITEAU O.BOITEAU
C TOLE CRP_20
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DE L'ESTIMATEUR D'ERREUR EN RESIDU
C      SUR UN ELEMENT ISOPARAMETRIQUE 2D/3D, LUMPE OU NON, VIA L'OPTION
C     'ERTH_ELEM_THER_F/R'

C IN OPTION : NOM DE L'OPTION
C IN NOMTE  : NOM DU TYPE D'ELEMENT

C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       MESSAGE:UTMESS,INFNIV,UTDEBM,UTIMPI,UTFINM.
C       JEVEUX:JEMARQ,JEDEMA,JEVETE,JEVEUO,JELIRA,JENUNO.
C       CHAMP LOCAUX:JEVECH,TECACH.
C       ENVIMA:R8PREM,R8MIEM.
C       ELEMENTS FINIS:DFDM2D,DFDM3D.
C       MATERIAUX/CHARGES:RCVALA,RCCOMA,FOINTE.
C       NON LINEAIRE: NTFCMA,RCFODE.
C       DEDIEES A TE0003:UTHK,UTJAC,UTINTC,UTIN3D,UTNORM,UTNO3D,
C                        UTVOIS,UTERFL,UTEREC,UTERSA,UTNBNV.

C     FONCTIONS INTRINSEQUES:
C       ABS,SQRT,SIGN.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       22/06/01 (OB): CREATION EN S'INSPIRANT DE TE0377.F (2D) ET DE
C                      TE0375.F (3D).
C       05/02/02 (OB): EXTENSION AUX EFS LUMPES.
C       10/06/02 (OB): CORRECTION BUG DES ELREFE.
C       22/08/02 (OB): RAJOUT TABNIV POUR NIVEAU DIFFERENCIE SI INFO=2
C               RAJOUT DE L'OBJET '&&RESTHE.JEVEUO' POUR AMELIORER LES
C               PERFORMANCES DE RESTHE/CALCUL/TE0003.
C       12/09/02 (OB): ELIMINATION ALARME DU A LA DIVISION PAR ZERO
C                POUR CONSTRUIRE ERTREL + AFFICHAGES SUPL. SI INFO=2.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*16 OPTION,NOMTE

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C DECLARATION VARIABLES LOCALES
      INTEGER JGANO,NNO,NPG1,IPOIDS,IVF,IDFDE,IGEOM,
     &        IFLUM,IFLUP,ISOUR,IMATE,ICHARG,IVOIS,IERRE,I,ITEMM,ITEMP,
     &        J,KP,K,ICODE,I1,NDIM,IJ,I2,MCELD,MCELV,PCELD,PCELV,IAUX1,
     &        IAVAF,NCMPF,IAVAH,NCMPH,NARET,NSOMM,INO,JNO,MNO,TYPMC,
     &        TYPMV,IMAV,IRET,IAPTMA,IENTF,IENTH,IENTT,IAVAT,NCMPT,NBSV,
     &        NBNV,JAD,JADV,IGREL,IEL,IAVALP,IAVALM,IAREPE,IFM,NIV,
     &        NIVEAU,IFON(3),NBPAR,ITYP,NDEGRE,
     &        NSOMM2,IDFDX,IDFDX2,IDFDY,IDFDY2,IPG,NPGF,NPGF2,
     &        NOE(9,6,3),TABNIV(20),IJEVEO,NNOS
      REAL*8 R8PREM,INSOLD,INST,VALTHE,AUX,RHOCP,DFDX(27),DFDY(27),
     &       POIDS,R,VALFP(9),VALFM(9),R8CART,VALPAR(4),VALSP,VALSM,
     &       VALUNT,TERBUF,TEMPM,TEMPP,FLUXM(3),FLUXP(3),FFORME,DELTAT,
     &       R8MIEM,PREC,OVFL,DER(6),FLURP,FLURM,UNSURR,X3,Y3,XN(9),
     &       YN(9),ZN(9),TERM22,JAC(9),HK,HF,ZRJNO1,ZRJNO2,ZRINO1,
     &       ZRINO2,POINC1,POINC2,VALHP(9),VALHM(9),VALTP(9),VALTM(9),
     &       R8CAR1,ERTABS,ERTREL,TERMNO,TERMVO,TERMSA,TERMFL,TERMEC,
     &       TERMV1,TERMV2,TERMS1,TERMS2,TERMF1,TERMF2,TERME1,TERME2,
     &       JACOB,UNSURD,R8BID,RHOCPM,RHOCPP,DFDZ(27),X,Y,Z,POIDS1(27),
     &       POIDS2(27),POIDS3(27)
      CHARACTER*2 CODRET,FORMV
      CHARACTER*3 NOMT3
      CHARACTER*4 EVOL
      CHARACTER*8 MA,NOMPAR(4),TYPMAC,TYPMAV,K8CART,K8CAR1,ELREFE,ELREF2
      CHARACTER*16 PHENOM
      CHARACTER*19 CARTEF,CARTEH,CARTET,CARTES,NOMGDF,NOMGDH,NOMGDT,
     &             NOMGDS,LIGREL,CHFLUM,CHFLUP
      CHARACTER*32 JEXNUM
      LOGICAL LEVOL,LTHETA,LAXI,LMAJ,LNONLI,L2D,LLUMPE,LTEATT

C DATA POUR 3D
C TABLEAU DES NUMEROS DE NOEUDS FACE ET PAR TYPE D'ELEMENT 3D
      DATA NOE/1,2,3,4,9,10,11,12,21,  3,7,8,4,15,19,16,11,24,
     &         5,8,7,6,20,19,18,17,26, 1,5,6,2,13,17,14,9,22,
     &         2,6,7,3,14,18,15,10,23, 4,8,5,1,16,20,13,12,25,
     &         1,2,3,7,8,9,3*0,        4,6,5,15,14,13,3*0,
     &         1,4,5,2,10,13,11,7,0,   2,5,6,3,11,14,12,8,0,
     &         1,3,6,4,9,12,15,10,0,   9*0,
     &         1,2,3,5,6,7,3*0,        2,4,3,9,10,6,3*0,
     &         3,4,1,10,8,7,3*0,       1,4,2,8,9,5,3*0,
     &         9*0,                    9*0/
C--------------------------------------------------------------------
C INITIALISATIONS/RECUPERATION DE LA GEOMETRIE ET DES CHAMPS LOCAUX
C--------------------------------------------------------------------
      CALL JEMARQ()

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,
     &              JGANO)

C INITIALISATION DIMENSION DE L'ESPACE DE TRAVAIL/LLUMPE OU PAS
      NOMT3 = NOMTE(5:7)
      IF ((NOMT3.EQ.'TR3') .OR. (NOMT3.EQ.'QU4') .OR.
     &    (NOMT3.EQ.'TR6') .OR. (NOMT3.EQ.'QU8') .OR.
     &    (NOMT3.EQ.'QU9')) THEN
        L2D = .TRUE.
        LLUMPE = .FALSE.
      ELSE IF ((NOMT3.EQ.'TL3') .OR. (NOMT3.EQ.'QL4') .OR.
     &         (NOMT3.EQ.'TL6') .OR. (NOMT3.EQ.'QL8') .OR.
     &         (NOMT3.EQ.'QL9')) THEN
        L2D = .TRUE.
        LLUMPE = .TRUE.
      ELSE
        L2D = .FALSE.
        IF (NOMTE(12:13).NE.'_D' .AND. NOMTE(11:12).NE.'_D') THEN
          LLUMPE = .FALSE.
        ELSE
          LLUMPE = .TRUE.
        END IF
      END IF

C INIT. GENERALES (PARAM NUMERIQUE, INTERPOLATION, FLAG SI AXI...)
      PREC = R8PREM()
      OVFL = R8MIEM()
      NBPAR = NDIM + 1
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(NBPAR) = 'INST'
      IF (L2D) THEN
        IF (LTEATT(' ','AXIS','OUI')) THEN
          LAXI = .TRUE.
        ELSE
          LAXI = .FALSE.
        END IF
      ELSE
        LAXI = .FALSE.
        NOMPAR(3) = 'Z'
      END IF

C RECUPERATION DES ADRESSES DES CHAMPS LOCAUX ASSOCIES AUX PARAMETRES:
C GEOMETRIE (IGEOM), FLUX TEMP - ET +(IFLUM ET IFLUP),SOURCE (ISOUR),
C MATERIAU (IMATE),CHARGE (ICHARG),VOISIN (IVOIS),ERREUR (IERR).
C FLAG EVOL='EVOL' OU '',THETA (VALTHE),INSTANT - ET + (INSOLD/INST)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCHARG','L',ICHARG)
      EVOL = ZK24(ICHARG+15)
      IF (EVOL.EQ.'EVOL') THEN
        CALL JEVECH('PTEMP_M','L',ITEMM)
        CALL JEVECH('PFLUX_M','L',IFLUM)
        READ (ZK24(ICHARG+13),'(F19.8)') INSOLD
        READ (ZK24(ICHARG+12),'(F19.8)') VALTHE
        VALUNT = 1.D0 - VALTHE
        LEVOL = .TRUE.
      ELSE
        VALTHE = 1.D0
        VALUNT = 0.D0
        LEVOL = .FALSE.
      END IF

      READ (ZK24(ICHARG+14),'(F19.8)') INST
C FIN DE LECTURE DE LA CARTE ETENDUE: LECTURE VECT '&&RESTHE.JEVEUO'
      READ (ZK24(ICHARG+16),'(I24)') IJEVEO
      NIVEAU = ZI(IJEVEO)
      IFM = ZI(IJEVEO+1)
      NIV = ZI(IJEVEO+2)
      IAREPE = ZI(IJEVEO+3)
      MCELD = ZI(IJEVEO+4)
      MCELV = ZI(IJEVEO+5)
      PCELD = ZI(IJEVEO+6)
      PCELV = ZI(IJEVEO+7)
      IAVAF = ZI(IJEVEO+8)
      NCMPF = ZI(IJEVEO+9)
      IAVAH = ZI(IJEVEO+10)
      NCMPH = ZI(IJEVEO+11)
      IAVAT = ZI(IJEVEO+12)
      NCMPT = ZI(IJEVEO+13)

      CALL JEVECH('PTEMP_P','L',ITEMP)
      CALL JEVECH('PFLUX_P','L',IFLUP)
      CALL TECACH('ONN','PSOURCR',1,ISOUR,IRET)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PVOISIN','L',IVOIS)
      CALL JEVECH('PERREUR','E',IERRE)

C NIVEAU D'AFFICHAGE DIFFERENCIE PAR ROUTINE (0: RIEN, 2 AFFICHAGE)
      DO 10 I = 1,20
        TABNIV(I) = 0
   10 CONTINUE
      IF (NIV.EQ.2) THEN
C INFO GENERALES SUR L'ELEMENT K
        TABNIV(1) = 2
        TABNIV(2) = 0
C POUR UTHK: INFO SUR LE DIAMETRE DE L'ELEMENT K
        TABNIV(3) = 2
C AFFICHAGE DU PHENOMENE DE LA MAILLE ET DU RHOCP
        TABNIV(4) = 0
C AFFICHAGE DU JACOBIEN
        TABNIV(5) = 2
C AFFICHAGE DES DETAILS DE CONSTRUCTION DU TERME SOURCE
        TABNIV(6) = 0
C AFFICHAGE DU TOTAL DU TERME SOURCE
        TABNIV(7) = 2
C POUR UTNORM: INFO SUR HF, NORMAL, CONNECTIQUE DES FACES
        TABNIV(8) = 2
C POUR UTINTC/3D: INTERPOLATION FLUX + INFO CARTE
        TABNIV(9) = 0
C POUR UTERFL: CALCUL TERME ERREUR FLUX
        TABNIV(10) = 0
C AFFICHAGE DU TOTAL DU TERME DE FLUX
        TABNIV(11) = 2
C POUR UTINC/3D: INTERPOLATION ECHANGE + INFO CARTE
        TABNIV(12) = 0
C POUR UTERFL: CALCUL TERME ERREUR ECHANGE
        TABNIV(13) = 0
C AFFICHAGE DU TOTAL DU TERME D'ECHANGE
        TABNIV(14) = 2
C POUR UTERSA: CALCUL TERME ERREUR SAUT
        TABNIV(15) = 0
C AFFICHAGE DU TOTAL DU TERME DE SAUT
        TABNIV(16) = 2
      END IF

C RECUPERATION DES CARTES FLUX, CHARGEMENT ET DE LEUR TYPE
      MA = ZK24(ICHARG)
      LIGREL = ZK24(ICHARG+1)
      CHFLUM = ZK24(ICHARG+2)
      CHFLUP = ZK24(ICHARG+3)
      CARTEF = ZK24(ICHARG+4)
      NOMGDF = ZK24(ICHARG+5)
      CARTEH = ZK24(ICHARG+6)
      NOMGDH = ZK24(ICHARG+7)
      CARTET = ZK24(ICHARG+8)
      NOMGDT = ZK24(ICHARG+9)
      CARTES = ZK24(ICHARG+10)
      NOMGDS = ZK24(ICHARG+11)

C FLAG POUR EFFECTUER LES CALCULS IMPLIQUANT (1-THETA)
      IF (VALUNT.GT.PREC) THEN
        LTHETA = .TRUE.
      ELSE
        LTHETA = .FALSE.
      END IF

C IMPRESSIONS NIVEAU 2 POUR DIAGNOSTIC...
      IF (TABNIV(1).EQ.2) THEN
        WRITE (IFM,*)
        WRITE (IFM,*) 'TE0003 **********'
        WRITE (IFM,*) 'NOMTE/L2D ',NOMTE,' / ',L2D
      END IF
      IF (TABNIV(2).EQ.2) THEN
        IF (L2D) WRITE (IFM,*) 'LAXI ',LAXI
        WRITE (IFM,*) 'VALTHE/VALUNT ',VALTHE,VALUNT
        WRITE (IFM,*) 'LEVOL/LTHETA ',LEVOL,LTHETA
        WRITE (IFM,*) 'MA/LIGREL ',MA,' / ',LIGREL
        WRITE (IFM,*) 'CHFLUM/P ',CHFLUM,' / ',CHFLUP
        WRITE (IFM,*) 'CARTEF/NOMGDF ',CARTEF,' / ',NOMGDF
        WRITE (IFM,*) 'CARTEH/NOMGDH ',CARTEH,' / ',NOMGDH
        WRITE (IFM,*) 'CARTET/NOMGDT ',CARTET,' / ',NOMGDT
        WRITE (IFM,*) 'CARTES/NOMGDS ',CARTES,' / ',NOMGDS
      END IF

C CALCUL DU DIAMETRE HK DE L'ELEMENT K
      CALL UTHK(NOMTE,IGEOM,HK,NDIM,NOE,NSOMM,ITYP,INO,TABNIV(3),IFM)

C------------------------------------------------------------------
C CALCUL DU TERME VOLUMIQUE
C------------------------------------------------------------------

C RECHERCHE DE LA VALEUR DE RHO*CP EN LINEAIRE ET EN NON-LINEAIRE
      CALL RCCOMA(ZI(IMATE),'THER',PHENOM,CODRET)
      IF (CODRET.EQ.'OK') THEN
        IF (PHENOM.EQ.'THER') THEN
          LNONLI = .FALSE.
          CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'INST',INST,1,'RHO_CP',
     &               RHOCP, CODRET,'FM')
          IF (CODRET.NE.'OK') CALL UTMESS('F','TE0003',
     &                             '! PB RCVALA RHOCP !')
        ELSE IF (PHENOM.EQ.'THER_NL') THEN
          LNONLI = .TRUE.
          CALL NTFCMA(ZI(IMATE),IFON)
          CALL UTDEBM('A','TE0003','! LE CALCUL DE CET ESTIMATEUR !')
          CALL UTIMPI('L','! NE TIENT PAS COMPTE D''EVENTUELLES !',0,I)
          CALL UTIMPI('L','! CONDITIONS LIMITES NON LINEAIRES   !',0,I)
          CALL UTFINM()
        ELSE
          CALL UTMESS('F','TE0003','! COMPORTEMENT NON TROUVE !')
        END IF
      ELSE
        CALL UTMESS('F','TE0003','! PB RCCOMA RHOCP !')
      END IF
      IF (TABNIV(4).EQ.2) THEN
        WRITE (IFM,*) 'PHENOM ',PHENOM
        IF (.NOT.LNONLI) WRITE (IFM,*) 'RHOCP ',RHOCP
      END IF

C---------------------------------
C BOUCLE SUR LES POINTS DE GAUSS ------------------------------------
C---------------------------------
      TERMVO = 0.D0
      TERMV1 = 0.D0
      AUX = 0.D0
C INIT. POUR UTMESS 11
      LMAJ = .FALSE.
      DO 70 KP = 1,NPG1

        TERBUF = 0.D0
        K = (KP-1)*NNO
C FONCTIONS DE FORME ET LEURS DERIVEES
        IF (L2D) THEN
          CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
        ELSE
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        END IF

C CALCUL L'ORIENTATION DE LA MAILLE
        CALL UTJAC ( L2D, IGEOM, KP, IDFDE,
     +                                    TABNIV(5), IFM, NNO, JACOB )

C---------------------------------
C CALCUL DE LA PARTIE SOURCE (THETA * S+ + (1-THETA) * S-)
C---------------------------------
C---------------------------------
C CAS SOURCE VARIABLE
C---------------------------------
        IF (NOMGDS(1:6).EQ.'SOUR_F') THEN

C SOURCE FONCTION (R,Z,TEMPS) (VALSP/M S+/- AU POINT DE GAUSS)
          X = 0.D0
          Y = 0.D0
          Z = 0.D0
          VALSP = 0.D0
          VALSM = 0.D0
          DO 20 I = 1,NNO
            I1 = I - 1
            I2 = IGEOM + NDIM*I1
            FFORME = ZR(IVF+K+I1)
            X = X + ZR(I2)*FFORME
            Y = Y + ZR(I2+1)*FFORME
            IF (.NOT.L2D) Z = Z + ZR(I2+2)*FFORME
   20     CONTINUE
          VALPAR(1) = X
          VALPAR(2) = Y
          IF (.NOT.L2D) VALPAR(3) = Z
          VALPAR(NBPAR) = INST
          CALL FOINTE('FM',ZK8(ISOUR),NBPAR,NOMPAR,VALPAR,VALSP,ICODE)
          IF (LTHETA) THEN
            VALPAR(NBPAR) = INSOLD
            CALL FOINTE('FM',ZK8(ISOUR),NBPAR,NOMPAR,VALPAR,VALSM,ICODE)
            TERBUF = VALTHE*VALSP + VALUNT*VALSM
          ELSE
            TERBUF = VALTHE*VALSP
          END IF
          IF (TABNIV(6).EQ.2) THEN
            WRITE (IFM,*) 'X / Y / Z / INST ',X,Y,Z,INST
            WRITE (IFM,*) 'TERMVO SOUR_F',VALSP,VALSM
          END IF

C---------------------------------
C CAS SOURCE CONSTANTE
C---------------------------------
        ELSE IF (NOMGDS(1:6).EQ.'SOUR_R') THEN
          TERBUF = ZR(ISOUR+KP-1)
          IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO SOUR_R',TERBUF
        END IF

C FLAG POUR UTMESS 11
        IF (TERBUF.GT.PREC) LMAJ = .TRUE.
C CALCUL PRELIMINAIRE POUR TERMNO (TERME SOURCE DE NORMALISATION)
        AUX = TERBUF

C---------------------------------
C CALCUL DE LA PARTIE DIFFERENCE FINIE (RHOCP*DELTA TEMP/DELTA T)
C---------------------------------

        IF (LEVOL) THEN

C TEMPM/P T-/+ AU POINT DE GAUSS
          TEMPM = 0.D0
          TEMPP = 0.D0
          DO 30 I = 1,NNO
            I1 = I - 1
            FFORME = ZR(IVF+K+I1)
            TEMPM = TEMPM + ZR(ITEMM+I1)*FFORME
            TEMPP = TEMPP + ZR(ITEMP+I1)*FFORME
   30     CONTINUE
          DELTAT = INST - INSOLD
          IF (ABS(DELTAT).GT.OVFL) THEN
            UNSURD = 1.D0/DELTAT
          ELSE
            CALL UTMESS('F','TE0003','! DELTAT: DIV PAR ZERO !')
          END IF
          IF (LNONLI) THEN
C CAS NON LINEAIRE
C INTERPOLATION DERIVEE CHAMP D'ENTHALPIE IFON(1) A T- ET T+
            CALL RCFODE(IFON(1),TEMPM,R8BID,RHOCPM)
            CALL RCFODE(IFON(1),TEMPP,R8BID,RHOCPP)
            TERBUF = TERBUF - (RHOCPP-RHOCPM)*UNSURD
            IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'RHOCPP/M ',RHOCPP,RHOCPM
          ELSE
C CAS LINEAIRE
            TERBUF = TERBUF - (TEMPP-TEMPM)*RHOCP*UNSURD
          END IF
C IMPRESSIONS NIVEAU 2 POUR DIAGNOSTIC...
          IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO TEMPP/M/DELTAT',
     &        TEMPP,TEMPM,DELTAT
        END IF

C---------------------------------
C CALCUL DE LA PARTIE DIVERGENCE (DIV(THETA*Q+ + (1-THETA)*Q-))
C---------------------------------

        DO 40 I = 1,NDIM
          FLUXM(I) = 0.D0
          FLUXP(I) = 0.D0
   40   CONTINUE

C TRAITEMENT PARTICULIER DU A L'AXI (PART I)
        IF (LAXI) THEN
          R = 0.D0
          FLURM = 0.D0
          FLURP = 0.D0
        END IF

        DO 60 I = 1,NNO
          I1 = I - 1
          I2 = I1*NDIM
          DER(1) = DFDX(I)
          DER(2) = DFDY(I)
C TRAITEMENT PARTICULIER DU A L'AXI (PART II)
          IF (LAXI) THEN
            DER(4) = ZR(IVF+K+I1)
            R = R + ZR(IGEOM+I2)*DER(4)
            FLURP = FLURP + ZR(IFLUP+I2)*DER(4)
            IF (LTHETA) FLURM = FLURM + ZR(IFLUM+I2)*DER(4)
          END IF
          IF (.NOT.L2D) DER(3) = DFDZ(I)
          DO 50 J = 1,NDIM
            IJ = I2 + J - 1
            FLUXP(J) = FLUXP(J) + ZR(IFLUP+IJ)*DER(J)
            IF (LTHETA) FLUXM(J) = FLUXM(J) + ZR(IFLUM+IJ)*DER(J)
   50     CONTINUE
   60   CONTINUE

C TRAITEMENT PARTICULIER DU A L'AXI (PART III)
        IF (LAXI) THEN
          IF (ABS(R).GT.OVFL) THEN
            UNSURR = 1.D0/R
          ELSE
            CALL UTMESS('F','TE0003','! R AXI: DIV PAR ZERO !')
          END IF
          POIDS = POIDS*R
        END IF
        IF (L2D) THEN
          TERBUF = TERBUF - VALTHE* (FLUXP(1)+FLUXP(2))
          IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLUXP',FLUXP(1),
     &        FLUXP(2)
          IF (LAXI) THEN
            TERBUF = TERBUF - VALTHE*UNSURR*FLURP
            IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLURP/R',
     &          FLURP*UNSURR,R
          END IF
          IF (LTHETA) THEN
            TERBUF = TERBUF - VALUNT* (FLUXM(1)+FLUXM(2))
            IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLUXM',FLUXM(1),
     &          FLUXM(2)
            IF (LAXI) THEN
              TERBUF = TERBUF - VALUNT*UNSURR*FLURM
              IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLURM',
     &            FLURM*UNSURR
            END IF
          END IF
        ELSE
          TERBUF = TERBUF - VALTHE* (FLUXP(1)+FLUXP(2)+FLUXP(3))
          IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLUXP',FLUXP(1),
     &        FLUXP(2),FLUXP(3)
          IF (LTHETA) THEN
            TERBUF = TERBUF - VALUNT* (FLUXM(1)+FLUXM(2)+FLUXM(3))
            IF (TABNIV(6).EQ.2) WRITE (IFM,*) 'TERMVO FLUXM',FLUXM(1),
     &          FLUXM(2),FLUXM(3)
          END IF
        END IF
        TERMVO = TERMVO + TERBUF*TERBUF*POIDS
        TERMV1 = TERMV1 + AUX*AUX*POIDS

C---------------------------------
C FIN BOUCLE SUR LES POINTS DE GAUSS --------------------------------
C---------------------------------
   70 CONTINUE

C CALCUL FINAL DU TERME VOLUMIQUE ET DU TERME SOURCE DE NORMALISATION
      TERMVO = HK*SQRT(TERMVO)
      TERMV1 = HK*SQRT(TERMV1)
      IF (TABNIV(7).EQ.2) WRITE (IFM,*) '---> TERMVO/TERMV1',TERMVO,
     &    TERMV1

C--------------------------------------------------------------------
C CALCUL DES TERMES SURFACIQUES
C--------------------------------------------------------------------

C---------------------------------
C ACCES AUX DONNEES GENERALES DES TERMES DE BORD
C---------------------------------

C TYPE DE LA MAILLE COURANTE
      TYPMC = ZI(IVOIS+7)
      CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',TYPMC),TYPMAC)

C CALCUL DES CARACTERISTIQUES DE SES ARETES (OU DE SES FACES) ET
C RECUPERATION DE SES DERIVEES DE FONCTIONS DE FORME (EN 3D ONLY).
      CALL UTVOIS(TYPMAC,L2D,LMAJ,NARET,NSOMM,NSOMM2,POINC1,POINC2,ITYP,
     &            ELREFE,ELREF2,NDEGRE,POIDS1,POIDS2,IDFDX,IDFDX2,IDFDY,
     &            IDFDY2,NPGF,NPGF2,LLUMPE)

      IF (TABNIV(1).EQ.2) THEN
        WRITE (IFM,*) '>>> MAILLE COURANTE <<<',ZI(IVOIS),' ',TYPMAC
        WRITE (IFM,*) 'DIAMETRE ',HK
        IF (L2D) THEN
          WRITE (IFM,*) ' ARETES DE TYPE ',ELREFE
        ELSE
          WRITE (IFM,*) ' FACE DE TYPE   ',ELREFE,ELREF2
        END IF
        WRITE (IFM,*) '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      END IF
C---------------------------------
C BOUCLE SUR LES ARETES OU LES FACES   --------------------------------
C---------------------------------
      TERMSA = 0.D0
      TERMS1 = 0.D0
      TERMFL = 0.D0
      TERMF1 = 0.D0
      TERMEC = 0.D0
      TERME1 = 0.D0
      DO 140 INO = 1,NARET

C---------------------------------
C CALCULS PRELIMINAIRES
C---------------------------------

C CALCUL HF + POINTS INTEGRATION + NORMALE/JACOBIEN
        IF (L2D) THEN
C CAS 2D
          CALL UTNORM(IGEOM,NSOMM,NARET,INO,POINC1,POINC2,JNO,MNO,
     &                ZRINO2,ZRINO1,ZRJNO2,ZRJNO1,X3,Y3,HF,XN,YN,JAC,
     &                LAXI,JACOB,IFM,TABNIV(8))
        ELSE

C CAS 3D
C CAS PARTICULIER DU PENTAEDRE. A PARTIR DE NARET=3 INCLUS ON TRAITE
C LES FACES DE TYPE 2.
          IF ((INO.GE.3) .AND. (NARET.EQ.5)) THEN
            NPGF = NPGF2
            NSOMM = NSOMM2
            IDFDX = IDFDX2
            IDFDY = IDFDY2
            DO 80 IPG = 1,NSOMM
              POIDS3(IPG) = POIDS2(IPG)
   80       CONTINUE
          ELSE
            DO 90 IPG = 1,NSOMM
              POIDS3(IPG) = POIDS1(IPG)
   90       CONTINUE
          END IF
          CALL UTNO3D(IFM,TABNIV(8),NSOMM,INO,ITYP,IGEOM,XN,YN,ZN,JAC,
     &                IDFDX,IDFDY,HF,POIDS3,NPGF,NOE)
        END IF

C TEST DU TYPE DE LA MAILLE VOISINE PARTAGEANT L'ARETE INO
        TYPMV = ZI(IVOIS+7+INO)
        IF (TYPMV.NE.0) THEN
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',TYPMV),TYPMAV)
          FORMV = TYPMAV(1:2)

C NUMERO DE CETTE MAILLE VOISINE
          IMAV = ZI(IVOIS+INO)
        ELSE

C PAS DE MAILLE VOISINE
          TYPMAV = ' '
          FORMV = ' '
          IMAV = 0
        END IF

        IF (TABNIV(1).EQ.2) THEN
          WRITE (IFM,*) '<<< MAILLE VOISINE ',IMAV,'  ',TYPMAV
          CALL JEVEUO(JEXNUM(MA//'.CONNEX',IMAV),'L',IAUX1)
          WRITE (IFM,*) '<<< DE 2 PREMIERS NOEUDS ',ZI(IAUX1),
     &      ZI(IAUX1+1)
        END IF

C---------------------------------
C MAILLE VOISINE DE TYPE ELEMENT DE PEAU -------------------------
C---------------------------------

        IF ((L2D.AND. ((FORMV.EQ.'SE').OR. (FORMV.EQ.'SL'))) .OR.
     &      (.NOT.L2D.AND. ((FORMV.EQ.'QU').OR. (FORMV.EQ.'TR').OR.
     &      (FORMV.EQ.'QL').OR. (FORMV.EQ.'TL')))) THEN

C---------------------------------
C CALCUL DE LA PARTIE FLUX
C           (THETA*(F+ + NU.Q+)+(1-THETA)*(F- + NU.Q-))
C---------------------------------

C POINTEUR CARTE FLUX IMPOSE
          IF (CARTEF.NE.' ') THEN
            CALL JEEXIN(CARTEF//'.PTMA',IRET)
            IF (IRET.EQ.0) THEN
C CARTE CONSTANTE
              IENTF = 1
            ELSE
C LA CARTE A ETE ETENDUE
              CALL JEVEUO(CARTEF//'.PTMA','L',IAPTMA)
              IENTF = ZI(IAPTMA-1+IMAV)
            END IF
          END IF

C---------------------------------
C CAS FLUX VARIABLE
C---------------------------------

          LMAJ = .FALSE.
          IF (NOMGDF(1:6).EQ.'FLUN_F') THEN

C FLUX IMPOSE FONCTION (VALFP/M(I)=Q+/- AU POINT INO/JNO/MNO)
            K8CART = ZK8(IAVAF+ (IENTF-1)*NCMPF)
            IF (TABNIV(9).EQ.2) WRITE (IFM,*) 'TERMFL FLUN_F ',K8CART
            IF (K8CART.NE.'&FOZERO') THEN

              LMAJ = .TRUE.
C INTERPOLATION F AUX INSTANTS +/-
              IF (L2D) THEN
                CALL UTINTC(ZRINO2,ZRINO1,ZRJNO2,ZRJNO1,X3,Y3,INST,
     &                      INSOLD,K8CART,LTHETA,NSOMM,VALFP,VALFM,
     &                      TABNIV(9),IFM,1)
              ELSE
                CALL UTIN3D(IGEOM,NSOMM,INO,ITYP,INST,INSOLD,K8CART,
     &                      LTHETA,TABNIV(9),IFM,1,VALFP,VALFM,NOE)
              END IF

C CALCUL DU TERME D'ERREUR ET DE NORMALISATION ASSOCIE
              CALL UTERFL(NDIM,IFLUP,IFLUM,INO,MNO,JNO,NSOMM,JAC,TERM22,
     &                    AUX,LTHETA,VALTHE,VALUNT,TABNIV(10),IFM,XN,YN,
     &                    ZN,VALFP,VALFM,ITYP,NOE)
            END IF

C---------------------------------
C CAS FLUX CONSTANT
C---------------------------------
          ELSE IF (NOMGDF(1:6).EQ.'FLUN_R') THEN

C FLUX IMPOSE CONSTANT (VALFP(I)=Q AU POINT INO/JNO/MNO VALFM(I)=0)
            R8CART = ZR(IAVAF+ (IENTF-1)*NCMPF)
            IF (TABNIV(9).EQ.2) WRITE (IFM,*) 'TERMFL FLUN_R',R8CART
            IF (ABS(R8CART).GT.PREC) THEN

              LMAJ = .TRUE.
C CALCUL DU TERME D'ERREUR ET DE NORMALISATION ASSOCIE
              DO 100 I = 1,NSOMM
                VALFP(I) = R8CART
  100         CONTINUE
              IF (LTHETA) THEN
                DO 110 I = 1,NSOMM
                  VALFM(I) = R8CART
  110           CONTINUE
              END IF
              CALL UTERFL(NDIM,IFLUP,IFLUM,INO,MNO,JNO,NSOMM,JAC,TERM22,
     &                    AUX,LTHETA,VALTHE,VALUNT,TABNIV(10),IFM,XN,YN,
     &                    ZN,VALFP,VALFM,ITYP,NOE)
            END IF
          END IF

C MISE A JOUR DU TERME DE FLUX
          IF (LMAJ) THEN
            TERM22 = SQRT(HF*TERM22)
            AUX = SQRT(HF*AUX)
            TERMFL = TERMFL + TERM22
            TERMF1 = TERMF1 + AUX
            IF (TABNIV(11).EQ.2) THEN
              WRITE (IFM,*) '---> TERMFL/TERMF1 ',TERM22,AUX
              WRITE (IFM,*)
            END IF
            LMAJ = .FALSE.
          END IF

C---------------------------------
C CALCUL DE LA PARTIE ECHANGE AVEC L'EXTERIEUR
C (THETA*(H+*(TEXT+ - T+)+NU.Q+)+(1-THETA)*(H-*(TEXT- - T-)+NU.Q-)
C---------------------------------

          IF (CARTEH.NE.' ') THEN
            CALL JEEXIN(CARTEH//'.PTMA',IRET)
            IF (IRET.EQ.0) THEN
              IENTH = 1
            ELSE
              CALL JEVEUO(CARTEH//'.PTMA','L',IAPTMA)
              IENTH = ZI(IAPTMA-1+IMAV)
            END IF
            CALL JEEXIN(CARTET//'.PTMA',IRET)
            IF (IRET.EQ.0) THEN
              IENTT = 1
            ELSE
              CALL JEVEUO(CARTET//'.PTMA','L',IAPTMA)
              IENTT = ZI(IAPTMA-1+IMAV)
            END IF
          END IF

C COMPTE-TENU DU PERIMETRE DE AFFE_CHAR_THER ON A SIMULTANEMENT
C (COEH_F,TEMP_F) OU  (COEH_R,TEMP_R)
C---------------------------------
C CAS ECHANGE VARIABLE
C---------------------------------

          LMAJ = .FALSE.
          IF (NOMGDH(1:6).EQ.'COEH_F') THEN

C COEF_H IMPOSE FONCTION (VALHP/M(I)=Q+/- AU POINT INO/JNO/MNO)
            K8CART = ZK8(IAVAH+ (IENTH-1)*NCMPH)
C TEMPERATURE IMPOSEE FONCTION (VALTP/M(I)=TEXT+/-  INO/JNO/MNO)
            K8CAR1 = ZK8(IAVAT+ (IENTT-1)*NCMPT)
            IF (TABNIV(12).EQ.2) WRITE (IFM,*) 'TERMEC COEH_F ',K8CART,
     &          ' / ',K8CAR1

            IF ((K8CART.NE.'&FOZERO') .AND. (K8CAR1.NE.'&FOZERO')) THEN

              LMAJ = .TRUE.
              IF (L2D) THEN
C INTERPOLATION H AUX INSTANTS +/-
                CALL UTINTC(ZRINO2,ZRINO1,ZRJNO2,ZRJNO1,X3,Y3,INST,
     &                      INSOLD,K8CART,LTHETA,NSOMM,VALHP,VALHM,
     &                      TABNIV(12),IFM,2)
C INTERPOLATION TEXT AUX INSTANTS +/-
                CALL UTINTC(ZRINO2,ZRINO1,ZRJNO2,ZRJNO1,X3,Y3,INST,
     &                      INSOLD,K8CAR1,LTHETA,NSOMM,VALTP,VALTM,
     &                      TABNIV(12),IFM,3)
              ELSE
                CALL UTIN3D(IGEOM,NSOMM,INO,ITYP,INST,INSOLD,K8CART,
     &                      LTHETA,TABNIV(12),IFM,2,VALHP,VALHM,NOE)
                CALL UTIN3D(IGEOM,NSOMM,INO,ITYP,INST,INSOLD,K8CAR1,
     &                      LTHETA,TABNIV(12),IFM,3,VALTP,VALTM,NOE)
              END IF

C CALCUL DU TERME D'ERREUR ET DE NORMALISATION ASSOCIE
              CALL UTEREC(NDIM,IFLUP,IFLUM,INO,MNO,JNO,NSOMM,JAC,TERM22,
     &                    AUX,LTHETA,VALTHE,VALUNT,TABNIV(13),IFM,XN,YN,
     &                    ZN,VALHP,VALHM,VALTP,VALTM,ITYP,ITEMP,ITEMM,
     &                    NOE)

            END IF

C---------------------------------
C CAS ECHANGE CONSTANT
C---------------------------------
          ELSE IF (NOMGDH(1:6).EQ.'COEH_R') THEN

C COEF_H IMPOSE CONSTANT (VALHP(I)=Q AU POINT INO/JNO/MNO VALHM(I)=0)
            R8CART = ZR(IAVAH+ (IENTH-1)*NCMPH)
C TEMPERATURE IMPOSEE CONSTANT (VALTP(I)=TEXT+  INO/JNO/MNO VALTM(I)=0)
            R8CAR1 = ZR(IAVAT+ (IENTT-1)*NCMPT)
            IF (TABNIV(12).EQ.2) WRITE (IFM,*) 'TERMEC COEH_R',R8CART,
     &          R8CAR1

            IF ((ABS(R8CART).GT.PREC) .OR. (ABS(R8CAR1).GT.PREC)) THEN

              LMAJ = .TRUE.
C CALCUL DU TERME D'ERREUR ET DE NORMALISATION ASSOCIE
              DO 120 I = 1,NSOMM
                VALHP(I) = R8CART
                VALTP(I) = R8CAR1
  120         CONTINUE
              IF (LTHETA) THEN
                DO 130 I = 1,NSOMM
                  VALHM(I) = R8CART
                  VALTM(I) = R8CAR1
  130           CONTINUE
              END IF
              CALL UTEREC(NDIM,IFLUP,IFLUM,INO,MNO,JNO,NSOMM,JAC,TERM22,
     &                    AUX,LTHETA,VALTHE,VALUNT,TABNIV(13),IFM,XN,YN,
     &                    ZN,VALHP,VALHM,VALTP,VALTM,ITYP,ITEMP,ITEMM,
     &                    NOE)
            END IF
          END IF

C CALCUL FINAL DU TERME D'ECHANGE
          IF (LMAJ) THEN
            TERM22 = SQRT(HF*TERM22)
            AUX = SQRT(HF*AUX)
            TERMEC = TERMEC + TERM22
            TERME1 = TERME1 + AUX
            IF (TABNIV(14).EQ.2) THEN
              WRITE (IFM,*) '---> TERMEC/TERME1',TERM22,AUX
              WRITE (IFM,*)
            END IF
            LMAJ = .FALSE.
          END IF

C---------------------------------
C MAILLE VOISINE VOLUMIQUE         -------------------------
C---------------------------------

C---------------------------------
C CALCUL DE LA PARTIE SAUT DU FLUX CALCULE
C---------------------------------

        ELSE IF ((L2D.AND. ((FORMV.EQ.'TR').OR. (FORMV.EQ.'QU').OR.
     &           (FORMV.EQ.'TL').OR. (FORMV.EQ.'QL'))) .OR.
     &           (.NOT.L2D.AND. ((FORMV.EQ.'HE').OR. (FORMV.EQ.'PE').OR.
     &            (FORMV.EQ.'TE')))) THEN

C CALCUL DU TYPE DE MAILLE VOISINE ET DE SON NBRE DE SOMMETS
          CALL UTNBNV(TYPMAV,NBSV,NBNV)

C NUMERO DU LIGREL DE LA MAILLE VOISINE DE NUMERO GLOBAL IMAV
          IGREL = ZI(IAREPE+2* (IMAV-1))
C INDICE DE LA MAILLE VOISINE DANS LE IGREL
          IEL = ZI(IAREPE+2* (IMAV-1)+1)
          IF (TABNIV(15).EQ.2) WRITE (IFM,*) 'IGREL/IEL',IGREL,IEL

C INDICE DE DEPART DANS LA SD .CELV DU FLUX + ET -. ADDRESSE
C DANS ZR DE LA CMP 1 DU PT 1 DE LA MAILLE 1 DU GREL IEL
          IAVALP = PCELV - 1 + ZI(PCELD-1+ZI(PCELD-1+4+IGREL)+8)
          IF (LTHETA) IAVALM = MCELV - 1 +
     &                         ZI(MCELD-1+ZI(MCELD-1+4+IGREL)+8)

C CALCUL DU TERME D'ERREUR ET DE NORMALISATION ASSOCIE
          CALL UTERSA(NDIM,IFLUP,IFLUM,INO,MNO,JNO,IVOIS,MA,IEL,NBNV,
     &                NBSV,IAVALP,IAVALM,NSOMM,JAC,LTHETA,VALTHE,VALUNT,
     &                TABNIV(15),IFM,ITYP,XN,YN,ZN,TERM22,AUX,JAD,JADV,
     &                NOE)

C CALCUL FINAL DU TERME DE SAUT
          TERM22 = 0.5D0*SQRT(HF*TERM22)
          AUX = 0.5D0*SQRT(HF*AUX)
          TERMSA = TERMSA + TERM22
          TERMS1 = TERMS1 + AUX
          IF (TABNIV(16).EQ.2) THEN
            WRITE (IFM,*) '---> TERMSA/TERMS1',TERM22,AUX
            WRITE (IFM,*)
          END IF
C---------------------------------
C FIN IF FORMV                    --------------------------------
C---------------------------------
        END IF
C---------------------------------
C FIN DE BOUCLE SUR LES ARETES    --------------------------------
C---------------------------------
  140 CONTINUE

C---------------------------------
C MISE EN FORME DES DIFFERENTS TERMES DE ERRETEMP
C---------------------------------

C ERREUR TOTALE
      ERTABS = TERMVO + TERMSA + TERMFL + TERMEC
      TERMNO = TERMV1 + TERMS1 + TERMF1 + TERME1
      ERTREL = 0.D0
      IF (TERMNO.GT.OVFL) ERTREL = (100.D0*ERTABS)/TERMNO

C ERREURS PARTIELLES
      IF (NIVEAU.EQ.2) THEN
        TERMV2 = 0.D0
        IF (TERMV1.GT.OVFL) TERMV2 = 100.D0* (TERMVO/TERMV1)
        TERMS2 = 0.D0
        IF (TERMS1.GT.OVFL) TERMS2 = 100.D0* (TERMSA/TERMS1)
        TERMF2 = 0.D0
        IF (TERMF1.GT.OVFL) TERMF2 = 100.D0* (TERMFL/TERMF1)
        TERME2 = 0.D0
        IF (TERME1.GT.OVFL) TERME2 = 100.D0* (TERMEC/TERME1)
      END IF

C STOCKAGE
      ZR(IERRE) = ERTABS
      ZR(IERRE+1) = ERTREL
      ZR(IERRE+2) = TERMNO
      IF (NIVEAU.EQ.2) THEN
        ZR(IERRE+3) = TERMVO
        ZR(IERRE+4) = TERMV2
        ZR(IERRE+5) = TERMV1
        ZR(IERRE+6) = TERMSA
        ZR(IERRE+7) = TERMS2
        ZR(IERRE+8) = TERMS1
        ZR(IERRE+9) = TERMFL
        ZR(IERRE+10) = TERMF2
        ZR(IERRE+11) = TERMF1
        ZR(IERRE+12) = TERMEC
        ZR(IERRE+13) = TERME2
        ZR(IERRE+14) = TERME1
      ELSE
        DO 150 I = 3,14
          ZR(IERRE+I) = 0.D0
  150   CONTINUE
      END IF

      IF (TABNIV(1).EQ.2) THEN
        WRITE (IFM,*)
        WRITE (IFM,*) '*********************************************'
        WRITE (IFM,*) '     TOTAL SUR LA MAILLE ',ZI(IVOIS)
        WRITE (IFM,*)
        WRITE (IFM,*) 'ERREUR             ABSOLUE   /  RELATIVE '//
     &    '/ NORMALISATION'
        WRITE (IFM,400) ' TOTAL           ',ERTABS,ERTREL,'%',TERMNO
        WRITE (IFM,400) ' TERME VOLUMIQUE ',TERMVO,TERMV2,'%',TERMV1
        WRITE (IFM,400) ' TERME SAUT      ',TERMSA,TERMS2,'%',TERMS1
        WRITE (IFM,400) ' TERME FLUX      ',TERMFL,TERMF2,'%',TERMF1
        WRITE (IFM,400) ' TERME ECHANGE   ',TERMEC,TERME2,'%',TERME1
        WRITE (IFM,*) '*********************************************'
        WRITE (IFM,*)
      END IF

      CALL JEDEMA()
  400 FORMAT (A17,D12.4,1X,D12.4,A2,1X,D12.4)
      END
