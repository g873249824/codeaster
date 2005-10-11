      SUBROUTINE  PJ6DA2(INO2,GEOM2,I,GEOM1,SEG2,COBARY,D2,LONG)
      IMPLICIT NONE
      REAL*8  COBARY(2),GEOM1(*),GEOM2(*),D2,LONG
      INTEGER INO2,I,SEG2(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/10/2005   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE VABHHTS J.PELLET
C ======================================================================
C     BUT :
C       DETERMINER LA DISTANCE D ENTRE LE NOEUD INO2 ET LE SEG2 I.
C       DETERMINER LES COORDONNEES BARYCENTRIQUES
C       DU POINT DE I LE PLUS PROCHE DE INO2.
C
C  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
C  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN   I          I  : NUMERO DU SEG2 CANDIDAT
C  IN   SEG2(*)    I  : OBJET '&&PJXXCO.SEG2'
C  OUT  COBARY(2)  R  : COORDONNEES BARYCENTRIQUES DE INO2 PROJETE SUR I
C  OUT  D2         R  : CARRE DE LA DISTANCE ENTRE I ET INO2
C  OUT  LONG       R  : LONGUEUR DU SEG2 I


C ----------------------------------------------------------------------
      INTEGER K
      REAL*8 R8MAEM ,DP,L1,L2,LA,LB
      REAL*8 A(3),B(3),M(3),AB(3)
C DEB ------------------------------------------------------------------

      DO 1,K=1,3
        M(K)=GEOM2(3*(INO2-1)+K)
        A(K)=GEOM1(3*(SEG2(1+3*(I-1)+1)-1)+K)
        B(K)=GEOM1(3*(SEG2(1+3*(I-1)+2)-1)+K)
        AB(K)=B(K)-A(K)
1     CONTINUE

      D2=R8MAEM()
      DP=R8MAEM()


C     1. ON CHERCHE LE POINT LE PLUS PROCHE DE AB :
C     -------------------------------------------------------------
      CALL  PJ3DA4(M,A,B,L1,L2,DP)
      IF (DP.LT.D2) THEN
        D2=DP
        LA=L1
        LB=L2
      END IF


C     2. ON CALCULE LONG :
C     --------------------
      LONG=SQRT(AB(1)**2+AB(2)**2+AB(3)**2)

      COBARY(1)=LA
      COBARY(2)=LB

      END
