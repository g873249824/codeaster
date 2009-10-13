      SUBROUTINE ARLMED(MOTCLE,IOCC  ,GRFIN ,GRMED)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/10/2009   AUTEUR CAO B.CAO 
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
      INTEGER      GRMED,GRFIN
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CHOIX DU MEDIATEUR
C
C ----------------------------------------------------------------------
C
C IN  MOTCLE : MOT-CLEF FACTEUR POUR ARLEQUIN
C IN  IOCC   : OCCURRENCE DU MOT CLEF-FACTEUR ARLEQUIN
C IN  GRFIN  : 1 SI MAILLAGE 1 PLUS FIN QUE MAILLAGE 2
C              2 DANS LE CAS CONTRAIRE
C OUT GRMED  : GROUPE DE MAILLES SERVANT DE MEDIATEUR (1 OU 2)
C
C ----------------------------------------------------------------------
C
      INTEGER      IRET,GRGRO
      INTEGER      IFM,NIV
      CHARACTER*16 COLLE

      INTEGER      NBVLI,NBVLR,NBVLK
      PARAMETER   ( NBVLI = 1 , NBVLR = 1 , NBVLK = 1 )
      INTEGER      VALI(NBVLI)
      REAL*8       VALR(NBVLR)
      CHARACTER*24 VALK(NBVLK)

      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='ARLMED')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C --- GROUPE AU MAILLAGE GROSSIER
C
      GRGRO = 3 - GRFIN
C
C --- CHOIX DU MEDIATEUR
C
      CALL GETVTX(MOTCLE,'COLLAGE',IOCC,1,1,COLLE,IRET)
      IF (COLLE(1:10).EQ.'GROUP_MA_1') THEN
        GRMED = 1
      ELSEIF (COLLE(1:10).EQ.'GROUP_MA_2') THEN
        GRMED = 2
      ELSE
        IF (COLLE(1:8).EQ.'GROSSIER') THEN
          GRMED = GRGRO
        ELSE
          GRMED = GRFIN
        ENDIF
      ENDIF
C
      VALI(1)=GRMED
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NBVLI,VALI,NBVLR,VALR,NBVLK,
     &            VALK)
C
      CALL JEDEMA()
      END
