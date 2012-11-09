      SUBROUTINE ADALIG(LIGRZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXATR
      CHARACTER*24 LIGR
      CHARACTER*(*) LIGRZ
C
C BUT: REORGANISER LA COLLECTION .LIEL DE LIGR AFIN DE REGROUPER
C      LES ELEMENTS DE MEME TYPE_ELEM DANS UN MEME GREL.
C DE PLUS, ON VEUT :
C   * LIMITER LA TAILLE DES GRELS (PAS PLUS DE N ELEMENTS)
C   * FAIRE EN SORTE QUE L'EQUILIBRAGE SOIT BON SI
C     PARALLELISME='GROUP_ELEM' :
C     POUR CHAQUE TYPE_ELEMENT :
C       ON DECOUPE LE PAQUET EN 1 NOMBRE DE GRELS MULTIPLE DE NBPROC
C       LES GRELS ONT TOUS LE MEME NOMBRE D'ELEMENTS (A 1 PRES)
C       LES SOUS-PAQUETS SONT CONSECUTIFS DANS LE LIGREL
C     AU TOTAL, LE NOMBRE TOTAL DE GRELS EST UN MULTIPLE DE NBPROC
C
C ARGUMENTS D'ENTREE:
C     LIGRZ : NOM DU LIGREL
C
C
C
C
      CHARACTER*1  CLAS
      CHARACTER*24 LIEL,TLIEL
      CHARACTER*8 KBID
      INTEGER I,IRET,NBTG,IAD,IADP,IADT,IADTP,JLIEL,JTLIE2,JNTEUT
      INTEGER JTEUT,JTLIEL,IGREL,ITYPE,J,JTYPE
      INTEGER NBEL,NBELEM,NBG,NBGREL,NBTYPE,NEL,NELEM,NTOT
      INTEGER NBELMX,RANG,NBPROC,NP1,NSPAQ,NBELGR,IGRE2
      INTEGER KTYPE,JGTEUT,K,NBELGV,LONT,IBID
      REAL*8  JEVTBL

      CALL JEMARQ()

      CALL MPICM0(RANG,NBPROC)
      LIGR = LIGRZ
      LIEL=LIGR(1:19)//'.LIEL'
      CALL JEEXIN(LIEL,IRET)
      IF (IRET.EQ.0) GO TO 9999
      CALL JELIRA(LIEL,'NUTIOC',NBGREL,KBID)
      IF (NBGREL.EQ.0) GO TO 9999


      TLIEL = '&&ADALIG.LIEL'


C --- RECOPIE DE LIEL DANS TLIEL ET DESTRUCTION DE LIEL
      CALL JELIRA(LIEL,'CLAS',IBID,CLAS)
      CALL JEDUPO(LIEL,'V',TLIEL,.TRUE.)
      CALL JEDETR(LIEL)


      CALL JELIRA(TLIEL,'NMAXOC',NBTG,KBID)

C     -- 3 OBJETS DE TRAVAIL (SUR-DIMENSIONNES) :
C     .TEUT  : LISTE DES TYPE_ELEM UTILISES DANS LE LIGREL
C     .NTEUT : NOMBRE TOTAL D'ELEMENTS DU LIGREL (PAR TYPE_ELEM)
C     .GTEUT : NOMBRE DE GRELS DU LIGREL (PAR TYPE_ELEM)
      CALL WKVECT('&&ADALIG.TEUT','V V I',NBTG,JTEUT)
      CALL WKVECT('&&ADALIG.NTEUT','V V I',NBTG,JNTEUT)
      CALL WKVECT('&&ADALIG.GTEUT','V V I',NBTG,JGTEUT)

      CALL JEVEUO(TLIEL,'L',JTLIEL)
      CALL JEVEUO(JEXATR(TLIEL,'LONCUM'),'L',JTLIE2)
      IAD = ZI(JTLIE2)
      NBTYPE = 0
      DO 1 I = 1,NBTG
        IADP = ZI(JTLIE2+I)
        NBELEM = IADP-IAD-1
        IAD = IADP
        IF (NBELEM.GT.0) THEN
          ITYPE = ZI(JTLIEL-1+IADP-1)
          DO 2 J = 1,NBTYPE
            IF (ITYPE.EQ.ZI(JTEUT-1+J)) THEN
              ZI(JNTEUT-1+J) = ZI(JNTEUT-1+J)+ NBELEM
              GOTO 1
            ENDIF
 2        CONTINUE
          NBTYPE = NBTYPE+1
          ZI(JTEUT-1+NBTYPE) = ITYPE
          ZI(JNTEUT-1+NBTYPE) = NBELEM
        ENDIF
 1    CONTINUE


C --- CALCUL DU NOMBRE DE GRELS DU NOUVEAU .LIEL
C     ET DE LA DIM TOTALE DE LA COLLECTION
      LONT = 0
      NBGREL = 0
      NBELMX = INT(JEVTBL('TAILLE_GROUP_ELEM'))
      DO 3 KTYPE = 1,NBTYPE
        NBEL = ZI(JNTEUT-1+KTYPE)

        NSPAQ=(NBEL/NBPROC)/NBELMX
        CALL ASSERT((NSPAQ*NBPROC*NBELMX.LE.NBEL))
        IF (NSPAQ*NBPROC*NBELMX.LT.NBEL) NSPAQ=NSPAQ+1
        NBG = NSPAQ*NBPROC
        ZI(JGTEUT-1+KTYPE) = NBG
        NBGREL = NBGREL + NBG
        LONT = LONT + NBEL + NBG
 3    CONTINUE
      CALL ASSERT((NBGREL/NBPROC)*NBPROC.EQ.NBGREL)


C     -- ALLOCATION DU NOUVEAU .LIEL
C     ------------------------------------
      CALL JECREC(LIEL,CLAS//' V I','NU','CONTIG','VARIABLE',NBGREL)
      CALL JEECRA(LIEL,'LONT',LONT,' ')
      IGREL=0
      DO 41 KTYPE = 1,NBTYPE
        ITYPE = ZI(JTEUT-1+KTYPE)
        NTOT = ZI(JNTEUT-1+KTYPE)
        NBG = ZI(JGTEUT-1+KTYPE)
        NBELGR=NTOT/NBG
C       -- ATTENTION : POUR LES PETITS GRELS, IL PEUT ARRIVER QUE
C          NBELGR=0 (SI NBPROC > NTOT)
C          IL Y AURA ALORS DES GRELS VIDES

C       -- LE NOMBRE D'ELEMENTS PAR GREL SERA NBELGR OU NBELGR+1
C       -- LES NP1 1ERS GREL DE KTYPE AURONT NBELGR+1 ELEMENTS
C          LES AUTRES AURONT NBELGR ELEMENTS
        NP1=NTOT-NBG*NBELGR
        CALL ASSERT(NP1.LT.NBG)
        DO 42 K = 1,NBG
          NBELGV=NBELGR
          IF (K.LE.NP1) NBELGV=NBELGV+1
          CALL JECROC(JEXNUM(LIEL,IGREL+K))
          CALL JEECRA(JEXNUM(LIEL,IGREL+K),'LONMAX',NBELGV+1,KBID)
          CALL JEVEUO(JEXNUM(LIEL,IGREL+K),'E',JLIEL)
          ZI(JLIEL+NBELGV) = ITYPE
 42     CONTINUE
        IGREL=IGREL+NBG
 41   CONTINUE
      CALL ASSERT(NBGREL.EQ.IGREL)


C     -- REMPLISSAGE DES NOUVEAUX GRELS
C     ------------------------------------
      IGREL = 0
      DO 4 KTYPE = 1,NBTYPE
        ITYPE = ZI(JTEUT-1+KTYPE)
        NTOT = ZI(JNTEUT-1+KTYPE)
        NBG = ZI(JGTEUT-1+KTYPE)
        NBELGR=NTOT/NBG
        NP1=NTOT-NBG*NBELGR
        CALL ASSERT(NP1.LT.NBG)

        IGRE2=1
        NBELGV=NBELGR
        IF (IGRE2.LE.NP1) NBELGV=NBELGV+1
        CALL JEVEUO(JEXNUM(LIEL,IGREL+IGRE2),'E',JLIEL)
        NELEM = 0

C       -- ON REMPLIT LES NOUVEAUX GRELS AVEC LES ELEMENTS DU BON TYPE
        IADT  = ZI(JTLIE2)
        DO 5 J = 1, NBTG
          IADTP = ZI(JTLIE2+J)
          JTYPE = ZI(JTLIEL-2+IADTP)
          IF (JTYPE.EQ.ITYPE) THEN
            NEL = IADTP -IADT -1
            DO 6 K = 1,NEL
C             -- IL FAUT CHANGER DE GREL :
              IF (NELEM.GE.NBELGV) THEN
                IGRE2 = IGRE2 + 1
                NBELGV=NBELGR
                IF (IGRE2.LE.NP1) NBELGV=NBELGV+1
                CALL JEVEUO(JEXNUM(LIEL,IGREL+IGRE2),'E',JLIEL)
                NELEM = 0
              ENDIF
              NELEM = NELEM + 1
              ZI(JLIEL-1+NELEM) = ZI(JTLIEL-1+IADT+K-1)
 6          CONTINUE
          ENDIF
          IADT = IADTP
 5      CONTINUE
        CALL ASSERT(IGRE2.LE.NBG)
        CALL ASSERT(NELEM.EQ.NBELGV)
        IGREL=IGREL+NBG
 4    CONTINUE
      CALL ASSERT (IGREL.EQ.NBGREL)


C --- DESTRUCTION DES OBJETS DE TRAVAIL
      CALL JEDETR(TLIEL)
      CALL JEDETR('&&ADALIG.TEUT')
      CALL JEDETR('&&ADALIG.NTEUT')
      CALL JEDETR('&&ADALIG.GTEUT')
 9999 CONTINUE
      CALL JEDEMA()
      END
