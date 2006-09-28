      SUBROUTINE CNSCES(CNSZ,TYPCES,CESMOZ,MNOGAZ,BASE,CESZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      CHARACTER*(*) CNSZ,CESZ,BASE,CESMOZ,TYPCES,MNOGAZ
C ------------------------------------------------------------------
C BUT: TRANSFORMER UN CHAM_NO_S EN CHAM_ELEM_S
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNSZ  IN/JXIN  K19 : SD CHAM_NO_S A TRANSFORMER
C TYPCES IN       K4  : TYPE VOULU POUR LE CHAM_ELEM_S
C                      /'ELEM' /'ELGA' /'ELNO'
C CESMOZ IN/JXIN  K19 :  SD CHAM_ELEM_S "MODELE" POUR CESZ
C       SI TYPCES = 'ELEM' : CESMOZ N'EST PAS UTILISE
C       SI TYPCES  ='ELGA' ON SE SERT DE CESMOZ POUR DETERMINER
C          LE NOMBRE DE POINTS ET DE SOUS-POINTS  DU CHAM_ELEM _S
C       SI TYPCES  ='ELNO' ON SE SERT DE CESMOZ POUR DETERMINER
C          LE NOMBRE DE SOUS-POINTS  DU CHAM_ELEM_S
C MNOGAZ IN/JXIN  K19 : SD CHAM_ELEM_S CONTENANT LES MATRICES
C                       DE PASSAGE NOEUD -> GAUSS.
C                       MNOGAZ N'EST UTILISE QUE SI TYPCES='ELGA'

C CESZ   IN/JXOUT K19 : SD CHAM_ELEM_S RESULTAT
C BASE    IN      K1  : BASE DE CREATION POUR CESZ : G/V/L
C-----------------------------------------------------------------------

C  PRINCIPES RETENUS POUR LA CONVERSION :

C  1) ON NE TRAITE QUE LES CHAM_NO_S REELS (R8)
C  2)
C    SI  TYPCES='ELEM'
C       ON AFFECTE A LA MAILLE LA MOYENNE ARITHMETIQUE DES NOEUDS
C    SI  TYPCES='ELNO'
C       ON RECOPIE LA VALEUR DU NOEUD GLOBAL SUR LE NOEUD LOCAL
C    SI  TYPCES='ELGA'
C       ON UTILISE LA MATRICE DE PASSAGE NOEUD -> GAUSS.

C  3) LES EVENTUELS SOUS-POINTS PORTENT TOUS LES MEMES VALEURS

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
      INTEGER IMA,IBID,NCMP,ICMP,JCNSK,JCNSL,JCNSC,JCNSV
      INTEGER JCESD,JCESV,JCESL,NBMA,IRET,NBSP,NBNO,ICO
      INTEGER IAD,JNBPT,NBPT,IPT,INO,NUNO,ISP,NBPG2,NBNO2,IAD1
      INTEGER JCEMD,JNBSP,ILCNX1,IACNX1,NBPG,IPG
      INTEGER MNOGAL,MNOGAD,MNOGAV,MNOGAK
      CHARACTER*1 KBID
      CHARACTER*8 MA,NOMGD
      CHARACTER*3 TSCA
      CHARACTER*19 CES,CESMOD,CNS,MNOGA
      REAL*8 V,V1
C     ------------------------------------------------------------------
      CALL JEMARQ()


      CES = CESZ
      CESMOD = CESMOZ
      CNS = CNSZ


C     1- RECUPERATION D'INFORMATIONS DANS CNS :
C        MA    : NOM DU MAILLAGE
C        NOMGD : NOM DE LA GRANDEUR
C        NCMP  : NOMBRE DE CMPS DANS CNS
C     ------------------------------------------
      CALL JEVEUO(CNS//'.CNSK','L',JCNSK)
      CALL JEVEUO(CNS//'.CNSC','L',JCNSC)
      CALL JEVEUO(CNS//'.CNSV','L',JCNSV)
      CALL JEVEUO(CNS//'.CNSL','L',JCNSL)

      MA = ZK8(JCNSK-1+1)
      NOMGD = ZK8(JCNSK-1+2)
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      IF (TSCA.NE.'R') CALL U2MESS('F','CALCULEL_46')
      CALL JEVEUO(MA//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ILCNX1)
      CALL JELIRA(CNS//'.CNSC','LONMAX',NCMP,KBID)


C     2. CALCUL DES OBJETS  '&&CNSCES.NBPT','&CNSCES.NBSP'
C     -----------------------------------------------------------------
      CALL WKVECT('&&CNSCES.NBPT','V V I',NBMA,JNBPT)
      CALL WKVECT('&&CNSCES.NBSP','V V I',NBMA,JNBSP)


C     -- PAR DEFAUT : NBSP=1
      DO 10,IMA = 1,NBMA
        ZI(JNBSP-1+IMA) = 1
   10 CONTINUE

      CALL EXISD('CHAM_ELEM_S',CESMOD,IRET)
      IF ((TYPCES.EQ.'ELGA') .AND. (IRET.LE.0)) CALL U2MESS('F','CALCULE
     &L_61')

      IF (IRET.GT.0) THEN
        CALL JEVEUO(CESMOD//'.CESD','L',JCEMD)
        DO 20,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = ZI(JCEMD-1+5+4* (IMA-1)+1)
          ZI(JNBSP-1+IMA) = ZI(JCEMD-1+5+4* (IMA-1)+2)
   20   CONTINUE
      END IF

      IF (TYPCES.EQ.'ELEM') THEN
        DO 30,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = 1
   30   CONTINUE
      ELSE IF (TYPCES.EQ.'ELNO') THEN
        DO 40,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = ZI(ILCNX1+IMA) - ZI(ILCNX1+IMA-1)
   40   CONTINUE
      ELSE IF (TYPCES.EQ.'ELGA') THEN
C       DEJA FAIT GRACE A CESMOD
      ELSE
        CALL ASSERT(.FALSE.)
      END IF


C     5- CREATION DE CES :
C     ---------------------------------------
      CALL CESCRE(BASE,CES,TYPCES,MA,NOMGD,NCMP,ZK8(JCNSC),ZI(JNBPT),
     &            ZI(JNBSP),-NCMP)

      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESV','E',JCESV)
      CALL JEVEUO(CES//'.CESL','E',JCESL)



C     6- REMPLISSAGE DES OBJETS .CESL ET .CESV :
C     ------------------------------------------


      IF (TYPCES.EQ.'ELEM') THEN
C     --------------------------
        DO 100,IMA = 1,NBMA
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
          NBNO = ZI(ILCNX1+IMA) - ZI(ILCNX1-1+IMA)
          DO 90 ICMP = 1,NCMP

C           - ON VERIFIE QUE TOUS LES NOEUDS PORTENT BIEN LA CMP :
            ICO = 0
            DO 50,INO = 1,NBNO
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IF (ZL(JCNSL-1+ (NUNO-1)*NCMP+ICMP)) ICO = ICO + 1
   50       CONTINUE
            IF (ICO.NE.NBNO) GO TO 90

C         -- CALCUL DE LA MOYENNE ARITHMETIQUE :
            V = 0.D0
            DO 60,INO = 1,NBNO
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IF (ZL(JCNSL-1+ (NUNO-1)*NCMP+ICMP)) THEN
                V = V + ZR(JCNSV-1+ (NUNO-1)*NCMP+ICMP)
              END IF
   60       CONTINUE
            V = V/NBNO


            DO 80,IPT = 1,NBPT
              DO 70,ISP = 1,NBSP
                CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,ICMP,IAD)
                CALL ASSERT(IAD.LT.0)
                ZL(JCESL-1-IAD) = .TRUE.
                ZR(JCESV-1-IAD) = V
   70         CONTINUE
   80       CONTINUE
   90     CONTINUE
  100   CONTINUE


      ELSE IF (TYPCES.EQ.'ELNO') THEN
C     --------------------------
        DO 150,IMA = 1,NBMA
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
          NBNO = ZI(ILCNX1+IMA) - ZI(ILCNX1-1+IMA)
          CALL ASSERT(NBNO.EQ.NBPT)

          DO 140 ICMP = 1,NCMP

C           - ON VERIFIE QUE TOUS LES NOEUDS PORTENT BIEN LA CMP :
            ICO = 0
            DO 110,INO = 1,NBNO
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IF (ZL(JCNSL-1+ (NUNO-1)*NCMP+ICMP)) ICO = ICO + 1
  110       CONTINUE
            IF (ICO.NE.NBNO) GO TO 140

            DO 130,INO = 1,NBNO
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IF (.NOT.ZL(JCNSL-1+ (NUNO-1)*NCMP+ICMP)) GO TO 130
              V = ZR(JCNSV-1+ (NUNO-1)*NCMP+ICMP)
              DO 120,ISP = 1,NBSP
                CALL CESEXI('C',JCESD,JCESL,IMA,INO,ISP,ICMP,IAD)
                CALL ASSERT(IAD.LT.0)
                ZL(JCESL-1-IAD) = .TRUE.
                ZR(JCESV-1-IAD) = V
  120         CONTINUE
  130       CONTINUE
  140     CONTINUE
  150   CONTINUE


      ELSE IF (TYPCES.EQ.'ELGA') THEN
C     --------------------------
        MNOGA = MNOGAZ
        CALL JEVEUO(MNOGA//'.CESK','L',MNOGAK)
        CALL JEVEUO(MNOGA//'.CESD','L',MNOGAD)
        CALL JEVEUO(MNOGA//'.CESL','L',MNOGAL)
        CALL JEVEUO(MNOGA//'.CESV','L',MNOGAV)
        CALL ASSERT(ZK8(MNOGAK).EQ.MA)

        DO 210,IMA = 1,NBMA
          CALL CESEXI('C',MNOGAD,MNOGAL,IMA,1,1,1,IAD)
          IF (IAD.LE.0) GO TO 210
          NBNO2 = NINT(ZR(MNOGAV-1+IAD))
          NBPG2 = NINT(ZR(MNOGAV-1+IAD+1))

          NBPG = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
          NBNO = ZI(ILCNX1+IMA) - ZI(ILCNX1-1+IMA)
          CALL ASSERT(NBNO.EQ.NBNO2)
          CALL ASSERT(NBPG.EQ.NBPG2)

          DO 200 ICMP = 1,NCMP

C           - ON VERIFIE QUE TOUS LES NOEUDS PORTENT BIEN LA CMP :
            ICO = 0
            DO 160,INO = 1,NBNO
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IF (ZL(JCNSL-1+ (NUNO-1)*NCMP+ICMP)) ICO = ICO + 1
  160       CONTINUE
            IF (ICO.NE.NBNO) GO TO 200

            DO 190,IPG = 1,NBPG
              V = 0.D0
              DO 170,INO = 1,NBNO
                NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
                V1 = ZR(JCNSV-1+ (NUNO-1)*NCMP+ICMP)
                V = V + V1*ZR(MNOGAV-1+IAD+1+NBNO* (IPG-1)+INO)
  170         CONTINUE

              DO 180,ISP = 1,NBSP
                CALL CESEXI('C',JCESD,JCESL,IMA,IPG,ISP,ICMP,IAD1)
                CALL ASSERT(IAD1.LT.0)
                ZL(JCESL-1-IAD1) = .TRUE.
                ZR(JCESV-1-IAD1) = V
  180         CONTINUE
  190       CONTINUE

  200     CONTINUE
  210   CONTINUE

      END IF


C     7- MENAGE :
C     -----------
      CALL JEDETR('&&CNSCES.NBPT')
      CALL JEDETR('&&CNSCES.NBSP')

      CALL JEDEMA()
      END
