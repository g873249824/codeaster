      SUBROUTINE FSTAPV(NBPT,FN,T,OFFSET,FNMOYT,FNMOYC,FNRMST,FNRMSC,
     +                  FNMAX,FNMIN,FMAXMO,FMINMO,
     +                  SFN,SFN2,TCHOC,NBMAXR,NBMINR)
C***********************************************************************
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C       MOYENNAGE STATISTIQUE DES FORCES
C       ALGORITHME TEMPOREL A PAS VARIABLE
C
C
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      REAL*8 FN(*),T(*),FNMOYT,FNMOYC,FNRMSC,FNRMST,FNMAX,FNMIN
      REAL*8 SMINR,SMAXR,OFFSET,FMAXMO,FMINMO,SFN2,SFN,TCHOC
C
C
C       ARGUMENTS:
C       ----------------------------------------
C       IN:
C            NBPT         NB DE POINTS DU TABLEAU A ANALYSER
C            FN           TABLEAU A ANALYSER
C            OFFSET       VALEUR DE SEUIL DE DETECTION DES VALEURS
C
C       OUT:
C            FNMOY        VALEUR MOYENNE ( COMPTAGE AU DESSUS DU SEUIL )
C            FNRMS        SQRT DE LA MOYENNE DES CARRES ( RMS POUR DES F
C                         REDRESSEES )
C            FNMAX        VALEUR MAXIMUM ABSOLU DU TABLEAU
C            FNMIN        VALEUR MINIMUM ABSOLU DE LA FONCTION
C            FMAXMO       MOYENNE DES MAXIMAS RELATIFS DE LA FONCTION
C            FMINMO       MOYENNE DES MINIMAS RELATIFS DE LA FONCTION
C
C
C
C       VARIABLES UTILISEES
C       ----------------------------------------
C       SFN SOMME DES FORCES DE CHOC
C       SFN2 SOMME DES CARRES DES FORCES DE CHOC
C       NBMAXR  NOMBRE DE MAXIMAS RELATIFS RENCONTRES
C       NBMINR  NOMBRE DE MINIMAS RELATIFS RENCONTRES
C       SMAXR   SOMME DES MAXIMAS RELATIFS
C       SMINR   SOMME DES MINIMAS RELATIFS
C
      CALL JEMARQ()
      SFN = 0.D0
      SFN2 = 0.D0
      FNMAX = -10.D20
      FNMIN = -FNMAX
      NBMINR = 0
      NBMAXR = 0
      SMAXR = 0.0D0
      SMINR = 0.0D0
C
      CALL WKVECT('&&FSTAPV.TEMP.FCNT','V V R',NBPT,IFT)
      CALL WKVECT('&&FSTAPV.TEMP.FTCT','V V R',NBPT,ITCT)
C
C           RECHERCHE DES EXTREMAS ABSOLUS
C
      DO 10 I = 1,NBPT
          IF (FN(I).GT.FNMAX) FNMAX = FN(I)
          IF (FN(I).LT.FNMIN) FNMIN = FN(I)
   10 CONTINUE
C
C
C
C --- RECHERCHE DES EXTREMAS RELATIFS
C
      DO 20 I = 1,NBPT
          IF ((I.GT.1) .AND. (I.LT.NBPT)) THEN
C
            IF ((FN(I).GT.FN(I-1)) .AND. (FN(I).GT.FN(I+1))) THEN
              SMAXR = SMAXR + FN(I)
              NBMAXR = NBMAXR + 1
            END IF
C
            IF ((FN(I).LT.FN(I-1)) .AND. (FN(I).LT.FN(I+1))) THEN
              SMINR = SMINR + FN(I)
              NBMINR = NBMINR + 1
            END IF
C
          END IF
   20 CONTINUE
C
C
C --- MOYENNE DES EXTREMAS RELATIFS
C
      IF (NBMINR.NE.0) THEN
        FMINMO = SMINR/DBLE(NBMINR)
      ELSE
        FMINMO = 0.D0
      END IF
C
      IF (NBMAXR.NE.0) THEN
        FMAXMO = SMAXR/DBLE(NBMAXR)
      ELSE
        FMAXMO = 0.D0
      END IF
C
C
C --- CALCUL DE LA FORCE MOYENNE
C
      DO 30 I = 1,NBPT
          IF ((ABS(FN(I))) .GT. OFFSET ) THEN
            ZR(IFT+I-1) = FN(I)
            ZR(ITCT+I-1) = 1.D0
          ELSE
            ZR(IFT+I-1) = 0.D0
            ZR(ITCT+I-1) = 0.D0
          ENDIF
   30 CONTINUE
      CALL TRAPEZ(T,ZR(IFT),NBPT,SFN)
      CALL TRAPEZ(T,ZR(ITCT),NBPT,TCHOC)
        TTOT = T(NBPT)-T(1)
        FNMOYT = SFN/TTOT
        IF (TCHOC .GT. 0.D0) THEN
          FNMOYC = SFN/TCHOC
        ELSE
          FNMOYC = 0.D0
        ENDIF
C
C
C --- CALCUL DE LA FORCE QUADRATIQUE MOYENNE
C
      DO 50 I = 1,NBPT
        IF (ABS(FN(I)).GT.OFFSET) THEN
            ZR(IFT+I-1) = FN(I)*FN(I)
        ELSE
            ZR(IFT+I-1) = 0.D0
        END IF
   50 CONTINUE
      CALL TRAPEZ(T,ZR(IFT),NBPT,SFN2)
        FNRMST = SQRT(SFN2/TTOT)
        IF (TCHOC .GT. 0.D0) THEN
          FNRMSC = SQRT(SFN2/TCHOC)
        ELSE
          FNRMSC = 0.D0
          FNMIN = 0.D0
          FNMAX = 0.D0
        ENDIF

C
      CALL JEDETR('&&FSTAPV.TEMP.FCNT')
      CALL JEDETR('&&FSTAPV.TEMP.FTCT')
      CALL JEDEMA()
      END
