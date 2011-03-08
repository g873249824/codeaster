      SUBROUTINE IRCAM1 ( NOFIMD, NOCHMD,
     &                    EXISTC, NCMPRF,
     &                    NUMPT, INSTAN, UNIINS, NUMORD,
     &                    ADSD, ADSV, ADSL, ADSK, PARTIE,
     &                    NCMPVE, NTLCMP, NTNCMP, NTUCMP, NTPROA,
     &                    NBIMPR, CAIMPI, CAIMPK, TYPECH,
     &                    NOMAMD, NOMTYP, MODNUM, NUANOM,
     &                    CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/03/2011   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C     ECRITURE D'UN CHAMP - FORMAT MED - PHASE 1
C        -  -       - -            -           -
C-----------------------------------------------------------------------
C     ENTREES :
C       NOFIMD : NOM DU FICHIER MED
C       NOCHMD : NOM MED DU CHAMP A ECRIRE
C       NCMPRF : NOMBRE DE COMPOSANTES DU CHAMP DE REFERENCE
C       NUMPT  : NUMERO DE PAS DE TEMPS
C       INSTAN : VALEUR DE L'INSTANT A ARCHIVER
C       UNIINS : UNITE DE L'INSTANT A ARCHIVER
C       NUMORD : NUMERO D'ORDRE DU CHAMP
C       ADSK, D, ... : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
C       PARTIE: IMPRESSION DE LA PARTIE IMAGINAIRE OU REELLE POUR
C               UN CHAMP COMPLEXE 
C       NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
C       NTPROA : PROFIL ASTER. C'EST LA LISTE DES NUMEROS ASTER DES
C                ELEMENTS/NOEUDS POUR LESQUELS LE CHAMP EST DEFINI
C       NBIMPR : NOMBRE D'IMPRESSIONS
C         NCAIMI : ENTIERS POUR CHAQUE IMPRESSION
C                  CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
C                  CAIMPI(2,I) = NOMBRE DE POINTS (DE GAUSS OU NOEUDS)
C                  CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
C                  CAIMPI(4,I) = NOMBRE DE MAILLES A ECRIRE
C                  CAIMPI(5,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
C                  CAIMPI(6,I) = TYPE GEOMETRIQUE AU SENS MED
C                  CAIMPI(7,I) = NOMBRE TOTAL DE MAILLES IDENTIQUES
C         NCAIMK : CARACTERES POUR CHAQUE IMPRESSION
C                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
C       NOMAMD : NOM DU MAILLAGE MED
C       NOMTYP : NOM DES TYPES POUR CHAQUE MAILLE
C       MODNUM : INDICATEUR SI LA SPECIFICATION DE NUMEROTATION DES
C                NOEUDS DES MAILLES EST DIFFERENTES ENTRE ASTER ET MED:
C                     MODNUM = 0 : NUMEROTATION IDENTIQUE
C                     MODNUM = 1 : NUMEROTATION DIFFERENTE
C       NUANOM : TABLEAU DE CORRESPONDANCE DES NOEUDS MED/ASTER.
C                NUANOM(ITYP,J): NUMERO DANS ASTER DU J IEME NOEUD DE LA
C                MAILLE DE TYPE ITYP DANS MED.
C     SORTIES:
C       CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_______________________________________________________________________
C
      IMPLICIT NONE
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 56)
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBIMPR
      INTEGER CAIMPI(7,NBIMPR)
      INTEGER NUMPT, NUMORD
      INTEGER ADSD, ADSV, ADSL, ADSK
      INTEGER EXISTC, NCMPRF
      INTEGER NCMPVE
      INTEGER TYPENT, TYGEOM
      INTEGER MODNUM(NTYMAX), NUANOM(NTYMAX,*)
C
      CHARACTER*8 UNIINS, TYPECH
      CHARACTER*8 NOMTYP(*)
      CHARACTER*24 NTLCMP, NTNCMP, NTUCMP, NTPROA
      CHARACTER*32 NOCHMD, NOMPB(2)
      CHARACTER*(*) NOFIMD,PARTIE
      CHARACTER*32 NOMAMD
      CHARACTER*32 CAIMPK(2,NBIMPR)
C
      REAL*8 INSTAN
C
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      ZI
      REAL*8       ZR
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRCAM1' )
C
      INTEGER EDLEAJ
      INTEGER EDNOEU
      PARAMETER (EDNOEU=3)
      INTEGER EDMAIL
      PARAMETER (EDMAIL=0)
      INTEGER TYPNOE
      PARAMETER (TYPNOE=0)
      INTEGER EDNOPG
      PARAMETER (EDNOPG=1)
      INTEGER EDNOMA
      PARAMETER (EDNOMA=4)
C
      CHARACTER*8  SAUX08,NTYMAS
      CHARACTER*16 K16B
      CHARACTER*24 NTVALE
      CHARACTER*32 NOMPRF
      CHARACTER*32 NOLOPG,K32B
C
      INTEGER NBREPG,NBPT,IRET,NUMPT2,I
      INTEGER IFM, NIVINF
      INTEGER NBENTY, NVALEC, NBPG, NBSP
      INTEGER TYMAST
      INTEGER ADVALE
      INTEGER ADPROA, ADNUCM
      INTEGER NRIMPR
      INTEGER IDEB, IFIN
C
      INTEGER IDFIMD
      INTEGER IAUX,IBID
      REAL*8 RBID
      LOGICAL LOCAL,FICEXI
C
C====
C 1. PREALABLES
C====
C
C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV ( IFM, NIVINF )
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'DEBUT DE '//NOMPRO
        WRITE (IFM,*) 'ECRITURE DE '//NOCHMD
      ENDIF
 1001 FORMAT(/,4X,10('='),A,10('='),/)
C
C 1.2. ==> NOMS DES TABLEAUX DE TRAVAIL
C               12   345678   9012345678901234
      NTVALE = '&&'//NOMPRO//'.VALEURS        '
C
C 1.3. ==> ADRESSES
C
      CALL JEVEUO ( NTPROA, 'L', ADPROA )
      CALL JEVEUO ( NTLCMP, 'L', ADNUCM )
C
C====
C 2. OUVERTURE FICHIER MED EN MODE 'LECTURE_AJOUT'
C    CELA SIGNIFIE QUE LE FICHIER EST ENRICHI MAIS ON NE PEUT PAS
C    ECRASER UNE DONNEE DEJA PRESENTE.
C    (LE FICHIER EXISTE DEJA CAR SOIT ON A TROUVE UN MAILLAGE DEDANS,
C     SOIT ON EST PASSE PAR IRMAIL/IRMHDF)
C====
C
      INQUIRE(FILE=NOFIMD,EXIST=FICEXI)
      IF ( FICEXI ) THEN
         EDLEAJ = 2
         CALL MFOUVR (IDFIMD, NOFIMD, EDLEAJ, CODRET)
         IF ( CODRET.NE.0 ) THEN
            EDLEAJ = 3
            CALL MFOUVR (IDFIMD, NOFIMD, EDLEAJ, CODRET)
         ENDIF
      ELSE
          EDLEAJ = 3
          CALL MFOUVR (IDFIMD, NOFIMD, EDLEAJ, CODRET)
      ENDIF
      IF ( CODRET.NE.0 ) THEN
          SAUX08='MFOUVR  '
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 3. CREATION DU CHAMP
C====
C
      CALL IRCMCC ( IDFIMD,
     &              NOCHMD, EXISTC,
     &              NCMPVE, NTNCMP, NTUCMP,
     &              CODRET )
C
C====
C 4. ECRITURE POUR CHAQUE IMPRESSION SELECTIONNEE
C====
C
      IFIN = 0
C
      DO 41 , NRIMPR = 1 , NBIMPR
C
        IF ( CODRET.EQ.0 ) THEN
C
CGN        PRINT *,'IMPRESSION NUMERO ',NRIMPR
CGN        PRINT *,'CAIMPI : ',(CAIMPI(IAUX,NRIMPR),IAUX = 1 , 7)
CGN        PRINT *,'CAIMPK (LOCA GAUSS) : ',CAIMPK(1,NRIMPR)
CGN        PRINT *,'CAIMPK (PROFIL)     : ',CAIMPK(2,NRIMPR)
C 4.0. ==> NOMBRE DE VALEURS A ECRIRE
C
        NVALEC = CAIMPI(4,NRIMPR)
C
        IF ( NVALEC.GT.0 ) THEN
C
C 4.1. ==> ON DOIT ECRIRE DES VALEURS CORRESPONDANTS A NVALEC SUPPORTS
C          DU TYPE EN COURS.
C
          IF ( NIVINF.GT.1 ) THEN
            WRITE (IFM,4000)
            CALL UTFLSH (CODRET)
          ENDIF
C
          TYGEOM = CAIMPI(6,NRIMPR)
          TYMAST = CAIMPI(5,NRIMPR)
          IDEB = IFIN + 1
          IFIN = IDEB + NVALEC - 1
C
          IF ( TYGEOM.EQ.TYPNOE ) THEN
            NBPG = 1
            NBSP = 1
            IF ( NIVINF.GT.1 ) THEN
              WRITE (IFM,4001)
            ENDIF
          ELSE
            NBPG = CAIMPI(2,NRIMPR)
            NBSP = CAIMPI(3,NRIMPR)
            IF ( ((NBPG.EQ.27).OR.(NBPG.EQ.18).OR.(NBPG.EQ.9).OR.
     &            (NBPG.EQ.7)).AND. (TYPECH.EQ.'ELNO    ') ) THEN
              NOMPB(1) = NOCHMD(9:22)
              IF (NBPG.EQ.27) THEN
                NOMPB(2) = 'HEXA27'
              ELSEIF (NBPG.EQ.18) THEN
                NOMPB(2) = 'PENTA18'
              ELSEIF (NBPG.EQ.9) THEN
                NOMPB(2) = 'QUAD9'
              ELSEIF (NBPG.EQ.7) THEN
                NOMPB(2) = 'TRIA7'
              ENDIF
              CALL U2MESK('A','PREPOST2_84',2,NOMPB(1))
              GOTO 41
            ENDIF
            IF ( NIVINF.GT.1 ) THEN
              WRITE (IFM,4002) NOMTYP(TYMAST), TYGEOM
            ENDIF
            TYPENT=EDMAIL
            CALL MFNPDT ( IDFIMD, NOCHMD,TYPENT, TYGEOM,NBPT,IRET)
            IF(IRET.NE.-1)THEN
              DO 411 I=1,NBPT
                CALL MFPDTI( IDFIMD, NOCHMD,TYPENT, TYGEOM, I, IBID,
     &                       IBID,NUMPT2,K16B,RBID,K32B,LOCAL,IBID,IRET)
                IF(NUMPT.EQ.NUMPT2) THEN
                   NTYMAS=NOMTYP(TYMAST)
                   CALL U2MESK('F','MED_99',1,NTYMAS)
                ENDIF
 411          CONTINUE
            ENDIF
          ENDIF
C
          NBENTY = CAIMPI(7,NRIMPR)
          NOLOPG = CAIMPK(1,NRIMPR)
          NOMPRF = CAIMPK(2,NRIMPR)
C
C 4.2. ==> CREATION DES TABLEAUX DE VALEURS A ECRIRE
C
          IF ( CODRET.EQ.0 ) THEN
C
          IAUX = NCMPVE*NBSP*NBPG*NVALEC
          CALL WKVECT ( NTVALE, 'V V R', IAUX, ADVALE )
C
          CALL IRCMVA ( ZI(ADNUCM), NCMPVE, NCMPRF,
     &                  NVALEC, NBPG, NBSP, 
     &                  ADSV, ADSD, ADSL,ADSK, PARTIE,
     &                  TYMAST, MODNUM, NUANOM, TYPECH,
     &                  ZR(ADVALE), ZI(ADPROA), IDEB, IFIN )
C
          ENDIF
C
C 4.4. ==> ECRITURE VRAIE
C
          IF ( CODRET.EQ.0 ) THEN
C
          NBREPG = EDNOPG
          IF ( TYGEOM.EQ.TYPNOE ) THEN
            TYPENT = EDNOEU
          ELSE
            IF ( NBPG*NBSP .NE.1 ) THEN
              NBREPG = NBPG*NBSP
            ENDIF
            IF ( TYPECH.EQ.'ELNO' )THEN
              TYPENT = EDNOMA
            ELSE
              TYPENT = EDMAIL
            ENDIF
          ENDIF
C
          CALL IRCMEC ( IDFIMD, NOMAMD,
     &                  NOCHMD, NOMPRF, NOLOPG,
     &                  NUMPT, INSTAN, UNIINS, NUMORD,
     &                  ZR(ADVALE),
     &                  NCMPVE, NBENTY, NBREPG, NVALEC,
     &                  TYPENT, TYGEOM,
     &                  CODRET )
C
          CALL JEDETC('V',NTVALE,1)
C
          ENDIF
C
        ENDIF
C
      ENDIF
C
   41 CONTINUE
C
      IF ( NIVINF.GT.1 ) THEN
        CALL UTFLSH (CODRET)
        WRITE (IFM,4000)
      ENDIF
C
 4000 FORMAT(/,80('-'),/)
 4001 FORMAT('  * VALEURS AUX NOEUDS',/)
 4002 FORMAT(
     &/,'  * VALEURS SUR LES MAILLES DE TYPE ASTER ',A,' ET MED',I4)
C
C====
C 5. FERMETURE DU FICHIER MED
C====
C
      CALL MFFERM ( IDFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFFERM  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 6. LA FIN
C====
C
      CALL JEDETC('V','&&'//NOMPRO,1)
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE '//NOMPRO
      ENDIF
C
      END
