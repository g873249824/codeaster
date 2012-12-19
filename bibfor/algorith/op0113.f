      SUBROUTINE OP0113()
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C
C OPERATEUR MODI_MODELE_XFEM
C
C
C ----------------------------------------------------------------------
C
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      REAL*8          CRIMAX
      INTEGER         IBID,IEL,IMA
      INTEGER         I,J2
      INTEGER         JLGRF1,JLGRF2,JMOFIS
      INTEGER         NBMA,NELT
      INTEGER         NB1
      INTEGER         NFISS,JNFIS
      INTEGER         NDIM
      CHARACTER*16    MOTFAC,K16BID
      CHARACTER*19    LIGR1,LIGR2
      CHARACTER*24    LIEL1,LIEL2
      CHARACTER*24    MAIL2
      CHARACTER*24    TRAV
      INTEGER         JMAIL2,JTAB,JXC,IRET
      CHARACTER*8     MODELX,MOD1,K8BID,NOMA,K8CONT
      LOGICAL        LINTER
      INTEGER      IARG
C
      DATA MOTFAC /' '/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOM DU MODELE MODIFIE
C
      CALL GETRES(MODELX,K16BID,K16BID)
      LIGR2  = MODELX//'.MODELE'
      LIEL2  = LIGR2//'.LIEL'
C
C --- NOM DU MODELE INITIAL
C
      CALL GETVID(MOTFAC,'MODELE_IN',1,IARG,1,MOD1,IBID )
      LIGR1  = MOD1//'.MODELE'
      LIEL1  = LIGR1//'.LIEL'
C
C --- ACCES AU MAILLAGE INITIAL
C
      CALL JEVEUO(LIGR1//'.LGRF','L',JLGRF1)
      NOMA   = ZK8(JLGRF1-1+1)
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8BID,IRET)

      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IBID)

C --- RECUPERER LE NOMBRE DE FISSURES
C
      CALL GETVID(MOTFAC,'FISSURE'  ,1,IARG,0,K8BID,NFISS)
      NFISS = -NFISS

C --- CREATION DES OBJETS POUR MULTIFISSURATION DANS MODELE MODIFIE
C
      CALL WKVECT(MODELX//'.NFIS'  ,'G V I'  ,1    ,JNFIS)
      CALL WKVECT(MODELX//'.FISS'  ,'G V K8' ,NFISS,JMOFIS)
      ZI(JNFIS)   = NFISS
C
C --- RECUPERER LES FISSURES ET REMPLISSAGE DE MODELX//'.FISS'
C
      CALL GETVID(MOTFAC,'FISSURE',1,IARG,NFISS,ZK8(JMOFIS), IBID )
      CALL GETVR8(MOTFAC,'CRITERE',1,IARG,1,CRIMAX,IBID)

C     VERIFICATION DE LA COHERENCE DES MOT-CLES FISSURE ET MODELE_IN
      CALL XVERMO(NFISS,ZK8(JMOFIS),MOD1)

C
C --- CONTACT ?
C
      CALL GETVTX(MOTFAC,'CONTACT',1,IARG,1,K8CONT,IBID)
      CALL WKVECT(MODELX//'.XFEM_CONT'  ,'G V I'  ,1,JXC)
      IF (K8CONT.EQ.'P1P1') THEN
        ZI(JXC) = 1
      ELSEIF (K8CONT.EQ.'P2P1') THEN
        ZI(JXC) = 3
      ELSE
        ZI(JXC) = 0
      ENDIF
C
C --- CREATION DU TABLEAU DE TRAVAIL
C
      TRAV  = '&&OP0113.TAB'
      CALL WKVECT(TRAV,'V V I',NBMA*5,JTAB)
C
      DO 110 I=1,NBMA
        ZI(JTAB-1+5*(I-1)+4) = 1
 110  CONTINUE
C
C ---------------------------------------------------------------------
C     1)  REMPLISSAGE DE TAB : NBMA X 5 : GR1 | GR2 | GR3 | GR0 | ITYP
C ---------------------------------------------------------------------
C
      CALL XTYELE(NOMA,TRAV,NFISS,ZK8(JMOFIS),ZI(JXC),NDIM,
     &            LINTER)
C
C ---------------------------------------------------------------------
C       2)  MODIFICATION DE TAB EN FONCTION DE L'ENRICHISSEMENT
C ---------------------------------------------------------------------
C
      CALL XMOLIG(LIEL1,TRAV)
C
C --- ON COMPTE LE NB DE MAILLES DU LIGREL1 (= NB DE GREL DE LIEL2)
C
      NELT   = 0
      DO 230 IMA = 1,NBMA
        IF (ZI(JTAB-1+5*(IMA-1)+5).NE.0) THEN
          NELT   = NELT+1
        ENDIF
 230  CONTINUE
      IF (NELT.EQ.0) THEN
        CALL U2MESS('F','XFEM2_51')
      ENDIF

C-----------------------------------------------------------------------
C     3)  CONSTRUCTION DU .LIEL2
C-----------------------------------------------------------------------

      CALL JECREC(LIEL2,'G V I','NU','CONTIG','VARIABLE',NELT)
      CALL JEECRA(LIEL2,'LONT',2*NELT,K8BID)

      IEL=0
      DO 300 IMA=1,NBMA
        IF (ZI(JTAB-1+5*(IMA-1)+5).EQ.0)  GOTO 300
        IEL=IEL+1
        CALL JECROC(JEXNUM(LIEL2,IEL))
        CALL JEECRA(JEXNUM(LIEL2,IEL),'LONMAX',2,K8BID)
        CALL JEVEUO(JEXNUM(LIEL2,IEL),'E',J2)
        ZI(J2-1+1)=IMA
        ZI(J2-1+2)=ZI(JTAB-1+5*(IMA-1)+5)
 300  CONTINUE

      CALL JELIRA(LIEL2,'NUTIOC',NB1,K8BID)
      CALL ASSERT(NB1.EQ.NELT)

C-----------------------------------------------------------------------
C     4)  CONSTRUCTION DU .MAILLE
C-----------------------------------------------------------------------

      MAIL2 = MODELX//'.MAILLE'
      CALL WKVECT(MAIL2,'G V I',NBMA,JMAIL2)
      DO 400 IMA = 1,NBMA
        ZI(JMAIL2-1+IMA)=ZI(JTAB-1+5*(IMA-1)+5)
 400  CONTINUE

C-----------------------------------------------------------------------
C     5) DUPLICATION DU .NOMA, .NBNO
C                ET DES .NEMA, .SSSA, .NOEUD S'ILS EXISTENT
C        PUIS .REPE, .PRNM ET .PRNS AVEC CALL ADALIG CORMGI ET INITEL
C-----------------------------------------------------------------------

      CALL JEDUPO(LIGR1//'.NBNO','G',LIGR2//'.NBNO',.FALSE.)
      CALL JEDUPO(LIGR1//'.LGRF','G',LIGR2//'.LGRF',.FALSE.)
      CALL JEVEUO(LIGR2//'.LGRF','E',JLGRF2)
      ZK8(JLGRF2-1+2)=MODELX

      CALL JEDUP1(MOD1//'.NEMA' ,'G',MODELX//'.NEMA')
      CALL JEDUP1(MOD1//'.SSSA' ,'G',MODELX//'.SSSA')
      CALL JEDUP1(MOD1//'.NOEUD','G',MODELX//'.NOEUD')

      CALL ADALIG(LIGR2)
      CALL CORMGI('G',LIGR2)
      CALL INITEL(LIGR2)

C-----------------------------------------------------------------------
C     6)  CALCUL DU D�COUPAGE EN SOUS-TETRAS, DES FACETTES DE CONTACT
C         ET VERIFICATION DES CRITERES DE CONDITIONNEMENT
C-----------------------------------------------------------------------
C
      CALL XCODEC(NOMA  ,MODELX,NDIM  ,CRIMAX, LINTER)
C
C --- MENAGE
C
      CALL JEDETR(TRAV)
C
      CALL JEDEMA()
      END
