      SUBROUTINE  XMASEL(NNOP,IPOIDS,IVF,DDLH,NFE,DDLC,IGEOM,
     &                  TYPMOD,NOMTE,IMATE,LGPG,
     &                  PINTT,CNSET,HEAVT,LONCH,BASLOC,
     &                  LSN,LST,MATUU,CODRET)

       IMPLICIT NONE
       INTEGER      NNOP,IMATE,LGPG,CODRET,IPOIDS,IVF,IGEOM
       INTEGER      DDLH,NFE,DDLC,CNSET(4*32),HEAVT(36),LONCH(10)
       CHARACTER*8  TYPMOD(*)
       CHARACTER*16 NOMTE
       REAL*8       PINTT(3*11),LSN(NNOP)
       REAL*8       LST(NNOP),MATUU(*),BASLOC(*)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/12/2010   AUTEUR MASSIN P.MASSIN 
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
C TOLE CRP_21
C
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
C.......................................................................
C
C     BUT:  PRÉLIMINAIRES AU CALCUL DES OPTIONS RIGI_MECA_TANG,
C           RAPH_MECA ET FULL_MECA  EN HYPER-ELASTICITE AVEC X-FEM
C.......................................................................
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  IPOIDS  : POIDS DES POINTS DE GAUSS
C IN  IVF     : VALEUR  DES FONCTIONS DE FORME
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  IGEOM   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  NOMTE   : NOM DU TE
C IN  IMATE   : MATERIAU CODE
C IN  LGPG  : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C              CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  PINTT   : COORDONNÉES DES POINTS D'INTERSECTION
C IN  CNSET   : CONNECTIVITE DES SOUS-ELEMENTS
C IN  HEAVT   : VALEURS DE L'HEAVISIDE SUR LES SS-ELTS
C IN  LONCH   : LONGUEURS DES CHAMPS UTILISÉES
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C OUT MATUU   : MATRICE DE MASSE PROFIL 
C..............................................................
C----------------------------------------------------------------
      CHARACTER*8   ELREFP,ELRESE(3),FAMI(3)
      CHARACTER*24  COORSE,PINTER,AINTER,HEAV
      CHARACTER*16  K16BID
      REAL*8        HE,R8BID
      INTEGER       NINTER,NSE,NPG,NDIM
      INTEGER       J,ISE,IN,INO,JCOORS
      INTEGER       IBID,IDECPG
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

C     RÉCUPÉRATION DE LA SUBDIVISION DE L'ÉLÉMENT EN NSE SOUS ELEMENT
      NSE=LONCH(1)

C       BOUCLE D'INTEGRATION SUR LES NSE SOUS-ELEMENTS
      DO 110 ISE=1,NSE

C       COORD DU SOUS-ELT EN QUESTION
        COORSE='&&XMASEL.COORSE'
        CALL WKVECT(COORSE,'V V R',NDIM*(NDIM+1),JCOORS)

C       BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
        DO 111 IN=1,NDIM+1
          INO=CNSET((NDIM+1)*(ISE-1)+IN)
          DO 112 J=1,NDIM
            IF (INO.LT.1000) THEN
              ZR(JCOORS-1+NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
            ELSE
              ZR(JCOORS-1+NDIM*(IN-1)+J)=PINTT(NDIM*(INO-1000-1)+J)
            ENDIF
 112      CONTINUE
 111    CONTINUE

C       FONCTION HEAVYSIDE CSTE SUR LE SS-ELT
        HE = HEAVT(ISE)

C       DEBUT DE LA ZONE MEMOIRE DE SIG ET VI CORRESPONDANTE
        IDECPG = NPG   * (ISE-1)

        IF (NDIM .EQ. 3) THEN

          CALL XMASE3(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,
     &                  NFE,BASLOC,NNOP,NPG,TYPMOD,IMATE,
     &                  LGPG,LSN,LST,IDECPG,MATUU,CODRET)

        ELSEIF (NDIM.EQ.2) THEN

          CALL XMASE2(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,
     &                NFE,BASLOC,NNOP,NPG,TYPMOD,IMATE,
     &                LGPG,LSN,LST,IDECPG,MATUU,CODRET)

        ENDIF

        CALL JEDETR(COORSE)

 110  CONTINUE

      END
