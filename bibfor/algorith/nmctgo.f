      SUBROUTINE NMCTGO(NOMA  ,SDIMPR,DEFICO,RESOCO,MAXREL,
     &                  VALINC,MMCVGO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO,SDIMPR
      CHARACTER*19 VALINC(*)
      LOGICAL      MAXREL,MMCVGO
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGO - BOUCLE CONTACT)
C             
C SEUIL DE GEOMETRIE
C      
C ----------------------------------------------------------------------
C 
C     
C IN  NOMA   : NOM DU MAILLAGE 
C IN  SDIMPR : SD AFFICHAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  MAXREL : .TRUE. SI CRITERE RESI_GLOB_RELA ET CHARGEMENT = 0,
C                     ON UTILISE RESI_GLOB_MAXI
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C OUT MMCVCA : INDICATEUR DE CONVERGENCE POUR BOUCLE DE 
C              GEOMETRIE
C               .TRUE. SI LA BOUCLE A CONVERGE
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
      LOGICAL      CFDISL,LCTCC,LCTCD,LXFCM
      LOGICAL      LSANS,LMANU,LAUTO
      INTEGER      CFDISI,NBREAG,MAXGEO
      INTEGER      MMITGO
      CHARACTER*19 DEPPLU,DEPGEO
      CHARACTER*16 CVGNOE
      REAL*8       CVGVAL,EPSGEO
      CHARACTER*24 CLREAC
      INTEGER      JCLREA 
      LOGICAL      CTCGEO     
      REAL*8       CFDISR,R8BID
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
        WRITE (IFM,*) '<CONTACT> MISE A JOUR DU SEUIL DE GEOMETRIE' 
      ENDIF       
C
C --- INITIALISATIONS
C
      K16BLA = ' '
      MMCVGO = .FALSE.
      DEPGEO = RESOCO(1:14)//'.DEPG'
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C       
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
C
C --- INFOS BOUCLE GEOMETRIQUE
C
      CALL MMBOUC(RESOCO,'GEOM','READ',MMITGO)
      MAXGEO  = CFDISI(DEFICO,'ITER_GEOM_MAXI')  
      NBREAG  = CFDISI(DEFICO,'NB_ITER_GEOM'  )
      EPSGEO  = CFDISR(DEFICO,'RESI_GEOM'     )             
C
C --- TYPE DE CONTACT      
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LCTCD  = CFDISL(DEFICO,'FORMUL_DISCRETE') 
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')     
C
      LMANU  = CFDISL(DEFICO,'REAC_GEOM_MANU')
      LSANS  = CFDISL(DEFICO,'REAC_GEOM_SANS')
      LAUTO  = CFDISL(DEFICO,'REAC_GEOM_AUTO')
C
C --- MISE A JOUR DES SEUILS
C        
      IF (LCTCC.OR.LXFCM) THEN 
        CALL MMMCRI('GEOM',NOMA  ,DEPGEO,DEPPLU,EPSGEO,
     &              CVGNOE,CVGVAL,MMCVGO)
C
C ----- CAS MANUEL    
C
        IF (LMANU) THEN
          IF (MMITGO.EQ.NBREAG) THEN
            IF (.NOT.MMCVGO) THEN
              CALL U2MESS('A','CONTACT3_96')
            ENDIF
            MMCVGO = .TRUE.
          ELSE
            MMCVGO = .FALSE.
          ENDIF        
        ENDIF
C
C ----- CAS SANS    
C
        IF (LSANS) THEN
          MMCVGO = .TRUE.
        ENDIF 
C
C ----- CAS AUTO    
C
        IF (LAUTO) THEN
          IF ((.NOT.MMCVGO).AND.(MMITGO.EQ.(MAXGEO+1))) THEN
            CALL U2MESS('F','CONTACT3_81')
          ENDIF 
        ENDIF        
C
C ----- IMPRESSIONS
C 
        CALL IMPSDR(SDIMPR,'CTCC_NOEU',CVGNOE,R8BID ,IBID)
        CALL IMPSDR(SDIMPR,'CTCC_BOUC',K16BLA,CVGVAL,IBID)              
C
        IF (MMCVGO) THEN
          CALL NMIMPR('IMPR','CNV_GEOME',K16BLA,0.D0,MMITGO)
          CALL IMPSDM(SDIMPR,'ITER_NEWT',' ')
          IF (MAXREL) THEN
            CALL NMCVGI('CVG_MX') 
          ELSE
            CALL NMCVGI('CVG_OK') 
          ENDIF
        ELSE     
          CALL COPISD('CHAMP_GD','V',DEPPLU,DEPGEO)        
        ENDIF           
      ELSEIF (LCTCD) THEN  
      
        CLREAC = RESOCO(1:14)//'.REAL'             
        CALL JEVEUO(CLREAC,'L',JCLREA)      
        CTCGEO = ZL(JCLREA+1-1) 
C
C ----- IMPRESSIONS
C                   
        IF (.NOT.CTCGEO) THEN 
          MMCVGO = .TRUE.       
          CALL NMIMPR('IMPR','CNV_GEOME',K16BLA,0.D0,0)
          IF (MAXREL) THEN
            CALL NMCVGI('CVG_MX') 
          ELSE
            CALL NMCVGI('CVG_OK') 
          ENDIF    
        ELSE  
          MMCVGO = .FALSE.
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)      
      ENDIF 
C
      CALL JEDEMA()
      END
