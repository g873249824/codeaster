      SUBROUTINE ARLBO0(MAIL  ,NOMARL,NGRMA ,NORM  ,DIME  ,
     &                  TYPMAI,NOMBOI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 11/08/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*19  NGRMA
      CHARACTER*16  NOMBOI
      CHARACTER*10  NORM
      CHARACTER*8   MAIL,NOMARL
      INTEGER       DIME
      CHARACTER*16  TYPMAI
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CONSTRUCTION DE BOITES ENGLOBANTES POUR UN ENSEMBLE DE MAILLES
C PRE ET POST-TRAITEMENT DES BOITES
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM DU MAILLAGE
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NGRMA  : NOM DU GROUPE DE MAILLES
C IN  NORM   : NORMALES LISSEES COQUES (CF LISNOR)
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  TYPMAI : SD CONTENANT NOM DES TYPES ELEMENTS (&&CATA.NOMTM)
C I/O NOMBOI : NOM DE LA SD BOITE
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32  JEXNUM
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*8   TYPEMA,VALK(2),NOMMAI,K8BID
      INTEGER       NMA,NPAN,NSOM,IMA,LCOQUE
      INTEGER       NBPAN,NBSOM,NUMA
      INTEGER       JTYPMA,JGRMA,JTYPMM
      INTEGER       IFM,NIV
      LOGICAL       ISBOX
      REAL*8        ARLGER,PRECBO
      INTEGER       ARLGEI,NHQUA

      INTEGER      NI,NR,NK
      PARAMETER   ( NI = 3 , NR = 1 , NK = 1 )
      INTEGER      VALI(NI)
      REAL*8       VALR(NR)
      CHARACTER*24 VALKK(NK)

      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='ARLBO0')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C --- INITIALISATIONS
C
      NPAN   = 0
      NSOM   = 0
C
C --- LECTURE DONNEES
C
      CALL JEVEUO(MAIL(1:8)//'.TYPMAIL','L',JTYPMA)
      CALL JEVEUO(TYPMAI,'L',JTYPMM)
      CALL JEVEUO(NGRMA,'L',JGRMA)
      CALL JELIRA(NGRMA,'LONMAX',NMA,K8BID)
C
C --- COMPTE NOMBRE TOTAL DE PANS ET DE SOMMETS
C
      DO 10 IMA = 1, NMA
        NUMA   = ZI(JGRMA + IMA - 1)
        TYPEMA = ZK8(JTYPMM+ZI(JTYPMA-1+NUMA)-1)
        CALL TMACOQ(TYPEMA,DIME  ,LCOQUE)
C
        IF (ISBOX(DIME  ,TYPEMA)) THEN
          NPAN  = NPAN + NBPAN(TYPEMA)
          NSOM  = NSOM + NBSOM(TYPEMA)
        ELSE
          CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',NUMA),NOMMAI)
          VALK(1) = NOMMAI
          VALK(2) = TYPEMA
          CALL U2MESK('F','ARLEQUIN_11',2,VALK)
        ENDIF
 10   CONTINUE
      VALI(1)=NMA
      VALI(2)=NPAN
      VALI(3)=NSOM
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NI,VALI,NR,VALR,NK,VALKK)
C
C --- CREATION SD BOITE
C
      CALL BOITCR(NOMBOI,'V'  ,NMA   ,DIME ,NPAN  ,
     &            NSOM  )
C
C --- CALCUL DES BOITES ET DES PANS
C
      PRECBO = ARLGER(NOMARL,'PRECBO')
      NHQUA  = ARLGEI(NOMARL,'NHQUA ')
      CALL BOITE (MAIL  ,NGRMA ,NORM  ,DIME  ,TYPMAI,
     &            NHQUA ,PRECBO,NOMBOI)
C
      CALL JEDEMA()

      END
