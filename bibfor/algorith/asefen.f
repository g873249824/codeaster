      SUBROUTINE ASEFEN(NOMSY,ID,STAT,NEQ,NBSUP,NDIR,
     &           NSUPP,MASSE,NOMSUP, DEPSUP,ZRCREP )
      IMPLICIT  REAL*8 (A-H,O-Z)
      INTEGER           NSUPP(*),NDIR(*)
      REAL*8            DEPSUP(NBSUP,*),ZRCREP(NBSUP,NEQ,*)
      CHARACTER*(*)     STAT,NOMSUP(NBSUP,*),MASSE
      CHARACTER*16      NOMSY
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     COMMANDE : COMB_SISM_MODAL
C        CALCUL DES TERMES D'ENTRAINEMENT
C     ------------------------------------------------------------------
C IN  : NOMSY  : OPTION DE CALCUL
C IN  : ID     : LA DIRECTION
C IN  : STAT   : MODE STATIQUES
C IN  : NEQ    : NOMBRE D'EQUATIONS
C IN  : NBSUP  : NOMBRE DE SUPPORTS
C IN  : NSUPP  : MAX DU NOMBRE DE SUPPORT PAR DIRECTION
C IN  : NOMSUP : VECTEUR DES NOMS DES SUPPORTS
C OUT  : DEPSUP : VECTEUR DES DEPLACEMENTS DES SUPPORTS
C OUT : ZRCREP : VECTEUR DES RECOMBINAISONS MODALES
C     ------------------------------------------------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*24 OBJ1, OBJ2
      CHARACTER*1  K1BID
      CHARACTER*8  K8B, NOEU, CMP, NOMCMP(3),NOMA,GRNOEU
      CHARACTER*8  NOEREF
      CHARACTER*16 MONACC
      CHARACTER*19 CHEXTR,MOTFAC
      COMPLEX*16   CBID
C     ------------------------------------------------------------------
      DATA  NOMCMP / 'DX' , 'DY' , 'DZ' /
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL DISMOI('F','NOM_MAILLA',MASSE,'MATR_ASSE',IBID,NOMA,IRET)
      OBJ1 = NOMA//'.GROUPENO'
      OBJ2 = NOMA//'.NOMNOE'
      INORF =0
C
      MOTFAC ='DEPL_MULT_APPUI'
      CALL  GETFAC(MOTFAC,NCAS)
      DO 2 IOC = 1,NCAS
        CALL GETVID(MOTFAC,'NOEUD_REFE',IOC,1,1,NOEREF,NNR)
         IF (NNR.NE.0) INORF = 1
         CALL GETVID(MOTFAC,'NOEUD',IOC,1,0,NOEU,NN)
         IF (NN.NE.0) THEN
            NNO = -NN
            CALL WKVECT('&&ASEFEN.NOEUD','V V K8',NNO,JNOE)
            CALL GETVID(MOTFAC,'NOEUD',IOC,1,NNO,ZK8(JNOE),NN)
            CALL GETVR8(MOTFAC,'DX',IOC,1,1,DX,NX)
            CALL GETVR8(MOTFAC,'DY',IOC,1,1,DY,NY)
            CALL GETVR8(MOTFAC,'DZ',IOC,1,1,DZ,NZ)
            DO 22 INO = 1, NNO
               NOEU = ZK8(JNOE+INO-1)
               CALL JENONU(JEXNOM(OBJ2,NOEU),IRET)
               IF (IRET.EQ.0) THEN
                  IER = IER + 1
                  CALL UTMESS('E',MOTFAC,'LE NOEUD '//NOEU//
     &                        ' N''APPARTIENT PAS AU MAILLAGE : '//NOMA)
C        CALL U2MESK('E','ALGORITH_21', 2 ,VALK)
                  GOTO 22
               ENDIF
               IF (NX.NE.0) THEN
                  DO 72 IS = 1,NSUPP(1)
                     IF (NOMSUP(IS,1).EQ.NOEU) DEPSUP(IS,1) = DX
 72               CONTINUE
               ENDIF
               IF (NY.NE.0) THEN
                  DO 74 IS = 1,NSUPP(2)
                     IF (NOMSUP(IS,2).EQ.NOEU) DEPSUP(IS,2) = DY
 74               CONTINUE
               ENDIF
               IF (NZ.NE.0) THEN
                  DO 76 IS = 1,NSUPP(3)
                     IF (NOMSUP(IS,3).EQ.NOEU) DEPSUP(IS,3) = DZ
 76               CONTINUE
               ENDIF
 22         CONTINUE
            CALL JEDETR('&&ASEFEN.NOEUD')
         ELSE
            CALL GETVID(MOTFAC,'GROUP_NO',IOC,1,0,K8B,NG)
            NGR = -NG
            CALL WKVECT('&&ASEFEN.GROUP_NO','V V K8',NGR,JGRN)
            CALL GETVID(MOTFAC,'GROUP_NO',IOC,1,NGR,ZK8(JGRN),NG)
            CALL GETVR8(MOTFAC,'DX',IOC,1,1,DX,NX)
            CALL GETVR8(MOTFAC,'DY',IOC,1,1,DY,NY)
            CALL GETVR8(MOTFAC,'DZ',IOC,1,1,DZ,NZ)
            DO 26 IGR = 1, NGR
               GRNOEU = ZK8(JGRN+IGR-1)
               CALL JEEXIN(JEXNOM(OBJ1,GRNOEU),IRET)
               IF (IRET .EQ. 0) THEN
                  IER = IER + 1
                  CALL UTMESS('E',MOTFAC,'LE GROUPE '//GRNOEU//
     &                        ' N''APPARTIENT PAS AU MAILLAGE : '//NOMA)
C        CALL U2MESK('E','ALGORITH_22', 2 ,VALK)
                  GOTO 26
               ELSE
                  CALL JELIRA(JEXNOM(OBJ1,GRNOEU),'LONMAX',NN,K1BID)
                  CALL JEVEUO(JEXNOM(OBJ1,GRNOEU),'L',JDGN)
                  DO 28 INO = 1, NN
                     CALL JENUNO(JEXNUM(OBJ2,ZI(JDGN+INO-1)),NOEU)
                     IF (NX.NE.0) THEN
                        DO 82 IS = 1,NSUPP(1)
                           IF (NOMSUP(IS,1).EQ.NOEU) DEPSUP(IS,1) = DX
 82                     CONTINUE
                     ENDIF
                     IF (NY.NE.0) THEN
                        DO 84 IS = 1,NSUPP(2)
                           IF (NOMSUP(IS,2).EQ.NOEU) DEPSUP(IS,2) = DY
 84                     CONTINUE
                     ENDIF
                     IF (NZ.NE.0) THEN
                        DO 86 IS = 1,NSUPP(3)
                           IF (NOMSUP(IS,3).EQ.NOEU) DEPSUP(IS,3) = DZ
 86                     CONTINUE
                     ENDIF
 28               CONTINUE
               ENDIF
 26         CONTINUE
            CALL JEDETR('&&ASEFEN.GROUP_NO')
         ENDIF
 20   CONTINUE

      IF (INORF.NE.0) THEN
         CALL JENONU(JEXNOM(OBJ2,NOEREF),IRE1)
         CALL JEEXIN(JEXNOM(OBJ1,NOEREF),IRE2)
         IF ((IRE1+IRE2).EQ.0) THEN
            IER = IER + 1
            CALL UTMESS('E',MOTFAC,'LE NOEUD '//NOEREF//
     &                        ' N''APPARTIENT PAS AU MAILLAGE : '//NOMA)
C        CALL U2MESK('E','ALGORITH_21', 2 ,VALK)
            GOTO 9999
         ENDIF
         IF (IRE2.NE.0) THEN
            CALL JEVEUO(JEXNOM(OBJ1,NOEREF),'L',JDGN)
            CALL JENUNO(JEXNUM(OBJ2,ZI(JDGN)),NOEREF)
         ENDIF
         DO 90 IDI = 1,3
            IF (NDIR(IDI).EQ.1) THEN
               DO 92 IS = 1,NSUPP(IDI)
                  IF (NOMSUP(IS,IDI).EQ.NOEREF) THEN
                      DO 94 IN = 1,NSUPP(IDI)
                        DEPSUP(IN,IDI) = DEPSUP(IN,IDI) - DEPSUP(IS,IDI)
 94                   CONTINUE
                      GOTO 90
                  ENDIF
 92            CONTINUE
               IER = IER + 1
               CALL U2MESK('E','ALGORITH_23',1,NOEREF)
               GOTO 9999
            ENDIF
 90      CONTINUE
      ENDIF
C
 2    CONTINUE

      CMP = NOMCMP(ID)
      DO 10 IS = 1,NSUPP(ID)
         NOEU   = NOMSUP(IS,ID)
         MONACC = NOEU//CMP
         XX1    = DEPSUP(IS,ID)
         CALL RSORAC(STAT,'NOEUD_CMP',IBID,R8B,MONACC,CBID,R8B,K8B,
     &                                                  IORDR,1,NBTROU)
         CALL RSEXCH(STAT,NOMSY,IORDR,CHEXTR,IRET)
         CALL JEEXIN(CHEXTR//'.VALE',IBID)
         IF (IBID.GT.0) THEN
           CALL JEVEUO(CHEXTR//'.VALE','L',JVALE)
         ELSE
           CALL JEVEUO(CHEXTR//'.CELV','L',JVALE)
         END IF
         DO 12 IN = 1,NEQ
            XXX = ZR(JVALE+IN-1) * XX1
            ZRCREP(IS,IN,ID) = ZRCREP(IS,IN,ID) + XXX*XXX
 12     CONTINUE
 10   CONTINUE
C
 9999 CONTINUE

      CALL JEDETC('V','&&ASEFEN',1)
      CALL JEDEMA()
      END
