      SUBROUTINE ADDC00 ( MESSAG, NBMCLF, MCLF,
     >                    NBOPT, TABENT, TABREE, TABCAR, LGCAR,
     >                    CODRET )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/10/2001   AUTEUR GNICOLAS G.NICOLAS 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C     ------------------------------------------------------------------
C      ADAPTATION - DECODAGE DES COMMANDES - PHASE 00
C      --           -            -                 --
C     ------------------------------------------------------------------
C    ELLES SONT EN PARTIE COMMUNES A LA COMMANDE ET A LA MACRO-COMMANDE
C     ENTREES :
C        MESSAG : MESSAGE POUR UTMESS
C        NBMCLF : NOMBRE DE MOTS-CLES FACTEURS A TRAITER
C        MCLF   : LISTE DES MOTS-CLES FACTEURS
C                 1 : TYPE DE TRAITEMENT
C                 2 : MISE A JOUR DE SOLUTION
C        NBOPT  : TAILLE DES TABLEAUX DE STOCKAGE DES OPTIONS
C        TABXXX : TABLEAU DE STOCKAGE DES OPTIONS
C     SORTIES:
C       CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C     ------------------------------------------------------------------
C
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBOPT, NBMCLF
      INTEGER TABENT(NBOPT), LGCAR(NBOPT)
      INTEGER CODRET
C
      REAL*8 TABREE(NBOPT)
C
      CHARACTER*16 MESSAG, MCLF(NBMCLF)
      CHARACTER*(*) TABCAR(NBOPT)
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'ADDC00' )
C
      INTEGER LXLGUT
C
      INTEGER IAUX
      INTEGER IFM, NIVINF
      INTEGER MODHOM, TYPRAF, TYPDER
      INTEGER TYPCRR, TYPCRD
      INTEGER NIVMIN, NIVMAX
      INTEGER LNCPIN
      INTEGER LLANGU
C
      REAL*8 CRITDE, CRITRA
C
      CHARACTER*8 NCPIN
      CHARACTER*128 LANGUE
C
C====
C 1. PREALABLE
C====
C
C 1.1. ==> ENTIERS
C
      MODHOM = TABENT(2)
      TYPRAF = TABENT(6)
      TYPDER = TABENT(7)
      IFM    = TABENT(29)
      NIVINF = TABENT(30)
C
C====
C 2. ON MET -1 PAR DEFAUT, POUR SAVOIR QU'IL NE FAUDRA DONNER AUCUNE
C    VALEUR A HOMARD
C    ON INITIALISE LES VARIABLES REELLES POUR LA BEAUTE DE L'ART
C====
C
      TYPCRR = -1
      TYPCRD = -1
      NIVMAX = -1
      NIVMIN = -1
      LNCPIN = 0
C
      CRITRA = 0.D0
      CRITDE = 0.D0
C
C====
C 3. SI ADAPTATION LIBRE, LES CRITERES
C====
C
      IF ( MODHOM.EQ.1 ) THEN
C
C 3.1. ==> CRITERE POUR LE RAFFINEMENT
C
      IF ( TYPRAF.EQ.1 ) THEN
C
        CALL GETVR8 ( MCLF(1), 'CRIT_RAFF_ABS', 1,1,1, CRITRA, IAUX)
C
        IF ( IAUX.EQ.0 ) THEN
          CALL GETVR8 ( MCLF(1), 'CRIT_RAFF_REL', 1,1,1, CRITRA, IAUX)
C
          IF ( IAUX.EQ.0 ) THEN
            CALL GETVR8 ( MCLF(1), 'CRIT_RAFF_PE', 1,1,1, CRITRA, IAUX)
C
            IF ( IAUX.EQ.0 ) THEN
              CALL UTMESS ( 'E', NOMPRO,
     >                     MESSAG//'IL FAUT LE CRITERE DE RAFFINEMENT')
              CODRET = CODRET + 1
            ELSE
              TYPCRR = 3
            ENDIF
          ELSE
            TYPCRR = 2
          ENDIF
C
        ELSE
          TYPCRR = 1
        ENDIF
C
      ENDIF
C
C 3.2. ==> CRITERE POUR LE DERAFFINEMENT
C
      IF ( TYPDER.EQ.1 ) THEN
C
        CALL GETVR8 ( MCLF(1), 'CRIT_DERA_ABS', 1,1,1, CRITDE, IAUX)
C
        IF ( IAUX.EQ.0 ) THEN
          CALL GETVR8 ( MCLF(1), 'CRIT_DERA_REL', 1,1,1, CRITDE, IAUX)
C
          IF ( IAUX.EQ.0 ) THEN
            CALL GETVR8 ( MCLF(1), 'CRIT_DERA_PE', 1,1,1, CRITDE, IAUX)
C
            IF ( IAUX.EQ.0 ) THEN
              CALL UTMESS ( 'E', NOMPRO,
     >                   MESSAG//'IL FAUT LE CRITERE DE DERAFFINEMENT' )
              CODRET = CODRET + 1
            ELSE
              TYPCRD = 3
            ENDIF
C
          ELSE
            TYPCRD = 2
          ENDIF
C
        ELSE
          TYPCRD = 1
        ENDIF
C
      ENDIF
C
      ENDIF
C
C====
C 4. SI ADAPTATION, LES NIVEAUX EXTREMES
C====
C
      IF ( MODHOM.EQ.1 ) THEN
C
C 4.1. ==> NIVEAU MAXIMUM POUR LE RAFFINEMENT
C
      IF ( TYPRAF.EQ.1 .OR. TYPRAF.EQ.2 ) THEN
C
        CALL GETVIS ( MCLF(1), 'NIVE_MAX', 1,1,1, NIVMAX, IAUX )
C
        IF ( IAUX.NE.0 ) THEN
          IF ( NIVMAX.LE.0 ) THEN
            CALL UTMESS ( 'E', NOMPRO,
     >      MESSAG//'LE NIVEAU MAXIMUM DOIT ETRE STRICTEMENT POSITIF.' )
            CODRET = CODRET + 1
          ENDIF
        ENDIF
C
      ENDIF
C
C 4.2. ==> NIVEAU MINIMUM POUR LE DERAFFINEMENT
C
      IF ( TYPDER.EQ.1 .OR. TYPDER.EQ.2 ) THEN
C
        CALL GETVIS ( MCLF(1), 'NIVE_MIN', 1,1,1, NIVMIN, IAUX )
C
        IF ( IAUX.NE.0 ) THEN
          IF ( NIVMIN.LT.0 ) THEN
            CALL UTMESS ( 'E', NOMPRO,
     >      MESSAG//'LE NIVEAU MINIMUM DOIT ETRE POSITIF.' )
            CODRET = CODRET + 1
          ENDIF
        ENDIF
C
      ENDIF
C
C 4.3. ==> COHERENCE
C
      IF ( TYPRAF.NE.0 .AND. TYPDER.NE.0 ) THEN
C
        IF ( NIVMAX.LT.NIVMIN ) THEN
          CALL UTMESS ( 'E', NOMPRO,
     >    MESSAG//'LE NIVEAU MAXIMUM DOIT ETRE > AU NIVEAU MINIMUM.')
          CODRET = CODRET + 1
        ENDIF
C
      ENDIF
C
      ENDIF
C
C====
C 5. SI ADAPTATION LIBRE, LA COMPOSANTE DE L'INDICATEUR
C====
C
      IF ( MODHOM.EQ.1 ) THEN
C
      IF ( TYPRAF.EQ.1 .OR. TYPDER.EQ.1 ) THEN
C
        CALL GETVTX ( MCLF(1), 'NOM_CMP_INDICA' , 1,1,1, NCPIN, IAUX )
C
        LNCPIN = LXLGUT(NCPIN)
C
      ENDIF
C
      ENDIF
C
C====
C 6. LANGUE DES MESSAGES DE HOMARD
C====
C
      CALL GETVTX ( ' ', 'LANGUE', 1,1,1, LANGUE, IAUX )
      LLANGU = LXLGUT(LANGUE)
C
C====
C 7. STOCKAGE DES ARGUMENTS
C====
C
      IF ( NIVINF.GE.2 ) THEN
        WRITE(IFM,*) 'DANS ',NOMPRO,' :'
        WRITE(IFM,*) 'MODHOM = ', MODHOM
        WRITE(IFM,*) 'TYPCRR = ', TYPCRR
        WRITE(IFM,*) 'TYPCRD = ', TYPCRD
        WRITE(IFM,*) 'CRITRA = ', CRITRA
        WRITE(IFM,*) 'CRITDE = ', CRITDE
        WRITE(IFM,*) 'LNCPIN = ', LNCPIN
        IF ( LNCPIN.GT.0 ) THEN
          WRITE(IFM,*) 'NCPIN  = ', NCPIN(1:LNCPIN)
        ENDIF
      ENDIF
C
C 7.1. ==> ENTIERS
C
      TABENT(9) = TYPCRR
      TABENT(10) = TYPCRD
      TABENT(11) = NIVMAX
      TABENT(12) = NIVMIN
C
C 7.2. ==> CARACTERES
C
      LGCAR(6) = LNCPIN
      IF ( LNCPIN.GT.0 ) THEN
        TABCAR(6)(1:LNCPIN) = NCPIN(1:LNCPIN)
      ENDIF
C
      LGCAR(38) = LLANGU
      IF ( LLANGU.GT.0 ) THEN
        TABCAR(38)(1:LLANGU) = LANGUE(1:LLANGU)
      ENDIF
C
C 7.3. ==> REELS
C
      TABREE(1) = CRITRA
      TABREE(2) = CRITDE
C
      END
