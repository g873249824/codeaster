      SUBROUTINE ECHMC2(NS,ARE,NARE,NH,OS,SEG,NSEG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/11/2004   AUTEUR DURAND C.DURAND 
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
C ----------------------------------------------------------------------
C  CONNECTIVITE DE L'ECHANTILLONNAGE PRODUIT PAR LA ROUTINE ECHMAP (2D)
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE
C INTEGER      NS              : NOMBRE DE SOMMETS
C INTEGER      ARE(*)          : CONNECTIVITE DES ARETES (CF. NOARET)
C INTEGER      NARE            : NOMBRE D'ARETES
C INTEGER      NH              : NOMBRE D'ECHANTILLONNAGE (NH .GE. 1)
C INTEGER      OS              : OFFSET SOMMET
C
C VARIABLES DE SORTIE
C INTEGER      SEG(2,*)        : CONNECTIVITE DES SEGMENTS
C INTEGER      NSEG            : NOMBRE DE SEGMENTS 
C
C DIMENSION
C NSEG : NARE*NH 
C ----------------------------------------------------------------------

      IMPLICIT NONE

C --- VARIABLES
      INTEGER SEG(2,*),NSEG,NH,OS,NNP,N0,N1,I,J,P0,NS,ARE(*),NARE

      P0 = 1
      NSEG = 0
      N0 = NS + OS
   
      DO 10 I = 1, NARE
                    
        NNP = ARE(P0)
        N1 = ARE(P0+1) + OS
  
        DO 20 J = 2, NH
          
          N0 = N0 + 1
          NSEG = NSEG + 1
          SEG(1,NSEG) = N1
          SEG(2,NSEG) = N0
          N1 = N0

 20       CONTINUE

          NSEG = NSEG + 1
          SEG(1,NSEG) = N1
          SEG(2,NSEG) = ARE(P0+2) + OS
          P0 = P0 + NNP + 1

 10     CONTINUE

      END
