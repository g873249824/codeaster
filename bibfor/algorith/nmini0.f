      SUBROUTINE NMINI0(ZPMET ,ZPCRI ,ZCONV ,ZPCON ,ZNMETH,
     &                  FONACT,PARMET,PARCRI,CONV  ,PARCON,
     &                  METHOD,ETA   ,NUMINS,MATASS,ZMEELM,
     &                  ZMEASS,ZVEELM,ZVEASS,ZSOLAL,ZVALIN,
     &                  SDIMPR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER      ZPMET ,ZPCRI ,ZCONV
      INTEGER      ZPCON ,ZNMETH
      INTEGER      FONACT(*)
      REAL*8       PARMET(ZPMET),PARCRI(ZPCRI),CONV(ZCONV)
      REAL*8       PARCON(ZPCON)
      CHARACTER*16 METHOD(ZNMETH)
      CHARACTER*19 MATASS
      CHARACTER*24 SDIMPR
      INTEGER      NUMINS
      REAL*8       ETA
      INTEGER      ZMEELM,ZMEASS,ZVEELM,ZVEASS,ZSOLAL,ZVALIN
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATIONS)
C
C PREMIERES INITIALISATIONS DE MECA_NON_LINE: MISES A ZERO
C
C ----------------------------------------------------------------------
C
C IN  SDIMPR : SD AFFICHAGE
C
C
C
C
      REAL*8       ZERO
      PARAMETER    (ZERO=0.D0)
      REAL*8       R8VIDE
      INTEGER      I,LONG
C
C ----------------------------------------------------------------------
C
C
C --- FONCTIONNALITES ACTIVEES               (NMFONC/ISFONC)
C
      DO 2 I=1,100
        FONACT(I) = 0
  2   CONTINUE
C
C --- PARAMETRES DES METHODES DE RESOLUTION  (NMDOMT)
C
      DO 3 I=1,ZPMET
        PARMET(I) = ZERO
  3   CONTINUE
C
C --- PARAMETRES DES CRITERES DE CONVERGENCE (NMLECT)
C
      DO 4 I=1,ZPCRI
        PARCRI(I) = ZERO
  4   CONTINUE
C
C --- INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C
      DO 5 I=1,ZCONV
        CONV  (I) = R8VIDE()
  5   CONTINUE
      CONV(3)  = -1
      CONV(10) = -1
C
C --- PARAMETRES DU CRITERE DE CONVERGENCE EN CONTRAINTE (NMLECT)
C
      DO 7 I=1,ZPCON
        PARCON(I) = ZERO
  7   CONTINUE
C
C --- METHODES DE RESOLUTION
C
      DO 8 I=1,ZNMETH
        METHOD(I) = ' '
  8   CONTINUE
C
C --- INITIALISATION BOUCLE EN TEMPS
C
      NUMINS = 0
      ETA    = 0.D0
      MATASS = '&&OP0070.MATASS'
C
C --- VERIF. LONGUEURS VARIABLES CHAPEAUX (SYNCHRO OP0070/NMCHAI)
C
      CALL NMCHAI('MEELEM','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZMEELM)
      CALL NMCHAI('MEASSE','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZMEASS)
      CALL NMCHAI('VEELEM','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZVEELM)
      CALL NMCHAI('VEASSE','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZVEASS)
      CALL NMCHAI('SOLALG','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZSOLAL)
      CALL NMCHAI('VALINC','LONMAX',LONG  )
      CALL ASSERT(LONG.EQ.ZVALIN)
C
C --- CREATION SD AFFICHAGE
C
      CALL OBCREA('AFFICHAGE',SDIMPR)
C
      END
