      SUBROUTINE CALPRO(NOMRES,CLASSE,BASMOD,NOMMAT)
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
C P. RICHARD     DATE 23/05/91
C-----------------------------------------------------------------------
C
C  BUT : < PROJECTION MATRICE SUR BASE QUELCONQUE >
C
C        CONSISTE A PROJETER UNE MATRICE ASSSEMBLEE SUR UNE BASE
C        QUELCONQUE (PAS DE PROPRIETE D'ORTHOGONALITE)
C
C        LA MATRICE RESULTAT EST SYMETRIQUE ET STOCKEE TRIANGLE SUP
C
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM K19 DE LA MATRICE CARREE RESULTAT
C CLASSE /I/ : CLASSE DE LA BASE JEVEUX DE L'OBJET RESULTAT
C BASMOD /I/ : NOM UT DE LA BASE MODALE DE PROJECTION
C NOMMAT /I/ : NOM UT DE LA MATRICE A PROJETER (RAIDEUR,MASSE)
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*1  CLASSE,TYP1
      CHARACTER*6  PGC
      CHARACTER*8  BASMOD,K8BID
      CHARACTER*19 NOMMAT
      CHARACTER*14 NUM
      CHARACTER*24 NOMRES
      CHARACTER*24 VALK
      CHARACTER*24   NOMCHA
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IAD ,IBID ,IDBASE ,IDDEEQ ,IER ,IRET
      INTEGER J ,LDDES ,LDREF ,LDRES ,LMAT ,LTVEC1 ,NBDEF
      INTEGER NEQ ,NTAIL
      REAL*8 XPROD,DDOT
C-----------------------------------------------------------------------
      DATA PGC/'CALPRO'/
C-----------------------------------------------------------------------
C
C --- CREATION DU .REFE
C
      CALL JEMARQ()
      CALL WKVECT(NOMRES(1:18)//'_REFE','G V K24',2,LDREF)
      ZK24(LDREF) = BASMOD
      ZK24(LDREF+1) = NOMMAT(1:8)
C
C --- RECUPERATION DES DIMENSIONS DE LA BASE MODALE
C
      CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBDEF,K8BID,IER)
C
C ----VERIFICATION DU TYPE DES VECTEURS PROPRES DANS LA BASE

      CALL RSEXCH ( BASMOD, 'DEPL', 1, NOMCHA, IRET )
      CALL JELIRA ( NOMCHA(1:19)//'.VALE', 'TYPE'  , IBID, TYP1 )
      IF (TYP1.EQ.'C') THEN
        VALK = BASMOD
        CALL U2MESG('F', 'ALGORITH12_16',1,VALK,0,0,0,0.D0)
      ENDIF

C --- ALLOCATION DE LA MATRICE RESULTAT
C
      NTAIL = NBDEF* (NBDEF+1)/2
      CALL WKVECT(NOMRES(1:18)//'_VALE',CLASSE//' V R',NTAIL,LDRES)
C
C --- CONTROLE D'EXISTENCE DE LA MATRICE
C
      CALL MTEXIS(NOMMAT(1:8),IER)
      IF (IER.EQ.0) THEN
        VALK = NOMMAT(1:8)
        CALL U2MESG('E', 'ALGORITH12_39',1,VALK,0,0,0,0.D0)
      ENDIF
C
C --- ALLOCATION DESCRIPTEUR DE LA MATRICE
C
      CALL MTDSCR(NOMMAT(1:8))
      CALL JEVEUO(NOMMAT(1:19)//'.&INT','E',LMAT)
C
C --- RECUPERATION NUMEROTATION ET NB EQUATIONS
C
      CALL DISMOI('F','NB_EQUA',NOMMAT(1:8),'MATR_ASSE',NEQ,K8BID,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',NOMMAT(1:8),'MATR_ASSE',IBID,NUM,
     &            IRET)
      CALL JEVEUO(NUM//'.NUME.DEEQ','L',IDDEEQ)
C
      CALL WKVECT('&&CALPRO.BASEMO','V V R',NBDEF*NEQ,IDBASE)
      CALL COPMO2(BASMOD,NEQ,NUM,NBDEF,ZR(IDBASE))
C
C
C --- ALLOCATION VECTEUR DE TRAVAIL
C
      CALL WKVECT('&&'//PGC//'.VECT1','V V R',NEQ,LTVEC1)
C
C --- PROJECTION SUR DEFORMEES
C
      DO 10 I=1,NBDEF
C
C ----- CALCUL PRODUIT MATRICE DEFORMEE
C
        CALL MRMULT('ZERO',LMAT,ZR(IDBASE+(I-1)*NEQ),ZR(LTVEC1),1,
     &              .TRUE.)
        CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
C
C ----- PRODUIT AVEC LA DEFORMEE COURANTE
C
        XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(IDBASE+(I-1)*NEQ),1)
        IAD = I*(I+1)/2
        ZR(LDRES+IAD-1) = XPROD
C
C ----- PRODUIT AVEC DEFORMEES D'ORDRE SUPERIEURE
C
        IF (I.LT.NBDEF) THEN
          DO 20 J=I+1,NBDEF
            XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(IDBASE+(J-1)*NEQ),1)
            IAD = I+(J-1)*J/2
            ZR(LDRES+IAD-1) = XPROD
20        CONTINUE
        ENDIF
C
10    CONTINUE
C
      CALL JEDETR('&&'//PGC//'.VECT1')
C
C --- CREATION DU .DESC
C
      CALL WKVECT(NOMRES(1:18)//'_DESC','G V I',3,LDDES)
      ZI(LDDES) = 2
      ZI(LDDES+1) = NBDEF
      ZI(LDDES+2) = 2
C
      CALL JEDETC('V','&&CALPRO',1)

      CALL JEDEMA()
      END
