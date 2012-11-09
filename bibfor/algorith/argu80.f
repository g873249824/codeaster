      SUBROUTINE ARGU80(NOMRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
C
C***********************************************************************
C    P. RICHARD     DATE 28/03/91
C-----------------------------------------------------------------------
C  BUT : RECUPERER LES ARGUMENTS D'APPEL (SAUF LES DIAMETRES ET LE
C        NOMBRE DE MODES A CALCULER) ET CREATION DES OBJETS
C        CORRESPONDANTS
C        VERIFICATION DES PROPRIETES DE REPETITIVITE SUR LE MAILLAGE
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU CONCEPT RESULTAT
C
C
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      CHARACTER*24 VALK
      CHARACTER*8 DROITE,GAUCHE,AXE,TYPD,TYPG,TYPA
      CHARACTER*8 NOMRES,INTF
      CHARACTER*8 BLANC
      CHARACTER*72 KAR72
      INTEGER      VALI
      INTEGER      IARG
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER IBAXE ,IBID ,LDDNBS ,LDDNIN ,LDDTBM ,LDDTYP ,LLREF
      INTEGER NBSEC ,NDIST ,NUMA ,NUMD ,NUMG ,NVERI
      REAL*8 DIST ,PREC
C-----------------------------------------------------------------------
      DATA BLANC /'  '/
C-----------------------------------------------------------------------
C
C
C-------------CREATION DES OBJETS DE LA SDD RESULTAT--------------------
C
      CALL JEMARQ()
      CALL WKVECT(NOMRES//'.CYCL_NUIN','G V I',3,LDDNIN)
      CALL WKVECT(NOMRES//'.CYCL_TYPE','G V K8',1,LDDTYP)
      CALL WKVECT(NOMRES//'.CYCL_NBSC','G V I',1,LDDNBS)
C
C--------------------RECUPERATION DES CONCEPTS AMONTS-------------------
C
      CALL JEVEUO(NOMRES//'.CYCL_REFE','L',LLREF)
      INTF=ZK24(LLREF+1)
C
C----------RECUPERATION NOM DES INTERFACES DE LIAISON-------------------
C
      CALL GETVTX('LIAISON','DROITE',1,IARG,1,KAR72,IBID)
      DROITE=KAR72
      CALL GETVTX('LIAISON','GAUCHE',1,IARG,1,KAR72,IBID)
      GAUCHE=KAR72
      CALL GETVTX('LIAISON','AXE',1,IARG,0,KAR72,IBAXE)
      IF(IBAXE.EQ.-1) THEN
        CALL GETVTX('LIAISON','AXE',1,IARG,1,KAR72,IBID)
        AXE=KAR72
      ELSE
        AXE=' '
      ENDIF
C
C   RECUPERATION DES NUMEROS D'INTERFACE
C
C   INTERFACE DE DROITE OBLIGATOIRE
C
      CALL JENONU(JEXNOM(INTF//'.IDC_NOMS',DROITE),NUMD)
      IF(NUMD.EQ.0) THEN
          VALK = DROITE
        CALL U2MESG('F','ALGORITH15_85',1,VALK,0,0,0,0.D0)
      ENDIF
C
C   INTERFACE DE GAUCHE OBLIGATOIRE
C
      CALL JENONU(JEXNOM(INTF//'.IDC_NOMS',GAUCHE),NUMG)
      IF(NUMG.EQ.0) THEN
        VALK = GAUCHE
        CALL U2MESG('F','ALGORITH15_86',1,VALK,0,0,0,0.D0)
      ENDIF
C
C   INTERFACE AXE FACULTATIVE
C
      IF(AXE.NE.'        ') THEN
        CALL JENONU(JEXNOM(INTF//'.IDC_NOMS',AXE),NUMA)
        IF(NUMA.EQ.0) THEN
        VALK = AXE
        CALL U2MESG('F','ALGORITH15_87',1,VALK,0,0,0,0.D0)
        ENDIF
      ELSE
        NUMA=0
      ENDIF
C
      ZI(LDDNIN)=NUMD
      ZI(LDDNIN+1)=NUMG
      ZI(LDDNIN+2)=NUMA
C
C   RECUPERATION DES TYPES DES INTERFACES
C
      CALL JEVEUO(INTF//'.IDC_TYPE','L',LDDTBM)
      TYPD=ZK8(LDDTBM+NUMD-1)
      TYPG=ZK8(LDDTBM+NUMG-1)
      IF(NUMA.GT.0) THEN
        TYPA=ZK8(LDDTBM+NUMA-1)
      ELSE
        TYPA=TYPD
      ENDIF
C
C  VERIFICATIONS SUR LES TYPES INTERFACES
C
      IF(TYPG.NE.TYPD.OR.TYPA.NE.TYPD) THEN
        CALL U2MESG('F','ALGORITH15_88',0,' ',0,0,0,0.D0)
      ENDIF
C
      IF(TYPD.NE.'MNEAL   '.AND.TYPD.NE.'CRAIGB  ') THEN
        IF(TYPD.NE.'AUCUN   '.AND.TYPD.NE.'CB_HARMO') THEN
          VALK = TYPD
          CALL U2MESG('F','ALGORITH15_89',1,VALK,0,0,0,0.D0)
        ENDIF
      ENDIF
C
C STOCKAGE TYPE INTERFACE
C
      ZK8(LDDTYP)= TYPD
C
C  RECUPERATION DU NOMBRE DE SECTEURS
C
      CALL GETVIS(BLANC,'NB_SECTEUR',1,IARG,1,NBSEC,IBID)
      IF(NBSEC.LT.2) THEN
          VALI = NBSEC
        CALL U2MESG('F','ALGORITH15_59',0,' ',1,VALI,0,0.D0)
      ENDIF
C
      ZI(LDDNBS)=NBSEC
C
C---------------VERIFICATION DE LA REPETITIVITE SUR MAILLAGE------------
C
      CALL GETFAC('VERI_CYCL',NVERI)
      CALL GETVR8('VERI_CYCL','PRECISION',1,IARG,1,PREC,IBID)
      CALL GETVR8('VERI_CYCL','DIST_REFE',1,IARG,1,DIST,NDIST)
      IF (NVERI.EQ.0) PREC=1.D-3
      IF (NDIST.EQ.0) THEN
C     --- AU CAS OU LA DISTANCE DE REFERENCE N'EST PAS DONNEE,ON DEVRAIT
C         LA LIRE DANS LA SD MAILLAGE (VOIR COMMANDE LIRE_MAILLAGE).
C         CE TRAVAIL N'ETANT PAS ACCOMPLI, ON MET DIST < 0 AFIN DE
C         SIGNIFIER A VERECY DE TRAVAILLER COMME AVANT
         DIST = -1.D0
      ENDIF
      CALL VERECY(INTF,NUMD,NUMG,NBSEC,PREC,DIST)
C
      CALL JEDEMA()
      END
