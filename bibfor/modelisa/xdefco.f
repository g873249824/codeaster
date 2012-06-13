      SUBROUTINE XDEFCO(NOMA  ,NOMO,  FISS  ,ALGOLA,NDIM  ,
     &                  NLISEQ,NLISRL,NLISCO,NBASCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      INTEGER      NDIM
      CHARACTER*8  FISS,NOMA,NOMO
      INTEGER      ALGOLA
      CHARACTER*19 NLISEQ,NLISRL,NLISCO,NBASCO
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (MODIF. DU MODELE)
C
C CHOIX DE L'ESPACE DES LAGRANGES POUR LE CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NOMA   : NOM DE L'OBJET MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  ALGOLA : TYPE DE CREATION DES RELATIONS DE LIAISONS ENTRE LAGRANGE
C IN  FISS   : SD FISS_XFEM
C OUT NLISRL : LISTE REL. LIN. POUR V1 ET V2
C OUT NLISCO : LISTE REL. LIN. POUR V1 ET V2
C OUT NLISEQ : LISTE REL. LIN. POUR V2 SEULEMENT
C OUT NBASCO : CHAM_NO POUR BASE COVARIANTE
C
C
C
C
      INTEGER      NMAENR,NMAEN1,NMAEN2,NMAEN3
      CHARACTER*24 XINDIC
      INTEGER      JINDIC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES AUX OBJETS
C
      XINDIC = FISS(1:8)//'.MAILFISS .INDIC'
      CALL JEVEUO(XINDIC,'L',JINDIC)
      NMAEN1 = ZI(JINDIC+1)
      NMAEN2 = ZI(JINDIC+3)
      NMAEN3 = ZI(JINDIC+5)
      NMAENR = NMAEN1+NMAEN2+NMAEN3
C
C --- CHOIX DE L'ESPACE DES LAGRANGES POUR LE CONTACT
C
      IF (NMAENR.EQ.0) THEN
        CALL U2MESS('A','XFEM_57')
      ELSE
        CALL XLAGSP(NOMA  ,NOMO  ,FISS  ,ALGOLA,NDIM  ,
     &              NLISEQ,NLISRL,NLISCO,NBASCO)
      ENDIF
C
      CALL JEDEMA()
      END
