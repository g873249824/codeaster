      SUBROUTINE       CONARE(TYPMA,AR,NBAR)
      IMPLICIT NONE
      INTEGER          AR(12,2),NBAR
      CHARACTER*8      TYPMA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2005   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                       RENVOIE LA MATRICE DE CONNECTIVIT� DES 
C                       ARETES D'UNE MAILLE DE TYPE TYPMA
C
C    ENTREE :
C              TYPMA : TYPE DE LA MAILLE
C
C    SORTIE : 
C              AR   : MATRICE DE CONNECTIVIT� DES ARETES
C              NBAR : NOMBRE D'ARETES
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     
      INTEGER       I,J      
C ----------------------------------------------------------------------

      CALL JEMARQ()

      DO 100 I=1,12
        DO 110 J=1,2
          AR(I,J)=0
 110    CONTINUE
 100  CONTINUE    

      IF (TYPMA.EQ.'HEXA8'.OR.TYPMA.EQ.'HEXA20') THEN
        NBAR=12
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE HEXA8 OU HEXA20
        AR(1,1)=1
        AR(1,2)=2
        AR(2,1)=2
        AR(2,2)=3
        AR(3,1)=3
        AR(3,2)=4
        AR(4,1)=4
        AR(4,2)=1
        AR(5,1)=5
        AR(5,2)=6
        AR(6,1)=6
        AR(6,2)=7
        AR(7,1)=7
        AR(7,2)=8
        AR(8,1)=8
        AR(8,2)=5
        AR(9,1)=1
        AR(9,2)=5
        AR(10,1)=2
        AR(10,2)=6
        AR(11,1)=3
        AR(11,2)=7
        AR(12,1)=4
        AR(12,2)=8  
      ELSEIF (TYPMA.EQ.'PENTA6'.OR.TYPMA.EQ.'PENTA15') THEN
        NBAR=9
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE PENTA6 OU PENTA15
        AR(1,1)=1
        AR(1,2)=2
        AR(2,1)=2
        AR(2,2)=3
        AR(3,1)=3
        AR(3,2)=1
        AR(4,1)=4
        AR(4,2)=5
        AR(5,1)=5
        AR(5,2)=6
        AR(6,1)=6
        AR(6,2)=4
        AR(7,1)=1
        AR(7,2)=4
        AR(8,1)=2
        AR(8,2)=5
        AR(9,1)=3
        AR(9,2)=6
      ELSEIF (TYPMA.EQ.'TETRA4'.OR.TYPMA.EQ.'TETRA10') THEN
        NBAR=6
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE TETRA4 OU TETRA10
        AR(1,1)=1
        AR(1,2)=2
        AR(2,1)=1
        AR(2,2)=3
        AR(3,1)=1
        AR(3,2)=4
        AR(4,1)=2
        AR(4,2)=3
        AR(5,1)=2
        AR(5,2)=4
        AR(6,1)=3
        AR(6,2)=4
      ELSEIF (TYPMA.EQ.'QUAD4'.OR.TYPMA.EQ.'QUAD8') THEN
        NBAR=4
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE QUAD4 OU QUAD10
        AR(1,1)=1
        AR(1,2)=2
        AR(2,1)=2
        AR(2,2)=3
        AR(3,1)=3
        AR(3,2)=4
        AR(4,1)=1
        AR(4,2)=4     
      ELSEIF (TYPMA.EQ.'TRIA3'.OR.TYPMA.EQ.'TRIA6') THEN
        NBAR=3
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE TRIA3 OU TRIA6
        AR(1,1)=1
        AR(1,2)=2
        AR(2,1)=2
        AR(2,2)=3
        AR(3,1)=1
        AR(3,2)=3
      ELSEIF (TYPMA.EQ.'SEG2'.OR.TYPMA.EQ.'SEG3') THEN
        NBAR=1
C       CONNECTIVIT� DES ARETES POUR UNE MAILLE SEG2 OU SEG3
        AR(1,1)=1
        AR(1,2)=2
      ELSEIF (TYPMA.EQ.'POI1') THEN
        NBAR=0
      ELSE
        CALL UTMESS('F','CONARE','LA MAILLE DOIT ETRE DE TYPE '//
     &      'TETRA4, TETRA10, PENTA6, PENTA15, HEXA8 OU HEXA20. '//
     &      'OR LA MAILLE EST DE TYPE : '//TYPMA//'.') 
      ENDIF

      CALL JEDEMA()
      END
