      SUBROUTINE TRCHNO ( IFIC, NOCC )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER    IFIC, NOCC
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C ----------------------------------------------------------------------
C     COMMANDE:  TEST_RESU
C                MOT CLE FACTEUR "CHAM_NO"
C ----------------------------------------------------------------------

      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='TRCHNO')

      INTEGER       IOCC, IBID, IRET, NBCMP,JCMP,N1,N2,N3,N4
      INTEGER       N1R,N2R,N3R,IREFRR, IREFIR,IREFCR
      INTEGER      IREFR, IREFI,IREFC,NREF, NL1, LXLGUT, NL2,NL11,NL22
      REAL*8        EPSI, EPSIR, R8B
      COMPLEX*16    C16B
      CHARACTER*1  TYPRES
      CHARACTER*3  SSIGNE
      CHARACTER*4   TESTOK
      CHARACTER*8  CRIT, NODDL, NOGRNO, NOMMA, TYPTES
      CHARACTER*11 MOTCLE
      CHARACTER*19 CHAM19
      CHARACTER*16 TBTXT(2),TBREF(2)
      CHARACTER*17 NONOEU
      CHARACTER*24 TRAVR,TRAVI,TRAVC,TRAVRR,TRAVIR,TRAVCR
      CHARACTER*200 LIGN1,LIGN2
      INTEGER      IARG
      LOGICAL       LREF
C     ------------------------------------------------------------------
      CALL JEMARQ()

      MOTCLE = 'CHAM_NO'
      TRAVR  = '&&'//NOMPRO//'_TRAVR          '
      TRAVI  = '&&'//NOMPRO//'_TRAVI          '
      TRAVC  = '&&'//NOMPRO//'_TRAVC          '
      TRAVRR = '&&'//NOMPRO//'_TRAVR_R        '
      TRAVIR = '&&'//NOMPRO//'_TRAVI_R        '
      TRAVCR = '&&'//NOMPRO//'_TRAVC_R        '
      IREFI=1
      IREFR=1
      IREFC=1
      IREFIR=1
      IREFRR=1
      IREFCR=1

      DO 100 IOCC = 1,NOCC
        LIGN1  = ' '
        LIGN2  = ' '
        TESTOK = 'NOOK'
        NONOEU = ' '
        NODDL = ' '
        CALL GETVID('CHAM_NO','CHAM_GD',IOCC,IARG,1,CHAM19,N1)
        LIGN1(1:21)='---- '//MOTCLE(1:8)
        LIGN1(22:22)='.'
        LIGN2(1:21)='     '//CHAM19(1:8)
        LIGN2(22:22)='.'

        CALL UTEST3('CHAM_NO',IOCC,TBTXT)

        CALL GETVTX ( 'CHAM_NO', 'NOM_CMP',   IOCC,IARG,1, NODDL, N1 )
        IF( N1 .NE. 0) THEN
           NL1 = LXLGUT(LIGN1)
           NL2 = LXLGUT(LIGN2)
           LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' NOM_CMP'
           LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//NODDL
           LIGN1(NL1+17:NL1+17)='.'
           LIGN2(NL2+17:NL2+17)='.'
        ENDIF
        CALL GETVTX ( 'CHAM_NO', 'VALE_ABS',  IOCC,IARG,1, SSIGNE,N1 )
        IF(SSIGNE.EQ.'OUI')THEN
            NL1 = LXLGUT(LIGN1)
            NL2 = LXLGUT(LIGN2)
            LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' VALE_ABS'
            LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//SSIGNE
            LIGN1(NL1+17:NL1+17)='.'
            LIGN2(NL2+17:NL2+17)='.'
        ENDIF
        CALL GETVR8 ( 'CHAM_NO', 'TOLE_MACHINE', IOCC,IARG,1, EPSI,IRET)
        CALL GETVTX ( 'CHAM_NO', 'CRITERE',   IOCC,IARG,1, CRIT,IRET )

        CALL GETVR8('CHAM_NO','VALE_CALC'    , IOCC,IARG,0,R8B   ,N1)
        CALL GETVIS('CHAM_NO','VALE_CALC_I'  , IOCC,IARG,0,IBID  ,N2)
        CALL GETVC8('CHAM_NO','VALE_CALC_C'  , IOCC,IARG,0,C16B  ,N3)
        IF( N1 .NE. 0) THEN
          NREF=-N1
          TYPRES = 'R'
          CALL JEDETR(TRAVR)
          CALL WKVECT(TRAVR,'V V R',NREF,IREFR)
          CALL GETVR8('CHAM_NO','VALE_CALC', IOCC,IARG,
     &                NREF,ZR(IREFR),IRET)
        ELSEIF( N2 .NE. 0) THEN
          NREF=-N2
          TYPRES = 'I'
          CALL JEDETR(TRAVI)
          CALL WKVECT(TRAVI,'V V I',NREF,IREFI)
          CALL GETVIS('CHAM_NO','VALE_CALC_I', IOCC,IARG,
     &                NREF,ZI(IREFI),IRET)
        ELSEIF( N3 .NE. 0) THEN
          NREF=-N3
          TYPRES = 'C'
          CALL JEDETR(TRAVC)
          CALL WKVECT(TRAVC,'V V C',NREF,IREFC)
          CALL GETVC8('CHAM_NO','VALE_CALC_C', IOCC,IARG,
     &                NREF,ZC(IREFC),IRET)
        ENDIF
C ----------------------------------------------------------------------
        LREF=.FALSE.
        CALL GETVR8('CHAM_NO','PRECISION',IOCC,IARG,1,EPSIR,IRET)
        IF (IRET.NE.0) THEN
           LREF=.TRUE.
           CALL GETVR8('CHAM_NO','VALE_REFE'     ,IOCC,IARG,0,R8B ,N1R)
           CALL GETVIS('CHAM_NO','VALE_REFE_I'   ,IOCC,IARG,0,IBID,N2R)
           CALL GETVC8('CHAM_NO','VALE_REFE_C'   ,IOCC,IARG,0,C16B,N3R)
           IF (N1R.NE.0) THEN
             CALL ASSERT((N1R.EQ.N1))
             NREF=-N1R
             CALL JEDETR(TRAVRR)
             CALL WKVECT(TRAVRR,'V V R',NREF,IREFRR)
             CALL GETVR8('CHAM_NO','VALE_REFE', IOCC,IARG,NREF,
     &                   ZR(IREFRR),IRET)
           ELSEIF (N2R.NE.0) THEN
             CALL ASSERT((N2R.EQ.N2))
             NREF=-N2R
             CALL JEDETR(TRAVIR)
             CALL WKVECT(TRAVIR,'V V I',NREF,IREFIR)
             CALL GETVIS('CHAM_NO','VALE_REFE_I', IOCC,IARG,NREF,
     &                   ZI(IREFIR),IRET)
           ELSEIF (N3R.NE.0) THEN
             CALL ASSERT((N3R.EQ.N3))
             NREF=-N3R
             CALL JEDETR(TRAVCR)
             CALL WKVECT(TRAVCR,'V V C',NREF,IREFCR)
             CALL GETVC8('CHAM_NO','VALE_REFE_C', IOCC,IARG,NREF,
     &                  ZC(IREFCR),IRET)
           ENDIF
        ENDIF
C ----------------------------------------------------------------------

        CALL GETVTX('CHAM_NO','TYPE_TEST',IOCC,IARG,1,TYPTES,N1)

        IF (N1.NE.0) THEN

          NL1 = LXLGUT(LIGN1)
          NL2 = LXLGUT(LIGN2)
          LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' TYPE_TEST'
          LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//TYPTES
          LIGN1(NL1+17:NL1+17)='.'
          LIGN2(NL2+17:NL2+17)='.'

          CALL GETVTX('CHAM_NO','NOM_CMP',IOCC,IARG,0,NODDL,N4)
          IF (N4.EQ.0) THEN
            NL1  = LXLGUT(LIGN1)
            NL11 = LXLGUT(LIGN1(1:NL1-1))
            NL2  = LXLGUT(LIGN2)
            NL22 = LXLGUT(LIGN2(1:NL2-1))
            IF(NL11.LT.80)THEN
              WRITE (IFIC,*) LIGN1(1:NL11)
            ELSEIF(NL11.LT.160)THEN
              WRITE (IFIC,1160) LIGN1(1:80),LIGN1(81:NL11)
            ELSE
              WRITE (IFIC,1200) LIGN1(1:80),LIGN1(81:160),
     &                          LIGN1(161:NL11)
            ENDIF
            IF(NL22.LT.80)THEN
              WRITE (IFIC,*) LIGN2(1:NL22)
            ELSEIF(NL22.LT.160)THEN
              WRITE (IFIC,1160) LIGN2(1:80),LIGN2(81:NL22)
            ELSE
              WRITE (IFIC,1200) LIGN2(1:80),LIGN2(81:160),
     &                          LIGN2(161:NL22)
            ENDIF

            IF (LREF) THEN
              TBREF(1)=TBTXT(1)
              TBREF(2)=TBTXT(2)
              TBTXT(1)='NON_REGRESSION'
            ENDIF
            CALL UTEST1(CHAM19,TYPTES,TYPRES,NREF,TBTXT,ZI(IREFI),
     &           ZR(IREFR),ZC(IREFC),EPSI,CRIT,IFIC,.TRUE.,SSIGNE)
            IF (LREF) THEN
              CALL UTEST1(CHAM19,TYPTES,TYPRES,NREF,TBREF,
     &                    ZI(IREFIR),ZR(IREFRR),ZC(IREFCR),EPSIR,CRIT,
     &                    IFIC,.FALSE.,SSIGNE)
            ENDIF

          ELSE
            NBCMP = -N4
            CALL WKVECT('&&TRCHNO.NOM_CMP','V V K8',NBCMP,JCMP)
            CALL GETVTX('CHAM_NO','NOM_CMP',IOCC,IARG,NBCMP,
     &                  ZK8(JCMP),N4)
            IF (LREF) THEN
              TBREF(1)=TBTXT(1)
              TBREF(2)=TBTXT(2)
              TBTXT(1)='NON_REGRESSION'
            ENDIF
            CALL UTEST4(CHAM19,TYPTES,TYPRES,NREF,TBTXT,ZI(IREFI),
     &                  ZR(IREFR),ZC(IREFC),EPSI,LIGN1,LIGN2,
     &                  CRIT,IFIC,NBCMP,ZK8(JCMP),.TRUE.,SSIGNE)
            IF (LREF) THEN
              CALL UTEST4(CHAM19,TYPTES,TYPRES,NREF,TBREF,ZI(IREFIR),
     &                  ZR(IREFRR),ZC(IREFCR),EPSIR,LIGN1,LIGN2,
     &                  CRIT,IFIC,NBCMP,ZK8(JCMP),.FALSE.,SSIGNE)
            ENDIF
            CALL JEDETR('&&TRCHNO.NOM_CMP')
          END IF

        ELSE

          CALL GETVTX('CHAM_NO','NOM_CMP',IOCC,IARG,1,NODDL,N1)
          CALL DISMOI('F','NOM_MAILLA',CHAM19,'CHAMP',IBID,NOMMA,IRET)
          CALL GETVEM(NOMMA,'NOEUD','CHAM_NO','NOEUD',IOCC,IARG,1,
     &                NONOEU(1:8),N1)
          IF (N1.NE.0) THEN
            NL1 = LXLGUT(LIGN1)
            NL2 = LXLGUT(LIGN2)
            LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' NOEUD'
            LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//NONOEU(1:8)
          ENDIF

          CALL GETVEM(NOMMA,'GROUP_NO','CHAM_NO','GROUP_NO',IOCC,IARG,1,
     &                NOGRNO,N2)
          IF (N2.NE.0) THEN
            NL1 = LXLGUT(LIGN1)
            NL2 = LXLGUT(LIGN2)
            LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' GROUP_NO'
            LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//NOGRNO
          ENDIF

          NL1 = LXLGUT(LIGN1)
          NL2 = LXLGUT(LIGN2)
          WRITE (IFIC,*) LIGN1(1:NL1)
          WRITE (IFIC,*) LIGN2(1:NL2)


          IF (N1.EQ.1) THEN
C            RIEN A FAIRE.
          ELSE
            CALL UTNONO('A',NOMMA,'NOEUD',NOGRNO,NONOEU(1:8),IRET)
            IF (IRET.NE.0) THEN
              WRITE (IFIC,*) TESTOK
              GO TO 100
            END IF
            NONOEU(10:17) = NOGRNO
          END IF

          IF (LREF) THEN
            TBREF(1)=TBTXT(1)
            TBREF(2)=TBTXT(2)
            TBTXT(1)='NON_REGRESSION'
          END IF
          CALL UTESTR(CHAM19,NONOEU,NODDL,NREF,TBTXT,
     &                ZI(IREFI),ZR(IREFR),ZC(IREFC),
     &                TYPRES,EPSI,CRIT,IFIC,.TRUE.,SSIGNE)
          IF (LREF) THEN
            CALL UTESTR(CHAM19,NONOEU,NODDL,NREF,TBREF,
     &                  ZI(IREFIR),ZR(IREFRR),ZC(IREFCR),
     &                  TYPRES,EPSIR,CRIT,IFIC,.FALSE.,SSIGNE)
          ENDIF
        END IF
        WRITE (IFIC,*)' '
 100  CONTINUE

1160  FORMAT(1X,A80,A)
1200  FORMAT(1X,2(A80),A)

      CALL JEDETR(TRAVR)
      CALL JEDETR(TRAVC)
      CALL JEDETR(TRAVI)


      CALL JEDEMA()
      END
