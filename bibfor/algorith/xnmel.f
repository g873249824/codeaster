      SUBROUTINE  XNMEL(POUM,NNOP,NFH,NFE,DDLC,DDLM,IGEOM,
     &                  TYPMOD,OPTION,IMATE,COMPOR,LGPG,
     &                  CRIT,JPINTT,CNSET,HEAVT,LONCH,
     &                  BASLOC,IDEPL,LSN,LST,SIG,VI,
     &                  MATUU,IVECTU,CODRET,JPMILT,NFISS,JFISNO)

       IMPLICIT NONE
      INCLUDE 'jeveux.h'
       INTEGER      NNOP,IMATE,LGPG,CODRET,IGEOM,NFISS,JFISNO
       INTEGER      CNSET(4*32),HEAVT(*),LONCH(10),NDIM
       INTEGER      NFH,NFE,DDLC,DDLM
       INTEGER      IVECTU,IDEPL,JPINTT,JPMILT
       CHARACTER*(*) POUM
       CHARACTER*8  TYPMOD(*)
       CHARACTER*16 OPTION,COMPOR(4)
       REAL*8       CRIT(3),VI(*)
       REAL*8       LSN(NNOP)
       REAL*8       LST(NNOP),MATUU(*),SIG(*),BASLOC(*)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_21 CRS_1404
C
C
C
C
C
C.......................................................................
C
C     BUT:  PRÉLIMINAIRES AU CALCUL DES OPTIONS RIGI_MECA_TANG,
C           RAPH_MECA ET FULL_MECA  EN HYPER-ELASTICITE AVEC X-FEM
C.......................................................................
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  IVF     : VALEUR  DES FONCTIONS DE FORME
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  DDLM    : NOMBRE DE DDL PAR NOEUD MILIEU
C IN  IGEOM   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  NOMTE   : NOM DU TE
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG  : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C              CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  PINTT   : COORDONNÉES DES POINTS D'INTERSECTION
C IN  CNSET   : CONNECTIVITE DES SOUS-ELEMENTS
C IN  HEAVT   : VALEURS DE L'HEAVISIDE SUR LES SS-ELTS
C IN  LONCH   : LONGUEURS DES CHAMPS UTILISÉES
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE
C IN  IDEPL   : DEPLACEMENT A PARTIR DE LA CONF DE REF
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C IN  PMILT   : COORDONNEES DES POINTS MILIEUX
C IN  NFISS   : NOMBRE DE FISSURES "VUES" PAR L'ÉLÉMENT
C IN  JFISNO  : POINTEUR DE CONNECTIVITÉ FISSURE/HEAVISIDE
C
C OUT SIG     : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT IVECTU  : VECTEUR FORCES NODALES (RAPH_MECA ET FULL_MECA)
C..............................................................
C----------------------------------------------------------------
      CHARACTER*8   ELREFP,ELRESE(6),FAMI(6)
      REAL*8        HE(NFISS),R8BID,COORSE(81)
      INTEGER       NSE,NPG,NBSIGM
      INTEGER       J,ISE,IN,INO,IDEBS,IDEBV
      INTEGER       IBID,IDECPG,NBSIG,IG,IFISS
      INTEGER       IRESE,NNO,FISNO(NNOP,NFISS),JTAB(2),NCOMP,IRET
      LOGICAL       ISELLI

      DATA    ELRESE /'SE2','TR3','TE4','SE3','TR6','TE4'/
      DATA    FAMI   /'BID','XINT','XINT','BID','XINT','XINT'/


C     ATTENTION, DEPL ET VECTU SONT ICI DIMENSIONNÉS DE TELLE SORTE
C     QU'ILS NE PRENNENT PAS EN COMPTE LES DDL SUR LES NOEUDS MILIEU

      CALL ELREF1(ELREFP)

C     NOMBRE DE COMPOSANTES DE PHEAVTO (DANS LE CATALOGUE)
      CALL TECACH('OOO','PHEAVTO',2,JTAB,IRET)
      NCOMP = JTAB(2)

C     ELEMENT DE REFERENCE PARENT : RECUP DE NDIM
      CALL ELREF4(' ','RIGI',NDIM,IBID,IBID,IBID,IBID,IBID,IBID,IBID)

C     SOUS-ELEMENT DE REFERENCE : RECUP DE NPG
      IF (.NOT.ISELLI(ELREFP).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF
      CALL ELREF5(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),IBID,NNO,IBID,
     &           NPG,IBID,IBID,IBID,IBID,IBID,IBID)

C     NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
      NBSIG = NBSIGM()

C     RECUPERATION DE LA CONNECTIVITÉ FISSURE - DDL HEAVISIDES
C     ATTENTION !!! FISNO PEUT ETRE SURDIMENTIONNÉ
      IF (NFISS.EQ.1) THEN
        DO 30 INO = 1, NNOP
          FISNO(INO,1) = 1
  30    CONTINUE
      ELSE
        DO 10 IG = 1, NFH
C    ON REMPLIT JUSQU'A NFH <= NFISS
          DO 20 INO = 1, NNOP
            FISNO(INO,IG) = ZI(JFISNO-1+(INO-1)*NFH+IG)
  20      CONTINUE
  10    CONTINUE
      ENDIF

C     RÉCUPÉRATION DE LA SUBDIVISION DE L'ÉLÉMENT EN NSE SOUS ELEMENT
      NSE=LONCH(1)

C       BOUCLE D'INTEGRATION SUR LES NSE SOUS-ELEMENTS
      DO 110 ISE=1,NSE

C       BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
        DO 111 IN=1,NNO
          INO=CNSET(NNO*(ISE-1)+IN)
          DO 112 J=1,NDIM
            IF (INO.LT.1000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
            ELSEIF (INO.GT.1000 .AND. INO.LT.2000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPINTT-1+NDIM*(INO-1000-1)+J)
            ELSEIF (INO.GT.2000 .AND. INO.LT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-2000-1)+J)
            ELSEIF (INO.GT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-3000-1)+J)
            ENDIF
 112      CONTINUE
 111    CONTINUE

C       FONCTION HEAVYSIDE CSTE POUR CHAQUE FISSURE SUR LE SS-ELT
        DO 113 IFISS = 1,NFISS
          HE(IFISS) = HEAVT(NCOMP*(IFISS-1)+ISE)
  113   CONTINUE

C       DEBUT DE LA ZONE MEMOIRE DE SIG ET VI CORRESPONDANTE
        IDECPG = NPG   * (ISE-1)
        IDEBS  = NBSIG *   IDECPG
        IDEBV  = LGPG  *   IDECPG

        IF (NDIM .EQ. 3) THEN

          CALL ASSERT(NBSIG.EQ.6)
          IF (OPTION.EQ.'RIGI_MECA') THEN
            CALL XNMEL3(POUM,ELREFP,NDIM,COORSE,
     &                  IGEOM,HE,NFH,DDLC,DDLM,
     &                  NFE,BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,
     &                  COMPOR,LGPG,R8BID,IBID,LSN,LST,IDECPG,
     &                  R8BID,R8BID,MATUU,IBID,CODRET,NFISS,FISNO)
          ELSEIF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &            OPTION(1:9).EQ.'FULL_MECA' .OR.
     &            OPTION(1:10).EQ.'RIGI_MECA_')  THEN
            CALL XNMEL3(POUM,ELREFP,NDIM,COORSE,
     &                  IGEOM,HE,NFH,DDLC,DDLM,
     &                  NFE,BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,
     &                  COMPOR,LGPG,CRIT,IDEPL,LSN,LST,IDECPG,
     &                  SIG(IDEBS+1),VI(IDEBV+1),MATUU,IVECTU,
     &                  CODRET,NFISS,FISNO)
          ENDIF
        ELSEIF (NDIM.EQ.2) THEN

          CALL ASSERT(NBSIG.EQ.4)

          IF (OPTION.EQ.'RIGI_MECA') THEN
            CALL XNMEL2(POUM,ELREFP,ELRESE(NDIM+IRESE),NDIM,COORSE,
     &                  IGEOM,HE,NFH,DDLC,DDLM,
     &                  NFE,BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,
     &                  COMPOR,LGPG,R8BID,IBID,LSN,LST,IDECPG,
     &                  R8BID,R8BID,MATUU,IBID,CODRET,
     &                  NFISS,FISNO)

          ELSEIF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &            OPTION(1:9).EQ.'FULL_MECA' .OR.
     &            OPTION(1:10).EQ.'RIGI_MECA_')  THEN


            CALL XNMEL2(POUM,ELREFP,ELRESE(NDIM+IRESE),NDIM,COORSE,
     &                  IGEOM,HE,NFH,DDLC,DDLM,
     &                  NFE,BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,
     &                  COMPOR,LGPG,CRIT,IDEPL,LSN,LST,IDECPG,
     &                  SIG(IDEBS+1),VI(IDEBV+1),MATUU,IVECTU,CODRET,
     &                  NFISS,FISNO)
          ENDIF
        ENDIF


 110  CONTINUE

      END
