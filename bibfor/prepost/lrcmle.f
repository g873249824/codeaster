      SUBROUTINE LRCMLE ( IDFIMD, NOCHMD, NOMAMD,
     >                    NBCMFI, NBVATO, NUMPT, NUMORD,
     >                    TYPENT, TYPGEO,
     >                    NTVALE, NOMPRF,
     >                    CODRET )
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/11/2004   AUTEUR MCOURTOI M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C     LECTURE D'UN CHAMP - FORMAT MED - LECTURE
C     -    -       -              -     --
C-----------------------------------------------------------------------
C      ENTREES:
C        IDFIMD : IDENTIFIANT DU FICHIER MED
C        NOCHMD : NOM MED DU CHAMP A LIRE
C        NOMAMD : NOM MED DU MAILLAGE LIE AU CHAMP A LIRE
C        NBCMFI : NOMBRE DE COMPOSANTES DANS LE FICHIER      .
C        NBVATO : NOMBRE DE VALEURS TOTAL (VALEUR DE EFNVAL)
C        NUMPT  : NUMERO DE PAS DE TEMPS
C        NUMORD : NUMERO D'ORDRE DU CHAMP
C        TYPENT : TYPE D'ENTITE AU SENS MED
C        TYPGEO : TYPE DE SUPPORT AU SENS MED
C      SORTIES:
C        NOMPRF : NOM DU PROFIL ASSOCIE
C        NTVALE : TABLEAU QUI CONTIENT LES VALEURS LUES
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER IDFIMD
      INTEGER NBCMFI, NBVATO, NUMPT, NUMORD
      INTEGER TYPENT, TYPGEO
      INTEGER CODRET
C
      CHARACTER*32 NOCHMD, NOMAMD, NOMPRF
      CHARACTER*(*) NTVALE
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRCMLE' )
C
      INTEGER EDFUIN
      PARAMETER (EDFUIN=0)
      INTEGER EDALL
      PARAMETER (EDALL=0)
      INTEGER EDCOMP
      PARAMETER (EDCOMP=2)
C
      INTEGER IFM, NIVINF, LXLGUT
C
      INTEGER ADVALE
C
      CHARACTER*8 SAUX08
      CHARACTER*16 NELREF
C
C====
C 1. PREALABLES
C====
C
C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV ( IFM, NIVINF )
C
CGN      IF ( NIVINF.GT.1 ) THEN
CGN        WRITE (IFM,1001) 'DEBUT DE '//NOMPRO
CGN      ENDIF
CGN 1001 FORMAT(/,10('='),A,10('='),/)
C
C====
C 2. LECTURE DU CHAMP DANS UN TABLEAU TEMPORAIRE
C====
C
      CALL WKVECT ( NTVALE, 'V V R', NBCMFI*NBVATO, ADVALE )
C
C       CALL EFCHRL ( IDFIMD, NOMAMD, NOCHMD, ZR(ADVALE),
C      >              EDFUIN, EDALL, NOMPRF,
C      >              TYPENT, TYPGEO,
C      >              NUMPT,  NUMORD, CODRET )
      CALL EFCHRL ( IDFIMD, NOMAMD, NOCHMD, ZR(ADVALE),
     >              EDFUIN, EDALL,  NELREF, NOMPRF, EDCOMP,
     >              TYPENT, TYPGEO,
     >              NUMPT,  NUMORD, CODRET)
C
      IF ( CODRET.NE.0 ) THEN
        CALL CODENT ( CODRET,'G',SAUX08 )
        CALL UTMESS ('F',NOMPRO,'MED: ERREUR EFCHRL NUMERO '//SAUX08)
      ENDIF
C                     12345678901234567890123456789012 = MED_NOGAUSS
      IF ( LXLGUT(NELREF).NE.0 .AND. NIVINF.GT.1) THEN
        WRITE(IFM,*) '. CHAMP : '//NOCHMD
        WRITE(IFM,*) '. ELT REFERENCE MED : '//NELREF(1:LXLGUT(NELREF))
      ENDIF
C
CGN      IF ( NIVINF.GT.1 ) THEN
CGN        WRITE (IFM,1001) 'FIN DE '//NOMPRO
CGN      ENDIF
C
      END
