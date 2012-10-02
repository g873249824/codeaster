      SUBROUTINE OP0014()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 02/10/2012   AUTEUR DESOZA T.DESOZA 
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
C     ------------------------------------------------------------------
C     OPERATEUR FACTORISER
C     BUT: - FACTORISE UNE MATRICE ASSEMBLEE EN 2 MATRICES TRIANGULAIRES
C            (SOLVEUR MUMPS,MULT_FRONT,LDLT), OU
C          - DETERMINE UNE MATRICE DE PRECONDITIONNEMENT POUR L'ALGO DU
C            GRADIENT CONJUGUE PRCONDITIONNE (SOLVEUR GCPC)
C     ------------------------------------------------------------------

      INCLUDE 'jeveux.h'
      CHARACTER*3 KSTOP
      CHARACTER*4 KLAG2
      CHARACTER*24 VALK(2)
      CHARACTER*8 MATASS,MATFAC,TYPE,KTYPR,KTYPS,PRECON,MIXPRE
      CHARACTER*12 KOOC
      CHARACTER*16 CONCEP,NOMCMD,METRES
      CHARACTER*19 MASS,MFAC,SOLVEU,SOLVBD
      INTEGER NPREC,IATFAC,IBDEB,IBFIN,IBID,IER1,IFM,ILDEB,ILFIN
      INTEGER IRET,IRETGC,ISINGU,ISTOP,JADIA,PCPIV,NIREMP
      INTEGER LDTBLO,LFNBLO,NDECI,NEQ,NIV,NPVNEG
      INTEGER JSLVK,JSLVR,JSLVI,REACPR
      REAL*8 RBID,FILLIN,EPSMAT
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()

      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

      CALL GETRES(MATFAC,CONCEP,NOMCMD)
      MFAC = MATFAC
      CALL GETVID('  ','MATR_ASSE',0,IARG,1,MATASS,IBID)
      MASS = MATASS
      CALL DISMOI('F','METH_RESO',MASS,'MATR_ASSE',IBID,METRES,IBID)

      IF (METRES.EQ.'GCPC'.OR.METRES.EQ.'PETSC') THEN
        CALL UTTCPU('CPU.RESO.1','DEBUT',' ')
        CALL UTTCPU('CPU.RESO.4','DEBUT',' ')
      ENDIF


C     CAS DU SOLVEUR  GCPC :
C     ---------------------
      IF(METRES.EQ.'GCPC')THEN
C        VERIFICATION : CONCEPT REENTRANT INTERDIT
         CALL EXISD('MATR_ASSE',MATFAC,IRET)
         IF(IRET.EQ.1)THEN
           CALL U2MESS('F','ALGELINE5_56')
         ENDIF
C        VERIFICATION : MATR_ASSE A VALEURS COMPLEXES INTERDIT
         IF(CONCEP(16:16).EQ.'C')THEN
           CALL U2MESS('F','ALGELINE5_57')
         ENDIF

         CALL GETVTX(' ','PRE_COND',0,IARG,1,PRECON,IBID)

         IF (PRECON.EQ.'LDLT_INC') THEN
C          ON ECRIT DANS LA SD SOLVEUR LE TYPE DE PRECONDITIONNEU
           CALL DISMOI('F','SOLVEUR',MASS,'MATR_ASSE',IBID,SOLVEU,IER1)
           CALL JEVEUO(SOLVEU//'.SLVK','E',JSLVK)
           ZK24(JSLVK-1+2) = PRECON

           CALL GETVIS(' ','NIVE_REMPLISSAGE',0,IARG,1,NIREMP,IRET)
           CALL PCLDLT(MFAC,MASS,NIREMP,'G')
         ELSE IF (PRECON.EQ.'LDLT_SP') THEN
C          OBLIGATOIRE POUR AVOIR UN CONCEPT DE SORTIE SD_VERI OK
           IF (MASS.NE.MFAC) CALL COPISD('MATR_ASSE','G',MASS,MFAC)
C          ON EST OBLIGE DE MODIFIER DIRECTEMENT MASS
           MFAC=MASS
C          CREATION D'UN NOM UNIQUE POUR LA SD SOLVEUR MUMPS
C          SIMPLE PRECISION
           CALL GCNCON('.', SOLVBD)
C          LECTURE PARAMETRE
           CALL GETVIS(' ','REAC_PRECOND',0,IARG,1,REACPR,IBID)
           CALL GETVIS(' ','PCENT_PIVOT',0,IARG,1,PCPIV,IBID)

C      --- ON REMPLIT LA SD_SOLVEUR GCPC
           CALL DISMOI('F','SOLVEUR',MASS,'MATR_ASSE',IBID,SOLVEU,IER1)
           CALL JEVEUO(SOLVEU//'.SLVK','E',JSLVK)
           CALL JEVEUO(SOLVEU//'.SLVR','E',JSLVR)
           CALL JEVEUO(SOLVEU//'.SLVI','E',JSLVI)
           ZK24(JSLVK-1+1) = 'GCPC'
           ZK24(JSLVK-1+2) = PRECON
           ZK24(JSLVK-1+3) = SOLVBD
           ZI(JSLVI-1+5)   = 0
           ZI(JSLVI-1+6)   = REACPR
           ZI(JSLVI-1+7)   = PCPIV

C      --- APPEL A LA CONSTRUCTION DU PRECONDITIONNEUR
           CALL PCMUMP(MFAC,SOLVEU,IRETGC)
           IF (IRETGC.NE.0) THEN
             CALL U2MESS('F','ALGELINE5_76')
           ENDIF
         ENDIF

         GO TO 9999
      ENDIF


      CALL GETVIS('  ','NPREC',0,IARG,1,NPREC,IBID)
      CALL GETVTX('  ','STOP_SINGULIER',0,IARG,1,KSTOP,IBID)
      IF (KSTOP.EQ.'OUI') THEN
        ISTOP = 0
      ELSE IF (KSTOP.EQ.'NON') THEN
        ISTOP = 1
      ENDIF



C     CAS DU SOLVEUR MUMPS :
C     ----------------------
      IF (METRES.EQ.'MUMPS') THEN
         KOOC='AUTO'
         MIXPRE='NON'
         EPSMAT=-1.D0
         IF (MASS.NE.MFAC) CALL COPISD('MATR_ASSE','G',MASS,MFAC)
         CALL DISMOI('F','SOLVEUR',MASS,'MATR_ASSE',IBID,SOLVEU,IER1)
         CALL GETVIS(' ','PCENT_PIVOT',1,IARG,1,PCPIV,IBID)
         CALL GETVTX(' ','TYPE_RESOL',1,IARG,1,KTYPR,IBID)
         CALL GETVTX(' ','PRETRAITEMENTS',1,IARG,1,KTYPS,IBID)
         CALL GETVTX(' ','ELIM_LAGR2',1,IARG,1,KLAG2,IBID)
         CALL GETVTX(' ','GESTION_MEMOIRE',1,IARG,1,KOOC,IBID)
         CALL JEVEUO(SOLVEU//'.SLVI','E',JSLVI)
         CALL JEVEUO(SOLVEU//'.SLVK','E',JSLVK)
         CALL JEVEUO(SOLVEU//'.SLVR','E',JSLVR)
         ZI(JSLVI-1+1)  =NPREC
         ZI(JSLVI-1+2)  =PCPIV
         ZI(JSLVI-1+3)  =ISTOP
         ZK24(JSLVK-1+2)=KTYPS
         ZK24(JSLVK-1+3)=KTYPR
         ZK24(JSLVK-1+6)=KLAG2
         ZK24(JSLVK-1+7)=MIXPRE
         ZK24(JSLVK-1+8)='NON'
         ZK24(JSLVK-1+9)=KOOC
         ZK24(JSLVK-1+10)='XXXX'
         ZK24(JSLVK-1+11)='XXXX'
         ZK24(JSLVK-1+12)='XXXX'
         ZR(JSLVR-1+1)  =EPSMAT
         ILDEB = 1
         ILFIN = 0
      ENDIF


C     CAS DU SOLVEUR PETSC :
C     ----------------------
      IF (METRES.EQ.'PETSC') THEN
C        OBLIGATOIRE POUR AVOIR UN CONCEPT DE SORTIE SD_VERI OK
         IF (MASS.NE.MFAC) CALL COPISD('MATR_ASSE','G',MASS,MFAC)
C        ON EST OBLIGE DE MODIFIER DIRECTEMENT MASS
         MFAC=MASS
         CALL DISMOI('F','SOLVEUR',MASS,'MATR_ASSE',IBID,SOLVEU,IER1)
         CALL GETVTX(' ','PRE_COND'        ,0,IARG,1,PRECON ,IBID)
         CALL JEVEUO(SOLVEU//'.SLVK','E',JSLVK)
         CALL JEVEUO(SOLVEU//'.SLVR','E',JSLVR)
         CALL JEVEUO(SOLVEU//'.SLVI','E',JSLVI)
         ZK24(JSLVK-1+2) = PRECON

         IF (PRECON.EQ.'LDLT_INC') THEN
           CALL GETVIS(' ','NIVE_REMPLISSAGE',0,IARG,1,NIREMP,IBID)
           CALL GETVR8(' ','REMPLISSAGE'     ,0,IARG,1,FILLIN,IBID)
           ZR(JSLVR-1+3) = FILLIN
           ZI(JSLVI-1+4) = NIREMP
         ELSE IF (PRECON.EQ.'LDLT_SP') THEN
C          CREATION D'UN NOM UNIQUE POUR LA SD SOLVEUR MUMPS
C          SIMPLE PRECISION
           CALL GCNCON('.', SOLVBD)
C          LECTURE PARAMETRE
           CALL GETVIS(' ','REAC_PRECOND',0,IARG,1,REACPR,IBID)
           CALL GETVIS(' ','PCENT_PIVOT',0,IARG,1,PCPIV,IBID)
           ZK24(JSLVK-1+3) = SOLVBD
           ZI(JSLVI-1+5)   = 0
           ZI(JSLVI-1+6)   = REACPR
           ZI(JSLVI-1+7)   = PCPIV
         ELSE
           CALL ASSERT(.FALSE.)
         ENDIF
         CALL APETSC('DETR_MAT',' ',MFAC,RBID,' ',0,IBID,IRET)
         CALL APETSC('PRERES',SOLVEU,MFAC,RBID,' ',0,IBID,IRET)
         IRET=0
         GOTO 9999
      ENDIF


C     CAS DES SOLVEURS LDLT/MULT_FRONT/MUMPS :
C     -------------------------------------
C
C     --- RECUPERATION DES INDICES DE DEBUT ET FIN DE LA FACTORISATION -
C     - 1) AVEC DDL_XXX
      IF (METRES.NE.'MUMPS') THEN
        ILDEB = 1
        ILFIN = 0
        CALL GETVIS('  ','DDL_DEBUT',0,IARG,1,ILDEB,IBID)
        CALL GETVIS('  ','DDL_FIN',0,IARG,1,ILFIN,IBID)
C     - 2) AVEC BLOC_XXX
        IBDEB = 1
        IBFIN = 0
        CALL GETVIS('  ','BLOC_DEBUT',0,IARG,1,IBDEB,LDTBLO)
        CALL GETVIS('  ','BLOC_FIN',0,IARG,1,IBFIN,LFNBLO)


C     --- EXISTENCE / COMPATIBILITE DES MATRICES ---
        CALL MTEXIS(MFAC,IRET)
        IF (IRET.NE.0) THEN
          CALL VRREFE(MASS,MFAC,IER1)
          IF (IER1.NE.0) THEN
             VALK(1) = MATASS
             VALK(2) = MATFAC
             CALL U2MESK('F','ALGELINE2_18', 2 ,VALK)
          ELSE IF (MFAC.NE.MASS) THEN
            IF (ILDEB.EQ.1 .AND. IBDEB.EQ.1) THEN
              CALL MTCOPY(MASS,MFAC,IRET)
              CALL ASSERT(IRET.EQ.0)
            ENDIF
          ENDIF
        ELSE
          TYPE = ' '
          CALL MTDEFS(MFAC,MASS,'GLOBALE',TYPE)
          CALL MTCOPY(MASS,MFAC,IRET)
          CALL ASSERT(IRET.EQ.0)
        ENDIF
      ENDIF

C     --- CHARGEMENT DES DESCRIPTEURS DE LA MATRICE A FACTORISER ---
      CALL MTDSCR(MFAC)
      CALL JEVEUO(MFAC(1:19)//'.&INT','E',IATFAC)
      IF (IATFAC.EQ.0) THEN
        CALL U2MESK('F','ALGELINE2_19',1,MATFAC)
      ENDIF
      CALL MTDSC2(ZK24(ZI(IATFAC+1)),'SXDI','L',JADIA)

C     --- NEQ : NOMBRE D'EQUATIONS (ORDRE DE LA MATRICE) ---
      NEQ = ZI(IATFAC+2)

      IF (METRES.NE.'MUMPS') THEN

C     --- VERIFICATION DES ARGUMENTS RELATIF A LA PARTIE A FACTORISER --
C     --- 1) AVEC DDL_XXX
        IF (ILFIN.LT.ILDEB .OR. ILFIN.GT.NEQ) ILFIN = NEQ

C     --- 2) AVEC BLOC_XXX
        IF (LDTBLO.NE.0) THEN
          IF (IBDEB.LT.1) THEN
            CALL U2MESS('A','ALGELINE2_1')
            IBDEB = 1
          ELSE IF (IBDEB.GT.ZI(IATFAC+13)) THEN
            CALL U2MESS('F','ALGELINE2_20')
          ENDIF
          ILDEB = ZI(JADIA+IBDEB-2) + 1
        ENDIF
        IF (LFNBLO.NE.0) THEN
          IF (IBFIN.LT.1) THEN
            CALL U2MESS('F','ALGELINE2_21')
          ELSE IF (IBDEB.GT.ZI(IATFAC+13)) THEN
            CALL U2MESS('A','ALGELINE2_8')
            IBFIN = ZI(IATFAC+13)
          ENDIF
          ILFIN = ZI(JADIA+IBFIN-1)
        ENDIF

C     --- IMPRESSION SUR LE FICHIER MESSAGE ----------------------------
        IF (NIV.EQ.2) THEN
          WRITE(IFM,*)' +++ EXECUTION DE "',NOMCMD,'"'
          WRITE(IFM,*)'       NOM DE LA MATRICE ASSEMBLEE  "',MATASS,'"'
          WRITE(IFM,*)'       NOM DE LA MATRICE FACTORISEE "',MATFAC,'"'
          IF (ILDEB.EQ.1 .AND. ILFIN.EQ.NEQ) THEN
            WRITE(IFM,*)'     FACTORISATION COMPLETE DEMANDEE'
          ELSE
            WRITE(IFM,*)'     FACTORISATION PARTIELLE DE LA LIGNE',
     &        ILDEB,' A LA LIGNE ',ILFIN
          ENDIF
          WRITE(IFM,*)'     NOMBRE TOTAL D''EQUATIONS  ',NEQ
          WRITE(IFM,*)'     NB. DE CHIFFRES SIGNIF. (NPREC) ',NPREC
          WRITE(IFM,*)' +++ -------------------------------------------'
        ENDIF
      ENDIF


C     ------------------ FACTORISATION EFFECTIVE -------------------
      CALL TLDLGG(ISTOP,IATFAC,ILDEB,ILFIN,NPREC,NDECI,ISINGU,NPVNEG,
     &            IRET)
C     --------------------------------------------------------------

 9999 CONTINUE

      IF (METRES.EQ.'GCPC'.OR.METRES.EQ.'PETSC') THEN
        CALL UTTCPU('CPU.RESO.1','FIN',' ')
        CALL UTTCPU('CPU.RESO.4','FIN',' ')
      ENDIF

      CALL TITRE

      CALL JEDEMA()
      END
