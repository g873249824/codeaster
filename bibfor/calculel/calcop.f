      SUBROUTINE CALCOP(OPTION,LISOPT,RESUIN,RESUOU,LISORD,
     &                  NBORDR,LISCHA,NCHARG,CHTYPE,TYPESD,
     &                  NBCHRE,IOCCUR,SUROPT,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBORDR,NCHARG,CODRET,NBCHRE,IOCCUR
      CHARACTER*4  CHTYPE
      CHARACTER*8  RESUIN,RESUOU
      CHARACTER*16 OPTION,TYPESD
      CHARACTER*19 LISCHA,LISORD
      CHARACTER*24 SUROPT
      CHARACTER*(*)LISOPT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/12/2011   AUTEUR DELMAS J.DELMAS 
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
C ----------------------------------------------------------------------
C  CALC_CHAMP - CALCUL D'UNE OPTION
C               ----         --
C ----------------------------------------------------------------------
C
C  ROUTINE DE BASE DE CALC_CHAMP
C
C IN  :
C   OPTION  K16  NOM DE L'OPTION A CALCULER
C   RESUIN  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT IN
C   RESUOU  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT OUT
C   NBORDR  I    NOMBRE DE NUMEROS D'ORDRE
C   LISORD  K19  LISTE DE NUMEROS D'ORDRE
C   LISCHA  K19  NOM DE L'OBJET JEVEUX CONTENANT LES CHARGES
C   NCHARG  I    NOMBRE DE CHARGES
C   CHTYPE  K4   TYPE DES CHARGES
C   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
C   NBCHRE  I    NOMBRE DE CHARGES REPARTIES (POUTRES)
C   IOCCUR  I    NUMERO D'OCCURENCE OU SE TROUVE LE CHARGE REPARTIE
C   SUROPT  K24
C
C OUT :
C   CODRET  I    CODE RETOUR (0 SI OK, 1 SINON)
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      LOGICAL      EXITIM,EXIPOU,OPTDEM

      INTEGER      NOPOUT,JLISOP,IOP,IBID,NBORD2,LRES,IER,N0,N1,POSOPT
      INTEGER      NBTROU,MINORD,MAXORD,JLINST,IORDR,NBORDL
      INTEGER      NUMORD,IEXCIT,IRET,NPASS,NBMA,CODRE2,JLIOPG,NBOPT
      INTEGER      INDK16

      REAL*8       R8B

      COMPLEX*16   C16B

      CHARACTER*1  BASOPT
      CHARACTER*8  MODELE,CARAEL,K8B
      CHARACTER*8  NOMAIL,NOBASE,POUX
      CHARACTER*16 OPTIO2,TYPMCL(4),MOTCLE(4)
      CHARACTER*19 EXCIT
      CHARACTER*24 CHAOUT,LIGREL,MATECO,LIGRES
      CHARACTER*24 NOLIOP,LISINS,MESMAI
      CHARACTER*32 JEXNOM
      INTEGER      IARG
C
      LOGICAL      LIGMOD
C
      CALL JEMARQ()
      CODRET = 1
      NPASS = 0
      NOBASE = '&&CALCOP'

      IF ( (OPTION.EQ.'ETOT_ELEM').OR.
     &     (OPTION.EQ.'ETOT_ELGA').OR.
     &     (OPTION.EQ.'ETOT_ELNO') ) GOTO 9999

      IF ( (OPTION.EQ.'SIEQ_ELNO') ) GOTO 9999

C     ON CONSERVE CES OPTIONS POUR PERMETTRE LE CALCUL DANS STANLEY
      IF ( (OPTION.EQ.'ERTH_ELEM').OR.
     &     (OPTION.EQ.'ERTH_ELNO') ) GOTO 9999

      IF ( (OPTION.EQ.'ERME_ELEM').OR.
     &     (OPTION.EQ.'ERME_ELNO').OR.
     &     (OPTION.EQ.'QIRE_ELEM').OR.
     &     (OPTION.EQ.'QIRE_ELNO') ) GOTO 9999

      IF ( (OPTION.EQ.'SIZ1_NOEU').OR.
     &     (OPTION.EQ.'SIZ2_NOEU').OR.
     &     (OPTION.EQ.'ERZ1_ELEM').OR.
     &     (OPTION.EQ.'ERZ2_ELEM').OR.
     &     (OPTION.EQ.'QIZ1_ELEM').OR.
     &     (OPTION.EQ.'QIZ2_ELEM') ) GOTO 9999

      IF ( (OPTION.EQ.'SING_ELEM').OR.
     &     (OPTION.EQ.'SING_ELNO') ) GOTO 9999
C
      CALL CCLIOP(OPTION,NOBASE,NOLIOP,NOPOUT)
      IF ( NOPOUT.EQ.0 ) GOTO 9999

      CALL JEVEUO(NOLIOP,'L',JLISOP)
C
      JLIOPG = 0
      NBOPT = 0
      IF ( LISOPT.NE.' ' ) THEN
        CALL JEVEUO(LISOPT,'L',JLIOPG)
        CALL JELIRA(LISOPT,'LONMAX',NBOPT,K8B)
      ENDIF
C
      EXITIM = .FALSE.
      CALL JENONU(JEXNOM(RESUIN//'           .NOVA','INST'),IRET)
      IF (IRET.NE.0) EXITIM = .TRUE.

      CALL RSORAC(RESUIN,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &            NBORD2,1,NBTROU)
      IF ( NBTROU.LT.0 ) NBTROU = -NBTROU
      CALL WKVECT('&&CALCOP.NB_ORDRE','V V I',NBTROU,LRES)
      CALL RSORAC(RESUIN,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,
     &            K8B,ZI(LRES),NBTROU,NBORD2)
C     ON EN EXTRAIT LE MIN ET MAX DES NUMEROS D'ORDRE DE LA SD_RESUTLAT
      MINORD = ZI(LRES)
      MAXORD = ZI(LRES+NBORD2-1)

      CALL RSLESD(RESUIN,MINORD,MODELE,MATECO(1:8),CARAEL,EXCIT,IEXCIT)
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMAIL,IRET)

      CALL EXLIMA(' ',0,'V',MODELE,LIGREL)
      POUX = 'NON'
      CALL DISMOI('F','EXI_POUX',LIGREL,'LIGREL',IBID,POUX,IER)
      EXIPOU = .FALSE.
      IF (POUX.EQ.'OUI') EXIPOU = .TRUE.
C
      IF ( OPTION(6:9).EQ.'NOEU' ) THEN
        NBMA = 0
        CALL GETVTX(' ','MAILLE',1,IARG,0,K8B,N0)
        CALL GETVTX(' ','GROUP_MA',1,IARG,0,K8B,N1)
        MESMAI = '&&OP0106.MES_MAILLES'
        IF ( N0+N1.NE.0 ) THEN
          MOTCLE(1) = 'GROUP_MA'
          MOTCLE(2) = 'MAILLE'
          TYPMCL(1) = 'GROUP_MA'
          TYPMCL(2) = 'MAILLE'
          CALL RELIEM(' ',NOMAIL,'NU_MAILLE',' ',1,2,MOTCLE,TYPMCL,
     &                MESMAI,NBMA)
        ENDIF
      ENDIF
C
C     COMME ON PARCOURT LES OPTIONS DANS L'ORDRE INVERSE DES DEPENDANCES
C     ON SAIT QUE LES LISTES D'INSTANT SERONT CORRECTEMENT CREES
      DO 10 IOP = 1,NOPOUT
        OPTIO2 = ZK24(JLISOP+IOP-1)
C
        IF ( OPTION.EQ.OPTIO2 ) THEN
          OPTDEM = .TRUE.
        ELSE
          OPTDEM = .FALSE.
        ENDIF
C
C       SI L'OPTION CALCULEE ICI EST DEMANDEE PAR
C       L'UTILISATUER, ON LA MET SUR LA BASE GLOBALE
        BASOPT = 'G'
        IF ( OPTIO2.NE.OPTION ) BASOPT = 'V'
C
        IF ( NBOPT.NE.0 ) THEN
          POSOPT = INDK16(ZK16(JLIOPG),OPTIO2,1,NBOPT)
          IF ( POSOPT.NE.0 ) BASOPT = 'G'
        ENDIF
C
        CALL CCLORD(IOP,NBORDR,LISORD,NOBASE,OPTDEM,
     &              MINORD,MAXORD,RESUIN,RESUOU,LISINS)
C
        CALL JEVEUO(LISINS,'L',JLINST)
        NBORDL = ZI(JLINST)
        CODRE2 = 0
        LIGREL = ' '
        LIGRES = ' '
        DO 20 IORDR = 1,NBORDL
          NUMORD = ZI(JLINST+IORDR+2)

          IF ( OPTIO2(6:9).EQ.'NOEU' ) THEN
C
            CALL MEDOM2(MODELE,MATECO,CARAEL,LISCHA,NCHARG,CHTYPE,
     &                  RESUIN,NUMORD,NBORDR,'V',NPASS,LIGREL)
C
            IF ( LIGRES.NE.LIGREL ) LIGMOD = .TRUE.
C
            CALL CCCHNO(OPTIO2,NUMORD,RESUIN,RESUOU,CHAOUT,
     &                  MESMAI,NOMAIL,MODELE,CARAEL,BASOPT,
     &                  LIGREL,LIGMOD,CODRE2)
C
          ELSEIF ( OPTIO2(6:7).EQ.'EL' ) THEN
C
            CALL MEDOM2(MODELE,MATECO,CARAEL,LISCHA,NCHARG,CHTYPE,
     &                  RESUIN,NUMORD,NBORDR,BASOPT,NPASS,LIGREL)
C
            CALL CCCHEL(OPTIO2,MODELE,RESUIN,RESUOU,ZI(JLINST+3),
     &                  IORDR, MATECO,CARAEL,TYPESD,LIGREL,
     &                  EXIPOU,EXITIM,LISCHA,NBCHRE,IOCCUR,
     &                  SUROPT,BASOPT,CHAOUT)
            IF ( CHAOUT.EQ.' ' ) GOTO 10
C
          ENDIF
          CALL EXISD('CHAMP_GD',CHAOUT,IRET)
          IF ( OPTIO2.EQ.OPTION ) THEN
            IF (IRET.EQ.0) THEN
              CODRET = 1
              CALL U2MESK('A','CALCULEL2_89',1,OPTIO2)
            ELSE
              CALL RSNOCH(RESUOU,OPTIO2,NUMORD,' ')
            ENDIF
          ENDIF
C
          IF (POUX.EQ.'OUI') CALL JEDETC('V','&&MECHPO',1)
          CALL DETRSD('CHAM_ELEM_S',CHAOUT)
C
          LIGRES = LIGREL
   20   CONTINUE
C
   10 CONTINUE

      CODRET = 0

      CALL JEDETR('&&CALCOP.NB_ORDRE')
      CALL CCNETT(NOBASE,NOPOUT)
      IF ( OPTION(6:9).EQ.'NOEU'.AND.NBMA.NE.0 ) CALL JEDETR(MESMAI)

 9999 CONTINUE

      CALL JEDEMA()

      END
