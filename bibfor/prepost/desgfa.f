      SUBROUTINE DESGFA ( TYPENT, NUMFAM, NOMFAM,
     &                    NBGF, NOGRF, NBAF, VALATT,
     &                    NBNOFA, NBELFA,
     &                    IFM, CODRET )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/12/2007   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C     ------------------------------------------------------------------
C  ENTREES :
C     TYPENT = TYPE D'ENTITES DANS LA FAMILLE
C              0 : DEBOGGAGE, 1 : NOEUDS, 2 : MAILLES
C     NUMFAM = NUMERO DE LA FAMILLE A DECRIRE
C     NOMFAM = NOM DE LA FAMILLE A DECRIRE
C     NOGRF  = NOMS DES GROUPES D ENTITES DE LA FAMILLE
C     NBGF   = NOMBRE DE GROUPES ASSOCIES A LA FAMILLE
C     NBAF   = NOMBRE D'ATTRIBUTS ASSOCIES A LA FAMILLE
C     VALATT = VALEURS DES ATTRIBUTS ASSOCIES A LA FAMILLE
C     NBNOFA = NOMBRE DE NOEUDS DANS LA FAMILLE
C              SI NEGATIF, ON N'IMPRIMERA RIEN
C     NBELFA = NOMBRE D'ELEMENTS DANS LA FAMILLE
C              SI NEGATIF, ON N'IMPRIMERA RIEN
C     IFM    = NUMERO DE L'UNITE LOGIQUE EN ECRITURE
C  SORTIES :
C     CODRET = CODE DE RETOUR
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NUMFAM, TYPENT, NBGF, NBAF
      INTEGER VALATT(NBAF)
      INTEGER NBNOFA, NBELFA
      INTEGER IFM, CODRET
C
      CHARACTER*32 NOMFAM
      CHARACTER*80 NOGRF(NBGF)
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*7 NOMENT(0:3)
C
C
      INTEGER IAUX
C
C 0.4. ==> INITIALISATIONS
C
C     ------------------------------------------------------------------
C
      CODRET = 0
C
C====
C 1. AFFICHAGE DU DESCRIPTIF DES FAMILLES
C====
C
      IF ( TYPENT.GE.0 .AND. TYPENT.LE.2 ) THEN
C
        NOMENT(0) = '???????'
        NOMENT(1) = 'NOEUDS '
        NOMENT(2) = 'MAILLES'
C
        WRITE (IFM,10001) NOMFAM, NUMFAM
C
        IF ( ( TYPENT.EQ.0 .OR. TYPENT.EQ.1 ) .AND. NBNOFA.GE.0 ) THEN
          WRITE (IFM,10002) NOMENT(1), NBNOFA
        ENDIF
        IF ( ( TYPENT.EQ.0 .OR. TYPENT.EQ.2 ) .AND. NBELFA.GE.0  ) THEN
          WRITE (IFM,10002) NOMENT(2), NBELFA
        ENDIF
C
        IF ( NBAF.EQ.0 ) THEN
          WRITE (IFM,10003)
        ELSE
          WRITE (IFM,10004) NOMENT(TYPENT)
          DO 10 , IAUX = 1 , NBAF
            WRITE (IFM,10005) VALATT(IAUX)
   10     CONTINUE
        ENDIF
C
        IF ( NBGF.EQ.0 ) THEN
          WRITE (IFM,10006)
        ELSE
          WRITE (IFM,10007) NOMENT(TYPENT)
          DO 20 , IAUX = 1 , NBGF
            WRITE (IFM,10008) NOGRF(IAUX)(1:8)
   20     CONTINUE
        ENDIF
C
        WRITE (IFM,10009)
C
10001 FORMAT(
     &//,50('*'),
     &/,'*   FAMILLE : ',A32,3X,'*',
     &/,'*   NUMERO  : ',I8,27X,'*')
10002 FORMAT(
     &  '*',3X,'NOMBRE DE ',A7,' : ',I7,18X,'*')
C
10003 FORMAT(
     &  50('*'),
     &/,'*',3X,'AUCUN ATTRIBUT N''A ETE DEFINI.',15X,'*')
10004 FORMAT(
     &  50('*'),
     &/,'*',3X,'ATTRIBUT(S) CORRESPONDANT(S) A CES ',A7,' : *')
10005 FORMAT(
     &  '*',10X,I8,30X,'*')
C
10006 FORMAT(
     &  50('*'),
     &/,'*',3X,'AUCUN GROUPE N''A ETE DEFINI.',17X,'*')
10007 FORMAT(
     &  50('*'),
     &/,'*',3X,'GROUPE(S) CORRESPONDANT(S) A CES ',A7,' :   *')
10008 FORMAT(
     &  '*',10X,A8,30X,'*')
C
10009 FORMAT(
     &  50('*'),/)
C
C====
C 2. MAUVAIS TYPE D'ENTITES
C====
C
      ELSE
C
        CODRET = 1
        CALL CODENT ( TYPENT, 'G', NOMENT(3) )
        CALL U2MESK('A','MED_42',1,NOMENT(3))
C
      ENDIF
C
      END
