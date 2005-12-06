      SUBROUTINE CBROTA(CHAR,NOMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C     BUT: TRAITE LE MOT_CLE : ROTATION
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DE LA CHARGE
C      NOMA   : NOM DU MAILLAGE
C
      REAL*8 ROTA(7),NORME,R8MIEM
      CHARACTER*8 CHAR,NOMA
      ZERO    = 0.0D0
      ROTA(5) = ZERO
      ROTA(6) = ZERO
      ROTA(7) = ZERO
      CALL GETVR8 (' ', 'ROTATION', 0, 1, 0, R8BID, NBVAL)
      NBVAL = -NBVAL
      IF (NBVAL.NE.0) THEN
      CALL GETVR8 (' ', 'ROTATION', 0, 1, NBVAL, ROTA, NROTA)
         NORME=SQRT( ROTA(2)*ROTA(2)+ROTA(3)*ROTA(3)+ROTA(4)*ROTA(4) )
         IF (NORME.GT.R8MIEM()) THEN
            ROTA(2)=ROTA(2)/NORME
            ROTA(3)=ROTA(3)/NORME
            ROTA(4)=ROTA(4)/NORME
         ELSE
            CALL UTMESS('F','ROTATION ','DONNER UN VECTEUR NON NUL')
         END IF
         CALL CAROTA(CHAR,NOMA,ROTA)
      END IF
      END
