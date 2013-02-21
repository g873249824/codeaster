      SUBROUTINE W039CA(IFI,FORM)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER IFI
      CHARACTER*(*) FORM
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
C ----------------------------------------------------------------------
C     BUT:
C       IMPRIMER LES "CARTES" DE DONNEES DES CHAM_MATER, CARA_ELE, ...
C ----------------------------------------------------------------------
C
C
C
C
      INTEGER NOCC,IOCC,N1,IBID
      CHARACTER*3 RPLO
      CHARACTER*8 CHMAT,CARELE,MAILLA,CHARGE,MODELE
      CHARACTER*80 TITRE
      CHARACTER*19 LIGREL
      LOGICAL LEXI
      INTEGER      IARG
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      LEXI=.FALSE.
      LIGREL='&&W039CA.LIGREL'

      IF (.NOT.(FORM.EQ.'MED'.OR.FORM.EQ.'RESULTAT'))GOTO 20



      CALL GETFAC('CONCEPT',NOCC)
      DO 10 IOCC=1,NOCC

C       -- CHAM_MATER :
C       ----------------
        CALL GETVID('CONCEPT','CHAM_MATER',IOCC,IARG,1,CHMAT,N1)
        IF (N1.EQ.1) THEN
          IF (.NOT.LEXI) THEN
            CALL DISMOI('F','NOM_MAILLA',CHMAT,'CHAM_MATER',IBID,
     &                MAILLA,IBID)
            CALL LGPHMO(MAILLA,LIGREL,'PRESENTATION','TOUT')
            LEXI=.TRUE.
          ENDIF


          TITRE='Champ de MATERIAUX'
          CALL W039C1(CHMAT//'.CHAMP_MAT',IFI,FORM,LIGREL,TITRE)
        ENDIF

C       -- CARA_ELEM :
C       ----------------
        CALL GETVID('CONCEPT','CARA_ELEM',IOCC,IARG,1,CARELE,N1)
        IF (N1.EQ.1) THEN
          IF (.NOT.LEXI) THEN
            CALL DISMOI('F','NOM_MAILLA',CARELE,'CARA_ELEM',IBID,
     &                MAILLA,IBID)
            CALL LGPHMO(MAILLA,LIGREL,'PRESENTATION','TOUT')
            LEXI=.TRUE.
          ENDIF


          TITRE='Caracteristiques generales des barres'
          CALL W039C1(CARELE//'.CARGENBA',IFI,FORM,LIGREL,TITRE)
          TITRE='Caracteristiques geom. des barres'
          CALL W039C1(CARELE//'.CARGEOBA',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques generales des poutres'
          CALL W039C1(CARELE//'.CARGENPO',IFI,FORM,LIGREL,TITRE)
          TITRE='Caracteristiques geom. des poutres'
          CALL W039C1(CARELE//'.CARGEOPO',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des cables'
          CALL W039C1(CARELE//'.CARCABLE',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des poutres courbes'
          CALL W039C1(CARELE//'.CARARCPO',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des poutres "fluides"'
          CALL W039C1(CARELE//'.CARPOUFL',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des elements discrets K_*'
          CALL W039C1(CARELE//'.CARDISCK',IFI,FORM,LIGREL,TITRE)
          CALL W039C1(CARELE//'.CARDNSCK',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des elements discrets M_*'
          CALL W039C1(CARELE//'.CARDISCM',IFI,FORM,LIGREL,TITRE)
          CALL W039C1(CARELE//'.CARDNSCM',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques des elements discrets A_*'
          CALL W039C1(CARELE//'.CARDISCA',IFI,FORM,LIGREL,TITRE)
          CALL W039C1(CARELE//'.CARDNSCA',IFI,FORM,LIGREL,TITRE)

          TITRE='Caracteristiques geom. des coques'
          CALL W039C1(CARELE//'.CARCOQUE',IFI,FORM,LIGREL,TITRE)

          TITRE='Orientation des elements 2D et 3D'
          CALL W039C1(CARELE//'.CARMASSI',IFI,FORM,LIGREL,TITRE)

          TITRE='Orientation des coques et des poutres'
          CALL W039C1(CARELE//'.CARORIEN',IFI,FORM,LIGREL,TITRE)

          CALL GETVTX('CONCEPT','REPERE_LOCAL',IOCC,IARG,1,RPLO,IBID)
          CALL ASSERT(IBID.EQ.1)
          IF (RPLO.EQ.'OUI') THEN
            CALL GETVID('CONCEPT','MODELE',IOCC,IARG,1,MODELE,IBID)
            CALL ASSERT(IBID.EQ.1)

            TITRE = 'vecteur du repere local'
            CALL W039C3(CARELE,MODELE,IFI,FORM,TITRE)


          ENDIF

        ENDIF

C       -- CHARGE :
C       ----------------
        CALL GETVID('CONCEPT','CHARGE',IOCC,IARG,1,CHARGE,N1)
        IF (N1.EQ.1) THEN
          IF (.NOT.LEXI) THEN
            CALL DISMOI('F','NOM_MAILLA',CHARGE,'CHARGE',IBID,
     &                MAILLA,IBID)
            CALL LGPHMO(MAILLA,LIGREL,'PRESENTATION','TOUT')
            LEXI=.TRUE.
          ENDIF


          TITRE='Chargement de PESANTEUR'
          CALL W039C1(CHARGE//'.CHME.PESAN',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de ROTATION'
          CALL W039C1(CHARGE//'.CHME.ROTAT',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de PRES_REP'
          CALL W039C1(CHARGE//'.CHME.PRESS',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces volumiques en 3D'
          CALL W039C1(CHARGE//'.CHME.F3D3D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces surfaciques en 3D'
          CALL W039C1(CHARGE//'.CHME.F2D3D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces lineiques en 3D'
          CALL W039C1(CHARGE//'.CHME.F1D3D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces surfaciques en 2D'
          CALL W039C1(CHARGE//'.CHME.F2D2D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces lineiques en 2D'
          CALL W039C1(CHARGE//'.CHME.F1D2D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de forces reparties pour les coques'
          CALL W039C1(CHARGE//'.CHME.FCO3D',IFI,FORM,LIGREL,TITRE)
          CALL W039C1(CHARGE//'.CHME.FCO2D',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de EPSI_INIT'
          CALL W039C1(CHARGE//'.CHME.EPSIN',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de SIGM_INTERNE'
          CALL W039C1(CHARGE//'.CHME.SIINT',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de FORCE_ELEC'
          CALL W039C1(CHARGE//'.CHME.FELEC',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement de FLUX_THM_REP'
          CALL W039C1(CHARGE//'.CHME.FLUX',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement d''IMPE_FACE'
          CALL W039C1(CHARGE//'.CHME.IMPE',IFI,FORM,LIGREL,TITRE)

          TITRE='Chargement d''ONDE_FLUI'
          CALL W039C1(CHARGE//'.CHME.ONDE',IFI,FORM,LIGREL,TITRE)

        ENDIF
   10 CONTINUE



   20 CONTINUE
      CALL DETRSD('LIGREL',LIGREL)
      CALL JEDEMA()
      END
