      SUBROUTINE CHSUT1(CHS1,NOMGD2,NCMP,LCMP1,LCMP2,BASE,CHS2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      INTEGER NCMP
      CHARACTER*(*) CHS1,NOMGD2,BASE,CHS2
      CHARACTER*8 LCMP1(NCMP),LCMP2(NCMP)
C ---------------------------------------------------------------------
C BUT: CHANGER LA GRANDEUR ET LE NOM DES CMPS D'UN CHAMP_S
C ---------------------------------------------------------------------
C     ARGUMENTS:
C CHS1   IN/JXIN  K19 : SD CHAMP_S A MODIFIER
C CHS2   IN/JXOUT K19 : SD CHAMP_S MODIFIEE
C BASE   IN       K1  : /G/V/L
C NCMP   IN       I   : NOMBRE DE CMPS DE LCMP1 ET LCMP2
C                       IL FAUT QUE LCMP1 CONTIENNE TOUTES LES CMPS
C                       DE CHS1
C NOMGD2  IN      K8   : NOM DE LA GRANDEUR "APRES"
C LCMP1   IN      L_K8 : LISTE DES CMPS "AVANT"
C LCMP2   IN      L_K8 : LISTE DES CMPS "APRES"

C REMARQUE : CHS2 PEUT ETRE IDENTIQUE A CHS1 (CHAMP_S MODIFIE)
C-----------------------------------------------------------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*24 VALK(3)
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      CHARACTER*19 CHSA,CHSB,CHSP
      INTEGER I1,I2,JCS1K,JCS1D,JCS1C,JCS2K,JCS2C,K,KK
      INTEGER INDIK8,IRET,IBID,NCMPCH

      CHARACTER*8 NOCMP,NOMGD1,TSCA1,TSCA2

      CHSA = CHS1
      CHSB = CHS2
      CHSP = '&&CHUT1.CHAMP_S_IN'

      CALL EXISD('CHAM_NO_S',CHSA,I1)
      CALL EXISD('CHAM_ELEM_S',CHSA,I2)
      IF (I1*I2.NE.0) CALL U2MESK('A','CALCULEL2_2',1,CHSA)
      IF (I1+I2.EQ.0) CALL U2MESK('A','CALCULEL2_3',1,CHSA)


C     1.  ON RECOPIE LE CHAMP "IN" ET ON RECUPERE LES ADRESSES JEVEUX :
C     -----------------------------------------------------------------
      IF (I1.GT.0) THEN
C      -- CAS D'UN CHAM_NO_S :
        CALL COPISD('CHAM_NO_S','V',CHSA,CHSP)
        CALL COPISD('CHAM_NO_S',BASE,CHSP,CHSB)
        CALL JEVEUO(CHSP//'.CNSK','L',JCS1K)
        CALL JEVEUO(CHSP//'.CNSD','L',JCS1D)
        CALL JEVEUO(CHSP//'.CNSC','L',JCS1C)
        CALL JEVEUO(CHSB//'.CNSK','E',JCS2K)
        CALL JEVEUO(CHSB//'.CNSC','E',JCS2C)

      ELSE
C      -- CAS D'UN CHAM_ELEM_S :
        CALL COPISD('CHAM_ELEM_S','V',CHSA,CHSP)
        CALL COPISD('CHAM_ELEM_S',BASE,CHSP,CHSB)
        CALL JEVEUO(CHSP//'.CESK','L',JCS1K)
        CALL JEVEUO(CHSP//'.CESD','L',JCS1D)
        CALL JEVEUO(CHSP//'.CESC','L',JCS1C)
        CALL JEVEUO(CHSB//'.CESK','E',JCS2K)
        CALL JEVEUO(CHSB//'.CESC','E',JCS2C)
      END IF


C     2. QUELQUES VERIFICATIONS :
C     ----------------------------

C     2.1 : LES TYPES SCALAIRES DE NOMGD1 ET NOMGD2 SONT LES MEMES:
      NOMGD1 = ZK8(JCS1K-1+2)
      CALL DISMOI('F','TYPE_SCA',NOMGD1,'GRANDEUR',IBID,TSCA1,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD2,'GRANDEUR',IBID,TSCA2,IBID)
      IF (TSCA1.NE.TSCA2) THEN
        VALK(1)=TSCA1
        VALK(2)=TSCA2
        CALL U2MESK('F','CALCULEL4_4',2,VALK)
      ENDIF

C     2.2 : NOMGD1 ET LCMP1 SONT COHERENTS :
      CALL VERIGD(NOMGD1,LCMP1,NCMP,IRET)
      CALL ASSERT(IRET.LE.0)

C     2.3 : NOMGD2 ET LCMP2 SONT COHERENTS :
      CALL VERIGD(NOMGD2,LCMP2,NCMP,IRET)
      CALL ASSERT(IRET.LE.0)


C      3. MODIFICATION DE CHS2 :
C      -------------------------
      ZK8(JCS2K-1+2) = NOMGD2
      NCMPCH = ZI(JCS1D-1+2)
      DO 10,K = 1,NCMPCH
        NOCMP = ZK8(JCS1C-1+K)
        KK = INDIK8(LCMP1,NOCMP,1,NCMP)
C       SI KK.EQ.0 : ON NE SAIT PAS RENOMMER LA CMP
        CALL ASSERT(KK.NE.0)
        ZK8(JCS2C-1+K) = LCMP2(KK)
   10 CONTINUE



C     5. MENAGE :
C     -----------
      IF (I1.GT.0) THEN
        CALL DETRSD('CHAM_NO_S',CHSP)
      ELSE
        CALL DETRSD('CHAM_ELEM_S',CHSP)
      END IF

      END
