      SUBROUTINE NMPILA(NEQ   , DU    , DU0   , DU1   , C     ,
     &                  DTAU  , DUREF , NBATTE, NBEFFE, ETA   ,
     &                  LICCVG)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/09/2001   AUTEUR PBBHHPB P.BADEL 
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
C RESPONSABLE ADBHHVV V.CANO

      IMPLICIT NONE
      INTEGER  NEQ, NBATTE, LICCVG(NBATTE), NBEFFE
      REAL*8   DU(NEQ), DU0(NEQ), DU1(NEQ), DUREF(NEQ)
      REAL*8   C(NEQ), DTAU, ETA(NBATTE)

C ----------------------------------------------------------------------
C        PILOTAGE PAR LONGUEUR D'ARC :   P(U) = SQR(U.C.U) = DTAU
C ----------------------------------------------------------------------
C
C IN  NEQ    NOMBRE DE DEGRES DE LIBERTE
C IN  DU     INCREMENT DE DEPLACEMENT (DEPDEL.VALE)
C IN  DU0    CORRECTION DE DEPLACEMENT POUR CHARGEMENT CONSTANT
C IN  DU1    CORRECTION DE DEPLACEMENT POUR CHARGEMENT PILOTE
C IN  C      COEFFICIENT DU PRODUIT SCALAIRE
C IN  DTAU   SECOND MEMBRE DE L'EQUATION DE PILOTAGE
C IN  DUREF  INCREMENT DE DEPLACEMENT DU PAS PRECEDENT (REFERENCE)
C OUT ETA    ETA_PILOTAGE
C OUT LICCVG CODE DE CONVERGENCE
C ----------------------------------------------------------------------

      INTEGER I, NRAC
      REAL*8  R0, R1, R2, DTAU2, RAC(2), R8NRM2
      REAL*8  SCA1, SCA2, NODUP1, NODUP2, CO1, CO2
C ----------------------------------------------------------------------


C -- CALCUL DES COEFFICIENTS DU POLYNOME DE DEGRE 2

      DTAU2 = DTAU**2
      R0 = - DTAU2
      R1 =   0.D0
      R2 =   0.D0
      DO 10 I = 1, NEQ
        R0 = R0 + C(I) * (DU(I)+DU0(I))**2
        R1 = R1 + C(I) * (DU(I)+DU0(I))*DU1(I)
        R2 = R2 + C(I) *  DU1(I)**2
 10   CONTINUE
      R1 = 2.D0*R1
      IF (R2.EQ.0) CALL UTMESS ('F','NMPILA','DENOMINATEUR NUL '
     &       //'DANS LE CALCUL DE ETA_PILOTAGE')


C -- RESOLUTION DE L'EQUATION

      CALL ZEROP2(R1/R2,R0/R2,RAC,NRAC)

C    PAS DE RACINE -> ON MINIMISE LA CONTRAINTE (CONV. INTERDITE)
      IF (NRAC.EQ.0) THEN
        NBEFFE    = 1
        LICCVG(1) = 1
        ETA(1)    = - R1 / (2.D0*R2)

C    RACINE DOUBLE
      ELSE IF (NRAC.EQ.1) THEN
        NBEFFE    = 1
        LICCVG(1) = 0
        ETA(1)    = RAC(1)

C    DEUX RACINES
      ELSE

C      SI ON ATTEND 2 SOLUTIONS, OK
        IF (NBATTE.EQ.2) THEN
          NBEFFE    = 2
          LICCVG(1) = 0
          LICCVG(2) = 0
          ETA(1)    = RAC(1)
          ETA(2)    = RAC(2)
      
C      SI ON ATTEND 1 SOLUTION, CHOIX PAR MAX COS(DUREF,DU+DU0+DETA*DU1)
        ELSE
          NBEFFE    = 1
          LICCVG(1) = 0
          
          SCA1   = 0.D0
          SCA2   = 0.D0
          NODUP1 = 0.D0
          NODUP2 = 0.D0
          DO 20 I = 1,NEQ
            SCA1   = SCA1   + DUREF(I)*(DU(I)+DU0(I)+RAC(1)*DU1(I))
            SCA2   = SCA2   + DUREF(I)*(DU(I)+DU0(I)+RAC(2)*DU1(I))
            NODUP1 = NODUP1 + (DU(I)+DU0(I)+RAC(1)*DU1(I))**2
            NODUP2 = NODUP2 + (DU(I)+DU0(I)+RAC(2)*DU1(I))**2
 20       CONTINUE
          CO1 = SCA1 / SQRT(NODUP1)
          CO2 = SCA2 / SQRT(NODUP2)
          IF (CO1.GE.CO2) THEN
            ETA(1) = RAC(1)
          ELSE
            ETA(1) = RAC(2)
          END IF
        END IF
        
      END IF
      END
