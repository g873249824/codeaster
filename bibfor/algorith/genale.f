      SUBROUTINE GENALE(VEC1,VEC2,R,V,X,DIM,LONG,LONV,LN)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C ----------------------------------------------------------------------
C     IN  : VEC1  : VECTEUR DES VALEURS DE LA MATRICE INTERSPECTRALE
C     OUT : VEC2  : VALEURS DES FONCTIONS GENEREES POUR UN TIRAGE
C           R     : MATRICE DE TRAVAIL (MATR. INTERSP. POUR UNE FREQ.)
C           V     : VECTEUR DE TRAVAIL (VALEURS DES FONCTIONS GENEREES)
C           X     : VECTEUR DE TRAVAIL (BRUIT BLANC)
C                               V(FREQ) = R(FREQ) * X(FREQ)
C           DIM   : DIMENSION DE LA MATRICE DE TRAVAIL
C           LN    : NOMBRE DE POINTS DE LA DISCRETISATION
C           NALEA : NOMBRE ALEATOIRE POUR INITIALISER LE GENERATEUR
      INCLUDE 'jeveux.h'
      INTEGER          DIM
      REAL*8           VEC1(LONG),VEC2(LONV)
      COMPLEX*16       R(DIM,DIM),V(DIM),X(DIM)
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,ICOMP ,IX ,IY ,J ,KF ,KK 
      INTEGER LN ,LN2 ,LONG ,LONV 
C-----------------------------------------------------------------------
      LN2=LN*2
      DO 10 KF=1,LN
        ICOMP = 0
        DO 20 J=1,DIM
          DO 30 I=1,DIM
            ICOMP = ICOMP+1
            IX = LN + KF + (ICOMP-1)*LN2
            IY = IX + LN
            R(I,J) = DCMPLX(VEC1(IX),VEC1(IY))
   30     CONTINUE
   20   CONTINUE
C
        CALL GENERE(R,DIM,V,X)
C
        DO 40 KK=1,DIM
          IX = KF   + (KK-1)*LN2
          IY = IX + LN
          VEC2(IX) = DBLE(V(KK))
          VEC2(IY) = DIMAG(V(KK))
   40   CONTINUE
   10 CONTINUE
      END
