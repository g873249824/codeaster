      SUBROUTINE DISREC(PZ,AZ,BZ,R,H)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/09/2010   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      REAL*8        PZ(2),AZ,BZ,R,H,XC,YC

C
C      CALCUL DE H : DISTANCE SIGNEE ENTRE LE POINT P ET LE RECTANGLE
C      DE CENTRE (0,0), DE DEMI-GRAND AXE A ET DE DEMI-PETIT AXE B
C      DONT L'ANGLE DROIT PEUT ETRE ARRONDI AVEC LE RAYON D
C
C IN  PZ     : POINT DU PLAN DONT ON CHERCHE LA DISTANCE AU RECTANGLE
C IN  AZ     : DEMI-GRAND AXE DU RECTANGLE (SUIVANT L'AXE X)
C IN  BZ     : DEMI-PETIT AXE DU RECTANGLE (SUIVANT L'AXE Y)
C IN  R      : RAYON DE L'ANGLE
C OUT H      : DISTANCE SIGNEE ENTRE LE POINT P ET LE RECTANGLE

      REAL*8        A,B,TEMP,P(2),X,Y

C     ON ADOPTE LA MEME CONFIGURATION QUE CELLE DE LA ROUTINE DISELL :
C     LE QUART DU RECTANGLE CONSIDERE EST DANS LE PLAN OXY
C
C     CHOIX DU SIGNE DE LA DISTANCE H :
C     H EST NEGATIF A L'INTERIEUR DU RECTANGLE
C     H EST POSITIF A L'EXTERIEUR DU RECTANGLE
C
C     TRAVAIL SUR DES VARIABLES LOCALES CAR ON RISQUE DE LES MODIFIER
      A = AZ
      B = BZ
      P(1) = PZ(1)
      P(2) = PZ(2)

C     VERIFICATIONS
      CALL ASSERT(A.GT.0.D0 .AND. B.GT.0.D0)
      IF (A.LT.B) THEN
C       SI A EST PLUS PETIT QUE B, ON INVERSE A ET B 
C       ET AUSSI LES COORDONNÉES DU POINT P
        TEMP = A
        A = B
        B = TEMP
        TEMP = P(1)
        P(1) = P(2)
        P(2) = TEMP
      ENDIF

C     DEFINITION DE QUELQUES VARIABLES UTILES
C     ---------------------------------------

C     ABSCISSE ET ORDONNEE DU POINT P (TOUJOURS POSITIVES) 
      X=ABS(P(1))       
      Y=ABS(P(2))

C     ABSCISSE ET ORDONNEE DU CENTRE DU CONGE
      XC = A-R
      YC = B-R

      CALL ASSERT(A.GE.B)
      CALL ASSERT(X.GE.0.D0)
      CALL ASSERT(Y.GE.0.D0)

C     CALCUL DE LA DISTANCE SIGNEE
C     ----------------------------

      IF (Y.GE.X+B-A .AND. X.LE.XC) THEN

C       ZONE 1
        H = Y-B

      ELSEIF (Y.LE.X+B-A .AND. Y.LE.YC) THEN

C       ZONE 2
        H = X-A
        
      ELSE

C       ZONE 3
        H = SQRT( (X-XC)**2 + (Y-YC)**2 ) - R

      ENDIF

      END
