      SUBROUTINE XMISZL(VECINC,DEFICO,NOMA  )
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      CHARACTER*24  VECINC,DEFICO
      CHARACTER*8   NOMA
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM ( UTILITAIRE)
C
C MISE A ZERO DES LAGRANGIENS CONTACT/FROTTEMENT DANS VECTEUR INCONNUES
C      
C ----------------------------------------------------------------------
C
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C I/O VECINC : VECTEUR DES INCONNUES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXATR
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
      INTEGER      NTMA,IMA,JCONX1,JCONX2
      INTEGER      NUMNO,INO,POSMA,NNO
      INTEGER      IBID,NBNO,IER,JTAB,ZMESX
      INTEGER      CFMMVD
      LOGICAL      LCUMUL(4)
      REAL*8       LCOEFR(4)
      CHARACTER*19 PRNO,LICHS(4)
      CHARACTER*19 CNS1,CNS1C
      CHARACTER*19 CNS1B,CNS1D,CNS1E
      INTEGER      JCNS1B,JCNS1D,JCNS1E      
      CHARACTER*24 MAESCL
      INTEGER      JMAESC
      COMPLEX*16   CBID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      MAESCL = DEFICO(1:16)// '.MAESCL'
      CALL JEVEUO(MAESCL,'L',JMAESC)
      ZMESX  = CFMMVD('ZMESX')
C
C --- INITIALISATIONS
C
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      NNO    = 8
      NTMA   = ZI(JMAESC)
      ZMESX  = CFMMVD('ZMESX')
      NBNO   = 0
C
C --- TABLEAU TEMPORAIRE POUR STOCKER NUMERO NOEUDS ESCLAVES
C
      CALL WKVECT('&&XMISZL.NNO','V V I',8*NTMA,JTAB)
C
      DO 10 IMA = 1,NTMA
        POSMA  = ZI(JMAESC+ZMESX*(IMA-1)+1)
        DO 20 INO = 1,NNO
          NBNO   = NBNO+1
          NUMNO  = ZI(JCONX1-1+ZI(JCONX2+POSMA-1)+INO-1)
          ZI(JTAB+NBNO-1) = NUMNO
 20     CONTINUE
 10   CONTINUE
C
C -- EXTRACTION CHAM_NO_S VECTEUR DES INCONNUES
C
      CNS1    = '&&XMISZL.CNS1'
      CNS1B   = '&&XMISZL.CNS1B'
      CNS1C   = '&&XMISZL.CNS1C'
      CNS1D   = '&&XMISZL.CNS1D'
      CNS1E   = '&&XMISZL.CNS1E'
      CALL CNOCNS(VECINC,'V',CNS1)
      CALL DISMOI('F','PROF_CHNO',VECINC,'CHAM_NO',IBID,PRNO,IER)
C
C -- REDUCTION CHAM_NO_S SUR LAGS_C/LAG_F1/LAG_F2 
C
      CALL CNSRED(CNS1,NBNO,ZI(JTAB),1,'LAGS_C' ,'V',CNS1B)
      CALL CNSRED(CNS1,NBNO,ZI(JTAB),1,'LAGS_F1','V',CNS1D)
      CALL CNSRED(CNS1,NBNO,ZI(JTAB),1,'LAGS_F2','V',CNS1E)
      CALL JEVEUO(CNS1B//'.CNSV','E',JCNS1B)
      CALL JEVEUO(CNS1D//'.CNSV','E',JCNS1D)
      CALL JEVEUO(CNS1E//'.CNSV','E',JCNS1E)
C
C --- MISE A ZERO LAGRANGIENS
C
      DO 11 INO = 1,NBNO
        ZR(JCNS1B-1+ZI(JTAB+INO-1))=0.D0
        ZR(JCNS1D-1+ZI(JTAB+INO-1))=0.D0
        ZR(JCNS1E-1+ZI(JTAB+INO-1))=0.D0
 11   CONTINUE
C      
C --- FUSION CHAM_NO_S POUR CREATION CHAM_NO_S CNS1C 
C
      LICHS(1)  = CNS1
      LICHS(2)  = CNS1B
      LICHS(3)  = CNS1D
      LICHS(4)  = CNS1E
      LCOEFR(1) = 1.D0
      LCOEFR(2) = 1.D0
      LCOEFR(3) = 1.D0
      LCOEFR(4) = 1.D0
      LCUMUL(1) = .FALSE.
      LCUMUL(2) = .FALSE.
      LCUMUL(3) = .FALSE.
      LCUMUL(4) = .FALSE.
      CALL CNSFUS(4,LICHS,LCUMUL,LCOEFR,CBID,.FALSE.,'V',CNS1C)
C
C --- CONSTRUCTION DU CHAM_NO
C 
      CALL CNSCNO(CNS1C,PRNO,'NON','V',VECINC,'F',IBID)
C
C --- MENAGE
C
      CALL DETRSD('CHAM_NO_S',CNS1)
      CALL DETRSD('CHAM_NO_S',CNS1B)
      CALL DETRSD('CHAM_NO_S',CNS1C)
      CALL DETRSD('CHAM_NO_S',CNS1D)
      CALL DETRSD('CHAM_NO_S',CNS1E)
      CALL JEDETR('&&XMISZL.NNO')
C      
      CALL JEDEMA()
      END
