      SUBROUTINE TE0533(OPTION,NOMTE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_20

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

      INTEGER     I,J,IJ,IFA,IPGF,ISSPG
      INTEGER      JINDCO,JDONCO,JLSN,IPOIDS,IVF,IDFDE,JGANO,IGEOM
      INTEGER      IDEPM,IDEPD,IMATT,JLST,JPTINT,JAINT,JCFACE,JLONCH
      INTEGER     IVFF,IADZI,IAZK24,IBID,JBASEC,JSEUIL
      INTEGER      NDIM,NFH,DDLC,DDLS,NDDL,NNO,NNOS,NNOM,NNOF,DDLM
      INTEGER     NPG,NPGF,FAC(6,4),NBF,ALGOCR,ALGOFR,VSTNC(32)
      INTEGER     INDCO,NINTER,NFACE,CFACE(5,3),IBID2(12,3)
      INTEGER     NFE,SINGU,JSTNO,NVIT,JCOHEO,NCOMPV
      INTEGER     NNOL,PLA(27),LACT(8),NLACT,NPTF
      INTEGER     CONTAC,NFISS,JFISNO,JMATE,JCOHES,NBSPG,NSPFIS
      REAL*8      FFP(27),FFC(8),COEFCP,COEFCR,COEFFP
      REAL*8      MMAT(216,216),JAC,MU,COEFFR,RELA
      REAL*8       TAU1(3),TAU2(3)
      REAL*8      ND(3),SEUIL,COHES(3)
      REAL*8      RR,RBID,COHEO(3)
      INTEGER     JHEANO,IFISS,JSTNC,JHEAFA,NCOMPH
      INTEGER      JTAB(2),IRET,NCOMPD,NCOMPP,NCOMPA,NCOMPB,NCOMPC
      LOGICAL     MATSYM,LELIM
      CHARACTER*8     ELREF,ELREFC,TYPMA
      CHARACTER*8 ELC,FPG
C......................................................................

      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DO 6 I  = 1,8
        LACT(I) = 0
 6    CONTINUE
      CALL VECINI(27,0.D0,FFP)
      CALL VECINI(3,0.D0,TAU2)
      LELIM = .FALSE.
      NBSPG=0
      CALL ELREF1(ELREF)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,SINGU,DDLC,NNOM,DDLS,NDDL,
     &            DDLM,NFISS,CONTAC)
C
      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)
C
      IF (NDIM .EQ. 3) THEN
         CALL CONFAC(TYPMA,IBID2,IBID,FAC,NBF)
      ENDIF
C
C     INITIALISATION DE LA MATRICE DE TRAVAIL
      CALL MATINI(216,216,0.D0,MMAT)
C
C --- ROUTINE SPECIFIQUE P2P1, A CONSERVER
C
      CALL ELELIN(CONTAC,ELREF,ELREFC,IBID,IBID)
C
C --- RECUPERATION DES ENTREES / SORTIE
C
      CALL JEVECH('PGEOMER','L',IGEOM)
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
      IF (NFISS.GT.1) THEN
        CALL JEVECH('PFISNO','L',JFISNO)
        CALL JEVECH('PHEAVNO','L',JHEANO)
        CALL JEVECH('PHEAVFA','L',JHEAFA)
        CALL TECACH('OOO','PHEAVFA',2,JTAB,IRET)
        NCOMPH = JTAB(2)
      ENDIF
C     NB COMPOSANTES DES MODES LOCAUX 
C     ASSOCIES AUX CHAMPS DANS LE CATALOGUE
      CALL TECACH('OOO','PDONCO',2,JTAB,IRET)
      NCOMPD = JTAB(2)
      CALL TECACH('OOO','PPINTER',2,JTAB,IRET)
      NCOMPP = JTAB(2)
      CALL TECACH('OOO','PAINTER',2,JTAB,IRET)
      NCOMPA = JTAB(2)
      CALL TECACH('OOO','PBASECO',2,JTAB,IRET)
      NCOMPB = JTAB(2)
      CALL TECACH('OOO','PCFACE',2,JTAB,IRET)
      NCOMPC = JTAB(2)

C     STATUT POUR L'ÉLIMINATION DES DDLS DE CONTACT
      DO 30 I=1,MAX(1,NFH)*NNOS
        VSTNC(I) = 1
  30  CONTINUE
C
C --- BOUCLE SUR LES FISSURES
C
      DO 90 IFISS = 1,NFISS
C
C --- RECUPERATION DIVERSES DONNEES CONTACT
C
         CALL XDOCON(ALGOCR,ALGOFR,CFACE ,CONTAC,COEFCP,
     &               COEFFP,COEFCR,COEFFR,ELC   ,FPG   ,
     &               IFISS ,IVFF  ,JCFACE,JDONCO,JLONCH,
     &               MU    ,NSPFIS,NCOMPD,NDIM  ,NFACE ,
     &               NINTER,NNOF  ,NOMTE ,NPGF  ,NPTF  ,
     &               RELA)
        IF(NINTER.EQ.0) GOTO 91
C
C --- RECUPERATION MATERIAU ET VARIABLES INTERNES COHESIF
C
        IF(ALGOCR.EQ.3) THEN
          CALL JEVECH('PMATERC','L',JMATE)
          CALL JEVECH('PCOHES' ,'L',JCOHES)
          CALL TECACH('OOO','PCOHES',2,JTAB,IRET)
          NCOMPV = JTAB(2)
          IF(OPTION.EQ.'RIGI_CONT') THEN
             CALL JEVECH('PCOHESO' ,'E',JCOHEO)
          ENDIF
        ENDIF
C
C --- RECUP MULTIPLICATEURS ACTIFS ET LEURS INDICES
C
        CALL XMULCO(CONTAC,DDLC,DDLM,JAINT,IFISS,
     &              JHEANO,VSTNC,LACT,.TRUE.,LELIM,NDIM,NFE,
     &              NFH,NFISS,NINTER,NLACT,NNO,
     &              NNOL,NNOM,NNOS,PLA,TYPMA)
C
C --- BOUCLE SUR LES FACETTES
C
        DO 100 IFA=1,NFACE
C
C --- BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
C
          DO 110 IPGF=1,NPGF
C
C --- RECUPERATION DES STATUTS POUR LE POINT DE GAUSS
C
          ISSPG = NPGF*(IFA-1)+IPGF
          INDCO = ZI(JINDCO-1+NBSPG+ISSPG)
          IF(ALGOFR.NE.0) SEUIL = ZR(JSEUIL-1+NBSPG+ISSPG)
          IF(ALGOCR.EQ.3) THEN
            DO 2 I=1,NCOMPV
              COHES(I) = ZR(JCOHES+NCOMPV*(NBSPG+ISSPG-1)-1+I)
2           CONTINUE
          ENDIF
C
C --- PREPARATION DU CALCUL
C
          CALL XMPREP(CFACE ,CONTAC,ELREF ,ELREFC,ELC   ,
     &                FFC   ,FFP   ,FPG   ,JAINT ,JBASEC,
     &                JPTINT,IFA   ,IGEOM ,IPGF  ,JAC   ,
     &                JLST  ,LACT  ,ND    ,NDIM  ,NINTER,
     &                NLACT ,NNO   ,NNOS  ,NPTF  ,NVIT  ,
     &                RR    ,SINGU ,TAU1  ,TAU2)
C
C --- CALCUL DES MATRICES DE CONTACT
C     ..............................

            IF (OPTION.EQ.'RIGI_CONT') THEN
C
            CALL XMCONT(ALGOCR,COEFCR,COEFCP,COHES ,COHEO,
     &                  DDLM  ,DDLS  ,FFC   ,FFP   ,IDEPD ,IDEPM ,
     &                  IFA   ,IFISS ,ZI(JMATE) ,INDCO ,IPGF  ,
     &                  JAC   ,JFISNO,JHEAFA,MMAT  ,LACT,
     &                  NCOMPH,ND    ,NDDL  ,NDIM  ,NFH   ,
     &                  NFISS ,NNO   ,NNOL  ,NNOS  ,
     &                  NVIT,PLA   ,RELA  ,RR    ,
     &                  SINGU,TAU1,TAU2)
C
C --- ACTUALISATION VARIABLE INTERNE
C
          IF(ALGOCR.EQ.3) THEN
            DO 3 I=1,NCOMPV
             ZR(JCOHEO+NCOMPV*(NBSPG+ISSPG-1)-1+I) = COHEO(I)
3           CONTINUE
          ENDIF
C
            ELSEIF (OPTION.EQ.'RIGI_FROT'
     &              .AND.RELA.NE.3.D0.AND.RELA.NE.4.D0) THEN
C
            CALL XMFROT(ALGOFR,COEFFR,COEFFP,DDLM  ,
     &                  DDLS  ,FFC   ,FFP   ,IDEPD ,IDEPM ,
     &                  INDCO ,JAC   ,
     &                  LACT  ,MMAT  ,MU    ,ND    ,NDIM  ,
     &                  NFH   ,NFISS ,NNO   ,NNOL  ,
     &                  NNOS  ,NVIT  ,PLA   ,RR    ,
     &                  SEUIL ,SINGU ,TAU1  ,TAU2)
C
              ELSE
              CALL ASSERT(RELA.EQ.3.D0.OR.RELA.EQ.4.D0)
                ENDIF
C --- FIN DE BOUCLE SUR LES POINTS DE GAUSS
 110      CONTINUE

C --- FIN DE BOUCLE SUR LES FACETTES
 100    CONTINUE
C --- FIN BOUCLE SUR LES FISSURES : DECALAGE D INDICES
        NBSPG  = NBSPG  + NSPFIS
91      CONTINUE
        JBASEC = JBASEC + NCOMPB
        JPTINT = JPTINT + NCOMPP
        JAINT  = JAINT  + NCOMPA
        JCFACE = JCFACE + NCOMPC
  90  CONTINUE
C
C-----------------------------------------------------------------------
C     COPIE DES CHAMPS DE SORTIES ET FIN
C-----------------------------------------------------------------------
C
      IF(ALGOCR.EQ.2.OR.ALGOFR.EQ.2.OR.
     &  (ALGOCR.EQ.3.AND.OPTION.EQ.'RIGI_FROT'))THEN
C --- RECUPERATION DE LA MATRICE 'OUT' NON SYMETRIQUE
        MATSYM=.FALSE.
        CALL JEVECH('PMATUNS','E',IMATT)
        DO 201 J = 1,NDDL
          DO 211 I = 1,NDDL
            IJ = J+NDDL*(I-1)
            ZR(IMATT+IJ-1) = MMAT(I,J)
 211      CONTINUE
 201    CONTINUE
      ELSE
C --- RECUPERATION DE LA MATRICE 'OUT' SYMETRIQUE
        MATSYM=.TRUE.
        CALL JEVECH('PMATUUR','E',IMATT)
        DO 200 J = 1,NDDL
          DO 210 I = 1,J
            IJ = (J-1)*J/2 + I
            ZR(IMATT+IJ-1) = MMAT(I,J)
 210      CONTINUE
 200    CONTINUE
      ENDIF
C --- SUPPRESSION DES DDLS DE DEPLACEMENT SEULEMENT POUR LES XHTC
      IF (NFH.NE.0) THEN
        CALL JEVECH('PSTANO' ,'L',JSTNO)
        CALL XTEDDL(NDIM,NFH,NFE,DDLS,NDDL,NNO,NNOS,ZI(JSTNO),
     &              .FALSE.,MATSYM,OPTION,NOMTE,ZR(IMATT),RBID,DDLM,
     &              NFISS,JFISNO)
      ENDIF
C --- SUPPRESSION DES DDLS DE CONTACT
      IF (LELIM) THEN
        CALL XTEDDL(NDIM,NFH,NFE,DDLS,NDDL,NNO,NNOS,VSTNC,
     &              .TRUE.,MATSYM,OPTION,NOMTE,ZR(IMATT),RBID,DDLM,
     &              NFISS,JFISNO)
      ENDIF
C
      CALL JEDEMA()
      END
