      SUBROUTINE ADALIG(LIGRZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*24 LIGR
      CHARACTER*(*) LIGRZ
      REAL*8       TMAX,JEVTBL
C
C     BUT: REORGANISER LA COLLECTION .LIEL DE LIGR AFIN DE REGROUPER
C          LES ELEMENTS DE MEME TYPE_ELEM DANS UN MEME GREL.
C          UN GREL CONTIENT AU PLUS NBMAX ELEMENTS , SI IL Y A PLUS DE
C          NBMAX ELEMENTS DE MEME TYPE_ELEM ON LES REPARTIS DANS AUTANT
C          DE GRELS QUE NECESSAIRE.
C
C ARGUMENTS D'ENTREE:
C     LIGRZ : NOM DU LIGREL
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      IBID
      CHARACTER*1  CLAS
      CHARACTER*24 LIEL,TLIEL,TTELM,TNBELM,TNBMAX
C
      CHARACTER*8 KBID
      CALL JEMARQ()
      LIGR = LIGRZ

      TMAX=JEVTBL()
C
      LIEL=LIGR(1:19)//'.LIEL'
      CALL JEEXIN(LIEL,IRET)
      IF (IRET.EQ.0) GO TO 9999
      CALL JELIRA(LIEL,'NUTIOC',NBGREL,KBID)
      IF (NBGREL.EQ.0) GO TO 9999
C
      TLIEL = '&&ADALIG.LIEL'
      TTELM = '&&ADALIG.TELM'
      TNBELM = '&&ADALIG.TNBELM'
      TNBMAX = '&&ADALIG.TNBMAX'
C
C --- RECOPIE DE LIEL DANS TLIEL ET DESTRUCTION DE LIEL
      CALL JELIRA(LIEL,'CLAS',IBID,CLAS)
      CALL JEDUPO(LIEL,'V',TLIEL,.TRUE.)
      CALL JEDETR(LIEL)
C
C --- LECTURE DE TOUTES LES DIM DE TLIEL
      CALL JELIRA(TLIEL,'NMAXOC',NBTG,KBID)
      CALL WKVECT(TTELM,'V V I',NBTG,IDTELM)
      CALL WKVECT(TNBELM,'V V I',NBTG,IDNBE)
      CALL WKVECT(TNBMAX,'V V I',NBTG,IDNBM)
      CALL JEVEUO(TLIEL,'L',IDTLI)
      CALL JEVEUO(JEXATR(TLIEL,'LONCUM'),'L',IDLON)
      IAD = ZI(IDLON)
      NBTYPE = 0
      DO 1 I = 1,NBTG
        IADP = ZI(IDLON+I)
        NBELEM = IADP-IAD-1
        IAD = IADP
        IF (NBELEM.GT.0) THEN
          ITYPE = ZI(IDTLI-1+IADP-1)
          DO 2 J = 1,NBTYPE
            IF (ITYPE.EQ.ZI(IDTELM-1+J)) THEN
              ZI(IDNBE-1+J) = ZI(IDNBE-1+J)+ NBELEM
              GOTO 1
            ENDIF
 2        CONTINUE
          NBTYPE = NBTYPE+1
          ZI(IDTELM-1+NBTYPE) = ITYPE
          ZI(IDNBE-1+NBTYPE) = NBELEM
          ZI(IDNBM-1+NBTYPE) = MAXELE(TMAX,ITYPE)
        ENDIF
 1    CONTINUE
C
C --- CALCUL DU NOMBRE DE GRELS DU NOUVEAU .LIEL
C     ET DE LA DIM TOTALE DE LA COLLECTION
      LONT = 0
      NBGREL = 0
      DO 3 I = 1,NBTYPE
        NBEL = ZI(IDNBE-1+I)
        NBMAX = ZI(IDNBM-1+I)
        NBG = NBEL/NBMAX
        IRESTE= NBEL-NBG*NBMAX
        IF (IRESTE.GT.0) NBG=NBG+1
        NBGREL = NBGREL + NBG
        LONT = LONT + NBEL + NBG
 3    CONTINUE
C
C --- CREATION DU NOUVEAU .LIEL
      CALL JECREC(LIEL,CLAS//' V I','NU','CONTIG','VARIABLE',NBGREL)
      CALL JEECRA(LIEL,'LONT',LONT,' ')
C
C --- MISE A JOUR DES NOUVEAUX GRELS
      IGREL = 0
      DO 4 I = 1,NBTYPE
        IGREL = IGREL + 1
        ITYPE = ZI(IDTELM-1+I)
        NBMAX = ZI(IDNBM-1+I)
        NTOT = ZI(IDNBE-1+I)
        LON = MIN(NTOT , NBMAX) + 1
        CALL JECROC(JEXNUM(LIEL,IGREL))
        CALL JEECRA(JEXNUM(LIEL,IGREL),'LONMAX',LON,KBID)
        CALL JEVEUO(JEXNUM(LIEL,IGREL),'E',IDLI)
        NELEM = 0
        NTOTR = NTOT
        IADT  = ZI(IDLON)
        DO 5 J = 1, NBTG
          IADTP = ZI(IDLON+J)
          JTYPE = ZI(IDTLI-2+IADTP)
          IF (JTYPE.EQ.ITYPE) THEN
            NEL = IADTP -IADT -1
            DO 6 K = 1,NEL
              IF (NELEM.EQ.NBMAX) THEN
                ZI(IDLI+NELEM) = ITYPE
                NTOTR = NTOTR - NBMAX
                CALL ASSERT (NTOTR.GT.0)
                LON = MIN(NTOTR , NBMAX) + 1
                IGREL = IGREL + 1
                CALL JECROC(JEXNUM(LIEL,IGREL))
                CALL JEECRA(JEXNUM(LIEL,IGREL),'LONMAX',LON,KBID)
                CALL JEVEUO(JEXNUM(LIEL,IGREL),'E',IDLI)
                NELEM = 0
              ENDIF
              NELEM = NELEM + 1
              ZI(IDLI-1+NELEM) = ZI(IDTLI-1+IADT+K-1)
 6          CONTINUE
          ENDIF
          IADT = IADTP
 5      CONTINUE
        ZI(IDLI+NELEM) = ITYPE
 4    CONTINUE
      CALL ASSERT (IGREL.EQ.NBGREL)
C
C --- DESTRUCTION DES OBJETS DE TRAVAIL
      CALL JEDETR(TLIEL)
      CALL JEDETR(TTELM)
      CALL JEDETR(TNBELM)
      CALL JEDETR(TNBMAX)
 9999 CONTINUE
      CALL JEDEMA()
      END
