      SUBROUTINE PPGANO(NNOS,NPG,NCMP,VPG,VNO)
      IMPLICIT   NONE
      INTEGER NNOS,NPG,NCMP,NNOS1,NPG1,JMAT,NNO
      REAL*8 VNO(*),VPG(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/07/2002   AUTEUR CIBHHPD D.NUNEZ 
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
C     POUR LES ELEMENTS 3D ET 2D (NCMP COMPOSANTES PAR NOEUD/PG) :
C     PASSAGE DES VALEURS AUX POINTS DE GAUSS
C             AUX VALEURS AUX NOEUDS SOMMETS PAR MATRICE
C                     ET  AUX NOEUDS MILIEUX PAR VALEUR MOYENNE
C ----------------------------------------------------------------------
C     IN     TYPMAI TYPE DE MAILLE
C            MAT    MATRICE DE PASSAGE GAUSS -> NOEUDS
C            NNOS   NOMBRE DE NOEUDS SOMMETS
C            NPG    NOMBRE DE POINTS DE GAUSS
C            NCMP   NOMBRE DE COMPOSANTES
C            VPG    VECTEUR DES VALEURS AUX POINTS DE GAUSS
C     OUT    VNO    VECTEUR DES VALEURS AUX NOEUDS
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       07/02/02 (OB): EXTENSION AUX EFS LUMPES.
C----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER I,J,IC,IADZI,IAZK24,NBELR
      REAL*8 S,DEMI
      CHARACTER*8 ELREFE
      CHARACTER*16 NOMTE,ELREFL
      CHARACTER*24 TYPMA
      CHARACTER*24 CHMAT

C DEB ------------------------------------------------------------------

      DEMI = 0.5D0

C --- RECUPERATION DU NOMBRE DE NOEUDS NNO

      CALL TECAEL(IADZI,IAZK24)
      NNO = ZI(IADZI+1)
C --- RECUPERATION DU NOMTE - CHOIX DES MATRICES DE PASSAGE

      NOMTE = ZK24(IAZK24-1+3+NNO+1) (1:16)
      TYPMA = ZK24(IAZK24-1+3+NNO+3)

      CALL ELREF1(ELREFE)

      IF (ELREFE.EQ.'XXXXXXXX') THEN
         ELREFL = NOMTE
      ELSE
         ELREFL=ELREFE
      END IF
      IF (NNOS.EQ.NPG) THEN
        CHMAT = '&INEL.'//ELREFL//'.A'
        CALL JEVEUO(CHMAT,'L',JMAT)
      ELSE
        CHMAT = '&INEL.'//ELREFL//'.B'
        CALL JEVEUO(CHMAT,'L',JMAT)
      END IF

C --- TEST DE LA COHERENCE DES MATRICES

      NNOS1 = NINT(ZR(JMAT-1+1))
      NPG1 = NINT(ZR(JMAT-1+2))

      IF (NNOS.NE.NNOS1) THEN
        CALL UTMESS('F','PPGANO','LE NOMBRE DE POINTS SOMMETS '//
     &              'N''EST PAS CORRECT POUR L''ELEMENT DE TYPE '//
     &              NOMTE)
      ELSE IF (NPG.NE.NPG1) THEN
        CALL UTMESS('F','PPGANO','LE NOMBRE DE POINTS DE GAUSS '//
     &              'N''EST PAS CORRECT POUR L''ELEMENT DE TYPE '//
     &              NOMTE)
      END IF

C --- PASSAGE DES POINTS DE GAUSS AUX NOEUDS SOMMETS PAR MATRICE
C     V(GAUSS) = P * V(NOEUD)

      JMAT = JMAT + 2
      DO 30 IC = 1,NCMP
        DO 20 I = 1,NNOS
          S = 0.D0
          DO 10 J = 1,NPG
            S = S + ZR(JMAT-1+ (I-1)*NPG+J)*VPG(NCMP* (J-1)+IC)
   10     CONTINUE
          VNO(NCMP* (I-1)+IC) = S
   20   CONTINUE
   30 CONTINUE

C --- PASSAGE DES NOEUDS SOMMETS AUX NOEUDS MILIEUX PAR VALEUR MOYENNE
C --- EN 2D
C     ------------------------------------------------------------------
      IF (TYPMA.EQ.'TRIA3'.OR.TYPMA.EQ.'QUAD4'.OR.
     >    TYPMA.EQ.'TETRA4'.OR.TYPMA.EQ.'HEXA8'.OR.
     >    TYPMA.EQ.'PENTA6'.OR.TYPMA.EQ.'PYRAM5'.OR.
     >    TYPMA.EQ.'SEG2'.OR.TYPMA.EQ.'SEG3'.OR.
     >    TYPMA.EQ.'POI1'.OR.TYPMA.EQ.'SEG22'.OR.
     >    TYPMA.EQ.'TRIA33'.OR.TYPMA.EQ.'QUAD44'.OR.
     >    TYPMA.EQ.'SEG33'.OR.TYPMA.EQ.'SEG4') THEN 
      GOTO 999


      ELSE IF (TYPMA.EQ.'TRIA6'.OR.TYPMA.EQ.'TRIA66') THEN
        DO 40 J = 1,NCMP
C   NOEUDS 4 A 6
          VNO(NCMP*3+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(NCMP*4+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(NCMP*5+J) = (VNO(NCMP*2+J)+VNO(J))*DEMI
   40   CONTINUE

C     ------------------------------------------------------------------
      ELSE IF (TYPMA.EQ.'QUAD8' .OR. TYPMA.EQ.'QUAD88' .OR.
     &         TYPMA.EQ.'QUAD9' .OR. TYPMA.EQ.'QUAD99') THEN
        DO 50 J = 1,NCMP
C   NOEUDS 5 A 8
          VNO(NCMP*4+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(NCMP*5+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(NCMP*6+J) = (VNO(NCMP*2+J)+VNO(NCMP*3+J))*DEMI
          VNO(NCMP*7+J) = (VNO(NCMP*3+J)+VNO(J))*DEMI
   50   CONTINUE

        IF (TYPMA.EQ.'QUAD9   ') THEN
          DO 60 J = 1,NCMP
C   BARYCENTRE DES Q9
            VNO(NCMP*8+J) = (VNO(NCMP*4+J)+VNO(NCMP*6+J))*DEMI
   60     CONTINUE
        END IF

C --- EN 3D
C     ------------------------------------------------------------------
      ELSE IF (TYPMA.EQ.'HEXA20' .OR. TYPMA.EQ.'HEXA27' ) THEN
        DO 70 J = 1,NCMP
C   NOEUDS 9 A 12
          VNO(8*NCMP+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(9*NCMP+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(10*NCMP+J) = (VNO(NCMP*2+J)+VNO(NCMP*3+J))*DEMI
          VNO(11*NCMP+J) = (VNO(NCMP*3+J)+VNO(J))*DEMI

C   NOEUDS 13 A 16
          VNO(12*NCMP+J) = (VNO(J)+VNO(NCMP*4+J))*DEMI
          VNO(13*NCMP+J) = (VNO(NCMP+J)+VNO(NCMP*5+J))*DEMI
          VNO(14*NCMP+J) = (VNO(NCMP*2+J)+VNO(NCMP*6+J))*DEMI
          VNO(15*NCMP+J) = (VNO(NCMP*3+J)+VNO(NCMP*7+J))*DEMI

C   NOEUDS 17 A 20
          VNO(16*NCMP+J) = (VNO(NCMP*5+J)+VNO(NCMP*4+J))*DEMI
          VNO(17*NCMP+J) = (VNO(NCMP*6+J)+VNO(NCMP*5+J))*DEMI
          VNO(18*NCMP+J) = (VNO(NCMP*7+J)+VNO(NCMP*6+J))*DEMI
          VNO(19*NCMP+J) = (VNO(NCMP*4+J)+VNO(NCMP*7+J))*DEMI
   70   CONTINUE

        IF (TYPMA.EQ.'HEXA27') THEN
C   NOEUDS 21 A 27
          DO 80 J = 1,NCMP
            VNO(NCMP*20+J) = (VNO(NCMP*8+J)+VNO(NCMP*10+J))*DEMI
            VNO(NCMP*21+J) = (VNO(NCMP*12+J)+VNO(NCMP*13+J))*DEMI
            VNO(NCMP*22+J) = (VNO(NCMP*9+J)+VNO(NCMP*17+J))*DEMI
            VNO(NCMP*23+J) = (VNO(NCMP*14+J)+VNO(NCMP*15+J))*DEMI
            VNO(NCMP*24+J) = (VNO(NCMP*12+J)+VNO(NCMP*15+J))*DEMI
            VNO(NCMP*25+J) = (VNO(NCMP*17+J)+VNO(NCMP*19+J))*DEMI
            VNO(NCMP*26+J) = (VNO(NCMP*20+J)+VNO(NCMP*25+J))*DEMI
   80     CONTINUE
        END IF

C     ------------------------------------------------------------------
      ELSE IF (TYPMA.EQ.'PENTA15') THEN

        DO 90 J = 1,NCMP
C   NOEUDS 7 A 9
          VNO(NCMP*6+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(NCMP*7+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(NCMP*8+J) = (VNO(NCMP*2+J)+VNO(J))*DEMI

C   NOEUDS 10 A 12
          VNO(NCMP*9+J) = (VNO(J)+VNO(NCMP*3+J))*DEMI
          VNO(NCMP*10+J) = (VNO(NCMP+J)+VNO(NCMP*4+J))*DEMI
          VNO(NCMP*11+J) = (VNO(NCMP*2+J)+VNO(NCMP*5+J))*DEMI

C   NOEUDS 13 A 15
          VNO(NCMP*12+J) = (VNO(NCMP*3+J)+VNO(NCMP*4+J))*DEMI
          VNO(NCMP*13+J) = (VNO(NCMP*4+J)+VNO(NCMP*5+J))*DEMI
          VNO(NCMP*14+J) = (VNO(NCMP*5+J)+VNO(NCMP*3+J))*DEMI
   90   CONTINUE

C     ------------------------------------------------------------------
      ELSE IF (TYPMA.EQ.'TETRA10 ' ) THEN
        DO 100 J = 1,NCMP
C   NOEUDS 5 A 7
          VNO(NCMP*4+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(NCMP*5+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(NCMP*6+J) = (VNO(NCMP*2+J)+VNO(J))*DEMI

C   NOEUDS 8 A 10
          VNO(NCMP*7+J) = (VNO(J)+VNO(NCMP*3+J))*DEMI
          VNO(NCMP*8+J) = (VNO(NCMP+J)+VNO(NCMP*3+J))*DEMI
          VNO(NCMP*9+J) = (VNO(NCMP*2+J)+VNO(NCMP*3+J))*DEMI

  100   CONTINUE
C     ------------------------------------------------------------------
      ELSE IF (TYPMA.EQ.'PYRAM13 ' ) THEN
        DO 110 J = 1,NCMP

C   NOEUDS 6 A 9
          VNO(NCMP*5+J) = (VNO(J)+VNO(NCMP+J))*DEMI
          VNO(NCMP*6+J) = (VNO(NCMP+J)+VNO(NCMP*2+J))*DEMI
          VNO(NCMP*7+J) = (VNO(NCMP*2+J)+VNO(NCMP*3+J))*DEMI
          VNO(NCMP*8+J) = (VNO(NCMP*3+J)+VNO(J))*DEMI

C   NOEUDS 10 A 13
          VNO(NCMP*9+J) = (VNO(J)+VNO(NCMP*4+J))*DEMI
          VNO(NCMP*10+J) = (VNO(NCMP+J)+VNO(NCMP*4+J))*DEMI
          VNO(NCMP*11+J) = (VNO(NCMP*2+J)+VNO(NCMP*4+J))*DEMI
          VNO(NCMP*12+J) = (VNO(NCMP*3+J)+VNO(NCMP*4+J))*DEMI
  110   CONTINUE
      ELSE
        CALL UTMESS('F','PPGANO','TYPE DE MAILLE NON VALABLE')
      END IF
 999  CONTINUE
      END
