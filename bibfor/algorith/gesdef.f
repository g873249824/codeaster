      SUBROUTINE GESDEF(NOMRES,NUMDDL)
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
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT: < GESTION DES DEFORMEES A CALCULER >
      IMPLICIT NONE
C
C     EN FONCTION DES DDL ACTIFS
C  ET DES MASQUE DE DDL AUX NOEUDS
C   FINIR DE REMPLIR LA TABLEAU DE DESCRIPTION DES DEFORMEES
C
C UTILISATION D'UN TABLEAU VOLATIL DE DESCRIPTION DES DDL PORTES PAR
C   LES NOEUDS:
C
C  ATTENTION: RESTRICTION A 12 DDL PAR NOEUD 6 PHYSIQUES ET LES 6
C            LAGRANGES CORRESPONDANTS
C
C    DX=1    (1)    LAG SUR UN DX=-1   (7)        () ASTER
C    DY=2    (2)    LAG SUR UN DY=-2   (7)
C    DZ=3    (3)    LAG SUR UN DZ=-3   (7)
C    DRX=4    (4)    LAG SUR UN DRX=-4   (7)
C    DRY=5    (5)    LAG SUR UN DRY=-5   (7)
C    DRZ=6    (6)    LAG SUR UN DRZ=-6   (7)
C
C   REMARQUE:LES DDL DU IPRNO NE PORTE QUE DE DDL A CODE POSITIF CAR LE
C     IPRNO CORRESPOND AU PRNO DU LIGREL MAILLAGE -> DECODAGE SUR 6
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DES RESULTATS DE L'OPERATEUR
C NUMDDL   /I/: NOM DE LA NUMEROTATION CORRESPONDANT AU PB
C NBDEF   /O/: NOMBRE TOTAL DE DEFORMEES A CALCULER
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*6 PGC
      CHARACTER*8 NOMRES
      CHARACTER*19 NUMDDL
      CHARACTER*24 DESDEF,DEEQ,TEMMAT,TEMIDC
      INTEGER IKYP(4)
      CHARACTER*8 K8BID
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IAD1 ,IAD2 ,IK ,IRET ,LDDESC ,LLDEEQ 
      INTEGER LLDES ,LTIDEC ,LTMAT ,NBCMP ,NBDEF ,NBEC ,NBNO 
      INTEGER NBNOT ,NBTEM ,NEQ ,NOMAX 
C-----------------------------------------------------------------------
      DATA PGC/'GESDEF'/
C-----------------------------------------------------------------------
C
C------------RECUPERATION DONNEES GRANDEURS SOUS-JACENTE----------------
C             ET CREATION VECEUR DE TRAVAIL DECODAGE
C
      CALL JEMARQ()
      CALL DISMOI('F','NB_CMP_MAX',NOMRES,'INTERF_DYNA',NBCMP,
     &            K8BID,IRET)
      CALL DISMOI('F','NB_EC',NOMRES,'INTERF_DYNA',NBEC,K8BID,IRET)
      TEMIDC = '&&'//PGC//'.IDEC'
      CALL WKVECT(TEMIDC,'V V I',NBCMP*NBEC*2,LTIDEC)
C
C-----------REQUETTE ADRESSE DE LA TABLE DESCRIPTION DES DEFORMEES------
C
      DESDEF = NOMRES//'.IDC_DEFO'
      CALL JEVEUO(DESDEF,'E',LLDES)
      CALL JELIRA(DESDEF,'LONMAX',NBNOT,K8BID)
      NBNOT = NBNOT/(2+NBEC)
C
C---------------COMPTAGE DES NOEUDS DES DIVERS TYPES INTERFACE----------
C
      DO 5 I = 1,4
        IKYP(I) = 0
    5 CONTINUE
C
      DO 10 I = 1,NBNOT
        IK = ZI(LLDES+NBNOT+I-1)
        IK = -IK
        IKYP(IK) = IKYP(IK) + 1
   10 CONTINUE
C
      NOMAX = MAX(IKYP(1),IKYP(2))
      NOMAX = MAX(NOMAX,IKYP(3))
      NOMAX = MAX(NOMAX,IKYP(4))
C
C-----------CREATION MATRICE DES ENTIER CODES DDL ASSEMBLES------------
C    COLONNES SEPARES POUR LES DDL PHYSIQUES ET LES LAGRANGES
C
      NOMAX = 2*NOMAX*NBEC
      TEMMAT = '&&'//PGC//'.MATDDL'
      CALL WKVECT(TEMMAT,'V V I',NOMAX,LTMAT)
C
C--------------------REQUETE SUR LE DEEQ DU NUMDDL----------------------
C
C
C
      DEEQ = NUMDDL//'.DEEQ'
      CALL JEVEUO(DEEQ,'L',LLDEEQ)
      CALL JELIRA(DEEQ,'LONMAX',NEQ,K8BID)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8BID,IRET)
C
C--------------TRAITEMENT DES MODES D'ATTACHE (MAC NEAL)----------------
C
C
C   DECALAGE EVENTUEL DE LA LISTE DES NOEUDS MN DANS LA LISTE GLOBALE
C
      NBTEM = 0
      NBDEF = 0
C
      NBNO = IKYP(1)
C
      CALL RECDDL(NBCMP,ZI(LLDES+NBTEM),NBNO,NBEC,ZI(LLDEEQ),NEQ,
     +            ZI(LTMAT),ZI(LTIDEC))
C
      IAD1 = LLDES + NBNOT*2 + NBTEM*NBEC
      IAD2 = LLDES + NBNOT + NBTEM
      CALL MASKMN(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(IAD1),ZI(IAD2),NBDEF)
C
C----------TRAITEMENT DES MODES CONTRAINTS (CRAIG BAMPTON)--------------
C
C   DECALAGE EVENTUEL DE LA LISTE DES NOEUDS MN DANS LA LISTE GLOBALE
C
      NBTEM = IKYP(1)
C
      NBNO = IKYP(2)
C
      CALL RECDDL(NBCMP,ZI(LLDES+NBTEM),NBNO,NBEC,ZI(LLDEEQ),NEQ,
     +            ZI(LTMAT),ZI(LTIDEC))
C
      IAD1 = LLDES + NBNOT*2 + NBTEM*NBEC
      IAD2 = LLDES + NBNOT + NBTEM
      CALL MASKCB(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(IAD1),ZI(IAD2),NBDEF)
C
C-------TRAITEMENT DES MODES CONTRAINTS HARMONIQUES(CB-HARMO)-----------
C
C   DECALAGE EVENTUEL DE LA LISTE DES NOEUDS MN DANS LA LISTE GLOBALE
C
      NBTEM = IKYP(1) + IKYP(2)
C
      NBNO = IKYP(3)
C
      CALL RECDDL(NBCMP,ZI(LLDES+NBTEM),NBNO,NBEC,ZI(LLDEEQ),NEQ,
     +            ZI(LTMAT),ZI(LTIDEC))
C
      IAD1 = LLDES + NBNOT*2 + NBTEM*NBEC
      IAD2 = LLDES + NBNOT + NBTEM
      CALL MASKCB(NBCMP,NBNO,NBEC,ZI(LTMAT),ZI(IAD1),ZI(IAD2),NBDEF)
C
C-----------------TRAITEMENT DES NOEUDS D'INTERFACE AUCUN---------------
C
C
C   DECALAGE EVENTUEL DE LA LISTE DES NOEUDS AU DANS LA LISTE GLOBALE
C
      NBTEM = IKYP(1) + IKYP(2) + IKYP(3)
C
      NBNO = IKYP(4)
C
      CALL RECDDL(NBCMP,ZI(LLDES+NBTEM),NBNO,NBEC,ZI(LLDEEQ),NEQ,
     +            ZI(LTMAT),ZI(LTIDEC))
C
      IAD1 = LLDES + NBNOT*2 + NBTEM*NBEC
      IAD2 = LLDES + NBNOT + NBTEM
      CALL MASKAU(NBNO,NBEC,ZI(IAD1))
C
C------------------------FINITION DU .DESC------------------------------
C
      CALL JEVEUO(NOMRES//'.IDC_DESC','E',LDDESC)
      ZI(LDDESC+4) = NBDEF
C
C---------------------LIBERATION DES OBJETS-----------------------------
C
C
C-------------------DESTRUCTION DES OBJETS VOLATILES--------------------
C
      CALL JEDETR(TEMMAT)
      CALL JEDETR(TEMIDC)
C
      CALL JEDEMA()
      END
