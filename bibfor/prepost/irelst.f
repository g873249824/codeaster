      SUBROUTINE IRELST(NOFIMD,CHANOM,TYPECH,NOMAAS,NOMAMD,
     &                  NBIMPR,CAIMPI,CAIMPK,SDCARM)
      IMPLICIT NONE
      CHARACTER*8   NOMAAS,TYPECH,SDCARM
      CHARACTER*(*) NOFIMD
      CHARACTER*19  CHANOM
      CHARACTER*64  NOMAMD
      CHARACTER*80  CAIMPK(3,NBIMPR)
      INTEGER       NBIMPR,CAIMPI(10,NBIMPR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/10/2012   AUTEUR SELLENET N.SELLENET 
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
C ----------------------------------------------------------------------
C  IMPR_RESU - IMPRESSION DES ELEMENTS DE STRUCTURE AU FORMAT MED
C  -    -                     --          --
C ----------------------------------------------------------------------
C
C IN  :
C   NOFIMD  K*   NOM DU FICHIER MED
C   CHANOM  K19  NOM DU CHAMP A IMPRIMER
C   TYPECH  K8   TYPE DU CHAMP
C   NOMAAS  K8   NOM DU MAILLAGE ASTER A COMPLETER DANS LE FICHIER MED
C   NOMAMD  K*   NOM DU MAILLAGE MED
C   NBIMPR  I    NOMBRE D'IMPRESSIONS
C   CAIMPI  I*   ENTIERS POUR CHAQUE IMPRESSION
C   CAIMPK  K80* CARACTERES POUR CHAQUE IMPRESSION
C   SDCARM  K*   SD_CARA_ELEM EN CHAM_ELEM_S
C
      INCLUDE 'jeveux.h'
C
      INTEGER       INIMPR,NBCOUC,NBSECT,NUMMAI,LGMAX,NTYPEF,CODRET
      INTEGER       NBNOSO,NBNOTO,NBREPG,NDIM,NBFAMX,NBELR
      INTEGER       EDLEAJ,IDFIMD,EDCART,EDFUIN,NTYMAX,NBTYP,NNOMAX
      INTEGER       EDMAIL,EDNODA,EDTYRE,MEDCEL,NBMSSU,NBATTC,PRESPR
      PARAMETER    (EDLEAJ = 1)
      PARAMETER    (NBFAMX = 20)
      PARAMETER    (LGMAX  = 1000)
      PARAMETER    (EDCART = 0)
      PARAMETER    (EDFUIN = 0)
      PARAMETER    (NTYMAX = 66)
      PARAMETER    (NNOMAX = 27)
      PARAMETER    (EDMAIL = 0)
      PARAMETER    (EDNODA = 0)
      PARAMETER    (EDTYRE = 6)
      INTEGER       NNOTYP(NTYMAX),TYPGEO(NTYMAX),RENUMD(NTYMAX)
      INTEGER       MODNUM(NTYMAX),NUANOM(NTYMAX,NNOMAX),INO,INIMP2
      INTEGER       NUMNOA(NTYMAX,NNOMAX),TYMAAS,TYMAMD,CONNEX(9)
      INTEGER       IMASUP,JMASUP,NBMASU,NBMSMX,NVTYMD,EDCAR2,NBATTV
      INTEGER       DIMEST,NBNOSU,JNVTYM,TYGEMS
C
      CHARACTER*8   LIELRF(NBFAMX),SAUX08,NOMTYP(NTYMAX)
      CHARACTER*16  NOMTEF,NOMFPG,NOCOOR(3),UNCOOR(3)
      CHARACTER*16  NOCOO2(3),UNCOO2(3)
      CHARACTER*64  NOMASU,ATEPAI,ATANGV,ATRMAX,ATRMIN,NOMAES
      CHARACTER*200 DESMED
      PARAMETER    (ATEPAI = 'EPAISSEUR')
      PARAMETER    (ATANGV = 'ANGLE DE VRILLE')
      PARAMETER    (ATRMIN = 'RAYON MIN')
      PARAMETER    (ATRMAX = 'RAYON MAX')
C
      REAL*8        REFCOO(3*LGMAX),GSCOO(3*LGMAX),WG(LGMAX)
C
      LOGICAL       NEWEST
C
      DATA NOCOOR  /'X               ',
     &              'Y               ',
     &              'Z               '/
      DATA UNCOOR  /'INCONNU         ',
     &              'INCONNU         ',
     &              'INCONNU         '/
C
      CALL MFOUVR(IDFIMD,NOFIMD,EDLEAJ,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFOUVR  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C     -- RELECTURE DES ELEMENTS DE STRUCTURES DEJA PRESENTS
      NBMASU = 0
      CALL MFESNB(IDFIMD,NBMASU,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFMSNB'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
      NBMSMX = NBMASU+10
      CALL WKVECT('&&IRELST.MAIL_SUPP','V V K80',NBMSMX,JMASUP)
      CALL WKVECT('&&IRELST.NV_TYPE_MED','V V I',NBMSMX,JNVTYM)
      IF ( NBMASU.NE.0 ) THEN
        DO 40, IMASUP = 1, NBMASU
          CALL MFMSLE(IDFIMD,IMASUP,NOMASU,NDIM,DESMED,
     &                EDCAR2,NOCOO2,UNCOO2,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFMSLE'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
          ZK80(JMASUP+IMASUP-1) = NOMASU
C
          CALL MFESLR(IDFIMD,IMASUP,NOMAES,NVTYMD,DIMEST,
     &                NOMASU,MEDCEL,NBNOSU,NBMSSU,TYGEMS,
     &                NBATTC,PRESPR,NBATTV,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESLR'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
          ZI(JNVTYM+IMASUP-1) = NVTYMD
  40    CONTINUE
      ENDIF
C
      DESMED = ' '
C
      CALL LRMTYP(NBTYP,NOMTYP,NNOTYP,TYPGEO,RENUMD,
     &            MODNUM,NUANOM,NUMNOA)
C
C     -- CREATION DES ELEMENTS DE STRUCTURES DANS LE FICHIER MED
C        UN ELEMENT DE STRUCTURE EST DEFINIT PAR UNE PAIRE :
C         TYPE ELEMENT (COQUE, TUYAU, ...) + TYPE MAILLE
      NEWEST = .FALSE.
      DO 10, INIMPR = 1,NBIMPR
        NTYPEF = CAIMPI(1,INIMPR)
        NBCOUC = CAIMPI(4,INIMPR)
        NBSECT = CAIMPI(5,INIMPR)
        NUMMAI = CAIMPI(6,INIMPR)
        TYMAAS = CAIMPI(8,INIMPR)
        TYMAMD = CAIMPI(9,INIMPR)
C
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NTYPEF),NOMTEF)
C
        CALL ELREF2(NOMTEF,NBFAMX,LIELRF,NBELR)
        CALL ASSERT(NBELR.GT.0)
C
        CALL UTEREF(CHANOM,TYPECH,NTYPEF,NOMTEF,NOMFPG,
     &              NBNOSO,NBNOTO,NBREPG,NDIM,  REFCOO,
     &              GSCOO,WG,CODRET)
C
        NOMASU = ' '
        IF ( NBCOUC.NE.0.AND.NBSECT.EQ.0 ) THEN
C         -- CAS D'UNE COQUE
          NOMASU(1:8) = 'COQUE   '
        ELSEIF ( NBCOUC.NE.0.AND.NBSECT.NE.0 ) THEN
C         -- CAS D'UN TUYAU
          NOMASU(1:8) = 'TUYAU   '
        ELSEIF ( NUMMAI.NE.0 ) THEN
C         -- CAS D'UNE PMF
          NOMASU(1:8) = 'PMF     '
        ELSEIF ( NBCOUC.EQ.0.AND.NBSECT.EQ.0.AND.NUMMAI.EQ.0 ) THEN
          GOTO 50
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        NOMASU(9:12) = NOMFPG(1:3)
        DO 70, INIMP2 = 1,NBIMPR
          IF ( CAIMPK(3,INIMP2).EQ.NOMASU ) THEN
            CAIMPK(3,INIMPR) = NOMASU
            CAIMPI(9,INIMPR) = CAIMPI(9,INIMP2)
            GOTO 50
          ENDIF
  70    CONTINUE
        DO 60, IMASUP = 1, NBMASU
          IF ( ZK80(JMASUP+IMASUP-1).EQ.NOMASU ) THEN
            CAIMPK(3,INIMPR) = ZK80(JMASUP+IMASUP-1)
            CAIMPI(9,INIMPR) = ZI(JNVTYM+IMASUP-1)
            GOTO 50
          ENDIF
  60    CONTINUE
C
C       -- DEFINITION DU MAILLAGE SUPPORT MED
        CALL MFMSCR(IDFIMD,NOMASU,NDIM,DESMED,EDCART,
     &              NOCOOR,UNCOOR,CODRET)
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFMSCR'
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
C
C       -- DEFINITION DES NOEUDS DU MAILLAGE SUPPORT MED
        CALL MFCOOE(IDFIMD,NOMASU,REFCOO,EDFUIN,NBNOTO,
     &              CODRET)
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFCOOE'
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
C
C       -- CREATION DE LA CONNECTIVITE
        CALL ASSERT(NBNOTO.LE.9)
        IF ( MODNUM(TYMAAS).EQ.0 ) THEN
          DO 20, INO = 1, NBNOTO
            CONNEX(INO) = INO
  20      CONTINUE
        ELSE
          DO 30, INO = 1, NBNOTO
            CONNEX(INO) = NUANOM(TYMAAS,INO)
  30      CONTINUE
        ENDIF
C
C       -- DEFINITION DE LA MAILLE DU MAILLAGE SUPPORT
        CALL MFCONE(IDFIMD,NOMASU,CONNEX,NBNOTO,EDFUIN,
     &              1,     EDMAIL,TYMAMD,EDNODA,CODRET)
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFCONE'
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
C
C       -- SAUVEGARDE DE L'ELEMENT DE STRUCTURE
        NBMASU = NBMASU+1
        IF ( NBMASU.GT.NBMSMX ) THEN
          NBMSMX = NBMSMX+10
          CALL JUVECA('&&IRELST.MAIL_SUPP',NBMSMX)
          CALL JEVEUO('&&IRELST.MAIL_SUPP','E',JMASUP)
        ENDIF
        ZK80(JMASUP+NBMASU-1) = NOMASU
C
        NVTYMD = -9999
        CALL MFESCR(IDFIMD,NOMASU,NDIM,NOMASU,EDMAIL,
     &              TYMAMD,NVTYMD,CODRET)
        CALL ASSERT(NVTYMD.NE.-9999)
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFESCR'
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
C
        IF ( NOMASU(1:5).EQ.'COQUE' ) THEN
C         -- ATTRIBUT VARIABLE EPAISSEUR
          CALL MFESAV(IDFIMD,NOMASU,ATEPAI,EDTYRE,1,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESAV'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
        ELSEIF ( NOMASU(1:5).EQ.'TUYAU' ) THEN
C         -- ATTRIBUT VARIABLE RAYON MIN
          CALL MFESAV(IDFIMD,NOMASU,ATRMIN,EDTYRE,1,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESAV'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
C         -- ATTRIBUT VARIABLE RAYON MAX
          CALL MFESAV(IDFIMD,NOMASU,ATRMAX,EDTYRE,1,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESAV'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
C         -- ATTRIBUT VARIABLE ANGLE DE VRILLE
          CALL MFESAV(IDFIMD,NOMASU,ATANGV,EDTYRE,1,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESAV'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
        ELSEIF ( NOMASU(1:3).EQ.'PMF' ) THEN
C         -- ATTRIBUT VARIABLE ANGLE DE VRILLE
          CALL MFESAV(IDFIMD,NOMASU,ATANGV,EDTYRE,1,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFESAV'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
C       -- MODIFICATION DU TYPE MED A IMPRIMER
        CAIMPI(9,INIMPR) = NVTYMD
        CAIMPK(3,INIMPR) = NOMASU
        NEWEST = .TRUE.
C
  50    CONTINUE
C
  10  CONTINUE
C
C     -- AJOUT DES MAILLES "STRUCTURES" AU MAILLAGE
      IF ( NEWEST ) THEN
        CALL IRMAES(IDFIMD,NOMAAS,NOMAMD,NBIMPR,CAIMPI,
     &              MODNUM,NUANOM,NOMTYP,NNOTYP,SDCARM)
      ENDIF
C
      CALL MFFERM(IDFIMD,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFFERM  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
      CALL JEDETR('&&IRELST.MAIL_SUPP')
      CALL JEDETR('&&IRELST.NV_TYPE_MED')
C
      END
