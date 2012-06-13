      SUBROUTINE MMCTAN(NOMMAI,ALIAS ,NNO   ,NDIM  ,COORMA,
     &                  COORNO,ITEMAX,EPSMAX,TAU1  ,TAU2  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMMAI,ALIAS
      INTEGER       ITEMAX,NDIM,NNO
      REAL*8        EPSMAX,COORNO(3),COORMA(27)
      REAL*8        TAU1(3),TAU2(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C CALCUL DES TANGENTES EN UN NOEUD D'UNE MAILLE
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMMAI : NOM DE LA MAILLE
C IN  ALIAS  : TYPE DE LA MAILLE
C IN  NNO    : NOMBRE DE NOEUDS DE LA MAILLE
C IN  NDIM   : DIMENSION DE LA MAILLE
C IN  COORMA : CORDONNNES DE LA MAILLE
C IN  COORNO : COORODNNEES DU NOEUD 
C IN  ITEMAX : NOMBRE MAXI D'ITERATIONS DE NEWTON POUR LA PROJECTION
C IN  EPSMAX : RESIDU POUR CONVERGENCE DE NEWTON POUR LA PROJECTION
C OUT TAU1   : PREMIERE TANGENTE (NON NORMALISEE)
C OUT TAU2   : SECONDE TANGENTE (NON NORMALISEE)
C 
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      NIVERR
      REAL*8       KSI1,KSI2 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)
C
C --- INITIALISATIONS
C           
      NIVERR = 0
C
C --- CALCUL DES VECTEURS TANGENTS DE LA MAILLE EN CE NOEUD
C         
      CALL MMNEWT(ALIAS ,NNO   ,NDIM  ,COORMA,COORNO,
     &            ITEMAX,EPSMAX,KSI1  ,KSI2  ,TAU1  ,
     &            TAU2  ,NIVERR)
C  
C --- GESTION DES ERREURS LORS DU NEWTON LOCAL POUR LA PROJECTION
C   
      IF (NIVERR.EQ.1) THEN
        CALL U2MESG('F','APPARIEMENT_13',1,NOMMAI,0,0,3,COORNO)       
      ENDIF
C
      CALL JEDEMA()
      END
