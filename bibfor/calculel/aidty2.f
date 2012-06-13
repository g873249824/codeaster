      SUBROUTINE AIDTY2(IMPR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE DURAND C.DURAND
      IMPLICIT NONE
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
C    BUT:
C       ECRIRE SUR LE FICHIER "IMPR"
C       1  LES COUPLES (OPTION, TYPE_ELEMENT) REALISES AUJOURD'HUI
C          (POUR VERIFIER LA COMPLETUDE)
C ----------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      CHARACTER*8 KBID
      CHARACTER*16 NOMTE,NOOP
      INTEGER IAOPTE,NBTE,NBOP,IANOP2,IOP,ITE,IOPTTE,IAOPMO,NUCALC,IMPR
C
      CALL JEMARQ()

C     1) IMPRESSION DES LIGNES DU TYPE :
C        &&CALCUL/MECA_XT_FACE3   /CHAR_MECA_PRES_R
C     ------------------------------------------------------------------
      CALL JEVEUO('&CATA.TE.OPTTE','L',IAOPTE)
      CALL JELIRA('&CATA.TE.NOMTE','NOMUTI',NBTE,KBID)
      CALL JELIRA('&CATA.OP.NOMOPT','NOMUTI',NBOP,KBID)

      CALL WKVECT('&&AIDTY2.NOP2','V V K16',NBOP ,IANOP2)
      DO 7,IOP=1,NBOP
        CALL JENUNO(JEXNUM('&CATA.OP.NOMOPT',IOP),NOOP)
        ZK16(IANOP2-1+IOP)=NOOP
 7    CONTINUE


C     -- ECRITURE DES COUPLES (TE,OPT)
C     --------------------------------
      DO 10,ITE=1,NBTE
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOMTE)
        DO 101,IOP=1,NBOP
          IOPTTE= ZI(IAOPTE-1+NBOP*(ITE-1)+IOP)
          IF (IOPTTE.EQ.0) GO TO 101
          CALL JEVEUO(JEXNUM('&CATA.TE.OPTMOD',IOPTTE),'L',IAOPMO)
          NUCALC= ZI(IAOPMO)
          IF (NUCALC.LE.0) GO TO 101
          WRITE(IMPR,*)'&&CALCUL/'//NOMTE//'/'//ZK16(IANOP2-1+IOP)
 101    CONTINUE
 10   CONTINUE


C     2) IMPRESSION DE LIGNES PERMETTANT LE SCRIPT "USAGE_ROUTINES" :
C        A QUELLES MODELISATIONS SERVENT LES ROUTINES TE00IJ ?
C     ----------------------------------------------------------------
C  PHENOMENE  MODELISATION TYPE_ELEMENT OPTION       TE00IJ
C  MECANIQUE  D_PLAN_HMS   HM_DPQ8S     SIEQ_ELNO    330

      CALL AIDTYP(IMPR)


      CALL JEDEMA()
      END
