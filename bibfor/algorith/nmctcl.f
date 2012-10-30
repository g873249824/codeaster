      SUBROUTINE NMCTCL(NUMINS,MODELE,NOMA  ,DEFICO,RESOCO,
     &                  SDDYNA,SDDISC,LOPTIN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/10/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      LOGICAL      LOPTIN
      CHARACTER*8  NOMA
      CHARACTER*24 MODELE
      CHARACTER*24 DEFICO,RESOCO
      INTEGER      NUMINS
      CHARACTER*19 SDDYNA,SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGO - BOUCLE CONTACT)
C
C CREATION DU LIGREL ET DES CHAMPS/CARTE POUR LES ELEMENTS TARDIFS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  LOPTIN : VAUT .TRUE. SI ACTIVATION DES OPTIONS *_INIT
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  NUMINS : NUMERO D'INSTANT
C
C ----------------------------------------------------------------------
C
      INTEGER      IFM,NIV
      LOGICAL      LCTCC,LXFCM
      LOGICAL      CFDISL,LTFCM
      CHARACTER*8  NOMO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECANONLINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> CREATION ET INITIALISATION'//
     &        ' DES OBJETS POUR LE CONTACT'
      ENDIF
C
C --- TYPE DE CONTACT
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')
      LTFCM  = CFDISL(DEFICO,'CONT_XFEM_GG')
      NOMO   = MODELE(1:8)
C
      IF (LXFCM) THEN
        IF (LOPTIN) THEN
          CALL XMELEM(NOMA  ,NOMO  ,DEFICO,RESOCO)
        ENDIF
        IF (LTFCM) THEN
          CALL XMLIGR(NOMA  ,NOMO  ,RESOCO)
          CALL XMCART(NOMA  ,DEFICO,NOMO  ,RESOCO)
        ENDIF
      ELSEIF (LCTCC) THEN
        CALL MMLIGR(NOMA,NOMO,DEFICO,RESOCO)
        CALL MMCHML(NOMA  ,DEFICO,RESOCO,SDDISC,SDDYNA,
     &              NUMINS)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

C
      CALL JEDEMA()
      END
