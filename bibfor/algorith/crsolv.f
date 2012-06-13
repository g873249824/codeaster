      SUBROUTINE CRSOLV ( METHOD, RENUM, SOLVE , BAS )
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*(*)      METHOD, RENUM, SOLVE , BAS
C ----------------------------------------------------------------------
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
C     CREATION D'UNE STRUCTURE SOLVEUR
C
C
C
C
      REAL*8             JEVTBL,EPSMAT
      CHARACTER*1        BASE
      CHARACTER*3        SYME
      CHARACTER*8        PRECO
      CHARACTER*19       SOLVEU
C
C --- INITIALISATIONS
C
      CALL JEMARQ()
C
      SOLVEU = SOLVE
      BASE = BAS
C
      PRECO  = 'SANS'
      SYME   = 'NON'
C
      RESIRE = 1.D-6
      NPREC = 8
      EPSMAT=-1.D0
C
C --- CREATION DES DIFFERENTS ATTRIBUTS DE LA S.D. SOLVEUR
C
      CALL WKVECT(SOLVEU//'.SLVK',BASE//' V K24',12,ISLVK)
      CALL WKVECT(SOLVEU//'.SLVR',BASE//' V R'  ,4,ISLVR)
      CALL WKVECT(SOLVEU//'.SLVI',BASE//' V I'  ,7,ISLVI)
C
      ZK24(ISLVK-1+1) = METHOD
      ZK24(ISLVK-1+2) = PRECO
      IF (METHOD.EQ.'MUMPS') THEN
        ZK24(ISLVK-1+3) = 'AUTO'
        ZK24(ISLVK-1+6) = 'OUI'
      ELSE
        ZK24(ISLVK-1+3) = 'XXXX'
        ZK24(ISLVK-1+6) = 'XXXX'
      ENDIF
      ZK24(ISLVK-1+4) = RENUM
      ZK24(ISLVK-1+5) = SYME
      ZK24(ISLVK-1+7) = 'XXXX'
      ZK24(ISLVK-1+8) = 'XXXX'
      ZK24(ISLVK-1+9) = 'XXXX'
      ZK24(ISLVK-1+10) = 'XXXX'
      ZK24(ISLVK-1+11) = 'XXXX'
      ZK24(ISLVK-1+12) = 'XXXX'

C
      ZR(ISLVR-1+1) = EPSMAT
      ZR(ISLVR-1+2) = RESIRE
      ZR(ISLVR-1+3) = JEVTBL('TAILLE_BLOC')
      ZR(ISLVR-1+4) = 0.D0
C
      ZI(ISLVI-1+1) = NPREC
      ZI(ISLVI-1+2) =-9999
      ZI(ISLVI-1+3) =-9999
      ZI(ISLVI-1+4) =-9999
      ZI(ISLVI-1+5) =-9999
      ZI(ISLVI-1+6) =-9999
      ZI(ISLVI-1+7) =-9999

C
      CALL JEDEMA()
C
C     CALL CHEKSD(SOLVEU,'sd_solveur',IRET)
      END
