      SUBROUTINE RECIRE ( TYPOPT, IDERRE, FREXCI, 
     &                    FREMIN, FREMAX, PAS, NBPTMD )
      IMPLICIT   NONE
      INTEGER             IDERRE, NBPTMD
      REAL*8              FREMIN, FREMAX, PAS
      CHARACTER*4         TYPOPT, FREXCI
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/12/97   AUTEUR CIBHHLV L.VIVAN 
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
C
C  BUT: RECUPERER LES INFORMATIONS DU MOT CLE FACTEUR REPONSE POUR
C        LE CALCUL DYNAMIQUE ALEATOIRE
C         
C OUT : TYPOPT : OPTION 'DIAG' OU 'TOUT'
C OUT : IDERRE : ORDRE DE DERIVATION
C OUT : FREXCI : FREQUENCE DE L EXCITATION: AVEC OU SANS
C OUT : FREMIN : FREQ MIN DE LA DISCRETISATION
C OUT : FREMAX : FREQ MAX DE LA DISCRETISATION
C OUT : PAS    : PAS DE LA DISCRETISATION
C OUT : NBPTMD : NOMBRE DE POINTS PAR MODES
C
C-----------------------------------------------------------------------
      INTEGER       IBID, NBOCC
C-----------------------------------------------------------------------
C
      TYPOPT = 'TOUT'
      IDERRE = 0
      FREXCI = 'AVEC'
      FREMIN = -1.D0
      FREMAX = -1.D0
      PAS    = -1.D0
      NBPTMD = 50
C 
      CALL GETFAC ( 'REPONSE', NBOCC )
C
      IF ( NBOCC .NE. 0 ) THEN
C 
C----TYPE DE REPONSE ET RELATIF/ABSOLU ET MONO/INTER
C
         CALL GETVTX ( 'REPONSE', 'OPTION'    , 1,1,1, TYPOPT, IBID )
         CALL GETVIS ( 'REPONSE', 'DERIVATION', 1,1,1, IDERRE, IBID )
C
C----INCLUSION DES FREQUENCES DEXCITATION DANS LA DISCRETISATION REPONSE
C
         CALL GETVTX ( 'REPONSE', 'FREQ_EXCIT', 1,1,1, FREXCI, IBID )
C-
C----FREQUENCE INITIALE
C
         CALL GETVR8 ( 'REPONSE', 'FREQ_MIN', 1,1,1, FREMIN, IBID )
         IF ( IBID .NE. 0 )  FREXCI = 'SANS'
C
C----FREQUENCE FINALE
C
         CALL GETVR8 ( 'REPONSE', 'FREQ_MAX', 1,1,1, FREMAX, IBID )
C
C----PAS DE LA DISCRETISATION
C
         CALL GETVR8 ( 'REPONSE', 'PAS', 1,1,1, PAS, IBID )
C
C----NOMBRE DE POINTS PAR MODES
C
         CALL GETVIS ( 'REPONSE', 'NB_POIN_MODE', 1,1,1, NBPTMD, IBID )
C
      ENDIF
C
      END
