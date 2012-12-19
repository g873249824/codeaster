      SUBROUTINE XMCHEX(NOMA  ,NBMA  ,CHPMOD,CHELEX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19  CHELEX,CHPMOD
      INTEGER       NBMA
      CHARACTER*8   NOMA
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
C
C CREATION D'UN CHAM_ELEM_S VIERGE POUR ETENDRE LE CHAM_ELEM
C A PARTIR DE LA STRUCTURE D UN CHAMP EXISTANT
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NBMA   : NOMBRE DE MAILLES
C IN  CHPMOD : CHAMP DONT LA STRUCTURE SERT DE MODELE
C OUT CHELEX : CHAM_ELEM_S PERMETTANT DE CREER UN CHAM_ELEM "ETENDU"
C
C

C
C
      INTEGER       NBCMP
      PARAMETER     (NBCMP = 2)
      CHARACTER*8   LICMP(NBCMP)
      CHARACTER*19  VALK(2),CHELSI
      INTEGER       VALI(1)
C
      INTEGER       IAD,IMA
      INTEGER       JCESL,JCESV,JCESD,JCESD2
C
      DATA LICMP    / 'NPG_DYN', 'NCMP_DYN'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- CREATION DU CHAM_ELEM_S VIERGE
C
      CALL CESCRE('V',CHELEX,'ELEM',NOMA,'DCEL_I',NBCMP,LICMP,
     &            -1,-1,-NBCMP)
C
C --- ACCES AU CHAM_ELEM_S
C
      CALL JEVEUO(CHELEX(1:19)//'.CESD','L',JCESD)
      CALL JEVEUO(CHELEX(1:19)//'.CESL','E',JCESL)
      CALL JEVEUO(CHELEX(1:19)//'.CESV','E',JCESV)
C
C --- TRANSFORMATION CHAMP MODELE EN CHAMP SIMPLE
      CHELSI = '&&XMCHEX.CHELSI'
      CALL CELCES(CHPMOD,'V',CHELSI)
      CALL JEVEUO(CHELSI(1:19)//'.CESD','L', JCESD2)
C
C --- AFFECTATION DES COMPOSANTES DU CHAM_ELEM_S
C
      DO 100 IMA = 1,NBMA
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
        IF (IAD.GE.0) THEN
          VALI(1) = 1
          VALK(1) = CHELEX(1:19)
          VALK(2) = 'ELEM'
          CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
        ENDIF
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = ZI(JCESD2-1+5+4*(IMA-1)+2)
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,2,IAD)
        IF (IAD.GE.0) THEN
          VALI(1) = 1
          VALK(1) = CHELEX(1:19)
          VALK(2) = 'ELEM'
          CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
        ENDIF
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = ZI(JCESD2-1+5+4*(IMA-1)+3)
100   CONTINUE
C
      CALL DETRSD('CHAM_ELEM_S',CHELSI)
C
      CALL JEDEMA()
C
      END
