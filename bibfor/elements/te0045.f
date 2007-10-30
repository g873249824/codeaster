      SUBROUTINE TE0045(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16      OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/10/2007   AUTEUR BOYERE E.BOYERE 
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
C     CALCUL DES CARACTERISTIQUES DE STRUCTURES POUR LES ELEMENTS
C     DISCRETS : MECA_DIS_T_N      MECA_DIS_T_L
C                MECA_DIS_TR_N     MECA_DIS_TR_L
C                MECA_2D_DIS_T_N   MECA_2D_DIS_T_L
C                MECA_2D_DIS_TR_N  MECA_2D_DIS_TR_L
C     ------------------------------------------------------------------
C IN  : OPTION : NOM DE L'OPTION A CALCULER
C IN  : NOMTE  : NOM DU TYPE_ELEMENT
C     ------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C     ------------------------------------------------------------------
      CHARACTER*16 CH16
      REAL*8       MAT(78), ZERO, UN, DEUX, TROIS, PGL(3,3)
C     ------------------------------------------------------------------
C
      ZERO  = 0.D0
      DEUX  = 2.D0
      TROIS = 3.D0
C
      IF (OPTION.EQ.'MASS_INER')   THEN
         CALL JEVECH ('PCADISM' ,'L',LMASS )
         CALL JEVECH ('PGEOMER' ,'L',LCOOR )
         CALL JEVECH ('PCAORIE' ,'L',LORIEN)
         CALL JEVECH ('PMASSINE','E',LCASTR)
         DO 2 I = 0,9
            ZR(LCASTR+I) = ZERO
 2       CONTINUE
         CALL MATROT ( ZR(LORIEN) , PGL )
C
C        ============ ELEMENT DE TYPE POI1 ============
C
         IF ( NOMTE. EQ. 'MECA_DIS_T_N' ) THEN
            NNO = 1
            NC  = 3
            N   = 6
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UTPSLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 10 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 10            CONTINUE
            ENDIF
C
C           --- MASSE ---
            DO 12 I = 1 , N
               ZR(LCASTR) = ZR(LCASTR) + MAT(I)
 12         CONTINUE
            ZR(LCASTR) = ZR(LCASTR) + MAT(2) + MAT(4) + MAT(5)
            ZR(LCASTR) = ZR(LCASTR) / TROIS
C
C           --- CDG ---
            ZR(LCASTR+1) = ZR(LCOOR  )
            ZR(LCASTR+2) = ZR(LCOOR+1)
            ZR(LCASTR+3) = ZR(LCOOR+2)
C
         ELSEIF ( NOMTE .EQ. 'MECA_DIS_TR_N' ) THEN
            NNO = 1
            NC  = 6
            N   = 21
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UTPSLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 20 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 20            CONTINUE
            ENDIF
C
C           --- MASSE ---
            DO 22 I = 1 , 6
               ZR(LCASTR) = ZR(LCASTR) + MAT(I)
 22         CONTINUE
            ZR(LCASTR) = ZR(LCASTR) + MAT(2) + MAT(4) + MAT(5)
            ZR(LCASTR) = ZR(LCASTR) / TROIS
C
C           --- CDG ---
            ZR(LCASTR+1) = ZR(LCOOR  )
            ZR(LCASTR+2) = ZR(LCOOR+1)
            ZR(LCASTR+3) = ZR(LCOOR+2)
C
C           --- INERTIE ---
            ZR(LCASTR+4) = MAT(10)
            ZR(LCASTR+5) = MAT(15)
            ZR(LCASTR+6) = MAT(21)
            ZR(LCASTR+7) = MAT(14)
            ZR(LCASTR+8) = MAT(19)
            ZR(LCASTR+9) = MAT(20)
C
         ELSEIF ( NOMTE. EQ. 'MECA_2D_DIS_T_N' ) THEN
            NNO = 1
            NC  = 2
            N   = 3
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UT2MLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 14 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 14            CONTINUE
            ENDIF
C
C           --- MASSE ---
            DO 15 I = 1 , N
               ZR(LCASTR) = ZR(LCASTR) + MAT(I)
 15         CONTINUE
            ZR(LCASTR) = ZR(LCASTR) + MAT(2)
            ZR(LCASTR) = ZR(LCASTR) / DEUX
C
C           --- CDG ---
            ZR(LCASTR+1) = ZR(LCOOR  )
            ZR(LCASTR+2) = ZR(LCOOR+1)
C
         ELSEIF ( NOMTE .EQ. 'MECA_2D_DIS_TR_N' ) THEN
            NNO = 1
            NC  = 3
            N   = 6
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UT2MLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 24 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 24            CONTINUE
            ENDIF
C
C           --- MASSE ---
            ZR(LCASTR) = ZR(LCASTR) + MAT(1) + DEUX*MAT(2) + MAT(3)
            ZR(LCASTR) = ZR(LCASTR) / DEUX
C
C           --- CDG ---
            ZR(LCASTR+1) = ZR(LCOOR  )
            ZR(LCASTR+2) = ZR(LCOOR+1)
C
C           --- INERTIE ---
            ZR(LCASTR+3) = MAT(6)
C
C        ============ ELEMENT DE TYPE SEG2 ============
C
         ELSEIF ( NOMTE .EQ. 'MECA_DIS_T_L' ) THEN
            NNO = 2
            NC  = 3
            N   = 21
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UTPSLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 30 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 30            CONTINUE
            ENDIF
C
C           --- MASSE ---
            DO 32 I = 1 , N
               ZR(LCASTR) = ZR(LCASTR) + MAT(I)
 32         CONTINUE
            ZR(LCASTR) = ZR(LCASTR) + MAT(2) + MAT(4) + MAT(5) + MAT(7)
     &                 + MAT(8) + MAT(9) + MAT(11) + MAT(12) + MAT(13)
     &                 + MAT(14) + MAT(16) + MAT(17) + MAT(18) + MAT(19)
     &                 + MAT(20)
            ZR(LCASTR) = ZR(LCASTR) / TROIS
C
C           --- CDG ---
            ZR(LCASTR+1) = ( ZR(LCOOR  ) + ZR(LCOOR+3) ) / DEUX
            ZR(LCASTR+2) = ( ZR(LCOOR+1) + ZR(LCOOR+4) ) / DEUX
            ZR(LCASTR+3) = ( ZR(LCOOR+2) + ZR(LCOOR+5) ) / DEUX
C
         ELSEIF ( NOMTE .EQ. 'MECA_DIS_TR_L' ) THEN
            NNO = 2
            NC  = 6
            N   = 78
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UTPSLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 40 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 40            CONTINUE
            ENDIF
C
C           --- MASSE ---
            ZR(LCASTR) =  MAT(2)  + MAT(4)  + MAT(5)  +
     &                    MAT(35) + MAT(43) + MAT(44)
            DO 42 I = 1,3
               I1 = 21 + I
               I2 = 28 + I
               I3 = 36 + I
               ZR(LCASTR) = ZR(LCASTR) + MAT(I1) + MAT(I2) + MAT(I3)
 42         CONTINUE
            ZR(LCASTR) = DEUX * ZR(LCASTR)
            ZR(LCASTR) =  ZR(LCASTR) + MAT(1)  + MAT(3)  + MAT(6) +
     &                                 MAT(28) + MAT(36) + MAT(45)
            ZR(LCASTR) = ZR(LCASTR) / TROIS
C
C           --- CDG ---
            ZR(LCASTR+1) = ( ZR(LCOOR  ) + ZR(LCOOR+3) ) / DEUX
            ZR(LCASTR+2) = ( ZR(LCOOR+1) + ZR(LCOOR+4) ) / DEUX
            ZR(LCASTR+3) = ( ZR(LCOOR+2) + ZR(LCOOR+5) ) / DEUX
C
         ELSEIF ( NOMTE .EQ. 'MECA_2D_DIS_T_L' ) THEN
            NNO = 2
            NC  = 2
            N   = 10
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UT2MLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 34 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 34            CONTINUE
            ENDIF
C
C           --- MASSE ---
            DO 35 I = 1 , N
               ZR(LCASTR) = ZR(LCASTR) + MAT(I)
 35         CONTINUE
            ZR(LCASTR) = ZR(LCASTR) + MAT(2) + MAT(4) + MAT(5) + MAT(7)
     &                 + MAT(8) + MAT(9)
            ZR(LCASTR) = ZR(LCASTR) / DEUX
C
C           --- CDG ---
            ZR(LCASTR+1) = ( ZR(LCOOR  ) + ZR(LCOOR+2) ) / DEUX
            ZR(LCASTR+2) = ( ZR(LCOOR+1) + ZR(LCOOR+3) ) / DEUX
C
         ELSEIF ( NOMTE .EQ. 'MECA_2D_DIS_TR_L' ) THEN
            NNO = 2
            NC  = 3
            N   = 21
            IF ( ZR(LMASS+N) .EQ. 2 ) THEN
               CALL UT2MLG ( NNO, NC, PGL, ZR(LMASS), MAT )
            ELSE
               DO 36 I = 1 , N
                  MAT(I) = ZR(LMASS+I-1)
 36            CONTINUE
            ENDIF
C
C           --- MASSE ---
            ZR(LCASTR) =  MAT(2)  + MAT(7)  + MAT(8)  +
     &                    MAT(11) + MAT(12) + MAT(14)
            ZR(LCASTR) = DEUX * ZR(LCASTR)
            ZR(LCASTR) =  ZR(LCASTR) + MAT(1)  + MAT(3)  +
     &                                 MAT(10) + MAT(15)
            ZR(LCASTR) = ZR(LCASTR) / DEUX
C
C           --- CDG ---
            ZR(LCASTR+1) = ( ZR(LCOOR  ) + ZR(LCOOR+2) ) / DEUX
            ZR(LCASTR+2) = ( ZR(LCOOR+1) + ZR(LCOOR+3) ) / DEUX
C
         ENDIF
C
      ELSE
         CH16 = OPTION
         CALL U2MESK('F','ELEMENTS2_47',1,CH16)
      ENDIF
C
      END
