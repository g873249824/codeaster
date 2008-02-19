      SUBROUTINE FOCRR2(NOMFON,RESU,BASE,NOMCHA,MAILLE,NOEUD,CMP,
     &                  NPOINT,NUSP,IVARI,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*1   BASE
      CHARACTER*8   MAILLE,NOEUD,CMP
      CHARACTER*16  NOMCHA
      CHARACTER*19  NOMFON,RESU
C     ------------------------------------------------------------------
C MODIF UTILITAI  DATE 19/02/2008   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     RECUPERATION D'UNE FONCTION DANS UNE STRUCTURE "RESULTAT"
C     ------------------------------------------------------------------
C VAR : NOMFON : NOM DE LA FONCTION
C IN  : RESU   : NOM DE LA STRUCTURE RESULTAT
C IN  : BASE   : BASE OU L'ON CREE LA FONCTION
C IN  : NOMCHA : NOM DU CHAMP
C IN  : NOEUD  : NOEUD
C IN  : MAILLE : MAILE
C IN  : CMP    : COMPOSANTE
C IN  : NPOINT : NUMERO DU POINT ( CAS DES CHAM_ELEMS )
C IN  : NUSP   : NUMERO DU SOUS-POINT ( CAS DES CHAM_ELEMS )
C IN  : IVARI   : NUMERO DE LA CMP (POUR VARI_R)
C OUT : IER    : CODE RETOUR, = 0 : OK
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      INTEGER VALI
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
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*1 TYPE
      CHARACTER*24 VALK(2)
      CHARACTER*8 K8B,NOMA,NOGD,NOMOBJ,NOMACC
      CHARACTER*16 NOMCMD,TYPCON,TYPCHA,TYPRES
      CHARACTER*19 LISTR,PROFCH,PROFC2,CH1,CH2
      REAL*8 DIMAG
      REAL*8 VALR(2)
      COMPLEX*16 VALC1,VALC2
      LOGICAL NVERI1,NVERI2,NVERI3
C     ------------------------------------------------------------------

      CALL JEMARQ()

      IER = 0
      CALL GETRES(K8B,TYPCON,NOMCMD)
      CALL GETTCO(RESU,TYPRES)

      CALL GETVR8(' ','INST',1,1,0,R8B,N1)
      CALL GETVID(' ','LIST_INST',1,1,0,K8B,N2)
      CALL GETVR8(' ','FREQ',1,1,0,R8B,N3)
      CALL GETVID(' ','LIST_FREQ',1,1,0,K8B,N4)

      IF (TYPRES(1:10).EQ.'DYNA_HARMO') THEN
        NOMACC = 'FREQ    '
        IF (N1+N2.NE.0) THEN
          CALL U2MESS('F','UTILITAI_95')
        END IF
        IF (N3+N4.EQ.0) THEN
          CALL FOCRRS(NOMFON,RESU,BASE,NOMCHA,MAILLE,NOEUD,CMP,NPOINT,
     &                NUSP,IVARI,IER)
          GO TO 40
        END IF
        IF (N3.NE.0) THEN
          NBINST = -N3
          CALL WKVECT('&&FOCRR2.INST','V V R',NBINST,JINST)
          CALL GETVR8(' ','FREQ',1,1,NBINST,ZR(JINST),N3)
        ELSE
          CALL GETVID(' ','LIST_FREQ',1,1,1,LISTR,N4)
          CALL JEVEUO(LISTR//'.VALE','L',JINST)
          CALL JELIRA(LISTR//'.VALE','LONMAX',NBINST,K8B)
        END IF
      ELSE
        NOMACC = 'INST    '
        IF (N3+N4.NE.0) THEN
          CALL U2MESS('F','UTILITAI_96')
        END IF
        IF (N1+N2.EQ.0) THEN
          CALL FOCRRS(NOMFON,RESU,BASE,NOMCHA,MAILLE,NOEUD,CMP,NPOINT,
     &                NUSP,IVARI,IER)
          GO TO 40
        END IF
        IF (N1.NE.0) THEN
          NBINST = -N1
          CALL WKVECT('&&FOCRR2.INST','V V R',NBINST,JINST)
          CALL GETVR8(' ','INST',1,1,NBINST,ZR(JINST),N1)
        ELSE
          CALL GETVID(' ','LIST_INST',1,1,1,LISTR,N2)
          CALL JEVEUO(LISTR//'.VALE','L',JINST)
          CALL JELIRA(LISTR//'.VALE','LONMAX',NBINST,K8B)
        END IF
      END IF

C     --- REMPLISSAGE DU .PROL ---
      CALL ASSERT(LXLGUT(NOMFON).LE.24)
      CALL WKVECT(NOMFON//'.PROL',BASE//' V K24',6,LPRO)
      IF (TYPRES(1:10).EQ.'DYNA_HARMO') THEN
        ZK24(LPRO) = 'FONCT_C'
      ELSE
        ZK24(LPRO) = 'FONCTION'
      END IF
      ZK24(LPRO+1) = 'NON     '
      ZK24(LPRO+2) = NOMACC
      ZK24(LPRO+3) = CMP
      ZK24(LPRO+4) = 'EE      '
      ZK24(LPRO+5) = NOMFON

      IF (TYPRES(1:10).EQ.'DYNA_HARMO') THEN
        CALL WKVECT(NOMFON//'.VALE',BASE//' V R',3*NBINST,LVAR)
      ELSE
        CALL WKVECT(NOMFON//'.VALE',BASE//' V R',2*NBINST,LVAR)
      END IF
      LFON = LVAR + NBINST

      CALL JENONU(JEXNOM(RESU//'.NOVA',NOMACC),IACCES)
      CALL ASSERT(IACCES.NE.0)
      CALL JEVEUO(JEXNUM(RESU//'.TAVA',IACCES),'L',IATAVA)
      NOMOBJ = ZK8(IATAVA-1+1)
      CALL JEVEUO(RESU//NOMOBJ,'L',KINST)
      CALL DISMOI('F','NB_CHAMP_MAX',RESU,'RESULTAT',NBORDR,K8B,IERD)

C     -- ON REPERE QUELS SONT LES CHAMPS EXISTANT REELLEMENT:
      CALL JECREO('&&FOCRR2.LEXI','V V L')
      CALL JEECRA('&&FOCRR2.LEXI','LONMAX',NBORDR,K8B)
      CALL JEVEUO('&&FOCRR2.LEXI','E',IALEXI)
      CALL JENONU(JEXNOM(RESU//'.DESC',NOMCHA),IBID)
      CALL JEVEUO(JEXNUM(RESU//'.TACH',IBID),'L',IATACH)
      DO 10 I = 1,NBORDR
        IF (ZK24(IATACH-1+I) (1:1).EQ.' ') THEN
          ZL(IALEXI-1+I) = .FALSE.
        ELSE
          ZL(IALEXI-1+I) = .TRUE.
        END IF
   10 CONTINUE

      RVAL = ZR(JINST)
      CALL RSBARY(ZR(KINST),NBORDR,.FALSE.,ZL(IALEXI),RVAL,I1,I2,IPOSIT)
      CALL RSUTRO(RESU,I1,IP1,IERR1)
      CALL RSEXCH(RESU,NOMCHA,IP1,CH1,IERD)
      CALL DISMOI('F','TYPE_SUPERVIS',CH1,'CHAMP',IBID,TYPCHA,IERD)

C               ----- EXTRACTION SUR UN "CHAM_NO" -----

      IF (TYPCHA(1:7).EQ.'CHAM_NO') THEN
        CALL DISMOI('F','PROF_CHNO',CH1,'CHAM_NO',IBID,PROFCH,IE)
        CALL DISMOI('F','NOM_MAILLA',CH1,'CHAM_NO',IBID,NOMA,IE)
        CALL POSDDL('CHAM_NO',CH1,NOEUD,CMP,INOEUD,IDDL1)
        IF (INOEUD.EQ.0) THEN
          LG1 = LXLGUT(NOEUD)
          CALL U2MESK('F','UTILITAI_92',1,NOEUD(1:LG1))
        ELSE IF (IDDL1.EQ.0) THEN
          LG1 = LXLGUT(NOEUD)
          LG2 = LXLGUT(CMP)
         VALK(1) = CMP(1:LG2)
         VALK(2) = NOEUD(1:LG1)
         CALL U2MESK('F','UTILITAI_93', 2 ,VALK)
        END IF
        IDDL2 = IDDL1
        DO 20 IORDR = 0,NBINST - 1
          CALL JEMARQ()

          RVAL = ZR(JINST+IORDR)
          CALL RSBARY(ZR(KINST),NBORDR,.FALSE.,ZL(IALEXI),RVAL,I1,I2,
     &                IPOSIT)
          IF (IPOSIT.EQ.-2) THEN
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_16',0,' ',0,0,1,VALR)

C           -- PROLONGEMENT A GAUCHE:
C           -------------------------
          ELSE IF (IPOSIT.EQ.-1) THEN
            VALR (1) = RVAL
            VALR (2) = ZR(KINST)
            CALL U2MESG('F', 'UTILITAI6_17',0,' ',0,0,2,VALR)

C           -- PROLONGEMENT A DROITE:
C           -------------------------
          ELSE IF (IPOSIT.EQ.1) THEN
            VALR (1) = RVAL
            VALR (2) = ZR(KINST+NBORDR-1)
            CALL U2MESG('F', 'UTILITAI6_18',0,' ',0,0,2,VALR)
          END IF

          CALL RSUTRO(RESU,I1,IP1,IERR1)
          CALL RSUTRO(RESU,I2,IP2,IERR2)
          CALL ASSERT(IERR1+IERR2.LE.0)
          RBASE = ZR(KINST-1+I2) - ZR(KINST-1+I1)

          CALL RSEXCH(RESU,NOMCHA,IP1,CH1,L1)
          CALL RSEXCH(RESU,NOMCHA,IP2,CH2,L2)
          IF (L1.GT.0) THEN
            VALK (1) = NOMCHA
            VALK (2) = RESU
            VALI = IP1
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_19',2,VALK,1,VALI,1,VALR)
          END IF
          IF (L2.GT.0) THEN
            VALK (1) = NOMCHA
            VALK (2) = RESU
            VALI = IP2
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_19',2,VALK,1,VALI,1,VALR)
          END IF

          CALL DISMOI('F','PROF_CHNO',CH1,'CHAM_NO',IBID,PROFC2,IE)
          IF (PROFC2.NE.PROFCH) THEN
            PROFCH = PROFC2
            CALL POSDDL('CHAM_NO',CH1,NOEUD,CMP,INOEUD,IDDL1)
            IF (INOEUD.EQ.0) THEN
              LG1 = LXLGUT(NOEUD)
              CALL U2MESK('F','UTILITAI_92',1,NOEUD(1:LG1))
            ELSE IF (IDDL1.EQ.0) THEN
              LG1 = LXLGUT(NOEUD)
              LG2 = LXLGUT(CMP)
               VALK(1) = CMP(1:LG2)
               VALK(2) = NOEUD(1:LG1)
               CALL U2MESK('F','UTILITAI_93', 2 ,VALK)
            END IF
            IDDL2 = IDDL1
          END IF

          IF (RBASE.EQ.0.0D0) THEN
            CALL JEVEUO(CH1//'.VALE','L',LVAL1)
            ZR(LVAR+IORDR) = RVAL
            ZR(LFON+IORDR) = ZR(LVAL1+IDDL1-1)
            GO TO 22
          END IF
          R1 = (ZR(KINST-1+I2)-RVAL)/RBASE
          R2 = (RVAL-ZR(KINST-1+I1))/RBASE

          CALL DISMOI('F','PROF_CHNO',CH2,'CHAM_NO',IBID,PROFC2,IE)
          IF (PROFC2.NE.PROFCH) THEN
            PROFCH = PROFC2
            CALL POSDDL('CHAM_NO',CH2,NOEUD,CMP,INOEUD,IDDL2)
            IF (INOEUD.EQ.0) THEN
              LG1 = LXLGUT(NOEUD)
              CALL U2MESK('F','UTILITAI_92',1,NOEUD(1:LG1))
            ELSE IF (IDDL2.EQ.0) THEN
              LG1 = LXLGUT(NOEUD)
              LG2 = LXLGUT(CMP)
               VALK(1) = CMP(1:LG2)
               VALK(2) = NOEUD(1:LG1)
               CALL U2MESK('F','UTILITAI_93', 2 ,VALK)
            END IF
          END IF

          CALL JEVEUO(CH1//'.VALE','L',LVAL1)
          CALL JEVEUO(CH2//'.VALE','L',LVAL2)
          ZR(LVAR+IORDR) = RVAL
          ZR(LFON+IORDR) = R1*ZR(LVAL1+IDDL1-1) + R2*ZR(LVAL2+IDDL2-1)

          IDDL1 = IDDL2
   22     CONTINUE
          CALL JEDEMA()
   20   CONTINUE

C               ----- EXTRACTION SUR UN "CHAM_ELEM" -----

      ELSE IF (TYPCHA(1:9).EQ.'CHAM_ELEM') THEN

C ---    VERIFICATION DE LA PRESENCE DES MOTS CLE GROUP_MA (OU MAILLE)
C ---    ET GROUP_NO (OU NOEUD OU POINT) DANS LE CAS D'UN CHAM_ELEM
C        -------------------------------------------------------------
        NVERI1 = MAILLE .EQ. ' '
        NVERI2 = NOEUD .EQ. ' '
        NVERI3 = NPOINT .EQ. 0
        IF (NVERI1 .OR. (NVERI2.AND.NVERI3)) THEN
            VALK (1) = K8B
            VALK (2) = K8B
        CALL U2MESG('F', 'UTILITAI6_15',2,VALK,0,0,0,0.D0)
        END IF
        CALL DISMOI('F','NOM_MAILLA',CH1,'CHAM_ELEM',IBID,NOMA,IE)
        CALL DISMOI('F','NOM_GD',CH1,'CHAM_ELEM',IBID,NOGD,IE)
        CALL DISMOI('F','TYPE_SCA',NOGD,'GRANDEUR',IBID,TYPE,IE)

        II = 0
        DO 30 IORDR = 0,NBINST - 1
          CALL JEMARQ()

          RVAL = ZR(JINST+IORDR)
          CALL RSBARY(ZR(KINST),NBORDR,.FALSE.,ZL(IALEXI),RVAL,I1,I2,
     &                IPOSIT)
          IF (IPOSIT.EQ.-2) THEN
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_16',0,' ',0,0,1,VALR)

C           -- PROLONGEMENT A GAUCHE:
C           -------------------------
          ELSE IF (IPOSIT.EQ.-1) THEN
            VALR (1) = RVAL
            VALR (2) = ZR(KINST)
            CALL U2MESG('F', 'UTILITAI6_17',0,' ',0,0,2,VALR)

C           -- PROLONGEMENT A DROITE:
C           -------------------------
          ELSE IF (IPOSIT.EQ.1) THEN
            VALR (1) = RVAL
            VALR (2) = ZR(KINST+NBORDR-1)
            CALL U2MESG('F', 'UTILITAI6_18',0,' ',0,0,2,VALR)
          END IF

          CALL RSUTRO(RESU,I1,IP1,IERR1)
          CALL RSUTRO(RESU,I2,IP2,IERR2)
          CALL ASSERT(IERR1+IERR2.LE.0)
          RBASE = ZR(KINST-1+I2) - ZR(KINST-1+I1)

          CALL RSEXCH(RESU,NOMCHA,IP1,CH1,L1)
          CALL RSEXCH(RESU,NOMCHA,IP2,CH2,L2)
          IF (L1.GT.0) THEN
            VALK (1) = NOMCHA
            VALK (2) = RESU
            VALI = IP1
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_25',2,VALK,1,VALI,1,VALR)
          END IF
          IF (L2.GT.0) THEN
            VALK (1) = NOMCHA
            VALK (2) = RESU
            VALI = IP2
            VALR (1) = RVAL
            CALL U2MESG('F', 'UTILITAI6_25',2,VALK,1,VALI,1,VALR)
          END IF

          IF (RBASE.EQ.0.0D0) THEN
            CALL UTCH19(CH1,NOMA,MAILLE,NOEUD,NPOINT,NUSP,IVARI,CMP,
     &                  TYPE,VALR1,VALC1,IRET)
            CALL ASSERT(IRET.EQ.0)
            ZR(LVAR+IORDR) = RVAL
            IF (TYPE.EQ.'R') THEN
              ZR(LFON+IORDR) = VALR1
            ELSE
              ZR(LFON+II) = DBLE(VALC1)
              II = II + 1
              ZR(LFON+II) = DIMAG(VALC1)
              II = II + 1
            END IF
            GO TO 32
          END IF
          R1 = (ZR(KINST-1+I2)-RVAL)/RBASE
          R2 = (RVAL-ZR(KINST-1+I1))/RBASE

          CALL UTCH19(CH1,NOMA,MAILLE,NOEUD,NPOINT,NUSP,IVARI,CMP,TYPE,
     &                VALR1,VALC1,IRET)
          CALL ASSERT (IRET.EQ.0)
          CALL UTCH19(CH2,NOMA,MAILLE,NOEUD,NPOINT,NUSP,IVARI,CMP,TYPE,
     &                VALR2,VALC2,IRET)
          CALL ASSERT (IRET.EQ.0)

          ZR(LVAR+IORDR) = RVAL
          IF (TYPE.EQ.'R') THEN
            ZR(LFON+IORDR) = R1*VALR1 + R2*VALR2
          ELSE
            ZR(LFON+II) = DBLE(R1*VALC1+R2*VALC2)
            II = II + 1
            ZR(LFON+II) = DIMAG(R1*VALC1+R2*VALC2)
            II = II + 1
          END IF

   32     CONTINUE
          CALL JEDEMA()
   30   CONTINUE
      END IF

      CALL JEDETR('&&FOCRR2.LEXI')
      CALL JEDETC('V ','&&FOCRR2',1)
   40 CONTINUE
      CALL JEDEMA()
      END
