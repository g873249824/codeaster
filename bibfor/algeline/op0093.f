      SUBROUTINE OP0093 ()
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C TOLE CRP_20
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C     ------------------------------------------------------------------
C
C     OPERATEUR MODE_STATIQUE
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
      INTEGER      IBID,NEQ,LMATR,IFM,NIV,IRET,
     &             NRA,NMA,NBPSMO,IERD,NBMODD,NBMOST,LDDLD,
     &             I,LMODD,NBMODF,NBFONA,LDDLF,LMODF,
     &             NBMOAD,NBMODA,
     &             NBMOIN,
     &             NBMODI,MASSFA
      REAL*8       R8B
      CHARACTER*8  K8B,RESU,NOMMA
      CHARACTER*14 NUME
      CHARACTER*16 NOMCMD,CONCEP
      CHARACTER*19 RAIDE,MASSE,AMOR,NUMEDD,MATPRE,SOLVEU,
     &             RAIDFA
      CHARACTER*24 VALK,MOCB,MOATTA,MOAIMP,MOAUNI,MOINTF,DDLCB,
     &             DDLMN,VEFREQ,DDLAC
C     ------------------------------------------------------------------
      CALL JEMARQ()

C------------------------------C
C--                          --C
C-- INITIALISATIONS DIVERSES --C
C--                          --C
C------------------------------C

      MASSE  = ' '
      AMOR   = ' '
      RAIDE  = ' '
      MASSFA=0
      NBMODD=0
      NBMODF=0
      NBMODA=0
      NBMOAD=0
      NBMODI=0

C---------------------------------------------C
C--                                         --C
C-- RECUPERATION DES INFOS ET FACTORISATION --C
C--                                         --C
C---------------------------------------------C

      CALL GETRES(RESU,CONCEP,NOMCMD)

      CALL GETVID(' ','MATR_RIGI',1,1,1,RAIDE,NRA)
      CALL GETVID(' ','MATR_MASS',1,1,1,MASSE,NMA)

      CALL GETFAC('PSEUDO_MODE',NBPSMO)
      IF (NBPSMO.NE.0) THEN
         IF (NMA.EQ.0) THEN
            CALL U2MESS('F','ALGELINE2_77')
         ENDIF
      ENDIF

C     -- CREATION DU SOLVEUR :
      SOLVEU='&&OP0093.SOLVEUR'
      CALL CRESOL(SOLVEU,' ')


C     --- COMPATIBILITE DES MODES (DONNEES ALTEREES) ---
      CALL EXISD('MATR_ASSE',RAIDE,IBID)
      IF (IBID.NE.0) THEN
        CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,
     &              NUMEDD,IRET)
      ELSE
        NUMEDD=' '
      ENDIF
      CALL VPCREA(0,RESU,MASSE,AMOR,RAIDE,NUMEDD,IBID)
C
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

      CALL DISMOI('F','NOM_MAILLA'  ,RAIDE,'MATR_ASSE',IBID,NOMMA,IERD)
      CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,NUME ,IERD)
      CALL DISMOI('F','NB_EQUA'     ,RAIDE,'MATR_ASSE',NEQ ,K8B ,IERD)

C-- FACTORISATION DE LA MATRICE DE RAIDEUR
      RAIDFA = '&&MOIN93.RAIDFA'
      MATPRE = '&&MOIN93.MATPRE'
      CALL MTDEFS(RAIDFA,RAIDE,'V',' ')
      CALL MTCOPY(RAIDE,RAIDFA,IRET)
      CALL MTDSCR(RAIDFA)
      CALL JEVEUO(RAIDFA(1:19)//'.&INT','E',LMATR)
      CALL PRERES(SOLVEU,'V',IRET,MATPRE,RAIDFA,IBID,-9999)
      IF (IRET.EQ.2) THEN
         VALK = RAIDE
         CALL U2MESK('F', 'ALGELINE4_37',1,VALK)
      ENDIF

      CALL GETFAC ( 'MODE_STAT', NBMOST )
      CALL GETFAC ( 'FORCE_NODALE', NBFONA )
      CALL GETFAC ( 'PSEUDO_MODE', NBPSMO )
      CALL GETFAC ( 'MODE_INTERF', NBMOIN )

C-------------------------------------C
C--                                 --C
C-- CALCUL DES DIFERENTES DEFORMEES --C
C--                                 --C
C-------------------------------------C
      DDLCB='&&OP0093.DDL_STAT_DEPL'
      MOCB='&&OP0093.MODE_STAT_DEPL'
      DDLMN='&&OP0093.DDL_STAT_FORC'
      MOATTA='&&OP0093.MODE_STAT_FORC'
      MOAUNI='&&OP0093.MODE_STAT_ACCU'
      MOAIMP='&&OP0093.MODE_ACCE_IMPO'
      DDLAC=   '&&OP0093.DDL_ACCE_IMPO'
      MOINTF='&&MOIN93.MODE_INTF_DEPL'
      VEFREQ='&&MOIN93.FREQ_INTF_DEPL'

C-- CALCUL DES MODES DE CONTRAINTES (METHODE CRAIG & BAMPTON)
      IF (NBMOST .GT. 0) THEN
         CALL WKVECT(DDLCB,'V V I',NEQ,LDDLD)
         CALL MSTGET(NOMCMD,RAIDE,'MODE_STAT',NBMOST,ZI(LDDLD))
         DO 10 I = 0,NEQ-1
            NBMODD = NBMODD + ZI(LDDLD+I)
 10      CONTINUE
         CALL WKVECT(MOCB,'V V R',NEQ*NBMODD,LMODD)
         CALL MODSTA('DEPL',RAIDFA,MATPRE,SOLVEU,IBID,NUME,ZI(LDDLD),
     &               R8B,NEQ,NBMODD,ZR(LMODD))
      ENDIF

C-- CALCUL DES MODES D'ATTACHE (METHODE MAC NEAL)
      IF (NBFONA .GT. 0) THEN
         CALL WKVECT(DDLMN,'V V I',NEQ,LDDLF)
         CALL MSTGET(NOMCMD,RAIDE,'FORCE_NODALE',NBFONA,ZI(LDDLF))
         DO 20 I = 0,NEQ-1
            NBMODF = NBMODF + ZI(LDDLF+I)
 20      CONTINUE
         CALL WKVECT(MOATTA,'V V R',NEQ*NBMODF,LMODF)
         CALL MODSTA('FORC',RAIDFA,MATPRE,SOLVEU,IBID,NUME,ZI(LDDLF),
     &               R8B,NEQ,NBMODF,ZR(LMODF))
      ENDIF

C-- CALCUL DES PSEUDO MODES
      IF (NBPSMO .GT. 0) THEN
        CALL MTDSCR(MASSE)
        MASSFA=2
        CALL PSMO93(SOLVEU,MASSE,RAIDE,RAIDFA,NUME,NBPSMO,NBMODA,
     &              NBMOAD)
      ENDIF

C-- CALCUL DES MODES D'INTERFACE
      IF (NBMOIN .GT. 0) THEN
        IF (MASSFA .LT. 1) THEN
          CALL MTDSCR(MASSE)
        ENDIF
        CALL GETVIS('MODE_INTERF','NBMOD',1,1,1,NBMODI,IBID)
        CALL MOIN93(MASSE,RAIDE,RAIDFA,NBMODI,MOINTF,VEFREQ)
      ENDIF

C-----------------------------C
C--                         --C
C-- ARCHIVAGE DES RESULTATS --C
C--                         --C
C-----------------------------C

      CALL ARCH93(RESU,CONCEP,NUME,RAIDE,NBMODD,NBMODF,NBMODA,NBMOAD,
     &            NBMODI,NBPSMO)


      CALL JEDETR(DDLCB)
      CALL JEDETR(MOCB)
      CALL JEDETR(DDLMN)
      CALL JEDETR(MOATTA)
      CALL JEDETR(MOAUNI)
      CALL JEDETR(MOAIMP)
      CALL JEDETR(DDLAC)
      CALL JEDETR(MOINTF)
      CALL JEDETR(VEFREQ)

      CALL JEDEMA()

      END
