      SUBROUTINE CAMOAT (NOMRES,NUMREF,INTF,RAID,RAILDL,INORD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/07/2005   AUTEUR CIBHHPD L.SALMONA 
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
C  BUT:  CALCUL DES MODES D'ATTACHE (FORCE UNITAIRE IMPOSE)
C       A PARTIR D'UN CONCEPT INTERF_DYNA'
C      ET STOCKAGE DANS LE CONCEPT BASE_MODALE A PARTIR D'UN
C                  NUMERO D'ORDRE
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM DU CONCEPT RESULTAT
C NUMREF   /I/: NOM UT DU NUM_DDL DE REFERENCE
C INTF     /I/: NOM UT DE L'INTERF_DYNA EN AMONT
C RAID     /I/: NOM DE LA MATRICE RAIDEUR
C RAILDL   /M/: NOM DE LA MATRICE RAIDEUR FACTORISEE LDLT OU BLANC
C INORD    /M/: DERNIER NUMERO D'ORDRE UTILISE
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
      PARAMETER (NBCPMX=300)
      CHARACTER*6      PGC
      CHARACTER*8 NOMRES,INTF,TYPCOU,NOMNOE,NOMCMP,MAILLA
      CHARACTER*8 K8BID
      CHARACTER*19 NUMDDL,NUMREF
      CHARACTER*19 RAILDL,RAID
      CHARACTER*16 TYPDEF
      CHARACTER*24 DESDEF,DEEQ,TEMDDL,TEMPAR
      INTEGER IDEC(NBCPMX)
C
C-----------------------------------------------------------------------
      DATA PGC /'CAMOAT'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      TYPDEF='ATTACHE'
C
C---------------------RECHERCHE DU NUMDDL ASSOCIE A LA MATRICE----------
C
      CALL DISMOI('F','NOM_NUME_DDL',RAID,'MATR_ASSE',IBID,
     &             NUMDDL,IRET)
      NUMDDL(15:19)='.NUME'
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
C-----------REQUETTE ADRESSE DE LA TABLE DESCRIPTION DES DEFORMEES------
C
      DESDEF=INTF//'.IDC_DEFO'
      CALL JEVEUO(DESDEF,'L',LLDES)
      CALL JELIRA(DESDEF,'LONMAX',NBNOT,K8BID)
C**************************************************************
      NBNOT = NBNOT/(2+NBEC)
C      NBNOT=NBNOT/3
C**************************************************************
C
C------------REQUETTE ADRESSE DEFINITION INTERFACE ET TYPE--------------
C
      CALL JELIRA(INTF//'.IDC_LINO','NMAXOC',NBINT,K8BID)
      CALL JEVEUO(INTF//'.IDC_TYPE','L',LLTYP)
C
C-----------COMPTAGE DU NOMBRE DE NOEUDS MAC NEAL-----------------------
C
      NBDEB=NBNOT
      NBFIN=0
C
      DO 10 J=1,NBINT
        CALL JELIRA(JEXNUM(INTF//'.IDC_LINO',J),'LONMAX',NBNOE,
     &                      K8BID)
        TYPCOU=ZK8(LLTYP+J-1)
        IF(TYPCOU.EQ.'MNEAL   ') THEN
          CALL JEVEUO(JEXNUM(INTF//'.IDC_LINO',J),'L',LLNOIN)
          DO 15 I=1,NBNOE
            IK=ZI(LLNOIN+I-1)
            NBFIN=MAX(NBFIN,IK)
            NBDEB=MIN(NBDEB,IK)
 15       CONTINUE
          CALL JELIBE(JEXNUM(INTF//'.IDC_LINO',J))
        ENDIF
 10   CONTINUE
C
      CALL JELIBE(INTF//'.IDC_TYPE')
C
      IF(NBFIN.GT.0) THEN
        NBMN=NBFIN-NBDEB+1
      ELSE
        NBMN=0
      ENDIF
C
C
C----------ALLOCATION DU VECTEUR DES DDL A IMPOSER A 1------------------
C                    ET DES VALEURS DES PARAMETRES NOEUD_CMP
      NTAIL=NBMN*NBCMP
      IF(NTAIL.EQ.0) GOTO 9999
C
      TEMDDL='&&'//PGC//'.LISTE.DDL'
      TEMPAR='&&'//PGC//'.PARA.NOCMP'
      CALL WKVECT(TEMDDL,'V V I',NTAIL,LTDDL)
      CALL WKVECT(TEMPAR,'V V K16',NTAIL,LTPAR)
      IF(RAILDL.EQ.'                   ') THEN
        RAILDL='&&'//PGC//'.RAID.LDLT'
        CALL FACMTR(RAID,RAILDL,IER)
        IF (IER.EQ.-2) THEN
          CALL UTDEBM('F','FACMTR',' ARRET PROBLEME DE FACTORISATION:'
     &     //'PRESENCE PROBABLE DE MODES DE CORPS RIGIDE '
     &     //'LA METHODE DE MAC-NEAL NE FONCTIONNE PAS EN PRESENCE '
     &    //'DE MODES DE CORPS RIGIDE')
        CALL UTFINM
        ENDIF
      ENDIF
C
C
C-------------COMPTAGE ET REPERAGE DES DEFORMEES A CALCULER-------------
C
C
      NBATTA=0
C
      IF(NBMN.GT.0) THEN
        DO 20 I=NBDEB,NBFIN
C**************************************************************
C          ICOD=ZI(LLDES+2*NBNOT+I-1)
          CALL ISDECO(ZI(LLDES+2*NBNOT+(I-1)*NBEC+1-1),IDEC,NBCMP)
C**************************************************************
          INO=ZI(LLDES+I-1)
          CALL JENUNO (JEXNUM(MAILLA//'.NOMNOE',INO),NOMNOE)
          DO 30 J=1,NBCMP
            IF(IDEC(J).EQ.1) THEN
              NBATTA=NBATTA+1
              NOMCMP=ZK8(LLNCMP+J-1)
              ZK16(LTPAR+NBATTA-1)=NOMNOE//NOMCMP
              CALL CHEDDL(ZI(LLDEEQ),NEQ,INO,J,ZI(LTDDL+NBATTA-1),1)
            ENDIF
 30       CONTINUE
 20     CONTINUE
      ENDIF
C
C
C------------------CALCUL DES MODES D'ATTACHE---------------------------
C
C
      CALL DEFSTA(NOMRES,NUMREF,RAILDL,ZI(LTDDL),ZK16(LTPAR),1,
     &            NBATTA,TYPDEF,INORD)
C
C
C-------------------MENAGE----------------------------------------------
C
      CALL JEDETR(TEMDDL)
      CALL JEDETR(TEMPAR)
      CALL JELIBE(DEEQ)
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
