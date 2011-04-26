      SUBROUTINE MOIN93(MASSE,RAIDE,RAIDFA,NBMOIN,MATMOD,VEFREQ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C           M. CORUS     DATE 4/02/10
C     ------------------------------------------------------------------
C
C     BUT : CALCUL DE MODES DE COUPLAGES,
C                => APPROXIMATION DES MODES D'INTERFACE
C           ON CONSTRUIT UN MODELE SIMPLIFIE DE L'INTERFACE, SUR LA BASE
C           D'UN TREILLIS DE POUTRES. ON CALCUL LES PREMIERS MODES DE CE
C           TREILLIS, QUI SERT A CONSTRUIRE UN SOUS ESPACE PERTINENT
C           POUR LE CALCUL DES MODES D'INTERFACE.
C
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      CHARACTER*32 JEXNUM

      INTEGER      IBID,IERD,NEQ,IEQ,
     &             I1,J1,K1,L1,M1,N1,
     &             NBMOIN,LINDNO,
     &             LINDDL,LDDLD,NBNOEU,
     &             LPRNO,NNOINT,IPOS1,IPOS2,NUMNO,
     &             NBCMPM,NBEC,NDDLIN,LNOINT,
     &             CONNEC,LCONNC,SIZECO,
     &             LINTRF,
     &             LINLAG,LIPOS,LFREQ

      PARAMETER    (NBCMPM=10)
      INTEGER      DECO(NBCMPM)
      REAL*8        RBID,
     &             SHIFT

      CHARACTER*8  K8B,K8BID,NOMMA
      CHARACTER*14 NUME,NUME91
      CHARACTER*16 NOMCMD
      CHARACTER*19 RAIDE,MASSE, SOLVEU,PRNO, SSAMI,RAIINT,RAIDFA
      CHARACTER*24 COINT,NODDLI, MATMOD,VEFREQ

C     ------------------------------------------------------------------
      CALL JEMARQ()

      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NBEC,K8BID,IBID)
      CALL DISMOI('F','NOM_MAILLA'  ,RAIDE,'MATR_ASSE',IBID,NOMMA,IERD)
      CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,NUME ,IERD)
      CALL DISMOI('F','NB_EQUA'     ,RAIDE,'MATR_ASSE',NEQ ,K8B ,IERD)
      CALL DISMOI('F','SOLVEUR',RAIDE,'MATR_ASSE',IBID,SOLVEU,IERD)
      CALL DISMOI('F','NB_NO_MAILLA',NOMMA,'MAILLAGE',NBNOEU,K8BID,IERD)

C-----------------------------------------------------C
C--                                                 --C
C-- CONSTRUCTION DES MATRICES DU MODELE D'INTERFACE --C
C--                                                 --C
C-----------------------------------------------------C

C-- RECUPERATION DE LA DEFINITION DES EQUATIONS
      CALL DISMOI('F','PROF_CHNO',NUME,'NUME_DDL',IBID,PRNO,IERD)
      CALL JEVEUO(JEXNUM(PRNO//'.PRNO',1),'L',LPRNO)

C-- ALLOCATION ET REMPLISSAGE DU VECTEUR DES INDICES DES DDL D'INTERFACE
      CALL WKVECT('&&MOIN93.IS_DDL_INTERF','V V I',NEQ,LDDLD)
      CALL MSTGET(NOMCMD,RAIDE,'MODE_INTERF',1,ZI(LDDLD))
      NDDLIN=0
      NNOINT=0
      NUMNO=0

      DO 10 I1=1,NBNOEU
        IPOS1=ZI(LPRNO+(I1-1)*(2+NBEC))
        IPOS2=ZI(LPRNO+(I1-1)*(2+NBEC)+1)
        IF (IPOS1 .GT. 0) THEN
          DO 15 J1=1,IPOS2
            IF (ZI(LDDLD+IPOS1-1+J1-1) .GT. 0) THEN
              NDDLIN=NDDLIN+1
              IF (NUMNO.EQ.0) THEN
                NUMNO=1
                NNOINT=NNOINT+1
              ENDIF
            ENDIF
  15      CONTINUE
          NUMNO=0
        ENDIF
  10  CONTINUE

C-- RECUPERATION DES NOEUDS D'INTERFACE
      NODDLI='&&MOIN93.NOEUDS_DDL_INT'
      CALL WKVECT(NODDLI,'V V I',9*NNOINT,LNOINT)
      CALL WKVECT('&&MOIN93.V_IND_DDL_INT','V V I',NDDLIN,LINDDL)
      CALL WKVECT('&&MOIN93.V_IND_LAG','V V I',2*NDDLIN,LINLAG)
      CALL WKVECT('&&MOIN93.IPOS_DDL_INTERF','V V I',NNOINT,LIPOS)
      CALL WKVECT('&&MOIN93.DDL_ACTIF_INT','V V I',NDDLIN,LINTRF)

      K1=0
      NUMNO=0
      M1=0
      DO 20 I1=1,NBNOEU
        IPOS1=ZI(LPRNO+(I1-1)*(2+NBEC))
        IPOS2=ZI(LPRNO+(I1-1)*(2+NBEC)+1)
        IF (IPOS1 .GT. 0) THEN

          DO 25 J1=1,IPOS2

            IF (ZI(LDDLD+IPOS1-1+J1-1) .GT. 0) THEN
C-- RECHERCHE DES DDL D'INTERFACE
              ZI(LINDDL+M1)=IPOS1+J1-1
              M1=M1+1
C-- RECHERCHE DES LAGRANGES ASSOCIES AUX DDL D'INTERFACE
              CALL DDLLAG(NUME,IPOS1+J1-1,NEQ,ZI(LINLAG+(M1-1)*2),
     &                    ZI(LINLAG+(M1-1)*2+1))
              RBID=(ZI(LINLAG+(M1-1)*2)*ZI(LINLAG+(M1-1)*2+1))
              IF (RBID .EQ. 0) THEN
                CALL U2MESS('F','ALGELINE2_4')
              ENDIF

C-- RECHERCHE DES TYPES DES DDLS ACTIFS
              IF (NUMNO.EQ.0) THEN
                NUMNO=1
                ZI(LNOINT+K1)=I1
                ZI(LNOINT+K1+NNOINT)=IPOS1
                ZI(LNOINT+K1+2*NNOINT)=6

                CALL ISDECO(ZI(LPRNO+(I1-1)*(2+NBEC)+2),DECO,NBCMPM)
                L1=1
                DO 30,N1=1,6
                  IF (DECO(N1)*ZI(LDDLD+IPOS1-1+N1-1) .GT. 0) THEN
                    ZI(LINTRF+M1-1+L1-1)=K1*6+N1
                    L1=L1+1
                  ENDIF
                  ZI(LNOINT+K1+(2+N1)*NNOINT)=N1

  30            CONTINUE
                K1=K1+1

              ENDIF
            ENDIF

  25      CONTINUE
          NUMNO=0
        ENDIF
  20  CONTINUE

      CALL WKVECT('&&MOIN93.IND_NOEUD','V V I',ZI(LNOINT+NNOINT-1),
     &            LINDNO)

C--
C-- CONSTRUCTION DE LA CONNECTIVITE, DU MODELE ET DES MATRICES --C
C--

C  LA TAILLE EST LARGEMENT SURESTIMEE : DANS LE CAS QUAD DE DEGRES 2,
C  ON PEUT AVOIR JUSQU'A 24 VOISINS, ON ALLOUE UN NOMBRE MAX DE 35.
C  LA PREMIERE COLONNE DONNE LE NOMBRE DE VOISINS
      SIZECO=36*NNOINT
      COINT='&&MOIN93.CONNEC_INTERF'
      NUME91='&&NUME91'
      RAIINT='&&RAID91'
      SSAMI='&&MASS91'

      CALL WKVECT(COINT,'V V I',SIZECO,LCONNC)
      CALL CONINT(NUME,RAIDE,COINT,SIZECO,CONNEC,
     &     NODDLI,NNOINT,NUME91,RAIINT,SSAMI)

C-------------------------------------------------C
C--                                             --C
C-- CALCUL DES MODES DES OPERATEURS D'INTERFACE --C
C--                                             --C
C-------------------------------------------------C

      CALL MODINT(SSAMI,RAIINT,NDDLIN,NBMOIN,SHIFT,MATMOD,MASSE,
     &              RAIDFA,NEQ,COINT,NODDLI,NNOINT,VEFREQ)
      CALL JEVEUO(VEFREQ,'L',LFREQ)

      WRITE(6,*)'    NUMERO    FREQUENCE (HZ)'
      DO 60 IEQ = 1,NBMOIN
        WRITE(6,'(I10,4X,F12.2)')IEQ,ZR(LFREQ+IEQ-1)
  60  CONTINUE

C----------------------------------------C
C--                                    --C
C-- DESTRUCTION DES OBJETS TEMPORAIRES --C
C--                                    --C
C----------------------------------------C

      CALL DETRSD('NUME_DDL',NUME91)
      CALL JEDETR(NUME91(1:14)//'.NUME.REFN')
      CALL DETRSD('MATR_ASSE',SSAMI)
      CALL DETRSD('MATR_ASSE',RAIINT)

      CALL JEDETR('&&MODL91      .MODG.SSNO')
      CALL JEDETR('&&MODL91      .MODG.SSME')

      CALL JEDETR('&&MOIN93.IND_NOEUD')
      CALL JEDETR('&&MOIN93.IPOS_DDL_INTERF')
      CALL JEDETR('&&MOIN93.IS_DDL_INTERF')
      CALL JEDETR('&&MOIN93.V_IND_DDL_INT')
      CALL JEDETR('&&MOIN93.V_IND_LAG')
      CALL JEDETR('&&MOIN93.DDL_ACTIF_INT')

      CALL JEDETR(NODDLI)
      CALL JEDETR(COINT)

      CALL JEDETR('&&MOIN93.NOEU')
      CALL JEDETR('&&MOIN93.ECRITURE.RES')
      CALL JEDETR('&&MOIN93.NOM_PARA')

C---------C
C--     --C
C-- FIN --C
C--     --C
C---------C

      CALL JEDEMA()

      END
