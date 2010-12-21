      SUBROUTINE XMVEC0(NDIM  ,JNNE   ,NNC   ,NFAES ,
     &                  DLAGRC,HPG   ,FFC   ,JACOBI,CFACE ,
     &                  JPCAI ,COEFCA,TYPMAI,JDDLE,NCONTA,VTMP)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/12/2010   AUTEUR MASSIN P.MASSIN 
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
C
      IMPLICIT NONE
      INTEGER  NDIM,JNNE(3),NNC,NFAES,CFACE(3,5),JPCAI,JDDLE(2),NCONTA
      REAL*8   DLAGRC,HPG,FFC(8),JACOBI,COEFCA
      REAL*8   VTMP(168)
      CHARACTER*8  TYPMAI
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
C
C VECTEUR SECOND MEMBRE SI PAS DE CONTACT (XFEM)
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  DLAGRC : LAGRANGE DE CONTACT AU POINT D'INTéGRATION
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFC    : FONCTIONS DE FORME DU POINT DE CONTACT
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  COEFCA : COEF_REGU_CONT
C IN  COEFFS : COEF_STAB_CONT
C IN  COEFFP : COEF_PENA_CONT
C IN  DDLES  : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C I/O VTMP   : VECTEUR SECOND MEMBRE ELEMENTAIRE DE CONTACT/FROTTEMENT
C ----------------------------------------------------------------------
C
      INTEGER I,IN,PL,XOULA,NNE,NNES,DDLES
C
C ----------------------------------------------------------------------
C
C --------------------- CALCUL DE [C]-----------------------------------
C
      NNE=JNNE(1)
      NNES=JNNE(2)
      DDLES=JDDLE(1)
C
      DO 10 I = 1,NNC
        IN=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI,NCONTA)
        CALL XPLMA2(NDIM,NNE,NNES,DDLES,IN,PL)
        VTMP(PL) = -HPG*JACOBI*DLAGRC*FFC(I)/COEFCA
   10 CONTINUE
C
      END
