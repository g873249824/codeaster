      FUNCTION ARLCOL(VEC1,N1,VEC2,N2,LVEC)
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
C      TESTE L'INCLUSION D'UN VECTEUR D'ENTIERS TRIES DANS UN AUTRE
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE
C INTEGER   VEC1(N1)    : VECTEUR D'ENTIERS TRIES PAR ORDRE CROISSANT
C INTEGER   N1          : NOMBRE D'ELEMENTS DE VEC1
C INTEGER   VEC2(N2)    : VECTEUR D'ENTIERS TRIES PAR ORDRE CROISSANT
C INTEGER   N2          : NOMBRE D'ELEMENTS DE VEC2
C
C VARIABLE DE SORTIE
C LOGICAL   LVEC(N2)    : .TRUE. SI VEC2(I) SE TROUVE DANS VEC1
C                         .FALSE. SINON
C
C RESULTAT FONCTION
C LOGICAL   ARLCOL      : .TRUE. SI VEC1 INCLUS DANS VEC2
C                         .FALSE. SINON
C ----------------------------------------------------------------------

      IMPLICIT NONE

C --- VARIABLES
      LOGICAL ARLCOL,LVEC(*)
      INTEGER N1,N2,VEC1(*),VEC2(*),V1,V2,I1,I2

      ARLCOL = .FALSE.
      IF ((N1.LE.0).OR.(N2.LE.0).OR.(N1.GT.N2)) GOTO 30

      I1 = 0
      I2 = 0

C --- V1 .EQ. V2

 10   CONTINUE

        I1 = I1 + 1
        I2 = I2 + 1

        IF (I1.GT.N1) THEN
          ARLCOL = .TRUE.
          GOTO 30
        ENDIF

        IF (I2.GT.N2) GOTO 30

        V1 = VEC1(I1)
        V2 = VEC2(I2)

        IF (V1.EQ.V2) THEN 
          LVEC(I2) = .TRUE. 
          GOTO 10
        ENDIF

        IF (V1.LT.V2) GOTO 30

C --- V2 .LT. V1

 20   CONTINUE

        LVEC(I2) = .FALSE.

        I2 = I2 + 1
        IF (I2.GT.N2) GOTO 30

        V2 = VEC2(I2)
        IF (V2.LT.V1) GOTO 20

        IF (V2.EQ.V1) THEN
          LVEC(I2) = .TRUE.
          GOTO 10
        ENDIF

 30   CONTINUE

      IF (.NOT.ARLCOL) THEN
        DO 40 I2 = 1, N2
          LVEC(I2) = .FALSE.
 40     CONTINUE
      ENDIF

      END
