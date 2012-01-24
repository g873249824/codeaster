      SUBROUTINE GIMPTE ( RESU, RAYINF, RAYSUP, THETA, NOMNOE,
     &                    DIR, ABSC, NBNO, FORMAT, UNIT )
      IMPLICIT   NONE
      INTEGER             NBNO, UNIT
      REAL*8              RAYINF(*), RAYSUP(*), THETA(*),DIR(*),ABSC(*)
      CHARACTER*8         RESU, NOMNOE(*)
      CHARACTER*(*)       FORMAT
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/01/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_6
C
C     IMPRESSION DES OBJETS DECRIVANT LE CHAMP THETA
C
C IN : NBRE   : NOMBRE-1 DE CHAMPS THETA (=1)
C IN : RAYINF : RAYON INTERNE SUR LE FOND DE FISSURE
C IN : RAYSUP : RAYON EXTERNE SUR LE FOND DE FISSURE
C IN : THETA  : MODULE DE THETA SUR LE FOND DE FISSURE
C IN : NOMNOE : NOMS DES NOEUDS SUR LE FOND DE FISSURE
C IN : DIR    : NORMALE SUR LE FOND DE FISSURE
C IN : NBNO   : NOMBRE DE NOEUDS SUR LE FOND DE FISSURE
C
C ----------------------------------------------------------------------
C
      INTEGER      I
      REAL*8       RINF, RSUP, MODULE, NX, NY, NZ
      CHARACTER*1  BACS
      CHARACTER*9  IMPNOE
C     ------------------------------------------------------------------
C
      BACS   = CHAR(92)
C
      WRITE ( UNIT, 1000) RESU
      WRITE ( UNIT, 1010)
      DO 10 I = 1 , NBNO
        IF ( FORMAT(1:5) .EQ. 'AGRAF' ) THEN
          IMPNOE = BACS//NOMNOE(I)
        ELSE
          IMPNOE = NOMNOE(I)
        ENDIF
        RINF   = RAYINF(I)
        RSUP   = RAYSUP(I)
        MODULE = THETA(I)
        NX   = DIR((I-1)*3+1)
        NY   = DIR((I-1)*3+2)
        NZ   = DIR((I-1)*3+3)
        WRITE ( UNIT, 1020) ABSC(I),IMPNOE,RINF,RSUP,MODULE,NX,NY,NZ
 10   CONTINUE
C
 1000 FORMAT( '==> CHAMP THETA : ',A8,/,'    FOND DE FISSURE' )
 1010 FORMAT(5X,'ABSC_CURV',5X,'NOEUD',9X,'R_INF',10X,'R_SUP',10X,
     &       'THETA',10X,'DIR_X',10X,'DIR_Y',10X,'DIR_Z')
 1020 FORMAT(1P,3X,E12.5,3X,A9,6(3X,E12.5))
 1030 FORMAT( '==> CHAMP THETA : ',A8,/)
 1040 FORMAT(7X,'R_INF',10X,'R_SUP',10X, 'THETA')
 1050 FORMAT(3(3X,E12.5))
C
      END
