      SUBROUTINE PEECAL(TYCH,RESU,NOMCHA,LIEU,NOMLIE,MODELE,ICHAGD,
     &                  CHPOST,NBCMP,NOMCMP,NOMCP2,NUORD,INST,IOCC)

      IMPLICIT NONE

      INTEGER NBCMP,NUORD,IOCC,ICHAGD
      CHARACTER*8 NOMCMP(NBCMP),NOMCP2(NBCMP),MODELE,NOMLIE,LIEU
      CHARACTER*19 CHPOST,RESU
      CHARACTER*24 NOMCHA
      CHARACTER*4 TYCH
C    -------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C
C     OPERATEUR   POST_ELEM
C     TRAITEMENT DU MOT CLE-FACTEUR "INTEGRALE"
C     ROUTINE D'APPEL : PEEINT
C
C     BUT : REALISER LES CALCULS DE MOYENNE ET LES
C           STOCKER DANS LA TABLE
C
C     IN  RESU   : NOM DE LA TABLE
C     IN  NOMCHA : NOM SYMBOLIQUE DU CHAMP DU POST-TRAITEMENT
C                  OU NOM DU CHAM_GD
C     IN  TYCH   : TYPE DU CHAMP 'ELGA/ELEM/ELNO)
C     IN  LIEU   : LIEU DU POST-TRAITEMENT
C         (LIEU='TOUT'/'GROUP_MA'/'MAILLE')
C     IN  NOMLIE : NOM DU LIEU
C     IN  MODELE : NOM DU MODELE
C     IN  ICHAGD : INDIQUE SI ON CHAM_GD (ICHAGD=0) OU RESULTAT
C     IN  CHPOST  : NOM DU CHAMP DU POST-TRAITEMENT
C     IN  NBCMP   : NOMBRE DE COMPOSANTES
C     IN  NOMCMP  : NOM DES COMPOSANTES
C     IN  NOMCP2  : NOM DES COMPOSANTES A AFFICHER
C                   (DIFFERENT DE NOMCMP DANS CERTAINS CAS) 
C     IN  NUORD   : NUMERO D'ORDRE
C     IN  INST    : INSTANT
C     IN  IOCC    : NUMERO DE L'OCCURENCE DE INTEGRALE
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER IRET,NBMA,NBMAI,I,JCESV,JCESL,JCESD,JPOIV,JPOIL,JPOID
      INTEGER NUCMP,JCESK,JCMPGD,NCMPM,IBID,IAD,JINTR,JINTK,INDMA
      INTEGER JMESMA,IPT,NBSP,NBPT,ICMP,IMA,NBPARA,INDIK8
      INTEGER JPDSM,ICO,IND1,IND2,IFM,NIV
      REAL*8  VOL,VAL,INST,VOLPT
      COMPLEX*16 CBID
      CHARACTER*8  NOMA,K8B,TYPMCL(2),NOMGD,NOMVA
      CHARACTER*4 DEJAIN
      CHARACTER*16 MOTCLE(2)
      CHARACTER*19 LIGREL,CESOUT,CESPOI
      CHARACTER*24 MESMAI,VALK(3)
      LOGICAL EXIST
      INTEGER      IARG

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGREL,IRET)
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET)
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8B,IRET)

C --- TABLEAUX DE TRAVAIL:
C     - TABLEAU DES PARAMETRES INTE_XXXX : ZK16(JINTK)
C     - TABLEAU DES VALEURS DES MOYENNES : ZR(JINTR)
      IF (ICHAGD.NE.0) THEN
        CALL WKVECT('&&PEECAL.INTE_R','V V R',2*NBCMP+2,JINTR)
        CALL WKVECT('&&PEECAL.INTE_K','V V K16',2*NBCMP+5,JINTK)
        ZK16(JINTK)  ='NOM_CHAM'
        ZK16(JINTK+1)='NUME_ORDRE'
        ZK16(JINTK+2)='INST'
        ZK16(JINTK+3)='VOL'
        ZK16(JINTK+4)=LIEU
        ZR(JINTR)=INST
        VALK(1)=NOMCHA
        VALK(2)=NOMLIE
        IND1 = 5
        IND2 = 1
      ELSE
        CALL WKVECT('&&PEECAL.INTE_R','V V R',2*NBCMP,JINTR)
        CALL WKVECT('&&PEECAL.INTE_K','V V K16',2*NBCMP+3,JINTK)
        ZK16(JINTK)  ='CHAM_GD'
        ZK16(JINTK+1)='VOL'
        ZK16(JINTK+2)=LIEU
        VALK(1)=NOMCHA
        VALK(2)=NOMLIE
        IND1 = 3
        IND2 = 0
      ENDIF  

C --- CREATION D'UN TABLEAU D'INDICES POUR REPERER
C     LES MAILLES DU POST TRAITEMENT
      CALL WKVECT('&&PEECAL.IND.MAILLE','V V I',NBMA,INDMA)
      IF(LIEU(1:4).NE.'TOUT')THEN
         MESMAI    = '&&PEECAL_NUM.MAILLE'
         MOTCLE(1) = 'GROUP_MA'
         MOTCLE(2) = 'MAILLE'
         TYPMCL(1) = 'GROUP_MA'
         TYPMCL(2) = 'MAILLE'
         CALL RELIEM(' ',NOMA,'NU_MAILLE','INTEGRALE', IOCC, 2,
     &               MOTCLE, TYPMCL, MESMAI, NBMAI )
         CALL JEVEUO(MESMAI,'L',JMESMA)
         DO 5 I=1,NBMA
           ZI(INDMA+I-1)=0
 5       CONTINUE
         DO 10 I=1,NBMAI
           ZI(INDMA+ZI(JMESMA+I-1)-1)=1
 10      CONTINUE
       ELSE
         DO 15 I=1,NBMA
           ZI(INDMA+I-1)=1
 15      CONTINUE
      ENDIF


C --- POUR LES CHAM_ELEM / ELEM : MOT CLE DEJA_INTEGRE:
      IF (TYCH.EQ.'ELEM') THEN
        CALL GETVTX('INTEGRALE','DEJA_INTEGRE',IOCC,IARG,1,DEJAIN,IRET)
        IF (IRET.EQ.0) CALL U2MESK('F','UTILITAI7_13',1,VALK)
      ENDIF


C --- CALCULS DES CHAMPS SIMPLES:
C      CESOUT: CHAMP ELXX CORRESPONDANT AU CHAMP CHPOST (SIMPLE) PONDERE
C              PAR LE POIDS*JACOBIEN.
C      CESPOI: CHAMP ELXX CORRESPONDANT AU POIDS*JACOBIEN
      CESOUT='&&PEECAL.CESOUT'
      CESPOI='&&PEECAL_POIDS_'//NOMCHA(1:4)
      CALL CHPOND(TYCH,DEJAIN,CHPOST,CESOUT,CESPOI,MODELE)
      CALL JEVEUO(CESOUT//'.CESV','L',JCESV)
      CALL JEVEUO(CESOUT//'.CESL','L',JCESL)
      CALL JEVEUO(CESOUT//'.CESD','L',JCESD)
      CALL JEVEUO(CESOUT//'.CESK','L',JCESK)
      CALL JEVEUO(CESPOI//'.CESV','L',JPOIV)
      CALL JEVEUO(CESPOI//'.CESL','L',JPOIL)
      CALL JEVEUO(CESPOI//'.CESD','L',JPOID)
      IF (TYCH.NE.'ELGA') CALL JEVEUO(CESPOI//'.PDSM','L',JPDSM)


C --- RECUPERATION DE LA LISTE DES CMPS DU CATALOGUE :
C     (POUR LA GRANDEUR VARI_* , IL FAUT CONSTITUER :(V1,V2,...,VN))
      NOMGD = ZK8(JCESK-1+2)
      CALL JELIRA(CESOUT//'.CESC','LONMAX',NCMPM,K8B)
      IF (NOMGD(1:5).NE.'VARI_') THEN
        CALL JEVEUO(CESOUT//'.CESC','L',JCMPGD)
      ELSE
        CALL WKVECT('&&PEECAL.LIST_CMP','V V K8',NCMPM,JCMPGD)
        DO 25 I = 1,NCMPM
          NOMVA = 'V'
          CALL CODENT(I,'G',NOMVA(2:8))
          ZK8(JCMPGD-1+I) = NOMVA
   25   CONTINUE
      END IF

C     - INFOS
      IF (NIV.GT.1) THEN
        WRITE(6,*) '<PEECAL> NOMBRE DE MAILLES A TRAITER : ',NBMAI
        WRITE(6,*) '<PEECAL> NOMBRE DE COMPOSANTES : ',NCMPM
      ENDIF


C --- CALCUL DE L'INTEGRALE ET DE LA MOYENNE(=INTEGRALE/VOLUME):
      DO 30 ICMP = 1 , NBCMP
         NUCMP=INDIK8(ZK8(JCMPGD),NOMCMP(ICMP),1,NCMPM)
         VAL=0.D0
         VOL=0.D0
         ICO=0
         DO 35 IMA=1,NBMA
            IF(ZI(INDMA+IMA-1).NE.1)GOTO 35
            NBPT=ZI(JCESD-1+5+4*(IMA-1)+1)
            NBSP=ZI(JCESD-1+5+4*(IMA-1)+2)
            IF(NBSP.GT.1) CALL U2MESS('F','UTILITAI8_60')
            DO 40 IPT=1,NBPT
               CALL CESEXI('C',JCESD,JCESL,IMA,IPT,1,NUCMP,IAD)
               CALL ASSERT(IAD.GE.0)
               IF (IAD.EQ.0) GOTO 35

               VAL=VAL+ZR(JCESV-1+IAD)

               IF (TYCH.EQ.'ELGA') THEN
                 CALL CESEXI('C',JPOID,JPOIL,IMA,IPT,1,1,IAD)
                 CALL ASSERT(IAD.GT.0)
                 VOLPT=ZR(JPOIV-1+IAD)
               ELSEIF (TYCH.EQ.'ELEM') THEN
                 CALL ASSERT(NBPT.EQ.1)
                 VOLPT=ZR(JPDSM-1+IMA)
               ELSEIF (TYCH.EQ.'ELNO') THEN
                 CALL ASSERT(NBPT.GE.1)
                 VOLPT=ZR(JPDSM-1+IMA)/NBPT
               ENDIF
               ICO=ICO+1
               VOL=VOL+VOLPT
 40         CONTINUE
 35      CONTINUE
         IF (ICO.EQ.0) THEN
           VALK(3)=NOMCMP(ICMP)
           CALL U2MESK('F','UTILITAI7_12',3,VALK)
         ENDIF

         IF(ICMP.EQ.1)ZR(JINTR+ICMP+IND2-1)=VOL
         ZR(JINTR+ICMP+IND2)=VAL
         ZK16(JINTK+IND1+ICMP-1)='INTE_'//NOMCP2(ICMP)
         ZR(JINTR+NBCMP+ICMP+IND2)=VAL/VOL
         ZK16(JINTK+IND1+NBCMP+ICMP-1)='MOYE_'//NOMCP2(ICMP)
 30   CONTINUE


C --- ON AJOUTE LES PARAMETRES MANQUANTS DANS LA TABLE:
      CALL TBEXIP(RESU,LIEU,EXIST,K8B)
      IF(.NOT.EXIST)THEN
         CALL TBAJPA(RESU,1,ZK16(JINTK+IND1-1),'K16')
      ENDIF
      DO 45 ICMP=1,NBCMP*2
          CALL TBEXIP(RESU,ZK16(JINTK+IND1+ICMP-1),EXIST,K8B)
          IF(.NOT.EXIST)THEN
             CALL TBAJPA(RESU,1,ZK16(JINTK+IND1+ICMP-1),'R' )
          ENDIF
 45    CONTINUE

C --- ON REMPLIT LA TABLE
      NBPARA=IND1+NBCMP*2
      CALL TBAJLI(RESU,NBPARA,ZK16(JINTK),NUORD,ZR(JINTR),CBID,VALK,0)
      CALL DETRSD('CHAM_ELEM_S','&&PEECAL.CESOUT')
      CALL JEDETR('&&PEECAL.INTE_R')
      CALL JEDETR('&&PEECAL.INTE_K')
      CALL JEDETR('&&PEECAL.IND.MAILLE')
      CALL JEDETR('&&PEECAL.LIST_CMP')

      CALL JEDEMA()

      END
