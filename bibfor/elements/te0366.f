       SUBROUTINE TE0366(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/04/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  CALCUL CALCUL DES MATRICES DE CONTACT ET DE FROTTEMENT
C  DE COULOMB STANDARD POUR LA METHODE XFEM EN GRANDS GLISSEMENTS
C
C  OPTION : 'RIGI_CONT' (CALCUL DES MATRICES DE CONTACT )
C           'RIGI_FROT' (CALCUL DES MATRICES DE FROTTEMENT STANDARD)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER      N
      PARAMETER    (N=168)
C
      INTEGER      I,J,IJ,NFAES
      INTEGER      NDIM,NDDL,NNE,NNES,NNM,NNC,NDDLSE
      INTEGER      NSINGE,NSINGM
      INTEGER      IMATT,JPCPO
      INTEGER      JPCPI,JPCAI,JPCCF,JSTNO
      INTEGER      INDNOR,IFROTT,INDCO
      INTEGER      CFACE(5,3)
      INTEGER      JDEPDE,JDEPM,JGEOM     
      REAL*8       MMAT(N,N),TAU1(3),TAU2(3),NORM(3)
      REAL*8       MPROJT(3,3)
      REAL*8       COORE(3),COORM(3),COORC(2)
      REAL*8       FFE(8),FFM(8),FFC(8),DFFC(2,8)       
      REAL*8       JACOBI,HPG
      CHARACTER*8  TYPMAE,TYPMAM,TYPMAC,TYPMAI
      INTEGER      INADH,NVIT,LACT(8),NLACT,NINTER
      REAL*8       GEOPI(9)
      REAL*8       COEFFF,COEFCA,COEFFA,COEFFP
      REAL*8       RESE(3),NRESE
      REAL*8       RRE,RRM,JEU,R8BID
      REAL*8       DDEPLE(3),DDEPLM(3),DLAGRC,DLAGRF(2)
      LOGICAL      LMALIN,LPENAF,LESCLX,LMAITX,LCONTX

C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFOS SUR LA MAILLE DE CONTACT
C
      CALL XMELET(NOMTE ,TYPMAI,TYPMAE,TYPMAM,TYPMAC,
     &            NDIM  ,NDDL  ,NNE   ,NNM   ,NNC   ,
     &            LMALIN,NNES  ,NDDLSE,NSINGE,NSINGM) 
      CALL ASSERT(NDDL.LE.N)
C
C --- INITIALISATIONS
C
      CALL MATINI(N   ,N     ,0.D0  ,MMAT  )         
      CALL VECINI(9   ,0.D0  ,GEOPI )
      CALL VECINI(2  ,0.D0  ,DLAGRF)
      CALL VECINI(3  ,0.D0  ,DDEPLE)
      CALL VECINI(3  ,0.D0  ,DDEPLM)      
      DLAGRC = 0.D0
      JEU    = 0.D0
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT 'POINT' (VOIR MMCART)
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
      NINTER   = NINT(ZR(JPCPO-1+12))
      COEFCA   = ZR(JPCPO-1+13)
      COEFFA   = ZR(JPCPO-1+14)
      COEFFF   = ZR(JPCPO-1+15)
      IFROTT   = NINT(ZR(JPCPO-1+16))
      INDNOR   = NINT(ZR(JPCPO-1+17))
      HPG      = ZR(JPCPO-1+19)
C --- LE NUMERO DE LA FACETTE DE CONTACT ESCLAVE
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
      RRE       = ZR(JPCPO-1+18)
      RRM       = ZR(JPCPO-1+23)
      IF (NNM.EQ.0) RRE = 2*RRE
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
C --- PAS DE 'PENALISATION' EN GRANDS GLISSEMENTS
C
      COEFFP=0.0D0
      LPENAF=.FALSE.
C
C --- ON CONSTRUIT LA MATRICE DE CONNECTIVITÉ CFACE (MAILLE ESCLAVE)
C --- CE QUI SUIT N'EST VALABLE QU'EN 2D POUR LA FORMULATION QUADRATIQUE
C --- EN 3D ON UTILISE SEULEMENT LA FORMULATION AUX NOEUDS SOMMETS,
C --- CETTE MATRICE EST DONC INUTILE, ON NE LA CONSTRUIT PAS !!!
C
      CFACE(1,1) = 1
      CFACE(1,2) = 2
C
C --- CALCUL DES COORDONNEES REELLES DES POINTS D'INTERSECTION ESCLAVES
C
      CALL XMPINT(NDIM  ,NFAES ,JPCPI ,JPCCF ,GEOPI )
C
C --- FONCTIONS DE FORME
C
      CALL XTFORM(NDIM  ,TYPMAE,TYPMAM,TYPMAC,NNES  ,
     &            NNM   ,NNC   ,COORE ,COORM ,COORC ,
     &            FFE   ,FFM   ,DFFC  )
C
C --- FONCTION DE FORMES POUR LES LAGRANGIENS
C --- SI ON EST EN LINEAIRE, ON IMPOSE QUE LE NB DE NOEUDS DE CONTACTS
C --- ET LES FFS LAGRANGES DE CONTACT SONT IDENTIQUES A CEUX
C --- DES DEPLACEMENTS DANS LA MAILLE ESCLAVE POUR LE CALCUL DES CONTRIB
C
      IF (LMALIN) THEN
        NNC   = NNE
        CALL XLACTI(TYPMAI,NINTER,JPCAI,LACT,NLACT)
        CALL XMOFFC(LACT,NLACT,NNC,FFE,FFC)
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
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C
      IF (INDNOR .EQ. 1) THEN
        INDCO = 0
      ENDIF
C
C --- CALCUL DES MATRICES DE CONTACT
C
      IF (OPTION.EQ.'RIGI_CONT') THEN
        IF (INDCO.EQ.1) THEN
C
C --- CALCUL DES MATRICES A, AT, AU - CAS DU CONTACT
C
          CALL XMMAA1(NDIM  ,NNE   ,NNES  ,NNC   ,NNM   ,
     &                NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                FFM   ,JACOBI,JPCAI ,COEFCA,NORM  ,
     &                TYPMAI,NSINGE,NSINGM,RRE   ,RRM   ,
     &                NDDLSE,MMAT  )
C     
        ELSE IF (INDCO .EQ. 0) THEN
          IF (NVIT.EQ.1) THEN
C
C --- CALCUL DE LA MATRICE C - CAS SANS CONTACT
C
            CALL XMMAA0(NDIM  ,NNC   ,NNE   ,NNES  ,HPG   ,
     &                  NFAES ,CFACE ,FFC   ,JACOBI,JPCAI ,
     &                  COEFCA,TYPMAI,NDDLSE,MMAT  )
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
      ELSEIF (OPTION.EQ.'RIGI_FROT') THEN
C
C --- CALCUL DES INCREMENTS - LAGRANGE DE CONTACT
C  
        CALL XTLAGC(TYPMAI,NDIM  ,NNC   ,NNE   ,NNES   ,
     &              NDDLSE,NFAES ,CFACE ,JDEPDE,JPCAI  ,
     &              FFC   ,DLAGRC)
         
        IF (COEFFF.EQ.0.D0) INDCO = 0
        IF (DLAGRC.EQ.0.D0) INDCO = 0
        IF (IFROTT.NE.3)    INDCO = 0
C
        IF (INDCO.EQ.0) THEN
          IF (NVIT.EQ.1) THEN       
C
C --- CALCUL DE LA MATRICE F - CAS SANS FROTTEMENT
C
            CALL XMMAB0(NDIM  ,NNC   ,NNE   ,NNES  ,NFAES ,
     &                  JPCAI ,HPG   ,FFC   ,JACOBI,COEFCA,
     &                  TYPMAI,CFACE ,TAU1  ,TAU2  ,NDDLSE,
     &                  MMAT  )
          ENDIF
        ELSE IF (INDCO.EQ.1) THEN
C
C --- CALCUL DES INCREMENTS - DEPLACEMENTS
C     
          CALL XTDEPM(NDIM  ,NNM   ,NNE   ,NNES  ,NDDLSE,
     &                NSINGE,NSINGM,FFE   ,FFM   ,JDEPDE,
     &                RRE   ,RRM   ,DDEPLE,DDEPLM)
C
C --- CALCUL DES INCREMENTS - LAGRANGE DE FROTTEMENT
C      
          CALL XTLAGF(TYPMAI,NDIM  ,NNC   ,NNE   ,NNES   ,
     &                NDDLSE,NFAES ,CFACE ,JDEPDE,JPCAI  ,
     &                FFC   ,DLAGRF)
C      
C --- ON CALCULE L'ETAT DE CONTACT ADHERENT OU GLISSANT
C      
          CALL TTPRSM(NDIM  ,DDEPLE,DDEPLM,DLAGRF,COEFFA,
     &                TAU1  ,TAU2  ,MPROJT,INADH ,RESE  ,
     &                NRESE ,COEFFP,LPENAF)
C
C --- CALCUL DU JEU     
C     
          CALL XMMJEU(NDIM  ,NNM   ,NNE   ,NNES  ,NDDLSE,
     &                NSINGE,NSINGM,FFE   ,FFM   ,NORM  ,
     &                JGEOM ,JDEPDE,JDEPM ,RRE   ,RRM   ,
     &                JEU   )
C
          IF (INADH.EQ.1) THEN
C
C --- CALCUL DE B, BT, BU - CAS ADHERENT
C
            CALL XMMAB1(NDIM  ,NNE   ,NNES  ,NNC   ,NNM   ,
     &                  NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI ,DLAGRC,COEFCA,   
     &                  JEU   ,COEFFA,COEFFF,TAU1  ,TAU2  ,
     &                  RESE  ,MPROJT,NORM  ,TYPMAI,NSINGE,
     &                  NSINGM,RRE   ,RRM   ,NVIT  ,NDDLSE,
     &                  MMAT  )
C                  
          ELSE IF (INADH.EQ.0) THEN
C
C --- CALCUL DE B, BT, BU, F - CAS GLISSANT
C
            CALL XMMAB2(NDIM  ,NNE   ,NNES  ,NNC   ,NNM   ,
     &                  NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI, DLAGRC,COEFCA,   
     &                  JEU   ,COEFFA,COEFFF,TAU1  ,TAU2  ,
     &                  RESE  ,NRESE ,MPROJT,NORM  ,TYPMAI,
     &                  NSINGE,NSINGM,RRE   ,RRM   ,NVIT  ,
     &                  NDDLSE,MMAT)
          END IF
        ELSE
          CALL ASSERT(.FALSE.)
        END IF
      ELSE
        CALL ASSERT(OPTION.EQ.'RIGI_FROT' .OR.
     &              OPTION.EQ.'RIGI_CONT')  
      END IF
C
C --- SUPPRESSION DES DDLS SUPERFLUS (CONTACT ET XHTC)
C
      LESCLX = NSINGE.EQ.1.AND.NNM.NE.0
      LMAITX = NSINGM.EQ.1
      LCONTX = LMALIN.AND.NLACT.LT.NNES
      IF (LESCLX.OR.LMAITX.OR.LCONTX) THEN
        CALL JEVECH('PSTANO' ,'L',JSTNO)
        CALL XTEDD2(NDIM  ,NNES  ,NNM   ,NDDL  ,NDDLSE,OPTION,
     &              LESCLX,LMAITX,LCONTX,ZI(JSTNO),LACT,
     &              MMAT  ,R8BID  )
      ENDIF
C
C --- RECOPIE VALEURS FINALES (SYMETRIQUE OU NON)
C
      IF (OPTION.EQ.'RIGI_CONT'.OR.INDCO.EQ.0) THEN
        CALL JEVECH('PMATUUR','E',IMATT)
        DO 700 J = 1,NDDL
          DO 710 I = 1,J
            IJ = (J-1)*J/2 + I
            ZR(IMATT+IJ-1) = MMAT(I,J)
 710      CONTINUE
 700    CONTINUE
      ELSE
        CALL JEVECH('PMATUNS','E',IMATT)
        DO 800 J = 1,NDDL
          DO 810 I = 1,NDDL
            IJ = NDDL*(I-1) + J
            ZR(IMATT+IJ-1) = MMAT(I,J)
 810      CONTINUE
 800    CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
