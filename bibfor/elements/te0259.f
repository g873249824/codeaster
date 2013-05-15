      SUBROUTINE TE0259(OPTION,NOMTE)
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/05/2013   AUTEUR TORKHANI M.TORKHANI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRS_512
C ======================================================================
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C       'MECA_GYRO': CALCUL DE LA MATRICE D'AMORTISSEMENT GYROSCOPIQUE
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C       'MECA_POU_D_E'  : POUTRE DROITE D'EULER       (SECTION VARIABLE)
C       'MECA_POU_D_T'  : POUTRE DROITE DE TIMOSHENKO (SECTION VARIABLE)
C       'MECA_POU_D_EM' : POUTRE DROITE MULTIFIBRE D EULER (SECT. CONST)
C       'MECA_POU_D_TG' : POUTRE DROITE DE TIMOSHENKO (GAUCHISSEMENT)
C       'MECA_POU_D_TGM': POUTRE DROITE DE TIMOSHENKO (GAUCHISSEMENT)
C                         MULTI-FIBRES (SECTION CONSTANTE)


      INTEGER NDDL,NBRES,I
      PARAMETER (NBRES=3)
      REAL*8 VALRES(NBRES)
      INTEGER CODRES(NBRES)
      CHARACTER*8 NOMPAR,NOMRES(NBRES),FAMI,POUM
      REAL*8 PGL(3,3),KLV(78),KLW(78),MLV(105)
      REAL*8 E, RHO
      REAL*8     VALPAR, XNU, ZERO
      INTEGER IMATE, LMAT, LORIEN, LSECT
      INTEGER NBPAR, NC, NNO,KPG,SPT
C     ------------------------------------------------------------------
      DATA NOMRES/'E','RHO','NU'/
C     ------------------------------------------------------------------
      ZERO = 0.D0
C     ------------------------------------------------------------------
C
C     --- CARACTERISTIQUES DES ELEMENTS
C
      IF (NOMTE.EQ.'MECA_POU_D_E'  .OR.
     &    NOMTE.EQ.'MECA_POU_D_T'  .OR.
     &    NOMTE.EQ.'MECA_POU_D_EM'     ) THEN
        NNO = 2
        NC  = 6
      ELSEIF (NOMTE.EQ.'MECA_POU_D_TG' .OR.
     &        NOMTE.EQ.'MECA_POU_D_TGM'    ) THEN
        NNO    = 2
        NC     = 7
      ELSE
        CALL U2MESK('F','ELEMENTS2_42',1,NOMTE)
      ENDIF
C
      NDDL = NC*NNO
C
C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
C
      CALL JEVECH('PMATERC','L',IMATE)

      NBPAR  = 0
      NOMPAR = ' '
      VALPAR = ZERO
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      CALL RCVALB(FAMI,KPG,SPT,POUM,ZI(IMATE),' ','ELAS',NBPAR,NOMPAR,
     &            VALPAR,NBRES,NOMRES,VALRES,CODRES,1)
      E   = VALRES(1)
      RHO = VALRES(2)
      XNU = VALRES(3)

      CALL JEVECH('PCAGNPO','L',LSECT)

      CALL JEVECH('PMATUNS','E',LMAT)

C     --- RECUPERATION DES ORIENTATIONS ---

      CALL JEVECH('PCAORIE','L',LORIEN)

C     --- CALCUL DE LA MATRICE GYROSCOPIQUE LOCALE ---
      CALL POGYRO(NOMTE,RHO,XNU,ZI(IMATE),KLV,78)

      CALL MATROT(ZR(LORIEN),PGL)
C  CHANGEMENT DE BASE : LOCAL -> GLOBAL
      CALL UTPALG (NNO,6,PGL,KLV,KLW)
C
      IF (NOMTE.EQ.'MECA_POU_D_TG' .OR.
     &    NOMTE.EQ.'MECA_POU_D_TGM'    ) THEN
         DO 100 I = 1 , 21
            MLV(I) = KLW(I)
100      CONTINUE
         DO 102 I = 22 , 28
            MLV(I) = 0.D0
102      CONTINUE
         DO 104 I = 29 , 34
            MLV(I) = KLW(I-7)
104      CONTINUE
         MLV(35) = 0.D0
         DO 106 I = 36 , 42
            MLV(I) = KLW(I-8)
106      CONTINUE
         MLV(43) = 0.D0
         DO 108 I = 44 , 51
            MLV(I) = KLW(I-9)
108      CONTINUE
         MLV(52) = 0.D0
         DO 110 I = 53 , 61
            MLV(I) = KLW(I-10)
110      CONTINUE
         MLV(62) = 0.D0
         DO 112 I = 63 , 72
            MLV(I) = KLW(I-11)
112      CONTINUE
         MLV(73) = 0.D0
         DO 114 I = 74 , 84
            MLV(I) = KLW(I-12)
114      CONTINUE
         MLV(85) = 0.D0
         DO 116 I = 86 , 91
            MLV(I) = KLW(I-13)
116      CONTINUE
         DO 118 I = 92 , 105
            MLV(I) = 0.D0
118      CONTINUE
      ENDIF

C CONSITUER UNE MATRICE PLEINE A PARTIR DE LA TRIANGULAIRE SUPERIEURE

      IF (NOMTE.EQ.'MECA_POU_D_TG' .OR.
     &    NOMTE.EQ.'MECA_POU_D_TGM'    ) THEN
         CALL UPLETR(NDDL,ZR(LMAT),MLV)
      ELSE
         CALL UPLETR(NDDL,ZR(LMAT),KLW)
      ENDIF

      END
