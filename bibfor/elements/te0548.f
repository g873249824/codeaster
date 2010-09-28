      SUBROUTINE TE0548(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/09/2010   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C.......................................................................
C
C                CONTACT X-FEM METHODE CONTINUE : 
C             MISE A JOUR DU SEUIL DE FROTTEMENT
C             MISE A JOUR DE LA COHESION DANS LE CAS COHESIF
C
C
C  OPTION : 'XREACL' (X-FEM MISE � JOUR DU SEUIL DE FROTTEMENT)

C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR 
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      INTEGER      I,J,K,IFA,IPGF,ISSPG,NI,PLI
      INTEGER      IDEPPL,JAINT,JCFACE,JLONCH,JSEUIL,IPOIDF,IVFF,IDFDEF
      INTEGER      IADZI,IAZK24,IPOIDS,IVF,IDFDE,JGANO,JDONCO
      INTEGER      NDIM,NNO,NNOS,NPG,NFH,DDLC,NNOM,INTEG,NINTER,NFE
      INTEGER      NFACE,CFACE(5,3),IBID,NNOF,NPGF,XOULA,JPTINT
      CHARACTER*8  ELREF,TYPMA,FPG,ELC,LAG,ELREFC
      REAL*8       SEUIL,FFI,E,G(3),RBID,FFP(27),FFC(8),ND(3)
      REAL*8       FFPC(27),DFBID(27,3),R3BID(3),R2BID(2)
      INTEGER      DDLS,NDDL,NNOL,LACT(8),NLACT,IGEOM,DDLM
      INTEGER      IER,NCONTA
      LOGICAL      MALIN,ISMALI

      REAL*8       SAUT(3),LST,R,RR
      REAL*8       BETA,GC,SIGMC,BETASQ,ALPHA0,DTANG(3),DNOR(3)
      REAL*8       DEPEQI,SQRNOR,SQRTAN,P(3,3),PP(3,3)
      CHARACTER*2  CODRET(3)
      CHARACTER*8  NOMRES(3)
      CHARACTER*16 ENR
      REAL*8       VALRES(3),PENADH,RELA,COHES
      INTEGER      IMATE,SINGU,JCOHES,JCOHEO,AR(12,3),NBAR,JLST,JBASEC
      INTEGER      NPTF

C......................................................................

      CALL JEMARQ()

      CALL ELREF1(ELREF)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,SINGU,DDLC,NNOM,DDLS,NDDL,DDLM,IBID)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

C------------RECUPERATION DU TYPE DE CONTACT----------------------------
C
      NCONTA=0
      CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
      IF (IBID.EQ.0.AND.LAG.EQ.'NOEUD') THEN
        MALIN=.TRUE.
        IF(ISMALI(ELREF))      NCONTA=1
        IF(.NOT.ISMALI(ELREF)) NCONTA=3
      ELSE
        MALIN=.FALSE.
      ENDIF
      CALL ELELIN(NCONTA,ELREF,ELREFC,IBID,IBID)
C
C ----------------------------------------------------------------------

C     DEP ACTUEL (DEPPLU) : 'PDEPL_P'
      CALL JEVECH('PDEPL_P','L',IDEPPL)
      CALL JEVECH('PDONCO','L',JDONCO)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE' ,'L',JCFACE)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PSEUIL' ,'E',JSEUIL)
      CALL JEVECH('PBASECO','L',JBASEC)

      CALL TEATTR(NOMTE,'S','XFEM',ENR,IBID)          
      IF (ENR.EQ.'XHC') THEN
        RELA =  ZR(JDONCO-1+10)
      ELSE
        RELA=0.0D0
      ENDIF
      IF(RELA.EQ.1.D0) THEN
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PCOHES' ,'L',JCOHES)
        CALL JEVECH('PCOHESO' ,'E',JCOHEO)
        CALL JEVECH('PLST','L',JLST)
      ENDIF

C     RECUPERATIONS DES DONNEES SUR LE CONTACT ET
C     SUR LA TOPOLOGIE DES FACETTES
      NINTER=ZI(JLONCH-1+1)
      NFACE=ZI(JLONCH-1+2)
      NPTF=ZI(JLONCH-1+3)

      DO 15 I=1,NFACE
        DO 16 J=1,NPTF
          CFACE(I,J)=ZI(JCFACE-1+NPTF*(I-1)+J)
   16   CONTINUE
 15   CONTINUE
C
C     SCHEMA D'INTEGRATION NUMERIQUE ET ELEMENT DE REFERENCE DE CONTACT
      INTEG = NINT(ZR(JDONCO-1+4))
      IF (NDIM .EQ. 3) THEN
        IF (INTEG.EQ.1) FPG='NOEU'
        IF (INTEG.EQ.2) FPG='GAUSS'
        IF (INTEG.EQ.3) FPG='SIMP'
        IF (INTEG.EQ.4) FPG='SIMP1'
        IF (INTEG.EQ.6) FPG='COTES'
        IF (INTEG.EQ.10) FPG='XCON'
        IF (INTEG.EQ.14) FPG='FPG4'
        IF (INTEG.EQ.16) FPG='FPG6'
        IF (INTEG.EQ.17) FPG='FPG7'
        ELC='TR3'
      ELSEIF (NDIM.EQ.2) THEN
        IF (INTEG.EQ.1) FPG='NOEU'
        IF (INTEG.EQ.2) FPG='GAUSS'
        IF (INTEG.EQ.3) FPG='SIMP'
        IF (INTEG.EQ.4) FPG='SIMP1'
        IF (INTEG.EQ.6) FPG='COTES'
        IF (INTEG.EQ.7) FPG='COTES1'
        IF (INTEG.EQ.8) FPG='COTES2'
        IF (INTEG.EQ.12) FPG='FPG2'
        IF (INTEG.EQ.13) FPG='FPG3'
        IF (INTEG.EQ.14) FPG='FPG4'
        IF(ISMALI(ELREF)) THEN
          ELC='SE2'
        ELSE
          ELC='SE3'
        ENDIF
      ENDIF
      CALL ELREF4(ELC,FPG,IBID,NNOF,IBID,NPGF,IPOIDF,IVFF,IDFDEF,IBID)

C     RECUPERATION DU COEFFICIENT DE MISE � L'ECHELLE DES PRESSIONS
      E=ZR(JDONCO-1+5)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

C     L'ELEMENT EST-IL LINEAIRE OU QUADRATIQUE
C
      CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
      IF (IBID.EQ.0.AND.LAG.EQ.'NOEUD') THEN
        MALIN=.TRUE.
      ELSE
        MALIN=.FALSE.
      ENDIF
C
C     LISTE DES LAMBDAS ACTIFS
C
      IF (MALIN) THEN
        CALL XLACTI(TYPMA,NINTER,JAINT,LACT,NLACT)
        IF (NCONTA.EQ.1) NNOL=NNO
        IF (NCONTA.EQ.3) NNOL=NNOS
      ELSE
        NNOL=NNOF
      ENDIF
C
C     BOUCLE SUR LES FACETTES
      DO 100 IFA=1,NFACE
C
C       BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
        DO 110 IPGF=1,NPGF
C
C         INDICE DE CE POINT DE GAUSS DANS PSEUIL
          ISSPG=NPGF*(IFA-1)+IPGF
C
C         CALCUL DE JAC (PRODUIT DU JACOBIEN ET DU POIDS)
C         ET DES FF DE L'ELEMENT PARENT AU POINT DE GAUSS
C         ET LA NORMALE ND ORIENT�E DE ESCL -> MAIT
          IF (NDIM.EQ.3) THEN
            CALL XJACFF(ELREF,ELREFC,ELC,NDIM,FPG,JPTINT,IFA,CFACE,IPGF,
     &      NNO,IGEOM,JBASEC,G,'NON',RBID,FFP,FFPC,DFBID,ND,R3BID,R3BID)
          ELSEIF (NDIM.EQ.2) THEN
            CALL XJACF2(ELREF,ELREFC,ELC,NDIM,FPG,JPTINT,IFA,CFACE,NPTF,
     &      IPGF,NNO,IGEOM,JBASEC,G,'NON',RBID,FFP,FFPC,DFBID,ND,R3BID)
          ENDIF

C        CALCUL DES FONCTIONS DE FORMES DE CONTACT DANS LE CAS LINEAIRE
          IF (NCONTA.EQ.1) THEN
            CALL XMOFFC(LACT,NLACT,NNO,FFP,FFC)
          ELSEIF (NCONTA.EQ.3) THEN
            CALL XMOFFC(LACT,NLACT,NNOS,FFPC,FFC)
          ENDIF

C         CALCUL DU NOUVEAU SEUIL A PARTIR DES LAMBDA DE DEPPLU
C         RQ : LA VALEUR DANS IDEPPL EST LA PRESSION DIVIS�E PAR E
          SEUIL = 0.D0
          DO 120 I = 1,NNOL
            IF (MALIN) THEN
              FFI=FFC(I)
              NI=I
            ELSE
              NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
              FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
            ENDIF
            CALL XPLMAT(NDIM,NFH,NFE,DDLC,DDLM,NNO,NNOM,NI,PLI)
            SEUIL = SEUIL + FFI * ZR(IDEPPL-1+PLI) * E
 120      CONTINUE

C         LORS D'UNE CONVERGENCE FORCEE, IL SE PEUT QUE LES REACTIONS
C         SOIENT TROP PETITES. LE POINT DOIT ETRE CONSIDERE GLISSANT.
          IF (ABS(SEUIL).LT.1.D-11) THEN
            SEUIL=0.D0
          ENDIF

          ZR(JSEUIL-1+ISSPG)=SEUIL

C
C         CALCUL DE LA NOUVELLE VALEUR DE LA COHESION
C
C         ACTIVATION DE LA LOI COHESIVE ET 
C         RECUPERATION DES PARAMETRES MATERIAUX : 
             IF(RELA.NE.1.D0) THEN
               GO TO 53
             ENDIF
             
              NOMRES(1) = 'GC'
              NOMRES(2) = 'SIGM_C'
              NOMRES(3) = 'PENA_ADH'

              CALL RCVALA ( ZI(IMATE),' ','RUPT_FRAG',0,' ',0.D0,3,
     &                 NOMRES,VALRES,CODRET, 'FM' )
C
                GC   = VALRES(1)
                SIGMC  = VALRES(2)
                PENADH = VALRES(3)
C
                BETA=1.0D0                
                BETASQ=BETA*BETA
                ALPHA0=(GC/SIGMC)*PENADH
C
C          SAUT DE DEPLACEMENT EQUIVALENT [[U]]EQ
            DEPEQI=0.0D0
            COHES = 0.D0
            IF (SINGU.EQ.1) THEN
              LST=0.D0
              DO 112 I=1,NNO
                LST=LST+ZR(JLST-1+I)*FFP(I)
 112          CONTINUE
              R=ABS(LST)
              RR=SQRT(R)
            ENDIF
            CALL VECINI(3,0.D0,SAUT)
            DO 140 I = 1,NNO
              DO 141 J = 1,NFH*NDIM
                 
                SAUT(J) = SAUT(J) - 2.D0 * FFP(I) *
     &                              ZR(IDEPPL-1+DDLS*(I-1)+NDIM+J)

 141          CONTINUE
              DO 142 J = 1,SINGU*NDIM
                SAUT(J) = SAUT(J) - 2.D0 * FFP(I) * RR *
     &                            ZR(IDEPPL-1+DDLS*(I-1)+NDIM*(1+NFH)+J)

 142          CONTINUE
 140        CONTINUE
 
            CALL MATINI(3,3,0.D0,PP)
            CALL XMAFR1(NDIM,ND,P)    
            DO 212 I=1,NDIM
              DTANG(I) = 0.D0
              DNOR(I) = 0.D0
              DO 213  K=1,NDIM
                PP(I,K)=ND(I)*ND(K)
                DTANG(I)=DTANG(I)+P(I,K)*SAUT(K)
                DNOR(I) = DNOR(I) +PP(I,K)*SAUT(K)
 213         CONTINUE
 212        CONTINUE

            SQRTAN=0.D0 
            SQRNOR=0.D0
            
            DO 214 I=1,NDIM
              SQRTAN=SQRTAN+DTANG(I)**2
              SQRNOR=SQRNOR+DNOR(I)**2
 214        CONTINUE    

            DEPEQI=SQRT((SQRNOR+(BETASQ*SQRTAN)))

            IF (ABS(COHES).LT.1.D-11) THEN
              COHES=0.D0
            ENDIF
C
           IF ( DEPEQI . GE . ZR(JCOHES-1+ISSPG)*1.001D0 ) THEN
            ZR(JCOHEO-1+ISSPG)=DEPEQI
            IF(DEPEQI . LT . ALPHA0 ) ZR(JCOHEO-1+ISSPG)= 0.D0

            ELSE IF (DEPEQI.LT.ZR(JCOHES-1+ISSPG)*1.001D0) THEN
               ZR(JCOHEO-1+ISSPG)=ZR(JCOHES-1+ISSPG)
            END IF            
            
 53       CONTINUE

 110    CONTINUE
 100  CONTINUE

      CALL JEDEMA()
      END
