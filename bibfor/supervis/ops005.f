      SUBROUTINE OPS005( ICMD , ICOND, IER )
      IMPLICIT NONE
      INTEGER            ICMD , ICOND, IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 19/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
C     ------------------------------------------------------------------
C
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
      CHARACTER*1  KBID
      CHARACTER*8  NOMRES, NOMPAR
      CHARACTER*16 TYPRES, NOMCMD
      CHARACTER*19 NOMFON
      INTEGER      LPROL,  LNOVA,    NK,    IR
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL GETRES(NOMFON,TYPRES,NOMCMD)
C
      IF (ICOND.EQ.0) THEN 
        NOMPAR = '  '
        NOMRES = 'TOUTRESU'
        CALL WKVECT(NOMFON//'.PROL','G V K24',6,LPROL)
        ZK24(LPROL)   = 'INTERPRE'
        ZK24(LPROL+1) = 'INTERPRE'
        ZK24(LPROL+2) =  NOMPAR
        ZK24(LPROL+3) =  NOMRES
        ZK24(LPROL+4) = 'II      '
        ZK24(LPROL+5) = NOMFON
        CALL GETVTX(' ','NOM_PARA',1,1,1,KBID,NK)
        IF (NK.NE.1) NK=-NK
        CALL WKVECT(NOMFON//'.NOVA','G V K8',NK,LNOVA)
        CALL GETVTX(' ','NOM_PARA',1,1,NK,ZK8(LNOVA),IR)
      ENDIF
C
      CALL JEDEMA()
      END
