      SUBROUTINE ARLAPF(MAIL  ,DIME  ,TYPMAI,NOM1  ,NOM2  ,
     &                  NOMARL,NORM  ,GRMED ,GRCOL ,CINE  ,
     &                  DEGRE ,NBMAC ,NOMC  ,NAPP  ,QUADRA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/08/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*8   MAIL
      CHARACTER*8   NOMARL
      INTEGER       DIME
      CHARACTER*16  TYPMAI
      CHARACTER*8   CINE(3)
      INTEGER       NBMAC
      INTEGER       NAPP
      CHARACTER*10  QUADRA
      INTEGER       GRCOL,GRMED
      CHARACTER*10  NOMC,NOM1,NOM2
      INTEGER       DEGRE
      CHARACTER*10  NORM
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C APPARIEMENT DES MAILLES ET FAMILLES D'INTEGRALES
C ROUTINE D'AIGUILLAGE SUIVANT GROUPE COLLAGE
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM UTILISATEUR DU MAILLAGE
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  TYPMAI : SD CONTENANT NOM DES TYPES ELEMENTS (&&CATA.NOMTM)
C IN  NOM1   : NOM DE LA SD DE STOCKAGE MAILLES GROUP_MA_1
C IN  NOM2   : NOM DE LA SD DE STOCKAGE MAILLES GROUP_MA_2
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NORM   : NOM DE LA SD POUR STOCKAGE DES NORMALES
C IN  GRMED  : GROUPE DE MAILLES SERVANT DE MEDIATEUR (1 OU 2)
C               DONNEE UTILISATEUR MOT_CLEF 'COLLAGE' (VOIR GRMED)
C IN  GRCOL  : GROUPE DANS LEQUEL SE TROUVE LA ZONE DE COLLAGE (1 OU 2)
C               FORCEMENT AUTOMATIQUE ET DETERMINEE
C IN  CINE   : CINEMATIQUES DES GROUPES DE MAILLE
C IN  DEGRE  : DEGRE MAXIMUM DU GRAPHE POUR LES DEUX ZONES
C IN  NBMAC  : NOMBRE DE MAILLES DE LA ZONE DE COLLAGE
C OUT NOMC   : NOM DE LA SD POUR LES MAILLES DE COLLAGE
C OUT NAPP   : NOMBRE DE COUPLES D'APPARIEMENT
C OUT QUADRA : SD DES QUADRATURES A CALCULER
C
C ----------------------------------------------------------------------
C
      CHARACTER*10 NOMMED,NOMGRP
      LOGICAL      ISMED
      CHARACTER*8  CINE1,CINE2
      INTEGER      IFM,NIV
      CHARACTER*14 NOMAPP

      INTEGER      NI,NR,NK
      PARAMETER   ( NI = 1 , NR = 1 , NK = 1 )
      INTEGER      VALI(NI)
      REAL*8       VALR(NR)
      CHARACTER*24 VALK(NK)

      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='ARLAPF')

C
C ----------------------------------------------------------------------
C
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- INITIALISATIONS
C
      IF (GRCOL.EQ.1) THEN
        NOMMED = NOM2
        NOMGRP = NOM1
        CINE1  = CINE(1)
        CINE2  = CINE(2)
      ELSEIF (GRCOL.EQ.2) THEN
        NOMMED = NOM1
        NOMGRP = NOM2
        CINE1  = CINE(2)
        CINE2  = CINE(1)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CONSTRUCTION D'UN ARBRE DE PARTITION BINAIRE DE L'ESPACE (BSP)
C
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NI,VALI,NR,VALR,NK,VALK)
      CALL ARLBSP(NOMARL,NOMMED)
C
C --- APPARIEMENT DES MAILLES EN VIS-A-VIS
C
      CALL ARLDBG(NOMPRO,NIV,IFM,2,NI,VALI,NR,VALR,NK,VALK)
      CALL ARLAPP(MAIL  ,TYPMAI,NOMGRP,NOMMED,NORM,
     &            NOMARL,DEGRE ,NBMAC ,NOMC  ,NAPP)
C
      IF (NIV.GE.2) THEN
        NOMAPP = NOMARL(1:8)//'.GRAPH'
        CALL APPAIM(IFM,NOMGRP,NOMMED,NOMAPP)
      ENDIF
C
C --- DESTRUCTION DE L'ARBRE
C
      CALL ARLDSD('ARBRE',NOMMED)
C
C --- REGROUPEMENT DES INTEGRALES A CALCULER POUR LA JONCTION
C
      ISMED = GRCOL.EQ.GRMED
C
      CALL ARLDBG(NOMPRO,NIV,IFM,3,NI,VALI,NR,VALR,NK,VALK)
      CALL ARLFAM(MAIL  ,NOMARL,NOMGRP,NOMMED,NAPP  ,
     &            TYPMAI,NOMC  ,ISMED ,QUADRA)
C
      IF (NIV.GE.2) THEN
        CALL QUADIM(IFM,ISMED,QUADRA,NOMGRP,NOMMED)
      ENDIF
C
C --- ALLOCATION ET ECRITURE DES POINTEURS DES MATRICES DE COUPLAGE
C
      CALL ARLDBG(NOMPRO,NIV,IFM,4,NI,VALI,NR,VALR,NK,VALK)
      CALL ARLFC0(MAIL  ,DIME  ,ISMED ,NOMGRP,NOMMED,
     &            CINE1 ,CINE2 ,NOMC  ,NOMARL)
C
C --- DESTRUCTION DES CONNECTIVITES INVERSES
C
      CALL ARLDSD('CNCINV',NOM1)
      CALL ARLDSD('CNCINV',NOM2)
C
      END
