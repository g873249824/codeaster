      SUBROUTINE IRCMPE ( NOFIMD,
     >                    NCMPVE, NUMCMP, EXICMP,
     >                    NBVATO, NBMAEC, LIMAEC, ADSD, ADSL,
     >                    NBIMPR, NCAIMI, NCAIMK,
     >                    TYEFMA, TYPMAI, TYPGEO, NOMTYP, TYPECH,
     >                    PROFAS, PROMED, PROREC, NROIMP, CHANOM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C TOLE CRP_21 CRP_20
C_______________________________________________________________________
C     ECRITURE D'UN CHAMP - MAILLES ET PROFIL SUR LES ELEMENTS
C        -  -       -       -          -              -
C_______________________________________________________________________
C     ENTREES :
C       NOFIMD : NOM DU FICHIER MED
C       NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
C       NUMCMP : NUMEROS DES COMPOSANTES VALIDES
C       EXICMP : EXISTENCE DES COMPOSANTES PAR MAILLES
C       NBVATO : NOMBRE DE VALEURS TOTALES
C       NBMAEC : NOMBRE D'ENTITES A ECRIRE (O, SI TOUTES)
C       LIMAEC : LISTE DES ENTITES A ECRIRE SI EXTRAIT
C       ADSK, D, ... : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
C       TYPMAI : TYPE ASTER POUR CHAQUE MAILLE
C       TYEFMA : NRO D'ELEMENT FINI OU DE MAILLE ASSOCIE A CHAQUE MAILLE
C       TYPGEO : TYPE GEOMETRIQUE DE MAILLE ASSOCIEE AU TYPE ASTER
C       NOMTYP : NOM DES TYPES DE MAILLES ASTER
C       PROREC : PROFIL RECIPROQUE. AUXILIAIRE.
C     SORTIES :
C       NBIMPR : NOMBRE D'IMPRESSIONS
C       NCAIMI : STRUCTURE ASSOCIEE AU TABLEAU CAIMPI
C         CAIMPI : ENTIERS POUR CHAQUE IMPRESSION
C                  CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
C                  CAIMPI(2,I) = NOMBRE DE POINTS (GAUSS OU NOEUDS)
C                  CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
C                  CAIMPI(4,I) = NOMBRE DE MAILLES A ECRIRE
C                  CAIMPI(5,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
C                  CAIMPI(6,I) = TYPE GEOMETRIQUE AU SENS MED
C                  CAIMPI(7,I) = NOMBRE TOTAL DE MAILLES IDENTIQUES
C       NCAIMK : STRUCTURE ASSOCIEE AU TABLEAU CAIMPK
C         CAIMPK : CARACTERES POUR CHAQUE IMPRESSION
C                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
C       PROFAS : PROFIL ASTER. C'EST LA LISTE DES NUMEROS ASTER DES
C                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
C       PROMED : PROFIL MED. C'EST LA LISTE DES NUMEROS MED DES
C                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
C       NROIMP : NUMERO DE L'IMPRESSION ASSOCIEE A CHAQUE MAILLE
C
C  COMMENTAIRE : C'EST AVEC L'APPEL A CESEXI QU'IL FAUT FILTRER LES
C                COMPOSANTES. SEUL MOYEN FIABLE AVEC UN CHAMELEM
C                SIMPLIFIE.
C_______________________________________________________________________
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBVATO, NCMPVE
      INTEGER NUMCMP(NCMPVE)
      INTEGER NBMAEC
      INTEGER LIMAEC(*)
      INTEGER TYPMAI(*)
      INTEGER TYEFMA(*)
      INTEGER ADSD, ADSL
      INTEGER TYPGEO(*)
      INTEGER NBIMPR
      INTEGER PROFAS(NBVATO)
      INTEGER PROMED(NBVATO)
      INTEGER PROREC(NBVATO)
      INTEGER NROIMP(NBVATO)
C
      CHARACTER*(*) NOFIMD
      CHARACTER*8 NOMTYP(*),TYPECH
      CHARACTER*19 CHANOM
      CHARACTER*24 NCAIMI, NCAIMK
C
      LOGICAL EXICMP(NBVATO)
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16           ZK16
      CHARACTER*24                   ZK24
      CHARACTER*32                           ZK32
      CHARACTER*80                                   ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*16  NOMFPG
C
      CHARACTER*32 EDNOPF
      PARAMETER ( EDNOPF='                                ' )
      CHARACTER*32 EDNOGA
      PARAMETER ( EDNOGA='                                ' )
C                         12345678901234567890123456789012
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX=56)
C
      INTEGER IFM, NIVINF, IBID
      INTEGER IAUX, JAUX, KAUX, LAUX
      INTEGER IMA
      INTEGER NREFMA,JNOFPG,JCHFPG
      INTEGER NRCMP, NRPG, NRSP, NBPG, NBSP, NVAL, TYPMAS
      INTEGER NMATY0(NTYMAX), ADRAUX(NTYMAX)
      INTEGER NBIMP0, NRIMPR
      INTEGER ADCAII, ADCAIK
C
      CHARACTER*32 NOPROF
C====
C 1. PREALABLES
C====
C
      CALL INFNIV ( IFM, NIVINF )
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'DEBUT DE IRCMPE'
      ENDIF
 1001 FORMAT(/,4X,10('='),A,10('='),/)
C
C====
C 2. ON REMPLIT UN PREMIER TABLEAU PAR MAILLE :
C    . VRAI DES QU'UNE DES COMPOSANTES DU CHAMP EST PRESENTE SUR
C      LA MAILLE
C    . FAUX SINON
C    REMARQUE : ON EXAMINE LES NCMPVE COMPOSANTES QUI SONT DEMANDEES,
C    MAIS IL FAUT BIEN TENIR COMPTE DE LA NUMEROTATION DE REFERENCE
C====
C
      LAUX = ADSD + 1
C
      DO 21 , IAUX = 1 , NBVATO
        LAUX = LAUX + 4
        NBPG = ZI(LAUX)
        NBSP = ZI(LAUX+1)
        DO 211 , NRCMP = 1 , NCMPVE
          KAUX = NUMCMP(NRCMP)
          DO 2111 , NRPG = 1 , NBPG
            DO 2112 , NRSP = 1 , NBSP
              CALL CESEXI ('C',ADSD,ADSL,IAUX,NRPG,NRSP,KAUX,JAUX)
              IF ( JAUX.GT.0 ) THEN
                EXICMP(IAUX) = .TRUE.
                GOTO 21
              ENDIF
 2112       CONTINUE
 2111     CONTINUE
  211   CONTINUE
   21 CONTINUE
C
C====
C 3. PROFAS : LISTE DES MAILLES POUR LESQUELS ON AURA IMPRESSION
C    UNE MAILLE EST PRESENTE SI ET SEULEMENT SI AU MOINS UNE COMPOSANTE
C    Y EST DEFINIE ET SI ELLE FAIT PARTIE DU FILTRAGE DEMANDE
C====
C
      NVAL = 0
C
C 3.1. ==> SANS FILTRAGE : C'EST LA LISTE DES MAILLES QUI POSSEDENT
C          UNE COMPOSANTE VALIDE
C
      IF ( NBMAEC.EQ.0 ) THEN
        DO 31 , IAUX = 1 , NBVATO
          IF ( EXICMP(IAUX) ) THEN
            NVAL = NVAL + 1
            PROFAS(NVAL) = IAUX
          ENDIF
   31   CONTINUE
C
C 3.2. ==> AVEC FILTRAGE : C'EST LA LISTE DES MAILLES REQUISES ET AVEC
C          UNE COMPOSANTE VALIDE
C
      ELSE
        DO 32 , JAUX = 1 , NBMAEC
          IAUX = LIMAEC(JAUX)
          IF ( EXICMP(IAUX) ) THEN
            NVAL = NVAL + 1
            PROFAS(NVAL) = IAUX
          ENDIF
   32   CONTINUE
      ENDIF
C
C====
C 4. CARACTERISATIONS DES IMPRESSIONS
C    ON TRIE SELON DEUX CRITERES :
C    1. LE NOMBRE DE SOUS-POINTS
C    2. LE TYPE D'ELEMENT FINI POUR UN CHAMP ELGA, OU LE TYPE DE LA
C       MAILLE, POUR UN AUTRE TYPE DE CHAMP. LE TABLEAU TYEFMA VAUT DONC
C       EFMAI OU TYPMAI A L'APPEL , SELON LE TYPE DE CHAMP.
C====
C
C 4.1. ==> TABLEAU DES CARACTERISATIONS ENTIERES DES IMPRESSIONS
C          ALLOCATION INITIALE
C
      NBIMP0 = 20
      IAUX = 7*NBIMP0
      CALL WKVECT ( NCAIMI, 'V V I'  , IAUX, ADCAII )
C
C 4.2. ==> PARCOURS DES MAILLES QUI PASSENT LE FILTRE
C
      NBIMPR = 0
C     SI ON EST SUR UN CHAMP ELGA, LE TRI DOIT SE FAIRE SUR LES FAMILLES
C     DE POINTS DE GAUSS
      IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
        CALL CELFPG ( CHANOM, '&&IRCMPE.NOFPGMA', IBID)
        CALL WKVECT ( '&&IRCMPE.TABNOFPG', 'V V K16', NVAL, JNOFPG )
        CALL JEVEUO ( '&&IRCMPE.NOFPGMA', 'L', JCHFPG )
      ENDIF
C
      DO 42 , IAUX = 1 , NVAL
        IMA = PROFAS(IAUX)
        NREFMA = TYEFMA(IMA)
C
        LAUX = ADSD + 4*IMA + 1
        NBPG = ZI(LAUX)
        NBSP = ZI(LAUX+1)
        IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
          NOMFPG = ZK16(JCHFPG+IMA-1)
        ENDIF
C
C 4.2.1. ==> RECHERCHE D'UNE IMPRESSION SEMBLABLE
C
        DO 421 , JAUX = 1 , NBIMPR
          IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
C           POUR LES ELGA, TRI SUR LES FAMILLES DE POINTS DE GAUSS
            IF ( ZK16(JNOFPG+JAUX-1).EQ.NOMFPG .AND.
     &           ZI(ADCAII+7*JAUX-5).EQ.NBSP ) THEN
              NRIMPR = JAUX
              GOTO 423
            ENDIF
          ELSE
            IF ( ZI(ADCAII+7*JAUX-7).EQ.NREFMA .AND.
     &           ZI(ADCAII+7*JAUX-5).EQ.NBSP ) THEN
              NRIMPR = JAUX
              GOTO 423
            ENDIF
          ENDIF
  421   CONTINUE
C
C 4.2.2. ==> ON CREE UNE NOUVELLE IMPRESSION
C            SI ON DEPASSE LA LONGUEUR RESERVEE, ON DOUBLE
C
        IF ( NBIMPR.EQ.NBIMP0 ) THEN
          NBIMP0 = 2*(7*NBIMP0)
          CALL JUVECA ( NCAIMI, NBIMP0 )
          CALL JEVEUO ( NCAIMI,'E', ADCAII )
        ENDIF
C
        NBIMPR = NBIMPR + 1
        JAUX = ADCAII+7*NBIMPR-7
C                  CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
        ZI(JAUX) = NREFMA
C                  CAIMPI(2,I) = NOMBRE DE POINTS (DE GAUSS OU NOEUDS)
        ZI(JAUX+1) = NBPG
C                  CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
        ZI(JAUX+2) = NBSP
C                  CAIMPI(4,I) = NOMBRE DE MAILLES A ECRIRE
        ZI(JAUX+3) = 0
C                  CAIMPI(5,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
        ZI(JAUX+4) = TYPMAI(IMA)
C                  CAIMPI(6,I) = TYPE GEOMETRIQUE AU SENS MED
        ZI(JAUX+5) = TYPGEO(TYPMAI(IMA))
C
        IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
          ZK16(JNOFPG+NBIMPR-1) = NOMFPG
        ENDIF
        NRIMPR = NBIMPR
C
C 4.2.3. ==> MEMORISATION DE L'IMPRESSION DE CETTE MAILLE
C            CUMUL DU NOMBRE DE MAILLES POUR CETTE IMPRESSION
C
  423   CONTINUE
C
        NROIMP(IMA) = NRIMPR
        JAUX = ADCAII+7*NRIMPR-4
        ZI(JAUX) = ZI(JAUX) + 1
C
   42 CONTINUE
C
      IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
        CALL JEDETR('&&IRCMPE.TABNOFPG')
        CALL JEDETR('&&IRCMPE.NOFPGMA')
      ENDIF
C
CGN      WRITE(IFM,*) 'A LA FIN DE 4, CAIMPI :'
CGN      DO 4200 , IAUX = 1 , NBIMPR
CGN        JAUX = ADCAII+7*IAUX-7
CGN        WRITE(IFM,4201) 'TYPE EF / MA ASTER',
CGN     >                   ZI(JAUX), ZI(JAUX+1), ZI(JAUX+2),
CGN     >                   ZI(JAUX+3), ZI(JAUX+4), ZI(JAUX+5)
CGN 4200 CONTINUE
CGN 4201 FORMAT(A,' =',I4,', NB PG =',I4,', NB SPT =',I4,
CGN     >       ', NBVAL ECR =',I8,', TYPE MA ASTER =',I4,
CGN     >       ', TYPE GEO MED =',I4)
C
C====
C 5. CONVERSION DU PROFIL EN NUMEROTATION MED
C    PROMED : ON STOCKE LES VALEURS DES NUMEROS DES MAILLES AU SENS MED
C    PAR TYPE DE MAILLES.
C    IL FAUT REORDONNER LE TABLEAU PROFAS PAR IMPRESSION SUCCESSIVE :
C    LE TABLEAU EST ORGANISE EN SOUS-TABLEAU CORRESPONDANT A CHAQUE
C    IMPRESSION. ON REPERE CHAQUE DEBUT DE SOUS-TABLEAU AVEC ADRAUX.
C====
C
C 5.1. ==> PROREC : C'EST LA LISTE RECIPROQUE. POUR LA MAILLE NUMERO
C                   IAUX EN NUMEROTATION ASTER, ON A SA POSITION DANS LE
C                   TABLEAU DES VALEURS S'IL FAIT PARTIE DE LA LISTE
C                   ET 0 SINON.
C
      DO 51 , IAUX = 1 , NVAL
        IMA = PROFAS(IAUX)
        PROREC(IMA) = IAUX
   51 CONTINUE
C
C 5.2. ==> ADRESSES DANS LE TABLEAU PROFAS
C          ADRAUX(IAUX) = ADRESSE DE LA FIN DE LA ZONE DE L'IMPRESSION
C                         PRECEDENTE, IAUX-1
C
      ADRAUX(1) = 0
      DO 52 , IAUX = 2 , NBIMPR
        ADRAUX(IAUX) = ADRAUX(IAUX-1) + ZI(ADCAII+7*IAUX-11)
   52 CONTINUE
CGN      PRINT *,'. ADRAUX '
CGN      PRINT 1789,(ADRAUX(IAUX),IAUX=1, NBIMPR)
C
C 5.3. ==> DECOMPTE DU NOMBRE DE MAILLES PAR TYPE DE MAILLES ASTER
C          NMATY0(IAUX) = NUMERO MED DE LA MAILLE COURANTE, DANS LA
C                         CATEGORIE ASTER IAUX. A LA FIN, NMATY0(IAUX)
C                         VAUT LE NOMBRE DE MAILLES PAR TYPE DE MAILLES
C                         ASTER, POUR TOUTES LES MAILLES DU MAILLAGE
C          ADRAUX(JAUX) = ADRESSE DANS LES TABLEAUX PROMED ET PROFAS
C                         DE LA MAILLE COURANTE ASSOCIEE A L'IMPRESSION
C                         NUMERO JAUX
C
      DO 531 , IAUX = 1 , NTYMAX
        NMATY0(IAUX) = 0
  531 CONTINUE
C
      DO 532 , IMA = 1 , NBVATO
C
        TYPMAS = TYPMAI(IMA)
        NMATY0(TYPMAS) = NMATY0(TYPMAS) + 1
        IF ( PROREC(IMA).NE.0 ) THEN
          JAUX = NROIMP(IMA)
          ADRAUX(JAUX) = ADRAUX(JAUX) + 1
          PROMED(ADRAUX(JAUX)) = NMATY0(TYPMAS)
          PROFAS(ADRAUX(JAUX)) = IMA
        ENDIF
C
  532 CONTINUE
C
C====
C 6. MEMORISATION DANS LES CARACTERISTIQUES DE L'IMPRESSION
C====
C
C 6.1. ==> NOMBRE DE MAILLES DU MEME TYPE
C
      DO 61 , IAUX = 1 , NBIMPR
C
        JAUX = ADCAII+7*IAUX-7
        TYPMAS = ZI(JAUX+4)
C                  CAIMPI(7,I) = NOMBRE DE MAILLES IDENTIQUES
        ZI(JAUX+6) = NMATY0(TYPMAS)
C
   61 CONTINUE
C
CGN      WRITE(IFM,*) 'A LA FIN DE 6, CAIMPI(7,*) :'
CGN      DO 6100 , IAUX = 1 , NBIMPR
CGN        WRITE(IFM,6101) IAUX, ZI(ADCAII+7*IAUX-1)
CGN 6100 CONTINUE
CGN 6101 FORMAT('IMPRESSION',I4,', NBMAILL TOT =',I8)
C
C 6.2. ==> CARACTERISTIQUES CARACTERES
C
      IAUX = 2*NBIMPR
      CALL WKVECT ( NCAIMK, 'V V K32', IAUX, ADCAIK )
C
      DO 62 , IAUX = 1 , NBIMPR
        JAUX = ADCAIK+2*(IAUX-1)
C                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
        ZK32(JAUX) = EDNOGA
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
        ZK32(JAUX+1) = EDNOPF
   62 CONTINUE
C
C====
C 7. STOCKAGE DES EVENTUELS PROFILS DANS LE FICHIER MED
C====
C
      KAUX = 1
C
      DO 71 , IAUX = 1 , NBIMPR
C
        JAUX = ADCAII+7*IAUX-7
C
C       SI LE NOMBRE DE MAILLES A ECRIRE EST >0
        IF ( ZI(JAUX+3).GT.0 ) THEN
C
C         SI LE NOMBRE DE MAILLES A ECRIRE EST DIFFERENT
C         DU NOMBRE TOTAL DE MAILLES DE MEME TYPE:
          IF ( ZI(JAUX+3).NE.ZI(JAUX+6) ) THEN
            CALL IRCMPF ( NOFIMD,
     >                    ZI(JAUX+3), PROMED(KAUX), NOPROF )
C
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
            ZK32(ADCAIK+2*IAUX-1) = NOPROF
          ENDIF
C
C         KAUX := POINTEUR PERMETTANT DE SE PLACER DANS PROMED
C         POUR LA PROCHAINE IMPRESSION
          KAUX = KAUX + ZI(JAUX+3)
C
        ENDIF
C
   71 CONTINUE
C
C====
C 8. LA FIN
C====
C
      IF ( NIVINF.GT.1 ) THEN
C
        IF(TYPECH(1:4).EQ.'ELGA')THEN
           WRITE (IFM,8001)
        ELSE
           WRITE (IFM,8004)
        ENDIF
C
        DO 81 , IAUX = 1 , NBIMPR
          JAUX = ADCAII+7*IAUX-7
          IF ( ZI(JAUX+3).GT.0 ) THEN
            WRITE (IFM,8002) NOMTYP(ZI(JAUX+4)),
     >                       ZI(JAUX+3), ZI(JAUX+1), ZI(JAUX+2)
          ENDIF
   81   CONTINUE
        WRITE (IFM,8003)
C
      ENDIF
 8001 FORMAT(
     >  4X,65('*'),
     >/,4X,'*  TYPE DE *',22X,'NOMBRE DE',21X,'*',
     >/,4X,'*  MAILLE  *  VALEURS   * POINT(S) DE GAUSS *',
     >     '   SOUS-POINT(S)   *',
     >/,4X,65('*'))
 8002 FORMAT(4X,'* ',A8,' *',I11,' *',I15,'    *',I15,'    *')
 8003 FORMAT(4X,65('*'))
 8004 FORMAT(
     >  4X,65('*'),
     >/,4X,'*  TYPE DE *',22X,'NOMBRE DE',21X,'*',
     >/,4X,'*  MAILLE  *  VALEURS   *      POINTS       *',
     >     '   SOUS-POINT(S)   *',
     >/,4X,65('*'))

C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE IRCMPE'
      ENDIF
C
      END
