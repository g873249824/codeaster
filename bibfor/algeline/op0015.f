      SUBROUTINE OP0015(IER)
      IMPLICIT NONE
      INTEGER IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 08/10/2007   AUTEUR REZETTE C.REZETTE 
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
C     OPERATEUR RESOUDRE
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL ,IDENSD
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER IBID,IFM,NIV,NB,NBCINE,IRET,LMAT,IER1,JSLVR
      INTEGER NBSOL,LXSOL,LCINE,JREFA,MXITER,IREP
      CHARACTER*1 FTYPE(2)
      CHARACTER*4 MUMPS
      CHARACTER*8 XSOL,SECMBR,MATR,TYPE,VCINE,TYPV,METRES,MATF,OUINON
      CHARACTER*16 CONCEP,NOMCMD
      CHARACTER*19 XSOL19,VCIN19,MAT19,PCHN1,PCHN2,SOLVEU
      CHARACTER*24 VXSOL,VXCIN,CRITER
      CHARACTER*24 VALK(2)
      COMPLEX*16   CBID
      REAL*8       EPS,RBID
C     ------------------------------------------------------------------
      DATA FTYPE/'R','C'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C----------------------------------------------------------------------
C
C     --- RECUPERATION SUR LA COMMANDE ET SON RESULAT ---
      CALL GETRES(XSOL,CONCEP,NOMCMD)
      XSOL19 = XSOL
C
C     --- RECUPERATION DES NOMS DE LA MATRICE ET DU SECOND MEMBRE ---
C     --- ET EVENTUELLEMENT D'UN CHAM_CINE                        ---
      CALL GETVID('  ','MATR',0,1,1,MATR,NB)
      CALL GETVID('  ','CHAM_NO',0,1,1,SECMBR,NB)
      CALL CHPVER('F',SECMBR,'NOEU','*',IER)

      CALL GETVID('  ','CHAM_CINE',0,1,1,VCINE,NBCINE)
      IF (NBCINE.NE.0) THEN
        CALL CHPVER('F',VCINE,'NOEU','*',IER)
        VCIN19 = VCINE
      ELSE
        VCIN19 = ' '
      ENDIF
C
C     --- RECUPERATION DU SOLVEUR : MUMPS, GCPC, MULT_FRONT, LDLT
      CALL DISMOI('F','METH_RESO',MATR,'MATR_ASSE',IBID,METRES,IBID)
C
C
C --- CAS DU SOLVEUR GCPC :
C     ===================
      IF(METRES(1:4).EQ.'GCPC')THEN

C       MATRICE DE PRECONDITIONNEMENT
        CALL GETVID(' ','MATR_PREC',0,1,1,MATF,IRET)

        CALL GETVIS(' ','NMAX_ITER',0,1,1,MXITER,IBID)
        CALL GETVR8(' ','RESI_RELA',0,1,1,EPS,IBID)

C       REPRISE OU NON (XSOL INITIALISE OU NON LES ITERATIONS)
        IREP = 0
        CALL GETVTX(' ','REPRISE',0,1,1,OUINON,IRET)
        IF (OUINON.EQ.'OUI') IREP = 1

        CRITER = '&&RESGRA_GCPC'
        CALL RESGRA ( XSOL, MATR, SECMBR, VCIN19, MATF, 'G',
     &                IREP, MXITER, EPS, CRITER)

        GOTO 9999
      ENDIF
C
C
C --- CAS DES SOLVEURS MUMPS,LDLT,MULT_FRONT :
C     ======================================

C     -- ON VERIFIE QUE LE PROF_CHNO DE LA MATR_ASSE
C        EST IDENTIQUE A CELUI DU  SECOND_MEMBRE :
C     -----------------------------------------------
       CALL DISMOI('F','PROF_CHNO',MATR,'MATR_ASSE',IBID,PCHN1,IBID)
       CALL DISMOI('F','PROF_CHNO',SECMBR,'CHAM_NO',IBID,PCHN2,IBID)
       IF (.NOT.IDENSD('PROF_CHNO',PCHN1,PCHN2))
     & CALL U2MESS('F','ALGELINE2_22')

      CALL EXISD('CHAMP_GD',XSOL,IRET)
      IF (IRET.NE.0) THEN
C        --- VERIFICATION DES COMPATIBILITES --
         CALL VRREFE(SECMBR,XSOL,IRET)
         IF (IRET.NE.0) THEN
             VALK(1) = SECMBR
             VALK(2) = XSOL
             CALL U2MESK('F','ALGELINE2_23', 2 ,VALK)
         ENDIF
      ELSE
C        --- CREATION DU VECTEUR SOLUTION ---
         TYPE = ' '
         CALL VTDEFS(XSOL,SECMBR,'GLOBALE',TYPE)
      ENDIF
C
      IF (XSOL.NE.SECMBR) THEN
C        --- TRANSFERT DU SECOND MEMBRE DANS LE VECTEUR SOLUTION ---
         CALL VTCOPY(SECMBR,XSOL,IRET)
         CALL ASSERT(IRET.EQ.0)
      ENDIF

C     --- CHARGEMENT DES DESCRIPTEURS DE LA MATRICE A FACTORISER ---
      CALL MTDSCR(MATR)
      CALL JEVEUO(MATR//'           .&INT','E', LMAT )
      CALL ASSERT(LMAT.NE.0)

C     --- SI LA MATRICE A DES DDLS ELIM., IL FAUT RENSEIGNER CHAM_CINE:
      IF ((ZI(LMAT+7).GT.0).AND.(NBCINE.EQ.0)) THEN
            CALL U2MESS('F','ALGELINE2_24')
      ENDIF

      MAT19 = MATR
C
C
C     CAS DU SOLVEUR MUMPS :
C     ---------------------
      CALL DISMOI('F','EST_MUMPS',MAT19,'MATR_ASSE',IBID,MUMPS,IER1)
      IF (MUMPS.EQ.'OUI') THEN
         CALL DISMOI('F','SOLVEUR',MAT19,'MATR_ASSE',IBID,SOLVEU,IER1)
         CALL GETVR8(' ','RESI_RELA',1,1,1,EPS,IBID)
         CALL JEVEUO(SOLVEU//'.SLVR','E',JSLVR)
         ZR(JSLVR-1+2)=EPS
         CALL AMUMPS('RESOUD',SOLVEU,MATR,SECMBR,XSOL,VCINE,IRET)
         CALL ASSERT(IRET.EQ.0)
         CALL JEVEUO(MAT19//'.REFA','E',JREFA)
         ZK24(JREFA-1+8)='DECT'
         GO TO 9999
      END IF

C
C     CAS DES SOLVEUR LDLT,MULT_FRONT :
C     -------------------------------
      NBSOL = 1
C
C     ---RECUPERATION DU TABLEAU DEVANT CONTENIR LA SOLUTION ---
      VXSOL = XSOL19//'.VALE'
      VXCIN = VCIN19//'.VALE'
      CALL JEVEUO(VXSOL,'E',LXSOL)
      CALL JELIRA(VXSOL,'TYPE',IBID,TYPE)
      IF (VCIN19.NE.' ') THEN
        CALL JEVEUO(VXCIN,'L',LCINE)
        CALL JELIRA(VXCIN,'TYPE',IBID,TYPV)
      ELSE
        TYPV = TYPE
      ENDIF
C
C     --- CONTROLE DES TYPES ---
      IF (FTYPE(ZI(LMAT+3)).NE.TYPE(1:1)) THEN
         CALL U2MESS('F','ALGELINE2_25')
      ELSE IF (TYPV(1:1).NE.TYPE(1:1)) THEN
         CALL U2MESS('F','ALGELINE2_26')
      ELSE IF (TYPE(1:1).EQ.'R') THEN
         CALL CSMBGG(LMAT,ZR(LXSOL),ZR(LCINE),CBID,CBID,'R')
         CALL MRCONL(LMAT,0,' ',ZR(LXSOL),NBSOL)
         CALL RLDLGG(LMAT,ZR(LXSOL),CBID,NBSOL)
      ELSE IF (TYPE(1:1).EQ.'C') THEN
         CALL CSMBGG(LMAT,RBID,RBID,ZC(LXSOL),ZC(LCINE),'C')
         CALL MCCONL(LMAT,0,' ',ZC(LXSOL),NBSOL)
         CALL RLDLGG(LMAT,RBID,ZC(LXSOL),NBSOL)
      ELSE
         CALL U2MESS('F','ALGELINE2_27')
      ENDIF
C     --------------------------------------------------------------

9999  CONTINUE
      CALL TITRE
      CALL JEDEMA()
      END
