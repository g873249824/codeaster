      SUBROUTINE MMCVEC(OPTION,MODELE,RESOCO,DEPMOI,DEPDEL,
     &                  VITMOI,VITPLU,ACCMOI,VECTCE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/07/2009   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*16  OPTION      
      CHARACTER*24  MODELE,RESOCO
      CHARACTER*24  DEPMOI,DEPDEL,ACCMOI,VITMOI,VITPLU
      CHARACTER*19  VECTCE      
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
C
C CALCUL DES SECONDS MEMBRES ELEMENTAIRES ELEMENTAIRES
C
C ----------------------------------------------------------------------
C
C
C IN  OPTION : OPTION DE CALCUL
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  MODELE : NOM DU MODELE
C IN  DEPMOI : CHAM_NO DES DEPLACEMENTS A L'INSTANT PRECEDENT
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  ACCMOI : CHAM_NO DES ACCELERATIONS A L'INSTANT PRECEDENT
C IN  VITMOI : CHAM_NO DES VITESSES A L'INSTANT PRECEDENT
C IN  VITPLU : CHAM_NO DES VITESSES A L'INSTANT SUIVANT
C OUT VECTCE : VECT_ELEM CONTACT/FROTTEMENT METHODE CONTINUE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=8)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      CHARACTER*19 CHGEOM,USUPLU
      LOGICAL      EXIGEO
      CHARACTER*1  BASE      
      INTEGER      IFM,NIV
      LOGICAL      DEBUG
      INTEGER      IFMDBG,NIVDBG        
      CHARACTER*19 LIGRCF,CHMLCF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)      
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CALCUL DES SECDS MEMBRES ELEMENTAIRES'
      ENDIF
C
C --- INITIALISATIONS
C       
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF      
      BASE   = 'V' 
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)              
C
C --- LIGREL DES ELEMENTS TARDIFS DE CONTACT/FROTTEMENT
C
      LIGRCF = RESOCO(1:14)//'.LIGR'
C
C --- CHAM_ELEM POUR ELEMENTS TARDIFS DE CONTACT/FROTTEMENT
C
      CHMLCF = RESOCO(1:14)//'.CHML'
C
C --- CARTE USURE
C
      USUPLU = RESOCO(1:14)//'.USUP'
C
C --- ON DETRUIT LES VECTEURS ELEMENTAIRES S'ILS EXISTENT
C
      CALL DETRSD('VECT_ELEM',VECTCE)
C
C --- RECUPERATION DE LA GEOMETRIE
C
      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      IF (.NOT.EXIGEO) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CREATION DES LISTES DES CHAMPS IN ET OUT
C --- GEOMETRIE ET DEPLACEMENTS
C
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PDEPL_M'
      LCHIN(2) = DEPMOI
      LPAIN(3) = 'PDEPL_P'
      LCHIN(3) = DEPDEL
      LPAIN(4) = 'PCONFR'
      LCHIN(4) = CHMLCF
      LPAIN(5) = 'PDEPLAR'
      LCHIN(5) = VITMOI
      LPAIN(6) = 'PCHDYNR'
      LCHIN(6) = ACCMOI
      LPAIN(7) = 'PUSULAR'
      LCHIN(7) = USUPLU
      LPAIN(8) = 'PVITE_P'
      LCHIN(8) = VITPLU
C
C --- PREPARATION DES VECTEURS ELEMENTAIRES 
C
      CALL MEMARE('V',VECTCE,MODELE,' ',' ','CHAR_MECA')
C
C --- CHAMPS DE SORTIE
C
      LPAOUT(1) = 'PVECTUR'
      LCHOUT(1) = VECTCE
C
C --- APPEL A CALCUL
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF
      CALL CALCUL('S',OPTION,LIGRCF,NBIN  ,LCHIN ,LPAIN ,
     &                              NBOUT ,LCHOUT,LPAOUT,BASE)
      CALL REAJRE(VECTCE,LCHOUT(1),BASE)    
C
      CALL JEDEMA()
      END
