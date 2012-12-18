      SUBROUTINE XMTBCA(NOMA  ,DEFICO,RESOCO,VALINC,MMCVCA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/12/2012   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE NISTOR I.NISTOR
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      LOGICAL       MMCVCA
      CHARACTER*8   NOMA
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  VALINC(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (CONTACT - GRANDS GLISSEMENTS)
C
C MISE � JOUR DU STATUT DES POINTS DE CONTACT
C ET RENVOIE MMCVCA (INDICE DE CONVERGENCE DE LA BOUCLE
C SUR LES CONTRAINTES ACTIVES)
C
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DE L'OBJET MAILLAGE
C IN  DEFICO : SD CONTACT (DEFINITION)
C IN  RESOCO : SD CONTACT (RESOLUTION)
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C OUT MMCVCA : INDICE DE CONVERGENCE DE LA BOUCLE SUR LES C.A.
C
C
C
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=6)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER      NTPC,SINCO,IPC,IPC2,CFDISI,GROUP,NARET,NARET2
      INTEGER      JTABF
      CHARACTER*24 TABFIN
      INTEGER      ZTABF,CFMMVD
      INTEGER      JVALV,JVALD
      CHARACTER*24 NOSDCO
      INTEGER      JNOSDC
      CHARACTER*19 LIGRXF,CINDCO
      CHARACTER*19 CPOINT,CAINTE,HEAVNO,HEAVFA
      CHARACTER*19 OLDGEO,DEPPLU
      CHARACTER*16 OPTION
      LOGICAL      DEBUG
      INTEGER      IFM,NIV,IFMDBG,NIVDBG
      INTEGER      IGR,IGR2,NGREL,IEL,IEL2,NEL,NEL2
      INTEGER      ADIEL,ADIEL2,JAD,JAD2,DEBGR,DEBGR2
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)
C
C --- INITIALISATIONS
C
      OLDGEO = NOMA(1:8)//'.COORDO'
      CPOINT = RESOCO(1:14)//'.XFPO'
      CAINTE = RESOCO(1:14)//'.XFAI'
      NOSDCO = RESOCO(1:14)//'.NOSDCO'
      HEAVNO = RESOCO(1:14)//'.XFPL'
      HEAVFA = RESOCO(1:14)//'.XFHF'
      CALL JEVEUO(NOSDCO,'L',JNOSDC)
      OPTION = 'XCVBCA'
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF
C
C --- LIGREL DES ELEMENTS TARDIFS DE CONTACT/FROTTEMENT
C
      LIGRXF = ZK24(JNOSDC+3-1)(1:19)
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)

C----RECUPERATION DE TABFIN -

      TABFIN = RESOCO(1:14)//'.TABFIN'
      CALL JEVEUO(TABFIN,'E',JTABF )
      ZTABF  = CFMMVD('ZTABF')

      CINDCO = '&&XMTBCA.INDCO'

      NTPC   = CFDISI(DEFICO,'NTPC'     )
C
C --- INITIALISATION DE L'INDICATEUR DE CONVERGENCE DE LA BOUCLE
C --- SUR LES CONTRAINTES ACTIVES (CONVERGENCE <=> INCOCA =1)
C
      SINCO  = 0
      MMCVCA = .TRUE.
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)
C
C --- CREATION DES LISTES DES CHAMPS IN
C
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = OLDGEO(1:19)
      LPAIN(2)  = 'PDEPL_P'
      LCHIN(2)  = DEPPLU(1:19)
      LPAIN(3)  = 'PCAR_PT'
      LCHIN(3)  = CPOINT
      LPAIN(4)  = 'PCAR_AI'
      LCHIN(4)  = CAINTE
      LPAIN(5)  = 'PHEAVNO'
      LCHIN(5)  = HEAVNO
      LPAIN(6)  = 'PHEAVFA'
      LCHIN(6)  = HEAVFA
C
C --- CREATION DES LISTES DES CHAMPS OUT
C
      LPAOUT(1) = 'PINDCOO'
      LCHOUT(1) = CINDCO
C
C --- APPEL A CALCUL
C
      CALL CALCUL('S',OPTION,LIGRXF,NBIN  ,LCHIN ,LPAIN,
     &                              NBOUT ,LCHOUT,LPAOUT,'V','OUI')
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF
C
C --- ON RECUP�RE LES VARIABLES CHANGEMENT DE STATUT/STATUT/MEMCO
C
      CALL JEVEUO(CINDCO//'.CELV','L',JVALV)
      CALL JEVEUO(CINDCO//'.CELD','L',JVALD)
      NGREL = ZI(JVALD-1+2)
C
C --- ON INTERVERTI LE STATUT DES ARETES SI NECESSAIRE
C
      DO 10 IGR = 1,NGREL
        DEBGR = ZI(JVALD-1+4+IGR)
        NEL = ZI(JVALD-1+DEBGR+1)
        CALL JEVEUO(JEXNUM(LIGRXF//'.LIEL',IGR),'L',JAD)
        DO 20 IEL = 1,NEL
          ADIEL = ZI(JVALD-1+DEBGR+4+4*(IEL-1)+4)
C --- SI PAS DE CHANGEMENT DE STATUT DU POINT D'INTEGRATION, ON SORT
          IF (ZI(JVALV-1+ADIEL).EQ.0) GOTO 20
          IPC = -ZI(JAD-1+IEL)
          GROUP = ZR(JTABF+ZTABF*(IPC-1)+4)
C --- SI LE POINT D'INTEGRATION N'APPARTIENT PAS � UN GROUPE, ON SORT
          IF (GROUP.EQ.0) GOTO 20
C --- SI LE POINT EST VITAL OU NON CONTACTANT, ON SORT
          IF (ZR(JTABF+ZTABF*(IPC-1)+27).EQ.1) GOTO 20
          IF (ZI(JVALV-1+ADIEL+1).EQ.0) GOTO 20
C
C --- SI LE PT D'INTEG EST SUR UNE ARETE NON VITAL ET DEVIENT CONTACTANT
C --- ON REGARDE SI UN PT SUR L'ARETE VITALE DE CE GROUPE DEVIENT OU
C --- RESTE CONTACTANT
          NARET = NINT(ZR(JTABF+ZTABF*(IPC-1)+5))
          DO 30 IGR2 = 1,NGREL
           DEBGR2 = ZI(JVALD-1+4+IGR2)
            NEL2 = ZI(JVALD-1+DEBGR2+1)
            CALL JEVEUO(JEXNUM(LIGRXF//'.LIEL',IGR2),'L',JAD2)
            DO 40 IEL2 = 1,NEL2
              ADIEL2=ZI(JVALD-1+DEBGR2+4+4*(IEL2-1)+4)
              IPC2 = -ZI(JAD2-1+IEL2)
              IF (ZR(JTABF+ZTABF*(IPC2-1)+4).NE.GROUP) GOTO 40
              IF (ZR(JTABF+ZTABF*(IPC2-1)+27).EQ.0) GOTO 40
C --- LE PT VITAL EST CONTACTANT
              IF (ZI(JVALV-1+ADIEL2+1).EQ.1) GOTO 20
C              CALL ASSERT(ZI(JVALV-1+ADIEL2+2).EQ.0)
C --- ATTENTION,LE PT VITAL EST NON CONTACTNT
              NARET2 = INT(ZR(JTABF+ZTABF*(IPC2-1)+5))
              DO 50 IPC2 = 1,NTPC
C --- ON INTERVERTI LE PT NON VITAL AVEC LE PT VITAL
                IF (ZR(JTABF+ZTABF*(IPC2-1)+4).EQ.GROUP) THEN
                  IF (ZR(JTABF+ZTABF*(IPC2-1)+5).EQ.NARET2) THEN
                    ZR(JTABF+ZTABF*(IPC2-1)+27) = 0
                  ELSEIF (ZR(JTABF+ZTABF*(IPC2-1)+5).EQ.NARET) THEN
                    ZR(JTABF+ZTABF*(IPC2-1)+27) = 1
                  ENDIF
                ENDIF
 50           CONTINUE
              GOTO 20
 40         CONTINUE
 30       CONTINUE
C
 20     CONTINUE
 10   CONTINUE
C
C --- MISE A JOUR DU STATUT DE CONTACT ET DE LA MEMOIRE DE CONTACT,
C --- SINCO = SOMME DES CICOCA SUR LES �LTS DU LIGREL
C
      DO 60 IGR = 1,NGREL
        DEBGR = ZI(JVALD-1+4+IGR)
        NEL = ZI(JVALD-1+DEBGR+1)
        CALL JEVEUO(JEXNUM(LIGRXF//'.LIEL',IGR),'L',JAD)
        DO 70 IEL = 1,NEL
          ADIEL = ZI(JVALD-1+DEBGR+4+4*(IEL-1)+4)
          IPC = -ZI(JAD-1+IEL)
          ZR(JTABF+ZTABF*(IPC-1)+13) = ZI(JVALV-1+ADIEL+1)
          ZR(JTABF+ZTABF*(IPC-1)+28) = ZI(JVALV-1+ADIEL+2)
          SINCO = SINCO + ZI(JVALV-1+ADIEL)
 70     CONTINUE
 60   CONTINUE
C
C
C --- SI SINCO EST STRICTEMENT POSITIF, ON A PAS CONVERG�
C
      IF (SINCO.GT.0) MMCVCA = .FALSE.
C
      CALL JEDEMA()
      END
