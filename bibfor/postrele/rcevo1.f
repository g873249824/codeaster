      SUBROUTINE RCEVO1 ( NOMMAT, FATIZH, SM, PARA, SYMAX )
      IMPLICIT   NONE
      REAL*8              SM, PARA(*), SYMAX
      LOGICAL             FATIZH
      CHARACTER*8         NOMMAT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------
C     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
C     LECTURE DU MOT CLE SIMPLE "MATER"
C
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER      NBPAR
      REAL*8       VALRES(3), EREFE, E,  RBID, R8VIDE
      INTEGER ICODRE(3)
      CHARACTER*8  NOMPAR, NOMVAL(3)
      CHARACTER*16 PHENOM
C DEB ------------------------------------------------------------------
C
      NBPAR     = 0
      NOMPAR    = ' '
      NOMVAL(1) = 'SM'
      CALL RCVALE ( NOMMAT, 'RCCM', NBPAR, NOMPAR, RBID, 1,
     &              NOMVAL, SM, ICODRE, 2)
C
      PARA(1) = R8VIDE()
      PARA(2) = R8VIDE()
      PARA(3) = R8VIDE()
      IF ( FATIZH ) THEN
         CALL RCCOME ( NOMMAT, 'FATIGUE', PHENOM, ICODRE )
        IF (ICODRE(1).EQ.1) CALL U2MESK('F','POSTRCCM_7',1,'FATIGUE')
         CALL RCCOME ( NOMMAT, 'ELAS', PHENOM, ICODRE )
         IF (ICODRE(1).EQ.1) CALL U2MESK('F','POSTRCCM_7',1,'ELAS')
C
         NOMVAL(1) = 'M_KE'
         NOMVAL(2) = 'N_KE'
         CALL RCVALE ( NOMMAT, 'RCCM', NBPAR, NOMPAR, RBID, 2,
     &                 NOMVAL, VALRES, ICODRE, 2)
         PARA(1) = VALRES(1)
         PARA(2) = VALRES(2)
C
         NOMVAL(1) = 'E_REFE'
         CALL RCVALE ( NOMMAT, 'FATIGUE', NBPAR, NOMPAR, RBID, 1,
     &                 NOMVAL, EREFE, ICODRE, 2)
C
         NOMVAL(1) = 'E'
         CALL RCVALE ( NOMMAT, 'ELAS', NBPAR, NOMPAR, RBID, 1,
     &                 NOMVAL, E, ICODRE, 2)
         PARA(3) = EREFE / E
      ENDIF
C
      IF ( SYMAX .EQ. R8VIDE() ) THEN
         NOMVAL(1) = 'SY_02'
         CALL RCVALE ( NOMMAT, 'RCCM', NBPAR, NOMPAR, RBID, 1,
     &                 NOMVAL, VALRES, ICODRE, 0)
         IF ( ICODRE(1) .EQ. 0 ) SYMAX = VALRES(1)
      ENDIF
C
      END
