      FUNCTION ARLFG(NOMBO1,NOMBO2)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      ARLFG
      CHARACTER*16 NOMBO1
      CHARACTER*16 NOMBO2      
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C ESTIMATION DU MAILLAGE LE PLUS FIN
C
C ----------------------------------------------------------------------
C
C
C IN  NOMBO1 : NOM DE LA SD POUR LES BOITES GROUPE 1 (APRES FILTRAGE)
C IN  NOMBO2 : NOM DE LA SD POUR LES BOITES GROUPE 2 (APRES FILTRAGE)
C
C RESULTAT FONCTION
C ARLFG   : 1 SI MAILLAGE 1 PLUS FIN QUE MAILLAGE 2
C           2 DANS LE CAS CONTRAIRE
C
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
      INTEGER      JBOIH1,JBOIH2,NBBOI1,NBBOI2,I
      REAL*8       H1,H2
      INTEGER      IFM,NIV 
      CHARACTER*8  K8BID      
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
      CALL INFNIV(IFM,NIV) 
C
C --- AFFICHAGES
C      
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> DETECTION AUTOMATIQUE DES FINESSES '//
     &               'RELATIVES...'
      ENDIF                  
C
C --- LECTURE DONNEES
C
      CALL JELIRA(NOMBO1(1:16)//'.H','LONMAX',NBBOI1,K8BID)
      CALL JELIRA(NOMBO2(1:16)//'.H','LONMAX',NBBOI2,K8BID)
      CALL JEVEUO(NOMBO1(1:16)//'.H','L',JBOIH1)
      CALL JEVEUO(NOMBO2(1:16)//'.H','L',JBOIH2)
C
C --- CALCUL DU VOLUME (SURFACE) MOYEN(NE) DES DEUX MAILLAGES
C
      H1 = 0.D0
      DO 10 I = 1, NBBOI1
        H1 = H1 + ZR(JBOIH1+I-1)
 10   CONTINUE
      H1 = H1/NBBOI1
C
      H2 = 0.D0
      DO 20 I = 1, NBBOI2
        H2 = H2 + ZR(JBOIH2+I-1)
 20   CONTINUE
      H2 = H2/NBBOI2
C     
C --- COMPARAISON
C
      IF (H1.LT.H2) THEN
        ARLFG = 1
      ELSE
        ARLFG = 2
      ENDIF       
C
      CALL JEDEMA()
      END
