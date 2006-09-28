      SUBROUTINE ROTLIS (NOMRES,FMLI,ICAR,FPLIN,FPLIO,II,SST,INTF,FACT)
      IMPLICIT NONE
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
C***********************************************************************
C  P. RICHARD     DATE 13/10/92
C-----------------------------------------------------------------------
C  BUT : < CALCUL DES LIAISONS >
C
C  CALCULER LES NOUVELLES MATRICES DE LIAISON EN TENANT COMPTE DE
C  L'ORIENTATION DES SOUS-STRUCTURES
C  ON DETERMINE LES MATRICES DE LIAISON, LES DIMENSIONS DE CES MATRICES
C  ET LE PRONO ASSOCIE
C  PRISE EN COMPTE D'UN FACTEUR MULTIPLICATIF POUR LA MATRICE ORIENTEE
C
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM UTILISATEUR DU RESULTAT MODELE_GENE
C II     /I/ : NUMERO INTERFACE COURANTE
C FMLI   /I/ : FAMILLE DES MATRICES DE LIAISON
C ICAR   /I/ : CARACTERISTIQUE DE LA LIAISON
C FPLIN  /I/ : FAMILLE DES PROFNO DES MATRICES DE LIAISON NON ORIENTEES
C FPLIO  /I/ : FAMILLE DES PROFNO DES MATRICES DE LIAISON ORIENTEES
C SST    /I/ : NOM DE LA SOUS-STRUCTURE MISE EN JEU PAR LA LIAISON
C INTF   /I/ : NOM DE L'INTERFACE MISE EN JEU PAR LA LIAISON
C FACT   /I/ : FACTEUR REEL MULTIPLICATIF DE LA MATRICE DE LIAISON
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32  JEXNOM,JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C   PARAMETER REPRESENTANT LE NOMBRE MAX DE COMPOSANTES DE LA GRANDEUR
C   SOUS-JACENTE TRAITEE
C
      INTEGER      NBCMPM,ORDO,NBEC,IERD,IBID,LLROT,NTAIL,
     &             IADN,IADO,I,J,K,L,NBLIGO,ICOMPO,LDMAT,II,LLPLIN,
     &             NBNOE,LLPLIO,LDLID,NBLIGN,NBCOLN,LLMAT,NBCOLO,
     &             ICOMPN,IBLO
      PARAMETER    (NBCMPM=10)
      INTEGER      IDECO(NBCMPM),IDECN(NBCMPM),ICAR(3)
      CHARACTER*1 K1BID
      CHARACTER*8  NOMRES,SST,INTF,NOMMCL,BASMOD,NOMG,KBID
      CHARACTER*24 FMLI,FPLIN,FPLIO,NOMATN,FAMLI
      REAL*8       ROT(3),MATROT(NBCMPM,NBCMPM),FACT,
     &             MATBUF(NBCMPM,NBCMPM),MATTMP(NBCMPM,NBCMPM),
     &             ZERO,XO(NBCMPM),XN(NBCMPM)
C
C-----------------------------------------------------------------------
      DATA ZERO /0.0D+00/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C-----RECUPERATION DU NOMBRE DU NOMBRE D'ENTIERS CODES ASSOCIE A DEPL_R
C
      NOMG = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,KBID,IERD)
      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ENDIF
C
      NTAIL=NBCMPM**2
C
C --- RECUPERATION DES NOMS DU MACR-ELEMENT ET DE LA BASE MODALE DE SST
C
      CALL MGUTDM(NOMRES,SST,IBID,'NOM_MACR_ELEM',IBID,NOMMCL)
      CALL MGUTDM(NOMRES,SST,IBID,'NOM_BASE_MODALE',IBID,BASMOD)
C
C --- RECUPERATION DES ROTATIONS DE LA SOUS-STRUCTURE
C
      CALL JENONU(JEXNOM(NOMRES//'      .MODG.SSNO',SST),IBID)
      CALL JEVEUO(JEXNUM(NOMRES//'      .MODG.SSOR',IBID),'L',LLROT)
      DO 10 I=1,3
        ROT(I)=ZR(LLROT+I-1)
10    CONTINUE
C
C --- CALCUL DE LA MATRICE DE ROTATION
C
      CALL INTET0(ROT(1),MATTMP,3)
      CALL INTET0(ROT(2),MATROT,2)
      CALL R8INIR(NTAIL,ZERO,MATBUF,1)
      CALL  PMPPR(MATTMP,NBCMPM,NBCMPM,1,MATROT,NBCMPM,NBCMPM,1,
     &            MATBUF,NBCMPM,NBCMPM)
      CALL INTET0(ROT(3),MATTMP,1)
      CALL R8INIR(NTAIL,ZERO,MATROT,1)
      CALL  PMPPR(MATBUF,NBCMPM,NBCMPM,1,MATTMP,NBCMPM,NBCMPM,1,
     &            MATROT,NBCMPM,NBCMPM)
C
C --- RECUPERATION DES DONNEES MINI-PROFNO DE LA LIAISON NON ORIENTEE
C     ET ORIENTEE
C
      CALL JEVEUO(JEXNUM(FPLIN,II),'L',LLPLIN)
      CALL JELIRA(JEXNUM(FPLIN,II),'LONMAX',NBNOE,K1BID)
      NBNOE=NBNOE/(1+NBEC)
      CALL JEVEUO(JEXNUM(FPLIO,II),'L',LLPLIO)
C
C --- RECUPERATION DE LA MATRICE DE LIAISON ET ECRITURE DES DIMENSIONS
C     DE LA MATRICE ORIENTEE
C
      NOMATN='&&ROTLIS.MAT.LIAN'

      FAMLI=NOMRES//'      .MODG.LIDF'
      CALL JEVEUO(JEXNUM(FAMLI,II),'L',LDLID)
      IF ((ZK8(LDLID+2).EQ.SST).AND.
     & (ZK8(LDLID+4).EQ.'OUI     ')) THEN
        ORDO=1
      ELSE
        ORDO=0
      ENDIF

      CALL EXMALI(BASMOD,INTF,IBID,NOMATN,'V',NBLIGN,NBCOLN,ORDO,II)
      CALL JEVEUO(NOMATN,'L',LLMAT)
C
C --- CREATION DE LA NOUVELLE MATRICE DE LIAISON
C
      NBLIGO=ICAR(1)
      NBCOLO=ICAR(2)
      IBLO=ICAR(3)
      CALL JECROC(JEXNUM(FMLI,IBLO))
      CALL JEECRA(JEXNUM(FMLI,IBLO),'LONMAX',NBCOLO*NBLIGO,' ')
      CALL JEVEUO(JEXNUM(FMLI,IBLO),'E',LDMAT)
C
C --- CALCUL PROPREMENT DIT DES MATRICES ORIENTEES DE LIAISON----------
C
C  BOUCLE SUR LES NOEUDS DU PROFIL
C
      DO 100 I=1,NBNOE
        IADN=ZI(LLPLIN+(I-1)*(1+NBEC))
        CALL ISDECO(ZI(LLPLIN+(I-1)*(1+NBEC)+1),IDECN,NBCMPM)
        IADO=ZI(LLPLIO+(I-1)*(1+NBEC))
        CALL ISDECO(ZI(LLPLIO+(I-1)*(1+NBEC)+1),IDECO,NBCMPM)
C
C  BOUCLE SUR LES DEFORMEES DE LA BASE
C
        DO 110 J=1,NBCOLN
          ICOMPO=IADO-1
          ICOMPN=IADN-1
C
C  BOUCLE SUR LES COMPOSANTES DE DEPART: NON ORIENTEES
C  INITIALISATION VALEURS
C
          DO 120 K=1,NBCMPM
            IF(IDECN(K).GT.0) THEN
              ICOMPN=ICOMPN+1
               XN(K)=ZR(LLMAT+(J-1)*NBLIGN+ICOMPN-1)
             ELSE
               XN(K)=ZERO
             ENDIF
120        CONTINUE
C
C  ROTATION DU DELACEMENT NODAL MODAL
C
           DO 140 K=1,NBCMPM
             XO(K)=ZERO
             DO 150 L=1,NBCMPM
               XO(K)=XO(K)+MATROT(K,L)*XN(L)
150          CONTINUE
140        CONTINUE
C
C  BOUCLE SUR LES COMPOSANTES ORIENTEES: RECUPERATION VALEURS
C
           DO 130 K=1,NBCMPM
             IF(IDECO(K).GT.0) THEN
               ICOMPO=ICOMPO+1
               ZR(LDMAT+(J-1)*NBLIGO+ICOMPO-1)=XO(K)*FACT
             ENDIF
130        CONTINUE
110      CONTINUE
100    CONTINUE
C
      CALL JEDETR(NOMATN)
C
      CALL JEDEMA()
      END
