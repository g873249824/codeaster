      SUBROUTINE COSOLI(NUMA  ,CONNEX,LONCUM,COORD ,DIME  ,
     &                  CNOEUD)
C     
C RESPONSABLE ABBAS M.ABBAS
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      INTEGER NUMA,CONNEX(*),LONCUM(*)
      INTEGER DIME
      REAL*8  COORD(3,*),CNOEUD(DIME,*)
C      
C ----------------------------------------------------------------------
C
C CONSTRUCTION DE BOITES ENGLOBANTES POUR UN GROUPE DE MAILLES
C
C RETOURNE LES COORDONNEES DES NOEUDS DE LA MAILLE POUR LES ELEMENTS
C SOLIDES
C
C ----------------------------------------------------------------------
C
C
C IN  NUMA   : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
C IN  CONNEX : CONNEXITE DES MAILLES
C IN  LONCUM : LONGUEUR CUMULEE DE CONNEX
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  COORD  : COORDONNEES DES NOEUDS
C OUT CNOEUD : COORD DES NOEUDS (X1, [Y1, Z1], X2, ...)
C
C ----------------------------------------------------------------------
C           
      INTEGER INO,IDIM,NUNO,JDEC,NBNO     
C
C ----------------------------------------------------------------------
C     
      JDEC   = LONCUM(NUMA)
      NBNO   = LONCUM(NUMA+1) - JDEC
C
      IF ((NBNO.LT.1).OR.(NBNO.GT.27)) CALL ASSERT(.FALSE.)      
C
      DO 10 INO = 1, NBNO       
        NUNO = CONNEX(JDEC-1+INO)
        DO 11 IDIM = 1, DIME
          CNOEUD(IDIM,INO) = COORD(IDIM,NUNO)
 11     CONTINUE
 10   CONTINUE

      END
