      SUBROUTINE TE0253(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C.......................................................................
C
C     BUT: CALCUL DES MATRICES DE RIGIDITE  ELEMENTAIRES EN MECANIQUE
C          ELEMENTS DE FLUIDE ISOPARAMETRIQUES 2D
C
C          OPTION : 'RIGI_MECA '
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
C-----------------------------------------------------------------------
      INTEGER ICOMPO ,IDEPLM ,IDEPLP ,K ,L ,N1 ,N2 
      INTEGER NBRES ,NN ,NNO2 ,NT2 
      REAL*8 R ,R8B 
C-----------------------------------------------------------------------
      PARAMETER         ( NBRES=2 )
      CHARACTER*8        NOMRES(NBRES),FAMI,POUM
      INTEGER            ICODRE(NBRES),KPG,SPT
      CHARACTER*16       NOMTE,OPTION
      REAL*8             VALRES(NBRES),A(2,2,9,9)
      REAL*8             B(18,18),UL(18),C(171)
      REAL*8             DFDX(9),DFDY(9),POIDS,RHO,CELER
      INTEGER            IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER            NNO,KP,NPG,IK,IJKL,I,J,IMATUU
      INTEGER            IVECTU,JCRET,NDIM,JGANO,NNOS
      LOGICAL            LTEATT
C
C
C
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      IF (  OPTION.EQ.'FULL_MECA' .OR. OPTION.EQ.'RAPH_MECA'
     & .OR. OPTION.EQ.'RIGI_MECA_TANG' ) THEN
         CALL JEVECH('PCOMPOR','L',ICOMPO)
         IF ( ZK16(ICOMPO+3) .EQ. 'COMP_ELAS' ) THEN
            CALL U2MESS('F','ELEMENTS2_90')
         ENDIF
      ENDIF
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
C
      NOMRES(1) = 'RHO'
      NOMRES(2) = 'CELE_R'
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      CALL RCVALB(FAMI,KPG,SPT,POUM, ZI(IMATE),' ','FLUIDE',0,' ',
     &             R8B,2,NOMRES,VALRES,ICODRE,1)
      RHO    = VALRES(1)
      CELER = VALRES(2)
C
C     INITIALISATION DE LA MATRICE A
      DO 112 K=1,2
         DO 112 L=1,2
            DO 112 I=1,NNO
            DO 112 J=1,I
                A(K,L,I,J) = 0.D0
112          CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 KP=1,NPG
C
        K = (KP-1)*NNO
        CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C      TERME EN (P**2)/ (RHO*(CEL**2))  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
        IF ( LTEATT(' ','AXIS','OUI') ) THEN
           R = 0.D0
           DO 102 I=1,NNO
             R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
102        CONTINUE
           POIDS = POIDS*R
        ENDIF
C
           DO 106 I=1,NNO
             DO 107 J=1,I
               A(1,1,I,J) = A(1,1,I,J) +
     &         POIDS * ZR(IVF+K+I-1) * ZR(IVF+K+J-1) / RHO /
     &         CELER/CELER
C
107          CONTINUE
C
106        CONTINUE
C
101   CONTINUE
C
C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)
C
      DO 111 K=1,2
         DO 111 L=1,2
            DO 111 I=1,NNO
                IK = ((2*I+K-3) * (2*I+K-2)) / 2
            DO 111 J=1,I
                IJKL = IK + 2 * (J-1) + L
                C(IJKL) = A(K,L,I,J)
111          CONTINUE
C
      NNO2 = NNO*2
      NT2 = NNO*(NNO2+1)

      IF (OPTION(1:9).NE.'FULL_MECA'.AND.OPTION(1:9).NE.'RIGI_MECA')
     &  GOTO 9998
      IF (OPTION.EQ.'RIGI_MECA_HYST') THEN
       CALL JEVECH('PMATUUC','E',IMATUU)
       DO 115 I=1,NT2
         ZC(IMATUU+I-1)=DCMPLX(C(I),0.D0)
115    CONTINUE
      ELSE
       CALL JEVECH('PMATUUR','E',IMATUU)
       DO 114 I=1,NT2
         ZR(IMATUU+I-1)=C(I)
114    CONTINUE
      ENDIF
 9998 CONTINUE

      IF (OPTION.NE.'FULL_MECA'.AND.OPTION.NE.'RAPH_MECA'
     &    .AND.OPTION.NE.'FORC_NODA') GOTO 9999
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      DO 113 I=1,NNO2
         ZR(IVECTU+I-1) = 0.D0
         UL(I)=ZR(IDEPLM+I-1)+ZR(IDEPLP+I-1)
113   CONTINUE
C
      NN = 0
      DO 120 N1 = 1,NNO2
        DO 121 N2 = 1,N1
          NN = NN + 1
          B(N1,N2) = C(NN)
          B(N2,N1) = C(NN)
121     CONTINUE
120   CONTINUE
C
      DO 130 N1 = 1,NNO2
      DO 130 N2 = 1,NNO2
        ZR(IVECTU+N1-1) = ZR(IVECTU+N1-1)+B(N1,N2)*UL(N2)
130   CONTINUE
C
 9999 CONTINUE
      IF ( OPTION(1:9).EQ.'FULL_MECA'  .OR.
     &     OPTION.EQ.'RAPH_MECA'  ) THEN
         CALL JEVECH ( 'PCODRET', 'E', JCRET )
         ZI(JCRET) = 0
      ENDIF
C
      END
