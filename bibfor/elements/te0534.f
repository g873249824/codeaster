      SUBROUTINE TE0534(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/12/2010   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C               CALCUL DES SECONDS MEMBRES DE CONTACT FROTTEMENT
C                   POUR X-FEM  (METHODE CONTINUE)
C
C
C  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
C  OPTION : 'CHAR_MECA_FROT' (CALCUL DU SECOND MEMBRE DE FROTTEMENT)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C.......................................................................
C TOLE CRP_20
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------

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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER      I,J,K,L,IJ,IFA,IPGF,INO,ISSPG,NI,NJ,NLI,PLI,PLJ
      INTEGER      JINDCO,JDONCO,JLST,IPOIDS,IVF,IDFDE,JGANO,IGEOM
      INTEGER      IDEPM,IDEPL,IMATT,JSTANO,JPTINT,JAINT,JCFACE,JLONCH
      INTEGER      IPOIDF,IVFF,IDFDEF,IADZI,IAZK24,IBID,IVECT,JBASEC
      INTEGER      NDIM,NFH,DDLC,DDLS,NDDL,NNO,NNOS,NNOM,NNOF,DDLM
      INTEGER      NPG,NPGF,XOULA,FAC(6,4),NBF,JSEUIL
      INTEGER      INDCO(60),NINTER,NFACE,CFACE(5,3),IBID2(12,3),CPT
      INTEGER      INTEG,NFE,SINGU,JSTNO,NVIT
      INTEGER      NNOL,PLA(27),LACT(8),NLACT
      INTEGER      IER,IN,NCONTA
      REAL*8       HE,SIGN,VTMP(400),REAC,REAC12(3),FFI,LAMBDA,JAC,JACN
      REAL*8       ND(3),DN,FFP(27),FFC(8),PTPB(3),PADIST
      REAL*8       METR(2),AL,RHON,MU,RHOTK,P(3,3),SEUIL(60),FFN(27)
      REAL*8       TAU1(3),TAU2(3),PB(3),RPB(3)
      REAL*8       RBID1(3,3),RBID2(3,3),RBID3(3,3),DDOT
      REAL*8       LST,R,RR,E,G(3),TT(3),RBID
      REAL*8       FFPC(27),DFBID(27,3),R3BID(3),R2BID(2)
      REAL*8       CSTACO,CSTAFR,CPENCO,CPENFR,VITANG(3),X(4)
      REAL*8       VTANG2(3),NVTNG2
      INTEGER      ZXAIN,XXMMVD
      INTEGER      JCOHES,III,IMATE
      LOGICAL      LPENAF,MALIN,LPENAC,LBID,ADHER,ISMALI
      REAL*8       DEPEQI,SQRNOR,SQRTAN,TTX(3),COHES(60)
      REAL*8       BETA,GC,SIGMC,TSELAS,ALPHA0,ALPHA,R8PREM
      REAL*8       DTANG(3),DNOR(3),VALRES(3),PENADH,RELA,PTPG(3)
      REAL*8       VIM(9),VIP(9),PP(3,3)
      REAL*8       SAUT(3),DSAUT(3),TNCOH,TTCOH,BETASQ,PPTG(3)        
      REAL*8       SIGMA(3,3),DSIDEP(3,3)
      REAL*8       AM(3),DAM(3),COEFF1,COEFF2
      CHARACTER*2  CODRET(3)
      CHARACTER*8  ELREF,TYPMA,FPG,ELC,LAG,ELREFC
      CHARACTER*8 NOMRES(3)
      CHARACTER*16 OPTIO2,ENR
      REAL*8       AM2D(2),DAM2D(2),DSID2D(2,2),TAU11(3),TAU22(3)
      INTEGER      NPTF,NFISS,JFISNO

C.......................................................................

      CALL JEMARQ()
C
C-----------------------------------------------------------------------
C     INITIALISATIONS
C-----------------------------------------------------------------------
      ZXAIN=XXMMVD('ZXAIN')
      CALL ELREF1(ELREF)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,SINGU,DDLC,NNOM,DDLS,NDDL,DDLM,NFISS)
C
      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

      IF (NDIM .EQ. 3) THEN
         CALL CONFAC(TYPMA,IBID2,IBID,FAC,NBF)
      ENDIF

      DO 40 J=1,NDDL
        VTMP(J)=0.D0
40    CONTINUE

C      INITIALISATION DES VARIABLES INTERNES POUR CZM-XFEM
       DO 295 III=1,9
       VIM(III)=0.0D0
       VIP(III)=0.0D0
 295   CONTINUE 

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
C-----------------------------------------------------------------------
C     RECUPERATION DES ENTR�ES / SORTIE
C-----------------------------------------------------------------------
      CALL JEVECH('PGEOMER','E',IGEOM)
C     DEPLACEMENT A L'EQUILIBRE PRECEDENT  (DEPMOI)       : 'PDEPL_M'
      CALL JEVECH('PDEPL_M','L',IDEPM)
C     INCREMENT DE DEP DEPUIS L'EQUILIBRE PRECEDENT (DEPDEL) : 'PDEPL_P'
      CALL JEVECH('PDEPL_P','L',IDEPL)
      CALL JEVECH('PINDCOI','L',JINDCO)
      CALL JEVECH('PDONCO','L',JDONCO)
      CALL JEVECH('PSEUIL','L',JSEUIL)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE','L',JCFACE)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASECO','L',JBASEC)
      CALL JEVECH('PVECTUR','E',IVECT)

      CALL TEATTR(NOMTE,'S','XFEM',ENR,IBID)          
      IF (ENR.EQ.'XHC') THEN
        RELA =  ZR(JDONCO-1+10)
      ELSE
        RELA=0.0D0
      ENDIF
       
      IF(RELA.EQ.1.D0) THEN
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PCOHES' ,'L',JCOHES)
      ENDIF

C     R�CUP�RATIONS DES DONN�ES SUR LE CONTACT ET
C     SUR LA TOPOLOGIE DES FACETTES
      NINTER=ZI(JLONCH-1+1)
      NFACE=ZI(JLONCH-1+2)
      NPTF=ZI(JLONCH-1+3)

      DO 10 I=1,60
        INDCO(I) = ZI(JINDCO-1+I)
        SEUIL(I) = ZR(JSEUIL-1+I)
      IF(RELA.EQ.1.D0) COHES(I) = ZR(JCOHES-1+I)
 10   CONTINUE
      RHON = ZR(JDONCO-1+1)
      MU = ZR(JDONCO-1+2)
      RHOTK = ZR(JDONCO-1+3)

      INTEG = NINT(ZR(JDONCO-1+4))
C     SCHEMA D'INTEGRATION NUMERIQUE ET ELEMENT DE REFERENCE DE CONTACT
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

C
      DO 11 I=1,NFACE
        DO 12 J=1,NPTF
          CFACE(I,J)=ZI(JCFACE-1+NPTF*(I-1)+J)
 12     CONTINUE
 11   CONTINUE

C     RECUPERATION DU COEFFICIENT DE MISE � L'ECHELLE DES PRESSIONS
      E=ZR(JDONCO-1+5)

C     COEFFICIENTS DE STABILISATION
      CSTACO=ZR(JDONCO-1+6)
      CSTAFR=ZR(JDONCO-1+7)

C     COEFFICIENTS DE PENALISATION
      CPENCO=ZR(JDONCO-1+8)
      CPENFR=ZR(JDONCO-1+9)

      IF (CSTACO.EQ.0.D0) CSTACO=RHON
      IF (CSTAFR.EQ.0.D0) CSTAFR=RHOTK

      IF (CPENCO.EQ.0.D0) CPENCO=RHON
      IF (CPENFR.EQ.0.D0) CPENFR=RHOTK

C     PENALISATION PURE
C     PENALISATION DU CONTACT
      LPENAC=.FALSE.
      IF (CSTACO.EQ.0.D0) THEN
        CSTACO=CPENCO
        LPENAC=.TRUE.
      ENDIF
C     PENALISATION DU FROTTEMENT
      LPENAF=.FALSE.
      IF (CSTAFR.EQ.0.D0) THEN
        LPENAF=.TRUE.
      ENDIF

C
C     LISTE DES LAMBDAS ACTIFS
C
      IF(MALIN) CALL XLACTI(TYPMA,NINTER,JAINT,LACT,NLACT)
C
C-----------------------------------------------------------------------
C
C     BOUCLE SUR LES FACETTES

      DO 100 IFA=1,NFACE
C       NOMBRE DE LAMBDAS ET LEUR PLACE DANS LA MATRICE
        IF (MALIN) THEN
          IF (NCONTA.EQ.1) NNOL=NNO
          IF (NCONTA.EQ.3) NNOL=NNOS
          DO 15 I=1,NNOL
            CALL XPLMAT(NDIM,NFH,NFE,DDLC,DDLM,NNO,NNOM,I,PLI)
            PLA(I)=PLI
 15       CONTINUE
        ELSE
          NNOL=NNOF
          DO 16 I=1,NNOF
C           XOULA  : RENVOIE LE NUMERO DU NOEUD PORTANT CE LAMBDA
            NI=XOULA(CFACE,IFA,I,JAINT,TYPMA,NCONTA)
C           PLACE DU LAMBDA DANS LA MATRICE
            CALL XPLMAT(NDIM,NFH,NFE,DDLC,DDLM,NNO,NNOM,NI,PLI)
            PLA(I)=PLI
 16       CONTINUE
        ENDIF

C       BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
        DO 110 IPGF=1,NPGF
C
C         INDICE DE CE POINT DE GAUSS DANS INDCO
          ISSPG=NPGF*(IFA-1)+IPGF

C         CALCUL DE JAC (PRODUIT DU JACOBIEN ET DU POIDS)
C         ET DES FF DE L'�L�MENT PARENT AU POINT DE GAUSS
C         ET LA NORMALE ND ORIENT�E DE ESCL -> MAIT
          IF (NDIM.EQ.3) THEN
            CALL XJACFF(ELREF,ELREFC,ELC,NDIM,FPG,JPTINT,IFA,CFACE,IPGF,
     &         NNO,IGEOM,JBASEC,G,'NON',JAC,FFP,FFPC,DFBID,ND,TAU1,TAU2)
          ELSEIF (NDIM.EQ.2) THEN
            CALL XJACF2(ELREF,ELREFC,ELC,NDIM,FPG,JPTINT,IFA,CFACE,NPTF,
     &      IPGF,NNO,IGEOM,JBASEC,G,'NON',JAC,FFP,FFPC,DFBID,ND,TAU1)
          ENDIF

C        CALCUL DES FONCTIONS DE FORMES DE CONTACT DANS LE CAS LAG NOEUD
          IF (NCONTA.EQ.1) THEN
            CALL XMOFFC(LACT,NLACT,NNO,FFP,FFC)
          ELSEIF (NCONTA.EQ.3) THEN
            CALL XMOFFC(LACT,NLACT,NNOS,FFPC,FFC)
          ENDIF

C         CE POINT DE GAUSS EST-IL SUR UNE ARETE?
          K=0
          DO 17 I=1,NINTER
            IF (K.EQ.0) THEN
              X(4)=0.D0
              DO 20 J=1,NDIM
                X(J)=ZR(JPTINT-1+NDIM*(I-1)+J)
 20           CONTINUE
              DO 21 J=1,NDIM
                X(4) = X(4) + (X(J)-G(J))*(X(J)-G(J))
 21           CONTINUE
              X(4) = SQRT(X(4))
              IF (X(4).LT.1.D-12) THEN
                K=I
                GOTO 17
              ENDIF
            ENDIF
 17       CONTINUE
C         SI OUI, L'ARETE EST-ELLE VITALE?
          IF (K.NE.0) THEN
            NVIT = ZR(JAINT-1+ZXAIN*(K-1)+5)
          ELSE
            NVIT = 0
          ENDIF
C         IL NE FAUT PAS UTILISER NVIT SI LE SCHEMA D'INTEGRATION
C         NE CONTIENT PAS DE NOEUDS
          IF ((FPG(1:3).EQ.'FPG').OR.(FPG.EQ.'GAUSS')
     &             .OR.(FPG.EQ.'XCON')) NVIT=1
C
C         R�ACTION CONTACT = SOMME DES FF(I).LAMBDA(I) POUR I=1,NNOL
C         RQ : LA VALEUR DANS IDEPPL EST LA PRESSION DIVIS�E PAR E
C         R�ACTION FROTT = SOMME DES FF(I).(LAMB1(I).TAU1+LAMB2(I).TAU2)
C        (DEPDEL+DEPMOI)
          REAC=0.D0
          CALL VECINI(3,0.D0,REAC12)
          DO 120 I = 1,NNOL
            PLI=PLA(I)
            IF (MALIN) THEN
              FFI=FFC(I)
              NLI=LACT(I)
              IF (NLI.EQ.0) GOTO 120
            ELSE
              FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
              NLI=CFACE(IFA,I)
            ENDIF
            REAC = REAC + FFI * (ZR(IDEPL-1+PLI)+ZR(IDEPM-1+PLI)) * E

            DO 121 J=1,NDIM
              IF (NDIM .EQ.3) THEN
                REAC12(J)=REAC12(J)+FFI*(ZR(IDEPL-1+PLI+1)*TAU1(J)
     &                                  +ZR(IDEPM-1+PLI+1)*TAU1(J)
     &                                  +ZR(IDEPM-1+PLI+2)*TAU2(J)
     &                                  +ZR(IDEPL-1+PLI+2)*TAU2(J))
              ELSEIF (NDIM.EQ.2) THEN
                REAC12(J)=REAC12(J)+FFI*(ZR(IDEPL-1+PLI+1)*TAU1(J)
     &                                  +ZR(IDEPM-1+PLI+1)*TAU1(J))
              ENDIF
 121        CONTINUE
 120      CONTINUE


C         CALCUL DE RR = SQRT(DISTANCE AU FOND DE FISSURE)
          IF (SINGU.EQ.1) THEN
            LST=0.D0
            DO 112 I=1,NNO
              LST=LST+ZR(JLST-1+I)*FFP(I)
 112        CONTINUE
            R=ABS(LST)
            RR=SQRT(R)
          ENDIF

C         I) CALCUL DES SECONDS MEMBRES DE CONTACT
C         ..............................

          IF (OPTION.EQ.'CHAR_MECA_CONT') THEN


C           SI PAS DE CONTACT POUR CE PG : ON REMPLIT LE VECTEUR LN2
            IF (INDCO(ISSPG).EQ.0) THEN

              IF (NVIT.NE.0) THEN

                DO 130 I = 1,NNOL

                  PLI=PLA(I)
                  IF (MALIN) THEN
                    FFI=FFC(I)
                  ELSE
                    FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                  ENDIF

                  VTMP(PLI) = VTMP(PLI) - REAC*FFI*JAC/CSTACO*E
 130            CONTINUE

              ENDIF
C
C           SI CONTACT POUR CE PG : ON REMPLIT LES VECTEURS LN1 ET LN2
            ELSE IF (INDCO(ISSPG).EQ.1) THEN
C
C             CALCUL DU SAUT ET DE DN EN CE PG (DEPMOI + DEPDEL)
              CALL VECINI(3,0.D0,SAUT)
              DO 140 I = 1,NNO
                CALL INDENT(I,DDLS,DDLM,NNOS,IN)

                DO 141 J = 1,NFH*NDIM
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(I) *
     &                             (   ZR(IDEPM-1+IN+NDIM+J)
     &                               + ZR(IDEPL-1+IN+NDIM+J) )
 141            CONTINUE
                DO 142 J = 1,SINGU*NDIM
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(I) * RR *
     &                          (   ZR(IDEPM-1+IN+NDIM*(1+NFH)+J)
     &                            + ZR(IDEPL-1+IN+NDIM*(1+NFH)+J) )
 142            CONTINUE
 140          CONTINUE
              DN = 0.D0
              DO 143 J = 1,NDIM
                DN = DN + SAUT(J)*ND(J)
 143          CONTINUE

C             TERME LN1
              IF (LPENAC) THEN
C               PENALISATION DU CONTACT
                DO 153 I = 1,NNO
                  CALL INDENT(I,DDLS,DDLM,NNOS,IN)

                  DO 154 J = 1,NFH*NDIM
                    VTMP(IN+NDIM+J) =
     &              VTMP(IN+NDIM+J) -
     &              (CPENCO*DN)*2.D0*FFP(I)*ND(J)*JAC
 154              CONTINUE
                  DO 155 J = 1,SINGU*NDIM
                    VTMP(IN+NDIM*(1+NFH)+J) =
     &              VTMP(IN+NDIM*(1+NFH)+J) -
     &              (CPENCO*DN)*2.D0*FFP(I)*RR*ND(J)*JAC
 155              CONTINUE
 153            CONTINUE
              ELSE
                DO 150 I = 1,NNO
                  CALL INDENT(I,DDLS,DDLM,NNOS,IN)

                  DO 151 J = 1,NFH*NDIM
                    VTMP(IN+NDIM+J) =
     &              VTMP(IN+NDIM+J) +
     &              (REAC-CPENCO*DN)*2.D0*FFP(I)*ND(J)*JAC
 151              CONTINUE
                  DO 152 J = 1,SINGU*NDIM
                    VTMP(IN+NDIM*(1+NFH)+J) =
     &              VTMP(IN+NDIM*(1+NFH)+J) +
     &              (REAC-CPENCO*DN)*2.D0*FFP(I)*RR*ND(J)*JAC
 152              CONTINUE
 150            CONTINUE
              ENDIF
C
C             TERME LN2
              DO 160 I = 1,NNOL

                PLI=PLA(I)
                IF (MALIN) THEN
                  FFI=FFC(I)
                ELSE
                  FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                ENDIF

                VTMP(PLI) = VTMP(PLI) - DN * FFI * JAC * E
                IF (LPENAC) THEN
                  VTMP(PLI) = VTMP(PLI) - REAC*FFI*JAC/CPENCO*E
                ENDIF

 160          CONTINUE

            ELSE
C             SI INDCO N'EST NI �GAL � 0 NI �GAL � 1
C             PROBLEME DE STATUT DE CONTACT.
              CALL ASSERT(INDCO(ISSPG).EQ.0 .OR. INDCO(ISSPG).EQ.1)
            END IF
C
C         II) CALCUL DES SECONDS MEMBRES DE FROTTEMENT
C         ..............................

          ELSEIF (OPTION.EQ.'CHAR_MECA_FROT') THEN

            IF (MU.EQ.0.D0.OR.SEUIL(ISSPG).EQ.0.D0) INDCO(ISSPG) = 0

C           II.1. SI PAS DE CONTACT POUR CE PG : ON REMPLIT QUE LN3
            IF (INDCO(ISSPG).EQ.0) THEN

              IF (NVIT.NE.0) THEN

                CALL VECINI(3,0.D0,SAUT)
                DO 161 I = 1,NNO
                  CALL INDENT(I,DDLS,DDLM,NNOS,IN)

                  DO 162 J = 1,NFH*NDIM
                    SAUT(J) = SAUT(J) - 2.D0 * FFP(I) *
     &                       (   ZR(IDEPM-1+IN+NDIM+J)
     &                       + ZR(IDEPL-1+IN+NDIM+J) )
 162              CONTINUE
                  DO 163 J = 1,SINGU*NDIM
                    SAUT(J) = SAUT(J) - 2.D0 * FFP(I) * RR *
     &                       (   ZR(IDEPM-1+IN+NDIM*(1+NFH)+J)
     &                       + ZR(IDEPL-1+IN+NDIM*(1+NFH)+J) )
 163              CONTINUE
 161            CONTINUE

                CALL VECINI(3,0.D0,TT)
                DO 165 I = 1,NNOL
                  PLI=PLA(I)
                  IF (MALIN) THEN
                    FFI=FFC(I)
                    NLI=LACT(I)
                    IF (NLI.EQ.0) GOTO 165
                  ELSE
                    FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                    NLI=CFACE(IFA,I)
                  ENDIF

                  METR(1)=DDOT(NDIM,TAU1(1),1,SAUT,1)
                  IF (NDIM.EQ.3) METR(2)=DDOT(NDIM,TAU2(1),1,
     &                                        SAUT,1)
                  TT(1)=DDOT(NDIM,TAU1(1),1,REAC12,1)
                  IF (NDIM .EQ.3) TT(2)=DDOT(NDIM,TAU2(1),1,
     &                                       REAC12,1)
                  DO 167 K=1,NDIM-1
                    VTMP(PLI+K) = VTMP(PLI+K) + TT(K)*FFI*JAC
 167              CONTINUE
 165            CONTINUE


C         II.2. CALCUL DES SECONDS MEMBRES DE COHESION
C         ..............................
C            II.2.1. VERIFICATION DE L'ACTIVATION DE LA LOI COHESIVE
C                    ET RECUPERATION DES PARAMETRES MATERIAUX :
                IF(RELA.NE.1.0D0) THEN
                  GO TO 53
                ENDIF
C                                      
                NOMRES(1) = 'GC'
                NOMRES(2) = 'SIGM_C'
                NOMRES(3) = 'PENA_ADH'
C
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
C           II.2.2. CALCUL DU SAUT DE DEPLACEMENT EQUIVALENT [[UEG]]

                DEPEQI=0.0D0
                CALL MATINI(3,3,0.D0,DSIDEP)
                CALL MATINI(2,2,0.D0,DSID2D)
                CALL MATINI(3,3,0.D0,SIGMA)                
                CALL VECINI(3,0.D0,SAUT)
                CALL VECINI(3,0.D0,TAU11)
                CALL VECINI(3,0.D0,TAU22)
C              
                DO 204 I=1,NNO
                  DO 205 J=1,NFH*NDIM
                    SAUT(J) = SAUT(J) - 2.D0 * FFP(I) *
     &                             (   ZR(IDEPM-1+DDLS*(I-1)+NDIM+J)
     &                               + ZR(IDEPL-1+DDLS*(I-1)+NDIM+J) )
 205              CONTINUE
                  DO 206 J = 1,SINGU*NDIM
                    SAUT(J) = SAUT(J) - 2.D0 * FFP(I) * RR *
     &                          (  ZR(IDEPM-1+DDLS*(I-1)+NDIM*(1+NFH)+J)
     &                          + ZR(IDEPL-1+DDLS*(I-1)+NDIM*(1+NFH)+J))
    
 206              CONTINUE
 204            CONTINUE 
 
                DO 210 I = 1,NNOL
                PLI=PLA(I)
                IF (MALIN) THEN
                   FFI=FFC(I)
                   NLI=LACT(I)
                   IF (NLI.EQ.0) GOTO 210
                ELSE
                   FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                   NLI=CFACE(IFA,I)
                ENDIF
                DO 211 J=1,NDIM
                IF (NDIM .EQ.3) THEN
                   TAU11(J)=TAU11(J)+FFI*TAU1(J)
                   TAU22(J)=TAU22(J)+FFI*TAU2(J)
                ELSEIF (NDIM.EQ.2) THEN
                   TAU11(J)=TAU11(J)+FFI*TAU1(J)
                ENDIF
 211           CONTINUE
 210           CONTINUE
 
C        
C            P : OPERATEUR DE PROJECTION 3D
                CALL XMAFR1(3,ND,P)
C
                CALL VECINI(3,0.D0,AM)
                CALL VECINI(3,0.D0,DAM)
                CALL MATINI(3,3,0.D0,PP)                
C                
                DO 218 I=1,NDIM
                  DTANG(I) = 0.D0
                  DNOR(I) = 0.D0
                  DO 219  K=1,NDIM
                    PP(I,K)=ND(I)*ND(K)
                    DTANG(I)=DTANG(I)+P(I,K)*SAUT(K)
                    DNOR(I) = DNOR(I) +PP(I,K)*SAUT(K)
 219              CONTINUE 
                  AM(1)= AM(1) + DNOR(I)*ND(I)
                  AM(2)= AM(2) + DTANG(I)*TAU11(I)
                  AM(3)= AM(3) + DTANG(I)*TAU22(I)
                  DAM(1)= AM(1)
                  DAM(2)= AM(2)
                  DAM(3)= AM(3)                                       
 218            CONTINUE   
 
                SQRTAN=0.D0
                SQRNOR=0.D0
              
                DO 214 I=1,NDIM
                  SQRTAN=SQRTAN+DTANG(I)**2
                  SQRNOR=SQRNOR+DNOR(I)**2
 214            CONTINUE 
                DEPEQI = SQRT(SQRNOR+BETASQ*SQRTAN)                 
                ALPHA = DEPEQI
C                
C VIM = VARIABLES INTERNES UTILISEES DANS LCEJEX
C...............VIM(1): SEUIL, PLUS GRANDE NORME DU SAUT
C...............VIM(2): INDICATEUR DE DISSIPATION (0 : NON, 1 : OUI)
                IF ( ( ALPHA . GE . ALPHA0) . AND . 
     &                ( ALPHA . GE . COHES(ISSPG)*1.001D0) ) THEN
                  VIM(1) = ALPHA
                  VIM(2) = 1
                ELSE
                  VIM(1) = COHES(ISSPG)   
                  VIM(2) = 0
                ENDIF 
C L'INTERPENETRATION DES LEVRES DE LA FISSURE
C  CORRESPOND A UN SAUT NEGATIF DANS LCEJEX !
                DO 777 I=1,NDIM
                  AM(I)=-AM(I)
                  DAM(I)=-DAM(I)
 777            CONTINUE
                
                OPTIO2=OPTION
                OPTION='RIGI_MECA'
              
                IF (NDIM.EQ.2)   THEN              
                  AM2D(1)=AM(1)
                  AM2D(2)=AM(2)              
                  DAM2D(1)=DAM(1)
                  DAM2D(2)=DAM(2)
                  CALL LCEJEX('RIGI',IPGF,1,2,ZI(IMATE),OPTION,AM2D, 
     &                      DAM2D,SIGMA,DSID2D,VIM,VIP)
              
                  DSIDEP(1,1)=DSID2D(1,1)                
                  DSIDEP(1,2)=DSID2D(1,2)                
                  DSIDEP(2,1)=DSID2D(2,1)                
                  DSIDEP(2,2)=DSID2D(2,2)
              
                ELSE IF (NDIM.EQ.3)   THEN              
                  CALL LCEJEX('RIGI',IPGF,1,3,ZI(IMATE),OPTION,AM, 
     &                      DAM,SIGMA,DSIDEP,VIM,VIP)
                ENDIF     
                OPTION=OPTIO2

C         II.2.3. CALCUL DES SECONDS MEMBRES DE COHESION

                IF (ABS(DEPEQI) . LE . R8PREM() ) THEN
                  GOTO 110
                ELSE

                  IF ( ( ALPHA . GE . ALPHA0) . AND . 
     &              ( ALPHA . GE . COHES(ISSPG)*1.001D0) ) THEN  
C                   CHARGE COHESIVE-ENDOMAGEMENT
                    COEFF1 = (DSIDEP(1,1)-DSIDEP(2,2))/
     &                     ((AM(1))**2-(AM(2))**2)
                    COEFF2 = DSIDEP(1,1) - COEFF1*(AM(1))**2  
                    TSELAS=COEFF2

                  ELSE IF ( ( ALPHA . LT . ALPHA0) . AND . 
     &                  ( ALPHA . GE . COHES(ISSPG)*1.001D0) ) THEN
C                   CHARGE ELASTIQUE AVANT ENDOMAGEMENT
                    TSELAS=DSIDEP(1,1)

                  ELSE IF ( ALPHA . LT . COHES(ISSPG)*1.001D0) THEN
C                   CHARGE ET DECHARGE ELASTIQUE APRES ENDOMAGEMENT
                    ALPHA = COHES(ISSPG)
                    TSELAS=DSIDEP(1,1)
                  ELSE 
C                   ALPHA NE CORRESPOND A AUCUN CAS       
                    CALL ASSERT(.FALSE.)
                  ENDIF

                  DO 248 I=1,NDIM
                    PTPG(I)=0.D0
                    PPTG(I)=0.D0
                    DO 249 K=1,NDIM
                      PTPG(I)=PTPG(I) + P(K,I)*DTANG(K)
                      PPTG(I)=PPTG(I) + PP(K,I)*DNOR(K)
 249                CONTINUE  
 248              CONTINUE                 

                  DO 450 I = 1,NNO
                    DO 451 J = 1,NFH*NDIM 
                      VTMP(DDLS*(I-1)+NDIM+J) =
     &                VTMP(DDLS*(I-1)+NDIM+J)- 
     &                 (2.D0*TSELAS*PPTG(J)*FFP(I)*JAC)-
     &                 (2.D0*BETASQ*TSELAS*PTPG(J)*FFP(I)*JAC)

 451                CONTINUE
                    DO 452 J = 1,SINGU*NDIM
                        VTMP(DDLS*(I-1)+NDIM*(1+NFH)+J) =
     &                  VTMP(DDLS*(I-1)+NDIM*(1+NFH)+J)- 
     &                 (2.D0*TSELAS*PPTG(J)*FFP(I)*JAC*RR)-
     &                 (2.D0*BETASQ*TSELAS*PTPG(J)*FFP(I)*JAC*RR)
 
 452                CONTINUE
 450              CONTINUE

                  CALL VECINI(3,0.D0,TTX)

                  DO 460 I = 1,NNOL
                    PLI=PLA(I)
                    IF (MALIN) THEN
                    FFI=FFC(I)
                    NLI=LACT(I)
                    IF (NLI.EQ.0) GOTO 460
                    ELSE
                      FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                      NLI=CFACE(IFA,I)
                    ENDIF
                    TTX(1)=DDOT(NDIM,TAU1(1),1,DTANG,1)
                    IF (NDIM .EQ.3) TTX(2)=DDOT(NDIM,TAU2(1),
     &                                           1,DTANG,1)
                    DO 465 K=1,NDIM-1
                      VTMP(PLI+K) = VTMP(PLI+K)
     &              -  BETASQ*TSELAS*TTX(K)*FFI*JAC
 465                CONTINUE
 460              CONTINUE
  
                  DO 470 I = 1,NNOL
                    PLI=PLA(I)
                    IF (MALIN) THEN
                    FFI=FFC(I)
                    NLI=LACT(I)
                    IF (NLI.EQ.0) GOTO 470
                    ELSE
                      FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                      NLI=CFACE(IFA,I)
                    ENDIF
                    DO 475 K = 1, NDIM
                      VTMP(PLI) = VTMP(PLI) - 
     &              TSELAS*DNOR(K)*ND(K)*FFI*JAC/CSTACO*E
 475                CONTINUE
 470              CONTINUE       
                    
                ENDIF           
 53             CONTINUE    
              ENDIF

C           II.3)SI CONTACT POUR CE PG : ON REMPLIT LN1 ET LN3
            ELSE IF (INDCO(ISSPG).EQ.1) THEN

C             P : OP�RATEUR DE PROJECTION
              CALL XMAFR1(NDIM,ND,P)

C             PBOUL SELON L'�TAT D'ADHERENCE DU PG (AVEC DEPDEL)
              CALL VECINI(3,0.D0,SAUT)
              DO 175 INO=1,NNO
                CALL INDENT(INO,DDLS,DDLM,NNOS,IN)

                DO 176 J=1,NFH*NDIM
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) *
     &                                ZR(IDEPL-1+IN+NDIM+J)
 176            CONTINUE
                DO 177 J = 1,SINGU*NDIM
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) * RR *
     &                              ZR(IDEPL-1+IN+NDIM*(1+NFH)+J)

 177            CONTINUE
 175          CONTINUE

              CALL XADHER(P,SAUT,REAC12,RHOTK,CSTAFR,CPENFR,LPENAF,
     &                 VITANG,PB,RBID1,RBID2,RBID3,ADHER)

C             TERME LN1

              IF (ADHER) THEN
C               CALCUL DE PT.REAC12
                DO 188 I=1,NDIM
                  PTPB(I)=0.D0
                  IF (LPENAF) THEN
                    DO 190 K=1,NDIM
                      PTPB(I)=PTPB(I)+P(K,I)*CPENFR*VITANG(K)
 190                CONTINUE
                  ELSE
                    DO 189 K=1,NDIM
                      PTPB(I)=PTPB(I)+P(K,I)*(REAC12(K)
     &                         +CPENFR*VITANG(K))
 189                CONTINUE
                  ENDIF
 188            CONTINUE
              ELSE
C               CALCUL DE PT.PBOUL
                DO 182 I=1,NDIM
                  PTPB(I)=0.D0
                  DO 183 K=1,NDIM
                    PTPB(I)=PTPB(I) + P(K,I)*PB(K)
 183              CONTINUE
 182            CONTINUE
              ENDIF

              DO 185 I = 1,NNO
                CALL INDENT(I,DDLS,DDLM,NNOS,IN)

                DO 186 J = 1,NFH*NDIM
                  VTMP(IN+NDIM+J) =
     &            VTMP(IN+NDIM+J) +
     &            2.D0*MU*SEUIL(ISSPG)* PTPB(J)*FFP(I)*JAC
 186            CONTINUE
                DO 187 J = 1,SINGU*NDIM
                  VTMP(IN+NDIM*(1+NFH)+J) =
     &            VTMP(IN+NDIM*(1+NFH)+J) +
     &            2.D0*RR*MU*SEUIL(ISSPG)* PTPB(J)*FFP(I)*JAC
 187            CONTINUE
 185          CONTINUE

C             TERME LN3

C             CALCUL DE REAC12-PBOUL
              IF (LPENAF) CSTAFR=CPENFR
              DO 180 I=1,NDIM
                RPB(I)=REAC12(I)-PB(I)
 180          CONTINUE
  
              DO 194 I = 1,NNOL
                PLI=PLA(I)
                IF (MALIN) THEN
                  FFI=FFC(I)
                  NLI=LACT(I)
                  IF (NLI.EQ.0) GOTO 194
                ELSE
                  FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                  NLI=CFACE(IFA,I)
                ENDIF

                METR(1)=DDOT(NDIM,TAU1(1),1,RPB,1)
                IF(NDIM.EQ.3)
     &            METR(2)=DDOT(NDIM,TAU2(1),1,RPB,1)
                DO 195 K=1,NDIM-1
                  VTMP(PLI+K) = VTMP(PLI+K)
     &                  + MU*SEUIL(ISSPG)/CSTAFR * METR(K)*FFI*JAC

 195            CONTINUE
 194          CONTINUE

            ELSE
C             SI INDCO N'EST NI �GAL � 0 NI �GAL � 1
C             PROBLEME DE STATUT DE CONTACT.
              CALL ASSERT(INDCO(ISSPG).EQ.0 .OR. INDCO(ISSPG).EQ.1)
            END IF

          ELSE
C           SI OPTION NI 'CHAR_MECA_CONT' NI 'CHAR_MECA_FROT'
            CALL ASSERT(OPTION.EQ.'CHAR_MECA_FROT' .OR.
     &                  OPTION.EQ.'CHAR_MECA_CONT')
          ENDIF

C         FIN DE BOUCLE SUR LES POINTS DE GAUSS
 110    CONTINUE

C       FIN DE BOUCLE SUR LES FACETTES
 100  CONTINUE

C
C-----------------------------------------------------------------------
C     COPIE DES CHAMPS DE SORTIES ET FIN
C-----------------------------------------------------------------------
C
      DO 900 I=1,NDDL
        ZR(IVECT-1+I)=VTMP(I)
 900  CONTINUE

      CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
      IF (IBID.EQ.0.AND.LAG.EQ.'ARETE') THEN
        NNO = NNOS
      ENDIF
C     SUPPRESSION DES DDLS DE DEPLACEMENT SEULEMENT POUR LES XHTC
      IF (NFH*NFE.NE.0) THEN
        CALL JEVECH('PSTANO' ,'L',JSTNO)
        CALL XTEDDL(NDIM,NFH,NFE,DDLS,NDDL,NNOS,NNOS,ZI(JSTNO),
     &              .FALSE.,LBID,OPTION,NOMTE,RBID,ZR(IVECT),DDLM,
     &              NFISS,JFISNO)
      ENDIF
C     SUPPRESSION DES DDLS DE CONTACT
      IF (MALIN.AND.NLACT.LT.NNO) THEN
        CALL XTEDDL(NDIM,NFH,NFE,DDLS,NDDL,NNO,NNOS,LACT,
     &              .TRUE.,.TRUE.,OPTION,NOMTE,RBID,ZR(IVECT),DDLM,
     &              NFISS,JFISNO)
      ENDIF

      CALL JEDEMA()
      END
