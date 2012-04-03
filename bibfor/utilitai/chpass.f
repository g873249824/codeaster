      SUBROUTINE CHPASS(TYCHR,MA,CELMOD,NOMGD,PROL0,CHOU)
      IMPLICIT  NONE
      CHARACTER*8 MA,CHOU
      CHARACTER*(*) CELMOD
      CHARACTER*4 TYCHR,TYCH2
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/04/2012   AUTEUR SELLENET N.SELLENET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C     BUT : TRAITER :
C          - OPTION 'ASSE' DE LA COMMANDE CREA_CHAMP
C     -----------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------

      INTEGER N1,IB,NBOCC,IOCC,NBTROU,JNUTRO,NBMOCL,LNOM,IBID
      LOGICAL CHGCMP,CUMUL,LCUMUL(2)
      INTEGER NCMP,JLICMP,GD,JCMPGD,JLICM2,IRET,NNCP,NCHG
      REAL*8 COEFR,LCOEFR(2)
      COMPLEX*16 COEFC,LCOEFC(2)
      CHARACTER*8 KBID,MODELE
      CHARACTER*8 CHAMP,NOMGD,NOMGD2,MA2
      CHARACTER*3 PROL0,TSCA
      CHARACTER*16 LIMOCL(5),TYMOCL(5),TYPEM
      CHARACTER*19 CHS1,CHS2,NUTROU,LICHS(2),CESMOD,OPTION
      CHARACTER*19 CHS3,LIGREL
      CHARACTER*24 CNOM,VALK(3)

      LOGICAL LCOC
      INTEGER      IARG
C     -----------------------------------------------------------------

      CALL JEMARQ()

      CHS1 = '&&CHPASS.CHS1'
      CHS2 = '&&CHPASS.CHS2'
      CHS3 = '&&CHPASS.CHS3'


C 1- CALCUL DE:
C      NOMGD : NOM DE LA GRANDEUR
C      GD    : NUMERO DE LA GRANDEUR
C      JCMPGD: ADRESSE DES CMPS DE LA GRANDEUR
C      PROL0 :/'OUI' POUR PROLONGER PAR ZERO LES CHAM_ELEM
C                    NON DEFINIS PARTOUT
C             /'NON' POUR ARRETER <F> DANS LE CAS PRECEDENT
C      LIGREL: NOM DU LIGREL ASSOCIE A CELMOD
C      OPTION: OPTION ASSOCIEE A CELMOD (SI CHAM_ELEM)
C      CESMOD: CHAM_ELEM_S EQUIVALENT A CELMOD (SI CHAM_ELEM)

C     ------------------------------------------------------------------

      IF (MA.EQ.' ') CALL U2MESS('F','UTILITAI_27')

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) CALL U2MESK('F','CALCULEL_67',1,NOMGD)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',JCMPGD)

      IF (TYCHR(1:2).EQ.'EL') THEN
        CALL DISMOI('F','NOM_LIGREL',CELMOD,'CHAM_ELEM',IB,LIGREL,IB)
        CALL DISMOI('F','NOM_OPTION',CELMOD,'CHAM_ELEM',IB,OPTION,IB)
        CESMOD = '&&CHPASS.CESMOD'
        CALL CELCES(CELMOD,'V',CESMOD)

        MODELE = LIGREL(1:8)
        CALL EXISD('MODELE',MODELE,IRET)
        IF (IRET.NE.1) MODELE = ' '

      ELSE
        LIGREL = ' '
        OPTION = ' '
        CESMOD = ' '
        MODELE = ' '
      ENDIF


C     2- BOUCLE DE VERIF SUR LES OCCURENCES DU MOT CLE "ASSE" :
C     ---------------------------------------------------------
      CALL GETFAC('ASSE',NBOCC)
      CNOM = '&&CHPASS.CHAM_GD_LISTE'
      CALL WKVECT(CNOM,'V V K24',NBOCC,LNOM)

      DO 10,IOCC = 1,NBOCC

C       2.1 VERIFICATION DES CARACTERISTIQUES DU CHAMP :
C       ------------------------------------------------
        CALL GETVID('ASSE','CHAM_GD',IOCC,IARG,1,CHAMP,IB)
        ZK24(LNOM+IOCC-1) = CHAMP
        CALL DISMOI('F','TYPE_CHAMP',CHAMP,'CHAMP',IB,TYCH2,IB)
        CALL DISMOI('F','NOM_MAILLA',CHAMP,'CHAMP',IB,MA2,IB)
        IF (MA.NE.MA2) THEN
          VALK(1)=CHAMP
          VALK(2)=MA2
          VALK(3)=MA
          CALL  U2MESK('F','CALCULEL2_17',3,VALK)
        ENDIF


        IF (TYCHR.EQ.'NOEU') THEN
          IF (TYCH2.NE.'NOEU') CALL U2MESK('F','UTILITAI_28',1,CHAMP)

        ELSEIF (TYCHR.EQ.'ELGA') THEN
          IF ((TYCH2.NE.'CART') .AND. (TYCH2.NE.'ELEM') .AND.
     &        (TYCH2.NE.'ELGA')) CALL U2MESK('F','UTILITAI_29',1,CHAMP)

        ELSEIF (TYCHR.EQ.'ELNO') THEN
          IF ((TYCH2.NE.'CART') .AND. (TYCH2.NE.
     &        'ELNO')) CALL U2MESK('F','UTILITAI_29',1,CHAMP)

        ELSEIF (TYCHR.EQ.'ELEM') THEN
          IF ((TYCH2.NE.'CART') .AND. (TYCH2.NE.
     &        'ELEM')) CALL U2MESK('F','UTILITAI_29',1,CHAMP)

        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

   10 CONTINUE



C     3- ARGUMENTS POUR APPELER RELIEM :
C     ---------------------------------
      LIMOCL(1) = 'TOUT'
      TYMOCL(1) = 'TOUT'
      LIMOCL(2) = 'MAILLE'
      TYMOCL(2) = 'MAILLE'
      LIMOCL(3) = 'GROUP_MA'
      TYMOCL(3) = 'GROUP_MA'
      LIMOCL(4) = 'NOEUD'
      TYMOCL(4) = 'NOEUD'
      LIMOCL(5) = 'GROUP_NO'
      TYMOCL(5) = 'GROUP_NO'
      NUTROU = '&&CHPASS.NU_TROUVES'
      IF (TYCHR.EQ.'NOEU') THEN
        TYPEM = 'NU_NOEUD'
        NBMOCL = 5

      ELSE
        TYPEM = 'NU_MAILLE'
        NBMOCL = 3
      ENDIF



C     4- BOUCLE SUR LES OCCURENCES DU MOT CLE "ASSE" :
C     -----------------------------------------------------
      NCHG = 0
      DO 20,IOCC = 1,NBOCC
        CALL GETVID('ASSE','CHAM_GD',IOCC,IARG,1,CHAMP,IB)
        CALL DISMOI('F','TYPE_CHAMP',CHAMP,'CHAMP',IB,TYCH2,IB)

        CUMUL = .FALSE.
        CALL GETVTX('ASSE','CUMUL',IOCC,IARG,1,KBID,IB)
        IF (KBID.EQ.'OUI') CUMUL = .TRUE.

C       4.0 CALCUL DE LA LISTE DES CMPS ET DU BOOLEEN CHGCMP
C        QUI INDIQUE QUE L'ON DOIT MODIFIER LES CMPS ET/OU LA GRANDEUR.
C       ---------------------------------------------------------------
        CALL GETVTX('ASSE','NOM_CMP',IOCC,IARG,0,KBID,N1)
        CHGCMP = .FALSE.
        IF (N1.LT.0) THEN
          NCMP = -N1
          CALL WKVECT('&&CHPASS.LICMP','V V K8',NCMP,JLICMP)
          CALL GETVTX('ASSE','NOM_CMP',IOCC,IARG,NCMP,ZK8(JLICMP),IB)
          CALL GETVTX('ASSE','NOM_CMP_RESU',IOCC,IARG,0,KBID,N1)
          IF (N1.LT.0) THEN
            CHGCMP = .TRUE.
            NCHG = NCHG + 1
            IF (N1.NE.-NCMP) CALL U2MESS('F','UTILITAI_31')
            CALL WKVECT('&&CHPASS.LICMP2','V V K8',NCMP,JLICM2)
            CALL GETVTX('ASSE','NOM_CMP_RESU',IOCC,IARG,NCMP,
     &                  ZK8(JLICM2),
     &                  IB)
          ENDIF

        ELSE
          NCMP = 0
          JLICMP = 0
        ENDIF

C       4.1 VERIFICATION DE LA GRANDEUR ASSOCIEE AU CHAMP
C       ------------------------------------------------------
        CALL DISMOI('F','NOM_GD',CHAMP,'CHAMP',IB,NOMGD2,IB)
        IF ((.NOT.CHGCMP) .AND. (NOMGD2.NE.NOMGD)) THEN
          VALK(1)=CHAMP
          VALK(2)=NOMGD
          VALK(3)=NOMGD2
          CALL U2MESK('F', 'UTILITAI_32',3,VALK)
        ENDIF


        CALL DISMOI('F','TYPE_SCA',NOMGD2,'GRANDEUR',IB,TSCA,IB)
        CALL GETVC8('ASSE','COEF_C',IOCC,IARG,1,COEFC,IRET)
        IF (IRET.NE.0) THEN
          IF (TSCA.NE.'C') THEN
            CALL U2MESS('F','UTILITAI_33')
          ENDIF
          LCOC = .TRUE.

        ELSE
          LCOC = .FALSE.
          CALL GETVR8('ASSE','COEF_R',IOCC,IARG,1,COEFR,IB)
        ENDIF

C       4.2 RECUPERATION DE LA LISTE DES NOEUDS OU MAILLES :
C       ----------------------------------------------------
        CALL RELIEM(MODELE,MA,TYPEM,'ASSE',IOCC,NBMOCL,LIMOCL,TYMOCL,
     &              NUTROU,NBTROU)
        CALL JEVEUO(NUTROU,'L',JNUTRO)


C       4.3 TRANSFORMATION ET REDUCTION DU CHAMP :
C       ------------------------------------------
        IF (TYCH2.EQ.'NOEU') THEN
          CALL CNOCNS(CHAMP,'V',CHS1)
          CALL CNSRED(CHS1,NBTROU,ZI(JNUTRO),NCMP,ZK8(JLICMP),'V',CHS2)

        ELSEIF (TYCH2(1:2).EQ.'EL') THEN
          CALL CELCES(CHAMP,'V',CHS1)
          CALL CESRED(CHS1,NBTROU,ZI(JNUTRO),NCMP,ZK8(JLICMP),'V',CHS2)

        ELSEIF (TYCH2.EQ.'CART') THEN
          CALL CARCES(CHAMP,TYCHR,CESMOD,'V',CHS1,'A',IB)
          CALL CESRED(CHS1,NBTROU,ZI(JNUTRO),NCMP,ZK8(JLICMP),'V',CHS2)

        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF


C       4.4 SI ON DOIT CHANGER LES CMPS ET/OU LA GRANDEUR :
C       ----------------------------------------------------
        IF (CHGCMP) THEN
          CALL CHSUT1(CHS2,NOMGD,NCMP,ZK8(JLICMP),ZK8(JLICM2),'V',CHS2)
        ENDIF


C       4.4 FUSION DU CHAMP REDUIT AVEC LE CHAMP RESULTAT :
C       ----------------------------------------------------
        IF (IOCC.EQ.1) THEN
          CALL CHSFUS(1,CHS2,.FALSE.,COEFR,COEFC,LCOC,'V',CHS3)
        ELSE
          LICHS(1) = CHS3
          LICHS(2) = CHS2
          LCUMUL(1) = .FALSE.
          LCUMUL(2) = CUMUL
          LCOEFR(1) = 1.D0
          LCOEFR(2) = COEFR
          LCOEFC(1) = 1.D0
          LCOEFC(2) = COEFC
          CALL CHSFUS(2,LICHS,LCUMUL,LCOEFR,LCOEFC,LCOC,'V',CHS3)
        ENDIF

        CALL JEDETR('&&CHPASS.LICMP')
        CALL JEDETR('&&CHPASS.LICMP2')
   20 CONTINUE

C     5 TRANSFORMATION DU CHAMP_S EN CHAMP :
C     ----------------------------------------------------
      IF (TYCH2.EQ.'NOEU') THEN
        CALL CNSCNO(CHS3,' ','NON','G',CHOU,'F',IBID)

      ELSE
        CALL CESCEL(CHS3,LIGREL,OPTION,' ',PROL0,NNCP,'G',CHOU,'F',IBID)
      ENDIF


C     6- MENAGE :
C     -----------------------------------------------------
      CALL DETRSD('CHAM_NO_S',CHS1)
      CALL DETRSD('CHAM_NO_S',CHS2)
      CALL DETRSD('CHAM_NO_S',CHS3)
      CALL DETRSD('CHAM_ELEM_S',CHS1)
      CALL DETRSD('CHAM_ELEM_S',CHS2)
      CALL DETRSD('CHAM_ELEM_S',CHS3)

      CALL DETRSD('CHAM_ELEM_S',CESMOD)
      CALL JEDETR(NUTROU)

      CALL JEDEMA()
      END
