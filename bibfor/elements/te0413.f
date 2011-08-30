      SUBROUTINE TE0413(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16      OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/08/2011   AUTEUR DELMAS J.DELMAS 
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
C
C FONCTIONS REALISEES:
C
C      CALCUL DE LA DENSITE DE DISSIPATION
C      A L'EQUILIBRE POUR LES ELEMENTS DKT
C      .SOIT AUX POINTS D'INTEGRATION : OPTION 'DISS_ELGA'
C      .SOIT L INTEGRALE PAR ELEMENT  : OPTION 'ENER_DISS'
C
C      OPTIONS : 'DISS_ELGA'
C                'ENER_DISS'
C
C ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C ----- DEBUT --- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER    NPGMX
      PARAMETER (NPGMX=4)

      REAL*8   PGL(3,3),COEF,DEUX
      REAL*8   QSI,ETA,XYZL(3,4),JACOB(5),POIDS,CARA(25)
      REAL*8   DISSE(NPGMX),DISSP(NPGMX)
      REAL*8   DISST(NPGMX),DSE,DSP,DST
      REAL*8   R8B(8),EP,SEUIL
      REAL*8   HIC,COEHSD,NBSP

      INTEGER  NDIM,NNO,NNOEL,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER  JGEOM,IPG,IDENER,IMATE
      INTEGER  ICOMPO,ICACOQ,NCMP,JVARI,NBVAR,JTAB(7),IVPG
      INTEGER  JNBSPI,NBCOU,NPGH,IRET,ICOU,IGAUH,ISP,TMA(3,3)

      CHARACTER*16 VALK(2)
      LOGICAL  GRILLE,DKQ,DKG,LKIT

      DEUX   = 2.D0
      DKQ = .FALSE.
      DKG = .FALSE.

      IF (NOMTE(1:8).EQ.'MEDKQU4 ') THEN
        DKQ = .TRUE.
      ELSEIF (NOMTE(1:8).EQ.'MEDKQG4 ') THEN
        DKQ = .TRUE.
        DKG = .TRUE.
      ELSEIF (NOMTE(1:8).EQ.'MEDKTR3 ') THEN
        DKQ = .FALSE.
      ELSEIF (NOMTE(1:8).EQ.'MEDKTG3 ') THEN
        DKQ = .FALSE.
        DKG = .TRUE.
      ELSE
        CALL U2MESK('F','ELEMENTS_34',1,NOMTE)
      END IF

      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOEL,NPG,IPOIDS,ICOOPG,
     &                                         IVF,IDFDX,IDFD2,JGANO)

      GRILLE = .FALSE.
      IF (NOMTE(1:8).EQ.'MEGRDKT ')  GRILLE = .TRUE.

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      IF (NNO.EQ.3) THEN
         CALL DXTPGL ( ZR(JGEOM), PGL )
      ELSE IF (NNO.EQ.4) THEN
         CALL DXQPGL ( ZR(JGEOM), PGL )
      END IF

      LKIT = ZK16(ICOMPO)(1:7).EQ.'KIT_DDI'

      IF ((ZK16(ICOMPO)(1:7).EQ.'GLRC_DM')      .OR.
     &    (ZK16(ICOMPO)(1:11).EQ.'GLRC_DAMAGE') .OR.
     &    (LKIT.AND.(ZK16(ICOMPO+7)(1:7).EQ.'GLRC_DM'))) THEN

      CALL JEVECH('PCACOQU','L',ICACOQ)

      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)

      IF ( DKQ ) THEN
         CALL GQUAD4(XYZL,CARA)
      ELSE
         CALL GTRIA3(XYZL,CARA)
      END IF

      IF(OPTION(1:4) .EQ. 'DISS') THEN
        CALL TECACH ( 'OON', 'PVARIGR', 7, JTAB, IRET )
        JVARI = JTAB(1)
      ELSE IF(OPTION(1:4) .EQ. 'ENER') THEN
        CALL TECACH ( 'OON', 'PVARIPR', 7, JTAB, IRET )
        JVARI = JTAB(1)
      ENDIF

      CALL R8INIR(NPGMX,0.D0,DISSE,1)
      CALL R8INIR(NPGMX,0.D0,DISSP,1)
      CALL R8INIR(NPGMX,0.D0,DISST,1)
      DSE = 0.0D0
      DSP = 0.0D0
      DST = 0.0D0

      IF ( GRILLE ) THEN
        NPGH = 1
        COEF = DEUX
      ELSE
        NPGH = 3
      END IF

      READ (ZK16(ICOMPO-1+2),'(I16)') NBVAR
      EP = ZR(ICACOQ)

      IF (DKG) THEN
        NBCOU = 1
      ELSE
        CALL JEVECH('PNBSP_I','L',JNBSPI)
        NBCOU=ZI(JNBSPI-1+1)

        HIC = EP/NBCOU
      ENDIF

      IF (NBCOU.LE.0) CALL U2MESK('F','ELEMENTS_36',1,ZK16(ICOMPO-1+6))

C ---- BOUCLE SUR LES POINTS D'INTEGRATION :
C      ===================================
      DO 20 IPG = 1, NPG

         QSI = ZR(ICOOPG-1+NDIM*(IPG-1)+1)
         ETA = ZR(ICOOPG-1+NDIM*(IPG-1)+2)
         IF ( DKQ ) THEN
           CALL JQUAD4 ( XYZL, QSI, ETA, JACOB )
           POIDS = ZR(IPOIDS+IPG-1)*JACOB(1)
         ELSE
           POIDS = ZR(IPOIDS+IPG-1)*CARA(7)
         ENDIF

        CALL JEVECH('PMATERC','L',IMATE)
        IF(ZK16(ICOMPO)(1:7).EQ.'GLRC_DM') THEN

          CALL CRGDM(ZI(IMATE),'GLRC_DM         ',TMA,R8B(1),R8B(2),
     &               R8B(3),R8B(4),R8B(5),R8B(6),R8B(7),SEUIL,R8B(8),EP,
     &               .FALSE.)

        ENDIF

C  --    CALCUL DE LA DENSITE D'ENERGIE POTENTIELLE ELASTIQUE :
C        ==========================================================
         IF ((OPTION(1:4).EQ.'DISS') .OR. (OPTION(6:9).EQ.'DISS')) THEN

           NBSP=JTAB(7)

           IF(DKG) THEN
             DISSE(IPG) = (ZR(JVARI-1 + (IPG-1)*NBVAR + 1) +
     &                     ZR(JVARI-1 + (IPG-1)*NBVAR + 2))*SEUIL
             DISSP(IPG) = 0.0D0

             DISST(IPG) = DISSE(IPG) + DISSP(IPG)

             DSE = DSE + DISSE(IPG)*POIDS
             DST = DSE
           ELSE
             DO 80,ICOU = 1,NBCOU
               DO 70,IGAUH = 1,NPGH
                 ISP=(ICOU-1)*NPGH+IGAUH
                 IVPG = ((IPG-1)*NBSP + ISP-1)*NBVAR

C       -- COTE DES POINTS D'INTEGRATION
C       --------------------------------
                IF (IGAUH.EQ.1) THEN
                  IF (GRILLE) THEN
                  ELSE
                    COEF = 1.D0/3.D0
                  END IF
                ELSE IF (IGAUH.EQ.2) THEN
                  COEF = 4.D0/3.D0
                ELSE
                  COEF = 1.D0/3.D0
                END IF
                COEHSD = COEF*HIC/DEUX

                R8B(1) = ZR(JVARI + IVPG)*SEUIL*COEHSD
                DISSE(IPG) = DISSE(IPG) + R8B(1)
                DSE = DSE + R8B(1)*POIDS
 70            CONTINUE
 80          CONTINUE
             DISSP(IPG) = 0.0D0
             DISST(IPG) = DISSE(IPG)
             DST = DSE

           ENDIF

         ENDIF
C
  20  CONTINUE
C
C ---- RECUPERATION DU CHAMP DES DENSITES D'ENERGIE DE DEFORMATION
C ---- ELASTIQUE EN SORTIE
C      -------------------
      IF(OPTION(1:4) .EQ. 'DISS') THEN
        CALL JEVECH('PDISSPG','E',IDENER)
      ELSE IF(OPTION(1:4) .EQ. 'ENER') THEN
        CALL JEVECH('PDISSD1','E',IDENER)
      ENDIF
C
C --- OPTIONS DISS_ELGA
C     ==============================
      IF (OPTION(1:9).EQ.'DISS_ELGA') THEN
         DO 100 IPG = 1, NPG
           ZR(IDENER-1+(IPG-1)*3 +1) = DISST(IPG)
           ZR(IDENER-1+(IPG-1)*3 +2) = DISSE(IPG)
           ZR(IDENER-1+(IPG-1)*3 +3) = DISSP(IPG)
 100     CONTINUE
C
C --- OPTION ENER_ELAS
C     ================
      ELSEIF (OPTION(1:9).EQ.'ENER_DISS') THEN
        ZR(IDENER-1+1) = DST
        ZR(IDENER-1+2) = DSE
        ZR(IDENER-1+3) = DSP
      ENDIF

      ELSE
C      RELATION NON PROGRAMMEE
        VALK(1)=OPTION
        VALK(2) = ZK16(ICOMPO)(1:7)
        CALL U2MESK('A','ELEMENTS4_63',2,VALK)
      ENDIF

      END
