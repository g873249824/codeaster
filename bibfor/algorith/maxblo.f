      SUBROUTINE  MAXBLO (NOMOB,XMAX)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C***********************************************************************
C    P. RICHARD     DATE 13/10/92
C-----------------------------------------------------------------------
C  BUT:      < MAXIMUM D'UN BLOC DE REELS >
C
C   DTERMINER LE MAXIMUM DES TERMES D'UN BLOC
C
C-----------------------------------------------------------------------
C
C NOM----- / /:
C
C NOMOB    /I/: NOM K32 DE L'OBJET REEL
C XMAX     /M/: MAXIMUM REEL
C
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*(*) NOMOB
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,LLBLO ,NBTERM 
      REAL*8 XMAX 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL JEVEUO(NOMOB(1:32),'L',LLBLO)
      CALL JELIRA(NOMOB(1:32),'LONMAX',NBTERM,K1BID)
C
      DO 10 I=1,NBTERM
        XMAX=MAX(XMAX,ABS(ZR(LLBLO+I-1)))
10    CONTINUE
C
C
      CALL JEDEMA()
      END
