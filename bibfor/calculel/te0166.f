      SUBROUTINE TE0166 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL FORCE DE PESANTEUR POUR MEPOULI
C                          OPTION : 'CHAR_MECA_PESA_R'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      CHARACTER*8        MATER
      CHARACTER*2        CODRET
      REAL*8             RHO,A,W(9),L1(3),L2(3),L10(3),L20(3)
      REAL*8             NORML1,NORML2,NORL10,NORL20,L0,NORM1P,NORM2P
      REAL*8             POIDS(3)
      INTEGER            I,NEU,NEUM1,KC,IC,IVECTU,IPESA
      INTEGER            IGEOM,IMATE,LSECT,IDEPLA,IDEPLP
C
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
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',R8B,1,'RHO',RHO,
     &            CODRET,'FM')
      CALL JEVECH('PCACABL','L',LSECT)
      A = ZR(LSECT)
C
      CALL JEVECH('PDEPLMR','L',IDEPLA)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
C
      DO 10 I=1,9
        W(I)=ZR(IDEPLA-1+I)+ZR(IDEPLP-1+I)
10    CONTINUE
C
      DO 21 KC=1,3
      L1(KC)  = W(KC  ) + ZR(IGEOM-1+KC) - W(6+KC) - ZR(IGEOM+5+KC)
      L10(KC) =           ZR(IGEOM-1+KC)           - ZR(IGEOM+5+KC)
21    CONTINUE
      DO 22 KC=1,3
      L2(KC)  = W(3+KC) + ZR(IGEOM+2+KC) - W(6+KC) - ZR(IGEOM+5+KC)
      L20(KC) =           ZR(IGEOM+2+KC)           - ZR(IGEOM+5+KC)
22    CONTINUE
      CALL PSCAL (3,L1 ,L1 ,   NORML1)
      CALL PSCAL (3,L2 ,L2 ,   NORML2)
      CALL PSCAL (3,L10,L10,   NORL10)
      CALL PSCAL (3,L20,L20,   NORL20)
      NORML1 = SQRT (NORML1)
      NORML2 = SQRT (NORML2)
      NORL10 = SQRT (NORL10)
      NORL20 = SQRT (NORL20)
      L0 = NORL10 + NORL20
C
      CALL JEVECH('PPESANR','L',IPESA)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      NORM1P = NORML1 * L0 / (NORML1+NORML2)
      NORM2P = NORML2 * L0 / (NORML1+NORML2)
      POIDS(1) = RHO * A * NORM1P * ZR(IPESA) / 2.D0
      POIDS(2) = RHO * A * NORM2P * ZR(IPESA) / 2.D0
      POIDS(3) = POIDS(1) + POIDS(2)
C
C
      DO 32 NEU=1,3
      NEUM1 = NEU - 1
      DO 31 IC=1,3
      ZR(IVECTU + 3*NEUM1 + IC-1) = POIDS(NEU) * ZR(IPESA+IC)
   31 CONTINUE
   32 CONTINUE
C
      END
