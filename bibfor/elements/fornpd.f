      SUBROUTINE FORNPD ( OPTION , NOMTE )
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16   OPTION , NOMTE
C     ----------------------------------------------------------------
C     CALCUL DES OPTIONS DES ELEMENTS DE COQUE 3D
C     OPTION : FORC_NODA (REPRISE)
C          -----------------------------------------------------------
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*2  CODRET(26)
      CHARACTER*8   NOMRES(26), NOMPAR
      CHARACTER*10  PHENOM
      CHARACTER*24  DESI , DESR
      INTEGER NB1,NB2,NDDLE,NPGE,NPGSR,NPGSN,IND,JNBSPI
      INTEGER ITAB(8),IRET
C     REAL*8 XI(3,9)
      REAL*8 VECTA(9,2,3),VECTN(9,3),VECTPT(9,2,3),VECPT(9,3,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 HSFM(3,9),HSS(2,9),HSJ1M(3,9),HSJ1S(2,9)
      REAL*8 BTDM(4,3,42),BTDS(4,2,42)
      REAL*8 HSF(3,9),HSJ1FX(3,9),WGT
      REAL*8 BTDF(3,42),BTILD(5,42)
      REAL*8 EPAIS
      REAL*8 VALRES(26),ROTFM(9),TEMPGA(8)
      REAL*8 DEPLM(42),EFFINT(42),VECL(48),VECLL(51)
      REAL*8 EPSI(5)
      REAL*8 SGMTD(5),TMOY(9),TINF(9),TSUP(9)
      REAL*8 YOUNG,NU,ALPHA
      REAL*8 KSI3S2
      REAL*8 SIGTMP(5),FTEMP(40)
      PARAMETER ( NPGE=3 )
C DEB
C
C     RECUPERATION DES OBJETS
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESI',' ', LZI )
      NB1  =ZI(LZI-1+1)
      NB2  =ZI(LZI-1+2)
      NPGSR=ZI(LZI-1+3)
      NPGSN=ZI(LZI-1+4)
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ', LZR )
C
      CALL TECACH('ONN','PCOMPOR',1,ICOMPO,IRET)
      IF(ICOMPO.EQ.0) THEN
           NBCOU = 1
      ELSE
        CALL JEVECH('PCOMPOR','L',ICOMPO)
        CALL JEVECH('PNBSP_I','L',JNBSPI)
        NBCOU=ZI(JNBSPI-1+1)
        IF (NBCOU.LE.0)
     &    CALL U2MESS('F','ELEMENTS_12')
        IF (NBCOU.GT.10)
     &    CALL U2MESS('F','ELEMENTS_13')
      ENDIF
      CALL JEVECH ('PGEOMER' , 'L' , JGEOM)
      CALL JEVECH ('PCACOQU' , 'L' , JCARA)
      EPAIS = ZR(JCARA)
      ZMIN = -EPAIS/2.D0
      HIC  =  EPAIS/NBCOU
C
      CALL JEVECH('PMATERC','L',IMATE)
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      CALL TECACH ('ONN','PTEMPER',8,ITAB,IRET)
      ITEMPE=ITAB(1)
      IF (OPTION.EQ.'FORC_NODA') THEN
         CALL JEVECH('PCONTMR','L',ICONTM)
      ELSEIF (OPTION.EQ.'REFE_FORC_NODA') THEN
         CALL JEVECH('PREFCO','L',ICONTM)
      ENDIF
      CALL JEVECH('PDEPLMR','L',IDEPLM)
C
      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)
C
      IF ( PHENOM .EQ. 'ELAS' )  THEN
         NBV=2
         NOMRES(1)='E'
         NOMRES(2)='NU'
      ELSE
         CALL U2MESS('F','ELEMENTS_42')
      ENDIF
C
      IF ( ITEMPE .EQ. 0 ) THEN
         NBPAR  = 0
         NOMPAR = ' '
         VALPAR = 0.D0
      ELSE
         NBPAR  = 1
         NOMPAR = 'TEMP'
         TPG1   = 0.D0
         DO 21 I = 1,NB2
            CALL DXTPIF(ZR(ITEMPE+3*(I-1)),ZL(ITAB(8)+3*(I-1)))
            TMOY(I) = ZR(ITEMPE  +3*(I-1))
            TINF(I) = ZR(ITEMPE+1+3*(I-1))
            TSUP(I) = ZR(ITEMPE+2+3*(I-1))
            TPG1 = TPG1 + TMOY(I) +
     &     ( TSUP(I) + TINF(I) - 2*TMOY(I) ) / 6.D0
 21      CONTINUE
         VALPAR = TPG1 / NB2
      ENDIF
C
      CALL RCVALA(ZI(IMATE),' ',PHENOM,NBPAR,NOMPAR,VALPAR,NBV,NOMRES,
     &                                            VALRES,CODRET, 'FM')
C
      CALL VECTAN(NB1,NB2,ZR(JGEOM),ZR(LZR),VECTA,VECTN,VECTPT)
C
      CALL TRNDGL(NB2,VECTN,VECTPT,ZR(IDEPLM),DEPLM,ROTFM)
C
      DO 35 I=1,5*NB1+2
         EFFINT(I)=0.D0
 35   CONTINUE
C
      IF  (OPTION.EQ.'REFE_FORC_NODA') THEN
         CALL R8INIR(NB1*5,0.D0,FTEMP,1)
      ENDIF

      KWGT=0
      KPGS=0
      DO 100 ICOU=1,NBCOU
      DO 100 INTE=1,NPGE
          IF (INTE.EQ.1) THEN
            ZIC = ZMIN + (ICOU-1)*HIC
            COEF = 1.D0/3.D0
          ELSEIF(INTE.EQ.2) THEN
            ZIC = ZMIN + HIC/2.D0 + (ICOU-1)*HIC
            COEF = 4.D0/3.D0
          ELSE
            ZIC = ZMIN + HIC + (ICOU-1)*HIC
            COEF = 1.D0/3.D0
          ENDIF
          KSI3S2=ZIC/HIC
          HEPA = HIC
C
C   CALCUL DE BTDMR, BTDSR : M=MEMBRANE , S=CISAILLEMENT , R=REDUIT
C
        DO 120 INTSR=1,NPGSR
           CALL MAHSMS(0,NB1,ZR(JGEOM),KSI3S2,INTSR,ZR(LZR),HEPA,VECTN,
     &                                             VECTG,VECTT,HSFM,HSS)
C
           CALL HSJ1MS(HEPA,VECTG,VECTT,HSFM,HSS,HSJ1M,HSJ1S)
C
           CALL BTDMSR(NB1,NB2,KSI3S2,INTSR,ZR(LZR),HEPA,
     &                                     VECTPT,HSJ1M,HSJ1S,BTDM,BTDS)
 120    CONTINUE
C
        DO 150 INTSN=1,NPGSN
C
          CALL MAHSF(1,NB1,ZR(JGEOM),KSI3S2,INTSN,ZR(LZR),HEPA,VECTN,
     &                                                  VECTG,VECTT,HSF)
C
          CALL HSJ1F(INTSN,ZR(LZR),HEPA,VECTG,VECTT,HSF,KWGT,HSJ1FX,WGT)
C
          WGT=COEF*WGT
C
          CALL BTDFN(1,NB1,NB2,KSI3S2,INTSN,ZR(LZR),HEPA,
     &                                               VECTPT,HSJ1FX,BTDF)
C
          CALL BTDMSN(1,NB1,INTSN,NPGSR,ZR(LZR),BTDM,BTDF,BTDS,BTILD)
C
          KPGS = KPGS + 1
          K1=6*(KPGS-1)
C
        IF  (OPTION.EQ.'FORC_NODA') THEN
          SGMTD(1)=ZR(ICONTM-1+K1+1)
          SGMTD(2)=ZR(ICONTM-1+K1+2)
          SGMTD(3)=ZR(ICONTM-1+K1+4)
          SGMTD(4)=ZR(ICONTM-1+K1+5)
          SGMTD(5)=ZR(ICONTM-1+K1+6)
C
          CALL EPSEFF('EFFORI',NB1,X,BTILD,SGMTD,X,WGT,EFFINT)
C
        ELSEIF  (OPTION.EQ.'REFE_FORC_NODA') THEN

C      CALCUL DES FORCES NODALES DE REFERENCE
C      EN AFFECTANT LA VALEUR SIGM_REFE A CHAQUE CMP SUCCESSIVEMENT
C      POUR CHAQUE POINT D'INTEGRATION

          CALL R8INIR(5,0.D0,SIGTMP,1)

          DO 155 I=1,5
             SIGTMP(I)=ZR(ICONTM)
             CALL EPSEFF('EFFORI',NB1,X,BTILD,SIGTMP,X,WGT,EFFINT)
             SIGTMP(I)=0.D0
             DO 156 J=1,NB1*5
                FTEMP(J) = FTEMP(J)+ABS(EFFINT(J))
 156         CONTINUE
 155      CONTINUE

        ENDIF
C
 150    CONTINUE
 100  CONTINUE
C
C      ON PREND LA VALEUR MOYENNE DES FORCES NODALES DE REFERENCE

      IF  (OPTION.EQ.'REFE_FORC_NODA') THEN
         NVAL=NBCOU*NPGE*NPGSN*5
         CALL DAXPY(NB1*5,1.D0/NVAL,FTEMP,1,EFFINT,1)
      ENDIF


C-- EXPANSION DU CHAMP
      CALL VEXPAN(NB1,EFFINT,VECL)
C
      DO 17 I=1,6*NB1
         VECLL(I)=VECL(I)
 17   CONTINUE
         VECLL(6*NB1+1)=EFFINT(5*NB1+1)
         VECLL(6*NB1+2)=EFFINT(5*NB1+2)
C        VECLL(6*NB1+3)=0.D0
C
C     ICI PAS DE CONTRIBUTION DES DDL DE LA ROTATION FICTIVE DANS EFFINT
C
      ZERO=0.D0
      DO 18 I=1,NB1
         VECLL(6*I)=ZERO*ROTFM(I)
 18   CONTINUE
         I=NB2
         VECLL(6*NB1+3)=ZERO*ROTFM(NB2)
C
C     TRANFORMATION DANS REPERE GLOBAL PUIS STOCKAGE
C
      DO 105 IB=1,NB2
      DO 106  I=1,2
      DO 107  J=1,3
         VECPT(IB,I,J)=VECTPT(IB,I,J)
 107  CONTINUE
 106  CONTINUE
         VECPT(IB,3,1)=VECTN(IB,1)
         VECPT(IB,3,2)=VECTN(IB,2)
         VECPT(IB,3,3)=VECTN(IB,3)
 105  CONTINUE
C
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      CALL TRNFLG(NB2,VECPT,VECLL,ZR(IVECTU))
C
      END
