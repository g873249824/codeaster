      SUBROUTINE IRMHDF ( IFI, NDIM,NBNOEU,COORDO,NBMAIL,CONNEX,
     &                    POINT,NOMAST,TYPMA,TITRE,NBTITR,
     &                    NBGRNO,NOMGNO,NBGRMA,NOMGMA,NOMMAI,NOMNOE,
     &                    INFMED )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
C RESPONSABLE GNICOLAS G.NICOLAS
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ECRITURE DU MAILLAGE - FORMAT MED
C        -  -     -                 ---
C-----------------------------------------------------------------------
C     ENTREE:
C       IFI    : UNITE LOGIQUE D'IMPRESSION DU MAILLAGE
C       NDIM   : DIMENSION DU PROBLEME (2  OU 3)
C       NBNOEU : NOMBRE DE NOEUDS DU MAILLAGE
C       COORDO : VECTEUR DES COORDONNEES DES NOEUDS
C       NBMAIL : NOMBRE DE MAILLES DU MAILLAGE
C       CONNEX : CONNECTIVITES
C       POINT  : VECTEUR POINTEUR DES CONNECTIVITES (LONGUEURS CUMULEES)
C       NOMAST : NOM DU MAILLAGE
C       TYPMA  : VECTEUR TYPES DES MAILLES
C       TITRE  : TITRE ASSOCIE AU MAILLAGE
C       NBGRNO : NOMBRE DE GROUPES DE NOEUDS
C       NBGRMA : NOMBRE DE GROUPES DE MAILLES
C       NOMGNO : VECTEUR NOMS DES GROUPES DE NOEUDS
C       NOMGMA : VECTEUR NOMS DES GROUPES DE MAILLES
C       NOMMAI : VECTEUR NOMS DES MAILLES
C       NOMNOE : VECTEUR NOMS DES NOEUDS
C       INFMED : NIVEAU DES INFORMATIONS A IMPRIMER
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER      CONNEX(*),TYPMA(*),POINT(*)
      INTEGER      IFI,NDIM,NBNOEU,NBMAIL,NBGRNO,NBGRMA
      INTEGER      INFMED,NBTITR
C
      CHARACTER*80 TITRE(*)
      CHARACTER*8  NOMGNO(*),NOMGMA(*),NOMMAI(*),NOMNOE(*),NOMAST
C
      REAL*8       COORDO(*)
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRMHDF' )
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 48)
      INTEGER NNOMAX
      PARAMETER (NNOMAX=27)
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
      INTEGER EDLEAJ
      PARAMETER (EDLEAJ=2)
      INTEGER EDCREA
      PARAMETER (EDCREA=3)
      INTEGER EDNSTR
      PARAMETER (EDNSTR=0)
C
      INTEGER EDMODE, CODRET
      INTEGER NBTYP,  FID
      INTEGER NMATYP(NTYMAX), NNOTYP(NTYMAX), TYPGEO(NTYMAX)
      INTEGER RENUMD(NTYMAX),MODNUM(NTYMAX),NUMNOA(NTYMAX,NNOMAX)
      INTEGER IAUX, JAUX, NUANOM(NTYMAX,NNOMAX)
      INTEGER LNOMAM
      INTEGER IFM, NIVINF
      INTEGER VALI
C
      CHARACTER*1   SAUX01
      CHARACTER*6   SAUX06
      CHARACTER*8   NOMTYP(NTYMAX)
      CHARACTER*8   SAUX08
      CHARACTER*16  SAUX16(0:3)
      CHARACTER*32  NOMAMD
      CHARACTER*200 NOFIMD
      CHARACTER*255 KFIC
      CHARACTER*24 VALK(2)
C
      LOGICAL EXISTM
C
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C====
C 1. PREALABLES
C====
C
C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV ( IFM, NIVINF )
C
C 1.2. ==> NOM DU FICHIER MED
C
      CALL ULISOG(IFI, KFIC, SAUX01)
      IF ( KFIC(1:1).EQ.' ' ) THEN
         CALL CODENT ( IFI, 'G', SAUX08 )
         NOFIMD = 'fort.'//SAUX08
      ELSE
         NOFIMD = KFIC(1:200)
      ENDIF
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) '<',NOMPRO,'> NOM DU FICHIER MED : ',NOFIMD
      ENDIF
C
C 1.3. ==> NOM DU MAILLAGE
C
      CALL MDNOMA ( NOMAMD, LNOMAM, NOMAST, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL CODENT ( CODRET,'G',SAUX08 )
        CALL U2MESK('F','PREPOST_72',1,SAUX08)
      ENDIF
C
C 1.4. ==> LE MAILLAGE EST-IL DEJA PRESENT DANS LE FICHIER ?
C          SI OUI, ON NE FAIT RIEN DE PLUS QU'EMETTRE UNE INFORMATION
C
      IAUX = 0
      CALL MDEXMA ( NOFIMD, NOMAMD, IAUX, EXISTM, JAUX, CODRET )
C
      IF ( EXISTM ) THEN
C
        VALK (1) = NOFIMD
        VALK (2) = NOMAMD
        CALL U2MESG('A', 'PREPOST5_33',2,VALK,0,0,0,0.D0)
        CALL U2MESS('A','PREPOST2_87')
C
C     ------------------------------------------------------------------
C
      ELSE
C
C====
C 2. DEMARRAGE
C====
C
C 2.1. ==> OUVERTURE FICHIER MED EN MODE
C      SOIT 'CREATION' SI LE FICHIER N'EXISTE PAS ENCORE,
C      SOIT 'LECTURE_AJOUT' (CELA SIGNIFIE QUE LE FICHIER EST ENRICHI).
C
C     TEST L'EXISTENCE DU FICHIER
      CALL EFOUVR (FID, NOFIMD, EDLECT, CODRET)
      IF ( CODRET.NE.0 ) THEN
         EDMODE = EDCREA
         CODRET = 0
      ELSE
         EDMODE = EDLEAJ
         CALL EFFERM ( FID, CODRET)
         IF ( CODRET.NE.0 ) THEN
          CALL CODENT ( CODRET,'G',SAUX08 )
          CALL U2MESK('F','PREPOST2_13',1,SAUX08)
         ENDIF
      ENDIF
C
      IF ( INFMED.GE.2 ) THEN
C                         1234567890123456
        SAUX16(EDLECT) = 'LECTURE SEULE.  '
        SAUX16(EDLEAJ) = 'LECTURE/ECRITURE'
        SAUX16(EDCREA) = 'CREATION.       '
        CALL CODENT ( EDMODE,'G',SAUX08 )
         VALK(1) = SAUX08
         VALK(2) = SAUX16(EDMODE)
         CALL U2MESK('I','PREPOST2_88', 2 ,VALK)
      ENDIF
C
      CALL EFOUVR (FID, NOFIMD, EDMODE, CODRET)
      IF ( CODRET.NE.0 ) THEN
        VALK (1) = NOFIMD
        VALK (2) = NOMAMD
        VALI = CODRET
        CALL U2MESG('A', 'PREPOST5_34',2,VALK,1,VALI,0,0.D0)
        CALL U2MESS('F','PREPOST_69')
      ENDIF
C
C 2.2. ==> CREATION DU MAILLAGE AU SENS MED (TYPE MED_NON_STRUCTURE)
C
CGN      PRINT *,'APPEL DE EFMAAC AVEC :'
CGN      PRINT *,NOMAMD
CGN      PRINT *,NDIM
CGN      PRINT *,EDNSTR
      CALL EFMAAC ( FID, NOMAMD, NDIM, EDNSTR,
     &              'CREE PAR CODE_ASTER', CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL CODENT ( CODRET,'G',SAUX08 )
        CALL U2MESK('F','PREPOST2_89',1,SAUX08)
      ENDIF
C
C 2.3. ==> . RECUPERATION DES NB/NOMS/NBNO/NBITEM DES TYPES DE MAILLES
C            DANS CATALOGUE
C          . RECUPERATION DES TYPES GEOMETRIE CORRESPONDANT POUR MED
C          . VERIF COHERENCE AVEC LE CATALOGUE
C
      CALL LRMTYP ( NBTYP, NOMTYP,
     &              NNOTYP, TYPGEO, RENUMD,
     &              MODNUM, NUANOM, NUMNOA )
C
C====
C 3. LA DESCRIPTION
C====
C
      IF ( EDMODE.EQ.EDCREA ) THEN
C
      CALL IRMDES ( FID,
     &              TITRE, NBTITR,
     &              INFMED )
C
      ENDIF
C
C====
C 4. LES NOEUDS
C====
C
      CALL IRMMNO ( FID, NOMAMD, NDIM,
     &              NBNOEU , COORDO, NOMNOE,
     &              INFMED )
C
C====
C 5. LES MAILLES
C====
C
      SAUX06 = NOMPRO
C
      CALL IRMMMA ( FID, NOMAMD,
     &              NDIM, NBMAIL,
     &              CONNEX, POINT, TYPMA, NOMMAI,
     &              SAUX06,
     &              NBTYP, TYPGEO, NOMTYP, NNOTYP, RENUMD,
     &              NMATYP,
     &              INFMED, MODNUM, NUANOM )
C
C====
C 6. LES FAMILLES
C====
C
      SAUX06 = NOMPRO
C
      CALL IRMMFA ( FID, NOMAMD,
     &              NBNOEU, NBMAIL,
     &              NOMAST, NBGRNO, NOMGNO, NBGRMA, NOMGMA,
     &              SAUX06,
     &              TYPGEO, NOMTYP, NMATYP,
     &              INFMED )
C
C====
C 7. LES EQUIVALENCES
C====
C
      CALL IRMMEQ ( FID, NOMAMD, INFMED )
C
C====
C 8. FERMETURE DU FICHIER MED
C====
C
      CALL EFFERM ( FID, CODRET )
      IF ( CODRET.NE.0 ) THEN
        VALK (1) = NOFIMD
        VALK (2) = NOMAMD
        VALI = CODRET
        CALL U2MESG('A', 'PREPOST5_35',2,VALK,1,VALI,0,0.D0)
        CALL U2MESS('F','PREPOST_70')
      ENDIF
C
C====
C 9. LA FIN
C====
C
      CALL JEDETC('V','&&'//NOMPRO,1)
C
      ENDIF
C
C     ------------------------------------------------------------------
C
      CALL JEDEMA()
C
      END
