      SUBROUTINE TE0467 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/04/2010   AUTEUR DESROCHES X.DESROCHES 
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
      IMPLICIT NONE
      CHARACTER*16        OPTION , NOMTE
C ----------------------------------------------------------------------
C     CALCUL DE L OPTION COOR_ELGA
C     POUR LES ELEMENTS 1D SEG2
C
C     POUR CHAQUE POINT DE GAUSS :
C     1) COORDONNEES DU POINT DE GAUSS
C     2) POIDS X JACOBIEN AU POINT DE GAUSS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER            NDIM,NNO,NNOS,NPG,JGANO,KP,ICOPG,INO
      INTEGER            IDFDE,IPOIDS,IVF,IGEOM,I
      REAL*8             XX,YY,POIDS,JACP,RBID,RBID2(2)
      LOGICAL            LTEATT, LAXI
C
      CALL ELREF4('SE2','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,
     &            IDFDE,JGANO)
      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCOORPG','E',ICOPG )
C
      DO 100 KP=1,NPG
        XX=0.D0
        YY=0.D0
        DO 50 INO=1,NNO
          XX=XX+ZR(IGEOM+2*(INO-1)+0)*ZR(IVF+(KP-1)*NNO+INO-1)
          YY=YY+ZR(IGEOM+2*(INO-1)+1)*ZR(IVF+(KP-1)*NNO+INO-1)
   50   CONTINUE
        ZR(ICOPG+3*(KP-1)+0)=XX
        ZR(ICOPG+3*(KP-1)+1)=YY
        POIDS=ZR(IPOIDS-1+KP)
        CALL DFDM1D (NNO,POIDS,ZR(IDFDE),ZR(IGEOM),RBID2,RBID,
     &               JACP,RBID,RBID)
C       EN AXI R C'EST XX
        IF (LAXI) JACP=JACP*XX          
        ZR(ICOPG+3*(KP-1)+2)=JACP
  100 CONTINUE
C
      END
