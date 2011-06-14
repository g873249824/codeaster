      SUBROUTINE NMRESI(MAILLA,MATE  ,NUMEDD,FONACT,SDDYNA,
     &                  SDIMPR,MATASS,NUMINS,CONV  ,RESIGR,
     &                  ETA   ,COMREF,VALINC,VEASSE,MEASSE,
     &                  VRELA ,VMAXI ,VCHAR ,VRESI ,VREFE ,
     &                  VINIT ,VCMP  ) 
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/06/2011   AUTEUR TARDIEU N.TARDIEU 
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
C TOLE CRP_21
C
      IMPLICIT      NONE
      CHARACTER*8   MAILLA
      CHARACTER*24  NUMEDD,SDIMPR, MATE
      INTEGER       NUMINS
      CHARACTER*19  SDDYNA
      CHARACTER*19  MEASSE(*),VEASSE(*)
      CHARACTER*19  VALINC(*)
      CHARACTER*19  MATASS
      CHARACTER*24  COMREF
      INTEGER       FONACT(*)
      REAL*8        ETA,CONV(*),RESIGR
      REAL*8        VRELA,VMAXI,VCHAR,VRESI,VREFE,VINIT,VCMP
      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C CALCULS DES RESIDUS D'EQUILIBRE ET DES CHARGEMENTS POUR
C ESTIMATION DE LA CONVERGENCE
C
C ----------------------------------------------------------------------
C
C
C IN  MAILLA : NOM DU MAILLAGE
C IN  SDIMPR : SD AFFICHAGE
C IN  NUMEDD : NUMEROTATION NUME_DDL
C IN  COMREF : VARI_COM REFE
C IN  MATASS : MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  NUMINS : NUMERO D'INSTANT
C IN  RESIGR : RESI_GLOB_RELA
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  ETA    : COEFFICIENT DE PILOTAGE
C OUT CONV   : INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C                20 - RESI_GLOB_RELA
C                21 - RESI_GLOB_MAXI
C OUT VRELA  : RESI_GLOB_RELA MAXI
C OUT VMAXI  : RESI_GLOB_MAXI MAXI
C OUT VCHAR  : CHARGEMENT EXTERIEUR MAXI
C OUT VRESI  : RESIDU EQUILIBRE MAXI
C OUT VREFE  : RESI_GLOB_REFE MAXI
C OUT VINIT  : CONTRAINTES INITIALES MAXI
C OUT VCMP  : RESI_COMP_RELA MAXI
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
      INTEGER      JCCID,JFINT,JDIRI,JFEXT,JVCFO,JREFE,JINER,JVCF1
      INTEGER      IFM,NIV,NIVMPI,NOCC
      INTEGER      NEQ
      CHARACTER*8  K8BID,NODDLM
      LOGICAL      LFETI,LDYNA,NDYNLO,LFETIP,LSTAT,LCINE
      CHARACTER*19 PROFCH,FOINER
      CHARACTER*24 K24BID
      CHARACTER*19 COMMOI,DEPMOI
      CHARACTER*24 CNFETI
      CHARACTER*19 CNDIRI,CNBUDI,CNVCFO,CNFEXT,CNVCF1,CNREFE,CNFINT
      CHARACTER*19 CNFNOD,CNDIPI,CNDFDO
      INTEGER      JDEEQ,JFNOD,JBUDI,JDFDO,JDIPI
      INTEGER      IBID,IER,I,IRET
      LOGICAL      ISFONC,LREFE,LINIT,LCMP
      REAL*8       VAL1,VAL4,VAL5,R8BID
      REAL*8       MAXRES
      INTEGER      IRELA,IMAXI,IRESI,IREFE,ICHAR,INODA
      LOGICAL      LNDEPL,NMIGNO,LPILO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV) 
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CALCUL DES RESIDUS'
      ENDIF           
C
C --- INITIALISATIONS
C
      VRELA  = 0.D0
      VMAXI  = 0.D0
      VREFE  = 0.D0
      VCHAR  = 0.D0
      VRESI  = 0.D0
      VCMP   = 0.D0
      VINIT  = 0.D0
      IRELA  = 0
      IMAXI  = 0
      IREFE  = 0
      IRESI  = 0
      ICHAR  = 0
      JCCID  = 0
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LSTAT  = NDYNLO(SDDYNA,'STATIQUE')
      LREFE  = ISFONC(FONACT,'RESI_REFE')
      LCMP   = ISFONC(FONACT,'RESI_COMP')
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LCINE  = ISFONC(FONACT,'DIRI_CINE')
      CALL GETFAC('ETAT_INIT',NOCC)
      LINIT  = (NUMINS.EQ.1).AND.(NOCC.EQ.0)  
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI)
      CALL NMCHEX(VALINC,'VALINC','COMMOI',COMMOI)      
      CALL NMCHEX(VEASSE,'VEASSE','CNDIRI',CNDIRI)
      CALL NMCHEX(VEASSE,'VEASSE','CNBUDI',CNBUDI)      
      CALL NMCHEX(VEASSE,'VEASSE','CNVCF0',CNVCFO)     
      CALL NMCHEX(VEASSE,'VEASSE','CNVCF1',CNVCF1)      
      CALL NMCHEX(VEASSE,'VEASSE','CNREFE',CNREFE)      
      CALL NMCHEX(VEASSE,'VEASSE','CNFNOD',CNFNOD)
      CALL NMCHEX(VEASSE,'VEASSE','CNDIPI',CNDIPI)
      CNDFDO = '&&CNCHAR.DFDO'   
      
C
C --- CALCUL DE LA FORCE DE REFERENCE POUR LA DYNAMIQUE
C
      IF (LDYNA) THEN
        FOINER = '&&CNPART.CHP1'
        CALL NDINER(NUMEDD,SDDYNA,VALINC,MEASSE,FOINER)
      ENDIF   
C
C --- TYPE DE FORMULATION
C
      LNDEPL = .NOT.(NDYNLO(SDDYNA,'FORMUL_DEPL').OR.LSTAT)
C
C --- RESULTANTE DES EFFORTS POUR ESTIMATION DE L'EQUILIBRE
C
      CALL NMEQUI(ETA   ,FONACT,SDDYNA,FOINER,VEASSE,
     &            CNFEXT,CNFINT)  
C
C --- POINTEUR SUR LES DDLS ELIMINES PAR AFFE_CHAR_CINE
C 
      IF (LCINE) THEN 
        CALL NMPCIN(MATASS)
        CALL JEVEUO(MATASS(1:19)//'.CCID','L',JCCID)
      ENDIF  
C
C --- ACCES NUMEROTATION DUALISATION DES EQUATIONS
C      
      CALL DISMOI('F','PROF_CHNO',DEPMOI,'CHAM_NO',IBID,PROFCH,IER)
      CALL JEVEUO(PROFCH(1:19)//'.DEEQ','L',JDEEQ)       
C      
C --- PREPARATION FETI
C
      CALL NMFETI(NUMEDD,IFM   ,LFETI ,NIVMPI,LFETIP)
C
C --- SI FETI PARALLELE, ON COMMUNIQUE A CHAQUE PROC LA SOMME DES
C --- CHAM_NOS GLOBAUX PARTIELLEMENT CALCULES
C --- A OPTIMISER VIA UN DES CRITERES LOCAUX
C
      IF (LFETIP) THEN
        CNFETI = CNDIRI(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,CNFETI,CNFETI,R8BID )
        CNFETI = CNBUDI(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,CNFETI,CNFETI,R8BID )
        CNFETI = CNFINT(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,K24BID,K24BID,R8BID )
        CNFETI = CNFEXT(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,K24BID,K24BID,R8BID )
        CNFETI = CNVCFO(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,K24BID,K24BID,R8BID)
        CNFETI = CNDFDO(1:19)//'.VALE'
        CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &              IBID  ,CNFETI,K24BID,K24BID,R8BID)
        IF (LDYNA) THEN
          CNFETI = FOINER(1:19)//'.VALE'
          CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &                IBID  ,CNFETI,K24BID,K24BID,R8BID)
        ENDIF
        IF (LINIT) THEN
          CNFETI = CNVCF1(1:19)//'.VALE'
          CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &                IBID  ,CNFETI,K24BID,K24BID,R8BID)
        ENDIF
        IF (LREFE) THEN
          CNFETI = CNREFE(1:19)//'.VALE'
          CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &                IBID  ,CNFETI,K24BID,K24BID,R8BID)
        ENDIF
        IF (LCINE) THEN
          CNFETI = CNFNOD(1:19)//'.VALE'
          CALL FETMPI(71    ,NEQ   ,IFM   ,NIVMPI,IBID  ,
     &                IBID  ,CNFETI,K24BID,K24BID,R8BID)
        ENDIF       
      ENDIF
C
C --- CALCULE LE MAX DES RESIDUS PAR CMP POUR LE RESIDU RESI_COMP_RELA
C
      IF (LCMP) THEN
        CALL RESCMP(CNDIRI,CNVCFO,CNFEXT,CNFINT,CNFNOD,
     &              MAXRES,NODDLM,INODA )
      ENDIF
C
C --- ACCES AUX CHAM_NO
C
      CALL JEVEUO(CNFINT(1:19)//'.VALE','L',JFINT )
      CALL JEVEUO(CNDIRI(1:19)//'.VALE','L',JDIRI )
      CALL JEVEUO(CNFEXT(1:19)//'.VALE','L',JFEXT )
      CALL JEVEUO(CNVCFO(1:19)//'.VALE','L',JVCFO ) 
      CALL JEVEUO(CNBUDI(1:19)//'.VALE','L',JBUDI )
      CALL JEVEUO(CNDFDO(1:19)//'.VALE','L',JDFDO )
      IF (LPILO) THEN
        CALL JEVEUO(CNDIPI(1:19)//'.VALE','L',JDIPI )
      ENDIF  
      IF (LDYNA) THEN
        CALL JEVEUO(FOINER(1:19)//'.VALE','L',JINER )
      ENDIF  
      IF (LINIT) THEN
        CALL JEVEUO(CNVCF1(1:19)//'.VALE','L',JVCF1 )
      ENDIF
      IF (LREFE) THEN
        CALL JEVEUO(CNREFE(1:19)//'.VALE','L',JREFE )
      ENDIF       
      IF (LCINE) THEN
        CALL JEVEUO(CNFNOD(1:19)//'.VALE','L',JFNOD )
      ENDIF
C
C --- CALCUL DES FORCES POUR MISE A L'ECHELLE (DENOMINATEUR)
C
      CALL NMREDE(NUMEDD,FONACT,SDDYNA,MATASS,VEASSE,
     &            NEQ   ,FOINER,CNFEXT,CNFINT,VCHAR ,
     &            ICHAR ) 
C
C --- CALCUL DES RESIDUS
C
      DO 20 I = 1,NEQ
C
C --- SI SCHEMA NON EN DEPLACEMENT: ON IGNORE LA VALEUR DU RESIDU
C
        IF (NMIGNO(JDIRI ,LNDEPL,I   ) ) THEN
          GOTO 20
        ENDIF
C
        IF (LCINE) THEN
          IF (ZI(JCCID+I-1).EQ.1) THEN
            GOTO 20
          ENDIF
        ENDIF   
C
C --- CALCUL DU RESIDU A PROPREMENT PARLER 
C
        IF (LPILO) THEN
          VAL1  = ABS(ZR(JFINT+I-1)+ZR(JDIRI+I-1)+ZR(JBUDI+I-1)
     &           -ZR(JFEXT+I-1)-ZR(JDFDO+I-1)-ETA*ZR(JDIPI+I-1))
        ELSE
          VAL1  = ABS(ZR(JFINT+I-1)+ZR(JDIRI+I-1)+ZR(JBUDI+I-1)
     &           -ZR(JFEXT+I-1)-ZR(JDFDO+I-1)                  ) 
        ENDIF   
C
C --- VRESI: MAX RESIDU D'EQUILIBRE
C
        IF (VRESI.LE.VAL1) THEN
          VRESI = VAL1
          IRESI = I
        ENDIF
C
C --- SI CONVERGENCE EN CONTRAINTE ACTIVE
C
        IF (LREFE) THEN
          IF (ZI(JDEEQ-1 + 2*I).GT.0) THEN          
            VAL4  = ABS(ZR(JFINT+I-1)+ZR(JDIRI+I-1)+ZR(JBUDI+I-1)
     &                -ZR(JFEXT+I-1)-ZR(JDFDO+I-1))/ZR(JREFE+I-1)
            IF (VREFE.LE.VAL4) THEN
               VREFE = VAL4
               IREFE = I
            ENDIF
          ENDIF
        ENDIF
C
C --- SI TEST CONTRAINTES INITIALES
C
        IF (LINIT) THEN
          VAL5 = ABS(ZR(JVCF1+I-1))
          IF (VINIT.LE.VAL5) THEN
            VINIT = VAL5
          ENDIF
        ENDIF

 20   CONTINUE
C
C --- SYNTHESE DES RESULTATS
C
      VMAXI = VRESI
      IMAXI = IRESI
      IF (VCHAR.GT.0.D0) THEN
        VRELA = VRESI/VCHAR
        IRELA = IRESI
      ELSE
        VRELA = -1.D0
      END IF
C       
      IF (LCMP) THEN
         VCMP = MAXRES
      ENDIF
C
C --- ECRITURE DES INFOS SUR LES RESIDUS POUR AFFICHAGE
C
      CALL NMIMRE(NUMEDD,SDIMPR,IRELA ,IMAXI ,IREFE ,
     &            VRELA ,VMAXI ,VREFE,VCMP, NODDLM,INODA)  
C
C --- SAUVEGARDES RESIDUS
C
      CONV(20) = VRELA
      CONV(21) = VMAXI      
C
C --- VERIFICATION QUE LES VARIABLES DE COMMANDE INITIALES CONDUISENT
C --- A DES FORCES NODALES NULLES
C
      IF (LINIT) THEN
        IF (VCHAR.GT.RESIGR) THEN
          VINIT = VINIT/VCHAR
        ENDIF
        IF (VINIT.GT.RESIGR) THEN
          CALL NMVCMX(MATE  ,MAILLA,COMREF,COMMOI)
        ENDIF
      ENDIF    
C
      CALL JEDEMA()
      END
