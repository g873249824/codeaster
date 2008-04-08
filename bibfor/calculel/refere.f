      SUBROUTINE REFERE(M     ,NO    ,DIME  ,TYPEMA,PREC  ,
     &                  ITEMAX,IFORM ,M0    ,IRET  ,F1)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*8  TYPEMA
      INTEGER      DIME,ITEMAX
      REAL*8       M(*),NO(DIME,*),M0(*),F1(*)
      REAL*8       PREC
      LOGICAL      IRET,IFORM
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C COORDONNEES PARAMETRIQUES D'UN POINT DANS LA MAILLE DE REFERENCE
C A PARTIR DE SES COORDONNES REELLES
C
C
C ----------------------------------------------------------------------
C
C
C IN  M      : POINT SUR MAILLE DE REFERENCE (X,[Y],[Z])
C IN  TYPEMA : TYPE DE LA MAILLE
C IN  NO     : COORDONNEES DES NOEUDS DE LA MAILLE
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  PREC   : PRECISION SUR LA POSITION DU POINT
C IN  ITEMAX : NOMBRE D'ITERATIONS MAXIMAL
C IN  IFORM  : SI .TRUE. ON RECUPERE LES FONCTIONS DE
C              FORME EN CE POINT DANS F1
C OUT M0     : COORDONNEES DE M SUR MAILLE DE REFERENCE
C                           (X0,Y0,[Z0])
C OUT IRET   : .TRUE. EN CAS DE SUCCES
C OUT F1     : FONCTIONS DE FORME EN CE POINT (W1,W2,...) SI IFORM
C
C ----------------------------------------------------------------------
C
      INTEGER      ITER,IDIME,ISING,NNO
      REAL*8       DET,D,R,M1(3),F(3),F0(27),DF(3,3),DF0(3,27),DM(3)
C
C ----------------------------------------------------------------------
C
C
C --- POINT DE DEPART DE LA METHODE DE NEWTON
C
      IF (TYPEMA(1:4).EQ.'TRIA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.33333333333D0
      ELSEIF (TYPEMA(1:4).EQ.'QUAD') THEN
        M1(1) = 0.D0
        M1(2) = 0.D0
      ELSEIF (TYPEMA(1:5).EQ.'TETRA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.03333333333D0
        M1(3) = 0.03333333333D0
      ELSEIF (TYPEMA(1:5).EQ.'PENTA') THEN
        M1(1) = 0.33333333333D0
        M1(2) = 0.33333333333D0
        M1(3) = 0.D0
      ELSE
        M1(1) = 0.D0
        M1(2) = 0.D0
        M1(3) = 0.D0
      ENDIF
C
C --- INITIALISATION DE LA METHODE DE NEWTON
C
      ITER = 0
      IRET = .TRUE.
C
C --- DEBUT DE LA BOUCLE DE NEWTON
C
 10   CONTINUE

C ----- RESIDU ET NORME DU RESIDU

C --- FONCTIONS DE FORME AU POINT M0 DANS LA MAILLE
        CALL FORME0(M1,TYPEMA,F0,NNO)
        CALL MMPROD(NO    ,DIME,0,DIME,0,NNO,
     &              F0    ,NNO ,0,0   ,1,
     &              F)

        ITER = ITER + 1
        R    = 0.D0

        DO 20 IDIME = 1, DIME
          DM(IDIME) = M(IDIME) - F(IDIME)
          D         = ABS(DM(IDIME))
          IF (D .GT. R) R = D
 20     CONTINUE

C ----- TEST DE SORTIE
        IF (R .LT. PREC) GOTO 40
        IF (ITER .GT. ITEMAX) THEN
          IRET = .FALSE.
          GOTO 40
        ENDIF

C ----- MATRICE TANGENTE
        CALL FORME1(M1,TYPEMA,DF0,NNO,DIME)
        CALL MTPROD(NO,DIME,0,DIME,0,NNO,DF0,DIME,0,DIME,0,DF)

C ----- RESOLUTION
        CALL MGAUSS('NCVP',DF,DM,DIME,DIME,1,DET,ISING)
        IF (ISING.EQ.0) THEN
          IRET=.TRUE.
        ENDIF

C ----- SI MATRICE NON INVERSIBLE, ECHEC
        IF (.NOT.IRET) GOTO 40

C ----- ACTUALISATION
        DO 30 IDIME = 1, DIME
          M1(IDIME) = M1(IDIME) + DM(IDIME)
 30     CONTINUE

        GOTO 10

 40   CONTINUE
C
C --- FIN DE LA BOUCLE DE NEWTON
C
C --- RECOPIE COORDONNEES DU POINT REFERENCE
      IF (IRET) THEN
        CALL DCOPY(DIME,M1,1,M0,1)
      ENDIF

C --- RECUPERATION DES FONCTIONS DE FORME
      IF (IFORM.AND.IRET) THEN
        CALL DCOPY(NNO,F0,1,F1,1)
      ENDIF

      END
