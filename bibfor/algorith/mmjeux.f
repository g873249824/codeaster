      SUBROUTINE MMJEUX(ALIAS ,NNO   ,NDIM  ,COORMA,KSI1  ,
     &                  KSI2  ,COORPT,JEUPM )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/10/2008   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  ALIAS         
      INTEGER      NNO,NDIM
      REAL*8       COORMA(27)
      REAL*8       COORPT(3)
      REAL*8       JEUPM
      REAL*8       KSI1,KSI2
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C CALCUL DE LA DISTANCE ENTRE POINT ET SA PROJECTION SUR LA 
C MAILLE 
C      
C ----------------------------------------------------------------------
C
C
C IN  ALIAS  : TYPE DE MAILLE
C IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
C IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
C IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE 
C IN  COORPT : COORDONNEES DU POINT 
C IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE DE LA PROJECTION DU
C              POINT SUR LA MAILLE
C IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE DE LA PROJECTION DU
C              POINT SUR LA MAILLE
C OUT JEUPM  : DISTANCE ENTRE POINT ET SA PROJECTION SUR LA MAILLE
C
C ----------------------------------------------------------------------
C
      REAL*8       COORPR(3),DIST(3)
      INTEGER      IDIM,NDIMG
      REAL*8       ZERO
      PARAMETER    (ZERO=0.D0)      
C
C ----------------------------------------------------------------------
C
      NDIMG   = 3
C
      DO 10 IDIM  = 1,NDIMG
        DIST(IDIM) = ZERO  
   10 CONTINUE    
C
C --- COORDONNEES DU PROJETE
C
      CALL MMCOOR(ALIAS ,NNO   ,NDIM  ,COORMA,KSI1  ,
     &            KSI2  ,COORPR)
C
C --- DISTANCE POINT DE CONTACT/PROJECTION 
C
      DO 140 IDIM = 1,NDIMG
        DIST(IDIM) = COORPR(IDIM) - COORPT(IDIM)
  140 CONTINUE
C
C --- JEUPM
C  
      JEUPM = SQRT(DIST(1)**2+DIST(2)**2+DIST(3)**2)

      END
