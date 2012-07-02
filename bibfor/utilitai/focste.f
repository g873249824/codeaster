      SUBROUTINE FOCSTE(NOMFON,NOMRES,RVAL,BASE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*1                          BASE
      CHARACTER*(*)     NOMFON,NOMRES
      REAL*8                          RVAL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     CREATION D'UN OBJET DE TYPE FONCTION CONSTANTE
C     ------------------------------------------------------------------
C IN  NOMFON : K19 : NOM DE LA FONCTION CONSTANTE A CREER
C IN  NOMRES : K8  : NOM_RESU DE LA FONCTION
C IN  RVAL   : R   : VALEUR DE LA CONSTANTE
C IN  BASE   : K1  : TYPE DE LA BASE 'G','V'
C     ------------------------------------------------------------------
C     OBJETS SIMPLES CREES:
C        NOMFON//'.PROL'
C        NOMFON//'.VALE
C     ------------------------------------------------------------------
      CHARACTER*19 NOMF
      CHARACTER*24 CHPRO, CHVAL
      INTEGER      JPRO,LVAL
      INTEGER      IRET,LXLGUT
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL JEMARQ()
      NOMF  = NOMFON
      CHPRO = NOMF//'.PROL'
      CHVAL = NOMF//'.VALE'
      CALL JEEXIN(CHPRO,IRET)
      IF (IRET.EQ.0) THEN
C
         CALL ASSERT(LXLGUT(NOMF).LE.24)
         CALL WKVECT(CHPRO,BASE//' V K24',6,JPRO)
         ZK24(JPRO)   = 'CONSTANT'
         ZK24(JPRO+1) = 'LIN LIN '
         ZK24(JPRO+2) = 'TOUTPARA'
         ZK24(JPRO+3) = NOMRES
         ZK24(JPRO+4) = 'CC      '
         ZK24(JPRO+5) = NOMF
C
C        --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE ---
         CHVAL(1:19)  = NOMF
         CHVAL(20:24) = '.VALE'
         CALL WKVECT(CHVAL,BASE//' V R',2,LVAL)
         ZR(LVAL)   = 1.0D0
         ZR(LVAL+1) = RVAL
      ELSE
         CALL JEVEUO(CHVAL,'E',LVAL)
         ZR(LVAL+1) = RVAL
      ENDIF
C
C     --- LIBERATIONS ---
      CALL JEDEMA()
      END
