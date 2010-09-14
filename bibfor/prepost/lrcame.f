      SUBROUTINE LRCAME ( NROFIC, NOCHMD, NOMAMD, NOMAAS,
     &                    NBVATO, TYPECH, TYPEN,
     &                    NBMA, NPGMA, NPGMM, NTYPEL, NPGMAX, INDPG,
     &                    NBCMPV, NCMPVA, NCMPVM,
     &                    IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     &                    NOMGD, NCMPRF, JNOCMP, ADSL, ADSV, ADSD,
     &                    CODRET )
C_____________________________________________________________________
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/09/2010   AUTEUR REZETTE C.REZETTE 
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
C        NBVATO : NOMBRE DE VALEURS TOTAL
C        TYPECH : TYPE DE CHAMP AUX ELEMENTS : ELEM/ELGA/ELNO/NOEU
C        TYPEN  : TYPE D'ENTITE DU CHAMP 
C                (MED_NOEUD=3,MED_MAILLE=0,MED_NOEUD_MAILLE=4)
C        NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C        NPGMA  : NOMBRE DE POINTS DE GAUSS PAR MAILLE (ASTER)
C        NPGMM  : NOMBRE DE POINTS DE GAUSS PAR MAILLE (MED)
C        NTYPEL : NOMBRE MAX DE TYPE DE MAILLES (DIMENSIONNE INDPG)
C        NPGMAX : NOMBRE MAX DE POINTS DE GAUSS (DIMENSIONNE INDPG)
C        INDPG  : TABLEAU D'INDICES DETERMINANT L'ORDRE DES POINTS
C                 DE GAUSS DANS UN ELEMENT DE REFERENCE (CF LRMPGA)
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
      INTEGER NROFIC,NBMA,TYPEN
      INTEGER ADSL, ADSV, ADSD
      INTEGER NBVATO, NCMPRF, JNOCMP
      INTEGER NBCMPV, NTYPEL, NPGMAX
      INTEGER IINST, NUMPT, NUMORD
      INTEGER INDPG(NTYPEL,NPGMAX),NPGMA(NBMA),NPGMM(NBMA)
      INTEGER CODRET, CODRE2
C
      CHARACTER*(*) TYPECH
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
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      REAL*8 VALR
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
      INTEGER EDLECT,TYPENT
      INTEGER VALI(4)
      PARAMETER (EDLECT=0)
      CHARACTER*32 EDNOPF
      PARAMETER ( EDNOPF='                                ' )
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX=54)
      INTEGER NNOMAX
      PARAMETER (NNOMAX=27)
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
      INTEGER IAUX, LETYPE, VLIB(3), VFIC(3), IRET
      INTEGER IDFIMD
      INTEGER NBCMFI, NBVAL
      INTEGER NCMPUT
      INTEGER EXISTC
      INTEGER NDIM
      INTEGER NPAS, ADINST, ADNUME
      INTEGER LGPROA
      INTEGER IFM, NIVINF
      INTEGER TYGEOM, NBTYP
      INTEGER NNOTYP(NTYMAX),MODNUM(NTYMAX),NUMNOA(NTYMAX,NNOMAX)
      INTEGER TYPGEO(NTYMAX),LYGEOM(NTYMAX),LYPENT(NTYMAX),LTYP(NTYMAX)
      INTEGER RENUMD(NTYMAX),NLYVAL(NTYMAX), NUANOM(NTYMAX,NNOMAX)
      INTEGER NBTYLU,IAUX2,K,NBTY(NTYMAX)
      INTEGER JTYPMA,NBNOMA,NMATYP
      INTEGER JNUMTY, NUMMA,IMA
C
      CHARACTER*1 SAUX01
      CHARACTER*8 SAUX08
      CHARACTER*8 NOMTYP(NTYMAX)
      CHARACTER*19 PREFIX
      CHARACTER*24 NUMCMP, NTNCMP, NTUCMP, NTVALE, NMCMFI(NTYMAX)
      CHARACTER*24 VALK(2)
      CHARACTER*24 NTPROA, NMCMFL
      CHARACTER*32 NOMPRF
      CHARACTER*200 NOFIMD
      CHARACTER*255 KFIC
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
        WRITE (IFM,*) '.. NOM DU CHAMP A LIRE : ',NOMAMD
      ENDIF
 1001 FORMAT(/,10('='),A,10('='),/)
C
C 1.2. ==> NOMS DES TABLEAUX DE TRAVAIL
C               12   345678   9012345678901234
      NUMCMP = '&&'//NOMPRO//'.NUMERO_CMP     '
      NTNCMP = '&&'//NOMPRO//'.NOMCMP         '
      NTUCMP = '&&'//NOMPRO//'.UNITECMP       '
      NTVALE = '&&'//NOMPRO//'.VALEUR         '
      NTPROA = '&&'//NOMPRO//'.PROFIL_ASTER   '
      PREFIX = '&&'//NOMPRO//'.MED'
C
C 1.3. ==> NOM DU FICHIER MED
C
      CALL ULISOG(NROFIC, KFIC, SAUX01)
      IF ( KFIC(1:1).EQ.' ' ) THEN
         CALL CODENT ( NROFIC, 'G', SAUX08 )
         NOFIMD = 'fort.'//SAUX08
      ELSE
         NOFIMD = KFIC(1:200)
      ENDIF
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) '<',NOMPRO,'> NOM DU FICHIER MED : ',NOFIMD
      ENDIF
C
C 1.4. ==> VERIFICATION DU FICHIER MED
C
C 1.4.1. ==> VERIFICATION DE LA VERSION HDF
C
      CALL EFFOCO ( NOFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='EFFOCO  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C 1.4.2. ==> VERIFICATION DE LA VERSION MED
C
      CALL EFVECO ( NOFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        VALI (1) = CODRET
        CALL U2MESS('F+','MED_24')
        CALL EFVEDO(VLIB(1),VLIB(2),VLIB(3),IRET)
        IF( IRET.EQ.0) THEN
          VALI (1) = VLIB(1)
          VALI (2) = VLIB(2)
          VALI (3) = VLIB(3)
          CALL U2MESG('F+','MED_25',0,' ',3,VALI,0,0.D0)
        ENDIF
        CALL EFOUVR ( IDFIMD, NOFIMD, EDLECT, CODRET )
        CALL EFVELI ( IDFIMD, VFIC(1),VFIC(2),VFIC(3), IRET )
        IF( IRET.EQ.0) THEN
          IF ( VFIC(2).EQ.-1 .OR. VFIC(3).EQ.-1) THEN
            CALL U2MESG('F+','MED_26',0,' ',0,0,0,0.D0)
          ELSE
          VALI (1) = VFIC(1)
          VALI (2) = VFIC(2)
          VALI (3) = VFIC(3)
            CALL U2MESG('F+','MED_27',0,' ',3,VALI,0,0.D0)
          ENDIF
          IF (     VFIC(1).LT.VLIB(1)
     &      .OR. ( VFIC(1).EQ.VLIB(1) .AND. VFIC(2).LT.VLIB(2) )
     &      .OR. ( VFIC(1).EQ.VLIB(1) .AND. VFIC(2).EQ.VLIB(2) .AND.
     &             VFIC(3).EQ.VLIB(3) ) ) THEN
            CALL U2MESG('F+','MED_28',0,' ',0,0,0,0.D0)
          ENDIF
        ENDIF
        CALL EFFERM ( IDFIMD, CODRET )
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
          CALL U2MESK('F','MED_50',1,NOFIMD)
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
           VALK(1) = NOMAMD(1:24)
           VALK(2) = NOFIMD(1:24)
           CALL U2MESK('F','MED_51', 2 ,VALK)
        ENDIF
C
      ENDIF
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) '.. NOM DU MAILLAGE MED ASSOCIE : ',NOMAMD,
     &                '   DE DIMENSION', NDIM
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
     &              NOMGD, NCMPRF, ZK8(JNOCMP),
     &              NCMPUT, NUMCMP, NTNCMP, NTUCMP )
C
C====
C 2. OUVERTURE DU FICHIER EN LECTURE
C====
C
      CALL EFOUVR ( IDFIMD, NOFIMD, EDLECT, CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='EFOUVR  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C 2.1. ==> . RECUPERATION DES NB/NOMS/NBNO/NBITEM DES TYPES DE MAILLES
C            DANS CATALOGUE
C          . RECUPERATION DES TYPES GEOMETRIE CORRESPONDANT POUR MED
C          . VERIF COHERENCE AVEC LE CATALOGUE
C
      CALL LRMTYP ( NBTYP, NOMTYP,
     &              NNOTYP, TYPGEO, RENUMD,
     &              MODNUM, NUANOM, NUMNOA )
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
          TYPENT = TYPEN
          TYGEOM = TYPGEO(IAUX)
        ENDIF
C
C       RECUPERE LE NOMBRE DE MAILLES DE TYPE TYGEOM
        CALL EFNEMA ( IDFIMD, NOMAMD, EDCONN, EDMAIL, TYGEOM, EDNODA,
     &                NMATYP, CODRE2 )
C
        IF ( CODRET.EQ.0 ) THEN
C
C 2.2.2. ==> SI LE CHOIX S'EST FAIT AVEC UNE VALEUR D'INSTANT, ON REPERE
C            LE NUMERO D'ORDRE ASSOCIE
C
        IF ( IINST.NE.0 ) THEN
C
          IF ( NIVINF.GT.1 ) THEN
           WRITE (IFM,*) '.... INSTANT : ', INST
          ENDIF
          CALL MDCHIN ( NOFIMD, NOCHMD, TYPENT, TYGEOM, PREFIX,
     &                  NPAS, CODRET )
C
          IF ( NPAS.NE.0 ) THEN
            CALL JEVEUO(PREFIX//'.INST','L',ADINST)
            CALL JEVEUO(PREFIX//'.NUME','L',ADNUME)
            LOGAUX = .FALSE.
            DO 222 , IAUX2 = 1 , NPAS
              IF ( CRIT(1:4).EQ.'RELA' ) THEN
                IF (ABS(ZR(ADINST-1+IAUX2)-INST).LE.ABS(PREC*INST)) THEN
                  LOGAUX = .TRUE.
                ENDIF
              ELSE IF ( CRIT(1:4).EQ.'ABSO' ) THEN
                IF (ABS(ZR(ADINST-1+IAUX2)-INST).LE.ABS(PREC)) THEN
                  LOGAUX = .TRUE.
                ENDIF
              ENDIF
              IF ( LOGAUX ) THEN
                NUMPT = ZI(ADNUME+2*IAUX2-2)
                NUMORD = ZI(ADNUME+2*IAUX2-1)
                GOTO 2221
              ENDIF
  222       CONTINUE
            VALK (1) = NOFIMD(1:24)
            VALK (2) = NOCHMD(1:24)
            VALR = INST
            VALI (1) = TYPENT
            VALI (2) = TYPGEO(1)
            CALL U2MESG('A','MED_97',2,VALK,2,VALI,1,VALR)
            CALL U2MESS('A','MED_52')
            GOTO 22
 2221       CONTINUE
C
            IF ( NIVINF.GT.1 ) THEN
              VALK (1) = NOCHMD(1:24)
              VALI (1) = TYPENT
              VALI (2) = TYPGEO(1)
              VALI (3) = NUMORD
              VALI (4) = NUMPT
              VALR = INST
              CALL U2MESG('I','MED_86',1,VALK,4,VALI,1,VALR)
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
        NMCMFL = '&&'//NOMPRO//'.NOMCMP_FICHIE'//K2BID

        CALL MDEXCH ( NOFIMD,
     &                NOCHMD, NOMAMD, NUMPT, NUMORD, NBCMPV, NCMPVM,
     &                NBVATO, TYPENT, TYGEOM,
     &                EXISTC, NBCMFI, NMCMFL, NBVAL, CODRET )
        IF ( EXISTC.GE.3 ) THEN
          EXISTT = .TRUE.
          NBTYLU = NBTYLU + 1
          NMCMFI(NBTYLU) = NMCMFL
          IF ( TYPECH(1:4).NE.'NOEU' ) THEN
            LYPENT(NBTYLU) = TYPENT
            LYGEOM(NBTYLU) = TYGEOM
            NLYVAL(NBTYLU) = NBVAL
            LTYP(NBTYLU)   = IAUX
            NBTY(NBTYLU)   = NMATYP
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
        VALK (1) = NOFIMD(1:24)
        VALK (2) = NOCHMD(1:24)
        CALL U2MESG('A+','MED_98',2,VALK,0,0,0,0.D0)
        IF ( IINST.NE.0 ) THEN
          VALR = INST
          CALL U2MESG('A+','MED_68',0,' ',0,0,1,VALR)
        ELSE
          VALI (1) = NUMORD
          VALI (2) = NUMPT
          CALL U2MESG('A+','MED_69',0,' ',2,VALI,0,0.D0)
        ENDIF
        IF ( EXISTC.EQ.0 ) THEN
         CALL U2MESS('A','MED_32')
        ELSEIF ( EXISTC.EQ.1 ) THEN
         CALL U2MESS('A','MED_33')
        ELSEIF ( EXISTC.EQ.2 ) THEN
         IF ( IINST.NE.0 ) THEN
          CALL U2MESS('A','MED_34')
         ELSE
          CALL U2MESS('A','MED_35')
         ENDIF
        ELSEIF ( EXISTC.EQ.4 ) THEN
         CALL U2MESS('A','MED_36')
        ENDIF
        CALL U2MESS('F','MED_37')
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
      TYPENT = TYPEN
      TYGEOM = TYPNOE
      CALL LRCMLE ( IDFIMD, NOCHMD, NOMAMD,
     &              NBCMFI, NBVATO, NUMPT, NUMORD,
     &              TYPENT, TYGEOM,
     &              NTVALE, NOMPRF,
     &              CODRET )
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
     &              NCMPRF, ZK8(JNOCMP),
     &              NBCMFI, NMCMFI(1), NBCMPV, NCMPVM, NUMCMP,
     &              NOCHMD,
     &              ADSL, ADSV,
     &              CODRET )
C
      ELSE
C
C=====================================================================
C 4. TRAITEMENT DES CHAMPS AUX ELEMENTS                           ====
C=====================================================================
C
C  ON BOUCLE (71) SUR LES TYPES DE MAILLE LUES DANS LE CHAMP MED. 
C  LES VALEURS NUMERIQUES SONT SAUVEES DANS LE TABLEAU D ADRESSE ADSV
C  CE TABLEAU A ETE DIMENSIONNE PAR CESCRE A :
C  NB DE TYPE DE MAIL * NB DE VALEURS PAR MAILLE * NB DE COMPOSANTES
C  * NB DE MAILLES DU TYPE
C  LE NB DE VALEURS PAR MAILLE :
C       - POUR UN ELNO : NB DE NOEUDS (NBNOMA DONNE PAR CONNECTIVITE)
C       - POUR UN ELEM : 1
C       - POUR UN ELGA : VARIABLE (INFO PRESENTE DANS LE TABLEAU NPGMA)
C
      NBMA=ZI(ADSD)
      CALL JEVEUO(NOMAAS(1:8)//'.TYPMAIL','L',JTYPMA)

      DO 71 , LETYPE = 1 , NBTYLU
C
         NBNOMA=1
         IF     (TYPECH(1:4).EQ.'ELNO') THEN
            NBNOMA = NNOTYP(LTYP(LETYPE))
         ENDIF
C
C====
C 4.0 VECTEUR CONTENANT LES NUMEROS DES MAILLES POUR CE TYPE
C====
C        ON BOUCLE (72) SUR LES MAILLES DU MAILLAGE ASTER
C        ET ON RELEVE LES MAILLES CORRESPONDANT AU TYPE LU
         CALL WKVECT ('&&'//NOMPRO//'.NUM.'//NOMTYP(LTYP(LETYPE)),
     &                  'V V I',NBTY(LETYPE),JNUMTY)
         K=0
         DO 72 IMA=1,NBMA
           IF(ZI(JTYPMA+IMA-1).EQ.LTYP(LETYPE))THEN
              K=K+1
              ZI(JNUMTY+K-1)=IMA
           ENDIF
 72      CONTINUE
         IF (K.NE.NBTY(LETYPE)) THEN
           CALL U2MESS('F','MED_58')
         ENDIF

C
C====
C 4.1 LECTURE DES VALEURS
C====
C
         CALL JEDETC ('V',NTVALE,1)
         CALL LRCMLE ( IDFIMD, NOCHMD, NOMAMD,
     &                 NBCMFI, NLYVAL(LETYPE), NUMPT, NUMORD,
     &                 LYPENT(LETYPE), LYGEOM(LETYPE),
     &                 NTVALE, NOMPRF,
     &                 CODRET )
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
     &                     NTPROA, LGPROA,
     &                     CODRET )
         ENDIF
C
C====
C 4.3 TRANFERT DES VALEURS
C====
C
         CALL LRCMVE ( NTVALE, NBTY(LETYPE), NBNOMA, NTPROA, LGPROA,
     &                 NCMPRF, ZK8(JNOCMP),NTYPEL,NPGMAX,INDPG,
     &                 NBCMFI, NMCMFI(LETYPE), NBCMPV, NCMPVM, NUMCMP,
     &                 JNUMTY, NOCHMD,NBMA,NPGMA,NPGMM,TYPECH,
     &                 LTYP(LETYPE),ADSL, ADSV, ADSD,
     &                 CODRET )
C 
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
        SAUX08='EFFERM  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
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
