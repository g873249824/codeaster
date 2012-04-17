      SUBROUTINE COLNEU(NBNODE,TYPEMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/02/2011   AUTEUR GREFFET N.GREFFET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE GREFFET N.GREFFET
C TOLE CRP_4
      IMPLICIT NONE
C
C      COLNEU --   LECTURE DES NUMEROS DE NOEUDS ET DE LEURS
C                  COORDONNEES PAR RECEPTION MEMOIRE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NBNODE         OUT   I         NOMBRE DE NOEUDS DU MAILLAGE
C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
      INTEGER  NBNODE
C -----  VARIABLES LOCALES
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
      INTEGER          INODE
      INTEGER          NDMAX
      INTEGER          JCOOR, JGROMA, JDETR, JINFO
      INTEGER          IBID
C
C     COUPLAGE =>
C
C     ANCIENS INCLUDE (CALCIUM.H)
C     ===========================
      INTEGER*4          LENVAR,CPITER,TAILLE,IBID4,NBNOD4,UN
      INTEGER            NBNMAX,IADR
      PARAMETER (LENVAR = 144)
      PARAMETER (CPITER= 41)
      PARAMETER (NBNMAX= 100000)
      INTEGER*4          INT4(NBNMAX),I4
      INTEGER            ICOMPO,IFM,NIV,VALI(2)
      REAL*4             TR4
      CHARACTER*8        TYPEMA,VALK(3)
      CHARACTER*24       AYACS   
      CHARACTER*(LENVAR) NOMVAR
C     COUPLAGE <=
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C.========================= DEBUT DU CODE EXECUTABLE ==================
      CALL JEMARQ()
      CALL INFNIV (IFM, NIV)
C
C --- INITIALISATION :
C     --------------
      NBNODE   = 0
C
C     ASSIGNATION DES NOMS POUR LES ADRESSES DANS LES COMMON ASTER
C     ------------------------------------------------------------
      AYACS='&ADR_YACS'
C
C     RECUPERATION DE L'ADRESSE YACS
C     ------------------------------        
      CALL JEVEUO(AYACS,'L',IADR)
      ICOMPO=ZI(IADR) 
C
C --- LECTURE DU NOMBRE DE NOEUDS :
C     ---------------------------
      IF (TYPEMA(1:7).EQ.'SOMMET') NOMVAR = 'NB_DYN'
      IF (TYPEMA(1:7).EQ.'MILIEU') NOMVAR = 'NB_FOR'
C      
      UN = 1
      TR4 = 0.D0
      I4 = 0
      CALL CPLEN(ICOMPO,CPITER,TR4,TR4,I4,NOMVAR,UN,
     &           TAILLE,NBNOD4,IBID4)
      NBNODE = NBNOD4
      IF ( NBNODE .GT. NBNMAX ) THEN
        VALI(1) = NBNODE
        VALI(2) = NBNMAX
        CALL U2MESI('F','COUPLAGEIFS_12',2,VALI)      
      ENDIF
C
C --- CREATION DE VECTEURS DE TRAVAIL :
C     -------------------------------
      CALL JEDETR('&&PRECOU.INFO.NOEUDS')
      CALL JEDETR('&&PRECOU.DETR.NOEUDS')
      CALL JEDETR('&&PRECOU.COOR.NOEUDS')
      CALL JEDETR('&&PRECOU.GROUPE.MAILLES')
C 
      CALL WKVECT('&&PRECOU.INFO.NOEUDS',    'V V I', NBNODE,JINFO)
      CALL WKVECT('&&PRECOU.COOR.NOEUDS',    'V V R', 3*NBNODE,JCOOR)
      CALL WKVECT('&&PRECOU.GROUPE.MAILLES', 'V V I', NBNODE,JGROMA)
C
C --- LECTURE DES NUMEROS DE NOEUDS ET DE LEURS COORDONNEES :
C     -----------------------------------------------------
      IF (TYPEMA(1:7).EQ.'SOMMET') NOMVAR = 'COONOD'
      IF (TYPEMA(1:7).EQ.'MILIEU') NOMVAR = 'COOFAC'
      IF (NIV.EQ.2) THEN
        VALK(1) = 'COLNEU'
        VALK(2) = 'NOMVAR'
        VALK(3) = NOMVAR     
        CALL U2MESK('I+','COUPLAGEIFS_11',3,VALK)      
      ENDIF
      CALL CPLDB(ICOMPO,CPITER,0.D0,0.D0,0,
     & NOMVAR,3*NBNOD4,TAILLE,ZR(JCOOR),IBID4)
      IF (NIV.EQ.2) THEN
        VALK(1) = 'COLNEU'
        VALK(2) = 'IBID'
        IBID = IBID4
        CALL U2MESG('I+','COUPLAGEIFS_10',2,VALK,1,IBID,0,0.D0)      
      ENDIF
C
      IF (TYPEMA(1:7).EQ.'SOMMET') NOMVAR = 'COLNOD'
      IF (TYPEMA(1:7).EQ.'MILIEU') NOMVAR = 'COLFAC'      
      IF (NIV.EQ.2) THEN
        VALK(1) = 'COLNEU'
        VALK(2) = 'NOMVAR'
        VALK(3) = NOMVAR     
        CALL U2MESK('I+','COUPLAGEIFS_11',3,VALK)      
      ENDIF
      CALL CPLEN(ICOMPO,CPITER,TR4,TR4,I4,NOMVAR,NBNOD4,
     &           TAILLE,INT4,IBID4)
      IF (NIV.EQ.2) THEN
        VALK(1) = 'COLNEU'
        VALK(2) = 'IBID'
        IBID = IBID4
        CALL U2MESG('I+','COUPLAGEIFS_10',2,VALK,1,IBID,0,0.D0)
      ENDIF
      DO 20 INODE = 1, NBNODE
        ZI(JGROMA-1+INODE) = INT4(INODE)
  20  CONTINUE
      IF (NIV.EQ.2) THEN
        VALK(1) = 'COLNEU'
        VALK(2) = 'NBNODE'
        CALL U2MESG('I+','COUPLAGEIFS_10',2,VALK,1,NBNODE,0,0.D0)
      ENDIF
C
      NDMAX = NBNODE
      DO 10 INODE = 1, NBNODE
        ZI(JINFO+INODE-1) = INODE
  10  CONTINUE
C     LISTE DES NOEUDS A DETRUIRE (0: A DETRUIRE, 1: A CONSERVER)
      CALL WKVECT('&&PRECOU.DETR.NOEUDS','V V I',NDMAX+1,JDETR)
      DO 12 INODE = 0,NDMAX
        ZI(JDETR+INODE) = 0
 12   CONTINUE
C.============================ FIN DE LA ROUTINE ======================
      CALL JEDEMA()
      END
