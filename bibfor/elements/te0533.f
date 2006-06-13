      SUBROUTINE TE0533(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2006   AUTEUR GENIAUT S.GENIAUT 
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
C
C.......................................................................
C
C         CALCUL DES MATRICES DE CONTACT FROTTEMENT POUR X-FEM 
C                       (METHODE CONTINUE)
C
C
C  OPTION : 'RIGI_CONT' (CALCUL DES MATRICES DE CONTACT)
C  OPTION : 'RIGI_FROT' (CALCUL DES MATRICES DE FROTTEMENT)

C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C TOLE CRP_20
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

      INTEGER      I,J,K,L,IJ,IFA,IPGF,INO,ISSPG,NI,NJ,NLI,NLJ,PLI,PLJ
      INTEGER      JINDCO,JDONCO,JLSN,IPOIDS,IVF,IDFDE,JGANO,IGEOM
      INTEGER      IDEPM,IDEPD,IMATT,JLST,JPTINT,JAINT,JCFACE,JLONCH
      INTEGER      IPOIDF,IVFF,IDFDEF,IADZI,IAZK24,IBID,JBASEC,JSEUIL
      INTEGER      NDIM,DDLH,DDLC,DDLS,NDDL,NNO,NNOS,NNOM,NNOF
      INTEGER      NPG,NPGF,AR(12,2),NBAR,XOULA,IN(3),FAC(6,4),NBF
      INTEGER      INDCO(60),NINTER,NFACE,CFACE(5,3),IBID2(12,3),CPT
      INTEGER      INTEG,NFE,SINGU
      CHARACTER*8  ELREF,TYPMA,FPG,ELC
      REAL*8       HE,SIGN,XG,FFI,FFJ,FFP(27),SAUT(3),KNP(3,3)
      REAL*8       MMAT(204,204),JAC,AL,RHON,MU,RHOTK,PADIST,MULT
      REAL*8       NDN(3,6),TAU1(3,6),TAU2(3,6),LAMB1(3),LAMB2(3)
      REAL*8       ND(3),METR(2,2),P(3,3),KN(3,3),R3(3),SEUIL(60),DDOT
      REAL*8       PTKNP(3,3),TAUKNP(2,3),TAIKTA(2,2),IK(3,3),NBARY(3)
      REAL*8       LSN,LST,R,RR,E,G(3)
C......................................................................

      CALL JEMARQ()
C
C-----------------------------------------------------------------------
C     INITIALISATIONS
C-----------------------------------------------------------------------
C 
      CALL ELREF1(ELREF)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,DDLH,NFE,SINGU,DDLC,NNOM,DDLS,NDDL)
C
C     INITIALISATION DE LA MATRICE
      CALL MATINI(204,204,0.D0,MMAT)
C
      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

      IF (NDIM .EQ. 3) THEN
         CALL CONFAC(TYPMA,IBID2,IBID,FAC,NBF)
      ELSE
         CALL CONARE(TYPMA,AR,NBAR)
      ENDIF
C
C-----------------------------------------------------------------------
C     RECUPERATION DES ENTREES / SORTIE
C-----------------------------------------------------------------------
C
      CALL JEVECH('PGEOMER','E',IGEOM)
C     DEPMOI
      CALL JEVECH('PDEPL_M','L',IDEPM)
C     DEPDEL
      CALL JEVECH('PDEPL_P','L',IDEPD)
      CALL JEVECH('PINDCOI','L',JINDCO)
      CALL JEVECH('PDONCO','L',JDONCO)
      CALL JEVECH('PSEUIL','L',JSEUIL)
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE','L',JCFACE)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASECO','L',JBASEC)

      CALL JEVECH('PMATUUR','E',IMATT)

C     RECUPERATIONS DES DONNEES SUR LE CONTACT ET
C     SUR LA TOPOLOGIE DES FACETTES
      DO 10 I=1,60
        INDCO(I) = ZI(JINDCO-1+I)
        SEUIL(I) = ZR(JSEUIL-1+I)
 10   CONTINUE
 
      RHON = ZR(JDONCO-1+1)
      MU = ZR(JDONCO-1+2)
      RHOTK = ZR(JDONCO-1+3)

      INTEG = NINT(ZR(JDONCO-1+4))
C     SCHEMA D'INTEGRATION NUMERIQUE ET ELEMENT DE REFERENCE DE CONTACT
C     DISCUSSION VOIR BOOK IV 18/10/2004 ET BOOK VI 06/07/2005
      INTEG = NINT(ZR(JDONCO-1+4))
      IF (NDIM .EQ. 3) THEN
        IF (INTEG.EQ.1) FPG='XCON'
        IF (INTEG.EQ.4) FPG='FPG4'
        IF (INTEG.EQ.6) FPG='FPG6'
        IF (INTEG.EQ.7) FPG='FPG7'
        ELC='TR3'
      ELSEIF (NDIM.EQ.2) THEN
        FPG='MASS'
        ELC='SE2'
      ENDIF
     
      NINTER=ZI(JLONCH-1+1)
      IF (NINTER.LT.NDIM) GOTO 9999 
      NFACE=ZI(JLONCH-1+2)
      DO 11 I=1,NFACE
        DO 12 J=1,NDIM
          CFACE(I,J)=ZI(JCFACE-1+NDIM*(I-1)+J)
 12      CONTINUE
 11   CONTINUE

C     RECUPERATION DU COEFFICIENT DE MISE � L'ECHELLE DES PRESSIONS
      E=ZR(JDONCO-1+5)
C
C     RECUPERATION DE LA BASE COVARIANTE AUX POINTS D'INTERSECTION
      DO 13 NLI=1,NINTER
        DO 14 J=1,NDIM
          NDN(J,NLI)  =ZR(JBASEC-1+NDIM*NDIM*(NLI-1)+J)  
          TAU1(J,NLI)=ZR(JBASEC-1+NDIM*NDIM*(NLI-1)+J+NDIM)
          IF (NDIM.EQ.3) 
     &      TAU2(J,NLI)=ZR(JBASEC-1+NDIM*NDIM*(NLI-1)+J+2*NDIM)
 14     CONTINUE
 13   CONTINUE
C    
C-----------------------------------------------------------------------
C
C     BOUCLE SUR LES FACETTES
      DO 100 IFA=1,NFACE
C
C       PETIT TRUC EN PLUS POUR LES FACES EN DOUBLE
        MULT=1.D0
        DO 101 I=1,NDIM
          NLI=CFACE(IFA,I)
          IN(I)=NINT(ZR(JAINT-1+4*(NLI-1)+2))
 101    CONTINUE
C       SI LES 2/3 SOMMETS DE LA FACETTE SONT DES NOEUDS DE L'ELEMENT
        IF (NDIM .EQ. 3) THEN
          IF (IN(1).NE.0.AND.IN(2).NE.0.AND.IN(3).NE.0) THEN
            DO 102 I=1,NBF
              CPT=0
              DO 103 INO=1,4
                IF (IN(1).EQ.FAC(I,INO).OR.IN(2).EQ.FAC(I,INO).OR.
     &            IN(3).EQ.FAC(I,INO))    CPT=CPT+1
 103          CONTINUE
              IF (CPT.EQ.3) THEN
C           	 WRITE(6,*)'MULTIPLICATION PAR 1/2'
                 MULT=0.5D0
                 GOTO 104
              ENDIF  
 102        CONTINUE
          ENDIF
        ELSEIF (NDIM .EQ. 2) THEN
          IF (IN(1).NE.0.AND.IN(2).NE.0) THEN
            DO 1021 I=1,NBAR
              CPT=0
              DO 1031 INO=1,2
                IF (IN(1).EQ.AR(I,INO).OR.IN(2).EQ.AR(I,INO))
     &          CPT=CPT+1
 1031         CONTINUE
              IF (CPT.EQ.2) THEN
                MULT=0.5D0
                GOTO 104
              ENDIF  
 1021       CONTINUE
          ENDIF
        ENDIF
 104    CONTINUE

        CALL ELREF4(ELC,FPG,IBID,NNOF,IBID,NPGF,IPOIDF,IVFF,IDFDEF,IBID)
C
C       BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
        DO 110 IPGF=1,NPGF
C
C         INDICE DE CE POINT DE GAUSS DANS INDCO
          ISSPG=NPGF*(IFA-1)+IPGF
C
C         CALCUL DE JAC (PRODUIT DU JACOBIEN ET DU POIDS)        
C         ET DES FF DE L'ELEMENT PARENT AU POINT DE GAUSS
C         ET LA NORMALE ND ORIENT�E DE ESCL -> MAIT
          IF (NDIM.EQ.3) THEN
            CALL XJACFF(ELREF,FPG,JPTINT,IFA,CFACE,IPGF,NNO,IGEOM,G,
     &                                                    JAC,FFP,ND)
          ELSEIF (NDIM.EQ.2) THEN
            CALL XJACF2(ELREF,FPG,JPTINT,IFA,CFACE,IPGF,NNO,IGEOM,
     &                                                    JAC,FFP,ND)
          ENDIF

C         NORMALE AU CENTRE DE LA FACETTE
          CALL LCINVN(NDIM,0.D0,NBARY)
          DO 122 I=1,NNOF
            NBARY(1)=NBARY(1)+NDN(1,CFACE(IFA,I))/NNOF
            NBARY(2)=NBARY(2)+NDN(2,CFACE(IFA,I))/NNOF
            IF (NDIM .EQ. 3)
     &        NBARY(3)=NBARY(3)+NDN(3,CFACE(IFA,I))/NNOF
 122      CONTINUE          

C         CALCUL DE RR = SQRT(DISTANCE AU FOND DE FISSURE)
          IF (SINGU.EQ.1) THEN
            LSN=0.D0
            LST=0.D0   
            DO 112 I=1,NNO
              LSN=LSN+ZR(JLSN-1+I)*FFP(I)
              LST=LST+ZR(JLST-1+I)*FFP(I)
 112        CONTINUE
            IF (ABS(LSN).GT.1.D-3) CALL UTMESS('A','TE0533',
     &                                    'LSN NON NUL SUR LA SURFACE.')
            R=SQRT(LSN*LSN+LST*LST)
            RR=SQRT(R)
          ENDIF

C         I) CALCUL DES MATRICES DE CONTACT
C         ..............................

          IF (OPTION.EQ.'RIGI_CONT') THEN
C
C           SI PAS DE CONTACT POUR CE PG : ON REMPLIT LA MATRICE C 
            IF (INDCO(ISSPG).EQ.0) THEN
C
              DO 120 I = 1,NNOF

                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
C               XOULA  : RENVOIE LE NUMERO DU NOEUD PORTANT CE LAMBDA
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)

                DO 121 J = 1,NNOF

                  FFJ=ZR(IVFF-1+NNOF*(IPGF-1)+J)
                  NJ=XOULA(CFACE,IFA,J,JAINT,TYPMA)
                  CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NJ,PLJ)
C
                  MMAT(PLI,PLJ) = MMAT(PLI,PLJ)
     &                     - FFJ * FFI * JAC * MULT / RHON * E * E

 121            CONTINUE
 120          CONTINUE
C
C           SI CONTACT POUR CE PG : ON REMPLIT LES MATRICES A, At ET A_U
            ELSE IF (INDCO(ISSPG).EQ.1) THEN
C
C             I.1. CALCUL DE A ET DE At
              DO 130 I = 1,NNOF

                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)

                DO 131 J = 1,NNO
                  DO 132 L = 1,DDLH
C
                    MMAT(PLI,DDLS*(J-1)+NDIM+L)=
     &              MMAT(PLI,DDLS*(J-1)+NDIM+L)+
     &              2.D0 * FFI * FFP(J) * ND(L) * JAC * MULT * E
C
                    MMAT(DDLS*(J-1)+NDIM+L,PLI)=
     &              MMAT(DDLS*(J-1)+NDIM+L,PLI)+
     &              2.D0 * FFI * FFP(J) * ND(L) * JAC * MULT * E
C
 132              CONTINUE

                  DO 133 L = 1,SINGU*NDIM
                    MMAT(PLI,DDLS*(J-1)+NDIM+DDLH+L)=
     &              MMAT(PLI,DDLS*(J-1)+NDIM+DDLH+L)+
     &              2.D0 * FFI * FFP(J) * RR * ND(L) * JAC * MULT * E

                    MMAT(DDLS*(J-1)+NDIM+DDLH+L,PLI)=
     &              MMAT(DDLS*(J-1)+NDIM+DDLH+L,PLI)+
     &              2.D0 * FFI * FFP(J) * RR * ND(L) * JAC * MULT * E

 133              CONTINUE
 
 131            CONTINUE

 130          CONTINUE
C
C             I.2. CALCUL DE A_U
              DO 140 I = 1,NNO
                DO 141 J = 1,NNO
                  DO 142 K = 1,DDLH
                    DO 143 L = 1,DDLH
C
                      MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+L)+
     &                4.D0*RHON*FFP(I)*FFP(J)*ND(K)*ND(L)*JAC*MULT
C
 143                CONTINUE
                    DO 144 L = 1,SINGU*NDIM
C
                      MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+DDLH+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+DDLH+L) +
     &                4.D0*RHON*FFP(I)*FFP(J)*RR*ND(K)*ND(L)*JAC*MULT
C
 144                CONTINUE
C 
 142              CONTINUE
 
                  DO 145 K = 1,SINGU*NDIM
                    DO 146 L = 1,DDLH
                      MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+L) +
     &                4.D0*RHON*FFP(I)*FFP(J)*RR*ND(K)*ND(L)*JAC*MULT
 146                CONTINUE
                    DO 147 L = 1,SINGU*NDIM
                     MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+DDLH+L)
     &           =   MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+DDLH+L)
     &           +   4.D0*RHON*FFP(I)*FFP(J)*RR*RR*ND(K)*ND(L)*JAC*MULT
 147                CONTINUE
 145              CONTINUE
 
 141            CONTINUE
 140          CONTINUE
C
            ELSE
C             SI INDCO N'EST NI EGAL A 0 NI EGAL A 1
              CALL UTMESS('F','TE0533','PB DE STATUT DE CONTACT') 
            END IF
C
C         II) CALCUL DES MATRICES DE FROTTEMENT
C         ..............................

          ELSEIF (OPTION.EQ.'RIGI_FROT') THEN

            IF (MU.EQ.0.D0.OR.SEUIL(ISSPG).EQ.0.D0) INDCO(ISSPG) = 0

C           SI PAS DE CONTACT POUR CE PG : ON REMPLIT QUE LA MATRICE F 
            IF (INDCO(ISSPG).EQ.0) THEN

              DO 150 I = 1,NNOF
                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                NLI=CFACE(IFA,I)
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)
                DO 151 J = 1,NNOF
                  FFJ=ZR(IVFF-1+NNOF*(IPGF-1)+J)
                  NLJ=CFACE(IFA,J)
                  NJ=XOULA(CFACE,IFA,J,JAINT,TYPMA)
                  CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NJ,PLJ)

C                 M�TRIQUE DE LA BASE COVARIANTE AUX PTS D'INTERSECT
                  METR(1,1)=DDOT(NDIM,TAU1(1,NLI),1,TAU1(1,NLJ),1)
                  IF (NDIM.EQ.3) THEN
                    METR(1,2)=DDOT(NDIM,TAU1(1,NLI),1,TAU2(1,NLJ),1)
                    METR(2,1)=DDOT(NDIM,TAU2(1,NLI),1,TAU1(1,NLJ),1)
                    METR(2,2)=DDOT(NDIM,TAU2(1,NLI),1,TAU2(1,NLJ),1)
                  ENDIF

                  DO 152 K = 1,NDIM-1
                    DO 153 L = 1,NDIM-1

                      MMAT(PLI+K,PLJ+L) = MMAT(PLI+K,PLJ+L)
     &                           + FFI * FFJ * METR(K,L) * JAC * MULT

 153                CONTINUE
 152              CONTINUE
 151            CONTINUE
 150          CONTINUE

C           SI CONTACT POUR CE PG : ON REMPLIT B, Bt, B_U et F
            ELSE IF (INDCO(ISSPG).EQ.1) THEN

C             INITIALISATIONS DES MATRICES DE TRAVAIL 3X3, EN 2D ET 3D
              CALL MATINI(3,3,0.D0,P)
              CALL MATINI(3,3,0.D0,PTKNP)
              CALL MATINI(3,3,0.D0,TAUKNP)

C             P : OP�RATEUR DE PROJECTION
              CALL XMAFR1(ND,P)

C             ON TESTE L'ETAT D'ADHERENCE DU PG (AVEC DEPDEL)
              CALL LCINVN(NDIM,0.D0,SAUT)
              CALL LCINVN(NDIM,0.D0,LAMB1)

              DO 154 INO=1,NNO
                DO 155 J=1,DDLH
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) *
     &                              ZR(IDEPD-1+DDLS*(INO-1)+NDIM+J)
 155            CONTINUE
                DO 156 J = 1,SINGU*NDIM
                  SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) * RR *
     &                              ZR(IDEPD-1+DDLS*(INO-1)+NDIM+DDLH+J)

 156            CONTINUE
 154          CONTINUE

              DO 158 I=1,NNOF
                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                NLI=CFACE(IFA,I)
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)       
                DO 159 J=1,NDIM
                  LAMB1(J)=LAMB1(J)+FFI * ZR(IDEPD-1+PLI+1)*TAU1(J,NLI)
                  IF (NDIM.EQ.3)  
     &              LAMB1(J)=LAMB1(J)+FFI*ZR(IDEPD-1+PLI+2)*TAU2(J,NLI)
 159            CONTINUE
 158          CONTINUE

              CALL XADHER(P,SAUT,LAMB1,RHOTK,R3,KN,PTKNP,IK)

              CALL PROMAT(KN,3,NDIM,NDIM,P,3,NDIM,NDIM,KNP)

C             II.1. CALCUL DE B ET DE Bt
              DO 160 I = 1,NNOF

                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                NLI=CFACE(IFA,I)
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)

C               CALCUL DE TAU.KN.P
                DO 161 J = 1,NDIM
                  TAUKNP(1,J) = 0.D0
                  DO 162 K = 1,NDIM
                    TAUKNP(1,J) = TAUKNP(1,J) + TAU1(K,NLI) * KNP(K,J)
 162              CONTINUE
 161            CONTINUE
                IF (NDIM.EQ.3) THEN
                  DO 163 J = 1,NDIM
                    TAUKNP(2,J) = 0.D0
                    DO 164 K = 1,NDIM
                      TAUKNP(2,J) = TAUKNP(2,J) + TAU2(K,NLI) * KNP(K,J)
 164                CONTINUE
 163              CONTINUE
                ENDIF

                DO 165 J = 1,NNO

                  DO 166 K = 1,NDIM-1
                    DO 167 L = 1,DDLH
C
                      MMAT(PLI+K,DDLS*(J-1)+NDIM+L) = 
     &                MMAT(PLI+K,DDLS*(J-1)+NDIM+L) +
     &              2.D0*MU*SEUIL(ISSPG)*FFI*FFP(J)*TAUKNP(K,L)*JAC*MULT
C
                      MMAT(DDLS*(J-1)+NDIM+L,PLI+K) =
     &                MMAT(DDLS*(J-1)+NDIM+L,PLI+K) +
     &              2.D0*MU*SEUIL(ISSPG)*FFI*FFP(J)*TAUKNP(K,L)*JAC*MULT
C
 167                CONTINUE
                    DO 168 L = 1,SINGU*NDIM
C
                      MMAT(PLI+K,DDLS*(J-1)+NDIM+DDLH+L) = 
     &                MMAT(PLI+K,DDLS*(J-1)+NDIM+DDLH+L) +
     &           2.D0*RR*MU*SEUIL(ISSPG)*FFI*FFP(J)*TAUKNP(K,L)*JAC*MULT
C
                      MMAT(DDLS*(J-1)+NDIM+DDLH+L,PLI+K) =
     &                MMAT(DDLS*(J-1)+NDIM+DDLH+L,PLI+K) +
     &           2.D0*RR*MU*SEUIL(ISSPG)*FFI*FFP(J)*TAUKNP(K,L)*JAC*MULT
C
 168                CONTINUE
 166              CONTINUE
 165            CONTINUE
 160          CONTINUE

C             II.2. CALCUL DE B_U
              DO 170 I = 1,NNO
                DO 171 J = 1,NNO

                  DO 172 K = 1,DDLH
                    DO 173 L = 1,DDLH
C
                      MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+L) -
     &                4.D0*MU*SEUIL(ISSPG)*RHOTK*FFP(I)*FFP(J)*
     &                                               PTKNP(K,L)*JAC*MULT
C
 173                CONTINUE
                    DO 174 L = 1,SINGU*NDIM
C
                      MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+DDLH+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+K,DDLS*(J-1)+NDIM+DDLH+L) -
     &                4.D0*RR*MU*SEUIL(ISSPG)*RHOTK*FFP(I)*FFP(J)*
     &                                               PTKNP(K,L)*JAC*MULT
C
 174                CONTINUE
 172              CONTINUE

                  DO 175 K = 1,SINGU*NDIM
                    DO 176 L = 1,DDLH
C
                      MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+L) =  
     &                MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+L) -
     &                4.D0*RR*MU*SEUIL(ISSPG)*RHOTK*FFP(I)*FFP(J)*
     &                                               PTKNP(K,L)*JAC*MULT
C
 176                CONTINUE
                    DO 177 L = 1,SINGU*NDIM
C
                     MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+DDLH+L)
     &            =  MMAT(DDLS*(I-1)+NDIM+DDLH+K,DDLS*(J-1)+NDIM+DDLH+L)
     &            -  4.D0*RR*RR*MU*SEUIL(ISSPG)*RHOTK*FFP(I)*FFP(J)*
     &                                               PTKNP(K,L)*JAC*MULT
C
 177                CONTINUE
 175              CONTINUE

 171            CONTINUE
 170          CONTINUE
C
C             II.3. CALCUL DE F
              DO 180 I = 1,NNOF
                FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
                NLI=CFACE(IFA,I)
                NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
                CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)
                DO 181 J = 1,NNOF
                  FFJ=ZR(IVFF-1+NNOF*(IPGF-1)+J)
                  NLJ=CFACE(IFA,J)
                  NJ=XOULA(CFACE,IFA,J,JAINT,TYPMA)
                  CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NJ,PLJ)

C                 CALCUL DE TAIKTA = TAUt.(Id-KN).TAU
                  CALL XMAFR2(NLI,NLJ,TAU1,TAU2,IK,TAIKTA)
      
                  DO 182 K = 1,NDIM-1
                    DO 183 L = 1,NDIM-1
                      
                      MMAT(PLI+K,PLJ+L) = MMAT(PLI+K,PLJ+L)
     &              - MU*SEUIL(ISSPG)/RHOTK*FFI*FFJ*TAIKTA(K,L)*JAC*MULT

 183                CONTINUE
 182              CONTINUE
 181            CONTINUE
 180          CONTINUE

            ELSE
C             SI INDCO N'EST NI �GAL � 0 NI �GAL � 1
              CALL UTMESS('F','TE0533','PB DE STATUT DE CONTACT') 
            END IF

          ELSE
C           SI OPTION NI 'RIGI_CONT' NI 'RIGI_FROTT'
            CALL UTMESS('F','TE0533','OPTION INCONNUE')           
          ENDIF

C         FIN DE BOUCLE SUR LES POINTS DE GAUSS
 110    CONTINUE

C       FIN DE BOUCLE SUR LES FACETTES
 100  CONTINUE
C
C-----------------------------------------------------------------------
C     COPIE DES CHAMPS DE SORITES ET FIN
C-----------------------------------------------------------------------
C 
      DO 200 J = 1,NDDL
        DO 210 I = 1,J
          IJ = (J-1)*J/2 + I
          ZR(IMATT+IJ-1) = MMAT(I,J)
 210    CONTINUE
 200  CONTINUE

 9999 CONTINUE
      CALL JEDEMA()
      END
