      SUBROUTINE NMCRLI(INSTIN,LISINS,SDDISC,NUMINI,DELMIN,
     &                  NOMCMD)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2008   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      CHARACTER*19 SDDISC,LISINS
      REAL*8       INSTIN,DELMIN
      INTEGER      NUMINI  
      CHARACTER*16 NOMCMD   
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION
C
C ----------------------------------------------------------------------
C
C
C IN  NOMCMD : NOM DE LA COMMANDE APPELANTE (THER, STAT ou DYNA)
C IN  INSTIN : INSTANT INITIAL QUAND ETAT_INIT 
C IN  LISINS : LISTE D'INSTANTS 
C OUT SDDISC : SD DISCRETISATION
C OUT NUMINI : NUMERO DU PREMIER INSTANT DE CALCUL 
C OUT DELMIN : PAS DE TEMPS MINI ENTRE INSTANT DE LA LISTE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      JINST
      INTEGER      NUMFIN,POS
      INTEGER      I
      INTEGER      N1,N2,N3,N4,N5
      INTEGER      NBTEMP,NBINST,NBINTV
      REAL*8       DELTAT,TOLE,INST
      REAL*8       R8BID
      REAL*8       DT,DTMIN,INS
      LOGICAL      LINSTI,LEINIT
      CHARACTER*8  K8BID
      CHARACTER*24 TPSDIT,TPSDIN,TPSBCL
      INTEGER      JTEMPS,JNIVTP,JBCLE
      INTEGER      IFM,NIV 
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
C
C --- AFFICHAGE
C
      IF (NOMCMD(1:4).EQ.'THER') THEN
        CALL INFDBG('THER_NON_LINE',IFM,NIV)
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<THERNONLINE> ... CREATION SD DISCRETISATION'
        ENDIF    
      ELSE
        CALL INFDBG('MECA_NON_LINE',IFM,NIV)
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ... CREATION SD DISCRETISATION'
        ENDIF          
      ENDIF  
C
C --- INITIALISATIONS
C
      LINSTI = .FALSE.
C
C --- NOM SD_DISC
C    
      TPSDIT = SDDISC(1:19)//'.DITR'  
      TPSDIN = SDDISC(1:19)//'.DINI' 
      TPSBCL = SDDISC(1:19)//'.BCLE'     
C
C --- OBJETS NIVEAUX DE BOUCLE
C --- 1 - ITERAT (NEWTON) 
C --- 2 - NUMINS (PAS DE TEMPS)
C --- 3 - NIVEAU (BOUCLE CONTACT/XFEM)
C --- 4 - PREMIE (0 SI TOUT PREMIER, 1 SINON)
C
      CALL WKVECT(TPSBCL,'V V I',4,JBCLE)             
C
C --- LECTURE DE LA LISTE D'INSTANTS
C
      CALL JEVEUO(LISINS(1:19)//'.VALE','L',JINST)
      CALL JELIRA(LISINS(1:19)//'.VALE','LONMAX',NBINST,K8BID)   
C
C --- NOMBRE D'INTERVALLES
C         
      NBINTV = NBINST-1
C
C --- VERIFICATIONS IL Y A AU MOINS UN INSTANT DE CALCUL
C
      IF (NBINST.LT.1) THEN
        CALL U2MESS('F','DISCRETISATION_86')
      ENDIF
C      
C --- VERIFICATION DU CARACTERE CROISSANT DE LA LISTE D'INSTANTS
C
      DO 10 I = 1,NBINTV
        DELTAT = ZR(JINST+I+1-1) - ZR(JINST + I -1)
        IF (DELTAT.LE.0) THEN
          CALL U2MESS('F','DISCRETISATION_87')
        ENDIF
10    CONTINUE
C
C --- INTERVALLE DE TEMPS MINIMAL
C
      DELMIN = ZR(JINST+2-1) - ZR(JINST+1-1)
      DO 11 I = 2,NBINTV
        DELTAT = ZR(JINST+I+1-1) - ZR(JINST + I -1)
        DELMIN = MIN(DELTAT,DELMIN)
11    CONTINUE
C
C --- TOLERANCE POUR RECHERCHE DANS LISTE D'INSTANTS
C
      CALL GETVR8('INCREMENT','PRECISION'     ,1,1,1,TOLE,N1)
      TOLE   = DELMIN * TOLE
C
C --- L'INSTANT DE L'ETAT INITIAL EXISTE-T-IL ?
C
      IF (NOMCMD(1:13).EQ.'STAT_NON_LINE') THEN
        CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,R8BID,N5)
        CALL GETVID('ETAT_INIT','EVOL_NOLI'     ,1,1,1,K8BID,N4)
      ELSEIF (NOMCMD(1:13).EQ.'DYNA_NON_LINE') THEN
        CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,R8BID,N5)
        CALL GETVID('ETAT_INIT','EVOL_NOLI'     ,1,1,1,K8BID,N4)
      ELSEIF (NOMCMD(1:13).EQ.'THER_NON_LINE') THEN
        CALL GETVR8('ETAT_INIT','INST_ETAT_INIT',1,1,1,R8BID,N5)
        CALL GETVID('ETAT_INIT','EVOL_THER'     ,1,1,1,K8BID,N4)
      ELSEIF (NOMCMD(1:13).EQ.'THER_LINEAIRE') THEN
        N5 = 0
        CALL GETVID('ETAT_INIT','EVOL_THER'     ,1,1,1,K8BID,N4)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF  

      LEINIT = .TRUE.
      IF (N5.EQ.0) THEN
        IF (N4.EQ.0) THEN
          LEINIT = .FALSE.
        ENDIF
      ENDIF 
C
C --- DETERMINATION DU NUMERO D'ORDRE INITIAL
C
      CALL GETVIS('INCREMENT','NUME_INST_INIT',1,1,1,NUMINI,N1)
      CALL GETVR8('INCREMENT','INST_INIT'     ,1,1,1,INST  ,N2)
      CALL GETFAC('ETAT_INIT',N3)
C
C --- PAS D'INSTANT INITIAL
C
      IF (.NOT.LEINIT) THEN
        N3     = 0
      ENDIF
C      
C --- PAS D'OCCURENCE DES MOTS-CLES -> NUMERO INITIAL
C
      IF (N1+N2+N3 .EQ. 0) THEN      
        NUMINI = 0
C        
C --- MOTS-CLES INST_INIT OU INSTANT DEFINI PAR ETAT_INIT
C
      ELSE IF (N1 .EQ. 0) THEN
      
        IF (N2 .EQ. 0) THEN
C        
C --- INSTANT DEFINI PAR ETAT_INIT
C          
          INST   = INSTIN
          CALL UTACLI(INST  ,ZR(JINST),NBINTV,TOLE  ,NUMINI)
C
C --- SI INST NON PRESENT DANS LA LISTE D INSTANT
C --- ON CHERCHE L INSTANT LE PLUS PROCHE AVANT L'INSTANT CHERCHE
C
          IF (NUMINI.LT.0) THEN
            LINSTI = .TRUE.
            DTMIN  = INST-ZR(JINST)
            INS    = ZR(JINST)
            DO 40 I=1,NBINTV
              DT     = INST-ZR(JINST+I)
              IF (DT.LE.0.D0) THEN
                GOTO 45
              ENDIF  
              IF (DT.LT.DTMIN) THEN
                DTMIN  = DT
                INS    = ZR(JINST+I)
              ENDIF
 40         CONTINUE
 45         CONTINUE
            INST   = INS
          ENDIF
        ENDIF
C
        CALL UTACLI(INST  ,ZR(JINST),NBINTV,TOLE  ,NUMINI)
        IF (NUMINI .LT. 0) THEN
          CALL U2MESS('F','DISCRETISATION_89')
        ENDIF  
      ENDIF     
C
C --- DETERMINATION DU NUMERO D'ORDRE FINAL
C
      CALL GETVIS('INCREMENT','NUME_INST_FIN',1,1,1,NUMFIN,N1)
      CALL GETVR8('INCREMENT','INST_FIN'     ,1,1,1,INST  ,N2)
C      
C --- PAS D'OCCURENCE DES MOTS-CLES -> NUMERO INITIAL
C
      IF (N1+N2 .EQ. 0) THEN
        NUMFIN = NBINTV
C        
C --- MOTS-CLES INST_FIN
C
      ELSE IF (N1 .EQ. 0) THEN
        CALL UTACLI(INST,ZR(JINST),NBINTV,TOLE,NUMFIN)
        IF (NUMFIN .LT. 0) THEN
          CALL U2MESS('F','DISCRETISATION_90')
        ENDIF  
      ENDIF
C
C --- VERIFICATION SENS DE LA LISTE
C
      IF (NUMINI.GE.NUMFIN) THEN
        CALL U2MESS('F','DISCRETISATION_92')
      ENDIF  
C
C --- VERIFICATION DES BORNES
C
      IF (NUMINI.LT.0 .OR. NUMINI.GT.NBINTV) THEN
        CALL U2MESS('F','DISCRETISATION_93')
      ENDIF  
      IF (NUMFIN.LT.0 .OR. NUMFIN.GT.NBINTV) THEN
        CALL U2MESS('A','DISCRETISATION_94')      
        NUMFIN = NBINTV
      END IF
C
C --- CREATION DE LA LISTE D'INSTANTS
C       
      NBTEMP = (NUMFIN-NUMINI)
      CALL WKVECT(TPSDIT,'V V R8',NBTEMP+1,JTEMPS)
C      
C --- TPSDIN: INDICATEUR DU NIVEAU DE SUBDIVISION
C --- DES PAS DE TEMPS : ON L INITIALISE ICI A 1
C
      CALL WKVECT(TPSDIN,'V V I' ,NBTEMP+1,JNIVTP)
      POS = 0
      DO 20 I = NUMINI, NUMFIN
       ZR(JTEMPS+POS) = ZR(JINST+I)
       ZI(JNIVTP+POS) = 1
       POS = POS+1
 20   CONTINUE
C 
C --- SI L'INSTANT INITIAL N'EXISTAIT PAS DANS LA LISTE D'INSTANTS
C --- ON A PRIS PLUS HAUT L'INSTANT LE PLUS PROCHE PRECEDENT : ICI 
C --- ON MET LA BONNE VALEUR COMME INSTANT INITIAL
C
      IF (LINSTI) THEN
        ZR(JTEMPS) = INSTIN
      ENDIF      
C
      CALL JEDEMA()

      END
