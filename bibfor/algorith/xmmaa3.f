      SUBROUTINE XMMAA3(NDIM  ,NNO   ,NNOS  ,NNOL ,NNOF,PLA,
     &                    IPGF,IVFF  ,FFC   ,FFP   ,E     ,JAC   ,
     &                    NFH   ,NOEUD ,ND    ,CPENCO,CSTACO,
     &                    SINGU ,RR    ,DDLS  ,DDLM  ,
     &                    LPENAC,MMAT )

      IMPLICIT NONE
      INTEGER     NDIM,NNO,NNOS,NNOL,NNOF,IVFF,IPGF
      INTEGER     NFH,DDLS,DDLM
      INTEGER     SINGU,PLA(27)
      REAL*8      MMAT(204,204),ND(3)
      REAL*8      FFC(8),FFP(27),JAC
      REAL*8      CPENCO,CSTACO,RR,E
      LOGICAL     NOEUD,LPENAC

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

C TOLE CRP_21
C
C ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
C
C --- CALCUL DES MATRICES A, AT, AU - CAS DU CONTACT
C
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
C IN  NNOS   : NOMBRE DE NOEUDS SOMMET DE L'ELEMENT DE REF PARENT
C IN  NNOL   : NOMBRE DE NOEUDS PORTEURS DE DDLC
C IN  NNOF   : NOMBRE DE NOEUDS DE LA FACETTE DE CONTACT
C IN  PLA    : PLACE DES LAMBDAS DANS LA MATRICE
C IN  IPGF   : NUM�RO DU POINTS DE GAUSS
C IN  IVFF   : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
C IN  FFC    : FONCTIONS DE FORME DE L'ELEMENT DE CONTACT
C IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
C IN  E      : COEFFICIENT DE MISE � L'ECHELLE DES PRESSIONS
C IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
C IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NOEUD  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
C IN  ND     : NORMALE � LA FACETTE ORIENT�E DE ESCL -> MAIT
C                 AU POINT DE GAUSS
C IN  CPENCO : COEFFICIENT DE PENALISATION DU CONTACT
C IN  CSTACO : COEFFICIENT DE STABILISATION DU CONTACT
C IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
C IN  RR     : DISTANCE AU FOND DE FISSURE
C IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
C IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
C IN  LPENAC : INDICATEUR DE PENALISATION DU CONTACT
C I/O MMAT   : MATRICE ELEMENTAITRE DE CONTACT/FROTTEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER I,J,K,L,JN,IN
      INTEGER PLI,PLJ
      REAL*8  FFI,FFJ
C
C ----------------------------------------------------------------------
C
      DO 130 I = 1,NNOL

        PLI=PLA(I)
        IF (NOEUD) THEN
          FFI=FFC(I)
        ELSE
          FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
        ENDIF

        DO 131 J = 1,NNO
          CALL INDENT(J,DDLS,DDLM,NNOS,JN)

          DO 132 L = 1,NFH*NDIM
            MMAT(PLI,JN+NDIM+L)=
     &      MMAT(PLI,JN+NDIM+L)+
     &      2.D0 * FFI * FFP(J) * ND(L) * JAC * E
C
            IF(.NOT.LPENAC)THEN
              MMAT(JN+NDIM+L,PLI)=
     &        MMAT(JN+NDIM+L,PLI)+
     &        2.D0 * FFI * FFP(J) * ND(L) * JAC * E
            ENDIF
 132      CONTINUE
C
          DO 133 L = 1,SINGU*NDIM
            MMAT(PLI,JN+NDIM*(1+NFH)+L)=
     &      MMAT(PLI,JN+NDIM*(1+NFH)+L)+
     &      2.D0 * FFI * FFP(J) * RR * ND(L) * JAC * E
C
            IF(.NOT.LPENAC)THEN
              MMAT(JN+NDIM*(1+NFH)+L,PLI)=
     &        MMAT(JN+NDIM*(1+NFH)+L,PLI)+
     &        2.D0 * FFI * FFP(J) * RR * ND(L) * JAC * E
            ENDIF
 133      CONTINUE

 131    CONTINUE

 130  CONTINUE
C
C     I.2. CALCUL DE A_U
      DO 140 I = 1,NNO
        CALL INDENT(I,DDLS,DDLM,NNOS,IN)

        DO 141 J = 1,NNO
          CALL INDENT(J,DDLS,DDLM,NNOS,JN)

          DO 142 K = 1,NFH*NDIM
            DO 143 L = 1,NFH*NDIM
              MMAT(IN+NDIM+K,JN+NDIM+L) =
     &        MMAT(IN+NDIM+K,JN+NDIM+L) +
     &        4.D0*CPENCO*FFP(I)*FFP(J)*ND(K)*ND(L)*JAC
 143        CONTINUE
C
            DO 144 L = 1,SINGU*NDIM
              MMAT(IN+NDIM+K,JN+NDIM*(1+NFH)+L) =
     &        MMAT(IN+NDIM+K,JN+NDIM*(1+NFH)+L) +
     &        4.D0*CPENCO*FFP(I)*FFP(J)*RR*ND(K)*ND(L)*JAC
 144        CONTINUE
C
 142      CONTINUE

          DO 145 K = 1,SINGU*NDIM
            DO 146 L = 1,NFH*NDIM
              MMAT(IN+NDIM*(1+NFH)+K,JN+NDIM+L) =
     &        MMAT(IN+NDIM*(1+NFH)+K,JN+NDIM+L) +
     &        4.D0*CPENCO*FFP(I)*FFP(J)*RR*ND(K)*ND(L)*JAC
 146        CONTINUE
C
            DO 147 L = 1,SINGU*NDIM
              MMAT(IN+NDIM*(1+NFH)+K,JN+NDIM*(1+NFH)+L) =
     &        MMAT(IN+NDIM*(1+NFH)+K,JN+NDIM*(1+NFH)+L) +
     &        4.D0*CPENCO*FFP(I)*FFP(J)*RR*RR*ND(K)*ND(L)
     &        *JAC
 147        CONTINUE
 145      CONTINUE

 141    CONTINUE
 140  CONTINUE
C
C     I.3. SI PENALISATION PURE CALCUL DE C
      IF (LPENAC) THEN
        DO 220 I = 1,NNOL

          PLI=PLA(I)
          IF (NOEUD) THEN
            FFI=FFC(I)
          ELSE
            FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
          ENDIF

          DO 221 J = 1,NNOL

            PLJ=PLA(J)
            IF (NOEUD) THEN
              FFJ=FFC(J)
            ELSE
              FFJ=ZR(IVFF-1+NNOF*(IPGF-1)+J)
            ENDIF
C
            MMAT(PLI,PLJ) = MMAT(PLI,PLJ)
     &                     - FFJ * FFI * JAC / CSTACO * E * E

 221        CONTINUE
 220      CONTINUE
        ENDIF

      END
