      SUBROUTINE ARLAS9(NDIM,NDML1,NDML2,PTMT,IDEB,IMATUU,MTMO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/10/2009   AUTEUR CAO B.CAO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT      NONE
      INTEGER       NDIM,NDML1,NDML2,IDEB,IMATUU
      INTEGER       PTMT(NDML2,NDML1)
      REAL*8        MTMO(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C GESTION DES RELATIONS LINEAIRES
C ASSEMBLAGE MATRICE ELEMENTAIRE ARLEQUIN
C   MAILLE SOLIDE / MAILLE SOLIDE
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NDML1   : NOMBRE DE NOEUDS MAILLE 1
C IN  NDML2   : NOMBRE DE NOEUDS MAILLE 2
C IN  PTMT  : POINTEURS DANS C (CF ARLAS0)
C I/O MTMO  : MATRICE MORSE (CF ARLFC*)
C
C MATRICE PONCTUELLE DANS MTMO : (X1.X2, X1.Y2, [X1.Z2], Y1.X2, ...)
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C

      INTEGER  IDIM1,IDIM2,INO1,INO2,IAUX
      REAL*8   MCPLCZ(NDIM,NDIM,NDML1,NDML2)
C
C ----------------------------------------------------------------------
C

       IAUX = IDEB
       DO 50 INO1 = 1,NDML1
         DO 40 IDIM1 = 1,NDIM
           DO 30 INO2 = 1,NDML2
             DO 20 IDIM2 = 1,NDIM
               IAUX = IAUX+1
               MCPLCZ(IDIM1,IDIM2,INO1,INO2) = ZR(IMATUU-1+IAUX)
 20          CONTINUE
 30        CONTINUE
 40      CONTINUE
 50    CONTINUE


C --- ASSEMBLAGE DE LA MATRICE ELEMENTAIRE CK

      DO 90 INO1 = 1,NDML1
        DO 80 INO2 = 1,NDML2
          IAUX = NDIM*NDIM*(PTMT(INO2,INO1)-1)
          DO 70 IDIM1 = 1,NDIM
            DO 60 IDIM2 = 1,NDIM
              IAUX = IAUX+1
              MTMO(IAUX) = MTMO(IAUX) + MCPLCZ(IDIM1,IDIM2,INO1,INO2)
 60         CONTINUE
 70       CONTINUE
 80     CONTINUE
 90   CONTINUE

      END
