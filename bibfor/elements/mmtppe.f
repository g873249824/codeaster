      SUBROUTINE MMTPPE(TYPMAE,TYPMAM,NDIM  ,NNE   ,NNM   ,
     &                  NNL   ,NBDM  ,IRESOG,LAXIS ,LDYNA ,
     &                  JEUSUP,PRFUSU,FFE   ,FFM   ,DFFM  ,
     &                  FFL   ,JACOBI,WPG   ,JEU   ,DJEUT ,
     &                  DLAGRC,DLAGRF,NORM  ,TAU1  ,TAU2  ,
     &                  MPROJN,MPROJT,MPRT1N,MPRT2N,GENE11,
     &                  GENE21)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 25/06/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'
      CHARACTER*8  TYPMAE,TYPMAM
      INTEGER      NDIM,NNE,NNM,NNL,NBDM
      INTEGER      IRESOG
      LOGICAL      LAXIS,LDYNA
      REAL*8       PRFUSU,JEUSUP
      REAL*8       JACOBI,WPG
      REAL*8       DLAGRC,DLAGRF(2)
      REAL*8       JEU,DJEU(3),DJEUT(3)
      REAL*8       FFE(9),FFM(9),FFL(9)
      REAL*8       DFFM(2,9)
      REAL*8       NORM(3),TAU1(3),TAU2(3)
      REAL*8       MPROJN(3,3),MPROJT(3,3)
      REAL*8       MPRT1N(3,3),MPRT2N(3,3)
      REAL*8       GENE11(3,3),GENE21(3,3)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
C
C PREPARATION DES CALCULS DES MATRICES - CALCUL DES QUANTITES
C CAS POIN_ELEM
C
C ----------------------------------------------------------------------
C
C
C IN  TYPMAE : NOM DE LA MAILLE ESCLAVE
C IN  TYPMAM : NOM DE LA MAILLE MAITRE
C IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  NNL    : NOMBRE DE NOEUDS PORTANT UN LAGRANGE DE CONTACT/FROTT
C IN  NBDM   : NOMBRE DE COMPOSANTES/NOEUD DES DEPL+LAGR_C+LAGR_F
C IN  IRESOG : ALGO. DE RESOLUTION POUR LA GEOMETRIE
C              0 - POINT FIXE
C              1 - NEWTON
C IN  LAXIS  : .TRUE. SI AXISYMETRIE
C IN  LDYNA  : .TRUE. SI DYNAMIQUE
C IN  JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
C IN  PRFUSU : JEU SUPPLEMENTAIRE PAR PROFONDEUR D'USURE
C OUT FFE    : FONCTIONS DE FORMES DEPL_ESCL
C OUT FFM    : FONCTIONS DE FORMES DEPL_MAIT
C OUT FFL    : FONCTIONS DE FORMES LAGR.
C OUT DFFM   : DERIVEES PREMIERES DES FONCTIONS DE FORME MAITRES
C OUT JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C OUT WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
C OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
C OUT JEU    : JEU NORMAL ACTUALISE
C OUT DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
C OUT NORM   : NORMALE
C OUT TAU1   : PREMIER VECTEUR TANGENT
C OUT TAU2   : SECOND VECTEUR TANGENT
C OUT MPROJN : MATRICE DE PROJECTION NORMALE [Pn]
C OUT MPROJT : MATRICE DE PROJECTION TANGENTE [Pt]
C OUT MPRONY : MATRICE DE PROJECTION (GEOME-GEOMM)/NORMALE
C OUT MPRT1N : MATRICE DE PROJECTION TANGENTE1/NORMALE
C OUT MPRT2N : MATRICE DE PROJECTION TANGENTE2/NORMALE
C OUT MPRNT1 : MATRICE DE PROJECTION NORMALE/TANGENTE1
C OUT MPRNT2 : MATRICE DE PROJECTION NORMALE/TANGENTE2
C OUT MPRT11 : MATRICE DE PROJECTION TANGENTE1/TANGENTE1
C OUT MPRT12 : MATRICE DE PROJECTION TANGENTE1/TANGENTE2
C OUT MPRT21 : MATRICE DE PROJECTION TANGENTE2/TANGENTE1
C OUT MPRT22 : MATRICE DE PROJECTION TANGENTE2/TANGENTE2
C OUT GENE11 : MATRICE
C OUT GENE12 : MATRICE
C OUT GENE21 : MATRICE
C OUT GENE22 : MATRICE
C
C ----------------------------------------------------------------------
C
      INTEGER      JPCF
      INTEGER      JGEOM,JDEPDE,JDEPM
      INTEGER      JACCM,JVITM,JVITP
      REAL*8       GEOMAE(9,3),GEOMAM(9,3)
      REAL*8       GEOMM(3),GEOME(3)
      REAL*8       DDEPLE(3),DDEPLM(3)
      REAL*8       DEPLME(3),DEPLMM(3)
      REAL*8       DFFE(2,9),DDFFE(3,9)
      REAL*8       DDFFM(3,9)
      REAL*8       DFFL(2,9),DDFFL(3,9)
      REAL*8       XPC,YPC,XPR,YPR
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- RECUPERATION DES DONNEES DE PROJECTION
C
      CALL JEVECH('PCONFR','L',JPCF )
      XPC      = ZR(JPCF-1+1)
      YPC      = ZR(JPCF-1+2)
      XPR      = ZR(JPCF-1+3)
      YPR      = ZR(JPCF-1+4)
      TAU1(1)  = ZR(JPCF-1+5)
      TAU1(2)  = ZR(JPCF-1+6)
      TAU1(3)  = ZR(JPCF-1+7)
      TAU2(1)  = ZR(JPCF-1+8)
      TAU2(2)  = ZR(JPCF-1+9)
      TAU2(3)  = ZR(JPCF-1+10)
      WPG      = ZR(JPCF-1+11)
C
C --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
C
      CALL JEVECH('PGEOMER','E',JGEOM )
      CALL JEVECH('PDEPL_P','E',JDEPDE)
      CALL JEVECH('PDEPL_M','L',JDEPM )
      IF (LDYNA) THEN
        CALL JEVECH('PVITE_P','L',JVITP )
        CALL JEVECH('PVITE_M','L',JVITM )
        CALL JEVECH('PACCE_M','L',JACCM )
      ENDIF
C
C --- FONCTIONS DE FORMES ET DERIVEES
C
      CALL MMFORM(NDIM  ,TYPMAE,TYPMAM,NNE   ,NNM   ,
     &            XPC   ,YPC   ,XPR   ,YPR   ,FFE   ,
     &            DFFE  ,DDFFE ,FFM   ,DFFM  ,DDFFM ,
     &            FFL   ,DFFL  ,DDFFL )
C
C --- JACOBIEN POUR LE POINT DE CONTACT
C
      CALL MMMJAC(TYPMAE,JGEOM ,FFE   ,DFFE  ,LAXIS ,
     &            NNE   ,NDIM  ,JACOBI)
C
C --- REACTUALISATION DE LA GEOMETRIE (MAILLAGE+DEPMOI)
C
      CALL MMREAC(NBDM  ,NDIM  ,NNE   ,NNM   ,JGEOM ,
     &            JDEPM ,GEOMAE,GEOMAM)
C
C --- CALCUL DES COORDONNEES ACTUALISEES
C
      CALL MMGEOM(IRESOG,NDIM  ,NNE   ,NNM   ,FFE   ,
     &            FFM   ,DDFFM ,GEOMAE,GEOMAM,TAU1  ,
     &            TAU2  ,NORM  ,MPROJN,MPROJT,GEOME ,
     &            GEOMM ,MPRT1N,MPRT2N,GENE11,GENE21)
C
C --- CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
C
      CALL MMLAGM(NBDM  ,NDIM  ,NNL   ,JDEPDE,FFL   ,
     &            DLAGRC,DLAGRF)
C
C --- MISE A JOUR DES CHAMPS INCONNUS INCREMENTAUX - DEPLACEMENTS
C
      CALL MMDEPM(NBDM  ,NDIM  ,NNE   ,NNM   ,JDEPM ,
     &            JDEPDE,FFE   ,FFM   ,DDEPLE,DDEPLM ,
     &            DEPLME,DEPLMM)
C
C --- CALCUL DES JEUX
C
      CALL MMMJEU(NDIM  ,JEUSUP,PRFUSU,NORM  ,GEOME ,
     &            GEOMM ,DDEPLE,DDEPLM,MPROJT,JEU   ,
     &            DJEU  ,DJEUT ,TAU1  ,TAU2  ,GENE11,
     &            GENE21)
C
      CALL JEDEMA()
C
      END
