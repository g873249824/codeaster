      SUBROUTINE PRERES(SOLVEU,BASE,IRET,MATPRE,MATASS)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 16/01/2006   AUTEUR BOITEAU O.BOITEAU 
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
C BUT : FACTORISER UNE MATR_ASSE (LDLT/MULT_FRONT)
C       OU FABRIQUER UNE MATRICE DE PRECONDITIONNEMENT (GCPC)
C
C SOLVEU(K19) IN : OBJET SOLVEUR
C BASE(K1) IN    : BASE SUR LAQUELLE ON CREE LES OBJETS DE LA FACTORISEE
C IRET(I) OUT CODE RETOUR :
C             /0 -> OK
C             /1 -> LA FACTORISATION EST ALLEE AU BOUT
C                   MAIS ON A PERDU BEAUCOUP DE DECIMALES
C             /2 -> LA FACTORISATION N'A PAS PU SE FAIRE
C                   JUSQU'AU BOUT.

C   REMARQUE : GCPC ET MUMPS RENDENT TOUJOURS IRET=0
C              (OU S'ARRETENT EN ERREUR FATALE !)

C MATPRE(K19) IN/JXVAR : MATRICE DE PRECONDITIONNEMENT (GCPC)
C MATASS(K19) IN/JXVAR : MATRICE A FACTORISER OU A PRECONDITIONNER
C-----------------------------------------------------------------------
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*1 BASE
      CHARACTER*19  SOLVEU
      CHARACTER*(*) MATASS,MATPRE

C FONCTIONS JEVEUX
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI ,NIREMP
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C VARIABLES LOCALES
      INTEGER      NBSD,IDD,IDD0,IFETM,IFETS,IDBGAV,IFM,NIV,ISLVK,IBID,
     &             ISLVI,LMAT,IDIME,NPREC,ISTOP,NDECI,ISINGU,NPVNEG,
     &             IRET,NBMOCR,NBSDF,IINF,IFCPU,NBPROC,ILIMPI
      REAL*8       TEMPS(6)
      CHARACTER*24 METRES,SDFETI,INFOFE
      CHARACTER*19 MATAS,MAPREC,SOLVSD,MATAS1
      CHARACTER*8  NOMSD
      CHARACTER*4  ETAMAT
      LOGICAL      LFETI,IDDOK,LFETIC

C CORPS DU PROGRAMME
      CALL JEMARQ()
      CALL JEDBG2(IDBGAV,0)
C RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)

C----------------------------------------------------------------------
      MATAS1=MATASS
      MATAS = MATASS
      MAPREC = MATPRE
      CALL JEVEUO(SOLVEU//'.SLVK','L',ISLVK)
      METRES = ZK24(ISLVK)
      CALL JELIRA(MATAS//'.REFA','DOCU',IBID,ETAMAT)

C MATRICE JUSTE ASSEMBLEE OU DEJA PASSES PAR PRERES ?
      IF (ETAMAT.EQ.'DECP'.OR.ETAMAT.EQ.'DECT') THEN
        IF (METRES.EQ.'LDLT'.OR.METRES.EQ.'MULT_FRO'.OR.METRES.EQ
     &     .'FETI') THEN
          IF (NIV.EQ.2)  WRITE(IFM,*) '  PAS DE DECOMPOSITION '//
     +       'CAR LA MATRICE '//MATAS//' EST DEJA DECOMPOSEE.'
        ELSE IF (METRES.EQ.'GCPC') THEN
          IF (NIV.EQ.2)   WRITE(IFM,*) '  LA MATRICE DE '//
     +         'PRECONDITIONNEMENT '//MAPREC//' EXISTE DEJA, '//
     +         'ON NE LA RECALCULE PAS.'
        ENDIF
        GOTO 9999
      ENDIF

C BOUCLE SUR LES SOUS-DOMAINES SI FETI
      LFETIC=.FALSE.
      IF (METRES(1:4).EQ.'FETI') THEN
        LFETI=.TRUE.
        SDFETI=ZK24(ISLVK+5)
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE=ZK24(IINF)
        IF (INFOFE(11:11).EQ.'T') LFETIC=.TRUE.
        CALL JEVEUO(SDFETI(1:19)//'.FDIM','L',IDIME)
C NOMBRE DE SOUS-DOMAINES
        NBSD=ZI(IDIME)
        NBSDF=0
        IDD0=1
C ADRESSE JEVEUX DE LA LISTE DES MATR_ASSE ET DE SOLVEURS ASSOCIES
C AUX SOUS-DOMAINES
        CALL JEVEUO(MATAS//'.FETM','L',IFETM)
        CALL JEVEUO(SOLVEU//'.FETS','L',IFETS)
C MAJ DE L'ETAMAT DU DOMAINE GLOBAL JUSTE UTILE POUR FRANCHIR RESOUD
C ET LE RECOPIE DU SECOND MEMBRE EN VECTEUR SOLUTION
        ETAMAT = 'DECT'
        CALL JEECRA(MATAS//'.REFA','DOCU',IBID,ETAMAT)
        CALL JEVEUO('&FETI.INFO.CPU.FACN','E',IFCPU)
C ADRESSE JEVEUX OBJET FETI & MPI
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
      ELSE
        LFETI=.FALSE.
        NBSD=0
        IDD0=0
        INFOFE='FFFFFFFFFFFFFFFFFFFFFFFF'
      ENDIF

C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
C IDD=0 --> DOMAINE GLOBAL/ IDD=I --> IEME SOUS-DOMAINE
      DO 100 IDD=IDD0,NBSD

C TRAVAIL PREALABLE POUR DETERMINER SI ON EFFECTUE LA BOUCLE SUIVANT
C LE SOLVEUR (FETI OU NON), LE TYPE DE RESOLUTION (PARALLELE OU 
C SEQUENTIELLE) ET L'ADEQUATION "RANG DU PROCESSEUR-NUMERO DU SD"
C ATTENTION SI FETI LIBERATION MEMOIRE PREVUE EN FIN DE BOUCLE
        IF (.NOT.LFETI) THEN
          IDDOK=.TRUE.
        ELSE 
          IF (ZI(ILIMPI+IDD).EQ.1) THEN
            IDDOK=.TRUE.
          ELSE
            IDDOK=.FALSE.
          ENDIF
        ENDIF
        IF (IDDOK) THEN
        
          IF (LFETI) CALL JEMARQ()
C CALCUL TEMPS
          IF ((NIV.GE.2).OR.(LFETIC)) THEN
            CALL UTTCPU(52,'INIT ',6,TEMPS)
            CALL UTTCPU(52,'DEBUT',6,TEMPS)
          ENDIF

C MATR_ASSE ASSOCIEE A CHAQUE SOUS-DOMAINE
          IF (IDD.GT.0) THEN
            MATAS=ZK24(IFETM+IDD-1)(1:19)
            SOLVSD=ZK24(IFETS+IDD-1)(1:19)
            CALL JEVEUO(SOLVSD//'.SLVK','L',ISLVK)
            METRES = ZK24(ISLVK)
            CALL JEVEUO(SOLVSD//'.SLVI','L',ISLVI)
          ELSE
            CALL JEVEUO(SOLVEU//'.SLVI','L',ISLVI)
          ENDIF

C ALLOCATION OBJET JEVEUX TEMPORAIRE .&INT/&IN2
          CALL MTDSCR(MATAS)
          CALL JEVEUO(MATAS//'.&INT','E',LMAT)

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C             MULTIFRONTALE OU LDLT                        C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          IF (METRES.EQ.'LDLT'.OR.METRES.EQ.'MULT_FRO') THEN
            IF (LFETI.AND.(METRES.EQ.'LDLT'))
     &        CALL UTMESS('F','PRERES',
     &        'SOLVEUR INTERNE LDLT POUR L''INSTANT PROSCRIT'//
     &        '  AVEC FETI')
            NPREC = ZI(ISLVI-1+1)
            ISTOP = ZI(ISLVI-1+3)
            IF (LFETI) THEN
              CALL FETFAC(LMAT,MATAS,IDD,NPREC,NBSD,MATAS1,SDFETI,NBSDF,
     &                    BASE,INFOFE)
            ELSE
              CALL TLDLGG(ISTOP,LMAT,1,0,NPREC,NDECI,ISINGU,NPVNEG,IRET)
            ENDIF

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                         MUMPS                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          ELSE IF (METRES.EQ.'MUMPS') THEN
            IF (LFETI)
     &        CALL UTMESS('F','PRERES',
     &        'SOLVEUR INTERNE MUMPS POUR L''INSTANT PROSCRIT'//
     &        '  AVEC FETI')
              CALL AMUMPS('DETR_MAT',' ',MATAS,' ',' ',' ')
              CALL AMUMPS('PRERES',SOLVEU,MATAS,' ',' ',' ')
              IRET=0

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                         GCPC                             C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          ELSE IF (METRES.EQ.'GCPC') THEN
            IF (LFETI)
     &        CALL UTMESS('F','PRERES',
     &        'SOLVEUR INTERNE GCPC POUR L''INSTANT PROSCRIT'//
     &        '  AVEC FETI')
            IRET=0
            NIREMP = ZI(ISLVI-1+4)
            CALL PCLDLT(MAPREC,MATAS,NIREMP,BASE)
          ENDIF

          IF ((NIV.GE.2).OR.(LFETIC)) THEN
            CALL UTTCPU(52,'FIN  ',6,TEMPS)
            IF (NIV.GE.2) WRITE(IFM,'(A44,D11.4,D11.4)')
     &         'TEMPS CPU/SYS FACTORISATION NUM           : ',TEMPS(5),
     &          TEMPS(6)
            IF (LFETIC) ZR(IFCPU+IDD)=TEMPS(5)+TEMPS(6)
          ENDIF
          IF (LFETI) CALL JEDEMA()
         
C========================================
C FIN BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================  
        ENDIF
  100 CONTINUE

 9999 CONTINUE

      CALL JEDBG2(IBID,IDBGAV)
      CALL JEDEMA()
      END
