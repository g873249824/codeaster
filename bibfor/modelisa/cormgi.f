      SUBROUTINE CORMGI(BASEZ, LIGREZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 25/03/2002   AUTEUR CIBHHGB G.BERTRAND 
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
C
      CHARACTER*(*)  BASEZ, LIGREZ
      CHARACTER*1    BASE
      CHARACTER*19   LIGREL
C
C**********************************************************************
C
C   OPERATION REALISEE
C   ------------------
C
C     CREATION DE L' ARTICLE REPE DANS LA SD DE LIGREL
C
C     LIGREL.REPE : OJB V I LONG(2*NB_MAILLE_TOTALE)
C
C        V(2*(I-1)+1) --> NUMERO DU GREL CONTENANT LA MAILLE NUMERO I
C
C        V(2*(I-1)+2) --> NUMERO LOCALE DE CETTE MAILLE DANS LE GREL
C
C**********************************************************************
C
      CHARACTER*24 NREPE,NLIEL
      CHARACTER*8 NMAILA
      INTEGER I,J,PT,LREPE,NBMAIL,NBGREL
      INTEGER AREPE,ANMAIL,AGREL,NBMGRE
C
C----------DECLARATION DES COMMUNS NORMALISES JEVEUX---------------
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
      CHARACTER*32 JEXNUM
      CHARACTER*1 K1BID
C
      CALL JEMARQ()
      BASE   = BASEZ
      LIGREL = LIGREZ
C
      NBMAIL = 0
      ANMAIL = 0
      NBGREL = 0
      NBMGRE = 0
      LREPE = 0
      AREPE = 0
      AGREL = 0
      PT = 0
      I = 0
      J = 0
C
      NREPE = LIGREL//'.REPE'
      NLIEL = LIGREL//'.LIEL'
C
      CALL JEVEUO(LIGREL//'.NOMA','L',ANMAIL)
C
      NMAILA = ZK8(ANMAIL)
C
      CALL JEEXIN(NMAILA//'.CONNEX',IRET)
      IF (IRET.EQ.0) GO TO 9999
      CALL JELIRA(NMAILA//'.CONNEX','NMAXOC',NBMAIL,K1BID)
      CALL JELIRA(LIGREL//'.LIEL','NUTIOC',NBGREL,K1BID)
C
      LREPE = 2*NBMAIL
C
      CALL JEEXIN(NREPE,IRET)
      IF (IRET.NE.0) GOTO 9999
      CALL JECREO(NREPE,BASE//' V I')
      CALL JEECRA(NREPE,'LONMAX',LREPE,' ')
      CALL JEVEUO(NREPE,'E',AREPE)
C
      DO 10,I = 1,LREPE,1
C
        ZI(AREPE+I-1) = 0
C
   10 CONTINUE
C
      DO 100,I = 1,NBGREL,1
C
        CALL JELIRA(JEXNUM(NLIEL,I),'LONMAX',NBMGRE,K1BID)
        CALL JEVEUO(JEXNUM(NLIEL,I),'L',AGREL)
C
        DO 110,J = 1,NBMGRE - 1,1
C
          IF (ZI(AGREL+J-1).GT.0) THEN
C
            PT = 2* (ZI(AGREL+J-1)-1) + 1
C
            ZI(AREPE+PT-1) = I
            ZI(AREPE+PT) = J
C
          END IF
C
  110   CONTINUE
C
  100 CONTINUE
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
