      SUBROUTINE TE0573(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/05/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS
C
      IMPLICIT      NONE
      CHARACTER*16  NOMTE,OPTION
C
C ----------------------------------------------------------------------
C
C ROUTINE CALCUL ELEMENTAIRE
C
C CALCUL DES OPTIONS ELEMENTAIRES EN MECANIQUE CORRESPONDANT A UN
C CHARGEMENT EN PRESSION SUIVEUSE SUR DES ARETES D'ELEMENTS
C ISOPARAMETRIQUES 2D
C
C LA PRESSION EST UNE CONSTANTE RELLE
C
C ----------------------------------------------------------------------
C
C
C IN  OPTION : OPTION DE CALCUL
C               CHAR_MECA_PRSU_R
C               RIGI_MECA_PRSU_R
C IN  NOMTE  : NOM DU TYPE ELEMENT
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER        MXNOEU  ,MXNPG   ,MXVECT    ,MXMATR
      PARAMETER     (MXNOEU=3,MXNPG=4,MXVECT=2*3,MXMATR=2*3*2*3)
C
      LOGICAL       LTEATT,LAXI
      INTEGER       NDIM,NNO,NPG,NNOS,NDDL
      INTEGER       IDDL,INO,IPG
      INTEGER       JPOIDS,JVF,JDF,JGANO
      INTEGER       JVECT,JMATR
      INTEGER       JGEOM,JDEPM,JDEPP,JPRES
      INTEGER       KDEC,I,J,K
C
      REAL*8        P(2,MXNPG)
      REAL*8        VECT(MXVECT),MATR(MXMATR)
C
C ----------------------------------------------------------------------
C
C
C --- CARACTERISTIQUES ELEMENT
C
      LAXI = LTEATT(' ','AXIS','OUI')
      CALL ELREF4(' '   ,'RIGI',NDIM  ,NNO   ,NNOS  ,
     &            NPG   ,JPOIDS,JVF   ,JDF   ,JGANO )
      NDDL = 2*NNO
      CALL ASSERT(NDIM  .LE.1     )
      CALL ASSERT(NNO   .LE.MXNOEU)
      CALL ASSERT(NPG   .LE.MXNPG )
C
C --- ACCES CHAMPS
C
      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PDEPLMR','L',JDEPM)
      CALL JEVECH('PDEPLPR','L',JDEPP)
      CALL JEVECH('PPRESSR','L',JPRES)
C
C --- REACTUALISATION DE LA GEOMETRIE PAR LE DEPLACEMENT
C
      DO 10 IDDL = 1,NDDL
        ZR(JGEOM+IDDL-1) = ZR(JGEOM+IDDL-1) +
     &                     ZR(JDEPM+IDDL-1) +
     &                     ZR(JDEPP+IDDL-1)
 10   CONTINUE
C
C --- CALCUL DE LA PRESSION AUX POINTS DE GAUSS (A PARTIR DES NOEUDS)
C
      DO 100 IPG = 1,NPG
        KDEC      = (IPG-1) * NNO
        P(1,IPG) = 0.D0
        P(2,IPG) = 0.D0
        DO 105 INO = 1,NNO
          P(1,IPG) = P(1,IPG) + ZR(JPRES+2*(INO-1)+1-1) *
     &                          ZR(JVF+KDEC+INO-1)
          P(2,IPG) = P(2,IPG) + ZR(JPRES+2*(INO-1)+2-1) *
     &                          ZR(JVF+KDEC+INO-1)
105     CONTINUE
100   CONTINUE
C
C --- CALCUL EFFECTIF DE LA RIGIDITE
C
      IF (OPTION.EQ.'CHAR_MECA_PRSU_R') THEN
        CALL NMPR2D(1     ,LAXI   ,NNO      ,NPG   ,ZR(JPOIDS),
     &              ZR(JVF),ZR(JDF),ZR(JGEOM),P     ,VECT      ,
     &              MATR   )
C
C --- RECOPIE DU VECTEUR ELEMENTAIRE
C
        CALL JEVECH('PVECTUR','E',JVECT)
        CALL DCOPY(NDDL  ,VECT  ,1,ZR(JVECT),1)

      ELSEIF (OPTION.EQ.'RIGI_MECA_PRSU_R') THEN
        CALL NMPR2D(2      ,LAXI   ,NNO      ,NPG   ,ZR(JPOIDS),
     &              ZR(JVF),ZR(JDF),ZR(JGEOM),P     ,VECT      ,
     &              MATR   )
C
C --- RECOPIE DE LA MATRICE ELEMENTAIRE (NON-SYMETRIQUE)
C --- LES MATRICES NON SYMETRIQUES SONT ENTREES EN LIGNE
C
        CALL JEVECH('PMATUNS','E',JMATR)
        K = 0
      DO 110 I = 1,NDDL
        DO 120 J = 1,NDDL
            K = K + 1
            ZR(JMATR-1+K) = MATR((J-1)*NDDL+I)
  120   CONTINUE
  110 CONTINUE
        CALL ASSERT(K.EQ.NDDL*NDDL)

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END
