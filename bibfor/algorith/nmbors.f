      SUBROUTINE NMBORS(BORST)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT      NONE
      LOGICAL       BORST
C ----------------------------------------------------------------------
C  PRECISE S'IL Y A INTEGRATION DE DE BORST SUR UN MATERIAU
C ----------------------------------------------------------------------
C OUT BORST  : VAUT .TRUE. SI UNE DES RELATIONS DE COMPORTEMENT
C              SE FAIT AVEC DEBORST
C ----------------------------------------------------------------------
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NBOCC,IOCC,N1
      CHARACTER*16 TXCP,TX1D
      INTEGER      GETEXM,EXICP,EXI1D
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      BORST = .FALSE.

      CALL GETFAC('COMP_INCR',NBOCC)

      DO 150 IOCC = 1,NBOCC

        TXCP  = 'ANALYTIQUE      '
        EXICP = GETEXM('COMP_INCR','ALGO_C_PLAN')
        IF (EXICP .EQ. 1) THEN
          CALL GETVTX('COMP_INCR','ALGO_C_PLAN',IOCC,IARG,1,TXCP,N1)
          IF (TXCP.EQ.'DEBORST') THEN 
            BORST = .TRUE.
          ENDIF
        END IF

        TX1D = 'ANALYTIQUE      '
        EXI1D = GETEXM('COMP_INCR','ALGO_1D')
        IF (EXI1D .EQ. 1) THEN
          CALL GETVTX('COMP_INCR','ALGO_1D',IOCC,IARG,1,TX1D,N1)
          IF (TX1D.EQ.'DEBORST') THEN
            BORST = .TRUE.
          ENDIF
        END IF
        
        IF (BORST) THEN
           GOTO 999
        ENDIF


  150 CONTINUE

  999 CONTINUE

      END
