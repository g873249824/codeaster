      SUBROUTINE  INIGMS(NOMAIL,NBNOMA,NUCONN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/05/2005   AUTEUR GJBHHEL E.LORENTZ 
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
           INTEGER     NUCONN(15,32),NBNOMA(15)
           CHARACTER*8  NOMAIL(*)


C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI,OPT,TE
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,ERROR
      CHARACTER*8 ZK8,PARA,TYPMAI
      CHARACTER*16 ZK16,NOMOPT,NOMTE
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 KBID,GD1,GD2,TGD1(10),TGD2(10),TYPOUT,TYPOU2
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------

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
      NOMAIL(10)  = 'QUAD8'
      NOMAIL(11)  = 'TETRA10'
      NOMAIL(12)  = 'HEXA20'
      NOMAIL(13)  = 'PENTA15'
      NOMAIL(14)  = 'PYRAM13'
      NOMAIL(15) = 'POI1'

      DO 5 M = 1,15
        CALL JEVEUO(JEXNOM('&CATA.TM.NBNO',NOMAIL(M)),'L',JNBNO)
        NBNOMA(M) = ZI(JNBNO)
 5    CONTINUE


C CORRESPONDANCE DE LA NUMEROTATION DES NOEUDS ENTRE GMSH ET ASTER
C TABLEAU NUCONN(TYPE,ND_ASTER) = ND_GMSH
C   TYPE     : NUMERO DU TYPE DE MAILLE (CF. TABLEAU NOMAIL)
C   ND_ASTER : NUMERO DU NOEUD DE LA MAILLE ASTER DE REFERENCE
C   ND_GMSH  : NUMERO DU NOEUD DE LA MAILLE GMSH  DE REFERENCE

C    PAR DEFAUT LES NUMEROTATIONS COINCIDENT
      DO 10 I = 1,15
        DO 20 J = 1,32
          NUCONN(I,J) = J
 20     CONTINUE
 10   CONTINUE

C   ON DECLARE MAINTENANT LES EXCEPTIONS

C    TETRA 10
      NUCONN(11, 9) = 10
      NUCONN(11,10) =  9

C    HEXA 20
      NUCONN(12, 9) =  9
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

C    PENTA 15
      NUCONN(13, 7) =  7
      NUCONN(13, 8) = 10
      NUCONN(13, 9) =  8
      NUCONN(13,10) =  9
      NUCONN(13,11) = 11
      NUCONN(13,12) = 12
      NUCONN(13,13) = 13
      NUCONN(13,14) = 15
      NUCONN(13,15) = 14

C    PYRAM 13
      NUCONN(14, 6) =  6
      NUCONN(14, 7) =  9
      NUCONN(14, 8) = 11
      NUCONN(14, 9) =  7
      NUCONN(14,10) =  8
      NUCONN(14,11) = 10
      NUCONN(14,12) = 12
      NUCONN(14,13) = 13


C
C.============================ FIN DE LA ROUTINE ======================
      END
