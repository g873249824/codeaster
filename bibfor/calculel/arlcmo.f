      SUBROUTINE ARLCMO(NOMMOR,BASE  ,NN    ,NNC   ,DIME)
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
      CHARACTER*1  BASE
      CHARACTER*16 NOMMOR
      INTEGER      NN,NNC,DIME
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DE LA SD MORSE 
C
C ----------------------------------------------------------------------
C
C
C LA MATRICE MORSE EST UNE MATRICE RECTANGULAIRE 
C DE DIMENSION (NNxDIME)xNNC 
C
C ELLE CONTIENT TROIS OBJETS:
C
C NOMMOR(1:16)//'.DIME' : VECTEUR D'UN ENTIER
C        DIMENSION DE LA MATRICE NODALE (* = 1, 2)
C
C NOMMOR(1:16)//'.INO'  : XC V I NUMERO VARIABLE
C         LISTES TRIEES DES NOEUDS COLONNES MATRICE MORSE
C                 [LIGNE 1] (NO1.1, NO1.2, ...) AVEC NO1.1 < NO1.2 < ...
C                 [LIGNE 2] (NO2.1, NO2.2, ...) AVEC NO2.1 < NO2.2 < ...
C 
C NOMMOR(1:16)//'.VALEUR' : VECTEUR DE REELS
C        VALEURS DE LA MATRICE MORSE
C
C LES LIGNES SONT DECRITES DANS UN AUTRE OBJET: L'OBJET COLLAGE
C (NOMC.INO)
C
C IN  NOMMOR : NOM DE LA SD MORSE
C IN  BASE   : TYPE DE BASE ('V' OU 'G')
C IN  NN     : NOMBRE DE NOEUDS DE LA ZONE PRINCIPALE
C IN  NNC    : NOMBRE DE NOEUDS DE LA ZONE DE COLLAGE
C IN  DIME   : DIMENSION DE L'ESPACE
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
      INTEGER      JMORSE,IBID        
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
C
C --- CREATION VECTEURS JEVEUX
C
      CALL JECREO(NOMMOR(1:16)//'.DIME',BASE//' E I')
      CALL JECREC(NOMMOR(1:16)//'.INO' ,BASE//' V I','NU','CONTIG',
     &            'VARIABLE',NNC)
      CALL JEECRA(NOMMOR(1:16)//'.INO','LONT',NN,' ')
      CALL WKVECT(NOMMOR(1:16)//'.VALE',BASE//' V R',NN*DIME,IBID)
C
C --- QUELQUES INITIALISATIONS ELEMENTAIRES
C
      CALL JEVEUO(NOMMOR(1:16)//'.DIME','E',JMORSE)
      ZI(JMORSE) = DIME
C
      CALL JEDEMA()
      END
