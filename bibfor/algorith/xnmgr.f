      SUBROUTINE  XNMGR(POUM,NNOP,IPOIDS,IVF,DDLH,NFE,DDLC,IGEOM,
     &                  INSTAM,INSTAP,DEPLP,SIGM,VIP,
     &                  TYPMOD,OPTION,NOMTE,IMATE,COMPOR,LGPG,CRIT,
     &                  PINTT,CNSET,HEAVT,LONCH,BASLOC,DEPL,
     &                  LSN,LST,SIG,VI,MATUU,VECTU,CODRET)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PROIX J-M.PROIX
C TOLE CRP_21
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
       INTEGER      NNOP,IMATE,LGPG,CODRET,IPOIDS,IVF,IGEOM
       INTEGER      DDLH,NFE,DDLC,CNSET(4*32),HEAVT(36),LONCH(7),NDIM
       CHARACTER*(*) POUM
       CHARACTER*8  TYPMOD(*)
       CHARACTER*16 OPTION,NOMTE,COMPOR(4)
       REAL*8       GEOM(3,NNOP),CRIT(3),PINTT(3*11),VI(*)
       REAL*8       DEPL(*),DEPLP(*),LSN(NNOP)
       REAL*8       LST(NNOP),MATUU(*),VECTU(*),SIG(*),BASLOC(*)
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
C IN  IPOIDS  : POIDS DES POINTS DE GAUSS
C IN  IVF     : VALEUR  DES FONCTIONS DE FORME
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT 
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
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
C IN  DEPL    : DEPLACEMENT A PARTIR DE LA CONF DE REF
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C
C OUT SIG     : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
C..............................................................
C----------------------------------------------------------------
      CHARACTER*8   ELREFP,ELRESE(3),FAMI(3)
      CHARACTER*24  COORSE,PINTER,AINTER,HEAV
      REAL*8        HE
      INTEGER       CONNEC(6,4),NINTER,NPTS,NSE,CNSE(6,4),NSEMAX(3),NPG
      INTEGER       I,IT,ISE,IN,INO,NIT,CPT,NCMPS,IDEBS,JCOORS,IDEBV
      INTEGER       IBID,NBSIG,NBSIGM,IDECPG
      DATA          NSEMAX / 2 , 3 , 6 /
      DATA    ELRESE /'SE2','TR3','TE4'/
      DATA    FAMI   /'BID','XINT','XINT'/
 
C     ATTENTION, DEPL ET VECTU SONT ICI DIMENSIONNÉS DE TELLE SORTE 
C     QU'ILS NE PRENNENT PAS EN COMPTE LES DDL SUR LES NOEUDS MILIEU

      CALL ELREF1(ELREFP)

C     ELEMENT DE REFERENCE PARENT : RECUP DE NDIM
      CALL ELREF4(' ','RIGI',NDIM,IBID,IBID,IBID,IBID,IBID,IBID,IBID)

C     SOUS-ELEMENT DE REFERENCE : RECUP DE NPG
      CALL ELREF5(ELRESE(NDIM),FAMI(NDIM),IBID,IBID,IBID,NPG,IBID,
     &                  IBID,IBID,IBID,IBID,IBID)

C     NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
      NBSIG = NBSIGM()
      
C     RECUPERATION DE LA SUBDIVISION L'ELEMENT PARENT EN NIT TETRAS 
      NIT=LONCH(1)
      CPT=0
C     BOUCLE SUR LES NIT TETRAS
      DO 100 IT=1,NIT

C       RECUPERATION DU DECOUPAGE EN NSE SOUS-ELEMENTS 
        NSE=LONCH(1+IT)

C       BOUCLE D'INTEGRATION SUR LES NSE SOUS-ELEMENTS
        DO 110 ISE=1,NSE

          CPT=CPT+1

C         COORD DU SOUS-ELT EN QUESTION
          COORSE='&&XNMPL.COORSE'
          CALL WKVECT(COORSE,'V V R',NDIM*(NDIM+1),JCOORS)

C         BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
          DO 112 IN=1,NDIM+1
            INO=CNSET((NDIM+1)*(CPT-1)+IN)
            IF (INO.LT.1000) THEN
              ZR(JCOORS-1+NDIM*(IN-1)+1)=ZR(IGEOM-1+NDIM*(INO-1)+1)
              ZR(JCOORS-1+NDIM*(IN-1)+2)=ZR(IGEOM-1+NDIM*(INO-1)+2)
              IF (NDIM .EQ. 3) 
     &        ZR(JCOORS-1+NDIM*(IN-1)+3)=ZR(IGEOM-1+NDIM*(INO-1)+3)
            ELSE
              ZR(JCOORS-1+NDIM*(IN-1)+1)=PINTT(NDIM*(INO-1000-1)+1)
              ZR(JCOORS-1+NDIM*(IN-1)+2)=PINTT(NDIM*(INO-1000-1)+2)
              IF (NDIM .EQ. 3) 
     &        ZR(JCOORS-1+NDIM*(IN-1)+3)=PINTT(NDIM*(INO-1000-1)+3)
            ENDIF
 112      CONTINUE

C         FONCTION HEAVYSIDE CSTE SUR LE SS-ELT
          HE=HEAVT(NSEMAX(NDIM)*(IT-1)+ISE)
          
C         DEBUT DE LA ZONE MEMOIRE DE SIG ET VI CORRESPONDANTE
          IDECPG = NPG   * ( NSEMAX(NDIM)*(IT-1)+ (ISE-1))
          IDEBS  = NBSIG *   IDECPG
          IDEBV  = LGPG  *   IDECPG

          IF (NDIM .EQ. 3) THEN

            CALL ASSERT(NBSIG.EQ.6)
            CALL XNMGR3(POUM,ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                  INSTAM,INSTAP,DEPLP,SIGM(IDEBS+1),VIP(IDEBV+1),
     &                  BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,COMPOR,
     &                  LGPG,CRIT,DEPL,LSN,LST,
     &                  SIG(IDEBS+1),VI(IDEBV+1),MATUU,VECTU,CODRET)

          ELSEIF (NDIM.EQ.2) THEN

            CALL ASSERT(NBSIG.EQ.4)
            CALL XNMGR2(POUM,ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                  INSTAM,INSTAP,DEPLP,SIGM(IDEBS+1),VIP(IDEBV+1),
     &                  BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,COMPOR,LGPG,
     &                  CRIT,DEPL,LSN,LST,SIG(IDEBS+1),
     &                  VI(IDEBV+1),MATUU,VECTU,CODRET)
              
          ENDIF

          CALL JEDETR(COORSE)

 110    CONTINUE

 100  CONTINUE
 
      END
