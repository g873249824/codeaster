      SUBROUTINE VRCOM2(COMPOM,COMPOP,VARMOI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 25/03/2003   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      CHARACTER*(*) COMPOP,VARMOI,COMPOM
C ------------------------------------------------------------------
C BUT: MODIFIER VARMOI POUR LE RENDRE COHERENT AVEC COMPOP

C      COMPOM EST LA CARTE DE COMPORTEMENT A L'INSTANT "-"
C      COMPOP EST LA CARTE DE COMPOPTEMENT A L'INSTANT "+"
C      VARMOI EST LE CHAMP DE VARIABLES INTERNES A L'INSTANT "-"

C ------------------------------------------------------------------
C     ARGUMENTS:
C COMPOM   IN/JXIN  K19 : CARTE DE COMPOPTEMENT "-"
C COMPOP   IN/JXIN  K19 : CARTE DE COMPOPTEMENT "+"
C VARMOI   IN/JXVAR K19 : SD CHAM_ELEM   (VARI_R) "-"
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
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER JCE1D,JCE1V,JCE1L
      INTEGER IAD1,IAD2,NBMA,NBPG,NBSP,NBSP2,NBCM,IPG,ISP,ICM
      INTEGER IMA,IRET,IB,JNBPG,JNBSP,JNBCM,NBVARI,JNOVAR,K
      INTEGER IADP,JCOPPL,JCOPPD,JCOPPV
      INTEGER IADM,JCOPML,JCOPMD,JCOPMV,ACTION
      INTEGER JCEV1D,JCEV1V,JCEV1L,JCEV1K
      INTEGER JCEV2D,JCEV2V,JCEV2L
      CHARACTER*8 NOMA,NOCMP
      CHARACTER*16 RELCOP,RELCOM
      CHARACTER*19 CESV1,CESV2,LIGREL,CES1,COTO,COPM,COPP
C     ------------------------------------------------------------------
      CALL JEMARQ()


C     1- ON TRANSFORME VARMOI EN CHAM_ELEM_S (CESV1)
C     --------------------------------------------------
      CESV1 = '&&VRCOM2.CESV1'
      CALL CELCES(VARMOI,'V',CESV1)
      CALL CESTAS(CESV1)
      CALL JEVEUO(CESV1//'.CESD','L',JCEV1D)
      CALL JEVEUO(CESV1//'.CESV','L',JCEV1V)
      CALL JEVEUO(CESV1//'.CESL','L',JCEV1L)
      CALL JEVEUO(CESV1//'.CESK','L',JCEV1K)
      NOMA = ZK8(JCEV1K-1+1)
      NBMA = ZI(JCEV1D-1+1)


C     2- ON ALLOUE 1 CHAM_ELEM_S AUX BONNES DIMENSIONS (CESV2):
C     ----------------------------------------------------------
      CES1 = COMPOP
      CALL JEVEUO(CES1//'.CESD','L',JCE1D)
      CALL JEVEUO(CES1//'.CESV','L',JCE1V)
      CALL JEVEUO(CES1//'.CESL','L',JCE1L)
      CALL WKVECT('&&VRCOM2.NBPG','V V I',NBMA,JNBPG)
      CALL WKVECT('&&VRCOM2.NBSP','V V I',NBMA,JNBSP)
      CALL WKVECT('&&VRCOM2.NBCM','V V I',NBMA,JNBCM)
      NBVARI = 0
      DO 10,IMA = 1,NBMA
        ZI(JNBPG-1+IMA) = ZI(JCEV1D-1+5+4* (IMA-1)+1)
        CALL CESEXI('C',JCE1D,JCE1L,IMA,1,1,1,IAD1)
        CALL CESEXI('C',JCE1D,JCE1L,IMA,1,1,2,IAD2)
        IF (IAD1.LE.0) THEN
          ZI(JNBSP-1+IMA) = 0
          ZI(JNBCM-1+IMA) = 0
        ELSE
          ZI(JNBSP-1+IMA) = ZI(JCE1V-1+IAD1)
          ZI(JNBCM-1+IMA) = ZI(JCE1V-1+IAD2)
          NBVARI = MAX(NBVARI,ZI(JCE1V-1+IAD2))
        END IF
   10 CONTINUE

      CALL WKVECT('&&VRCOM2.NOVARI','V V K8',NBVARI,JNOVAR)
      NOCMP = 'V'
      DO 20,K = 1,NBVARI
        CALL CODENT(K,'G',NOCMP(2:8))
        ZK8(JNOVAR-1+K) = NOCMP
   20 CONTINUE

      CESV2 = '&&VRCOM2.CESV2'
      CALL CESCRE('V',CESV2,'ELGA',NOMA,'VARI_R',NBVARI,ZK8(JNOVAR),
     &            ZI(JNBPG),ZI(JNBSP),ZI(JNBCM))




C     3- ON RECOPIE DE CESV1 VERS CESV2 :
C     -----------------------------------
      CALL JEVEUO(CESV2//'.CESD','L',JCEV2D)
      CALL JEVEUO(CESV2//'.CESV','L',JCEV2V)
      CALL JEVEUO(CESV2//'.CESL','L',JCEV2L)

      COTO = '&&VRCOM2.COTO'
      COPM = '&&VRCOM2.COPM'
      COPP = '&&VRCOM2.COPP'

      CALL CARCES(COMPOM,'ELEM',' ','V',COTO,IRET)
      CALL CESRED(COTO,0,0,1,'RELCOM','V',COPM)
      CALL DETRSD('CHAM_ELEM_S',COTO)

      CALL CARCES(COMPOP,'ELEM',' ','V',COTO,IRET)
      CALL CESRED(COTO,0,0,1,'RELCOM','V',COPP)
      CALL DETRSD('CHAM_ELEM_S',COTO)

      CALL JEVEUO(COPM//'.CESD','L',JCOPMD)
      CALL JEVEUO(COPM//'.CESV','L',JCOPMV)
      CALL JEVEUO(COPM//'.CESL','L',JCOPML)

      CALL JEVEUO(COPP//'.CESD','L',JCOPPD)
      CALL JEVEUO(COPP//'.CESV','L',JCOPPV)
      CALL JEVEUO(COPP//'.CESL','L',JCOPPL)

      DO 60,IMA = 1,NBMA
        NBPG = ZI(JCEV2D-1+5+4* (IMA-1)+1)
        NBSP = ZI(JCEV2D-1+5+4* (IMA-1)+2)
        NBCM = ZI(JCEV2D-1+5+4* (IMA-1)+3)

        NBSP2 = ZI(JCEV1D-1+5+4* (IMA-1)+2)
        IF (NBSP.NE.NBSP2) CALL UTMESS('F','VRCOM2',
     &      'NOMBRE DE SOUS-POINTS INCOHERENT AVEC ETAT INITIAL')

        CALL CESEXI('C',JCOPPD,JCOPPL,IMA,1,1,1,IADP)
        IF (IADP.LE.0) GO TO 60
        RELCOP = ZK16(JCOPPV-1+IADP)
        CALL CESEXI('C',JCOPMD,JCOPML,IMA,1,1,1,IADM)
        CALL ASSERT(IADM.GT.0)
        RELCOM = ZK16(JCOPMV-1+IADM)
        IF (RELCOM.EQ.RELCOP) THEN
          ACTION = 1
        ELSE
          IF ((RELCOM.EQ.'ELAS') .OR. (RELCOM.EQ.'SANS') .OR.
     &        (RELCOP.EQ.'ELAS') .OR. (RELCOP.EQ.'SANS')) THEN
            ACTION = 2
          ELSE
            CALL ASSERT(.FALSE.)
          END IF
        END IF

        DO 50,IPG = 1,NBPG
          DO 40,ISP = 1,NBSP
            DO 30,ICM = 1,NBCM
              CALL CESEXI('S',JCEV2D,JCEV2L,IMA,IPG,ISP,ICM,IAD2)
              CALL ASSERT(IAD2.LT.0)
              ZL(JCEV2L-1-IAD2) = .TRUE.
              IF (ACTION.EQ.1) THEN
                CALL CESEXI('S',JCEV1D,JCEV1L,IMA,IPG,ISP,ICM,IAD1)
                CALL ASSERT(IAD1.GT.0)
                ZR(JCEV2V-1-IAD2) = ZR(JCEV1V-1+IAD1)
              ELSE
                ZR(JCEV2V-1-IAD2) = 0.D0
              END IF
   30       CONTINUE
   40     CONTINUE
   50   CONTINUE
   60 CONTINUE


C     4- ON TRANSFORME CESV2 EN CHAM_ELEM (VARMOI)
C     --------------------------------------------------
      CALL DISMOI('F','NOM_LIGREL',VARMOI,'CHAM_ELEM',IB,LIGREL,IB)
      CALL DETRSD('CHAM_ELEM',VARMOI)
      CALL CESCEL(CESV2,LIGREL,'RAPH_MECA','PVARIPR','OUI','V',VARMOI)

C     4. MENAGE :
C     -----------
   70 CONTINUE
      CALL DETRSD('CHAM_ELEM_S',CESV1)
      CALL DETRSD('CHAM_ELEM_S',CESV2)

      CALL JEDEMA()
      END
