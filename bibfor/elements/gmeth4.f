      SUBROUTINE GMETH4(MODELE,OPTION,NNOFF,NDIMTE,FOND,GTHI,MILIEU,
     &                  PAIR,GS,OBJCUR,GI,GXFEM)
      IMPLICIT NONE

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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C ......................................................................
C      METHODE LAGRANGE_REGU POUR LE CALCUL DE G(S)
C
C ENTREE
C
C   MODELE   --> NOM DU MODELE
C   NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C   NDIMTE   --> NOMBRE de CHAMPS THETA CHOISIS
C   FOND     --> NOMS DES NOEUDS DU FOND DE FISSURE
C   GTHI     --> VALEURS DE G POUR LES CHAMPS THETAI
C   OBJCUR  --> ABSCISSES CURVILIGNES S
C
C
C SORTIE
C
C   GS      --> VALEUR DE G(S)
C   GI      --> VALEUR DE GI
C ......................................................................
C
      INCLUDE 'jeveux.h'
      INTEGER         NNOFF,I,NUMP,IMATR,NN
      INTEGER         I1,IADRNO,KK,NDIMTE
C
      REAL*8          GTHI(1),GS(1),GI(1),S1,S2,S3,DELTA
      REAL*8          OBJCUR(*)
C
      CHARACTER*8     MODELE
      CHARACTER*16    OPTION
      CHARACTER*24    MATR,FOND
      LOGICAL          CONNEX,MILIEU,PAIR,GXFEM
C
C
C
C
C OBJET DECRIVANT LE MAILLAGE
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL JEMARQ()

      CONNEX = .FALSE.
      IF (.NOT. GXFEM) THEN
        CALL JEVEUO (FOND,'L',IADRNO)
        IF (ZK8(IADRNO+1-1).EQ.ZK8(IADRNO+NNOFF-1)) CONNEX = .TRUE.
      ENDIF

C
C CONSTRUCTION DE LA MATRICE (NDIMTE x NDIMTE)
      MATR = '&&METHO4.MATRI'
      CALL WKVECT(MATR,'V V R8',NDIMTE*NDIMTE,IMATR)
C
      I1 = 2
      IF (MILIEU) THEN
        I1 = 4
      ENDIF
      DO 120 I=1,NDIMTE-2
        NUMP = 2*I-1
        IF (MILIEU) NUMP = 4*I-3
        S1 = OBJCUR(NUMP)
        S2 = OBJCUR(NUMP+I1)
        DELTA = (S2-S1)/6.D0
        KK = IMATR+(I-1  )*NDIMTE+I-1
        ZR(KK )= ZR(KK) +               2.D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1  )=  1.D0*DELTA
        ZR(IMATR+(I-1  )*NDIMTE+I-1+1)=  1.D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1+1)=  2.D0*DELTA
120   CONTINUE
C
      I = NDIMTE -1
      NUMP = 2*(I-1)
      IF (PAIR) THEN
        S1 = OBJCUR(NUMP)
        S2 = OBJCUR(NUMP+I1/2)
        DELTA = (S2-S1)/6.D0
        KK = IMATR+(I-1  )*NDIMTE+I-1
        ZR(KK )= ZR(KK) +         3.5D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1  )=  1.D0*DELTA
        ZR(IMATR+(I-1  )*NDIMTE+I-1+1)=  1.D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1+1)= 0.5D0*DELTA
      ELSE
        S1 = OBJCUR(NUMP+1)
        S2 = OBJCUR(NUMP+I1+1)
        DELTA = (S2-S1)/6.D0
        KK = IMATR+(I-1  )*NDIMTE+I-1
        ZR(KK )= ZR(KK) +               2.D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1  )=  1.D0*DELTA
        ZR(IMATR+(I-1  )*NDIMTE+I-1+1)=  1.D0*DELTA
        ZR(IMATR+(I-1+1)*NDIMTE+I-1+1)=  2.D0*DELTA
      ENDIF

      IF (NNOFF .EQ. 2) THEN
        S1 = OBJCUR(1)
        S2 = OBJCUR(2)
        DELTA = (S2-S1)/6.D0
        ZR(IMATR + 0)=  3.5D0*DELTA
        ZR(IMATR + 1)=  1.D0*DELTA
        ZR(IMATR + 2)=  1.D0*DELTA
        ZR(IMATR + 3)= 0.5D0*DELTA
      ENDIF

      IF (CONNEX) THEN
        ZR(IMATR) = 2.D0*ZR(IMATR)
        S1 = OBJCUR(NUMP-I1+1)
        S2 = OBJCUR(NUMP+1)
        DELTA = (S2-S1)/6.D0
        ZR(IMATR+(1-1)*NDIMTE+NDIMTE-1-1)= 1.D0*DELTA
        KK = IMATR+(NDIMTE-1)*NDIMTE+NDIMTE-1
        ZR(KK) = 2.D0*ZR(KK)
        S1 = OBJCUR(1)
        S2 = OBJCUR(I1+1)
        DELTA = (S2-S1)/6.D0
        ZR(IMATR+(NDIMTE-1)*NDIMTE+2-1)= 1.D0*DELTA
      ENDIF
C
C  SYSTEME LINEAIRE:  MATR*GI = GTHI
C
      CALL GSYSTE(MATR,NDIMTE,NDIMTE,GTHI,GI)
C
      IF (NNOFF .EQ. 2) THEN
        GS(1) = GI(1)
        GS(NNOFF) = GI(NDIMTE)
      ELSE
       DO 200 I=1,NDIMTE-1
        IF (MILIEU) THEN
          NN = 4*I-3
          GS(NN) = GI(I)
          S1 = OBJCUR(NN)
          S3 = OBJCUR(NN+4)
          GS(NN+1)=GI(I)+(OBJCUR(NN+1)-S1)*(GI(I+1)-GI(I))/(S3-S1)
          GS(NN+2)=GI(I)+(OBJCUR(NN+2)-S1)*(GI(I+1)-GI(I))/(S3-S1)
          GS(NN+3)=GI(I)+(OBJCUR(NN+3)-S1)*(GI(I+1)-GI(I))/(S3-S1)
        ELSE
          NN = 2*I-1
          GS(NN) = GI(I)
          S1 = OBJCUR(NN)
          S2 = OBJCUR(NN+1)
          S3 = OBJCUR(NN+2)
          GS(NN+1) = GI(I)+(S2-S1)*(GI(I+1)-GI(I))/(S3-S1)
        ENDIF
200    CONTINUE
       GS(NNOFF) = GI(NDIMTE)

C     SI PAIR, ON CORRIGE LA VALEUR DE G AU DERNIER NOEUD
       IF(PAIR)THEN
         NN=2*(NDIMTE-2)
         S1 = OBJCUR(NN)
         S2 = OBJCUR(NN+1)
         S3 = OBJCUR(NN+2)
         GS(NNOFF) = GS(NNOFF-1)+
     &              (S3-S2)*(GS(NNOFF-2)-GS(NNOFF-1))/(S1-S2)
       ENDIF
      ENDIF
C
      CALL JEDETR(MATR)
C
      CALL JEDEMA()
      END
