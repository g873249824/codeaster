      SUBROUTINE XPOINI(MAXFEM,MODELE,MALINI,MODVIS,LICHAM,RESUCO,RESUX,
     &                  PREFNO,NOGRFI)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      CHARACTER*2   PREFNO(4)
      CHARACTER*8   MAXFEM,MODELE,MALINI,RESUCO,RESUX,NOGRFI,MODVIS
      CHARACTER*24  LICHAM

C
C               RECUPERATION DES ENTREES SORTIES
C               POUR LES OPERATEURS DE POST-TRAITEMENT X-FEM
C
C
C   OUT
C       MAXFEM : MAILLAGE X-FEM
C       MODELE : MODELE FISSURE
C       MALINI : MAILLAGE SAIN
C       MODVIS : MODELE DE VISU (X-FEM)
C       LICHAM : LISTE DES CHAMPS A POST-TRAITER
C       RESUCO : NOM DU CONCEPT RESULTAT DONT ON EXTRAIT LES CHAMPS
C       RESUX  : NOM DU CONCEPT RESULTAT A CREER
C       PREFNO : PREFERENCES POUR LE NOMAGE DES NOUVELLES ENTITES
C       NOGRFI : NOM DU GROUPE DES NOEUDS SITUES SUR LA FISSURE

      INTEGER       IRET,IBID,JLICHA,JXC,I
      INTEGER       NBCHAM
      CHARACTER*8   K8B
      CHARACTER*16  K16B,NOMCMD,TYSD,LINOM(3)
      CHARACTER*19  K19BID

      INTEGER      IARG

      DATA          LINOM / 'DEPL', 'SIEF_ELGA', 'VARI_ELGA' /

      CALL JEMARQ()

C     NOM DE LA COMMANDE (POST_MAIL_XFEM OU POST_CHAM_XFEM)
      CALL GETRES(K8B,K16B,NOMCMD)

C     ------------------------------------------------------------------
      IF (NOMCMD.EQ.'POST_MAIL_XFEM') THEN
C     ------------------------------------------------------------------

C       NOM DU MAILLAGE DE SORTIE : MAXFEM
        CALL GETRES(MAXFEM,K16B,K16B)

C       MODELE ENRICHI : MODELE
        CALL GETVID(' ','MODELE',0,IARG,1,MODELE,IRET)
        CALL EXIXFE(MODELE,IRET)
        IF(IRET.EQ.0) CALL U2MESK('F','XFEM_3',1,MODELE)


C       PREFERENCES POUR LE NOMAGE DES NOUVELLES ENTITES
        CALL GETVTX(' ','PREF_NOEUD_X' ,1,IARG,1,PREFNO(1),IBID)
        CALL GETVTX(' ','PREF_NOEUD_M' ,1,IARG,1,PREFNO(2),IBID)
        CALL GETVTX(' ','PREF_NOEUD_P' ,1,IARG,1,PREFNO(3),IBID)
        CALL GETVTX(' ','PREF_MAILLE_X',1,IARG,1,PREFNO(4),IBID)
        CALL GETVTX(' ','PREF_GROUP_CO',1,IARG,1,NOGRFI   ,IBID)

C     ------------------------------------------------------------------
      ELSEIF (NOMCMD.EQ.'POST_CHAM_XFEM') THEN
C     ------------------------------------------------------------------

C       NOM DE LA SD RESULTAT A CREER : RESUX
        CALL GETRES(RESUX,K16B,K16B)

C       MODELE DE VISU ET MAILLAGE DE VISU (X-FEM)
        CALL GETVID(' ','MODELE_VISU',0,IARG,1,MODVIS,IRET)
        CALL DISMOI('F','NOM_MAILLA',MODVIS,'MODELE',IBID,MAXFEM,IRET)

C       NOM ET TYPE DE LA SD RESULTAT EN ENTREE : RESUCO
        CALL GETVID(' ','RESULTAT',1,IARG,1,RESUCO,IBID)

C       MODELE ENRICHI ASSOCIE AU RESULTAT EN ENTREE
        CALL DISMOI('F','NOM_MODELE',RESUCO,'RESULTAT',IBID,MODELE,IRET)

C       NOM DU CHAMPS A POST-TRAITER
        CALL GETTCO(RESUCO,TYSD)
        IF (TYSD(1:9).EQ.'MODE_MECA') THEN
          NBCHAM=1
        ELSEIF (TYSD(1:9).EQ.'EVOL_NOLI') THEN
C         A CORRIGER SUITE FICHE 15408
C         PB POST-TRAITEMENT VARIABLES INTERNES SI CONTACT P2P1 (GLUTE)
          CALL JEVEUO(MODELE//'.XFEM_CONT','L',JXC)
          IF (ZI(JXC-1+1).EQ.3) THEN
            WRITE(6,*)'ON NE PEUT PAS POST-TRAITER LE CHAMP VARI_ELGA'
            NBCHAM=2
          ELSE
            NBCHAM=3
          ENDIF
        ENDIF
        IF (TYSD(1:9).EQ.'EVOL_ELAS') THEN
          CALL RSEXCH(RESUCO,'SIEF_ELGA',1,K19BID,IRET)
          IF (IRET.EQ.0) THEN
            NBCHAM=2
          ELSE
            NBCHAM=1
          ENDIF
        ENDIF

        CALL WKVECT(LICHAM, 'V V K16', NBCHAM, JLICHA)
        DO 10 I=1,NBCHAM
          ZK16(JLICHA-1+I)=LINOM(I)
 10     CONTINUE

C     ----------------------------------------------------------------
      ENDIF
C     ------------------------------------------------------------------

C     MAILLAGE INITIAL : MALINI
C     CE MAILLAGE EST CELUI ASSOCIE AU MODELE ENRICHI
C     SAUF DANS LE CAS DU CONTACT AU ARETE 'P1P1A'
      CALL JEVEUO(MODELE//'.XFEM_CONT','L',JXC)
      CALL GETVID(' ','MAILLAGE_SAIN',0,IARG,1,MALINI,IRET)

      IF (ZI(JXC-1+1).EQ.2) THEN
C       CAS DU CONTACT AU ARETES : ON UTILISE FORCEMENT MAILLAGE_SAIN
        IF (IRET.EQ.0) CALL U2MESK('F','XFEM2_3',1,NOMCMD)
      ELSE
C       MAILLAGE_SAIN NE SERT A RIEN :
C       RECUPERATION DU MAILLAGE ASSOCIE AU MODELE
        IF (IRET.NE.0) CALL U2MESK('A','XFEM2_4',1,NOMCMD)
        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MALINI,IRET)
      ENDIF

      CALL JEDEMA()
      END
