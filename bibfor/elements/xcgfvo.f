      SUBROUTINE XCGFVO(OPTION,NDIM,NNOP,FNO,RHO)

      IMPLICIT NONE

      CHARACTER*16 OPTION
      INTEGER      NDIM,NNOP
      REAL*8       FNO(NDIM*NNOP),RHO
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/11/2012   AUTEUR LADIER A.LADIER 
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRS_1404
C
C    BUT : CALCUL DES CHARGES VOLUMIQUES AUX NOEUD DE L'ELEM PARENT
C         POUR LES OPTIONS CALC_G, CALC_G_F, CALC_K_G ET CALC_K_G_F
C
C 
C IN  OPTION : OPTION DE CALCUL
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NNOP   : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C OUT FNO    : FORCES NODALES CORRESPONDANT AUX CHARGES VOLUMIQUES 
C OUT RHO    : MASSE VOLUMIQUE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------

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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER      IGEOM,IMATE,IFORC,IFORF,ITEMPS,IPESA,IROTA
      INTEGER      IRET,INO,J,KK,MXSTAC
      LOGICAL      FONC
      REAL*8       VALPAR(4),RBID,OM,OMO,R8TADY
      CHARACTER*2  CODRET
      CHARACTER*8  NOMPAR(4)
      CHARACTER*16 PHENOM
      PARAMETER   (MXSTAC=1000)

C     VERIF QUE LES TABLEAUX LOCAUX DYNAMIQUES NE SONT PAS TROP GRANDS
C     (VOIR CRS 1404)
      CALL ASSERT(NDIM*NNOP.LE.MXSTAC)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

C     PARAMETRES DES FORCES VOLUMIQUES
      IF (OPTION.EQ.'CALC_G'.OR.
     &    OPTION.EQ.'CALC_K_G' .OR.
     &    OPTION.EQ.'K_G_MODA') THEN
        FONC=.FALSE.
        CALL JEVECH('PFRVOLU','L',IFORC)
      ELSEIF (OPTION.EQ.'CALC_G_F'.OR.
     &        OPTION.EQ.'CALC_K_G_F') THEN
        FONC=.TRUE.
        CALL JEVECH('PFFVOLU','L',IFORF)
        CALL JEVECH('PTEMPSR','L',ITEMPS)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      CALL TECACH('ONN','PPESANR',1,IPESA,IRET)
      CALL TECACH('ONN','PROTATR',1,IROTA,IRET)

C     INITIALISATION DE FNO
      CALL VECINI(NDIM*NNOP,0.D0,FNO)

C     INITIALISATION DE RHO
      RHO = 0.D0

C     ------------------------------------------------------------------
C                     TRAITEMENT DES FORCES VOLUMIQUES
C     ------------------------------------------------------------------

C     FORCES VOLUMIQUES FONCTION
      IF (FONC) THEN 

        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        VALPAR(NDIM+1) = ZR(ITEMPS)
        IF (NDIM.EQ.2) THEN
          NOMPAR(3) = 'INST'
        ELSEIF (NDIM.EQ.3) THEN
          NOMPAR(3) = 'Z'
          NOMPAR(4) = 'INST'
        ENDIF        

C       INTERPOLATION DE LA FORCE (FONCTION PAR ELEMENT) AUX NOEUDS
        DO 30 INO = 1,NNOP
          DO 31 J = 1,NDIM
            VALPAR(J) = ZR(IGEOM+NDIM*(INO-1)+J-1)
 31       CONTINUE
          DO 32 J = 1,NDIM
            KK = NDIM*(INO-1)+J
            CALL FOINTE('FM',ZK8(IFORF+J-1),NDIM+1,NOMPAR,VALPAR,
     &                                               FNO(KK),IRET)
 32       CONTINUE
 30     CONTINUE
 
C     FORCES VOLUMIQUES CONSTANTES (AUX NOEUDS)
      ELSE
      
        DO 33 INO = 1,NNOP
          DO 34 J = 1,NDIM
            FNO(NDIM*(INO-1)+J) = ZR(IFORC+NDIM*(INO-1)+J-1)
 34       CONTINUE
 33     CONTINUE
 
      ENDIF
      
C     ------------------------------------------------------------------
C            TRAITEMENT DES FORCES DE PESANTEUR OU DE ROTATION
C     ------------------------------------------------------------------

      IF ((IPESA.NE.0).OR.(IROTA.NE.0)) THEN
      
        CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)
        CALL RCVALB('RIGI',1,1,'+',ZI(IMATE),' ',PHENOM,1,' ',RBID,1,
     &              'RHO',RHO,CODRET,'FM')
     
        IF (IPESA.NE.0) THEN
          DO 60 INO=1,NNOP
            DO 61 J=1,NDIM
              KK = NDIM*(INO-1)+J
              FNO(KK) = FNO(KK) + RHO*ZR(IPESA)*ZR(IPESA+J)
 61         CONTINUE
 60       CONTINUE
        ENDIF
        
        IF (IROTA.NE.0) THEN
          OM = ZR(IROTA)
          DO 62 INO=1,NNOP
            OMO = 0.D0
            DO 63 J=1,NDIM
              OMO = OMO + ZR(IROTA+J)* ZR(IGEOM+NDIM*(INO-1)+J-1)
 63         CONTINUE
            DO 64 J=1,NDIM
              KK = NDIM*(INO-1)+J
              FNO(KK)=FNO(KK)+RHO*OM*OM*(ZR(IGEOM+KK-1)-OMO*ZR(IROTA+J))
 64         CONTINUE
 62       CONTINUE
        ENDIF
        
      ENDIF

C     ------------------------------------------------------------------

      END
