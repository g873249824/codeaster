      SUBROUTINE NOMGFA ( NOGR, NBGR, DGF, NOGRF, NBGF )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 19/06/2000   AUTEUR DURAND C.DURAND 
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
C  ENTREES :
C     NOGR   = NOMS   DES GROUPES D ENTITES
C     NBGR   = NOMBRE DE  GROUPES
C     DGF    = DESCRIPTEUR-GROUPE DE LA FAMILLE (VECTEUR ENTIERS)
C  SORTIES :
C     NOGRF  = NOMS + NUMEROS DES GROUPES D ENTITES DE LA FAMILLE
C     NBGF   = NOMBRE DE  GROUPES DE LA FAMILLE
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBGF, NBGR
      INTEGER DGF(*)
      CHARACTER*80 NOGRF(*)
      CHARACTER*8  NOGR(NBGF)
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*72 SAUX72
      INTEGER IAUX
      LOGICAL EXIGFA
C
C     ------------------------------------------------------------------
C
C               123456789012345678901234567890123456
      SAUX72 = '                                    '//
     >         '                                    '
C
      NBGF = 0
      DO 10 , IAUX = 1,NBGR
        IF ( EXIGFA(DGF,IAUX) ) THEN
          NBGF = NBGF + 1
          NOGRF(NBGF)(1:8) = NOGR(IAUX)
          NOGRF(NBGF)(9:80) = SAUX72
        ENDIF
  10  CONTINUE
C
      END
