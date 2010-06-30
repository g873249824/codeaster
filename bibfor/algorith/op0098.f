      SUBROUTINE OP0098()
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
C***********************************************************************
C  P. RICHARD   DATE 09/07/91
C-----------------------------------------------------------------------
C  BUT : OPERATEUR DE DEFINITION DE LISTE INTERFACE POUR SUPERPOSITION
C        OU SYNTHESE MODALE : DEFI_INTERF_DYNA
C        LISTE_INTERFACE CLASSIQUE ( MIXTE CRAIG-BAMPTON MAC-NEAL)
C-----------------------------------------------------------------------
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX -----------------------------
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
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      CHARACTER*8  NOMRES,MAILLA,MAILSK,NOMGD,K8BID
      CHARACTER*19 NUMDDL
      CHARACTER*16 NOMOPE,NOMCON
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C --- PHASE DE VERIFICATION
C
      CALL JEMARQ()
C
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
C --- RECUPERATION NOM ARGUMENT
C
      CALL GETRES(NOMRES,NOMCON,NOMOPE)
C
C --- CREATION .REFE
C
      CALL GETVID('   ','NUME_DDL',1,1,1,NUMDDL,NBID)
      NUMDDL(15:19)='.NUME'
      CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IBID,MAILLA,IERD)
      CALL WKVECT(NOMRES//'.IDC_REFE','G V K24',3,IADREF)
      ZK24(IADREF)=MAILLA
      ZK24(IADREF+1)=NUMDDL
      ZK24(IADREF+2)='              '
C
C --- CREATION DU .DESC
C
      CALL DISMOI('F','NOM_GD',NUMDDL,'NUME_DDL',IBID,NOMGD,IER)
      CALL DISMOI('F','NUM_GD',NOMGD,'GRANDEUR',NUMGD,K8BID,IER)
      CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NBCMP,K8BID,IER)
      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NBEC,K8BID,IER)
C
      CALL WKVECT(NOMRES//'.IDC_DESC','G V I',5,LDDESC)
      ZI(LDDESC)=1
      ZI(LDDESC+1)=NBEC
      ZI(LDDESC+2)=NBCMP
      ZI(LDDESC+3)=NUMGD
      ZI(LDDESC+4)=0
C
C CETTE DERNIERE VALEUR SERA REACTUALISEE PAR LE NOMBRE DE DEFORMEE
C STATIQUE A CALCULER
C
C --- CAS D'UNE LISTE_INTERFACE CONNUE
C
      CALL CALC98 (NOMRES,MAILLA,NUMDDL)
C
C --- IMPRESSION SUR FICHIER
C
      IF (NIV.GT.1) CALL IMBINT(NOMRES,IFM)
C
      CALL JEDEMA()
      END
