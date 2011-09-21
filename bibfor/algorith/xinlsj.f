      SUBROUTINE XINLSJ(NOMA,NDIM,FISS,NFISS,CNSLJ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MASSIN P.MASSIN
      IMPLICIT NONE
      CHARACTER*8   NOMA,FISS
      INTEGER      NDIM,NFISS
      CHARACTER*19  CNSLJ
C
C ----------------------------------------------------------------------
C
C CALCUL DU CHAMP LOCAL LEVEL-SET JONCTIONS
C
C ELLES SERVENT A DELIMITER LA ZONE D'ENRICHISSEMENT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      REAL*8      POINT(3),DIST,DMIN,R8MAEM,PADIST
      INTEGER     JJONF,JJONC,JJON3,JNCMP,INO,NBNO,IRET,IBID
      INTEGER     NFINI,IFISS,NFIS2,NFIS3,IFIS2,IFIS3,CPT,JCNSVT,NFISD
      INTEGER     JCNSV,JCNSL,JCNSVN,COEFLN(10),JFISS,IADRCO,NUNO
      CHARACTER*8  CH,KBID,NOMFIS(10)
      CHARACTER*19 CNSLN,CNSLT,JONFIS,JONCOE
      INTEGER      IARG

C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

C --- INITIALISATIONS
      NFISS = -NFISS
      CNSLN= '&&XINLSJ.CNSLN'
      CNSLT= '&&XINLSJ.CNSLT'
      CALL WKVECT('&&XINLSJ.FISS'  ,'G V K8' ,NFISS,JFISS)
      CALL GETVID('JONCTION','FISSURE',1,IARG,NFISS,ZK8(JFISS), IBID)
      CALL GETVR8('JONCTION','POINT',1,IARG,3,POINT,IBID )
      CALL WKVECT('&&XINLSJ.LICMP' ,'G V K8' ,NFISS,JNCMP)
C
C --- ACCES AU MAILLAGE
C
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',IADRCO)
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,KBID,IRET)
C
C --- RECHERCHE DU NUM�RO DU NOEUD NUNO LE PLUS PROCHE DU POINT
C
      DMIN = R8MAEM()
      DO 100 INO = 1,NBNO
        DIST = PADIST(NDIM,POINT,ZR(IADRCO+(INO-1)*3+1-1))
        IF (DIST.LT.DMIN) THEN
          NUNO = INO
          DMIN = DIST
        ENDIF
 100  CONTINUE

C --- ON AJOUTE LES FISSURES DECLAR�ES DANS LE MOT CL� JONCTION
      CPT = 0
      DO 50 IFISS=1,NFISS
        DO 110 IFIS2 = IFISS+1,NFISS
          CALL JEEXIN(ZK8(JFISS-1+IFIS2)//'.JONFISS',IRET)
          IF (IRET.NE.0) THEN
            CALL JEVEUO(ZK8(JFISS-1+IFIS2)//'.JONFISS','L',JJON3)
            CALL JELIRA(ZK8(JFISS-1+IFIS2)//'.JONFISS','LONMAX',NFIS3,
     &                                                             KBID)
            DO 120 IFIS3 = 1,NFIS3
C --- SI IFISS EST CONTENU DANS LES FISSURES SUIVANTES : ON SORT
C --- ELLE SERA AJOUT� DANS LA BOUCLE 60
              IF (ZK8(JJON3-1+IFIS3).EQ.ZK8(JFISS-1+IFISS)) GOTO 50
 120        CONTINUE
          ENDIF
 110    CONTINUE
        CPT = CPT +1
        NOMFIS(CPT) = ZK8(JFISS-1+IFISS)
        CALL CNOCNS(NOMFIS(CPT)//'.LNNO','V',CNSLN)
        CALL JEVEUO(CNSLN//'.CNSV','L',JCNSVN)
        CALL ASSERT(ZR(JCNSVN-1+NUNO).NE.0.D0)
        COEFLN(CPT) = NINT(SIGN(1.D0,-1.D0*ZR(JCNSVN-1+NUNO)))
  50  CONTINUE

      NFINI = 1
      NFISS = CPT
      NFISD = NFISS
C --- ON AJOUTE TOUTES LES FISSURES CONNECT�ES PRECEDEMENT
C --- SAUF CELLES QUI CONTIENNENT LA FISSURE FISS EN COURS

  90  CONTINUE
      DO 60 IFISS=NFINI,NFISS
        CALL JEEXIN(NOMFIS(IFISS)//'.JONFISS',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(NOMFIS(IFISS)//'.JONFISS','L',JJONF)
          CALL JEVEUO(NOMFIS(IFISS)//'.JONCOEF','L',JJONC)
          CALL JELIRA(NOMFIS(IFISS)//'.JONFISS','LONMAX',NFIS2,KBID)
C --- BOUCLE SUR LES FISSURES CONNECTES � IFISS
          DO 70 IFIS2 = 1,NFIS2
C --- ON VERIFIE QUE LA FISSURE CONNECTEE NE CONTIENT PAS CELLE EN COURS
            CALL JEEXIN(ZK8(JJONF-1+IFIS2)//'.JONFISS',IRET)
            IF (IRET.NE.0) THEN
              CALL JEVEUO(ZK8(JJONF-1+IFIS2)//'.JONFISS','L',JJON3)
              CALL JELIRA(ZK8(JJONF-1+IFIS2)//'.JONFISS','LONMAX',NFIS3,
     &                    KBID)
              DO 75 IFIS3 = 1,NFIS3
                IF (ZK8(JJON3-1+IFIS3).EQ.FISS) GOTO 70
  75          CONTINUE
            ENDIF
C --- ON VERIFIE QU'ON A PAS DEJA STOCK� LA FISSURE DANS LA LISTE
            DO 80 IFIS3 = 1,CPT
              IF (ZK8(JJONF-1+IFIS2).EQ.NOMFIS(IFIS3)) GOTO 70
  80        CONTINUE
C --- ON AJOUTE LES FISSURES CONNECT�S � LA LISTE
            CPT = CPT+1
            NOMFIS(CPT) = ZK8(JJONF-1+IFIS2)
            COEFLN(CPT) = ZI(JJONC-1+IFIS2)
  70      CONTINUE
        ENDIF
  60  CONTINUE
      NFINI = NFISS+1
      NFISS = CPT
      IF (NFINI.LE.NFISS) GOTO 90
      CALL ASSERT(NFISS.LE.10)

C --- CR�ATION DES SD GLOBALES JONFISS ET JONCOEF

      JONFIS = FISS(1:8)//'.JONFISS'
      JONCOE = FISS(1:8)//'.JONCOEF'
      CALL WKVECT(JONFIS,'G V K8',NFISS,JJONF)
      CALL WKVECT(JONCOE,'G V I',NFISS,JJONC)
      DO 40 IFISS=1,NFISS
        ZK8(JJONF-1+IFISS) = NOMFIS(IFISS)
        ZI(JJONC-1+IFISS)  = COEFLN(IFISS)
  40  CONTINUE

      DO 10 IFISS = 1,2*NFISS
        CALL CODENT(IFISS,'G',CH)
        ZK8(JNCMP-1+IFISS) = 'X'//CH
  10  CONTINUE

C --- CR�ATION DE LA SD CNSLJ : LSJ(IFISS,1) = COEF*LSN(IFISS)
C                               LSJ(IFISS,2) = LST(IFISS)

      CALL CNSCRE(NOMA,'NEUT_R',2*NFISS,ZK8(JNCMP),'V',CNSLJ)
      CALL JEVEUO(CNSLJ//'.CNSV','E',JCNSV)
      CALL JEVEUO(CNSLJ//'.CNSL','E',JCNSL)
      DO 20 IFISS=1,NFISS
        CALL CNOCNS(NOMFIS(IFISS)//'.LNNO','V',CNSLN)
        CALL JEVEUO(CNSLN//'.CNSV','L',JCNSVN)
        CALL CNOCNS(NOMFIS(IFISS)//'.LTNO','V',CNSLT)
        CALL JEVEUO(CNSLT//'.CNSV','L',JCNSVT)
        DO 30 INO = 1,NBNO
          ZL(JCNSL-1+2*NFISS*(INO-1)+2*(IFISS-1)+1) = .TRUE.
          ZR(JCNSV-1+2*NFISS*(INO-1)+2*(IFISS-1)+1) =
     &                                COEFLN(IFISS)*ZR(JCNSVN-1+INO)
          ZL(JCNSL-1+2*NFISS*(INO-1)+2*(IFISS-1)+2) = .TRUE.
          IF (IFISS.LE.NFISD) THEN
            ZR(JCNSV-1+2*NFISS*(INO-1)+2*(IFISS-1)+2) = -1
          ELSE
C --- CRITERE SUR LA LST POUR LES FISS NON DECLAREES PAR L'UTILISATEUR
            ZR(JCNSV-1+2*NFISS*(INO-1)+2*(IFISS-1)+2) = ZR(JCNSVT-1+INO)
          ENDIF
  30    CONTINUE
  20  CONTINUE

      CALL JEDETR('&&XINLSJ.FISS')
      CALL JEDETR('&&XINLSJ.COEF')
      CALL JEDETR('&&XINLSJ.LICMP')
      CALL DETRSD('CHAM_NO_S',CNSLN)
      CALL DETRSD('CHAM_NO_S',CNSLT)

      CALL JEDEMA()
      END
