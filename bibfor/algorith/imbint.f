      SUBROUTINE IMBINT ( NOMRES, IFM )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C***********************************************************************
C    P. RICHARD     DATE 21/02/1991
C-----------------------------------------------------------------------
C  BUT:  IMPRIMER LES RESULTATS RELATIFS A LA BASE MODALE
      IMPLICIT NONE
C
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM DU CONCEPT RESULTAT
C MAILLA   /I/: NOM DU MAILLA
C IFM      /I/: UMITE DU FICHIER MESSAGE
C
C
C
C
C
      INCLUDE 'jeveux.h'
C-----------------------------------------------------------------------
      INTEGER I ,IBID ,IDAU ,IDCB ,IDDA ,IDHA ,IDMN 
      INTEGER IFAU ,IFCB ,IFHA ,IFMN ,INO ,IPOIN ,IRET 
      INTEGER ITYP ,J ,K ,LLACT ,LLDES ,LLDESC ,LLNCMP 
      INTEGER LLNOE ,LLTYP ,NBCMP ,NBCPMX ,NBDEF ,NBEC ,NBINT 
      INTEGER NBNO ,NBNOT ,NCOMP ,NUMGD 
C-----------------------------------------------------------------------
      PARAMETER    (NBCPMX=300)
      CHARACTER*1  K1BID
      CHARACTER*8  NOMCOU,TYPCOU,NOMNOE,TYP,TYPBAS(3),NOMTYP
      CHARACTER*8  NOMRES,MAILLA,FLEC,CRAIGB,MNEAL,AUCUN,CBHARM
      CHARACTER*8  K8BID
      CHARACTER*16 TYDEF
      CHARACTER*11 DACTIF
      CHARACTER*24 NOMINT,TYPINT,NOEINT,DESDEF,DDACT
      CHARACTER*80 CHAINE
      INTEGER      IDEC(NBCPMX), IFM
C
      INTEGER IBID1
      DATA IBID1/0/
C
C-----------------------------------------------------------------------
      DATA MNEAL,CRAIGB,AUCUN,FLEC /'MNEAL','CRAIGB','AUCUN','--->'/
      DATA CBHARM /'CB_HARMO'/
      DATA DACTIF /'DDL_ACTIF: '/
      DATA TYPBAS / 'CONNUE','CYCLIQUE','RITZ'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      WRITE(IFM,*)' '
      WRITE(IFM,*)'----------------------------------------------------'
      WRITE(IFM,*)' '
      WRITE(IFM,*)'                DEFI_INTERF_DYNA '
      WRITE(IFM,*)' '
      WRITE(IFM,*)'  IMPRESSIONS NIVEAU: 2 '
      WRITE(IFM,*)' '
C
C--------------RECUPERATION DU NOM DU MAILLA--------------------------
C
      CALL DISMOI('F','NOM_MAILLA',NOMRES,'INTERF_DYNA',IBID,MAILLA,
     &            IBID1)
C
C--------------RECUPERATION TYPE LIST_INTERFACE-------------------------
C
      CALL JEVEUO(NOMRES//'.IDC_DESC','L',LLDESC)
        ITYP=ZI(LLDESC)
      CALL JELIBE(NOMRES//'.IDC_DESC')
C
      NOMTYP=TYPBAS(ITYP)
C
C----RECUPERATION DES DONNEES RELATIVES A LA GRANDEUR SOUS-JACENTE------
C
      CALL DISMOI('F','NB_CMP_MAX',NOMRES,'INTERF_DYNA',
     &           NBCMP,K8BID,IRET)
      CALL DISMOI('F','NB_EC',NOMRES,'INTERF_DYNA',NBEC,
     &            K8BID,IRET)
      CALL DISMOI('F','NUM_GD',NOMRES,'INTERF_DYNA',
     &           NUMGD,K8BID,IRET)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',LLNCMP)
C
C--------------------INITIALISATION DES MOTS USUELS---------------------
C
      DESDEF=NOMRES//'.IDC_DEFO'
      NOMINT=NOMRES//'.IDC_NOMS'
      TYPINT=NOMRES//'.IDC_TYPE'
      NOEINT=NOMRES//'.IDC_LINO'
      DDACT=NOMRES//'.IDC_DDAC'
C
      CALL JEVEUO(TYPINT,'L',LLTYP)
      CALL JEVEUO(DESDEF,'L',LLDES)
      CALL JELIRA(NOMINT,'NOMMAX',NBINT,K1BID)
      CALL JELIRA(DESDEF,'LONMAX',NBNOT,K1BID)
      NBNOT=NBNOT/(2+NBEC)
C
      IDAU=NBNOT+1
      IDMN=NBNOT+1
      IDCB=NBNOT+1
      IDHA=NBNOT+1
      IFCB=0
      IFMN=0
      IFAU=0
      IFHA=0
C
      WRITE(IFM,*) ' '
      WRITE(IFM,*) ' NOM DE L'' INTERF_DYNA: ',NOMRES
      WRITE(IFM,*) '-------------------------- '
C
      WRITE(IFM,*) ' '
      WRITE(IFM,*) ' TYPE : ',NOMTYP
      WRITE(IFM,*) '------ '
C
      WRITE(IFM,*) ' '
      WRITE(IFM,*) ' DEFINITION DES INTERFACES'
      WRITE(IFM,*) '--------------------------- '
C
C  BOUCLE SUR LES INTERFACES
C
      DO 10 I=1,NBINT
        WRITE(IFM,*) ' '
        WRITE(IFM,*) ' '
        TYPCOU=ZK8(LLTYP+I-1)
        CALL JEVEUO(JEXNUM(DDACT,I),'L',LLACT)
        CALL JENUNO(JEXNUM(NOMINT,I),NOMCOU)
        CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNOE)
        CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
        WRITE(IFM,*)' INTERFACE: ',NOMCOU
        WRITE(IFM,*) '---------- '
        WRITE(IFM,*)'              TYPE: ',TYPCOU
        WRITE(IFM,*) ' '
          WRITE(IFM,*) ' LISTE DES NOEUDS:  NOMBRE: ',NBNO
          WRITE(IFM,*) ' '
C
C  BOUCLE SUR LES NOEUDS DE L'INTERFACE COURANTE
C
          DO 20 J=1,NBNO
            IPOIN=ZI(LLNOE+J-1)
            CALL ISDECO(ZI(LLACT+(J-1)*NBEC+1-1),IDEC,NBCMP)
            IDDA=1
            DO 25 K=1,NBCMP
              IF(IDEC(K).GT.0) THEN
                CHAINE(IDDA:IDDA+7)=ZK8(LLNCMP+K-1)
                IDDA=IDDA+8
              ENDIF
 25         CONTINUE
            IDDA=IDDA-1
            INO=ZI(LLDES+IPOIN-1)
            CALL JENUNO (JEXNUM(MAILLA//'.NOMNOE',INO),NOMNOE)
            IF (IDDA.LT.1) THEN
               WRITE(IFM,*)'NOEUD: ',J,FLEC,NOMNOE,' ',DACTIF,
     &         'PAS DE DDL ACTIF'
               GO TO 100
            ENDIF
            WRITE(IFM,*)'NOEUD: ',J,FLEC,NOMNOE,' ',DACTIF,
     &CHAINE(1:IDDA)
100         CONTINUE
C
C  STOCKAGE DU NUMERO DU PREMIER ET DERNIER NOEUD DE CHAQUE TYPE
C            D'INTERFACE
C
            IF(TYPCOU.EQ.MNEAL) THEN
              IDMN=MIN(IDMN,IPOIN)
              IFMN=MAX(IFMN,IPOIN)
            ENDIF
C
            IF(TYPCOU.EQ.CRAIGB) THEN
              IDCB=MIN(IDCB,IPOIN)
              IFCB=MAX(IFCB,IPOIN)
            ENDIF
C
            IF(TYPCOU.EQ.CBHARM) THEN
              IDHA=MIN(IDHA,IPOIN)
              IFHA=MAX(IFHA,IPOIN)
            ENDIF
C
            IF(TYPCOU.EQ.AUCUN) THEN
              IDAU=MIN(IDAU,IPOIN)
              IFAU=MAX(IFAU,IPOIN)
            ENDIF
C
 20       CONTINUE
        WRITE(IFM,*)'  '
        CALL BMNODI('        ',NOMRES,'         ',I,0,IBID,NBDEF)
        WRITE(IFM,*)'  '
       WRITE(IFM,*)' NOMBRE DE DEFORMEES STATIQUES ASSOCIES: ',NBDEF
        WRITE(IFM,*)'  '
        CALL JELIBE(JEXNUM(DDACT,I))
        CALL JELIBE(JEXNUM(NOEINT,I))
 10   CONTINUE
C
        WRITE(IFM,*) ' '
        WRITE(IFM,*) ' '
        WRITE(IFM,*) ' '
        WRITE(IFM,*) ' DEFINITION DES DEFORMEES A CALCULER'
        WRITE(IFM,*) '------------------------------------'
C
C  CAS OU IL Y A DES DEFORMEES STATIQUES
C
        IF(IDAU.EQ.1) THEN
          WRITE(IFM,*)' PAS DE DEFORMEES STATIQUES A CALCULER'
          GOTO 9999
        ENDIF
        WRITE(IFM,*) ' '
        NCOMP=0
        DO 40 I=1,NBNOT
          WRITE(IFM,*) ' '
          IF(I.GE.IDMN.AND.I.LE.IFMN) TYDEF='MODE D''ATTACHE'
          IF(I.GE.IDCB.AND.I.LE.IFCB) TYDEF='MODE CONTRAINT'
          IF(I.GE.IDHA.AND.I.LE.IFHA) TYDEF='MODE CONT-HARM'
          INO=ZI(LLDES+I-1)
          CALL JENUNO (JEXNUM(MAILLA//'.NOMNOE',INO),NOMNOE)
          CALL ISDECO(ZI(LLDES+NBNOT*2+(I-1)*NBEC+1-1),IDEC,NBCMP)
          DO 50 J=1,NBCMP
            IF(IDEC(J).GT.0) THEN
              TYP=ZK8(LLNCMP+J-1)
              NCOMP=NCOMP+1
      WRITE(IFM,*)'DEFORMEE: ',NCOMP,FLEC,NOMNOE,' ',TYP,' ',TYDEF
            ENDIF
 50       CONTINUE
 40     CONTINUE
C
      WRITE(IFM,*)' '
      WRITE(IFM,*)'----------------------------------------------------'
      WRITE(IFM,*)' '
C
 9999 CONTINUE
      CALL JEDEMA()
      END
