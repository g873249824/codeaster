      SUBROUTINE CAFTHM (CHAR, LIGRMO, NOMA, FONREE )
      IMPLICIT      NONE
      CHARACTER*4   FONREE
      CHARACTER*8   CHAR, NOMA
      CHARACTER*(*) LIGRMO
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C ======================================================================
C MODIF MODELISA  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE GRANET
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
C
C BUT : STOCKAGE DES FLUX THERMO-HYDRAULIQUES DANS UNE CARTE ALLOUEE
C       SUR LE LIGREL DU MODELE (MODELISATIONS THM)
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      LIGRMO : NOM DU LIGREL DE MODELE
C      NOMA   : NOM DU MAILLAGE
C      FONREE : FONC OU REEL
C ======================================================================
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C ======================================================================
      INTEGER       IBID, N1, N2, N3, NFLUX, JVALV, JNCMP, IOCC
      INTEGER       NBTOU, NBMA, JMA, IER, NCMP
      CHARACTER*8   K8B, MOD, TYPMCL(2)
      CHARACTER*16  MOTCLF, MOTCLE(2), MODELI
      CHARACTER*19  CARTE
      CHARACTER*24  MESMAI
      INTEGER      IARG
C ======================================================================
      CALL JEMARQ()
C
      MOTCLF = 'FLUX_THM_REP'
      CALL GETFAC ( MOTCLF, NFLUX )
C
      MOD = LIGRMO(1:8)
      CALL DISMOI('F','MODELISATION',MOD,'MODELE',IBID,MODELI,IER)
C
      CARTE = CHAR//'.CHME.FLUX '
C
      IF (FONREE.EQ.'REEL') THEN
         CALL ALCART ( 'G', CARTE, NOMA, 'FTHM_R')
      ELSE IF (FONREE.EQ.'FONC') THEN
         CALL ALCART ( 'G', CARTE, NOMA, 'FTHM_F')
      ELSE
         CALL U2MESK('F','MODELISA2_37',1,FONREE)
      END IF
C
      CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
C
C --- STOCKAGE DE FORCES NULLES SUR TOUT LE MAILLAGE
C
      NCMP = 3
      ZK8(JNCMP)   = 'PFLU1'
      ZK8(JNCMP+1) = 'PFLU2'
      ZK8(JNCMP+2) = 'PTHER'
C
      IF (FONREE.EQ.'REEL') THEN
         ZR(JVALV)   = 0.D0
         ZR(JVALV+1) = 0.D0
         ZR(JVALV+2) = 0.D0
      ELSE
         ZK8(JVALV)   = '&FOZERO'
         ZK8(JVALV+1) = '&FOZERO'
         ZK8(JVALV+2) = '&FOZERO'
      ENDIF
      CALL NOCART ( CARTE, 1, ' ', 'NOM', 0, ' ', 0, LIGRMO, NCMP )
C
      MESMAI = '&&CAFTHM.MAILLES_INTE'
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
C --- STOCKAGE DANS LA CARTE
C
      DO 10 IOCC = 1, NFLUX
         IF (FONREE.EQ.'REEL') THEN
            CALL GETVR8 (MOTCLF, 'FLUN_HYDR1',IOCC,IARG,1,ZR(JVALV),N1)
            CALL GETVR8 (MOTCLF,'FLUN_HYDR2',IOCC,IARG,1,
     &                   ZR(JVALV+1),N2)
            CALL GETVR8 (MOTCLF,'FLUN',IOCC,IARG,1,
     &                   ZR(JVALV+2),N3)
         ELSE
            CALL GETVID(MOTCLF, 'FLUN_HYDR1',IOCC,IARG,1,ZK8(JVALV),N1)
            CALL GETVID(MOTCLF,'FLUN_HYDR2',IOCC,IARG,1,
     &                  ZK8(JVALV+1),N2)
            CALL GETVID(MOTCLF,'FLUN',IOCC,IARG,1,
     &                  ZK8(JVALV+2),N3)
         END IF
C
C --- TEST SUR LES CAL
C
C
         CALL GETVTX ( MOTCLF, 'TOUT', IOCC,IARG, 1, K8B, NBTOU )
C
         IF ( NBTOU .NE. 0 ) THEN
C
            CALL NOCART ( CARTE, 1, ' ', 'NOM', 0, ' ', 0,LIGRMO, NCMP)
         ELSE
            CALL RELIEM(LIGRMO, NOMA, 'NU_MAILLE', MOTCLF, IOCC, 2,
     &                                  MOTCLE, TYPMCL, MESMAI, NBMA )
            IF (NBMA.EQ.0) GOTO 10
            CALL JEVEUO ( MESMAI, 'L', JMA )
            CALL NOCART ( CARTE,3,K8B,'NUM',NBMA,K8B,ZI(JMA),' ',NCMP)
            CALL JEDETR ( MESMAI )
         ENDIF
C
 10   CONTINUE
C
      CALL JEDEMA()
      END
