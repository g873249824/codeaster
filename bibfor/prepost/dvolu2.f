      FUNCTION DVOLU2(COORD,NORM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/07/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

C**********************************************************
C              BUT DE CETTE ROUTINE :                     *
C CALCULER LE VOLUME DE L INTERSECTION CYLINDRE-TETRAEDRE *
C**********************************************************

C IN   COORD  : COORDONNEES DES NOEUDS DU TETRA
C               ET DES INTERSECTIONS AVEC LE CYLINDRE
C IN   NORM   : POSITION DES NOEUDS PAR RAPPORT AU CYLINDRE 
C OUT  DVOLU2 : VOLUME DE L INTERSECTION

      IMPLICIT NONE 

C DECLARATION GLOBALE

      INTEGER NORM(2,4)
      REAL*8 COORD(3,12),DVOLU2

C DECLARATION LOCALE

      INTEGER I,J,K,L,M,N
      REAL*8  VOL3, VOL4, VOL5

C 1 - RECHERCHE DES DEUX POINTS INTERNES
C     RQ : 2 POINTS DEDANS ET 4 INTERSECTIONS

      I = 0
      DO 10 K = 1,4
        IF ( NORM(1,K).EQ.1.AND.I.GT.0 ) J = K
        IF ( NORM(1,K).EQ.1.AND.I.EQ.0 ) I = K
 10   CONTINUE
 
C 2 - TABLEAU DES INTERSECTIONS

      IF ( I.EQ.1.AND.J.EQ.2 ) THEN
        K = 6
        L = 7
        M = 8
        N = 9
      ELSE IF ( I.EQ.1.AND.J.EQ.3 ) THEN
        K = 7
        L = 5
        M = 10
        N = 8
      ELSE IF ( I.EQ.1.AND.J.EQ.4 ) THEN
        K = 5
        L = 6
        M = 9
        N = 10
      ELSE IF ( I.EQ.2.AND.J.EQ.3 ) THEN
        K = 5
        L = 9
        M = 6
        N = 10
      ELSE IF ( I.EQ.2.AND.J.EQ.4 ) THEN
        K = 8
        L = 5
        M = 10
        N = 7
      ELSE IF ( I.EQ.3.AND.J.EQ.4 ) THEN
        K = 6
        L = 8
        M = 7
        N = 9
      ENDIF

C 3 - CALCUL DU VOLUME 

      VOL3 =(COORD(1,L)-COORD(1,I))*
     &    ((COORD(2,J)-COORD(2,I))*(COORD(3,K)-COORD(3,I)) -
     &      (COORD(3,J)-COORD(3,I))*(COORD(2,K)-COORD(2,I)) )
      VOL3 = VOL3 +(COORD(2,L)-COORD(2,I))*
     &    ((COORD(1,K)-COORD(1,I))*(COORD(3,J)-COORD(3,I)) -
     &      (COORD(3,K)-COORD(3,I))*(COORD(1,J)-COORD(1,I)) )
      VOL3 = VOL3 +(COORD(3,L)-COORD(3,I))*
     &    ((COORD(1,J)-COORD(1,I))*(COORD(2,K)-COORD(2,I)) -
     &      (COORD(2,J)-COORD(2,I))*(COORD(1,K)-COORD(1,I)) )

      IF ( ABS(VOL3).LT.1.0D-10 ) VOL3 = 0.0D0     
      IF ( VOL3.LT.0.D0 ) VOL3 = - VOL3

      VOL4 =(COORD(1,L)-COORD(1,J))*
     &    ((COORD(2,M)-COORD(2,J))*(COORD(3,K)-COORD(3,J)) -
     &      (COORD(3,M)-COORD(3,J))*(COORD(2,K)-COORD(2,J)) )
      VOL4 = VOL4 +(COORD(2,L)-COORD(2,J))*
     &    ((COORD(1,K)-COORD(1,J))*(COORD(3,M)-COORD(3,J)) -
     &      (COORD(3,K)-COORD(3,J))*(COORD(1,M)-COORD(1,J)) )
      VOL4 = VOL4 +(COORD(3,L)-COORD(3,J))*
     &    ((COORD(1,M)-COORD(1,J))*(COORD(2,K)-COORD(2,J)) -
     &      (COORD(2,M)-COORD(2,J))*(COORD(1,K)-COORD(1,J)) )

      IF ( ABS(VOL4).LT.1.0D-10 ) VOL4 = 0.0D0     
      IF ( VOL4.LT.0.D0 ) VOL4 = - VOL4

      VOL5 =(COORD(1,L)-COORD(1,J))*
     &    ((COORD(2,N)-COORD(2,J))*(COORD(3,M)-COORD(3,J)) -
     &      (COORD(3,N)-COORD(3,J))*(COORD(2,M)-COORD(2,J)) )
      VOL5 = VOL5 +(COORD(2,L)-COORD(2,J))*
     &    ((COORD(1,M)-COORD(1,J))*(COORD(3,N)-COORD(3,J)) -
     &      (COORD(3,M)-COORD(3,J))*(COORD(1,N)-COORD(1,J)) )
      VOL5 = VOL5 +(COORD(3,L)-COORD(3,J))*
     &    ((COORD(1,N)-COORD(1,J))*(COORD(2,M)-COORD(2,J)) -
     &      (COORD(2,N)-COORD(2,J))*(COORD(1,M)-COORD(1,J)) )

      IF ( ABS(VOL5).LT.1.0D-6 ) VOL5 = 0.0D0     
      IF ( VOL5.LT.0.D0 ) THEN
        CALL UTMESS('A','DVOLU2','VOLUME NEGATIF' )
        VOL5 = - VOL5
      ENDIF
      DVOLU2 = VOL3 + VOL4 + VOL5
      DVOLU2 = DVOLU2 / 6.D0

      END
