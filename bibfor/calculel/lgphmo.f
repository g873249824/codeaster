      SUBROUTINE LGPHMO(MA,LIGREL,PHENO,MODELI)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8 MA
      CHARACTER*(*) LIGREL, PHENO, MODELI
C ----------------------------------------------------------------------
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C ----------------------------------------------------------------------
C     BUT: CREER LE LIGREL LIGREL SUR TOUTES LES MAILLES DU MAILLAGE MA
C     ON UTILISE LES E.F. DE LA MODELISATION MODELI DU PHENOMENE PHENO
C ----------------------------------------------------------------------
C
C
C
C
      INTEGER IBID,NBGREL,NBMA,NBTM,JTYMA,JLITM,IMA,TM
      INTEGER TE,JLIEL,IGR,ICO,JPHMOD,KMOD,JLGRF
      INTEGER INDK16,NBEL
      CHARACTER*8 KBID
      CHARACTER*19 LIGR19,PHEN1
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      LIGR19=LIGREL
      PHEN1=PHENO

      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IBID)
      CALL JENONU(JEXNOM('&CATA.'//PHEN1(1:13)//'.MODL',MODELI),KMOD)
      CALL ASSERT(KMOD.GT.0)
      CALL JEVEUO(JEXNUM('&CATA.'//PHEN1,KMOD),'L',JPHMOD)


C     -- ON PARCOURT LA CONNECTIVITE POUR DETERMINER LES ENSEMBLES DE
C        DE MAILLES DE MEME TYPE
      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
      CALL JEVEUO(MA//'.TYPMAIL','L',JTYMA)
      CALL WKVECT('&&LGPHMO.LITM','V V I',NBTM,JLITM)
      NBEL=0
      DO 1, IMA=1,NBMA
        TM= ZI(JTYMA-1+IMA)
        CALL ASSERT(TM.GT.0)
        TE= ZI(JPHMOD-1+TM)
        IF (TE.GT.0) THEN
          NBEL=NBEL+1
          ZI(JLITM-1+TM)=ZI(JLITM-1+TM)+1
        ENDIF
 1    CONTINUE


C     -- CALCUL DE NBGREL :
      NBGREL=0
      DO 2, TM=1,NBTM
        IF (ZI(JLITM-1+TM).GT.0) NBGREL=NBGREL+1
 2    CONTINUE


C     -- ALLOCATION ET REMPLISSAGE DE L'OBJET .LIEL :
C     -------------------------------------------------------
      CALL JECREC(LIGR19//'.LIEL','V V I','NU','CONTIG',
     &            'VARIABLE',NBGREL)
      CALL JEECRA(LIGR19//'.LIEL','LONT',NBEL+NBGREL,' ')
      CALL JEVEUO(LIGR19//'.LIEL','E',JLIEL)

      IGR=0
      ICO=0
      DO 3, TM=1,NBTM
         IF (ZI(JLITM-1+TM).GT.0) THEN
           IGR=IGR+1
           TE= ZI(JPHMOD-1+TM)
           CALL ASSERT(TE.GT.0)
           NBEL=0
           DO 4, IMA=1,NBMA
             IF (ZI(JTYMA-1+IMA).EQ.TM) THEN
               NBEL=NBEL+1
               ICO=ICO+1
               ZI(JLIEL-1+ICO)=IMA
             ENDIF
 4         CONTINUE
           CALL ASSERT(NBEL.GT.0)
           CALL JECROC(JEXNUM(LIGR19//'.LIEL',IGR))
           CALL JEECRA(JEXNUM(LIGR19//'.LIEL',IGR),'LONMAX',NBEL+1,KBID)
           ICO=ICO+1
           ZI(JLIEL-1+ICO)=TE
         ENDIF
 3    CONTINUE


C     -- OBJET .LGRF :
C     ----------------
      CALL WKVECT(LIGR19//'.LGRF','V V K8',2,JLGRF)
      ZK8(JLGRF-1+1)=MA


C     -- ON "ADAPTE" LA TAILLE DES GRELS DU LIGREL :
      CALL ADALIG(LIGR19)

      CALL JEDETR('&&LGPHMO.LITM')
      CALL JEDEMA()
      END
