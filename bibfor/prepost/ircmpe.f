      SUBROUTINE IRCMPE ( NOFIMD, NCMPVE, NUMCMP, EXICMP, NBVATO,
     >                    NBMAEC, LIMAEC, ADSD,   ADSL,   NBIMPR,
     >                    NCAIMI, NCAIMK, TYEFMA, TYPMAI, TYPGEO,
     >                    NOMTYP, TYPECH, PROFAS, PROMED, PROREC,
     >                    NROIMP, CHANOM, SDCARM )
      IMPLICIT NONE
      INTEGER NBVATO,NCMPVE,NUMCMP(NCMPVE),NBMAEC,TYPMAI(*),ADSD
      INTEGER LIMAEC(*),NBIMPR,TYPGEO(*),PROFAS(NBVATO),TYEFMA(*)
      INTEGER NROIMP(NBVATO),PROMED(NBVATO),PROREC(NBVATO),ADSL
      CHARACTER*(*) NOFIMD
      CHARACTER*8 NOMTYP(*),TYPECH,SDCARM
      CHARACTER*19 CHANOM
      CHARACTER*24 NCAIMI,NCAIMK
      LOGICAL EXICMP(NBVATO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 16/10/2012   AUTEUR SELLENET N.SELLENET 
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
C TOLE CRP_21
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
C                  CAIMPI(4,I) = NOMBRE DE COUCHES
C                  CAIMPI(5,I) = NOMBRE DE SECTEURS
C                  CAIMPI(6,I) = NOMBRE DE FIBTRES
C                  CAIMPI(7,I) = NOMBRE DE MAILLES A ECRIRE
C                  CAIMPI(8,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
C                  CAIMPI(9,I) = TYPE GEOMETRIQUE AU SENS MED
C                  CAIMPI(10,I) = NOMBRE TOTAL DE MAILLES IDENTIQUES
C       NCAIMK : STRUCTURE ASSOCIEE AU TABLEAU CAIMPK
C         CAIMPK : CARACTERES POUR CHAQUE IMPRESSION
C                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
C                  CAIMPK(3,I) = NOM DE L'ELEMENT DE STRUCTURE
C       PROFAS : PROFIL ASTER. C'EST LA LISTE DES NUMEROS ASTER DES
C                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
C       PROMED : PROFIL MED. C'EST LA LISTE DES NUMEROS MED DES
C                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
C       NROIMP : NUMERO DE L'IMPRESSION ASSOCIEE A CHAQUE MAILLE
C_______________________________________________________________________
C
      INCLUDE 'jeveux.h'
      CHARACTER*80 EDNOPF,EDNOGA
      PARAMETER (EDNOPF=' ')
      PARAMETER (EDNOGA=' ')
C
      INTEGER NTYMAX,NMAXFI
      PARAMETER (NTYMAX=66)
      PARAMETER (NMAXFI=10)
      INTEGER IFM,NIVINF,IBID,IRET,IAUX,JAUX,KAUX,IMA,JCESD,LAUX
      INTEGER JCESC,JCESL,JCESV,NREFMA,JNOFPG,JCHFPG
      INTEGER NRCMP,NRPG,NRSP,NBPG,NBSP,NVAL,TYPMAS,NBIMP0,NRIMPR
      INTEGER NMATY0(NTYMAX),ADRAUX(NTYMAX),NBCOU,NBSEC,NBFIB
      INTEGER ADCAII,ADCAIK,NBGRF,NUGRFI(NMAXFI)
      INTEGER NBGRF2,NBCOU2,NBSEC2,NBFIB2,IMA2
      INTEGER NUGRF2(NMAXFI),IGRFI,IMAFIB
C
      CHARACTER*16 NOMFPG
      CHARACTER*64 NOPROF
C
      LOGICAL EXICAR,GRFIDT
C
C====
C 1. PREALABLES
C====
      CALL INFNIV ( IFM, NIVINF )

      IF ( NIVINF.GT.1 ) WRITE (IFM,1001) 'DEBUT DE IRCMPE'
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
      LAUX = ADSD + 1
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
      NVAL = 0
C
C 3.1. ==> SANS FILTRAGE : C'EST LA LISTE DES MAILLES QUI POSSEDENT
C          UNE COMPOSANTE VALIDE
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
C 4.1. ==> TABLEAU DES CARACTERISATIONS ENTIERES DES IMPRESSIONS
C          ALLOCATION INITIALE
      NBIMP0 = 20
      IAUX = 10*NBIMP0
      CALL WKVECT ( NCAIMI, 'V V I'  , IAUX, ADCAII )
C
C 4.2. ==> PARCOURS DES MAILLES QUI PASSENT LE FILTRE
      NBIMPR = 0
C     SI ON EST SUR UN CHAMP ELGA, LE TRI DOIT SE FAIRE SUR LES FAMILLES
C     DE POINTS DE GAUSS
      IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
        CALL CELFPG ( CHANOM, '&&IRCMPE.NOFPGMA', IBID)
        CALL WKVECT ( '&&IRCMPE.TABNOFPG', 'V V K16', NVAL, JNOFPG )
        CALL JEVEUO ( '&&IRCMPE.NOFPGMA', 'L', JCHFPG )
      ENDIF
C
      CALL JEEXIN(SDCARM//'.CANBSP    .CESV', IRET)
      EXICAR=.FALSE.
      IF ( IRET.NE.0.AND.TYPECH(1:4).EQ.'ELGA' ) THEN
        CALL JEVEUO(SDCARM//'.CANBSP    .CESD','L',JCESD)
        CALL JEVEUO(SDCARM//'.CANBSP    .CESC','L',JCESC)
        CALL JEVEUO(SDCARM//'.CANBSP    .CESL','L',JCESL)
        CALL JEVEUO(SDCARM//'.CANBSP    .CESV','L',JCESV)
        EXICAR=.TRUE.
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
        NBCOU = 0
        NBSEC = 0
        NBFIB = 0
        NBGRF = 0
        IMAFIB = 0
        IF ( NBSP.GT.1.AND.EXICAR ) THEN
          CALL IRCAEL(JCESD,JCESL,JCESV,JCESC,IMA,
     &                NBCOU,NBSEC,NBFIB,NBGRF,NUGRFI)
          IF ( NBFIB.NE.0 ) IMAFIB = IMA
        ENDIF
C
C 4.2.1. ==> RECHERCHE D'UNE IMPRESSION SEMBLABLE
C
        DO 421 , JAUX = 1 , NBIMPR
          IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
C           POUR LES ELGA, TRI SUR LES FAMILLES DE POINTS DE GAUSS
            IF ( .NOT.EXICAR ) THEN
C             SI ON N'A PAS DE CARA_ELEM, LE CAS EST SIMPLE
C             ON COMPARE LE NOM DE LA FAMILLE DE PG ET NBSP
              IF ( ZK16(JNOFPG+JAUX-1).EQ.NOMFPG .AND.
     &             ZI(ADCAII+10*(JAUX-1)+2).EQ.NBSP ) THEN
                NRIMPR = JAUX
                GOTO 423
              ENDIF
            ELSE
C             SINON, ON A DEUX CAS, PMF ET AUTRES
              IF ( NBFIB.NE.0 ) THEN
                IF ( ZK16(JNOFPG+JAUX-1).EQ.NOMFPG ) THEN
C                 POUR LES PMF, ON COMPARE AUSSI LES GROUPES DE FIBRES
                  IMA2 = ZI(ADCAII+10*(JAUX-1)+5)
                  CALL IRCAEL(JCESD,JCESL,JCESV,JCESC,IMA2,
     &                        NBCOU2,NBSEC2,NBFIB2,NBGRF2,NUGRF2)
                  IF ( NBFIB2.EQ.NBFIB.AND.NBGRF2.EQ.NBGRF ) THEN
                    GRFIDT = .TRUE.
                    DO 10, IGRFI = 1, NBGRF2
                      IF ( NUGRF2(IGRFI).NE.NUGRFI(IGRFI) )
     &                  GRFIDT = .FALSE.
  10                CONTINUE
                    IF ( GRFIDT ) THEN
                      NRIMPR = JAUX
                      GOTO 423
                    ENDIF
                  ENDIF
                ENDIF
              ELSE
                IF ( ZK16(JNOFPG+JAUX-1).EQ.NOMFPG .AND.
     &               ZI(ADCAII+10*(JAUX-1)+3).EQ.NBCOU.AND.
     &               ZI(ADCAII+10*(JAUX-1)+4).EQ.NBSEC ) THEN
                  NRIMPR = JAUX
                  GOTO 423
                ENDIF
              ENDIF
            ENDIF
          ELSE
            IF ( ZI(ADCAII+10*(JAUX-1)).EQ.NREFMA .AND.
     &           ZI(ADCAII+10*(JAUX-1)+2).EQ.NBSP ) THEN
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
          NBIMP0 = 2*NBIMP0
          CALL JUVECA ( NCAIMI, 10*NBIMP0 )
          CALL JEVEUO ( NCAIMI,'E', ADCAII )
        ENDIF
C
        NBIMPR = NBIMPR + 1
        JAUX = ADCAII+10*(NBIMPR-1)
C                  CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
        ZI(JAUX) = NREFMA
C                  CAIMPI(2,I) = NOMBRE DE POINTS (DE GAUSS OU NOEUDS)
        ZI(JAUX+1) = NBPG
C                  CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
        ZI(JAUX+2) = NBSP
C                  CAIMPI(4,I) = NOMBRE DE COUCHES
        ZI(JAUX+3) = NBCOU
C                  CAIMPI(5,I) = NOMBRE DE SECTEURS
        ZI(JAUX+4) = NBSEC
C                  CAIMPI(6,I) = NUMERO DE LA MAILLE 'EXEMPLE' POUR
C                                LES PMF
        ZI(JAUX+5) = IMAFIB
C                  CAIMPI(7,I) = NOMBRE DE MAILLES A ECRIRE
        ZI(JAUX+6) = 0
C                  CAIMPI(8,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
        ZI(JAUX+7) = TYPMAI(IMA)
C                  CAIMPI(9,I) = TYPE GEOMETRIQUE AU SENS MED
        ZI(JAUX+8) = TYPGEO(TYPMAI(IMA))
C
        IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
          ZK16(JNOFPG+NBIMPR-1) = NOMFPG
        ENDIF
        NRIMPR = NBIMPR
C
C 4.2.3. ==> MEMORISATION DE L'IMPRESSION DE CETTE MAILLE
C            CUMUL DU NOMBRE DE MAILLES POUR CETTE IMPRESSION
  423   CONTINUE
C
        NROIMP(IMA) = NRIMPR
        JAUX = ADCAII+10*(NRIMPR-1)+6
        ZI(JAUX) = ZI(JAUX) + 1
C
   42 CONTINUE
C
      IF ( TYPECH(1:4).EQ.'ELGA' ) THEN
        CALL JEDETR('&&IRCMPE.TABNOFPG')
        CALL JEDETR('&&IRCMPE.NOFPGMA')
      ENDIF
C
C====
C 5. CONVERSION DU PROFIL EN NUMEROTATION MED
C    PROMED : ON STOCKE LES VALEURS DES NUMEROS DES MAILLES AU SENS MED
C    PAR TYPE DE MAILLES.
C    IL FAUT REORDONNER LE TABLEAU PROFAS PAR IMPRESSION SUCCESSIVE :
C    LE TABLEAU EST ORGANISE EN SOUS-TABLEAU CORRESPONDANT A CHAQUE
C    IMPRESSION. ON REPERE CHAQUE DEBUT DE SOUS-TABLEAU AVEC ADRAUX.
C====
C 5.1. ==> PROREC : C'EST LA LISTE RECIPROQUE. POUR LA MAILLE NUMERO
C                   IAUX EN NUMEROTATION ASTER, ON A SA POSITION DANS LE
C                   TABLEAU DES VALEURS S'IL FAIT PARTIE DE LA LISTE
C                   ET 0 SINON.
      DO 51 , IAUX = 1 , NVAL
        IMA = PROFAS(IAUX)
        PROREC(IMA) = IAUX
   51 CONTINUE
C
C 5.2. ==> ADRESSES DANS LE TABLEAU PROFAS
C          ADRAUX(IAUX) = ADRESSE DE LA FIN DE LA ZONE DE L'IMPRESSION
C                         PRECEDENTE, IAUX-1
      ADRAUX(1) = 0
      DO 52 , IAUX = 2 , NBIMPR
        ADRAUX(IAUX) = ADRAUX(IAUX-1) + ZI(ADCAII+10*(IAUX-2)+6)
   52 CONTINUE
C
C 5.3. ==> DECOMPTE DU NOMBRE DE MAILLES PAR TYPE DE MAILLES ASTER
C          NMATY0(IAUX) = NUMERO MED DE LA MAILLE COURANTE, DANS LA
C                         CATEGORIE ASTER IAUX. A LA FIN, NMATY0(IAUX)
C                         VAUT LE NOMBRE DE MAILLES PAR TYPE DE MAILLES
C                         ASTER, POUR TOUTES LES MAILLES DU MAILLAGE
C          ADRAUX(JAUX) = ADRESSE DANS LES TABLEAUX PROMED ET PROFAS
C                         DE LA MAILLE COURANTE ASSOCIEE A L'IMPRESSION
C                         NUMERO JAUX
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
C 6.1. ==> NOMBRE DE MAILLES DU MEME TYPE
      DO 61 , IAUX = 1 , NBIMPR
C
        JAUX = ADCAII+10*(IAUX-1)
        TYPMAS = ZI(JAUX+7)
C                  CAIMPI(10,I) = NOMBRE DE MAILLES IDENTIQUES
        ZI(JAUX+9) = NMATY0(TYPMAS)
C
   61 CONTINUE
C
C 6.2. ==> CARACTERISTIQUES CARACTERES
      IAUX = 3*NBIMPR
      CALL WKVECT ( NCAIMK, 'V V K80', IAUX, ADCAIK )
      DO 62 , IAUX = 1 , NBIMPR
        JAUX = ADCAIK+2*(IAUX-1)
C                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
        ZK80(JAUX) = EDNOGA
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
        ZK80(JAUX+1) = EDNOPF
C                  CAIMPK(3,I) = NOM DE L'ELEMENT DE STRUCTURE
        ZK80(JAUX+2) = EDNOPF
   62 CONTINUE
C
C====
C 7. STOCKAGE DES EVENTUELS PROFILS DANS LE FICHIER MED
C====
      KAUX = 1
C
      DO 71 , IAUX = 1 , NBIMPR
C
        JAUX = ADCAII+10*(IAUX-1)
C
C       SI LE NOMBRE DE MAILLES A ECRIRE EST >0
        IF ( ZI(JAUX+6).GT.0 ) THEN
C
C         SI LE NOMBRE DE MAILLES A ECRIRE EST DIFFERENT
C         DU NOMBRE TOTAL DE MAILLES DE MEME TYPE:
          IF ( ZI(JAUX+6).NE.ZI(JAUX+9) ) THEN
            CALL IRCMPF ( NOFIMD,
     >                    ZI(JAUX+6), PROMED(KAUX), NOPROF )
C
C                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
            ZK80(ADCAIK+3*(IAUX-1)+1) = NOPROF
          ENDIF
C
C         KAUX := POINTEUR PERMETTANT DE SE PLACER DANS PROMED
C         POUR LA PROCHAINE IMPRESSION
          KAUX = KAUX + ZI(JAUX+6)
        ENDIF
   71 CONTINUE
C
C====
C 8. LA FIN
C====
      IF ( NIVINF.GT.1 ) THEN
        IF(TYPECH(1:4).EQ.'ELGA')THEN
           WRITE (IFM,8001)
        ELSE
           WRITE (IFM,8004)
        ENDIF
        DO 81 , IAUX = 1 , NBIMPR
          JAUX = ADCAII+10*(IAUX-1)
          IF ( ZI(JAUX+6).GT.0 )
     &      WRITE (IFM,8002) NOMTYP(ZI(JAUX+7)),ZI(JAUX+6),
     &                       ZI(JAUX+1),ZI(JAUX+2)
   81   CONTINUE
        WRITE (IFM,8003)
        WRITE (IFM,1001) 'FIN DE IRCMPE'
      ENDIF
 8001 FORMAT(4X,65('*'),/,4X,'*  TYPE DE *',22X,'NOMBRE DE',21X,'*',
     >/,4X,'*  MAILLE  *  VALEURS   * POINT(S) DE GAUSS *',
     >     '   SOUS_POINT(S)   *',/,4X,65('*'))
 8002 FORMAT(4X,'* ',A8,' *',I11,' *',I15,'    *',I15,'    *')
 8003 FORMAT(4X,65('*'))
 8004 FORMAT(4X,65('*'),/,4X,'*  TYPE DE *',22X,'NOMBRE DE',21X,'*',
     >/,4X,'*  MAILLE  *  VALEURS   *      POINTS       *',
     >     '   SOUS_POINT(S)   *',/,4X,65('*'))
C
      END
