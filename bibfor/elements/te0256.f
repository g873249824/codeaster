      SUBROUTINE TE0256(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C.......................................................................
      IMPLICIT NONE

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 1D

C          OPTION : 'CHAR_MECA_VNOR_F '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      INCLUDE 'jeveux.h'

      INTEGER ICODRE
      CHARACTER*8 NOMPAR(2),FAMI,POUM
      CHARACTER*16 NOMTE,OPTION
      REAL*8 POIDS,NX,NY,VALPAR(2)
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IVNOR,KPG,SPT
      INTEGER NNO,KP,NPG,IVECTU,IMATE,LDEC
      LOGICAL LAXI, LTEATT

C-----------------------------------------------------------------------
      INTEGER I ,IER ,II ,JGANO ,N ,NDIM ,NNOS

      REAL*8 R ,R8B ,RHO ,VNORF ,X ,Y
C-----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PSOURCF','L',IVNOR)
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'

      CALL RCVALB(FAMI,KPG,SPT,POUM,ZI(IMATE),' ','FLUIDE',0,' ',R8B,1,
     &            'RHO',RHO, ICODRE,1)

      DO 10 I = 1,2*NNO
        ZR(IVECTU+I-1) = 0.0D0
   10 CONTINUE

C     BOUCLE SUR LES POINTS DE GAUSS

      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      DO 50 KP = 1,NPG
        LDEC = (KP-1)*NNO

C        COORDONNEES DU POINT DE GAUSS
        X = 0.D0
        Y = 0.D0
        DO 20 N = 0,NNO - 1
          X = X + ZR(IGEOM+2*N)*ZR(IVF+LDEC+N)
          Y = Y + ZR(IGEOM+2*N+1)*ZR(IVF+LDEC+N)
   20   CONTINUE

C        VALEUR DE LA VITESSE
        VALPAR(1) = X
        VALPAR(2) = Y
        CALL FOINTE('FM',ZK8(IVNOR),2,NOMPAR,VALPAR,VNORF,IER)
        NX = 0.0D0
        NY = 0.0D0

        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)

        IF (LAXI) THEN
          R = 0.D0
          DO 30 I = 1,NNO
            R = R + ZR(IGEOM+2* (I-1))*ZR(IVF+LDEC+I-1)
   30     CONTINUE
          POIDS = POIDS*R
        END IF

        DO 40 I = 1,NNO
          II = 2*I
          ZR(IVECTU+II-1) = ZR(IVECTU+II-1) -
     &                      POIDS*VNORF*RHO*ZR(IVF+LDEC+I-1)
   40   CONTINUE

   50 CONTINUE

      END
