      SUBROUTINE XMOINI(NH8,NH20,NP6,NP15,NP5,NP13,NT4,NT10,NCPQ4,NCPQ8,
     &                  NCPT3,NCPT6,NDPQ4,NDPQ8,NDPT3,NDPT6,NF4,NF8,NF3,
     &                  NF6,NPF2,NPF3,NH8X,NP6X,NP5X,NT4X,NCPQ4X,NCPT3X,
     &                  NDPQ4X,NDPT3X)
      IMPLICIT NONE

      INTEGER       NH8(11),NH20(7),NP6(11),NP15(7),NP5(11),NP13(7)
      INTEGER       NT4(11),NT10(7)
      INTEGER       NCPQ4(11),NCPQ8(7),NCPT3(11),NCPT6(7), NDPQ4(11)
      INTEGER       NDPQ8(7),NDPT3(11),NDPT6(7),NF4(11),NF8(7),NF3(11)
      INTEGER       NF6(7),NPF2(11),NPF3(7),NH8X(7),NP6X(7),NP5X(7)
      INTEGER       NT4X(7),NCPQ4X(7),NCPT3X(7),NDPQ4X(7),NDPT3X(7)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/12/2010   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT
C TOLE CRP_21
C
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM APPELEE PAR MODI_MODELE_XFEM (OP0113)
C
C    BUT : INITIALISER LES COMPTEURS DES NOMBRES D'ELEMENTS
C
C ----------------------------------------------------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER    I
C
      CALL JEMARQ()

      DO 10 I=1,7
        NH8(I)=0
        NH20(I)=0
        NP6(I)=0
        NP15(I)=0
        NP5(I)=0
        NP13(I)=0
        NT4(I)=0
        NT10(I)=0
        NCPQ4(I)=0
        NCPQ8(I)=0
        NCPT3(I)=0
        NCPT6(I)=0
        NDPQ4(I)=0
        NDPQ8(I)=0
        NDPT3(I)=0
        NDPT6(I)=0
        NF4(I)=0
        NF8(I)=0
        NF3(I)=0
        NF6(I)=0
        NPF2(I)=0
        NPF3(I)=0
        NH8X(I)=0
        NP6X(I)=0
        NP5X(I)=0
        NT4X(I)=0
        NCPQ4X(I)=0
        NCPT3X(I)=0
        NDPQ4X(I)=0
        NDPT3X(I)=0
 10   CONTINUE
      DO 20 I=8,11
        NH8(I)=0
        NP6(I)=0
        NP5(I)=0
        NT4(I)=0
        NCPT3(I)=0
        NCPQ4(I)=0
        NDPQ4(I)=0
        NDPT3(I)=0
        NF4(I)=0
        NF3(I)=0
        NPF2(I)=0
 20   CONTINUE
       

      CALL JEDEMA()
      END
