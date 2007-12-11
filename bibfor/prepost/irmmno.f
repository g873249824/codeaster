      SUBROUTINE IRMMNO ( IDFIMD, NOMAMD, NDIM,
     &                    NBNOEU, COORDO, NOMNOE,
     &                    INFMED )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/12/2007   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C     ECRITURE DU MAILLAGE -  FORMAT MED - LES NOEUDS
C        -  -     -                  -         --
C-----------------------------------------------------------------------
C     ENTREE:
C       IDFIMD  : IDENTIFIANT DU FICHIER MED
C       NOMAMD : NOM DU MAILLAGE MED
C       NDIM   : DIMENSION DU PROBLEME (2  OU 3)
C       NBNOEU : NOMBRE DE NOEUDS DU MAILLAGE
C       COORDO : VECTEUR DES COORDONNEES DES NOEUDS
C       NOMNOE : VECTEUR NOMS DES NOEUDS
C       INFMED : NIVEAU DES INFORMATIONS A IMPRIMER
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER IDFIMD
      INTEGER NDIM, NBNOEU
      INTEGER INFMED
C
      REAL*8 COORDO(*)
C
      CHARACTER*(*)  NOMNOE(*)
      CHARACTER*(*)  NOMAMD
C
C 0.2. ==> COMMUNS
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRMMNO' )
C
      INTEGER EDFUIN
      PARAMETER (EDFUIN=0)
      INTEGER EDCART
      PARAMETER (EDCART=0)
      INTEGER EDNOEU
      PARAMETER (EDNOEU=3)
      INTEGER TYGENO
      PARAMETER (TYGENO=0)
C
      INTEGER CODRET
      INTEGER IAUX, INO
      INTEGER JCOORD
      INTEGER IFM, NIVINF
      INTEGER ADNOMN
C
      CHARACTER*8 SAUX08
      CHARACTER*16 NOMCOO(3), UNICOO(3)
C
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
C
      CALL INFNIV ( IFM, NIVINF )
C
C====
C 2. ECRITURE DES COORDONNEES DES NOEUDS
C    LA DIMENSION DU PROBLEME PHYSIQUE EST VARIABLE (1,2,3), MAIS
C    ASTER STOCKE TOUJOURS 3 COORDONNEES PAR NOEUDS.
C====
C
C 2.1. ==> NOMS ET UNITES
C
      NOMCOO(1) = 'X               '
      NOMCOO(2) = 'Y               '
      NOMCOO(3) = 'Z               '
C
      UNICOO(1) = 'INCONNUE        '
      UNICOO(2) = 'INCONNUE        '
      UNICOO(3) = 'INCONNUE        '
C
      IF ( INFMED.GT.1 ) THEN
        WRITE (IFM,2001) 1, NOMCOO(1), UNICOO(1)
        IF ( NDIM.GE.2 ) THEN
          WRITE (IFM,2001) 2, NOMCOO(2), UNICOO(2)
        ENDIF
        IF ( NDIM.GE.3 ) THEN
          WRITE (IFM,2001) 3, NOMCOO(3), UNICOO(3)
        ENDIF
        WRITE (IFM,*) ' '
      ENDIF
 2001 FORMAT('COORDONNEE',I2,' : ',A16,', ',A16)
C
C 2.2. ==> ECRITURE
C 2.2.1. ==> EN DIMENSION 3, ON PASSE LE TABLEAU DES COORDONNEES
C
C    LE TABLEAU COORDO EST UTILISE AINSI : COORDO(NDIM,NBNOEU)
C    EN FORTRAN, CELA CORRESPOND AU STOCKAGE MEMOIRE SUIVANT :
C    COORDO(1,1), COORDO(2,1), COORDO(3,1), COORDO(1,2), COORDO(2,2),
C    COORDO(3,2), COORDO(1,3), ... , COORDO(1,NBNOEU), COORDO(2,NBNOEU),
C    COORDO(3,NBNOEU)
C    C'EST CE QUE MED APPELLE LE MODE ENTRELACE
C
      IF ( NDIM.EQ.3 ) THEN
C
        CALL EFCOOE ( IDFIMD, NOMAMD, NDIM, COORDO, EDFUIN, NBNOEU,
     &                EDCART, NOMCOO, UNICOO, CODRET )
C
      ELSE
C
C 2.2.2. ==> AUTRES DIMENSIONS : ON CREE UN TABLEAU COMPACT DANS LEQUEL
C            ON STOCKE LES COORDONNEES, NOEUD APRES NOEUD.
C            C'EST CE QUE MED APPELLE LE MODE ENTRELACE.
C
        CALL WKVECT ('&&'//NOMPRO//'.COORDO','V V R',NBNOEU*NDIM,JCOORD)
C
        IF ( NDIM.EQ.2 ) THEN
          DO 221 , IAUX = 0 , NBNOEU-1
            ZR(JCOORD+2*IAUX)   = COORDO(3*IAUX+1)
            ZR(JCOORD+2*IAUX+1) = COORDO(3*IAUX+2)
  221     CONTINUE
        ELSE
          DO 222 , IAUX = 0 , NBNOEU-1
            ZR(JCOORD+IAUX)  = COORDO(3*IAUX+1)
  222     CONTINUE
        ENDIF
C
        CALL EFCOOE ( IDFIMD, NOMAMD, NDIM, ZR(JCOORD), EDFUIN, NBNOEU,
     &                EDCART, NOMCOO, UNICOO, CODRET)
C
        CALL JEDETR ('&&'//NOMPRO//'.COORDO')
C
      ENDIF
C
      IF ( CODRET.NE.0 ) THEN
        SAUX08='EFCOOE  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 3. LES NOMS DES NOEUDS
C====
C
      CALL WKVECT ('&&'//NOMPRO//'NOMNOE',
     &             'V V K16',  NBNOEU, ADNOMN )
C
      DO 3 INO=1, NBNOEU
        ZK16(ADNOMN+INO-1) = NOMNOE(INO)//'        '
C                                          12345678
 3    CONTINUE
C
      CALL EFNOME ( IDFIMD, NOMAMD, ZK16(ADNOMN), NBNOEU,
     &              EDNOEU, TYGENO, CODRET )
C
      IF ( CODRET.NE.0 ) THEN
        SAUX08='EFNOME  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 4. LES RENUMEROTATIONS
C====
C
C    ON N'ECRIT PAS DE RENUMEROTATION CAR LES NOEUDS SONT NUMEROTES
C    DE 1 A NBNOEU, SANS TROU. DONC, INUTILE D'ENCOMBRER LE FICHIER.
C
C====
C 5. LA FIN
C====
C
      CALL JEDETC ('V','&&'//NOMPRO,1)
C
      CALL JEDEMA()
C
      END
