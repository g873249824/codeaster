      SUBROUTINE AGCART(NGDMXN, CHINZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/04/97   AUTEUR VABHHTS J.PELLET 
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
C     ARGUMENTS:
C     ----------
      INTEGER NGDMXN
      CHARACTER*24 CHIN
      CHARACTER*(*) CHINZ
C --------------------------------------------------------------------
C   AGRANDISSEMENT DE LA CARTE CHIN, NGDMXN ETANT LE NOUVEAU NOMBRE
C   MAXIMUM DE COUPLES (ENTITE,VALEUR) A STOCKER
C --------------------------------------------------------------------
C  NGDMXN       - IN     - I    - : NOUVEAU NOMBRE MAX DE COUPLES
C               -        -      -   (ENTITE,VALEUR) A STOCKER
C --------------------------------------------------------------------
C  CHINZ        - IN     - K*(*)- : NOM DE LA CARTE A REDIMENSIONNER -
C               - JXVAR  -      -   ON REALLOUE ET ON RECOPIE LEURS
C               -        -      -   ANCIENNES VALEURS POUR LES OBJETS-
C               -        -      -   CHIN.DESC
C               -        -      -   CHIN.VALE
C               -        -      -   CHIN.NOMA
C               -        -      -   CHIN.NOLI
C               -        -      -   CHIN.LIMA
C --------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER NBEC
      CHARACTER*8 SCALAI
      CHARACTER*32 JEXNUM,JEXNOM
C
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
C
C ----------------------------------------------------------------------
      CHARACTER*1 BASE
      CHARACTER*24 TRAV, CLIMA
      CHARACTER*1 K1BID
      CALL JEMARQ()
      CHIN = CHINZ
      TRAV = CHIN(1:19)//'.TRAV'
      CLIMA = CHIN(1:19)//'.LIMA'
C
C ---  AGRANDISSEMENT DE DESC:
C
      CALL JEVEUO(CHIN(1:19)//'.DESC','E',IDESC)
      IGD = ZI(IDESC-1+1)
      NEC = NBEC(IGD)
      NGDMXA = ZI(IDESC-1+2)
      CALL JUVECA(CHIN(1:19)//'.DESC',3+NGDMXN* (2+NEC))
      CALL JEVEUO(CHIN(1:19)//'.DESC','E',IDESC)
      J = 3+2*NGDMXN+1
      IND1 = 3+2*NGDMXA+1
      IND2 = 3+NGDMXA* (2+NEC)
      DO 10 I =IND1, IND2
          ZI(IDESC+J-1) = ZI(IDESC+I-1)
          J = J+1
  10  CONTINUE
      ZI(IDESC-1+2) = NGDMXN
      CALL JEECRA(CHIN(1:19)//'.DESC','DOCU',IBID,'CART')
C
C ---  AGRANDISSEMENT DE VALE:
C
      CALL JEVEUO(CHIN(1:19)//'.VALE','E',IVALE)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',IGD),'LONMAX',NCMP,K1BID)
      CALL JUVECA(CHIN(1:19)//'.VALE',NGDMXN*NCMP)
      CALL JEVEUO(CHIN(1:19)//'.VALE','E',IVALE)
C
C ---  AGRANDISSEMENT DE NOLI
C
      CALL JEVEUO(CHIN(1:19)//'.NOLI','E',INOLI)
      CALL JUVECA(CHIN(1:19)//'.NOLI',NGDMXN)
      CALL JEVEUO(CHIN(1:19)//'.NOLI','E',INOLI)
C
C ---  AGRANDISSEMENT DE LIMA
C
      CALL JELIRA(CLIMA,'CLAS',IBID,BASE)
      CALL JEDUPO(CLIMA,'G',TRAV,.FALSE.)
      CALL JEDETR(CHIN(1:19)//'.LIMA')
      CALL COCOPG(TRAV, CLIMA, NGDMXN, 2*NGDMXN, 'G')
      CALL JEDETR(CHIN(1:19)//'.TRAV')
C
      CALL JEDEMA()
      END
