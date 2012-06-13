      SUBROUTINE RSUTN2 ( RESU, NOMCHA, MOTCLE, IOCC, OBJVEU, NBORDR )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER          IOCC, NBORDR
      CHARACTER*(*)    RESU, NOMCHA, MOTCLE, OBJVEU
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     RECUPERATION DES NUMEROS D'ORDRE DANS UNE STRUCTURE DE DONNEES
C     DE TYPE "RESULTAT" A PARTIR D'UN NOM SYMBOLIQUE ET DES VARIABLES
C     D'ACCES UTILISATEUR
C     ------------------------------------------------------------------
C IN  : RESU   : NOM DE LA STRUCTURE DE DONNEES
C IN  : NOMCHA : NOM SYMBOLIQUE DU CHAMP
C IN  : MOTCLE : NOM DU MOT CLE FACTEUR
C IN  : IOCC   : NUMERO D'OCCURENCE
C OUT : OBJVEU : NOM JEVEUX DU VECTEUR ZI POUR ECRIRE LA LISTE DES NUME
C OUT : NBORDR : NOMBRE DE NUMERO D'ORDRE VALIDE POUR LE NOMCHA
C     ------------------------------------------------------------------
      INTEGER       IRET, II, IORDR, LORDR, JORDR, NP, NC, NBTORD
      REAL*8        PREC
      CHARACTER*8   K8B, CRIT
      CHARACTER*16  K16B
      CHARACTER*19  CHAM19
      CHARACTER*24  KNUME
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
C     --- LECTURE DE LA PRECISION ET DU CRITERE ---
C
      CALL GETVR8 ( MOTCLE, 'PRECISION', IOCC,IARG,1, PREC, NP )
      CALL GETVTX ( MOTCLE, 'CRITERE'  , IOCC,IARG,1, CRIT, NC )
C
C     --- RECUPERATION DES NUMEROS D'ORDRE ---
C
      KNUME = '&&RSUTN2.NUME_ORDR'
      CALL RSUTNU ( RESU, MOTCLE, IOCC, KNUME, NBTORD, PREC, CRIT, IRET)
      IF ( IRET .NE. 0 ) THEN
         K8B = RESU
         CALL U2MESK('F','UTILITAI4_49',1,K8B)
      ENDIF
      CALL JEVEUO ( KNUME, 'L', LORDR )
C
C     --- VERIFICATION QUE LE NOMCHA EXISTE DANS LA SD RESULTAT ---
C
      II = 0
      DO 10 IORDR = 1,NBTORD
         CALL RSEXCH ( RESU, NOMCHA, ZI(LORDR+IORDR-1),CHAM19,IRET)
         IF (IRET.EQ.0)  II = II + 1
 10   CONTINUE
      IF ( II .EQ. 0 ) THEN
         K16B = NOMCHA
         CALL U2MESK('F','UTILITAI4_52',1,K16B)
      ENDIF
C
C     --- LISTE DES NUMEROS D'ORDRE ---
C
      NBORDR = 0
      CALL WKVECT ( OBJVEU, 'V V I', II, JORDR )
      DO 20 IORDR = 1,NBTORD
         CALL RSEXCH ( RESU, NOMCHA, ZI(LORDR+IORDR-1),CHAM19,IRET)
         IF (IRET.EQ.0) THEN
            NBORDR = NBORDR + 1
            ZI(JORDR+NBORDR-1) = ZI(LORDR+IORDR-1)
         ENDIF
 20   CONTINUE
C
      CALL JEDETR('&&RSUTN2.NUME_ORDR')
C
      CALL JEDEMA()
      END
