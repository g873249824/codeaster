      SUBROUTINE NMFINT(OPTIOZ,
     &                  MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CARCRI,FONACT,RESOCO,
     &                  ITERAT,SDDYNA,LDCCVG,VALMOI,VALPLU,
     &                  POUGD ,DEPALG,MERIGI,MESSTR,VEDIRI,
     &                  VEFINT,SSTRU ,CNFINT,CNDIRI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/02/2008   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*(*) OPTIOZ      
      INTEGER       LDCCVG
      INTEGER       ITERAT
      CHARACTER*24  RESOCO
      LOGICAL       FONACT(*)
      CHARACTER*19  LISCHA,CNFINT,CNDIRI,SDDYNA
      CHARACTER*24  MODELE,NUMEDD,MATE, CODERE  
      CHARACTER*24  CARELE,COMPOR,COMREF,CARCRI
      CHARACTER*24  VALMOI(8),POUGD(8),VALPLU(8),DEPALG(8)
      CHARACTER*8   VEDIRI,VEFINT
      CHARACTER*8   MERIGI,MESSTR
      CHARACTER*19  SSTRU
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C INTEGRATION DE LA LOI DE COMPORTEMENT
C CALCUL DES FORCES INTERIEURES ET DES REACTIONS D'APPUI
C      
C ----------------------------------------------------------------------
C
C
C IN  OPTION : 'RAPH_MECA' OU 'FULL_MECA'
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NOM DE LA NUMEROTATION
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VALEURS DE REF DES VARIABLES DE COMMANDE
C IN  COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C IN  LISCHA : SD L_CHARGES
C IN  CARCRI : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN  POUGD  : TABLEAU DE K24 CONTENANT LES NOMS DES OBJETS
C IN  ITERAT : NUMERO DE L'ITERATION DE NEWTON
C IN  VALMOI : VARIABLES EN T-
C IN  DEPDEL : INCR. DE DEPLACEMENT DEPUIS L'INSTANT PRECEDENT
C             RELATIFS AUX POUTRES EN GRANDS DEPL.
C IN  RESOCO : SD DE RESOLUTION POUR LE CONTACT ET/OU LE FROTTEMENT
C IN  VALPLU : VARIABLES EN T+
C OUT MERIGI : MATRICES ELEMENTAIRES DE RIGIDITE
C IN  MESSTR : MATRICES ELEMENTAIRES DES SOUS-ELEMENTS STATIQUES
C OUT VEDIRI : VECTEURS ELEMENTAIRES DES REACTIONS D'APPUI
C OUT VEFINT : VECTEURS ELEMENTAIRES DES FORCES INTERNES
C IN  SSTRU  : MATRICE ASSEMBLEE DES SOUS-ELEMENTS STATIQUES
C OUT CNFINT : FORCES INTERNES   - FINT + AT.MU
C OUT CNDIRI : REACTIONS D'APPUI - BT.LAMBDA + AT.MU
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                0 : CAS DE FONCTIONNEMENT NORMAL
C                1 : ECHEC DE L'INTEGRATION DE LA LDC
C                3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      TABRET(0:10),LFETI,LDIRI,LFINT
      INTEGER      NBPROC,ITER
      REAL*8       R8BID
      INTEGER      NIVMPI
      CHARACTER*24 K24BID,DEPPLU
      INTEGER      IFM,NIV,IBID
      INTEGER      NEQ
      CHARACTER*8  K8BID
      CHARACTER*1  BASE    
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)  
C
C --- INITIALISATIONS
C
      ITER   = ITERAT+1   
      BASE   = 'V'        
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)       
C      
C --- PREPARATION FETI
C
      CALL NMFETI(NUMEDD,IFM   ,LFETI ,NIVMPI,NBPROC)
C
C --- CALCUL A FAIRE: FORCES INTERIEURES ET REACTIONS D'APPUI ?
C
      IF (OPTIOZ(1:9).EQ.'FULL_MECA') THEN
        LDIRI  = .TRUE. 
        LFINT  = .TRUE.                      
      ELSE IF (OPTIOZ(1:9).EQ.'RAPH_MECA') THEN
        LDIRI  = .TRUE. 
        LFINT  = .TRUE.                         
      ELSE
        CALL ASSERT(.FALSE.)
      END IF    
C
C --- CALCUL DES FORCES INTERIEURES
C
      IF (LFINT) THEN
        CALL GCNCON('.',CODERE)
        CALL MERIMO(BASE  ,MODELE,CARELE,MATE  ,COMREF,
     &              COMPOR,LISCHA,CARCRI,ITER  ,FONACT,
     &              SDDYNA,VALMOI,VALPLU,POUGD ,DEPALG,
     &              MERIGI,VEFINT,OPTIOZ,TABRET,CODERE)
        LDCCVG = 0
        IF (TABRET(0)) THEN
          IF ( TABRET(3) ) THEN
            LDCCVG = 3
          ELSE
            LDCCVG = 1
          ENDIF
          IF ( TABRET(1) ) THEN
            LDCCVG = 1
          ENDIF
        ENDIF
      ENDIF
C
C --- CALCUL DES VECTEURS ELEMENTAIRES DES REACTIONS D'APPUIS (LAGRANGE)
C
      IF (LDIRI) THEN
        CALL VEBTLA(MODELE,MATE  ,CARELE,DEPPLU,LISCHA,
     &              VEDIRI)
      END IF        
C
C --- ASSEMBLAGE DES FORCES INTERIEURES ET DES REACTIONS D'APPUI
C
      CALL NMASSR(FONACT,NUMEDD,RESOCO,VALPLU,MESSTR,
     &            SSTRU ,VEFINT,VEDIRI,CNFINT,CNDIRI)  
C
C --- SI FETI PARALLELE, ON COMMUNIQUE A CHAQUE PROC LA SOMME DES
C --- CHAM_NOS GLOBAUX PARTIELLEMENT CALCULES
C --- A OPTIMISER VIA UN DES CRITERES LOCAUX
C
      IF ((LFETI).AND.(NBPROC.GT.1)) THEN
        CALL JELIRA(CNFINT(1:19)//'.VALE','LONMAX',NEQ,K8BID)
        K24BID = CNFINT(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,K24BID,K24BID,K24BID,R8BID )
        K24BID = CNDIRI(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,K24BID,K24BID,K24BID,R8BID )
      ENDIF
C
      CALL JEDEMA()
      END
