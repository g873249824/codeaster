      SUBROUTINE VRCIN2(MODELE,CHMAT,CARELE,CHVARS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8 MODELE,CHMAT,CARELE
      CHARACTER*19 CHVARS
C ======================================================================
C   BUT : ALLOUER LE CHAM_ELEM_S RESULTAT (CHVARS)
C         ET CREER UN OBJET CHMAT.CESVI QUI EST UN OBJET DE MEME
C         STRUCTURE QUE CHVARS.CESV
C
C   IN :
C     MODELE (K8)  IN/JXIN : SD MODELE
C     CHMAT  (K8)  IN/JXIN : SD CHAM_MATER
C     CARELE (K8)  IN/JXIN : SD CARA_ELEM (SOUS-POINTS)

C   OUT :
C     + CHVARS (K19) IN/JXOUT: SD CHAM_ELEM_S ELGA (VARI_R) A ALLOUER
C     + CREATION DE CHMAT//'.CESVI' V V I LONG=LONG(CHVARS//.CESL)
C        SI CHVARS.CESL(K)= .TRUE.
C           CHMAT.CESVI(K)= ICHS : RANG DANS CHMAT.LISTE_CH(:) DU CHAMP
C                                  A RECOPIER DANS CHVARS.CESV(K)
C
C ----------------------------------------------------------------------


      INTEGER N1,IRET,IAD,ICHS,NBCHS,ISP,IPT,JLISSD,JCESVI
      INTEGER K,K2,NBMA,NCMP,ICMP,JCESL2,JCESV2,JCESD2
      INTEGER JCESD,JCESL,IMA,NBPT,NBSP,NBCVRC,JCVVAR
      INTEGER JDCLD,JDCLL,JDCLV,JCESK,JCESK2
      CHARACTER*16 TYSD1,TYSD2,NOSD1,NOSD2,NOSY1,NOSY2
      CHARACTER*8 KBID,VARC
      CHARACTER*19  DCELI,CELMOD,CART2,CES2,LIGRMO
      CHARACTER*24 VALK(5)
C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL JEVEUO(CHMAT//'.CVRCVARC','L',JCVVAR)
      CALL JELIRA(CHMAT//'.CVRCVARC','LONMAX',NBCVRC,KBID)
      LIGRMO=MODELE//'.MODELE'

C     -- CALCUL DE JLISSD ET NBCHS :
      CALL JELIRA(CHMAT//'.LISTE_CH','LONMAX',NBCHS,KBID)
      CALL JEVEUO(CHMAT//'.LISTE_SD','L',JLISSD)
      CALL JELIRA(CHMAT//'.LISTE_SD','LONMAX',N1,KBID)
      CALL ASSERT(N1.EQ.NBCHS*7)


C     1. ALLOCATION DE CHVARS ET DE CHMAT.CESVI:
C     ------------------------------------------
      DCELI='&&VRCIN2.DCELI'
      CELMOD='&&VRCIN2.CELMOD'
      CALL CESVAR(CARELE,' ',LIGRMO,DCELI)

C     -- MODIFICATION DE DCELI : TOUTES LES MAILLES ONT
C        NBCVRC COMPOSANTES.
      CALL JEVEUO(DCELI//'.CESD','L',JDCLD)
      CALL JEVEUO(DCELI//'.CESL','L',JDCLL)
      CALL JEVEUO(DCELI//'.CESV','E',JDCLV)
      NBMA = ZI(JDCLD-1+1)

      DO 170,IMA = 1,NBMA
        NBPT = ZI(JDCLD-1+5+4* (IMA-1)+1)
        NBSP = MAX(1,ZI(JDCLD-1+5+4* (IMA-1)+2))
        CALL ASSERT(NBPT.EQ.1)
        CALL ASSERT(NBSP.EQ.1)
        CALL CESEXI('C',JDCLD,JDCLL,IMA,1,1,2,IAD)
        IF (IAD.GT.0) ZI(JDCLV-1+IAD)=NBCVRC
170   CONTINUE

      CALL ALCHML(LIGRMO,'INIT_VARC','PVARCPR','V',CELMOD,IRET,DCELI)
      CALL ASSERT(IRET.EQ.0)
      CALL DETRSD('CHAMP',DCELI)
      CALL CELCES(CELMOD,'V',CHVARS)
      CALL DETRSD('CHAMP',CELMOD)

      CALL JELIRA(CHVARS//'.CESV','LONMAX',N1,KBID)
      CALL WKVECT(CHMAT//'.CESVI','V V I',N1,JCESVI)

      CALL JEVEUO(CHVARS//'.CESK','L',JCESK)
      CALL JEVEUO(CHVARS//'.CESD','L',JCESD)
      CALL JEVEUO(CHVARS//'.CESL','E',JCESL)
      CALL JELIRA(CHVARS//'.CESL','LONMAX',N1,KBID)
      DO 777, K=1,N1
        ZL(JCESL-1+K)=.FALSE.
777   CONTINUE



C     2. REMPLISSAGE DE CHMAT.CESVI :
C     ------------------------------------------

C     -- ON CHERCHE A BOUCLER SUR LES VARC.
C        POUR CELA ON BOUCLE SUR LES CVRC ET ON "SAUTE"
C        LES CVRC SUIVANTES (DE LA MEME VARC)
      VARC=' '
      DO 1, K=1,NBCVRC
        IF (ZK8(JCVVAR-1+K).EQ.VARC) GO TO 1

        VARC=ZK8(JCVVAR-1+K)
        CART2 = CHMAT//'.'//VARC//'.2'
        CES2='&&VRCIN2.CES2'
        CALL  CARCES(CART2,'ELEM',' ','V',CES2,'A',IRET)
        CALL ASSERT(IRET.EQ.0)

        CALL JEVEUO(CES2//'.CESK','L',JCESK2)
        CALL JEVEUO(CES2//'.CESD','L',JCESD2)
        CALL JEVEUO(CES2//'.CESV','L',JCESV2)
        CALL JEVEUO(CES2//'.CESL','L',JCESL2)

        IF (ZK8(JCESK).NE.ZK8(JCESK2)) THEN
          VALK(1)=ZK8(JCESK)
          VALK(2)=ZK8(JCESK2)
          CALL U2MESK('F','CALCULEL2_11',2,VALK)
        ENDIF
        NBMA = ZI(JCESD-1+1)
        CALL ASSERT(NBMA.EQ.ZI(JCESD2-1+1))

C       -- CALCUL DE NCMP (NOMBRE DE CVRC DANS VARC)
        NCMP=0
        DO 69, K2=K,NBCVRC
          IF (ZK8(JCVVAR-1+K2).EQ.VARC) NCMP=NCMP+1
69      CONTINUE

        DO 70,IMA = 1,NBMA
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = MAX(1,ZI(JCESD-1+5+4* (IMA-1)+2))

          CALL CESEXI('C',JCESD2,JCESL2,IMA,1,1,1,IAD)
          IF (IAD.LE.0) GO TO 70

C         -- CALCUL DE ICHS :
          TYSD1=ZK16(JCESV2-1+IAD+1)
          NOSD1=ZK16(JCESV2-1+IAD+2)
          NOSY1=ZK16(JCESV2-1+IAD+3)
          DO 71, ICHS=1,NBCHS
            TYSD2=ZK16(JLISSD-1+7*(ICHS-1)+1)(1:8)
            NOSD2=ZK16(JLISSD-1+7*(ICHS-1)+2)(1:8)
            NOSY2=ZK16(JLISSD-1+7*(ICHS-1)+3)
            IF((TYSD1.EQ.TYSD2).AND.(NOSD1.EQ.NOSD2)
     &        .AND.(NOSY1.EQ.NOSY2)) GO TO 72
71        CONTINUE
          CALL ASSERT(.FALSE.)
72        CONTINUE

          DO 60,IPT = 1,NBPT
            DO 50,ISP = 1,NBSP
              DO 51,ICMP = 1,NCMP
                CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,K-1+ICMP,IAD)
C               LA FORMULE K-1+ICMP PEUT PARAITRE CURIEUSE MAIS
C               EN REALITE, K S'INCREMENTE PAR PAQUETS DE NCMP
C               (VOIR COMMENTAIRE EN DEBUT DE BOUCLE 1)
                IF(IAD.EQ.0) GOTO 51
                CALL ASSERT(IAD.LT.0)
                IAD=-IAD
                ZL(JCESL-1+IAD)=.TRUE.
                ZI(JCESVI-1+IAD)=ICHS
51          CONTINUE
50          CONTINUE
60        CONTINUE
70      CONTINUE
        CALL DETRSD('CHAMP',CES2)
1     CONTINUE


      CALL JEDEMA()
      END
