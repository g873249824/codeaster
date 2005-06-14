      SUBROUTINE LRCMVE ( NTVALE, NMATYP, NBNOMA, NTPROA, LGPROA,
     >                    NCMPRF, NOMCMR,
     >                    NBCMFI, NMCMFI, NBCMPV, NCMPVM, NUMCMP,
     >                    JNUMMA,
     >                    ADSL,   ADSV,   ADSD,
     >                    CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/11/2004   AUTEUR MCOURTOI M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C     LECTURE D'UN CHAMP - FORMAT MED - CREATION DES VALEURS AUX ELTS
C     -    -       -              -                  -           -
C-----------------------------------------------------------------------
C     ENTREES:
C       NTVALE : TABLEAU QUI CONTIENT LES VALEURS LUES
C       NMATYP : NOMBRE D ELEMENTS DU TYPE CONSIDERE
C       NBNOMA : NOMBRE DE POINTS PAR ELEMENTS (1 OU GAUSS OU NOEUDS)
C       NTPROA : TABLEAU QUI CONTIENT LE PROFIL ASTER
C       LGPROA : LONGUEUR DU PROFIL ASTER
C                SI NUL, PAS DE PROFIL
C       NCMPRF : NOMBRE DE COMPOSANTES DU CHAMP DE REFERENCE
C       NOMCMR : NOMS DES COMPOSANTES DE REFERENCE
C       NBCMFI : NOMBRE DE COMPOSANTES DANS LE FICHIER      .
C       NMCMFI : NOM DES COMPOSANTES DANS LE FICHIER
C       NBCMPV : NOMBRE DE COMPOSANTES VOULUES
C                SI NUL, ON LIT LES COMPOSANTES A NOM IDENTIQUE
C       NCMPVM : LISTE DES COMPOSANTES VOULUES DANS MED
C       NUMCMP : TABLEAU DES NUMEROS DES COMPOSANTES VALIDES
C       JNUMMA : ADR JEVEUX DU VECTEUR DES NUMEROS DE MAILLES BALAYEES
C     SORTIES:
C       ADSL, ADSV : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C
C   REMARQUE :
C    LE TABLEAU DE VALEURS EST UTILISE AINSI : TV(NBCMFI,NVALUT)
C    EN FORTRAN, CELA CORRESPOND AU STOCKAGE MEMOIRE SUIVANT :
C    TV(1,1), TV(2,1), ..., TV(NBCMFI,1), TV(1,2), TV(2,2), ..., 
C    TV(NBCMFI,2) , TV(1,3), TV(2,3), ..., TV(1,NVALUT), TV(2,NVALUT),
C    TV(NBCMFI,NVALUT)
C    C'EST CE QUE MED APPELLE LE MODE ENTRELACE
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NMATYP, NBNOMA, LGPROA
      INTEGER NCMPRF, NBCMPV, JNUMMA
      INTEGER ADSL, ADSV, ADSD
      INTEGER CODRET
C
      CHARACTER*(*) NOMCMR(*)
      CHARACTER*(*) NTVALE, NTPROA, NCMPVM, NMCMFI, NUMCMP
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRCMVE' )
C
      INTEGER INDIK8
C
      INTEGER IAUX, JAUX, LAUX
      INTEGER NRCMP, NCMPDB
      INTEGER NUVAL
      INTEGER NBCMFI, I, KK, LXLGUT
      INTEGER ADREMP, ADVALE, ADNCFI, ADNUCM, ADNCVM, ADPROA
C
      CHARACTER*8 SAUX08
      CHARACTER*24 NTCMPL
C
C====
C 1. ON BOUCLE SUR LES NBCMFI COMPOSANTES DU CHAMP QUI A ETE LU
C    DANS LE FICHIER
C====
C
      CODRET = 0
C
C               12   345678   9012345678901234
      NTCMPL = '&&'//NOMPRO//'.LOGIQUECMP     '
      CALL WKVECT ( NTCMPL, 'V V L', NCMPRF , ADREMP )
C
      CALL JEVEUO ( NTVALE, 'L', ADVALE )
      IF ( NBCMPV.NE.0 ) THEN
        CALL JEVEUO ( NCMPVM, 'L', ADNCVM )
      ENDIF
      CALL JEVEUO ( NMCMFI, 'L', ADNCFI )
      CALL JEVEUO ( NUMCMP, 'L', ADNUCM )
C
      IF ( LGPROA.NE.0 ) THEN
        CALL JEVEUO ( NTPROA, 'L', ADPROA )
      ENDIF
C
      DO 11 , IAUX = 1 , NBCMFI
C
        NCMPDB = 1
C
C 1.1. ==> REPERAGE DU NUMERO DE LA COMPOSANTE DU CHAMP ASTER DANS
C          LAQUELLE AURA LIEU LE TRANSFERT DE LA IAUX-EME COMPOSANTE LUE
C
  110   CONTINUE
C
        NRCMP = 0
C
C 1.1.1. ==> QUAND ON VEUT UNE SERIE DE COMPOSANTES :
C            BOUCLE 111 : ON CHERCHE, DANS LA LISTE VOULUE EN MED,
C            NCMPVM, A QUEL ENDROIT SE TROUVE LA COMPOSANTE LUE EN
C            COURS DE TRAITEMENT, ZK16(ADNCFI-1+IAUX).
C            ON EXPLORE LA LISTE DE NCMPDB, QUI VAUT 1 AU DEBUT, A
C            NBCMPV, QUI EST LE NOMBRE DE COMPOSANTES VOULUES.
C
C            DEUX CAS DE FIGURE :
C            . SI AUCUN ELEMENT DE CETTE LISTE NE CORRESPOND A LA
C              COMPOSANTE LUE, CELA VEUT DIRE QUE CETTE COMPOSANTE N'EST
C              PAS SOUHAITEE. EN QUELQUE SORTE, ELLE A ETE LUE POUR
C              RIEN. ON PASSE A LA COMPOSANTE LUE SUIVANTE (GOTO 11)
C
C            . QUAND ON TOMBE SUR UNE COMPOSANTE MED VOULUE IDENTIQUE,
C              ON VA REMPLIR LA COMPOSANTE ASTER ASSOCIEE AVEC LES
C              VALEURS DE LA COMPOSANTE LUE. POUR CELA :
C              . ON DEDUIT LE NUMERO DANS LA LISTE OFFICIELLE DE LA
C                COMPOSANTE ASTER ASSOCIEE, ZI(ADNUCM-1+JAUX).
C              . ON MEMORISE QUE LA COMPOSANTE ASTER EST REMPLIE GRACE
C                AU BOOLEN ZL(ADREMP+NRCMP-1).
C              . ON MEMORISE A QUEL ENDROIT DE LA LISTE VOULUE EN MED ON
C                EN EST. EN EFFET, LES VALEURS DE LA COMPOSANTE LUE
C                PEUVENT ETRE MISES DANS PLUSIEURS COMPOSANTES ASTER.
C                UNE FOIS LE TRANSFERT EFFECTUE, ON REPRENDRA
C                L'EXPLORATION DE LA LISTE A L'ENDROIT OU ON S'ETAIT
C                ARRETE : NCMPDB.
C              . ON FAIT LE TRANSFERT DES VALEURS (GOTO 12).
C
        IF ( NBCMPV.NE.0 ) THEN
C
            DO 111 , JAUX = NCMPDB , NBCMPV
              IF ( ZK16(ADNCVM-1+JAUX).EQ.ZK16(ADNCFI-1+IAUX) ) THEN
                NRCMP = ZI(ADNUCM-1+JAUX)
                NCMPDB = JAUX + 1
                GOTO 12
              ENDIF
 111       CONTINUE
           GOTO 11
C
C 1.1.2. ==> QUAND ON STOCKE A L'IDENTIQUE, ON RECHERCHE LE NUMERO DE
C            COMPOSANTE DE REFERENCE QUI A LE MEME NOM QUE LA
C            COMPOSANTE LUE. ON EST OBLIGE DE FAIRE CETTE RECHERCHE CAR
C            RIEN NE GARANTIT QUE L'ORDRE DES COMPOSANTES SOIT LE MEME
C            DANS LA REFERENCE ASTER ET DANS LE CHAMP ECRIT DANS LE
C            FICHIER.
        ELSE
C
          SAUX08 = ZK16(ADNCFI-1+IAUX)(1:8)
          IF ( LXLGUT(ZK16(ADNCFI-1+IAUX)).GT.8 ) THEN
            CALL UTMESS( 'A',NOMPRO,'NOM DE COMPOSANTE TRONQUEE A 8 '//
     &        'CARACTERES ('//ZK16(ADNCFI-1+IAUX)//' >>> '//SAUX08//')')
          ENDIF
          NRCMP = INDIK8 ( NOMCMR, SAUX08, 1, NCMPRF )
C
        ENDIF
C
C 1.2. ==> SI AUCUNE COMPOSANTE N'A ETE TROUVEE, MALAISE ...
C
  12    CONTINUE
C          
        IF ( NRCMP.EQ.0 ) THEN
          CALL UTMESS('F',NOMPRO,'IMPOSSIBLE DE TROUVER LA COMPOSANTE'//
     >                ' ASTER ASSOCIEE A '//ZK16(ADNCFI-1+IAUX))
        ENDIF
C
C 1.3. ==> TRANSFERT DES VALEURS DANS LA COMPOSANTE NRCMP
C
        ZL(ADREMP+NRCMP-1) = .TRUE.
        LAUX = ADVALE-NBCMFI+IAUX-1
C
C 1.3.1. ==> SANS PROFIL : ON PARCOURT TOUTES LES MAILLES
C
        IF ( LGPROA.EQ.0 ) THEN
          DO 131 , JAUX = 1 , NMATYP
            DO 132 ,  I = 1 , NBNOMA
              CALL CESEXI('S',ADSD,ADSL,ZI(JNUMMA+JAUX-1),I,1,IAUX,KK)
              LAUX = LAUX + NBCMFI
              ZL(ADSL-KK-1) = .TRUE.
              ZR(ADSV-KK-1) = ZR(LAUX)
 132        CONTINUE
 131      CONTINUE
        ELSE
C
C 1.3.2. ==> AVEC PROFIL : ON PARCOURT LES MAILLES DU PROFIL 
C
          DO 133 , NUVAL = 0 , LGPROA-1
           JAUX = ZI(ADPROA+NUVAL)
            DO 134 ,  I = 1 , NBNOMA
              CALL CESEXI('S',ADSD,ADSL,ZI(JNUMMA+JAUX-1),I,1,IAUX,KK)
              LAUX = LAUX + NBCMFI
              ZL(ADSL-KK-1) = .TRUE.
              ZR(ADSV-KK-1) = ZR(LAUX)
 134        CONTINUE
 133      CONTINUE
        ENDIF
C
C
C 1.4. ==> QUAND ON VEUT UNE SERIE DE COMPOSANTES, ON REPREND
C          L'EXPLORATION DE LA LISTE VOULUE
C
        IF ( NBCMPV.NE.0 ) THEN
          GOTO 110
        ENDIF
C
  11  CONTINUE
C
C====
C 2. ON INFORME SUR LES COMPOSANTES QUI N'ONT PAS ETE REMPLIES
C====
C
      DO 21 , JAUX = 1 , NCMPRF
        IF ( .NOT.ZL(ADREMP+JAUX-1) ) THEN
          SAUX08 = NOMCMR(JAUX)
          CALL UTMESS('I',NOMPRO,'LA COMPOSANTE '//SAUX08//
     >                ' N''A PAS ETE REMPLIE.')
        ENDIF
   21 CONTINUE
C
C====
C 3. MENAGE
C====
C
      CALL JEDETC ('V','&&'//NOMPRO,1)
C
      END
