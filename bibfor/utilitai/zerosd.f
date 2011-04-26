      LOGICAL FUNCTION ZEROSD(TYPESD,SD)
      IMPLICIT NONE
      CHARACTER*(*) SD,TYPESD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
C ----------------------------------------------------------------------
C  BUT : DETERMINER SI UNE SD EST NULLE (OU PAS)
C  IN   TYPESD : TYPE DE  SD
C   LISTE DES POSSIBLES: 'RESUELEM', 'CARTE', 'CHAM_NO', 'CHAM_ELEM'
C       SD     : NOM DE LA SD
C
C     RESULTAT:
C       ZEROSD : .TRUE.    SI LES VALEURS DE LA SD SONT TOUTES NULLES
C                .FALSE.   SINON
C ----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ----------------------------------------------------------------------
      LOGICAL ZEROBJ
      CHARACTER*19 K19
      CHARACTER*16 TYP2SD
C
C -DEB------------------------------------------------------------------
C
      TYP2SD=TYPESD



      IF (TYP2SD.EQ.'RESUELEM') THEN
C     --------------------------------
        K19=SD
        ZEROSD=ZEROBJ(K19//'.RESL')


      ELSE IF (TYP2SD.EQ.'CHAM_NO') THEN
C     --------------------------------
        K19=SD
        ZEROSD=ZEROBJ(K19//'.VALE')


      ELSE IF (TYP2SD.EQ.'CARTE') THEN
C     --------------------------------
        K19=SD
        ZEROSD=ZEROBJ(K19//'.VALE')


      ELSE IF (TYP2SD.EQ.'CHAM_ELEM') THEN
C     --------------------------------
        K19=SD
        ZEROSD=ZEROBJ(K19//'.CELV')

      ELSE
        CALL U2MESK('F','UTILITAI_47',1,TYP2SD)
      END IF

      END
