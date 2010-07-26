      FUNCTION   JEXATR ( NOMC , NOMA )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 26/07/2010   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C TOLE CFT_720 CFT_726 CRP_18 CRS_508 CRS_512
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       NOMC , NOMA
      CHARACTER*32        JEXATR
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
C     ------------------------------------------------------------------
      INTEGER          NUMATR
      COMMON /IDATJE/  NUMATR
C     ------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     ,IDIADD     , IDIADM     ,
     &               IDMARQ     , IDNOM      ,             IDLONG     ,
     &               IDLONO     , IDLUTI     ,IDNUM
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 ,IDIADD = 2 , IDIADM = 3 ,
     &               IDMARQ = 4 , IDNOM  = 5 ,             IDLONG = 7 ,
     &               IDLONO = 8 , IDLUTI = 9 ,IDNUM  = 10 )
C     ------------------------------------------------------------------
      INTEGER          ICRE , IRET
      CHARACTER *75    CMESS
      CHARACTER*24     NOM24
      CHARACTER*6      NOMALU
      CHARACTER*8      CH8
      DATA             CH8      / '$$XATR  ' /
C DEB ------------------------------------------------------------------
C
      NOM24  = NOMC
      NOMALU = NOMA
      IF ( NOMALU .NE. 'LONCUM' ) THEN
        CALL U2MESK('F','JEVEUX1_28',1,NOMALU)
      ENDIF
      ICRE = 0
      CALL JJVERN ( NOM24//'        ' , ICRE ,IRET )
      IF ( IRET .NE. 2 ) THEN
        CALL U2MESS('F','JEVEUX1_29')
      ELSE
        CALL JJALLC ( ICLACO , IDATCO , 'L' , IBACOL )
        IXIADD = ISZON ( JISZON + IBACOL + IDIADD )
        IF ( IXIADD .NE. 0 ) THEN
          CALL U2MESS('F','JEVEUX1_30')
        ENDIF
        IXLONO = ISZON ( JISZON + IBACOL + IDLONO )
        IF ( IXLONO .EQ. 0 ) THEN
          CALL U2MESS('F','JEVEUX1_63')
        ENDIF
        JEXATR = NOM24//CH8
        NUMATR = IXLONO
      ENDIF
C DEB ------------------------------------------------------------------
      END
