      SUBROUTINE XSTANO(NOMA,LISNO,NMAFIS,JMAFIS,CNSLT,CNSLN,RAYON,
     &                  CNXINV,STANO)
      IMPLICIT NONE

      REAL*8        RAYON
      INTEGER       NMAFIS,JMAFIS
      CHARACTER*8   NOMA
      CHARACTER*19  CNSLT,CNSLN,CNXINV
      CHARACTER*24  LISNO,STANO
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2010   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C                DETERMINER LE STATUT (ENRICHISSEMENT) DES NOEUDS
C                    1 : ENRICHISSEMENT HEAVISIDE
C                    2 : ENRICHISSEMENT CRACK TIP
C                    3 : ENRICHISSEMENT HEAVISIDE ET CRACK TIP
C
C     ENTREE
C         NOMA   : NOM DE L'OBJET MAILLAGE
C         LISNO  : LISTE DES NOEUDS DE GROUP_MA_ENRI
C         NMAFIS : NOMBRE DE MAILLES DE LA ZONE FISSURE
C         JMAFIS : ADRESSE DES MAILLES DE LA ZONE FISSURE
C         CNSLT  : LEVEL SET TANGENTE
C         CNSLN  : LEVEL SET NORMALE
C         RAYON  : RAYON DE LA ZONE D'ENRICHISSEMENT DES NOEUDS EN FOND
C                  DE FISSURE
C         CNXINV : CONNECTIVITE INVERSE
C         STANO  : VECTEUR STATUT DES NOEUDS INITIALISE � 0
C
C     SORTIE
C         STANO  : VECTEUR STATUT DES NOEUDS
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32    JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER         IN,AR(12,3),IA,I,J,K,NBNOE,NBNOTT(3)
      INTEGER         INO,IMA,NBNOMA,NUNO,NRIEN,NBAR,NA
      INTEGER         NB,NUNOA,NUNOB,ENR,ENR1,ENR2,JDLINO,JMA,JSTANO
      INTEGER         JCONX1,JCONX2,JLTSV,JLNSV,JCOOR,ITYPMA,NDIM
      INTEGER         NBMA,IBID,JLMAF,NMASUP,JMASUP,ISUP,IRET
      REAL*8          MINLSN,MINLST,MAXLSN,MAXLST,LSNA,LSNB,LSTA,LSTB
      REAL*8          LSNC,LSTC,LSN,A(3),B(3),C(3),R8MAEM,R8PREM,LST
      REAL*8          DDOT,AB(3),AC(3)
      CHARACTER*8     TYPMA,K8B
      CHARACTER*19    MAI,LMAFIS
      CHARACTER*32    JEXATR
C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)

      CALL JELIRA(LISNO,'LONMAX',NBNOE,K8B)
      CALL JEVEUO(LISNO,'L',JDLINO)

      CALL JEVEUO(STANO,'E',JSTANO)

      CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
      CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)

      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8B,IRET)

      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8B,IBID)

C     CREATION D'UN VECTEUR TEMPORAIRE LMAFIS POUR SAVOIR RAPIDEMENT
C     SI UNE MAILLE DU MAILLAGE APPARTIENT A MAFIS
      LMAFIS='&&XSTANO.LMAFIS'
      CALL WKVECT(LMAFIS,'V V I',NBMA,JLMAF)
      DO 10 I=1,NMAFIS
        IMA=ZI(JMAFIS-1+I)
        ZI(JLMAF-1+IMA)=1
 10   CONTINUE

C     BOUCLE SUR LES NOEUDS DE GROUP_ENRI
      DO 200 I=1,NBNOE
        MAXLSN=-1*R8MAEM()
        MINLSN=R8MAEM()
        MAXLST=-1*R8MAEM()
        MINLST=R8MAEM()
        INO=ZI(JDLINO-1+I)

        CALL JELIRA(JEXNUM(CNXINV,INO),'LONMAX',NMASUP,K8B)
        CALL JEVEUO(JEXNUM(CNXINV,INO),'L',JMASUP)
C
C       ON VERIFIE SI LE NOEUD N'EST PAS ORPHELIN
        IF(ZI(JMASUP).EQ.0)GOTO 200

        ISUP=0

C       BOUCLE SUR LES MAILLES SUPPORT DE INO
        DO 210 J=1,NMASUP
          IMA = ZI(JMASUP-1+J)

C         SI LA MAILLE N'APPARTIENT PAS A MAFIS, ON PASSE A LA SUIVANTE
          IF (ZI(JLMAF-1+IMA).EQ.0) GOTO 210
          ISUP = 1

C         MAILLE SUPPORT APPARTENANT A MAFIS :
C         ON CALCULE LST QUE SUR LES PTS O� LSN=0
C         ON CALCULE LSN SUR LES NOEUDS
          NRIEN=0
C         BOUCLE SUR LES ARETES DE LA MAILLE RETENUE
          ITYPMA=ZI(JMA-1+IMA)
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
          CALL CONARE(TYPMA,AR,NBAR)
          DO 212 IA=1,NBAR
            NA=AR(IA,1)
            NB=AR(IA,2)
            NUNOA=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NA-1)
            NUNOB=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NB-1)
            LSNA=ZR(JLNSV-1+(NUNOA-1)+1)
            LSNB=ZR(JLNSV-1+(NUNOB-1)+1)
            LSTA=ZR(JLTSV-1+(NUNOA-1)+1)
            LSTB=ZR(JLTSV-1+(NUNOB-1)+1)

            IF (LSNA.EQ.0.D0.AND.LSNB.EQ.0.D0) THEN
C             ON RETIENT LES 2 POINTS A ET B
C             ET ACTUALISATION DE MIN ET MAX POUR LST
              IF (LSTA.LT.MINLST) MINLST=LSTA
              IF (LSTA.GT.MAXLST) MAXLST=LSTA
              IF (LSTB.LT.MINLST) MINLST=LSTB
              IF (LSTB.GT.MAXLST) MAXLST=LSTB
            ELSEIF((LSNA*LSNB).LE.0.D0) THEN
C            CA VEUT DIRE QUE LSN S'ANNULE SUR L'ARETE AU PT C
C            (RETENU) ET ACTUALISATION DE MIN ET MAX POUR LST EN CE PT
              DO 21 K=1,NDIM
                A(K)=ZR(JCOOR-1+3*(NUNOA-1)+K)
                B(K)=ZR(JCOOR-1+3*(NUNOB-1)+K)
                AB(K)=B(K)-A(K)
C               INTERPOLATION DES COORDONN�ES DE C ET DE LST EN C
                C(K)=A(K)-LSNA/(LSNB-LSNA)*AB(K)
                AC(K)=C(K)-A(K)
 21           CONTINUE
              CALL ASSERT(DDOT(NDIM,AB,1,AB,1).GT.R8PREM())
              LSTC = LSTA + (LSTB-LSTA) * DDOT(NDIM,AB,1,AC,1)
     &                                  / DDOT(NDIM,AB,1,AB,1)
              IF (LSTC.LT.MINLST) MINLST=LSTC
              IF (LSTC.GT.MAXLST) MAXLST=LSTC
            ELSE
C             AUCUN POINT DE L'ARETE N'A LSN = 0,ALORS ON RETIENT RIEN
              NRIEN=NRIEN+1
            ENDIF
C           AUCUNE ARETE SUR LAQUELLE LSN S'ANNULE
            CALL ASSERT(NRIEN.NE.NBAR)
 212      CONTINUE

          CALL PANBNO(ITYPMA,NBNOTT)
C         BOUCLE SUR LES NOEUDS SOMMET DE LA MAILLE COURANTE
          DO 213 IN=1,NBNOTT(1)
            NUNO=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+IN-1)
            LSN=ZR(JLNSV-1+(NUNO-1)+1)
            IF (LSN.LT.MINLSN) MINLSN=LSN
            IF (LSN.GT.MAXLSN) MAXLSN=LSN
 213      CONTINUE

 210    CONTINUE

        ENR=0
        ENR1=0
        ENR2=0

C       TEST S'IL Y A EU UNE MAILLE SUPPORT TROUV�E DANS MAFIS
        IF (ISUP.GT.0) THEN
          IF ((MINLSN*MAXLSN.LT.0.D0).AND.(MAXLST.LE.R8PREM())) ENR1=1
          IF ((MINLSN*MAXLSN.LE.R8PREM()).AND.
     &        (MINLST*MAXLST.LE.R8PREM()))                      ENR2=2
        ENDIF

C       SI ON DEFINIT UN RAYON POUR LA ZONE D'ENRICHISSEMENT SINGULIER
        IF (RAYON.GT.0.D0) THEN
          LSN=ZR(JLNSV-1+(INO-1)+1)
          LST=ZR(JLTSV-1+(INO-1)+1)
          IF (SQRT(LSN**2+LST**2).LE.RAYON) ENR2=2
        ENDIF

C       ATTENTION, LE TRAITEMENT EVENTUEL DE NB_COUCHES N'EST PAS FAIT
C       ICI CAR ON NE CONNAIT PAS LA TAILLE DES MAILLES DU FOND DE FISS
C       CE TRAITEMENT SERA EFFECTUE APRES DANS XENRCH, DONC STANO SERA
C       PEUT ETRE MODIFIE

        ENR=ENR1+ENR2

C       ENREGISTREMENT DU STATUT DU NOEUD
        ZI(JSTANO-1+(INO-1)+1)=ENR

 200  CONTINUE

      CALL JEDETR(LMAFIS)

      CALL JEDEMA()
      END
