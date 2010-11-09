      SUBROUTINE PASCOU(MATE  ,CARELE,SDDYNA,SDDISC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*24   MATE,CARELE
      CHARACTER*19   SDDYNA,SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE DYNA_NON_LINE (UTILITAIRE)
C
C EVALUATION DU PAS DE TEMPS DE COURANT POUR LE MODELE
C
C ----------------------------------------------------------------------
C
C
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C IN  SDDISC : SD DISCRETISATION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32 JEXNUM
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER   IBID,JCESD,JCESL,JCESV,N1,I,IRET
      INTEGER   NBMA,IMA,IAD,JINST,NBINST,NBMCFL
      REAL*8    DTCOU,VALEUR,PHI,NDYNRE,R8B
      LOGICAL   EXIGEO,BOONEG,BOOPOS,EXICAR,NDYNLO
      CHARACTER*6 NOMPRO
      CHARACTER*8  K8BID,MO,LPAIN(3),LPAOUT(1),STOCFL,MAICFL,MAIL
      CHARACTER*19 CHAMS
      CHARACTER*24 CHGEOM,LIGREL,LCHIN(3),LCHOUT(1),CHCARA(18)
C
C ---------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NOMPRO ='OP0070'

      CALL GETVID(' ','MODELE',1,1,1,MO,IBID)

      LIGREL=MO//'.MODELE'

      LPAIN(1)='PMATERC'
      LCHIN(1)=MATE

C --- RECUPERATION DU CHAMP GEOMETRIQUE
      CALL MEGEOM(MO,' ',EXIGEO,CHGEOM)

      LPAIN(2)='PGEOMER'
      LCHIN(2)=CHGEOM

C --- CHAMP DE CARACTERISTIQUES ELEMENTAIRES
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)

      IF ( EXICAR ) THEN
        LPAIN(3)='PCACOQU'
        LCHIN(3)=CHCARA(7)
      ENDIF

      LPAOUT(1)='PCOURAN'
      LCHOUT(1)='&&'//NOMPRO//'.PAS_COURANT'

      CALL CALCUL('S','PAS_COURANT',LIGREL,3,LCHIN,LPAIN,
     &             1,LCHOUT,LPAOUT,'V','OUI')

C     PASSAGE D'UN CHAM_ELEM EN UN CHAM_ELEM_S
      CHAMS ='&&'//NOMPRO//'.CHAMS'

      CALL CELCES (LCHOUT(1),'V',CHAMS)

      CALL JEVEUO(CHAMS//'.CESD','L',JCESD)

      CALL JELIRA(MO//'.MAILLE','LONMAX',NBMA,K8BID)
      CALL JEVEUO(CHAMS//'.CESL','L',JCESL)
      CALL JEVEUO(CHAMS//'.CESV','L',JCESV)

C     INITIALISATION DE DTCOU

      DTCOU = -1.D0

C A L'ISSUE DE LA BOUCLE :
C BOONEG=TRUE SI L'ON N'A PAS PU CALCULER DTCOU POUR AU MOINS UN ELMNT
C BOOPOS=TRUE SI L'ON A CALCULE DTCOU POUR AU MOINS UN ELEMENT
      BOONEG = .FALSE.
      BOOPOS = .FALSE.
      NBMCFL = 1
      DO 10,IMA = 1,NBMA
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
        IF (IAD.GT.0) THEN
          VALEUR = ZR(JCESV-1+IAD)
        ELSEIF (IAD.EQ.0) THEN
          GOTO 10
        ENDIF
        IF (VALEUR.LT.0) THEN
          BOONEG = .TRUE.
        ELSE
          BOOPOS = .TRUE.
          IF (DTCOU.GT.0) THEN
            IF (VALEUR.LE.DTCOU) THEN
              DTCOU = VALEUR
              NBMCFL = IMA
            ENDIF
          ELSE
            DTCOU = VALEUR
          ENDIF
        ENDIF
 10   CONTINUE

      CALL GETVTX('SCHEMA_TEMPS','STOP_CFL',1,1,1,STOCFL,N1)

C BOOPOS=TRUE SI L'ON A CALCULE DTCOU POUR AU MOINS UN ELEMENT
      IF (BOOPOS) THEN
        IF (BOONEG) THEN
          CALL U2MESS('A','DYNAMIQUE_3')
        ENDIF

C       VERIFICATION DE LA CONFORMITE DE LA LISTE D'INSTANTS
        CALL UTDIDT('L',SDDISC,'LIST',IBID,'NBINST',R8B,NBINST,K8BID)
        CALL JEVEUO(SDDISC//'.DITR','L',JINST)

        CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MAIL,IRET)
        CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',NBMCFL),MAICFL)


        IF (NDYNLO(SDDYNA,'DIFF_CENT')) THEN
          DTCOU = DTCOU / (2.D0)
          CALL U2MESG('I','DYNAMIQUE_5',1,MAICFL,0,0,1,DTCOU)
        ELSE
          IF (NDYNLO(SDDYNA,'TCHAMWA')) THEN
            PHI=NDYNRE(SDDYNA,'PHI')
            DTCOU = DTCOU/(PHI*2.D0)
            CALL U2MESG('I','DYNAMIQUE_6',1,MAICFL,0,0,1,DTCOU)
          ELSE
            CALL U2MESS('F','DYNAMIQUE_1')
          ENDIF
        ENDIF

        DO 20 I=1,NBINST-1
          IF (ZR(JINST-1+I+1)-ZR(JINST-1+I).GT.DTCOU) THEN
            IF (STOCFL(1:3).EQ.'OUI') THEN
              CALL U2MESS('F','DYNAMIQUE_2')
            ELSE
              CALL U2MESS('A','DYNAMIQUE_2')
            ENDIF
          ENDIF
 20     CONTINUE

      ELSEIF (STOCFL(1:3).EQ.'OUI') THEN
        CALL U2MESS('F','DYNAMIQUE_4')
      ELSEIF (STOCFL(1:3).EQ.'NON') THEN
        CALL U2MESS('A','DYNAMIQUE_4')
      ENDIF

      CALL JEDEMA()

      END
