      SUBROUTINE COPCVN(NB,VEC1,VEC2,INDIR,FACT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/01/98   AUTEUR CIBHHLB L.BOURHRARA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT:  COPIER UN VECTEUR DE REELS DANS UN AUTRE EN LE MULTIPLIANT
C   PAR UN FACTEUR AVEC UNE INDIRECTION ENTRE LES ADRESSES DES DEUX
C        VECTEURS
C
C-----------------------------------------------------------------------
C
C NB       /I/: NOMBRE REELS A COPIER
C IVEC1    /I/: VECTEUR A COPIER
C IVEC2    /O/: VECTEUR RESULTAT
C INDIR    /I/: VECTEUR DES INDIRECTIONS DE RANG
C FACT     /I/: FACTEUR
C
C-----------------------------------------------------------------------
C
      REAL*8 VEC1(*),VEC2(NB)
      INTEGER INDIR(NB)
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      IF(NB.EQ.0) GOTO 9999
C
      DO 10 I=1,NB
        IF(INDIR(I).GT.0) THEN
          VEC2(I)=VEC1(INDIR(I))*FACT
        ELSE
          VEC2(I)=0.D0
        ENDIF
 10   CONTINUE
C
 9999 CONTINUE
      END
