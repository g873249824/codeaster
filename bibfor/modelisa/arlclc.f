      SUBROUTINE ARLCLC(MODARL,NBCART,CTARLQ,MARLEL)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  MODARL
      INTEGER      NBCART
      CHARACTER*19 CTARLQ(NBCART)
      CHARACTER*8  MARLEL             
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C APPEL A CALCUL - ARLQ_COUPL
C
C ----------------------------------------------------------------------
C
C
C IN  MODARL : NOM DU PSEUDO-MODELE
C IN  NBCART : NOMBRE DE CARTES CREEES
C IN  CTARLQ : LISTE DES CARTES D'ENTREES
C I/O MARLEL : IN  -> NOM DES MATR_ELEM A CREER
C              OUT -> MATR_ELEM
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=2, NBIN=7)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      CHARACTER*19 LIGRMO
      CHARACTER*16 OPTION
      LOGICAL      DEBUG         
      INTEGER      IFM,NIV,IFMDBG,NIVDBG    
      CHARACTER*19 CTFAMI,CTINFO,CTREF1,CTCOO1,CTREF2,CTCOO2,CHGEOM 
      LOGICAL      LBID
      INTEGER      JARLM1, JARLM2
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV) 
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)         
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> *** CALCUL ARLQ_MATR...'   
      ENDIF        
C
C --- INITIALISATIONS
C
      LIGRMO = MODARL(1:8)//'.MODELE'
      OPTION = 'ARLQ_MATR' 
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF 
C
      CTFAMI = CTARLQ(1)
      CTINFO = CTARLQ(2)
      CTREF1 = CTARLQ(3)
      CTCOO1 = CTARLQ(4) 
      CTREF2 = CTARLQ(5)
      CTCOO2 = CTARLQ(6)       
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT) 
C
C --- ON DETRUIT MARLEL 
C
      CALL DETRSD(' ',MARLEL)     
C       
C --- CREATION DES LISTES DES CHAMPS IN
C
      CALL MEGEOM(MODARL,' ',LBID  ,CHGEOM)
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PFAMILK'
      LCHIN(2) = CTFAMI
      LPAIN(3) = 'PINFORR'
      LCHIN(3) = CTINFO
      LPAIN(4) = 'PREFE1K'
      LCHIN(4) = CTREF1
      LPAIN(5) = 'PCOOR1R'
      LCHIN(5) = CTCOO1
      LPAIN(6) = 'PREFE2K'
      LCHIN(6) = CTREF2
      LPAIN(7) = 'PCOOR2R'
      LCHIN(7) = CTCOO2
C
C --- CALCUL DE MARLEL: MATRICES ELEMENTAIRES
C
      CALL WKVECT(MARLEL(1:8)//'.ARLMT1','V V K24',1,JARLM1)
      CALL WKVECT(MARLEL(1:8)//'.ARLMT2','V V K24',1,JARLM2)
C       
C --- CREATION DES LISTES DES CHAMPS OUT
C    
      LPAOUT(1) = 'PMATUN1'
      LCHOUT(1) = MARLEL(1:8)//'.ARLMT1'
      LPAOUT(2) = 'PMATUN2'
      LCHOUT(2) = MARLEL(1:8)//'.ARLMT2'
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
C --- AFFICHAGE
C 
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> *** FIN DE CALCUL ARLQ_MATR...'
      ENDIF
C
      CALL JEDEMA()
      END
