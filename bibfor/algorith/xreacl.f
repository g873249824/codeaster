      SUBROUTINE XREACL(NOMA  ,NOMO  ,VALINC,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      CHARACTER*8   NOMA ,NOMO
      CHARACTER*24  RESOCO
      CHARACTER*19  VALINC(*)
C     
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - ALGORITHME)
C
C MISE � JOUR DU SEUIL DE FROTTEMENT
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DE L'OBJET MODELE
C IN  NOMA   : NOM DE L'OBJET MAILLAGE 
C IN  RESOCO : SD CONTACT (RESOLUTION)  
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C 
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=7)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER      NBMA,IBID
      CHARACTER*8  KBID
      CHARACTER*19 LIGRMO,XDONCO,XSEUCO,CSEUIL
      CHARACTER*16 OPTION
      CHARACTER*24 AINTER,CFACE,FACLON,PINTER,CHGEOM
      CHARACTER*19 DEPPLU
      INTEGER      JXC 
      LOGICAL      DEBUG,LCONTX         
      INTEGER      IFM,NIV,IFMDBG,NIVDBG            
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)      
C
C --- INITIALISATIONS
C 
      LIGRMO = NOMO(1:8)//'.MODELE'
      CSEUIL = '&&XREACL.SEUIL'
      XDONCO = RESOCO(1:14)//'.XFDO'
      XSEUCO = RESOCO(1:14)//'.XFSE'      
      OPTION = 'XREACL' 
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF            
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,KBID,IBID)
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C        
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)    
C
C --- SI PAS DE CONTACT ALORS ON ZAPPE LA V�RIFICATION 
C
      CALL JEVEUO(NOMO(1:8)//'.XFEM_CONT'  ,'L',JXC)
      LCONTX = ZI(JXC) .EQ. 1
      IF (.NOT.LCONTX) THEN
        GOTO 9999
      ENDIF 
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)                  
C                                                               
C --- CREATION DU CHAM_ELEM_S VIERGE                             
C               
      CALL XMCHEX(NOMA  ,NBMA  ,CSEUIL)      
C
C --- RECUPERATION DES DONNEES XFEM
C
      AINTER = NOMO(1:8)//'.TOPOFAC.AI'
      CFACE  = NOMO(1:8)//'.TOPOFAC.CF'
      FACLON = NOMO(1:8)//'.TOPOFAC.LO'
      PINTER = NOMO(1:8)//'.TOPOFAC.OE'
C
C --- RECUPERATION DES COORDONNEES DES NOEUDS
C
      CHGEOM = NOMA(1:8)//'.COORDO'
C       
C --- CREATION DES LISTES DES CHAMPS IN
C
      LPAIN(1) = 'PDEPL_P'
      LCHIN(1) = DEPPLU(1:19)
      LPAIN(2) = 'PAINTER'
      LCHIN(2) = AINTER(1:19)
      LPAIN(3) = 'PCFACE'
      LCHIN(3) = CFACE(1:19)
      LPAIN(4) = 'PLONCHA'
      LCHIN(4) = FACLON(1:19)
      LPAIN(5) = 'PDONCO'
      LCHIN(5) = XDONCO(1:19)
      LPAIN(6) = 'PPINTER'
      LCHIN(6) = PINTER(1:19)
      LPAIN(7) = 'PGEOMER'
      LCHIN(7) = CHGEOM(1:19)
C       
C --- CREATION DES LISTES DES CHAMPS OUT
C    
      LPAOUT(1) = 'PSEUIL'
      LCHOUT(1) = CSEUIL(1:19)
C
C --- APPEL A CALCUL
C
      CALL CALCUL('S',OPTION,LIGRMO,NBIN  ,LCHIN ,LPAIN,
     &                              NBOUT ,LCHOUT,LPAOUT,'V')
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF      
C
C --- ON COPIE CSEUIL DANS RESOCO.SE
C
      CALL COPISD('CHAMP_GD','V',LCHOUT(1),XSEUCO)
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
