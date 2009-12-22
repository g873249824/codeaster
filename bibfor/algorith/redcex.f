      SUBROUTINE REDCEX(NDIMG ,RESOCO,NEQ   ,NUMNOE,NORM  ,
     &                  EXNOE )
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INTEGER      NEQ,NUMNOE,NDIMG
      CHARACTER*24 RESOCO
      REAL*8       NORM(3)
      LOGICAL      EXNOE
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT - UTILITAIRE)
C
C DETECTION DE RELATIONS DE CONTACT REDONDANTES AVEC
C LES CONDITIONS AUX LIMITES DDL_IMPO ET LIAISON_DDL
C      
C ----------------------------------------------------------------------
C
C
C IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  NUMNOE : NUMERO DU NOEUD ESCLAVE
C IN  NORM   : NORMALE AU NOEUD ESCLAVE
C IN  NORM   : VECTEUR NORMAL AU NOEUD MAITRE APPARIE
C OUT EXNOE  : VAUT .TRUE. SI LE NOEUD DOIT ETRE EXCLU DE 
C              LA SURFACE DE CONTACT (PIVOT NUL)
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
      INTEGER      I,K
      REAL*8       PROV(3),NPROV,VECTX(3),VECTY(3),VECTZ(3)
      LOGICAL      EXNOX,EXNOY,EXNOZ
      CHARACTER*24 VECNOD,VECNOX,VECNOY,VECNOZ
      INTEGER      JVECNO,JVECNX,JVECNY,JVECNZ 
C
      DATA VECTX    /1.D0,0.D0,0.D0/  
      DATA VECTY    /0.D0,1.D0,0.D0/   
      DATA VECTZ    /0.D0,0.D0,1.D0/                      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS 
C
      EXNOX  = .FALSE. 
      EXNOY  = .FALSE.
      EXNOZ  = .FALSE.
      EXNOE  = .FALSE.      
C
C --- ACCES AUX STRUCTURES DE DONNEES POUR LA
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES
C 
      VECNOD = RESOCO(1:14)//'.VECNOD'
      VECNOX = RESOCO(1:14)//'.VECNOX'
      VECNOY = RESOCO(1:14)//'.VECNOY'
      VECNOZ = RESOCO(1:14)//'.VECNOZ'
      CALL JEVEUO(VECNOD,'L',JVECNO)
      CALL JEVEUO(VECNOX,'L',JVECNX)
      CALL JEVEUO(VECNOY,'L',JVECNY)
      CALL JEVEUO(VECNOZ,'L',JVECNZ)
C            
      DO 11, I=(1+NEQ),(2*NEQ)
        IF (NUMNOE .EQ. ZI(JVECNO+I-1)) THEN
          EXNOE =.TRUE.
        ENDIF
11    CONTINUE      
      
      DO 12, K=1,NEQ
        IF (NUMNOE .EQ. ZI(JVECNO+K-1)) THEN
          IF (ZI(JVECNX+K-1) .EQ. 1) THEN
            EXNOX =.TRUE.
          ENDIF
          IF (ZI(JVECNY+K-1) .EQ. 1) THEN
            EXNOY =.TRUE.
          ENDIF           
          IF (ZI(JVECNZ+K-1) .EQ. 1) THEN
            EXNOZ =.TRUE.
          ENDIF
        ENDIF  
12    CONTINUE
      
      IF (NDIMG.EQ.2) THEN     
        IF (EXNOX .AND. EXNOY) THEN
          EXNOE=.TRUE.
        ENDIF  
        IF (EXNOX .AND.(.NOT. EXNOY)) THEN             
          CALL PROVEC(NORM,VECTX,PROV)
          CALL NORMEV(PROV,NPROV)              
          IF (NPROV .EQ. 0.D0) THEN
            EXNOE = .TRUE.              
          ENDIF  
        ENDIF
        IF ((.NOT. EXNOX) .AND. EXNOY) THEN               
          CALL PROVEC(NORM,VECTY,PROV)
          CALL NORMEV(PROV,NPROV)              
          IF (NPROV .EQ. 0.D0) THEN
            EXNOE = .TRUE.              
          ENDIF            
        ENDIF
      ELSE IF (NDIMG.EQ.3) THEN
        IF (EXNOX .AND. EXNOY .AND.  EXNOZ) THEN
          EXNOE=.TRUE.
        ENDIF  
        IF (EXNOX .AND. EXNOY .AND.(.NOT. EXNOZ)) THEN 
          IF (NORM(3) .EQ. 0.D0) EXNOE = .TRUE.            
        ENDIF
        IF (EXNOX .AND. EXNOZ .AND.(.NOT. EXNOY)) THEN 
          IF(NORM(2) .EQ. 0.D0) EXNOE = .TRUE.            
        ENDIF
        IF (EXNOY .AND. EXNOZ .AND.(.NOT. EXNOX)) THEN 
          IF(NORM(1) .EQ. 0.D0) EXNOE = .TRUE.            
        ENDIF
        IF (EXNOX .AND.(.NOT. EXNOY).AND.(.NOT. EXNOZ)) THEN            
          CALL PROVEC(NORM,VECTX,PROV)
          CALL NORMEV(PROV,NPROV)              
          IF (NPROV .EQ. 0.D0) THEN
            EXNOE = .TRUE.              
          ENDIF             
        ENDIF
        IF ((.NOT. EXNOX) .AND. EXNOY .AND.(.NOT. EXNOZ)) THEN   
          CALL PROVEC(NORM,VECTY,PROV)
          CALL NORMEV(PROV,NPROV)              
          IF (NPROV .EQ. 0.D0) THEN
            EXNOE = .TRUE.              
          ENDIF     
        ENDIF
        IF ((.NOT. EXNOX) .AND. (.NOT. EXNOY).AND. EXNOZ) THEN 
          CALL PROVEC(NORM,VECTZ,PROV)
          CALL NORMEV(PROV,NPROV)              
          IF (NPROV .EQ. 0.D0) THEN
            EXNOE = .TRUE.              
          ENDIF     
        ENDIF       
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF    
C        
      CALL JEDEMA()
      END
