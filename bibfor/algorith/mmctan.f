      SUBROUTINE MMCTAN(NOMMAI,ALIAS ,NNO   ,NDIM  ,COORMA,
     &                  COORNO,ITEMAX,EPSMAX,TAU1  ,TAU2  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*8   NOMMAI,ALIAS
      INTEGER       ITEMAX,NDIM,NNO
      REAL*8        EPSMAX,COORNO(3),COORMA(27)
      REAL*8        TAU1(3),TAU2(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
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
C OUT TAU1   : PREMIERE TANGENTE (NORMALISEE)
C OUT TAU2   : SECONDE TANGENTE (NORMALISEE)
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
      INTEGER      IFM,NIV
      INTEGER      NIVERR
      REAL*8       KSI1,KSI2 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
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
        CALL U2MESS('I','CONTACT3_33')
        CALL U2MESG('F','CONTACT3_13',1,NOMMAI,0,0,3,COORNO)       
      ENDIF      
C
C --- NORMALISATION DES VECTEURS TANGENTS 
C
      CALL MMTANN(NDIM  ,TAU1  ,TAU2  ,NIVERR)     
      IF (NIVERR.EQ.1) THEN  
        CALL U2MESS('I','CONTACT3_33')
        CALL U2MESG('F','CONTACT3_14',1,NOMMAI,0,0,3,COORNO)          
      ENDIF
C
      CALL JEDEMA()
      END
