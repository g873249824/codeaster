      SUBROUTINE ARLLPO(MOTCLE,IOCC  ,NOM1  ,NOM2  ,POND1 ,
     &                  POND2 ,GRFIN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 07/07/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*16 MOTCLE
      INTEGER      IOCC
      CHARACTER*10 NOM1,NOM2
      REAL*8       POND1,POND2
      INTEGER      GRFIN
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C LECTURE ET VERIFICATION PONDERATION
C
C ----------------------------------------------------------------------
C
C
C IN  MOTCLE : MOT-CLEF FACTEUR POUR ARLEQUIN
C IN  IOCC   : OCCURRENCE DU MOT CLEF-FACTEUR ARLEQUIN
C IN  NOM1   : NOM DE LA SD POUR STOCKAGE MAILLES GROUP_MA_1
C IN  NOM2   : NOM DE LA SD POUR STOCKAGE MAILLES GROUP_MA_2
C OUT POND1  : VALEUR DE LA PONDERATION SUR MAILLAGE FIN
C OUT POND2  : VALEUR DE LA PONDERATION SUR MAILLAGE GROSSIER
C OUT GRFIN  : 1 SI MAILLAGE 1 PLUS FIN QUE MAILLAGE 2
C              2 DANS LE CAS CONTRAIRE
C
C ----------------------------------------------------------------------
C
      INTEGER      ARLFG,NOCC1,NOCC2
      INTEGER      IFM,NIV
      CHARACTER*16 NOMBO1,NOMBO2

      INTEGER      NI,NR,NK
      PARAMETER   ( NI = 1 , NR = 2 , NK = 1 )
      INTEGER      VALI(NI)
      REAL*8       VALR(NR)
      CHARACTER*24 VALK(NK)

      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='ARLLPO')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C --- INITIALISATIONS
C
      NOMBO1 = NOM1(1:10)//'.BOITE'
      NOMBO2 = NOM2(1:10)//'.BOITE'
C
C --- DETECTION DU GROUPE AU MAILLAGE LE PLUS FIN
C
      GRFIN  = ARLFG(NOMBO1,NOMBO2)
C
C --- CHOIX MANUEL DES VALEURS DE PONDERATION
C
      CALL GETVR8(MOTCLE,'POIDS_1',IOCC,1,1,POND1,NOCC1)
      IF (NOCC1.NE.0) THEN
        POND2 = 1.D0 - POND1
        GOTO 50
      ENDIF
C
      CALL GETVR8(MOTCLE,'POIDS_2',IOCC,1,1,POND2,NOCC2)
      IF (NOCC2.NE.0) THEN
        POND1 = 1.D0 - POND2
        GOTO 50
      ENDIF
C
C --- CHOIX AUTOMATIQUE DES VALEURS DE PONDERATION
C
      CALL GETVR8(MOTCLE,'POIDS_FIN',IOCC,1,1,POND1,NOCC1)
      IF (NOCC1.NE.0) THEN
        IF (GRFIN.EQ.1) THEN
          POND2 = 1.D0 - POND1
        ELSE
          POND2 = POND1
          POND1 = 1.D0 - POND2
        ENDIF
        GOTO 50
      ENDIF
C
      CALL GETVR8(MOTCLE,'POIDS_GROSSIER',IOCC,1,1,POND1,NOCC2)
      IF (GRFIN.EQ.1) THEN
        POND2 = POND1
        POND1 = 1.D0 - POND2
      ELSE
        POND2 = 1.D0 - POND1
      ENDIF
C
 50   CONTINUE
C
      IF (GRFIN.EQ.0) THEN
        GRFIN  = ARLFG(NOMBO1,NOMBO2)
      ENDIF
      VALI(1)=GRFIN
      VALR(1)=POND1
      VALR(2)=POND2
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NI,VALI,NR,VALR,NK,VALK)
C
      CALL JEDEMA()
      END
