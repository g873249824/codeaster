      SUBROUTINE TE0379 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
      CHARACTER*16        OPTION  , NOMTE
C ......................................................................
C    - FONCTION REALISEE: EXTENSION DU CHAM_ELEM ERREUR DES POINTS
C                         DE GAUSS AUX NOEUDS
C                         OPTION : 'ERRE_ELNO_ELGA'
C             (POUR PERMETTRE D'UTILISER POST_RELEVE_T)
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE
C ......................................................................
C
C ---------- DEBUT DECLARATIONS NORMALISEES JEVEUX --------------------
C
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                         ZK24
      CHARACTER*32                                   ZK32
      CHARACTER*80                                             ZK80
      COMMON / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      CHARACTER*32      JEXNUM , JEXNOM , JEXR8 , JEXATR
C
C --------- FIN DECLARATIONS NORMALISEES JEVEUX ----------------------
C
      INTEGER           I, NNO
      INTEGER           ICARAC, IERRG, IERRN
      REAL*8            ERREST, NUEST, SIGCAL
      CHARACTER*24      CARAC
      CHARACTER*8       ELREFE
C
      CALL ELREF1(ELREFE)
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO = ZI(ICARAC)
C
C
      CALL JEVECH('PERREUR','L',IERRG)
      CALL JEVECH('PERRENO','E',IERRN)
C
C
      ERREST = ZR(IERRG)
      NUEST = ZR(IERRG+1)
      SIGCAL = ZR(IERRG+2)
C
C
      DO 10 I=1,NNO
        ZR(IERRN+3*I-3) = ERREST
        ZR(IERRN+3*I-2) = NUEST
        ZR(IERRN+3*I-1) = SIGCAL
   10 CONTINUE
      END
