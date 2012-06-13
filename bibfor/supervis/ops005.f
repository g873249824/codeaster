      SUBROUTINE OPS005()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C     ------------------------------------------------------------------
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*1  KBID
      CHARACTER*8  NOMRES, NOMPAR
      CHARACTER*16 TYPRES, NOMCMD
      CHARACTER*19 NOMFON
      INTEGER      LPROL,  LNOVA,    NK,    IR
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL GETRES(NOMFON,TYPRES,NOMCMD)
C
      NOMPAR = '  '
      NOMRES = 'TOUTRESU'
      CALL WKVECT(NOMFON//'.PROL','G V K24',6,LPROL)
      ZK24(LPROL)   = 'INTERPRE'
      ZK24(LPROL+1) = 'INTERPRE'
      ZK24(LPROL+2) =  NOMPAR
      ZK24(LPROL+3) =  NOMRES
      ZK24(LPROL+4) = 'II      '
      ZK24(LPROL+5) = NOMFON
      CALL GETVTX(' ','NOM_PARA',1,IARG,1,KBID,NK)
      IF (NK.NE.1) NK=-NK
      CALL WKVECT(NOMFON//'.NOVA','G V K8',NK,LNOVA)
      CALL GETVTX(' ','NOM_PARA',1,IARG,NK,ZK8(LNOVA),IR)
C
      CALL JEDEMA()
      END
