      SUBROUTINE LKD2FS(NMAT,MATERF,PARA,VARA,VARH,I1,DEVSIG,DS2HDS,
     &                  D2SHDS,D2FDS2,IRET)
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
C     CALCUL DE DERIVEE 2NDE DE F PAR RAPPORT A SIGMA 
C     IN  NMAT   : DIMENSION TABLE DES PARAMETRES MATERIAU
C         MATERF : PARAMETRES MATERIAU A T+DT
C         I1     : TRACE DES CONTRAINTES
C         DEVSIG : DEVIATEUR DES CONTRAINTES
C         PARA   : PARAMETRES AXI, SXI, MXI
C         VARA   : PARAMTERES ADXI,BDXI,DDXI,KDXI
C         VARH   : VECTEUR CONTENANT H0E,H0C ET HTHETA
C         DS2HDS : DERIVEE DE SII*H PAR RAPPORT A SIGMA
C         D2SHDS : DERIVVE 2NDE DE SII*H PAR RAPPORT A SIGMA 
C     OUT D2FDS2 :  DERIVEE 2NDE F PAR RAPPORT A SIGMA (NDT X NDT)
C         IRET   :  CODE RETOUR
C     ------------------------------------------------------------------
      INTEGER         IRET,NMAT
      REAL*8          D2FDS2(6,6),PARA(3),VARA(4),MATERF(NMAT,2)
      REAL*8          DEVSIG(6),I1,DS2HDS(6),VARH(3),D2SHDS(6,6)
C
      INTEGER         NDI,NDT,I
      REAL*8          SIGC,SII,COEF1,COEF2,VIDENT(6),ZERO,UN,VECT1(6)
      REAL*8          MAT1(6,6),MAT2(6,6),MAT3(6,6),UCRI,DEUX
      PARAMETER       ( ZERO   = 0.0D0 )
      PARAMETER       ( UN     = 1.0D0 )
      PARAMETER       ( DEUX   = 2.0D0 )
C     ------------------------------------------------------------------
      COMMON /TDIM/   NDT,NDI
C     ------------------------------------------------------------------

C --- RECUPERATION PARAMETRES MATERIAU
      SIGC = MATERF(3,2)

C --- CONSTRUCTION DE SII
      CALL LCPRSC(DEVSIG,DEVSIG,SII)
      SII = SQRT(SII)

C --- CONSTRUCTION COEF1 = A*SIGC*H0C*(A-1)(AD*SII*H+B*I1+D)^(A-2)
      UCRI = VARA(1)*SII*VARH(3)+VARA(2)*I1+VARA(3)
      IF(UCRI.LE.ZERO)THEN
        UCRI  = ZERO
        COEF1 = ZERO
        COEF2 = UN
      ELSE
        COEF1 = PARA(1)*SIGC*VARH(2)*(PARA(1)-UN)*UCRI**(PARA(1)-DEUX)
C --- CONSTRUCTION COEF2 = A*SIGC*H0C(AD*SII*H+B*I1+D)^(A-1)
        COEF2 = UN-(VARA(1)*PARA(1)*SIGC*VARH(2)*UCRI**(PARA(1)-UN))
      ENDIF
      
C --- CONSTRUCTION VECTEUR IDENTITE
      CALL LCINVE(ZERO,VIDENT)
      DO 10 I = 1, NDI
        VIDENT(I) = UN
  10  CONTINUE

C --- CONSTRUCTION (A*DS2HDS+B*VIDENT)
      DO 20 I = 1, NDT
        VECT1(I) = VARA(1)*DS2HDS(I)+VARA(2)*VIDENT(I)
  20  CONTINUE
C --- CONSTRUCTION PRODUIT TENSORIEL COEF1*(VECT1 X VECT1)
      CALL LCPRTE(VECT1,VECT1,MAT1)
      CALL LCPRSM(COEF1,MAT1,MAT2)

C --- CONSTRUCTION PRODUIT COEF2*D2SHDS
      CALL LCPRSM(COEF2,D2SHDS,MAT3)   

C --- CONSTRUCTION DIFFERENCE MAT3-MAT2 = D2FDS2
      CALL LCDIMA(MAT3,MAT2,D2FDS2)

      END
