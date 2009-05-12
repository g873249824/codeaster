      SUBROUTINE IRCMVA ( NUMCMP, NCMPVE, NCMPRF,
     &                    NVALEC, NBPG, NBSP,
     &                    ADSV, ADSD, ADSL, ADSK, PARTIE,
     &                    TYMAST, MODNUM, NUANOM, TYPECH,
     &                    VAL, PROFAS, IDEB, IFIN )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
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
C_______________________________________________________________________
C     ECRITURE D'UN CHAMP -  FORMAT MED - CREATION DES VALEURS
C        -  -       -               -                  --
C_______________________________________________________________________
C     ENTREES :
C       NUMCMP : NUMEROS DES COMPOSANTES
C       NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
C       NVALEC : NOMBRE DE VALEURS A ECRIRE
C       NBPG   : NOMBRE DE POINTS DE GAUSS (1 POUR DES CHAMNO)
C       NBSP   : NOMBRE DE SOUS-POINTS (1 POUR DES CHAMNO)
C       TYPECH : TYPE DE CHAMP (ELNO,ELGA,NOEU)
C       ADSV,D,L,K : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
C       PARTIE: IMPRESSION DE LA PARTIE IMAGINAIRE OU REELLE POUR
C               UN CHAMP COMPLEXE 
C       TYMAST : TYPE ASTER DE MAILLE QUE L'ON VEUT (0 POUR LES NOEUDS)
C       MODNUM : INDICATEUR SI LA SPECIFICATION DE NUMEROTATION DES
C                NOEUDS DES MAILLES EST DIFFERENTES ENTRE ASTER ET MED:
C                     MODNUM = 0 : NUMEROTATION IDENTIQUE
C                     MODNUM = 1 : NUMEROTATION DIFFERENTE
C       NUANOM : TABLEAU DE CORRESPONDANCE DES NOEUDS MED/ASTER.
C                NUANOM(ITYP,J): NUMERO DANS ASTER DU J IEME NOEUD DE LA
C                MAILLE DE TYPE ITYP DANS MED.
C       PROFAS : PROFIL ASTER. C'EST LA LISTE DES NUMEROS ASTER
C                DES NOEUDS OU DES ELEMENTS POUR LESQUELS LE CHAMP
C                EST DEFINI
C       IDEB   : INDICE DE DEBUT DANS PROFAS
C       IFIN   : INDICE DE FIN DANS PROFAS
C     SORTIES :
C       VAL    : VALEURS EN MODE ENTRELACE
C_______________________________________________________________________
C
      IMPLICIT NONE
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 53)
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NCMPVE, NCMPRF, NVALEC, NBPG, NBSP
      INTEGER NUMCMP(NCMPRF)
      INTEGER ADSV, ADSD, ADSL, ADSK
      INTEGER TYMAST
      INTEGER MODNUM(NTYMAX), NUANOM(NTYMAX,*)
      INTEGER PROFAS(*)
      INTEGER IDEB, IFIN
C
      REAL*8 VAL(NCMPVE,NBSP,NBPG,NVALEC)
C
      CHARACTER*8  TYPECH
      CHARACTER*(*) PARTIE
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
C
      CHARACTER*8  PART,GD, VALK(2), TYPCHA ,K8BID
      INTEGER IAUX, JAUX, KAUX, ITYPE, IBID
      INTEGER ADSVXX,ADSLXX
      INTEGER INO, IMA, NRCMP, NRCMPR, NRPG, NRSP
      INTEGER IFM, NIVINF, IER
C
      LOGICAL LOGAUX,LPROLZ
C
C====
C 1. PREALABLES
C====
      LPROLZ=.FALSE.
      PART=PARTIE
      GD=ZK8(ADSK-1+2)
C
      CALL DISMOI('F','TYPE_SCA',GD,'GRANDEUR',IBID,TYPCHA,IER)
C
      IF (TYPCHA.EQ.'R')THEN 
           ITYPE=1
      ELSE IF(TYPCHA.EQ.'C')THEN
         IF (PART(1:4).EQ.'REEL')THEN
           ITYPE=2
         ELSEIF (PART(1:4).EQ.'IMAG')THEN
           ITYPE=3
         ENDIF
      ELSE
         VALK(1) = GD
         VALK(2) = 'IRCMVA'
         CALL U2MESK('F', 'DVP_3', 2, VALK)
      ENDIF

C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV ( IFM, NIVINF )
C
C 1.2. ==> INFORMATION
C
      IF ( NIVINF.GT.1 ) THEN
        CALL U2MESS('I','MED_47')
        WRITE (IFM,13001) NVALEC, NCMPVE, NBPG, NBSP
      ENDIF
13001 FORMAT('  NVALEC =',I8,', NCMPVE =',I8,
     &       ', NBPG   =',I8,', NBSP   =',I8,/)
C
C====
C 2. CREATION DU CHAMP DE VALEURS AD-HOC
C    LE TABLEAU DE VALEURS EST UTILISE AINSI :
C        TV(NCMPVE,NBSP,NBPG,NVALEC)
C    EN FORTRAN, CELA CORRESPOND AU STOCKAGE MEMOIRE SUIVANT :
C    TV(1,1,1,1), TV(2,1,1,1), ..., TV(NCMPVE,1,1,1),
C    TV(1,2,1,1), TV(2,2,1,1), ..., TV(NCMPVE,2,1,1),
C            ...     ...     ...
C    TV(1,NBSP,NBPG,NVALEC), TV(2,NBSP,NBPG,NVALEC), ... ,
C                                      TV(NCMPVE,NBSP,NBPG,NVALEC)
C    C'EST CE QUE MED APPELLE LE MODE ENTRELACE
C    ATTENTION : LE CHAMP SIMPLIFIE EST DEJA PARTIELLEMENT FILTRE ...
C    ATTENTION ENCORE : LE CHAMP SIMPLIFIE N'A PAS LA MEME STRUCTURE
C    POUR LES NOEUDS ET LES ELEMENTS. IL FAUT RESPECTER CE TRAITEMENT
C    REMARQUE : SI UNE COMPOSANTE EST ABSENTE, ON AURA UNE VALEUR NULLE
C    REMARQUE : ATTENTION A BIEN REDIRIGER SUR LE NUMERO DE
C    COMPOSANTE DE REFERENCE
C====
C
C 2.1. ==> POUR LES NOEUDS : ON PREND TOUT CE QUI FRANCHIT LE FILTRE
C
      IF ( TYMAST.EQ.0 ) THEN
CGN        PRINT *,'PREMIER NOEUD : ',PROFAS(IDEB)
CGN        PRINT *,'DERNIER NOEUD : ',PROFAS(IFIN)
C
        DO 21 , NRCMP = 1 , NCMPVE
C
          ADSVXX = ADSV-1+NUMCMP(NRCMP)-NCMPRF
          ADSLXX = ADSL-1+NUMCMP(NRCMP)-NCMPRF
          JAUX = 0
          DO 211 , IAUX = IDEB, IFIN
            INO = PROFAS(IAUX)
            JAUX = JAUX + 1
            KAUX = INO*NCMPRF
            IF(ZL(ADSLXX+KAUX))THEN
              IF(ITYPE.EQ.1)THEN
                 VAL(NRCMP,1,1,JAUX) = ZR(ADSVXX+KAUX)
              ELSEIF(ITYPE.EQ.2)THEN
                 VAL(NRCMP,1,1,JAUX) = DBLE(ZC(ADSVXX+KAUX))
              ELSEIF(ITYPE.EQ.3)THEN
                 VAL(NRCMP,1,1,JAUX) = DIMAG(ZC(ADSVXX+KAUX))
              ENDIF
            ELSE
              LPROLZ=.TRUE.
              VAL(NRCMP,1,1,JAUX) = 0.D0
            ENDIF
  211     CONTINUE
C
   21   CONTINUE

        IF(LPROLZ)CALL U2MESS('I','MED_30')
C
      ELSE
C
C 2.2. ==> POUR LES MAILLES : ON PREND TOUT CE QUI FRANCHIT LE FILTRE
C          ET QUI EST DU TYPE EN COURS
C          REMARQUE : ON NE REDECODE PAS LES NOMBRES DE POINTS DE GAUSS
C          NI DE SOUS-POINT CAR ILS SONT INVARIANTS POUR UNE IMPRESSION
C          DONNE
C          REMARQUE : DANS LE CAS DE CHAMPS AUX NOEUDS PAR ELEMENTS,
C          L'ORDRE DE STOCKAGE DES VALEURS DANS UNE MAILLE DONNEE EST
C          CELUI DE LA CONNECTIVITE LOCALE DE LA MAILLE. OR POUR
C          CERTAINES MAILLES, CET ORDRE CHANGE ENTRE ASTER ET MED. IL
C          FAUT DONC RENUMEROTER.
C
CGN        PRINT *,'PREMIERE MAILLE : ',PROFAS(IDEB)
CGN        PRINT *,'DERNIERE MAILLE : ',PROFAS(IFIN)
C
C 2.2.1. ==> A-T-ON BESOIN DE RENUMEROTER ?
C            REMARQUE : LE MODE DE RANGEMENT FAIT QUE CELA NE FONCTIONNE
C            QUE POUR LES CHAMPS AVEC 1 SEUL SOUS-POINT.
C
        LOGAUX = .FALSE.
        IF ( TYPECH(1:4).EQ.'ELNO' ) THEN
          IF ( MODNUM(TYMAST).EQ.1 ) THEN
            LOGAUX = .TRUE.
          ENDIF
        ENDIF
C
        IF ( LOGAUX ) THEN
          IF ( NBSP.GT.1 ) THEN
            WRITE (IFM,13001) NVALEC, NCMPVE, NBPG, NBSP
            CALL U2MESS('F','MED_48')
          ENDIF
        ENDIF
C
C 2.2.2. ==> TRANSFERT
C            ON FAIT LE TEST AVANT LA BOUCLE 211. IL EST DONC FAIT
C            AUTANT DE FOIS QUE DE COMPOSANTES A TRANSFERER. AU-DELA, CE
C            SERAIT AUTANT DE FOIS QUE DE MAILLES, DONC COUTEUX
C
        DO 22 , NRCMP = 1 , NCMPVE
C
          NRCMPR = NUMCMP(NRCMP)
          JAUX = 0
          IF ( LOGAUX ) THEN
C
            NRSP = 1
            DO 221 , IAUX = IDEB, IFIN
              IMA = PROFAS(IAUX)
              JAUX = JAUX + 1
              DO 2211 , NRPG = 1 , NBPG
                CALL CESEXI ('C',ADSD,ADSL,IMA,NRPG,NRSP,NRCMPR,KAUX)
                IF(ITYPE.EQ.1)THEN
                    VAL(NRCMP,NRSP,NUANOM(TYMAST,NRPG),JAUX)=
     &                    ZR(ADSV-1+KAUX)
                ELSEIF(ITYPE.EQ.2)THEN
                    VAL(NRCMP,NRSP,NUANOM(TYMAST,NRPG),JAUX)=
     &                    DBLE(ZC(ADSV-1+KAUX))
                ELSEIF(ITYPE.EQ.3)THEN
                    VAL(NRCMP,NRSP,NUANOM(TYMAST,NRPG),JAUX)=
     &                    DIMAG(ZC(ADSV-1+KAUX))
                ENDIF
 2211         CONTINUE
C
  221       CONTINUE
C
          ELSE
C
            DO 222 , IAUX = IDEB, IFIN
              IMA = PROFAS(IAUX)
              JAUX = JAUX + 1
              DO 2221 , NRPG = 1 , NBPG
                DO 2222 , NRSP = 1 , NBSP
                  CALL CESEXI ('C',ADSD,ADSL,IMA,NRPG,NRSP,NRCMPR,KAUX)
                  IF(ITYPE.EQ.1)THEN
                    VAL(NRCMP,NRSP,NRPG,JAUX) = ZR(ADSV-1+KAUX)
                  ELSEIF(ITYPE.EQ.2)THEN
                    VAL(NRCMP,NRSP,NRPG,JAUX) = DBLE(ZC(ADSV-1+KAUX))
                  ELSEIF(ITYPE.EQ.3)THEN
                    VAL(NRCMP,NRSP,NRPG,JAUX) = DIMAG(ZC(ADSV-1+KAUX))
                  ENDIF
 2222           CONTINUE
 2221         CONTINUE
C
  222       CONTINUE
C
          ENDIF
C
   22   CONTINUE
C
      ENDIF
C
      END
