      SUBROUTINE  INIGMS(NOMAIL,NBNOMA,NUCONN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C.======================================================================

C
C      INIGMS --   INITIALISATION DES TYPES DE MAILLES
C                  POUR LE PASSAGE GMSH VERS ASTER
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NOMAIL(*)      OUT   K8       NOM DES TYPES DE MAILLES
C    NBNOMA         OUT   I        NOMBRE DE NOEUDS DES MAILLES ASTER
C    NUCONN(15,32)  OUT   I        CORRESPONDANCE DES NDS GMSH / ASTER
C                                   NUCONN(TYPMAI,ND_ASTER) = ND_GMSH

C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
           IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
           INTEGER     NUCONN(19,32),NBNOMA(19)
           CHARACTER*8  NOMAIL(*)



      INTEGER M,JNBNO,I,J
C.========================= DEBUT DU CODE EXECUTABLE ==================

C
      NOMAIL(1)  = 'SEG2'
      NOMAIL(2)  = 'TRIA3'
      NOMAIL(3)  = 'QUAD4'
      NOMAIL(4)  = 'TETRA4'
      NOMAIL(5)  = 'HEXA8'
      NOMAIL(6)  = 'PENTA6'
      NOMAIL(7)  = 'PYRAM5'
      NOMAIL(8)  = 'SEG3'
      NOMAIL(9)  = 'TRIA6'
      NOMAIL(10) = 'QUAD8'
      NOMAIL(11) = 'TETRA10'
      NOMAIL(12) = 'HEXA27'
      NOMAIL(13) = 'PENTA18'
      NOMAIL(14) = 'PYRAM13'
      NOMAIL(15) = 'POI1'
      NOMAIL(16) = 'QUAD8'
      NOMAIL(17) = 'HEXA20'
      NOMAIL(18) = 'PENTA15'
      NOMAIL(19) = 'PYRAM13'

      DO 5 M = 1,19
        CALL JEVEUO(JEXNOM('&CATA.TM.NBNO',NOMAIL(M)),'L',JNBNO)
        NBNOMA(M) = ZI(JNBNO)
 5    CONTINUE


C CORRESPONDANCE DE LA NUMEROTATION DES NOEUDS ENTRE GMSH ET ASTER
C TABLEAU NUCONN(TYPE,ND_ASTER) = ND_GMSH
C   TYPE     : NUMERO DU TYPE DE MAILLE (CF. TABLEAU NOMAIL)
C   ND_ASTER : NUMERO DU NOEUD DE LA MAILLE ASTER DE REFERENCE
C   ND_GMSH  : NUMERO DU NOEUD DE LA MAILLE GMSH  DE REFERENCE

C    PAR DEFAUT LES NUMEROTATIONS COINCIDENT
      DO 10 I = 1,19
        DO 20 J = 1,32
          NUCONN(I,J) = J
 20     CONTINUE
 10   CONTINUE

C   ON DECLARE MAINTENANT LES EXCEPTIONS

C    TETRA 10
      NUCONN(11, 9) = 10
      NUCONN(11,10) =  9

C    HEXA 27
      NUCONN(12,10) = 12
      NUCONN(12,11) = 14
      NUCONN(12,12) = 10
      NUCONN(12,13) = 11
      NUCONN(12,14) = 13
      NUCONN(12,15) = 15
      NUCONN(12,16) = 16
      NUCONN(12,17) = 17
      NUCONN(12,18) = 19
      NUCONN(12,19) = 20
      NUCONN(12,20) = 18
      NUCONN(12,23) = 24
      NUCONN(12,24) = 25
      NUCONN(12,25) = 23

C    PENTA 18
      NUCONN(13, 7) =  7
      NUCONN(13, 8) = 10
      NUCONN(13, 9) =  8
      NUCONN(13,10) =  9
      NUCONN(13,11) = 11
      NUCONN(13,12) = 12
      NUCONN(13,13) = 13
      NUCONN(13,14) = 15
      NUCONN(13,15) = 14
      NUCONN(13,17) = 18
      NUCONN(13,18) = 17

C    PYRAM 13
      NUCONN(14, 6) =  6
      NUCONN(14, 7) =  9
      NUCONN(14, 8) = 11
      NUCONN(14, 9) =  7
      NUCONN(14,10) =  8
      NUCONN(14,11) = 10
      NUCONN(14,12) = 12
      NUCONN(14,13) = 13

C    HEXA 20
      NUCONN(17,10) = 12
      NUCONN(17,11) = 14
      NUCONN(17,12) = 10
      NUCONN(17,13) = 11
      NUCONN(17,14) = 13
      NUCONN(17,15) = 15
      NUCONN(17,16) = 16
      NUCONN(17,17) = 17
      NUCONN(17,18) = 19
      NUCONN(17,19) = 20
      NUCONN(17,20) = 18

C    PENTA 15
      NUCONN(18, 7) =  7
      NUCONN(18, 8) = 10
      NUCONN(18, 9) =  8
      NUCONN(18,10) =  9
      NUCONN(18,11) = 11
      NUCONN(18,12) = 12
      NUCONN(18,13) = 13
      NUCONN(18,14) = 15
      NUCONN(18,15) = 14

C    PYRAM 13
      NUCONN(19, 6) =  6
      NUCONN(19, 7) =  9
      NUCONN(19, 8) = 11
      NUCONN(19, 9) =  7
      NUCONN(19,10) =  8
      NUCONN(19,11) = 10
      NUCONN(19,12) = 12
      NUCONN(19,13) = 13


C
C.============================ FIN DE LA ROUTINE ======================
      END
