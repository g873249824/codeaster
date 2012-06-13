      SUBROUTINE CELCEL(TRANSF,CEL1,BASE,CEL2)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) TRANSF,CEL1,BASE,CEL2
C ----------------------------------------------------------------------
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C RESPONSABLE PELLET
C ----------------------------------------------------------------------
C  BUT : TRANSFORMER UN CHAM_ELEM (CEL1) EN UN CHAM_ELEM (CEL2) QUI
C        A DE NOUVELLES PROPRIETES. PAR EXEMPLE POUR POUVOIR ETRE
C        IMPRIME, POST-TRAITE, ...

C  IN        TRANSF K*  : NOM DE LA TRANSFORMATION :

C  'NBVARI_CST' : SI LES ELEMENTS DU CHAM_ELEM (VARI_R) N'ONT
C                   PAS LE MEME NOMBRE DE DE CMPS, ON LES ALIGNE
C                   TOUS SUR LE NOMBRE MAX (SITUATION AVANT 10/99)

C  'PAS_DE_SP'  : SI DES ELEMENTS DU CHAM_ELEM ONT DES SOUS-POINTS
C                 ON MET LE MODE LOCAL DE LEUR GREL A 0.
C                 C'EST COMME S'ILS AVAIENT ETE EFFACES.


C  IN/JXIN   CEL1   K19 : CHAM_ELEM A TRANSFORMER
C  IN        BASE   K1  : /'V'/'G'/ : BASE DE CREATION DE CEL2
C  IN/JXOUT  CEL2   K19 : CHAM_ELEM APRES TRANSFORMATION
C ----------------------------------------------------------------------

C     ------------------------------------------------------------------
      INTEGER IMA,IPT,ISPT,ICMP,NBMA,IBID,IERD
      INTEGER JCESD1,JCESL1,JCESV1,JCESC1,JCESK1
      INTEGER JCESD2,JCESL2,JCESV2,JCELD2,NBGREL,IGREL,DEBUGR,NBEL
      INTEGER NBPT,NBSPT,NCMP2,IAD1,IAD2,IMOLO,NBSPMX,IEL,NBSP
      INTEGER NCMPG,NBVAMX,JNBPT,JNBSPT,JCELK1,NNCP,ICO
      CHARACTER*19 CES1,CES2,LIGREL,CEL11,CEL22
      CHARACTER*16 OPTINI,NOMPAR
      CHARACTER*8 MA,NOMGD,TYPCES,KBID
      CHARACTER*24 VALK(3)
C -DEB------------------------------------------------------------------
      CALL JEMARQ()

      CALL DISMOI('F','NOM_GD',CEL1,'CHAMP',IBID,NOMGD,IERD)


      IF (TRANSF.EQ.'NBVARI_CST') THEN
C     =================================

        IF (NOMGD.NE.'VARI_R') THEN
C         -- IL N'Y A RIEN A FAIRE : NBVARI EST CST !
          CALL COPISD('CHAMP_GD',BASE,CEL1,CEL2)
          GOTO 80
        ENDIF

C       1- ON TRANSFORME CEL1 EN CHAM_ELEM_S : CES1
C       -------------------------------------------
        CES1 = '&&CELCEL.CES1'
        CALL CELCES(CEL1,'V',CES1)
        CALL JEVEUO(CES1//'.CESD','L',JCESD1)
        CALL JEVEUO(CES1//'.CESL','L',JCESL1)
        CALL JEVEUO(CES1//'.CESV','L',JCESV1)
        CALL JEVEUO(CES1//'.CESC','L',JCESC1)
        CALL JEVEUO(CES1//'.CESK','L',JCESK1)

C       2- ON ALLOUE UN CHAM_ELEM_S PLUS GROS: CES2
C       -------------------------------------------
        CES2 = '&&CELCEL.CES2'
        MA = ZK8(JCESK1-1+1)
        TYPCES = ZK8(JCESK1-1+3)
        NBMA = ZI(JCESD1-1+1)
        NCMPG = ZI(JCESD1-1+2)
        NBVAMX = ZI(JCESD1-1+5)
        CALL ASSERT(NCMPG.EQ.NBVAMX)

C       2.1 : CALCUL DE 2 VECTEURS CONTENANT LE NOMBRE DE
C             POINTS DE SOUS-POINTS DES MAILLES
C       ---------------------------------------------------
        CALL WKVECT('&&CELCEL.NBPT','V V I',NBMA,JNBPT)
        CALL WKVECT('&&CELCEL.NBSPT','V V I',NBMA,JNBSPT)
        DO 10,IMA = 1,NBMA
          ZI(JNBPT-1+IMA) = ZI(JCESD1-1+5+4* (IMA-1)+1)
          ZI(JNBSPT-1+IMA) = ZI(JCESD1-1+5+4* (IMA-1)+2)
   10   CONTINUE

C       2.2 : ALLOCATION DE CES2 :
C       ---------------------------------------------------
        CALL CESCRE('V',CES2,TYPCES,MA,NOMGD,-NBVAMX,KBID,ZI(JNBPT),
     &              ZI(JNBSPT),-NBVAMX)
        CALL JEVEUO(CES2//'.CESD','L',JCESD2)
        CALL JEVEUO(CES2//'.CESL','E',JCESL2)
        CALL JEVEUO(CES2//'.CESV','E',JCESV2)




C       3- ON RECOPIE LES VALEURS DE CES1 DANS CES2 :
C       ---------------------------------------------
        DO 50,IMA = 1,NBMA
          NBPT = ZI(JCESD1-1+5+4* (IMA-1)+1)
          NBSPT = ZI(JCESD1-1+5+4* (IMA-1)+2)

          NCMP2 = ZI(JCESD2-1+5+4* (IMA-1)+3)

          DO 40,IPT = 1,NBPT
            DO 30,ISPT = 1,NBSPT
              DO 20,ICMP = 1,NCMP2
                CALL CESEXI('C',JCESD1,JCESL1,IMA,IPT,ISPT,ICMP,IAD1)
                CALL CESEXI('C',JCESD2,JCESL2,IMA,IPT,ISPT,ICMP,IAD2)
                CALL ASSERT(IAD2.LT.0)
                ZL(JCESL2-1-IAD2) = .TRUE.
                IF (IAD1.GT.0) THEN
                  ZR(JCESV2-1-IAD2) = ZR(JCESV1-1+IAD1)

                ELSE
                  ZR(JCESV2-1-IAD2) = 0.D0
                ENDIF
   20         CONTINUE
   30       CONTINUE
   40     CONTINUE
   50   CONTINUE



C       4- ON TRANSFORME CES2 EN CHAM_ELEM : CEL2
C       -------------------------------------------
        CEL11 = CEL1
        CALL JEVEUO(CEL11//'.CELK','L',JCELK1)
        LIGREL = ZK24(JCELK1-1+1)
        OPTINI = ZK24(JCELK1-1+2)
        NOMPAR = ZK24(JCELK1-1+6)
        CALL CESCEL(CES2,LIGREL,OPTINI,NOMPAR,'NON',NNCP,BASE,CEL2,'F',
     &              IBID)


C       5- MENAGE :
C       -------------------------------------------
        CALL JEDETR('&&CELCEL.NBPT')
        CALL JEDETR('&&CELCEL.NBSPT')
        CALL DETRSD('CHAM_ELEM_S',CES1)
        CALL DETRSD('CHAM_ELEM_S',CES2)


      ELSEIF (TRANSF.EQ.'PAS_DE_SP') THEN
C     =====================================

        CALL COPISD('CHAMP_GD',BASE,CEL1,CEL2)
        CEL22 = CEL2
        CALL JEVEUO(CEL22//'.CELD','E',JCELD2)
        NBGREL = ZI(JCELD2-1+2)

C       -- ON MET A ZERO LE MODE LOCAL DES GRELS QUI ONT DES
C          SOUS-POINTS :
        ICO=0
        DO 70,IGREL = 1,NBGREL
          DEBUGR = ZI(JCELD2-1+4+IGREL)
          NBEL = ZI(JCELD2-1+DEBUGR+1)
          IMOLO = ZI(JCELD2-1+DEBUGR+2)
          IF (IMOLO.GT.0) THEN
            NBSPMX = 0
            DO 60,IEL = 1,NBEL
              NBSP = ZI(JCELD2-1+DEBUGR+4+4* (IEL-1)+1)
              NBSPMX = MAX(NBSPMX,NBSP)
   60       CONTINUE
            IF (NBSPMX.GT.1) THEN
              ZI(JCELD2-1+DEBUGR+2) = 0
            ELSE
              ICO=ICO+1
            ENDIF
          ENDIF
   70   CONTINUE
        IF (ICO.EQ.0) THEN
          VALK(1)=CEL1
          VALK(2)=NOMGD
          CALL U2MESK('F','CALCULEL2_40',2,VALK)
        ENDIF


      ELSE
C       CAS RESTANT A PROGRAMMER ...
        CALL ASSERT(.FALSE.)
      ENDIF

   80 CONTINUE
      CALL JEDEMA()
      END
