      SUBROUTINE DXQFOR ( TYPELE , GLOBAL , XYZL , PGL , FOR , VECL )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/01/98   AUTEUR CIBHHLB L.BOURHRARA 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8  TYPELE
      LOGICAL      GLOBAL
      REAL*8       XYZL(3,*) , PGL(3,*)
      REAL*8       FOR(6,4)
      REAL*8       VECL(*)
C     ------------------------------------------------------------------
C     CHARGEMENT FORCE_FACE DES ELEMENTS DE PLAQUE DKQ ET DSQ
C     ------------------------------------------------------------------
C     IN  TYPELE : TYPE DE L'ELEMENT
C     IN  GLOBAL : VARIABLE LOGIQUE DE REPERE GLOBAL OU LOCAL
C     IN  XYZL   : COORDONNEES LOCALES DES QUATRE NOEUDS
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL - LOCAL
C     IN  FOR    : FORCE APPLIQUE SUR LA FACE
C     OUT VECL   : CHARGEMENT NODAL RESULTANT
C     ------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*24 DESR
      REAL*8       AIRE(4) , C1 , C2 , FNO(6,4,4)
      REAL*8       FX , FY
C     ------------------ PARAMETRAGE QUADRANGLE ------------------------
      INTEGER NPG , NC , NNO
      INTEGER LJACO,LTOR,LQSI,LETA,LWGT,LXYC,LCOTE,LCOS,LSIN,
     &        LAIRE,LAIRN,LT1VE,LT2VE
               PARAMETER (NPG   = 4)
               PARAMETER (NNO   = 4)
               PARAMETER (NC    = 4)
               PARAMETER (LJACO = 2)
               PARAMETER (LTOR  = LJACO + 4)
               PARAMETER (LQSI  = LTOR  + 1)
               PARAMETER (LETA  = LQSI + NPG + NNO + 2*NC)
               PARAMETER (LWGT  = LETA + NPG + NNO + 2*NC)
               PARAMETER (LXYC  = LWGT + NPG)
               PARAMETER (LCOTE = LXYC + 2*NC)
               PARAMETER (LCOS  = LCOTE + NC)
               PARAMETER (LSIN  = LCOS + NC)
               PARAMETER (LAIRE = LSIN  + NC)
               PARAMETER (LAIRN = LAIRE + 1)
               PARAMETER (LT1VE = LAIRN + 4 )
               PARAMETER (LT2VE = LT1VE + 9 )
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      DESR = '&INEL.'//TYPELE//'.DESR'
      CALL JEVETE( DESR ,' ',LZR )
C
C     ----- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE --------
      CALL GQUAD4 (XYZL , ZR(LZR))
      CALL DXREPE ( NNO , PGL , ZR(LZR) )
C
      IF (.NOT. GLOBAL) THEN
         DO 50 I = 1, NNO
            FX = FOR(1,I)
            FY = FOR(2,I)
            FOR(1,I) = FX*ZR(LZR-1+LT2VE  ) + FY*ZR(LZR-1+LT2VE+2)
            FOR(2,I) = FX*ZR(LZR-1+LT2VE+1) + FY*ZR(LZR-1+LT2VE+3)
            FX = FOR(4,I)
            FY = FOR(5,I)
            FOR(4,I) = FX*ZR(LZR-1+LT2VE  ) + FY*ZR(LZR-1+LT2VE+2)
            FOR(5,I) = FX*ZR(LZR-1+LT2VE+1) + FY*ZR(LZR-1+LT2VE+3)
   50    CONTINUE
      ENDIF
      DO 100 INO = 1, NNO
         AIRE(INO) = ZR(LZR-1+LAIRN+INO-1)
  100 CONTINUE
      DO 110 K = 1, 6*NNO*NNO
         FNO(K,1,1) = 0.D0
  110  CONTINUE
      DO 120 I = 1, 6*NNO
         VECL(I) = 0.D0
  120  CONTINUE
      C1 = 1.D0 /  6.D0
      C2 = 1.D0 / 12.D0
      DO 200 I = 1, 6
         FNO(I,1,1) = (C1*FOR(I,1)+C2*FOR(I,2)+C2*FOR(I,4)) * AIRE(1)
         FNO(I,1,2) = (C2*FOR(I,1)+C1*FOR(I,2)+C2*FOR(I,4)) * AIRE(1)
         FNO(I,1,4) = (C2*FOR(I,1)+C2*FOR(I,2)+C1*FOR(I,4)) * AIRE(1)
         FNO(I,2,2) = (C1*FOR(I,2)+C2*FOR(I,3)+C2*FOR(I,1)) * AIRE(2)
         FNO(I,2,3) = (C2*FOR(I,2)+C1*FOR(I,3)+C2*FOR(I,1)) * AIRE(2)
         FNO(I,2,1) = (C2*FOR(I,2)+C2*FOR(I,3)+C1*FOR(I,1)) * AIRE(2)
         FNO(I,3,3) = (C1*FOR(I,3)+C2*FOR(I,4)+C2*FOR(I,2)) * AIRE(3)
         FNO(I,3,4) = (C2*FOR(I,3)+C1*FOR(I,4)+C2*FOR(I,2)) * AIRE(3)
         FNO(I,3,2) = (C2*FOR(I,3)+C2*FOR(I,4)+C1*FOR(I,2)) * AIRE(3)
         FNO(I,4,4) = (C1*FOR(I,4)+C2*FOR(I,1)+C2*FOR(I,3)) * AIRE(4)
         FNO(I,4,1) = (C2*FOR(I,4)+C1*FOR(I,1)+C2*FOR(I,3)) * AIRE(4)
         FNO(I,4,3) = (C2*FOR(I,4)+C2*FOR(I,1)+C1*FOR(I,3)) * AIRE(4)
         DO 160 INO = 1, NNO
            DO 150 IT = 1, NNO
               VECL(I+6*(INO-1)) = VECL(I+6*(INO-1)) + FNO(I,IT,INO)
  150       CONTINUE
            VECL(I+6*(INO-1)) = VECL(I+6*(INO-1)) / 2.D0
  160    CONTINUE
  200 CONTINUE
C
      CALL JEDEMA()
      END
