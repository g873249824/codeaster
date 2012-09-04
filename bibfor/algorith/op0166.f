      SUBROUTINE OP0166()
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C
C     COMMANDE:  PROJ_CHAMP
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
C
C 0.2. ==> COMMUNS
C ----------------------------------------------------------------------
C
C
C
C 0.3. ==> VARIABLES LOCALES
C
C
      INCLUDE 'jeveux.h'
      INTEGER IRET
      INTEGER IE,IBID,N1,N2,N3
      INTEGER JPJK1
      LOGICAL ISOLE
      LOGICAL LNOEU,LELNO,LELEM,LELGA
      CHARACTER*4 TYCHV,TYPCAL
      CHARACTER*8 K8B,NOMA1,NOMA2,NOMA3,RESUIN,PROL0,PROJON,NOREIN
      CHARACTER*8 NOMO1,NOMO2,MOA1,MOA2,CNREF,NOMARE,NOCA
      CHARACTER*16 TYPRES,NOMCMD,LCORRE(2),CORRU
      CHARACTER*19 RESUOU,CHAM1,METHOD,RTYP
      CHARACTER*19 LIGRE1,LIGRE2
      CHARACTER*24 VALK(4)
      INTEGER      IARG,NBOCC



C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
      CALL TITRE()
      LELGA = .FALSE.


C     0- CALCUL DE TYPCAL =
C     ------------------------------------------------------------
C       / '1ET2' : ON CALCULE LA SD_CORRESP_2_MAILLA ET ON PROJETTE
C                  LES CHAMPS
C       / '1'    : ON CALCULE LA SD_CORRESP_2_MAILLA ET ON S'ARRETE
C       / '2'    : ON UTILISE LA SD_CORRESP_2_MAILLA DEJA CALCULEE
      CALL GETVTX(' ','PROJECTION',1,IARG,1,PROJON,N1)
      CALL GETVID(' ','MATR_PROJECTION',1,IARG,1,CORRU,N2)
      IF (N2.EQ.0) CORRU=' '
      IF (PROJON.EQ.'NON') THEN
        TYPCAL='1'
        CALL ASSERT(N2.EQ.0)
      ELSE
        CALL ASSERT(PROJON.EQ.'OUI')
        IF (CORRU.NE.' ') THEN
          TYPCAL='2'
        ELSE
          TYPCAL='1ET2'
        ENDIF
      ENDIF



C     1- CALCUL DE RESUOU, TYPRES, METHOD, ISOLE, CHAM1, RESUIN :
C     ------------------------------------------------------------
C        RESUOU : NOM DU CONCEPT RESULTAT
C        TYPRES : TYPE DU RESULTAT (CHAM_GD OU SD_RESULTAT)
C        METHOD : METHODE CHOISIE POUR LA PROJECTION
C        ISOLE  : .TRUE.  : ON NE PROJETTE QU'UN CHAMP ISOLE
C                 .FALSE. : ON PROJETTE UNE SD_RESULTAT
C        CHAM1  : NOM DU CHAMP A PROJETER (SI ISOLE)
C        RESUIN : NOM DE LA SD_RESULTAT A PROJETER (SI .NOT.ISOLE)
      CALL GETRES(RESUOU,TYPRES,NOMCMD)
      CALL GETVTX(' ','METHODE',1,IARG,1,METHOD,N1)
      IF (N1.EQ.0) METHOD=' '
      IF (PROJON.EQ.'OUI') THEN
        CALL GETVID(' ','RESULTAT',1,IARG,1,RESUIN,N2)
        IF (N2.EQ.1) THEN
          ISOLE=.FALSE.
          CHAM1=' '
          CALL DISMOI('F','NOM_MAILLA',RESUIN,'RESULTAT',IBID,
     &              NOMARE,IBID)
          NOREIN = RESUIN
        ELSE
          ISOLE=.TRUE.
          CALL GETVID(' ','CHAM_GD',1,IARG,1,CHAM1,N3)
          NOREIN = CHAM1(1:8)
          CALL DISMOI('F','NOM_MAILLA',CHAM1,'CHAMP',IBID,NOMARE,IBID)
          CALL ASSERT(N3.EQ.1)
          RESUIN=' '
        ENDIF
      ELSE
        CHAM1=' '
        RESUIN=' '
        NOMARE=' '
      ENDIF


C     LIMITATION DE LA METHODE ECLA_PG :
C      IL N'EST PAS POSSIBLE DE PROJETER UNE SD_RESULTAT

      IF ((METHOD.EQ.'ECLA_PG') .AND. (.NOT.ISOLE)) THEN
        CALL U2MESS('F','CALCULEL5_9')
      ENDIF




C     2- CALCUL DE NOMA1, NOMA2, MOA1, MOA2, CNREF, NOCA:
C     ---------------------------------------------
C        NOMA1 : NOM DU MAILLAGE "1"
C        NOMA2 : NOM DU MAILLAGE "2"
C        NOMO1 : NOM DU MODELE "1"  (OU ' ')
C        NOMO2 : NOM DU MODELE "2"  (OU ' ')
C        MOA1  : NOMO1 SI NON ' '. SINON : NOMA1
C        MOA2  : NOMO2 SI NON ' '. SINON : NOMA2
C        CNREF : NOM DU CHAM_NO "MODELE" "2" (SI NUAGE_DEG_0/1)
      IF (TYPCAL.EQ.'1' .OR. TYPCAL.EQ.'1ET2') THEN
        CALL GETVID(' ','MODELE_1',1,IARG,1,NOMO1,N1)
        IF (N1.EQ.1) THEN
          CALL DISMOI('F','NOM_MAILLA',NOMO1,'MODELE',IBID,NOMA1,IE)
          MOA1=NOMO1
        ELSE
          NOMO1=' '
          CALL GETVID(' ','MAILLAGE_1',1,IARG,1,NOMA1,N2)
          CALL ASSERT(N2.EQ.1)
          MOA1=NOMA1
        ENDIF

        CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
        IF (N1.EQ.1) THEN
          CALL DISMOI('F','NOM_MAILLA',NOMO2,'MODELE',IBID,NOMA2,IE)
          MOA2=NOMO2
        ELSE
          NOMO2=' '
          CALL GETVID(' ','MAILLAGE_2',1,IARG,1,NOMA2,N2)
          CALL ASSERT(N2.EQ.1)
          MOA2=NOMA2
        ENDIF

C
C     VERIFICATION DE LA COHERENCE ENTRE LES MAILLAGES ASSOCIES
C      1. AU RESULTAT (OU CHAM) A PROJETER
C      2. AU MODELE (OU MAILLAGE) FOURNI EN ENTREE
C
        IF ((NOMA1.NE.NOMARE).AND.(PROJON.EQ.'OUI')) THEN
          VALK(1) = MOA1
          VALK(2) = NOREIN
          VALK(3) = NOMA1
          VALK(4) = NOMARE
          CALL U2MESK('F','CALCULEL4_59',4,VALK)
        ENDIF

        CALL GETVID(' ','CHAM_NO_REFE',1,IARG,1,CNREF,N1)
        IF (N1.EQ.1) THEN
          CALL DISMOI('F','NOM_MAILLA',CNREF,'CHAMP',IBID,NOMA3,IE)
          IF (NOMA3.NE.NOMA2) THEN
            VALK(1)=CNREF
            VALK(2)=NOMA3
            VALK(3)=NOMA2
            CALL U2MESK('F','CALCULEL2_6',3,VALK)
          ENDIF
        ELSE
          CNREF=' '
        ENDIF
      ENDIF

      IF (METHOD .EQ. 'SOUS_POINT')THEN
C       RECUPERATION DU CARA_ELEM
        CALL GETVID(' ','CARA_ELEM'  ,1,IARG,1,NOCA,N1)
        CALL ASSERT(N1.NE.0)
C       LE MOT-CLE 'MODELE_2' EST OBLIGATOIRE
        CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
        IF (N1.EQ.0) THEN
            CALL U2MESS('F','CALCULEL5_40')
        ENDIF
C       VIS_A_VIS EST INTERDIT AVEC SOUS_POINT
        CALL GETFAC('VIS_A_VIS',NBOCC)
        IF (NBOCC.NE.0) CALL U2MESS('F','CALCULEL5_31')
        IF (.NOT. ISOLE)THEN
          CALL DISMOI('F','TYPE_RESU',RESUIN,'RESULTAT',IBID,RTYP,IE)
          IF (RTYP.NE.'EVOL_THER') CALL U2MESS('F','CALCULEL5_30')
        ENDIF
      ELSE
        NOCA = ' '
      ENDIF


C     3- CALCUL DE LA SD_LCORRESP_2_MAILLA :
C     ------------------------------------
C     LA SD_LCORRESP_2_MAILLA EST CONSTITUEE D'UNE LISTE DE DEUX SD :
C        LA 1RE EST UNE SD_CORRESP_2_MAILLA
C        LA 2DE EST UNE SD_CORRESP_2_MAILLA PARTICULIERE
C          ELLE EST UTILISEE POUR LA PROJECTION DE CHAM_ELEM (ELGA)
C          ELLE COMPORTE PJEF_EL (TABLEAU AUXILIAIRE)

      IF (TYPCAL.EQ.'1' .OR. TYPCAL.EQ.'1ET2') THEN
        LCORRE(1)='&&OP0166.CORRES'
        LCORRE(2)='&&OP0166.CORRE2'
        CALL PJXXCO(TYPCAL,METHOD,LCORRE,ISOLE,
     &            RESUIN,CHAM1,
     &            MOA1,MOA2,
     &            NOMA1,NOMA2,CNREF,NOCA)
      ENDIF

C     3.1 : SI TYPCAL='1', IL FAUT S'ARRETER LA :
      IF (TYPCAL.EQ.'1')  GOTO 9999



C     4- PROJECTION DES CHAMPS :
C     ------------------------------------


C     4.1 : SI TYPCAL='2', IL FAUT SURCHARGER LCORR(1) ET
C           EVENTUELLEMENT RECUPERER MODELE_2
      IF (TYPCAL.EQ.'2') THEN
         LCORRE(1)=CORRU
         LCORRE(2)=' '
         CALL JEVEUO(CORRU//'.PJXX_K1','L',JPJK1)
C        -- LES MOA1 ET MOA2 STOCKES SONT LES MAILLAGES
         MOA1=ZK24(JPJK1-1+1)(1:8)
         MOA2=ZK24(JPJK1-1+2)(1:8)
         IF (MOA1.NE.NOMARE) THEN
           VALK(1) = MOA1
           VALK(2) = NOREIN
           VALK(3) = MOA1
           VALK(4) = NOMARE
           CALL U2MESK('F','CALCULEL4_59',4,VALK)
         ENDIF
C        -- POUR POUVOIR PROJETER LES CHAM_ELEM, IL FAUT MODELE_2
         CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
         IF (N1.EQ.1) THEN
           CALL DISMOI('F','NOM_MAILLA',NOMO2,'MODELE',IBID,NOMA2,IE)
           IF (MOA2.NE.NOMA2) THEN
             VALK(1) = MOA2
             VALK(2) = NOMA2
             CALL U2MESK('F','CALCULEL4_72',2,VALK)
           ENDIF
           MOA2=NOMO2
         ENDIF
      ENDIF

C       1- CAS CHAMP ISOLE :
C       =====================
        IF (ISOLE) THEN

          IF (METHOD(1:10).EQ.'NUAGE_DEG_') THEN

C       ---- METHODE 'NUAGE_DEG' :
C       ----   ON NE PEUT PROJETER QUE DES CHAM_NO
            TYCHV = ' '
            CALL PJXXCH(LCORRE(1),CHAM1,RESUOU,TYCHV,' ','NON',' ',
     &                                                     'G',IRET)
            CALL ASSERT(IRET.EQ.0)

          ELSE

C       ---- AUTRE METHODE :
C       ---- ON PEUT PROJETER DES CHAM_NO OU DES CHAM_ELEM
C       ---- ON INTERDIT LE MOT-CLE 'TYPE_CHAM' POUR UN CHAMP ISOLE

            CALL GETVTX(' ','TYPE_CHAM',1,IARG,1,TYCHV,IBID)
            IF (TYCHV.EQ.'NOEU') THEN
              CALL U2MESS('F','CALCULEL5_36')
            ENDIF

C       ---- ON DETERMINE LE TYPE DE CHAMP A PROJETER

            CALL PJTYCO(ISOLE,K8B,CHAM1,
     &                LNOEU,LELNO,LELEM,LELGA)

            IF (LNOEU) THEN
C       ------ CAS OU IL Y A UN CHAM_NO
              IF (METHOD.EQ.'ECLA_PG') THEN
                VALK(1) = METHOD
                CALL U2MESK('F','CALCULEL5_32', 1 ,VALK)
              ENDIF
              IF (METHOD.EQ.'SOUS_POINT')THEN
                LIGRE2 = NOMO2//'.MODELE'
                PROL0='NON'
                CALL PJSPMA(LCORRE(1),CHAM1,RESUOU,PROL0,
     &                                  LIGRE2,NOCA,'G',IRET)
              ELSE
                TYCHV = ' '
                CALL PJXXCH(LCORRE(1),CHAM1,
     &            RESUOU,TYCHV,' ','NON',' ','G',IRET)
                CALL ASSERT(IRET.EQ.0)
              ENDIF
            ELSEIF (LELNO) THEN
C       ------ CAS OU IL Y A UN CHAM_ELEM (ELNO)
              IF (METHOD.EQ.'ECLA_PG') THEN
                VALK(1) = METHOD
                VALK(2) = 'ELNO'
                CALL U2MESK('F','CALCULEL5_33', 2 ,VALK)
              ENDIF
C       ------   LE MOT-CLE 'MODELE_2' EST OBLIGATOIRE
              CALL GETVTX(' ','PROL_ZERO',1,IARG,1,PROL0,IE)
              CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
              IF (N1.EQ.0) THEN
                CALL U2MESS('F','CALCULEL5_37')
              ENDIF

              LIGRE2 = NOMO2//'.MODELE'
              IF (METHOD.EQ.'SOUS_POINT')THEN
                CALL PJSPMA(LCORRE(1),CHAM1,RESUOU,PROL0,
     &                                  LIGRE2,NOCA,'G',IRET)
              ELSE
                TYCHV = ' '
                CALL PJXXCH(LCORRE(1),CHAM1,
     &            RESUOU,TYCHV,' ',PROL0,LIGRE2,'G',IRET)
                CALL ASSERT(IRET.EQ.0)
              ENDIF
            ELSEIF (LELEM) THEN
C       ------ CAS OU IL Y A UN CHAM_ELEM (ELEM)
              IF ((METHOD.EQ.'ECLA_PG').OR.
     &            (METHOD.EQ.'SOUS_POINT')) THEN
                VALK(1) = METHOD
                VALK(2) = 'ELEM'
                CALL U2MESK('F','CALCULEL5_33', 2 ,VALK)
              ENDIF
C       ------   LE MOT-CLE 'MODELE_2' EST OBLIGATOIRE
              CALL GETVTX(' ','PROL_ZERO',1,IARG,1,PROL0,IE)
              CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
              IF (N1.EQ.0) THEN
                CALL U2MESS('F','CALCULEL5_37')
              ENDIF
              LIGRE2 = NOMO2//'.MODELE'
              TYCHV = ' '
              CALL PJXXCH(LCORRE(1),CHAM1,
     &            RESUOU,TYCHV,' ',PROL0,LIGRE2,'G',IRET)
              CALL ASSERT(IRET.EQ.0)

            ELSEIF (LELGA) THEN
C       ------ CAS OU IL Y A UN CHAM_ELEM (ELGA)
              IF ((METHOD.EQ.'COLLOCATION') .OR.
     &            (METHOD.EQ.'SOUS_POINT')) THEN
                VALK(1) = METHOD
                VALK(2) = 'ELGA'
                CALL U2MESK('F','CALCULEL5_33', 2 ,VALK)
              ENDIF
C       ------  LES MOTS-CLES 'MODELE_1' ET 'MODELE_2' SONT OBLIGATOIRES
              CALL GETVTX(' ','PROL_ZERO',1,IARG,1,PROL0,IE)
              CALL GETVID(' ','MODELE_1',1,IARG,1,NOMO1,N1)
              IF (N1.EQ.0) THEN
                CALL U2MESS('F','CALCULEL5_35')
              ENDIF
              CALL GETVID(' ','MODELE_2',1,IARG,1,NOMO2,N1)
              IF (N1.EQ.0) THEN
                CALL U2MESS('F','CALCULEL5_37')
              ENDIF
              LIGRE1 = NOMO1//'.MODELE'
              LIGRE2 = NOMO2//'.MODELE'

              CALL PJELGA(NOMO2,CHAM1,LIGRE1,PROL0,
     &             LCORRE(2),RESUOU,LIGRE2,IRET)
              CALL ASSERT(IRET.EQ.0)

            ENDIF

          ENDIF


C       2- CAS SD_RESULTAT :
C       =====================
        ELSE
          CALL PJXXPR(RESUIN,RESUOU(1:8),MOA1,MOA2,LCORRE(1),'G',
     &                NOCA,METHOD)
        ENDIF

 9999 CONTINUE

      IF (TYPCAL.NE.'2') THEN
        CALL DETRSD('CORRESP_2_MAILLA',LCORRE(1))
      ENDIF

      IF (LELGA) THEN
        CALL DETRSD('CORRESP_2_MAILLA',LCORRE(2))
        CALL DETRSD('MAILLAGE','&&PJELC2')
      ENDIF

      IF (METHOD.EQ.'SOUS_POINT') THEN
        CALL DETRSD('MAILLAGE','&&PJSPCO')
      ENDIF

      CALL JEDEMA()
      END
