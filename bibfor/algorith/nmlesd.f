      SUBROUTINE NMLESD(TYPESD,NOMSD ,NOMPAR,VALI  ,VALR  ,
     &                  VALK  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/01/2012   AUTEUR BEAURAIN J.BEAURAIN 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*(*) TYPESD
      CHARACTER*(*) NOMSD
      CHARACTER*(*) NOMPAR
      INTEGER       VALI
      REAL*8        VALR
      CHARACTER*(*) VALK    
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C LECTURE DANS UNE SD
C
C ----------------------------------------------------------------------
C
C
C IN  TYPESD :  TYPE DE LA SD
C               'POST_TRAITEMENT' - MODES VIBRATOIRES OU 
C                                  FLAMBEMENT OU STABILITE
C IN  NOMSD  : NOM DE LA SD
C IN  NOMPAR : NOM DU PARAMETRE
C IN  VALI   : PARAMETRE DE TYPE ENTIER
C IN  VALR   : PARAMETRE DE TYPE REEL
C IN  VALK   : PARAMETRE DE TYPE CHAINE (K24)
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C   
      CHARACTER*24 SDINFI,SDINFR,SDINFK
      INTEGER      JPINFI,JPINFR,JPINFK
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      VALI   = 0
      VALR   = 0.D0
      VALK   = ' '     
C
C --- INTERROGATION
C 
      IF (TYPESD.EQ.'POST_TRAITEMENT') THEN
        SDINFI = NOMSD(1:19)//'.INFI'
        SDINFR = NOMSD(1:19)//'.INFR'
        SDINFK = NOMSD(1:19)//'.INFK'         
        CALL JEVEUO(SDINFI,'L',JPINFI)
        CALL JEVEUO(SDINFR,'L',JPINFR)      
        CALL JEVEUO(SDINFK,'L',JPINFK)
        
        IF (NOMPAR.EQ.'CRIT_STAB') THEN 
          VALI = ZI(JPINFI+1-1)
        ELSEIF(NOMPAR.EQ.'MODE_VIBR') THEN 
          VALI = ZI(JPINFI+2-1)
        ELSEIF(NOMPAR.EQ.'OPTION_CALCUL_FLAMB') THEN 
          VALK = ZK24(JPINFK+1-1)
        ELSEIF(NOMPAR.EQ.'OPTION_CALCUL_VIBR') THEN 
          VALK = ZK24(JPINFK+2-1)  
        ELSEIF(NOMPAR.EQ.'TYPE_MATR_VIBR') THEN 
          VALK = ZK24(JPINFK+3-1)
        ELSEIF(NOMPAR.EQ.'OPTION_EXTR_VIBR') THEN 
          VALK = ZK24(JPINFK+4-1)
        ELSEIF(NOMPAR.EQ.'NB_FREQ_VIBR') THEN 
          VALI = ZI(JPINFI+3-1)
        ELSEIF(NOMPAR.EQ.'BANDE_VIBR_1') THEN 
          VALR = ZR(JPINFR+1-1)
        ELSEIF(NOMPAR.EQ.'BANDE_VIBR_2') THEN 
          VALR = ZR(JPINFR+2-1)
        ELSEIF(NOMPAR.EQ.'TYPE_MATR_FLAMB') THEN 
          VALK = ZK24(JPINFK+5-1)         
        ELSEIF(NOMPAR.EQ.'NB_FREQ_FLAMB') THEN 
          VALI = ZI(JPINFI+4-1)
        ELSEIF(NOMPAR.EQ.'BANDE_FLAMB_1') THEN 
          VALR = ZR(JPINFR+3-1)
        ELSEIF(NOMPAR.EQ.'BANDE_FLAMB_2') THEN 
          VALR = ZR(JPINFR+4-1)
        ELSEIF(NOMPAR.EQ.'RIGI_GEOM_FLAMB') THEN 
          VALK = ZK24(JPINFK+6-1)
        ELSEIF(NOMPAR.EQ.'NB_DDL_EXCLUS') THEN 
          VALI = ZI(JPINFI+5-1)
        ELSEIF(NOMPAR.EQ.'SOLU_FREQ_VIBR') THEN 
          VALR = ZR(JPINFR+5-1)
        ELSEIF(NOMPAR.EQ.'SOLU_FREQ_FLAM') THEN 
          VALR = ZR(JPINFR+6-1)
        ELSEIF(NOMPAR.EQ.'SOLU_NUME_VIBR') THEN 
          VALI = ZI(JPINFI+6-1)
        ELSEIF(NOMPAR.EQ.'SOLU_NUME_FLAM') THEN 
          VALI = ZI(JPINFI+7-1)
        ELSEIF(NOMPAR.EQ.'SOLU_MODE_VIBR') THEN 
          VALK = ZK24(JPINFK+8-1)
        ELSEIF(NOMPAR.EQ.'SOLU_MODE_FLAM') THEN 
          VALK = ZK24(JPINFK+9-1)
        ELSEIF(NOMPAR.EQ.'NOM_DDL_EXCLUS') THEN 
          VALK = ZK24(JPINFK+10-1)
        ELSEIF(NOMPAR.EQ.'NB_DDL_STAB') THEN 
          VALI = ZI(JPINFI+8-1)          
        ELSEIF(NOMPAR.EQ.'NOM_DDL_STAB') THEN 
          VALK = ZK24(JPINFK+11-1)   
        ELSEIF(NOMPAR.EQ.'SOLU_FREQ_STAB') THEN 
          VALR = ZR(JPINFR+7-1)          
        ELSEIF(NOMPAR.EQ.'SOLU_NUME_STAB') THEN 
          VALI = ZI(JPINFI+9-1)          
        ELSEIF(NOMPAR.EQ.'SOLU_MODE_STAB') THEN
          VALK = ZK24(JPINFK+12-1)
        ELSEIF(NOMPAR.EQ.'COEF_DIM_FLAMB') THEN
          VALI = ZI(JPINFI+10-1)
        ELSEIF(NOMPAR.EQ.'COEF_DIM_VIBR') THEN
          VALI = ZI(JPINFI+11-1)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF              
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
 
C          
      CALL JEDEMA()
      END
