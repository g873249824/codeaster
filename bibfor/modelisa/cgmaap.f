      SUBROUTINE CGMAAP ( MOFAZ, IOCC, NOMAZ, LISMAZ, NBMA )
      IMPLICIT   NONE
      INTEGER             IOCC, NBMA
      CHARACTER*(*)       MOFAZ, NOMAZ, LISMAZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/06/2009   AUTEUR REZETTE C.REZETTE 
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
C
C       CGMAAP -- TRAITEMENT DE L'OPTION 'APPUI'
C                 DU MOT FACTEUR CREA_GROUP_MA DE
C                 LA COMMANDE DEFI_GROUP
C
C -------------------------------------------------------
C  MOFAZ         - IN    - K16  - : MOT FACTEUR 'CREA_GROUP_MA'
C  IOCC          - IN    - I    - : NUMERO D'OCCURENCE DU MOT-FACTEUR
C  NOMAZ         - IN    - K8   - : NOM DU MAILLAGE
C  LISMAZ        - JXVAR - K24  - : NOM DE LA LISTE DE MAILLES OBTENUES
C                                   SUIVANT LE TYPE D'APPUI 
C                                   (VOIR CI-DESSOUS)
C  NBMA          - OUT   -  I   - : LONGUEUR DE CETTE LISTE
C -------------------------------------------------------
C
C    TYPE D'APPUI:
C      - 'AU_MOINS_UN': LES MAILLES DU GROUPE PRODUIT PAR CET OPERATEUR
C              ONT LA PARTICULARITÉ D'AVOIR AU MOINS UN DE LEURS NOEUDS 
C              DANS LA LISTE DES NOEUDS FOURNIS PAR CET OPÉRATEUR.
C      - 'TOUT' : lES MAILLES DU GROUPE PRODUIT PAR CET OPERATEUR ONT LA
C              PARTICULARITÉ D'AVOIR TOUS LEURS NOEUDS DANS LA LISTE DES
C              NOEUDS FOURNIS PAR CET OPÉRATEUR.
C      - 'SOMMET' : LES MAILLES DU GROUPE PRODUIT PAR CET OPERATEUR
C              ONT LA PARTICULARITE D'AVOIR TOUS LEURS NOEUDS SOMMETS
C              DANS LA LISTE DES NOEUDS FOURNIS PAR CET OPÉRATEUR.
C 
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNOM, JEXNUM, JEXATR
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER        NBMALA, I, J, JMALA, JCO, IACNX, ILCNX, II, NBMC
      INTEGER        JNOEU,NBNO,NNO, JJ, INDIIS, JLMAS, IDLIST, IMA, N1
      INTEGER        ITYP, JNNMA, DIME, IBID, IRET
      CHARACTER*8    NOMA, K8BID, MOTCLE(2), TYMOCL(2),TYPMA
      CHARACTER*16   MOTFAC,TYPAPP
      CHARACTER*24   LISTRV,LISMAI,MESNOE,LISMAS,LNNMA
      
C     -----------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS :
C     ================
      NBMALA=0
      MOTFAC    = MOFAZ
      NOMA      = NOMAZ
      LISMAI    = LISMAZ
      LISTRV    = '&&CGMAAS.MAILLES_LACHE'
      MESNOE    = '&&CGMAAL.NOEUDS'
      LISMAS    = '&&CGMAAS.MAILLES_STRICT'
      LNNMA     = '&&CGMAAL.NBNO_MA'

C --  ON RECUPERE LES MAILLES DU TYPE D'APPUI 'AU_MOINS_UN'
C     (COMMMUN A TOUT TYPE D'APPUION)
      CALL CGMAAL(MOTFAC, IOCC, NOMA, LISTRV, NBMALA)
C
C --  RECUPERATION DU TYPE D'APPUI :
      CALL GETVTX('CREA_GROUP_MA','TYPE_APPUI',IOCC,1,1,TYPAPP,N1)
      CALL JEVEUO(LISTRV,'L',JMALA)
C
C --- TYPE D'APPUI = 'AU_MOINS_UN'
C     ============================
      IF(TYPAPP(1:11).EQ.'AU_MOINS_UN')THEN
         NBMA=NBMALA
         JLMAS=JMALA
         GOTO 333
      ELSE
        CALL WKVECT(LISMAS,'V V I',NBMALA,JLMAS)
      ENDIF
C
C --- TYPE D'APPUI = 'TOUT' ET 'SOMMET'
C     ======================================
C 
C --  RECUPERATIONS DES NOEUDS FOURNIS PAR L'UTILISATEUR
C     --------------------------------------------------
      NBMC = 2
      MOTCLE(1) = 'NOEUD'
      TYMOCL(1) = 'NOEUD'
      MOTCLE(2) = 'GROUP_NO'
      TYMOCL(2) = 'GROUP_NO'
      CALL RELIEM ( ' ', NOMA, 'NU_NOEUD', MOTFAC, IOCC, NBMC, MOTCLE,
     &                                          TYMOCL, MESNOE, NBNO )
      CALL JEVEUO ( MESNOE, 'L', JNOEU )
C
C --  ON DETERMINE LE NOMBRE DE NOEUDS 'SOMMET' POUR CHAQUE MAILLE
C     A CONSIDERER (CELLES DU TYPE D'APPUI 'AU_MOINS_UN')
C     ---------------------------------------------------
      CALL JEVEUO(NOMA//'.CONNEX','L',IACNX)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',ILCNX)
      CALL WKVECT(LNNMA,'V V I',NBMALA,JNNMA)

C  -  SI LE TYPE D'APPUI EST 'SOMMET' : 
      IF(TYPAPP(1:6).EQ.'SOMMET')THEN
        CALL JEVEUO ( NOMA//'.TYPMAIL', 'L', ITYP )
        DIME = 3
        CALL DISMOI('F','Z_CST',NOMA,'MAILLAGE',IBID,K8BID,IRET)
        IF ( K8BID(1:3) .EQ. 'OUI' )  DIME = 2

        DO 10 I=1,NBMALA
          IMA=ZI(JMALA+I-1)
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(ITYP+IMA-1)),TYPMA)

           IF ( DIME .EQ. 2 ) THEN
               IF (TYPMA(1:4).EQ.'QUAD' )THEN
                  ZI(JNNMA+I-1)=4
               ELSE IF (TYPMA(1:4).EQ.'TRIA' )THEN
                  ZI(JNNMA+I-1)=3
               ENDIF
            ELSE
               IF (TYPMA(1:5).EQ.'TETRA')THEN
                   ZI(JNNMA+I-1)=4
               ELSE IF(TYPMA(1:5).EQ.'PENTA')THEN
                   ZI(JNNMA+I-1)=6
               ELSE IF(TYPMA(1:5).EQ.'PYRAM')THEN
                   ZI(JNNMA+I-1)=5
               ELSE IF(TYPMA(1:4).EQ.'HEXA' )THEN
                   ZI(JNNMA+I-1)=8
               ENDIF
           ENDIF
 10     CONTINUE

C  -  SI LE TYPE D'APPUI EST 'TOUT' : 
      ELSEIF(TYPAPP(1:4).EQ.'TOUT')THEN
        DO 20 I=1,NBMALA
          IMA=ZI(JMALA+I-1)
          ZI(JNNMA+I-1)=ZI(ILCNX+IMA)-ZI(ILCNX+IMA-1)
 20     CONTINUE
      ENDIF
C
C --  ON FILTRE LES MAILLES SUIVANT LES CRITERES RELATIFS 
C     A CHAQUE TYPE D'APPUI:
C     -------------------
      NBMA=0
      DO 30 I=1,NBMALA
         IMA=ZI(JMALA+I-1)
         JCO=IACNX+ZI(ILCNX+IMA-1)-1
         NNO=ZI(JNNMA+I-1)
         II=0
         DO 40 J=1,NNO
           JJ=INDIIS(ZI(JNOEU),ZI(JCO+J-1),1,NBNO)
           IF(JJ.GT.0) II=II+1
 40      CONTINUE
         
         IF(II.EQ.NNO)THEN
           NBMA=NBMA+1
           ZI(JLMAS+NBMA-1)=IMA 
         ENDIF
 30    CONTINUE        
C
C --- CREATION ET REMPLISSAGE DU VECTEUR DE SORTIE
C     --------------------------------------------
 333  CONTINUE
      CALL WKVECT ( LISMAI, 'V V I', NBMA, IDLIST )
      DO 50 I = 1 , NBMA
         ZI(IDLIST+I-1) = ZI(JLMAS+I-1)
 50   CONTINUE
C
C --- FIN
C     ===
      CALL JEDETR ( LISTRV )
      CALL JEDETR ( LISMAS )
      CALL JEDETR ( MESNOE )
      CALL JEDETR ( LNNMA  )
C
      CALL JEDEMA()
C
      END
