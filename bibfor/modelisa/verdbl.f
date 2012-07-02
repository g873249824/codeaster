        SUBROUTINE VERDBL(DEBLIG,CNL,IER,IRTETI)
      IMPLICIT NONE
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C       ----------------------------------------------------------------
C       VERIFIE QUE L ITEM LUT EST EN DEBUT DE LIGNE ( DEBUT ATTENDU )
C       ----------------------------------------------------------------
C       IN      DEBLIG  =       0 > DANS LA LIGNE  ( # 1ERE POSITION)
C                       =       1 > DEBUT DE LIGNE ( = 1ERE POSITION)
C               CNL     =       NUMERO LIGNE
C       OUT     IER     =       0 > VRAI ( RETURN )
C                       =       1 > FAUX ( RETURN 1 )
C       ----------------------------------------------------------------
        INTEGER         IER , DEBLIG
        CHARACTER*14    CNL
        CHARACTER*16    CMD
        COMMON          /OPMAIL/                CMD
C
C-----------------------------------------------------------------------
      INTEGER IRTETI 
C-----------------------------------------------------------------------
        IRTETI = 0
        IF(DEBLIG.EQ.0)THEN
        CALL U2MESK('E','MODELISA7_66',1,CNL)
        IER = 1
        IRTETI = 1
        GOTO 9999
        ELSE
        IRTETI = 0
        GOTO 9999
        ENDIF
C
 9999   CONTINUE
        END
