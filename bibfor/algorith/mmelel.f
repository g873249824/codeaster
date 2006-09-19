      SUBROUTINE MMELEL(IIN,NTYMA1,NTYMA2,IORDR,NNDEL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INTEGER      IIN
      CHARACTER*8  NTYMA1
      CHARACTER*8  NTYMA2      
      INTEGER      NNDEL
      INTEGER      IORDR  
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : MMLIGR
C ----------------------------------------------------------------------
C
C RETOURNE DES INFOS SUR LES ELEMENTS DE CONTACT FORMES ENTRE
C DEUX ELEMENTS DE SURFACE
C
C IN  IIN    : NUMERO D'ORDRE EN ENTREE
C               SI ZERO: ON UTILISE NTYMA1/NTYMA2
C IN  NTYMA1 : PREMIERE MAILLE 
C IN  NTYMA2 : SECONDE  MAILLE 
C OUT IORDR  : ORDRE DANS LA LISTE DES ELEMENTS
C OUT NNDEL  : NOMBRE DE NOEUDS DE L'ELEMENT DE CONTACT
C
C
C ----------------------------------------------------------------------
C
      INTEGER      NBTYP
      PARAMETER    (NBTYP=30)
      CHARACTER*8  CPL(NBTYP,2)
      INTEGER      NPL(NBTYP)
      INTEGER      K
C
      DATA (CPL(K,1),K=1,NBTYP) /
     &      'SEG2','SEG3','SEG2','SEG3','TRIA3', 
     &      'TRIA3','TRIA6','TRIA6','QUAD4','QUAD4',
     &      'QUAD8','QUAD8','QUAD4','TRIA3','TRIA6',
     &      'QUAD4','TRIA6','QUAD8','TRIA6','QUAD9',
     &      'QUAD8','TRIA3','QUAD8','QUAD9','QUAD9',
     &      'QUAD4','QUAD9','TRIA3','QUAD9','SEG2'/      
      DATA (CPL(K,2),K=1,NBTYP) /
     &      'SEG2','SEG3','SEG3','SEG2','TRIA3', 
     &      'TRIA6','TRIA3','TRIA6','QUAD4','QUAD8',
     &      'QUAD4','QUAD8','TRIA3','QUAD4','QUAD4',
     &      'TRIA6','QUAD8','TRIA6','QUAD9','TRIA6',
     &      'TRIA3','QUAD8','QUAD9','QUAD8','QUAD4',
     &      'QUAD9','TRIA3','QUAD9','QUAD9','SEG2'/          
      DATA (NPL(K),K=1,NBTYP) /
     &      4 ,6 ,5 ,5 ,6 ,
     &      9 ,9 ,12,8 ,12,
     &      12,16,7 ,7 ,10,
     &      10,14,14,15,15,
     &      11,11,17,17,13,
     &      13,12,12,18,4/
C
C ----------------------------------------------------------------------
C
      IORDR = 0
      NNDEL = 0
C
      IF (IIN.EQ.0) THEN
        DO 10 K=1,NBTYP
          IF (NTYMA1.EQ.CPL(K,1)) THEN
            IF (NTYMA2.EQ.CPL(K,2)) THEN
              NNDEL = NPL(K)
              IORDR = K         
            ENDIF        
          ENDIF    
  10    CONTINUE
      ELSEIF ((IIN.GT.0).AND.(IIN.LE.NBTYP)) THEN
        IORDR = IIN
        NNDEL = NPL(IIN)
      ELSE
        IORDR = 0
      ENDIF

      IF (IORDR.EQ.0) THEN
        CALL UTMESS('F','MMELEL','ELEMENT DE CONTACT INCONNU (DVLP)')
      ENDIF
      
      END
