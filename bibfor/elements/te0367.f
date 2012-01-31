      SUBROUTINE TE0367(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/01/2012   AUTEUR DESOZA T.DESOZA 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C
C ----------------------------------------------------------------------
C  CALCUL DES SECONDS MEMBRES DE CONTACT ET DE FROTTEMENT DE COULOMB STD
C   POUR LA METHODE XFEM EN GRANDS GLISSEMENTS
C  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
C           'CHAR_MECA_FROT' (CALCUL DU SECOND MEMBRE DE
C                              FROTTEMENT STANDARD )
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
      INTEGER      N
      PARAMETER    (N=336)
C
      INTEGER      I,NFAES
      INTEGER      NDIM,NDDL,NNE(3),NNM(3),NNC
      INTEGER      NSINGE,NSINGM
      INTEGER      JPCPO,JPCPI,JPCAI,JPCCF,IVECT,JSTNO
      INTEGER      INDNOR,IFROTT,INDCO
      INTEGER      CFACE(5,3)
      INTEGER      JDEPDE,JDEPM,JGEOM,JHEAFA,JHEANO
      REAL*8       TAU1(3),TAU2(3),NORM(3)
      REAL*8       MPROJT(3,3)
      REAL*8       COORE(3),COORM(3),COORC(2)
      REAL*8       FFE(8),FFM(8),FFC(8),DFFC(3,8)
      REAL*8       JACOBI,HPG
      CHARACTER*8  TYPMAE,TYPMAM,TYPMAC,TYPMAI,TYPMEC
      INTEGER      INADH,NVIT,LACT(8),NLACT,NINTER
      REAL*8       GEOPI(9),DVITET(3)
      REAL*8       COEFFF,COEFCR,COEFFR,COEFFP
      REAL*8       COEFCP
      REAL*8       RRE,RRM,JEU,R8BID
      REAL*8       RESE(3),NRESE
      REAL*8       DDEPLE(3),DDEPLM(3),DLAGRC,DLAGRF(2)
      LOGICAL      LFROTT,LPENAF,LPENAC,LESCLX,LMAITX,LCONTX
      REAL*8       VTMP(N)
      INTEGER      CONTAC,IBID,NPTE
      INTEGER      NDEPLE,DDLE(2),DDLM(2),NFHE,NFHM
      REAL*8       FFEC(8),NLAGR
      LOGICAL      LMULTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFOS SUR LA MAILLE DE CONTACT
C
      CALL XMELET(NOMTE , TYPMAI , TYPMAE ,TYPMAM ,TYPMAC  ,
     &                  NDIM  , NDDL   , NNE   , NNM  ,
     &                  NNC   , DDLE  , DDLM  ,
     &                  CONTAC, NDEPLE , NSINGE, NSINGM,NFHE,NFHM)

      CALL ASSERT(NDDL.LE.N)
      LMULTI = .FALSE.
      IF (NFHE.GT.1.OR.NFHM.GT.1) LMULTI = .TRUE.
C
C --- INITIALISATIONS
C
      CALL VECINI(N     ,0.D0  ,VTMP  )
      CALL VECINI(9     ,0.D0  ,GEOPI )
      CALL VECINI(2     ,0.D0  ,DLAGRF)
      DLAGRC = 0.D0

      CALL VECINI(3     ,0.D0  ,DDEPLE)
      CALL VECINI(3     ,0.D0  ,DDEPLM)
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT POINT (VOIR XMCART)
C
      CALL JEVECH('PCAR_PT','L',JPCPO)
      COORC(1) = ZR(JPCPO-1+1)
      COORC(2) = ZR(JPCPO-1+10)
      TAU1(1)  = ZR(JPCPO-1+4)
      TAU1(2)  = ZR(JPCPO-1+5)
      TAU1(3)  = ZR(JPCPO-1+6)
      TAU2(1)  = ZR(JPCPO-1+7)
      TAU2(2)  = ZR(JPCPO-1+8)
      TAU2(3)  = ZR(JPCPO-1+9)
      INDCO    = NINT(ZR(JPCPO-1+11))
      NINTER   = NINT(ZR(JPCPO-1+31))
      COEFCR   = ZR(JPCPO-1+13)
      COEFFR   = ZR(JPCPO-1+14)
      COEFCP   = ZR(JPCPO-1+33)
      COEFFP   = ZR(JPCPO-1+34)
      COEFFF   = ZR(JPCPO-1+15)
      IFROTT   = NINT(ZR(JPCPO-1+16))
      INDNOR   = NINT(ZR(JPCPO-1+17))
      HPG      = ZR(JPCPO-1+19)
C --- LES NUMEROS DES FACETTES DE CONTACT (ESCLAVE ET MAITRE) DONT LE
C --- PTC ET SON PROJETE APPARTIENT
      NPTE     = NINT(ZR(JPCPO-1+12))
      NFAES    = NINT(ZR(JPCPO-1+22))
C --- LES COORDONNEES ESCLAVE ET MAITRES DANS L'ELEMENT PARENT
      COORE(1) = ZR(JPCPO-1+24)
      COORE(2) = ZR(JPCPO-1+25)
      COORE(3) = ZR(JPCPO-1+26)
      COORM(1) = ZR(JPCPO-1+27)
      COORM(2) = ZR(JPCPO-1+28)
      COORM(3) = ZR(JPCPO-1+29)
C --- POINT D'INTEGRATION VITAL OU PAS
      NVIT     = NINT(ZR(JPCPO-1+30))
C --- SQRT LSN PT ESCLAVE ET MAITRE
      RRE      = ZR(JPCPO-1+18)
      RRM      = ZR(JPCPO-1+23)
      IF (NNM(1).EQ.0) RRE = 2*RRE
      LFROTT   = IFROTT.EQ.3
      LPENAF=((COEFFR.EQ.0.D0).AND.(COEFFP.NE.0.D0))
      LPENAC=((COEFCR.EQ.0.D0).AND.(COEFCP.NE.0.D0))
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT PINTER (VOIR XMCART)
C
      CALL JEVECH('PCAR_PI','L',JPCPI )
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT AINTER (VOIR XMCART)
C
      CALL JEVECH('PCAR_AI','L',JPCAI )
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT CFACE (VOIR XMCART)
C
      CALL JEVECH('PCAR_CF','L',JPCCF )
C
C --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
C
      CALL JEVECH('PGEOMER','E',JGEOM )
      CALL JEVECH('PDEPL_P','E',JDEPDE)
      CALL JEVECH('PDEPL_M','L',JDEPM )
C
      IF (LMULTI) THEN
C
C --- RECUPERATION DES FONCTION HEAVISIDES SUR LES FACETTES
C
        CALL JEVECH('PHEAVFA','L',JHEAFA )
C
C --- RECUPERATION DE LA PLACE DES LAGRANGES
C
        CALL JEVECH('PHEAVNO','L',JHEANO )
      ENDIF
C
C --- ON CONSTRUIT LA MATRICE DE CONNECTIVITÉ CFACE (MAILLE ESCLAVE)
C --- CE QUI SUIT N'EST VALABLE QU'EN 2D POUR LA FORMULATION QUADRATIQUE
C --- EN 3D ON UTILISE SEULEMENT LA FORMULATION AUX NOEUDS SOMMETS,
C --- CETTE MATRICE EST DONC INUTILE, ON NE LA CONSTRUIT PAS !!!
C
      CFACE(1,1)=1
      CFACE(1,2)=2
C
C --- CALCUL DES COORDONNEES REELLES DES POINTS D'INTERSECTION ESCLAVES
C
      CALL XMPINT(NDIM  ,NPTE,NFAES ,JPCPI ,JPCCF ,GEOPI )
C
C --- FONCTIONS DE FORME
C
      CALL XTFORM(NDIM  ,TYPMAE,TYPMAM,TYPMAC,NDEPLE ,
     &            NNM(1)   ,NNC   ,COORE ,COORM ,COORC ,
     &            FFE   ,FFM   ,DFFC  )
C
C --- FONCTION DE FORMES POUR LES LAGRANGIENS
C
      IF (CONTAC.EQ.1) THEN
        NNC   = NNE(2)
        CALL XLACTI(TYPMAI,NINTER,JPCAI,LACT,NLACT)
        CALL XMOFFC(LACT,NLACT,NNC,FFE,FFC)
      ELSEIF (CONTAC.EQ.3) THEN
        NNC   = NNE(2)
        CALL ELELIN(CONTAC,TYPMAE,TYPMEC,IBID,IBID)
        CALL ELRFVF(TYPMEC,COORE,NNC,FFEC,IBID)
        CALL XLACTI(TYPMAI,NINTER,JPCAI,LACT,NLACT)
        CALL XMOFFC(LACT,NLACT,NNC,FFEC,FFC)
      ELSE
        CALL ELRFVF(TYPMAC,COORC,NNC,FFC,NNC)
      ENDIF
C
C --- JACOBIEN POUR LE POINT DE CONTACT
C
      CALL XMMJAC(TYPMAC,GEOPI ,DFFC  ,JACOBI)
C
C --- CALCUL DE LA NORMALE ET DES MATRICES DE PROJECTION
C
      CALL XTCALN(NDIM  ,TAU1  ,TAU2  ,NORM  ,MPROJT)
C
C --- CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
C
      CALL XTLAGM(TYPMAI,NDIM  ,NNC   ,NNE   ,
     &            DDLE(1),NFAES ,CFACE ,JDEPDE,
     &            JPCAI  ,FFC   ,LFROTT,CONTAC,
     &            NFHE,LMULTI,ZI(JHEANO),DLAGRC,DLAGRF) 
C
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C
      IF (INDNOR .EQ. 1) THEN
        INDCO  = 0
      ENDIF
C
C --- RECUPERATION DES VECTEURS 'OUT' (A REMPLIR DONC MODE ECRITURE)
C
      CALL JEVECH('PVECTUR','E',IVECT)
C
C --- CALCUL DES SECOND MEMBRES DE CONTACT/FROTTEMENT

      IF (OPTION.EQ.'CHAR_MECA_CONT') THEN
        IF (INDCO.EQ.1) THEN
C
C --- VECTEUR SECOND MEMBRE SI CONTACT
C
         CALL XMMJEU(NDIM  ,NNM,NNE,NDEPLE,
     &                  NSINGE,NSINGM,FFE   ,FFM   ,NORM  ,
     &                  JGEOM ,JDEPDE,JDEPM ,RRE   ,RRM   ,
     &                  DDLE  ,DDLM  ,NFHE  ,NFHM  ,LMULTI,
     &                  ZI(JHEAFA),JEU   )

         CALL XMVEC1(NDIM, NNE, NDEPLE, NNC   ,NNM   ,
     &                  HPG   ,NFAES ,FFC   ,FFE   ,FFM   ,
     &                  JACOBI,DLAGRC,JPCAI ,CFACE ,COEFCR,
     &                  COEFCP,LPENAC,JEU   ,NORM  ,
     &                  TYPMAI,NSINGE,NSINGM,RRE   ,RRM   ,CONTAC,
     &                  DDLE, DDLM,NFHE  ,NFHM  ,LMULTI,ZI(JHEANO),
     &                  ZI(JHEAFA),VTMP  )     

        ELSE IF (INDCO .EQ. 0) THEN
          IF (NVIT.EQ.1) THEN
C
C --- CALCUL DU VECTEUR - CAS SANS CONTACT
C
          CALL XMVEC0(NDIM  ,NNE   ,NNC   ,NFAES ,
     &                  DLAGRC,HPG   ,FFC   ,JACOBI,CFACE ,
     &                  JPCAI ,COEFCR,COEFCP,LPENAC,TYPMAI,
     &                  DDLE,CONTAC,NFHE  ,LMULTI,ZI(JHEANO),VTMP  )
          ENDIF
        ELSE
          CALL U2MESS('F','ELEMENTS3_80')
        ENDIF

      ELSEIF (OPTION.EQ.'CHAR_MECA_FROT') THEN
C              ---------------------
        IF (COEFFF.EQ.0.D0) INDCO = 0
C ON MET LA SECURITE EN PENALISATION EGALEMENT
        IF (DLAGRC.EQ.0.D0) INDCO = 0
        IF (IFROTT.NE.3)    INDCO = 0

        IF (INDCO.EQ.0) THEN
          IF (NVIT.EQ.1) THEN
C
C --- CALCUL DU VECTEUR - CAS SANS FROTTEMENT
C

         CALL XMVEF0(NDIM  ,NNE ,NNC   ,NFAES ,
     &                  JPCAI ,HPG   ,FFC   ,JACOBI,
     &                  LPENAC,DLAGRF,CFACE ,TYPMAI,
     &                  TAU1  ,TAU2  ,DDLE  ,CONTAC,
     &                  NFHE  ,LMULTI,ZI(JHEANO),VTMP  )     
          ENDIF
        ELSE IF (INDCO.EQ.1) THEN
C
C --- CALCUL DES INCREMENTS - DEPLACEMENTS
C
          CALL XTDEPM(NDIM  ,NNM,NNE,NDEPLE,
     &                  NSINGE,NSINGM,FFE   ,FFM   ,JDEPDE,
     &                  RRE   ,RRM ,DDLE, DDLM,
     &                  DDEPLE,DDEPLM)

C
C --- ON CALCULE L'ETAT DE CONTACT ADHERENT OU GLISSANT
C
          CALL TTPRSM(NDIM  ,DDEPLE,DDEPLM,DLAGRF,COEFFR,
     &                TAU1  ,TAU2  ,MPROJT,INADH ,RESE  ,
     &                NRESE ,COEFFP,LPENAF,DVITET)
C
C --- CALCUL DU JEU INUTILE
C
C --- SI GLISSANT, NORMALISATION RESE
C
          IF (INADH.EQ.0)  CALL NORMEV(RESE,NRESE)
C
C --- VECTEUR FROTTEMENT
C
          CALL XMVEF1(NDIM  ,NNE   ,NNM,NDEPLE ,
     &                  NNC,NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI ,DLAGRC,DLAGRF,
     &                  COEFFR,LPENAF,COEFFF,TAU1  ,
     &                  TAU2  ,RESE  ,MPROJT ,
     &                  TYPMAI,NSINGE,NSINGM,RRE   ,RRM   ,
     &                  NVIT  ,CONTAC,DDLE,DDLM,NFHE,VTMP  )
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- SUPPRESSION DES DDLS SUPERFLUS (CONTACT ET XHTC)
C
      LESCLX = NSINGE.EQ.1.AND.NNM(1).NE.0
      LMAITX = NSINGM.EQ.1
      LCONTX = (CONTAC.EQ.1.OR.CONTAC.EQ.3).AND.NLACT.LT.NNE(2)
      CALL JEVECH('PSTANO' ,'L',JSTNO)
      CALL XTEDD2(NDIM,NNE,NDEPLE,NNM,NDDL,
     &             OPTION,LESCLX,LMAITX,LCONTX,ZI(JSTNO),LACT,DDLE,DDLM,
     &             NFHE,NFHM,LMULTI,ZI(JHEANO),R8BID,VTMP)

C
C --- RECOPIE VALEURS FINALES
C
      DO 250 I=1,NDDL
        ZR(IVECT-1+I)=VTMP(I)
 250  CONTINUE
C
      CALL JEDEMA()
      END
