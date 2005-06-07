      SUBROUTINE IRMAMA(NOMA,NBMA,NOMAI,NBGR,NOGRM,NUMMAI,NBMAT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/10/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT NONE
C
      CHARACTER*(*) NOMA,NOMAI(*),NOGRM(*),NUMMAI
      INTEGER       NBMA,NBGR,NBMAT
C ----------------------------------------------------------------------
C     BUT :   TROUVER LES NUMEROS DES MAILLES TROUVES DANS
C             UNE LISTE DE MAILLES ET DE GROUP_MA
C     ENTREES:
C        NOMA   : NOM DU MAILLAGE.
C        NBMA   : NOMBRE DE MAILLES
C        NBGR   : NOMBRE DE GROUPES DE MAILLES
C        NOMAI  : NOM DES  MAILLES
C        NOGRM  : NOM DES  GROUP_MA
C     SORTIES:
C        NBMAT  : NOMBRE TOTAL DE NOEUDS A IMPRIMER
C        NUMMAI : NOM DE L'OBJET CONTENANT LES NUMEROS
C                 DES MAILLES TROUVES.
C ----------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C     ------------------------------------------------------------------
      CHARACTER*8  NOMMA,K8BID
      INTEGER JNUMA,IMA,IAD,IN,JTOPO,IMAI,IGR,IRET,NBN,LNUMA
C
C
      CALL JEMARQ()
      NOMMA=NOMA
      NBMAT= 0
      CALL JEVEUO('&&OP0039.LIST_TOPO','E',JTOPO)
      CALL JEVEUO(NUMMAI,'E',JNUMA)
      CALL JELIRA(NUMMAI,'LONMAX',LNUMA,K8BID )

C  --- TRAITEMENT DES LISTES DE MAILLES----
      IF(NBMA.NE.0) THEN
C     --- RECUPERATION DU NUMERO DE MAILLE----
        DO 12 IMAI=1,NBMA
          CALL JENONU(JEXNOM(NOMMA//'.NOMMAI',NOMAI(IMAI)),IMA)
          IF (IMA.EQ.0) THEN
            CALL UTDEBM('A','IRMAMA',' ON NE TROUVE PAS LA MAILLE')
            CALL UTIMPK('S',' ',1,NOMAI(IMAI))
            CALL UTFINM
            NOMAI(IMAI) = ' '
          ELSE
            ZI(JTOPO-1+6) = ZI(JTOPO-1+6) + 1
            NBMAT = NBMAT + 1
            IF (NBMAT.GT.LNUMA) THEN
              LNUMA=2*LNUMA
              CALL JUVECA(NUMMAI,LNUMA)
              CALL JEVEUO(NUMMAI,'E',JNUMA)
            END IF
            ZI(JNUMA-1+NBMAT)=IMA
          ENDIF
  12    CONTINUE
      ENDIF
C  --- TRAITEMENT DES LISTES DE GROUPES DE MAILLES---
      IF(NBGR.NE.0) THEN
C     --- RECUPERATION DU NUMERO DE MAILLE----
        DO 13 IGR=1,NBGR
          CALL JEEXIN(JEXNOM(NOMMA//'.GROUPEMA',NOGRM(IGR)),IRET)
          IF (IRET.EQ.0) THEN
            CALL UTDEBM('A','IRMAMA',' ON NE TROUVE PAS LE GROUPE')
            CALL UTIMPK('S',' ',1,NOGRM(IGR))
            CALL UTFINM
            NOGRM(IGR) = ' '
          ELSE
            CALL JELIRA(JEXNOM(NOMMA//'.GROUPEMA',NOGRM(IGR)),
     +                       'LONMAX',NBN,K8BID)
            IF(NBN.EQ.0) THEN
            CALL UTDEBM('A','IRMAMA',' LE GROUPE')
            CALL UTIMPK('S',' ',1,NOGRM(IGR))
            CALL UTIMPK('S',' NE CONTIENT AUCUNE MAILLE ',0,' ')
            CALL UTFINM
            NOGRM(IGR) = ' '
            ELSE
              ZI(JTOPO-1+8) = ZI(JTOPO-1+8) + 1
              CALL JEVEUO(JEXNOM(NOMMA//'.GROUPEMA',NOGRM(IGR)),'L',IAD)
              DO 14 IN=1,NBN
                NBMAT=NBMAT+1
                IF (NBMAT.GT.LNUMA) THEN
                  LNUMA=2*LNUMA
                  CALL JUVECA(NUMMAI,LNUMA)
                  CALL JEVEUO(NUMMAI,'E',JNUMA)
                END IF
                ZI(JNUMA-1+NBMAT)=ZI(IAD+IN-1)
  14          CONTINUE
            ENDIF
          ENDIF
  13    CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
