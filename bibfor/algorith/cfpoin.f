      SUBROUTINE CFPOIN(NOMA  ,DEFICO,NEWGEO,SDAPPA)
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
      CHARACTER*19 SDAPPA
      CHARACTER*24 DEFICO
      CHARACTER*19 NEWGEO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - SD APPARIEMENT)
C
C REMPLISSAGE DE LA SD APPARIEMENT - POINTS (COORD. ET NOMS)
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C
C
C
C
      INTEGER      IFM,NIV
      CHARACTER*24 APPOIN,APINFP
      INTEGER      JPOIN,JINFP
      CHARACTER*24 APNOMS
      INTEGER      JPNOMS
      INTEGER      SUPPOK
      INTEGER      IP,INOE,IZONE
      INTEGER      NBPT,NBNOE
      INTEGER      POSNOE,NUMNOE
      INTEGER      JDECNE
      REAL*8       COORPT(3)
      CHARACTER*8  NOMNOE
      CHARACTER*16 NOMPT
      INTEGER      CFDISI,NZOCO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ......... PREPARATION DE ' //
     &                'L''APPARIEMENT'
      ENDIF
C
C --- ACCES SDAPPA
C
      APPOIN = SDAPPA(1:19)//'.POIN'
      CALL JEVEUO(APPOIN,'E',JPOIN )
      APINFP = SDAPPA(1:19)//'.INFP'
      CALL JEVEUO(APINFP,'E',JINFP )
      APNOMS = SDAPPA(1:19)//'.NOMS'
      CALL JEVEUO(APNOMS,'E',JPNOMS)
C
C --- INITIALISATIONS
C
      NZOCO  = CFDISI(DEFICO,'NZOCO')
C
C --- BOUCLE SUR LES ZONES
C
      IP     = 1
      DO 10 IZONE = 1,NZOCO
C
C ----- INFORMATION SUR LA ZONE
C
        CALL APZONI(SDAPPA,IZONE ,'NBPT'  ,NBPT  )
        CALL APZONI(SDAPPA,IZONE ,'NBNOE' ,NBNOE )
        CALL APZONI(SDAPPA,IZONE ,'JDECNE',JDECNE)
C
C ----- POINTS DE CONTACT = NOEUDS ESCLAVES
C
        CALL ASSERT(NBPT.EQ.NBNOE)
C
C ----- BOUCLE SUR LES POINTS
C
        DO 20 INOE = 1,NBNOE
C
C ------- NUMERO ABSOLU DU NOEUD
C
          POSNOE = JDECNE + INOE
          CALL CFNUMN(DEFICO,1     ,POSNOE,NUMNOE)
C
C ------- COORDONNEES DU NOEUD
C
          CALL CFCORN(NEWGEO,NUMNOE,COORPT)
          ZR(JPOIN + 3*(IP-1)+1-1) = COORPT(1)
          ZR(JPOIN + 3*(IP-1)+2-1) = COORPT(2)
          ZR(JPOIN + 3*(IP-1)+3-1) = COORPT(3)
C
C ------- NOEUD EXCLU ?
C
          CALL CFMMEX(DEFICO,'CONT',IZONE ,NUMNOE,SUPPOK)
          ZI(JINFP+IP-1) = SUPPOK
C
C ------- NOM DU POINT
C
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOE),NOMNOE)
          NOMPT  = 'NOEUD   '//NOMNOE
          ZK16(JPNOMS+IP-1) = NOMPT
C
C ------- POINT SUIVANT
C
          IP     = IP + 1
  20    CONTINUE
  10  CONTINUE
C
      CALL JEDEMA()
C
      END
