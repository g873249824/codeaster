      SUBROUTINE TE0558 ( OPTION , NOMTE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT NONE
C
      CHARACTER*16 OPTION, NOMTE
C
C ......................................................................
C
C    - FONCTION REALISEE : CALCUL DE LA DERIVEE LAGRANGIENNE DU TENSEUR
C                          DES CONTRAINTES
C
C          OPTION : 'DLAG_ELGA_SIGM'
C
C  DLAG(SIGMA) = 0.5 * HOOKE * ( GRAD(DLAG(U)) + GRAD(DLAG(U))T )
C   - 0.5 * HOOKE * ( T(GRAD(U),GRAD(THETA)) + T(GRAD(U),GRAD(THETA))T )
C         + K * DLAGTE * IDENTITE
C
C    - ELEMENTS ISOPARAMETRIQUES 2D
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      REAL*8 R
      REAL*8 POIDS, DFDX(9), DFDY(9)
      REAL*8 GRADTH(3,3), THETAR
      REAL*8 EPSI, R8PREM
      REAL*8 DLAGTG, GRADU(3,3), UR, GRADDU(3,3), DUR
      REAL*8 LAMBDA(3), LAGUGT(4), KDLTID
      REAL*8 INSTAN
      REAL*8 TEMPER
      REAL*8 R8AUX
C
      INTEGER IGEOM, IMATE, IPOIDS, IVF, IDFDE
      INTEGER NNO, NPG, NDIM, NNOS, JGANO
      INTEGER KP, I, K, IDEB, IFIN
      INTEGER ITEMPS, IDEPL, ITEMPE, IDLAGT, IDLAGD
      INTEGER IDLAGS
      INTEGER ITHETA
C
      LOGICAL DPAXI
      LOGICAL THTNUL, DLTNUL
      LOGICAL AXI
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
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
      CHARACTER*6        PGC
      COMMON  / NOMAJE / PGC
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C====
C 1. INITIALISATIONS ET CONTROLE DE LA NULLITE DE THETA
C====
C
      EPSI = R8PREM ()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH('PVECTTH','L',ITHETA)
      CALL JEVECH('PGEOMER','L',IGEOM)
C
      IDEB = ITHETA
      IFIN = ITHETA + 2*NNO - 1
      THTNUL = .TRUE.
      DO 102 , I = IDEB , IFIN
        IF ( ABS(ZR(I)).GT.EPSI ) THEN
          THTNUL = .FALSE.
        ENDIF
  102 CONTINUE
C
      CALL JEVECH('PDLAGTE','L',IDLAGT)
C
      IDEB = IDLAGT
      IFIN = IDLAGT + NNO - 1
      DLTNUL = .TRUE.
      DO 103 , I = IDEB , IFIN
        IF ( ABS(ZR(I)).GT.EPSI ) THEN
          DLTNUL = .FALSE.
        ENDIF
 103  CONTINUE
C
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PDLAGDE','L',IDLAGD)
      CALL JEVECH('PDEPLAR','L',IDEPL)
C
      CALL JEVECH('PDLAGSG','E',IDLAGS)
C
      IF ( NOMTE(3:4) .EQ. 'AX' ) THEN
        AXI = .TRUE.
        DPAXI = .TRUE.
      ELSE
        AXI = .FALSE.
        IF ( NOMTE(3:4).EQ.'DP' ) THEN
          DPAXI = .TRUE.
        ELSEIF (NOMTE(3:4).EQ.'CP') THEN
          DPAXI = .FALSE.
        ELSE
          CALL UTMESS('F','TE0558','LA MODELISATION : '//NOMTE//
     >              'N''EST PAS TRAITEE.')
        ENDIF
      ENDIF
C
C     INSTAN : L'INSTANT COURANT
C
      INSTAN = ZR(ITEMPS)
C
C====
C 2. BOUCLE SUR LES POINTS DE GAUSS
C====
C
      DO 202 , KP = 1 , NPG
C
        K = (KP-1)*NNO
C
        CALL DFDM2D ( NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS )
C
C 2.2.1. ==> CALCUL DES GRADIENTS DU DEPLACEMENT ET DE SA DERIVEE,
C            DE LA DERIVEE LAGRANGIENNE DE T,
C            DU GRADIENT ET DE LA DIVERGENCE DE THETA AU POINT DE GAUSS
C   GRADTH(I,K) = D THETA I / D X K
C   SI THETA EST NUL, IL SUFFIT DE CALCULER LA TEMPERATURE, SA DERIVEE
C   ET LE GRADIENT DE LA DERIVEE DU DEPLACEMENT
C
        TEMPER      = 0.D0
        GRADDU(1,1) = 0.D0
        GRADDU(1,2) = 0.D0
        GRADDU(2,1) = 0.D0
        GRADDU(2,2) = 0.D0
        DLAGTG      = 0.D0
C
        IF ( THTNUL ) THEN
C
          DO 2211 , I = 1 , NNO
            TEMPER      = TEMPER      + ZR(ITEMPE+I-1)*ZR(IVF+K+I-1)
            DLAGTG      = DLAGTG      + ZR(IDLAGT+I-1)*ZR(IVF+K+I-1)
            GRADDU(1,1) = GRADDU(1,1) + ZR(IDLAGD+2*I-2)*DFDX(I)
            GRADDU(1,2) = GRADDU(1,2) + ZR(IDLAGD+2*I-2)*DFDY(I)
            GRADDU(2,1) = GRADDU(2,1) + ZR(IDLAGD+2*I-1)*DFDX(I)
            GRADDU(2,2) = GRADDU(2,2) + ZR(IDLAGD+2*I-1)*DFDY(I)
 2211     CONTINUE
C
        ELSE
C
          GRADU(1,1)  = 0.D0
          GRADU(1,2)  = 0.D0
          GRADU(2,1)  = 0.D0
          GRADU(2,2)  = 0.D0
          GRADTH(1,1) = 0.D0
          GRADTH(1,2) = 0.D0
          GRADTH(2,1) = 0.D0
          GRADTH(2,2) = 0.D0
          DO 2212 , I = 1 , NNO
            TEMPER      = TEMPER      + ZR(ITEMPE+I-1)*ZR(IVF+K+I-1)
            DLAGTG      = DLAGTG      + ZR(IDLAGT+I-1)*ZR(IVF+K+I-1)
            GRADDU(1,1) = GRADDU(1,1) + ZR(IDLAGD+2*I-2)*DFDX(I)
            GRADDU(1,2) = GRADDU(1,2) + ZR(IDLAGD+2*I-2)*DFDY(I)
            GRADDU(2,1) = GRADDU(2,1) + ZR(IDLAGD+2*I-1)*DFDX(I)
            GRADDU(2,2) = GRADDU(2,2) + ZR(IDLAGD+2*I-1)*DFDY(I)
            GRADU(1,1)  = GRADU(1,1)  + ZR(IDEPL+2*I-2)*DFDX(I)
            GRADU(1,2)  = GRADU(1,2)  + ZR(IDEPL+2*I-2)*DFDY(I)
            GRADU(2,1)  = GRADU(2,1)  + ZR(IDEPL+2*I-1)*DFDX(I)
            GRADU(2,2)  = GRADU(2,2)  + ZR(IDEPL+2*I-1)*DFDY(I)
            GRADTH(1,1) = GRADTH(1,1) + ZR(ITHETA+2*I-2)*DFDX(I)
            GRADTH(1,2) = GRADTH(1,2) + ZR(ITHETA+2*I-2)*DFDY(I)
            GRADTH(2,1) = GRADTH(2,1) + ZR(ITHETA+2*I-1)*DFDX(I)
            GRADTH(2,2) = GRADTH(2,2) + ZR(ITHETA+2*I-1)*DFDY(I)
 2212     CONTINUE
C
        ENDIF
C
C 2.2.2. ==> EN 2D-AXI, TERME
C COMPLEMENTAIRE SUR LES GRADIENTS EN UR/R
C LES POINTS DE GAUSS ETANT TOUJOURS STRICTEMENT INTERIEURS
C A L'ELEMENT, R NE PEUT PAS ETRE NUL, DONC ON PEUT DIVISER PAR R.
C
        IF ( AXI ) THEN
          R  = 0.D0
          THETAR = 0.D0
          UR  = 0.D0
          DUR = 0.D0
          DO 222 , I = 1 , NNO
            R8AUX = ZR(IVF+K+I-1)
            R      = R      +  ZR(IGEOM+2*I-2)*R8AUX
            THETAR = THETAR + ZR(ITHETA+2*I-2)*R8AUX
            UR     = UR     +  ZR(IDEPL+2*I-2)*R8AUX
            DUR    = DUR    + ZR(IDLAGD+2*I-2)*R8AUX
222     CONTINUE
          GRADU(3,3)  = UR / R
          GRADTH(3,3) = THETAR / R
          GRADDU(3,3) = DUR / R
        ENDIF
C
C 2.2.3. ==> CALCUL DES TENSEURS
C     0.5 * ( MATRICE DE HOOKE )
C     * ( T(GRAD(U),GRAD(THETA)) + T(GRAD(U),GRAD(THETA))T )
C                ET
C     K * DLAGTE * IDENTITE
C
        CALL DEEUT1 ( LAMBDA, LAGUGT, KDLTID,
     >                ZI(IMATE), INSTAN, R,
     >                THTNUL, AXI   , DPAXI,
     >                TEMPER, DLAGTG, DLTNUL, GRADU , GRADTH )
C
C 2.2.4. ==> TERMES EN
C       0.5 * HOOKE * ( GRAD(DLAG(U)) + GRAD(DLAG(U))T )
C
        I = IDLAGS + 4*(KP-1)
        ZR(I)   = LAMBDA(1)*GRADDU(1,1) + LAMBDA(2)*GRADDU(2,2)
        ZR(I+1) = LAMBDA(2)*GRADDU(1,1) + LAMBDA(1)*GRADDU(2,2)
        ZR(I+2) = LAMBDA(2)*GRADDU(1,1) + LAMBDA(2)*GRADDU(2,2)
        ZR(I+3) = 0.5D0 * LAMBDA(3) * ( GRADDU(1,2) + GRADDU(2,1) )
        IF ( AXI ) THEN
          ZR(I)   = ZR(I)   + LAMBDA(2)*GRADDU(3,3)
          ZR(I+1) = ZR(I+1) + LAMBDA(2)*GRADDU(3,3)
          ZR(I+2) = ZR(I+2) + LAMBDA(1)*GRADDU(3,3)
        ENDIF
C
C 2.2.5. ==> TERMES EN
C       0.5 * ( MATRICE DE HOOKE )
C     * ( T(GRAD(U),GRAD(THETA)) + T(GRAD(U),GRAD(THETA))T )
C
        IF ( .NOT.THTNUL ) THEN
C
          ZR(I)   = ZR(I)   - LAGUGT(1)
          ZR(I+1) = ZR(I+1) - LAGUGT(2)
          ZR(I+2) = ZR(I+2) - LAGUGT(3)
          ZR(I+3) = ZR(I+3) - LAGUGT(4)
C
        ENDIF
C
C 2.2.6. ==> TERMES EN K * DLAGTE * IDENTITE
C
        IF ( .NOT.DLTNUL ) THEN
C
          ZR(I)   = ZR(I)   + KDLTID
          ZR(I+1) = ZR(I+1) + KDLTID
          ZR(I+2) = ZR(I+2) + KDLTID
C
        ENDIF
C
  202 CONTINUE
C
      END
