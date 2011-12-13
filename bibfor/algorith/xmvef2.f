      SUBROUTINE XMVEF2(NDIM ,NNO,NNOS ,FFP ,JAC,
     &                    SEUIL,REAC12,SINGU,NFH,RR,
     &                    CPENFR,CSTAFR,MU,LPENAF,ND,
     &                    DDLS,DDLM,IDEPL,RHOTK,
     &                    PB,VTMP )

      IMPLICIT NONE
      INTEGER     NDIM,NNO,NNOS,DDLS,DDLM,NFH,SINGU,IDEPL
      REAL*8      VTMP(400),RR,ND(3)
      REAL*8      FFP(27),JAC,PB(3),REAC12(3)
      REAL*8      CPENFR,CSTAFR,SEUIL,MU,RHOTK
      LOGICAL     LPENAF

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
C --- CALCUL DU VECTEUR LN1
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
C IN  IDEPD  :
C IN  IDEPM  :
C IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  MALIN  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
C IN  TAU1   : TANGENTE A LA FACETTE AU POINT DE GAUSS
C IN  TAU2   : TANGENTE A LA FACETTE AU POINT DE GAUSS
C IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
C IN  RR     : DISTANCE AU FOND DE FISSURE
C IN  IFA    : INDICE DE LA FACETTE COURANTE
C IN  CFACE  : CONNECTIVIT� DES NOEUDS DES FACETTES
C IN  LACT   : LISTE DES LAGRANGES ACTIFS
C IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
C IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
C IN  RHOTK  :
C IN  CSTAFR : COEFFICIENTS DE STABILISATION DU FROTTEMENT
C IN  CPENFR : COEFFICIENTS DE PENALISATION DU FROTTEMENT
C IN  LPENAF : INDICATEUR DE PENALISATION DU FROTTEMENT
C IN  P      :
C OUT ADHER  :
C OUT KNP    : PRODUIT KN.P
C OUT PTKNP  : MATRICE PT.KN.P
C OUT IK     :
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
      INTEGER  I,J,K,IN,INO
      REAL*8   PTPB(3),P(3,3),VITANG(3),SAUT(3),RBID(3,3)
      LOGICAL  ADHER
C
C ----------------------------------------------------------------------
C
C     P : OP�RATEUR DE PROJECTION
      CALL XMAFR1(NDIM,ND,P)

C     PBOUL SELON L'�TAT D'ADHERENCE DU PG (AVEC DEPDEL)
      CALL VECINI(3,0.D0,SAUT)
      DO 175 INO=1,NNO
        CALL INDENT(INO,DDLS,DDLM,NNOS,IN)
        DO 176 J=1,NFH*NDIM
          SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) * ZR(IDEPL-1+IN+NDIM+J)
 176    CONTINUE
        DO 177 J = 1,SINGU*NDIM
          SAUT(J) = SAUT(J) - 2.D0 * FFP(INO) * RR *
     &                                  ZR(IDEPL-1+IN+NDIM*(1+NFH)+J)

 177    CONTINUE
 175  CONTINUE
C
      CALL XADHER(P,SAUT,REAC12,RHOTK,CSTAFR,CPENFR,LPENAF,
     &            VITANG,PB,RBID,RBID,RBID,ADHER)
C
      IF (ADHER) THEN
C               CALCUL DE PT.REAC12
        DO 188 I=1,NDIM
          PTPB(I)=0.D0
          IF (LPENAF) THEN
            DO 190 K=1,NDIM
              PTPB(I)=PTPB(I)+P(K,I)*CPENFR*VITANG(K)
 190        CONTINUE
          ELSE
            DO 189 K=1,NDIM
              PTPB(I)=PTPB(I)+P(K,I)*(REAC12(K)+CPENFR*VITANG(K))
 189        CONTINUE
          ENDIF
 188    CONTINUE
      ELSE
C     CALCUL DE PT.PBOUL
        DO 182 I=1,NDIM
          PTPB(I)=0.D0
          DO 183 K=1,NDIM
            PTPB(I)=PTPB(I) + P(K,I)*PB(K)
 183      CONTINUE
 182    CONTINUE
      ENDIF
C
      DO 185 I = 1,NNO
        CALL INDENT(I,DDLS,DDLM,NNOS,IN)

        DO 186 J = 1,NFH*NDIM
          VTMP(IN+NDIM+J) = VTMP(IN+NDIM+J) +
     &            2.D0*MU*SEUIL* PTPB(J)*FFP(I)*JAC
 186    CONTINUE
        DO 187 J = 1,SINGU*NDIM
          VTMP(IN+NDIM*(1+NFH)+J) = VTMP(IN+NDIM*(1+NFH)+J) +
     &            2.D0*RR*MU*SEUIL* PTPB(J)*FFP(I)*JAC
 187    CONTINUE
 185  CONTINUE

      END
