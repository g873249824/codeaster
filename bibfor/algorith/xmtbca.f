      SUBROUTINE XMTBCA(NOMA    ,NOMO,DEFICO,RESOCO,VALMOI,
     &                  VALPLU,MMCVCA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE NISTOR I.NISTOR
C
      IMPLICIT NONE
      LOGICAL       MMCVCA
      CHARACTER*8   NOMA  ,NOMO
      CHARACTER*24  RESOCO,DEFICO
      CHARACTER*24  VALMOI(8),VALPLU(8)

C ----------------------------------------------------------------------
C                    MISE � JOUR DU STATUT DES POINTS DE CONTACT
C              ET RENVOIE MMCVCA (INDICE DE CONVERGENCE DE LA BOUCLE
C                         SUR LES CONTRAINTES ACTIVES)
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C IN  NOMO   : NOM DE L'OBJET MOD�LE
C IN  NOMA   : NOM DE L'OBJET MAILLAGE
C IN  RESOCO : SD CONTACT (RESOLUTION)
C IN  DEFICO : SD CONTACT (DEFINITION)
C IN  VALMOI : ETAT EN T-
C IN  VALPLU : ETAT EN T+
C OUT MMCVCA : INDICE DE CONVERGENCE DE LA BOUCLE SUR LES C.A.
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=3, NBIN=7)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER       NBPC,SINCO,IPC
      INTEGER       JTABF,ZTABF,CFMMVD
      INTEGER       JVALV,JVALV1,JVALV2,IBID
      CHARACTER*4  KMPIC
      CHARACTER*19  LIGRCF,CICOCA,CINDCO,CINDME
      CHARACTER*19  CPOINT,CPINTE,CAINTE,CCFACE
      CHARACTER*24  OLDGEO,DEPMOI,DEPPLU,K24BID
      CHARACTER*16  OPTION
      LOGICAL       DEBUG
      INTEGER       IFM,NIV,IFMDBG,NIVDBG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)
C
C --- INITIALISATIONS
C
      OLDGEO = NOMA(1:8)//'.COORDO'
      LIGRCF = RESOCO(1:14)//'.LIGR'
      CPOINT = RESOCO(1:14)//'.XFPO'
      CPINTE = RESOCO(1:14)//'.XFPI'
      CAINTE = RESOCO(1:14)//'.XFAI'
      CCFACE = RESOCO(1:14)//'.XFCF'
      OPTION = 'XCVBCA'
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)

C----RECUPERATION DE TABFIN -

      CALL JEVEUO(DEFICO(1:16)//'.TABFIN','E',JTABF)
      ZTABF = CFMMVD('ZTABF')

      CINDCO = '&&XMTBCA.INDCO'
      CINDME = '&&XMTBCA.INDME'
      CICOCA = '&&XMTBCA.CICOCA'

      NBPC = NINT(ZR(JTABF-1+1))
C
C --- INITIALISATION DE L'INDICATEUR DE CONVERGENCE DE LA BOUCLE
C     SUR LES CONTRAINTES ACTIVES (CONVERGENCE <=> INCOCA =1)

      SINCO  = 0
      MMCVCA = .TRUE.
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)
C
C --- CREATION DES LISTES DES CHAMPS IN
C
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = OLDGEO
      LPAIN(2)  = 'PDEPL_M'
      LCHIN(2)  = DEPMOI
      LPAIN(3)  = 'PDEPL_P'
      LCHIN(3)  = DEPPLU
      LPAIN(4)  = 'PCAR_PT'
      LCHIN(4)  = CPOINT
      LPAIN(5)  = 'PCAR_PI'
      LCHIN(5)  = CPINTE
      LPAIN(6)  = 'PCAR_AI'
      LCHIN(6)  = CAINTE
      LPAIN(7)  = 'PCAR_CF'
      LCHIN(7)  = CCFACE
C
C --- CREATION DES LISTES DES CHAMPS OUT
C
      LPAOUT(1) = 'PINCOCA'
      LCHOUT(1) = CICOCA
      LPAOUT(2) = 'PINDCOT'
      LCHOUT(2) = CINDCO
      LPAOUT(3) = 'PINDMEM'
      LCHOUT(3) = CINDME
C
C --- APPEL A CALCUL
C
      CALL CALCUL('S',OPTION,LIGRCF,NBIN  ,LCHIN ,LPAIN,
     &                              NBOUT ,LCHOUT,LPAOUT,'V')
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF

C-----ON FAIT SINCO = SOMME DES CICOCA SUR LES �LTS DU LIGREL

      CALL JEVEUO(CICOCA//'.CELV','L',JVALV)
      CALL DISMOI('F','MPI_COMPLET',CICOCA,'CHAM_ELEM',IBID,KMPIC,IBID)
      IF (KMPIC.NE.'OUI') CALL U2MESS('F','CALCULEL6_54')
      DO 10 IPC = 1,NBPC
         SINCO=SINCO+ZI(JVALV-1+IPC)
 10   CONTINUE

C-----SI SINCO EST STRICTEMENT POSITIF, ALORS ON A EU UN CODE RETOUR
C     SUPERIEUR A ZERO SUR UN ELEMENT ET DONC ON A PAS CONVERG�

      IF (SINCO.GT.0) MMCVCA=.FALSE.

C --- MISE A JOUR DU STATUT DE CONTACT
      CALL JEVEUO(CINDCO//'.CELV','L',JVALV1)
      CALL DISMOI('F','MPI_COMPLET',CINDCO,'CHAM_ELEM',IBID,KMPIC,IBID)
      IF (KMPIC.NE.'OUI') CALL U2MESS('F','CALCULEL6_54')
      DO 20 IPC = 1,NBPC
        ZR(JTABF+ZTABF*(IPC-1)+13)=ZR(JVALV1-1+IPC)
 20   CONTINUE

C --- MISE A JOUR DE LA MEMOIRE DE CONTACT
      CALL JEVEUO(CINDME//'.CELV','L',JVALV2)
      CALL DISMOI('F','MPI_COMPLET',CINDME,'CHAM_ELEM',IBID,KMPIC,IBID)
      IF (KMPIC.NE.'OUI') CALL U2MESS('F','CALCULEL6_54')
      DO 30 IPC = 1,NBPC
        ZR(JTABF+ZTABF*(IPC-1)+28)=ZI(JVALV2-1+IPC)
 30   CONTINUE


      CALL JEDEMA()
      END
