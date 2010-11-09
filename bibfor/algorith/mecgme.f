      SUBROUTINE MECGME(MODELZ,CARELZ,MATE  ,LISCHA,INSTAP,
     &                  DEPMOI,DEPDEL,INSTAM,COMPOR,CARCRI,
     &                  MESUIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*(*) MODELZ,CARELZ
      CHARACTER*(*) MATE
      REAL*8        INSTAP,INSTAM
      CHARACTER*24  COMPOR,CARCRI
      CHARACTER*19  LISCHA
      CHARACTER*19  MESUIV,DEPDEL,DEPMOI
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C CALCUL DES MATRICES ELEMENTAIRES DES CHARGEMENTS MECANIQUES
C DEPENDANT DE LA GEOMETRIE (SUIVEURS)
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE  : NOM DU MODELE
C IN  LISCHA  : SD L_CHARGES
C IN  CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : CHAMP DE MATERIAU
C IN  INSTAP  : INSTANT DU CALCUL
C IN  DEPMOI  : DEPLACEMENT A L'INSTANT MOINS
C IN  DEPDEL  : INCREMENT DE DEPLACEMENT AU COURS DES ITERATIONS
C IN  INSTAM  : INSTANT MOINS
C IN  COMPOR  : COMPORTEMENT
C IN  CARCRI  : CRITERES DE CONVERGENCE (THETA)
C OUT MESUIV  : MATRICES ELEMENTAIRES
C               POSITION 7-8  : NUMERO DE LA CHARGE
C                               VAUT 00 SI PAS DE CHARGE
C               POSITION 12-14: NUMERO DU VECTEUR ELEMENTAIRE / CHARGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=15)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      CHARACTER*24 MODELE,CARELE
      CHARACTER*24 CHARGE,INFCHA
      CHARACTER*8  NOMCHA,K8BID
      CHARACTER*8  AFFCHA
      CHARACTER*16 OPTION,REPVR,REPCT
      CHARACTER*24 CHTIM2
      CHARACTER*24 CHGEOM,CHCARA(18),CHTIME,LIGREL
      CHARACTER*24 LIGRMO,LIGRCH,EVOLCH
      INTEGER      IBID,IRET,IERD,IER,I,K,ICHA,INUM
      INTEGER      SOMME
      LOGICAL      LBID,PREM
      INTEGER      JCHAR,JINF,JLME
      INTEGER      NCHAR,NUMCHM,NBCHME
      COMPLEX*16   C16BID
      INTEGER      IFM,NIV
C
      INTEGER NBCHMX
      PARAMETER (NBCHMX=4)
      INTEGER NBOPT(NBCHMX),TAB(NBCHMX)
      CHARACTER*6 NOMLIG(NBCHMX),NOMPAF(NBCHMX),NOMOPF(NBCHMX)
      CHARACTER*6 NOMPAR(NBCHMX),NOMOPR(NBCHMX)
      DATA NOMLIG/'.ROTAT','.PESAN','.PRESS','.FCO3D'/
      DATA NOMOPF/'??????','??????','PRSU_F','SFCO3D'/
      DATA NOMPAF/'??????','??????','PRESSF','FFCO3D'/
      DATA NOMOPR/'RO    ','THMG  ','PRSU_R','SRCO3D'/
      DATA NOMPAR/'ROTATR','PESANR','PRESSR','FRCO3D'/
      DATA NBOPT/9,15,9,15/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      MODELE = MODELZ
      CARELE = CARELZ
      LIGRMO = MODELE(1:8)//'.MODELE'
      CHARGE = LISCHA(1:19)//'.LCHA'
      INFCHA = LISCHA(1:19)//'.INFC'
      CHTIME = '&&MECHME.CH_INST_R'
      CHTIM2 = '&&MECHME.CH_INST_M'
      CALL DISMOI('F','EXI_THM_CT',MODELE,'MODELE',IBID,REPCT,IERD)
      CALL DISMOI('F','EXI_THM_VR',MODELE,'MODELE',IBID,REPVR,IERD)
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)
C
C --- ACCES AUX CHARGEMENTS
C
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.EQ.0) THEN
        NCHAR = 0
        GOTO 60
      ELSE
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
        CALL JEVEUO(CHARGE,'L',JCHAR)
        CALL JEVEUO(INFCHA,'L',JINF)
      ENDIF
C
C --- PREPARATION DES MATR_ELEM
C
      CALL JEEXIN(MESUIV//'.RELR',IRET)
      IF (IRET.EQ.0) THEN
        CALL MEMARE('V',MESUIV,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        CALL REAJRE(MESUIV,' ','V')
        PREM   = .TRUE.
      ELSE
        PREM   = .FALSE.
        CALL JELIRA(MESUIV//'.RELR','LONUTI',NBCHME,K8BID)
        IF(NBCHME.GT.0)CALL JEVEUO(MESUIV//'.RELR','L',JLME)
      END IF
C
C --- CHAMP DE GEOMETRIE
C
      CALL MEGEOM(MODELE(1:8),ZK24(JCHAR) (1:8),LBID  ,CHGEOM)
C
C --- CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C
      CALL MECARA(CARELE(1:8),LBID  ,CHCARA)
C
C --- CHAMP POUR LES INSTANTS
C
      CALL MECACT('V'   ,CHTIME   ,'MODELE',LIGRMO,'INST_R  ',
     &            1     ,'INST   ',IBID    ,INSTAP,C16BID    ,
     &            K8BID)
      CALL MECACT('V'   ,CHTIM2   ,'MODELE',LIGRMO,'INST_R  ',
     &            1     ,'INST   ',IBID    ,INSTAM,C16BID    ,
     &            K8BID)
C
C --- REMPLISSAGE DES CHAMPS
C
      LPAIN(2)  = 'PGEOMER'
      LCHIN(2)  = CHGEOM(1:19)
      LPAIN(3)  = 'PTEMPSR'
      LCHIN(3)  = CHTIME(1:19)
      LPAIN(4)  = 'PMATERC'
      LCHIN(4)  = MATE(1:19)
      LPAIN(5)  = 'PCACOQU'
      LCHIN(5)  = CHCARA(7)(1:19)
      LPAIN(6)  = 'PCAGNPO'
      LCHIN(6)  = CHCARA(6)(1:19)
      LPAIN(7)  = 'PCADISM'
      LCHIN(7)  = CHCARA(3)(1:19)
      LPAIN(8)  = 'PDEPLMR'
      LCHIN(8)  = DEPMOI
      LPAIN(9)  = 'PDEPLPR'
      LCHIN(9)  = DEPDEL
      LPAIN(10) = 'PCAORIE'
      LCHIN(10) = CHCARA(1)(1:19)
      LPAIN(11) = 'PCACABL'
      LCHIN(11) = CHCARA(10)(1:19)
      LPAIN(12) = 'PCARCRI'
      LCHIN(12) = CARCRI(1:19)
      LPAIN(13) = 'PINSTMR'
      LCHIN(13) = CHTIM2(1:19)
      LPAIN(14) = 'PCOMPOR'
      LCHIN(14) = COMPOR(1:19)
      LPAIN(15) = 'PINSTPR'
      LCHIN(15) = CHTIME(1:19)
C
C --- CHAMP DE SORTIE
C
      IF (REPVR(1:3).EQ.'OUI') THEN
        LPAOUT(1) = 'PMATUNS'
      ELSE
        LPAOUT(1) = 'PMATUUR'
      ENDIF
C
      IF (PREM) THEN
        DO 30 ICHA = 1,NCHAR
          INUM = 0
          LCHOUT(1) = MESUIV(1:8)//'. '
          NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
          LIGRCH = NOMCHA//'.CHME.LIGRE'
          NUMCHM = ZI(JINF+NCHAR+ICHA)
          CALL DISMOI('F','TYPE_CHARGE',ZK24(JCHAR+ICHA-1),'CHARGE',
     &                IBID,AFFCHA,IERD)

          IF (NUMCHM.EQ.4) THEN

C ---- BOUCLES SUR LES TOUS LES TYPES DE CHARGE POSSIBLES SAUF LAPLACE)
            SOMME = 0
            LIGREL = LIGRMO
            DO 20 K = 1,NBCHMX
              LCHIN(1) = LIGRCH(1:13)//NOMLIG(K)//'.DESC'
              CALL EXISD('CHAMP_GD',LCHIN(1),IRET)
              TAB(K) = IRET

              IF (IRET.NE.0) THEN

                IF ((K.NE.2) .OR. ((REPCT(1:3).EQ.'OUI').OR. (REPVR(1:
     &              3).EQ.'OUI'))) THEN
                  IF (AFFCHA(5:7).EQ.'_FO') THEN
                    OPTION = 'RIGI_MECA_'//NOMOPF(K)
                    LPAIN(1) = 'P'//NOMPAF(K)
                  ELSE
                    OPTION = 'RIGI_MECA_'//NOMOPR(K)
                    LPAIN(1) = 'P'//NOMPAR(K)
                  END IF
                  LCHOUT(1) (10:10) = 'G'
                  INUM = INUM + 1
                  CALL CODENT(ICHA,'D0',LCHOUT(1) (7:8))
                  CALL CODENT(INUM,'D0',LCHOUT(1) (12:14))

C               POUR UNE MATRICE NON SYMETRIQUE EN COQUE3D (VOIR TE0486)
                  IF (K.EQ.4) LPAOUT(1) = 'PMATUNS'

                  CALL CALCUL('S',OPTION,LIGREL,NBOPT(K),LCHIN,LPAIN,1,
     &                        LCHOUT,LPAOUT,'V','OUI')
                  CALL REAJRE(MESUIV, LCHOUT(1),'V')
                END IF
              END IF
              EVOLCH= NOMCHA//'.CHME.EVOL.CHAR'
              CALL JEEXIN(EVOLCH,IER)
              IF((TAB(K).EQ.1).OR.(IER.GT.0)) THEN
                SOMME = SOMME + 1
              ENDIF
   20       CONTINUE
            IF (SOMME.EQ.0) THEN
              CALL U2MESS('F','MECANONLINE2_4')
             ENDIF
          END IF
   30   CONTINUE
      ELSE

C ----- LES MATR_ELEM EXISTENT DEJA, ON REGARDE S'ILS DEPENDENT DE
C ----- LA GEOMETRIE

        LIGREL = LIGRMO

        DO 50 I = 1,NBCHME
          IF (ZK24(JLME-1+I) (10:10).EQ.'G') THEN
            CALL LXLIIS(ZK24(JLME-1+I) (7:8),ICHA,IER)
            NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
            LIGRCH = NOMCHA//'.CHME.LIGRE'

C ---- BOUCLES SUR LES TOUS LES TYPES DE CHARGE POSSIBLES SAUF LAPLACE

            CALL DISMOI('F','TYPE_CHARGE',ZK24(JCHAR+ICHA-1),'CHARGE',
     &                  IBID,AFFCHA,IERD)
            DO 40 K = 1,NBCHMX
              LCHIN(1) = LIGRCH(1:13)//NOMLIG(K)//'.DESC'
              CALL EXISD('CHAMP_GD',LCHIN(1),IRET)
              IF (IRET.NE.0) THEN
                IF ((K.NE.2) .OR. ((REPCT(1:3).EQ.'OUI').OR. (REPVR(1:
     &              3).EQ.'OUI'))) THEN
                  LCHOUT(1) = ZK24(JLME-1+I)(1:19)
                  IF (AFFCHA(5:7).EQ.'_FO') THEN
                    OPTION = 'RIGI_MECA_'//NOMOPF(K)
                    LPAIN(1) = 'P'//NOMPAF(K)
                  ELSE
                    OPTION = 'RIGI_MECA_'//NOMOPR(K)
                    LPAIN(1) = 'P'//NOMPAR(K)
                  END IF
C               POUR UNE MATRICE NON SYMETRIQUE EN COQUE3D (VOIR TE0486)
                  IF (K.EQ.4) LPAOUT(1) = 'PMATUNS'

                  CALL CALCUL('S',OPTION,LIGREL,NBOPT(K),LCHIN,LPAIN,1,
     &                        LCHOUT,LPAOUT,'V','OUI')
                END IF
              END IF
   40       CONTINUE
          END IF
   50   CONTINUE
      END IF

      CALL JELIRA(MESUIV//'.RELR','LONUTI',NBCHME,K8BID)


   60 CONTINUE
C
      CALL JEDEMA()
      END
