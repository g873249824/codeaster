      SUBROUTINE TE0236(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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
C ----------------------------------------------------------------------

C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_EVOLNI'
C                                   'CHAR_SENS_EVOLNI'
C                          ELEMENTS 3D ISOPARAMETRIQUES

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT

C THERMIQUE NON LINEAIRE ET SECHAGE
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       05/03/02 (OB): MODIFICATIONS POUR INSERER LES ARGUMENTS OPTION
C        NELS PERMETTANT D'UTILISER CETTE ROUTINE POUR CALCULER LA
C        SENSIBILITE PAR RAPPORT AUX CARACTERISTIQUES MATERIAU.
C        + MODIFS FORMELLES: IMPLICIT NONE, IDENTATION...
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C PARAMETRES D'APPEL
      CHARACTER*16 NOMTE,OPTION

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


      CHARACTER*2 CODRET
      REAL*8 BETA,DBETA,LAMBDA,THETA,DELTAT,TPG,CHAL,R8BID,DFDX(27),
     &       DFDY(27),DFDZ(27),POIDS,DTPGDX,DTPGDY,DTPGDZ,DIFF,TPSEC,
     &       PREC,R8PREM,LAMBS,CPS,TPGM,DLAMBD,DTPGMX,DTPGMY,DTPGMZ,
     &       DTPGPX,TPGBUF,DTPGPY,DTPGPZ,TEMS,FLUXS(3),HYDRPG(27)
      INTEGER JGANO,IPOIDS,IVF,IDFDE,IGEOM,IMATE,ITEMP,NNO,
     &        KP,NPG1,I,L,IFON(3),NDIM,ICOMP,IHYDR,ISECHI,ISECHF,
     &        IVECTT,IVECTI,ITEMPS,IMATSE,IVAPRI,IVAPRM,IFONS(3),TETYPS,
     &        IFM,NIV,IRET,NNOS
      LOGICAL LSENS,LSTAT,LHYD

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      PREC = R8PREM()*10.D0
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      IF (OPTION(6:9).EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE IF (OPTION(6:9).EQ.'THER') THEN
        LSENS = .FALSE.
      ELSE
        CALL U2MESS('F','ELEMENTS2_95')
      END IF

C====
C 1.2 PREALABLES LIES AUX CALCULS DE SENSIBILITE PART I
C====

      LSTAT = .FALSE.
      IMATSE = 0
      IF (LSENS) THEN
        CALL TECACH('ONN','PMATSEN',1,IMATSE,IRET)
        CALL JEVECH('PVAPRIN','L',IVAPRI)
        CALL TECACH('ONN','PVAPRMO',1,IVAPRM,IRET)
C DANS LE CAS DES DERIVEES MATERIAUX:
C L'ABSENCE DE CE CHAMP DETERMINE LE CRITERE STATIONNAIRE OU PAS
C ON "TRUANDE" ALORS DE MANIERE PEU OPTIMALE MAIS FACILE A MAINTE
C NIR: CP ET/OU CPS SONT ANNULES ET ON CREE UN CHAMP T- BIDON.
        IF (IVAPRM.EQ.0) THEN
          LSTAT = .TRUE.
          IVAPRM = IVAPRI
        END IF
      END IF

C====
C 1.3 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      IF (.NOT.LSTAT) CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PVECTTI','E',IVECTI)
      DELTAT = ZR(ITEMPS+1)
      THETA = ZR(ITEMPS+2)

C====
C 1.5 PREALABLES LIES AUX CALCULS DE SENSIBILITE PART II
C     (NE CONCERNE QUE LES DERIVES MATERIAU AVEC UN IMATSE NON NUL)
C====

      TETYPS = 0
      IF (IMATSE.NE.0) THEN
        CALL INFNIV(IFM,NIV)
        CALL NTFCMA(ZI(IMATSE),IFONS)
        TPG = 0.D0
        IF (LSTAT) THEN
          CALL RCFODE(IFONS(2),TPG,LAMBS,R8BID)
          CPS = 0.D0
        ELSE
          CALL RCFODE(IFONS(1),TPG,R8BID,CPS)
          CALL RCFODE(IFONS(2),TPG,LAMBS,R8BID)
        END IF
        IF ((ABS(CPS).LT.PREC) .AND. (ABS(LAMBS).LT.PREC)) THEN
C PAS DE TERME DE SENSIBILITE SUPPLEMENTAIRE, CALCUL INSENSIBLE
          TETYPS = 0
        ELSE IF (ABS(LAMBS).LT.PREC) THEN
C SENSIBILITE PAR RAPPORT A RHO_CP
          TETYPS = 2
        ELSE IF (CPS.LT.PREC) THEN
C SENSIBILITE PAR RAPPORT A LAMBDA
          TETYPS = 1
        ELSE
          CALL U2MESS('F','SENSIBILITE_39')
        END IF
        IF (NIV.EQ.2) THEN
          WRITE (IFM,*) '   CPS/LAMBS :',CPS,LAMBS
        END IF
      END IF

C====
C 2. CALCUL DE L'OPTION SI SECHAGE
C====

      IF (ZK16(ICOMP) (1:5).EQ.'SECH_') THEN
        IF (LSENS) CALL U2MESS('F','SENSIBILITE_31')
        IF (ZK16(ICOMP) (1:12).EQ.'SECH_GRANGER' .OR.
     &      ZK16(ICOMP) (1:10).EQ.'SECH_NAPPE') THEN
          CALL JEVECH('PTMPCHI','L',ISECHI)
          CALL JEVECH('PTMPCHF','L',ISECHF)
        ELSE
C          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
C          ISECHI ET ISECHF SONT FICTIFS
          ISECHI = ITEMP
          ISECHF = ITEMP
        END IF
        DO 30 KP = 1,NPG1
          L = NNO*(KP-1)
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          TPSEC = 0.D0
          DO 10 I = 1,NNO
            TPG   = TPG   + ZR( ITEMP+I-1)*ZR(IVF+L+I-1)
            TPSEC = TPSEC + ZR(ISECHI+I-1)*ZR(IVF+L+I-1)
            DTPGDX = DTPGDX + ZR(ITEMP+I-1)*DFDX(I)
            DTPGDY = DTPGDY + ZR(ITEMP+I-1)*DFDY(I)
            DTPGDZ = DTPGDZ + ZR(ITEMP+I-1)*DFDZ(I)
   10     CONTINUE
          CALL RCDIFF(ZI(IMATE),ZK16(ICOMP),TPSEC,TPG,DIFF)
CCDIR$ IVDEP
          DO 20 I = 1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                       POIDS* (TPG/DELTAT*ZR(IVF+L+I-1)-
     &                       (1.0D0-THETA)*DIFF* (DFDX(I)*DTPGDX+
     &                       DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ))
            ZR(IVECTI+I-1) = ZR(IVECTT+I-1)
   20     CONTINUE
   30   CONTINUE
      ELSE


C====
C 1.4 PREALABLES LIES A L'HYDRATATION
C====
        CALL NTFCMA(ZI(IMATE),IFON)
        IF (ZK16(ICOMP) (1:9).EQ.'THER_HYDR') THEN
          LHYD = .TRUE.
          IF (LSENS) CALL U2MESS('F','SENSIBILITE_32')
          CALL JEVECH('PHYDRPM','L',IHYDR)
          DO 150 KP = 1,NPG1
             L = NNO*(KP-1)
             HYDRPG(KP)=0.D0
             DO 160 I = 1,NNO
                HYDRPG(KP)=HYDRPG(KP)+ZR(IHYDR)*ZR(IVF+L+I-1)
 160         CONTINUE
 150      CONTINUE

          CALL RCVALA(ZI(IMATE),' ','THER_HYDR',0,' ',R8BID,1,
     &               'CHALHYDR', CHAL,CODRET,'FM')
        ELSE
          LHYD = .FALSE.
        END IF

C====
C 3. CALCULS DE L'OPTION POUR NEWTON (CALCUL STD) AVEC EVENTUELLEMENT
C    HYDRATATION OU POUR LA SENSIBILITE (SANS HYDRATATION)
C====

        DO 130 KP = 1,NPG1
          L = NNO*(KP-1)
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          IF (.NOT.LSTAT) THEN
            DO 40 I = 1,NNO
C CALCUL DE T- (OU (DT/DS)- EN SENSI) ET DE SON GRADIENT
              TPG = TPG + ZR(ITEMP+I-1)*ZR(IVF+L+I-1)
              DTPGDX = DTPGDX + ZR(ITEMP+I-1)*DFDX(I)
              DTPGDY = DTPGDY + ZR(ITEMP+I-1)*DFDY(I)
              DTPGDZ = DTPGDZ + ZR(ITEMP+I-1)*DFDZ(I)
   40       CONTINUE
          END IF

C CALCUL DE SENSIBILITE PART III
          IF (LSENS) THEN
            DTPGMX = 0.D0
            DTPGMY = 0.D0
            DTPGMZ = 0.D0
            DTPGPX = 0.D0
            DTPGPY = 0.D0
            DTPGPZ = 0.D0
            TEMS = 0.D0
            TPGM = 0.D0
          END IF
          IF (TETYPS.EQ.1) THEN
            DO 50 I = 1,NNO
C CALCUL DE GRAD(T+) POUR TERME DE RIGIDITE. LE TERME GRAD(T-)
C EST CALCULE SI NECESSAIRE CI-DESSOUS.
              DTPGPX = DTPGPX + ZR(IVAPRI+I-1)*DFDX(I)
              DTPGPY = DTPGPY + ZR(IVAPRI+I-1)*DFDY(I)
              DTPGPZ = DTPGPZ + ZR(IVAPRI+I-1)*DFDZ(I)
   50       CONTINUE
          ELSE IF ((TETYPS.EQ.2) .AND. (.NOT.LSTAT)) THEN
            DO 60 I = 1,NNO
C CALCUL DE (T- - T+) POUR TERME DE MASSE
              TEMS = TEMS + (ZR(IVAPRM+I-1)-ZR(IVAPRI+I-1))*
     &               ZR(IVF+L+I-1)
   60       CONTINUE
          END IF
          IF (LSENS .AND. (.NOT.LSTAT)) THEN
            DO 70 I = 1,NNO
C CALCUL DE GRAD(T-) POUR TERME COMPLEMENTAIRE EN DLAMBDA/DT
              DTPGMX = DTPGMX + ZR(IVAPRM+I-1)*DFDX(I)
              DTPGMY = DTPGMY + ZR(IVAPRM+I-1)*DFDY(I)
              DTPGMZ = DTPGMZ + ZR(IVAPRM+I-1)*DFDZ(I)
C CALCUL DE T- EN SENSIBILITE
              TPGM = TPGM + ZR(IVAPRM+I-1)*ZR(IVF+L+I-1)
   70       CONTINUE
          END IF

C CALCUL DES CARACTERISTIQUES MATERIAUX STD EN TRANSITOIRE UNIQUEMENT
C POUR LE PB STD ON LES EVALUE AVEC TPG=T-
C POUR LE PB DERIVE, ON UTILISE TPGM=T-
          IF (.NOT.LSTAT) THEN
            IF (.NOT.LSENS) THEN
              TPGBUF = TPG
            ELSE
              TPGBUF = TPGM
            END IF
            CALL RCFODE(IFON(1),TPGBUF,BETA,DBETA)
            CALL RCFODE(IFON(2),TPGBUF,LAMBDA,DLAMBD)
          ELSE
            BETA = 0.D0
            DBETA = 0.D0
            LAMBDA = 0.D0
            DLAMBD = 0.D0
          END IF

CCDIR$ IVDEP
          IF (LHYD) THEN
C THER_HYDR

            DO 80 I = 1,NNO
              ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                         POIDS* ((BETA-CHAL*HYDRPG(KP))*
     &                         ZR(IVF+L+I-1)/DELTAT-
     &                         (1.0D0-THETA)*LAMBDA*
     &                         (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                         DFDZ(I)*DTPGDZ))
              ZR(IVECTI+I-1) = ZR(IVECTI+I-1) +
     &                         POIDS* ((DBETA*TPG-CHAL*HYDRPG(KP))*
     &                         ZR(IVF+L+I-1)/DELTAT-
     &                         (1.0D0-THETA)*LAMBDA*
     &                         (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                         DFDZ(I)*DTPGDZ))
   80       CONTINUE
          ELSE
C THER_NL

            IF (.NOT.LSENS) THEN
C CALCUL STD A 2 OUTPUTS (LE DEUXIEME NE SERT QUE POUR LA PREDICTION)

              DO 90 I = 1,NNO
                ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                           POIDS* (BETA/DELTAT*ZR(IVF+L+I-1)-
     &                           (1.0D0-THETA)*LAMBDA*
     &                           (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                           DFDZ(I)*DTPGDZ))
                ZR(IVECTI+I-1) = ZR(IVECTI+I-1) +
     &                           POIDS* (DBETA*TPG/DELTAT*ZR(IVF+L+I-1)-
     &                            (1.0D0-THETA)*LAMBDA*
     &                           (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                           DFDZ(I)*DTPGDZ))
   90         CONTINUE
            ELSE

C CALCUL DE SENSIBILITE PART IV: TRONC COMMUN TRANSITOIRE
              IF (.NOT.LSTAT) THEN
                DO 100 I = 1,NNO
                  ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                             POIDS* ((DBETA*TPG*ZR(IVF+L+I-
     &                             1)/DELTAT)+ (THETA-1.D0)*
     &                             (LAMBDA* (DFDX(I)*DTPGDX+
     &                             DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ)+
     &                             DLAMBD*TPG* (DFDX(I)*DTPGMX+
     &                             DFDY(I)*DTPGMY+DFDZ(I)*DTPGMZ)))
  100           CONTINUE
              END IF

C CALCUL DE SENSIBILITE PART V: TERME PARTICULIER STATIONNAIRE OU TRANSI
              IF (TETYPS.EQ.1) THEN
                FLUXS(1) = THETA*DTPGPX + (1.D0-THETA)*DTPGMX
                FLUXS(2) = THETA*DTPGPY + (1.D0-THETA)*DTPGMY
                FLUXS(3) = THETA*DTPGPZ + (1.D0-THETA)*DTPGMZ
                DO 110 I = 1,NNO
                  ZR(IVECTT+I-1) = ZR(IVECTT+I-1) -
     &                             POIDS*LAMBS* (DFDX(I)*FLUXS(1)+
     &                             DFDY(I)*FLUXS(2)+DFDZ(I)*FLUXS(3))
  110           CONTINUE
C TERME DE MASSE EN SENSIBILITE
              ELSE IF ((TETYPS.EQ.2) .AND. (.NOT.LSTAT)) THEN
                DO 120 I = 1,NNO
                  ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                             POIDS*CPS/DELTAT*ZR(IVF+L+I-1)*TEMS
  120           CONTINUE
              END IF

C FIN DU IF LSENS
            END IF
C FIN DU IF THERMIQUE AVEC OU SANS HYDRATATION
          END IF
C FIN BOUCLE SUR LES PT DE GAUSS
  130   CONTINUE
C FIN DU IF SECHAGE OU THERMIQUE
      END IF
C FIN ------------------------------------------------------------------
      END
