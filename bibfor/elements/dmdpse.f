      SUBROUTINE DMDPSE(FAMI,MATER,INSTAN,POUM,IGAU,ISGAU,REPERE,D)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C.======================================================================
C
C      DMDPSE --   CALCUL DE LA MATRICE DE HOOKE POUR LES ELEMENTS
C                  MASSIFS 2D EN DEFORMATIONS PLANES OU AXISYMETRIQUES
C                  POUR DES MATERIAUX ISOTROPE, ORTHOTROPE
C                  ET ISOTROPE TRANSVERSE
C
C                  CALCUL DE SENSIBILITE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    FAMI           IN     K4       FAMILLE DU POINT DE GAUSS
C    MATER          IN     I        MATERIAU
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    POUM           IN     K1       + OU -
C    IGAU           IN     I        POINT DE GAUSS
C    ISGAU          IN     I        SOUS-POINT DE GAUSS
C    REPERE(3)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    D(4,4)         OUT    R        MATRICE DE HOOKE
C
C
C
C.========================= DEBUT DES DECLARATIONS ====================
      IMPLICIT NONE
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

C -----  ARGUMENTS
      CHARACTER*(*)  FAMI,POUM
      REAL*8   REPERE(7),D(4,4),INSTAN
      INTEGER  MATER,IGAU,ISGAU
C -----  VARIABLES LOCALES
      INTEGER   NBRES,I,J,IMATSE,NBV,IREP,TETYPS
      PARAMETER (NBRES=7)

      CHARACTER*2 CODRET(NBRES)
      CHARACTER*8 NOMRES(NBRES),NOMPAR
      CHARACTER*16 PHENOM,PHESEN

      REAL*8 VALRES(NBRES),PREC,R8PREM,VALPAR
      REAL*8 PASSAG(4,4),DORTH(4,4),WORK(4,4),DMDX(3,3),M(3,3),DALPHA
      REAL*8 NU,NU12,NU13,NU23,NU21,NU31,NU32,ALPHA
      REAL*8 ZERO,UNDEMI,UN,DEUX
      REAL*8 E,ES,E1,E1S,E2,E2S,E3,E3S,NUS,NU12S,NU13S,NU23S,GS
C.========================= DEBUT DU CODE EXECUTABLE ==================

C ---- INITIALISATIONS
C      ---------------
      ZERO   = 0.0D0
      UNDEMI = 0.5D0
      UN     = 1.0D0
      DEUX   = 2.0D0
      PREC   = R8PREM()
      NOMPAR = 'INST'
      VALPAR = INSTAN

      DO 20 I = 1,4
        DO 10 J = 1,4
          D(I,J) = ZERO
          DORTH(I,J) = ZERO
          WORK(I,J) = ZERO
   10   CONTINUE
   20 CONTINUE

C ---- RECUPERATION DU TYPE DU MATERIAU DANS PHENOM
C      --------------------------------------------
      CALL RCCOMA(MATER,'ELAS',PHENOM,CODRET)

C ---- RECUPERATION DU MATERIAU DERIVE SI SENSIBILITE
C      ----------------------------------------------
      CALL JEVECH('PMATSEN','L',IMATSE)
      CALL RCCOMA(ZI(IMATSE),'ELAS',PHESEN,CODRET)
      IF (PHESEN.NE.PHENOM) CALL U2MESS('F','ELEMENTS_38')

C      ------------
C ---- CAS ISOTROPE
C      ------------
      IF (PHENOM.EQ.'ELAS') THEN

         NOMRES(1) = 'E'
         NOMRES(2) = 'NU'
         NBV = 2

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')

         E  = VALRES(1)
         NU = VALRES(2)

         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,ZI(IMATSE),' ',PHENOM,1,
     &              NOMPAR,VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')
         ES  = VALRES(1)
         NUS = VALRES(2)

         IF ((ABS(ES).LT.PREC) .AND. (ABS(NUS).LT.PREC)) THEN
C --------- CALCUL INSENSIBLE
            GOTO 9999

         ELSE IF (ABS(NUS).LT.PREC) THEN
C --------- SENSIBILITE PAR RAPPORT A E
            TETYPS = 1

         ELSE IF (ABS(ES).LT.PREC) THEN
C --------- SENSIBILITE PAR RAPPORT A NU
            TETYPS = 2
         END IF

         IF (TETYPS.EQ.1) THEN
            D(1,1) = (UN* (-NU+UN))/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(1,2) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(1,3) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(2,1) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(2,2) = (UN* (-NU+UN))/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(2,3) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(3,1) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(3,2) = (NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))
            D(3,3) = (UN* (-NU+UN))/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(4,4) = UNDEMI/ (NU+UN)

         ELSE IF (TETYPS.EQ.2) THEN
            D(1,1) = (DEUX*E*UN* (-NU+UN))/
     &               ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*UN* (-NU+UN))/ ((NU+UN)**2* (- (DEUX*NU)+UN)) -
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(1,2) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(1,3) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))


            D(2,1) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(2,2) = (DEUX*E*UN* (-NU+UN))/
     &               ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*UN* (-NU+UN))/ ((NU+UN)**2* (- (DEUX*NU)+UN)) -
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(2,3) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))


            D(3,1) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(3,2) = (DEUX*E*NU*UN)/ ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*NU*UN)/ ((NU+UN)**2* (- (DEUX*NU)+UN)) +
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))

            D(3,3) = (DEUX*E*UN* (-NU+UN))/
     &               ((NU+UN)* (- (DEUX*NU)+UN)**2) -
     &               (E*UN* (-NU+UN))/ ((NU+UN)**2* (- (DEUX*NU)+UN)) -
     &               (E*UN)/ ((NU+UN)* (- (DEUX*NU)+UN))


            D(4,4) = - ((E*UNDEMI)/ (NU+UN)**2)
         END IF

C      --------------
C ---- CAS ORTHOTROPE
C      --------------
      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'E_T'
         NOMRES(3) = 'E_N'
         NOMRES(4) = 'NU_LT'
         NOMRES(5) = 'NU_LN'
         NOMRES(6) = 'NU_TN'
         NOMRES(7) = 'G_LT'
         NBV = 7

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')

         E1 = VALRES(1)
         E2 = VALRES(2)
         E3 = VALRES(3)
         NU12 = VALRES(4)
         NU13 = VALRES(5)
         NU23 = VALRES(6)
         NU21 = E2*NU12/E1
         NU31 = E3*NU13/E1
         NU32 = E3*NU23/E2

         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,ZI(IMATSE),' ',PHENOM,1,
     &              NOMPAR,VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')

         E1S = VALRES(1)
         E2S = VALRES(2)
         E3S = VALRES(3)
         NU12S = VALRES(4)
         NU13S = VALRES(5)
         NU23S = VALRES(6)
         GS = VALRES(7)

C        LA DERIVEE DE LA MATRICE D ORTHOTROPIE DANS LE REPERE LOCAL
C        PEUT S ECRIRE SOUS LA FORME
C        D[DORTH]/DX=-DALPHA/DX*1/ALPHA**2*[M]+1/ALPHA*D[M]/DX
C        OU X CORRESPOND A UN DES PARAMETRE MATERIAUX,
C        ALPHA CORRESPOND A E1*E2*E3*DELTA, DELTA CORRESPONDANT A
C        LA VALEUR DECRITE DANS LA DOC R ET [M] CORRESPOND A LA MATRICE
C        TEL QUE [DORTH]=[M]/ALPHA
C        CETTE REMARQUE NE S APPLIQUE QU AU TERMES DORTH(1,*),
C        DORTH(2,*) ET DORTH(3,*) HORMIS LES PARAMETRES MATERIAUX DE
C        CISAILLEMENT, LES AUTRES TERMES ETANT TRIVIAUX

         ALPHA=(1-NU12*NU21-NU13*NU31-NU23*NU32-2.D0*NU12*NU23*NU31)
         M(1,1)=E1*(1-NU23*NU32)
         M(1,2)=E1*(NU21+NU31*NU23)
         M(1,3)=E1*(NU31+NU21*NU32)
         M(2,2)=E2*(1-NU31*NU13)
         M(2,3)=E2*(NU32+NU31*NU12)
         M(3,3)=E3*(1-NU12*NU21)

         M(2,1)=M(1,2)
         M(3,1)=M(1,3)
         M(3,2)=M(2,3)

         IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &        (ABS(E3S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &        (ABS(NU13S).LT.PREC) .AND. (ABS(NU23S).LT.PREC) .AND.
     &        (ABS(GS).LT.PREC)) THEN
C --------- CALCUL INSENSIBLE
            GOTO 9999

         ELSE IF ((ABS(E2S).LT.PREC) .AND. (ABS(E3S).LT.PREC) .AND.
     &             (ABS(NU12S).LT.PREC) .AND. (ABS(NU13S).LT.PREC) .AND.
     &             (ABS(NU23S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A E1
            TETYPS = 1

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E3S).LT.PREC) .AND.
     &             (ABS(NU12S).LT.PREC) .AND. (ABS(NU13S).LT.PREC) .AND.
     &             (ABS(NU23S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A E2
            TETYPS = 2

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &             (ABS(NU12S).LT.PREC) .AND. (ABS(NU13S).LT.PREC) .AND.
     &             (ABS(NU23S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A E3
            TETYPS = 3

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &             (ABS(E3S).LT.PREC) .AND. (ABS(NU13S).LT.PREC) .AND.
     &             (ABS(NU23S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A NU12
            TETYPS = 4

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &             (ABS(E3S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &             (ABS(NU23S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A NU13
            TETYPS = 5

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &             (ABS(E3S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &             (ABS(NU13S).LT.PREC) .AND. (ABS(GS).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A NU23
            TETYPS = 6

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E2S).LT.PREC) .AND.
     &             (ABS(E3S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &             (ABS(NU13S).LT.PREC) .AND. (ABS(NU23S).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A G
            TETYPS = 7
         END IF

        IF (TETYPS.EQ.1) THEN

          DALPHA=(NU12*NU21+NU13*NU31+2*NU12*NU23*NU31)/E1
          DMDX(1,1)=1-NU23*NU32
          DMDX(2,2)=E2*NU13*NU31/E1
          DMDX(3,3)=E3*NU12*NU21/E1
          DMDX(1,2)=0.D0
          DMDX(1,3)=0.D0
          DMDX(2,3)=-NU21*NU31
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.2) THEN
          DALPHA=(NU23*NU32-NU12*NU21)/E2
          DMDX(1,1)=E1*NU23*NU32/E2
          DMDX(2,2)=1-NU13*NU31
          DMDX(3,3)=-E3*NU12*NU21/E2
          DMDX(1,2)=NU12
          DMDX(1,3)=0.D0
          DMDX(2,3)=NU12*NU31
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.3) THEN

          DALPHA=(-NU13*NU31-NU23*NU32-2*NU12*NU23*NU31)/E3
          DMDX(1,1)=-E1*NU23*NU32/E3
          DMDX(2,2)=-E2*NU13*NU31/E3
          DMDX(3,3)=1-NU12*NU21
          DMDX(1,2)=NU13*NU23
          DMDX(1,3)=NU13+NU12*NU23
          DMDX(2,3)=NU23+NU21*NU13
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.4) THEN

          DALPHA=-2*(NU21+NU23*NU31)
          DMDX(1,1)=0.D0
          DMDX(2,2)=0.D0
          DMDX(3,3)=-2*E3*NU21
          DMDX(1,2)=E2
          DMDX(1,3)=E3*NU23
          DMDX(2,3)=E2*NU31
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.5) THEN
          DALPHA=-2*(NU31+NU32*NU21)
          DMDX(1,1)=0.D0
          DMDX(2,2)=-2*E2*NU31
          DMDX(3,3)=0.D0
          DMDX(1,2)=E3*NU23
          DMDX(1,3)=E3
          DMDX(2,3)=E3*NU21
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.6) THEN

          DALPHA=-2*(NU32+NU31*NU12)
          DMDX(1,1)=-2*E1*NU32
          DMDX(2,2)=0.D0
          DMDX(3,3)=0.D0
          DMDX(1,2)=E3*NU13
          DMDX(1,3)=E3*NU12
          DMDX(2,3)=E3
          DMDX(2,1)=DMDX(1,2)
          DMDX(3,1)=DMDX(1,3)
          DMDX(3,2)=DMDX(2,3)

        ELSE IF (TETYPS.EQ.7) THEN
          DORTH(1,1) = 0.D0
          DORTH(1,2) = 0.D0
          DORTH(1,3) = 0.D0
          DORTH(2,1) = 0.D0
          DORTH(2,2) = 0.D0
          DORTH(2,3) = 0.D0
          DORTH(3,1) = 0.D0
          DORTH(3,2) = 0.D0
          DORTH(3,3) = 0.D0

          DORTH(4,4) = 1.D0
        END IF

C        POUR LES DERIVEES PAR RAPPORT AUX MODULES D YOUNG OU
C        AUX COEFFICIENTS DE POISSON, ON UTILISE LA FORMULE RAPPELE
C        CI DESSUS (LES AUTRES DERIVES ETANT TRIVIALES)
         IF (TETYPS.LE.6) THEN
           DO 25 I=1,3
             DO 35 J=1,3
               DORTH(I,J)=(-DALPHA/ALPHA**2)*M(I,J)+DMDX(I,J)/ALPHA
 35          CONTINUE
 25        CONTINUE
         ENDIF
C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
C        ------------------------------------------
        CALL DPAO2D(REPERE,IREP,PASSAG)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
        IF (IREP.EQ.1) THEN
          CALL UTBTAB('ZERO',4,4,DORTH,PASSAG,WORK,D)
        ELSE IF (IREP.EQ.0) THEN
          DO 40 I = 1,4
            DO 30 J = 1,4
              D(I,J) = DORTH(I,J)
   30       CONTINUE
   40     CONTINUE
        ELSE
          CALL U2MESS('F','ELEMENTS_22')
        END IF


C      -----------------------
C ---- CAS ISOTROPE-TRANSVERSE
C      -----------------------
      ELSE IF (PHENOM.EQ.'ELAS_ISTR') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'E_N'
         NOMRES(3) = 'NU_LT'
         NOMRES(4) = 'NU_LN'
         NBV = 4

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')

         E1 = VALRES(1)
         E3 = VALRES(2)
         NU12 = VALRES(3)
         NU13 = VALRES(4)
         NU31=E3*NU13/E1

         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,ZI(IMATSE),' ',PHENOM,1,
     &              NOMPAR,VALPAR,NBV,NOMRES,VALRES,CODRET,'FM')

         E1S = VALRES(1)
         E3S = VALRES(2)
         NU12S = VALRES(3)
         NU13S = VALRES(4)

C        LA DERIVEE DE LA MATRICE D ORTHOTROPIE DANS LE REPERE LOCAL
C        PEUT S ECRIRE SOUS LA FORME
C        D[DORTH]/DX=-DALPHA/DX*1/ALPHA**2*[M]+1/ALPHA*D[M]/DX
C        OU X CORRESPOND A UN DES PARAMETRE MATERIAUX,
C        ALPHA CORRESPOND A E1*E2*E3*DELTA, DELTA CORRESPONDANT A
C        LA VALEUR DECRITE DANS LA DOC R ET [M] CORRESPOND A LA MATRICE
C        TEL QUE [DORTH]=[M]/ALPHA
C        CETTE REMARQUE NE S APPLIQUE QU AU TERMES DORTH(1,*),
C        DORTH(2,*) ET DORTH(3,*) HORMIS LES PARAMETRES MATERIAUX DE
C        CISAILLEMENT, LES AUTRES TERMES ETANT TRIVIAUX

         ALPHA=(1+NU12)*(1-NU12-2*NU13*NU31)
C
         M(1,1)=E1*(1-NU13*NU31)
         M(1,2)=E1*(NU12+NU31*NU13)
         M(1,3)=E3*NU13*(1+NU12)
         M(2,1)=M(1,2)
         M(2,2)=M(1,1)
         M(2,3)=M(1,3)
         M(3,1)=M(1,3)
         M(3,2)=M(2,3)
         M(3,3)=E3*(1-NU12**2)

         IF ((ABS(E1S).LT.PREC) .AND. (ABS(E3S).LT.PREC) .AND.
     &        (ABS(NU12S).LT.PREC) .AND. (ABS(NU13S).LT.PREC)) THEN
C --------- CALCUL INSENSIBLE
            GOTO 9999

         ELSE IF ((ABS(E3S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &             (ABS(NU13S).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A E1
            TETYPS = 1

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(NU12S).LT.PREC) .AND.
     &             (ABS(NU13S).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A E3
            TETYPS = 2

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E3S).LT.PREC) .AND.
     &             (ABS(NU13S).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A NU12
            TETYPS = 3

         ELSE IF ((ABS(E1S).LT.PREC) .AND. (ABS(E3S).LT.PREC) .AND.
     &             (ABS(NU12S).LT.PREC)) THEN
C --------- SENSIBILITE PAR RAPPORT A NU13
            TETYPS = 4
         END IF

         IF (TETYPS.EQ.1) THEN
           DALPHA=2*NU13*NU31*(1+NU12)/E1
           DMDX(1,1)=1.D0
           DMDX(1,2)=NU12
           DMDX(1,3)= 0.D0
           DMDX(2,1)=DMDX(1,2)
           DMDX(2,2)=DMDX(1,1)
           DMDX(2,3)=DMDX(1,3)
           DMDX(3,1)=DMDX(1,3)
           DMDX(3,2)=DMDX(2,3)
           DMDX(3,3)=0.D0

           DORTH(4,4)=0.5D0/(1.D0+NU12)

         ELSE IF (TETYPS.EQ.2) THEN

           DALPHA=-2.D0*NU13**2*(1+NU12)/E1
           DMDX(1,1)= -NU13**2
           DMDX(1,2)= NU13**2
           DMDX(1,3)= NU13*(1+NU12)
           DMDX(2,1)=DMDX(1,2)
           DMDX(2,2)=DMDX(1,1)
           DMDX(2,3)=DMDX(1,3)
           DMDX(3,1)=DMDX(1,3)
           DMDX(3,2)=DMDX(2,3)
           DMDX(3,3)= 1.D0-NU12**2

         ELSE IF (TETYPS.EQ.3) THEN

           DALPHA=-2*(NU13*NU31+NU12)
           DMDX(1,1)=0.D0
           DMDX(3,3)=-2*E3*NU12
           DMDX(1,2)=E1
           DMDX(1,3)=E3*NU13
           DMDX(2,2)=DMDX(1,1)
           DMDX(2,3)=DMDX(1,3)
           DMDX(2,1)=DMDX(1,2)
           DMDX(3,1)=DMDX(1,3)
           DMDX(3,2)=DMDX(2,3)

           DORTH(4,4)=-0.5D0*E1/(1+NU12)**2

         ELSE IF (TETYPS.EQ.4) THEN

           DALPHA=-4*NU31*(1+NU12)
           DMDX(1,1)=-2*E3*NU13
           DMDX(3,3)=0.D0
           DMDX(1,2)=2*E3*NU13
           DMDX(1,3)=E3*(1+NU12)
           DMDX(2,2)=DMDX(1,1)
           DMDX(2,3)=DMDX(1,3)
           DMDX(2,1)=DMDX(1,2)
           DMDX(3,1)=DMDX(1,3)
           DMDX(3,2)=DMDX(2,3)

         END IF

         DO 45 I=1,3
           DO 55 J=1,3
             DORTH(I,J)=(-DALPHA/ALPHA**2)*M(I,J)+DMDX(I,J)/ALPHA
 55        CONTINUE
 45      CONTINUE

C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
C        ------------------------------------------
        CALL DPAO2D(REPERE,IREP,PASSAG)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
        IF (IREP.EQ.1) THEN
          CALL UTBTAB('ZERO',4,4,DORTH,PASSAG,WORK,D)
        ELSE IF (IREP.EQ.0) THEN
          DO 60 I = 1,4
            DO 50 J = 1,4
              D(I,J) = DORTH(I,J)
   50       CONTINUE
   60     CONTINUE
        ELSE
          CALL U2MESS('F','ELEMENTS_22')
        END IF

      ELSE
        CALL U2MESK('F','ELEMENTS_15',1,PHENOM)
      END IF
C.============================ FIN DE LA ROUTINE ======================
 9999 CONTINUE
      END
