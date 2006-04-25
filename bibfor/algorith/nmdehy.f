      SUBROUTINE NMDEHY(MODELE,LISCHA,INSTAN,SECMOI,EXISEC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/04/2006   AUTEUR CIBHHPD L.SALMONA 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      LOGICAL EXISEC
      CHARACTER*19 LISCHA
      CHARACTER*19 SECMOI
      CHARACTER*8 MODELE
      REAL*8 INSTAN
C ----------------------------------------------------------------------
C     DETERMINATION DES CHAMPS DE SECHAGE ET D HYDRATATION

C IN        MODELE  K8   NOM DU MODELE
C IN        LISCHA  K19  SD L_CHARGES
C IN        INSTAN  R8   INSTANT DE LA DETERMINATION
C IN/JXOUT  SECMOI  K19  SECHAGE
C OUT       EXISEC   L   TRUE SI SECHAGE N'EST PAS PAR DEFAUT
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER NCHAR,IRET,NUMCH1,JSECH,IBID
      CHARACTER*1 BASE
      CHARACTER*8 CHHYDR,CHSECH,K8BID,NOMA
      CHARACTER*8 LPAIN(1),LPAOUT(1)
      CHARACTER*16 TYSD
      CHARACTER*19 CH19
      CHARACTER*24 NOM24,LIGRMO,LCHIN(1),LCHOUT(1),CHGEOM,OPTION
      COMPLEX*16 CBID

      CALL JEMARQ()
      BASE = 'V'
      EXISEC = .FALSE.
      NUMCH1 = 0
      LIGRMO = MODELE//'.MODELE'
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IRET)

      CALL JEEXIN(LISCHA//'.LCHA',IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(LISCHA//'.LCHA','LONMAX',NCHAR,K8BID)
        CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)

        CALL JEVEUO(LISCHA//'.INFC','L',JINF)
        NUMCH1 = ZI(JINF+4*NCHAR+6)
      END IF


C CHAMP SECHAGE
C -------------

      IF (NUMCH1.GT.0) THEN
        NOM24 = ZK24(JCHAR+NUMCH1-1) (1:8)//'.CHME.EVOL.SECH'
        CALL JEVEUO(NOM24,'L',JSECH)
        CHSECH = ZK8(JSECH)

C ----- SI LE CHAMP CHSECH EXISTE DEJA , ON LE DETRUIT:

        CALL DETRSD('CHAMP_GD',SECMOI)

        CALL GETTCO(CHSECH,TYSD)
        IF (TYSD(1:9).EQ.'EVOL_THER') THEN
          CALL DISMOI('F','NB_CHAMP_UTI',CHSECH,'RESULTAT',NBCHAM,K8BID,
     &                IERD)
          IF (NBCHAM.GT.0) THEN
            TIME = INSTAN

C --------- RECUPERATION DU CHAMP SECHAGE DANS CHSECH

            CALL RSINCH(CHSECH,'TEMP','INST',TIME,SECMOI,'CONSTANT',
     &                  'CONSTANT',1,BASE,ICORET)
            IF (ICORET.GE.10) THEN
              CALL UTDEBM('F','NMDEHY_04','INTERPOLATION SECHATATION:')
              CALL UTIMPK('L','EVOL_THER:',1,CHSECH)
              CALL UTIMPR('S','INSTANT:',1,TIME2)
              CALL UTIMPI('L','ICORET:',1,ICORET)
              CALL UTFINM()
            END IF
            EXISEC = .TRUE.
          ELSE
            CALL UTMESS('F','NMDEHY_05',' LE CONCEPT EVOL_THER : '//
     &                  CHSECH//' NE CONTIENT AUCUN CHAMP SECHAGE')
          END IF

         ELSE IF ((TYSD(1:8).EQ.'CHAM_NO_') .OR.
     +            (TYSD(1:6).EQ.'CARTE_') .OR.
     +            (TYSD(1:10).EQ.'CHAM_ELEM_')) THEN
C
          CH19 = CHSECH
          CALL COPISD('CHAMP_GD','V',CH19,SECMOI)
          EXISEC = .TRUE.

        ELSE
          CALL UTMESS('F','NMDEHY_06','ERREUR DE TYPE SUR LA CHARGE '//
     &                'SECHAGE '//CHSECH)
        END IF
      ELSE

C IL N'Y A PAS DE CHARGES SECHAGES
C CREATION D'UNE CARTE CONSTANTE AFFECTEE A 0.D0

        CALL MECACT('V',SECMOI,'MODELE',LIGRMO,'TEMP_R',1,'TEMP',IBID,
     &              0.0D0,CBID,K8BID)
      END IF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
