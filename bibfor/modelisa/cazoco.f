      SUBROUTINE CAZOCO(CHAR  ,NOMO  ,MOTFAC,IFORM ,IZONE ,
     &                  NZOCO )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  CHAR,NOMO
      CHARACTER*16 MOTFAC
      INTEGER      IFORM,IZONE,NZOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C LECTURE DES CARACTERISTIQUES DU CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMO   : NOM DU MODELE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'ZONE')
C IN  IFORM  : TYPE DE FORMULATION DE CONTACT
C IN  IZONE  : INDICE POUR LIRE LES DONNEES
C
C ----------------------------------------------------------------------
C
      LOGICAL      LMAIL
C
C ----------------------------------------------------------------------
C
      LMAIL  = (IFORM.EQ.1).OR.(IFORM.EQ.2)
C
C --- LECTURE DES PRINCIPALES CARACTERISTIQUES DU CONTACT
C --- CONCERNANT L'APPARIEMENT ET SES OPTIONS
C
      IF (LMAIL) THEN
        CALL CAZOCM(CHAR  ,MOTFAC,IZONE )
      ENDIF
C
C --- LECTURE PARAMETRES SPECIFIQUES SUIVANT FORMULATION
C
      IF (IFORM.EQ.1) THEN
        CALL CAZOCD(CHAR  ,MOTFAC,IZONE ,NZOCO)
      ELSEIF (IFORM.EQ.2) THEN
        CALL CAZOCC(CHAR  ,MOTFAC,IZONE )
      ELSEIF (IFORM.EQ.3) THEN
        CALL CAZOCX(CHAR  ,NOMO  ,MOTFAC,IZONE )
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END
