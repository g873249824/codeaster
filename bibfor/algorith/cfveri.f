      SUBROUTINE CFVERI(NOMA  ,DEFICO,RESOCO,NEWGEO,SDAPPA,
     &                  NPT   ,JEUX  ,LOCA  ,ENTI  ,ZONE  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMA
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  NEWGEO
      CHARACTER*19  SDAPPA
      CHARACTER*24  JEUX,LOCA,ENTI,ZONE
      INTEGER       NPT
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE VERIF)
C
C METHODE VERIF POUR LA FORMULATION DISCRETE
C      
C ----------------------------------------------------------------------
C
C      
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NEWGEO : GEOMETRIE ACTUALISEE
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  JEUX   : NOM DE LA SD STOCKANT LE JEU
C IN  ENTI   : NOM DE LA SD STOCKANT LES NOMS DES ENTITES APPARIEES
C IN  ZONE   : NOM DE LA SD STOCKANT LA ZONE A LAQUELLE APPARTIENT LE
C              POINT
C IN  LOCA   : NUMERO DU NOEUD POUR LE POINT DE CONTACT (-1 SI LE POINT
C              N'EST PAS UN NOEUD ! )
C IN  NPT    : NOMBRE DE POINTS EN MODE VERIF
C
C
C
C          
      INTEGER      IFM,NIV
      INTEGER      CFDISI,MMINFI
      INTEGER      TYPAPP,ENTAPP
      INTEGER      JDECNE
      INTEGER      POSMAE,NUMMAM,POSNOE,POSMAM,NUMNOE
      INTEGER      POSNOM,NUMNOM
      INTEGER      IZONE,IP,IPTM,INOE,IPT
      INTEGER      NDIMG,NZOCO
      INTEGER      NBPC,NBPT,NPT0
      REAL*8       GEOMP(3),COORPC(3)
      REAL*8       TAU1M(3),TAU2M(3)
      REAL*8       TAU1(3),TAU2(3)
      REAL*8       NORM(3),NOOR
      REAL*8       KSIPR1,KSIPR2
      REAL*8       R8VIDE,R8PREM,R8BID
      REAL*8       JEU,DIST
      CHARACTER*8  NOMNOE,NOMMAM,NOMNOM,K8BLA
      CHARACTER*16 NOMPT,NOMENT
      LOGICAL      MMINFL,LVERI
      INTEGER      JJEUX,JLOCA,JENTI,JZONE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)   
C
C --- INITIALISATIONS
C
      POSNOE = 0    
      IPT    = 1
      K8BLA  = ' '
C
C --- QUELQUES DIMENSIONS
C
      NZOCO  = CFDISI(DEFICO,'NZOCO' )
      NDIMG  = CFDISI(DEFICO,'NDIM'  )
C
C --- ACCES SD PROVISOIRES
C
      CALL JEVEUO(JEUX  ,'E',JJEUX )
      CALL JEVEUO(LOCA  ,'E',JLOCA )
      CALL JEVEUO(ENTI  ,'E',JENTI )
      CALL JEVEUO(ZONE  ,'E',JZONE )  
C
C --- BOUCLE SUR LES ZONES
C      
      IP     = 1
      NPT0   = 0
      DO 10 IZONE = 1,NZOCO
C
C ----- OPTIONS SUR LA ZONE DE CONTACT
C 
        NBPT   = MMINFI(DEFICO,'NBPT'  ,IZONE )
        JDECNE = MMINFI(DEFICO,'JDECNE',IZONE )
C 
C ----- MODE NON-VERIF: ON SAUTE LES POINTS
C  
        LVERI  = MMINFL(DEFICO,'VERIF' ,IZONE )
        IF (.NOT.LVERI) THEN
          NBPC   = MMINFI(DEFICO,'NBPC'  ,IZONE )
          IP     = IP + NBPC
          GOTO 25
        ENDIF
C
C ----- BOUCLE SUR LES NOEUDS DE CONTACT
C
        DO 20 IPTM = 1,NBPT
C
C ------- NOEUD ESCLAVE COURANT
C
          INOE   = IPTM
          POSNOE = JDECNE + INOE
C
C ------- INDICE ABSOLU DANS LE MAILLAGE DU NOEUD
C            
          CALL CFNUMN(DEFICO,1     ,POSNOE,NUMNOE)
C
C ------- NOM DU NOEUD ESCLAVE
C            
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOE),NOMNOE)
C
C ------- INFOS APPARIEMENT
C
          CALL APINFI(SDAPPA,'APPARI_TYPE'     ,IP    ,TYPAPP)
          CALL APINFI(SDAPPA,'APPARI_ENTITE'   ,IP    ,ENTAPP)
          CALL APINFR(SDAPPA,'APPARI_PROJ_KSI1',IP    ,KSIPR1)
          CALL APINFR(SDAPPA,'APPARI_PROJ_KSI2',IP    ,KSIPR2)
          CALL APVECT(SDAPPA,'APPARI_TAU1'     ,IP    ,TAU1M )
          CALL APVECT(SDAPPA,'APPARI_TAU2'     ,IP    ,TAU2M )          
C
C ------- COORDONNEES DU POINT DE CONTACT
C            
          CALL APCOPT(SDAPPA,IP    ,COORPC)
C
C ------- NOM DU POINT DE CONTACT
C 
          CALL MMNPOI(NOMA  ,K8BLA ,NUMNOE,IPTM  ,NOMPT )
C
C ------- TRAITEMENT DE L'APPARIEMENT
C
          IF (TYPAPP.EQ.2) THEN 
C
C --------- MAILLE MAITRE 
C
            POSMAM = ENTAPP
            CALL CFNUMM(DEFICO,1     ,POSMAM,NUMMAM)
C
C --------- NOM DE LA MAILLE MAITRE 
C            
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAM),NOMMAM)
            NOMENT = NOMMAM
C
C --------- COORDONNEES PROJECTION DU NOEUD ESCLAVE SUR LA MAILLE MAITRE
C
            CALL CFCOOR(NOMA  ,DEFICO,NEWGEO,POSMAM,KSIPR1,
     &                  KSIPR2,GEOMP ) 
C          
C --------- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C
            CALL CFTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &                  POSNOE,'MAIL',POSMAM,NUMMAM,KSIPR1,
     &                  KSIPR2,TAU1M ,TAU2M ,TAU1  ,TAU2  ) 
C
C --------- CALCUL DE LA NORMALE INTERIEURE
C
            CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR  )
            IF (NOOR.LE.R8PREM()) THEN
              CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
            ENDIF
C
C --------- CALCUL DU JEU 
C
            CALL CFNEWJ(NDIMG ,COORPC,GEOMP ,NORM  ,JEU   )    
C
C --------- CALCUL DU JEU FICTIF DE LA ZONE
C  
            CALL CFDIST(DEFICO,'DISCRETE',IZONE ,POSNOE,POSMAE,
     &                COORPC,DIST      )
C
C --------- JEU TOTAL
C
            JEU    = JEU+DIST        
          ELSEIF (TYPAPP.EQ.1) THEN
C
C --------- NOEUD MAITRE 
C
            POSNOM = ENTAPP 
            CALL CFNUMN(DEFICO,1     ,POSNOM,NUMNOM)
C
C --------- NOM DU NOEUD MAITRE 
C            
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOM),NOMNOM)
            NOMENT = NOMNOM
C
C --------- COORDONNNEES DU NOEUD MAITRE
C            
            CALL CFCORN(NEWGEO,NUMNOM,GEOMP  )
C          
C --------- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C
            CALL CFTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &                  POSNOE,'NOEU',POSNOM,NUMNOM,R8BID ,
     &                  R8BID ,TAU1M ,TAU2M ,TAU1  ,TAU2  )           
C
C --------- CALCUL DE LA NORMALE INTERIEURE
C
            CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR  )
            IF (NOOR.LE.R8PREM()) THEN
              CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
            ENDIF                             
C
C --------- CALCUL DU JEU 
C
            CALL CFNEWJ(NDIMG ,COORPC,GEOMP ,NORM  ,JEU   )    
C
C --------- CALCUL DU JEU FICTIF DE LA ZONE
C  
            CALL CFDIST(DEFICO,'DISCRETE',IZONE ,POSNOE,POSMAE,
     &                COORPC,DIST      )
C
C --------- JEU TOTAL
C
            JEU    = JEU+DIST
C
          ELSEIF (TYPAPP.EQ.-1) THEN
            NOMENT = 'EXCLU'
            JEU    = R8VIDE()
          ELSEIF (TYPAPP.EQ.-2) THEN
            NOMENT = 'EXCLU'  
            JEU    = R8VIDE()
          ELSEIF (TYPAPP.EQ.-3) THEN
            NOMENT = 'EXCLU'
            JEU    = R8VIDE()
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
C
C ------- SAUVEGARDE
C 
          ZR(JJEUX+IPT-1)           = JEU
          ZI(JLOCA+IPT-1)           = NUMNOE
          ZI(JZONE+IPT-1)           = IZONE
          ZK16(JENTI+2*(IPT-1)+1-1) = NOMPT
          ZK16(JENTI+2*(IPT-1)+2-1) = NOMENT
C
C ------- LIAISON SUIVANTE
C
          IPT    = IPT + 1
          NPT0   = NPT0+ 1
C
C ------- POINT SUIVANT
C
          IP     = IP + 1
C
  20    CONTINUE
  25    CONTINUE
  10  CONTINUE
C
      CALL ASSERT(NPT0.EQ.NPT)
C
      CALL JEDEMA()
      END
