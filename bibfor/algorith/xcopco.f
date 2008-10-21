      SUBROUTINE XCOPCO(CHS,ALIAS,POSMA,XI,YI,GEOM)
  
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/10/2008   AUTEUR DESOZA T.DESOZA 
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
      IMPLICIT NONE

      CHARACTER*19 CHS
      CHARACTER*8  ALIAS
      INTEGER      POSMA
      REAL*8       XI
      REAL*8       YI
      REAL*8       GEOM(3)
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : XAPPAR
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C CALCUL DES COORDONNEES D'UN POINT DE CONTACT A PARTIR
C DES COORDONNEES PARAMETRIQUES POUR LE CONTACT METHODE CONTINUE
C
C IN  CHS    : CHAMP CONTENANT LA GEOMETRIE DE LA FACETTE ESCLAVE
C IN  ALIAS  : TYPE DE MAILLE
C IN  POSMA  : INDICE DE LA MAILLE DANS CONTAMA
C IN  XI     : COORDONNEE PARAMETRIQUE KSI DU PROJETE
C IN  YI     : COORDONNEE PARAMETRIQUE ETA DU PROJETE
C OUT GEOM   : COORDONNEES DU PROJETE (EN 2D Z=0)
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      JCSD1,JCSV1,JCSL1
      INTEGER      NDIM,NNO,I,J,IAD
      REAL*8       FF(9),COOR(27)
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL JEVEUO(CHS//'.CESD','L',JCSD1)
      CALL JEVEUO(CHS//'.CESV','L',JCSV1)
      CALL JEVEUO(CHS//'.CESL','L',JCSL1)
C
C --- INITIALISATIONS
C----!!!!valable pour 2d pour l'instant!!!
      NDIM=2
      NNO=2

      DO 100 I=1,NDIM
        GEOM(I) = 0.D0
  100 CONTINUE
C
C     RECUPERATION DES COORDONNES REELES DES POINTS D'INTERSECTION
      DO 200 I=1,NNO
        DO 210 J=1,NDIM
          CALL CESEXI('S',JCSD1,JCSL1,POSMA,1,1,NDIM*(I-1)+J,IAD)
          CALL ASSERT(IAD.GT.0)
          COOR(NDIM*(I-1)+J)=ZR(JCSV1-1+IAD)
 210    CONTINUE
 200  CONTINUE
C
      CALL MMNONF(NDIM,NNO,ALIAS,XI,YI,FF)
      DO 300 I = 1,NDIM
        DO 310 J = 1,NNO
          GEOM(I) = FF(J)*COOR((J-1)*NDIM+I) + GEOM(I)
  310   CONTINUE
  300 CONTINUE
C
      CALL JEDEMA()
      END
