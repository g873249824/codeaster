      SUBROUTINE NMRLDB(SOLVEU,LMAT,RESU,NBSM,CNCINE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      INTEGER      LMAT,NBSM
      REAL*8       RESU(*)
      CHARACTER*19 SOLVEU,CNCINE
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT
C
C ROUTINE DE CALCUL DE RESU = MAT-1(RESU,CNCINE)  NON LINEAIRE
C
C ----------------------------------------------------------------------
C
C
C IN  SOLVEU : SD SOLVEUR
C IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE
C IN  CNCINE : NOM DU CHARGEMENT CINEMATIQUE
C I/O RESU   : .VALE DU CHAM_NO RESULTAT EN OUT , SMB EN IN
C
C
C
C ----------------------------------------------------------------------
C
      CHARACTER*19 MATR
      COMPLEX*16   C16BID
      INTEGER      IRET
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      MATR   = ZK24(ZI(LMAT+1))

      CALL RESOUD(MATR  ,' '   ,SOLVEU,CNCINE,NBSM  ,
     &            ' '   ,' '   ,'V'   ,RESU  ,C16BID,
     &            ' '   ,.TRUE.,0     ,IRET  )
C
      CALL JEDEMA()

      END
