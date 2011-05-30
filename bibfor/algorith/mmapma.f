      SUBROUTINE MMAPMA(NOMA  ,DEFICO,RESOCO,NDIMG ,IZONE ,
     &                  LEXFRO,TYPINT,ALIASE,POSMAE,NUMMAE,
     &                  NNOMAE,POSMAM,NUMMAM,KSIPR1,KSIPR2,
     &                  TAU1M ,TAU2M ,IPTM  ,IPTC  ,NORM  ,
     &                  NOMMAM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/05/2011   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*8  NOMA
      CHARACTER*8  ALIASE
      CHARACTER*24 DEFICO,RESOCO
      REAL*8       KSIPR1,KSIPR2
      INTEGER      NDIMG
      INTEGER      POSMAE,NUMMAE
      INTEGER      POSMAM,NUMMAM,NNOMAE
      INTEGER      IZONE,IPTM,IPTC
      INTEGER      TYPINT
      REAL*8       TAU1M(3),TAU2M(3),NORM(3)
      CHARACTER*8  NOMMAM
      LOGICAL      LEXFRO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES CONTINUES - APPARIEMENT)
C
C RECOPIE DE LA SD APPARIEMENT - CAS MAIT_ESCL
C
C ----------------------------------------------------------------------
C
C
C IN  LSSFRO : IL Y A DES NOEUDS DANS SANS_GROUP_NO_FR
C IN  NOMA   : NOM DU MAILLAGE
C IN  ALIASE : NOM D'ALIAS DE L'ELEMENT ESCLAVE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  NDIMG  : DIMENSION DE L'ESPACE
C IN  IZONE  : ZONE DE CONTACT ACTIVE
C IN  LEXFRO : LE POINT D'INTEGRATION DOIT-IL ETRE EXCLUS DU FROTTEMENT?
C IN  POSMAM : POSITION DE LA MAILLE MAITRE DANS LES SD CONTACT
C IN  NUMMAM : NUMERO ABSOLU MAILLE MAITRE QUI RECOIT LA PROJECTION
C IN  POSMAE : POSITION DE LA MAILLE ESCLAVE DANS LES SD CONTACT
C IN  NNOMAE : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  TYPINT : TYPE D'INTEGRATION
C IN  IPTM   : NUMERO DU POINT D'INTEGRATION DANS LA MAILLE
C IN  KSIPR1 : PREMIERE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
C              SUR MAILLE MAITRE
C IN  KSIPR2 : SECONDE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
C              SUR MAILLE MAITRE
C IN  TAU1M  : PREMIERE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
C              PROJETE
C IN  TAU2M  : SECONDE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
C              PROJETE
C OUT NORM   : NORMALE FINALE
C OUT NOMMAM : NOM DE LA MAILLE MAITRE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
      REAL*8       NOOR,R8PREM
      REAL*8       KSIPC1,KSIPC2,WPC
      REAL*8       TAU1(3),TAU2(3)
      INTEGER      POSNOE,NUMNOE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- POSITION DU NOEUD ESCLAVE SI INTEGRATION AUX NOEUDS
C
      CALL MMPNOE(DEFICO,POSMAE,ALIASE,TYPINT,IPTM  ,
     &            POSNOE)
C
C --- NUMERO ABSOLU DU POINT DE CONTACT
C
      CALL MMNUMN(NOMA  ,TYPINT,NUMMAE,NNOMAE,IPTM  ,
     &            NUMNOE)
C
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS
C
      CALL MMTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &            LEXFRO,POSNOE,KSIPR1,KSIPR2,POSMAM,
     &            NUMMAM,TAU1M ,TAU2M ,TAU1  ,TAU2  )
C
C --- CALCUL DE LA NORMALE
C
      CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR  )
      IF (NOOR.LE.R8PREM()) THEN
        CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAM),NOMMAM)
        CALL U2MESK('F','CONTACT3_24',1,NOMMAM)
      ENDIF
C
C --- POIDS ET COORDONNEES DU POINT DE CONTACT
C
      CALL MMGAUS(ALIASE,TYPINT,IPTM  ,KSIPC1,KSIPC2,
     &            WPC   )
C
C --- SAUVEGARDE APPARIEMENT
C
      CALL MMSAUV(RESOCO,IZONE ,IPTC  ,NUMMAM,KSIPR1,
     &            KSIPR2,TAU1  ,TAU2  ,NUMMAE,NUMNOE,
     &            KSIPC1,KSIPC2,WPC   )
C
      CALL JEDEMA()
      END
