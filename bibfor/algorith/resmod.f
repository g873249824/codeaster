      SUBROUTINE RESMOD(BMODAL,NBMODE,NEQ,NUMGEN,MDGENE,NOECHO,MODSST)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C***********************************************************************
C  C. VARE     DATE 16/10/95
C-----------------------------------------------------------------------
C  BUT : < CALCUL DEPLACEMENT MODAL >
C  CALCULER LES DEPLACEMENTS MODAUX D'UN NOEUD D'UNE SOUS-STRUCTURE
C-----------------------------------------------------------------------
C
C BMODAL /I/ : BASE MODALE DE LA STRUCTURE COMPLETE
C NBMODE /I/ : NOMBRE DE MODES DE LA STRUCTURE COMPLETE
C NEQ    /I/ : NOMBRE D'EQUATIONS DU MODELE GENERALISE
C NUMGEN /I/ : NUMEROTATION DU PROBLEME GENERALISE
C MDGENE /I/ : MODELE GENERALISE
C NOECHO /I/ : NOEUD A RESTITUER : NOECHO(1) = NOEUD_1
C                                  NOECHO(2) = SOUS_STRUC_1
C                                  NOECHO(3) = NUME_1
C MODSST /O/ : DEPL PHYSIQUES DES MODES AUX NOEUDS DE CHOC
C
C
C
      INCLUDE 'jeveux.h'
C
C
      INTEGER      NBMODE,DDL(6),NEQ
      CHARACTER*8  BASMOD,NOMSST,SOUTR,KB,NUMDDL,NOEUD,NOECHO(3)
      CHARACTER*16 DEPL
      CHARACTER*24 CHAMBA,MDGENE,NUMGEN
      REAL*8       BMODAL(NEQ,*),COORD(3),MODSST(NBMODE,6)
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IBID ,IEQ ,J ,JCOORD ,LCHAB ,LLORS 
      INTEGER LLPRS ,NEQGEN ,NSST ,NUNOE ,NUSST ,NUTARS 
C-----------------------------------------------------------------------
      DATA DEPL   /'DEPL            '/
      DATA SOUTR  /'&SOUSSTR'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      NOEUD  = NOECHO(1)
      NOMSST = NOECHO(2)
      NUMDDL = NOECHO(3)
      NUMGEN = NUMGEN(1:14)//'.NUME'
C
C --- NUMERO DE SOUS-STRUCTURE ET DU NOEUD TARDIF CORRESPONDANT
C
      CALL JENONU(JEXNOM(MDGENE(1:14)//'.MODG.SSNO',NOMSST),NUSST)
      CALL JENONU(JEXNOM(NUMGEN(1:19)//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN(1:19)//'.ORIG',IBID),'L',LLORS)
      CALL JELIRA(JEXNUM(NUMGEN(1:19)//'.ORIG',IBID),'LONMAX',NSST,KB)
      DO 10 I=1,NSST
        IF (ZI(LLORS+I-1).EQ.NUSST) NUTARS=I
10    CONTINUE
C
      CALL JENONU(JEXNOM(NUMGEN(1:19)//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN(1:19)//'.PRNO',IBID),'L',LLPRS)
      NEQGEN=ZI(LLPRS+(NUTARS-1)*2+1)
      IEQ=ZI(LLPRS+(NUTARS-1)*2)
C
C --- BASE MODALE ET DU NBRE D'EQUATIONS DE LA SOUS-STRUCTURE
C
      CALL MGUTDM(MDGENE,NOMSST,IBID,'NOM_BASE_MODALE',IBID,BASMOD)
C
C --- RESTITUTION PROPREMENT DITE
C
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DX' ,NUNOE,DDL(1))
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DY' ,NUNOE,DDL(2))
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DZ' ,NUNOE,DDL(3))
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DRX',NUNOE,DDL(4))
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DRY',NUNOE,DDL(5))
      CALL POSDDL('NUME_DDL',NUMDDL,NOEUD,'DRZ',NUNOE,DDL(6))
C
      CALL WKVECT('&&RESMOD.COORDO','V V R',3,JCOORD)
      DO 20 I=1,NBMODE
        MODSST(I,1)=0.D0
        MODSST(I,2)=0.D0
        MODSST(I,3)=0.D0
        MODSST(I,4)=0.D0
        MODSST(I,5)=0.D0
        MODSST(I,6)=0.D0
        ZR(JCOORD)   = 0.D0
        ZR(JCOORD+1) = 0.D0
        ZR(JCOORD+2) = 0.D0
        DO 30 J=1,NEQGEN
          CALL DCAPNO(BASMOD,DEPL,J,CHAMBA)
          CALL JEVEUO(CHAMBA,'E',LCHAB)
          MODSST(I,1)=MODSST(I,1)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(1)-1)
          MODSST(I,2)=MODSST(I,2)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(2)-1)
          MODSST(I,3)=MODSST(I,3)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(3)-1)
          IF (DDL(4).NE.0.AND.DDL(5).NE.0.AND.DDL(6).NE.0) THEN
            MODSST(I,4)=MODSST(I,4)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(4)-1)
            MODSST(I,5)=MODSST(I,5)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(5)-1)
            MODSST(I,6)=MODSST(I,6)+BMODAL(IEQ+J-1,I)*ZR(LCHAB+DDL(6)-1)
          ENDIF
30      CONTINUE
        ZR(JCOORD)   = MODSST(I,1)
        ZR(JCOORD+1) = MODSST(I,2)
        ZR(JCOORD+2) = MODSST(I,3)
        CALL ORIENT(MDGENE,NOMSST,JCOORD,1,COORD,0)
        MODSST(I,1) = COORD(1)
        MODSST(I,2) = COORD(2)
        MODSST(I,3) = COORD(3)
        ZR(JCOORD)   = MODSST(I,4)
        ZR(JCOORD+1) = MODSST(I,5)
        ZR(JCOORD+2) = MODSST(I,6)
        CALL ORIENT(MDGENE,NOMSST,JCOORD,1,COORD,0)
        MODSST(I,4) = COORD(1)
        MODSST(I,5) = COORD(2)
        MODSST(I,6) = COORD(3)
20    CONTINUE
      CALL JEDETR('&&RESMOD.COORDO')
C
      CALL JEDEMA()
      END
