      SUBROUTINE VTCREB(CHAMPZ,NUMEDZ,BASEZ,TYPCZ,NEQ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 05/03/2002   AUTEUR GJBHHEL E.LORENTZ 
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
      CHARACTER*24 CHAMP,NUMEDD,BASE,TYPC
      CHARACTER*(*) CHAMPZ,NUMEDZ,BASEZ,TYPCZ
      INTEGER NEQ
C-----------------------------------------------------------------------
C     CREATION D'UNE STRUCTURE CHAM_NO "CHAMP"
C
C     IN  CHAMPZ : K19 : NOM DU CHAM_NO A CREER
C     IN  NUMEDZ : K24 : PROF_CHNO DU CHAM_NO
C     IN  BASEZ  : CH1 : NOM DE LA BASE SUR LAQUELLE LE CHAM_NO DOIT
C                        ETRE CREE
C     IN  TYPCZ  :     : TYPE DES VALEURS DU CHAM_NO A CREER
C                  'R'    ==> COEFFICIENTS REELS
C                  'C'    ==> COEFFICIENTS COMPLEXES
C     REMARQUE:  AUCUN CONTROLE SUR LE "TYPC" QUE L'ON PASSE TEL QUEL
C                A JEVEUX_MON_NEVEU
C
C     PRECAUTIONS D'EMPLOI :
C       1) LE CHAM_NO "CHAMP" NE DOIT PAS EXISTER
C       2) LES COEFFICIENTS DU CHAM_NO "CHAMP" NE SONT PAS AFFECTES
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
      INTEGER NBVAL,IVAL,LCHAMP,IBID
      CHARACTER*1 CLASSE,TYPE
      CHARACTER*8 K8BID
      CHARACTER*16 REPK
      CHARACTER*24 VALE,REFE,DESC
C
      DATA VALE/'                   .VALE'/
      DATA REFE/'                   .REFE'/
      DATA DESC/'                   .DESC'/
C
      CALL JEMARQ()
      CHAMP  = CHAMPZ
      NUMEDD = NUMEDZ
      BASE   = BASEZ
      TYPC   = TYPCZ
      CLASSE = BASE(1:1)
C
C ------------------------------- REFE --------------------------------
C --- AFFECTATION DES INFORMATIONS DE REFERENCE A CHAMP
C
      REFE(1:19) = CHAMP
      CALL WKVECT(REFE,CLASSE//' V K24',2,JCHAMP)
      CALL JEVEUO(NUMEDD(1:14)//'.NUME.REFN','L',JREFE)
      ZK24(JCHAMP) = ZK24(JREFE)
      ZK24(JCHAMP+1) = NUMEDD(1:14)//'.NUME'
C
C ------------------------------- DESC --------------------------------
C --- AFFECTATION DES INFORMATIONS DE REFERENCE A CHAMP
C
      DESC(1:19) = CHAMP
      CALL WKVECT(DESC,CLASSE//' V I',2,JCHAMP)
      CALL JEECRA(DESC,'DOCU',IBID,'CHNO')
      CALL DISMOI('F','NUM_GD_SI',NUMEDD,'NUME_DDL',ZI(JCHAMP),
     &            K8BID,IERD)
      ZI(JCHAMP+1) = 1
C
C ------------------------------- VALE --------------------------------
C --- CREATION DE L'OBJET SIMPLE DES VALEURS
C --- TYPE DES VALEURS, LONGUEUR D'UN VECTEUR
C
      CALL JEVEUO(NUMEDD(1:14)//'.NUME.NEQU','L',JNEQ)
      NEQ = ZI(JNEQ)
C
      VALE(1:19) = CHAMP
      TYPE = TYPC
      CALL JECREO(VALE,CLASSE//' V '//TYPE)
      CALL JEECRA(VALE,'LONMAX',NEQ,K8BID)
      CALL JEVEUO(VALE,'E',LCHP)
C
C --- CHANGER LA GRANDEUR
C
      CALL SDCHGD(CHAMP,TYPE)
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
