      SUBROUTINE TE0496(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C     ----------------------------------------------------------------
C MODIF ELEMENTS  DATE 05/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DU NOMBRE DE VARIABLES INTERNES ET DU NOMBRE DE SOUS-POINTS
C     POUR TOUS LES TYPE_ELEM
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER NBCOU,NPGH,NBSECT,NBFIBR,NBVARI,JCOMPO,JDCEL,JNBSP,ITAB(2)
      INTEGER IRET
      LOGICAL LTEATT


      CALL JEVECH('PDCEL_I','E',JDCEL)

C     PCOMPOR CONTIENT 1 SEULE CMP : NBVARI
C     ET LES AUTRES INFO VIENNENT DE PNBSP_I
C     SI PCOMPOR N'EST PAS FOURNI : NCMP_DYN = 0
C     ------------------------------------------------
      CALL TECACH('ONN','PCOMPOR',2,ITAB,IRET)
      IF (ITAB(1).NE.0) THEN
        CALL ASSERT(ITAB(2).EQ.1)
        JCOMPO=ITAB(1)
        READ (ZK16(JCOMPO-1+1),'(I16)') NBVARI
      ELSE
        NBVARI=0
      END IF


C     PNBSP_I  CONTIENT LES INFOS NECESSSAIRES AU CALCUL
C     DU NOMBRE DE SOUS-POINTS.
C     SI LE CHAMP N'EST PAS DONNE, NBSPT=1
C     (VATU_ELNO PAR EXEMPLE)
C     -----------------------------------------------------
      CALL TECACH('NNN','PNBSP_I',1,JNBSP,IRET)




C     -- CAS DES ELEMENTS "COQUE EPAISSE" (MULTI-COUCHE) :
C     ------------------------------------------------------------
      IF ((NOMTE.EQ.'MEC3QU9H') .OR. (NOMTE.EQ.'MEC3TR7H') .OR.
     &    (NOMTE.EQ.'METCSE3') .OR. (NOMTE.EQ.'METDSE3') .OR.
     &    (NOMTE.EQ.'MECXSE3')) THEN
        IF (JNBSP.NE.0) THEN
          NBCOU = ZI(JNBSP-1+1)
          NPGH = 3
          ZI(JDCEL-1+1) = NPGH*NBCOU
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI



C     -- CAS DES ELEMENTS "DKT"
C     ------------------------------------------------------------
      ELSE IF ( (NOMTE.EQ.'MEDKQU4') .OR. (NOMTE.EQ.'MEDKTR3') .OR.
     &          (NOMTE.EQ.'MEDSQU4') .OR. (NOMTE.EQ.'MEDSTR3') .OR.
     &          (NOMTE.EQ.'MEQ4QU4') ) THEN
        IF (JNBSP.NE.0) THEN
          NBCOU = ZI(JNBSP-1+1)
          NPGH = 3
          ZI(JDCEL-1+1) = NPGH*NBCOU
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI



C     -- CAS DES ELEMENTS "GRILLE"
C     ------------------------------------------------------------
      ELSE IF ( LTEATT(' ','GRILLE','OUI') ) THEN
        IF (JNBSP.NE.0) THEN
          NBCOU = ZI(JNBSP-1+1)
          NPGH = 1
          ZI(JDCEL-1+1) = NPGH*NBCOU
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI


C     -- CAS DES ELEMENTS  "TUYAU" :
C     ------------------------------------------------------------
      ELSE IF ((NOMTE.EQ.'MET3SEG3') .OR. (NOMTE.EQ.'MET6SEG3') .OR.
     &         (NOMTE.EQ.'MET3SEG4')) THEN
        IF (JNBSP.NE.0) THEN
          NBCOU = ZI(JNBSP-1+1)
          NBSECT = ZI(JNBSP-1+2)
          ZI(JDCEL-1+1) = (2*NBSECT+1)* (2*NBCOU+1)
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI


C     -- CAS DES ELEMENTS DE POUTRE "MULTIFIBRES" :
C     ------------------------------------------------------------
      ELSE IF (NOMTE.EQ.'MECA_POU_D_EM') THEN
        IF (JNBSP.NE.0) THEN
          NBFIBR = ZI(JNBSP-1+1)
          ZI(JDCEL-1+1) = NBFIBR
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI

      ELSE IF (NOMTE.EQ.'MECA_POU_D_TGM') THEN
        IF (JNBSP.NE.0) THEN
          NBFIBR = ZI(JNBSP-1+1)
          ZI(JDCEL-1+1) = NBFIBR
        ELSE
          ZI(JDCEL-1+1) = 1
        END IF
        ZI(JDCEL-1+2) = NBVARI

C     -- CAS DES AUTRES ELEMENTS (ORDINAIRES):
C     ------------------------------------------------------------
      ELSE
        ZI(JDCEL-1+1) = 1
        ZI(JDCEL-1+2) = NBVARI
      END IF


      END
