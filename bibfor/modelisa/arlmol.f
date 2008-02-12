      SUBROUTINE ARLMOL(MAIL  ,NOMO  ,NDIM  ,MAILAR,MODARL,
     &                  TABCOR)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  MAILAR,MODARL
      CHARACTER*8  MAIL,NOMO      
      INTEGER      NDIM   
      CHARACTER*24 TABCOR     
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DU LIGREL DU PSEUDO-MODELE  
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  MAILAR : NOM DU PSEUDO-MAILLAGE
C IN  NDIM   : NDIMNSION DU PROBLEME
C IN  TABCOR : TABLEAU DE CORRESPONDANCE 
C            POUR CHAQUE NOUVEAU NUMERO ABSOLU DANS MAILAR 
C             -> ANCIEN NUMERO ABSOLU DANS MAIL
C             -> SI NEGATIF, LA NOUVELLE MAILLE EST ISSUE D'UNE
C                DECOUPE DE LA MAILLE DE NUMERO ABSOLU ABS(NUM) DANS
C                MAIL
C IN  MODARL : NOM DU PSEUDO-MODELE
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM
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
      INTEGER      IMA,NBMA,IBID    
      INTEGER      JNBNO,JAD,JLGRF,JDIME,JTYEL,JTABCO
      CHARACTER*8  K8BID
      INTEGER      IFM,NIV
      CHARACTER*19 LIGRMO
      INTEGER      NUMORI,ITYEL2
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> *** CREATION DU LIGREL DU '//
     &                'PSEUDO-MODELE...'   
      ENDIF
C
C --- INITIALISATIONS
C
      LIGRMO = MODARL(1:8)//'.MODELE'      
C
C --- DESTRUCTION DU LIGREL S'IL EXISTE
C
      CALL DETRSD('LIGREL',LIGRMO)
C
C --- INFO SUR LE MODELE ORIGINAL
C
      CALL JEVEUO(NOMO(1:8)//'.MAILLE','L',JTYEL)
C
C --- ACCES AU TABLEAU DE CORRESPONDANCE
C   
      CALL JEVEUO(TABCOR,'L',JTABCO)        
C
C --- INFO SUR LE MAILLAGE
C     
      CALL JEVEUO(MAILAR(1:8)//'.DIME','L',JDIME)
      NBMA = ZI(JDIME - 1 + 3)
C
C --- CREATION DE .NOMA + ATTRIBUT DOCU
C
      CALL WKVECT(LIGRMO//'.LGRF','V V K8',1,JLGRF)
      ZK8(JLGRF-1+1) = MAILAR
      CALL JEECRA(LIGRMO//'.LGRF','DOCU',IBID,'MECA')
C
C --- CREATION DE L'OBJET .LIEL: ON LE CREE AU MAX. AUTANT DE LIEL
C --- QUE DE MAILLES
C
      CALL JECREC(LIGRMO//'.LIEL','V V I','NU','CONTIG','VARIABLE',
     &            NBMA)
      CALL JEECRA(LIGRMO//'.LIEL','LONT',2*NBMA,K8BID)
C      
      DO 90 IMA = 1,NBMA   
C
C --- CREATION OBJET DE LA COLLECTION
C        
        CALL JECROC(JEXNUM(LIGRMO//'.LIEL',IMA))
        CALL JEECRA(JEXNUM(LIGRMO//'.LIEL',IMA),'LONMAX',2,K8BID)
        CALL JEVEUO(JEXNUM(LIGRMO//'.LIEL',IMA),'E',JAD)
C
C --- NUMERO DANS LE MAILLAGE ORIGINAL
C
        NUMORI = ZI(JTABCO+IMA-1)
C
C --- TYPE DE LA MAILLE DANS LE PSEUDO-MODELE
C
        CALL ARLTMM(JTYEL  ,NUMORI,ITYEL2)
C
C --- PAS D'EF AFFECTE SUR LA MAILLE !
C        
        IF (ITYEL2.EQ.0) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          ZI(JAD  ) = IMA
          ZI(JAD+1) = ITYEL2
        ENDIF  
   90 CONTINUE 
C
C --- ADAPTATION DE .LIEL
C
      CALL ADALIG(LIGRMO)
C
C --- PAS DE NOEUDS TARDIFS
C
      CALL WKVECT(LIGRMO//'.NBNO','V V I',1,JNBNO)
      ZI(JNBNO-1+1) = 0
C
C --- CREATION DE L'OBJET .REPE
C
      CALL CORMGI('V',LIGRMO)
C
C --- INITIALISATION DU LIGREL (OBJETS PRNM/PRNS)
C
      CALL INITEL(LIGRMO)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
C       CALL UTIMSD(IFM,2,.TRUE.,.TRUE.,LIGRMO,1,'V')
        WRITE(IFM,*) '<ARLEQUIN> *** FIN DE CREATION DU LIGREL DU '//
     &                'PSEUDO-MODELE...'   
      ENDIF  
C
      CALL JEDETR(TABCOR)                   
C
      CALL JEDEMA()

      END
