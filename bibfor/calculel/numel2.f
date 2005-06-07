      SUBROUTINE NUMEL2 ( CHAM, IMA, IGREL, IEL )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       CHAM
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
C
C IN  : CHAM   : NOM D'UN CHAMP GD
C IN  : IMA    : NUMERO D'UNE MAILLE
C OUT : IGREL  : NUMERO DU GREL OU ON TROUVE LA MAILLE IMA
C OUT : IEL    : NUMERO DE L'ELEMENT DANS LE GREL.
C
C     SI ON NE TROUVE PAS LA MAILLE, ON REND IGREL=IEL=0
C ----------------------------------------------------------------------
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
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CHARACTER*8  K8B
      CHARACTER*19 CHAM19, NOLIGR
C
      CALL JEMARQ()
      IGREL=0
      IEL=0
      CHAM19 = CHAM
      CALL JEVEUO(CHAM19//'.CELK','L',IACELK)
      NOLIGR = ZK24(IACELK)(1:19)
C
      CALL JELIRA(NOLIGR//'.LIEL','NUTIOC',NBGREL,K8B)
      DO 10 IGR = 1 , NBGREL
         CALL JELIRA(JEXNUM(NOLIGR//'.LIEL',IGR),'LONMAX',NEL,K8B)
         CALL JEVEUO(JEXNUM(NOLIGR//'.LIEL',IGR),'L',IALIEL)
         DO 20 I = 1 , NEL-1
            IF (ZI(IALIEL-1+I).EQ.IMA) THEN
               IGREL = IGR
               IEL = I
               GOTO 9999
            ENDIF
 20      CONTINUE
 10   CONTINUE
C
 9999 CONTINUE
      CALL JEDEMA()
      END
