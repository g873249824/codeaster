      SUBROUTINE LRMPGA(NROFIC,LIGREL,NOCHMD,NBMA,PGMAIL,PGMMIL,
     &                  NTYPEL,NPGMAX,INDPG,NUMPT, NUMORD,
     &                  OPTION, PARAM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/03/2012   AUTEUR SELLENET N.SELLENET 
C RESPONSABLE SELLENET N.SELLENET
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
C-----------------------------------------------------------------------
C     LECTURE FICHIER MED - LOCALISATION POINTS DE GAUSS
C     -    -            -                  -         --
C-----------------------------------------------------------------------
C     IN :
C       NROFIC : UNITE LOGIQUE DU FICHIER MED
C       LIGREL : NOM DU LIGREL
C       NOCHMD : NOM DU CHAMP MED
C       NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C       NTYPEL : NOMBRE TOTAL DE TYPES DE MAILLE (=27)
C       NPGMAX : NOMBRE DE PG MAX (=27)
C       NUMPT  : NUMERO DE PAS DE TEMPS EVENTUEL
C       NUMORD : NUMERO D'ORDRE EVENTUEL DU CHAMP
C
C     OUT:
C       PGMAIL : NOMBRE DE POINTS DE GAUSS PAR MAILLE (ASTER)
C       PGMMIL : NOMBRE DE POINTS DE GAUSS PAR MAILLE (MED)
C     IN/OUT:
C       INDPG  : TABLEAU D'INDICES DETERMINANT L'ORDRE DES POINTS
C                DE GAUSS DANS UN ELEMENT DE REFERENCE :
C                INDPG(K,I_MED)=I_ASTER :
C                   - K = NUM DU TYPE DE MAILLE
C                   - I_ASTER = NUMERO LOCAL DU PG DANS L'ELEMENT
C                               DE REFERENCE ASTER
C                   - I_MED  = NUMERO LOCAL DU PG DANS L'ELEMENT
C                               DE REFERENCE MED
C
C-----------------------------------------------------------------------

      IMPLICIT NONE
C
      INTEGER NROFIC,NBMA,NTYPEL,NPGMAX,NUMPT, NUMORD
      INTEGER PGMAIL(NBMA),PGMMIL(NBMA),INDPG(NTYPEL,NPGMAX)
      CHARACTER*8 PARAM
      CHARACTER*19 LIGREL
      CHARACTER*24 OPTION
      CHARACTER*(*)  NOCHMD
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
      CHARACTER*32 JEXNUM,JEXNOM
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRMPGA' )
C
      INTEGER NTYGEO
      PARAMETER (NTYGEO=14)
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
      INTEGER EDMAIL
      PARAMETER (EDMAIL=0)
      INTEGER EDCOMP
      PARAMETER (EDCOMP=2)

      INTEGER MODAT2, IFM, NIVINF, NCMP, JCOMP, JUNIT
      INTEGER IDFIMD,CODRET,NLOC,IRET,IGREL
      INTEGER J,NBGREL
      INTEGER NUMTE,TYPELE,I,ITYG,NGAULU,NPDT
      INTEGER TYGEO(NTYGEO),NBPG,NBPGM
      INTEGER JTMFPG,NUFGPG
      INTEGER DIME,JTYMED
      INTEGER JNGALU,NBTYEL,NBMAG,IGR,IMA
      INTEGER NUTYMA,IPG,IPGM,JPERM
      INTEGER NPR,N
      INTEGER IOPT, IMOD, JMOD, IGRD, IADGD, NEC
      REAL*8  RBID

      CHARACTER*1 SAUX01
      CHARACTER*3 TYELE(NTYGEO)
      CHARACTER*8 SAUX08,K8B,FAPG,ELREF
      CHARACTER*16 NOMTE,NOFGPG
      CHARACTER*24 LIEL
      CHARACTER*64 NOMPRF,NOMLOC,NOMAM2
      CHARACTER*200 NOFIMD
      CHARACTER*255 KFIC

      DATA TYGEO /    102,        103,         203,         206,
     &                204,        208,         304,         310,
     &                308,        320,         306,         315,
     &                305,        313/
      DATA TYELE /   'SE2',      'SE3',        'TR3',       'TR6',
     &               'QU4',      'QU8',        'TE4',       'T10',
     &               'HE8',      'H20',        'PE6',       'P15',
     &               'PY5',      'P13'/

C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL INFNIV ( IFM, NIVINF )
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'DEBUT DE '//NOMPRO
      ENDIF
C
C  ======================================
C  == 1 : EXPLOITATION DU FICHIER MED  ==
C  ======================================
C
C     INITIALISATIONS
      DO 5 I=1,NBMA
        PGMAIL(I)=0
 5    CONTINUE

C     NOM DU FICHIER MED
      CALL ULISOG(NROFIC, KFIC, SAUX01)
      IF ( KFIC(1:1).EQ.' ' ) THEN
        CALL CODENT ( NROFIC, 'G', SAUX08 )
        NOFIMD = 'fort.'//SAUX08
      ELSE
        NOFIMD = KFIC(1:200)
      ENDIF

C     OUVERTURE DU FICHIER MED
      CALL MFOUVR (IDFIMD, NOFIMD, EDLECT, CODRET)

C      A PARTIR DU NOM DU CHAMP MED ET DE L'INDICE DU PAS DE TEMPS,
C      ON RECUPERE POUR CHAQUE TYPE DE MAILLE PRESENT:
C      - LE NOMBRE DE POINTS DE GAUSS : ZI(JNGALU)
C      - LE NOM DU TYPE GEOMETRIQUE   : ZK8(JTYMED)
C      REMARQUE: L'INDICE DU PAS DE TEMPS EST OBTENU EN PARCOURANT
C      LA LISTE DES PAS DE TEMPS (BOUCLE 39)
      CALL WKVECT('&&LRMPGA_TYPGEO_NBPG_MED','V V I',NTYGEO,JNGALU)
      CALL WKVECT('&&LRMPGA_TYPGEO_TYPG_MED','V V K8',NTYGEO,JTYMED)
      NBTYEL=0
      IF ( NIVINF.GT.1 ) THEN
        WRITE(IFM, 2001)
      ENDIF
C
      CALL MFNCO2(IDFIMD,NOCHMD,NCMP,IRET)
      CALL WKVECT('&&LRMPGA.CNAME','V V K16',NCMP,JCOMP)
      CALL WKVECT('&&LRMPGA.CUNIT','V V K16',NCMP,JUNIT)
      CALL MFNPDT(IDFIMD,NOCHMD,NOMAM2,NPDT,
     &            ZK16(JUNIT),ZK16(JCOMP),IRET)
      IF(NPDT.GT.0)THEN
C
        DO 38 ITYG=1,NTYGEO
          CALL MFNNOP(IDFIMD,NOCHMD,EDMAIL,TYGEO(ITYG),NOMAM2,
     &                NUMPT,NUMORD,1,NOMPRF,EDCOMP,NPR,
     &                NOMLOC,NGAULU,N,IRET)
          CALL ASSERT(IRET.EQ.0)
          IF ( N.GT.0 ) THEN
            NBTYEL=NBTYEL+1
            ZK8(JTYMED+NBTYEL-1)=TYELE(ITYG)
            ZI(JNGALU+NBTYEL-1)=NGAULU
          ENDIF
C
          IF ( NIVINF.GT.1 ) THEN
            WRITE (IFM,2002) TYGEO(ITYG),TYELE(ITYG),NGAULU
          ENDIF
C
 38     CONTINUE
      ENDIF
C
      CALL JEDETR('&&LRMPGA.CNAME')
      CALL JEDETR('&&LRMPGA.CUNIT')
C
      IF(NBTYEL.EQ.0)THEN
        CALL U2MESG ('F', 'MED_77', 1, NOCHMD, 1, NROFIC, 0, RBID)
      ENDIF


C     LECTURE DU NOMBRE DE LOCALISATIONS PRESENT DANS LE FICHIER MED
C     NOMBRE DE LOCALISATION(S) : NLOC
      NLOC=0
      CALL MFNGAU(IDFIMD, NLOC, IRET)
C
      CALL DISMOI('F','DIM_GEOM',LIGREL(1:8),'MODELE',DIME,K8B,IRET)
      IF (.NOT.(DIME.EQ.2.OR.DIME.EQ.3))
     &       CALL U2MESS('F','MODELISA2_6')
      LIEL=LIGREL//'.LIEL'
      CALL JELIRA(LIEL,'NMAXOC',NBGREL,K8B)
C
C  =========================================
C  == 2 : EXPLOITATION DES DONNEES ASTER  ==
C  =========================================

      CALL JENONU(JEXNOM('&CATA.OP.NOMOPT', OPTION), IOPT)

C     ON PARCOURT LES GROUPES D'ELEMENTS PRESENTS DANS LE MODELE
      DO 30 IGREL=1,NBGREL

C       NOM DU TYPE D'ELEMENT
        NUMTE=TYPELE(LIGREL,IGREL)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUMTE),NOMTE)

C       NOMBRE D'ELEMENTS DU GREL : NBMAG-1
        CALL JEVEUO(JEXNUM(LIEL,IGREL),'L',IGR)
        CALL JELIRA(JEXNUM(LIEL,IGREL),'LONMAX',NBMAG,K8B)

C       MODE LOCAL ASSOCIE AU PARAMETRE PARAM DE L'OPTION OPTION
        IMOD = MODAT2(IOPT, NUMTE, PARAM)
        IF(IMOD.EQ.0)THEN
           NBPG = 0
        ELSE
          CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC', IMOD), 'L', JMOD)
C         CHAMP ELGA
          CALL ASSERT(ZI(JMOD-1+1).EQ.3)

          IGRD = ZI(JMOD-1+2)
          CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',IGRD),'L',IADGD)
          NEC = ZI(IADGD-1+3)
C         NUMERO ET NOM DE LA FAMILLE GLOBALE DE PTS GAUSS
          NUFGPG = ZI(JMOD-1+4+NEC+1)
          CALL JENUNO(JEXNUM('&CATA.TM.NOFPG',NUFGPG),NOFGPG)
          ELREF= NOFGPG(1:8)
          FAPG = NOFGPG(9:16)
C         NOMBRE DE PG : NBPG
          CALL JEVEUO('&CATA.TM.TMFPG', 'L', JTMFPG)
          NBPG=ZI(JTMFPG+NUFGPG-1)
C
          IF ( NIVINF.GT.1 ) THEN
            WRITE(IFM,2003) NOMTE, FAPG
          ENDIF

C         ON PARCOURT LES ELEMENTS DE REFERENCE MED
          DO 800 J=1,NBTYEL

C         SI LES ELEMENTS DE REFERENCE ASTER/MED CORRESPONDENT :
            IF(ZK8(JTYMED+J-1)(1:3).EQ.ELREF) THEN
C
C             VERIFICATION DU NOMBRE DE PG ASTER/MED
C             COMPARAISON DES COORDONNEES DES PG ASTER/MED
              CALL WKVECT('&&LRMPGA_PERMUT','V V I',NBPG,JPERM)
              CALL LRVCPG(IDFIMD,NBPG,ZI(JNGALU+J-1),
     &               ELREF,ZK8(JTYMED+J-1),FAPG,NLOC,ZI(JPERM),
     &               NUTYMA,CODRET)
              NBPGM = ZI(JNGALU+J-1)

C             SI LE NBRE PT GAUSS INCORRECT ET PAS DE <F>,
C             NBPG=0 : RIEN A ECRIRE DANS LRCMVE
              IF ( CODRET.EQ.4 ) THEN
                NBPG = 0
C             SI PERMUTATIONS AU NIVEAU DES PG ASTER/MED :
              ELSE IF(CODRET.EQ.1)THEN
C  ===>         REMPLISSAGE DU TABLEAU INDPG: CAS OU L'ON A
C               UNE PERMUTATION DANS LES PG MED/ASTER
                DO 220 IPGM=1,NBPG
                  INDPG(NUTYMA,IPGM)=ZI(JPERM+IPGM-1)
 220            CONTINUE
              ELSE
C  ===>         SINON REMPLISSAGE DU TABLEAU INDPG: CAS OU L'ON A :
C              - ABSENCE DE LOCALISATION
C              - L UN DES PG MED N A PAS ETE IDENTIFIE A UN PG ASTER
C              - LES PG ASTER/MED CORRESPONDENT
                DO 145 IPG=1,NBPG
                  INDPG(NUTYMA,IPG)=IPG
 145            CONTINUE
              ENDIF
C
C             DESTRUCTION DU TABLEAU TEMPORAIRE
              CALL JEDETR('&&LRMPGA_PERMUT')
C
            ENDIF
C
 800      CONTINUE

C      REMPLISSAGE DU TABLEAU PGMAIL : PGMAIL(NUM_MAILLE_ASTER)=NBRE_PG
          IF ( ZI(IGR).GT.0 ) THEN
            DO 301 IMA=1,NBMAG-1
              PGMAIL(ZI(IGR+IMA-1))=NBPG
              PGMMIL(ZI(IGR+IMA-1))=NBPGM
301         CONTINUE
          ENDIF
C
        ENDIF
C
 30   CONTINUE

C     DESTRUCTION DES TABLEAUX TEMPORAIRES
      CALL JEDETR('&&LRMPGA_TYPGEO_NBPG_MED')
      CALL JEDETR('&&LRMPGA_TYPGEO_TYPG_MED')
C
      CALL JEDEMA()
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE '//NOMPRO
      ENDIF
C
 1001 FORMAT(/,10('='),A,10('='),/)
 2001 FORMAT('  MAILLE MED     ELREFE ASTER ASSOCIE ',
     &       '  NBRE DE PTS DE GAUSS MED')
 2002 FORMAT(4X, I6, 16X, A6, 16X, I4)
 2003 FORMAT(  '  NOM DE L''ELEMENT FINI : ',A8,
     &       /,'  FAMILLE DE PT GAUSS    : ',A8)
      END
