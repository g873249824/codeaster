      SUBROUTINE VRCOMP(COMPOM,COMPOP,VARMOI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      CHARACTER*(*) COMPOP,VARMOI,COMPOM
C ------------------------------------------------------------------
C BUT: VERIFIER LA COHERENCE D'UN CHAMP DE VARIABLES INTERNES AVEC
C      UN CHAMP DE COMPORTEMENT.

C      COMPOP EST LA CARTE DE COMPOPTEMENT A L'INSTANT "+"
C      VARMOI EST LE CHAMP DE VARIABLES INTERNES A L'INSTANT "-"
C      COMPOM EST LA CARTE DE COMPORTEMENT DE VARMOI (OU ' ')

C      - SI COMPOM = ' ' :
C           ON SE CONTENTE DE COMPARER LE NOMBRE DE V.I. DE VARMOI
C           AVEC LE NOMBRE ATTENDU DANS COMPOP.
C      - SI COMPOM /= ' ':
C           ON PEUT ALORS COMPARER LE NOM DES COMPORTEMENTS DES
C           INSTANTS "+" ET "-"
C           ON EXIGE QUE CES NOMS SOIENT IDENTIQUES OU BIEN QUE :
C             "-" : 'ELAS' OU 'SANS'  -> "+" : N'IMPORTE QUOI
C             "+" : 'ELAS' OU 'SANS'  -> "-" : N'IMPORTE QUOI


C ------------------------------------------------------------------
C     ARGUMENTS:
C COMPOM   IN/JXIN  K19 : CARTE DE COMPOPTEMENT "-"
C COMPOP   IN/JXIN  K19 : CARTE DE COMPOPTEMENT "+"
C VARMOI   IN/JXVAR K19 : SD CHAM_ELEM   (VARI_R) "-"

C REMARQUES :
C  - VARMOI EST PARFOIS MODIFIE POUR ETRE COHERENT AVEC COMPOP
C           ON LE RECREE ALORS SUR LA BASE VOLATILE
C  - ON VERIFIE EGALEMENT LE NOMBRE DE SOUS-POINTS

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
      CHARACTER*24 VALK(3)
      CHARACTER*32 ZK32,JEXNOM,JEXNUM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER JCE1D,JCE1V,JCE1L,JCE1K,JCE2D
      INTEGER IAD1,IAD2,NBMA,NBSP1,NBSP2,NBCMP1,NBCMP2
      INTEGER IMA,IRET,JLIMA,KMA,IB
      INTEGER IADP,JCOPPL,JCOPPD,JCOPPV,JCOPPK,IP
      INTEGER IADM,JCOPML,JCOPMD,JCOPMV,JCOPMK,IM
      INTEGER VALI(2)
      CHARACTER*8 NOMA,NOMAIL
      CHARACTER*16 RELCOP,RELCOM
      CHARACTER*19 CES1,CES2,COPM,COPP,COTO
      CHARACTER*48 COMP1,COMP2
      LOGICAL MODIF
C     ------------------------------------------------------------------
      CALL JEMARQ()

C     COMPORTEMENTS MISCIBLES ENTRE EUX :
C                     1         2         3         4
C            123456789012345678901234567890123456789012345678
      COMP1 = 'LEMAITRE        VMIS_ISOT_LINE  VMIS_ISOT_TRAC  '
      COMP2 = 'ELAS            SANS '


C     1.  SI COMPOM EST DONNE, ON VERIFIE LES NOMS DES COMPORTEMENT :
C     ---------------------------------------------------------------
      IF (COMPOM.NE.' ') THEN
        COTO = '&&VRCOMP.COTO'
        COPM = '&&VRCOMP.COPM'
        COPP = '&&VRCOMP.COPP'

        CALL CARCES(COMPOM,'ELEM',' ','V',COTO,IRET)
        CALL CESRED(COTO,0,0,1,'RELCOM','V',COPM)
        CALL DETRSD('CHAM_ELEM_S',COTO)

        CALL CARCES(COMPOP,'ELEM',' ','V',COTO,IRET)
        CALL CESRED(COTO,0,0,1,'RELCOM','V',COPP)
        CALL DETRSD('CHAM_ELEM_S',COTO)


        CALL JEVEUO(COPM//'.CESD','L',JCOPMD)
        CALL JEVEUO(COPM//'.CESV','L',JCOPMV)
        CALL JEVEUO(COPM//'.CESL','L',JCOPML)
        CALL JEVEUO(COPM//'.CESK','L',JCOPMK)

        CALL JEVEUO(COPP//'.CESD','L',JCOPPD)
        CALL JEVEUO(COPP//'.CESV','L',JCOPPV)
        CALL JEVEUO(COPP//'.CESL','L',JCOPPL)
        CALL JEVEUO(COPP//'.CESK','L',JCOPPK)

        CALL ASSERT(ZK8(JCOPMK-1+1).EQ.ZK8(JCOPPK-1+1))
        NOMA = ZK8(JCOPMK-1+1)
        NBMA = ZI(JCOPMD-1+1)
        CALL WKVECT('&&VRCOMP.LIMA','V V I',NBMA,JLIMA)

        KMA = 0
        MODIF = .FALSE.
        DO 10,IMA = 1,NBMA
          KMA = KMA + 1
          ZI(JLIMA-1+KMA) = IMA
          CALL CESEXI('C',JCOPMD,JCOPML,IMA,1,1,1,IADM)
          CALL CESEXI('C',JCOPPD,JCOPPL,IMA,1,1,1,IADP)
          IF (IADP.GT.0) THEN
            RELCOP = ZK16(JCOPPV-1+IADP)
            IF (IADM.LE.0) GO TO 40
            RELCOM = ZK16(JCOPMV-1+IADM)
            IF (RELCOM.EQ.RELCOP) GO TO 10

            IM = INDEX(COMP1,RELCOM)
            IP = INDEX(COMP1,RELCOP)
            IF ((IM.GT.0) .AND. (IP.GT.0)) GO TO 10

            IM = INDEX(COMP2,RELCOM)
            IP = INDEX(COMP2,RELCOP)
            IF ((IM.GT.0) .OR. (IP.GT.0)) THEN
              MODIF = .TRUE.
              KMA = KMA - 1
              GO TO 10
            END IF
            GO TO 60
          END IF
   10   CONTINUE
        IF (MODIF) CALL VRCOM2(COMPOM,COMPOP,VARMOI)
      END IF


C     2.  ON VERIFIE LES NOMBRES DE SOUS-POINTS ET LES LONGUEURS :
C     ------------------------------------------------------------

C     2.1  DANS COMPOP, ON RECUPERE LE CHAM_ELEM_S DE DCEL_I :
C     ----------------------------------------------------------------
      CES1 = COMPOP

C     1.2  ON TRANSFORME VARMOI EN CHAM_ELEM_S :
C     ----------------------------------------------------------------
      CES2 = '&&VRCOMP.VARI_R'
      CALL CELCES(VARMOI,'V',CES2)
      CALL CESTAS(CES2)

C     1.3  ON BOUCLE SUR LES MAILLES POUR VERIFIER :
C     ----------------------------------------------------------------
      CALL JEVEUO(CES1//'.CESD','L',JCE1D)
      CALL JEVEUO(CES1//'.CESV','L',JCE1V)
      CALL JEVEUO(CES1//'.CESL','L',JCE1L)
      CALL JEVEUO(CES1//'.CESK','L',JCE1K)

      CALL JEVEUO(CES2//'.CESD','L',JCE2D)

      NOMA = ZK8(JCE1K-1+1)
      NBMA = ZI(JCE1D-1+1)

      DO 20,IMA = 1,NBMA
        CALL CESEXI('C',JCE1D,JCE1L,IMA,1,1,1,IAD1)
        CALL CESEXI('C',JCE1D,JCE1L,IMA,1,1,2,IAD2)
C
C       SI LE COMPORTEMENT N'EST PAS PRESENT SUR IMA, ON SAUTE
C       (C'EST LE CAS POUR UN CALCUL SUR UN GROUPE DE MAILLES :)
C       LE COMPOR EST ALORS RESTREINT A CE GROUP_MA, ET LES
C       POUR LES AUTRES MAILLES ON N'A PAS BESOIN DE VERIFIER
C
        IF (IAD1.EQ.0.AND.IAD2.EQ.0) THEN
           GOTO 20
        ENDIF
        IF (IAD1.LE.0) THEN
          NBSP1 = 0
          NBCMP1 = 0
        ELSE
          CALL ASSERT(IAD2.GT.0)
          NBSP1 = ZI(JCE1V-1+IAD1)
          NBCMP1 = ZI(JCE1V-1+IAD2)
        END IF
        NBSP2 = ZI(JCE2D-1+5+4* (IMA-1)+2)
        NBCMP2 = ZI(JCE2D-1+5+4* (IMA-1)+3)

        IF (NBSP1.NE.NBSP2) GO TO 30
        IF (COMPOM.EQ.' ') THEN
          IF (NBCMP1.NE.NBCMP2) GO TO 50
        END IF
   20 CONTINUE
      GO TO 70


C     3. MESSAGES D'ERREUR :
C     ----------------------
   30 CONTINUE
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),NOMAIL)
      VALI (1) = NBSP2
      VALI (2) = NBSP1
      CALL U2MESG('F', 'CALCULEL6_52',1,NOMAIL,2,VALI,0,0.D0)

   40 CONTINUE
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),NOMAIL)
      CALL U2MESK('F','CALCULEL5_41',1,NOMAIL)

   50 CONTINUE
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),NOMAIL)
      VALI (1) = NBCMP1
      VALI (2) = NBCMP2
      CALL U2MESG('F', 'CALCULEL6_53',0,' ',2,VALI,0,0.D0)

   60 CONTINUE
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),NOMAIL)
       VALK(1) = RELCOM
       VALK(2) = RELCOP
       VALK(3) = NOMAIL
       CALL U2MESK('F','CALCULEL5_42', 3 ,VALK)

C     4. MENAGE :
C     -----------
   70 CONTINUE
      CALL DETRSD('CHAM_ELEM_S',CES2)

      CALL JEDEMA()
      END
