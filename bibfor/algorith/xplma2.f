      SUBROUTINE       XPLMA2(NDIM,NNE,NNES,NDLS,N,PL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
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
C
      IMPLICIT NONE
      INTEGER          NDIM,NNE,NNES,N,PL,NDLS
C
C ----------------------------------------------------------------------
C
C    CADRE :  CALCULE LA PLACE DU LAMBDA(N) NORMAL DANS LA MATRICE
C             ET LE SECOND MEMBRE DE CONTACT 
C
C----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  NDIM    : DIMENSION
C IN  DNE     : NOMBRE TOTAL DE NOEUDS ESCLAVES
C IN  NNES    : NOMBRE DE NOEUDS ESCLAVES SOMMETS
C IN  NDLS    : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C IN  N       : NUM�RO DU NOEUD PORTANT LE LAMBDA
C
C OUT PL      : PLACE DU LAMBDA DANS LA MATRICE  
C      
C ----------------------------------------------------------------------
C
      CALL ASSERT(N.LE.NNE)
C
      IF (N.LE.NNES) THEN
        PL= NDLS*N - NDIM + 1
      ELSE
        PL=NNES*3*NDIM+NDIM*(N-NNES-1)+1
      ENDIF
C
      END
