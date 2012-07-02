      SUBROUTINE CRELGT (BASEZ, LIGREZ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C
C
C ======================================================================
C ------------------------------------------------------------
C     BUT : CREATION DE L'OBJET DE TYPE LIGRET
C           ET DE NOM LIGRET
C           LE NOM LIGRET EST FOURNI EN ARGUMENT
C           SI L'OBJET LIGRET  EXISTE DEJA, ON LE DETRUIT
C           PUIS ON LE RECREE
C
C           LE NOMBRE D'AFFECTATION DU LIGRET EST DIMENSIONNE A
C           NBAJEL = 1000
C
C           LE NOMBRE DE MAILLES DU LIGRET EST DIMENSIONNE A
C           NBMAIL = 10000
C
C  ARGUMENT       E/S    TYPE          ROLE
C  BASEZ          IN      K1      BASE SUR LAQUELLE EST CREE LE LIGRET
C
C  LIGREZ         IN      K19     NOM DU LIGRET
C                 JXOUT
C-------------------------------------------------------------
C
C ====================== DEBUT DES DECLARATIONS ========================
C
C ----- ARGUMENTS
      INCLUDE 'jeveux.h'
      CHARACTER*(*) BASEZ, LIGREZ
C ----- VARIABLES LOCALES -------------------------------
C-----------------------------------------------------------------------
      INTEGER IDLIMA ,IDLINO ,IDLITY ,IDMATA ,IDMODE ,IDNBMA ,IDPAMA 
      INTEGER IDPANO ,IDPHEN ,IDPOMA ,IDPONO ,IRET ,JLGRF ,NBAJEL 
      INTEGER NBMAIL 
C-----------------------------------------------------------------------
      PARAMETER (NBAJEL = 1000 )
      PARAMETER (NBMAIL = 10000)
      CHARACTER*1  BASE
      CHARACTER*8  K8BID
      CHARACTER*19 LIGRET
C ====================== DEBUT DU CODE EXECUTABLE ======================
C
      CALL JEMARQ()
C
C --- INITIALISATIONS :
C     ---------------
      BASE   = BASEZ
      LIGRET = LIGREZ
C
C --- SI L'OBJET LIGRET EXISTE , ON LE DETRUIT :
C     ----------------------------------------
      CALL JEEXIN(LIGRET//'.LGRF',IRET)
C
      IF (IRET.NE.0) THEN
          CALL JEDETR(LIGRET//'.LIMA')
          CALL JEDETR(LIGRET//'.LITY')
          CALL JEDETR(LIGRET//'.MODE')
          CALL JEDETR(LIGRET//'.PHEN')
          CALL JEDETR(LIGRET//'.POMA')
          CALL JEDETR(LIGRET//'.PONO')
          CALL JEDETR(LIGRET//'.LGRF')
          CALL JEDETR(LIGRET//'.MATA')
          CALL JEDETR(LIGRET//'.LINO')
          CALL JEDETR(LIGRET//'.APMA')
          CALL JEDETR(LIGRET//'.APNO')
          CALL JEDETR(LIGRET//'.NBMA')
      ENDIF
C
C ---  CREATION DU VECTEUR DE LA LISTE DES MAILLES CUMULEES DU LIGRET :
C      --------------------------------------------------------------
      CALL WKVECT(LIGRET//'.LIMA',BASE//' V I',NBMAIL,IDLIMA)
      CALL JEECRA(LIGRET//'.LIMA','LONUTI',0,K8BID)
C
C ---  CREATION DU VECTEUR DES TYPES DES MAILLES CUMULEES DU LIGRET :
C      ------------------------------------------------------------
      CALL WKVECT(LIGRET//'.LITY',BASE//' V I',NBMAIL,IDLITY)
C
C ---  CREATION DU K16 QUI VA CONTENIR LE NOM DE LA MODELISATION :
C      ---------------------------------------------------------
      CALL WKVECT(LIGRET//'.MODE',BASE//' V K16',1,IDMODE)
C
C ---  CREATION DU K16 QUI VA CONTENIR LE NOM DU PHENOMENE :
C      ---------------------------------------------------
      CALL WKVECT(LIGRET//'.PHEN',BASE//' V K16',1,IDPHEN)
C
C ---  CREATION DU TABLEAU DE POINTEURS DANS LA LISTE DES MAILLES :
C      ----------------------------------------------------------
      CALL WKVECT(LIGRET//'.POMA',BASE//' V I',NBAJEL+1,IDPOMA)
C
C ---  CREATION DU TABLEAU DE POINTEURS DANS LA LISTE DES NOEUDS :
C      ---------------------------------------------------------
      CALL WKVECT(LIGRET//'.PONO',BASE//' V I',NBAJEL+1,IDPONO)
C
C ---  CREATION DU K8 QUI EST LE NOM DU MAILLAGE :
C      -----------------------------------------
      CALL WKVECT(LIGRET//'.LGRF',BASE//' V K8',2,JLGRF)
C
C ---  CREATION DE L'ENTIER QUI EST LE NOMBRE DE MAILLES TARDIVES :
C      ----------------------------------------------------------
      CALL WKVECT(LIGRET//'.MATA',BASE//' V I',1,IDMATA)
C
C ---  CREATION DU VECTEUR DE LA LISTE DES NOEUDS CUMULES DU LIGRET :
C      ------------------------------------------------------------
      CALL WKVECT(LIGRET//'.LINO',BASE//' V I',NBMAIL,IDLINO)
      CALL JEECRA(LIGRET//'.LINO','LONUTI',0,K8BID)
C
C ---  CREATION DE L'ENTIER QUI EST LE NOMBRE D'AFFECTATIONS DE
C ---  MAILLES (VIA AJELLT) :
C      --------------------
      CALL WKVECT(LIGRET//'.APMA',BASE//' V I',1,IDPAMA)
C
C ---  CREATION DE L'ENTIER QUI EST LE NOMBRE D'AFFECTATIONS DE
C ---  NOEUDS (VIA AJELLT) :
C      -------------------
      CALL WKVECT(LIGRET//'.APNO',BASE//' V I',1,IDPANO)
C
C ---  CREATION DE L'ENTIER QUI EST LE NOMBRE DE MAILLES PHYSIQUES :
C      -----------------------------------------------------------
      CALL WKVECT(LIGRET//'.NBMA',BASE//' V I',1,IDNBMA)
C
      CALL JEDEMA()
      END
