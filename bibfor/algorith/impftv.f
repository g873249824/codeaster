      SUBROUTINE IMPFTV(ISOR,IFT,IBL,FMOYT,FETYPT,FRMST,
     +                  FMOYC,FETYPC,FRMSC,FMAX,FMIN)
C***********************************************************************
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C     IMPRESSION DES FORCES TANGENTIELLES AMV
C
C
C
      IMPLICIT REAL *8 (A-H,O-Z)
      INTEGER ISOR,IFT
      REAL*8 FMOYT,FRMST,FETYPT,FMOYC,FRMSC,FETYPC,FMAX,FMIN
C
C
C
      IF (IFT.EQ.1) THEN
        IF (IBL.EQ.1) THEN
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES FORCE TANGENTE 1 *****'
         WRITE(ISOR,*)' *****    RAMENEES AU TEMPS TOTAL   *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT1 MOY     ! FT1 E.TYPE  ! FT1 RMS     !',
     &               ' FT1 MIN     ! FT1 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
        ELSEIF (IBL.EQ.0) THEN
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES GLOBALES FTANG1 *****'
         WRITE(ISOR,*)' *****    RAMENEES AU TEMPS TOTAL   *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT1 MOY     ! FT1 E.TYPE  ! FT1 RMS     !',
     &               ' FT1 MIN     ! FT1 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES GLOBALES FTANG1 *****'
         WRITE(ISOR,*)' *****   RAMENEES AU TEMPS DE CHOC  *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT1 MOY     ! FT1 E.TYPE  ! FT1 RMS     !',
     &               ' FT1 MIN     ! FT1 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYC,FETYPC,FRMSC,FMIN,FMAX
        ELSEIF (IBL.GE.2) THEN
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
        ENDIF
      ELSEIF (IFT.EQ.2) THEN
        IF (IBL.EQ.1) THEN
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES FORCE TANGENTE 2 *****'
         WRITE(ISOR,*)' *****    RAMENEES AU TEMPS TOTAL   *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT2 MOY     ! FT2 E.TYPE  ! FT2 RMS     !',
     &               ' FT2 MIN     ! FT2 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
        ELSEIF (IBL.EQ.0) THEN
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES GLOBALES FTANG2 *****'
         WRITE(ISOR,*)' *****    RAMENEES AU TEMPS TOTAL   *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT2 MOY     ! FT2 E.TYPE  ! FT2 RMS     !',
     &               ' FT2 MIN     ! FT2 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
         WRITE(ISOR,*)
         WRITE(ISOR,*)' ***** STATISTIQUES GLOBALES FTANG2 *****'
         WRITE(ISOR,*)' *****   RAMENEES AU TEMPS DE CHOC  *****'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
         WRITE(ISOR,*)'!IB! FT2 MOY     ! FT2 E.TYPE  ! FT2 RMS     !',
     &               ' FT2 MIN     ! FT2 MAX     !'
         WRITE(ISOR,*)'+--+-------------+-------------+-------------+'//
     &               '-------------+-------------+'
        WRITE(ISOR,10) IBL,FMOYC,FETYPC,FRMSC,FMIN,FMAX
        ELSEIF (IBL.GE.2) THEN
        WRITE(ISOR,10) IBL,FMOYT,FETYPT,FRMST,FMIN,FMAX
        ENDIF
      ENDIF
C
 10   FORMAT(' !',I2,'!',1PE12.5,' !',1PE12.5,' !',1PE12.5,' !',
     &        1PE12.5,' !',1PE12.5 ,' !')
C
      END
