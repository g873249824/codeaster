      SUBROUTINE CCACCL(OPTION,MODELE,RESUIN,MATECO,CARAEL,
     &                  LIGREL,LORDRE,IORDRE,TYPESD,NBPAIN,
     &                  LIPAIN,LICHIN,EXITIM,NOMCHA,NOMCMP,
     &                  LICHOU,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBPAIN,IORDRE,LORDRE(*),CODRET
      CHARACTER*8  MODELE,RESUIN,MATECO,CARAEL
      CHARACTER*8  LIPAIN(*),NOMCMP
      CHARACTER*16 OPTION,TYPESD,NOMCHA
      CHARACTER*24 LICHIN(*),LIGREL,LICHOU(2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C  POUTRE POUX, DCHA_*, RADI_*, ...
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
C   NOMCHA  K16  NOM DU CHAMP RECUPERE A PARTIR DU FICHIER DE COMMANDE
C                (N'EST UTILE QUE POUR OPTION == 'SPMX_ELGA'
C   NOMCMP  K8   NOM CMP RECUPERE A PARTIR DU FICHIER DE COMMANDE
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
      LOGICAL      EXITIM,EXICAR

      INTEGER      IRET1,IRET2,IBID,JAINST,LFREQ
      INTEGER      NUMOR1,JAINS2,JNMO,IPARA,INUME

      REAL*8       R8B,TIME,TIME2,RUNDF,R8VIDE,ZERO,UN,FREQ
      PARAMETER    (ZERO=0.0D0,UN=1.0D0)

      COMPLEX*16   CBID

      CHARACTER*2  CHDRET
      CHARACTER*4  TYPE
      CHARACTER*8  K8B,NOMA,Z1Z2(2),CURPAR,SAVCAR(2),CARAE2
      CHARACTER*16 VARI
      CHARACTER*19 CHVARC,CHVREF,CHVAC2,COMPOR,CANBVA
      CHARACTER*24 CHMASS,CHTIME,CHHARM,CHCMP
      CHARACTER*24 NOMS(2),CHNOVA,CHFREQ,VALKM(2)
      CHARACTER*24 CHCARA(18)

      RUNDF = R8VIDE()

      CHVARC = '&&MECALM.CHVARC'
      CHVREF = '&&MECALM.CHVREF'

      CALL JEMARQ()

      CODRET = 0

      SAVCAR(1) = '????????'
      SAVCAR(2) = '????????'

      CALL MECARA(CARAEL,EXICAR,CHCARA)
      CALL MECHC1(SAVCAR,MODELE,MATECO,EXICAR,CHCARA)
      IF ( EXICAR ) THEN
        DO 10 IPARA = 1,NBPAIN
          CURPAR = LIPAIN(IPARA)
          IF ( CURPAR.EQ.'PCACOQU' ) LICHIN(IPARA) = CHCARA(7)
   10   CONTINUE
      ENDIF

      NUMOR1 = LORDRE(IORDRE)
      IF (EXITIM) THEN
        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET1)
        CALL RSADPA(RESUIN,'L',1,'INST',NUMOR1,0,JAINST,K8B)
        TIME = ZR(JAINST)
        CALL MECHTI(NOMA,TIME,RUNDF,RUNDF,CHTIME)
      ELSE
        CHTIME = ' '
        TIME = ZERO
      ENDIF
      CALL VRCREF(MODELE,MATECO(1:8),CARAEL,CHVREF(1:19))
      CALL VRCINS(MODELE,MATECO,CARAEL,TIME,CHVARC,CHDRET)

      IF ( OPTION.EQ.'SIEQ_ELGA' ) THEN
        IF ( TYPESD.EQ.'FOURIER_ELAS' ) THEN
          CALL U2MESK('F','CALCULEL6_83',1,OPTION)
        ENDIF
      ELSE
        IF ( TYPESD.EQ.'FOURIER_ELAS'.OR.
     &       TYPESD.EQ.'COMB_FOURIER') THEN
          CALL RSADPA(RESUIN,'L',1,'NUME_MODE',NUMOR1,0,JNMO,K8B)
          CALL MEHARM(MODELE,ZI(JNMO),CHHARM)
          DO 20 IPARA = 1,NBPAIN
            CURPAR = LIPAIN(IPARA)
            IF ( CURPAR.EQ.'PHARMON' ) LICHIN(IPARA) = CHHARM
   20     CONTINUE
        ELSE
          CALL MEHARM(MODELE,0,CHHARM)
        ENDIF
      ENDIF

C      ELSEIF (OPTION.EQ.'ECIN_ELEM') THEN
      IF (OPTION.EQ.'ECIN_ELEM') THEN
        IF (TYPESD.EQ.'MODE_MECA') THEN
          TYPE = 'DEPL'
        ELSE IF (TYPESD.EQ.'EVOL_NOLI') THEN
          TYPE = 'VITE'
        ELSE IF (TYPESD.EQ.'DYNA_TRANS') THEN
          TYPE = 'VITE'
        ELSE IF (TYPESD.EQ.'DYNA_HARMO') THEN
          TYPE = 'VITE'
        ELSE
          VALKM(1) = OPTION
          VALKM(2) = TYPESD
          CALL U2MESK('A','CALCULEL3_6', 2 ,VALKM)
          CODRET = 1
          GO TO 9999
        ENDIF

        INUME = 1
        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET1)
        CHMASS = '&&MECALM.MASD'
        CALL MECACT('V',CHMASS,'MAILLA',NOMA,'POSI',1,'POS',INUME,
     &              R8B,CBID,K8B)

        FREQ = UN
        IF (TYPE.EQ.'DEPL') THEN
          CALL RSADPA(RESUIN,'L',1,'OMEGA2',NUMOR1,0,LFREQ,K8B)
          FREQ = ZR(LFREQ)
        END IF

        CHFREQ = '&&MECALM.FREQ'
        CALL MECACT('V',CHFREQ,'MAILLA',NOMA,'FREQ_R',1,'FREQ',
     &              IBID,FREQ,CBID,K8B)

      ELSEIF ( OPTION.EQ.'ENDO_ELGA' ) THEN
        CHVAC2 = '&&MECALM.CHVAC2'
        IF (EXITIM) THEN
          NUMOR1 = LORDRE(IORDRE-1)
          CALL RSADPA(RESUIN,'L',1,'INST',NUMOR1,0,JAINS2,K8B)
          TIME2 = ZR(JAINS2)
        ELSE
          TIME2 = ZERO
        ENDIF
        CALL VRCINS(MODELE,MATECO,CARAEL,TIME2,CHVAC2,CHDRET)

      ELSEIF ( OPTION.EQ.'SPMX_ELGA' ) THEN
        CHCMP = '&&OP0058.ELGA_MAXI'
        Z1Z2(1) = 'Z1'
        Z1Z2(2) = 'Z2'
        NOMS(1) = NOMCHA
        NOMS(2) = NOMCMP
        CALL MECACT('V',CHCMP,'MODELE',MODELE,'NEUT_K24',2,Z1Z2,
     &              IBID,R8B,CBID,NOMS)

      ELSEIF ( (OPTION.EQ.'VAEX_ELGA').OR.
     &         (OPTION.EQ.'VAEX_ELNO') ) THEN
        CHNOVA = '&&MECALC.NOVARI'
        CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET1)
        CALL GETVTX(' ','NOM_VARI',0,1,1,VARI,IBID)

        CALL MECACT('V',CHNOVA,'MAILLA',NOMA,'NEUT_K24',1,'Z1',
     &              IBID,R8B,CBID,VARI )

      ELSEIF ( (OPTION.EQ.'VARI_ELNO').OR.
     &         (OPTION.EQ.'VATU_ELNO').OR.
     &         (OPTION.EQ.'VACO_ELNO')  ) THEN
        DO 30 IPARA = 1,NBPAIN
          CURPAR = LIPAIN(IPARA)
          IF ( CURPAR.EQ.'PCOMPOR' ) COMPOR = LICHIN(IPARA)
   30   CONTINUE
        CALL EXISD('CARTE',COMPOR,IRET2)
        IF (IRET2.NE.1) THEN
          CALL U2MESS('A','CALCULEL2_86')
          CODRET = 1
          GO TO 9999
        END IF
        CANBVA = '&&MECALC.NBVAR'
        CARAE2 = CARAEL
        IF ( OPTION.EQ.'VATU_ELNO'.OR.
     &       (OPTION.EQ.'VACO_ELNO') ) THEN
          CANBVA = '&&MECALC.NBVARI'
          CARAE2 = ' '
        ENDIF
        CALL CESVAR(CARAE2,COMPOR,LIGREL,CANBVA)
        CALL COPISD('CHAM_ELEM_S','V',CANBVA,LICHOU(1))
        CALL DETRSD('CHAM_ELEM_S',CANBVA)

      ELSE IF ( (OPTION.EQ.'EPSI_ELGA') .OR.
     &          (OPTION.EQ.'SIEF_ELGA').OR.
     &          (OPTION.EQ.'SIEQ_ELGA') .OR.
     &          (OPTION.EQ.'EPEQ_ELGA') ) THEN
        CANBVA = '&&MECALC.NBSP'
        CALL EXISD('CHAM_ELEM_S',CANBVA,IRET1)
        IF (IRET1.NE.1) CALL CESVAR(CARAEL,' ',LIGREL,CANBVA)
        CALL COPISD('CHAM_ELEM_S','V',CANBVA,LICHOU(1))

      ENDIF

 9999 CONTINUE

      CALL JEDEMA()

      END
