      SUBROUTINE DEFAPP (MA, GEOMI, ALPHA, DEPLA, BASE, GEOMF )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      REAL*8        ALPHA
      CHARACTER*1   BASE
      CHARACTER*8   DEPLA,K8B,MA
      CHARACTER*19  GEOMI, GEOMF
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C
C     VARIABLES LOCALES:
C     ------------------
      INTEGER            IAVALF,
     &              IAVALI, IBID, ICMP, INO,
     &               NBNO, NCMP,
     &              JNO,NGST,NBNO1,NBNO2,IEM,KNO,JGNAP,JNOAP,
     &              NGAP,JGNST,NNO,JNOST,JCNSK,JCNSD,JCNSC,
     &              JCNSV,JCNSL,NOAP,NOST
      REAL*8        RDEPLA
      CHARACTER*1   BAS2,TSCA
      CHARACTER*8    KARG,NOMGD
      CHARACTER*19  GEOMI2, GEOMF2,CHAMNS
      INTEGER      IARG

C ----------------------------------------------------------------------
      CALL JEMARQ()
      GEOMI2 = GEOMI
      GEOMF2= GEOMF
      BAS2  = BASE(1:1)

C     -- ON RECOPIE BESTIALEMENT LE CHAMP POUR CREER LE NOUVEAU:
      CALL COPISD('CHAMP_GD',BAS2,GEOMI2,GEOMF2)

C RECUPERATION DES GROUPES DE NOEUDS

      CALL GETVEM(MA,'GROUP_NO','DEFORME','GROUP_NO_STRU',
     &            1,IARG,0,K8B,NGST)
      CALL GETVEM(MA,'GROUP_NO','DEFORME','GROUP_NO_APPUI',
     &            1,IARG,0,K8B,NGAP)
      IF (NGST.NE.NGAP) THEN
        CALL U2MESS('F','ALGORITH2_61')
      ENDIF

C TRAITEMENT DU GROUP_NO_STRUC

      IF (NGST.NE.0) THEN
        NGST = -NGST
        NBNO1 = 0
        CALL WKVECT ('&&DEFAPP.GNST','V V K8',NGST,JGNST)
        CALL GETVEM(MA,'GROUP_NO','DEFORME','GROUP_NO_STRU',
     &            1,IARG,NGST,ZK8(JGNST),IBID)
C PREMIERE BOUCLE POUR COMPTER LE NOMBRE DE NOEUDS

        DO 40 IEM= 1, NGST
          KARG = ZK8(JGNST-1+IEM)
          CALL JELIRA(JEXNOM(MA//'.GROUPENO',KARG),'LONUTI',NNO,K8B)
          NBNO1 = NBNO1 + NNO
 40     CONTINUE
C
        CALL WKVECT ('&&DEFAPP.NOST','V V I',NBNO1,JNOST)
C
C DEUXIEME BOUCLE POUR RECUPERER LES NUMEROS DES NOEUDS
        NBNO1 =0
        DO 60 IEM= 1, NGST
          KARG = ZK8(JGNST-1+IEM)
          CALL JELIRA(JEXNOM(MA//'.GROUPENO',KARG),'LONUTI',NNO,K8B)
          CALL JEVEUO(JEXNOM(MA//'.GROUPENO',KARG),'L',KNO)
          DO 50 JNO = 1,NNO
            ZI(JNOST-1+NBNO1+JNO) = ZI(KNO+JNO-1)
 50       CONTINUE
          NBNO1 = NBNO1 +NNO
 60     CONTINUE
      ENDIF

C TRAITEMENT DU GROUP_NO_APPUI

      IF (NGAP.NE.0) THEN
        NGAP = -NGAP
        NBNO2 = 0
        CALL WKVECT ('&&DEFAPP.GNAP','V V K8',NGST,JGNAP)
        CALL GETVEM(MA,'GROUP_NO','DEFORME','GROUP_NO_APPUI',
     &            1,IARG,NGAP,ZK8(JGNAP),IBID)

C PREMIERE BOUCLE POUR COMPTER LE NOMBRE DE NOEUDS

        DO 70 IEM= 1, NGAP
          KARG = ZK8(JGNAP-1+IEM)
          CALL JELIRA(JEXNOM(MA//'.GROUPENO',KARG),'LONUTI',NNO,K8B)
          NBNO2 = NBNO2 + NNO
 70     CONTINUE
C
        CALL WKVECT ('&&DEFAPP.NOAP','V V I',NBNO2,JNOAP)
C
C DEUXIEME BOUCLE POUR RECUPERER LES NUMEROS DES NOEUDS
        NBNO2 = 0
        DO 80 IEM= 1, NGAP
          KARG = ZK8(JGNAP-1+IEM)
          CALL JELIRA(JEXNOM(MA//'.GROUPENO',KARG),'LONUTI',NNO,K8B)
          CALL JEVEUO(JEXNOM(MA//'.GROUPENO',KARG),'L',KNO)
          DO 90 JNO = 1,NNO
            ZI(JNOAP-1+NBNO2+JNO)= ZI(KNO+JNO-1)
 90       CONTINUE
          NBNO2 = NBNO2 +NNO
 80     CONTINUE
      ENDIF
      IF (NBNO1 .NE. NBNO2 ) THEN
        CALL U2MESS('F','ALGORITH2_62')
      ENDIF
C
      NBNO = NBNO1
      CALL JEVEUO (GEOMI2//'.VALE','L',IAVALI)
      CALL JEVEUO (GEOMF2//'.VALE','E',IAVALF)
C
      CHAMNS = '&&DEFAPP.CHAMNO'
      CALL CNOCNS ( DEPLA, 'V', CHAMNS )

      CALL JEVEUO ( CHAMNS//'.CNSK', 'L', JCNSK )
      CALL JEVEUO ( CHAMNS//'.CNSD', 'L', JCNSD )
      CALL JEVEUO ( CHAMNS//'.CNSC', 'L', JCNSC )
      CALL JEVEUO ( CHAMNS//'.CNSV', 'L', JCNSV )
      CALL JEVEUO ( CHAMNS//'.CNSL', 'L', JCNSL )
C
      NCMP = ZI(JCNSD-1+2)
      NOMGD = ZK8(JCNSK-1+2)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      IF ( TSCA .NE. 'R' ) THEN
         CALL U2MESS('F','ALGORITH2_63')
      ENDIF
      DO 200 INO = 1, NBNO
         NOAP =  ZI(JNOAP-1+INO)
         NOST = ZI(JNOST -1 +INO)
         DO 100 ICMP = 1, NCMP
           IF (ZL(JCNSL-1+ (NOAP-1)*NCMP+ICMP)) THEN
             RDEPLA = ZR(JCNSV-1+(NOST-1)*NCMP+ICMP)
             ZR(IAVALF-1+3*(NOAP-1)+ICMP)=
     &         ZR(IAVALI-1+3*(NOAP-1)+ICMP)+ ALPHA * RDEPLA
           ENDIF
 100     CONTINUE
 200   CONTINUE
       CALL CNSCNO ( CHAMNS,' ','NON', 'V',DEPLA,'F',IBID)

C -- MENAGE
      CALL JEDETR('&&DEFAPP.GNST')
      CALL JEDETR('&&DEFAPP.NOST')
      CALL JEDETR('&&DEFAPP.GNAP')
      CALL JEDETR('&&DEFAPP.NOAP')
C
C
      CALL JEDEMA()
      END
