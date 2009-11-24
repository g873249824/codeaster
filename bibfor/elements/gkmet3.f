      SUBROUTINE GKMET3(NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR,NUM)
      IMPLICIT NONE

      INTEGER         NNOFF,IADRGK,IADGKS,IADGKI,NUM
      CHARACTER*24    CHFOND,ABSCUR


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/11/2009   AUTEUR GENIAUT S.GENIAUT 
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
C
C ......................................................................
C      METHODE THETA-LAGRANGE ET G-LAGRANGE POUR LE CALCUL DE G(S)
C      K1(S) K2(S) ET K3(S) DANS LE CADRE X-FEM
C
C ENTREE
C
C     MODELE   --> NOM DU MODELE
C     NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C     NORMFF   --> VALEURS DE LA NORMALE SUR LE FOND DE FISSURE
C     FOND     --> NOMS DES NOEUDS DU FOND DE FISSURE
C     IADRGK    --> ADRESSE DE VALEURS DE GKTHI
C                 (G, K1, K2, K3 POUR LES CHAMPS THETAI)
C
C  SORTIE
C
C   IADGKS     --> ADRESSE DE VALEURS DE GKS 
C                   (VALEUR DE G(S), K1(S), K2(S), K3(S), BETA(S)
C   IADGKI     --> ADRESSE DE VALEURS DE GKTHI
C                  (G, K1, K2, K3 POUR LES CHAMPS THETAI)
C   ABSCUR     --> VALEURS DES ABSCISSES CURVILIGNES S
C      NUM     --> 3 (LAGRANGE-LAGRANGE)
C              --> 4 (NOEUD-NOEUD)
C
      INTEGER      IFON,IADABS,IVECT,IMATR
      INTEGER      I,IBID,KK,J
      REAL*8       S1,S2,DELTA,S3,SN2,SN1,SN
      REAL*8       GTHI(NNOFF),K1TH(NNOFF),K2TH(NNOFF),K3TH(NNOFF)
      REAL*8       GS(NNOFF),K1S(NNOFF),K2S(NNOFF),K3S(NNOFF)
      REAL*8       BETAS(NNOFF),GITH(NNOFF),GIS(NNOFF)
      REAL*8       G1TH(NNOFF),G2TH(NNOFF),G3TH(NNOFF)
      REAL*8       G1S(NNOFF),G2S(NNOFF),G3S(NNOFF)
      CHARACTER*24 LISSG,VECT,MATR

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
      CHARACTER*24 ZK24CM
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24CM(1),ZK32(1),ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CALL JEMARQ()
C
      CALL JEVEUO(CHFOND,'L',IFON)
      CALL JEVEUO(ABSCUR,'E',IADABS)
      DO 10 I=1,NNOFF
        ZR(IADABS-1+(I-1)+1)=ZR(IFON-1+4*(I-1)+4)
        GTHI(I)=ZR(IADRGK-1+(I-1)*8+1)
        G1TH(I)=ZR(IADRGK-1+(I-1)*8+2)
        G2TH(I)=ZR(IADRGK-1+(I-1)*8+3)
        G3TH(I)=ZR(IADRGK-1+(I-1)*8+4)
        K1TH(I)=ZR(IADRGK-1+(I-1)*8+5)
        K2TH(I)=ZR(IADRGK-1+(I-1)*8+6)
        K3TH(I)=ZR(IADRGK-1+(I-1)*8+7)
        GITH(I)=G1TH(I)*G1TH(I) +G2TH(I)*G2TH(I) +G3TH(I)*G3TH(I)
10    CONTINUE

      CALL GETVTX('LISSAGE','LISSAGE_G',1,1,1,LISSG,IBID)
C
      IF (LISSG .EQ. 'LAGRANGE_NO_NO') THEN
        VECT = '&&METHO3.VECT'
        CALL WKVECT(VECT,'V V R8',NNOFF,IVECT)
        NUM = 4
        DO 20 I = 1,NNOFF-1
          S1 = ZR(IADABS+I-1)
          S2 = ZR(IADABS+I+1-1)
          DELTA = (S2-S1) / 3.D0
          ZR(IVECT+I-1) = ZR(IVECT+I-1) + DELTA
          ZR(IVECT+I+1-1) = 2.D0 * DELTA
 20     CONTINUE
        DO 30 I=1,NNOFF
          GS(I) = GTHI(I)/ZR(IVECT+I-1 )
          K1S(I) = K1TH(I)/ZR(IVECT+I-1 )
          K2S(I) = K2TH(I)/ZR(IVECT+I-1 )
          K3S(I) = K3TH(I)/ZR(IVECT+I-1 )
          GIS(I) = GITH(I)/(ZR(IVECT+I-1 ) * ZR(IVECT+I-1 ))
                
30      CONTINUE

C       CORRECTION DES VALEURS AUX EXTREMITES (RESULTAT + PRECIS)
        IF (NNOFF .GT. 2) THEN
          S1 = ZR(IADABS-1+1)
          S2 = ZR(IADABS-1+2)
          S3 = ZR(IADABS-1+3)
          SN2 = ZR(IADABS-1+NNOFF-2)
          SN1 = ZR(IADABS-1+NNOFF-1)
          SN =  ZR(IADABS-1+NNOFF)

          GS(1)=GS(2)+(S1-S2)*(GS(3)-GS(2))/(S3-S2)
          K1S(1)=K1S(2)+(S1-S2)*(K1S(3)-K1S(2))/(S3-S2)
          K2S(1)=K2S(2)+(S1-S2)*(K2S(3)-K2S(2))/(S3-S2)
          K3S(1)=K3S(2)+(S1-S2)*(K3S(3)-K3S(2))/(S3-S2)
          GIS(1)=GIS(2)+(S1-S2)*(GIS(3)-GIS(2))/(S3-S2)
          GS(NNOFF)=GS(NNOFF-1)
     &        +(SN-SN1)*(GS(NNOFF-2)-GS(NNOFF-1))/(SN2-SN1)
          K1S(NNOFF)=K1S(NNOFF-1)
     &        +(SN-SN1)*(K1S(NNOFF-2)-K1S(NNOFF-1))/(SN2-SN1)
          K2S(NNOFF)=K2S(NNOFF-1)
     &        +(SN-SN1)*(K2S(NNOFF-2)-K2S(NNOFF-1))/(SN2-SN1)
          K3S(NNOFF)=K3S(NNOFF-1)
     &        +(SN-SN1)*(K3S(NNOFF-2)-K3S(NNOFF-1))/(SN2-SN1)
          GIS(NNOFF)=GIS(NNOFF-1)
     &        +(SN-SN1)*(GIS(NNOFF-2)-GIS(NNOFF-1))/(SN2-SN1)
          
        ENDIF
        
      ELSEIF (LISSG .EQ. 'LAGRANGE') THEN
        MATR = '&&METHO3.MATRI'

        CALL WKVECT(MATR,'V V R8',NNOFF*NNOFF,IMATR)

        NUM = 3
        DO 40 I = 1,NNOFF-1
          S1 = ZR(IADABS+I-1)
          S2 = ZR(IADABS+I)          
          DELTA = (S2-S1) / 6.D0
C
          KK = IMATR + (I-1)*NNOFF + I - 1
          ZR(KK) = ZR(KK) + 2.D0*DELTA
          ZR(IMATR+(I-1+1)*NNOFF+I-1) = 1.D0 * DELTA
C
          ZR(IMATR+(I-1)*NNOFF+I-1+1) = 1.D0 * DELTA
          ZR(IMATR+(I-1+1)*NNOFF+I-1+1) = 2.D0 * DELTA
 40     CONTINUE
 

C       CORRECTION DES VALEURS AUX EXTREMITES (RESULTAT + PRECIS)
        IF (NNOFF .NE. 2) THEN
          S1 = ZR(IADABS-1+1)
          S2 = ZR(IADABS-1+2)
          S3 = ZR(IADABS-1+3)
          SN2 = ZR(IADABS-1+NNOFF-2)
          SN1 = ZR(IADABS-1+NNOFF-1)
          SN =  ZR(IADABS-1+NNOFF)

          GTHI(1)=GTHI(2)*(S2-S1)/(S3-S1)
          K1TH(1)=K1TH(2)*(S2-S1)/(S3-S1)
          K2TH(1)=K2TH(2)*(S2-S1)/(S3-S1)
          K3TH(1)=K3TH(2)*(S2-S1)/(S3-S1)
          GITH(1)=GITH(2)*(S2-S1)/(S3-S1)
          GTHI(NNOFF)=GTHI(NNOFF-1)*(SN-SN1)/(SN-SN2)
          K1TH(NNOFF)=K1TH(NNOFF-1)*(SN-SN1)/(SN-SN2)
          K2TH(NNOFF)=K2TH(NNOFF-1)*(SN-SN1)/(SN-SN2)
          K3TH(NNOFF)=K3TH(NNOFF-1)*(SN-SN1)/(SN-SN2)
          GITH(NNOFF)=GITH(NNOFF-1)*(SN-SN1)/(SN-SN2)
        ENDIF
        
C       SYSTEME LINEAIRE:  MATR*GS = GTHI
        CALL GSYSTE(MATR,NNOFF,NNOFF,GTHI,GS)

C       SYSTEME LINEAIRE:  MATR*K1S = K1TH
        CALL GSYSTE(MATR,NNOFF,NNOFF,K1TH,K1S)

C       SYSTEME LINEAIRE:  MATR*K2S = K2TH
        CALL GSYSTE(MATR,NNOFF,NNOFF,K2TH,K2S)

C       SYSTEME LINEAIRE:  MATR*K3S = K3TH
        CALL GSYSTE(MATR,NNOFF,NNOFF,K3TH,K3S)
        
C       SYSTEMES LINEAIRES POUR GIRWIN
        CALL GSYSTE(MATR,NNOFF,NNOFF,G1TH,G1S)
        CALL GSYSTE(MATR,NNOFF,NNOFF,G2TH,G2S)
        CALL GSYSTE(MATR,NNOFF,NNOFF,G3TH,G3S)
        DO 50 I=1,NNOFF
          GIS(I)=G1S(I)*G1S(I) + G2S(I)*G2S(I) +G3S(I)*G3S(I)
 50     CONTINUE

      ENDIF
      
 100  CONTINUE
      DO 60 I=1,NNOFF
        ZR(IADGKS-1+(I-1)*6+1)=GS(I)
        ZR(IADGKS-1+(I-1)*6+2)=K1S(I)
        ZR(IADGKS-1+(I-1)*6+3)=K2S(I)
        ZR(IADGKS-1+(I-1)*6+4)=K3S(I)
        ZR(IADGKS-1+(I-1)*6+5)=GIS(I)
 60   CONTINUE

      DO 70 I=1,NNOFF
        ZR(IADGKI-1+(I-1)*5+1) = ZR(IADRGK-1+(I-1)*8+1)
        ZR(IADGKI-1+(I-1)*5+2) = ZR(IADRGK-1+(I-1)*8+5)
        ZR(IADGKI-1+(I-1)*5+3) = ZR(IADRGK-1+(I-1)*8+6)
        ZR(IADGKI-1+(I-1)*5+4) = ZR(IADRGK-1+(I-1)*8+7)
 70   CONTINUE


C     CALCUL DES ANGLES DE PROPAGATION DE FISSURE LOCAUX BETA
      DO 80 I=1,NNOFF
        BETAS(I) = 0.0D0      
        IF (K2S(I).NE.0.D0) BETAS(I) = 2.0D0*ATAN2(0.25D0*(K1S(I)/K2S(I)
     &    -SIGN(1.0D0,K2S(I))*SQRT((K1S(I)/K2S(I))**2.0D0+8.0D0)),1.0D0)
          ZR(IADGKS-1+(I-1)*6+6)=BETAS(I)
 80   CONTINUE

      CALL JEDETR('&&METHO3.MATRI')
      CALL JEDETR('&&METHO3.VECT')

      CALL JEDEMA()
      END
