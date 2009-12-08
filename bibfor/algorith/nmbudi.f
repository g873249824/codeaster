      SUBROUTINE NMBUDI(MODELE,NUMEDD,LISCHA,VECLAG,VEBUDI,
     &                  CNBUDI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE     
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE,NUMEDD
      CHARACTER*24  VECLAG
      CHARACTER*19  VEBUDI,CNBUDI
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DES CONDITIONS DE DIRICHLET B.U
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NOM DE LA NUMEROTATION
C IN  LISCHA : LISTE DES CHARGES
C IN  VECLAG : VECTEUR D'INCONNUES PORTANT LES LAGRANGES
C OUT VEBUDI : VECT_ELEM DES CONDITIONS DE DIRICHLET B.U
C OUT CNBUDI : VECT_ASSE DES CONDITIONS DE DIRICHLET B.U
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IFM,NIV
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... ASSEMBLAGE DES REACTIONS '//
     &                'D''APPUI'
      ENDIF                   
C
C --- CALCUL <CNBUDI>
C
      CALL VEBUME(MODELE,VECLAG,LISCHA,VEBUDI) 
C
C --- ASSEMBLAGE <CNBUDI>
C
      CALL ASSVEC('V'   ,CNBUDI,1     ,VEBUDI,1.D0  ,
     &            NUMEDD,' '   ,'ZERO',1     )     
C
      IF (NIV.GE.2) THEN
        CALL NMDEBG('VECT',CNBUDI,6)
      ENDIF    
C
      CALL JEDEMA()
      END
