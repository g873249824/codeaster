      SUBROUTINE LRCEME ( CHANOM, NOCHMD, TYPECH, NOMAMD,
     &                    NOMAAS, NOMMOD, NOMGD, TYPENT,
     &                    NBCMPV, NCMPVA, NCMPVM, PROLZ,
     &                    IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     &                    NROFIC, LIGREL, OPTION, PARAM, 
     &                    NBPGMA, NBPGMM, CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/05/2011   AUTEUR SELLENET N.SELLENET 
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
C     LECTURE D'UN CHAMP AUX ELEMENTS - FORMAT MED
C     -    -       -         -               --
C-----------------------------------------------------------------------
C     ENTREES:
C        CHANOM : NOM ASTER DU CHAMP A LIRE
C        NOCHMD : NOM MED DU CHAMP DANS LE FICHIER
C        TYPECH : TYPE DE CHAMP AUX ELEMENTS : ELEM/ELGA/ELNO
C        TYPENT : TYPE D'ENTITE DU CHAMP
C                (MED_NOEUD,MED_MAILLE,MED_NOEUD_MAILLE)
C        NOMAMD : NOM MED DU MAILLAGE LIE AU CHAMP A LIRE
C                  SI ' ' : ON SUPPOSE QUE C'EST LE PREMIER MAILLAGE
C                           DU FICHIER
C        NOMAAS : NOM ASTER DU MAILLAGE
C        NOMMOD : NOM ASTER DU MODELE NECESSAIRE POUR LIGREL
C        NOMGD  : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
C        NBCMPV : NOMBRE DE COMPOSANTES VOULUES
C                 SI NUL, ON LIT LES COMPOSANTES A NOM IDENTIQUE
C        NCMPVA : LISTE DES COMPOSANTES VOULUES POUR ASTER
C        NCMPVM : LISTE DES COMPOSANTES VOULUES DANS MED
C        PROLZ  : VALEUR DE PROL_ZERO ('OUI' OU 'NAN')
C        IINST  : 1 SI LA DEMANDE EST FAITE SUR UN INSTANT, 0 SINON
C        NUMPT  : NUMERO DE PAS DE TEMPS EVENTUEL
C        NUMORD : NUMERO D'ORDRE EVENTUEL DU CHAMP
C        INST   : INSTANT EVENTUEL
C        CRIT   : CRITERE SUR LA RECHERCHE DU BON INSTANT
C        PREC   : PRECISION SUR LA RECHERCHE DU BON INSTANT
C        NROFIC : NUMERO NROFIC LOGIQUE DU FICHIER MED
C        LIGREL : NOM DU LIGREL
C     SORTIES:
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*19  CHANOM,LIGREL
      CHARACTER*(*) NCMPVA, NCMPVM
      CHARACTER*8   NOMMOD, NOMAAS, NOMGD
      CHARACTER*4   TYPECH
      CHARACTER*3   PROLZ
      CHARACTER*8   CRIT, PARAM
      CHARACTER*24  OPTION
      CHARACTER*(*) NOCHMD, NOMAMD
C
      INTEGER NROFIC, TYPENT
      INTEGER NBCMPV
      INTEGER IINST, NUMPT, NUMORD
      INTEGER NBPGMA(*),NBPGMM(*)
      INTEGER CODRET
C
      REAL*8 INST
      REAL*8 PREC
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRCEME' )
C
      INTEGER IAUX, NAUX, UNITE, NBCHAM, NBCMP, JCMP
      INTEGER NTYPEL,NPGMAX, TYCHA, JUNIT
      PARAMETER(NTYPEL=26,NPGMAX=27)
      INTEGER VALI(2),INDPG(NTYPEL,NPGMAX)
      INTEGER NBMAI, NBVATO,NBMA, IBID
      INTEGER JCESD,JCESV,JCESL,JCESC,JCESK
      INTEGER IFM, NIVINF, IDFIMD, NSEQCA
      INTEGER JNOCMP, NCMPRF, JCMPVA, NBCMPA, IRET, I, J,NNCP
      INTEGER EDLECT
      PARAMETER (EDLECT=0)

      CHARACTER*1  SAUX01
      CHARACTER*8  K8B,SAUX08
      CHARACTER*19 CHAMES
      CHARACTER*64 NOMCHA
      CHARACTER*200 NOFIMD
      CHARACTER*255 KFIC
C
      LOGICAL      TTT
C
      CALL JEMARQ ( )
C
      CALL INFNIV ( IFM, NIVINF )
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'DEBUT DE '//NOMPRO
      ENDIF
 1001 FORMAT(/,10('='),A,10('='),/)
C====
C 0. TRAITEMENT PARTICULIER POUR LES CHAMPS ELGA
C====
C
C 0.1 ==> VERIFICATION DES LOCALISATIONS DES PG
C         CREATION DU TABLEAU DEFINISSANT LE NBRE DE PG PAR MAIL
C         CREATION D'UN TABLEAU DE CORRESPONDANCE ENTRE LES PG MED/ASTER
C
      DO 5 I=1,NTYPEL
          DO 6 J=1,NPGMAX
            INDPG(I,J)=0
 6        CONTINUE
 5    CONTINUE
      IF(TYPECH(1:4).EQ.'ELGA')THEN
        CALL DISMOI('F','NB_MA_MAILLA',NOMAAS,'MAILLAGE',NBMA,K8B,IRET)
C        CALL WKVECT('&&LRCEME_NBPG_MAILLE','V V I',NBMA,JNBPGM)
        CALL LRMPGA(NROFIC,LIGREL,NOCHMD,NBMA,NBPGMA,NBPGMM,
     &              NTYPEL,NPGMAX,INDPG,IINST,NUMPT, NUMORD,
     &              INST,CRIT, PREC, OPTION, PARAM)
      ENDIF


C====
C 1. ALLOCATION D'UN CHAM_ELEM_S  (CHAMES)
C====
C
C 1.1. ==> REPERAGE DES CARACTERISTIQUES DE CETTE GRANDEUR
C
      CALL JENONU ( JEXNOM ( '&CATA.GD.NOMGD', NOMGD ) , IAUX )
      IF ( IAUX.EQ.0 ) THEN
        CALL U2MESS('F','MED_65')
      ENDIF
      CALL JEVEUO ( JEXNOM ( '&CATA.GD.NOMCMP', NOMGD ) ,
     &              'L', JNOCMP )
      CALL JELIRA ( JEXNOM ( '&CATA.GD.NOMCMP', NOMGD ) ,
     &              'LONMAX', NCMPRF, SAUX01 )
C
C 1.2. ==> ALLOCATION DU CHAM_ELEM_S
C
C               1234567890123456789
      CHAMES = '&&      .CES.MED   '
      CHAMES(3:8) = NOMPRO
      LIGREL = NOMMOD//'.MODELE'
C
      CALL JEEXIN ( NCMPVA, IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO ( NCMPVA, 'L', JCMPVA )
        CALL JELIRA ( NCMPVA, 'LONMAX',NBCMPA,K8B)
        IF (NOMGD(1:4).EQ.'VARI') THEN
          JNOCMP=JCMPVA
          NCMPRF=NBCMPA
        ELSEIF (NBCMPA.LE.NCMPRF) THEN
          DO 20 I=1,NBCMPA
             TTT=.FALSE.
             DO 30 J=1,NCMPRF
              IF (ZK8(JCMPVA+I-1).EQ.ZK8(JNOCMP+J-1)) THEN
                        TTT=.TRUE.
               ENDIF
 30          CONTINUE
             IF (.NOT.TTT) THEN
                CALL U2MESS('F','MED_66')
             ENDIF
 20       CONTINUE
        ELSE
          CALL U2MESS('F','MED_70')
        ENDIF

      ELSE
      
        CALL GETVIS ( ' ', 'UNITE', 0, 1, 1, UNITE, IAUX )
        CALL ULISOG(UNITE, KFIC, SAUX01)
        IF ( KFIC(1:1).EQ.' ' ) THEN
          CALL CODENT ( UNITE, 'G', SAUX08 )
          NOFIMD = 'fort.'//SAUX08
        ELSE
          NOFIMD = KFIC(1:200)
        ENDIF
        CALL MFOUVR ( IDFIMD, NOFIMD, EDLECT, IRET )
        CALL MFNCHA ( IDFIMD, NBCHAM, IRET )
        DO 777 I=1,NBCHAM
          CALL MFNCOM(IDFIMD,I,NBCMP,IRET)
          CALL WKVECT('&&LRCEME.NOMCMP_K16','V V K16',NBCMP,JCMP)
          CALL WKVECT('&&LRCEME.UNITCMP','V V K16',NBCMP,JUNIT)
          CALL MFCHAI(IDFIMD,I,NOMCHA,TYCHA,ZK16(JCMP),
     &                ZK16(JUNIT),NSEQCA,IRET)
          IF( NOMCHA.EQ.NOCHMD )THEN
            NCMPRF=NBCMP
            CALL WKVECT('&&LRCEME.NOMCMP_K8','V V K8',NBCMP,JNOCMP)
            DO 778 J=1,NBCMP
              ZK8(JNOCMP+J-1)=ZK16(JCMP+J-1)(1:8)
 778        CONTINUE
            CALL JEDETR('&&LRCEME.NOMCMP_K16')
            CALL JEDETR('&&LRCEME.UNITCMP')
            GOTO 780
          ENDIF
          CALL JEDETR('&&LRCEME.NOMCMP_K16')
          CALL JEDETR('&&LRCEME.UNITCMP')
 777    CONTINUE
        CALL MFFERM ( IDFIMD, IRET )
      ENDIF
C
 780  CONTINUE

      IF (TYPECH(1:4).EQ.'ELGA')THEN
        CALL CESCRE ( 'V', CHAMES, TYPECH, NOMAAS, NOMGD, NCMPRF,
     &               ZK8(JNOCMP),NBPGMA,-1,-NCMPRF)
      ELSE
        CALL CESCRE ( 'V', CHAMES, TYPECH, NOMAAS, NOMGD, NCMPRF,
     &               ZK8(JNOCMP),-1,-1,-NCMPRF)
      ENDIF
      
C
      CALL JEVEUO ( CHAMES//'.CESK', 'L', JCESK )
      CALL JEVEUO ( CHAMES//'.CESD', 'L', JCESD )
      CALL JEVEUO ( CHAMES//'.CESC', 'L', JCESC )
      CALL JEVEUO ( CHAMES//'.CESV', 'E', JCESV )
      CALL JEVEUO ( CHAMES//'.CESL', 'E', JCESL )
C
C NBMAI: NOMBRE DE MAILLES DU MAILLAGE
      NBMAI = ZI(JCESD-1+1)
      NBVATO = NBMAI
C
C====
C 3. LECTURE POUR CHAQUE TYPE DE SUPPORT
C====
C
      CALL LRCAME ( NROFIC, NOCHMD, NOMAMD, NOMAAS,
     &              NBVATO, TYPECH, TYPENT,
     &              NBMA, NBPGMA, NBPGMM, NTYPEL, NPGMAX, INDPG,
     &              NBCMPV, NCMPVA, NCMPVM,
     &              IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     &              NOMGD, NCMPRF, JNOCMP, JCESL, JCESV, JCESD,
     &              CODRET )
C
C====
C 4. TRANSFORMATION DU CHAM_ELEM_S EN CHAM_ELEM :
C====
C
C
      CALL CESCEL (CHAMES,LIGREL,OPTION,PARAM,PROLZ,NNCP,'V',CHANOM,
     &             'F',IBID)
      IF(NNCP.GT.0)THEN
         IAUX=0
         CALL JELIRA(CHAMES//'.CESL', 'LONMAX', NAUX, SAUX01)
         DO 40 I=1, NAUX
            IF(ZL(JCESL+I-1)) IAUX=IAUX+1
 40      CONTINUE
         VALI (1) = IAUX
         VALI (2) = NNCP
         CALL U2MESG('A', 'MED_83',0,' ',2,VALI,0,0.D0)
      ENDIF
C
      CALL DETRSD ( 'CHAM_ELEM_S', CHAMES )
C
C====
C 5. BILAN
C====
C
      IF ( CODRET.NE.0 ) THEN
         CALL U2MESK('A','MED_55',1,CHANOM)
      ENDIF

C      IF(TYPECH(1:4).EQ.'ELGA')THEN
C        CALL JEDETR('&&LRCEME_NBPG_MAILLE')
C      ENDIF
      CALL JEDETR('&&LRCEME.NOMCMP_K8')
      CALL JEDEMA ( )
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE '//NOMPRO
      ENDIF
C
      END
