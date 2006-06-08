      SUBROUTINE CRAGLC (LONG, LIGRCH)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/09/96   AUTEUR CIBHHLV L.VIVAN 
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
      CHARACTER*19 LIGRCH
C ---------------------------------------------------------------------
C     CREATION OU EXTENSION DU LIGREL DE CHARGE LIGRCH
C     D'UN NOMBRE DE TERMES EGAL A LONG
C
C     LONG DOIT ETRE > 0
C
C----------------------------------------------------------------------
C  LONG          - IN   - I    - : NOMBRE DE GRELS A RAJOUTER A LIGRCH-
C----------------------------------------------------------------------
C  LIGRCH        - IN   - K19  - : NOM DU LIGREL DE CHARGE
C                - JXVAR-      -
C----------------------------------------------------------------------
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
      COMMON  / KVARJE /ZK8(1),ZK16(1),ZK24(1),ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C --------- VARIABLES LOCALES ------------------------------------------
      CHARACTER*8   NOMA, MOD
      CHARACTER*8   K8BID
      CHARACTER*1 K1BID
C --------- FIN  DECLARATIONS  VARIABLES LOCALES ----------------------
C
      CALL JEMARQ()
      IF (LONG.LE.0) THEN
               CALL UTMESS('F','CRAGLC','ON ESSAIE DE CREER OU '//
     +                   'D''AGRANDIR LE LIGREL DE CHARGE AVEC '//
     +                   'UN NOMBRE DE TERMES NEGATIF OU NUL')
      ENDIF
C
C --- ON CREE LIGREL DE CHARGE S'IL N'EXISTE PAS ---
C
      CALL JEEXIN(LIGRCH//'.LIEL', IRET)
      IF (IRET .EQ. 0) THEN
         CALL JECREC (LIGRCH//'.LIEL','G V I','NU','CONTIG',
     &                'VARIABLE',LONG)
         LONLIG = 2*LONG
         CALL JEECRA (LIGRCH//'.LIEL', 'LONT', LONLIG, ' ')
C
         CALL JECREC (LIGRCH//'.NEMA', 'G V I', 'NU', 'CONTIG',
     +                                              'VARIABLE', LONG)
         LONEMA = 4*LONG
         CALL JEECRA (LIGRCH//'.NEMA', 'LONT', LONEMA, ' ')
C
         CALL JECREO (LIGRCH//'.NOMA', 'G E K8')
         CALL JEVEUO (LIGRCH//'.NOMA', 'E', JNOMA)
C
         CALL WKVECT(LIGRCH//'.LGNS','G V I',2*LONEMA,IDLGNS)
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
C
         CALL DISMOI('F','NOM_MODELE',LIGRCH(1:8),'CHARGE',IBID,MOD,IER)
C
C --- MAILLAGE ASSOCIE AU MODELE ---
C
         CALL JEVEUO(MOD(1:8)//'.MODELE    '//'.NOMA','L',INOMA)
         NOMA = ZK8(INOMA)
         ZK8(JNOMA) = NOMA
C
         CALL JECREO (LIGRCH//'.NBNO', 'G E I')
         CALL JEVEUO (LIGRCH//'.NBNO', 'E',IDNBNO)
         ZI(IDNBNO) = 0
      ENDIF
C
C --- NOMBRE MAX D'ELEMENTS DE LA COLLECTION LIGRCH ---
C
      CALL JELIRA(LIGRCH//'.NEMA','NMAXOC',NBELMA,K1BID)
C
C --- NOMBRE DE MAILLES TARDIVES DU LIGREL DE CHARGE ---
C
      CALL DISMOI('F','NB_MA_SUP',LIGRCH,'LIGREL',NBMATA,K8BID,IER)
C
C --- NOMBRE D'ELEMENTS DEJA AFFECTES DE LA COLLECTION LIGRCH ---
C
      CALL JELIRA(LIGRCH//'.NEMA','NUTIOC',NBELUT,K1BID)
C
C --- NOMBRE D'ELEMENTS DISPONIBLES DE LA COLLECTION LIGRCH ---
C
      NBELDI = NBELMA - NBELUT
C
C --- LONGUEUR TOTALE DE LA COLLECTION LIGRCH ---
C
      CALL JELIRA(LIGRCH//'.NEMA','LONT',LONT,K1BID)
C
C --- NOUVEAU NOMBRE D'OBJETS DE LA COLLECTION LIGRCH ---
C
      LONGUT = NBELUT + LONG
C
C --- MAJORANT DE LA NOUVELLE LONGUEUR DE LA COLLECTION LIGRCH.NEMA ---
C
      CALL DISMOI('F','NB_NO_MAX','&','CATALOGUE',NBNOMX,K8BID,IER)
      LONGMA = (NBNOMX+1)*LONGUT
C
C --- VERIFICATION DE L'ADEQUATION DE LA TAILLE DU LIGREL DE ---
C --- CHARGE A SON AFFECTATION PAR LES MAILLES TARDIVES DUES ---
C --- AUX RELATIONS LINEAIRES                                ---
C
      IF (LONG.GT.NBELDI.OR.LONGMA.GT.LONT) THEN
C
C ---       LA TAILLE DU LIGREL DE CHARGE EST INSUFFISANTE  ---
C ---       ON LA REDIMENSIONNE DE MANIERE ADEQUATE         ---
          CALL AGLIGR(LONGUT, LIGRCH)
      ENDIF
C
      CALL JEDEMA()
      END
