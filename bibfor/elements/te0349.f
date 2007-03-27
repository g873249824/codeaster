      SUBROUTINE TE0349 ( OPTION , NOMTE )
      IMPLICIT   NONE
      CHARACTER*(*)       OPTION , NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
C     CALCUL
C       - DEFORMATIONS GENERALISEES DE POUTRE
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C     ------------------------------------------------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      JEFFG, LMATER, LSECT, LSECT2, LX,
     &             LORIEN, JDEPL, I, J, KP, NBPAR, NNO, NC, NBRES,IRET,
     &             NPG,ITEMP
      PARAMETER   (        NBRES = 3 )
      REAL*8        VALRES(NBRES)
      CHARACTER*2   CODRES(NBRES)
      CHARACTER*4  FAMI
      CHARACTER*8  NOMPAR,NOMRES(NBRES)
      CHARACTER*16 CH16
      REAL*8       UL(14), PGL(3,3), D1B(7,14), DEGE(3,7)
      REAL*8       ZERO, UN, DEUX, TEMP, TREF, E, XNU, ALPHA, G, XL
      REAL*8       A, XIY, XIZ, ALFAY, ALFAZ, EY, EZ, PHIY, PHIZ
      REAL*8       KSI1, D1B3(2,3)
C      REAL*8       A2, XIY2, XIZ2, ALFAY2, ALFAZ2, XJX, XJX2
C     ------------------------------------------------------------------
      DATA NOMRES / 'E' , 'NU' , 'ALPHA'  /
C     ------------------------------------------------------------------
      ZERO   = 0.D0
      UN     = 1.D0
      DEUX   = 2.D0
C     ------------------------------------------------------------------
C
      FAMI = 'RIGI'
      NPG = 3
      IF ( OPTION .EQ. 'DEGE_ELNO_DEPL' ) THEN
         CALL JEVECH ('PDEFOGR', 'E', JEFFG )
      ELSE
         CH16 = OPTION
         CALL U2MESK('F','ELEMENTS2_47',1,CH16)
      ENDIF
C
C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
      CALL JEVECH ('PMATERC', 'L', LMATER)
      DO 10 I = 1, NBRES
         VALRES(I) = ZERO
 10   CONTINUE
C
      CALL RCVARC('F','TEMP','REF',FAMI,1,1,TREF,IRET)
      CALL MOYTEM(FAMI,NPG,1,'+',TEMP)
      NBPAR  = 1
      NOMPAR = 'TEMP'
C
      CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,TEMP,2,
     &              NOMRES,VALRES,CODRES,'FM')
      CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,TEMP,1,
     &              NOMRES(3),VALRES(3),CODRES(3),'  ')
      IF ( CODRES(3) .NE. 'OK' ) VALRES(3) = ZERO
C
      E      = VALRES(1)
      XNU    = VALRES(2)
      ALPHA  = VALRES(3)
      G = E / ( DEUX * ( UN + XNU ) )
C
C     --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS ---
      CALL JEVECH ('PCAGNPO', 'L',LSECT)
      LSECT = LSECT-1
C
C     --- SECTION INITIALE ---
      A     =  ZR(LSECT+ 1)
      XIY   =  ZR(LSECT+ 2)
      XIZ   =  ZR(LSECT+ 3)
      ALFAY =  ZR(LSECT+ 4)
      ALFAZ =  ZR(LSECT+ 5)
C      EY    = -ZR(LSECT+ 6)
C      EZ    = -ZR(LSECT+ 7)
C      XJX   =  ZR(LSECT+ 8)
C
C     --- SECTION FINALE ---
      LSECT2 = LSECT + 11
C      A2     = ZR(LSECT2+ 1)
C      XIY2   = ZR(LSECT2+ 2)
C      XIZ2   = ZR(LSECT2+ 3)
C      ALFAY2 = ZR(LSECT2+ 4)
C      ALFAZ2 = ZR(LSECT2+ 5)
      EY     = -(ZR(LSECT+6)+ZR(LSECT2+6))/DEUX
      EZ     = -(ZR(LSECT+7)+ZR(LSECT2+7))/DEUX
C      XJX2   = ZR(LSECT2+ 8)
C
C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH ('PGEOMER', 'L',LX)
      LX = LX - 1
      XL = SQRT( (ZR(LX+4)-ZR(LX+1))**2
     &  + (ZR(LX+5)-ZR(LX+2))**2 + (ZR(LX+6)-ZR(LX+3))**2 )
      IF( XL .EQ. ZERO ) THEN
         CH16 = ' ?????????'
         CALL U2MESK('F','ELEMENTS2_43',1,CH16(:8))
      ENDIF
C
      IF     ( NOMTE .EQ. 'MECA_POU_D_TG' .OR.
     &         NOMTE .EQ. 'MECA_POU_D_TGM' ) THEN
         NNO = 2
         NC  = 7
         PHIY = E*XIZ*12.D0*ALFAY/ (XL*XL*G*A)
         PHIZ = E*XIY*12.D0*ALFAZ/ (XL*XL*G*A)
      ELSE
         CH16 = NOMTE
         CALL U2MESK('F','ELEMENTS2_42',1,CH16)
      ENDIF
C
C     --- RECUPERATION DES ORIENTATIONS ---
      CALL JEVECH ('PCAORIE', 'L', LORIEN )
      CALL MATROT ( ZR(LORIEN) , PGL )
C
C     --- PASSAGE DES DEPLACEMENTS DANS LE REPERE LOCAL ---
      CALL JEVECH ('PDEPLAR', 'L', JDEPL)
      CALL UTPVGL ( NNO, NC, PGL, ZR(JDEPL), UL )
C
C     --- PASSAGE DE G (CENTRE DE GRAVITE) A C (CENTRE DE TORSION)
      DO 20 I = 1,2
         UL(7* (I-1)+2) = UL(7* (I-1)+2) - EZ*UL(7* (I-1)+4)
         UL(7* (I-1)+3) = UL(7* (I-1)+3) + EY*UL(7* (I-1)+4)
  20  CONTINUE
C
C     --- BOUCLE SUR LES POINTS DE GAUSS
C
      DO 30 KP = 1,3
C
         CALL JSD1FF ( KP, XL, PHIY, PHIZ, D1B )
C
         DO 32 I = 1,NC
            DEGE(KP,I) = ZERO
            DO 34 J = 1,2*NC
               DEGE(KP,I) = DEGE(KP,I) + D1B(I,J)*UL(J)
 34         CONTINUE
 32      CONTINUE
         IF (ALPHA.NE.ZERO)THEN
            DEGE(KP,1) = DEGE(KP,1) - ALPHA*(TEMP-TREF)
         ENDIF
C
 30   CONTINUE
C
C      DO 40 I = 1,NC
C         ZR(JEFFG+I-1)    = DEGE(1,I)
C         ZR(JEFFG+NC+I-1) = DEGE(3,I)
C 40   CONTINUE
C
C     --- POUR LE POINT 1 ---
      KSI1 = -SQRT( 5.D0 / 3.D0 )
      D1B3(1,1) = KSI1*(KSI1-1.D0)/2.0D0
      D1B3(1,2) = 1.D0-KSI1*KSI1
      D1B3(1,3) = KSI1*(KSI1+1.D0)/2.0D0
C     --- POUR LE POINT 2 ---
      KSI1 = SQRT( 5.D0 / 3.D0 )
      D1B3(2,1) = KSI1*(KSI1-1.D0)/2.0D0
      D1B3(2,2) = 1.D0-KSI1*KSI1
      D1B3(2,3) = KSI1*(KSI1+1.D0)/2.0D0
C
      DO 42 I = 1,NC
        DO 44 KP = 1 , 3
          ZR(JEFFG+I-1)    = ZR(JEFFG+I-1)    + DEGE(KP,I)*D1B3(1,KP)
          ZR(JEFFG+NC+I-1) = ZR(JEFFG+NC+I-1) + DEGE(KP,I)*D1B3(2,KP)
 44      CONTINUE
 42   CONTINUE
C
      END
