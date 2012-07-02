      SUBROUTINE JEVEUT ( NOMLU , CEL  , JCTAB )
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
C ----------------------------------------------------------------------
C ALLOUE UN OBJET EM MEMOIRE DE FACON PERMANENTE (MARQUE = -1)
C
C IN  NOMLU  : NOM DE L'OBJET A ALLOUER
C IN  CEL    : TYPE D'ACCES 'E' OU 'L'
C OUT JCTAB  : ADRESSE DANS LE COMMUN DE REFERENCE ASSOCIE
C ----------------------------------------------------------------------
      IMPLICIT NONE
      INTEGER                            JCTAB
      CHARACTER*(*)       NOMLU , CEL
C     ------------------------------------------------------------------
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
C DEB ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER IPGCEX 
C-----------------------------------------------------------------------
      IPGCEX = IPGC
      IPGC   = -1
      CALL JEVEUO ( NOMLU , CEL  , JCTAB )
      IPGC = IPGCEX
C FIN ------------------------------------------------------------------
      END
