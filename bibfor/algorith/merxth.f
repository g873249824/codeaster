      SUBROUTINE MERXTH(MODELE,CHARGE,INFCHA,CARELE,MATE,INST,CHTNI,
     &                  MERIGI,COMPOR,TMPCHI,TMPCHF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 MODELE,CHARGE,INFCHA,CARELE,INST,CHTNI,MERIGI,MATE,
     &             COMPOR,TMPCHI,TMPCHF
C ----------------------------------------------------------------------
C CALCUL DES MATRICES TANGENTES ELEMENTAIRES
C EN THERMIQUE NON LINEAIRE
C  - TERMES DE VOLUME
C  - TERMES DE SURFACE DUS AUX CONDITIONS LIMITES ET CHARGEMENTS

C IN  MODELE  : NOM DU MODELE
C IN  CHARGE  : LISTE DES CHARGES
C IN  INFCHA  : INFORMATIONS SUR LES CHARGEMENTS
C IN  CARELE  : CHAMP DE CARA_ELEM
C IN  MATE    : MATERIAU CODE
C IN  INST    : CARTE CONTENANT LA VALEUR DE L'INSTANT
C IN  CHTNI   : IEME ITEREE DU CHAMP DE TEMPERATURE
C IN  COMPOR  : COMPORTEMENT (POUR LE SECHAGE)
C IN  TMPCHI  : CHAMP DE TEMPERAT. A T    (POUR LE CALCUL DE D-SECHAGE)
C IN  TMPCHI  : CHAMP DE TEMPERAT. A T+DT (POUR LE CALCUL DE D-SECHAGE)
C OUT MERIGI  : MATRICES ELEMENTAIRES



      CHARACTER*8 NOMCHA,LPAIN(10),LPAOUT(1),K8BID
      CHARACTER*16 OPTION
      CHARACTER*24 LIGREL(2),LCHIN(10),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(18)
      INTEGER IRET,NCHAR,ILIRES,ICHA,JCHAR,JINF
      LOGICAL EXICAR,EXIGEO
C ----------------------------------------------------------------------
      INTEGER NBCHMX
      PARAMETER (NBCHMX=5)
      INTEGER NLIGR(NBCHMX),K
      CHARACTER*6 NOMOPR(NBCHMX),NOMOPF(NBCHMX),NOMCHP(NBCHMX)
      CHARACTER*7 NOMPAR(NBCHMX),NOMPAF(NBCHMX)
      DATA NOMCHP/'.COEFH','.FLUNL','.SOUNL','.RAYO','.HECHP'/
      DATA NOMOPR/'COEF_R','      ','      ','RAYO_R','PARO_R'/
      DATA NOMOPF/'COEF_F','FLUXNL','SOURNL','RAYO_F','PARO_F'/
      DATA NOMPAR/'PCOEFHR','       ','       ','PRAYONR','PHECHPR'/
      DATA NOMPAF/'PCOEFHF','PFLUXNL','PSOURNL','PRAYONF','PHECHPF'/
      DATA NLIGR/1,1,1,1,2/
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
        CALL JEVEUO(CHARGE,'L',JCHAR)
      ELSE
        NCHAR = 0
      END IF

      CALL MEGEOM(MODELE,'       ',EXIGEO,CHGEOM)
      CALL MECARA(CARELE,EXICAR,CHCARA)

      CALL JEEXIN(MERIGI,IRET)
      IF (IRET.EQ.0) THEN
        MERIGI = '&&METRIG           .RELR'
        CALL MEMARE('V',MERIGI,MODELE(1:8),MATE,CARELE,'MTAN_THER')
      ELSE
        CALL JEDETR(MERIGI)
      END IF

      LIGREL(1) = MODELE(1:8)//'.MODELE'

      ILIRES = 0

      IF (MODELE.NE.' ') THEN
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PMATERC'
        LCHIN(2) = MATE
        LPAIN(3) = 'PTEMPSR'
        LCHIN(3) = INST
        LPAIN(4) = 'PTEMPEI'
        LCHIN(4) = CHTNI
        LPAIN(5) = 'PCOMPOR'
        LCHIN(5) = COMPOR
        LPAIN(6) = 'PTMPCHI'
        LCHIN(6) = TMPCHI
        LPAIN(7) = 'PTMPCHF'
        LCHIN(7) = TMPCHF
        LPAIN(8) = 'PVARCPR'
        LCHIN(8) = '&&NXACMV.CHVARC'

        LPAOUT(1) = 'PMATTTR'
        LCHOUT(1) = MERIGI(1:8)//'.ME001'
        OPTION = 'MTAN_RIGI_MASS'
        ILIRES = ILIRES + 1
        CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
        CALL CALCUL('S',OPTION,LIGREL(1),8,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V','OUI')
        CALL REAJRE(MERIGI,LCHOUT(1),'V')
      END IF

      IF (NCHAR.GT.0) THEN
        CALL JEVEUO(INFCHA,'L',JINF)
        DO 20 ICHA = 1,NCHAR
          IF (ZI(JINF+NCHAR+ICHA).GT.0) THEN
            NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
            LIGREL(2) = NOMCHA//'.CHTH.LIGRE'
            LPAIN(1) = 'PGEOMER'
            LCHIN(1) = CHGEOM
            LPAIN(3) = 'PTEMPSR'
            LCHIN(3) = INST
            LPAIN(4) = 'PTEMPEI'
            LCHIN(4) = CHTNI
            LPAIN(5) = 'PVARCPR'
            LCHIN(5) = '&&NXACMV.CHVARC'

            LPAOUT(1) = 'PMATTTR'
            LCHOUT(1) = MERIGI(1:8)//'.ME001'

            DO 10 K = 1,NBCHMX
              LCHIN(2) = ZK24(JCHAR+ICHA-1) (1:8)//'.CHTH'//NOMCHP(K)//
     &                   '.DESC'
              CALL JEEXIN(LCHIN(2),IRET)
              IF (IRET.GT.0) THEN
                IF (ZI(JINF+NCHAR+ICHA).EQ.1) THEN
                  OPTION = 'MTAN_THER_'//NOMOPR(K)
                  LPAIN(2) = NOMPAR(K)
                ELSE IF (ZI(JINF+NCHAR+ICHA).EQ.2 .OR.
     &                   ZI(JINF+NCHAR+ICHA).EQ.3) THEN
                  OPTION = 'MTAN_THER_'//NOMOPF(K)
                  LPAIN(2) = NOMPAF(K)
                END IF
                ILIRES = ILIRES + 1
                CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
                CALL CALCUL('S',OPTION,LIGREL(NLIGR(K)),5,LCHIN,
     &                      LPAIN,1,LCHOUT,LPAOUT,'V','OUI')
                CALL REAJRE(MERIGI,LCHOUT(1),'V')
              END IF
   10       CONTINUE
          END IF

   20   CONTINUE

      END IF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
