      SUBROUTINE TE0024(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 NOMTE,OPTION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/09/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DU GRADIENT AUX NOEUDS D'UN CHAMP SCALAIRE
C                      AUX NOEUDS
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C.......................................................................
C
C
      REAL*8   DFDX(27), DFDY(27), DFDZ(27), JAC
      REAL*8   GRADX, GRADY, GRADZ
      CHARACTER*8 ELP,ELPQ
      INTEGER  NDIM, NNO, NNOS, NPG
      INTEGER  INO, I, IBID
      INTEGER  IPOIDS, IVF, IDFDE, JGAN, IGEOM, INEUT
      INTEGER  IGR

      LOGICAL  DEBUG
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

C DEB ------------------------------------------------------------------

      CALL JEMARQ()

      CALL ELREF1(ELP)

C     ON CALCULE LES GRADIENTS SUR TOUS LES NOEUDS DE L'ELEMENT DE REF
      CALL ELREF4(ELP,'NOEU',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGAN)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PNEUTER','L',INEUT)
      CALL JEVECH('PGNEUTR','E',IGR)

C     BOUCLE SUR LES NOEUDS
      DO 100 INO=1,NNO
        IF (NDIM .EQ. 3) THEN
          CALL DFDM3D(NNO,INO,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,DFDZ,JAC)
        ELSE IF (NDIM .EQ. 2) THEN
          CALL DFDM2D(NNO,INO,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,JAC)
        ENDIF

        GRADX = 0.0D0
        GRADY = 0.0D0
        GRADZ = 0.0D0

        DO 110 I = 1,NNO

          GRADX = GRADX + DFDX(I)*ZR(INEUT+I-1)
          GRADY = GRADY + DFDY(I)*ZR(INEUT+I-1)
        IF (NDIM .EQ. 3)  GRADZ = GRADZ + DFDZ(I)*ZR(INEUT+I-1)

 110    CONTINUE
        ZR(IGR-1+(INO-1)*NDIM+1)= GRADX
        ZR(IGR-1+(INO-1)*NDIM+2)= GRADY
        IF (NDIM .EQ. 3) ZR(IGR-1+(INO-1)*NDIM+3)= GRADZ

 100  CONTINUE
      
      CALL JEDEMA()

C FIN ------------------------------------------------------------------
      END
