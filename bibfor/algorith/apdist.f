      SUBROUTINE APDIST(ELREFE,COORMA,NBNO  ,KSI1  ,KSI2  ,
     &                  COORPT,DIST  ,VECPM )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INTEGER      NBNO
      CHARACTER*8  ELREFE
      REAL*8       COORMA(27),COORPT(3)
      REAL*8       KSI1,KSI2
      REAL*8       DIST,VECPM(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C DISTANCE POINT - PROJECTION SUR MAILLE
C
C ----------------------------------------------------------------------
C
C
C IN  ELREFE : TYPE DE LA MAILLE
C IN  COORMA : COORDONNEES DE LA MAILLE
C IN  NBNO   : NOMBRE DE NOEUDS DE LA MAILLE
C IN  KSI1   : COORD. PARAM. 1 DE LA PROJECTION SUR MAILLE
C IN  KSI2   : COORD. PARAM. 2 DE LA PROJECTION SUR MAILLE
C IN  COORPT : COORD. DU POINT A PROJETER
C OUT VECPM  : VECTEUR POINT DE CONTACT -> SON PROJETE SUR MAILLE
C OUT DIST   : DISTANCE POINT - PROJECTION (NORME DE VECPM)
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV 
      REAL*8       COORPR(3)
      INTEGER      IDIM,INO,IBID
      REAL*8       ZERO
      PARAMETER    (ZERO=0.D0) 
      REAL*8       KSI(2),FF(9)               
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)     
C
C --- INITIALISATIONS
C
      VECPM(1) = ZERO
      VECPM(2) = ZERO
      VECPM(3) = ZERO
      COORPR(1) = ZERO
      COORPR(2) = ZERO
      COORPR(3) = ZERO
      KSI(1)    = KSI1
      KSI(2)    = KSI2
      DIST      = 0   
C
C --- RECUP FONCTIONS DE FORME 
C
      CALL ELRFVF(ELREFE,KSI   ,NBNO  ,FF    ,IBID  )
C
C --- COORDONNEES DE LA PROJECTION
C
      DO 40 IDIM = 1,3
        DO 30 INO = 1,NBNO
          COORPR(IDIM) = FF(INO)*COORMA(3*(INO-1)+IDIM) + COORPR(IDIM)
   30   CONTINUE
   40 CONTINUE
C
C --- VECTEUR POINT/PROJECTION 
C
      DO 140 IDIM = 1,3
        VECPM(IDIM) = COORPR(IDIM) - COORPT(IDIM)
  140 CONTINUE
C
C --- CALCUL DE LA DISTANCE
C  
      DIST  = SQRT(VECPM(1)**2+VECPM(2)**2+VECPM(3)**2)   
   
      CALL JEDEMA()
C 
      END
