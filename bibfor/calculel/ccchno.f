      SUBROUTINE CCCHNO(OPTION,NUMORD,RESUIN,RESUOU,LICHOU,
     &                  MESMAI,NOMAIL,MODELE,CARAEL,BASOPT,
     &                  LIGREL,LIGMOD,CODRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NUMORD,CODRET
      CHARACTER*1  BASOPT
      CHARACTER*8  RESUIN,RESUOU,NOMAIL,MODELE,CARAEL
      CHARACTER*16 OPTION
      CHARACTER*24 LICHOU(2),MESMAI,LIGREL
      LOGICAL      LIGMOD
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/04/2012   AUTEUR SELLENET N.SELLENET 
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
C ----------------------------------------------------------------------
C  CALC_CHAMP - CALCUL D'UN CHAMP AUX NOEUDS
C  -    -                   --        --
C ----------------------------------------------------------------------
C
C  ROUTINE DE CALCUL D'UN CHAMP AUX NOEUDS DE CALC_CHAMP
C
C IN  :
C   OPTION  K16  NOM DE L'OPTION A CALCULER
C   NUMORD  I    NUMERO D'ORDRE COURANT
C   RESUIN  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT IN
C   RESUOU  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT OUT
C   MESMAI  K24  NOM DU VECTEUR CONTENANT LES MAILLES SUR LESQUELLES
C                LE CALCUL EST DEMANDE
C   NOMAIL  K8   NOM DU MAILLAGE SUR LEQUEL LE CALCUL EST REALISE
C   MODELE  K8   NOM DU MODELE
C   CARAEL  K8   NOM DU CARAEL
C   BASOPT  K1   BASE SUR LAQUELLE DOIT ETRE CREE LE CHAMP DE SORTIE
C   LIGREL  K24  NOM DU LIGREL
C
C IN/OUT :
C   LICHOU  K8*  LISTE DES CHAMPS OUT
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
      INTEGER      IER,NBMA,JMAI,IBID,NGR,IGR,NMAXOB,IRET
      PARAMETER    (NMAXOB=30)
      INTEGER      ADOBJ(NMAXOB),NBOBJ,NBSP
C
      CHARACTER*1  CBID,K1BID
      CHARACTER*8  K8B,ERDM
      CHARACTER*16 VALK(2)
      CHARACTER*19 OPTELE,PRFCHN,NOCHOU,CHAMS0,CHAMS1
      CHARACTER*24 NOOJB,CHELEM,NOOBJ(NMAXOB)
C
      CALL JEMARQ()
C
      CALL JEEXIN(MESMAI,IER)
      IF ( IER.NE.0 ) THEN
        CALL JEVEUO(MESMAI,'L',JMAI)
        CALL JELIRA(MESMAI,'LONMAX',NBMA,CBID)
      ELSE
        NBMA = 0
      ENDIF
C
      CHAMS0 = '&&CALCOP.CHAMS0'
      CHAMS1 = '&&CALCOP.CHAMS1'
      OPTELE = OPTION(1:5)//'ELNO'
C
      NOOJB = '12345678.00000.NUME.PRNO'
      CALL GNOMSD(NOOJB,10,14)
      PRFCHN = NOOJB(1:19)
C
      CALL RSEXC1(RESUOU,OPTION,NUMORD,NOCHOU)
      LICHOU(1) = NOCHOU
C
      CALL RSEXCH(RESUIN,OPTELE,NUMORD,CHELEM,IER)
      IF ( IER.NE.0 ) THEN
        CALL RSEXCH(RESUOU,OPTELE,NUMORD,CHELEM,IER)
      ENDIF
C
      CALL CELCES(CHELEM,'V',CHAMS0)
      IF (NBMA.NE.0) THEN
        CALL CESRED(CHAMS0,NBMA,ZI(JMAI),0,K8B,'V',CHAMS0)
      ENDIF
C
C     VERIFICATION DES REPERES LOCAUX
      ERDM = 'NON'
      CALL DISMOI('F','EXI_RDM',LIGREL,'LIGREL',IBID,ERDM,IER)
C
C     CETTE VERIFICATION NE DOIT ETRE FAITE QUE DANS LE CAS
C     OU LE MODELE CONTIENT DE ELEMENTS DE STRUCTURE
C     ET QUE POUR CERTAINS CHAMPS QUI SONT EN REPERE LOCAL
      IF ((ERDM.EQ.'OUI').AND.((OPTION(1:4).EQ.'EPSI')
     &    .OR.(OPTION(1:4).EQ.'SIGM').OR.(OPTION(1:4).EQ.'DEGE')
     &    .OR.(OPTION(1:4).EQ.'EFGE'))) THEN
        IF (LIGMOD) THEN
C
C         POUR LES COQUES 3D CERTAINES INITIALISATIONS SONT
C         NECESSAIRES POUR POUVOIR UTILISER LES ROUTINES
C         DE CHANGEMENT DE REPERE PROPRES AUX COQUES 3D
          CALL DISMOI('F','EXI_COQ3D',LIGREL,'LIGREL',IBID,ERDM,IER)
          IF (ERDM.EQ.'OUI'.AND.LIGMOD) THEN
            CALL JELIRA(LIGREL(1:19)//'.LIEL','NUTIOC',NGR,K1BID)
            DO 10 IGR = 1,NGR
              CALL INIGRL(LIGREL,IGR,NMAXOB,ADOBJ,NOOBJ,NBOBJ)
  10        CONTINUE
          ENDIF
        ENDIF
        IF ( CARAEL.NE.' ' )
     &    CALL CCVRRL(NOMAIL,MODELE,CARAEL,MESMAI,CHAMS0,'A',CODRET)
      ENDIF
C
      CALL CESCNS(CHAMS0,' ','V',CHAMS1,'A',CODRET)
      CALL CNSCNO(CHAMS1,PRFCHN,'NON',BASOPT,NOCHOU,' ',IRET)
C
C     VERIFICATION POUR LES CHAMPS A SOUS-POINT
      CALL DISMOI('F','MXNBSP',CHELEM,'CHAM_ELEM',NBSP,K8B,IBID)
      IF ((NBSP.GT.1).AND.(IRET.EQ.1)) THEN
        VALK(1)=OPTELE
        VALK(2)=OPTION
        CALL U2MESK('F','CALCULEL4_16',2,VALK)
      ENDIF
C
      CALL DETRSD('CHAM_ELEM_S',CHAMS0)
      CALL DETRSD('CHAM_NO_S',CHAMS1)
C
      CALL JEDEMA()
C
      END
