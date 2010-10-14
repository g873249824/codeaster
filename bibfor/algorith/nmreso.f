      SUBROUTINE NMRESO(FONACT,CNDONN,CNPILO,CNCINE,SOLVEU,
     &                  MAPREC,MATASS,DEPSO1,DEPSO2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2010   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT NONE
      INTEGER       FONACT(*)
      CHARACTER*19  MAPREC,MATASS
      CHARACTER*19  SOLVEU,CNDONN,CNPILO
      CHARACTER*19  CNCINE,DEPSO1,DEPSO2
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
C
C RESOLUTION AVEC PILOTAGE  K.U = F0 + ETA.F1
C SUR DDLS PHYSIQUES
C      
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  CNDONN : SECOND MEMBRE DONNE
C IN  CNPILO : SECOND MEMBRE PILOTE
C IN  CNCINE : CHAM_NO DE CHARGE CINEMATIQUE
C IN  SOLVEU : SOLVEUR
C IN  MAPREC : MATRICE DE PRECONDITIONNEMENT (GCPC)
C IN  MATASS : MATRICE ASSEMBLEE
C OUT DEPSO1 : SOLUTION DU DU SYSTEME K.U = F EN L'ABSENCE DE PILOTAGE
C OUT DEPSO2 : SOLUTION DU DU SYSTEME K.U = F AVEC PILOTAGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      ISFONC,LPILO,LFETI
      INTEGER      IFM,NIV
      INTEGER      JCRI,JCRI1
      INTEGER      IRET
      REAL*8       R8BID
      COMPLEX*16   C16BID
      CHARACTER*19 CRGC
      DATA CRGC            /'&&RESGRA_GCPC'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE><RESO> RESOLUTION K.U = F' 
      ENDIF   
C
C --- INITIALISATIONS
C    
      CALL VTZERO(DEPSO1)
      CALL VTZERO(DEPSO2)            
C
C --- FONCTIONNALITES ACTIVEES
C
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LFETI  = ISFONC(FONACT,'FETI')
C
C --- SECOND MEMBRE FIXE
C
      IF (NIV.GE.2) THEN 
        WRITE (IFM,*) '<MECANONLINE><RESO> -> SECOND MEMBRE DONNE'
        CALL NMDEBG('VECT',CNDONN,6)
      ENDIF   
C
C --- SECOND MEMBRE PILOTE
C     
      IF (LPILO) THEN
        IF (NIV.GE.2) THEN 
          WRITE (IFM,*) '<MECANONLINE><RESO> -> SECOND MEMBRE PILOTE'
          CALL NMDEBG('VECT',CNPILO,6)
        ENDIF   
      END IF
C
      IF (NIV.GE.2) THEN 
        WRITE (IFM,*) '<MECANONLINE><RESO> -> MATRICE'
        CALL NMDEBG('MATA',MATASS,6)
      ENDIF
C  
C --- INVERSION DE LA PARTIE FIXE
C
      CALL RESOUD(MATASS,MAPREC,CNDONN,SOLVEU,CNCINE,
     &            'V'   ,DEPSO1,CRGC  ,0     ,R8BID ,
     &            C16BID,.TRUE.)
C  
C --- INVERSION DE LA PARTIE PILOTEE
C         
      IF (LPILO) THEN
        CALL RESOUD(MATASS,MAPREC,CNPILO,SOLVEU,CNCINE,
     &              'V'   ,DEPSO2,CRGC  ,0     ,R8BID ,
     &              C16BID,.TRUE.)      
      END IF
C 
C --- AFFICHAGE DES SOLUTIONS
C     
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE><RESO> -> SOLUTION 1:'
        CALL NMDEBG('VECT',DEPSO1,6)
        IF (LPILO) THEN
        WRITE (IFM,*) '<MECANONLINE><RESO> -> SOLUTION 2:'
          CALL NMDEBG('VECT',DEPSO2,6)     
        ENDIF
      ENDIF   
C
C --- FETI OR NOT ?
C --- SI FETI ON DUPLIQUE L'INFO DU NBRE D'ITERATIONS POUR AFFICHAGE DE
C --- NMCONV. ON NE GARDE PAS L'OBJET GRGC.CRTI CAR CELA PERTURBE LE
C --- REDECOUPAGE AUTOMATIQUE DU PAS DE TEMPS
C
      IF (LFETI) THEN
        CALL JEEXIN('&FETI.CRITER.CRTI',IRET)
        IF (IRET.EQ.0) THEN
          CALL WKVECT('&FETI.CRITER.CRTI','V V I',1,JCRI1)
        ELSE
          CALL JEVEUO('&FETI.CRITER.CRTI','E',JCRI1)
        ENDIF
        CALL JEVEUO(CRGC//'.CRTI','L',JCRI)
        ZI(JCRI1) = ZI(JCRI)
      ENDIF
C      
      CALL JEDETR(CRGC//'.CRTI' )
      CALL JEDETR(CRGC//'.CRTR' )
      CALL JEDETR(CRGC//'.CRDE' )
C      

      CALL JEDEMA()
      END
