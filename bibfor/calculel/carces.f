      SUBROUTINE CARCES(CARTZ,TYPCES,CESMOZ,BASE,CESZ,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
C RESPONSABLE VABHHTS J.PELLET
C A_UTIL
      IMPLICIT NONE
      CHARACTER*(*) CARTZ,CESZ,BASE,CESMOZ,TYPCES
C ------------------------------------------------------------------
C BUT: TRANSFORMER UNE CARTE EN CHAM_ELEM_S
C ------------------------------------------------------------------
C     ARGUMENTS:
C CARTZ  IN/JXIN  K19 : SD CARTE A TRANSFORMER
C TYPCES IN       K4  : TYPE VOULU POUR LE CHAM_ELEM_S
C                      /'ELEM' /'ELGA' /'ELNO'
C CESMOZ IN/JXIN  K19 :  SD CHAM_ELEM_S "MODELE" POUR CESZ
C       SI TYPCES = 'ELEM' : CESMOZ N'EST PAS UTILISE
C       SI TYPCES  ='ELGA' ON SE SERT DE CESMOZ POUR DETERMINER
C          LE NOMBRE DE POINTS ET DE SOUS-POINTS  DU CHAM_ELEM_S
C       SI TYPCES  ='ELNO' ON SE SERT DE CESMOZ POUR DETERMINER
C          LE NOMBRE DE SOUS-POINTS  DU CHAM_ELEM_S. SI CESMOZ
C          EST ABSENT, NBSP=1

C CESZ   IN/JXOUT K19 : SD CHAM_ELEM_S RESULTAT
C BASE    IN      K1  : BASE DE CREATION POUR CESZ : G/V/L
C IRET   OUT      I   : CODE RETOUR :
C                       0 : R.A.S.
C                       1 : LA CARTE CONCERNAIT AUSSI DES MAILLES
C                           TARDIVES QUI N'ONT PAS ETE TRAITEES.
C-----------------------------------------------------------------------

C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER IMA,IRET,IBID,NEC,NCMPMX,JNCMP,JDESC,JVALE,NGRMX,NCMP
      INTEGER JPTMA,JCESD,JCESC,JCESV,JCESL,NBMA,IENT,DEBGD,DEB1,ICO
      INTEGER CMP,IEQ,IAD,CMP2,JNOCMP,JCRCMP,NBEDIT,IGD,JNBPT,NBPT,IPT
      INTEGER JCEMD,JNBSP,JCONX2,ISP,NBSP
      LOGICAL EXISDG
      CHARACTER*1 KBID
      CHARACTER*8 MA,NOMGD
      CHARACTER*3 TSCA
      CHARACTER*19 CART,CES,CESMOD
C     ------------------------------------------------------------------
      CALL JEMARQ()


      CART = CARTZ
      CES = CESZ
      CESMOD = CESMOZ

      CALL DISMOI('F','NOM_MAILLA',CART,'CARTE',IBID,MA,IBID)
      CALL DISMOI('F','NOM_GD',CART,'CARTE',IBID,NOMGD,IBID)
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,KBID,IBID)
      CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NCMPMX,KBID,IBID)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'L',JNCMP)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)


C     1-CALCUL DES OBJETS  '&&CARCES.NBPT','&CARCES.NBSP'
C     -----------------------------------------------------------------
      CALL WKVECT('&&CARCES.NBPT','V V I',NBMA,JNBPT)
      CALL WKVECT('&&CARCES.NBSP','V V I',NBMA,JNBSP)


      CALL EXISD('CHAM_ELEM_S',CESMOD,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(CESMOD//'.CESD','L',JCEMD)
        DO 10,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = ZI(JCEMD-1+5+4* (IMA-1)+1)
          ZI(JNBSP-1+IMA) = ZI(JCEMD-1+5+4* (IMA-1)+2)
   10   CONTINUE
      ELSE
        DO 20,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = 1
          ZI(JNBSP-1+IMA) = 1
   20   CONTINUE
      END IF


      IF (TYPCES.EQ.'ELEM') THEN
        DO 30,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = 1
          ZI(JNBSP-1+IMA) = 1
   30   CONTINUE
      ELSE IF (TYPCES.EQ.'ELNO') THEN
        DO 40,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = ZI(JCONX2+IMA) - ZI(JCONX2+IMA-1)
   40   CONTINUE
      END IF



C     2- RECUPERATION D'INFORMATIONS DANS CART :
C     ------------------------------------------
      CALL JEVEUO(CART//'.DESC','L',JDESC)
      CALL JEVEUO(CART//'.VALE','L',JVALE)
      NGRMX = ZI(JDESC-1+2)
      NBEDIT = ZI(JDESC-1+3)


C     3- ON ETEND LA CARTE POUR CREER L'OBJET .PTMA :
C     -----------------------------------------------------------
      CALL ETENC2(CART,IRET)
      IF (IRET.EQ.1) CALL U2MESS('A','CALCULEL_38')
      CALL JEVEUO(CART//'.PTMA','L',JPTMA)



C     4- ON CHERCHE LES CMPS PRESENTES DANS LA CARTE :
C         NCMP : NOMBRE DE CMPS PRESENTES DANS LA CARTE
C         '&&CARCES.CORR_CMP': CONTIENT LA CORRESPONDANCE ENTRE LE
C                           NUMERO D'1 CMP DE LA CARTE ET LE
C                           NUMERO D'1 CMP DU CHAM_ELEM_S
C         '&&CARCES.NOM_CMP': CONTIENT LES NOMS DES CMPS DU CHAM_ELEM_S
C     -----------------------------------------------------------------
      CALL WKVECT('&&CARCES.CORR_CMP','V V I',NCMPMX,JCRCMP)
      DO 60 IGD = 1,NBEDIT
        IENT = ZI(JDESC-1+3+2*IGD)
        IF (IENT.EQ.0) GO TO 60

        DEBGD = 3 + 2*NGRMX + (IGD-1)*NEC + 1
        DO 50 CMP = 1,NCMPMX
          IF (.NOT. (EXISDG(ZI(JDESC-1+DEBGD),CMP))) GO TO 50
          ZI(JCRCMP-1+CMP) = 1
   50   CONTINUE
   60 CONTINUE
      ICO = 0
      DO 70 CMP = 1,NCMPMX
        IF (ZI(JCRCMP-1+CMP).EQ.1) THEN
          ICO = ICO + 1
          ZI(JCRCMP-1+CMP) = ICO
        END IF
   70 CONTINUE
      NCMP = ICO

      CALL WKVECT('&&CARCES.NOM_CMP','V V K8',NCMP,JNOCMP)
      DO 80 CMP = 1,NCMPMX
        CMP2 = ZI(JCRCMP-1+CMP)
        IF (CMP2.EQ.0) GO TO 80
        ZK8(JNOCMP-1+CMP2) = ZK8(JNCMP-1+CMP)
   80 CONTINUE


C     5- CREATION DE CES :
C     ---------------------------------------
      CALL CESCRE(BASE,CES,TYPCES,MA,NOMGD,NCMP,ZK8(JNOCMP),ZI(JNBPT),
     &            ZI(JNBSP),-NCMP)

      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESC','L',JCESC)
      CALL JEVEUO(CES//'.CESV','E',JCESV)
      CALL JEVEUO(CES//'.CESL','E',JCESL)



C     6- REMPLISSAGE DES OBJETS .CESL ET .CESV :
C     ------------------------------------------
      DO 120,IMA = 1,NBMA
        IENT = ZI(JPTMA-1+IMA)
        IF (IENT.EQ.0) GO TO 120

        DEB1 = (IENT-1)*NCMPMX + 1
        DEBGD = 3 + 2*NGRMX + (IENT-1)*NEC + 1
        NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
        NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)

        ICO = 0
        DO 110 CMP = 1,NCMPMX
          IF (.NOT. (EXISDG(ZI(JDESC-1+DEBGD),CMP))) GO TO 110
          ICO = ICO + 1
          IEQ = DEB1 - 1 + ICO

          CMP2 = ZI(JCRCMP-1+CMP)
          CALL ASSERT(CMP2.GT.0)
          CALL ASSERT(CMP2.LE.NCMP)

          DO 100,IPT = 1,NBPT
            DO 90,ISP = 1,NBSP
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,CMP2,IAD)
              CALL ASSERT(IAD.LE.0)
              IF (IAD.EQ.0) GO TO 110


C         -- RECOPIE DE LA VALEUR:
              ZL(JCESL-1-IAD) = .TRUE.
              IF (TSCA.EQ.'R') THEN
                ZR(JCESV-1-IAD) = ZR(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'C') THEN
                ZC(JCESV-1-IAD) = ZC(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'I') THEN
                ZI(JCESV-1-IAD) = ZI(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'L') THEN
                ZL(JCESV-1-IAD) = ZL(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K8') THEN
                ZK8(JCESV-1-IAD) = ZK8(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K16') THEN
                ZK16(JCESV-1-IAD) = ZK16(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K24') THEN
                ZK24(JCESV-1-IAD) = ZK24(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K32') THEN
                ZK32(JCESV-1-IAD) = ZK32(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K80') THEN
                ZK80(JCESV-1-IAD) = ZK80(JVALE-1+IEQ)
              ELSE
                CALL ASSERT(.FALSE.)
              END IF
   90       CONTINUE
  100     CONTINUE
  110   CONTINUE

  120 CONTINUE


C     7- RETASSAGE DE CES :
C     ---------------------
      CALL CESTAS(CES)


C     8- MENAGE :
C     -----------
      CALL JEDETR(CART//'.PTMA')
      CALL JEDETR('&&CARCES.CORR_CMP')
      CALL JEDETR('&&CARCES.NOM_CMP')
      CALL JEDETR('&&CARCES.NBPT')
      CALL JEDETR('&&CARCES.NBSP')

      CALL JEDEMA()
      END
