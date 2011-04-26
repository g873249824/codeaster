      SUBROUTINE RCEVSE ( CSIGM, CINST, CSNO, CSNE )
      IMPLICIT      NONE
      CHARACTER*24  CSIGM, CINST, CSNO, CSNE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------
C     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
C     CALCUL DU SN*
C
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER      NCMP, JSIGM, JINST, NBINST, NBORDR, JSNO, JSNE,
     +             IND, I1, I2, ICMP, L1, L2, L3
      PARAMETER  ( NCMP = 6 )
      REAL*8       SN1O(NCMP), SN1E(NCMP), SN2O(NCMP), SN2E(NCMP),
     +             SN12O(NCMP), SN12E(NCMP), TRESCA
      CHARACTER*8  K8B
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL JEVEUO ( CSIGM, 'L', JSIGM )
      CALL JEVEUO ( CINST, 'L', JINST )
      CALL JELIRA ( CINST, 'LONMAX', NBINST, K8B )
C
      NBORDR = (NBINST*(NBINST+1)) / 2
      CALL WKVECT (CSNO, 'V V R', NBORDR, JSNO )
      CALL WKVECT (CSNE, 'V V R', NBORDR, JSNE )
      IND = 0
C
      DO 100 I1 = 1, NBINST
C
         DO 102 ICMP = 1, NCMP
            L1 =                 NCMP*(I1-1) + ICMP
            L2 =   NCMP*NBINST + NCMP*(I1-1) + ICMP
            L3 = 3*NCMP*NBINST + NCMP*(I1-1) + ICMP
            SN1O(ICMP) = ZR(JSIGM-1+L1)-ZR(JSIGM-1+L2)+ZR(JSIGM-1+L3)
            SN1E(ICMP) = ZR(JSIGM-1+L1)+ZR(JSIGM-1+L2)-ZR(JSIGM-1+L3)
 102     CONTINUE
         IND = IND + 1
         ZR(JSNO+IND-1) = 0.D0
         ZR(JSNE+IND-1) = 0.D0
C
         DO 110 I2 = I1+1, NBINST
C
            DO 112 ICMP = 1, NCMP
               L1 =                 NCMP*(I2-1) + ICMP
               L2 =   NCMP*NBINST + NCMP*(I2-1) + ICMP
               L3 = 3*NCMP*NBINST + NCMP*(I2-1) + ICMP
               SN2O(ICMP) = ZR(JSIGM-1+L1)-ZR(JSIGM-1+L2)+ZR(JSIGM-1+L3)
               SN2E(ICMP) = ZR(JSIGM-1+L1)+ZR(JSIGM-1+L2)-ZR(JSIGM-1+L3)
 112        CONTINUE
            IND = IND + 1
C ======================================================================
C ---       COMBINAISON DES CONTRAINTES AUX 2 INSTANTS TEMP1 ET TEMP2 :
C ======================================================================
            DO 114 ICMP = 1 , NCMP
               SN12O(ICMP) = SN1O(ICMP) - SN2O(ICMP)
               SN12E(ICMP) = SN1E(ICMP) - SN2E(ICMP)
CCC           ENDIF
 114        CONTINUE
C ======================================================================
C ---       CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS
C ---       DE CONTRAINTES LINEARISEES
C ---       SN12O = SNO(TEMP1)-SNO(TEMP2) A L'ORIGINE DU CHEMIN :
C ---  CALCUL DE LA DIFFERENCE SUP SNO DES VALEURS PROPRES ( LE TRESCA)
C ======================================================================
            CALL RCTRES ( SN12O, TRESCA )
            ZR(JSNO+IND-1) = TRESCA
C ======================================================================
C ---      CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS
C ---      DE CONTRAINTES LINEARISEES
C ---      SN12E = SNE(TEMP1)-SNE(TEMP2) A L'AUTRE EXTREMITE DU CHEMIN :
C ---   CALCUL DE LA DIFFERENCE SUP SNE DES VALEURS PROPRES (LE TRESCA)
C ======================================================================
            CALL RCTRES ( SN12E, TRESCA )
            ZR(JSNE+IND-1) = TRESCA
C
 110     CONTINUE
C
 100  CONTINUE
C
      CALL JEDEMA( )
      END
