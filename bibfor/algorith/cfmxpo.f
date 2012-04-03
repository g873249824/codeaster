      SUBROUTINE CFMXPO(NOMA  ,MODELZ,DEFICO,RESOCO,NUMINS,
     &                  SDDISC,SDSTAT,SOLALG,VALINC,VEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*24  RESOCO,DEFICO,SDSTAT
      CHARACTER*8   NOMA
      CHARACTER*19  SDDISC
      CHARACTER*19  SOLALG(*),VEASSE(*),VALINC(*)
      CHARACTER*(*) MODELZ
      INTEGER       NUMINS
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (POST_TRAITEMENT)
C
C POST_TRAITEMENT DU CONTACT (TOUTES METHODES)
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  MODELE : SD MODELE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMINS : NUMERO DU PAS DE CHARGE
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C
C ------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------
C
      INTEGER      IFM,NIV
      LOGICAL      CFDISL,LCTCD,LCTCC,LALLV,LXFCM
      CHARACTER*8  NOMO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- INITIALISATIONS
C
      NOMO   = MODELZ
C
C --- TYPE DE CONTACT
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LCTCD  = CFDISL(DEFICO,'FORMUL_DISCRETE')
      LALLV  = CFDISL(DEFICO,'ALL_VERIF')
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')
C
C --- GESTION DE LA  DECOUPE
C
      IF (.NOT.LALLV) THEN
        IF (LCTCD) THEN
          CALL CFDECO(DEFICO,RESOCO)
        ELSEIF (LCTCC) THEN
          CALL MMDECO(DEFICO,RESOCO)
        ELSEIF (LXFCM) THEN
          CALL XMDECO(RESOCO)
        ENDIF
      ENDIF
C
C --- VERIFICATION FACETTISATION
C
      IF (LCTCD.OR.LCTCC) THEN
        CALL CFVERL(DEFICO,RESOCO)
      ENDIF
C
C --- REMPLISSAGE DU CHAM_NO VALE_CONT ET PERCUSSION
C
      CALL CFMXRE(NOMA  ,NOMO  ,SDSTAT,DEFICO,RESOCO,
     &            NUMINS,SDDISC,SOLALG,VALINC,VEASSE)
C
      CALL JEDEMA()
      END
