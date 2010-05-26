      SUBROUTINE MMPREL(CHAR  ,NOMA  ,NOMO  ,LIGRET)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/05/2010   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  CHAR,NOMA,NOMO
      CHARACTER*19 LIGRET
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - LECTURE DONNEES)
C
C CREATION DES ELEMENTS ESCLAVES TARDIFS
C
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C OUT LIGRET : LIGREL D'ELEMENTS TARDIFS DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 PARACI,CONTMA
      INTEGER      JPARCI,JMACO
      LOGICAL      MMMAXI,MMINFL,LFROT,LAXIS
      CHARACTER*24 LISMAE,DEFICO
      CHARACTER*16 MODELI,PHENOM
      INTEGER      IBID,IER,JDECMA,JLIST,IZONE
      INTEGER      CFDISI,NZOCO,NDIM,NMACO,NTMAE
      INTEGER      ISURFE,IMAE,POSMAE,NUMMAE,NBMAE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      LISMAE = '&&MMPREL.LISTE_MAILLES'
      DEFICO = CHAR(1:8)//'.CONTACT'
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      CONTMA = DEFICO(1:16)//'.MAILCO'
      PARACI = DEFICO(1:16)//'.PARACI'
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(PARACI,'E',JPARCI)
C
C --- RECUPERATION DU NOM DU PHENOMENE ET DE LA  MODELISATION
C
      CALL DISMOI('F','PHENOMENE'   ,NOMO,'MODELE',IBID,PHENOM,IER)
C
C --- INFOS DE LA ZONE
C
      NDIM    = CFDISI(DEFICO,'NDIM' )
      NMACO   = CFDISI(DEFICO,'NMACO' )
      NTMAE   = CFDISI(DEFICO,'NTMAE' )
      NZOCO   = CFDISI(DEFICO,'NZOCO' )
C
C --- MAILLES AXISYMETRIQUES ?
C
      LAXIS   = .FALSE.
      IF (NDIM .EQ. 2) THEN
        LAXIS = MMMAXI(NOMO  ,CONTMA,NMACO)
      ENDIF
      IF (LAXIS) THEN
        ZI(JPARCI+16-1) = 1
      ELSE
        ZI(JPARCI+16-1) = 0
      ENDIF
C
C --- AJOUT DES ELEMENTS TARDIFS AU LIGREL
C
      CALL WKVECT(LISMAE,'V V I',NTMAE ,JLIST )
      DO 20 IZONE = 1,NZOCO
        LFROT  = MMINFL(DEFICO,'FROTTEMENT_ZONE',IZONE)
        IF (NDIM .EQ. 2) THEN
          IF ( LFROT ) THEN
            MODELI = 'COFR_DVP_2D'
          ELSE
            MODELI = 'CONT_DVP_2D'
          END IF
        ELSEIF (NDIM .EQ. 3) THEN
          IF ( LFROT ) THEN
            MODELI = 'COFR_DVP_3D'
          ELSE
            MODELI = 'CONT_DVP_3D'
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        END IF

        CALL CFZONE(DEFICO,IZONE ,'ESCL',ISURFE)
        CALL CFNBSF(DEFICO,ISURFE,'MAIL',NBMAE ,JDECMA)
        DO 10 IMAE = 1 , NBMAE
          POSMAE = JDECMA+IMAE
          NUMMAE = ZI(JMACO+POSMAE-1)
          ZI(JLIST+IMAE-1) = NUMMAE
  10    CONTINUE
        CALL AJELLT(LIGRET,NOMA  ,NBMAE ,LISMAE,' '   ,
     &              PHENOM,MODELI,0     ,' '   )
  20  CONTINUE
C
      CALL JEDETR(LISMAE)
      CALL JEDEMA()
      END
