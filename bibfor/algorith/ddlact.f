      SUBROUTINE DDLACT(NOMRES,NUMDDL)
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT:  GESTION DES DDL A PRENDRE EN COMPTE DANS LES EQUATIONS
C  DE CONTINUITE A L'INTERFACE, EN FONCTION DES DDL BLOQUE ET
C  DU TYPE D'INTERFACE
C
C UTILISATION D'UN TABLEAU VOLATIL DE DESCRIPTION DES DDL PORTES PAR
C   LES NOEUDS:
C
C  COLONNE 1: ENTIERS CODES DDL PHYSIQUE ASSEMBLES
C  COLONNE 2 : ENTIERS CODES LAGRANGE DE DUALISATION ASSEMBLES
C
C   REMARQUE:LES DDL DU IPRNO NE PORTE QUE DE DDL A CODE POSITIF CAR LE
C     IPRNO CORRESPOND AU PRNO DU LIGREL MAILLAGE -> DECODAGE SUR 6
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DES RESULTATS DE L'OPERATEUR
C NUMDDL   /I/: NOM DE LA NUMEROTATION CORRESPONDANT AU PB
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
      CHARACTER*6      PGC
      CHARACTER*8 NOMRES,TYPINT
      CHARACTER*8 K8BID
      CHARACTER*19 NUMDDL
      CHARACTER*24 DESDEF,DEEQ,TEMMAT,NOEINT,ACTINT,TEMDEC
      CHARACTER*1 K1BID
      REAL*8      ACTIFS
C
C-----------------------------------------------------------------------
      DATA PGC /'DDLACT'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      NOEINT=NOMRES//'.IDC_LINO'
      ACTINT=NOMRES//'.IDC_DDAC'
C
C------RECUPERATION DONNEES RELATIVES A LA GRANDEUR SOUS-JACENTE--------
C            ET ALLOCATION VECTEUR TRAVAIL DECODAGE
C
      CALL DISMOI('F','NB_CMP_MAX',NOMRES,'INTERF_DYNA',
     &             NBCMP,K8BID,IRET)
      CALL DISMOI('F','NB_EC',NOMRES,'INTERF_DYNA',
     &            NBEC,K8BID,IRET)
      TEMDEC='&&'//PGC//'.IDEC'
      CALL WKVECT(TEMDEC,'V V I',NBCMP*NBEC*2,LTIDEC)
C
C-----------REQUETTE ADRESSE DE LA TABLE DESCRIPTION DES DEFORMEES------
C
      DESDEF=NOMRES//'.IDC_DEFO'
      CALL JEVEUO(DESDEF,'L',LLDES)
      CALL JELIRA(DESDEF,'LONMAX',NBNOT,K1BID)
      NBNOT=NBNOT/(2+NBEC)
C
C---------------RECUPERATION DU NOMBRE D'INTERFACE----------------------
C
      CALL JELIRA(NOEINT,'NMAXOC',NBINT,K1BID)
C
C---------------RECUPERATION DES TYPES D'INTERFACE ---------------------
C
      CALL JEVEUO(NOMRES//'.IDC_TYPE','L',LLTYPI)
C
C----------------COMPTAGE DU NOMBRE MAX DE NOEUDS DES INTERFACE---------
C
      NOMAX=0
      DO 10 I=1,NBINT
        CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
        NOMAX=MAX(NOMAX,NBNO)
 10   CONTINUE
C
C---------CREATION DU NOM DE LA MATRICE DESCRIPTIVE DES DDL-------------
C
      NOMAX=2*NOMAX
      TEMMAT='&&'//PGC//'.MATDDL'
      CALL WKVECT(TEMMAT,'V V I',NOMAX*NBEC,LTMAT)
C
C--------------------CREATION VECTEUR DE TRAVAIL------------------------
C
      CALL WKVECT('&&'//PGC//'.NONO','V V I',NOMAX,LTNONO)
      CALL WKVECT('&&'//PGC//'.CONO','V V I',NOMAX*NBEC,LTCONO)
C
C--------------------REQUETE SUR LE DEEQ DU NUMDDL----------------------
C
      DEEQ=NUMDDL//'.DEEQ'
      CALL JEVEUO(DEEQ,'L',LLDEEQ)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8BID,IRET)
C
C-----------------------BOUCLE SUR LES INTERFACES-----------------------
C
      DO 20 I=1,NBINT
        CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
        CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNOE)
        CALL JEVEUO(JEXNUM(ACTINT,I),'E',LDACT)
C
        DO 30 J=1,NBNO
          INO=ZI(LLNOE+J-1)
          ZI(LTNONO+J-1)=ZI(LLDES+INO-1)
          DO 40 IEC = 1, NBEC
            ZI(LTCONO+(J-1)*NBEC+IEC-1)=
     +                  ZI(LLDES+2*NBNOT+(INO-1)*NBEC+IEC-1)
 40       CONTINUE
 30     CONTINUE
C
        CALL RECDDL(NBCMP,ZI(LTNONO),NBNO,NBEC,ZI(LLDEEQ),NEQ,
     &              ZI(LTMAT),ZI(LTIDEC))
C
        TYPINT=ZK8(LLTYPI+I-1)
C
        IF(TYPINT.EQ.'CRAIGB  '.OR.TYPINT.EQ.'CB_HARMO') THEN
          CALL ACTICB(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(LTCONO),ZI(LDACT))
        ENDIF
C
        IF(TYPINT.EQ.'MNEAL   ') THEN
          CALL ACTIMN(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(LDACT))
        ENDIF
C
        IF(TYPINT.EQ.'AUCUN   ') THEN
          CALL ACTIAU(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(LDACT))
        ENDIF
C
C--  TEST SUR LA PRESENCE DE DDL ACTIFS
C
        ACTIFS=0.D0
        DO 50 J=1,NBNO*NBEC
          ACTIFS=ACTIFS+ZI(LDACT+J-1)**2
  50    CONTINUE
C
        IF (ACTIFS .LT. 1) THEN
          CALL U2MESG('F', 'SOUSTRUC2_8',0,' ',0,0,0,0.D0)
        ENDIF
C
        CALL JELIBE(JEXNUM(ACTINT,I))
        CALL JELIBE(JEXNUM(NOEINT,I))
C
 20   CONTINUE
C
      CALL JELIBE(DEEQ)
      CALL JEDETR(TEMDEC)
      CALL JEDETR('&&'//PGC//'.NONO')
      CALL JEDETR('&&'//PGC//'.CONO')
      CALL JEDETR(TEMMAT)
C
      CALL JEDEMA()
      END
