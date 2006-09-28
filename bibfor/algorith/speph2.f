      SUBROUTINE SPEPH2 ( MOVREP, NAPEXC, NBMODE, NBPF, INTMOD, TABLE,
     &                    SPECMR, SPECMI )
      IMPLICIT   NONE
      INTEGER             NAPEXC, NBMODE, NBPF
      REAL*8              SPECMR(NBPF,*), SPECMI(NBPF,*)
      LOGICAL             INTMOD
      CHARACTER*8         TABLE
      CHARACTER*16        MOVREP
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       IBID, NBPAR, IVAL(2), IDEB1, IFIN1, I, J, IMI, IMJ,
     &              IDEB, ISJ, IRET, IFON, IF1
      PARAMETER   ( NBPAR = 2 )
      REAL*8        R8B
      CHARACTER*8   K8B
      CHARACTER*16  NOPAR(NBPAR)
      CHARACTER*24  NOMFON
      COMPLEX*16    C16B
C
      DATA NOPAR / 'NUME_ORDRE_I' , 'NUME_ORDRE_J' /
C     ------------------------------------------------------------------
C
      IF ( MOVREP .EQ. 'ABSOLU' ) THEN
         IDEB1 = 1
         IFIN1 = NAPEXC+NBMODE
      ELSEIF ( MOVREP .EQ. 'RELATIF' ) THEN
         IDEB1 = NAPEXC+1
         IFIN1 = NAPEXC+NBMODE
      ELSEIF ( MOVREP .EQ. 'DIFFERENTIEL' ) THEN
         IDEB1 = 1
         IFIN1 = NAPEXC
      ENDIF
C
      J = 0
      DO 30 IMJ = IDEB1 , IFIN1
         J = J + 1
C
         IVAL(2) = IMJ
C
         IDEB = IMJ
         IF ( INTMOD ) IDEB = IDEB1
C
         I = 0
         DO 40 IMI = IDEB , IMJ
            I = I + 1
C
            IVAL(1) = IMI
C
            CALL TBLIVA ( TABLE, NBPAR, NOPAR, IVAL, R8B, C16B, K8B,
     &        K8B, R8B, 'FONCTION', K8B, IBID, R8B, C16B, NOMFON, IRET )
            IF ( IRET .NE. 0 ) CALL U2MESS('F','MODELISA2_91')
C
            CALL JEVEUO ( NOMFON(1:19)//'.VALE', 'L', IFON )
            ISJ = J * ( J - 1 ) / 2 + I
C
            DO 50 IF1 = 1 , NBPF
               SPECMR(IF1,ISJ) = ZR(IFON+NBPF+ (IF1-1)*2)
               SPECMI(IF1,ISJ) = ZR(IFON+NBPF+ (IF1-1)*2+1)
 50         CONTINUE
 40      CONTINUE
C
 30   CONTINUE
      END
