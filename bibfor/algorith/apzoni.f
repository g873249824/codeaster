      SUBROUTINE APZONI(SDAPPA,IZONE ,QUESTZ,VALI  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/01/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*19  SDAPPA
      INTEGER       IZONE ,VALI 
      CHARACTER*(*) QUESTZ
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C INFO. DE TYPE ENTIER SUR LA ZONE COURANTE
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  IZONE  : NUMERO DE LA ZONE
C IN  QUESTI : QUESTION
C      NBPT             NBRE DE POINTS DE LA ZONE
C      NBNOM            NBRE NOEUDS ATTACHES A LA SURFACE MAITRE
C      NBMAM            NBRE MAILLES ATTACHEES A LA SURFACE MAITRE
C      NBNOE            NBRE NOEUDS ATTACHES A LA SURFACE ESCLAVE
C      NBMAE            NBRE MAILLES ATTACHEES A LA SURFACE ESCLAVE
C      JDECNM           DECALAGE DANS LES VECTEURS POUR LE PREMIER 
C                       NOEUD DE LA SURFACE MAITRE
C      JDECMM           DECALAGE DANS LES VECTEURS POUR LA PREMIERE 
C                       MAILLE DE LA SURFACE MAITRE
C      JDECNE           DECALAGE DANS LES VECTEURS POUR LE PREMIER 
C                       NOEUD DE LA SURFACE ESCLAVE
C      JDECME           DECALAGE DANS LES VECTEURS POUR LA PREMIERE 
C                        MAILLE DE LA SURFACE ESCLAVE
C      JDECIV           DECALAGE POUR TABLEAU DES CONNECTIVITES
C                       INVERSES
C      DIRE_APPA        1 SI APPARIEMENT DE DIRECTION FIXE
C                       0 SINON      
C      TYPE_APPA        0 SI APPARIEMENT NODAL
C                       1 SI APPARIEMENT MAITRE-ESCLAVE
C      TYPE_NORM_MAIT   ORIENTATION BASE LOCALE MAIT.
C                       0 SI AUTO
C                       1 SI FIXE
C                       2 SI VECT_Y
C      TYPE_NORM_ESCL   ORIENTATION BASE LOCALE ESCL.
C                       0 SI AUTO
C                       1 SI FIXE
C                       2 SI VECT_Y
C      CALC_NORM_ESCL   1 SI CALCUL DE LA NORMALE SUR NOEUD ESCLAVE
C                       0 SINON   
C      CALC_NORM_MAIT   1 SI CALCUL DE LA NORMALE SUR NOEUD MAITRE
C                       0 SINON   
C OUT VALI   : REPONSE A LA QUESTION 
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      CHARACTER*24 APINZI
      INTEGER      JPINZI
      CHARACTER*24 QUESTI
      INTEGER      APMMVD,ZINZI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)     
C
C --- ACCES SDAPPA
C
      APINZI = SDAPPA(1:19)//'.INZI'
      CALL JEVEUO(APINZI,'L',JPINZI)
C
C --- INITIALISATIONS
C
      VALI   = 0
      QUESTI = QUESTZ
      ZINZI  = APMMVD('ZINZI')
C
C --- REPONSE
C
      IF (QUESTI.EQ.'NBPT') THEN
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+1 -1)
      ELSEIF (QUESTI.EQ.'NBNOM') THEN
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+2 -1)
      ELSEIF (QUESTI.EQ.'NBNOE') THEN
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+3 -1)
      ELSEIF (QUESTI.EQ.'NBMAM') THEN
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+4 -1)
      ELSEIF (QUESTI.EQ.'NBMAE') THEN
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+5 -1)
      ELSEIF (QUESTI.EQ.'JDECNM') THEN   
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+6 -1)
      ELSEIF (QUESTI.EQ.'JDECMM') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+7 -1)
      ELSEIF (QUESTI.EQ.'JDECNE') THEN   
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+8 -1)
      ELSEIF (QUESTI.EQ.'JDECME') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+9 -1)
C  
      ELSEIF (QUESTI.EQ.'DIRE_APPA') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+10-1)
      ELSEIF (QUESTI.EQ.'TYPE_APPA') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+11-1)        
C
      ELSEIF (QUESTI.EQ.'TYPE_NORM_MAIT') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+12-1)
      ELSEIF (QUESTI.EQ.'TYPE_NORM_ESCL') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+13-1)
C
      ELSEIF (QUESTI.EQ.'CALC_NORM_ESCL') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+14-1)        
      ELSEIF (QUESTI.EQ.'CALC_NORM_MAIT') THEN       
        VALI   = ZI(JPINZI+ZINZI*(IZONE-1)+15-1)          
      ELSE    
        CALL ASSERT(.FALSE.)
      ENDIF                    
C
      CALL JEDEMA()
C 
      END
