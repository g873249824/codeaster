      SUBROUTINE TITREC(DEMON,DONNEE,ILIGD,ICOLD,NBTITR,MXPARA,
     &                                                     PARA,NBPARA)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     DEMON,DONNEE(*),                   PARA(*)
      INTEGER                        ILIGD,ICOLD,NBTITR,MXPARA, NBPARA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     EXTRACTION DES PARAMETRES
C     ------------------------------------------------------------------
C IN  MXPARA : I  : NOMBRE MAXIMUM DE PARAMETRES ATTENDUS
C OUT PARA   : K* : LISTE DES PARAMETRES RECUS
C OUT NBPARA : I  : NOMBRE DE PARAMETRES RECUS
C     ------------------------------------------------------------------
      INTEGER      IVAL, ICOL, ILIG
      REAL*8       RVAL
      CHARACTER*80 CVAL
      CHARACTER*8  K8BID
C     ------------------------------------------------------------------
      NBPARA = 0
      ILIG   = ILIGD
      ICOL   = ICOLD
  1   CONTINUE
      CALL LXSCAN(DONNEE(ILIG),ICOL,ICLASS,IVAL,RVAL,CVAL)
      IF ( ICLASS .EQ. -1 ) THEN
C-DEL                WRITE(6,*) ' TITREC EOF '
         ICOL = 1
         ILIG = ILIG + 1
         IF ( ILIG .LE. NBTITR) GOTO 1
      ELSEIF ( ICLASS .EQ. 5 .AND. CVAL(1:1) .EQ. '('  ) THEN
C-DEL                WRITE(6,*) ' TITREC "(" '
         ICOLD = ICOL
         ILIGD = ILIG
 11      CONTINUE
         CALL LXSCAN(DONNEE(ILIGD),ICOLD,ICLASS,IVAL,RVAL,CVAL)
 12      CONTINUE
         IF ( ICLASS .EQ. -1 ) THEN
            ICOLD = 1
            ILIGD = ILIGD + 1
            IF(ILIGD.GT.NBTITR) THEN
               CALL U2MESS('A','UTILITAI4_96')
               NBPARA = 0
               GO TO 20
            ENDIF
            GOTO 11
         ELSEIF (ICLASS .EQ. 3 .OR. ICLASS .EQ.4 ) THEN
            NBPARA = NBPARA + 1
            PARA(NBPARA) = CVAL(1:IVAL)
CCC            CALL LXCAPS(PARA(NBPARA))
            CALL LXSCAN(DONNEE(ILIGD),ICOLD,ICLASS,IVAL,RVAL,CVAL)
            IF (ICLASS .EQ. 5 .AND. CVAL(1:1) .EQ. ',' ) GOTO 11
            GOTO 12
         ELSEIF (ICLASS .EQ. 5 .AND. CVAL(1:1) .EQ. ')' ) THEN
            IF ( NBPARA .NE. MXPARA ) THEN
               NBPARA = 0
               CALL U2MESS('A','UTILITAI4_97')
            ENDIF
            GOTO 20
         ELSE
            NBPARA = 0
            CALL U2MESS('A','UTILITAI4_98')
         ENDIF
 20   CONTINUE
      ENDIF
      IF (NBPARA.EQ.0 ) THEN
         DO 30 IPARA = 1, MXPARA
            CALL GETRES(PARA(IPARA),K8BID,K8BID)
            NBPARA = NBPARA + 1
 30      CONTINUE
      ENDIF
      END
