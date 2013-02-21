      SUBROUTINE NIRFPD(NDIM,NNO1,NNO2,NNO3,NPG,IW,VFF1,VFF2,VFF3,
     &                  IDFF1,VU,VG,VP,TYPMOD,GEOMI,SIGREF,EPSREF,VECT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/02/2013   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRS_1404
C RESPONSABLE SFAYOLLE S.FAYOLLE

      IMPLICIT NONE
      INTEGER      NDIM,NNO1,NNO2,NNO3,NPG,IW,IDFF1
      INTEGER      VU(3,27),VG(27),VP(27)
      REAL*8       GEOMI(NDIM,NNO1)
      REAL*8       VFF1(NNO1,NPG),VFF2(NNO2,NPG),VFF3(NNO3,NPG)
      REAL*8       SIGREF,EPSREF
      REAL*8       VECT(*)
      CHARACTER*8  TYPMOD(*)

C-----------------------------------------------------------------------
C          CALCUL DE REFE_FORC_NODA POUR LES ELEMENTS
C          INCOMPRESSIBLES POUR LES GRANDES DEFORMATIONS
C          3D/D_PLAN/AXIS
C          ROUTINE APPELEE PAR TE0591
C-----------------------------------------------------------------------
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AU GONFLEMENT
C IN  NNO3    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES AU GONFLEMENT
C IN  VFF3    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C IN  IDFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  IDFF2   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  VU      : TABLEAU DES INDICES DES DDL DE DEPLACEMENTS
C IN  VG      : TABLEAU DES INDICES DES DDL DE GONFLEMENT
C IN  VP      : TABLEAU DES INDICES DES DDL DE PRESSION
C IN  GEOMI   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  SIGREF  : CONTRAINTE DE REFERENCE
C IN  EPSREF  : DEFORMATION DE REFERENCE
C OUT VECT    : REFE_FORC_NODA
C-----------------------------------------------------------------------

      LOGICAL      AXI
      INTEGER      NDDL,G
      INTEGER      KL,SA,RA,NA,IA,JA,KK
      INTEGER      NDIMSI
      REAL*8       R,W,SIGMA(6)
      REAL*8       RAC2
      REAL*8       F(3,3)
      REAL*8       DEF(6,NNO1,NDIM)
      REAL*8       DDOT,T1,DFF1(NNO1,4)

      DATA         F    / 1.D0, 0.D0, 0.D0,
     &                    0.D0, 1.D0, 0.D0,
     &                    0.D0, 0.D0, 1.D0 /
C-----------------------------------------------------------------------

C - INITIALISATION

      AXI  = TYPMOD(1).EQ.'AXIS'
      NDDL = NNO1*NDIM + NNO2 + NNO3
      RAC2  = SQRT(2.D0)
      NDIMSI = 2*NDIM

      CALL R8INIR(NDDL,0.D0,VECT,1)

      DO 1000 G = 1,NPG

        CALL DFDMIP(NDIM,NNO1,AXI,GEOMI,G,IW,VFF1(1,G),IDFF1,R,W,DFF1)

C - CALCUL DE LA MATRICE B EPS_ij=B_ijkl U_kl
        IF (NDIM.EQ.2) THEN
          DO 35 NA=1,NNO1
            DO 45 IA=1,NDIM
              DEF(1,NA,IA)= F(IA,1)*DFF1(NA,1)
              DEF(2,NA,IA)= F(IA,2)*DFF1(NA,2)
              DEF(3,NA,IA)= 0.D0
              DEF(4,NA,IA)=(F(IA,1)*DFF1(NA,2)+F(IA,2)*DFF1(NA,1))/RAC2
 45         CONTINUE
 35       CONTINUE
        ELSE
          DO 36 NA=1,NNO1
            DO 46 IA=1,NDIM
              DEF(1,NA,IA)= F(IA,1)*DFF1(NA,1)
              DEF(2,NA,IA)= F(IA,2)*DFF1(NA,2)
              DEF(3,NA,IA)= F(IA,3)*DFF1(NA,3)
              DEF(4,NA,IA)=(F(IA,1)*DFF1(NA,2)+F(IA,2)*DFF1(NA,1))/RAC2
              DEF(5,NA,IA)=(F(IA,1)*DFF1(NA,3)+F(IA,3)*DFF1(NA,1))/RAC2
              DEF(6,NA,IA)=(F(IA,2)*DFF1(NA,3)+F(IA,3)*DFF1(NA,2))/RAC2
 46         CONTINUE
 36       CONTINUE
        ENDIF

C - TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
        IF (AXI) THEN
          DO 47 NA=1,NNO1
            DEF(3,NA,1) = F(3,3)*VFF1(NA,G)/R
 47       CONTINUE
        END IF

C - VECTEUR FINT:U
        DO 10 KL = 1,NDIMSI
          CALL R8INIR(6,0.D0,SIGMA,1)
          SIGMA(KL) = SIGREF
          DO 300 NA=1,NNO1
            DO 310 IA=1,NDIM
              KK = VU(IA,NA)
              T1 = DDOT(2*NDIM, SIGMA,1, DEF(1,NA,IA),1)
              VECT(KK) = VECT(KK) + ABS(W*T1)/NDIMSI
 310        CONTINUE
 300      CONTINUE
 10     CONTINUE

C - VECTEUR FINT:G
        DO 350 RA=1,NNO2
          KK = VG(RA)
          T1 = VFF2(RA,G)*SIGREF
          VECT(KK) = VECT(KK) + ABS(W*T1)
 350    CONTINUE

C - VECTEUR FINT:P
        DO 370 SA=1,NNO3
          KK = VP(SA)
          T1 = VFF3(SA,G)*EPSREF
          VECT(KK) = VECT(KK) + ABS(W*T1)
 370    CONTINUE

 1000 CONTINUE
      END
