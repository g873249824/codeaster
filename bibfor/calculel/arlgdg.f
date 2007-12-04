      SUBROUTINE ARLGDG(MAIL  ,NOM1  ,NOM2  ,DIMVAR,DEGRE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*8  MAIL
      CHARACTER*10 NOM1,NOM2
      INTEGER      DIMVAR(2)
      INTEGER      DEGRE
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CALCUL DU DEGRE MAXIMAL DES GRAPHES NOEUDS -> MAILLES 
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM UTILISATEUR DU MAILLAGE
C IN  NOM1   : NOM DE LA SD DE STOCKAGE MAILLES GROUP_MA_1 
C IN  NOM2   : NOM DE LA SD DE STOCKAGE MAILLES GROUP_MA_2 
C IN  DIMVAR : DIMENSION DES GROUPES DE MAILLES
C OUT DEGRE  : DEGRE MAXIMUM DES GRAPHES 
C
C ON ENRICHIT NOMX(1:10) (X VAUT 1 OU 2)  
C     IN : NOMX(1:10)//'.GROUPEMA': LISTE DES MAILLES
C     IN : NOMX(1:10)//'.BOITE'   : LISTE DES BOITES ENGLOBANTES
C     OUT: NOMX(1:10)//'.GRMAMA'  : GRAPHE MAILLE/MAILLE
C     OUT: NOMX(1:10)//'.CNCINV'  : CONNECTIVITE INVERSE
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
      INTEGER      IFM,NIV  
      CHARACTER*24 NGRM1,NGRIN1,NGRMA1
      CHARACTER*24 NGRM2,NGRIN2,NGRMA2
      INTEGER      JCHM1,JCHM2
      CHARACTER*8  K8BID
      INTEGER      NBMA1,NBMA2
      INTEGER      DEGMAX(2)
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)      
C
C --- INITIALISATIONS
C
      NGRM1  = NOM1(1:10)//'.GROUPEMA'
      NGRMA1 = NOM1(1:10)//'.GRMAMA'
      NGRIN1 = NOM1(1:10)//'.CNCINV'
      NGRM2  = NOM2(1:10)//'.GROUPEMA'
      NGRMA2 = NOM2(1:10)//'.GRMAMA'
      NGRIN2 = NOM2(1:10)//'.CNCINV'  
      DEGMAX(1) = 0
      DEGMAX(2) = 0
               
      CALL JELIRA(NGRM1,'LONMAX',NBMA1,K8BID)
      CALL JEVEUO(NGRM1,'L',JCHM1)
      CALL JELIRA(NGRM2,'LONMAX',NBMA2,K8BID)
      CALL JEVEUO(NGRM2,'L',JCHM2)      
C     
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_1 - CREATION DE LA  '//
     &               'CONNECTIVITE INVERSE NOEUDS -> MAILLE'     
      ENDIF
C
      CALL CNCINV(MAIL,ZI(JCHM1),NBMA1,'V',NGRIN1)
C
      IF (NBMA1.GT.1) THEN
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_1 - CREATION DU GRAPHE '//
     &                 'MAILLE/MAILLE'     
        ENDIF      
        CALL GRMAMA(NGRIN1,NBMA1,DIMVAR(1),'V',NGRMA1,DEGMAX(1))
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_1 - GRAPHE '//
     &                 'MAILLE/MAILLE' 
          CALL GRMAIM(IFM,NGRMA1,DEGMAX(1))     
        ENDIF              
      ENDIF                   
C
C ---
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_2 - CREATION DE LA  '//
     &               'CONNECTIVITE INVERSE NOEUDS -> MAILLE'     
      ENDIF
C      
      CALL CNCINV(MAIL,ZI(JCHM2),NBMA2,'V',NGRIN2) 
C
      IF (NBMA2.GT.1) THEN      
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_2 - CREATION DU GRAPHE '//
     &                 'MAILLE/MAILLE'     
        ENDIF      
        CALL GRMAMA(NGRIN2,NBMA2,DIMVAR(2),'V',NGRMA2,DEGMAX(2)) 
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> GROUP_MA_2 - GRAPHE '//
     &                 'MAILLE/MAILLE' 
          CALL GRMAIM(IFM,NGRMA2,DEGMAX(2))     
        ENDIF         
      ENDIF     
C
      DEGRE = MAX(DEGMAX(1),DEGMAX(2))      
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> DEGRE MAXIMUM: ',DEGRE
      ENDIF
C
      CALL JEDEMA()
      END
