      SUBROUTINE JELIBE ( NOMLU )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
      CHARACTER*(*)       NOMLU
C     ==================================================================
      CHARACTER *6     PGMA
      COMMON /KAPPJE/  PGMA
C     ==================================================================
      CHARACTER*32     NOML32
      INTEGER          ICRE , IRET
C     ==================================================================
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      PGMA = 'JELIBE'
      IF ( LEN(NOMLU) .LE. 0 ) THEN
         CALL U2MESK('F','JEVEUX1_08',1,NOMLU)
      ENDIF
      NOML32 = NOMLU(1:MIN(32,LEN(NOMLU)))
C
      ICRE = 0
      CALL JJVERN ( NOML32 , ICRE , IRET )
C
      IF ( IRET .EQ. 0 ) THEN
        CALL U2MESK('F','JEVEUX_26',1,NOML32(1:24))
      ELSE
        CALL JJLIDE ( 'JELIBE' , NOML32 , IRET )
      ENDIF
      END
