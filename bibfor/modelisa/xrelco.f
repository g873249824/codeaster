      SUBROUTINE XRELCO(NOMA,NLISEQ,NLISRL,NLISCO,
     &                  NBASCO,LISREL,NREL  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/04/2010   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      INTEGER      NREL
      CHARACTER*8  NOMA
      CHARACTER*19 NLISEQ,NLISRL,NLISCO,NBASCO
      CHARACTER*19 LISREL
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION - AFFE_CHAR_MECA)
C
C CREER DES RELATIONS ENTRE LES INCONNUES DE CONTACT POUR
C SATISFAIRE LA LBB CONDITION
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NLISRL : LISTE REL. LIN. POUR V1 ET V2
C IN  NLISCO : LISTE REL. LIN. POUR V1 ET V2
C IN  NLISEQ : LISTE REL. LIN. POUR V2 SEULEMENT
C IN  NBASCO : CHAM_NO POUR BASE COVARIANTE
C OUT LISREL : LISTE DES RELATIONS � IMPOSER
C OUT NREL   : NOMBRE DE RELATIONS � IMPOSER
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXATR,JEXNUM
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
      INTEGER     NBDDL,XXMMVD,ZXEDG,ZXBAS
      PARAMETER  (NBDDL=3)
      CHARACTER*8 DDLC(NBDDL)
C
      REAL*8       RBID,BETAR,COEFR(6),DDOT
      REAL*8       TAUA(3,2),TAUB(3,2),TAUC(3,2),TAU(3,2,4)
      INTEGER      IER,JLIS1,NDIME(8),NEQ,I,NRL,JLIS2,JLIS3,K,IBID,IRET
      INTEGER      NUNO(8),NDIM,JCNSD,JCNSV,JCNSL,IAD,J,NRS,JLIS4,L,NNS
      CHARACTER*8  NOEUD(8),K8BID,DDL(8)
      CHARACTER*19 CHS,CNXINV
      COMPLEX*16   CBID

C
      DATA DDLC /'LAGS_C','LAGS_F1','LAGS_F2'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INTIALISATIONS
C
      BETAR  = 0.D0
      CHS    = '&&XRELCO.BASCO'
      DO 5 I = 1,8
        NDIME(I) = 0
 5    CONTINUE
      ZXBAS=XXMMVD('ZXBAS')
C
C --- DONN�ES RELATIVES AU MAILLAGE
C
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8BID,IRET)
C
C --- 1) RELATIONS D'EGALITE
C
      CALL JEEXIN(NLISEQ,IER)
      IF (IER.EQ.0)THEN
        GO TO 100
      ELSE
        CALL JEVEUO(NLISEQ,'L',JLIS1)
        CALL JELIRA(NLISEQ,'LONMAX',NEQ,K8BID)
      ENDIF

      DO 10 I = 1,NEQ/2
        NUNO(1)  = ZI(JLIS1-1+2*(I-1)+1)
        NUNO(2)  = ZI(JLIS1-1+2*(I-1)+2)
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUNO(1)),NOEUD(1))
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUNO(2)),NOEUD(2))
C
        COEFR(1) = 1.D0
        COEFR(2) = -1.D0
C
C --- RELATION POUR LES MULTIPLICATEURS DE CONTACT ET FROTTEMENT
C
        DO 20 J = 1,NDIM
          DDL(1) = DDLC(J)
          DDL(2) = DDLC(J)
          CALL AFRELA(COEFR,CBID,DDL,NOEUD,NDIME,RBID,2,BETAR,CBID,
     &              K8BID,'REEL','REEL','12',0.D0,LISREL)
          NREL = NREL + 1
 20     CONTINUE
 10   CONTINUE
 100  CONTINUE
C
C --- 2) RELATIONS LINEAIRES
C
      CALL JEEXIN(NLISRL,IER)
      IF (IER.EQ.0) THEN
        GOTO 200
      ELSE
        CALL JEVEUO(NLISRL,'L',JLIS2)
        CALL JELIRA(NLISRL,'LONMAX',NRL,K8BID)
        CALL JEVEUO(NLISCO,'L',JLIS3)
        CALL JELIRA(NLISCO,'LONMAX',IER,K8BID)
        CALL CNOCNS(NBASCO,'V',CHS)
        CALL JEVEUO(CHS(1:19)//'.CNSV' ,'L',JCNSV)
        CALL JEVEUO(CHS(1:19)//'.CNSD' ,'L',JCNSD)
        CALL JEVEUO(CHS(1:19)//'.CNSL' ,'L',JCNSL)
        CALL ASSERT(IER.EQ.NRL)
      ENDIF
C
      DO 30 I = 1,NRL/3
        NUNO(1)  = ZI(JLIS2-1+3*(I-1)+1)
        NUNO(2)  = ZI(JLIS2-1+3*(I-1)+2)
        NUNO(3)  = ZI(JLIS2-1+3*(I-1)+3)
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUNO(1)),NOEUD(1))
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUNO(2)),NOEUD(2))
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUNO(3)),NOEUD(3))
        IAD      = JLIS3-1+3*(I-1)
        COEFR(1) = ZR(IAD+1)
        COEFR(2) = ZR(IAD+2)
        COEFR(3) = ZR(IAD+3)
C
C --- RELATION POUR LES MULTIPLICATEURS DE CONTACT ('LAGS_C')
C
        DDL(1) = DDLC(1)
        DDL(2) = DDLC(1)
        DDL(3) = DDLC(1)
        CALL AFRELA(COEFR,CBID,DDL,NOEUD,NDIME,RBID,3,BETAR,CBID,
     &              K8BID,'REEL','REEL','12',0.D0,LISREL)
        NREL = NREL + 1
C
C --- RELATIONS POUR LES SEMI-MULTIPLICATEURS DE FROTTEMENT
C              (VOIR BOOK VI 20/04/06)

        DDL(1) = DDLC(2)
        DDL(2) = DDLC(2)
        DDL(3) = DDLC(2)
        IF (NDIM.EQ.3) THEN
          DDL(4)   = DDLC(3)
          DDL(5)   = DDLC(3)
          DDL(6)   = DDLC(3)
          NUNO(4)  = NUNO(1)
          NUNO(5)  = NUNO(2)
          NUNO(6)  = NUNO(3)
          NOEUD(4) = NOEUD(1)
          NOEUD(5) = NOEUD(2)
          NOEUD(6) = NOEUD(3)
        ENDIF
        DO 40 J=1,NDIM
          TAUA(J,1) = ZR(JCNSV-1+ZXBAS*(NUNO(1)-1)+6+J)
          TAUB(J,1) = ZR(JCNSV-1+ZXBAS*(NUNO(2)-1)+6+J)
          TAUC(J,1) = ZR(JCNSV-1+ZXBAS*(NUNO(3)-1)+6+J)
          IF (NDIM.EQ.3) TAUA(J,2) = ZR(JCNSV-1+ZXBAS*(NUNO(1)-1)+9+J)
          IF (NDIM.EQ.3) TAUB(J,2) = ZR(JCNSV-1+ZXBAS*(NUNO(2)-1)+9+J)
          IF (NDIM.EQ.3) TAUC(J,2) = ZR(JCNSV-1+ZXBAS*(NUNO(3)-1)+9+J)
 40     CONTINUE

        DO 41 K=1,NDIM-1
          COEFR(1) = ZR(IAD+1) * DDOT(NDIM,TAUA(1,1),1,TAUA(1,K),1)
          COEFR(2) = ZR(IAD+2) * DDOT(NDIM,TAUB(1,1),1,TAUA(1,K),1)
          COEFR(3) = ZR(IAD+3) * DDOT(NDIM,TAUC(1,1),1,TAUA(1,K),1)
          IF (NDIM.EQ.3) THEN
            COEFR(4) = ZR(IAD+1) * DDOT(NDIM,TAUA(1,2),1,TAUA(1,K),1)
            COEFR(5) = ZR(IAD+2) * DDOT(NDIM,TAUB(1,2),1,TAUA(1,K),1)
            COEFR(6) = ZR(IAD+3) * DDOT(NDIM,TAUC(1,2),1,TAUA(1,K),1)
          ENDIF

          CALL AFRELA(COEFR,CBID,DDL,NOEUD,NDIME,RBID,3*(NDIM-1),BETAR,
     &                CBID,K8BID,'REEL','REEL','12',0.D0,LISREL)
          NREL = NREL + 1
 41     CONTINUE

 30   CONTINUE

 200  CONTINUE
C
C
      CALL JEDEMA()
      END
