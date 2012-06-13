      SUBROUTINE GSYSTE(MATR,NCHTHE,NNOFF,GTHI,GI)
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C ......................................................................
C     - FONCTION REALISEE:   FORMATION DU SYSTEME A RESOUDRE
C                            TA A <GI> = TA<G,THETAI>
C
C ENTREE
C
C     MATR         --> VALEURS DE LA MATRICE A
C     NCHTHE       --> NOMBRE DE CHAMPS THETAI
C     GTHI         --> VALEURS DE <G,THETAI>
C     NNOFF        --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C
C  SORTIE
C
C     GI           --> VALEUR DE GI
C ......................................................................
C
      INCLUDE 'jeveux.h'
      INTEGER         ISTOK,NCHTHE,NNOFF
      INTEGER         I,J,K,IRET
C
      REAL*8          GTHI(NNOFF),GI(NCHTHE),DET
C
      CHARACTER*24    MATR
C
C
C
C
      CALL JEMARQ()
      CALL JEVEUO(MATR,'L',ISTOK)
      CALL WKVECT('&&GSYSTE.A1','V V R8',NCHTHE*NCHTHE,IADRA1)
C
C INITIALISATION DES VECTEURS ET MATRICES
C
      DO 20 I=1,NCHTHE
         GI(I) = 0.D0
20    CONTINUE
C
C CALCUL DU PRODUIT TA*A
C
      DO 7 I=1,NCHTHE
        DO 8 J=1,NCHTHE
           DO 9 K=1,NNOFF
              KK = IADRA1+(I-1)*NCHTHE+J-1
              ZR(KK) = ZR(KK)+
     &          ZR(ISTOK +(K-1)*NCHTHE+I-1)*ZR(ISTOK+(K-1)*NCHTHE+J-1)

9          CONTINUE
8       CONTINUE
7     CONTINUE
C
C  SECOND MEMBRE TAIJ <G,THETHAI>
C
      DO 11 I=1,NCHTHE
        DO 12 J=1,NNOFF
          GI(I) = GI(I) + ZR(ISTOK +(J-1)*NCHTHE+I-1)*GTHI(J)
12      CONTINUE
11    CONTINUE
C
C RESOLUTION DU SYSTEME LINEAIRE NON SYMETRIQUE PAR GAUSS
C
      CALL MGAUSS('NFVP',ZR(IADRA1),GI,NCHTHE,NCHTHE,1,DET,IRET)
C
      CALL JEDETR('&&GSYSTE.A1')
      CALL JEDEMA()
      END
