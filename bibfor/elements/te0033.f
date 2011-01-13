      SUBROUTINE TE0033 ( OPTION, NOMTE )
      IMPLICIT  NONE
      CHARACTER*16        OPTION, NOMTE
C     ------------------------------------------------------------------
C MODIF ELEMENTS  DATE 13/01/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     CALCUL DE CONTRAINTES, DEFORMATIONS, EFFORTS ET DEFORMATIONS
C     GENERALISES POUR LES ELEMENTS DKT, DKTG, DST, DKQ, DSQ ET Q4G
C     POUR UN MATERIAU ISOTROPE OU MULTICOUCHE
C         OPTIONS TRAITEES  ==>  SIEF_ELGA
C                                EFGE_ELNO_DEPL
C                                SIGM_ELNO_DEPL
C                                EPSI_ELNO_DEPL
C                                DEGE_ELNO
C     IN   K16   OPTION : NOM DE L'OPTION A CALCULER
C     IN   K16   NOMTE  : NOM DU TYPE_ELEMENT
C     ------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER       NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO
      INTEGER       I, IBID, IC, IER, INIV, IRET, JCARA, KPG,
     &              JDEPG, JEFFG, JGEOM, JMATE, JNUMCO, JSIGM,
     &              NP, MULTIC, JTAB(8), IPG,ICONTP,
     &              JNBSPI, NBCOU, NBSP,ISP, IEFF, ICOU
      REAL*8        ZERO, X3I,EPI,EPTOT,EXCEN
      REAL*8        PGL(3,3), XYZL(3,4), VALPU(2),R8BID
      REAL*8        DEPL(24), DEPLR(24), DEPLI(24), SIGMR(32),SIGMI(32)
      REAL*8        DEPGR(24), DEPGI(24), SIGMRL(32), SIGMIL(32)
      REAL*8        EFFGT(32), SIGTOT(24), SIETOT(72)
      REAL*8        T2EV(4), T2VE(4), T1VE(9)
      LOGICAL       LTEATT
      CHARACTER*2   CODRET,VAL
      CHARACTER*4   FAMI
      CHARACTER*8   NOMPU(2),NOMRES
      CHARACTER*16  PHENOM
      CHARACTER*3 NUM
C     ------------------------------------------------------------------
C
      IF (OPTION(6:9).EQ.'ELNO') THEN
        FAMI = 'NOEU'
      ELSE
        FAMI = 'RIGI'
      ENDIF
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO)
C
      IF (OPTION.NE.'SIEF_ELGA  ' .AND.
     &    OPTION.NE.'EFGE_ELNO_DEPL  ' .AND.
     &    OPTION.NE.'SIGM_ELNO_DEPL  ' .AND.
     &    OPTION.NE.'EPSI_ELNO_DEPL  ' .AND.
     &    OPTION.NE.'DEGE_ELNO  ') THEN
CC OPTION DE CALCUL INVALIDE
        CALL ASSERT(.FALSE.)
      END IF
      ZERO   = 0.0D0

      DO 10 I = 1,32
        EFFGT(I) = ZERO
   10 CONTINUE

      DO 20 I = 1,24
        SIGTOT(I) = ZERO
   20 CONTINUE

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PMATERC','L',JMATE)
      CALL JEVECH('PCACOQU','L',JCARA)
C      EPAIS  = ZR(JCARA)

      IF (OPTION(8:9).EQ.'GA') THEN
        NP = NPG
      ELSE IF (OPTION(8:9).EQ.'NO') THEN
        NP = NNO
      END IF

      IF (NNO.EQ.3) THEN
        CALL DXTPGL(ZR(JGEOM),PGL)
      ELSE IF (NNO.EQ.4) THEN
        CALL DXQPGL(ZR(JGEOM),PGL)
      END IF

      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)
      CALL DXREPE( PGL,T2EV, T2VE, T1VE )

      CALL JEVECH('PDEPLAR','L',JDEPG)
      CALL UTPVGL(NNO,6,PGL,ZR(JDEPG),DEPL)


C     ---------- CONTRAINTES ET DEFORMATIONS --------------------------

C          ----------------------------
      IF ( OPTION(1:9) .EQ. 'SIGM_ELNO' ) THEN
C          ----------------------------
        CALL JEVECH('PNUMCOR','L',JNUMCO)
        IC = ZI(JNUMCO)
        INIV = ZI(JNUMCO+1)
        CALL JEVECH('PCONTRR','E',JSIGM)

C ---   CALCUL DES CONTRAINTES VRAIES (I.E. SIG_MECA - SIG_THERM)
C ---   AUX POINTS DE CALCUL
C       --------------------
        CALL DXSIGV(FAMI,NOMTE,OPTION,XYZL,PGL,IC,
     &              INIV,DEPL,SIGTOT)

C ---   PASSAGE DES CONTRAINTES DU REPERE INTRINSEQUE
C ---   A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C       ---------------------------------------
        CALL DXSIRO(NP,T2EV,SIGTOT,ZR(JSIGM))

C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'EPSI_ELNO' ) THEN
C               ----------------------------
        CALL JEVECH('PDEFORR','E',JSIGM)
        CALL JEVECH('PNUMCOR','L',JNUMCO)
        IC = ZI(JNUMCO)
        INIV = ZI(JNUMCO+1)

        IF (NOMTE.EQ.'MEDKTR3 ' ) THEN
          CALL DKTCOD(XYZL,OPTION,PGL,IC,INIV,DEPL,SIGTOT,
     &                MULTIC)
        ELSE IF (NOMTE.EQ.'MEDKTG3 ') THEN
          CALL DKTGCO(XYZL,OPTION,PGL,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDSTR3 ') THEN
          CALL DSTCOD(XYZL,OPTION,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDKQU4 ') THEN
          CALL DKQCOD(XYZL,OPTION,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDKQG4 ') THEN
          CALL DKQGCO(XYZL,OPTION,PGL,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEDSQU4 ') THEN
          CALL DSQCOD(XYZL,OPTION,PGL,IC,INIV,DEPL,SIGTOT)
        ELSE IF (NOMTE.EQ.'MEQ4QU4 ') THEN
          CALL Q4GCOD(XYZL,OPTION,PGL,IC,INIV,DEPL,SIGTOT)
        END IF

C ---     PASSAGE DES DEFORMATIONS  DU REPERE INTRINSEQUE
C ---     A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C         ---------------------------------------
        CALL DXSIRO(NP,T2EV,SIGTOT,ZR(JSIGM))
C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'SIEF_ELGA' ) THEN
C               ----------------------------

        CALL JEVECH('PCONTRR','E',JSIGM)
C
        CALL RCCOMA ( ZI(JMATE), 'ELAS', PHENOM, CODRET )
        IF ( PHENOM.EQ.'ELAS'      .OR.
     &       PHENOM.EQ.'ELAS_ORTH' .OR.
     &       PHENOM.EQ.'ELAS_ISTR' ) THEN
           CALL DXSIEF ( NOMTE, XYZL, DEPL, ZI(JMATE), PGL, ZR(JSIGM) )

        ELSEIF ( PHENOM.EQ.'ELAS_COQUE' ) THEN

           CALL JEVECH('PNBSP_I','L',JNBSPI)
           NBCOU = ZI(JNBSPI)
           IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_46')

           IF ( NOMTE.EQ.'MEDKTR3 ' .OR.
     &          NOMTE.EQ.'MEDKTG3 ' ) THEN
              CALL DKTSIE(FAMI,XYZL,OPTION,PGL,DEPL,ZR(JSIGM))
           ELSE IF (NOMTE.EQ.'MEDSTR3 ' ) THEN
              CALL DSTCOL(FAMI,XYZL,OPTION,PGL,NBCOU,3,DEPL,
     &                    ZR(JSIGM),NPG)
           ELSE IF (NOMTE.EQ.'MEDKQU4 ' .OR.
     &              NOMTE.EQ.'MEDKQG4 ' ) THEN
              CALL DKQSIE(FAMI,XYZL,OPTION,PGL,DEPL,ZR(JSIGM))
           ELSE IF (NOMTE.EQ.'MEDSQU4 ' ) THEN
              CALL DSQCOL(FAMI,XYZL,OPTION,PGL,NBCOU,3,DEPL,
     &                    ZR(JSIGM),NPG)
           ELSE IF (NOMTE.EQ.'MEQ4QU4 ' ) THEN
              CALL Q4GCOL(FAMI,XYZL,OPTION,PGL,NBCOU,3,DEPL,
     &                    ZR(JSIGM),NPG)
           END IF
C
        ELSEIF ( PHENOM.EQ.'ELAS_COQMU' ) THEN
C
C       EXCEPTION POUR LES MULTICOUCHES COMP�SITES : ON STOCKE DANS UNE
C       SEULE COUCHE LES CONTRAINTES HOMOGENEISEES
C
            EXCEN = ZR(JCARA+5-1)
            CALL JEVECH('PNBSP_I','L',JNBSPI)
            NBCOU = ZI(JNBSPI)
            IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_46')

            CALL DXEFGV(NOMTE,OPTION,XYZL,PGL,DEPL,EFFGT)
            CALL EXCENT(OPTION,NOMTE,NNO,EFFGT)
            CALL TECACH('OON','PCONTRR',7,JTAB,IRET)
            NPG=JTAB(3)
            NBSP=JTAB(7)
C RECALCUL DE L'EPAISSEUR
            ICOU=0
            EPTOT=0.D0
 215        CONTINUE
            ICOU=ICOU+1
            CALL CODENT(ICOU,'G',NUM)
            CALL CODENT(1,'G',VAL)
            NOMRES = 'C'//NUM//'_V'//VAL
            CALL RCVALA(ZI(JMATE),' ','ELAS_COQMU',0,' ',R8BID,
     &         1,NOMRES,EPI,CODRET,' ')
            IF (CODRET.EQ.'OK') THEN
                EPTOT=EPTOT+EPI
                GOTO 215
            ENDIF
C EN PRINCIPE, EPTOT=EPAIS LUE DANS CARA_ELEM. MAIS PAS TOUJOURS
C CAR DANS HPLA100G,H ET SSLS113A, ON DECLARE EPAIS=0
            DO 216 IPG=1,NPG
               IEFF=8*(IPG-1)
               DO 219 I = 1,6
                  SIGTOT(I) = 0.D0
  219          CONTINUE
               DO 217 ISP=1,NBSP
                  IF (ISP.EQ.1) THEN
                     X3I = EXCEN - EPTOT/2.D0
                  ELSE IF (ISP.EQ.2) THEN
                     X3I = EXCEN
                  ELSE IF (ISP.EQ.3) THEN
                     X3I = EXCEN + EPTOT/2.D0
                  END IF
C                 SIGXX=NXX/E + Z*MXX*12:E**3
C                 SIGYY=NYY/E + Z*MYY*12:E**3
                  DO 218 I = 1,2
                     SIGTOT(I) = EFFGT(IEFF+I)/EPTOT +
     &                       X3I*EFFGT(IEFF+3+I)/EPTOT/EPTOT/EPTOT*12.D0
 218              CONTINUE
C                 SIGXY=NXY/E + Z*MXY*12:E**3
                  SIGTOT(4) = EFFGT(IEFF+3)/EPTOT +
     &                    X3I*EFFGT(IEFF+3+3)/EPTOT/EPTOT/EPTOT*12.D0
                  ICONTP=JTAB(1)+(6*NBSP)*(IPG-1)+6*(ISP-1)
                  CALL DCOPY(6,SIGTOT,1,ZR(ICONTP),1)
217            CONTINUE
216         CONTINUE

        ELSE
           CALL U2MESK('F','ELEMENTS2_76',1,PHENOM)
        END IF
C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'EFGE_ELNO' ) THEN
C               ----------------------------
C ---     CALCUL DES EFFORTS GENERALISES VRAIS
C ---     AUX POINTS DE CALCUL
C         --------------------
        CALL DXEFGV(NOMTE,OPTION,XYZL,PGL,DEPL,EFFGT)
C
C ---    PRISE EN COMPTE DE L'EXCENTREMENT SI ON CALCULE LES
C ---    EFFORTS GENERALISES SUR UN FEUILLET DE REFERENCE DIFFERENT
C ---    DU FEUILLET DU MAILLAGE (I.E. EN PEAU SUP, INF OU MOY)
C        ------------------------------------------------------
C
        CALL EXCENT(OPTION,NOMTE,NNO,EFFGT)

C ---   PASSAGE DES EFFORTS GENERALISES DU REPERE INTRINSEQUE
C ---   A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C       ---------------------------------------
        CALL JEVECH('PEFFORR','E',JEFFG)
        CALL DXEFRO(NP,T2EV,EFFGT,ZR(JEFFG))

C
C               ----------------------------
      ELSE IF ( OPTION(1:9) .EQ. 'DEGE_ELNO' ) THEN
C               ----------------------------

        CALL JEVECH('PDEFOGR','E',JEFFG)


        IF (NOMTE.EQ.'MEDKTR3 ' .OR.
     &     NOMTE.EQ.'MEDKTG3 ' ) THEN
          CALL DKTEDG(XYZL,OPTION,PGL,DEPL,EFFGT,MULTIC)
        ELSE IF (NOMTE.EQ.'MEDSTR3 ' ) THEN
          CALL DSTEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEDKQU4 ' .OR.
     &           NOMTE.EQ.'MEDKQG4 ' ) THEN
          CALL DKQEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEDSQU4 ' ) THEN
          CALL DSQEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        ELSE IF (NOMTE.EQ.'MEQ4QU4 ' ) THEN
          CALL Q4GEDG(XYZL,OPTION,PGL,DEPL,EFFGT)
        END IF
C
C ---    PRISE EN COMPTE DE L'EXCENTREMENT SI ON CALCULE LES
C ---    EFFORTS GENERALISES SUR UN FEUILLET DE REFERENCE DIFFERENT
C ---    DU FEUILLET DU MAILLAGE (I.E. EN PEAU SUP, INF OU MOY)
C        ------------------------------------------------------
          CALL EXCENT(OPTION,NOMTE,NNO,EFFGT)
C
C ---     PASSAGE DES DEFORMATIONS GENERALISEES DU REPERE INTRINSEQUE
C ---     A L'ELEMENT AU REPERE LOCAL DE LA COQUE
C         ---------------------------------------
        CALL DXEFRO(NP,T2EV,EFFGT,ZR(JEFFG))

      END IF
      END
