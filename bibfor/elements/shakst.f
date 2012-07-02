      SUBROUTINE SHAKST(KSTAB,K11,K22,K33,K12,K21,K13,K23,K31,K32)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C--------------------------------------------------------
C ELEMENT SHB8-PS A.COMBESCURE, S.BAGUET INSA LYON 2003 /
C-------------------------------------------------------
      IMPLICIT NONE
      REAL*8 KSTAB(24,24),K11(8,8),K22(8,8),K33(8,8),K12(8,8)
      REAL*8 K21(8,8),K13(8,8),K23(8,8),K31(8,8),K32(8,8)
      INTEGER I,J
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C ASSEMBLAGE DE LA MATRICE DE STABILISATION
C AVEC LES 3 MATRICES 8*8 K11 K22 ET K33

C      CALL ZDANUL(KSTAB,576)
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL R8INIR(576,0.D0,KSTAB,1)
      DO 20 I = 1,8
        DO 10 J = 1,8
          KSTAB(I,J) = K11(I,J)
   10   CONTINUE
   20 CONTINUE
      DO 40 I = 9,16
        DO 30 J = 9,16
          KSTAB(I,J) = K22(I-8,J-8)
   30   CONTINUE
   40 CONTINUE
      DO 60 I = 17,24
        DO 50 J = 17,24
          KSTAB(I,J) = K33(I-16,J-16)
   50   CONTINUE
   60 CONTINUE
      DO 80 I = 1,8
        DO 70 J = 9,16
          KSTAB(I,J) = K12(I,J-8)
   70   CONTINUE
   80 CONTINUE
      DO 100 I = 9,16
        DO 90 J = 1,8
          KSTAB(I,J) = K21(I-8,J)
   90   CONTINUE
  100 CONTINUE
      DO 120 I = 1,8
        DO 110 J = 17,24
          KSTAB(I,J) = K13(I,J-16)
  110   CONTINUE
  120 CONTINUE
      DO 140 I = 9,16
        DO 130 J = 17,24
          KSTAB(I,J) = K23(I-8,J-16)
  130   CONTINUE
  140 CONTINUE
      DO 160 I = 17,24
        DO 150 J = 1,8
          KSTAB(I,J) = K31(I-16,J)
  150   CONTINUE
  160 CONTINUE
      DO 180 I = 17,24
        DO 170 J = 9,16
          KSTAB(I,J) = K32(I-16,J-8)
  170   CONTINUE
  180 CONTINUE
      END
