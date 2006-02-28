      SUBROUTINE UALFVA(MATAZ,BASZ)
      IMPLICIT NONE
      CHARACTER*(*) MATAZ,BASZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 28/02/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CREATION DE L'OBJET MATAZ.VALM A PARTIR DE L'OBJET MATAZ.UALF
C     L'OBJET .UALF DOIT CONTENIR LA MATRICE INITIALE NON FACTORISEE :
C       - ON CREE L'OBJET.VALM
C       - ON DETRUIT .UALF (A LA FIN DE LA ROUTINE)
C       - ON CREE LE STOCKAGE MORSE DANS LE NUME_DDL S'IL N'EXISTE PAS.
C
C     CETTE ROUTINE NE DEVRAIT ETRE UTILISEE QUE RAREMENT :
C        LORSQUE LA MATR_ASSE A ETE CREE SOUS LA FORME .UALF POUR DES
C        RAISONS HISTORIQUES.
C
C     ------------------------------------------------------------------
C IN  JXVAR K19 MATAZ     : NOM D'UNE S.D. MATR_ASSE
C IN        K1  BASZ      : BASE DE CREATION POUR .VALM
C                  SI BASZ=' ' ON PREND LA MEME BASE QUE CELLE DE .UALF
C     REMARQUE : ON DETRUIT L'OBJET .UALF
C     ------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C-----------------------------------------------------------------------
C     VARIABLES LOCALES
      CHARACTER*1  BASE,KBID,TYRC
      CHARACTER*14 NU
      CHARACTER*19 STOMOR,STOLCI,MATAS
      LOGICAL LDIAG, LPLEIN
      INTEGER JSCDE,NEQ,NBLOC,IBID,NBLOCM,IRET
      INTEGER JSMHC, JSMDI, JSCDI, JSCHC,JSMDE
      INTEGER ITBLOC,IEQ,IBLOC,JUALF,JVALE,KTERM,NBTERM,ILIG
      INTEGER ISMDI,ISMDI0,IBLOAV,ISCDI,JREFA,JSCIB,KBLOCM,NBLOCL
C     ------------------------------------------------------------------



      CALL JEMARQ()
      MATAS=MATAZ
      BASE=BASZ
      IF (BASE.EQ.' ') CALL JELIRA(MATAS//'.UALF','CLAS',IBID,BASE)

C     -- .VALM NE DOIT PAS EXISTER :
      CALL JEEXIN(MATAS//'.VALM',IRET)
      CALL ASSERT(IRET.EQ.0)

      CALL JEVEUO(MATAS//'.REFA','L',JREFA)
      NU=ZK24(JREFA-1+2)(1:14)
      STOMOR=NU//'.SMOS'
      STOLCI=NU//'.SLCS'

      CALL JEVEUO(STOLCI//'.SCDE','L',JSCDE)
      CALL JEVEUO(STOLCI//'.SCDI','L',JSCDI)
      CALL JEVEUO(STOLCI//'.SCHC','L',JSCHC)
      CALL JEVEUO(STOLCI//'.SCIB','L',JSCIB)
      NEQ=ZI(JSCDE-1+1)
      NBLOC= ZI(JSCDE-1+3)

C     -- SI STOMOR N'EXISTE PAS, ON LE CREE :
      CALL JEEXIN(STOMOR//'.SMDI',IRET)
      IF (IRET.EQ.0) THEN
C        -- ON NE SAIT TRAITER QUE LES MATRICES DIAGONALES OU PLEINES :
         LDIAG=.TRUE.
         LPLEIN=.TRUE.
         DO 5,IEQ=1,NEQ
            IF (ZI(JSCHC-1+IEQ).NE.1) LDIAG=.FALSE.
            IF (ZI(JSCHC-1+IEQ).NE.IEQ) LPLEIN=.FALSE.
            IF (LDIAG) THEN
               CALL CRSMOS(STOMOR,'DIAG',NEQ)
            ELSE
               IF (LPLEIN) THEN
                  CALL CRSMOS(STOMOR,'PLEIN',NEQ)
               ELSE
                  CALL ASSERT(.FALSE.)
               ENDIF
            ENDIF

 5       CONTINUE
      ENDIF

      CALL JEVEUO(STOMOR//'.SMDI','L',JSMDI)
      CALL JEVEUO(STOMOR//'.SMHC','L',JSMHC)
      CALL JEVEUO(STOMOR//'.SMDE','L',JSMDE)
      ITBLOC= ZI(JSMDE-1+2)

      CALL JELIRA(MATAS//'.UALF','NMAXOC',NBLOCL,KBID)
      CALL ASSERT(NBLOCL.EQ.NBLOC .OR. NBLOCL.EQ.2*NBLOC)
      NBLOCM=1
      IF (NBLOCL.EQ.2*NBLOC) NBLOCM=2

C     -- REEL OU COMPLEXE ?
      CALL JELIRA(MATAS//'.UALF','TYPE',IBID,TYRC)
      CALL ASSERT(TYRC.EQ.'R' .OR. TYRC.EQ.'C')


C     1. ALLOCATION DE .VALM :
C     ----------------------------------------
      CALL JECREC(MATAS//'.VALM', BASE//' V '//TYRC,'NU','DISPERSE',
     &            'CONSTANT',NBLOCM)
      CALL JEECRA(MATAS//'.VALM','LONMAX',ITBLOC,KBID)
      DO 3,KBLOCM=1,NBLOCM
         CALL JECROC(JEXNUM(MATAS//'.VALM',KBLOCM))
3     CONTINUE


C     2. REMPLISSAGE DE .VALM :
C     ----------------------------------------
      DO 10, KBLOCM=1,NBLOCM
        CALL JEVEUO(JEXNUM(MATAS//'.VALM',KBLOCM),'E',JVALE)
        IBLOAV=0+NBLOC*(KBLOCM-1)
        ISMDI0=0
        DO 1, IEQ=1,NEQ
           ISCDI=ZI(JSCDI-1+IEQ)
           IBLOC=ZI(JSCIB-1+IEQ)+NBLOC*(KBLOCM-1)

C          -- ON RAMENE LE BLOC EN MEMOIRE SI NECESSAIRE:
           IF (IBLOC.NE.IBLOAV) THEN
              CALL JEVEUO(JEXNUM(MATAS//'.UALF',IBLOC),'L',JUALF)
              IF (IBLOAV.NE.0) THEN
                   CALL JELIBE(JEXNUM(MATAS//'.UALF',IBLOAV))
              ENDIF
              IBLOAV=IBLOC
           ENDIF

           ISMDI=ZI(JSMDI-1+IEQ)
           NBTERM=ISMDI-ISMDI0

           DO 2, KTERM=1,NBTERM
              ILIG=ZI(JSMHC-1+ISMDI0+KTERM)
              IF (TYRC.EQ.'R') THEN
                 ZR(JVALE-1+ISMDI0+KTERM)=ZR(JUALF-1+ ISCDI +ILIG-IEQ)
              ELSE
                 ZC(JVALE-1+ISMDI0+KTERM)=ZC(JUALF-1+ ISCDI +ILIG-IEQ)
              ENDIF
2          CONTINUE
           CALL ASSERT(ILIG.EQ.IEQ)

           ISMDI0=ISMDI
1       CONTINUE
10    CONTINUE



      CALL JEDETR(MATAS//'.UALF')

      CALL JEDEMA()
C     CALL VERISD('MATRICE',MATAS)
      END
