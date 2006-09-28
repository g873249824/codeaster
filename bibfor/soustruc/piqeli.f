      SUBROUTINE PIQELI ( MAILLA )
      IMPLICIT   NONE
      CHARACTER*8         MAILLA
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     OPERATEUR: "DEFI_GROUP" , MOTCLE FACTEUR "EQUE_PIQUA"
C     ELIMINE LES NOEUDS EN DOUBLE:
C             SURFACE S_LAT1  AVEC S_LAT2
C             SURFACE S_FOND1 AVEC S_FOND2
C
C-----------------------------------------------------------------------
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
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C-----------------------------------------------------------------------
C
      INTEGER       NBMA, JMAIL, IMA, INUMA, NBPT, JPOIN, INO, INOV,
     &              NBNO, JGRN1, JGRN2, JVI1, JVI2, IRET, NBGMA, IGR
      INTEGER       NBNO3, NBNO4, NBNOR, JGRNR, INO1, INO2, I, NB1, NB2
      INTEGER       NUMNO(10), INC, NBNOR2, JGRNR2, NBGNO, NBNO2,
     &              JGG, JVG

      CHARACTER*8   K8B, NOMGRM, NOGRN1, NOGRN2
      CHARACTER*8   NOGRN3, NOGRN4, NOGRNR, NOMGNO
      INTEGER       IN,NBNOMS
      PARAMETER    (NBNOMS=8)
      CHARACTER*8   NOMS1(NBNOMS),NOMS2(NBNOMS)
      CHARACTER*24  GRPMAI, GRPNOE, CONNEX, LISO1, LISO2, LISO3,GRPNOV
      LOGICAL       RECOSF
      CHARACTER*1   K1BID
      REAL*8        DMIN0
C
      DATA NOMS1 / 'S_LAT1','S_LAT1_C','S_LAT1_T','S_FOND1',
     &             'S_LAT1_C','S_LAT1_C','S_LAT1_C','S_LAT1_C' /
      DATA NOMS2 / 'S_LAT2','S_LAT2_C','S_LAT2_T','S_FOND2',
     &             'S_FOND1','S_FOND2','S_FOND1','S_FOND2' /
C     ------------------------------------------------------------------
C
      CALL JEMARQ ( )
C
      GRPMAI = MAILLA//'.GROUPEMA       '
      GRPNOE = MAILLA//'.GROUPENO       '
      CONNEX = MAILLA//'.CONNEX         '
      GRPNOV  = '&&PIQELI'//'.GROUPENO       '
      LISO1 = '&&PIQELI.NOEUD_1'
      LISO2 = '&&PIQELI.NOEUD_2'
      LISO3 = '&&PIQELI.NOEUD_3'
C
      CALL JELIRA(MAILLA//'.GROUPEMA','NOMUTI',NBGMA,K8B)
C
C
C --- CORRECTION DES GROUPES DE NOEUDS S_FOND1 ET S_FOND2 APRES
C     RECOLLEMENT DES AUTRES GROUPES DE NOEUDS
C     PREPARATION DES DONNEES
C
      NOGRN3 =  NOMS1(4)
      NOGRN4 =  NOMS2(4)
      RECOSF = .FALSE.
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN3), IRET )
      IF ( IRET .EQ. 0 ) RECOSF = .FALSE.
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN4), IRET )
      IF ( IRET .EQ. 0 ) RECOSF = .FALSE.
      CALL JELIRA ( JEXNOM(GRPNOE,NOGRN3), 'LONMAX', NBNO3, K8B )
      CALL JELIRA ( JEXNOM(GRPNOE,NOGRN4), 'LONMAX', NBNO4, K8B )
      IF(NBNO3.LE.NBNO4) THEN
         RECOSF = .TRUE.
         NOGRNR = NOGRN4
         NBNOR = NBNO4
         CALL JEVEUO ( JEXNOM(GRPNOE,NOGRNR), 'L', JGRNR )
      ENDIF
      IF(NBNO4.LE.NBNO3) THEN
         RECOSF = .TRUE.
         NOGRNR = NOGRN3
         NBNOR = NBNO3
         CALL JEVEUO ( JEXNOM(GRPNOE,NOGRNR), 'L', JGRNR )
      ENDIF
C
C --- ELIMINATION SUR LES GROUPES DE MAILLES
C
      DO 300 IN=1,4
      NOGRN1 =  NOMS1(IN)
      NOGRN2 =  NOMS2(IN)
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN1), IRET )
      IF ( IRET .EQ. 0 ) GOTO 300
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN2), IRET )
      IF ( IRET .EQ. 0 ) GOTO 300
      CALL JELIRA ( JEXNOM(GRPNOE,NOGRN1), 'LONMAX', NBNO, K8B )
      CALL JEVEUO ( JEXNOM(GRPNOE,NOGRN1), 'L', JGRN1 )
      CALL JEVEUO ( JEXNOM(GRPNOE,NOGRN2), 'L', JGRN2 )
      CALL PACOA1 ( ZI(JGRN1), ZI(JGRN2), NBNO, MAILLA, LISO1, LISO2 )
      CALL JEVEUO ( LISO1, 'L', JVI1 )
      CALL JEVEUO ( LISO2, 'L', JVI2 )
C
      DO 100 IGR = 1 , NBGMA
         CALL JENUNO(JEXNUM(GRPMAI,IGR),NOMGRM)
         CALL JELIRA ( JEXNOM(GRPMAI,NOMGRM), 'LONMAX', NBMA, K8B )
         CALL JEVEUO ( JEXNOM(GRPMAI,NOMGRM), 'E', JMAIL )
         DO 200 IMA = 1, NBMA
            INUMA = ZI(JMAIL+IMA-1)
            CALL JELIRA ( JEXNUM(CONNEX,INUMA), 'LONMAX', NBPT, K8B )
            CALL JEVEUO ( JEXNUM(CONNEX,INUMA), 'E', JPOIN )
            DO 202 INO = 1 , NBPT
               DO 204 INOV = 1 , NBNO
                  IF ( ZI(JVI2+INOV-1) .EQ. ZI(JPOIN+INO-1) ) THEN
                     ZI(JPOIN+INO-1) = ZI(JVI1+INOV-1)
                  ENDIF
 204           CONTINUE
 202        CONTINUE
 200     CONTINUE
 100  CONTINUE
C
C --- CORRECTION DES GROUPES DE NOEUDS S_FOND1 ET S_FOND2 APRES
C     RECOLLEMENT DES AUTRES GROUPES DE NOEUDS
C
      IF(RECOSF) THEN
         INC = 0
         DO 400 INO = 1 , NBNOR
            DO 401 INO1 = 1 , NBNO
               IF(ZI(JGRNR+INO-1).EQ.ZI(JVI1+INO1-1)) THEN
                  DO 402 I = 1 , NBNOR
                     IF(ZI(JGRNR+I-1).EQ.ZI(JVI2+INO1-1)) THEN
                        INC = INC + 1
                        IF(INC.GT.10) THEN
                          CALL U2MESS('F','MODELISA_67')
                        ENDIF
                        NUMNO(INC) = ZI(JVI2+INO1-1)
                     ENDIF
 402              CONTINUE
               ENDIF
 401        CONTINUE
 400     CONTINUE
C
C
         IF(INC.GT.0) THEN
            INO2 = 0
            NBNOR2 = NBNOR - INC
            CALL WKVECT (LISO3,'V V I',NBNOR2,JGRNR2)
            DO 404 INO = 1 , NBNOR
               DO 405 INO1 = 1 , INC
                  IF(NUMNO(INO1).EQ.ZI(JGRNR+INO-1)) GOTO 404
 405           CONTINUE
               INO2  = INO2 + 1
               ZI(JGRNR2+INO2-1) = ZI(JGRNR+INO-1)
 404        CONTINUE
C
            CALL JELIRA (GRPNOE,'NOMUTI',NBGNO,K1BID)
            CALL JEDUPO (GRPNOE,'V',GRPNOV,.FALSE.)
            CALL JEDETR (GRPNOE)
            CALL JECREC(GRPNOE,'G V I','NOM','DISPERSE',
     &                 'VARIABLE',NBGNO)
            DO 408 I = 1 , NBGNO
               CALL JENUNO(JEXNUM(GRPNOV,I),NOMGNO)
               CALL JELIRA(JEXNUM(GRPNOV,I),'LONMAX',NBNO2,K1BID)
               CALL JEVEUO(JEXNUM(GRPNOV,I),'L',JVG)
C
               IF(NOMGNO.NE.NOGRNR) THEN
                  CALL JECROC(JEXNOM(GRPNOE,NOMGNO))
                  CALL JEECRA(JEXNOM(GRPNOE,NOMGNO),'LONMAX',NBNO2,' ')
                  CALL JEVEUO(JEXNOM(GRPNOE,NOMGNO),'E',JGG)
                  DO 406 INO = 0 , NBNO2-1
                     ZI(JGG+INO) = ZI(JVG+INO)
 406              CONTINUE
               ELSE
                  CALL JECROC(JEXNOM(GRPNOE,NOGRNR))
                  CALL JEECRA(JEXNOM(GRPNOE,NOGRNR),'LONMAX',NBNOR2,' ')
                  CALL JEVEUO(JEXNOM(GRPNOE,NOGRNR),'E',JGRNR)
                  DO 407 INO = 1 , NBNOR2
                     ZI(JGRNR+INO-1) = ZI(JGRNR2+INO-1)
 407              CONTINUE
              ENDIF
 408        CONTINUE
         ENDIF
      ENDIF
C
  300 CONTINUE
C
C --- ELIMINATION SUR LES GROUPES DE MAILLES
C
      DO 800 IN=5,8
      NOGRN1 =  NOMS1(IN)
      NOGRN2 =  NOMS2(IN)
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN1), IRET )
      IF ( IRET .EQ. 0 ) GOTO 800
      CALL JEEXIN ( JEXNOM(GRPNOE,NOGRN2), IRET )
      IF ( IRET .EQ. 0 ) GOTO 800
      CALL JELIRA ( JEXNOM(GRPNOE,NOGRN1), 'LONMAX', NB1, K8B )
      CALL JELIRA ( JEXNOM(GRPNOE,NOGRN2), 'LONMAX', NB2, K8B )
      CALL JEVEUO ( JEXNOM(GRPNOE,NOGRN1), 'L', JGRN1 )
      CALL JEVEUO ( JEXNOM(GRPNOE,NOGRN2), 'L', JGRN2 )
      DMIN0 = 0.01D0
      CALL PACOA3 ( ZI(JGRN1), ZI(JGRN2), NB1, NB2, DMIN0, MAILLA,
     &  LISO1, LISO2, NBNO )
      CALL JEVEUO ( LISO1, 'L', JVI1 )
      CALL JEVEUO ( LISO2, 'L', JVI2 )
C
      DO 600 IGR = 1 , NBGMA
         CALL JENUNO(JEXNUM(GRPMAI,IGR),NOMGRM)
         CALL JELIRA ( JEXNOM(GRPMAI,NOMGRM), 'LONMAX', NBMA, K8B )
         CALL JEVEUO ( JEXNOM(GRPMAI,NOMGRM), 'E', JMAIL )
         DO 500 IMA = 1, NBMA
            INUMA = ZI(JMAIL+IMA-1)
            CALL JELIRA ( JEXNUM(CONNEX,INUMA), 'LONMAX', NBPT, K8B )
            CALL JEVEUO ( JEXNUM(CONNEX,INUMA), 'E', JPOIN )
            DO 502 INO = 1 , NBPT
               DO 504 INOV = 1 , NBNO
                  IF ( ZI(JVI2+INOV-1) .EQ. ZI(JPOIN+INO-1) ) THEN
                     ZI(JPOIN+INO-1) = ZI(JVI1+INOV-1)
                  ENDIF
 504           CONTINUE
 502        CONTINUE
 500     CONTINUE
 600  CONTINUE
C
  800 CONTINUE

      CALL JEDETR ( LISO1 )
      CALL JEDETR ( LISO2 )
      CALL JEDETR ( LISO3 )
      CALL JEDETR ( GRPNOV )
C
      CALL JEDEMA ( )
C
      END
