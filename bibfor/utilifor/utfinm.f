      SUBROUTINE UTFINM
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 21/02/96   AUTEUR VABHHTS J.PELLET 
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
C     ==================================================================
      INTEGER          MXCOLS , ITABU , LIGCOU , COLCOU , IDF
      COMMON /UTINIP/  MXCOLS , ITABU , LIGCOU , COLCOU , IDF
      PARAMETER      ( NT = 10 )
      CHARACTER*132    TAMPON
      COMMON /UTTAMP/  TAMPON(NT)
      INTEGER          LDEB
      COMMON /UTDEB /  LDEB
C     ------------------------------------------------------------------
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      CHARACTER*24   SPVR,CBID
C     ------------------------------------------------------------------
      CALL JEMARQ()
      LIGCOU = LIGCOU + 1
      IF ( LIGCOU .GT. NT ) THEN
         CALL UTVTAM
         LIGCOU = 1
      ENDIF
      IF ( IDF .EQ. 6 ) THEN
         CALL GETRES(SPVR,CBID,CBID)
         IF ( SPVR .NE. '  ' ) THEN
            SPVR(20:24) = '.SPVR'
            CALL JEEXIN(SPVR,IRET)
            IF (IRET.NE.0) CALL JEDETR(SPVR)
            NBL = MIN(LIGCOU,NT)
            CALL WKVECT(SPVR,'G V K80',NBL,LSPVR)
            DO 1 L= 1, NBL
               ZK80(LSPVR+L-1) = TAMPON(L)
 1          CONTINUE
         ENDIF
      ENDIF
      CALL UTVTAM
      IF ( IDF .EQ. 2 ) THEN
         CALL JXVERI('ERREUR',' ')
         CALL JEFINI('ERREUR')
      ELSE IF ( IDF .EQ. 6 ) THEN
         CALL GCUOPR(2, ICMD)
         CALL JEFINI('NORMAL')
      ENDIF
      LIGCOU = 0
      COLCOU = 0
      IDF    = 0
C
      CALL JEDEMA()
      END
