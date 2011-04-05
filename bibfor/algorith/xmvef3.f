      SUBROUTINE XMVEF3(NDIM  ,NNOL ,NNOF,PLA,
     &                    IPGF,IVFF  ,FFC ,REAC12,PB,JAC,
     &                    NOEUD ,SEUIL,TAU1,TAU2,
     &                    IFA,CFACE,LACT,
     &                    CPENFR,CSTAFR,MU ,LPENAF,
     &                    VTMP )

      IMPLICIT NONE
      INTEGER     NDIM,NNOL,NNOF,IVFF,IPGF,PLA(27)
      INTEGER     CFACE(5,3),IFA,LACT(8)
      REAL*8      VTMP(400),TAU1(3),TAU2(3)
      REAL*8      FFC(8),JAC,PB(3),REAC12(3)
      REAL*8      CPENFR,CSTAFR,SEUIL,MU
      LOGICAL     NOEUD,LPENAF

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/01/2011   AUTEUR MASSIN P.MASSIN 
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
C --- CALCUL DU VECTEUR LN3
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
C IN  NOEUD  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
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
      INTEGER I,K
      INTEGER PLI,NLI
      REAL*8  FFI,METR(2),DDOT,RPB(3)
C
C ----------------------------------------------------------------------
C
C --- CALCUL DE REAC12-PBOUL
      IF (LPENAF) CSTAFR=CPENFR
      DO 180 I=1,NDIM
        RPB(I)=REAC12(I)-PB(I)
 180  CONTINUE
C
       DO 194 I = 1,NNOL
         PLI=PLA(I)
         IF (NOEUD) THEN
           FFI=FFC(I)
           NLI=LACT(I)
           IF (NLI.EQ.0) GOTO 194
         ELSE
           FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
           NLI=CFACE(IFA,I)
         ENDIF
C
         METR(1)=DDOT(NDIM,TAU1(1),1,RPB,1)
         IF(NDIM.EQ.3) METR(2)=DDOT(NDIM,TAU2(1),1,RPB,1)
           DO 195 K=1,NDIM-1
             VTMP(PLI+K) = VTMP(PLI+K)
     &       + MU*SEUIL/CSTAFR * METR(K)*FFI*JAC
 195       CONTINUE
 194     CONTINUE

      END
