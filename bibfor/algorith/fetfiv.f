      SUBROUTINE FETFIV(NBSD,NBI,VD1,VD2,VDO,MATAS,VSDF,VDDL,
     &                  INFOFE,IREX,IFIV,NBPROC,RANG,K24IRZ,SDFETI)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DU PRODUIT OPERATEUR_FETI * V
C
C      IN   NBSD: IN   : NOMBRE DE SOUS-DOMAINES
C      IN    NBI: IN   : NOMBRE DE NOEUDS D'INTERFACE
C      IN    VD1: VR8  : VECTEUR V DE TAILLE NBI 
C      IN    VD2: VR8  : VECTEUR AUXILIAIRE DE TAILLE NBI
C      OUT   VDO: VR8  : VECTEUR OUTPUT DE TAILLE NBI
C      IN  MATAS: CH19 : NOM DE LA MATR_ASSE GLOBALE
C      IN   VSDF: VIN  : VECTEUR MATR_ASSE.FETF INDIQUANT SI 
C                         SD FLOTTANT
C      IN   VDDL: VIN  : VECTEUR DES NBRES DE DDLS DES SOUS-DOMAINES
C     IN IREX/IFIV: IN: ADRESSE DU VECTEUR AUXILAIRE EVITANT DES APPELS
C                        JEVEUX.
C     IN RANG  : IN  : RANG DU PROCESSEUR
C     IN NBPROC: IN  : NOMBRE DE PROCESSEURS
C     IN K24IRZ : K24 : NOM DE L'OBJET JEVEUX VDO POUR LE PARALLELISME
C     IN SDFETI: CH19 : SD DECRIVANT LE PARTIONNEMENT FETI
C----------------------------------------------------------------------
C TOLE CRP_4
C RESPONSABLE BOITEAU O.BOITEAU
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER      NBSD,NBI,VDDL(NBSD),VSDF(NBSD),IREX,IFIV,RANG,NBPROC
      REAL*8       VD1(NBI),VD2(NBI),VDO(NBI)
      CHARACTER*19 MATAS,SDFETI
      CHARACTER*24 INFOFE,K24IRZ
      
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      
C DECLARATION VARIABLES LOCALES
      INTEGER      IDD,IFETM,NBDDL,IDD1,JXSOL,J,TYPSYM,J1,NIVMPI,ILIMPI,
     &             LMAT,NBMC,IFETP,NBMC1,JXSOL1,IAUXJ,K,LCONL,IFM,IBID,
     &             LCON1
      REAL*8       RBID
      CHARACTER*8  NOMSD
      CHARACTER*19 MATDD
      CHARACTER*24 NOMSDP,SDFETG,K24B
      CHARACTER*32 JEXNUM,JEXNOM
      LOGICAL      LPARA
      INTEGER*4    NBI4
            
C ROUTINE AVEC MOINS DE MONITORING, JEVEUX.. CAR APPELLEE SOUVENT

C INITS DIVERSES
      NBI4=NBI
      IF (NBPROC.EQ.1) THEN
        LPARA=.FALSE.
      ELSE
        LPARA=.TRUE.
      ENDIF
      IF (INFOFE(10:10).EQ.'T') THEN
        NIVMPI=2
      ELSE
        NIVMPI=1
      ENDIF
C ADRESSE JEVEUX OBJET FETI & MPI
      CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
C INIT. NOM OBJET JEVEUX POUR PRODUIT PAR PSEUDO-INVERSE LOCALE      
      NOMSDP=MATAS//'.FETP'
C INIT POUR JENUNO
      SDFETG=SDFETI//'.FETG'
            
C INIT. VECTEUR SOLUTION ET AUX
      DO 10 J=1,NBI
        VDO(J)=0.D0
   10 CONTINUE
         
C OBJET JEVEUX POINTANT SUR LA LISTE DES MATR_ASSE
      IFETM=ZI(IFIV+1)
      IFM=ZI(IFIV)

C MONITORING
      IF (INFOFE(1:1).EQ.'T')
     &  WRITE(IFM,*)'<FETI/FETFIV', RANG,'> CALCUL FI*V'
C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
      DO 40 IDD=1,NBSD
C LE SOUS-DOMAINE IDD EST IL CONCERNE PAR LE PROCESSUS ACTUEL ?
        IF (ZI(ILIMPI+IDD).EQ.1) THEN
          IDD1=IDD-1
        
C MATR_ASSE ASSOCIEE AU SOUS-DOMAINE IDD      
          MATDD=ZK24(IFETM+IDD1)(1:19)
C DESCRIPTEUR DE LA MATRICE DU SOUS-DOMAINE
          K=IFIV+2+IDD1*5     
          LMAT=ZI(K)
C ADRESSE MATDD.CONL SI IL EXISTE       
          LCONL=ZI(K+1)
C NOMBRE DE BLOC DE STOCKAGE DE LA MATRICE KI/ TYPE DE SYMETRIE
          TYPSYM=ZI(LMAT+4)                       
C NBRE DE DDL DU SOUS-DOMAINE IDD       
          NBDDL=VDDL(IDD)
C VECTEUR AUXILIAIRE DE TAILLE NDDL(SOUS_DOMAINE_IDD)     
          JXSOL=ZI(K+3)
                
C EXTRACTION DU VECTEUR V AU SOUS-DOMAINE IDD: (RIDD)T * V
          CALL FETREX(2,IDD,NBI,VD1,NBDDL,ZR(JXSOL),IREX)

C SCALING VIA ALPHA DES COMPOSANTES DU SECOND MEMBRE DUES AUX LAGRANGES
C SYSTEME: K * U= ALPHA * F ---> K * U/ALPHA = F
          IF (LCONL.NE.0) THEN
            LCON1=ZI(K+2)
            DO 15 J=1,NBDDL
              J1=J-1
              ZR(JXSOL+J1)=ZR(LCON1+J1)*ZR(JXSOL+J1)
   15       CONTINUE
          ENDIF
C -------------------------------------------------
C ----  SOUS-DOMAINE NON FLOTTANT
C -------------------------------------------------
C NOMBRES DE MODES DE CORPS RIGIDES DU SOUS-DOMAINE IDD
          NBMC=VSDF(IDD)     
          IF (NBMC.EQ.0) THEN 

C CALCUL DE (KIDD)- * FIDD PAR MULT_FRONT  
            CALL RLTFR8(MATDD,NBDDL,ZR(JXSOL),1,TYPSYM)          

          ELSE
C -------------------------------------------------
C ----  SOUS-DOMAINE FLOTTANT
C -------------------------------------------------
C CALCUL DE (KI)+FI PAR MULT_FRONT 
            CALL RLTFR8(MATDD,NBDDL,ZR(JXSOL),1,TYPSYM)
            CALL JENUNO(JEXNUM(SDFETG,IDD),NOMSD)
            CALL JEVEUO(JEXNOM(NOMSDP,NOMSD),'L',IFETP)
          
            NBMC1=NBMC-1
            JXSOL1=JXSOL-1
            DO 25 J=0,NBMC1
              IAUXJ=ZI(IFETP+J)
              ZR(JXSOL1+IAUXJ)=0.D0   
   25       CONTINUE
            CALL JELIBE(JEXNOM(NOMSDP,NOMSD))
          ENDIF
C SCALING DES COMPOSANTES DE ZR(LXSOL) POUR CONTENIR LA SOL. REELLE U
          IF (LCONL.NE.0) THEN
            DO 30 J=1,NBDDL
              J1=J-1
              ZR(JXSOL+J1)=ZR(LCON1+J1)*ZR(JXSOL+J1)
   30       CONTINUE
          ENDIF

C RESTRICTION DU SOUS-DOMAINE IDD SUR L'INTERFACE: (RIDD) * ...
          CALL FETREX(1,IDD,NBDDL,ZR(JXSOL),NBI,VD2,IREX)  
C CUMUL DANS LE VECTEUR VDO=SOMME(I=1,NBSD)(RI * ((KI)+ * RIT * V))
          CALL DAXPY(NBI4,1.D0,VD2,1,VDO,1)
C FIN DU IF ILIMPI
        ENDIF
   40 CONTINUE
C========================================
C FIN BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
      IF (LPARA) THEN
C REDUCTION DU RESULTAT Z=FI*V POUR LE PROCESSUS MAITRE
        CALL FETMPI(7,NBI,IFM,NIVMPI,IBID,IBID,K24IRZ,K24B,K24B,RBID)
      ENDIF             
      END
