      SUBROUTINE INITEL(LIGREL)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*19 LIGREL
C ----------------------------------------------------------------------
C     BUT:
C     INITIALISER LES TYPE_ELEMENTS PRESENTS DANS LE LIGREL (INI00K)
C     CREER (ET REMPLIR) LES OBJETS .PRNM ET/OU .PRNS DU LIGREL.

C     IN:
C     LIGREL : NOM DU LIGREL A INITIALISER

C     OUT:
C       - INITIALISATION DES ELREFE PRESENTS DANS LE LIGREL
C       - CALCUL DES OBJETS : '.PRNM' ET '.PRNS'

C ----------------------------------------------------------------------

C     VARIABLES LOCALES:
C     ------------------
      INTEGER IGR,NGR,IBID,NMAXOB,NBOBJ,IERD,NBPRIN
      INTEGER NBNO,JPRIN,JNOMA,JLIEL,JLLIEL,ICONX1,ICONX2,IER
      INTEGER NUTE,NBEL,NBELEM,IEL,NUMA,NBNOMA,INO,NUNO,TYPELE
      PARAMETER (NMAXOB=30)
      INTEGER ADOBJ(NMAXOB)
      CHARACTER*24 NOOBJ(NMAXOB)
      CHARACTER*1 K1BID,BASE
      CHARACTER*8 EXIELE,MA,PRIN,NOMAIL,RESUCO
      CHARACTER*16 NOMTE,NOMCMD,TYPCON
C ----------------------------------------------------------------------

C DEB-------------------------------------------------------------------

      CALL JEMARQ()
      CALL DISMOI('F','EXI_ELEM',LIGREL,'LIGREL',IBID,EXIELE,IERD)
      IF (EXIELE(1:3).EQ.'OUI') THEN
        CALL JELIRA(LIGREL//'.LIEL','CLAS',IBID,BASE)
      ELSE
C       -- UN LIGREL QUI N'A PAS D'ELEMENTS VIENT FORCEMENT
C          D'UN MODELE QUI DOIT AVOIR DES SOUS-STRUCTURES STATIQUES
        CALL JELIRA(LIGREL//'.SSSA','CLAS',IBID,BASE)
        GO TO 20
      END IF

      CALL JELIRA(LIGREL//'.LIEL','NUTIOC',NGR,K1BID)
      DO 10 IGR = 1,NGR
        CALL INIGRL(LIGREL,IGR,NMAXOB,ADOBJ,NOOBJ,NBOBJ)
   10 CONTINUE
   20 CONTINUE


C     -- CALCUL DE .PRNM ET .PRNS :
      CALL CREPRN(LIGREL,' ',BASE,LIGREL(1:19)//'.PRNM',
     &            LIGREL(1:19)//'.PRNS')




C     -- ON VERIFIE QUE LES ELEMENTS DE "BORD" SONT COLLES AUX
C        ELEMENTS "PRINCIPAUX" (CEUX QUI CALCULENT LA RIGIDITE):
C     ------------------------------------------------------------
      CALL GETRES(RESUCO,TYPCON,NOMCMD)
      IF ((EXIELE(1:3).NE.'OUI') .OR.
     &    (NOMCMD.NE.'AFFE_MODELE')) GO TO 90

      CALL JEVEUO(LIGREL//'.LGRF','L',JNOMA)
      CALL JEVEUO(LIGREL//'.LIEL','L',JLIEL)
      CALL JEVEUO(JEXATR(LIGREL//'.LIEL','LONCUM'),'L',JLLIEL)
      MA = ZK8(JNOMA)
      CALL JEVEUO(MA//'.CONNEX','L',ICONX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ICONX2)
      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNO,K1BID,IER)

C     -- ON COCHE LES NOEUDS PORTES PAR LES ELEMENTS PRINCIPAUX :
      CALL WKVECT('&&INITEL.PRIN','V V I',NBNO,JPRIN)
      DO 50 IGR = 1,NGR
        NUTE = TYPELE(LIGREL,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTE),NOMTE)
        CALL DISMOI('F','CALC_RIGI',NOMTE,'TYPE_ELEM',IBID,PRIN,IER)
        IF (PRIN.NE.'OUI') GO TO 50
        NBEL = NBELEM(LIGREL,IGR)
        DO 40 IEL = 1,NBEL
          NUMA = ZI(JLIEL-1+ZI(JLLIEL+IGR-1)+IEL-1)
          IF (NUMA.LT.0) GO TO 40
          NBNOMA = ZI(ICONX2+NUMA) - ZI(ICONX2+NUMA-1)
          DO 30,INO = 1,NBNOMA
            NUNO = ZI(ICONX1-1+ZI(ICONX2+NUMA-1)+INO-1)
            ZI(JPRIN-1+NUNO) = 1
   30     CONTINUE
   40   CONTINUE
   50 CONTINUE

C     -- ON VERIFIE LES NOEUDS DES ELEMENTS NON-PRINCIPAUX (BORD)
      NBPRIN=0
      DO 80 IGR = 1,NGR
        NUTE = TYPELE(LIGREL,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTE),NOMTE)
        CALL DISMOI('F','CALC_RIGI',NOMTE,'TYPE_ELEM',IBID,PRIN,IER)
        NBEL = NBELEM(LIGREL,IGR)
        IF (PRIN.EQ.'OUI') THEN
          IF  (NBEL.GT.0) NBPRIN=1
          GO TO 80
        END IF
        DO 70 IEL = 1,NBEL
          NUMA = ZI(JLIEL-1+ZI(JLLIEL+IGR-1)+IEL-1)
          IF (NUMA.LT.0) GO TO 70
          NBNOMA = ZI(ICONX2+NUMA) - ZI(ICONX2+NUMA-1)
          DO 60,INO = 1,NBNOMA
            NUNO = ZI(ICONX1-1+ZI(ICONX2+NUMA-1)+INO-1)
            IF (ZI(JPRIN-1+NUNO).NE.1) THEN
              CALL JENUNO(JEXNUM(MA//'.NOMMAI',NUMA),NOMAIL)
              CALL U2MESK('A','CALCULEL2_63',1,NOMAIL)
              GO TO 71
            END IF
   60     CONTINUE
   71   CONTINUE
   70   CONTINUE
   80 CONTINUE

C     -- SI C'EST LE LIGREL DU MODELE, ON VERIFIE QU'IL EXISTE AU MOINS
C        UN ELEMENT PRINCIPAL (QUI CALCULE DE LA RIGIDITE):
      IF (NOMCMD.EQ.'AFFE_MODELE' .AND. RESUCO(1:8).EQ.LIGREL(1:8)) THEN
        IF (NBPRIN.EQ.0) CALL U2MESK('A','CALCULEL2_64',1,RESUCO)

      END IF


      CALL JEDETR('&&INITEL.PRIN')



   90 CONTINUE
      CALL JEDEMA()
      END
