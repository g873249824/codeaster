      SUBROUTINE DFDM1D ( NNO,POIDS,DFRDK,COOR,DFDX,COUR,JACP,COSA,SINA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 10/11/1999   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             NNO
      REAL*8                  DFRDK(1),COOR(1),DFDX(1)
      REAL*8                  DXDK,DYDK,COUR,JAC,JACP,POIDS,SINA,COSA
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES DERIVEES DE LA FONCTION DE FORME
C  PAR RAPPORT A UN ELEMENT COURANT EN 1 DIMENSION EN UN POINT DE GAUSS
C
C    - ARGUMENTS:
C        DONNEES:     NNO           -->  NOMBRE DE NOEUDS
C                     POIDS         -->  POIDS DE GAUSS
C                     DFRDK         -->  DERIVEES FONCTIONS DE FORME
C                     COOR          -->  COORDONNEES DES NOEUDS
C
C        RESULTATS:   DFDX          <--  DERIVEES DES FONCTIONS DE FORME
C                                        / ABSCISSE CURVILIGNE
C                     COUR          <--  COURBURE AU NOEUD
C                     COSA          <--  COS DE L'ANGLE ALPHA:
C                                        TANGENTE / HORIZONTALE
C                     SINA          <--  SIN DE L'ANGLE ALPHA
C                     JACP          <--  PRODUIT DU JACOBIEN ET DU POIDS
C ......................................................................
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*8 ZK8,NOMAIL
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER            I
C
      DXDK = 0.D0
      DYDK = 0.D0
      DO 100 I=1,NNO
        DXDK = DXDK + COOR( 2*I-1 ) * DFRDK(I)
        DYDK = DYDK + COOR( 2*I   ) * DFRDK(I)
100   CONTINUE
      JAC  = SQRT ( DXDK**2 + DYDK**2 )

      IF(ABS(JAC).LE.1.D0/R8GAEM()) THEN
         CALL TECAEL(IADZI,IAZK24)
         NOMAIL= ZK24(IAZK24-1+3)(1:8)
         CALL UTMESS('F','DFDM1D',
     &     ' LA TRANSFORMATION GEOMETRIQUE EST SINGULIERE'
     &   //' POUR LA MAILLE :'//NOMAIL//' (JACOBIEN =0.)')
      ENDIF

      COSA =  DYDK/JAC
      SINA = -DXDK/JAC
      D2XDK = COOR(1) + COOR(3) - 2.D0 * COOR(5)
      D2YDK = COOR(2) + COOR(4) - 2.D0 * COOR(6)
      COUR  = ( DXDK * D2YDK - D2XDK * DYDK ) / JAC**3
      DO 200 I=1,NNO
        DFDX(I) = DFRDK(I) / JAC
200   CONTINUE
      JACP = JAC * POIDS
      END
