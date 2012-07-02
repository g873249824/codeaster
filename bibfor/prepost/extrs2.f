      SUBROUTINE EXTRS2 ( RESU0, RESU1, TYPCON,
     &                    LREST, MAILLA, MODELE,
     &                    NBORDR, NUORDR, NBACC, NOMACC,
     &                    NBARCH, NUARCH, NBEXCL, CHEXCL, NBNOSY )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER NBORDR,NUORDR(*),NBARCH,NBACC,NUARCH(*),NBEXCL,NBNOSY
      CHARACTER*16 NOMACC(*),CHEXCL(*)
      CHARACTER*(*) RESU0, RESU1
      CHARACTER*16 TYPCON
      CHARACTER*8 MAILLA,MODELE
      LOGICAL LREST
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE SELLENET N.SELLENET
C     OPERATEUR D'EXTRACTION
C     ------------------------------------------------------------------

C
C 0.3. ==> VARIABLES LOCALES
C
      INTEGER LXLGUT
      INTEGER VALI(2)
C
      INTEGER I,J,IRE1,IRE2,IADIN,IADOU,IRET,IBID,JLGRF
      INTEGER JMAOR,IER,CRET
      CHARACTER*3 TYPE,KCHML
      CHARACTER*4  TYCH
      CHARACTER*8  NOMA1,NOMA2,NOMAVR
      CHARACTER*16 NOMSYM
      CHARACTER*16 NOPARA
      CHARACTER*19 RESUIN,RESUOU,LIGREL
      CHARACTER*24 CHAMIN,CHAMOU,CORRN,CORRM
      CHARACTER*24 VALK
C     ------------------------------------------------------------------

      CALL JEMARQ( )
C
C               1234567890123456789
      RESUIN = '                   '
      RESUOU = '                   '
      I = LXLGUT(RESU0)
      RESUIN(1:I) = RESU0(1:I)
      I = LXLGUT(RESU1)
      RESUOU(1:I) = RESU1(1:I)
C

      CALL JEEXIN (RESUOU//'.DESC',IRET)
      IF ( IRET.EQ.0 ) THEN
        CALL RSCRSD('G',RESUOU,TYPCON,NBARCH)
      ENDIF

      IF ( LREST ) THEN
        CALL DISMOI('C','EXI_CHAM_ELEM',RESUIN,
     &              'RESULTAT',IBID,KCHML,IRET)
        IF ( KCHML.EQ.'OUI'.AND.MODELE.NE.' ' ) THEN
          CALL JEVEUO(MODELE//'.MODELE    .LGRF','L',JLGRF)
          NOMA2=ZK8(JLGRF)
          LIGREL=MODELE//'.MODELE'
        ELSE
          CALL ASSERT(MAILLA.NE.' ')
          NOMA2=MAILLA
          LIGREL=' '
        ENDIF
        CALL JEVEUO(NOMA2//'.MAOR','L',JMAOR)
        NOMA1=ZK8(JMAOR)
        CORRN=NOMA2//'.CRNO'
        CORRM=NOMA2//'.CRMA'
      ENDIF

      DO 30 I = 1,NBNOSY

        CALL JENUNO(JEXNUM(RESUIN//'.DESC',I),NOMSYM)
        DO 10 J = 1,NBEXCL
          IF ( CHEXCL(J) .EQ. NOMSYM ) GO TO 30
   10   CONTINUE

        DO 20 J = 1,NBORDR
          IF (NUARCH(J).EQ.0) GO TO 20
          CALL RSEXCH(RESUIN,NOMSYM,NUORDR(J),CHAMIN,IRE1)
          IF (IRE1.GT.0) GO TO 20

          CALL RSEXCH(RESUOU,NOMSYM,NUORDR(J),CHAMOU,IRE2)
          IF (IRE2.EQ.0) THEN
          ELSE IF (IRE2.EQ.100) THEN
          ELSE
            VALI (1) = NUORDR(J)
            VALI (2) = IRE2
            VALK = CHAMOU
            CALL U2MESG('F', 'PREPOST5_16',1,VALK,2,VALI,0,0.D0)
          END IF
          IF ( LREST ) THEN
            CALL DISMOI('F','NOM_MAILLA',CHAMIN,
     &                  'CHAMP',IBID,NOMAVR,IRET)
            CALL ASSERT(NOMA1.EQ.NOMAVR)
            CALL DISMOI('F','TYPE_CHAMP',CHAMIN,'CHAMP',IBID,TYCH,IER)
            IF ( TYCH(1:2).EQ.'EL' ) THEN
              CALL ASSERT(LIGREL.NE.' ')
            ENDIF
            CALL RDTCHP(CORRN,CORRM,CHAMIN(1:19),CHAMOU(1:19),'G',
     &                  NOMA1,NOMA2,LIGREL,CRET)
          ELSE
            CALL COPISD('CHAMP_GD','G',CHAMIN,CHAMOU)
          ENDIF
          CALL RSNOCH(RESUOU,NOMSYM,NUORDR(J))
   20   CONTINUE
   30 CONTINUE


      DO 50 I = 1 , NBORDR
        IF ( NUARCH(I).EQ.0 ) GOTO 50
        DO 40 J = 1 , NBACC
          NOPARA = NOMACC(J)
          CALL RSADPA(RESUIN,'L',1,NOPARA,NUORDR(I),1,IADIN,TYPE)
          CALL RSADPA(RESUOU,'E',1,NOPARA,NUORDR(I),1,IADOU,TYPE)
          IF (TYPE(1:1).EQ.'I') THEN
            ZI(IADOU) = ZI(IADIN)
          ELSEIF (TYPE(1:1).EQ.'R') THEN
            ZR(IADOU) = ZR(IADIN)
          ELSEIF (TYPE(1:1).EQ.'C') THEN
            ZC(IADOU) = ZC(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K80') THEN
            ZK80(IADOU) = ZK80(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K32') THEN
            ZK32(IADOU) = ZK32(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K24') THEN
            ZK24(IADOU) = ZK24(IADIN)
            IF(NOPARA(1:5).EQ.'EXCIT'.AND.ZK24(IADIN)(1:2).NE.'  ')THEN
              ZK24(IADOU) = RESUOU(1:8)//ZK24(IADIN)(9:)
              CALL COPISD(' ','G',ZK24(IADIN)(1:19),ZK24(IADOU)(1:19))
            ENDIF
          ELSEIF (TYPE(1:3).EQ.'K16') THEN
            ZK16(IADOU) = ZK16(IADIN)
          ELSEIF (TYPE(1:2).EQ.'K8') THEN
            ZK8(IADOU) = ZK8(IADIN)
          ENDIF
   40   CONTINUE
   50 CONTINUE

      CALL JEDEMA( )

      END
