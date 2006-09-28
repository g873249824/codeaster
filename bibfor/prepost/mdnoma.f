      SUBROUTINE MDNOMA ( NOMAMD, LNOMAM,
     &                    NOMAST, CODRET )
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C        FORMAT MED : ELABORATION D'UN NOM DE MAILLAGE DANS LE FICHIER
C               - -                    --     --
C_____________________________________________________________________
C
C   LA REGLE EST LA SUIVANTE :
C
C     LE NOM EST LIMITE A 32 CARACTERES DANS MED. ON UTILISE ICI
C     AU MAXIMUM 8 CARACTERES.
C                 12345678901234567890123456789012
C                 AAAAAAAA
C       AAAAAAAA : NOM DU MAILLAGE DANS ASTER
C
C
C     SORTIES :
C       NOMAMD : NOM DU MAILLAGE DANS LE FICHIER MED
C       LNOMAM : LONGUEUR UTILE DU NOM DU MAILLAGE DANS LE FICHIER MED
C       CODRET : CODE DE RETOUR DE L'OPERATION
C                0 --> TOUT VA BIEN
C                1 --> LA DECLARATION DU NOM DE L'OBJET NE CONVIENT PAS
C               10 --> AUTRE PROBLEME
C    ENTREES :
C       NOMAST : NOM DU MAILLAGE ASTER
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*32 NOMAMD
      CHARACTER*8  NOMAST
C
      INTEGER LNOMAM
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER      ZI
      REAL*8       ZR
      COMPLEX*16   ZC
      LOGICAL      ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
C
      INTEGER LXLGUT
C
      INTEGER IAUX
C
C====
C 1. PREALABLES
C====
C
      CODRET = 0
C
C====
C 2. CREATION DU NOM
C====
C
      IF ( CODRET.EQ.0 ) THEN
C
C 2.1. ==> BLANCHIMENT INITIAL
C               12345678901234567890123456789012
      NOMAMD = '                                '
C
C 2.2. ==> NOM DU MAILLAGE
C
      IAUX = LXLGUT(NOMAST)
      IF ( IAUX.GE.1 .AND. IAUX.LE.8 ) THEN
        NOMAMD(1:IAUX) = NOMAST(1:IAUX)
        LNOMAM = IAUX
      ELSE
        CODRET = 1
        CALL U2MESS('E','PREPOST3_61')
      ENDIF
C
      ENDIF
C
C====
C 3. BILAN
C====
C
      IF ( CODRET.NE.0 ) THEN
        CALL U2MESS('E','PREPOST3_62')
      ENDIF
C
      END
