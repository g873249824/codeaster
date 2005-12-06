      INTEGER FUNCTION NBELEM(LIGRLZ,IGREL)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/11/1999   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      CHARACTER*19 LIGREL
      CHARACTER*(*) LIGRLZ
      INTEGER IGREL
C ----------------------------------------------------------------------
C     ENTREES:
C      LIGRLZ : NOM D'1 LIGREL
C       IGREL : NOM D'1 GROUPE ELEMENT DANS LE LIGREL

C     SORTIES:
C      NBELEM : NOMBRE D'ELEMENTS DU GROUPE LIGREL(IGREL)

C     SI IGREL = 0   ---> NBRE TOTAL D'ELEMENTS (LIGREL)

C ----------------------------------------------------------------------
C     FONCTIONS EXTERNES:
C     ------------------
      INTEGER NBGREL
      CHARACTER*32 JEXNUM

C     VARIABLES LOCALES:
C     ------------------
      INTEGER N,I
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID

      LIGREL = LIGRLZ

C DEB-------------------------------------------------------------------

      IF (IGREL.EQ.0) THEN
        NBELEM = 0
        CALL JELIRA(LIGREL//'.LIEL','NUTIOC',NBGREL,K1BID)
        DO 10 I = 1,NBGREL
          CALL JELIRA(JEXNUM(LIGREL//'.LIEL',I),'LONMAX',N,K1BID)
          NBELEM = NBELEM + N - 1
   10   CONTINUE
      ELSE
        CALL JELIRA(JEXNUM(LIGREL//'.LIEL',IGREL),'LONMAX',N,K1BID)
        NBELEM = N - 1
      END IF
   20 CONTINUE
      END
