      SUBROUTINE EXNOEL(CHAR  ,NOMA  ,TYPENT,NGRMA ,NMA   ,
     &                  CALCMA,NBMA  ,NBNO  ,NBNOQU,LISTMA,
     &                  LISTNO,LISTQU,IPMA  ,IPNO  ,IPNOQU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8 CHAR
      CHARACTER*8 NOMA
      CHARACTER*8 TYPENT
      INTEGER     NGRMA,NMA
      CHARACTER*8 CALCMA(*)
      INTEGER     NBMA,NBNO,NBNOQU
      INTEGER     LISTMA(NBMA)
      INTEGER     LISTNO(NBNO)
      INTEGER     LISTQU(3*NBNOQU)
      INTEGER     IPMA
      INTEGER     IPNO
      INTEGER     IPNOQU
C     
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C EXTRACTION DES NOEUDS ET DES NOEUDS QUADRATIQUES DE GROUPES DE MAILLE
C OU DE MAILLES
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  TYPENT : MOT-CLE (GROUP_MA ou MAILLE)
C IN  NGRMA  : NOMBRE DE GROUP_MA DANS LE MOT-CLE
C IN  NMA    : NOMBRE DE MAILLES DANS LE MOT-CLE
C IN  CALCMA : VECTEUR DE CHARACTER*8 DE TRAVAIL
C              CONTIENT SOIT LE NOM DES GROUP_MA, SOIT LE NOM DES
C              MAILLES
C -- LES TROIS VALEURS SUIVANTES (NBMA, NBNO,NBNOQU) ONT ETE DETERMINEES
C -- VIA LA ROUTINE NBNOEL
C IN  NBMA   : NOMBRE DE MAILLES DANS LA ZONE COURANTE
C IN  NBNO   : NOMBRE DE NOEUDS DANS LA ZONE COURANTE
C IN  NBNOQU : NOMBRE DE NOEUDS QUADRATIQUES DANS LA ZONE COURANTE
C I/O LISTMA : LISTE DES NUMEROS DES MAILLES DE CONTACT
C I/O LISTNO : LISTE DES NUMEROS DES NOEUDS DE CONTACT
C I/O LISTQU : LISTE DES NUMEROS DES NOEUDS QUADRATIQUES DE CONTACT
C I/O IPMA   : INDICE POUR LA LISTE DES NUMEROS DES MAILLES DE CONTACT
C I/O IPNO   : INDICE POUR LA LISTE DES NUMEROS DES NOEUDS DE CONTACT
C I/O IPNOQU : INDICE POUR LA LISTE DES NUMEROS DES NOEUDS QUADRATIQUES
C              DE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM,JEXNOM
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*1  K1BID
      CHARACTER*8  NOMTM,NOMO
      CHARACTER*19 LIGRMO
      CHARACTER*24 GRMAMA,MAILMA
      INTEGER      IER,INDQUA,IBID
      INTEGER      IGRMA,IMA      
      INTEGER      NBMAIL,N1
      INTEGER      NUTYP,NUMAIL
      INTEGER      JGRO,IATYMA,ITYP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C 
      MAILMA = NOMA(1:8)//'.NOMMAI'
      GRMAMA = NOMA(1:8)//'.GROUPEMA'
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      CALL JEVEUO(NOMA(1:8)//'.TYPMAIL','L',IATYMA)
      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,
     &            NOMO,IER)
      LIGRMO = NOMO(1:8)//'.MODELE'
      IF (NBNOQU.EQ.0) THEN
        INDQUA = 1
      ELSE
        INDQUA = 0
      ENDIF  
C      
C --- REMPLISSAGE DES SD
C
      IF (TYPENT.EQ.'GROUP_MA') THEN
        DO 80 IGRMA = 1,NGRMA
          CALL JEVEUO(JEXNOM(GRMAMA,CALCMA(IGRMA)),'L',JGRO)
          CALL JELIRA(JEXNOM(GRMAMA,CALCMA(IGRMA)),'LONMAX',
     &                NBMAIL,K1BID)
          DO 70 IMA = 1,NBMAIL        
            NUMAIL = ZI(JGRO-1+IMA)
            ITYP   = IATYMA - 1 + NUMAIL
            NUTYP  = ZI(ITYP)
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP),NOMTM)  
            CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMAIL),'LONMAX',N1,
     &                  K1BID)
            CALL EXNOCP(NOMA  ,LIGRMO,NOMTM ,NUMAIL,N1    ,
     &                  INDQUA,LISTMA,LISTNO,LISTQU,IPMA  ,
     &                  IPNO  ,IPNOQU)
   70     CONTINUE
   80   CONTINUE
      ELSE IF (TYPENT.EQ.'MAILLE') THEN
        NBMAIL = NMA
        DO 150 IMA = 1,NBMAIL
          CALL JENONU(JEXNOM(MAILMA,CALCMA(IMA)),NUMAIL)
          ITYP  = IATYMA - 1 + NUMAIL
          NUTYP = ZI(ITYP)          
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP),NOMTM)
          CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMAIL),'LONMAX',N1,
     &                K1BID)
          CALL EXNOCP(NOMA  ,LIGRMO,NOMTM ,NUMAIL,N1    ,
     &                INDQUA,LISTMA,LISTNO,LISTQU,IPMA  ,
     &                IPNO  ,IPNOQU)     
  150   CONTINUE
      END IF

      CALL JEDEMA()
      END
