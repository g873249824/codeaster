      SUBROUTINE DFDM3D ( NNO, POIDS, DFRDE, DFRDN, DFRDK, COOR,
     &DFDX, DFDY, DFDZ, JAC )
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
      REAL*8            POIDS,DFRDE(1),DFRDN(1),DFRDK(1),COOR(1)
      REAL*8            DE,DN,DK
      REAL*8                             DFDX(1),DFDY(1),DFDZ(1),JAC
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES DERIVEES DES FONCTIONS DE FORME
C               PAR RAPPORT A UN ELEMENT COURANT EN UN POINT DE GAUSS
C               POUR LES ELEMENTS 3D
C
C    - ARGUMENTS:
C        DONNEES:     NNO           -->  NOMBRE DE NOEUDS
C                     POIDS         -->  POIDS DU POINT DE GAUSS
C              DFDRDE,DFRDN,DFRDK   -->  DERIVEES FONCTIONS DE FORME
C                     COOR          -->  COORDONNEES DES NOEUDS
C
C        RESULTATS:   DFDX          <--  DERIVEES DES F. DE F. / X
C                     DFDY          <--  DERIVEES DES F. DE F. / Y
C                     DFDZ          <--  DERIVEES DES F. DE F. / Z
C                     JAC           <--  JACOBIEN AU POINT DE GAUSS
C ......................................................................
C
      REAL*8             G(3,3)
      REAL*8             J11,J12,J13,J21,J22,J23,J31,J32,J33
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*8 ZK8,NOMAIL
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
      DO 1 I=1,3
      DO 1 J=1,3
      G(I,J) = 0.D0
1     CONTINUE
C
      DO 100 I=1,NNO
      II = 3*(I-1)
        DE = DFRDE(II+1)
        DN = DFRDN(II+1)
        DK = DFRDK(II+1)
      DO 101 J=1,3
        G(1,J) = G(1,J) + COOR(II+J) * DE
        G(2,J) = G(2,J) + COOR(II+J) * DN
        G(3,J) = G(3,J) + COOR(II+J) * DK
101   CONTINUE
100   CONTINUE
C
      J11 = G(2,2) * G(3,3) - G(2,3) * G(3,2)
      J21 = G(3,1) * G(2,3) - G(2,1) * G(3,3)
      J31 = G(2,1) * G(3,2) - G(3,1) * G(2,2)
      J12 = G(1,3) * G(3,2) - G(1,2) * G(3,3)
      J22 = G(1,1) * G(3,3) - G(1,3) * G(3,1)
      J32 = G(1,2) * G(3,1) - G(3,2) * G(1,1)
      J13 = G(1,2) * G(2,3) - G(1,3) * G(2,2)
      J23 = G(2,1) * G(1,3) - G(2,3) * G(1,1)
      J33 = G(1,1) * G(2,2) - G(1,2) * G(2,1)

      JAC = G(1,1) * J11 + G(1,2) * J21 + G(1,3) * J31

      IF(ABS(JAC).LE.1.D0/R8GAEM()) THEN
         CALL TECAEL(IADZI,IAZK24)
         NOMAIL= ZK24(IAZK24-1+3)(1:8)
         CALL UTMESS('F','DFDM3D',
     &     ' LA TRANSFORMATION GEOMETRIQUE EST SINGULIERE'
     &   //' POUR LA MAILLE :'//NOMAIL//' (JACOBIEN =0.)')
      ENDIF

      DO 200 I=1,NNO
      J = 3*(I-1) + 1
      DFDX(I) = (J11 * DFRDE(J) + J12 * DFRDN(J) + J13 * DFRDK(J))/JAC
      DFDY(I) = (J21 * DFRDE(J) + J22 * DFRDN(J) + J23 * DFRDK(J))/JAC
      DFDZ(I) = (J31 * DFRDE(J) + J32 * DFRDN(J) + J33 * DFRDK(J))/JAC
200   CONTINUE
C
      JAC=ABS(JAC)*POIDS
      END
