      SUBROUTINE LRCAME ( NROFIC, NOCHMD, NOMAMD, NOMAAS,
     >                    NBVATO, TYPECH,
     >                    NBCMPV, NCMPVA, NCMPVM,
     >                    IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     >                    NOMGD, NCMPRF, JNOCMP, ADSL, ADSV, ADSD,
     >                    CODRET )
C_____________________________________________________________________
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 06/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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
C TOLE CRP_20
C TOLE CRP_21
C-----------------------------------------------------------------------
C     LECTURE D'UN CHAMP - FORMAT MED
C     -    -       - -            --
C-----------------------------------------------------------------------
C      ENTREES:
C        NROFIC : UNITE LOGIQUE DU FICHIER MED
C        NOCHMD : NOM MED DU CHAMP A LIRE
C        NOMAMD : NOM MED DU MAILLAGE LIE AU CHAMP A LIRE
C                  SI ' ' : ON SUPPOSE QUE C'EST LE PREMIER MAILLAGE
C                          DU FICHIER 
C        NOMAAS : NOM ASTER DU MAILLAGE
C        NBVATO : NOMBRE DE VALEURS TOTALES
C        TYPECH : TYPE DE CHAMP AUX ELEMENTS : ELEM/ELGA/ELNO/NOEU
C        NBCMPV : NOMBRE DE COMPOSANTES VOULUES
C                 SI NUL, ON LIT LES COMPOSANTES A NOM IDENTIQUE
C        NCMPVA : LISTE DES COMPOSANTES VOULUES POUR ASTER
C        NCMPVM : LISTE DES COMPOSANTES VOULUES DANS MED
C        IINST  : 1 SI LA DEMANDE EST FAITE SUR UN INSTANT, 0 SINON
C        NUMPT  : NUMERO DE PAS DE TEMPS EVENTUEL
C        NUMORD : NUMERO D'ORDRE EVENTUEL DU CHAMP
C        INST   : INSTANT EVENTUEL
C        CRIT   : CRITERE SUR LA RECHERCHE DU BON INSTANT
C        PREC   : PRECISION SUR LA RECHERCHE DU BON INSTANT
C        NOMGD  : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
C        NCMPRF : NOMBRE DE COMPOSANTES DE REFERENCE DU CHAMP SIMPLE
C        JNOCMP : ADRESSE DU NOM DES COMP. DE REF. DU CHAMP SIMPLE
C        ADSL, ADSV : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
C      SORTIES:
C         CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NROFIC
      INTEGER ADSL, ADSV, ADSD
      INTEGER NBVATO, NCMPRF, JNOCMP
      INTEGER NBCMPV
      INTEGER IINST, NUMPT, NUMORD
      INTEGER CODRET, CODRE2
C
      CHARACTER*4 TYPECH
      CHARACTER*8 NOMGD, NOMAAS
      CHARACTER*8 CRIT
      CHARACTER*32 NOCHMD, NOMAMD
      CHARACTER*(*) NCMPVA, NCMPVM
C
      REAL*8 INST
      REAL*8 PREC
C
C 0.2. ==> COMMUNS
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRCAME' )
C
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
      CHARACTER*32 EDNOPF
      PARAMETER ( EDNOPF='                                ' )
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX=48)
      INTEGER EDNOEU
      PARAMETER (EDNOEU=3)
      INTEGER EDMAIL
      PARAMETER (EDMAIL=0)
      INTEGER EDCONN
      PARAMETER (EDCONN=1)
      INTEGER EDNODA
      PARAMETER (EDNODA=0)
      INTEGER TYPNOE
      PARAMETER (TYPNOE=0)
      INTEGER IAUX, LETYPE
      INTEGER IDFIMD
      INTEGER NBCMFI, NBVAL
      INTEGER NCMPUT
      INTEGER EXISTC
      INTEGER NDIM
      INTEGER NPAS, ADINST, ADNUME
      INTEGER LGPROA
      INTEGER IFM, NIVINF
      INTEGER TYPENT, TYGEOM, NBTYP
      INTEGER NNOTYP(NTYMAX),NITTYP(NTYMAX)
      INTEGER TYPGEO(NTYMAX),LYGEOM(NTYMAX),LYPENT(NTYMAX),LTYP(NTYMAX)
      INTEGER RENUMD(NTYMAX),NLYVAL(NTYMAX)
      INTEGER I,NBTYLU, NBVALS
      INTEGER JTYPMA,JLCONX,NBNOMA,NMATYP
      INTEGER JNUMTY, NROMAI, JAUX, NUMMA, NMATY0(NTYMAX)
C
      CHARACTER*8 SAUX08
      CHARACTER*8 NOMTYP(NTYMAX)
      CHARACTER*19 PREFIX
      CHARACTER*24 NUMCMP, NTNCMP, NTUCMP, NTVALE, NMCMFI(NTYMAX)
      CHARACTER*24 NTPROA, NMCMFL
      CHARACTER*32 NOMPRF
      CHARACTER*200 NOFIMD
      CHARACTER*2 K2BID
C
      LOGICAL EXISTM, EXISTT
      LOGICAL LOGAUX
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
      ENDIF
 1001 FORMAT(/,10('='),A,10('='),/)
C
C 1.2. ==> NOMS DES TABLEAUX DE TRAVAIL
C               12   345678   9012345678901234
      NUMCMP = '&&'//NOMPRO//'.NUMERO_CMP     '
      NTNCMP = '&&'//NOMPRO//'.N0MCMP         '
      NTUCMP = '&&'//NOMPRO//'.UNITECMP       '
      NTVALE = '&&'//NOMPRO//'.VALEUR         '
      NTPROA = '&&'//NOMPRO//'.PROFIL_ASTER   '
      PREFIX = '&&'//NOMPRO//'.MED'
C
C 1.3. ==> NOM DU FICHIER MED
C
      CALL CODENT ( NROFIC, 'G', SAUX08 )
      NOFIMD = 'fort.'//SAUX08
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) NOMPRO, ' : NOM DU FICHIER MED : ', NOFIMD
      ENDIF
C
C 1.4. ==> VERIFICATION DE LA BONNE VERSION DU FICHIER MED
C
      CALL EFFOCO ( NOFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'CHAMP : ', 1, NOCHMD )
        CALL UTIMPI ( 'L', 'ERREUR EFFOCO NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'SOIT LE FICHIER N''EXISTE PAS,'//
     >             ' SOIT C''EST UNE MAUVAISE VERSION DE MED.' )
      ENDIF
C
C 1.5. ==> VERIFICATION DE L'EXISTENCE DU MAILLAGE CONCERNE
C
C 1.5.1. ==> C'EST LE PREMIER MAILLAGE DU FICHIER
C            ON RECUPERE SON NOM ET SA DIMENSION.
C
      IF ( NOMAMD.EQ.' ' ) THEN
C
        CALL MDEXPM ( NOFIMD, NOMAMD, EXISTM, NDIM, CODRET )
        IF ( .NOT.EXISTM ) THEN
          CALL UTMESS ( 'F', NOMPRO, 'PAS DE MAILLAGE DANS '//NOFIMD )
        ENDIF
C
C 1.5.2. ==> C'EST UN MAILLAGE DESIGNE PAR UN NOM
C            ON RECUPERE SA DIMENSION.
C
      ELSE
C
        IAUX = 1
        CALL MDEXMA ( NOFIMD, NOMAMD, IAUX, EXISTM, NDIM, CODRET )
        IF ( .NOT.EXISTM ) THEN
          CALL UTMESS ( 'F', NOMPRO,
     >   'LE MAILLAGE '//NOMAMD//' EST INCONNU DANS '//NOFIMD )
        ENDIF
C
      ENDIF
C
C 2.2. ==> VERIFICATIONS DES COMPOSANTES ASTER DEMANDEES
C          EN SORTIE, ON A :
C       NCMPUT : NOMBRE DE COMPOSANTES VALIDES.
C       NUMCMP : TABLEAU DES NUMEROS DES COMPOSANTES VALIDES
C       NTNCMP : TABLEAU DES NOMS DES COMPOSANTES VALIDES (K8)
C       NTUCMP : TABLEAU DES UNITES DES COMPOSANTES VALIDES (K16)
C
      IF ( NBCMPV.NE.0 ) THEN
        CALL JEVEUO ( NCMPVA, 'L', IAUX )
      ELSE
        IAUX = 1
      ENDIF
C
      CALL UTLICM ( NBCMPV, ZK8(IAUX),
     >              NOMGD, NCMPRF, ZK8(JNOCMP),
     >              NCMPUT, NUMCMP, NTNCMP, NTUCMP )
C
C====
C 2. OUVERTURE DU FICHIER EN LECTURE
C====
C
      CALL CODENT (NROFIC, 'G', SAUX08 )
      NOFIMD = 'fort.'//SAUX08
C
      CALL EFOUVR ( IDFIMD, NOFIMD, EDLECT, CODRET)
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'CHAMP : ', 1, NOCHMD )
        CALL UTIMPI ( 'L', 'ERREUR EFOUVR NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'PROBLEME A L OUVERTURE DU FICHIER' )
      ENDIF
C
C 2.1. ==> . RECUPERATION DES NB/NOMS/NBNO/NBITEM DES TYPES DE MAILLES
C            DANS CATALOGUE
C          . RECUPERATION DES TYPES GEOMETRIE CORRESPONDANT POUR MED
C          . VERIF COHERENCE AVEC LE CATALOGUE
C
      CALL LRMTYP ( NDIM, NBTYP, NOMTYP,
     >              NNOTYP, NITTYP, TYPGEO, RENUMD )
C
C 2.1.1 ==> LE CHAMP EXISTE-T-IL DANS LE FICHIER ?
C          AU BON NUMERO D'ORDRE ?
C          CONTIENT-IL A MINIMA LES COMPOSANTES VOULUES ?
C          LE NOMBRE DE VALEURS EST-IL CORRECT ?
C          SI OUI A TOUTES SES QUESTIONS, EXISTC VAUT 3.
C          ON RECUPERE ALORS :
C          . LE NOMBRE DE COMPOSANTES QU'IL Y A.
C          . LE NOM DE CES COMPOSANTES.
C
C     COMME DANS LRMMMA :
C    REMARQUE : GRACE A LA RENUMEROTATION, ON PARCOURT LES TYPES DE
C    MAILLES DANS L'ORDRE CROISSANT DE LEUR TYPE MED. CE N'EST PAS
C    OBLIGATOIRE SI ON DISPOSE DES TABLEAUX DE NUMEROTATION DES MAILLES.
C    MAIS QUAND CES TABLEAUX SONT ABSENTS, LES CONVENTIONS MED PRECISENT
C    QUE LA NUMEROTATION IMPLICITE SE FAIT DANS CET ORDRE. DONC ON
C    LE FAIT !
C
      NBTYLU = 0
      NBCMFI = 0
      EXISTT = .FALSE.
C
      NUMMA = 1
C     EN SORTIE DE MDEXMA/MDEXPM, CODRET=0
      CODRET = 0
      DO 22 , LETYPE = 0 , NBTYP
C
C 2.2.1. ==> LES BONS TYPES
C
        IF ( LETYPE.EQ.0 ) THEN
          IAUX = LETYPE
        ELSE
          IAUX = RENUMD(LETYPE)
        ENDIF
C
        IF ( IAUX.EQ.0 ) THEN
          TYPENT = EDNOEU
          TYGEOM = TYPNOE
        ELSE
          TYPENT = EDMAIL
          TYGEOM = TYPGEO(IAUX)
        ENDIF
C
C       RECUPERE LE NOMBRE DE MAILLES DE TYPE TYGEOM
        CALL EFNEMA ( IDFIMD, NOMAMD, EDCONN, EDMAIL, TYGEOM, EDNODA,
     >                NMATYP, CODRE2 )
C
        IF ( CODRET.EQ.0 ) THEN
C
C 2.2.2. ==> SI LE CHOIX S'EST FAIT AVEC UNE VALEUR D'INSTANT, ON REPERE
C            LE NUMERO D'ORDRE ASSOCIE
C
        IF ( IINST.NE.0 ) THEN
C
          CALL MDCHIN ( NOFIMD, NOCHMD, TYPENT, TYGEOM, PREFIX,
     >                  NPAS, CODRET )
C
          IF ( NPAS.NE.0 ) THEN
            CALL JEVEUO(PREFIX//'.INST','L',ADINST)
            CALL JEVEUO(PREFIX//'.NUME','L',ADNUME)
            LOGAUX = .FALSE.
            DO 222 , IAUX = 1 , NPAS
              IF ( CRIT(1:4).EQ.'RELA' ) THEN
                IF (ABS(ZR(ADINST-1+IAUX)-INST).LE.ABS(PREC*INST)) THEN
                  LOGAUX = .TRUE.
                ENDIF
              ELSE IF ( CRIT(1:4).EQ.'ABSO' ) THEN
                IF (ABS(ZR(ADINST-1+IAUX)-INST).LE.ABS(PREC)) THEN
                  LOGAUX = .TRUE.
                ENDIF
              ENDIF
              IF ( LOGAUX ) THEN
                NUMPT = ZI(ADNUME+2*IAUX-2)
                NUMORD = ZI(ADNUME+2*IAUX-1)
                GOTO 2221
              ENDIF
  222       CONTINUE
            CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
            CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
            CALL UTIMPK ( 'L', 'CHAMP : ', 1, NOCHMD )
            CALL UTIMPR ( 'L', 'INSTANT VOULU : ', 1, INST )
            CALL UTIMPI ( 'L', 'TYPENT : ', 1, TYPENT )
            CALL UTIMPI ( 'L', 'TYPGEO : ', 1, TYPGEO )
            CALL UTFINM ()
            CALL UTMESS ( 'A', NOMPRO,
     >             'INSTANT INCONNU POUR CE CHAMP ET CES SUPPORTS '//
     >             'DANS LE FICHIER.' )
            GOTO 22
 2221       CONTINUE
C
            IF ( NIVINF.GT.1 ) THEN
              CALL UTDEBM ( 'I', NOMPRO, 'CHAMP ' )
              CALL UTIMPK ( 'S', 'A LIRE : ', 1, NOCHMD )
              CALL UTIMPI ( 'L', 'TYPENT : ', 1, TYPENT )
              CALL UTIMPI ( 'L', 'TYPGEO : ', 1, TYPGEO )
              CALL UTIMPR ( 'L', 'INSTANT VOULU : ', 1, INST )
              CALL UTIMPI ( 'L', '--> NUMERO D ORDRE : ', 1, NUMORD )
              CALL UTIMPI ( 'L',
     >                   '--> NUMERO DE PAS DE TEMPS : ', 1, NUMPT )
              CALL UTFINM ()
            ENDIF
            CALL JEDETC ( 'V', PREFIX, 1 )
          ENDIF
C
C       ENDIF <<< IF ( IINST.NE.0 )
        ENDIF
C
C 2.2.3. ==> RECHERCHE DES COMPOSANTES
C
        CALL CODENT(LETYPE,'G',K2BID)
        NMCMFL = '&&'//NOMPRO//'.N0MCMP_FICHIE'//K2BID

        CALL MDEXCH ( NOFIMD,
     >                NOCHMD, NUMPT, NUMORD, NBCMPV, NCMPVM,
     >                NBVATO, TYPENT, TYGEOM,
     >                EXISTC, NBCMFI, NMCMFL, NBVAL, CODRET )
        IF ( EXISTC.GE.3 ) THEN 
          EXISTT = .TRUE.
          NBTYLU = NBTYLU + 1
          NMCMFI(NBTYLU) = NMCMFL
          IF ( TYPECH.NE.'NOEU' ) THEN 
            LYPENT(NBTYLU) = TYPENT
            LYGEOM(NBTYLU) = TYGEOM
            NLYVAL(NBTYLU) = NBVAL
            LTYP(NBTYLU)   = IAUX
            NMATY0(NBTYLU) = NUMMA
          ENDIF
        ENDIF
C
C       ENDIF <<< IF ( CODRET.EQ.0 )
        ENDIF
C
C       INCREMENTE LE NUMERO INITIAL DES MAILLES DU TYPE SUIVANT
        IF ( NMATYP.GT.0 ) THEN
           NUMMA = NUMMA + NMATYP
        ENDIF
C
   22 CONTINUE
C
C 2.3. ==> IL MANQUE DES CHOSES !
C
      IF ( .NOT.EXISTT ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'CHAMP : ', 1, NOCHMD )
        IF ( IINST.NE.0 ) THEN
          CALL UTIMPR ( 'L', 'INSTANT VOULU : ', 1, INST )
        ELSE
          CALL UTIMPI ( 'L', 'NUMERO D ORDRE : ', 1, NUMORD )
          CALL UTIMPI ( 'L', 'NUMERO DE PAS DE TEMPS : ', 1, NUMPT )
        ENDIF
        CALL UTFINM ()
        IF ( EXISTC.EQ.0 ) THEN 
         CALL UTMESS ( 'A', NOMPRO, 'CHAMP INCONNU.' )
        ELSEIF ( EXISTC.EQ.1 ) THEN 
         CALL UTMESS ( 'A', NOMPRO, 'IL MANQUE DES COMPOSANTES.' )
        ELSEIF ( EXISTC.EQ.2 ) THEN 
         IF ( IINST.NE.0 ) THEN
          CALL UTMESS ( 'A', NOMPRO, 'AUCUNE VALEUR A CET INSTANT.' )
         ELSE
          CALL UTMESS ( 'A', NOMPRO, 'AUCUNE VALEUR A CE NRO D ORDRE.' )
         ENDIF
        ELSEIF ( EXISTC.EQ.4 ) THEN 
         CALL UTMESS ( 'A', NOMPRO, 'MAUVAIS NOMBRE DE VALEURS.' )
        ENDIF
        CALL UTMESS ( 'F', NOMPRO, 'LECTURE IMPOSSIBLE.' )
      ENDIF
C
C=====================================================================
C 3. TRAITEMENT DES CHAMPS AUX NOEUDS                             ====
C=====================================================================
C
      IF (TYPECH(1:4).EQ.'NOEU') THEN
C
C====
C 3.1 LECTURE DES VALEURS
C====
C
      TYPENT = EDNOEU
      TYGEOM = TYPNOE
      CALL LRCMLE ( IDFIMD, NOCHMD, NOMAMD,
     >              NBCMFI, NBVATO, NUMPT, NUMORD,
     >              TYPENT, TYGEOM,
     >              NTVALE, NOMPRF,
     >              CODRET )
C
C====
C 3.2 LECTURE DU PROFIL
C====
C
      IF ( NOMPRF.EQ.EDNOPF ) THEN
        LGPROA = 0
      ELSE
        CALL LRCMPR ( IDFIMD, NOMPRF,NTPROA, LGPROA,CODRET )
      ENDIF
C
C====
C 3.3 TRANFERT DES VALEURS
C====
C
      CALL LRCMVA ( NTVALE, NBVATO, NTPROA, LGPROA,
     >              NCMPRF, ZK8(JNOCMP),
     >              NBCMFI, NMCMFI(1), NBCMPV, NCMPVM, NUMCMP,
     >              ADSL, ADSV,
     >              CODRET )
C
      ELSE
C
C=====================================================================
C 4. TRAITEMENT DES CHAMPS AUX ELEMENTS                           ====
C=====================================================================
C
C  ON BOUCLE (71) SUR LES TYPES DE MAILLE LUS DANS LE CHAMP MED. LE
C  NOMBRE DE MAILLES RELATIF A CE TYPE EST NMATYP RENVOYE PAR EFNEMA.
C  LES VALEURS NUMERIQUES SONT SAUVEES DANS LE TABLEAU D ADRESSE ADSV
C  CE TABLEAU A ETE DIMENSIONNE PAR CESCRE A :
C  NB DE TYPE DE MAIL * NB DE VALEURS PAR MAILLE * NB DE COMPOSANTES 
C  * NB DE MAILLES DU TYPE
C  LE NB DE VALEURS PAR MAILLE :
C       - POUR UN ELNO : NB DE NOEUDS (NBNOMA DONNE PAR CONNECTIVITE)
C       - POUR UN ELEM : 1
C       - POUR UN ELGA : 27 EN DUR (NB MAX DE PTS DE GAUSS)
C
      CALL JEVEUO(JEXATR(NOMAAS(1:8)//'.CONNEX','LONCUM'),'L',JLCONX)
      CALL JEVEUO('&CATA.TE.TYPEMA','L',JTYPMA)
      DO 71 , LETYPE = 1 , NBTYLU
C
C  RECUPERATION DE NMATYP : NOMBRE TOTAL DE MAILLES DANS LE TYPE LYGEOM
C
         CALL EFNEMA ( IDFIMD, NOMAMD, 1, 0, LYGEOM(LETYPE), 0,
     >                 NMATYP, CODRET )
         IF     (TYPECH(1:4).EQ.'ELNO') THEN
            NBNOMA = 0
            DO 72 I=1,NTYMAX
               IF (LYGEOM(LETYPE).EQ.TYPGEO(I)) NBNOMA=NNOTYP(I)
  72        CONTINUE
         ELSEIF (TYPECH(1:4).EQ.'ELEM') THEN
            NBNOMA =  1
         ELSEIF (TYPECH(1:4).EQ.'ELGA') THEN
            NBNOMA =  27
         ENDIF
C
C 4.0.   VECTEUR CONTENANT LES NUMEROS DES MAILLES POUR CE TYPE
C        SI LE FICHIER NE CONTIENT PAS DE NUMERO DES MAILLES, ON LEUR
C        DONNE UN NUMERO PAR DEFAUT
C        C'EST ICI QUE L'ORDRE DE PARCOURS DES TYPES PREND TOUT
C        SON SENS
C
         CALL WKVECT ('&&'//NOMPRO//'.NUM.'//NOMTYP(LTYP(LETYPE)),
     >                  'V V I',NMATYP,JNUMTY)
         CALL EFNUML ( IDFIMD, NOMAMD, ZI(JNUMTY), NMATYP,
     >                 EDMAIL, TYPGEO, CODRET )
C
         NROMAI = NMATY0(LETYPE)
         IF ( CODRET.EQ.0 ) THEN
            NROMAI = NROMAI + NMATYP
         ELSE
            CALL UTMESS ('I',NOMPRO,'ABSENCE DE NUMEROTATION '//
     >             'DES MAILLES '//NOMTYP(LTYP(LETYPE))//
     >             ' DANS LE FICHIER MED')
            DO 211 , JAUX = 1 , NMATYP
              ZI(JNUMTY+JAUX-1) = NROMAI
              NROMAI = NROMAI + 1
  211       CONTINUE
            CODRET = 0
         ENDIF
C
C====
C 4.1 LECTURE DES VALEURS
C====
C
         CALL JEDETC ('V',NTVALE,1)
         NBVALS  =  NLYVAL(LETYPE)*NBCMFI
         CALL LRCMLE ( IDFIMD, NOCHMD, NOMAMD,
     >                 NBCMFI, NBVALS, NUMPT, NUMORD,
     >                 LYPENT(LETYPE), LYGEOM(LETYPE),
     >                 NTVALE, NOMPRF,
     >                 CODRET )
C
C====
C 4.2 LECTURE DU PROFIL
C====
C
         IF ( NOMPRF.EQ.EDNOPF ) THEN
             LGPROA = 0
         ELSE
             CALL JEDETC ('V',NTPROA,1)
             CALL LRCMPR ( IDFIMD, NOMPRF,
     >                     NTPROA, LGPROA,
     >                     CODRET )
         ENDIF
C
C====
C 4.3 TRANFERT DES VALEURS
C====
C
         CALL LRCMVE ( IDFIMD, NOMAMD, LYGEOM(LETYPE),
     >                 NTVALE, NMATYP, NBNOMA, NTPROA, LGPROA,
     >                 NCMPRF, ZK8(JNOCMP),
     >                 NBCMFI, NMCMFI(LETYPE), NBCMPV, NCMPVM, NUMCMP,
     >                 JNUMTY,
     >                 ADSL, ADSV, ADSD, 
     >                 CODRET )
C
   71 CONTINUE
      ENDIF
C
C====
C 5. FIN
C====
C
C 5.1. ==> FERMETURE FICHIER
C
      CALL EFFERM ( IDFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'CHAMP : ', 1, NOCHMD )
        CALL UTIMPI ( 'L', 'ERREUR EFFERM NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'PROBLEME A LA FERMETURE DU FICHIER')
      ENDIF
C
C 5.2. ==> MENAGE
C
      CALL JEDETC ('V','&&'//NOMPRO,1)
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE '//NOMPRO
      ENDIF
C
      END
