      SUBROUTINE VPVOPT( OPTION, TYPRES, NBFREQ , FREQ, IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)      OPTION
      REAL*8                              FREQ(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C     CONTROLE DE VALIDITE DE L'OPTION SUR LES FREQUENCES
C     ------------------------------------------------------------------
      CHARACTER*16   LOPTFR(3), OPTIOM, TYPRES
      DATA  LOPTFR / 'CENTRE ', 'BANDE   ', 'PLUS_PETITE' /
C     ------------------------------------------------------------------
C IN  OPTION   : K : NOM DE L'OPTION
C              = 'PLUS_PETITE'    (ITERATION SIMULTANEE EN SOUS-ESPACE)
C              = 'CENTRE'         (ITERATION SIMULTANEE EN SOUS-ESPACE)
C              = 'BANDE'          (ITERATION SIMULTANEE EN SOUS-ESPACE)
C IN  TYPRES   : K : TYPE DE CALUCL EFFECTUE : DYNAMIQUE OU FLAMBEMENT
C IN  NBFREQ   : I : NOMBRE DE FREQUENCES DEFINIES DANS LA LISTE FREQ
C IN  FREQ     : R : LISTE DES FREQUENCES FOURNIES EN ENTREE
C OUT IER      : R : CODE RETOUR
C     ------------------------------------------------------------------
      IER=0
      CALL UTREMT( OPTION , LOPTFR , 3 , IRET )
      IF ( IRET .EQ. 0 ) THEN
         OPTIOM = OPTION
         IER = IER + 1
         CALL UTMESS('E','VPVOPT',
     +                   '"'//OPTIOM//'"  ARGUMENT DU MOT CLE "OPTION"'
     +                //' POUR LE CALCUL DES FREQUENCES EST INVALIDE.')
      ELSE
         IF (TYPRES.EQ.'DYNAMIQUE') THEN 
         
         IF ( OPTION .EQ. 'BANDE') THEN
            IF ( NBFREQ.NE.2 ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT',
     +              'POUR L''OPTION  "BANDE" IL FAUT '//
     +              'EXACTEMENT 2 FREQUENCES.')
             ELSEIF ( FREQ(1).GE. FREQ(2) ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT','FREQUENCE MIN. PLUS GRANDE '//
     +                  'OU EGALE A LA FREQUENCE MAX.')
             ENDIF
         ELSEIF ( OPTION .EQ. 'CENTRE' ) THEN
            IF ( NBFREQ.NE.1 ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT',
     +                         'POUR L''OPTION  "CENTRE" IL FAUT '//
     +                                       'EXACTEMENT 1 FREQUENCE.')
            ENDIF
         ELSEIF ( OPTION .EQ. 'PLUS_PETITE') THEN
            IF ( NBFREQ.NE.0 ) THEN
               CALL UTMESS('I','VPVOPT',
     +                         'POUR L''OPTION  "PLUS_PETITE" LES FRE'//
     +                         'QUENCES DE "FREQ" SONT IGNOREES.')
            ENDIF
         ENDIF
         
         ELSE
         
         IF ( OPTION .EQ. 'BANDE') THEN
            IF ( NBFREQ.NE.2 ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT',
     +              'POUR L''OPTION  "BANDE" IL FAUT '//
     +              'EXACTEMENT 2 CHARGES CRITIQUES.')
             ELSEIF ( FREQ(1).GE. FREQ(2) ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT','CHARGE CRIT. MIN. PLUS  '//
     +                  'GRANDE OU EGALE A LA CHARGE CRIT. MAX.')
             ENDIF
         ELSEIF ( OPTION .EQ. 'CENTRE' ) THEN
            IF ( NBFREQ.NE.1 ) THEN
               IER = IER + 1
               CALL UTMESS('E','VPVOPT',
     +                         'POUR L''OPTION  "CENTRE" IL FAUT '//
     +                         'EXACTEMENT 1 CHARGE CRITIQUE.')
            ENDIF
         ELSEIF ( OPTION .EQ. 'PLUS_PETITE') THEN
            IF ( NBFREQ.NE.0 ) THEN
               CALL UTMESS('I','VPVOPT',
     +             'POUR L''OPTION  "PLUS_PETITE" LES '//
     +             'CHARGES CRITIQUES DE "CHAR_CRIT" SONT IGNOREES.')
            ENDIF
         ENDIF
         
         ENDIF
      ENDIF
      END
