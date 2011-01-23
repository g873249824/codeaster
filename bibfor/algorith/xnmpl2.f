      SUBROUTINE  XNMPL2(ELREFP,ELRESE,NDIM,COORSE,IGEOM,HE,NFH,
     &                   DDLC,DDLM,NFE,INSTAM,INSTAP,IDEPLP,SIGM,VIP,
     &                   BASLOC,NNOP,NPG,TYPMOD,OPTION,IMATE,COMPOR,
     &                   LGPG,CRIT,IDEPLM,LSN,LST,
     &                   SIG,VI,MATUU,IVECTU,CODRET,NFISS,FISNO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/01/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21 CRS_1404
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE

      INTEGER       NDIM,IGEOM,IMATE,LGPG,CODRET,NNOP,NPG
      INTEGER       NFH,DDLC,DDLM,NFE,IDEPLM,IVECTU,IDEPLP
      INTEGER       NFISS,FISNO(NNOP,NFISS)
      CHARACTER*8   ELREFP,TYPMOD(*)
      CHARACTER*8   ELRESE
      CHARACTER*16  OPTION,COMPOR(4)
      CHARACTER*24  COORSE
      REAL*8        BASLOC(6*NNOP),CRIT(3),HE(NFISS)
      REAL*8        LSN(NNOP),LST(NNOP)
      REAL*8        VI(LGPG,NPG),VIP(LGPG,NPG),SIG(4,NPG),MATUU(*)
      REAL*8        INSTAM,INSTAP,SIGM(4,NPG),SIGN(6)
C.......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN HYPER-ELASTICITE AVEC X-FEM EN 2D
C.......................................................................
C IN  ELREFP  : ELEMENT DE REFERENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONNEES DES SOMMETS DU SOUS-ELEMENT
C IN  IGEOM   : COORDONNEES DES NOEUDS DE L'ELEMENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-ELT
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  DDLM    : NOMBRE DE DDL PAR NOEUD MILIEU
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE AUX NOEUDS
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-ELEMENT
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  IDEPL   : DEPLACEMENT A PARTIR DE LA CONF DE REF
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS

C OUT SIG     : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT IVECTU  : VECTEUR FORCES NODALES (RAPH_MECA ET FULL_MECA)
C......................................................................
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

      INTEGER  KPG,KK,N,I,M,J,J1,KL,PQ,KKD,INO,IG,IRET
      INTEGER  NNO,NNOS,NPGBIS,DDLS,DDLD,CPT,NDIMB
      INTEGER  JCOOPG,JDFD2,JGANO,JCOORS,IDFDE,IVF,IPOIDS
      LOGICAL  GRDEPL,AXI,CPLAN
      REAL*8   DSIDEP(6,6),F(3,3),EPS(6),DEPS(6),SIGMA(6),FTF,DETF
      REAL*8   TMP1,TMP2,SIGP(6),FE(4),BASLOG(6)
      REAL*8   XG(NDIM),XE(NDIM),FF(NNOP),JAC,LSNG,LSTG
      REAL*8   RBID1(10),RBID2(10)
      REAL*8   DFDI(NNOP,NDIM),PFF(6,NNOP,NNOP),DGDGL(4,3)
      REAL*8   DEF(6,NNOP,NDIM*(1+NFH+NFE)),GRAD(3,3),ANGMAS(3)
      REAL*8   ELGEOM(10,27),DFDIB(27,3),DEPLB1(3,27),DEPLB2(3,27)
      INTEGER  INDI(4),INDJ(4)
      REAL*8   RIND(4),RAC2, R, UR, RBID
      INTEGER  NNOPS,IBID,NN,MN

      DATA    INDI / 1 , 2 , 3 , 1 /
      DATA    INDJ / 1 , 2 , 3 , 2 /
      DATA    RIND / 0.5D0 , 0.5D0 , 0.5D0 , 0.70710678118655D0 /
      DATA    RAC2 / 1.4142135623731D0 /
      DATA    ANGMAS /0.D0, 0.D0, 0.D0/
C--------------------------------------------------------------------

C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET
      DDLD=NDIM*(1+NFH+NFE)

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLS=DDLD+DDLC

C     RECUPERATION DU NOMBRE DE NOEUDS SOMMETS DE L'ELEMENT PARENT
      CALL ELREF4(' ','RIGI',IBID,IBID,NNOPS,IBID,IBID,IBID,IBID,IBID)

C - INITIALISATION
      GRDEPL = .FALSE.
      AXI    = TYPMOD(1) .EQ. 'AXIS'
      CPLAN  = TYPMOD(1) .EQ. 'C_PLAN'

C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)
C
      CALL ELREF5(ELRESE,'XINT',NDIMB,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
     &                  IDFDE,JDFD2,JGANO)

      CALL ASSERT(NPG.EQ.NPGBIS.AND.NDIM.EQ.NDIMB)


C - CALCUL DES ELEMENTS GEOMETRIQUES SPECIFIQUES LOIS DE COMPORTEMENT
      CALL LCEGEO(NNO      ,NPG   ,IPOIDS,IVF   ,IDFDE ,
     &            ZR(IGEOM),TYPMOD,COMPOR,NDIM  ,DFDIB ,
     &            DEPLB1   ,DEPLB2,ELGEOM)


C-----------------------------------------------------------------------
C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 10 KPG=1,NPG

C       COORDONNEES DU PT DE GAUSS DANS LE REPERE REEL : XG
        CALL VECINI(NDIM,0.D0,XG)
        DO 110 I=1,NDIM
          DO 111 N=1,NNO
          XG(I)=XG(I)+ZR(IVF-1+NNO*(KPG-1)+N)*ZR(JCOORS-1+NDIM*(N-1)+I)
 111      CONTINUE
 110    CONTINUE

C             JUSTE POUR CALCULER LES FF
        CALL REEREF(ELREFP,AXI,NNOP,NNOPS,IGEOM,XG,IDEPLM,GRDEPL,
     &              NDIM,HE,RBID, RBID,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'NON',
     &              XE,FF,DFDI,F,EPS,GRAD)

        IF (NFE.GT.0) THEN
C         BASE LOCALE AU POINT DE GAUSS
          CALL VECINI(6,0.D0,BASLOG)
          LSNG = 0.D0
          LSTG = 0.D0
          DO 113 INO=1,NNOP
            LSNG = LSNG + LSN(INO) * FF(INO)
            LSTG = LSTG + LST(INO) * FF(INO)
            DO 114 I=1,6
              BASLOG(I) = BASLOG(I) + BASLOC(6*(INO-1)+I) * FF(INO)
 114        CONTINUE
 113      CONTINUE
C
C         FONCTION D'ENRICHISSEMENT AU POINT DE GAUSS ET LEURS DERIVEES
          CALL XCALF2(XG,HE,LSNG,LSTG,BASLOG,FE,DGDGL,IRET)
C         ON A PAS PU CALCULER LES DERIVEES DES FONCTIONS SINGULIERES
C         CAR ON SE TROUVE SUR LE FOND DE FISSURE
          CALL ASSERT(IRET.NE.0)
          
        ENDIF
C
C -     CALCUL DE LA DISTANCE A L'AXE (AXISYMETRIQUE)
C       ET DU DEPL. RADIAL
        IF (AXI) THEN
          R  = 0.D0
          UR = 0.D0
          DO 1000 INO=1,NNOP
            R  = R  + FF(INO)*ZR(IGEOM-1+2*(INO-1)+1)
            UR = UR + FF(INO)*ZR(IDEPLM-1+DDLS*(INO-1)+1)
            DO 1001 IG=1,NFH         
              UR = UR + FF(INO)
     &                   *ZR(IDEPLM-1+DDLS*(INO-1)+NDIM*IG+1)
 1001       CONTINUE 
            DO 1002 IG=1,NFE
                UR = UR + FF(INO)
     &                   *ZR(IDEPLM-1+DDLS*(INO-1)+NDIM*(NFH+IG)+1)
     &                   *FE(IG)

 1002       CONTINUE
            
1000      CONTINUE


          CALL ASSERT(R.GT.0D0)
C          ATTENTION : LE POIDS N'EST PAS X R
C          CE SERA FAIT PLUS TARD AVEC JAC = JAC X R
        ENDIF
        
C       COORDONN�ES DU POINT DE GAUSS DANS L'ELEMENT DE REF PARENT : XE
C       ET CALCUL DE FF, DFDI, DEPS ET EPS
        CALL REEREF(ELREFP,AXI,NNOP,NNOPS,IGEOM,XG,IDEPLP,GRDEPL,
     &              NDIM,HE,R, UR,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'OUI',
     &              XE,FF,DFDI,F,DEPS,GRAD)

        CALL REEREF(ELREFP,AXI,NNOP,NNOPS,IGEOM,XG,IDEPLM,GRDEPL,
     &              NDIM,HE,R, UR,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'OUI',
     &              XE,FF,DFDI,F,EPS,GRAD)


C - CALCUL DES ELEMENTS GEOMETRIQUES

C      CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 120 N=1,NNOP
C         FONCTIONS DE FORME CLASSIQUES
          DO 121 I=1,2
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 121      CONTINUE
 
C       TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
          IF (AXI) THEN
            DEF(3,N,1) = F(3,3) * FF(N)/R
          ENDIF
          
C         ENRICHISSEMENT PAR HEAVYSIDE
          DO 122 IG=1,NFH
            DO 123 I=1,2
              CPT=NDIM*(1+IG-1)+I
              DEF(1,N,CPT) =  DEF(1,N,I) * HE(FISNO(N,IG))
              DEF(2,N,CPT) =  DEF(2,N,I) * HE(FISNO(N,IG))
              DEF(3,N,CPT) =  0.D0
              DEF(4,N,CPT) =  DEF(4,N,I) * HE(FISNO(N,IG))
 123        CONTINUE

C  ATTENTION:TERME DE CORRECTION (3,3) AXI SUR LE DDL 1+NDIM*IG
            IF (AXI) THEN
              DEF(3,N,(1+NDIM*IG)) = F(3,3) * FF(N)/R * HE(FISNO(N,IG))
            ENDIF
            
  122      CONTINUE
C         ENRICHISSEMENT PAR LES NFE FONTIONS SINGULIERES
          DO 124 IG=1,NFE
            DO 125 I=1,2
              CPT = NDIM*(1+NFH+IG-1)+I
              DEF(1,N,CPT) =  F(I,1) *
     &             (DFDI(N,1) * FE(IG) + FF(N)*DGDGL(IG,1))

              DEF(2,N,CPT) =  F(I,2) *
     &             (DFDI(N,2) * FE(IG) + FF(N)*DGDGL(IG,2))

              DEF(3,N,CPT) =  0.D0

              DEF(4,N,CPT) =
     &         ( F(I,1)* (DFDI(N,2)*FE(IG)+FF(N)*DGDGL(IG,2))
     &         + F(I,2)* (DFDI(N,1)*FE(IG)+FF(N)*DGDGL(IG,1)) )/RAC2
 125         CONTINUE
 
C   ATTENTION:TERME DE CORRECTION (3,3) AXI LE DDL 1+NDIM*(NFH+IG)
            IF (AXI) THEN
              DEF(3,N,(1+NDIM*(NFH+IG))) = F(3,3)* FF(N)/R * FE(IG)
            ENDIF
 124       CONTINUE
 
        CALL ASSERT(CPT.EQ.DDLD)
        
 120    CONTINUE

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
C       ON ENVOIE DFDM2D AVEC LES COORD DU SS-ELT
        CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                   RBID1,RBID2,JAC)
     
        IF (AXI) THEN
          JAC= JAC * R
        ENDIF

C      CALCUL DES PRODUITS DE FONCTIONS DE FORMES (ET DERIVEES)
        IF ( (OPTION(1:10) .EQ. 'RIGI_MECA_'
     &  .OR.  OPTION(1: 9) .EQ. 'FULL_MECA'    ) .AND. GRDEPL) THEN
          DO 128 N=1,NNOP
            DO 126 M=1,N
              PFF(1,N,M) =  DFDI(N,1)*DFDI(M,1)
              PFF(2,N,M) =  DFDI(N,2)*DFDI(M,2)
              PFF(3,N,M) = 0.D0
              PFF(4,N,M) =(DFDI(N,1)*DFDI(M,2)+DFDI(N,2)*DFDI(M,1))/RAC2
 126        CONTINUE
 128      CONTINUE
        ENDIF


C - LOI DE COMPORTEMENT : S(E) ET DS/DE

C      CALL NMCPEL('RIGI',KPG,1,POUM,2,TYPMOD,ANGMAS,IMATE,COMPOR,CRIT,
C   &            OPTION,EPS,SIGMA,VI(1,KPG),DSIDEP,CODRET)

        DO 135 M=1,3
          SIGN(M) = SIGM(M,KPG)
 135    CONTINUE
        SIGN(4) = SIGM(4,KPG)*RAC2

        CALL R8INIR(6,0.0D0,SIGMA,1)
        CALL NMCOMP('RIGI',KPG,1,2,TYPMOD,IMATE,COMPOR,CRIT,
     &              INSTAM,INSTAP,
     &              EPS,DEPS,
     &              SIGN,VI(1,KPG),
     &              OPTION,
     &              ANGMAS,
     &              ELGEOM(1,KPG),
     &              SIGMA,VIP(1,KPG),DSIDEP,CODRET)

C - CALCUL DE LA MATRICE DE RIGIDITE

        IF ( OPTION(1:10) .EQ. 'RIGI_MECA_'
     &  .OR. OPTION(1: 9) .EQ. 'FULL_MECA'    ) THEN

          DO 130 N=1,NNOP
            CALL INDENT(N,DDLS,DDLM,NNOPS,NN)

            DO 131 I=1,DDLD
              KKD = (NN+I-1) * (NN+I) /2
              DO 151,KL=1,4
                SIGP(KL)=0.D0
                SIGP(KL)=SIGP(KL)+DEF(1,N,I)*DSIDEP(1,KL)
                SIGP(KL)=SIGP(KL)+DEF(2,N,I)*DSIDEP(2,KL)
                SIGP(KL)=SIGP(KL)+DEF(3,N,I)*DSIDEP(3,KL)
                SIGP(KL)=SIGP(KL)+DEF(4,N,I)*DSIDEP(4,KL)
 151          CONTINUE
              DO 140 J=1,DDLD
                DO 141 M=1,N
                  CALL INDENT(M,DDLS,DDLM,NNOPS,MN)

                  IF (M.EQ.N) THEN
                    J1 = I
                  ELSE
                    J1 = DDLD
                  ENDIF

C                 RIGIDITE GEOMETRIQUE
                  TMP1 = 0.D0
                  IF (GRDEPL .AND. I.EQ.J) THEN
                    TMP1 = PFF(1,N,M)*SIGMA(1)
     &                   + PFF(2,N,M)*SIGMA(2)
     &                   + PFF(3,N,M)*SIGMA(3)
     &                   + PFF(4,N,M)*SIGMA(4)

C                  TERME DE CORRECTION AXISYMETRIQUE
C                    IF (AXI .AND. I.EQ.1) THEN
C                      TMP1=TMP1+ZR(IVF+N+(KPG-1)*NNO-1)*
C     &                     ZR(IVF+M+(KPG-1)*NNO-1)/(R*R)*SIGMA(3)
C                    END IF
                  ENDIF

C                RIGIDITE ELASTIQUE
                  TMP2 = SIGP(1)*DEF(1,M,J) + SIGP(2)*DEF(2,M,J)
     &                 + SIGP(3)*DEF(3,M,J) + SIGP(4)*DEF(4,M,J)

C                STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                  IF (J.LE.J1) THEN
                    KK = KKD + MN + J
                    MATUU(KK) = MATUU(KK) + (TMP1+TMP2)*JAC
                  END IF

 141            CONTINUE
 140          CONTINUE
 131        CONTINUE
 130      CONTINUE
        ENDIF


C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY

        IF(OPTION(1:9).EQ.'FULL_MECA'.OR.
     &     OPTION(1:9).EQ.'RAPH_MECA') THEN

          DO 185 N=1,NNOP
            CALL INDENT(N,DDLS,DDLM,NNOPS,NN)

            DO 186 I=1,DDLD
              DO 187 KL=1,4
              ZR(IVECTU-1+NN+I)=
     &        ZR(IVECTU-1+NN+I)+DEF(KL,N,I)*SIGMA(KL)*JAC
 187          CONTINUE
 186        CONTINUE
 185      CONTINUE

          IF ( GRDEPL ) THEN
C          CONVERSION LAGRANGE -> CAUCHY
            IF (CPLAN) F(3,3) = SQRT(ABS(2.D0*EPS(3)+1.D0))
            DETF = F(3,3)*(F(1,1)*F(2,2)-F(1,2)*F(2,1))
            DO 190 PQ = 1,4
              SIG(PQ,KPG) = 0.D0
              DO 200 KL = 1,4
                FTF = (F(INDI(PQ),INDI(KL))*F(INDJ(PQ),INDJ(KL)) +
     &          F(INDI(PQ),INDJ(KL))*F(INDJ(PQ),INDI(KL)))*RIND(KL)
                SIG(PQ,KPG) =  SIG(PQ,KPG)+ FTF*SIGMA(KL)
 200          CONTINUE
              SIG(PQ,KPG) = SIG(PQ,KPG)/DETF
 190        CONTINUE
          ELSE
            DO 210 KL=1,3
              SIG(KL,KPG) = SIGMA(KL)
 210        CONTINUE
            SIG(4,KPG) = SIGMA(4)/RAC2
          ENDIF
        ENDIF

 10   CONTINUE

      END
