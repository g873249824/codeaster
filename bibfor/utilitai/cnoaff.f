      SUBROUTINE CNOAFF ( NOMA, GRAN, BASE, CNO )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
      CHARACTER*1 BASE
      CHARACTER*8 GRAN,NOMA,CNO
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE PELLET J.PELLET

C     COMMANDE   :  CREA_CHAMP/OPERATION:'AFFE', TYPE DE CHAMP : 'NOEU'
C
C     BUT : CREER UN CHAMP AU NOEUD PAR AFFECTATION
C
C     IN     : NOMA (K8) : NOM DU MAILLAGE
C              GRAN (K8) : NOM DE LA GRANDEUR DU CHAMP A CONSTRUIRE
C              BASE (K1) : VOLATILE ('V') OU GLOBALE ('G')
C              CNO  (K8) : NOM DU CHAMP A CONSTRUIRE
C ----------------------------------------------------------------------


      INTEGER      NUMGD,IAV,INUME,IBID,IERD,ICHNO,NOCC,JCMPT,NBCMPT
      INTEGER      IOCC,NBCMP,NBVAR,NBVAI,NBVAC,NBVAK,NBVA,VALI,JCMP
      INTEGER      I,IRET,NCMP,JTMP,INDIK8,NCMPMX,JCMPMX,JCNSV,JCNSL
      INTEGER      NBNO,NBTOU,NBNOE,JLNO,JVAL,ICMP,J,INO,JREF,NT,NBVAL
      REAL*8       RBID
      COMPLEX*16   CBID
      CHARACTER*1  TSCA
      CHARACTER*3  PROL0
      CHARACTER*8  K8B,NOMGD,NOGDSI,NOCHNO,KBID,TYPMCL(4)
      CHARACTER*14 NONUME
      CHARACTER*16 MOTCLE(4)
      CHARACTER*19 CNOS
      CHARACTER*24 VALK(2),MESNOE,MESCMP,PRCHNO,REFE
      INTEGER      IARG
C
C ----------------------------------------------------------------------

      CALL JEMARQ()
C
C
C --- 1. RECUPERATION
C     ===============
C
C     RECUP : COMPOSANTES DE LA GRANDEUR
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',GRAN),NUMGD)
      IF (NUMGD.EQ.0) THEN
        VALK (1) = GRAN
        CALL U2MESG('F', 'UTILITAI6_1',1,VALK,0,0,0,0.D0)
      ELSE
        CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',JCMPMX)
        CALL JEVEUO(JEXATR('&CATA.GD.NOMCMP','LONCUM'),'L',IAV)
        NCMPMX = ZI(IAV+NUMGD) - ZI(IAV+NUMGD-1)
      END IF
C
C
C --- 2. VERIFICATIONS
C     =================
C
C  -- NUME_DDL :
C     VERIFICATION QUE LA GRANDEUR ASSOCIEE AU NUME_DDL
C     EST LA MEME QUE CELLE DE LA COMMANDE
      CALL GETVID(' ','NUME_DDL',0,IARG,0,K8B,INUME)
      IF (INUME.NE.0) THEN
        CALL GETVID(' ','NUME_DDL',0,IARG,1,NONUME,INUME)
        CALL DISMOI('F','NOM_GD',NONUME,'NUME_DDL',IBID,NOMGD,IERD)
        CALL DISMOI('F','NOM_GD_SI',NOMGD,'GRANDEUR',IBID,NOGDSI,IERD)
        IF (NOGDSI.NE.GRAN) THEN
          VALK (1) = NOGDSI
          VALK (2) = GRAN
          CALL U2MESG('F', 'UTILITAI6_5',2,VALK,0,0,0,0.D0)
        END IF
      END IF
C
C  -- CHAM_NO :
C     VERIFICATION QUE LA GRANDEUR ASSOCIEE AU PROFIL
C     DU CHAM_NO EST LA MEME QUE CELLE DE LA COMMANDE
      CALL GETVID(' ','CHAM_NO',0,IARG,0,K8B,ICHNO)
      IF (ICHNO.NE.0) THEN
        CALL GETVID(' ','CHAM_NO',0,IARG,1,NOCHNO,ICHNO)
        CALL DISMOI('F','NOM_GD',NOCHNO,'CHAM_NO',IBID,NOMGD,IERD)
        CALL DISMOI('F','NOM_GD_SI',NOMGD,'GRANDEUR',IBID,NOGDSI,IERD)
        IF (NOGDSI.NE.GRAN) THEN
          VALK (1) = NOGDSI
          VALK (2) = GRAN
          CALL U2MESG('F', 'UTILITAI6_5',2,VALK,0,0,0,0.D0)
        END IF
      END IF
C
C  -- DANS LE MOT-CLE FACTEUR AFFE
C     ----------------------------
      CALL GETFAC ( 'AFFE', NOCC )
      DO 20 IOCC = 1,NOCC
        CALL GETVTX ( 'AFFE','NOM_CMP' , IOCC,IARG,0, KBID, NBCMP )
        CALL GETVR8 ( 'AFFE','VALE'    , IOCC,IARG,0, RBID, NBVAR )
        CALL GETVIS ( 'AFFE','VALE_I'  , IOCC,IARG,0, IBID, NBVAI )
        CALL GETVC8 ( 'AFFE','VALE_C'  , IOCC,IARG,0, CBID, NBVAC )
        CALL GETVID ( 'AFFE','VALE_F'  , IOCC,IARG,0, KBID, NBVAK )

C       => VERIF : NOMBRE DE COMPOSANTES = NOMBRE DE VALEURS
        NBVA=NBVAR+NBVAI+NBVAC+NBVAK
        IF(NBCMP.NE.NBVA)THEN
          VALI = IOCC
          CALL U2MESG('F', 'UTILITAI6_3',0,' ',1,VALI,0,0.D0)
        END IF

C       => VERIF : COMPOSANTES FOURNIES INCLUSES DANS LA LISTE DES
C       COMPOSANTES DE LA GRANDEUR
        NBCMP=-NBCMP
        CALL ASSERT(NBCMP.GT.0)
        CALL WKVECT('&&CNOAFF.LISTE_COMP','V V K8',NBCMP,JCMP)
        CALL GETVTX('AFFE','NOM_CMP',IOCC,IARG,NBCMP,ZK8(JCMP),NBCMP)
        DO 21 I = 1,NBCMP
          CALL VERICP(ZK8(JCMPMX),ZK8(JCMP+I-1),NCMPMX,IRET)
          IF (IRET.NE.0) THEN
                  VALI = IOCC
                  VALK (1) = GRAN
                  VALK (2) = ZK8(JCMP+I-1)
            CALL U2MESG('F', 'UTILITAI6_4',2,VALK,1,VALI,0,0.D0)
          END IF
   21   CONTINUE
        CALL JEDETR('&&CNOAFF.LISTE_COMP')

 20   CONTINUE
C
C
C --- 3. PREPARATION AVANT LA CREATION DU CHAMP
C     =========================================
C
C  -- COMPOSANTES CONCERNEES : ZK8(JCMPT)
C     ----------------------
      MESCMP = '&&CNOAFF.MES_CMP'
      CALL WKVECT(MESCMP,'V V K8',NCMPMX,JCMPT)
      DO 30 IOCC = 1 , NOCC
        CALL GETVTX ( 'AFFE', 'NOM_CMP', IOCC,IARG,0, KBID, NCMP )
        NCMP=-NCMP
        CALL WKVECT('&&CNOAFF.TMP','V V K8',NCMP,JTMP)
        CALL GETVTX ( 'AFFE', 'NOM_CMP', IOCC,IARG,NCMP,ZK8(JTMP),NCMP)
        IF(IOCC.EQ.1)THEN
          DO 31 I=1,NCMP
             ZK8(JCMPT+I-1)=ZK8(JTMP+I-1)
 31       CONTINUE
          NT=NCMP
        ELSE
           DO 32 I=1,NCMP
              J=INDIK8(ZK8(JCMPT),ZK8(JTMP+I-1),1,NT)
              IF(J.EQ.0)THEN
                ZK8(JCMPT+NT)=ZK8(JTMP+I-1)
                NT=NT+1
              ENDIF
 32        CONTINUE
        ENDIF
        CALL JEDETR('&&CNOAFF.TMP')
 30   CONTINUE
      NBCMPT=NT
C
C
C --- 4. CREATION DU CHAMP
C     =====================
C
      CNOS='&&CNOAFF.CNOS'
      CALL CNSCRE(NOMA,GRAN,NBCMPT,ZK8(JCMPT),'V',CNOS)
C
C
C --- 5. REMPLISSAGE DU CHAMP
C     =======================
C
      MESNOE = '&&CNOAFF.MES_NOEUDS'
      MOTCLE(1) = 'NOEUD'
      MOTCLE(2) = 'GROUP_NO'
      MOTCLE(3) = 'MAILLE'
      MOTCLE(4) = 'GROUP_MA'
      TYPMCL(1) = 'NOEUD'
      TYPMCL(2) = 'GROUP_NO'
      TYPMCL(3) = 'MAILLE'
      TYPMCL(4) = 'GROUP_MA'

      CALL JEVEUO(CNOS//'.CNSV','E',JCNSV)
      CALL JEVEUO(CNOS//'.CNSL','E',JCNSL)

      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8B,IRET)
      CALL DISMOI('F','TYPE_SCA',GRAN,'GRANDEUR',IBID,TSCA,IRET)

      DO 50 IOCC = 1,NOCC
C
C  --    NOEUDS CONCERNES
C        ----------------
         CALL GETVTX ( 'AFFE', 'TOUT', IOCC,IARG,1, KBID, NBTOU )
         IF ( NBTOU .NE. 0 ) THEN
           NBNOE=NBNO
           CALL JEDETR(MESNOE)
           CALL WKVECT(MESNOE,'V V I',NBNOE,JLNO)
           DO 51 I=1,NBNOE
             ZI(JLNO+I-1)=I
 51        CONTINUE
         ELSE
           CALL RELIEM(' ', NOMA, 'NU_NOEUD', 'AFFE', IOCC, 4,
     &                 MOTCLE, TYPMCL, MESNOE, NBNOE )
           CALL JEVEUO ( MESNOE, 'L', JLNO )
         ENDIF
C
C  --    COMPOSANTES CONCERNEES
C        ----------------------
         CALL GETVTX ( 'AFFE', 'NOM_CMP', IOCC,IARG,0, KBID, NCMP )
         NCMP=-NCMP
         CALL JEDETR('&&CNOAFF.CMP_IOCC')
         CALL WKVECT('&&CNOAFF.CMP_IOCC','V V K8',NCMP,JCMP)
         CALL GETVTX ( 'AFFE', 'NOM_CMP', IOCC,IARG,NCMP,ZK8(JCMP),NCMP)
C
C  --    VALEURS
C        -------
         CALL GETVR8 ( 'AFFE', 'VALE'   , IOCC,IARG,0, RBID, NBVAR )
         CALL GETVID ( 'AFFE', 'VALE_F' , IOCC,IARG,0, KBID, NBVAK )
         CALL GETVIS ( 'AFFE', 'VALE_I' , IOCC,IARG,0, IBID, NBVAI )
         CALL GETVC8 ( 'AFFE', 'VALE_C' , IOCC,IARG,0, CBID, NBVAC )

C  --    REMPLISSAGE DES OBJETS .CNSL ET .CNSV
C        -------------------------------------

C   -    TYPE "R" :
         IF(NBVAR.NE.0)THEN
            IF (TSCA.NE.'R') CALL U2MESS('F','UTILITAI6_2')
            NBVAR=-NBVAR
            CALL JEDETR('&&CNOAFF.VAL_IOCC')
            CALL WKVECT('&&CNOAFF.VAL_IOCC','V V R',NBVAR,JVAL)
            CALL GETVR8 ( 'AFFE','VALE',IOCC,IARG,NBVAR,ZR(JVAL),NBVAR)
            DO 52 I=1,NCMP
               ICMP=INDIK8(ZK8(JCMPT),ZK8(JCMP+I-1),1,NBCMPT)
               CALL ASSERT(ICMP.GT.0)
               DO 53 J=1,NBNOE
                 INO=ZI(JLNO+J-1)
                 ZR(JCNSV+NBCMPT*(INO-1)+ICMP-1)=ZR(JVAL+I-1)
                 ZL(JCNSL+NBCMPT*(INO-1)+ICMP-1)=.TRUE.
 53            CONTINUE
 52         CONTINUE
            CALL JEDETR('&&CNOAFF.VAL_IOCC')

C   -    TYPE "I" :
         ELSEIF(NBVAI.NE.0)THEN
            IF (TSCA.NE.'I') CALL U2MESS('F','UTILITAI6_2')
            NBVAI=-NBVAI
            CALL JEDETR('&&CNOAFF.VAL_IOCC')
            CALL WKVECT('&&CNOAFF.VAL_IOCC','V V I',NBVAI,JVAL)
            CALL GETVIS ('AFFE','VALE_I',IOCC,IARG,NBVAI,
     &                   ZI(JVAL),NBVAL)
            DO 54 I=1,NCMP
               ICMP=INDIK8(ZK8(JCMPT),ZK8(JCMP+I-1),1,NBCMPT)
               CALL ASSERT(ICMP.GT.0)
               DO 55 J=1,NBNOE
                 INO=ZI(JLNO+J-1)
                 ZI(JCNSV+NBCMPT*(INO-1)+ICMP-1)=ZI(JVAL+I-1)
                 ZL(JCNSL+NBCMPT*(INO-1)+ICMP-1)=.TRUE.
 55            CONTINUE
 54         CONTINUE
            CALL JEDETR('&&CNOAFF.VAL_IOCC')

C   -    TYPE "C" :
         ELSEIF(NBVAC.NE.0)THEN
            IF (TSCA.NE.'C') CALL U2MESS('F','UTILITAI6_2')
            NBVAC=-NBVAC
            CALL JEDETR('&&CNOAFF.VAL_IOCC')
            CALL WKVECT('&&CNOAFF.VAL_IOCC','V V C',NBVAC,JVAL)
            CALL GETVC8 ('AFFE','VALE_C',IOCC,IARG,NBVAC,
     &                   ZC(JVAL),NBVAC)
            DO 56 I=1,NCMP
               ICMP=INDIK8(ZK8(JCMPT),ZK8(JCMP+I-1),1,NBCMPT)
               CALL ASSERT(ICMP.GT.0)
               DO 57 J=1,NBNOE
                 INO=ZI(JLNO+J-1)
                 ZC(JCNSV+NBCMPT*(INO-1)+ICMP-1)=ZC(JVAL+I-1)
                 ZL(JCNSL+NBCMPT*(INO-1)+ICMP-1)=.TRUE.
 57            CONTINUE
 56         CONTINUE
            CALL JEDETR('&&CNOAFF.VAL_IOCC')

C   -    TYPE "F" :
         ELSEIF(NBVAK.NE.0)THEN
            IF (TSCA.NE.'K') CALL U2MESS('F','UTILITAI6_2')
            NBVAK=-NBVAK
            CALL JEDETR('&&CNOAFF.VAL_IOCC')
            CALL WKVECT('&&CNOAFF.VAL_IOCC','V V K8',NBVAK,JVAL)
            CALL GETVID('AFFE','VALE_F',IOCC,IARG,NBVAK,
     &                  ZK8(JVAL),NBVAK)
            DO 58 I=1,NCMP
               ICMP=INDIK8(ZK8(JCMPT),ZK8(JCMP+I-1),1,NBCMPT)
               CALL ASSERT(ICMP.GT.0)
               DO 59 J=1,NBNOE
                 INO=ZI(JLNO+J-1)
                 ZK8(JCNSV+NBCMPT*(INO-1)+ICMP-1)=ZK8(JVAL+I-1)
                 ZL(JCNSL+NBCMPT*(INO-1)+ICMP-1)=.TRUE.
 59            CONTINUE
 58         CONTINUE
            CALL JEDETR('&&CNOAFF.VAL_IOCC')
         ENDIF

 50   CONTINUE
C
C
C --- 5. PASSAGE DU CHAMP SIMPLE AU CHAMP CLASSIQUE
C     =============================================
C
      IF (INUME.EQ.1) THEN
        PRCHNO = NONUME//'.NUME'
        PROL0='OUI'
      ELSE IF (ICHNO.EQ.1) THEN
        REFE= NOCHNO//'           .REFE'
        CALL JEVEUO(REFE,'L',JREF)
        PRCHNO = ZK24(JREF+1)
        PROL0='OUI'
      ELSE
        PRCHNO=' '
        CALL GETVTX(' ','PROL_ZERO',0,IARG,1,PROL0,IBID)
      END IF

      CALL CNSCNO(CNOS,PRCHNO,PROL0,BASE,CNO,'F',IRET)
C
C
C --- 6. FIN
C     =======
C
      CALL JEDETR(MESCMP)
      CALL JEDETR(CNOS)

      CALL JEDEMA()
      END
