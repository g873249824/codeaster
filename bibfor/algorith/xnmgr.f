      SUBROUTINE  XNMGR(NNOP,NFH,NFE,DDLC,DDLM,IGEOM,
     &                  INSTAM,INSTAP,IDEPLP,SIGM,VIP,
     &                  TYPMOD,OPTION,IMATE,COMPOR,LGPG,CRIT,
     &                  JPINTT,CNSET,HEAVT,LONCH,BASLOC,IDEPL,
     &                  LSN,LST,NFISS,JFISNO,
     &                  SIG,VI,MATUU,IVECTU,CODRET,JPMILT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/03/2012   AUTEUR SIAVELIS M.SIAVELIS 
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
C RESPONSABLE MASSIN P.MASSIN
C TOLE CRP_21 CRS_1404
C
C.......................................................................
C
C     BUT:  PRÉLIMINAIRES AU CALCUL DES OPTIONS RIGI_MECA_TANG,
C           RAPH_MECA ET FULL_MECA
C           EN GRANDE ROTATION ET PETITE DEFORMATION AVEC X-FEM EN 2D
C
C     TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C.......................................................................
C
       IMPLICIT NONE
       INTEGER      NNOP,IMATE,LGPG,CODRET,IGEOM,NFISS,JFISNO
       INTEGER      CNSET(4*32),HEAVT(36*NFISS),LONCH(10),NDIM
       INTEGER      NFH,NFE,DDLC,DDLM
       INTEGER      JPINTT,JPMILT,IDEPL,IVECTU,IDEPLP
       CHARACTER*8  TYPMOD(*)
       CHARACTER*16 OPTION,COMPOR(4)
       REAL*8       CRIT(3),VI(*)
       REAL*8       LSN(NNOP)
       REAL*8       LST(NNOP),MATUU(*),SIG(*),BASLOC(*)
       REAL*8       INSTAM,INSTAP,SIGM(*),VIP(*)
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER  ZI
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  IGEOM   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
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
C IN  DEPL    : DEPLACEMENT A PARTIR DE LA CONF DE REF
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C IN  NFISS   : NOMBRE DE FISSURES "VUES" PAR L'ÉLÉMENT
C IN  JFISNO  : POINTEUR DE CONNECTIVITÉ FISSURE/HEAVISIDE
C
C OUT SIG     : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
C..............................................................
C----------------------------------------------------------------
      CHARACTER*8   ELREFP,ELRESE(6),FAMI(6)
      REAL*8        HE(NFISS),COORSE(81)
      INTEGER       NSE,NPG,JTAB(2),NCOMP,IRET
      INTEGER       ISE,IN,J,INO,IDEBS,IDEBV
      INTEGER       IBID,NBSIG,NBSIGM,IDECPG,IG,IFISS,FISNO(NNOP,NFISS)
      INTEGER       IRESE,NNO
      LOGICAL       ISMALI
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
      IF (.NOT.ISMALI(ELREFP).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF
      CALL ELREF5(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),IBID,NNO,IBID,NPG,
     &            IBID,IBID,IBID,IBID,IBID,IBID)

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

        DO 112 IN=1,NNO
          INO=CNSET(NNO*(ISE-1)+IN)
          DO 113 J=1,NDIM
            IF (INO.LT.1000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
            ELSEIF (INO.GT.1000 .AND. INO.LT.2000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPINTT-1+NDIM*(INO-1000-1)+J)
            ELSEIF (INO.GT.2000 .AND. INO.LT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-2000-1)+J)
            ELSEIF (INO.GT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-3000-1)+J)
            ENDIF
 113      CONTINUE
 112    CONTINUE

C       FONCTION HEAVYSIDE CSTE POUR CHAQUE FISSURE SUR LE SS-ELT
        DO 114 IFISS = 1,NFISS
          HE(IFISS) = HEAVT(NCOMP*(IFISS-1)+ISE)
  114   CONTINUE

C       DEBUT DE LA ZONE MEMOIRE DE SIG ET VI CORRESPONDANTE
        IDECPG = NPG   * (ISE-1)
        IDEBS  = NBSIG *   IDECPG
        IDEBV  = LGPG  *   IDECPG

        IF (NDIM .EQ. 3) THEN

          CALL ASSERT(NBSIG.EQ.6)
          CALL XNMGR3(ELREFP,NDIM,COORSE,IGEOM,HE,NFH,DDLC,NFE,
     &                  INSTAM,INSTAP,ZR(IDEPLP),SIGM(IDEBS+1),
     &                  VIP(IDEBV+1),BASLOC,NNOP,NPG,TYPMOD,OPTION,
     &                  IMATE,COMPOR,LGPG,CRIT,ZR(IDEPL),LSN,LST,IDECPG,
     &                  NFISS,FISNO,SIG(IDEBS+1),VI(IDEBV+1),MATUU,
     &                  ZR(IVECTU),CODRET)

        ELSEIF (NDIM.EQ.2) THEN

          CALL ASSERT(NBSIG.EQ.4)
          CALL XNMGR2(ELREFP,ELRESE(NDIM+IRESE),NDIM,COORSE,IGEOM,
     &                  HE,NFH,DDLC,DDLM,NFE,INSTAM,INSTAP,IDEPLP,
     &                  SIGM(IDEBS+1),VIP(IDEBV+1),BASLOC,NNOP,
     &                  NPG,TYPMOD,OPTION,IMATE,COMPOR,LGPG,IDECPG,
     &                  CRIT,IDEPL,LSN,LST,NFISS,FISNO,SIG(IDEBS+1),
     &                  VI(IDEBV+1),MATUU,IVECTU,CODRET)

        ENDIF

 110  CONTINUE

      END
