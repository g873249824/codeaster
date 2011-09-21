      SUBROUTINE DESCCY(NOMRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C***********************************************************************
C    P. RICHARD     DATE 07/03/91
C-----------------------------------------------------------------------
C  BUT:  CREATION DE LA NUMEROTATION GENERALISEE POUR LE PROBLEME
      IMPLICIT REAL*8 (A-H,O-Z)
C        CYCLIQUE
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
C BASMOD   /I/: NOM UTILISATEUR DE L'EVENTUELLE BASE MODALE (OU BLANC)
C RESCYC   /I/: NOM UTILISATEUR EVENTUEL CONCEPT MODE CYCLIQUE(OU BLANC)
C NUMCYC   /O/: NOM K24 DE LA NUMEROTATION RESULTAT
C
C-----------------------------------------------------------------------
C
      INTEGER          ZI
      INTEGER VALI(3)
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
      CHARACTER*8  INTF,KBID,BASMOD,NOMRES
      CHARACTER*24 NOEINT
      CHARACTER*1 K1BID
      INTEGER      IARG
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
      KBID=' '
C-----------------------------------------------------------------------
C
C------------------RECUPERATION CONCEPT AMONT---------------------------
C
      CALL JEVEUO(NOMRES//'.CYCL_REFE','L',LLREF)
      INTF=ZK24(LLREF+1)
      BASMOD=ZK24(LLREF+2)
C
C-----RECUPERATION NUMEROS INTERFACES DROITE GAUCHE ET AXE--------------
C
      CALL JEVEUO(NOMRES//'.CYCL_NUIN','L',LDDNIN)
      NUMD=ZI(LDDNIN)
      NUMG=ZI(LDDNIN+1)
      NUMA=ZI(LDDNIN+2)
C
C----------RECUPERATION DU DESCRIPTEUR DES DEFORMEES STATIQUES----------
C
      CALL JEVEUO(INTF//'.IDC_DEFO','L',LLDESC)
      CALL JELIRA(INTF//'.IDC_DEFO','LONMAX',NBNOT,K1BID)
      NBNOT=NBNOT/3
C
C--------RECUPERATION DES DEFINITIONS DES INTERFACES DROITE ET GAUCHE---
C
      NOEINT=INTF//'.IDC_LINO'
C
      CALL JEVEUO(JEXNUM(NOEINT,NUMD),'L',LDNOED)
      CALL JELIRA(JEXNUM(NOEINT,NUMD),'LONMAX',NBD,K1BID)
C
      CALL JEVEUO(JEXNUM(NOEINT,NUMG),'L',LDNOEG)
      CALL JELIRA(JEXNUM(NOEINT,NUMG),'LONMAX',NBG,K1BID)
C
      IF(NUMA.GT.0) THEN
        CALL JEVEUO(JEXNUM(NOEINT,NUMA),'L',LDNOEA)
        CALL JELIRA(JEXNUM(NOEINT,NUMA),'LONMAX',NBA,K1BID)
      ENDIF
C
      IF(NBG.NE.NBD) THEN
        VALI (1) = NBD
        VALI (2) = NBG
        CALL U2MESG('F', 'ALGORITH12_79',0,' ',2,VALI,0,0.D0)
      ENDIF
C
C------COMPTAGE DEFORMEES STATIQUES INTERFACE DROITE GAUCHE-------------
C
      CALL BMNODI(BASMOD,KBID,'        ',NUMD,0,IBID,NBDD)
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'        ',NUMG,0,IBID,NBDG)
C
C--------------TEST SUR NOMBRE DE DDL AUX INTERFACES--------------------
C
      IF(NBDD.NE.NBDG) THEN
        VALI (1) = NBDD
        VALI (2) = NBDG
        CALL U2MESG('F', 'ALGORITH12_80',0,' ',2,VALI,0,0.D0)
      ENDIF
C
C-----COMPTAGE NOMBRE DEFORMEES STATIQUE SUR EVENTUELLE INTERFACE AXE---
C
      NBDA=0
      IF(NUMA.GT.0) THEN
        KBID=' '
        CALL BMNODI(BASMOD,KBID,'        ',NUMA,0,IBID,NBDA)
      ELSE
        NBDA=0
      ENDIF
C
C--------DETERMINATION DU NOMBRE DE MODES PROPRES DE LA BASE------------
C
C  NOMBRE DE MODES DEMANDES
C
      CALL GETVIS('   ','NB_MODE',1,IARG,1,NBMOD1,IBID)
C
C  NOMBRE DE MODES EXISTANTS
      CALL DISMOI('F','NB_MODES_DYN',BASMOD,'RESULTAT',NBMOD2,
     &              KBID,IER)
C
C  TEST
C
      IF(NBMOD2.EQ.0) THEN
        CALL U2MESG('F', 'ALGORITH12_81',0,' ',0,0,0,0.D0)
      ENDIF
      NBMOD=MIN(NBMOD1,NBMOD2)
C
C---------DETERMINATION DU NOMBRE DE MODES PROPRES A CALCULER-----------
C
      CALL GETVIS('CALCUL','NMAX_FREQ',1,IARG,0,IBID,NBOC)
C
      IF(NBOC.EQ.0) THEN
        NBMCAL=NBMOD
      ELSE
        CALL GETVIS('CALCUL','NMAX_FREQ',1,IARG,1,NBMCAL,IBID)
      ENDIF
C
      IF(NBMCAL.GT.NBMOD) THEN
        NBTEMP=NBMCAL-NBMOD
        VALI (1) = NBMCAL
        VALI (2) = NBMOD
        VALI (3) = NBTEMP
        CALL U2MESG('A', 'ALGORITH12_82',0,' ',3,VALI,0,0.D0)
      ENDIF
C
C----------------ALLOCATION DE L'OBJET .DESC----------------------------
C
      CALL WKVECT(NOMRES//'.CYCL_DESC','G V I',4,LDNUMG)
C
C------------------CREATION DE LA NUMEROTATION--------------------------
C
      ZI(LDNUMG)=NBMOD
      ZI(LDNUMG+1)=NBDD
      ZI(LDNUMG+2)=NBDA
      ZI(LDNUMG+3)=NBMCAL
C
      CALL JEDEMA()
      END
