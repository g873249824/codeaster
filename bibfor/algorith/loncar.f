      SUBROUTINE LONCAR(ELREF,COORD,L)
      IMPLICIT NONE 

      REAL*8        COORD(*),L
      CHARACTER*8   ELREF

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/01/2005   AUTEUR GENIAUT S.GENIAUT 
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

C                      LONGUEUR CARACT�RISTIQUE D'UN �L�MENT
C
C     ENTREE
C       ELREF   : TYPE D'�L�MENT DE R�F�RENCE 
C       COORD   : COORDONN�ES DES NOEUDS
C
C     SORTIE
C       L      : LONGUEUR CARACT�RISTIQUE
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER        I,J
      REAL*8         AR(3)
C ----------------------------------------------------------------------

      CALL JEMARQ()

      IF (ELREF.EQ.'HE8'.OR.ELREF.EQ.'X20') THEN

C       LA LONGUEUR CARACT�RISTIQUE EST LA GRANDE DIAGONALE N1-N7
        L=SQRT( (COORD(1)-COORD(19))**2 + (COORD(2)-COORD(20))**2
     &                                  + (COORD(3)-COORD(21))**2 )

      ELSEIF (ELREF.EQ.'PE6'.OR.ELREF.EQ.'X15') THEN

C       LA LONGUEUR CARACT�RISTIQUE EST ((N3-N1)*(N3-N2)*(N3-N6))^(1/3)
        AR(1)=SQRT((COORD(7)-COORD(1))**2  + (COORD(8)-COORD(2))**2 
     &                                     + (COORD(9)-COORD(3))**2 )
        AR(2)=SQRT((COORD(7)-COORD(4))**2  + (COORD(8)-COORD(5))**2 
     &                                     + (COORD(9)-COORD(6))**2 )
        AR(3)=SQRT((COORD(7)-COORD(16))**2 + (COORD(8)-COORD(17))**2 
     &                                     + (COORD(9)-COORD(18))**2 )
        L=(AR(1)*AR(2)*AR(3))**(1/3)

      ELSEIF (ELREF.EQ.'TE4'.OR.ELREF.EQ.'X10') THEN

C       LA LONGUEUR CARACT�RISTIQUE EST ((N1-N2)*(N1-N3)*(N1-N4))^(1/3)
        DO 10 I=1,3
          AR(I)=SQRT((COORD(1)-COORD(3*I+1))**2 + 
     &        (COORD(2)-COORD(3*I+2))**2 + (COORD(3)-COORD(3*I+3))**2 )
 10     CONTINUE
        L=(AR(1)*AR(2)*AR(3))**(1/3)

      ELSE
        CALL UTMESS('F','LONCAR','TYPE D''ELEMENT FINI PAS TRAITE')
      ENDIF

      CALL JEDEMA()
      END
