      SUBROUTINE XBSIGR (NDIM,NNOP,DDLH,NFE,DDLC,IGEOM,PINTT,CNSET,
     &                   HEAVT,LONCH,BASLOC,SIGMA,NBSIG,LSN,LST,
     &                   DDLS,VECTU)
      
       IMPLICIT NONE
C
       INTEGER       NDIM,NNOP,DDLH,NFE,DDLC,IGEOM,NBSIG,DDLS
       INTEGER       CNSET(4*32),HEAVT(36),LONCH(7)
       REAL*8        PINTT(3*11),BASLOC(*),SIGMA,LSN(NNOP),LST(NNOP)
       REAL*8        VECTU(DDLS*NNOP)
C

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2008   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                 CALCUL DES FORCES INTERNES B*SIGMA AUX NOEUDS 
C                 DE L'ELEMENT DUES AU CHAMP DE CONTRAINTES SIGMA 
C                 DEFINI AUX POINTS D'INTEGRATION DANS LE CADRE DE
C                 LA M�THODE X-FEM, POUR L'OPTION REFE_FORC_NODA
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  DDLH    : NOMBRE DE DDLS HEAVYSIDE (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT 
C IN  DDLC    : NOMBRE DE DDLS DE CONTACT (PAR NOEUD)
C IN  IGEOM   : COORDONEES DES NOEUDS
C IN  PINTT   : COORDONN�ES DES POINTS D'INTERSECTION
C IN  CNSET   : CONNECTIVITE DES SOUS-ELEMENTS
C IN  HEAVT   : VALEURS DE L'HEAVISIDE SUR LES SS-ELTS
C IN  LONCH   : LONGUEURS DES CHAMPS UTILIS�ES
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE
C IN  SIGMA   : CONTRAINTES DE REFERENCE
C IN  NBSIG   : NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C IN  DDLS    : NOMBRE DE DDL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET

C OUT VECTU  : BT.SIGMA REFE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C     VARIABLES LOCALES
      REAL*8        HE,SIGTMP(15*6),BSIGMA(DDLS*NNOP)
      CHARACTER*8   ELREFP,ELRESE(3),FAMI(3)
      CHARACTER*24  COORSE
      INTEGER       CONNEC(6,4),NSE
      INTEGER       IT,ISE,IN,INO,NIT,NSEMAX(3),CPT,NPG,IDEB,JCOORS,I,J
      DATA          NSEMAX / 2 , 3 , 6 /
      DATA          ELRESE /'SE2','TR3','TE4'/
      DATA          FAMI   /'BID','XINT','XINT'/

C.========================= DEBUT DU CODE EXECUTABLE ==================
C

      CALL ELREF1(ELREFP)

C     SOUS-ELEMENT DE REFERENCE : RECUP DE NPG
      CALL ELREF5(ELRESE(NDIM),FAMI(NDIM),I,I,I,NPG,I,I,I,I,I,I)

C     R�CUP�RATION DE LA SUBDIVISION L'�L�MENT PARENT EN NIT TETRAS 
      NIT=LONCH(1)

      CPT=0
C     BOUCLE SUR LES NIT TETRAS
      DO 100 IT=1,NIT
C       R�CUP�RATION DU D�COUPAGE EN NSE SOUS-�L�MENTS 
        NSE=LONCH(1+IT)

C       BOUCLE SUR LES NSE SOUS-�L�MENTS
        DO 110 ISE=1,NSE
          CPT=CPT+1

C         COORD DU SOUS-�LT EN QUESTION
          COORSE='&&XBSIGR.COORSE'
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

          CALL R8INIR(NBSIG*NPG,0.D0,SIGTMP,1)

C         BOUCLE SUR LES SIG TESTS : SIGTMP = {0 0 0  SIGMA 0 0 0 0 0}
          DO 200 I=1,NBSIG*NPG

            SIGTMP(I)=SIGMA

            IF (NDIM .EQ. 3) THEN
              CALL XBSIG3(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                    BASLOC,NNOP,NPG,SIGTMP,LSN,LST,BSIGMA)
            ELSE
              CALL XBSIG2(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                    BASLOC,NNOP,NPG,SIGTMP,LSN,LST,BSIGMA)
            ENDIF

            DO 210 J=1,DDLS*NNOP
              VECTU(J) = VECTU(J)+ABS(BSIGMA(J))/NPG
 210        CONTINUE

            SIGTMP(I)=0.D0

 200      CONTINUE

          CALL JEDETR(COORSE)

 110    CONTINUE

 100  CONTINUE
 
C.============================ FIN DE LA ROUTINE ======================
      END
