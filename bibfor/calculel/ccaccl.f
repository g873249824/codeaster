      SUBROUTINE CCACCL(OPTION,MODELE,RESUIN,MATECO,CARAEL,
     &                  LIGREL,LORDRE,IORDRE,TYPESD,NBPAIN,
     &                  LIPAIN,LICHIN,EXITIM,LICHOU,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBPAIN,IORDRE,LORDRE(*),CODRET
      CHARACTER*8  MODELE,RESUIN,MATECO,CARAEL
      CHARACTER*8  LIPAIN(*)
      CHARACTER*16 OPTION,TYPESD
      CHARACTER*24 LICHIN(*),LIGREL,LICHOU(2)
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
C  CALC_CHAMP - AJOUT ET CALCUL DE CHAMPS LOCAUX
C  -    -       -        -         -      -
C ----------------------------------------------------------------------
C
C  ROUTINE DE GESTION DES GLUTES NECESSAIRES POUR CERTAINES OPTIONS
C  * POUTRE POUX, DCHA_*, RADI_*, ...
C  * APPEL A CESVAR POUR LES CHAMPS A SOUS-POINTS.
C
C IN  :
C   OPTION  K16  NOM DE L'OPTION
C   MODELE  K8   NOM DU MODELE
C   RESUIN  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT IN
C   MATECO  K8   NOM DU MATERIAU CODE
C   CARAEL  K8   NOM DU CARAELE
C   LIGREL  K24  NOM DU LIGREL
C   LORDRE  I*   LISTE DE NUMERO D'ORDRE
C   IORDRE  I    NUMERO D'ORDRE COURANT
C   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
C   NBPAIN  I    NOMBRE DE PARAMETRES IN
C   LIPAIN  K8*  LISTE DES PARAMETRES IN
C   EXITIM  BOOL EXISTENCE OU NON DE L'INSTANT DANS LA SD RESULTAT
C   LICHOU  K24* LISTE DES CHAMPS OUT
C
C IN/OUT :
C   LICHIN  K24* LISTE MODIFIEE DES CHAMPS IN
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
      LOGICAL EXITIM,EXICAR

      INTEGER IRET1,IRET2,IBID,JAINST,KPARIN
      INTEGER NUMOR1,JAINS2,IPARA,INUME,NBSP,INDIK8

      REAL*8 R8B,TIME,TIME2,ZERO
      PARAMETER(ZERO=0.0D0)

      COMPLEX*16 CBID

      CHARACTER*2 CHDRET,KBID
      CHARACTER*8 K8B,NOMA,CURPAR,CARAE2,PARAIN
      CHARACTER*16 VARI,CONCEP,NOMCMD,TYPRES
      CHARACTER*19 CHVARC,CHVREF,CHVAC2,COMPOR,COMPO2,CANBVA
      CHARACTER*24 CHMASS,CHNLIN
      CHARACTER*24 CHNOVA
      CHARACTER*24 CHCARA(18)
      CHARACTER*24 CHSIG,CHSIGF
      INTEGER      IARG

      CHVARC='&&MECALM.CHVARC'
      CHVREF='&&MECALM.CHVREF'

      CALL JEMARQ()

      CODRET=0

      CALL GETRES(K8B,CONCEP,NOMCMD)
      CALL GETTCO(RESUIN,TYPRES)
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET1)


      CALL MECARA(CARAEL,EXICAR,CHCARA)
      IF (EXICAR) THEN
        DO 10 IPARA=1,NBPAIN
          CURPAR=LIPAIN(IPARA)
          IF (CURPAR.EQ.'PCACOQU')LICHIN(IPARA)=CHCARA(7)
   10   CONTINUE
      ENDIF

      NUMOR1=LORDRE(IORDRE)
      IF (EXITIM) THEN
        CALL RSADPA(RESUIN,'L',1,'INST',NUMOR1,0,JAINST,K8B)
        TIME=ZR(JAINST)
      ELSE
        TIME=ZERO
      ENDIF
      CALL VRCREF(MODELE,MATECO(1:8),CARAEL,CHVREF(1:19))
      CALL VRCINS(MODELE,MATECO,CARAEL,TIME,CHVARC,CHDRET)


      IF (OPTION.EQ.'SIEQ_ELGA') THEN
        IF (TYPESD.EQ.'FOURIER_ELAS') THEN
          CALL U2MESK('F','CALCULEL6_83',1,OPTION)
        ENDIF
      ENDIF


      IF (OPTION.EQ.'ECIN_ELEM') THEN
        INUME=1
        CHMASS='&&MECALM.MASD'
        CALL MECACT('V',CHMASS,'MAILLA',NOMA,'POSI',1,'POS',INUME,R8B,
     &              CBID,K8B)


C     -- GLUTE EFGE_ELNO (RESPONSABLE J. PELLET) :
C     ------------------------------------------------
      ELSEIF (OPTION.EQ.'EFGE_ELNO') THEN
        CHNLIN='&&CCACCL.PNONLIN'
C       -- INUME=0 => CALCUL LINEAIRE
C       -- INUME=1 => CALCUL NON-LINEAIRE
        INUME=0
        IF (TYPRES.EQ.'EVOL_NOLI') INUME=1
        CALL MECACT('V',CHNLIN,'MAILLA',NOMA,'NEUT_I',1,'X1',INUME,R8B,
     &              CBID,K8B)
C       -- SI LINEAIRE, ON DOIT CHANGER PCOMPOR (POUR POU_D_EM):
        IF (INUME.EQ.0) THEN
          KPARIN=INDIK8(LIPAIN,'PCOMPOR',1,NBPAIN)
          CALL ASSERT(KPARIN.GE.1)
          LICHIN(KPARIN)=MATECO(1:8)//'.COMPOR'
        ENDIF


      ELSEIF (OPTION.EQ.'ENDO_ELGA') THEN
        CHVAC2='&&MECALM.CHVAC2'
        IF (EXITIM) THEN
          NUMOR1=LORDRE(IORDRE-1)
          CALL RSADPA(RESUIN,'L',1,'INST',NUMOR1,0,JAINS2,K8B)
          TIME2=ZR(JAINS2)
        ELSE
          TIME2=ZERO
        ENDIF
        CALL VRCINS(MODELE,MATECO,CARAEL,TIME2,CHVAC2,CHDRET)


      ELSEIF (OPTION.EQ.'SIRO_ELEM') THEN
        CHSIGF='&&CCACCL.CHAM_SI2D'
        CALL RSEXCH(RESUIN,'SIGM_ELNO',IORDRE,CHSIG,IRET1)
        CALL MEARCC(OPTION,MODELE,CHSIG,CHSIGF)


      ELSEIF ((OPTION.EQ.'VAEX_ELGA') .OR.
     &        (OPTION.EQ.'VAEX_ELNO')) THEN
        CHNOVA='&&MECALC.NOVARI'
        IF ( NOMCMD.EQ.'CALC_CHAMP' ) THEN
          CALL GETVTX('VARI_INTERNE','NOM_VARI',0,IARG,1,VARI,IBID)
        ELSE
          CALL GETVTX(' ','NOM_VARI',0,IARG,1,VARI,IBID)
        ENDIF

        CALL MECACT('V',CHNOVA,'MAILLA',NOMA,'NEUT_K24',1,'Z1',IBID,R8B,
     &              CBID,VARI)


      ELSEIF (OPTION.EQ.'VARI_ELNO') THEN
C     -- POUR CETTE OPTION ON A BESOIN DE COMPOR :
        DO 20 IPARA=1,NBPAIN
          CURPAR=LIPAIN(IPARA)
          IF (CURPAR.EQ.'PCOMPOR')COMPOR=LICHIN(IPARA)
   20   CONTINUE
        CALL EXISD('CARTE',COMPOR,IRET2)
        IF (IRET2.NE.1) THEN
          CALL U2MESS('A','CALCULEL2_86')
          CODRET=1
          GOTO 30

        ENDIF
      ENDIF


C     ---------------------------------------------------------------
C     -- AJOUT EVENTUEL DU CHAM_ELEM_S PERMETTANT LES SOUS-POINTS
C        ET LE BON NOMBRE DE VARIABLES INTERNES
C     ---------------------------------------------------------------

      IF ((OPTION.EQ.'EPEQ_ELGA') .OR.
     &    (OPTION.EQ.'EPSI_ELGA') .OR.
     &    (OPTION.EQ.'SIEF_ELGA') .OR.
     &    (OPTION.EQ.'SIEQ_ELGA') .OR.
     &    (OPTION.EQ.'SIGM_ELGA') .OR.
     &    (OPTION.EQ.'SIGM_ELNO') .OR.
     &    (OPTION.EQ.'SIEF_ELNO') .OR.
     &    (OPTION.EQ.'VARI_ELNO')) THEN

C       -- CONCERNANT LES VARIABLES INTERNES :
        IF (OPTION.EQ.'VARI_ELNO') THEN
          COMPO2=COMPOR
        ELSE
          COMPO2=' '
        ENDIF

        CARAE2=CARAEL

C       -- POUR LES OPTIONS SUIVANTES, LE NOMBRE DE SOUS-POINTS
C          DU CHAMP "OUT" DEPEND D'UN CHAMP "IN" PARTICULIER :
        IF (OPTION.EQ.'SIGM_ELNO') THEN
          PARAIN='PCONTRR'
        ELSEIF (OPTION.EQ.'SIEF_ELNO') THEN
          PARAIN='PCONTRR'
        ELSEIF (OPTION.EQ.'SIGM_ELGA') THEN
          PARAIN='PSIEFR'
        ELSE
          PARAIN=' '
        ENDIF

        IF (PARAIN.NE.' ') THEN
          KPARIN=INDIK8(LIPAIN,PARAIN,1,NBPAIN)
          CALL ASSERT(KPARIN.GE.1)
          CALL JEEXIN(LICHIN(KPARIN)(1:19)//'.CELD',IRET1)
          NBSP=1
          IF ( IRET1.NE.0 ) THEN
            CALL DISMOI('F','MXNBSP',LICHIN(KPARIN),'CHAM_ELEM',NBSP,
     &                  KBID,IBID)
          ENDIF
          IF (NBSP.LE.1)CARAE2=' '
        ENDIF

        CANBVA='&&CCACCL.CANBVA'
        IF (CARAE2.NE.' ' .OR. COMPO2.NE.' ') THEN
          CALL CESVAR(CARAE2,COMPO2,LIGREL,CANBVA)
          CALL COPISD('CHAM_ELEM_S','V',CANBVA,LICHOU(1))
          CALL DETRSD('CHAM_ELEM_S',CANBVA)
        ENDIF
      ENDIF


   30 CONTINUE
      CALL JEDEMA()

      END
