      SUBROUTINE TE0580 ( OPTION, NOMTE )
      IMPLICIT  NONE
      CHARACTER*16        OPTION, NOMTE
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR REZETTE C.REZETTE 
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
C     ------------------------------------------------------------------
C     OPTION: SIGM_ELNO_COQU ET VARI_ELNO_COQU
C     ------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER    NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO
      INTEGER    JNUMC,JSIGM,ICOU,JNBSPI,IRET
      INTEGER    NBCOU,NBSP,JCONT,NUSP,IPG,ICMP,JGEOM
      INTEGER    NORDO,JTAB(7)
      INTEGER    JVARN,JVARI,NCMP,INO
      REAL*8     VPG(24),VNO(24),PGL(3,3),T2EV(4), T2VE(4), T1VE(9)
C     ------------------------------------------------------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDX,JGANO)
C
      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
C
      CALL JEVECH('PNUMCOR','L',JNUMC)
      ICOU = ZI(JNUMC)
      IF (ICOU.LE.0 .OR. ICOU.GT.NBCOU)
     &                 CALL U2MESS('F','ELEMENTS3_95')
      NORDO = ZI(JNUMC+1)
      NUSP = 3*(ICOU-1) + NORDO +2
C
      IF (OPTION(1:14).EQ.'SIGM_ELNO_COQU') THEN
C                          --------------
        CALL JEVECH('PSIGNOD','E',JSIGM)
        CALL JEVECH('PGEOMER','L',JGEOM)
        CALL TECACH('OON','PCONTRR',7,JTAB,IRET)
        JCONT = JTAB(1)
        NBSP  = JTAB(7)
        IF ( NNO .EQ. 3 ) THEN
          CALL DXTPGL ( ZR(JGEOM), PGL )
        ELSE IF ( NNO .EQ. 4 ) THEN
          CALL DXQPGL ( ZR(JGEOM), PGL )
        END IF
        CALL DXREPE ( PGL, T2EV, T2VE, T1VE )
        DO 10, IPG=1,NPG
          DO 12,ICMP=1,6
            VPG(6*(IPG-1)+ICMP)= ZR( JCONT-1+(IPG-1)*6*NBSP +
     &                              (NUSP-1)*6+ICMP )
 12       CONTINUE
 10     CONTINUE
C       -- PASSAGE GAUSS -> NOEUDS :
        CALL PPGAN2 ( JGANO, 6, VPG ,  VNO )
C       -- PASSAGE DANS LE REPERE DE L'UTILISATEUR :
        CALL DXSIRO ( NNO, T2EV, VNO, ZR(JSIGM) )
C
      ELSE IF (OPTION(1:14).EQ.'VARI_ELNO_COQU') THEN
C                               --------------
        CALL JEVECH('PVARINR','E',JVARN)
        CALL TECACH('OON','PVARIGR',7,JTAB,IRET)
        JVARI = JTAB(1)
        NCMP  = JTAB(6)
        NBSP  = JTAB(7)
        DO 20, ICMP=1,NCMP
          DO 22, IPG=1,NPG
            VPG(IPG) = ZR(JVARI-1+(IPG-1)*NCMP*NBSP+(NUSP-1)*NCMP+ICMP)
 22       CONTINUE
C         -- PASSAGE GAUSS -> NOEUDS :
          CALL PPGAN2 ( JGANO, 1, VPG ,  VNO )
          DO 24, INO=1,NNO
            ZR(JVARN-1 + (INO-1)*NCMP + ICMP) = VNO(INO)
 24       CONTINUE
 20     CONTINUE
C
      END IF
C
      END
