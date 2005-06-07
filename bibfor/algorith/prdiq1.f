      SUBROUTINE PRDIQ1(KMIN,
     &                  ARETT1,NOEUT1,ARETT2,NOEUT2,
     &                  ARETT3,NOEUT3,ARETT4,NOEUT4,
     &                  ARETE,NOEUD)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C
      INTEGER      KMIN
      INTEGER      ARETT1(3)
      INTEGER      NOEUT1(3)
      INTEGER      ARETT2(3)
      INTEGER      NOEUT2(3)
      INTEGER      ARETT3(3)
      INTEGER      NOEUT3(3)
      INTEGER      ARETT4(3)
      INTEGER      NOEUT4(3)

      INTEGER      ARETE(4)
      INTEGER      NOEUD(4)
 



C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJQ1
C ----------------------------------------------------------------------
C
C DIAGNOSTIC GEOMETRIQUE FIN POUR LA PROJECTION SUR UN QUADRANGLE
C  CAS 1: SEPARATION EN QUATRE TRIANGLES
C     LA TOLERANCE GEOMETRIQUE <TOLEIN> EST UTILISEE PAR PRDITR
C
C IN  KMIN   : TRIANGLE REALISANT LE JEU MINIMUM
C IN  NOEUT1 : DETECTION DE PROJECTION SUR NOEUDS SUR TRIANGLE 1
C IN  ARETT1 : DETECTION DE PROJECTION SUR ARETES SUR TRIANGLE 1
C IN  NOEUT2 : DETECTION DE PROJECTION SUR NOEUDS SUR TRIANGLE 2
C IN  ARETT2 : DETECTION DE PROJECTION SUR ARETES SUR TRIANGLE 2
C IN  NOEUT3 : DETECTION DE PROJECTION SUR NOEUDS SUR TRIANGLE 3
C IN  ARETT3 : DETECTION DE PROJECTION SUR ARETES SUR TRIANGLE 3
C IN  NOEUT4 : DETECTION DE PROJECTION SUR NOEUDS SUR TRIANGLE 4
C IN  ARETT4 : DETECTION DE PROJECTION SUR ARETES SUR TRIANGLE 4
C OUT ARETE  : DETECTION DE PROJECTION SUR ARETE
C                 (1: SUR L'ARETE, 0: NON)
C              ARETE(1) : SEGMENT AB
C              ARETE(2) : SEGMENT BC
C              ARETE(3) : SEGMENT CD
C              ARETE(3) : SEGMENT DA
C OUT NOEUD  : DETECTION DE PROJECTION SUR NOEUD 
C                 (1: SUR LE NOEUD, 0: NON)
C              NOEUD(1) : NOEUD A
C              NOEUD(2) : NOEUD B
C              NOEUD(3) : NOEUD C
C              NOEUD(4) : NOEUD D
C
C ----------------------------------------------------------------------
C

      ARETE(1) = 0
      ARETE(2) = 0
      ARETE(3) = 0
      ARETE(4) = 0

      NOEUD(1) = 0
      NOEUD(2) = 0
      NOEUD(3) = 0
      NOEUD(4) = 0

      IF (KMIN.EQ.1) THEN
        IF (ARETT1(1).EQ.1) THEN
          ARETE(1) = 1
        ENDIF
        IF (ARETT1(2).EQ.1) THEN
          ARETE(2) = 1
        ENDIF
      ENDIF
      IF (KMIN.EQ.2) THEN
        IF (ARETT2(2).EQ.1) THEN
          ARETE(3) = 1
        ENDIF
        IF (ARETT2(3).EQ.1) THEN
          ARETE(4) = 1
        ENDIF
      ENDIF
      IF (KMIN.EQ.3) THEN
        IF (ARETT3(1).EQ.1) THEN
          ARETE(1) = 1
        ENDIF
        IF (ARETT3(3).EQ.1) THEN
          ARETE(4) = 1
        ENDIF
      ENDIF
      IF (KMIN.EQ.4) THEN
        IF (ARETT4(1).EQ.1) THEN
          ARETE(2) = 1
        ENDIF
        IF (ARETT4(2).EQ.1) THEN
          ARETE(3) = 1
        ENDIF
      ENDIF

      IF ((ARETE(1).EQ.1).AND.
     &    (ARETE(2).EQ.1)) THEN
          NOEUD(2) = 1    
      END IF
      IF ((ARETE(2).EQ.1).AND.
     &    (ARETE(3).EQ.1)) THEN
          NOEUD(3) = 1    
      END IF
      IF ((ARETE(3).EQ.1).AND.
     &    (ARETE(4).EQ.1)) THEN
          NOEUD(4) = 1    
      END IF
      IF ((ARETE(4).EQ.1).AND.
     &    (ARETE(1).EQ.1)) THEN
          NOEUD(1) = 1    
      END IF


      END
