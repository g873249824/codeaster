      SUBROUTINE CHLICI(CHAINE,LONG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PELLET J.PELLET
C TOLE CRP_6
      IMPLICIT NONE
      CHARACTER*(*) CHAINE
      INTEGER LONG
C ----------------------------------------------------------------------
C BUT : VERIFIER QU'UNE CHAINE DE CARACTERES NE CONTIENT QUE
C       DES CARACTERES AUTORISES PAR JEVEUX : (A-Z)(a-z)(0-9)
C       PLUS : PERLUETTE, BLANC, BLANC SOULIGNE ET POINT
C       ON VERIFIE LA CHAINE SUR UNE LONGUEUR : LONG
C       SI CARACTERE ILLICITE : ERREUR FATALE <F>

C IN  CHAINE    : CHAINE A VERIFIER
C IN  LONG      : LA CHAINE EST VERIFIEE DE (1:LONG)
C ----------------------------------------------------------------------
      INTEGER I ,K
C-----------------------------------------------------------------------

      DO 10,I = 1,LONG
        K = ICHAR(CHAINE(I:I))
        CALL ASSERT(( (K.EQ.32).OR.
     &                (K.EQ.46).OR.
     &                (K.EQ.38).OR.
     &                (K.EQ.95).OR.
     &               ((K.GE.48).AND. (K.LE.57)).OR.
     &               ((K.GE.65).AND. (K.LE.90)).OR.
     &               ((K.GE.97).AND. (K.LE.122))    ))
   10 CONTINUE
      END
