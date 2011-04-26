      SUBROUTINE COUPLA(NP1,NBM,INDIC,TPFL,VECI1,
     &                  VGAP,VECR4,VECR1,VECR2,VECR5,VECR3,
     &                  MASG,PULS,LOCFLC,AMFLU0,AMFLUC,XSI0)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
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
C
C-----------------------------------------------------------------------
C DESCRIPTION : PRISE EN COMPTE DU COUPLAGE EN CAS DE REGIME
C -----------   DE VIBRATION NON-LINEAIRE (IMPACT-FROTTEMENT)
C
C               APPELANTS : ALITMI, NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER      NP1, NBM, INDIC
      CHARACTER*8  TPFL
      INTEGER      VECI1(*)
      REAL*8       VGAP, VECR4(*),
     &             VECR1(*), VECR2(*), VECR5(*), VECR3(*),
     &             MASG(*), PULS(*)
      LOGICAL      LOCFLC(*)
      REAL*8       AMFLU0(NP1,*), AMFLUC(NP1,*), XSI0(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER      I, J
      REAL*8       XCF, R8B1, R8B2
      COMPLEX*16   C16B
      LOGICAL      LK
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL     MATINI, COEFMO
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C 1.  CALCUL DE LA MATRICE D'AMORTISSEMENT AJOUTE ADIMENSIONALISEE
C     ------------------------------------------------------------
      CALL MATINI(NP1,NP1,0.D0,AMFLUC)
C
C.... LK = .FALSE. INDIQUE QU'ON NE CALCULE PAS LES TERMES DE RAIDEUR
C
      LK = .FALSE.
      DO 10 I = 1, NBM
         IF ( LOCFLC(I) ) THEN
            CALL COEFMO(TPFL,LK,NBM,I,INDIC,R8B1,PULS(I),VGAP,
     &                  XSI0(I),VECI1,VECR1,VECR2,VECR3,VECR4,
     &                  VECR5,R8B2,C16B,XCF)
            AMFLUC(I,I) = XCF/MASG(I)
         ENDIF
  10  CONTINUE
C
C 2.  CALCUL DU SAUT DE MATRICE D'AMORTISSEMENT AJOUTE ADIMENSIONALISEE
C     PAR RAPPORT A LA MATRICE DE REFERENCE EN VOL
C     --------------------------------------------
      DO 20 J = 1, NBM
         DO 21 I = 1, NBM
            AMFLUC(I,J) = AMFLUC(I,J) - AMFLU0(I,J)
  21     CONTINUE
  20  CONTINUE
C
C --- FIN DE COUPLA.
      END
