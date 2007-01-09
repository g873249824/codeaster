      SUBROUTINE GRMAMA(NGRINV,NMA  ,DIMVAR,BASE  ,
     &                  NGRMM ,DEGMAX) 
C         
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*1   BASE
      CHARACTER*24  NGRINV,NGRMM        
      INTEGER       NMA,DIMVAR,DEGMAX            
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DU GRAPHE MAILLE / MAILLE
C
C ----------------------------------------------------------------------
C
C
C IN  NGRINV : SD CONNECTIVITE INVERSE (CF CNCINV)    
C IN  NMA    : NOMBRE DE MAILLES
C IN  DIMVAR : DIMENSION MINIMALE (DEFAUT = 1)
C IN  BASE   : BASE DE CREATION DE NGRMMZ
C IN  NGRMM  : NOM DE L'OBJET GRAPHE MAILLE/MAILLE
C OUT NGRMM  : (XC V I NUMERO VARIABLE)
C          MAILLE -> LISTE DES MAILLES VOISINES  
C          (IE. DIFFERENTES ET PARTAGEANT UN NOEUD)
C             [MAILLE I] (IMA1,IMA2,...)
C OUT DEGMAX : DEGRE MAXIMUM DU GRAPHE
C
C NB: LA NUMEROTATION DES MAILLES EST FAITE DANS LIMA (CF CNCINV)   
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM ,JEXATR
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
      CHARACTER*8   K8BID
      INTEGER       NNO,NARE
      INTEGER       IMA1,IMA2
      INTEGER       INO
      INTEGER       IAD1,IAD2
      INTEGER       I,J,K,L,L0,P0,P1,P2,Q0,Q1,Q2,N     
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()  
C
C --- LECTURE DES DONNEES
C       
      CALL JELIRA(NGRINV,'NMAXOC',NNO,K8BID)    
      CALL JEVEUO(NGRINV,'L',P1)
      CALL JEVEUO(JEXATR(NGRINV,'LONCUM'),'L',P2)
C
C --- MAJORATION NOMBRE D'ARETES DU GRAPHE MAILLE/MAILLE
C
      NARE = 0
      DO 10 I = 1, NNO
        N = ZI(P2+I)-ZI(P2-1+I)
        IF (N.GT.1) THEN
          IF (DIMVAR.EQ.1) THEN
            NARE = NARE + N*(N-1)
          ELSEIF (DIMVAR.EQ.2) THEN
            NARE = NARE + (N-1)**2
          ELSEIF (DIMVAR.EQ.3) THEN
            NARE = NARE + N*(N-1)/2
          ENDIF
        ENDIF
 10   CONTINUE
C     
C --- ALLOCATION OBJETS TEMPORAIRES
C
      CALL WKVECT('&&GRMAMA.NVOISIN'      ,'V V I',NMA   ,Q0)
      CALL WKVECT('&&GRMAMA.LISTE.ENTETE' ,'V V I',NMA   ,Q1)
      CALL WKVECT('&&GRMAMA.LISTE.RESERVE','V V I',2*NARE,Q2)
C
C --- ECRITURE LISTE
C      
      NARE = 0

      DO 30 I = 1, NNO

        P0 = ZI(P2-1+I)
        N = ZI(P2+I)-P0
        P0 = P0 + P1 - 2
        IF (N.EQ.1) GOTO 30

        DO 40 J = 1, N

          IMA1 = ZI(P0+J)
          L0 = ZI(Q1-1+IMA1)

          DO 40 K = J+1, N

            IMA2 = ZI(P0+K)

            L = L0
 50         CONTINUE
            IF (L.NE.0) THEN
              IF (ZI(L).EQ.IMA2) GOTO 40 
              L = ZI(L+1)
              GOTO 50
            ENDIF

            NARE = NARE + 2

            ZI(Q2) = IMA2
            ZI(Q2+1) = L0
            ZI(Q1-1+IMA1) = Q2
            ZI(Q0-1+IMA1) = ZI(Q0-1+IMA1) + 1
            L0 = Q2
            Q2 = Q2 + 2

            ZI(Q2) = IMA1
            ZI(Q2+1) = ZI(Q1-1+IMA2)
            ZI(Q1-1+IMA2) = Q2
            ZI(Q0-1+IMA2) = ZI(Q0-1+IMA2) + 1
            Q2 = Q2 + 2

 40     CONTINUE

 30   CONTINUE
C
C --- ALLOCATION GRAPHE MAILLE/MAILLE 
C
      CALL JECREC(NGRMM,BASE//' V I','NU','CONTIG','VARIABLE',NMA)
      CALL JEECRA(NGRMM,'LONT',NARE,' ')
C     
C --- COPIE LISTE -> GRAPHE MAILLE/MAILLE
C
      DO 60 I = 1, NMA   
        CALL JECROC(JEXNUM(NGRMM,I))
        CALL JEECRA(JEXNUM(NGRMM,I),'LONMAX',ZI(Q0-1+I),' ')
        CALL JEVEUO(JEXNUM(NGRMM,I),'E',Q2)
        L = ZI(Q1-1+I)
 70     CONTINUE
        ZI(Q2) = ZI(L)
        Q2 = Q2 + 1
        L = ZI(L+1)
        IF (L.NE.0) GOTO 70
        
 60   CONTINUE      
C
C --- DEGRE MAXIMUM DU GRAPHE
C 
      IAD1 = ZI(P2)
      DO 100 INO = 1, NNO
        IAD2 = ZI(P2+INO)
        IF ((IAD2-IAD1).GT.DEGMAX) THEN
          DEGMAX = IAD2 - IAD1
        ENDIF  
        IAD1 = IAD2
 100  CONTINUE 
C                          
C --- DESALLOCATION
C
      CALL JEDETR('&&GRMAMA.NVOISIN')
      CALL JEDETR('&&GRMAMA.LISTE.ENTETE')
      CALL JEDETR('&&GRMAMA.LISTE.RESERVE')
 80   CONTINUE
C
      CALL JEDEMA()
C      
      END
