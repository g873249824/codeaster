      SUBROUTINE MATRC(NOMTE,NNO,KCIS,MATC,VECTT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2013   AUTEUR DELMAS J.DELMAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      INTEGER NNO
      REAL*8 KCIS,MATC(5,5),VECTT(3,3)

      REAL*8 VALRES(5),VALPAR
      CHARACTER*(*) NOMTE
      INTEGER ICODRE(5)
      CHARACTER*4 FAMI
      CHARACTER*8 NOMRES(5),NOMPAR
      CHARACTER*10 PHENOM
      REAL*8 YOUNG,NU,NULT,NUTL,ALPHA,R8DGRD,BETA
      REAL*8 PASSAG(3,3),PAS2(2,2),DORTH(3,3),WORK(3,3),D(3,3)
      REAL*8 DCIS(2,2),C,S,D2(2,2),EL,ET,GLT,GTN,DELTA
      REAL*8 R8BID4(4)
      INTEGER I,J,JMATE,NBV,NBPAR,JCOQU,IRET
      INTEGER NDIM,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO,JCOU

      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      DO 20 I = 1,5
        DO 10 J = 1,5
          MATC(I,J) = 0.D0
   10   CONTINUE
   20 CONTINUE

      CALL JEVECH('PMATERC','L',JMATE)
      CALL JEVECH('PNBSP_I','L',JCOU)

      NBPAR = 1
      NOMPAR = 'TEMP'
      CALL MOYTEM(FAMI,NPG,3*ZI(JCOU),'+',VALPAR,IRET)

      CALL RCCOMA(ZI(JMATE),'ELAS',1,PHENOM,ICODRE)

      IF (PHENOM.EQ.'ELAS') THEN
        NBV = 2
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'

C        ------ MATERIAU ISOTROPE --------------------------------------

        CALL RCVALA(ZI(JMATE),' ',PHENOM,NBPAR,NOMPAR,VALPAR,NBV,
     &              NOMRES,VALRES,ICODRE,1)

        YOUNG = VALRES(1)
        NU = VALRES(2)

C ------ CONSTRUCTION DE LA MATRICE DE COMPORTEMENT MATC : (5,5)

        MATC(1,1) = YOUNG/ (1.D0-NU*NU)
        MATC(1,2) = MATC(1,1)*NU
        MATC(2,1) = MATC(1,2)
        MATC(2,2) = MATC(1,1)
        MATC(3,3) = YOUNG/2.D0/ (1.D0+NU)
        MATC(4,4) = MATC(3,3)*KCIS
        MATC(5,5) = MATC(4,4)

      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN

        NOMRES(1) = 'E_L'
        NOMRES(2) = 'E_T'
        NOMRES(3) = 'NU_LT'
        NOMRES(4) = 'G_LT'
        NOMRES(5) = 'G_TN'
        NBV = 5

C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
        CALL RCVALA(ZI(JMATE),' ',PHENOM,NBPAR,NOMPAR,VALPAR,NBV,NOMRES,
     &              VALRES,ICODRE,1)

        EL = VALRES(1)
        ET = VALRES(2)
        NULT = VALRES(3)
        GLT  = VALRES(4)
        GTN  = VALRES(5)
        NUTL  = ET*NULT/EL
        DELTA = 1.D0 - NULT*NUTL
        DORTH(1,1) = EL/DELTA
        DORTH(1,2) = NULT*ET/DELTA
        DORTH(1,3) = 0.D0
        DORTH(2,2) = ET/DELTA
        DORTH(2,1) = DORTH(1,2)
        DORTH(2,3) = 0.D0
        DORTH(3,1) = 0.D0
        DORTH(3,2) = 0.D0
        DORTH(3,3) = GLT

C ---   DETERMINATION DES MATRICE DE PASSAGE DES REPERES INTRINSEQUES
C ---   AUX NOEUDS ET AUX POINTS D'INTEGRATION DE L'ELEMENT
C ---   AU REPERE UTILISATEUR :

C ---   RECUPERATION DES ANGLES DETERMINANT LE REPERE UTILISATEUR
C ---   PAR RAPPORT AU REPERE GLOBAL :

        CALL JEVECH('PCACOQU','L',JCOQU)

        ALPHA = ZR(JCOQU+1)*R8DGRD()
        BETA = ZR(JCOQU+2)*R8DGRD()

C       CALCUL DU COSINUS ET DU SINUS DE L'ANGLE ENTRE LE REPERE
C       INTRINSEQUE ET LE REPERE UTILISATEUR
        CALL COQREP(VECTT, ALPHA, BETA, R8BID4,R8BID4,C,S)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE INTRINSEQUE :
C ----   D_GLOB = PASSAG_T * D_ORTH * PASSAG

        DO 40 I = 1,3
          DO 30 J = 1,3
            PASSAG(I,J) = 0.D0
   30     CONTINUE
   40   CONTINUE
        PASSAG(1,1) = C*C
        PASSAG(2,2) = C*C
        PASSAG(1,2) = S*S
        PASSAG(2,1) = S*S
        PASSAG(1,3) = C*S
        PASSAG(3,1) = -2.D0*C*S
        PASSAG(2,3) = -C*S
        PASSAG(3,2) = 2.D0*C*S
        PASSAG(3,3) = C*C - S*S
        CALL UTBTAB('ZERO',3,3,DORTH,PASSAG,WORK,D)

        DO 60 I = 1,3
          DO 50 J = 1,3
            MATC(I,J) = D(I,J)
   50     CONTINUE
   60   CONTINUE

        DCIS(1,1) = GLT
        DCIS(1,2) = 0.D0
        DCIS(2,1) = 0.D0
        DCIS(2,2) = GTN
        PAS2(1,1) = C
        PAS2(2,2) = C
        PAS2(1,2) = S
        PAS2(2,1) = -S

        CALL UTBTAB('ZERO',2,2,DCIS,PAS2,WORK,D2)
        DO 80 I = 1,2
          DO 70 J = 1,2
            MATC(3+I,3+J) = D2(I,J)
   70     CONTINUE
   80   CONTINUE

      ELSE
        CALL U2MESS('F','ELEMENTS_42')
      END IF

      END
