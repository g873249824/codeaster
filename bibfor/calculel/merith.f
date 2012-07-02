      SUBROUTINE MERITH(MODELZ,NCHAR,LCHAR,MATE,CARAZ,TIMEZ,
     &                  MATELZ,NH,BASEZ)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*(*) LCHAR(*), MATE
      CHARACTER*(*) MODELZ,CARAZ,MATELZ,BASEZ,TIMEZ
      CHARACTER*8 MODELE,CARA
      CHARACTER*19 MATEL
      CHARACTER*1 BASE
      CHARACTER*24 TIME
      INTEGER NCHAR
C ----------------------------------------------------------------------
C
C     CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE THERMIQUE
C      MATEL:
C            ( ISO     , 'RIGIDI_TH'  )
C            ( CAL_TI  , 'DDLMUR_THER')
C            ( ISO_FACE, 'RIGITH_COEFR/F' )
C
C     ENTREES:
C
C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELZ : NOM DU MODELE
C        NCHAR  : NOMBRE DE CHARGES
C        LCHAR  : LISTE DES CHARGES
C        MATE   : CHAMP DE MATERIAUX
C        CARAZ  : CHAMP DE CARAC_ELEM
C        TIMEZ  : CHAMPS DE TEMPSR
C        MATELZ : NOM  DU  MATELE (N RESUELEM) PRODUIT
C                  ( ISO      , 'RIGIDI_TH'             )
C                  ( CAL_TI   , 'DDLMUR_THER'           )
C                  ( ISO_FACE , 'RIGIDI_TH_COEFHR/F'    )
C        NH     : NUMERO DE L'HARMONIQUE DE FOURIER(SI PAS FOURIER NH=0)
C
C     SORTIES:
C        MATELZ   : LE MATELE EST REMPLI.
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
C
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*8  K8BID
C-----------------------------------------------------------------------
      INTEGER I ,IRET ,JLIRE1 ,JLIRE2 ,JLIRE3 ,LONG1 ,LONG2 
      INTEGER LONG3 ,NH ,NUMOR3 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      MODELE = MODELZ
      CARA   = CARAZ
      TIME   = TIMEZ
      BASE   = BASEZ
      MATEL  = MATELZ
C
C     -- RIGIDITE CORRESPONDANT AUX ELEMENTS ISO ET AUX ELEMENTS CAL_TI:
      CALL MERIT1(MODELE,NCHAR,LCHAR,MATE,CARA,TIME,
     &            '&MERITH1           ',NH,MATEL,0,BASE)
      CALL JEEXIN('&MERITH1           .RELR',IRET)
      LONG1=0
      IF(IRET.NE.0)THEN
        CALL JELIRA('&MERITH1           .RELR','LONUTI',LONG1,K8BID)
        CALL JEVEUO('&MERITH1           .RELR','L',JLIRE1)
      ENDIF
C
C     -- RIGIDITE CORRESPONDANT AUX ELEMENTS D'ECHANGE:
      CALL MERIT2(MODELE,NCHAR,LCHAR,CARA,TIME,'&MERITH2           ',
     &            MATEL,LONG1,BASE)
      CALL JEEXIN('&MERITH2           .RELR',IRET)
      LONG2=0
      IF(IRET.NE.0)THEN
        CALL JELIRA('&MERITH2           .RELR','LONUTI',LONG2,K8BID)
        CALL JEVEUO('&MERITH2           .RELR','L',JLIRE2)
      ENDIF
C
C     -- OPERATEUR ELEMENTAIRE DE CONVECTION NATURELLE:
      NUMOR3 = LONG1 + LONG2
      CALL MERIT3(MODELE,NCHAR,LCHAR,MATE,CARA,TIME,
     &            '&MERITH3           ',MATEL,NUMOR3,BASE)
      CALL JEEXIN('&MERITH3           .RELR',IRET)
      LONG3=0
      IF(IRET.NE.0)THEN
        CALL JELIRA('&MERITH3           .RELR','LONUTI',LONG3,K8BID)
        CALL JEVEUO('&MERITH3           .RELR','L',JLIRE3)
      ENDIF
C
C
C     -- ON RECOPIE LES .RELR DE &MERITH1, &MERITH2 ET
C     -- &MERITH3 DANS MATEL.
C
      CALL JEEXIN(MATEL//'.RERR',IRET)
      IF (IRET.GT.0) THEN
        CALL JEDETR(MATEL//'.RERR')
        CALL JEDETR(MATEL//'.RELR')
      END IF

      CALL MEMARE(BASE,MATEL,MODELE,MATE,CARA,'RIGI_THER')

      DO 1,I = 1,LONG1
        CALL REAJRE(MATEL,ZK24(JLIRE1-1+I),BASE)
    1 CONTINUE
      DO 2,I = 1,LONG2
        CALL REAJRE(MATEL,ZK24(JLIRE2-1+I),BASE)
    2 CONTINUE
      DO 3,I = 1,LONG3
        CALL REAJRE(MATEL,ZK24(JLIRE3-1+I),BASE)
    3 CONTINUE
C
      CALL JEDETC(BASE,'&MERITH',1)
C
      MATELZ = MATEL
      CALL JEDEMA()
      END
