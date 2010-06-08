      SUBROUTINE FGDOMA(NOMMAT,NBCYCL,EPSMIN,EPSMAX,DOM)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     NOMMAT
      REAL*8                          EPSMIN(*),EPSMAX(*)
      REAL*8                  DOM(*)
      INTEGER                  NBCYCL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 25/07/2001   AUTEUR CIBHHLV L.VIVAN 
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
C     -----------------------------------------------------------------
C     CALCUL DU DOMMAGE ELEMENTAIRE PAR INTERPOLATION SUR
C     UNE COURBE DE MANSON_COFFIN DONNEE POINT PAR POINT
C     ------------------------------------------------------------------
C IN  NOMMAT : K   : NOM DU MATERIAU
C IN  NBCYCL : I   : NOMBRE DE CYCLES
C IN  EPSMIN : R   : DEFORMATIONS MINIMALES DES CYCLES
C IN  EPSMAX : R   : DEFORMATIONS MAXIMALES DES CYCLES
C OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*2  CODRET
      CHARACTER*8  NOMRES,NOMPAR,NOMP,K8BID
      CHARACTER*10 PHENO
      REAL*8       NRUPT,DELTA
C
      CALL JEMARQ()
      NOMRES = 'MANSON_C '
      NBPAR     = 1
      PHENO     = 'FATIGUE   '
      NOMPAR    = 'EPSI    '
C
      DO 10 I=1,NBCYCL
         DELTA = (ABS(EPSMAX(I)-EPSMIN(I)))/2.D0
         CALL RCVALE(NOMMAT,PHENO,NBPAR,NOMPAR,DELTA,1,NOMRES,
     +                                         NRUPT,CODRET,'F ')
         DOM(I) = 1.D0/NRUPT
 10   CONTINUE
C
      CALL JEDEMA()
      END
