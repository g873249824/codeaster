      SUBROUTINE LRMMF3 ( FID, NOMAMD,
     &                    RANGFA, CARAFA,
     &                    NBNOEU, FAMNOE,
     &                    NMATYP, JFAMMA, JNUMTY,
     &                    VAATFA, NOGRFA, TABAUX,
     &                    NOMGRO, NUMGRO, NUMENT,
     &                    INFMED, NIVINF, IFM,
     &                    VECGRM, NBCGRM, NBGRLO )
C TOLE CRP_21
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 18/12/2012   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE SELLENET N.SELLENET
C-----------------------------------------------------------------------
C     LECTURE DU MAILLAGE - FORMAT MED - LES FAMILLES - 3
C     -    -     -                 -         -          -
C-----------------------------------------------------------------------
C    . SI LA DESCRIPTION D'UNE FAMILLE CONTIENT DES NOMS DE GROUPES, ON
C    VA CREER AUTANT DE GROUPES QUE DECRITS ET ILS PORTERONT CES NOMS.
C    TOUTES LES ENTITES DE LA FAMILLE APPARTIENDRONT A CES GROUPES. UN
C    GROUPE PEUT APPARAITRE DANS LA DESCRIPTION DE PLUSIEURS FAMILLES.
C    SON CONTENU SERA DONC ENRICHI AU FUR ET A MESURE DE L'EXPLORATION
C    DES FAMILLES.
C    . SI LA DESCRIPTION D'UNE FAMILLE NE CONTIENT PAS DE NOMS DE GROUPE
C    ON CREERA DES GROUPES EN SE BASANT SUR UNE IDENTITE D'ATTRIBUTS.
C    LE NOM DE CHAQUE GROUPE EST 'GN' OU 'GM' SELON QUE C'EST UN GROUPE
C    DE NOEUDS OU DE MAILLES, SUIVI DE LA VALEUR DE L'ATTRIBUT. UN MEME
C    ATTRIBUT PEUT APPARAITRE DANS LA DESCRIPTION DE PLUSIEURS FAMILLES.
C    LE CONTENU DU GROUPE ASSOCIE SERA DONC ENRICHI AU FUR ET A MESURE
C    DE L'EXPLORATION DES FAMILLES.
C
C    LE PREMIER CAS APPARAIT QUAND ON RELIT UN FICHIER MED CREE PAR
C    ASTER, OU PAR UN LOGICIEL QUI UTILISERAIT LA NOTION DE GROUPE DE
C    LA MEME MANIERE.
C    LE SECOND CAS A LIEU QUAND LE FICHIER MED A ETE CREE PAR UN
C    LOGICIEL QUI IGNORE LA NOTION DE GROUPE.
C
C ENTREES :
C   FID    : IDENTIFIANT DU FICHIER MED
C   NOMAMD : NOM DU MAILLAGE MED
C   RANGFA : RANG DE LA FAMILLE EN COURS D'EXAMEN
C   NBNOEU : NOMBRE DE NOEUDS
C   FAMNOE : NUMERO DE FAMILLE POUR CHAQUE NOEUD
C   NMATYP : NOMBRE DE MAILLES DU MAILLAGE PAR TYPE DE MAILLES
C   JFAMMA : POUR UN TYPE DE MAILLE, ADRESSE DANS LE TABLEAU DES
C            FAMILLES D'ENTITES
C   JNUMTY : POUR UN TYPE DE MAILLE, ADRESSE DANS LE TABLEAU DES
C            RENUMEROTATIONS
C   VECGRM : VECTEUR DE CORRESPONDANCE DES NOMS DE GROUPES MED / ASTER
C   NBCGRM : NOMBRE DE CORRESPONDANCE
C SORTIES :
C   NOMGRO : COLLECTION DES NOMS DES GROUPES A CREER
C   NUMGRO : COLLECTION DES NUMEROS DES GROUPES A CREER
C   NUMENT : COLLECTION DES NUMEROS DES ENTITES DANS LES GROUPES
C TABLEAUX DE TRAVAIL
C   VAATFA : VALEUR DES ATTRIBUTS ASSOCIES A CHAQUE FAMILLE.
C   NOGRFA : NOM DES GROUPES ASSOCIES A CHAQUE FAMILLE.
C   TABAUX :
C DIVERS
C   INFMED : NIVEAU DES INFORMATIONS SPECIFIQUES A MED A IMPRIMER
C   NIVINF : NIVEAU DES INFORMATIONS GENERALES
C   IFM    : UNITE LOGIQUE DU FICHIER DE MESSAGE
C ENTREES/SORTIES :
C   CARAFA : CARACTERISTIQUES DE CHAQUE FAMILLE
C     CARAFA(1,I) = NOMBRE DE GROUPES
C     CARAFA(2,I) = NOMBRE D'ATTRIBUTS
C     CARAFA(3,I) = NOMBRE D'ENTITES
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 66)
C
C 0.1. ==> ARGUMENTS
C
      INTEGER FID, NBCGRM
      INTEGER RANGFA, CARAFA(3,*)
      INTEGER NBNOEU, FAMNOE(NBNOEU)
      INTEGER NMATYP(NTYMAX), JFAMMA(NTYMAX), JNUMTY(NTYMAX)
      INTEGER VAATFA(*)
      INTEGER TABAUX(*)
      INTEGER INFMED
      INTEGER IFM, NIVINF, NBGRLO, MAJOR, MINOR, REL, CRET
C
      CHARACTER*(*) NOMGRO, NUMGRO, NUMENT
      CHARACTER*(*) NOGRFA(*)
      CHARACTER*(*) NOMAMD, VECGRM
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRMMF3' )
C
      INTEGER CODRET, I, CODRE2
      INTEGER VALI
      INTEGER IAUX, JAUX, KAUX,JAU2
      INTEGER ITYP, INDIK8, INOM, ITMP, IVGRM
      INTEGER NUMFAM, MI(2)
      INTEGER NBATTR, NBGROU, NBENFA
      INTEGER IDATFA(200)
      INTEGER ADNOMG, ADNUMG, ADNUME, NVNBGR
      INTEGER ILMED, ILNEW, NOGRLO, JNOGRL, JNOGRC
      LOGICAL IERR, RENOMM, ERRGM
      REAL*8  MR
      CHARACTER*80 KBID, NEWGRM
C
      CHARACTER*2 SAUX02
      CHARACTER*8 SAUX08
      CHARACTER*24 K24B,SAUX24
      CHARACTER*64 NOMFAM
      CHARACTER*80 VALK(4)
      CHARACTER*200 DESCAT(200)
C
      INTEGER LXLGUT
C
C     ------------------------------------------------------------------
C
      IERR = .FALSE.
      IF ( NIVINF.GE.2 ) THEN
        WRITE (IFM,1001) NOMPRO
 1001 FORMAT( 60('-'),/,'DEBUT DU PROGRAMME ',A)
      ENDIF
C
C====
C 0. TABLEAU DE CORRESPONDANCE NOM MED - NOM ASTER
C====
      IF ( NBCGRM .GT. 0 ) THEN
         CALL JEVEUO(VECGRM, 'L', IVGRM)
      ENDIF
C
C====
C 1. CARACTERISTIQUES DE LA FAMILLE
C====
C
C 1.1. ==> LECTURE DANS LE FICHIER MED
C
C     NOMBRE MAXI D'ATTRIBUTS
      NBATTR = 200
      NOMFAM = ' '
      CALL INITCH(DESCAT, NBATTR)
      CALL MFVELI (FID,MAJOR,MINOR,REL,CRET)
      IF ( MAJOR.EQ.3 ) THEN
        CALL MFFAM3 ( FID,  NOMAMD, RANGFA, NOMFAM, NUMFAM,
     &                NOGRFA, CODRET )
        NBATTR = 0
      ELSE
        CALL MFFAMI ( FID,  NOMAMD, RANGFA, NOMFAM, NUMFAM,
     &                IDATFA, VAATFA, DESCAT, NBATTR,
     &                NOGRFA, CODRET )
        CALL MFNATT( FID, NOMAMD, RANGFA, NBATTR, CODRE2 )
      ENDIF
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFFAMI  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
      CALL MFNGRO( FID, NOMAMD, RANGFA, NBGROU, CODRET )
C
      CALL JEVEUO('&&LRMMF1.NOM_GR_LONG','E',JNOGRL)
      CALL JELIRA('&&LRMMF1.NOM_GR_LONG','LONMAX',NOGRLO, KBID)
      CALL JEVEUO('&&LRMMF1.NOM_GR_COURT','E',JNOGRC)
C
C 1.2. ==> INFORMATION EVENTUELLE
C
      IF ( INFMED.GE.3 ) THEN
        IF ( NUMFAM.GT.0 ) THEN
          JAUX = 1
        ELSE
          JAUX = 2
        ENDIF
        KAUX = -1
        CALL DESGFA ( JAUX, NUMFAM, NOMFAM,
     &                NBGROU, NOGRFA, NBATTR, VAATFA,
     &                KAUX, KAUX,
     &                IFM, CODRET )
      ENDIF
C
C====
C 2. SI LA FAMILLE N'EST PAS LA FAMILLE NULLE, DECODAGE
C====
C
      IF ( NUMFAM.NE.0 ) THEN
C
        IF ( INFMED.GE.2 ) THEN
           CALL U2MESG('I','MED_14',1,NOMFAM,1,NUMFAM,0,MR)
        ENDIF
C
C 2.0. ==> CONTROLE DE LA LONGUEUR DES NOMS DES GROUPES
C
        IF ( NBGROU.GT.0 ) THEN
C
          DO 20 , IAUX = 1 , NBGROU
C   2.0.1. --- RENOMMAGE PAR L'UTILISATEUR
            RENOMM = .FALSE.
            ERRGM  = .FALSE.
            IF ( NBCGRM .GT. 0 ) THEN
               ILMED = LXLGUT(NOGRFA(IAUX))
               DO 910 I=1, NBCGRM
                  KBID = ZK80(IVGRM-1+I*2-1)
                  ILNEW = LXLGUT(KBID)
                  IF (NOGRFA(IAUX)(1:ILMED) .EQ. KBID(1:ILNEW)) THEN
                     KBID = ZK80(IVGRM-1+I*2)
                     ILNEW = LXLGUT(KBID)
                     RENOMM = .TRUE.
                     VALK(1) = NOGRFA(IAUX)
                     VALK(2) = KBID(1:ILNEW)
                     IF ( INFMED.GE.2 ) THEN
                        CALL U2MESG('I','MED_16',2,VALK,1,IAUX,0,MR)
                     ENDIF
                     NEWGRM = KBID(1:ILNEW)
                  ENDIF
C
C          --- VERIFIER QUE LES NOUVEAUX NOMS N'EXISTENT PAS DEJA
                  KBID = ZK80(IVGRM-1+I*2)
                  ILNEW = LXLGUT(KBID)
                  IF (NOGRFA(IAUX)(1:ILMED) .EQ. KBID(1:ILNEW)) THEN
                     ERRGM = .TRUE.
                     VALK(1) = ZK80(IVGRM-1+I*2-1)
                     VALK(2) = KBID(1:ILNEW)
                     CALL U2MESK('E','MED_9',2,VALK)
                  ENDIF
 910           CONTINUE
            ENDIF
            IF ( .NOT. RENOMM ) THEN
               IF ( INFMED.GE.2 ) THEN
                  CALL U2MESG('I','MED_15',1,NOGRFA(IAUX),1,IAUX,0,MR)
               ENDIF
            ELSE
               NOGRFA(IAUX) = NEWGRM
            ENDIF
            IF ( ERRGM ) THEN
               CALL U2MESS('F', 'MED_18')
            ENDIF
C
C   2.0.2. --- SUPPRESSION DES CARACTERES INTERDITS (ACCENTS...)
            CALL LXNOAC(NOGRFA(IAUX), NEWGRM)
            IF ( NOGRFA(IAUX).NE.NEWGRM ) THEN
              JAU2 = LXLGUT(NOMFAM)
              MI(1) = IAUX
              VALK(1) = NOMFAM(1:JAU2)
              VALK(2) = NOGRFA(IAUX)
              VALK(3) = NEWGRM(1:24)
              CALL U2MESG('A', 'MED_10', 3, VALK, 1, MI, 0, MR)
              NOGRFA(IAUX) = NEWGRM(1:24)
            ENDIF
C
C   2.0.3. --- CONTROLE QUE LA LONGUEUR <= 8
            JAUX = LXLGUT(NOGRFA(IAUX))
            IF ( JAUX.GT.24 ) THEN
              JAU2 = LXLGUT(NOMFAM)
              MI(1) = IAUX
              VALK(1) = NOMFAM(1:JAU2)
              VALK(2) = NOGRFA(IAUX)
              VALK(3) = NOGRFA(IAUX)(1:24)
              CALL U2MESG('A', 'MED_7', 3, VALK, 1, MI, 0, MR)
C
C   2.0.3. --- CONTROLE QUE LE NOM EST NON VIDE
            ELSEIF(JAUX.EQ.0)THEN
              JAU2 = LXLGUT(NOMFAM)
              MI(1) = IAUX
              VALK(1) = NOMFAM(1:JAU2)
              CALL U2MESG('F', 'MED_11', 1, VALK, 1, MI, 0, MR)
            ENDIF
   20     CONTINUE
C
        ENDIF
C
C 2.1. ==> IL FAUT AU MOINS UN GROUPE OU UN ATTRIBUT
C
        IF ( NBGROU.EQ.0 .AND. NBATTR.EQ.0 ) THEN
          CALL U2MESK('A','MED_13',1,NOMFAM)
        ENDIF
C
C 2.2. ==> COHERENCE DES NOMBRES DE GROUPES OU D'ATTRIBUTS
C
        VALK(1) = NOMFAM
        IF ( NBGROU.NE.CARAFA(1,RANGFA) ) THEN
          MI(1) = CARAFA(1,RANGFA)
          MI(2) = NBGROU
          VALK(2) = 'groupes'
        ENDIF
        IF ( NBATTR.NE.CARAFA(2,RANGFA) ) THEN
          MI(1) = CARAFA(2,RANGFA)
          MI(2) = NBATTR
          VALK(2) = 'attributs'
        ENDIF
        IF ( ( NBGROU.NE.CARAFA(1,RANGFA) ) .OR. 
     &       ( NBATTR.NE.CARAFA(2,RANGFA) ) ) THEN
          CALL U2MESG('F','MED_8', 2, VALK, 2, MI, 0, MR)
        ENDIF
C
C 2.3. ==> CREATION :
C        COLLECTION INVERSE       FAM I -> NUMNO(MA)X,NUMNO(MA)Y..
C     ET VECTEUR DES LONGUEURS    FAM I -> NBNUMNO(MA)
C       (POUR EVITER DE FAIRE DES TONNES DE JELIRA APRES)
C          MEMORISATION DU DU NOMBRE D'ENTITES QUE LA FAMILLE CONTIENT
C
        NBENFA = 0
C
C 2.3.1. ==> POUR UNE FAMILLE DE NOEUDS : LE TABLEAU TABAUX CONTIENDRA
C            LA LISTE DES NOEUDS DE LA FAMILLE
C
        IF ( NUMFAM.GT.0 ) THEN
C
          DO 231 , IAUX = 1 , NBNOEU
            IF ( NUMFAM.EQ.FAMNOE(IAUX) ) THEN
              NBENFA = NBENFA + 1
              TABAUX(NBENFA) = IAUX
            ENDIF
  231     CONTINUE
C
C 2.3.2. ==> POUR UNE FAMILLE DE MAILLES : LE TABLEAU TABAUX CONTIENDRA
C            LA LISTE DES MAILLES DE LA FAMILLE, TYPE PAR TYPE.
C
        ELSEIF ( NUMFAM.LT.0 ) THEN
C
          DO 232 , ITYP = 1 , NTYMAX
            IF ( NMATYP(ITYP).NE.0 ) THEN
              DO 2321 , IAUX = 1 , NMATYP(ITYP)
                IF ( NUMFAM.EQ.ZI(JFAMMA(ITYP)+IAUX-1) ) THEN
                  NBENFA = NBENFA + 1
                  TABAUX(NBENFA) = ZI(JNUMTY(ITYP)+IAUX-1)
                ENDIF
 2321         CONTINUE
            ENDIF
  232     CONTINUE
C
        ENDIF
C
        CARAFA(3,RANGFA) = NBENFA
C
C 2.4. ==> MEMORISATION DES NUMEROS DES ENTITES DE LA FAMILLE
C
        IF ( NBENFA.GT.0 ) THEN
C
          CALL JUCROC ( NUMENT, SAUX24, RANGFA, NBENFA, ADNUME )
          ADNUME = ADNUME - 1
          DO 24 , IAUX = 1 , NBENFA
            ZI(ADNUME+IAUX) = TABAUX(IAUX)
   24     CONTINUE
C
        ENDIF
C
C 2.5. ==> CREATION DES NOMS DES GROUPES ASSOCIES
C         POUR FORMER LES COLLECTIONS FAM I -> NOMGNO X , NOMGMA Y ...
C                                     FAM J -> NUMGNO X , NUMGMA Y ...
C         ON MET LE NUMERO DE GROUPE A +-99999999. AINSI, LE PROGRAMME
C         DE CREATION, LRMNGR, FERA UNE NUMEROTATION AUTOMATIQUE.
C         CONVENTION : SI GROUPE DE MAILLES => NUMGRP< 0 SINON NUMGRP>0
C
C         SI AUCUN GROUPE N'A ETE DEFINI, ON CREE DES GROUPES DONT LE
C         NOM EST BATI SUR LA VALEUR DES ATTRIBUTS. ATTENTION, ASTER
C         REFUSE LES SIGNES '-' DANS LES NOMS DES GROUPES ... DE MEME,
C         IL FAUT DISTINGUER LES GROUPES DE NOEUDS ET DE MAILLES
C         SINON, ON COPIE LES NOMS PRESENTS DANS LE DESCRIPTIF DE LA
C         FAMILLE.
C
        IF ( NBENFA.GT.0 ) THEN
C
          IAUX = MAX ( 1, NBATTR, NBGROU )
          CALL JUCROC ( NOMGRO, SAUX24, RANGFA, IAUX, ADNOMG )
          CALL JUCROC ( NUMGRO, SAUX24, RANGFA, IAUX, ADNUMG )
C
          IF ( NUMFAM.GT.0 ) THEN
            SAUX02 = 'GN'
            JAUX =  99999999
          ELSE
            SAUX02 = 'GM'
            JAUX = -99999999
          ENDIF
C
          IF ( NBGROU.EQ.0 ) THEN
C
            NVNBGR = NBGRLO+NBATTR
            IF ( NVNBGR.GT.NOGRLO ) THEN
              CALL JUVECA('&&LRMMF1.NOM_GR_LONG    ',NVNBGR)
              CALL JUVECA('&&LRMMF1.NOM_GR_COURT   ',NVNBGR)
              CALL JEVEUO('&&LRMMF1.NOM_GR_LONG','E',JNOGRL)
              CALL JEVEUO('&&LRMMF1.NOM_GR_COURT','E',JNOGRC)
            ENDIF
C
            DO 251 , IAUX = 1 , NBATTR
              CALL CODENT (VAATFA(IAUX),'G',SAUX24)
              IF ( VAATFA(IAUX).LT.0 ) THEN
                SAUX24(3:8) = 'M'//SAUX24(2:6)
              ELSE
                SAUX24(3:8) = 'P'//SAUX24(1:5)
              ENDIF
              SAUX24(1:2) = SAUX02
              ZK24(ADNOMG-1+IAUX) = SAUX24
              ZI(ADNUMG-1+IAUX)  = JAUX
              ZK80(JNOGRL-1+IAUX+NBGRLO) = SAUX24
              ZK24(JNOGRC-1+IAUX+NBGRLO) = SAUX24
  251       CONTINUE
            NBGRLO = NBGRLO + NBATTR
C
          ELSE
C
            NVNBGR = NBGRLO+NBGROU
            IF ( NVNBGR.GT.NOGRLO ) THEN
              CALL JUVECA('&&LRMMF1.NOM_GR_LONG    ',NVNBGR)
              CALL JUVECA('&&LRMMF1.NOM_GR_COURT   ',NVNBGR)
              CALL JEVEUO('&&LRMMF1.NOM_GR_LONG','E',JNOGRL)
              CALL JEVEUO('&&LRMMF1.NOM_GR_COURT','E',JNOGRC)
            ENDIF
C
            DO 252 , IAUX = 1 , NBGROU
C
               K24B = NOGRFA(IAUX)(1:24)
               INOM = INDIK8 ( ZK24(ADNOMG), K24B, 1, IAUX )
               IF ( INOM .NE. 0 ) THEN
                  IERR = .TRUE.
                  VALI = IAUX
                  VALK (1) = ' '
                  ITMP = LXLGUT(NOGRFA(IAUX))
                  VALK (2) = NOGRFA(IAUX)(1:ITMP)
                  ITMP = LXLGUT(NOGRFA(INOM))
                  VALK (3) = NOGRFA(INOM)(1:ITMP)
                  VALK (4) = K24B
                  CALL U2MESG('E', 'MED_22',4,VALK,1,VALI,0,0.D0)
               ENDIF
               ZK24(ADNOMG-1+IAUX) = K24B
               ZI(ADNUMG-1+IAUX) = JAUX
               ZK80(JNOGRL-1+IAUX+NBGRLO) = NOGRFA(IAUX)
               ZK24(JNOGRC-1+IAUX+NBGRLO) = K24B
  252       CONTINUE
            NBGRLO = NBGRLO + NBGROU
C
          ENDIF
C
        ENDIF
C
      ENDIF
C
C     ERREUR LORS DE LA VERIFICATION DES NOMS DE GROUPES:
      CALL ASSERT(.NOT.IERR)
C
      IF ( NIVINF.GE.2 ) THEN
C
        WRITE (IFM,4001) NOMPRO
 4001 FORMAT(/,'FIN DU PROGRAMME ',A,/,60('-'))
C
      ENDIF
C
      END
