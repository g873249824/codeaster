      SUBROUTINE LKD2SH(NMAT,MATERF,VARH,DHDS,DEVSIG,RCOS3T,
     &                  D2SHDS,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/09/2012   AUTEUR FOUCAULT A.FOUCAULT 
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
C RESPONSABLE FOUCAULT A.FOUCAULT
      IMPLICIT   NONE
C     ------------------------------------------------------------------
C     CALCUL DE DERIVEE 2NDE DE SII*H PAR RAPPORT A SIGMA 
C     IN  NMAT   : DIMENSION TABLE DES PARAMETRES MATERIAU
C         MATERF : PARAMETRES MATERIAU A T+DT
C         VARH   : VECTEUR CONTENANT H0E,H0C ET HTHETA
C         DHDS   : DERIVEE DE HTHETA PAR RAPPORT A SIGMA
C         DEVSIG : DEIATEUR DES CONTRAINTES
C         RCOS3T : COS(3THETA) = SQRT(54)*DET(DEVISG)/SII**3
C     OUT D2SHDS :  DERIVEE 2NDE SII*H PAR RAPPORT A SIGMA (NDT X NDT)
C         IRET   :  CODE RETOUR
C     ------------------------------------------------------------------
      INTEGER         IRET,NMAT
      REAL*8          MATERF(NMAT,2),VARH(3),D2SHDS(6,6),DHDS(6)
      REAL*8          DEVSIG(6),RCOS3T
C
      INTEGER         NDI,NDT,I,J
      REAL*8          H0EXT,COEFH,SII,UN,ZERO,DIKDJL(6,6),DIJDKL(6,6)
      REAL*8          TROIS,DSIIDS(6),DSDSIG(6,6),MAT1(6,6),D2HDS2(6,6)
      REAL*8          MAT2(6,6),MAT3(6,6),DHTDS(6),MAT4(6,6),MAT5(6,6)
      REAL*8          D2HDSI(6,6)
      PARAMETER       ( ZERO   = 0.0D0 )
      PARAMETER       ( UN     = 1.0D0 )
      PARAMETER       ( TROIS  = 3.0D0 )
C     ------------------------------------------------------------------
      COMMON /TDIM/   NDT,NDI
C     ------------------------------------------------------------------

C --- RECUPERATION PROPRIETES MATERIAUX
      H0EXT = MATERF(4,2)

C --- COEFFICIENT (H0C-H0EXT)/(H0C-HOE)
      COEFH = (VARH(2)-H0EXT)/(VARH(2)-VARH(1))

C --- CONSTRUCTION DE SII
      CALL LCPRSC(DEVSIG,DEVSIG,SII)
      SII = SQRT(SII)

C --- INITIALISATION MATRICE D_IK X D_JL
      CALL LCINMA(ZERO,DIKDJL)
      DO 10 I = 1, NDT
        DIKDJL(I,I) = UN
  10  CONTINUE

C --- INITIALISATION MATRICE D_IJ X D_KL
      CALL LCINMA(ZERO,DIJDKL)
      DO 20 I = 1, NDI
        DO 30 J = 1, NDI
          DIJDKL(I,J) = UN/TROIS
  30    CONTINUE
  20  CONTINUE

C --- CALCUL DERIVEE SII PAR RAPPORT A SIGMA = 
C          SIJ/SII*(K_IK*K_KL-1/3*K_IJ*K_KL)
      DO 40 I = 1, NDT
        DSIIDS(I) = ZERO
        DO 50 J = 1, NDT
          DSDSIG(J,I) = DIKDJL(J,I)-DIJDKL(J,I)
          DSIIDS(I) = DSIIDS(I) + DEVSIG(J)*DSDSIG(J,I)/SII
  50    CONTINUE 
  40  CONTINUE

C --- CALCUL DE DHDS*DSIIDS
      CALL LCPRTE(DHDS,DSIIDS,MAT1)

C --- CALCUL DE D2HDS2
      CALL LKD2HS(NMAT,MATERF,DEVSIG,SII,RCOS3T,DHDS,D2HDS2)

C --- CALCUL DE D2HDSIGMA    
      CALL LCPRMM(D2HDS2,DSDSIG,D2HDSI)

C --- CONSTRUCTION DE SII*D2HDSDSIGMA = MAT2
      CALL LCPRSM(SII,D2HDSI,MAT2)

C --- ADDITION DE MAT2 + MAT1 = MAT3
      CALL LCSOMA(MAT1,MAT2,MAT3)

C --- CALCUL DE COEFH*MAT3 = MAT2
      CALL LCPRSM(COEFH,MAT3,MAT2)

C --- CONSTRUCTION DE DHTDSIGMA = DHTDS*DSDSIG     
      CALL LCPRSM(COEFH,DSDSIG,MAT1)
      DO 60 I = 1, NDT
        DHTDS(I) = ZERO
        DO 70 J = 1, NDT
          DHTDS(I) = DHTDS(I) + DHDS(J)*MAT1(J,I)/SII
  70    CONTINUE  
  60  CONTINUE

C --- CONSTRUCTION PRODUIT TENSORIEL DE MAT1 = DEVSIG*DHTDSIGMA
      CALL LCPRTE(DEVSIG,DHTDS,MAT1)

C --- CALCUL DE HTHETA/SII*DSDSIG = MAT3
      CALL LCPRSM(VARH(3)/SII,DSDSIG,MAT3)

C --- MAT5 = HTHETA*DEVSIG*DSIIDS/SII**2
      CALL LCPRTE(DEVSIG,DSIIDS,MAT4)
      CALL LCPRSM(VARH(3)/SII**2,MAT4,MAT5)

C --- MAT4 = MAT2+MAT1+MAT3-MAT5
      DO 80 I = 1, NDT
        DO 90 J = 1, NDT
          MAT4(I,J) = MAT2(I,J)+MAT1(I,J)+MAT3(I,J)-MAT5(I,J)
  90    CONTINUE
  80  CONTINUE

C --- D2SHDS = DSDSIG.MAT4
      CALL LCPRMM(DSDSIG,MAT4,D2SHDS)
      
      END
