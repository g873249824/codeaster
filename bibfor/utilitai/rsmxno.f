      INTEGER FUNCTION RSMXNO(NOMSD)
      IMPLICIT NONE
      CHARACTER*(*) NOMSD
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C      RENVOIE LA VALEUR MAXIMALE DU NUMERO D'ORDRE (IORDR)
C ----------------------------------------------------------------------
C IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      CHARACTER*19 NOMD2
      CHARACTER*1 K1BID
      INTEGER NBORDR,JORDR,K,IVAL
C ----------------------------------------------------------------------
      CALL JEMARQ()
      IVAL = 0
      NOMD2 = NOMSD
C
      CALL JELIRA(NOMD2//'.ORDR','LONUTI',NBORDR,K1BID)
      IF (NBORDR.GT.0) THEN
        CALL JEVEUO(NOMD2//'.ORDR','L',JORDR)
        IVAL = ZI(JORDR)
        DO 10 K=1,NBORDR
          IVAL = MAX (IVAL,ZI(JORDR+K-1))
   10   CONTINUE
      ENDIF
      RSMXNO = IVAL
C
      CALL JEDEMA()
      END
