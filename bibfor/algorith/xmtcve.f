      SUBROUTINE XMTCVE(OPTION,MODELE,DEPMOI,DEPDEL,RESOCO,
     &                  VEXFTE)      
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      CHARACTER*19 VEXFTE          
      CHARACTER*8  MODELE
      CHARACTER*24 DEPMOI,DEPDEL,RESOCO
C     
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION OBJETS)
C
C CALCUL DES VECTEURS ELEMENTAIRES DES ELEMENTS DE CONTACT/FROTTEMENT 
C DANS LE CADRE D'X-FEM 'GRANDS GLISSEMENTS'
C      
C ----------------------------------------------------------------------
C
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  MODELE : NOM DU MODELE
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  DEPMOI : CHAM_NO DES DEPLACEMENTS A L'INSTANT PRECEDENT
C IN  RESOCO : SD CONTACT 
C OUT VEXFTE : VECT_ELEM CONTACT/FROTTEMENT      
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=7)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C      
      CHARACTER*19 CHGEOM,LIGRCF
      CHARACTER*19 CPOINT,CPINTE,CAINTE,CCFACE   
      LOGICAL      EXIGEO
      CHARACTER*16 OPTION
      LOGICAL      DEBUG
      INTEGER      IFM,NIV,IFMDBG,NIVDBG            
C
C ----------------------------------------------------------------------
C           
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)    
C
C --- AFFICHAGE
C            
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM  > CREATION DES VECT_ELEM' 
      ENDIF       
C      
C --- INITIALISATIONS     
C         
      CPOINT = RESOCO(1:14)//'.XFPO'
      CPINTE = RESOCO(1:14)//'.XFPI'
      CAINTE = RESOCO(1:14)//'.XFAI'
      CCFACE = RESOCO(1:14)//'.XFCF' 
      LIGRCF = RESOCO(1:14)//'.LIGR'
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF       
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)          
C      
C --- RECUPERATION DE LA GEOMETRIE
C
      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)  
C       
C --- CREATION DES LISTES DES CHAMPS IN
C
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM
      LPAIN(2)  = 'PDEPL_M'
      LCHIN(2)  = DEPMOI
      LPAIN(3)  = 'PDEPL_P'
      LCHIN(3)  = DEPDEL
      LPAIN(4)  = 'PCAR_PT'
      LCHIN(4)  = CPOINT
      LPAIN(5)  = 'PCAR_PI'
      LCHIN(5)  = CPINTE
      LPAIN(6)  = 'PCAR_AI'
      LCHIN(6)  = CAINTE
      LPAIN(7)  = 'PCAR_CF'
      LCHIN(7)  = CCFACE
C
C --- ON DETRUIT LES VECTEURS ELEMENTAIRES S'ILS EXISTENT
C
      CALL DETRSD('VECT_ELEM',VEXFTE)
C
C --- PREPARATION DES VECTEURS ELEMENTAIRES
C          
      CALL MEMARE('V',VEXFTE,MODELE,' ',' ','CHAR_MECA')     
C
C --- CALCUL DU VECT_ELEM CONTACT
C 
      LPAOUT(1) = 'PVECTUR'      
      LCHOUT(1) = VEXFTE  
      CALL CALCUL('S',OPTION,LIGRCF,NBIN  ,LCHIN ,LPAIN ,
     &                              NBOUT ,LCHOUT,LPAOUT,'V')
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF 
C     
      CALL REAJRE(VEXFTE,LCHOUT(1),'V')                 
C
      CALL JEDEMA()
      END
