      SUBROUTINE CAGRAI ( CHAR, LIGRMO, NOMA, FONREE )
      IMPLICIT   NONE
      CHARACTER*4       FONREE
      CHARACTER*8       CHAR, NOMA
      CHARACTER*(*)     LIGRMO
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 23/05/2006   AUTEUR CIBHHPD L.SALMONA 
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
C
C BUT : STOCKAGE DES CHARGES DES GRADIENTS INITIAUX DE TEMPERAT REPARTIS
C       DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      LIGRMO : NOM DU LIGREL DE MODELE
C      NOMA   : NOM DU MAILLAGE
C      FONREE : FONC OU REEL
C-----------------------------------------------------------------------
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
      INTEGER       NCHGI, JVALV, JNCMP, NX, NY, NZ, I,
     +              IOCC, NBTOU, NBMA, JMA
      REAL*8        GRX, GRY, GRZ
      CHARACTER*8   K8B, TYPMCL(2), GRXF, GRYF, GRZF
      CHARACTER*16  MOTCLF, MOTCLE(2)
      CHARACTER*19  CARTE
      CHARACTER*24  MESMAI
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      MOTCLF = 'GRAD_TEMP_INIT'
      CALL GETFAC ( MOTCLF, NCHGI )
C
      CARTE  = CHAR//'.CHTH.'//'GRAIN'
C
      IF (FONREE.EQ.'REEL') THEN
         CALL ALCART ( 'G', CARTE, NOMA, 'FLUX_R')
      ELSE IF (FONREE.EQ.'FONC') THEN
         CALL ALCART ( 'G', CARTE, NOMA, 'FLUX_F')
      ELSE
         CALL UTMESS('F','CAGRAI','VALEUR INATTENDUE: '//FONREE )
      END IF
C
      CALL JEVEUO (CARTE//'.NCMP'     , 'E', JNCMP)
      CALL JEVEUO (CARTE//'.VALV'     , 'E', JVALV)
C
      ZK8(JNCMP-1+1) = 'FLUX'
      ZK8(JNCMP-1+2) = 'FLUY'
      ZK8(JNCMP-1+3) = 'FLUZ'
      IF (FONREE.EQ.'REEL') THEN
         DO 10 I = 1, 3
            ZR(JVALV-1+I) = 0.D0
 10      CONTINUE
      ELSE IF (FONREE.EQ.'FONC') THEN
         DO 12 I = 1, 3
            ZK8(JVALV-1+I) = '&FOZERO'
 12      CONTINUE
      END IF
      CALL NOCART (CARTE, 1, ' ', 'NOM', 0, ' ', 0, LIGRMO, 3)
C
      MESMAI = '&&CAGRAI.MES_MAILLES'
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
      DO 20 IOCC = 1, NCHGI
C
         IF (FONREE.EQ.'REEL') THEN
            CALL GETVR8 ( MOTCLF, 'FLUX_X', IOCC,1,1, GRX, NX )
            CALL GETVR8 ( MOTCLF, 'FLUX_Y', IOCC,1,1, GRY, NY )
            CALL GETVR8 ( MOTCLF, 'FLUX_Z', IOCC,1,1, GRZ, NZ )
            DO 22 I = 1, 3
               ZR(JVALV-1+I) = 0.D0
 22         CONTINUE
            IF (NX .NE. 0) ZR(JVALV-1+1) = GRX
            IF (NY .NE. 0) ZR(JVALV-1+2) = GRY
            IF (NZ .NE. 0) ZR(JVALV-1+3) = GRZ
         ELSE IF (FONREE.EQ.'FONC') THEN
            CALL GETVID ( MOTCLF, 'FLUX_X', IOCC,1,1, GRXF, NX )
            CALL GETVID ( MOTCLF, 'FLUX_Y', IOCC,1,1, GRYF, NY )
            CALL GETVID ( MOTCLF, 'FLUX_Z', IOCC,1,1, GRZF, NZ )
            DO 24 I = 1, 3
               ZK8(JVALV-1+I) = '&FOZERO'
 24         CONTINUE
            IF (NX .NE. 0) ZK8(JVALV-1+1) = GRXF
            IF (NY .NE. 0) ZK8(JVALV-1+2) = GRYF
            IF (NZ .NE. 0) ZK8(JVALV-1+3) = GRZF
         ENDIF
C
         CALL GETVTX ( MOTCLF, 'TOUT', IOCC, 1, 1, K8B, NBTOU )
         IF ( NBTOU .NE. 0 ) THEN
            CALL NOCART (CARTE,1,' ','NOM',0,' ', 0,LIGRMO,3)
C
         ELSE
            CALL RELIEM(LIGRMO, NOMA, 'NU_MAILLE', MOTCLF, IOCC, 2,
     +                                  MOTCLE, TYPMCL, MESMAI, NBMA )
            CALL JEVEUO ( MESMAI, 'L', JMA )
            CALL NOCART ( CARTE,3,K8B,'NUM',NBMA,K8B,ZI(JMA),' ',3)
            CALL JEDETR ( MESMAI )
         ENDIF
C
 20   CONTINUE
C
      CALL JEDEMA()
      END
