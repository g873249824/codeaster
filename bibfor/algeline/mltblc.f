      SUBROUTINE MLTBLC(NBSN,DEBFSN,MXBLOC,SEQ,NBLOC,DECAL,LGBLOC,
     +                  NCBLOC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
C RESPONSABLE JFBHHUC C.ROSE
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
C       CALCUL DU NOMBRE DE BLOCS POUR LA MATRICE FACTORISEE
C       DONNEES :
C                 MXBLOC : LONGUEUR MAXIMUM D'UN BLOC
C       RESULTATS :
C                   NBLOC NBRE DE BLOCS
C                   NOBLOC(NBLOC) : NUMERO DE BLOC DE CHQUE SND
C                   LGBLOC(NBLOC) : NBRE DE COEFFICIENTS DE CHAQUE BLOC
C                   DECAL(NBSN) :  DEBUT DE CHAQUE SNOEUD DANS LE TABLEA
C                                    FACTOR QUI CONTIENT LES BLOCS
      INTEGER NBSN,SEQ(NBSN),DEBFSN(NBSN+1),MXBLOC,NBLOC,DECAL(NBSN)
      INTEGER LGBLOC(*),NCBLOC(*)
      INTEGER I,L,I0,LONG
      INTEGER VALI(3)
      NBLOC = 1
      I0 = 1
  110 CONTINUE
      I = I0
      DECAL(SEQ(I)) = 1
      LONG = DEBFSN(SEQ(I)+1) - DEBFSN(SEQ(I))
      IF (LONG.GT.MXBLOC) THEN
              VALI (1) = MXBLOC
              VALI (2) = I
              VALI (3) = LONG
          CALL U2MESG('F', 'ALGELINE4_21',0,' ',3,VALI,0,0.D0)
      END IF
C      DO WHILE (LONG.LE.MXBLOC)
  120 CONTINUE
      IF (LONG.LE.MXBLOC) THEN
          IF (I.EQ.NBSN) GO TO 130
          I = I + 1
          DECAL(SEQ(I)) = LONG + 1
          L = DEBFSN(SEQ(I)+1) - DEBFSN(SEQ(I))
          IF (L.GT.MXBLOC) THEN
              VALI (1) = MXBLOC
              VALI (2) = I
              VALI (3) = L
              CALL U2MESG('F', 'ALGELINE4_22',0,' ',3,VALI,0,0.D0)
          END IF
          LONG = LONG + L
          GO TO 120
C FIN DO WHILE
      END IF
C      CHAQUE BLOC VA DES NUMEROS DE SNDS SEQ(I0) A SEQ(I-1)
      NCBLOC(NBLOC) = I - I0
      LGBLOC(NBLOC) = LONG - L
      NBLOC = NBLOC + 1
      I0 = I
      GO TO 110
C
  130 CONTINUE
      NCBLOC(NBLOC) = NBSN - I0 + 1
      LGBLOC(NBLOC) = LONG
      END
