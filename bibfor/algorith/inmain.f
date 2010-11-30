      SUBROUTINE INMAIN(NOMMAT,NEQ,NOZERO)
      
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/06/2010   AUTEUR CORUS M.CORUS 
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
C-----------------------------------------------------------------------
C    M. CORUS     DATE 11/03/10
C-----------------------------------------------------------------------
C  BUT:      < INITIALISER LES MATRICES D'INTERFACE >
CC
C-----------------------------------------------------------------------
C  NOMMAT    /I/ : NOM DE LA MATRICE
C  NEQ       /I/ : NOMBRE D'EQUATIONS
C  NOZERO   /O/ : NOMBRE DE TERMES NONS NULS
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      CHARACTER*32 JEXNUM, JEXNOM

C-- VARIABLES EN ENTREES / SORTIE
      INTEGER       NEQ,NOZERO
      CHARACTER*19  NOMMAT

C-- VARIABLES DE LA ROUTINE      
      INTEGER      IBID,JREFA,I1,J1,IRET

C-----------C
C--       --C      
C-- DEBUT --C      
C--       --C
C-----------C

      CALL JEMARQ()

C-- CREATION DU .REFA
      CALL WKVECT(NOMMAT//'.REFA','V V K24',11,JREFA)
      ZK24(JREFA-1+11)='MPI_COMPLET'
      ZK24(JREFA-1+1)=' '
      ZK24(JREFA-1+2)='&&NUME91'
      ZK24(JREFA-1+8) = 'ASSE'
      ZK24(JREFA-1+9) = 'MS'
      ZK24(JREFA-1+10) = 'GENE'
      ZK24(JREFA-1+7) = '&&NUME91      .SOLV'

      
C-- CREATION DU .LIME
      CALL WKVECT(NOMMAT//'.LIME','V V K24',1,IBID)
      ZK24(IBID)='&&MODL91'

C-- CREATION DU .CONL
      CALL WKVECT(NOMMAT//'.CONL','V V R',NEQ,J1)
      DO 10 I1=1,NEQ
        ZR(J1+I1-1)=1.D0
  10  CONTINUE

C-- .VALM NE DOIT PAS EXISTER :
      CALL JEEXIN(NOMMAT//'.VALM',IRET) 
      CALL ASSERT(IRET.EQ.0)

C-- ALLOCATION DES MATRICES D'INTERFACE    
      CALL JECREC(NOMMAT//'.VALM','V V R','NU','DISPERSE',
     &            'CONSTANT',1)
     
      CALL JECROC(JEXNUM(NOMMAT//'.VALM',1))

      CALL JEECRA(JEXNUM(NOMMAT//'.VALM',1),'LONMAX',
     &            NOZERO,' ')

C---------C
C--     --C
C-- FIN --C
C--     --C
C---------C
      CALL JEDEMA()
      END
