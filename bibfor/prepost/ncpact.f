      SUBROUTINE NCPACT(DG,NEC,NBC)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C
      INTEGER DG(*),NEC,NBC
C
C**********************************************************************
C
C     NBC := NBR DE COMPOSSANTES REPRESENTANT LA GRANDEUR DE
C            DESCRIPTEUR DG ( TAILLE = NEC)
C
C**********************************************************************
C
      INTEGER I,COMPT
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      NBC   = 0
      COMPT = 0
C
      DO 10, I = 1, NEC, 1
C
         CALL NBBIT1(DG(I),COMPT)
C
         NBC = NBC + COMPT
C
10    CONTINUE
C
      END
