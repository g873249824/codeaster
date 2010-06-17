      SUBROUTINE XINVAC(ELP,NDIM,JTABAR,S,KSI)
      IMPLICIT NONE 

      INTEGER     NDIM,JTABAR
      REAL*8      S,KSI(NDIM)
      CHARACTER*8 ELP

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                      TROUVER LES PTS MILIEUX ENTRE LES EXTREMITES DE
C                      L'ARETE ET LE POINT D'INTERSECTION
C                    
C     ENTREE
C       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
C       JTABAR  : COORDONNEES DES 3 NOEUDS DE L'ARETE
C       S       : ABSCISSE CURVILIGNE DU POINT SUR L'ARETE
C
C     SORTIE
C       XE      : COORDONNES DE REFERENCE DU POINT
C     ----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  ------------------------

      REAL*8      COEF1,COEF2,COEF3
      REAL*8      PT1(NDIM),PT2(NDIM),PT3(NDIM)
      REAL*8      D,R8PREM,EPSMAX
      INTEGER     ITEMAX,I,IBID,NUM  
      CHARACTER*6 NAME
C
C.....................................................................

      CALL JEMARQ()

      ITEMAX=500
      EPSMAX=1.D-9
      NAME='XINVAC'

C    CALCUL DE COEF1, COEF2, COEF3, D
      COEF1=0.D0
      COEF2=0.D0
      COEF3=0.D0
      CALL VECINI(NDIM,0.D0,PT1)
      CALL VECINI(NDIM,0.D0,PT2)
      CALL VECINI(NDIM,0.D0,PT3)

      DO 101 I=1, NDIM
        PT1(I)=ZR(JTABAR-1+I)
        PT2(I)=ZR(JTABAR-1+NDIM+I)
        PT3(I)=ZR(JTABAR-1+2*NDIM+I)
 101  CONTINUE

      DO 102 I=1,NDIM
        COEF1 = COEF1 + (PT1(I)-2*PT3(I)+PT2(I))*
     &                                  (PT1(I)-2*PT3(I)+PT2(I))
 102  CONTINUE  
     
      DO 103 I=1,NDIM
        COEF2 = COEF2 + (PT2(I)-PT1(I))*(PT1(I)-2*PT3(I)+PT2(I))
 103  CONTINUE

      DO 104 I=1,NDIM
        COEF3 = COEF3 + (PT2(I)-PT1(I))*(PT2(I)-PT1(I))/4
 104  CONTINUE

      D = COEF2*COEF2 - 4*COEF1*COEF3

C    CALCUL COORDONNEES DE REFERENCE DU POINT

      IF (ABS(COEF1).LE.R8PREM()) THEN
        KSI(1) = (S/SQRT(COEF3))-1
      ELSEIF(ABS(COEF1).GT.R8PREM()) THEN
        IF    (ABS(D).LE.R8PREM()) THEN
          NUM=1
        ELSEIF(D.GT.R8PREM()) THEN
          NUM=2      
        ELSEIF(D.LT.-R8PREM()) THEN
          NUM=3
        ENDIF

        CALL XNEWTO(ELP,NAME,NUM,IBID,NDIM,IBID,JTABAR,IBID,IBID,
     &                  IBID,S,ITEMAX,EPSMAX,KSI)
      ENDIF

      CALL JEDEMA()
      END
