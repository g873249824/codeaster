      SUBROUTINE CAMOCO (NOMRES,NUMREF,INTF,RAID,RAILDL,INORD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2000   AUTEUR DURAND C.DURAND 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT:  CALCUL DES MODES CONTRAINTS (DEPLACEMENT UNITAIRE IMPOSE)
C      ET STOCKAGE DANS LE CONCEPT MODE MECA A PARTIR D'UN
C                  NUMERO D'ORDRE
C-----------------------------------------------------------------------
C
C NOMRES    /I/: NOM DU CONCEPT RESULTAT
C NUMREF   /I/: NOM UT DU NUM_DDL DE REFERENCE
C INTF     /I/: NOM UT DE L'INTERF_DYNA EN AMONT
C RAID      /I/: NOM DE LA MATRICE RAIDEUR
C RAILDL    /M/: NOM DE LA MATRICE RAIDEUR FACTORISEE LDLT OU BLANC
C INORD     /M/: DERNIER NUMERO D'ORDRE UTILISE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      PARAMETER    (NBCPMX=300)
      CHARACTER*6  PGC
      CHARACTER*8  K8BID
      CHARACTER*8  NOMRES,INTF,TYPCOU,NOMNOE,NOMCMP,MAILLA
      CHARACTER*19 NUMREF,NUMDDL
      CHARACTER*19 RAILDL,RAID
      CHARACTER*16 TYPDEF
      CHARACTER*24 DESDEF,DEEQ,TEMDDL,TEMPAR
      INTEGER     IDEC(NBCPMX)
C
C-----------------------------------------------------------------------
      DATA PGC /'CAMOCO'/
C-----------------------------------------------------------------------
C
C
      CALL JEMARQ()
      TYPDEF='CONTRAINT'
C
C---------------------RECHERCHE DU NUMDDL ASSOCIE A LA MATRICE----------
C
      CALL DISMOI('F','NOM_NUME_DDL',RAID,'MATR_ASSE',IBID,NUMDDL,
     &IRET)
C
C---------------------REQUETTE DU DEEQ DU NUMDDL------------------------
C
      NUMDDL(15:19)='.NUME'
      DEEQ=NUMDDL//'.DEEQ'
      CALL JEVEUO(DEEQ,'L',LLDEEQ)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8BID,IRET)
C
C--------------------RECUPERATION DU MAILLAGE---------------------------
C
      CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IBID,MAILLA,IRET)
C
C----RECUPERATION DES DONNEES RELATIVES A LA GRANDEUR SOUS-JACENTE------
C
      CALL DISMOI('F','NB_CMP_MAX',INTF,'INTERF_DYNA',
     &           NBCMP,K8BID,IRET)
      CALL DISMOI('F','NB_EC',INTF,'INTERF_DYNA',NBEC,
     &            K8BID,IRET)
      CALL DISMOI('F','NUM_GD',INTF,'INTERF_DYNA',
     &           NUMGD,K8BID,IRET)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',LLNCMP)
C
C
C-----------REQUETTE ADRESSE DE LA TABLE DESCRIPTION DES DEFORMEES------
C
      DESDEF=INTF//'      .INTD.DEFO'
      CALL JEVEUO(DESDEF,'L',LLDES)
      CALL JELIRA(DESDEF,'LONMAX',NBNOT,K8BID)
C**************************************************************
      NBNOT = NBNOT/(2+NBEC)
C      NBNOT=NBNOT/3
C**************************************************************
C
C
C------------REQUETTE ADRESSE DEFINITION INTERFACE ET TYPE--------------
C
      CALL JELIRA(INTF//'      .INTD.LINO','NMAXOC',NBINT,K8BID)
      CALL JEVEUO(INTF//'      .INTD.TYPE','L',LLTYP)
C
C-----------COMPTAGE DU NOMBRE DE NOEUDS CRAIG BAMPT--------------------
C
      NBDEB=NBNOT
      NBFIN=0
C
      DO 10 J=1,NBINT
        CALL JELIRA(JEXNUM(INTF//'      .INTD.LINO',J),'LONMAX',NBNOE,
     &                      K8BID)
        TYPCOU=ZK8(LLTYP+J-1)
        IF(TYPCOU.EQ.'CRAIGB   ') THEN
          CALL JEVEUO(JEXNUM(INTF//'      .INTD.LINO',J),'L',LLNOIN)
          DO 15 I=1,NBNOE
            IK=ZI(LLNOIN+I-1)
            NBFIN=MAX(NBFIN,IK)
            NBDEB=MIN(NBDEB,IK)
 15       CONTINUE
          CALL JELIBE(JEXNUM(INTF//'      .INTD.LINO',J))
        ENDIF
 10   CONTINUE
C
      CALL JELIBE(INTF//'      .INTD.TYPE')
C
      IF(NBFIN.GT.0) THEN
        NBCB=NBFIN-NBDEB+1
      ELSE
        NBCB=0
      ENDIF
C
C
C----------ALLOCATION DU VECTEUR DES DDL A IMPOSER A 1------------------
C
      NTAIL1=(NBCB*NBCMP)*2
      NTAIL2=(NBCB*NBCMP)
C
C  TAILLE DOUBLE CAR PRESENCE EVENTUELLE DE DOUBLE LAGRANGE POUR LE
C   BLOCAGE
C
      IF(NTAIL1.EQ.0) GOTO 9999
      TEMDDL='&&'//PGC//'.LISTE.DDL'
      TEMPAR='&&'//PGC//'.PARA.NOCMP'
      CALL WKVECT(TEMDDL,'V V I',NTAIL1,LTDDL)
      CALL WKVECT(TEMPAR,'V V K16',NTAIL2,LTPAR)
      IF(RAILDL.EQ.'                  ') THEN
        RAILDL='&&'//PGC//'.RAID.LDLT'
        CALL FACMTR(RAID,RAILDL,IER)
      ENDIF
C
C-------------COMPTAGE ET REPERAGE DES DEFORMEES A CALCULER-------------
C
      NBCONT=0
C
      IF(NBCB.GT.0) THEN
        DO 20 I=NBDEB,NBFIN
C**************************************************************
C          ICOD=ZI(LLDES+2*NBNOT+I-1)
          CALL ISDECO(ZI(LLDES+2*NBNOT+(I-1)*NBEC+1-1),IDEC,NBCMP)
C**************************************************************
          INO=ZI(LLDES+I-1)
          CALL JENUNO (JEXNUM(MAILLA//'.NOMNOE',INO),NOMNOE)
          DO 30 J=1,NBCMP
            IF(IDEC(J).EQ.1) THEN
              JJ=-J
              NBCONT=NBCONT+1
              NOMCMP=ZK8(LLNCMP+J-1)
              ZK16(LTPAR+NBCONT-1)=NOMNOE//NOMCMP
              IAD=LTDDL+(NBCONT-1)*2
              CALL CHEDDL(ZI(LLDEEQ),NEQ,INO,JJ,ZI(IAD),2)
            ENDIF
 30       CONTINUE
 20     CONTINUE
      ENDIF
C
C
C
C------------------CALCUL DES MODES CONTRAINTS--------------------------
C
      CALL DEFSTA(NOMRES,NUMREF,RAILDL,ZI(LTDDL),ZK16(LTPAR),2,
     &            NBCONT,TYPDEF,INORD)
C
C----------------------MENAGE-------------------------------------------
C
       CALL JEDETR(TEMDDL)
       CALL JEDETR(TEMPAR)
       CALL JELIBE(DEEQ)
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
