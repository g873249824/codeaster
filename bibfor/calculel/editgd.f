      SUBROUTINE EDITGD(CHINZ,NCMP,GD,NEDIT,DG)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C TOLE CRP_6
C
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER DG(*),NCMP,GD,NEDIT
      CHARACTER*(*) CHINZ
C ----------------------------------------------------------------------
C     ENTREES:
C     CHINZ : NOM DE LA CARTE A METTRE A JOUR
C     NCMP  : NOMBRE DE CMP A STOCKER
C     GD  : GRANDEUR
C     NEDIT : NUMERO DE LA GRANDEUR EDITEE
C
C     SORTIES:
C     DG  : DESCRIPTEUR_GRANDEUR A METTRE A JOUR
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER INDIK8,IOR
C
C     VARIABLES LOCALES:
C     ------------------
      INTEGER I,J,IEC,RESTE,CODE,NCMPMX,DEB2,DEBGD
      INTEGER NOCMP,WNOCMP
      CHARACTER*8 NOMCMP,CTYPE
      CHARACTER*24 VALK
      CHARACTER*1 K1BID
      CHARACTER*19 CHIN
C
C
      CALL JEMARQ()
      CHIN=CHINZ
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K1BID)
      DEBGD = (NEDIT-1)*NCMPMX
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',NOCMP)
      CALL JEVEUO(CHIN//'.NCMP','L',WNOCMP)
C
C     -- ON COMPTE LE NOMBRE DE CMPS A NOTER REELLEMENT :
      NCMP2=0
      DO 103,I=1,NCMP
        IF (ZK8(WNOCMP-1+I)(1:1).NE.' ') NCMP2=NCMP2+1
 103  CONTINUE
C
      INDGD = 0
      ICO=0
      DO 100 I = 1,NCMPMX
         NOMCMP = ZK8(NOCMP-1+I)
         J = INDIK8(ZK8(WNOCMP),NOMCMP,1,NCMP)
         IF (J.NE.0) THEN
            ICO=ICO+1
            INDGD = INDGD + 1
            IEC = (I-1)/30 + 1
            RESTE = I - 30* (IEC-1)
            CODE = LSHIFT(1,RESTE)
            DG(IEC) = IOR(DG(IEC),CODE)
            DEB2 = DEBGD + INDGD
            CALL JEVEUO(CHIN//'.VALV','L',IAD1)
            CALL JELIRA(CHIN//'.VALV','TYPELONG',IBID,CTYPE)
            CALL JEVEUO(CHIN//'.VALE','E',IAD2)
            CALL JACOPO(1,CTYPE,IAD1+J-1,IAD2+DEB2-1)
         END IF
  100 CONTINUE
C
      IF (ICO.NE.NCMP2) THEN
         CALL U2MESS('F+','CALCULEL6_68')
         DO 101 I = 1,NCMPMX
           NOMCMP = ZK8(NOCMP-1+I)
           VALK = NOMCMP
           CALL U2MESK('F+','CALCULEL6_69',1,VALK)
  101    CONTINUE
         CALL U2MESS('F+','CALCULEL6_70')
         DO 102 I = 1,NCMP
           NOMCMP = ZK8(WNOCMP-1+I)
           VALK = NOMCMP
           CALL U2MESK('F+','CALCULEL6_71',1,VALK)
  102    CONTINUE
         CALL U2MESS('F','VIDE_1')
      ENDIF
C
      CALL JEDEMA()
      END
