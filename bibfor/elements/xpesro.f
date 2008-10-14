      SUBROUTINE XPESRO(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                  NNOP,NPG,JLSN,JLST,IDECPG,ITEMPS,IVECTU,FNO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR DELMAS J.DELMAS 
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

      IMPLICIT NONE
      CHARACTER*8   ELREFP
      CHARACTER*16  OPTION
      CHARACTER*24  COORSE
      INTEGER       IGEOM,NDIM,DDLH,DDLC,NFE,NNOP,NPG
      INTEGER       IDECPG,ITEMPS,IVECTU,JLSN,JLST
      REAL*8        HE,LSN(NNOP),LST(NNOP),FNO(NDIM*NNOP)
      LOGICAL FONO
C-----------------------------------------------------------------------
C FONCTION REALISEE : CALCUL DU SECOND MEMBRE AUX PG DU SOUS EL COURANT 
C                     DANS LE CAS D'UNE FORCE VOLUMIQUE IMPOSEE SUR LES 
C                     ELEMENTS X-FEM 2D ET 3D
C                          
C                          OPTIONS  :  CHAR_MECA_PESA_R
C                                      CHAR_MECA_ROTA_R 
C                          
C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-�L�MENT
C IN  JLSN    : INDICE DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  JLST    : INDICE DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
C IN  IDECPG  : POSITION DANS LA FAMILLE 'XFEM' DU 1ER POINT DE GAUSS
C               DU SOUS ELEMENT COURRANT (EN FAIT 1ER POINT : IDECPG+1)
C IN ITEMPS   : INDICE DE L'INSTANT
C IN FNO      : FORCES VOLUMIQUES AUX NOEUDS DE L'ELEMENT PARENT
C IN IVECTU   : INDICE DU SECONDE MEMBRE

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER I,INO,IG,IER,J,N,IBID
      INTEGER NDIMB,NNO,NNOS,NPGBIS,POS
      INTEGER JCOORS,JCOOPG,IPOIDS,IVF,IDFDE,JDFD2,JGANO,KPG
      REAL*8  XE(NDIM),XG(NDIM),FF(NNOP),LSNG,LSTG,RG,TG,FORVOL(NDIM)
      REAL*8  VALPAR(NDIM+1),FE(4),POIDS
      REAL*8  RBID,RBID1(4),RBID2(4),RBID3(4)
      CHARACTER*8  ELRESE(3),FAMI(3),NOMPAR(NDIM+1)
      LOGICAL GRDEPL
      DATA     ELRESE /'SE2','TR3','TE4'/
      DATA     FAMI   /'BID','XINT','XINT'/

C-----------------------------------------------------------------------

      GRDEPL=.FALSE.

C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)

C     SOUS-ELEMENT DE REFERENCE 
      CALL ELREF5(ELRESE(NDIM),FAMI(NDIM),NDIMB,NNO,NNOS,NPGBIS,IPOIDS,
     &            JCOOPG,IVF,IDFDE,JDFD2,JGANO)
      CALL ASSERT(NDIM.EQ.NDIMB)

C     ------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS DU SOUS-ELEMENT COURANT
C     ------------------------------------------------------------------

      DO 10 KPG=1,NPGBIS

C       COORDONN�ES DU PT DE GAUSS DANS LA CONFIG R�ELLE DU SE : XG
        CALL LCINVN(NDIM,0.D0,XG)
        DO 101 I=1,NDIM
          DO 102 N=1,NNO
            XG(I) = XG(I) + ZR(IVF-1+NNO*(KPG-1)+N) 
     &                    * ZR(JCOORS-1+NDIM*(N-1)+I)
 102      CONTINUE
 101    CONTINUE

C       CALCUL DES FF DE L'ELEMENT DE REFERENCE PARENT AU PG COURANT
        CALL REEREF(ELREFP,NNOP,IGEOM,XG,RBID,GRDEPL,NDIM,RBID,IBID,
     &              IBID,IBID,RBID,RBID,'NON',XE,FF,RBID,RBID,RBID,RBID)

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SS-ELT -> SS-ELT REF
C       ON ENVOIE DFDM3D/DFDM2D AVEC LES COORD DU SS-ELT
        IF (NDIM.EQ.3) CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                      RBID1,RBID2,RBID3,POIDS)
        IF (NDIM.EQ.2) CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                      RBID1,RBID2,POIDS)

C       CALCUL DES FONCTIONS D'ENRICHISSEMENT
C       -------------------------------------

        IF (NFE.GT.0) THEN
C         LEVEL SETS AU POINT DE GAUSS
          LSNG = 0.D0
          LSTG = 0.D0
          DO 103 INO=1,NNOP
            LSNG = LSNG + ZR(JLSN-1+INO) * FF(INO)
            LSTG = LSTG + ZR(JLST-1+INO) * FF(INO)
 103      CONTINUE

C         COORDONN�ES POLAIRES DU POINT
          RG=SQRT(LSNG**2+LSTG**2)
          TG = HE * ABS(ATAN2(LSNG,LSTG))

C         FONCTIONS D'ENRICHISSEMENT
          FE(1)=SQRT(RG)*SIN(TG/2.D0)
          FE(2)=SQRT(RG)*COS(TG/2.D0)
          FE(3)=SQRT(RG)*SIN(TG/2.D0)*SIN(TG)
          FE(4)=SQRT(RG)*COS(TG/2.D0)*SIN(TG)
        ENDIF


C       CALCUL DE LA FORCE VOLUMIQUE AU PG COURANT
C       ------------------------------------------

        CALL LCINVN(NDIM,0.D0,FORVOL)
        DO 104 INO = 1,NNOP
          DO 105 J=1,NDIM
            FORVOL(J)=FORVOL(J)+FNO(NDIM*(INO-1)+J)*FF(INO)
 105      CONTINUE
 104    CONTINUE


C       CALCUL EFFECTIF DU SECOND MEMBRE
C       --------------------------------

        POS=0
        DO 108 INO = 1,NNOP          

C         TERME CLASSIQUE
          DO 109 J=1,NDIM
            POS=POS+1
            ZR(IVECTU-1+POS) = ZR(IVECTU-1+POS)
     &                       + FORVOL(J)*POIDS*FF(INO)
 109      CONTINUE

C         DOUTE SUR LA PRISE EN COMPTE DES TERMES SINGULIERS,
C         TEMPORAIREMENT ON NE LES PREND PAS EN COMPTE

C         TERME HEAVISIDE
          DO 110 J=1,DDLH
            POS=POS+1
            ZR(IVECTU-1+POS) = ZR(IVECTU-1+POS)
     &                       + 0.D0*HE*FORVOL(J)*POIDS*FF(INO) 
 110      CONTINUE

C         TERME SINGULIER   
          DO 111 IG=1,NFE
            DO 112 J=1,NDIM
              POS=POS+1
              ZR(IVECTU-1+POS) = ZR(IVECTU-1+POS)
     &                         + 0.D0*FE(IG)*FORVOL(J)*POIDS*FF(INO)
 112        CONTINUE
 111      CONTINUE 
 
C         ON SAUTE LES POSITIONS DES LAG DE CONTACT FROTTEMENT
          POS = POS + DDLC
 
 108    CONTINUE 


 10   CONTINUE
 
C     ------------------------------------------------------------------
C     FIN BOUCLE SUR LES POINTS DE GAUSS DU SOUS-ELEMENT
C     ------------------------------------------------------------------

      END
