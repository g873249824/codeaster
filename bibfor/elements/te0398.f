      SUBROUTINE TE0398(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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

      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE,OPTION
C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DU GRADIENT AUX NOEUDS D'UN CHAMP SCALAIRE
C                      AUX NOEUDS A 9 COMPOSANTES
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C.......................................................................
C
C
      REAL*8   DFDX(27),DFDY(27),DFDZ(27),JAC,GRADX,GRADY,GRADZ

      INTEGER  NDIM,NNO,NNOS,NPG
      INTEGER  IPOIDS,IVF,IDFDE,JGANO,IGEOM,INEUT,IGR
      INTEGER  I,KP,INO



C DEB ------------------------------------------------------------------

      CALL JEMARQ()

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)


      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PNEUTER','L',INEUT)
      CALL JEVECH('PGNEUTR','E',IGR)

C   C'EST SUREMENT MIEUX D'INVERSER LES BOUCLES !!

C     BOUCLE SUR LES 9 CHAMPS SCALAIRES D'ENTREE
      DO 100 I=1,9

C       BOUCLE SUR LES POINTS DE GAUSS
        DO 200 KP=1,NPG
          CALL DFDM3D(NNO,KP,IPOIDS,IDFDE,
     &                 ZR(IGEOM),DFDX,DFDY,DFDZ,JAC)
          GRADX = 0.0D0
          GRADY = 0.0D0
          GRADZ = 0.0D0
          DO 210 INO = 1,NNO
            GRADX = GRADX + ZR(INEUT-1+9*(INO-1)+I) * DFDX(INO)
            GRADY = GRADY + ZR(INEUT-1+9*(INO-1)+I) * DFDY(INO)
            GRADZ = GRADZ + ZR(INEUT-1+9*(INO-1)+I) * DFDZ(INO)
 210      CONTINUE
          ZR(IGR-1+27*(KP-1)+3*(I-1)+1)= GRADX
          ZR(IGR-1+27*(KP-1)+3*(I-1)+2)= GRADY
          ZR(IGR-1+27*(KP-1)+3*(I-1)+3)= GRADZ
 200    CONTINUE

 100  CONTINUE

      CALL JEDEMA()

C FIN ------------------------------------------------------------------
      END
