      SUBROUTINE LCUMEF(OPTION,DEP,DEPM,AN,BN,CN,EPSM,EPSRM,EPSRP,
     &                  DEPSI,EPSFM,SIGI,NSTRS,SIGT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE YLEPAPE Y.LEPAPE
C
C ROUTINE APPELE DANS FLU
C LCUMEF     SOURCE    BENBOU   01/03/26
C
C_______________________________________________________________________
C
C ROUTINE QUI CALCUL L INCREMENT DE CONTRAINTES (ELASTIQUE)
C  CORRIGE PAR LE FLUAGE TOTAL (PROPRE + DESSICCATION)
C
C IN  DEP      : MATRICE ELASTIQUE DE HOOKE A L'INSTANT T+DT
C IN  DEPM     : MATRICE ELASTIQUE DE HOOKE A L'INSTANT T
C IN  AN       : PRISE EN COMPTE DES DEFORMATIONS DE FLUAGE (CF LCUMMD)
C IN  BN       : PRISE EN COMPTE DES DEFORMATIONS DE FLUAGE (CF LCUMMD)
C IN  CN       : PRISE EN COMPTE DES DEFORMATIONS DE FLUAGE (CF LCUMMD)
C IN  EPSM     : DEFORMATION TEMPS MOINS
C IN  EPSRM    : DEFORMATION DE RETRAIT TEMPS MOINS
C IN  EPSRP    : DEFORMATION DE RETRAIT TEMPS PLUS
C IN  EPSFM    : DEFORMATION DE FLUAGE TEMPS MOINS
C IN  DEPSI    : INCREMENT DE DEFORMATION TOTALE
C IN  SIGI     : CONTRAINTES INITIALES
C IN  NSTRS    : DIMENSION DES VECTEURS CONTRAINTE ET DEFORMATION
C OUT SIGT     : CONTRAINTES AU TEMPS PLUS
C_______________________________________________________________________
C
      IMPLICIT NONE
C MODIFI DU 18 DECEMBRE 2002 - YLP SUPPRESSION DE LA DECLARATION DE
C LA VARIABLE ISING APPELEE DANS INVERMAT (RESORBEE PAR MGAUSS)
      INTEGER  I,J,K,NSTRS
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESSION DES DECLARATIONS
C IMPLICITES DE TABLEAUX
C      REAL*8   AN(NSTRS),BN(NSTRS,NSTRS),CN(NSTRS,NSTRS)
C      REAL*8   DEP(NSTRS,NSTRS),SIGI(NSTRS),DSIGT(NSTRS),DEPSI(NSTRS)
      REAL*8   AN(6),BN(6,6),CN(6,6)
      REAL*8   DEP(6,6),SIGI(6),SIGT(6),DEPSI(6),EPSM(6),EPSFM(6)
C MODIFI DU 18 AOUT 2004 - YLP AJOUT DES VARIABLES DE
C                              DEFORMATION DE RETRAIT
      REAL*8   EPSRM,EPSRP
C MODIFI DU 6 JANVIER 2002 - YLP SUPPRESSION DES DECLARATIONS
C IMPLICITES DES TABLEAUX
C      REAL*8   EFLU(NSTRS,NSTRS),DEFELA(NSTRS),TEMP(NSTRS,NSTRS)
C      REAL*8   DEFLUN(NSTRS),TEMP2(NSTRS,NSTRS)
      REAL*8   TEMP(6,6)
      REAL*8   DEFLUN(6),TEMP2(6,6),TEMP3(6,6),RTEMP(6)
C MODIFI DU 18 AOUT 2004 - YLP AJOUT DE LA VARIABLE KRON
      REAL*8   KRON(6),BNSIGI(6),DEPSC(6)
      REAL*8   DEPSR(6),DEPM(6,6),EPSM2(6)
      CHARACTER*16    OPTION(2)
C-----------------------------------------------------------------------
      INTEGER IRET 
      REAL*8 DET 
C-----------------------------------------------------------------------
      DATA     KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
C
C INITIALISATION DES VARIABLES
C
      DO 11 I=1,NSTRS
        SIGT(I)  = 0.D0
        DEFLUN(I) = 0.D0
        DO 12 J=1,NSTRS
          TEMP(I,J) = 0D0
12      CONTINUE
11    CONTINUE
C
        DO 5 I=1,NSTRS
          DO 5 J=1,NSTRS
            DO 5 K=1,NSTRS
              TEMP(I,J) = TEMP(I,J) + CN(I,K) * DEP(K,J)
  5     CONTINUE
C
C CONSTRUCTION DE LA MATRICE D ELASTICITE CORRIGE PAR LE FLUAGE
C
C
C  EQUATION : (3.1-2)
C


        DO 10 I=1,NSTRS
          DO 66 J=1,NSTRS
            TEMP2(I,J) = TEMP(I,J)
  66      CONTINUE
          TEMP2(I,I) = 1.D0 + TEMP2(I,I)
  10    CONTINUE
C EN COMMENTAIRES CI-DESSOUS, L'ANCIENNE VERSION UTILISANT UNE ROUTINE
C D'INVERSION FOURNIE AVEC LE PAQUET DES SOURCES INITIALES. ELLE A ETE
C DEBRANCHEE AU PROFIT DE LA ROUTINE MGAUSS PRE-EXISTANT DANS CODE_ASTER
C        CALL LCUMIN(TEMP,NSTRS,ISING)
C
       DO 16 I=1,NSTRS
         DO 15 J=1,NSTRS
           IF (I.EQ.J) THEN
             TEMP3(I,J) = 1.D0
           ELSE
             TEMP3(I,J) = 0.D0
           ENDIF
 15      CONTINUE
 16    CONTINUE

C
C MODIFI DU 6 JANVIER - YLP
C       CALL MGAUSS(TEMP, TEMP2, NSTRS, NSTRS, NSTRS, ZERO, LGTEST)
C        CALL MGAUSS(TEMP2, TEMP3, 6, NSTRS, NSTRS, ZERO, LGTEST)
       CALL MGAUSS('NFVP',TEMP2, TEMP3, 6, NSTRS, NSTRS, DET, IRET)

       IF((OPTION(2).EQ.'MAZARS').OR.
     &    (OPTION(2).EQ.'ENDO_ISOT_BETON'))THEN

         CALL R8INIR(6,0.D0,RTEMP,1)
         DO 17 I=1,NSTRS
           RTEMP(I)=AN(I)
           DO 17 J=1,NSTRS
C MODIFI DU 18 AOUT 2004 - YLP AJOUT DE LA CORRECTION DES
C DEFORMATIONS TOTALES PAR LES DEFORMATIONS DE RETRAIT
C             RTEMP(I) = RTEMP(I)+BN(I,J)*SIGI(J)+
C     &                           TEMP(I,J)*(EPSM(J)+DEPSI(J)-EPSFM(J))
             RTEMP(I) = RTEMP(I)+BN(I,J)*SIGI(J)+
     &                           TEMP(I,J)*(EPSM(J)+DEPSI(J)-EPSFM(J)
     &                                     -EPSRM*KRON(J))
 17      CONTINUE
C
C CALCUL DE (1 + CN)-1 * E0
C
         DO 20 I=1,NSTRS
           DO 20 J=1,NSTRS
             DEFLUN(I)=DEFLUN(I)+TEMP3(I,J)*RTEMP(J)
  20     CONTINUE
C
         DO 60 I=1,NSTRS
           DO 60 J=1,NSTRS
C MODIFI DU 18 AOUT 2004 - YLP AJOUT DE LA CORRECTION DES
C DEFORMATIONS TOTALES PAR LES DEFORMATIONS DE RETRAIT
C          SIGT(I) = SIGT(I) +
C     &               DEP(I,J) * (EPSM(J)+DEPSI(J)-EPSFM(J)-DEFLUN(J))
              SIGT(I) = SIGT(I) +
     &                  DEP(I,J) * (EPSM(J)+DEPSI(J)-EPSRP*KRON(J)
     &                  -EPSFM(J)-DEFLUN(J))
  60     CONTINUE
C
       ELSE
C --- MODELE BETON_UMLV_FP SEUL - ECRITURE EN INCREMENTALE
C --- CONSTRUCTION VECTEUR DEFORMATION (RETRAIT + THERMIQUE)
         CALL LCINVE(0.D0,DEPSR)
         DO 110 I = 1, NSTRS
           DEPSR(I) = KRON(I)*(EPSRP-EPSRM)
 110     CONTINUE
C --- CALCUL DE BN:SIGI = BNSIGI -> TENSEUR ORDRE 2
         CALL LCPRMV(BN,SIGI,BNSIGI)
C --- CALCUL DE SIGT
         DO 120 I = 1, NSTRS
           DEPSC(I) = DEPSI(I)-AN(I)-BNSIGI(I)-DEPSR(I)
 120     CONTINUE
C --- PRODUIT MATRICE*VECTEUR : (E(T+))*DEPSC
         CALL LCPRMV(DEP,DEPSC,EPSM2)

C --- PRODUIT MATRICE*VECTEUR : (E(T+))*(E(T-))^(-1)*SIGI
         DO 130 I=1,NSTRS
           DO 140 J=1,NSTRS
             IF (I.EQ.J) THEN
               TEMP2(I,J) = 1.D0
             ELSE
               TEMP2(I,J) = 0.D0
             ENDIF
 140       CONTINUE
 130     CONTINUE

         CALL MGAUSS('NFVP',DEPM,TEMP2,6,NSTRS,NSTRS,DET,IRET)
         CALL LCPRMM(TEMP2,DEP,TEMP)
         CALL LCPRMV(TEMP,SIGI,RTEMP)

         DO 150 I = 1, NSTRS
           EPSM2(I) = EPSM2(I) + RTEMP(I)
 150     CONTINUE
         CALL LCPRMV(TEMP3,EPSM2,SIGT)
       ENDIF

       END
