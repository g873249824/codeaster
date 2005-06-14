      SUBROUTINE IRGMOR ( TORD, VERS )
      IMPLICIT   NONE
      INTEGER    NTYELE,NELETR
      PARAMETER (NTYELE = 27)
      PARAMETER (NELETR =  8)
C
      INTEGER             TORD(NTYELE)
      INTEGER                          VERS
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/02/2004   AUTEUR MCOURTOI M.COURTOIS 
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
C     ------------------------------------------------------------------
C     IN  : VERS
C     OUT : TORD
C
C     NTYELE : NOMBRE DE TYPES DE MAILLES TRAITEES
C              (MAX DE TYPE_MAILLE__.CATA)
C
C     NELETR : NOMBRE DE TYPES DE MAILLES TRANSMISES A GMSH
C
C     RETOURNE LE TABLEAU DANS L'ORDRE DANS LEQUEL ON DOIT IMPRIMER
C     LES ELEMENTS (OU PLUTOT LES VALEURS QU'ILS PORTENT)
C      TORD(1)=NUMERO DE LA MAILLE POI1...
C
C     DOC GMSH (FILE FORMATS VERSION 1.2)
C        point
C        line
C        triangle
C        quadrangle
C        tetrahedron
C        hexahedron
C        prism
C        pyramid     ET POUR CHAQUE scalar, vector, puis tensor
C
C     ------------------------------------------------------------------
      INTEGER I, IND
      CHARACTER*32 JEXNOM
C
C --- DATA QUI DEFINIT L'ORDRE
C     (IDENTIQUE EN VERSION 1.0 ET 1.2 PUISQUE ON AURA ZERO ELEMENT SUR
C      LES TYPES QUE LA VERSION 1.0 NE CONNAIT PAS)
      CHARACTER*8 FORMGM(NELETR)
      DATA FORMGM/'POI1',  'SEG2',   'TRIA3', 'QUAD4', 'TETRA4',
     +            'HEXA8', 'PENTA6', 'PYRAM5'/
C     ------------------------------------------------------------------
C --- VERIF
      IF(VERS.NE.1.AND.VERS.NE.2) GOTO 999
C
C --- REMPLISSAGE QUI POURRAIT VARIER SELON LA VERSION
      DO 10 I=1,NELETR
         CALL JENONU(JEXNOM('&CATA.TM.NOMTM',FORMGM(I)),IND)
         IF(IND.GT.NTYELE) GOTO 999
         TORD(I)=IND
10    CONTINUE
      GOTO 9000

C     VERIFICATION EMMELAGE DE PINCEAUX DU PROGRAMMEUR...
 999  CONTINUE
      CALL UTMESS('F','IRGMTB','ERREUR DE PROGRAMMATION')
C     ------------------------------------------------------------------
C
9000  CONTINUE
      END
