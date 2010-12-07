      SUBROUTINE TE0382(OPTION,NOMTE)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE DELMAS J.DELMAS
C TOLE CRP_20
C
C     BUT:
C         CALCUL DE L'INDICATEUR D'ERREUR SUR UN ELEMENT 2D
C         POUR L'ELEMENT XFEM COURANT AVEC LA METHODE
C         DES RESIDUS EXPLICITES.
C         OPTION : 'ERME_ELEM'
C
C REMARQUE : LES PROGRAMMES SUIVANTS DOIVENT RESTER TRES SIMILAIRES
C            TE0368, TE0375, TE0377, TE0378, TE0382, TE0497
C
C ......................................................................
C CORPS DU PROGRAMME
      IMPLICIT NONE
C
C DECLARATION PARAMETRES D'APPELS
      CHARACTER*16 OPTION,NOMTE
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32 JEXNUM
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER NBNASE,NBNAMX
C     SOUS-ELEMENTS TOUJOURS LINEAIRES => ON A TOUJOURS NBNASE=2
      PARAMETER (NBNASE=2)
C     ON DIMENSIONNE LES VECTEURS POUR LE NBRE MAX DE NOEUDS PAR ARETE
C     (CAS D'1 ELEMENT PARENT QUADRATIQUE) => NBNAMX=3
      PARAMETER (NBNAMX=3)

      INTEGER IFM,NIV
      INTEGER IADZI,IAZK24
      INTEGER IBID,IAUX,IRET,ITAB(7),ITABID(9,6,4)
      INTEGER IGEOM,JTIME
      INTEGER IERR, IVOIS
      INTEGER IMATE
      INTEGER IREF1,IREF2
      INTEGER NDIM
      INTEGER NNO,NPG,IDFDE,JGANO
      INTEGER NBCMP
      INTEGER TYV
      INTEGER NPGP,NNOP,NNOSP,IPOIDP,IVFP
      INTEGER ISIGNO
      INTEGER NBS,JCOORS,IDFSE
      INTEGER INP
      INTEGER INO,NBSIGM,NBNAPA
      INTEGER JPINTT,JCNSET,JLONCH,JVOXSE,JSIGSE,JPMILT
      INTEGER NIT,NSE,IT,ISE,CPT,IN,J,IPG
      INTEGER LEVOIS
      INTEGER IER,IRESE

      REAL*8 R8BID,RTBID3(3)
      REAL*8 DFDXP(9),DFDYP(9),POIDP,HE,HSE,HF,COEFF
      REAL*8 SG11(NBNAMX),SG22(NBNAMX),SG12(NBNAMX),JACO(NBNAMX)
      REAL*8 NX(NBNAMX),NY(NBNAMX),TX(NBNAMX),TY(NBNAMX)
      REAL*8 CHX(NBNAMX),CHY(NBNAMX)
      REAL*8 INST,INTE,ORIEN
      REAL*8 SIG11(NBNAMX),SIG22(NBNAMX),SIG12(NBNAMX)
      REAL*8 TVOL,TVOLSE,TSAU,TNOR,NOR,NORSIG,SIGCAL
      REAL*8 E,NU,VALRES(2),R8TMP

      CHARACTER*2 CODRET(2)
      CHARACTER*2 NOEU
      CHARACTER*3 TYPNOR
      CHARACTER*8 TYPMAV, ELREFE
      CHARACTER*8 FAMI(6),ELRESE(6)
      CHARACTER*8 NOMPAR(2)
      CHARACTER*8 ENR
      CHARACTER*16 PHENOM,BLAN16,NOMTSE
      CHARACTER*24 COORSE
      CHARACTER*24 VALK(2)

      LOGICAL ISMALI

      DATA    ELRESE /'SE2','TR3','TE4','SE3','TR6','TE4'/
      DATA    FAMI   /'BID','XINT','XINT','BID','XINT','XINT'/
C
C ----------------------------------------------------------------------
C ----- NORME CALCULEE : SEMI-H1 (H1) ou ENERGIE (NRJ) -----------------
C ----------------------------------------------------------------------
C
      DATA TYPNOR / 'NRJ' /
C
C ----------------------------------------------------------------------
C 1 -------------- GESTION DES DONNEES ---------------------------------
C ----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

C 1.1. --- LES INCONTOURNABLES
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVOISIN','L',IVOIS)
      CALL JEVECH('PTEMPSR','L',JTIME)
      INST=ZR(JTIME-1+1)
C
      CALL JEVECH('PERREUR','E',IERR)

C 1.2. --- LES CARACTERISTIQUES DE LA MAILLE EN COURS
      CALL TECAEL(IADZI,IAZK24)
      VALK(1)=ZK24(IAZK24-1+3)
      VALK(2)=OPTION

      CALL ELREF1(ELREFE)

      IF ( NIV.GE.2 ) THEN
      WRITE(IFM,*) ' '
      WRITE(IFM,*) '================================================='
      WRITE(IFM,*) ' '
      WRITE(IFM,*) 'MAILLE NUMERO', ZI(IADZI),', DE TYPE ', ELREFE
      ENDIF
C
C --- ELEMENT PARENT DE REFERENCE : RECUP DE NNO, NPG ET IDFDE
C
      CALL ELREF4(' ','RIGI',NDIM,NNOP,NNOSP,NPGP,IPOIDP,IVFP,IDFDE,
     &            JGANO)
C
C     !!! ATTENTION !!! LA VALEUR DE NOMTSE EST UTILISEE POUR DEFINIR
C     LE "TYPE" DU SOUS-ELEMENT AFIN DE CALCULER SA TAILLE AVEC LA
C     ROUTINE UTHK(), DANS LAQUELLE UN TEST EST REALISE SUR NOMTSE(5:6)
C     2D => SOUS ELEMENTS SONT DES TRIANGLES
C             0123456789012345
      BLAN16='                '
      NOMTSE=BLAN16
C                   123456
      NOMTSE(1:6)= '    TR'
C
C --- SOUS-ELEMENT DE REFERENCE : RECUP DE NNO, NPG ET IDFSE
C
      IF (.NOT.ISMALI(ELREFE).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF
C
      CALL ELREF4(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),IBID,NNO,IBID,NPG,
     &     IBID,IBID,IDFSE,IBID)
C
C --- RECUPERATION DES CHAMPS IN "CLASSIQUES"
C
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PFORCE','L',IREF1)
      CALL JEVECH('PPRESS','L',IREF2)
      CALL TECACH('OOO','PCONTNO',3,ITAB,IRET)
      ISIGNO=ITAB(1)
      NBCMP=NBSIGM()
C
C --- RECUPERATION DES CHAMPS IN "XFEM"
C
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PCVOISX','L',JVOXSE)
      CALL JEVECH('PSIEFSER','L',JSIGSE)
C     PROPRE AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
      CALL TEATTR (NOMTE,'S','XFEM',ENR,IBID)
      IF (IBID.EQ.0 .AND.(ENR.EQ.'XH'.OR.ENR.EQ.'XHC').AND. NDIM.LE.2)
     &  CALL JEVECH('PPMILTO','L',JPMILT)
C
C ----------------------------------------------------------------------
C ----------------------------- PREALABLES -----------------------------
C ----------------------------------------------------------------------
C
C --- INITIALISATION DES TERMES VOLUMIQUE, DE SAUT ET NORMAL
C
      TVOL=0.D0
      TSAU=0.D0
      TNOR=0.D0
C
C --- CALCUL DU DIAMETRE DE L'ELEMENT PARENT
C
      CALL UTHK(NOMTE,IGEOM,HE,NDIM,ITAB,IBID,IBID,IBID,NIV,IFM)
C
C --- CALCUL DE LA NORME DE SIGMA
C
      NORSIG = 0.D0
C
      DO 100 , IPG=1,NPGP
C
C ----- CALCUL DES DERIVEES DES FONCTIONS DE FORMES /X ET /Y
C
        CALL DFDM2D (NNO,IPG,IPOIDP,IDFDE,ZR(IGEOM),DFDXP,DFDYP,POIDP)
C
C ----- CALCUL DE LA DIVERGENCE (INUTILISEE ICI) ET DE LANORME DE SIGMA
C
        IAUX=IVFP+(IPG-1)*NNOP
        IBID = 1
        CALL ERMEV2(NNOP,IGEOM,ZR(IAUX),ISIGNO,NBCMP,DFDXP,DFDYP,
     &              POIDP,IBID,
     &              R8BID,R8BID,NOR)

        NORSIG=NORSIG+NOR*POIDP

 100  CONTINUE
C
C ----------------------------------------------------------------------
C ------------ BOUCLE SUR LES COTES DE L'ELEMENT PARENT : --------------
C ------------ CALCUL DU TERME DE BORD SUR CHAQUE COTE    --------------
C ----------------------------------------------------------------------
C
C     NBS : NOMBRE DE NOEUDS SOMMETS PAR ARETE POUR L'ELEMENT PARENT
      IF(ELREFE(1:2).EQ.'TR')THEN
        NBS=3
      ELSE
        NBS=4
      ENDIF
C
C     NBNAPA : NBRE DE NOEUDS PAR ARETE POUR L'ELEMENT PARENT
      NOEU=ELREFE(3:3)
      IF (NOEU.EQ.'3'.OR.NOEU.EQ.'4') THEN
        NBNAPA=2
        ELSE
        NBNAPA=3
      ENDIF
C
C --- CALCUL DE L'ORIENTATION DE LA MAILLE
C
      CALL UTJAC(.TRUE.,IGEOM,1,IDFDE,0,IBID,NNOP,ORIEN)
C
C --- BOUCLE SUR LES COTES DU PARENT
C
      DO 200 , INP=1,NBS
C
C ----- TYPE DU DU VOISIN
C
        TYV=ZI(IVOIS+7+INP)
C
        IF ( TYV.NE.0 ) THEN
C
C ------- RECUPERATION DU TYPE DE LA MAILLE VOISINE
C
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',TYV),TYPMAV)
C
C ------- CALCUL DE : NORMALE, TANGENTE, ET JACOBIEN
C
          IAUX = INP
          CALL CALNOR ( '2D' , IGEOM,
     &                  IAUX, NBS, NBNAPA, ORIEN,
     &                  IBID, IBID, ITABID, IBID, IBID, IBID,
     &                  JACO, NX, NY, RTBID3,
     &                  TX, TY, HF )
C
C ------- SI L'ARETE N'EST PAS SUR LA FRONTIERE DE LA STRUCTURE...
C ------- ON CALCULE LE TERME DE SAUT POUR LES ELEMENTS PARENTS
C
          IF (TYPMAV(1:4).EQ.'TRIA'.OR.
     &        TYPMAV(1:4).EQ.'QUAD') THEN
C
C --------- CALCUL DU SAUT DE CONTRAINTES
C
            CALL ERMES2(INP,ELREFE,TYPMAV,IREF1,IVOIS,ISIGNO,
     &                  NBCMP,SG11,SG22,SG12)
C
C --------- CALCUL DE L'INTEGRALE SUR LE BORD
C
            CALL R8INIR(NBNAMX,0.D0,CHX,1)
            CALL R8INIR(NBNAMX,0.D0,CHY,1)
            CALL INTENC(NBNAPA,JACO,CHX,CHY,SG11,SG22,SG12,NX,NY,INTE)
C
C --------- ACTUALISATION DU TERME DE BORD
C
            IF (TYPNOR.EQ.'NRJ') THEN
              TSAU=TSAU+0.5D0*HF*INTE
            ELSE 
              TSAU=TSAU+0.5D0*SQRT(HF)*SQRT(INTE)
            ENDIF                
C
C ------- SI L'ARETE EST SUR LA FRONTIERE DE LA STRUCTURE...
C ------- ON CALCULE LE TERME NORMAL POUR LES ELEMENTS PARENTS
C
          ELSE IF (TYPMAV(1:2).EQ.'SE') THEN
C
C --------- CALCUL DES EFFORTS SURFACIQUES ET CONTRAINTES SI NEUMANN,
C --------- SINON -> EFFORTS=0 (ERMEB2)
C
            CALL ERMEB2(INP,IREF1,IREF2,IVOIS,IGEOM,ISIGNO,ELREFE,
     &                  NBCMP,INST,NX,NY,TX,TY,SIG11,SIG22,SIG12,
     &                  CHX,CHY)
C
C --------- CALCUL DE L'INTEGRALE DE BORD
C
            CALL INTENC(NBNAPA,JACO,CHX,CHY,SIG11,SIG22,SIG12,
     &                  NX,NY,INTE)
C
C --------- ACTUALISATION DU TERME DE BORD
C
            IF (TYPNOR.EQ.'NRJ') THEN
              TNOR=TNOR+HF*INTE
            ELSE 
              TNOR=TNOR+SQRT(HF)*SQRT(INTE)
            ENDIF                
C
C ----------------------------------------------------------------------
C --------------- CURIEUX ----------------------------------------------
C ----------------------------------------------------------------------
C
          ELSE
C
            VALK(1)=TYPMAV(1:4)
            CALL U2MESK('F','INDICATEUR_10',1,VALK)
C
          END IF
C
        END IF
C
 200  CONTINUE
C
C ----------------------------------------------------------------------
C ---------- FIN BOUCLE SUR LES COTES DE L'ELEMENT PARENT  -------------
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C ------------------- BOUCLE SUR LES SOUS ELEMENTS ---------------------
C ----------------------------------------------------------------------
C
C --- INITIALISATION DU N� DE SS-ELEMENT COURANT
C
      CPT=0
C
C --- RECUPERATION DU DECOUPAGE EN NIT SIMPLEXES
C
      NIT=ZI(JLONCH-1+1)
C
C --- BOUCLE SUR LES NIT SIMPLEXES
C
      DO 300 IT=1,NIT
C
C ----- RECUPERATION DU DECOUPAGE EN NSE SOUS-ELEMENTS
C
        NSE=ZI(JLONCH-1+1+IT)
C
C ----- BOUCLE SUR LES NSE SOUS-ELEMENTS
C
        DO 310 ISE=1,NSE
C
          CPT=CPT+1
C
C ------- CALCUL DES COORDONNEES DES NOEUDS ET ECRITURE DANS ZR()
C
          COORSE='&&TE0288.COORSE'
          CALL WKVECT(COORSE,'V V R',NDIM*NNO,JCOORS)
C
C ------- BOUCLE SUR LES 3 SOMMETS DU SOUS-ELEMENT
C
          DO 311 IN=1,NNO
            INO=ZI(JCNSET-1+NNO*(CPT-1)+IN)
            DO 312 J=1,NDIM
              IF (INO.LT.1000) THEN
                ZR(JCOORS-1+NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
              ELSEIF (INO.GT.1000 .AND. INO.LT.2000) THEN
                ZR(JCOORS-1+NDIM*(IN-1)+J)=
     &                               ZR(JPINTT-1+NDIM*(INO-1000-1)+J)
              ELSEIF (INO.GT.2000 .AND. INO.LT.3000) THEN
                ZR(JCOORS-1+NDIM*(IN-1)+J)=
     &                               ZR(JPMILT-1+NDIM*(INO-2000-1)+J)
              ELSEIF (INO.GT.3000) THEN
                ZR(JCOORS-1+NDIM*(IN-1)+J)=
     &                               ZR(JPMILT-1+NDIM*(INO-3000-1)+J)
              ENDIF
 312        CONTINUE
 311      CONTINUE
C
C ------- CALCUL DE LA TAILLE DU SOUS-ELEMENT
C
          CALL UTHK(NOMTSE,JCOORS,HSE,NDIM,ITAB,IBID,IBID,IBID,NIV,IFM)
C
C ------- CALCUL DE L'ORIENTATION DU SOUS-ELEMENT
C
          CALL UTJAC(.TRUE.,JCOORS,1,IDFSE,0,IBID,NNO,ORIEN)
C
C ------------------- CALCUL DU TERME VOLUMIQUE -----------------------
C
          TVOLSE=0.D0
          CALL XRMEV2(CPT,NPG,NDIM,IGEOM,JSIGSE,COORSE,TVOLSE)
C
          IF (TYPNOR.EQ.'NRJ') THEN
            TVOL=TVOL+TVOLSE*HSE**2
          ELSE 
            TVOL=TVOL+SQRT(TVOLSE)*HSE
          ENDIF                
C
C ----------------------------------------------------------------------
C --------------- BOUCLE SUR LES ARETES DU SOUS-ELEMENT ----------------
C ----------------------------------------------------------------------
C
          DO 314 IN=1,NNO
C
            LEVOIS=ZI(JVOXSE-1+NNO*(CPT-1)+IN)
C
C --------- PRESENCE OU NON D'UN VOISIN DE L'AUTRE COTE DE L'ARETE
C
            IF(LEVOIS.NE.0) THEN
C
C ----------- CALCUL DE NORMALES, TANGENTES ET JACOBIENS
C
              IAUX = IN
              CALL CALNOR('2D',JCOORS,
     &                    IAUX,NNO,NBNASE,ORIEN,
     &                    IBID,IBID,ITABID,IBID,IBID,IBID,
     &                    JACO,NX,NY,RTBID3,
     &                    TX,TY,HF)
C
C ----------- CALCUL DU SAUT DE CONTRAINTES AUX NOEUDS S-E/VOISIN
C ----------- (EQUIVALENT XFEM DE ERMES2)
C
              CALL XRMES2(NDIM,NBNASE,CPT,IN,LEVOIS,JSIGSE,NNO,NBCMP,
     &                    JCNSET,SG11,SG22,SG12)
C
C ----------- CALCUL DE L'INTEGRALE SUR L'ARETE
C
              CALL R8INIR(NBNASE,0.D0,CHX,1)
              CALL R8INIR(NBNASE,0.D0,CHY,1)
C             ATTENTION, NBNASE=2 ALORS QUE DS INTENC TOUS LES ARGUMENTS
C             D'ENTREE SONT DIMENSIONNES A 3, MAIS CA NA POSE PAS DE PB
              CALL INTENC(NBNASE,JACO,CHX,CHY,SG11,SG22,SG12,NX,NY,INTE)
C
C ----------- ACTUALISATION DU TERME DE BORD
C
              IF (TYPNOR.EQ.'NRJ') THEN
                TSAU=TSAU+0.5D0*HF*INTE
              ELSE 
                TSAU=TSAU+0.5D0*SQRT(HF)*SQRT(INTE)
              ENDIF                
C
            END IF
C
 314      CONTINUE
C
C ----------------------------------------------------------------------
C ----------- FIN BOUCLE SUR LES ARETES DU SOUS-ELEMENT ----------------
C ----------------------------------------------------------------------
C
          CALL JEDETR(COORSE)

 310    CONTINUE

 300  CONTINUE
C
C ----------------------------------------------------------------------
C ------------------ FIN BOUCLE SUR LES SOUS ELEMENTS  -----------------
C ----------------------------------------------------------------------
C
C     ATTENTION, NBNAPA=2 EN LINEAIRE, NBNAPA=3 EN QUADRATIQUE
C
      IF (NBNAPA.EQ.3) THEN
        COEFF=SQRT(96.D0)
      ELSE
        COEFF=SQRT(24.D0)
      ENDIF

      IF (TYPNOR.EQ.'NRJ') THEN

        NOMPAR(1)='E'
        NOMPAR(2)='NU'
        CALL RCCOMA (ZI(IMATE),'ELAS',PHENOM,CODRET)
        CALL RCVALA (ZI(IMATE),' ',PHENOM,1,' ',R8BID,2,NOMPAR,
     &               VALRES,CODRET,'FM')
        E =VALRES(1)
        NU=VALRES(2)

        IF (NBNAPA.EQ.3) THEN
          COEFF=SQRT(96.D0*E/(1-NU))
        ELSE
          COEFF=SQRT(24.D0*E/(1-NU))
        ENDIF
C
        R8TMP=SQRT(TVOL+TNOR+TSAU)/COEFF
        SIGCAL=SQRT(NORSIG)
        ZR(IERR-1+1)=R8TMP
        ZR(IERR-1+2)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
        ZR(IERR-1+3)=SIGCAL
C
        R8TMP=SQRT(TVOL)/COEFF
        ZR(IERR-1+4)=R8TMP
        ZR(IERR-1+5)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
        R8TMP=SQRT(TNOR)/COEFF
        ZR(IERR-1+6)=R8TMP
        ZR(IERR-1+7)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
        R8TMP=SQRT(TSAU)/COEFF
        ZR(IERR-1+8)=SQRT(TSAU)/COEFF
        ZR(IERR-1+9)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
      ELSE
C
        R8TMP=(TVOL+TNOR+TSAU)/COEFF
        SIGCAL=SQRT(NORSIG)
        ZR(IERR-1+1)=R8TMP
        ZR(IERR-1+2)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
        ZR(IERR-1+3)=SIGCAL
C
        R8TMP=TVOL/COEFF
        ZR(IERR-1+4)=R8TMP
        ZR(IERR-1+5)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
        R8TMP=TNOR/COEFF
        ZR(IERR-1+6)=R8TMP
        ZR(IERR-1+7)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
        R8TMP=TSAU/COEFF
        ZR(IERR-1+8)=R8TMP
        ZR(IERR-1+9)=100.D0*SQRT(R8TMP**2/(R8TMP**2+NORSIG))
C
      END IF

      ZR(IERR-1+10)=HE

      CALL JEDEMA()

      END
