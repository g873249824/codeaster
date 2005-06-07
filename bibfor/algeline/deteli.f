      SUBROUTINE DETELI(LMAT)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           LMAT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 12/05/95   AUTEUR CIBHHGB G.BERTRAND 
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
C     DESTRUCTION DE LA S.D. ELIM_DDL DE LA MATR_ASSE DE
C     DESCRIPTEUR LMAT SI CETTE S.D. EXISTE
C     -----------------------------------------------------------------
C VAR  I  LMAT   = POINTEUR DE MATRICE DONT ON VEUT DETRUIRE
C                  LE ELIM_DDL
C     -----------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32  JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C     -----------------------------------------------------------------
      CHARACTER*19  MATIN
C     -----------------------------------------------------------------
      MATIN = ZK24(ZI(LMAT+1))
C
C --- NOMBRE DE DDLS ELIMINES
C
      NIMP = ZI(LMAT+7)
      IF (NIMP.NE.0) THEN
        CALL JEDETR(MATIN//'.CONI')
        CALL JEDETR(MATIN//'.LLIG')
        ZI(LMAT+7) = 0
        ZI(LMAT+15) = 0
        CALL JEDETR(MATIN//'.ALIG')
        ZI(LMAT+16) = 0
        CALL JEDETR(MATIN//'.ABLI')
        ZI(LMAT+17) = 0
        ZI(LMAT+18) = 0
        CALL JEDETR(MATIN//'.VALI')
      ENDIF
C
      END
