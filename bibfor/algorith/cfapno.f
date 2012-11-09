      SUBROUTINE CFAPNO(NOMA  ,NEWGEO,DEFICO,RESOCO,LCTFD ,
     &                  LCTF3D,NDIMG ,IZONE ,POSNOE,NUMNOE,
     &                  COORNE,POSNOM,TAU1M ,TAU2M ,ILIAI )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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

      CHARACTER*32 JEXNUM
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 NEWGEO
      REAL*8       COORNE(3)
      REAL*8       TAU1M(3),TAU2M(3)
      INTEGER      IZONE,NDIMG
      INTEGER      POSNOM,POSNOE,NUMNOE
      INTEGER      ILIAI
      LOGICAL      LCTFD ,LCTF3D
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C RECOPIE DE LA SD APPARIEMENT - CAS NODAL
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : NOUVELLE GEOMETRIE (AVEC DEPLACEMENT GEOMETRIQUE)
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LCTFD  : FROTTEMENT
C IN  LCTF3D : FROTTEMENT EN 3D
C IN  NDIMG  : DIMENSION DE L'ESPACE
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  POSNOE : INDICES DANS CONTNO DU NOEUD ESCLAVE
C IN  NUMNOE : NUMERO ABSOLU DU NOEUD ESCLAVE
C IN  COORNE : COORDONNEES DU NOEUD ESCLAVE
C IN  POSNOM : INDICES DANS CONTNO DU NOEUD MAITRE
C IN  TAU1M  : PREMIERE TANGENTE SUR LE NOEUD MAITRE
C IN  TAU2M  : SECONDE TANGENTE SUR LE NOEUD MAITRE
C IN  ILIAI  : INDICE DE LA LIAISON COURANTE
C
C
C
C
      INTEGER      IFM,NIV
      CHARACTER*19 SDAPPA
      REAL*8       TAU1(3),TAU2(3)
      REAL*8       NORM(3),NOOR
      REAL*8       R8BID,R8PREM,JEU
      REAL*8       COORNM(3)
      CHARACTER*8  NOMNOE
      INTEGER      NUMNOM,NBNOM
      REAL*8       COEFNO(9)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- NUMERO DU NOEUD MAITRE
C
      CALL CFNUMN(DEFICO,1     ,POSNOM,NUMNOM)
C
C --- LECTURE APPARIEMENT
C
      SDAPPA = RESOCO(1:14)//'.APPA'
C
C --- RECUPERATIONS DES TANGENTES AU NOEUD MAITRE
C
      CALL APVECT(SDAPPA,'APPARI_NOEUD_TAU1',POSNOM,TAU1M)
      CALL APVECT(SDAPPA,'APPARI_NOEUD_TAU2',POSNOM,TAU2M)
C
C --- COORDONNNEES DU NOEUD MAITRE
C
      CALL CFCORN(NEWGEO,NUMNOM,COORNM)
C
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS
C
      CALL CFTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &            POSNOE,'NOEU',POSNOM,NUMNOM,R8BID ,
     &            R8BID ,TAU1M ,TAU2M ,TAU1  ,TAU2  )
C
C --- CALCUL DE LA NORMALE INTERIEURE
C
      CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR  )
      IF (NOOR.LE.R8PREM()) THEN
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOE),NOMNOE)
        CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
      ENDIF
C
C --- CALCUL DU JEU
C
      CALL CFNEWJ(NDIMG ,COORNE,COORNM,NORM  ,JEU   )
C
C --- COEFFICIENT DE LA RELATION LINEAIRE SUR NOEUD MAITRE
C
      COEFNO(1) = - 1.D0
      NBNOM     = 1
C
C --- AJOUT DE LA LIAISON NODALE
C
      CALL CFADDM(RESOCO,LCTFD ,LCTF3D,POSNOE,ILIAI ,
     &            NDIMG ,NBNOM ,POSNOM,COEFNO,TAU1  ,
     &            TAU2  ,NORM  ,JEU   ,COORNM)
C
      CALL JEDEMA()
      END
