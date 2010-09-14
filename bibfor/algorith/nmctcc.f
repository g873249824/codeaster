      SUBROUTINE NMCTCC(NOMA  ,MODELE,SDDYNA,SDIMPR,DEFICO,
     &                  RESOCO,VALINC,MMCVCA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      LOGICAL      MMCVCA
      CHARACTER*8  NOMA
      CHARACTER*24 MODELE
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 SDDYNA
      CHARACTER*24 SDIMPR
      CHARACTER*19 VALINC(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGO - BOUCLE CONTACT)
C             
C ALGO. DES CONTRAINTES ACTIVES
C      
C ----------------------------------------------------------------------
C 
C      
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  SDDYNA : SD POUR DYNAMIQUE
C IN  SDIMPR : SD AFFICHAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C OUT MMCVCA : INDICATEUR DE CONVERGENCE POUR BOUCLE DES 
C              CONTRAINTES ACTIVES
C               .TRUE. SI LA BOUCLE DES CONTRAINTES ACTIVES A CONVERGE
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
      INTEGER      IFM,NIV
      LOGICAL      CFDISL,LTFCM,LCTCC,LXFCM,LFROT
      INTEGER      CFDISI,NTPC,ITEMUL,MAXCON
      INTEGER      MMITCA
      CHARACTER*8  NOMO
      REAL*8       R8BID,R8VIDE
      INTEGER      IBID
      CHARACTER*16 K16BLA
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECANONLINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ALGORITHME DES CONTRAINTES ACTIVES' 
      ENDIF       
C
C --- INITIALISATIONS
C
      NOMO   = MODELE(1:8)
      NTPC   = CFDISI(DEFICO,'NTPC') 
      K16BLA = ' ' 
      MMCVCA = .FALSE.
C
C --- INFOS BOUCLE CONTACT
C      
      CALL MMBOUC(RESOCO,'CONT','READ',MMITCA)
      ITEMUL  = CFDISI(DEFICO,'ITER_CONT_MULT')
      IF (ITEMUL.EQ.-1) THEN
        MAXCON  = CFDISI(DEFICO,'ITER_CONT_MAXI')  
      ELSE
        MAXCON  = ITEMUL*NTPC
      ENDIF
C
C --- TYPE DE CONTACT      
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')
      LFROT  = CFDISL(DEFICO,'FROTTEMENT')
      LTFCM  = CFDISL(DEFICO,'CONT_XFEM_GG')   
C
C --- APPEL ALGO DES CONT. ACTIVES
C
      IF (LXFCM) THEN
        IF (LTFCM) THEN
          CALL XMTBCA(NOMA  ,DEFICO,RESOCO,VALINC,MMCVCA)
        ELSE
          CALL XMMBCA(NOMA  ,NOMO  ,RESOCO,VALINC,MMCVCA)
        ENDIF
      ELSEIF (LCTCC) THEN
        CALL MMMBCA(NOMA  ,SDDYNA,DEFICO,RESOCO,VALINC,
     &              MMCVCA)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CONVERGENCE CONTRAINTES ACTIVES
C
      IF ((.NOT.MMCVCA).AND.(MMITCA.EQ.MAXCON)) THEN
        IF (LFROT) THEN
C ------- CONVERGENCE FORCEE
          CALL U2MESS('A','CONTACT3_86')
          MMCVCA = .TRUE.        
        ELSE
          CALL U2MESS('F','CONTACT3_85')
        ENDIF  
      END IF
C
C --- IMPRESSIONS
C      
      CALL IMPSDR(SDIMPR,'CTCC_NOEU',K16BLA,R8BID   ,IBID  )
      CALL IMPSDR(SDIMPR,'CTCC_BOUC',K16BLA,R8VIDE(),IBID  )      
C
      IF (MMCVCA) THEN
        CALL NMIMPR('IMPR','CNV_CTACT',' ',0.D0,MMITCA)      
      ENDIF      
C
      CALL JEDEMA()
      END
