      SUBROUTINE CALCOP(OPTION,RESUIN,RESUOU,LISORD,NBORDR,
     &                  LISCHA,NCHARG,CHTYPE,TYPESD,NBCHRE,
     &                  IOCCUR,SUROPT,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBORDR,NCHARG,CODRET,NBCHRE,IOCCUR
      CHARACTER*4  CHTYPE
      CHARACTER*8  RESUIN,RESUOU
      CHARACTER*16 OPTION,TYPESD
      CHARACTER*19 LISCHA,LISORD
      CHARACTER*24 SUROPT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 27/06/2011   AUTEUR SELLENET N.SELLENET 
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
C   LISORD  K19   LISTE DE NUMEROS D'ORDRE
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

      INTEGER      NOPOUT,JLISOP,IOP,IBID,NBORD2,LRES,IER,NBVAL,N0,N1
      INTEGER      NBTROU,MINORD,MAXORD,JLINST,IORDR,NBORDL,IFISS
      INTEGER      NUMORD,IEXCIT,IRET,NPASS,NBMA,CODRE2

      REAL*8       R8B

      COMPLEX*16   C16B

      CHARACTER*1  BASOPT
      CHARACTER*8  MODELE,CARAEL,K8B
      CHARACTER*8  NOMA,NOBASE,POUX,NOMCMP
      CHARACTER*16 OPTIO2,NOMCHA,TYPMCL(4),MOTCLE(4)
      CHARACTER*19 EXCIT
      CHARACTER*24 CHAOUT,LIGREL,MATECO
      CHARACTER*24 NOLIOP,LISINS,MESMAI,CHELEM
      CHARACTER*32 JEXNOM

      CALL JEMARQ()
      CODRET = 1
      NPASS = 0
      NOBASE = '&&CALCOP'

      IF ( (OPTION.EQ.'ETOT_ELEM').OR.
     &     (OPTION.EQ.'ETOT_ELGA').OR.
     &     (OPTION.EQ.'ETOT_ELNO') ) GOTO 9999

      IF ( (OPTION.EQ.'SIGM_ELNO').OR.
     &     (OPTION.EQ.'EFCA_ELNO').OR.
     &     (OPTION.EQ.'SIRO_ELEM').OR.
     &     (OPTION.EQ.'SIEQ_ELNO').OR.
     &     (OPTION.EQ.'EFGE_ELNO') ) GOTO 9999

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
      CALL JEEXIN(MODELE(1:8)//'.FISS',IFISS)
      IF (IFISS.NE.0.AND.OPTION.EQ.'SIEF_ELNO') THEN
        NOPOUT = 0
        GOTO 9998
      ENDIF
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET)

      POUX = 'NON'
      CALL DISMOI('F','EXI_POUX',MODELE,'MODELE',IBID,POUX,IER)
      EXIPOU = .FALSE.
      IF (POUX.EQ.'OUI') EXIPOU = .TRUE.
C
      IF ( OPTION(6:9).EQ.'NOEU' ) THEN
        NBMA = 0
        CALL GETVTX(' ','MAILLE',1,1,0,K8B,N0)
        CALL GETVTX(' ','GROUP_MA',1,1,0,K8B,N1)
        MESMAI = '&&OP0106.MES_MAILLES'
        IF ( N0+N1.NE.0 ) THEN
          MOTCLE(1) = 'GROUP_MA'
          MOTCLE(2) = 'MAILLE'
          TYPMCL(1) = 'GROUP_MA'
          TYPMCL(2) = 'MAILLE'
          CALL RELIEM(' ',NOMA,'NU_MAILLE',' ',1,2,MOTCLE,TYPMCL,
     &                MESMAI,NBMA)
        ENDIF
      ENDIF
C
C     COMME ON PARCOURT LES OPTIONS DANS L'ORDRE INVERSE DES DEPENDANCES
C     ON SAIT QUE LES LISTES D'INSTANT SERONT CORRECTEMENT CREES
      DO 10 IOP = 1,NOPOUT
        OPTIO2 = ZK24(JLISOP+IOP-1)
C
        IF ( OPTION.EQ.'SPMX_ELGA' ) THEN
          CALL GETVTX(' ','NOM_CHAM',1,1,1,NOMCHA,NBVAL)
          CALL GETVTX(' ','NOM_CMP',1,1,1,NOMCMP,NBVAL)
        ENDIF
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
        CALL CCLORD(IOP,NBORDR,LISORD,NOBASE,OPTDEM,
     &              MINORD,MAXORD,RESUIN,RESUOU,LISINS)

        CALL JEVEUO(LISINS,'L',JLINST)
        NBORDL = ZI(JLINST)
        CODRE2 = 0
        DO 20 IORDR = 1,NBORDL
          NUMORD = ZI(JLINST+IORDR+2)

          CALL MEDOM2(MODELE,MATECO,CARAEL,LISCHA,NCHARG,CHTYPE,
     &                RESUIN,NUMORD,NBORDR,NPASS,LIGREL)

          IF ( OPTIO2(6:9).EQ.'NOEU' ) THEN
C
            CALL CCCHNO(OPTIO2,NUMORD,RESUIN,RESUOU,CHAOUT,
     &                  MESMAI,BASOPT,CODRE2)
C
          ELSEIF ( OPTIO2(6:7).EQ.'EL' ) THEN
C
            CALL CCCHEL(OPTIO2,MODELE,RESUIN,RESUOU,ZI(JLINST+3),
     &                  IORDR, MATECO,CARAEL,TYPESD,LIGREL,
     &                  EXIPOU,EXITIM,LISCHA,NBCHRE,IOCCUR,
     &                  SUROPT,NOMCHA,NOMCMP,BASOPT,CHAOUT)
            IF ( CHAOUT.EQ.' ' ) GOTO 10
C
          ENDIF
          CALL EXISD('CHAMP_GD',CHAOUT,IRET)
          IF (IRET.EQ.0) THEN
            CODRET = 1
            CALL U2MESK('A','CALCULEL2_89',1,OPTIO2)
          ELSE
            IF ( OPTIO2.EQ.OPTION )
     &        CALL RSNOCH(RESUOU,OPTIO2,NUMORD,' ')
          END IF

          IF (POUX.EQ.'OUI') CALL JEDETC('V','&&MECHPO',1)
          CALL DETRSD('CHAM_ELEM_S',CHAOUT)
   20   CONTINUE
        IF ( CODRE2.NE.0 ) CALL U2MESS('A','UTILITAI_3')
C
   10 CONTINUE

      CODRET = 0

 9998 CONTINUE

      CALL JEDETR('&&CALCOP.NB_ORDRE')

      CALL CCNETT(NOBASE,NOPOUT)
C
      IF ( OPTION(6:9).EQ.'NOEU'.AND.NBMA.NE.0 ) CALL JEDETR(MESMAI)
C
 9999 CONTINUE

      CALL JEDEMA()

      END
