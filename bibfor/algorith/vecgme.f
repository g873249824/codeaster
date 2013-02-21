      SUBROUTINE VECGME(MODELE,CARELE,MATE,CHARGE,INFCHA,
     &                  INSTAP,DEPMOZ,DEPDEZ,VECELZ,INSTAM,
     &                  COMPOR,CARCRI,LIGREZ,VITEZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) MATE,LIGREZ,VECELZ,DEPMOZ,DEPDEZ,VITEZ
      CHARACTER*19 VECELE
      CHARACTER*24 MODELE,CARELE,CHARGE,INFCHA,COMPOR,
     &             CARCRI
      REAL*8 INSTAP,INSTAM
C ----------------------------------------------------------------------
C     CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
C     DEPENDANT DE
C          LA GEOMETRIE
C          LA VITESSE
C          L'ACCELARATION
C     PRODUIT UN VECT_ELEM DEVANT ETRE ASSEMBLE PAR LA ROUTINE ASASVE

C IN  MODELE  : NOM DU MODELE
C IN  CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : NOM DU MATERIAU
C IN  CHARGE  : LISTE DES CHARGES
C IN  INFCHA  : INFORMATIONS SUR LES CHARGEMENTS
C IN  INSTAP  : INSTANT DU CALCUL
C IN  DEPMOI  : DEPLACEMENT A L'INSTANT TEMMOI
C IN  DEPDEL  : INCREMENT DE DEPLACEMENT AU COURS DES ITERATIONS
C IN  INSTAM  : INSTANT MOINS
C IN  COMPOR  : COMPORTEMENT
C IN  CARCRI  : CRITERES DE CONVERGENCE (THETA)
C IN  LIGREZ  : (SOUS-)LIGREL DE MODELE POUR CALCUL REDUIT
C                  SI ' ', ON PREND LE LIGREL DU MODELE
C VAR/JXOUT  VECELZ  : VECT_ELEM RESULTAT.
C ----------------------------------------------------------------------

      CHARACTER*5 SUFFIX
      CHARACTER*8 NOMCHA,LPAIN(15),PAOUT,K8BID,AFFCHA,KBID,NEWNOM
      CHARACTER*16 OPTION
      CHARACTER*24 CHGEOM,CHCARA(18),CHTIME,LIGREL,LIGRMO
      CHARACTER*24 LCHIN(15),CHTIM2,LIGRCH,EVOLCH
      CHARACTER*19 RESUEL,RESUFV(1),DEPMOI,DEPDEL,VITES
      INTEGER IBID,IRET,NCHAR,ILVE,JCHAR,JINF,K,ICHA,NUMCHM
      INTEGER IERD,JLCHIN,IER
      LOGICAL EXICAR,BIDON
      COMPLEX*16 CBID
      INTEGER NBCHMX,II,SOMME
      PARAMETER (NBCHMX=6)
      INTEGER NBOPT(NBCHMX),TAB(NBCHMX)
      CHARACTER*6 NOMLIG(NBCHMX),NOMPAF(NBCHMX),NOMPAR(NBCHMX)
      CHARACTER*6 NOMOPF(NBCHMX),NOMOPR(NBCHMX)

      DATA NOMLIG/'.F1D1D','.PESAN','.ROTAT','.PRESS','.VEASS','.FCO3D'/
      DATA NOMOPR/'SR1D1D','PESA_R','ROTA_R','PRSU_R','      ','SRCO3D'/
      DATA NOMOPF/'SF1D1D','??????','??????','PRSU_F','      ','SFCO3D'/
      DATA NOMPAR/'FR1D1D','PESANR','ROTATR','PRESSR','      ','FRCO3D'/
      DATA NOMPAF/'FF1D1D','??????','??????','PRESSF','      ','FFCO3D'/
      DATA NBOPT/10,15,10,9,0,9/
C     ------------------------------------------------------------------

      CALL JEMARQ()
      NEWNOM = '.0000000'


      VECELE = VECELZ
      IF (VECELE.EQ.' ') VECELE = '&&VEMSUI           '
      RESUEL = '&&VECGME.???????'
      DEPMOI = DEPMOZ
      DEPDEL = DEPDEZ
      VITES  = VITEZ

      BIDON = .TRUE.
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
        IF (NCHAR.NE.0) THEN
          CALL JEVEUO(CHARGE,'L',JCHAR)
          CALL JEVEUO(INFCHA,'L',JINF)
          DO 10 K = 1,NCHAR
            IF (ZI(JINF+NCHAR+K).EQ.4) BIDON = .FALSE.
   10     CONTINUE
        END IF
      END IF

C     -- ALLOCATION DU VECT_ELEM RESULTAT :
C     -------------------------------------
      CALL DETRSD('VECT_ELEM',VECELE)
      CALL MEMARE('V',VECELE,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
      CALL REAJRE(VECELE,' ','V')
      IF (BIDON) GO TO 60

      LIGRMO = LIGREZ
      IF (LIGRMO.EQ.' ') LIGRMO = MODELE(1:8)//'.MODELE'
      LIGREL = LIGRMO

      CALL MEGEOM(MODELE(1:8),CHGEOM)
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)

      CHTIME = '&&VECHME.CH_INST_R'
      CALL MECACT('V',CHTIME,'LIGREL',LIGREL,'INST_R  ',1,'INST   ',
     &            IBID,INSTAP,CBID,KBID)
      CHTIM2 = '&&VECHME.CH_INST_M'
      CALL MECACT('V',CHTIM2,'LIGREL',LIGREL,'INST_R  ',1,'INST   ',
     &            IBID,INSTAM,CBID,KBID)

      LPAIN(2) = 'PGEOMER'
      LCHIN(2) = CHGEOM
      LPAIN(3) = 'PTEMPSR'
      LCHIN(3) = CHTIME
      LPAIN(4) = 'PMATERC'
      LCHIN(4) = MATE
      LPAIN(5) = 'PCACOQU'
      LCHIN(5) = CHCARA(7)
      LPAIN(6) = 'PCAGNPO'
      LCHIN(6) = CHCARA(6)
      LPAIN(7) = 'PCADISM'
      LCHIN(7) = CHCARA(3)
      LPAIN(8) = 'PDEPLMR'
      LCHIN(8) = DEPMOI
      LPAIN(9) = 'PDEPLPR'
      LCHIN(9) = DEPDEL
      LPAIN(10) = 'PCAORIE'
      LCHIN(10) = CHCARA(1)
      LPAIN(11) = 'PCACABL'
      LCHIN(11) = CHCARA(10)
      LPAIN(12) = 'PCARCRI'
      LCHIN(12) = CARCRI
      LPAIN(13) = 'PINSTMR'
      LCHIN(13) = CHTIM2
      LPAIN(15) = 'PINSTPR'
      LCHIN(15) = CHTIME
      LPAIN(14) = 'PCOMPOR'
      LCHIN(14) = COMPOR
      PAOUT = 'PVECTUR'

      ILVE = 0
      DO 50 ICHA = 1,NCHAR
        NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
        LIGRCH = NOMCHA//'.CHME.LIGRE'
        NUMCHM = ZI(JINF+NCHAR+ICHA)
        CALL DISMOI('F','TYPE_CHARGE',ZK24(JCHAR+ICHA-1),'CHARGE',IBID,
     &              AFFCHA,IERD)

        IF (NUMCHM.EQ.4) THEN
          SOMME = 0

          DO 20 K = 1,NBCHMX
            IF (NOMLIG(K).EQ.'.FORNO') THEN
              LIGREL = LIGRCH
            ELSE
              LIGREL = LIGRMO
            END IF

            IF (NOMLIG(K).EQ.'.VEASS') THEN
              SUFFIX = '     '
            ELSE
              SUFFIX = '.DESC'
            END IF
            LCHIN(1) = NOMCHA//'.CHME'//NOMLIG(K)//SUFFIX
            CALL EXISD('CHAMP_GD',LCHIN(1),IRET)
            TAB(K)=IRET
            IF (IRET.NE.0) THEN
              IF (AFFCHA(5:7).EQ.'_FO') THEN
                OPTION = 'CHAR_MECA_'//NOMOPF(K)
                LPAIN(1) = 'P'//NOMPAF(K)
              ELSE
                OPTION = 'CHAR_MECA_'//NOMOPR(K)
                LPAIN(1) = 'P'//NOMPAR(K)
              END IF

              CALL GCNCO2(NEWNOM)
              RESUEL(10:16) = NEWNOM(2:8)
              CALL CORICH('E',RESUEL,ICHA,IBID)

              IF (NOMLIG(K).EQ.'.VEASS') THEN
                CALL JEVEUO(LCHIN(1),'L',JLCHIN)
                CALL COPISD('CHAMP_GD','V',ZK8(JLCHIN),RESUEL)
              ELSE
                CALL CALCUL('S',OPTION,LIGREL,NBOPT(K),LCHIN,LPAIN,1,
     &                      RESUEL,PAOUT,'V','OUI')
              END IF
              ILVE = ILVE + 1
              CALL REAJRE(VECELE,RESUEL,'V')
            END IF
            EVOLCH= NOMCHA//'.CHME.EVOL.CHAR'
            CALL JEEXIN(EVOLCH,IER)
            IF((TAB(K).EQ.1).OR.(IER.GT.0)) THEN
               SOMME = SOMME + 1
            ENDIF
   20     CONTINUE
          IF (SOMME.EQ.0) THEN
             CALL U2MESS('F','MECANONLINE2_4')
          ENDIF
        END IF
C       --TRAITEMENT DE AFFE_CHAR_MECA/EVOL_CHAR
C       ----------------------------------------
C       RESULTATS POSSIBLES
C          1 - VITESSE
        DO 30 II = 1,1
          RESUFV(II) = RESUEL
          CALL GCNCO2(NEWNOM)
          RESUFV(II) (10:16) = NEWNOM(2:8)
   30   CONTINUE
        CALL NMVGME(MODELE,LIGREL,CARELE,CHARGE,ICHA,INSTAP,RESUFV,
     &              DEPMOI,DEPDEL,VITES)
        DO 40 II = 1,1
          CALL REAJRE(VECELE,RESUFV(II),'V')
   40   CONTINUE

   50 CONTINUE

   60 CONTINUE

      VECELZ = VECELE//'.RELR'
      CALL JEDEMA()
      END
