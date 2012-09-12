      SUBROUTINE CAECHP (CHAR,LIGRCH,LIGRMO,IGREL,INEMA,NOMA,FONREE)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           IGREL, INEMA
      CHARACTER*4       FONREE
      CHARACTER*8       CHAR, NOMA
      CHARACTER*(*)     LIGRCH, LIGRMO
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 22/11/2011   AUTEUR MACOCCO K.MACOCCO 
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
C     BUT: REMPLIR LA CARTE .HECHP ET LE LIGREL DE CHARGE POUR LE MOT
C     CLE ECHANGE_PAROI
C
C ARGUMENTS D'ENTREE:
C IN   CHAR   K8  : NOM UTILISATEUR DU RESULTAT DE CHARGE
C IN   LIGRCH K19 : NOM DU LIGREL DE CHARGE
C IN   LIGRMO K19 : NOM DU LIGREL DU MODELE
C IN   IGREL  I   : NUMERO DU GREL DE CHARGE
C VAR  INEMA  I   : NUMERO  DE LA DERNIERE MAILLE TARDIVE DANS LIGRCH
C IN   NOMA   K8  : NOM DU MAILLAGE
C IN   FONREE K4  : 'FONC' OU 'REEL'
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       NBTYMX,NECHP,IBID, IERD, NBAPNO, NBALL,
     &              JNCMP, JVALV, IOCC, NH, NT, NR, NO, I, J,
     &              NBTYP, JLISTT, NBM
      PARAMETER    (NBTYMX=7)
C --- NOMBRE MAX DE TYPE_MAIL DE COUPLAGE ENTRE 2 PAROIS
      REAL*8        T(3)
      CHARACTER*8   MO, K8B
      CHARACTER*16  MOTCLF
      CHARACTER*24  LIEL, MODL, LLIST1, LLIST2, LLISTT
      CHARACTER*19  CARTE
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      MOTCLF = 'ECHANGE_PAROI'
      CALL GETFAC ( MOTCLF , NECHP )
      IF (NECHP.EQ.0) GOTO 9999
C
      LIEL = LIGRCH
      LIEL(20:24) = '.LIEL'
      MO = LIGRMO
      CALL DISMOI ( 'F','MODELISATION',MO,'MODELE',IBID,MODL,IERD)
C
      CARTE = CHAR//'.CHTH.HECHP'
      IF (FONREE.EQ.'REEL') THEN
        CALL ALCART ( 'G', CARTE, NOMA, 'COEH_R')
      ELSE IF (FONREE.EQ.'FONC') THEN
        CALL ALCART ( 'G', CARTE, NOMA, 'COEH_F')
      ELSE
        CALL U2MESK('F','MODELISA2_37',1,FONREE)
      END IF
C
C     MISE A JOUR DE LIGRCH ET STOCKAGE DANS LA CARTE
C
      CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
      NCMP = 1
      ZK8(JNCMP) = 'H'
C
      LLIST1 = '&&CAECHP.LLIST1'
      LLIST2 = '&&CAECHP.LLIST2'
      LLISTT = '&&CAECHP.LLIST.TRIE'
C
      DO 100 IOCC = 1, NECHP
C
         IF (FONREE.EQ.'REEL') THEN
            CALL GETVR8 ( MOTCLF, 'COEF_H', IOCC,1,1, ZR(JVALV) , NH )
         ELSE IF (FONREE.EQ.'FONC') THEN
            CALL GETVID ( MOTCLF, 'COEF_H', IOCC,1,1, ZK8(JVALV), NH )
         ENDIF
C
         DO 101 I = 1 , 3
            T(I) = 0.0D0
101      CONTINUE
         CALL GETVR8 ( MOTCLF, 'TRAN', IOCC,1,3, T, NT )
C
         CALL PALIMA (NOMA,MOTCLF,'GROUP_MA_1','MAILLE_1',IOCC,LLIST1)
         CALL PALIMA (NOMA,MOTCLF,'GROUP_MA_2','MAILLE_2',IOCC,LLIST2)
C
         CALL PATRMA(LLIST1,LLIST2,T,NBTYMX,NOMA,LLISTT,NBTYP)
C
         DO 200 J = 1,NBTYP
            IGREL = IGREL+1
            CALL JEVEUO(JEXNUM(LLISTT,J),'L',JLISTT)
            CALL PALIGI('THER',MODL,LIGRCH,IGREL,INEMA,ZI(JLISTT))
C
C   STOCKAGE DANS LA CARTE
C
            CALL JEVEUO ( JEXNUM(LIEL,IGREL), 'E', JLIGR )
            CALL JELIRA ( JEXNUM(LIEL,IGREL), 'LONMAX', NBM, K8B )
            NBM = NBM - 1
           CALL NOCART(CARTE,-3,' ','NUM',NBM,' ',ZI(JLIGR),LIGRCH,NCMP)
200      CONTINUE
100   CONTINUE
      CALL JEDETC (' ','&&CAECHP',1)
 9999 CONTINUE
      CALL JEDEMA()
      END
