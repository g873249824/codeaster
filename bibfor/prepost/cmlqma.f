      SUBROUTINE CMLQMA(NBMATO, NBMA  , NBNO  , LIMA  , TYPEMA,
     &                  CONNIZ, CONNOZ, NOFILS)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 07/01/2003   AUTEUR GJBHHEL E.LORENTZ 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE

      INTEGER      NBMATO,NBMA,NBNO,LIMA(NBMA),NOFILS(12,*),TYPEMA(*)
      CHARACTER*(*) CONNIZ, CONNOZ
      CHARACTER*24  CONNEI, CONNEO


C ----------------------------------------------------------------------
C           MISE A JOUR DES MAILLES (CREA_MAILLAGE LINE_QUAD)
C ----------------------------------------------------------------------
C IN        NBMATO  NOMBRE TOTAL DE MAILLES DU MAILLAGE
C IN        NBMA    NOMBRE DE MAILLES DE LA LISTE DES MAILLES A TRAITER
C IN        NBNO    NOMBRE DE NOEUDS DU MAILLAGE INITIAL
C IN        LIMA    LISTE DES MAILLES A TRAITER
C VAR       TYPEMA  LISTE DES TYPES DES MAILLES
C IN        NDINIT  NUMERO INITIAL DES NOEUDS CREES
C IN        CONNEI  CONNECTIONS INITIALES (COLLECTION JEVEUX)
C IN/JXOUT  CONNEO  NOUVELLES CONNECTIONS (COLLECTION JEVEUX)
C IN        NOFILS  LISTE DES NOEUDS CREES PAR MAILLE A TRAITER
C ----------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER M,MA,TYMAIN,TYMAOU,NBNOIN,NBNOOU,N
      INTEGER JMAMO,JPOSMA,JCONXI,JCONXO
      INTEGER REFTYP(26),NBREF(26)
      CHARACTER*8 KBID
      CHARACTER*24 MAMO, POSMAI



      DATA REFTYP /1,4,3,4,5,6,9,8,9,10,11,14,13,14,15,16,17,19,19,21,
     &             21,23,23,25,25,26/
      DATA NBREF /1,3,4,3,6,4,6,6,6,12,7,8,8,8,16,9,18,10,10,15,15,
     &            13,13,20,20,27/
C ----------------------------------------------------------------------



      CALL JEMARQ()
      CONNEI = CONNIZ
      CONNEO = CONNOZ



C - LISTE DES MAILLES MODIFIEES

      MAMO   = '&&CMLQMA.MAMO'
      POSMAI = '&&CMLQMA.POSMAI'
      CALL WKVECT(MAMO  ,'V V L',NBMATO, JMAMO)
      CALL WKVECT(POSMAI,'V V I',NBMATO, JPOSMA)
      DO 5 M = 1, NBMATO
        ZL(JMAMO-1+M) = .FALSE.
 5    CONTINUE

      DO 10 M = 1, NBMA
        MA = LIMA(M)
        TYMAIN = TYPEMA(MA)
        TYMAOU = REFTYP(TYMAIN)
        IF (TYMAIN.NE.TYMAOU) THEN
          ZL(JMAMO -1+MA) = .TRUE.
          ZI(JPOSMA-1+MA) = M
        END IF
 10   CONTINUE


C - CREATION DE LA CONNECTIVITE

      DO 20 MA = 1, NBMATO

C      ANCIENNE CONNECTIVITE
        CALL JELIRA(JEXNUM(CONNEI,MA),'LONMAX',NBNOIN,KBID)
        CALL JEVEUO(JEXNUM(CONNEI,MA),'L',JCONXI)

C      NOUVEAU NOMBRE DE NOEUD POUR LA MAILLE COURANTE
        TYMAIN = TYPEMA(MA)
        IF (ZL(JMAMO-1 + MA)) THEN
          NBNOOU = NBREF(TYMAIN)
        ELSE
          NBNOOU = NBNOIN
        END IF

C      NOUVELLE CONNECTIVITE
        CALL JEECRA(JEXNUM(CONNEO,MA),'LONMAX',NBNOOU,KBID)
        CALL JEVEUO(JEXNUM(CONNEO,MA),'E',JCONXO)

C      RECOPIE DES NOEUDS INCHANGES
        DO 30 N = 1, NBNOIN
          ZI(JCONXO-1+N) = ZI(JCONXI-1+N)
 30     CONTINUE

C      INSERTION DES NOUVEAUX NOEUDS
        IF (ZL(JMAMO-1+MA)) THEN
          DO 40 N = NBNOIN+1, NBNOOU
            ZI(JCONXO-1+N) = NOFILS(N-NBNOIN, ZI(JPOSMA-1+MA)) + NBNO
 40       CONTINUE

C      MODIFICATION DU TYPE
          TYMAOU = REFTYP(TYMAIN)
          TYPEMA(MA) = TYMAOU
        END IF

 20   CONTINUE


      CALL JEDETR(MAMO)
      CALL JEDETR(POSMAI)
      CALL JEDEMA()
      END
