      SUBROUTINE RVRCCM ( T, CMP, NBCP, NBCO, NBSP, NOMTAB,
     +                    IOCC, NCHEFF, I1, IOC, ISD )
      IMPLICIT   NONE
      INTEGER             IOCC, I1, NBCP, NBCO, NBSP, IOC, ISD
      REAL*8              T(*)
      CHARACTER*16        NCHEFF
      CHARACTER*(*)       CMP(*), NOMTAB
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 26/11/2002   AUTEUR CIBHHLV L.VIVAN 
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
C     CALCUL DU TRESCA MOYEN
C     ------------------------------------------------------------------
C IN  T     : R : TABLE DES VALEURS
C IN  CMP   : K : NOM DES COMPOSANTES
C IN  NBCP  : I : NBR DE CMP
C IN  NBCO  : I : NBR DE COUCHES
C IN  NBSP  : I : NBR DE SOUS-POINTS
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER      NBPAR, ILIGN, I10, I20, I30, VALEI(12), N1, ADRVAL,
     +             ISP, ICP, ADRACC, JACC, IK, IR, II, ICO, NBVP, L, M,
     +             NBACC, NBPR, JACES, IAC, IADR, NC
      REAL*8       VALE(6,4), VALER(10), EQUI(6)
      COMPLEX*16   C16B
      LOGICAL      EXIST
      CHARACTER*3  TYPPAR
      CHARACTER*8  INTITU, ACCES, NOMRES, CTYPE
      CHARACTER*24 NOMVAL, NOMACC, NNORES, NOPARA(18), NOMJV, COURBE
      CHARACTER*80 VALEK(11)
C     -----------------------------------------------------------------
      CALL JEMARQ()
C
      NBVP = 3
      L = 6 * NBSP
      M = L * NBCO
C
      CALL GETVTX ( 'ACTION', 'INTITULE', IOCC,1,1, INTITU, N1 )
      CALL GETVID ( 'ACTION', 'CHEMIN'  , IOCC,1,1, COURBE, NC )
C
      NOMVAL = NCHEFF//'.VALACCE'
      NOMACC = NCHEFF//'.TYPACCE'
      NNORES = NCHEFF//'.NOMRESU'
      CALL JEVEUO ( NOMACC, 'L', JACC )
C
      IK = 1
      II = 0
      IR = 0
      NBPAR = 1
      NOPARA(NBPAR) = 'INTITULE'
      VALEK(IK) = INTITU
C
      IF ( NC .NE. 0 ) THEN
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'CHEMIN'
         IK = IK + 1
         VALEK(IK) = COURBE
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'SEGMENT'
         II = II + 1
         VALEI(II) = ISD
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'CMP_CNX'
         II = II + 1
         VALEI(II) = IOC
      ENDIF
C
      IF ( ZK8(JACC) .EQ. 'DIRECT  ' ) THEN
         CALL JEVEUO ( JEXNUM(NCHEFF//'.LSCHEFF',1), 'L', JACC )
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'CHAM_GD'
         IK = IK + 1
         VALEK(IK) = ZK24(JACC)(1:8)
      ELSE
         CALL JEVEUO ( NNORES, 'L', JACC )
         NOMRES = ZK16(JACC)(1:8)
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'RESU'
         IK = IK + 1
         VALEK(IK) = NOMRES
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'NOM_CHAM'
         IK = IK + 1
         VALEK(IK) = ZK16(JACC+1)
         CALL JEVEUO ( JEXNUM(NOMACC,IOCC), 'L', ADRACC )
         CALL JEVEUO ( JEXNUM(NOMVAL,IOCC), 'L', ADRVAL )
         ACCES = ZK8(ADRACC)
         IF ( ACCES(1:1) .EQ. 'O' ) THEN
            NBPAR = NBPAR + 1
            NOPARA(NBPAR) = 'NUME_ORDRE'
            II = II + 1
            VALEI(II) = ZI(ADRVAL + I1-1)
            NOMJV = '&&RVRCCM.NOMS_ACCES'
            CALL RSNOPA ( NOMRES, 0, NOMJV, NBACC, NBPR )
            IF ( NBACC .NE. 0 ) THEN
               CALL JEVEUO ( NOMJV, 'L', JACES )
               DO 10 IAC = 1 , NBACC
                  CALL RSADPA ( NOMRES, 'L', 1, ZK16(JACES-1+IAC),
     +                          ZI(ADRVAL+I1-1), 1, IADR, CTYPE )
                  CALL TBEXIP ( NOMTAB, ZK16(JACES-1+IAC), EXIST,TYPPAR)
                  IF ( .NOT. EXIST ) THEN
                     CALL TBAJPA ( NOMTAB, 1, ZK16(JACES-1+IAC), CTYPE )
                  ENDIF
                  NBPAR = NBPAR + 1
                  NOPARA(NBPAR) = ZK16(JACES-1+IAC)
                  IF ( CTYPE(1:1) .EQ. 'I' ) THEN
                     II = II + 1
                     VALEI(II) = ZI(IADR)
                  ELSEIF ( CTYPE(1:1) .EQ. 'R'   ) THEN
                     IR = IR + 1
                     VALER(IR) = ZR(IADR)
                  ELSEIF ( CTYPE(1:3) .EQ. 'K80' ) THEN
                     IK = IK + 1
                     VALEK(IK) = ZK80(IADR)
                  ELSEIF ( CTYPE(1:3) .EQ. 'K32' ) THEN
                     IK = IK + 1
                     VALEK(IK) = ZK32(IADR)
                  ELSEIF ( CTYPE(1:3) .EQ. 'K24' ) THEN
                     IK = IK + 1
                     VALEK(IK) = ZK24(IADR)
                  ELSEIF ( CTYPE(1:3) .EQ. 'K16' ) THEN
                     IK = IK + 1
                     VALEK(IK) = ZK16(IADR)
                  ELSEIF ( CTYPE(1:2) .EQ. 'K8'  ) THEN
                     IK = IK + 1
                     VALEK(IK) = ZK8(IADR)
                  ENDIF
 10            CONTINUE
               CALL JEDETR ( NOMJV )
            ENDIF
         ELSEIF ( ACCES(1:1) .EQ. 'M' ) THEN
            NBPAR = NBPAR + 1
            NOPARA(NBPAR) = 'NUME_MODE'
            II = II + 1
            VALEI(II) = ZI(ADRVAL + I1-1)
         ELSEIF ( ACCES(1:1) .EQ. 'I' ) THEN
            NBPAR = NBPAR + 1
            NOPARA(NBPAR) = 'INST'
            IR = IR + 1
            VALER(IR) = ZR(ADRVAL + I1-1)
         ELSEIF ( ACCES(1:1) .EQ. 'F' ) THEN
            NBPAR = NBPAR + 1
            NOPARA(NBPAR) = 'FREQ'
            IR = IR + 1
            VALER(IR) = ZR(ADRVAL + I1-1)
         ENDIF
      ENDIF
C
      IF ( NBCO .GT. 1 ) THEN
         CALL TBEXIP ( NOMTAB, 'NUME_COUCHE', EXIST,TYPPAR)
         IF ( .NOT. EXIST ) THEN
            CALL TBAJPA ( NOMTAB, 1, 'NUME_COUCHE', 'I' )
         ENDIF
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'NUME_COUCHE'
      ENDIF
      IF ( NBSP .GT. 1 ) THEN
         CALL TBEXIP ( NOMTAB, 'NUME_GAUSS', EXIST,TYPPAR)
         IF ( .NOT. EXIST ) THEN
            CALL TBAJPA ( NOMTAB, 1, 'NUME_GAUSS', 'I' )
         ENDIF
         NBPAR = NBPAR + 1
         NOPARA(NBPAR) = 'NUME_GAUSS'
      ENDIF
      NBPAR = NBPAR + 1
      NOPARA(NBPAR) = 'TRESCA_MEMBRANE'
      NBPAR = NBPAR + 1
      NOPARA(NBPAR) = 'TRESCA_FLEXION'
      NBPAR = NBPAR + 1
      NOPARA(NBPAR) = 'TRESCA_MFLE_ORIG'
      NBPAR = NBPAR + 1
      NOPARA(NBPAR) = 'TRESCA_MFLE_EXTR'
C
      IF ( NBPAR .GT. 15 ) CALL UTMESS('F','RVRCCM','Y A UN BUG 0')
      IF ( II+2  .GT. 10 ) CALL UTMESS('F','RVRCCM','Y A UN BUG 1')
      IF ( IR+4  .GT. 10 ) CALL UTMESS('F','RVRCCM','Y A UN BUG 2')
      IF ( IK    .GT. 10 ) CALL UTMESS('F','RVRCCM','Y A UN BUG 3')
C
      ILIGN = 0
C
      DO 110 ICO = 1, NBCO
         I20 = L * ( ICO - 1 )
         VALEI(II+1) = ICO
C
         DO 120 ISP = 1, NBSP
            I10 = 6 * ( ISP - 1 )
            VALEI(II+2) = ISP
C
            DO 130 ICP = 1, NBCP
               I30 = M * ( ICP - 1 )
C              --- COMPOSANTE MOMENT_0 ---
               VALE(ICP,1) = T(I30+I20+I10+1)
C              --- COMPOSANTE MOMENT_1 ---
               VALE(ICP,2) = 0.5D0 * T(I30+I20+I10+2)
C              --- COMPOSANTE MOYE_INT ---
               VALE(ICP,3) = T(I30+I20+I10+5)
C              --- COMPOSANTE MOYE_EXT ---
               VALE(ICP,4) = T(I30+I20+I10+6)
 130        CONTINUE
C
            CALL FGEQUI ( VALE(1,1), 'SIGM', NBVP, EQUI )
            VALER(IR+1) = EQUI(2)
C
            CALL FGEQUI ( VALE(1,2), 'SIGM', NBVP, EQUI )
            VALER(IR+2) = EQUI(2)
C
            CALL FGEQUI ( VALE(1,3), 'SIGM', NBVP, EQUI )
            VALER(IR+3) = EQUI(2)
C
            CALL FGEQUI ( VALE(1,4), 'SIGM', NBVP, EQUI )
            VALER(IR+4) = EQUI(2)
C
            CALL TBAJLI ( NOMTAB, NBPAR, NOPARA,
     +                            VALEI, VALER, C16B, VALEK, ILIGN )
C
 120     CONTINUE
 110  CONTINUE
C
      CALL JEDEMA()
      END
