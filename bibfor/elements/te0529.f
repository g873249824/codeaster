      SUBROUTINE TE0529(OPTION,NOMTE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

C     BUT: CALCUL DES DEFORMATIONS LIEES AUX VARIABLES DE COMMANDE
C          AUX POINTS D'INTEGRATION DES ELEMENTS ISOPARAMETRIQUES 3D

C          OPTIONS : 'EPVC_ELGA'
C    CINQ COMPOSANTES :
C    EPTHER_L = DILATATION THERMIQUE (LONGI)   : ALPHA_L*(T-TREF)
C    EPTHER_T = DILATATION THERMIQUE (TRANSV)   : ALPHA_T*(T-TREF)
C    EPTHER_N = DILATATION THERMIQUE (NORMLALE)   : ALPHA_N*(T-TREF)
C    EPSECH = RETRAIT DE DESSICCATION : -K_DESSIC(SREF-SECH)
C    EPHYDR = RETRAIT ENDOGENE        : -B_ENDOGE*HYDR
C    EPPTOT = RETRAIT DU A LA PRESSION DE FLUIDE EN THM CHAINEE :
C             -BIOT*PTOT
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      INTEGER JGANO,NDIM,NNO,I,NNOS,NPG,IPOIDS,IVF,IDFDE,
     &        IGAU,ISIG,IGEOM,
     &        ITEMPS,IDEFO,IMATE,IRET,NBCMP,IDIM
      REAL*8 EPVC(162),REPERE(7)
      REAL*8 INSTAN,EPSSE(6),EPSTH(6),EPSHY(6),EPSPT(6)
      REAL*8 XYZGAU(3),XYZ(3)
      CHARACTER*4 FAMI
      CHARACTER*16 OPTIO2
C DEB ------------------------------------------------------------------

C    NOMBRE DE COMPOSANTES  A  CALCULER
      NBCMP=6

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES :
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU :
C      ----------------------------------------------
      CALL TECACH('NNN','PMATERC','L',1,IMATE,IRET)

C --- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE :
C     ------------------------------------------------------------
C     COORDONNEES DU BARYCENTRE ( POUR LE REPERE CYLINDRIQUE )
      XYZ(1) = 0.D0
      XYZ(2) = 0.D0
      XYZ(3) = 0.D0
      DO 300 I = 1,NNO
        DO 310 IDIM = 1,NDIM
          XYZ(IDIM) = XYZ(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 310    CONTINUE
 300  CONTINUE
      CALL ORTREP(ZI(IMATE),NDIM,XYZ,REPERE)

C ---- RECUPERATION DE L'INSTANT DE CALCUL :
C      -----------------------------------
      CALL TECACH('NNN','PTEMPSR','L',1,ITEMPS,IRET)
      IF (ITEMPS.NE.0) THEN
        INSTAN = ZR(ITEMPS)
      END IF

C     -----------------
C ---- RECUPERATION DU VECTEUR DES DEFORMATIONS EN SORTIE :
C      --------------------------------------------------
      CALL JEVECH('PDEFOPG','E',IDEFO)
      CALL R8INIR(135,0.D0,EPVC,1)


      DO 200 IGAU = 1 , NPG

C      CALCUL AU POINT DE GAUSS DE LA TEMPERATURE ET
C       DU REPERE D'ORTHOTROPIE
C ------------------------------------------
           XYZGAU(1) = 0.D0
           XYZGAU(2) = 0.D0
           XYZGAU(3) = 0.D0
             DO 55 IDIM = 1, NDIM
               XYZGAU(IDIM) = XYZGAU(IDIM) +
     +          ZR(IVF+IDIM-1+NNO*(IGAU-1))*
     +                 ZR(IGEOM+IDIM-1+NDIM*(IDIM-1))
  55         CONTINUE


        OPTIO2 = 'EPVC_ELGA_TEMP'

        CALL EPSTMC(FAMI,NDIM,
     &    INSTAN,'+',IGAU,1,XYZGAU,REPERE,ZI(IMATE),OPTIO2,EPSTH)
        OPTIO2 = 'EPVC_ELGA_SECH'
        CALL EPSTMC(FAMI,NDIM,
     &    INSTAN,'+',IGAU,1,XYZGAU,REPERE,ZI(IMATE),OPTIO2,EPSSE)
        OPTIO2 = 'EPVC_ELGA_HYDR'
        CALL EPSTMC(FAMI,NDIM,
     &    INSTAN,'+',IGAU,1,XYZGAU,REPERE,ZI(IMATE),OPTIO2,EPSHY)
        OPTIO2 = 'EPVC_ELGA_PTOT'
        CALL EPSTMC(FAMI,NDIM,
     &    INSTAN,'+',IGAU,1,XYZGAU,REPERE,ZI(IMATE),OPTIO2,EPSPT)
        DO 60 I=1,3
         EPVC(I+NBCMP*(IGAU-1)) = EPSTH(I)
 60     CONTINUE
         EPVC(4+NBCMP*(IGAU-1) )= EPSSE(1)
         EPVC(5+NBCMP*(IGAU-1) )= EPSHY(1)
         EPVC(6+NBCMP*(IGAU-1) )= EPSPT(1)

  200  CONTINUE

C         --------------------
C ---- AFFECTATION DU VECTEUR EN SORTIE AVEC LES DEFORMATIONS AUX
C ---- POINTS D'INTEGRATION :
C      --------------------
        DO 80 IGAU = 1,NPG
          DO 70 ISIG = 1,NBCMP
            ZR(IDEFO+NBCMP* (IGAU-1)+ISIG-1) = EPVC(NBCMP* (IGAU-1)+
     &        ISIG)
   70     CONTINUE
   80   CONTINUE


      END
