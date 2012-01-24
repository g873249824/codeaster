      SUBROUTINE MMMTFC(PHASEP,NDIM  ,NBCPS ,NNL   ,WPG   ,
     &                  FFL   ,JACOBI,TAU1  ,TAU2  ,RESE  ,
     &                  NRESE ,COEFAF,COEFFF,DLAGRC,DLAGRF,
     &                  DJEUT ,MATRFC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/01/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*9  PHASEP
      INTEGER      NDIM,NNL,NBCPS
      REAL*8       WPG,FFL(9),JACOBI
      REAL*8       TAU1(3),TAU2(3)
      REAL*8       RESE(3),NRESE
      REAL*8       DLAGRC,DLAGRF(2)
      REAL*8       DJEUT(3)
      REAL*8       COEFAF,COEFFF
      REAL*8       MATRFC(18,9)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DE LA MATRICE LAGR_F/LAGR_C
C
C ----------------------------------------------------------------------
C
C
C IN  PHASEP : PHASE DE CALCUL
C              'SANS' - PAS DE CONTACT
C              'ADHE' - CONTACT ADHERENT
C              'GLIS' - CONTACT GLISSANT
C              'SANS_PENA' - PENALISATION - PAS DE CONTACT
C              'ADHE_PENA' - PENALISATION - CONTACT ADHERENT
C              'GLIS_PENA' - PENALISATION - CONTACT GLISSANT
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NBCPS  : NB DE DDL DE LAGRANGE
C IN  NNL    : NOMBRE DE NOEUDS LAGRANGE
C IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFL    : FONCTIONS DE FORMES LAGR.
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  TAU1   : PREMIER VECTEUR TANGENT
C IN  TAU2   : SECOND VECTEUR TANGENT
C IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C               GTK = LAMBDAF + COEFAF*VITESSE
C IN  NRESE  : RACINE DE LA NORME DE RESE
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  COEFAF : COEF_AUGM_FROT
C IN  DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
C IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
C IN  DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
C OUT MATRFC : MATRICE ELEMENTAIRE LAGR_F/LAGR_C
C
C ----------------------------------------------------------------------
C
      INTEGER   NBCPF
      INTEGER   INOC,INOF,ICMP,IDIM,JJ 
      REAL*8    DJEUTT(2),RESET(2)
      REAL*8    COEF,R8PREM
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      CALL VECINI(2,0.D0,DJEUTT)
      CALL VECINI(2,0.D0,RESET )      
      NBCPF = NBCPS - 1
      COEF  = COEFAF * DLAGRC
      IF (ABS(COEF).LE.R8PREM()) COEF = COEFAF
C
C --- PROJECTION INCREMENT DEPDEL DU JEU TANGENT SUR LE PLAN TANGENT
C
      IF (PHASEP(1:4).EQ.'ADHE') THEN
        DO 10 IDIM = 1,NDIM
          DJEUTT(1) = DJEUT(IDIM)*TAU1(IDIM)+DJEUTT(1)       
          DJEUTT(2) = DJEUT(IDIM)*TAU2(IDIM)+DJEUTT(2)
 10     CONTINUE
      ENDIF
C
C --- PROJECTION DU SEMI-MULT. DE FROTTEMENT SUR LE PLAN TANGENT
C
      IF (PHASEP(1:4).EQ.'GLIS') THEN
        DO 15 IDIM = 1,NDIM
          RESET(1)  = RESE(IDIM)*TAU1(IDIM)+RESET(1)
          RESET(2)  = RESE(IDIM)*TAU2(IDIM)+RESET(2)
 15     CONTINUE  
      ENDIF
C
C --- CALCUL DES TERMES
C      
      IF (PHASEP(1:4).EQ.'ADHE') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
C
C ----- ON NE FAIT RIEN / LA MATRICE EST NULLE
C    
        ELSE
          DO 207 INOC = 1,NNL
            DO 197 INOF = 1,NNL
              DO 187 ICMP = 1,NBCPF
                JJ = NBCPF*(INOF-1)+ICMP
                MATRFC(JJ,INOC) = MATRFC(JJ,INOC) -
     &           COEFFF*WPG*FFL(INOC)*FFL(INOF)*JACOBI*
     &           DJEUTT(ICMP)
  187         CONTINUE
  197       CONTINUE
  207     CONTINUE
        ENDIF

      ELSEIF (PHASEP(1:4).EQ.'GLIS') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
C
C ----- ON NE FAIT RIEN / LA MATRICE EST NULLE
C
        ELSE
          IF (NDIM.EQ.2) THEN
            DO 205 INOC = 1,NNL
              DO 195 INOF = 1,NNL
                DO 185 ICMP = 1,NBCPF
                  JJ = NBCPF*(INOF-1)+ICMP
                  MATRFC(JJ,INOC) = MATRFC(JJ,INOC) + 
     &  (1.D0/COEF)*COEFFF*WPG*FFL(INOC)*FFL(INOF)*JACOBI*
     &  (DLAGRF(ICMP)-RESET(ICMP)/NRESE) 
  185           CONTINUE
  195         CONTINUE
  205       CONTINUE
          ELSEIF (NDIM.EQ.3) THEN
            DO 209 INOC = 1,NNL
              DO 199 INOF = 1,NNL
                DO 189 ICMP = 1,NBCPF
                  JJ = NBCPF*(INOF-1)+ICMP
                  MATRFC(JJ,INOC) = MATRFC(JJ,INOC) + 
     &  (1.D0/COEF)*COEFFF*WPG*FFL(INOC)*FFL(INOF)*JACOBI*
     &  DLAGRF(ICMP) 
  189           CONTINUE
  199         CONTINUE
  209       CONTINUE
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ENDIF
      ENDIF
      END
