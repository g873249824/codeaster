      SUBROUTINE MDCHIN ( NOFIMD, IDFIMD, NOCHMD, TYPENT, TYPGEO,
     &                    PREFIX, NBTV,
     &                    CODRET )
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/05/2011   AUTEUR SELLENET N.SELLENET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE SELLENET N.SELLENET
C ======================================================================
C     FORMAT MED - CHAMP - INFORMATIONS - FICHIER CONNU PAR NOM
C            --    --      -                                -
C     DONNE LE NOMBRE DE TABLEAUX DE VALEURS ET LEURS CARACTERISTIQUES
C     TEMPORELLES POUR UN CHAMP ET UN SUPPORT GEOMETRIQUE
C-----------------------------------------------------------------------
C      ENTREES:
C        NOFIMD : NOM DU FICHIER MED
C        IDFIMD : OU NUMERO DU FCHIER MED DEJA OUVERT
C        NOCHMD : NOM MED DU CHAMP A LIRE
C        TYPENT : TYPE D'ENTITE AU SENS MED
C        TYPGEO : TYPE DE SUPPORT AU SENS MED
C      ENTREES/SORTIES:
C        PREFIX : BASE DU NOM DES STRUCTURES
C                 POUR LE TABLEAU NUMERO I
C                 PREFIX//'.NUME' : T(2I-1) = NUMERO DE PAS DE TEMPS
C                                   T(2I)   = NUMERO D'ORDRE
C                 PREFIX//'.INST' : T(I) = INSTANT S'IL EXISTE
C      SORTIES:
C        NBTV   : NOMBRE DE TABLEAUX DE VALEURS DU CHAMP
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBTV
      INTEGER TYPENT, TYPGEO
      INTEGER CODRET
C
      CHARACTER*19 PREFIX
      CHARACTER*(*) NOCHMD
      CHARACTER*(*) NOFIMD
C
C 0.2. ==> VARIABLES LOCALES
C
      CHARACTER*8  SAUX08
C
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
C
      INTEGER IDFIMD
      LOGICAL DEJOUV
C====
C 1. ON OUVRE LE FICHIER EN LECTURE
C====
C
      IF ( IDFIMD.EQ.0 ) THEN
        CALL MFOUVR ( IDFIMD, NOFIMD, EDLECT, CODRET )
        DEJOUV = .FALSE.
      ELSE
        DEJOUV = .TRUE.
        CODRET = 0
      ENDIF
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFOUVR  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 2. APPEL DU PROGRAMME GENERIQUE
C====
C
      CALL MDCHII ( IDFIMD, NOCHMD, TYPENT, TYPGEO,
     &              PREFIX, NBTV,
     &              CODRET )
C
C====
C 3. FERMETURE DU FICHIER MED
C====
C
      IF ( .NOT.DEJOUV ) THEN
        CALL MFFERM ( IDFIMD, CODRET )
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFFERM  '
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
        IDFIMD = 0
      ENDIF
C
      END
