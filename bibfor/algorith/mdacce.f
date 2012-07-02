      SUBROUTINE MDACCE (TYPBAS,NEQGEN,PULSA2,MASGEN,DESCM,
     &                   RIGGEN,DESCR,FEXGEN,LAMOR,AMOGEN,DESCA,
     &                   WORK1,DEPGEN,VITGEN,ACCGEN )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER            NEQGEN,DESCM,DESCR,DESCA
      REAL*8             MASGEN(*),RIGGEN(*),FEXGEN(*),AMOGEN(*)
      REAL*8             DEPGEN(*),VITGEN(*),ACCGEN(*)
      REAL*8             WORK1(*),PULSA2(*)
      CHARACTER*16       TYPBAS
      LOGICAL                                 LAMOR
      COMPLEX*16         CBID
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     CALCUL DE L'ACCELERATION (EQUATION D'EQUILIBRE)
C     ------------------------------------------------------------------
C IN  : TYPBAS : TYPE DE LA BASE 'MODE_MECA' 'BASE_MODA' 'MODELE_GENE'
C IN  : NEQGEN : NOMBRE DE MODES
C IN  : PULSA2 : PULSATIONS MODALES AU CARREES
C IN  : MASGEN : MASSES GENERALISEES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE MASSE GENERALISEE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCM : DESCRIPTEUR DE LA MATRICE DE MASSE
C IN  : RIGGEN : RAIDEURS GENERALISES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE RAIDEUR GENERALISE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCR : DESCRIPTEUR DE LA MATRICE DE RIGIDITE
C IN  : FEXGEN : FORCES EXTERIEURES GENERALISEES
C IN  : LAMOR  : AMORTISSEMENT SOUS FORME D'UNE LISTE DE REELS
C IN  : AMOGEN : AMORTISSEMENTS REDUITS ( LAMOR = .TRUE. )
C                MATRICE D'AMORTISSEMENT ( LAMOR = .FALSE. )
C IN  : DESCA : DESCRIPTEUR DE LA MATRICE D'AMORTISSEMENT
C IN  : WORK1  : VECTEUR DE TRAVAIL
C IN  : DEPGEN : DEPLACEMENTS GENERALISES
C IN  : VITGEN : VITESSES GENERALISEES
C OUT : ACCGEN : ACCELERATIONS GENERALISEES
C ----------------------------------------------------------------------
C
C
C
C
      REAL*8  X1, X2
C
C-----------------------------------------------------------------------
      INTEGER IM ,IRET ,JMASS 
C-----------------------------------------------------------------------
      IF (TYPBAS(1:9).EQ.'MODE_MECA'.OR.
     &    TYPBAS(1:9).EQ.'MODE_GENE') THEN
        IF ( LAMOR ) THEN
          DO 100 IM = 1,NEQGEN
            X1 = FEXGEN(IM) / MASGEN(IM)
            X2 = PULSA2(IM)*DEPGEN(IM) + AMOGEN(IM)*VITGEN(IM)
            ACCGEN(IM) = X1 - X2
100       CONTINUE
        ELSE
          CALL PMAVEC('ZERO',NEQGEN,AMOGEN,VITGEN,WORK1)
          DO 110 IM = 1,NEQGEN
            X1 = FEXGEN(IM) / MASGEN(IM)
            X2 = PULSA2(IM)*DEPGEN(IM) + WORK1(IM)/MASGEN(IM)
            ACCGEN(IM) = X1 - X2
110       CONTINUE
        ENDIF
C
      ELSEIF (TYPBAS(1:9).EQ.'BASE_MODA') THEN
        CALL JEEXIN('&&MDACCE.MASS',IRET)
        IF (IRET.EQ.0) THEN
          CALL WKVECT('&&MDACCE.MASS','V V R8',NEQGEN*NEQGEN,JMASS)
          CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
          CALL TRLDS(ZR(JMASS),NEQGEN,NEQGEN,IRET)
        ELSE
          CALL JEVEUO('&&MDACCE.MASS','E',JMASS)
        ENDIF
        IF ( LAMOR ) THEN
          CALL PMAVEC('ZERO',NEQGEN,MASGEN,VITGEN,WORK1)
          DO 120 IM = 1,NEQGEN
            WORK1(IM) = AMOGEN(IM)*WORK1(IM)
120       CONTINUE
        ELSE
          CALL PMAVEC('ZERO',NEQGEN,AMOGEN,VITGEN,WORK1)
        ENDIF
        CALL PMAVEC('CUMU',NEQGEN,RIGGEN,DEPGEN,WORK1)
        DO 130 IM = 1,NEQGEN
          ACCGEN(IM) = FEXGEN(IM) - WORK1(IM)
130     CONTINUE
C        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
C        CALL TRLDS(ZR(JMASS),NEQGEN,NEQGEN,IRET)
        CALL RRLDS(ZR(JMASS),NEQGEN,NEQGEN,ACCGEN,1)
C
      ELSEIF (TYPBAS(1:11).EQ.'MODELE_GENE' ) THEN
        IF (DESCA.NE.0) THEN
          CALL MRMULT('ZERO',DESCA,VITGEN,WORK1,1,.FALSE.)
          CALL MRMULT('CUMU',DESCR,DEPGEN,WORK1,1,.FALSE.)
        ELSE
          CALL MRMULT('ZERO',DESCR,DEPGEN,WORK1,1,.FALSE.)
        ENDIF
        DO 140 IM = 1,NEQGEN
          ACCGEN(IM) = FEXGEN(IM) - WORK1(IM)
140     CONTINUE

        CALL RESOU2(' ',DESCM,1,ACCGEN,CBID)
      ENDIF
C
      END
