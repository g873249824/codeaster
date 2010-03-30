      SUBROUTINE ECRTES(NOMSD,TITRE,NOMGDS,NUMOR,FITYPE,NBCMP,ITYP,
     &                  ENTETE,LCMP)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER                              NUMOR,             ITYP
      CHARACTER*(*)     NOMSD,   TITRE,NOMGDS
      CHARACTER*(*)          FITYPE
      CHARACTER*80      ENTETE(10)
      LOGICAL           LCMP
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/03/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C  ECRITURE DE L'EN TETE D'UN DATASET SUPERTAB
C  ENTREE:
C     NOMSD : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER
C     TITRE : TITRE SUPERTAB ( 1 LIGNE)
C     NOMGDS: NOM DE LA GRANDEUR DU CHAMP
C     NUMOR : NUMERO D'ORDRE DU CHAMP
C     FITYPE: 'NOEU' ===> DATASET DE TYPE 55
C             'ELGA' ===> DATASET DE TYPE 56 (MOYENNES PAR ELEMENT)
C             'ELEM' ===> DATASET DE TYPE 56 (VALEUR PAR ELEMENT)
C             'ELNO' ===> DATASET DE TYPE 57
C
C        CODES SUPERTAB:
C     MODTYP: 1  MECANIQUE, 2 THERMIQUE, 0 INCONNU
C     ANATYP: 1  STATIC, 2 MODAL, 4 TRANSITOIRE, 5 HARMONIQUE
C     DATCAR: 1  SCALAIRE, 3 6DOF,4 TENSEUR, 0 INCONNU
C     NUTYPE: 2  STRESS, 3 STRAIN, 4 ELEMENT FORCE, 5 TEMPERATURE
C             8  DEPLACEMENT, 11 VITESSE, 12 ACCELERATION, 0 INCONNU
C     LCMP  : PRECISE SI LE MOT CLE NOM_CMP DE IMPR_RESU EST PRESENT
C   SORTIE:
C     ENTETE:10 LIGNES D'EN-TETE DU DATASET SUPERTAB
C---------------------------------------------------------------------
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32   JEXNUM,JEXNOM
C     ------------------------------------------------------------------
      INTEGER       IMODE,ITYPE,MODTYP,ANATYP,DATCAR,NUTYPE
      INTEGER       NBTITR
      REAL*8        FREQ,MASGEN,AMOR1,AMOR2,RVIDE
      CHARACTER*8   K8BID
      CHARACTER*16  TYPESD, TYPINC
      CHARACTER*24  NOMST
      CHARACTER*80  STITR,STITRB
      LOGICAL       EXISTE
      COMPLEX*16    CBID
C     ------------------------------------------------------------------
      CALL JEMARQ()
      ITYPE = ITYP
      RVIDE = R8VIDE()
C
      NOMST= '&&IRECRI.SOUS_TITRE.TITR'
      CALL JEVEUO(NOMST,'L',JTITR)
      STITR  = ZK80(JTITR)
      CALL JELIRA(NOMST,'LONMAX',NBTITR,K8BID)
      IF(NBTITR.GE.2) THEN
        STITRB = ZK80(JTITR+1)
      ELSE
        STITRB = ' '
      ENDIF
C
C ---CHOIX DU NUMERO DE DATASET--------------
      ENTETE(1) =  '    -1'
      IF (FITYPE.EQ.'NOEU') THEN
         ENTETE(2) = '    55   %VALEURS AUX NOEUDS'
      ELSE IF (FITYPE.EQ.'ELGA') THEN
         ENTETE(2) = '    56   %VALEURS MOYENNES PAR ELEMENT'
      ELSE IF (FITYPE.EQ.'ELEM') THEN
         ENTETE(2) = '    56   %VALEUR PAR ELEMENT'
      ELSE IF (FITYPE.EQ.'ELNO') THEN
         ENTETE(2) = '    57   %VALEURS AUX NOEUDS DES ELEMENTS'
      ELSE
         CALL ASSERT(.FALSE.)
      END IF
C
C   --- CHOIX DU TYPE DE MODELE--------
      IF (NOMGDS.EQ.'TEMP'.OR.NOMGDS.EQ.'FLUX') THEN
         MODTYP = 2
      ELSE
         MODTYP = 1
      ENDIF
C
C   --- A-T-ON UN CHAMP OU UN RESULTAT --------
      CALL DISMOI('F','TYPE',NOMSD,'INCONNU',IBID,TYPINC,IER)
C
C   --- CHOIX DU TYPE D'ANALYSE--------
      ANATYP = 0
      IF ( TYPINC .EQ. 'CHAM_NO' ) THEN
         ANATYP = 1
      ELSEIF ( TYPINC .EQ. 'CHAM_ELEM' ) THEN
         ANATYP = 1
      ELSE
         CALL RSNOPA(NOMSD,0,'&&ECRTES.NOM_ACC',NBAC,NBPA)
         CALL JEEXIN('&&ECRTES.NOM_ACC',IRET)
         IF (IRET.GT.0) CALL JEVEUO('&&ECRTES.NOM_ACC','E',JPAR)
         IF (NBAC.EQ.0) THEN
            ANATYP = 1
         ELSE
            DO 20 I=1,NBAC
               IF (ZK16(JPAR-1+I).EQ.'INST') THEN
                  ANATYP = 4
                  GO TO 21
               ELSEIF (ZK16(JPAR-1+I).EQ.'NUME_MODE') THEN
                  ANATYP = 2
                  GOTO 21
               ELSEIF (ZK16(JPAR-1+I).EQ.'FREQ') THEN
                  ANATYP = 5
               ENDIF
 20         CONTINUE
         ENDIF
      ENDIF
 21   CONTINUE
      CALL JEDETR('&&ECRTES.NOM_ACC')
C
C   --- CHOIX DU TYPE DE CARACTERISTIQUES----
C   --- CHOIX DU TYPE DE RESULTAT ---
      IF (NOMGDS.EQ.'DEPL') THEN
         DATCAR = 3
         NUTYPE = 8
      ELSEIF (NOMGDS.EQ.'VITE') THEN
         DATCAR =  3
         NUTYPE = 11
      ELSEIF (NOMGDS.EQ.'ACCE') THEN
         DATCAR =  3
         NUTYPE = 12
      ELSEIF (NOMGDS.EQ.'FLUX') THEN
         DATCAR =  2
         NUTYPE =  6
      ELSEIF (NOMGDS.EQ.'TEMP') THEN
         DATCAR =  1
         NUTYPE =  5
      ELSEIF (NOMGDS.EQ.'PRES') THEN
         DATCAR =  1
         NUTYPE = 15
      ELSEIF (NOMGDS(1:3).EQ.'SIG') THEN
         DATCAR =  4
         NUTYPE =  2
      ELSEIF (NOMGDS.EQ.'EPSI') THEN
         DATCAR =  4
         NUTYPE =  3
      ELSE
         DATCAR = 3
         NUTYPE = 0
         IF(NBCMP.EQ.1) DATCAR=1
      ENDIF
      IF (LCMP) THEN
         DATCAR = 3
      ENDIF
      IF(DATCAR.EQ.1) THEN
         NBCMP = 1
      ELSE IF (DATCAR.EQ.2) THEN
         NBCMP = 3
      ELSE IF (DATCAR.EQ.3.OR.DATCAR.EQ.4) THEN
         NBCMP = 6
      ENDIF
C
      ITIMAX = LXLGUT(TITRE)
      ISTMAX = LXLGUT(STITR)
      ISTMAX = MIN(ISTMAX,36)
      ITIMAX = MIN(ITIMAX,72-ISTMAX)
      ENTETE(3)= TITRE(1:ITIMAX)//' - '//STITR(1:ISTMAX)
      ENTETE(4) = ' '
      ENTETE(5) = TITRE(1:80)
      ENTETE(6) = STITR(1:80)
      ENTETE(7) = STITRB(1:80)
      IF (ANATYP.EQ.0) THEN
         WRITE (ENTETE(8),1000) MODTYP,ANATYP,DATCAR,NUTYPE
     &        ,ITYPE,NBCMP
         WRITE (ENTETE(9),2000) 1,1,NUMOR
         WRITE (ENTETE(10),3000) 0.0D0
      ELSE IF (ANATYP.EQ.1) THEN
         WRITE (ENTETE(8),1000) MODTYP,ANATYP,DATCAR,NUTYPE
     &        ,ITYPE,NBCMP
         WRITE (ENTETE(9),2000) 1,1,1
         WRITE (ENTETE(10),3000) 0.0D0
      ELSEIF (ANATYP.EQ.2) THEN
         CALL RSADPA(NOMSD,'L',1,'NUME_MODE',NUMOR,0,IAD,K8BID)
         IMODE = ZI(IAD)
         CALL RSEXPA ( NOMSD, 2, 'FREQ', IRET )
         IF ( IRET .NE. 0 ) THEN
            CALL RSADPA(NOMSD,'L',1,'FREQ',NUMOR,0,IAD,K8BID)
         ELSE
            CALL RSEXPA ( NOMSD, 2, 'CHAR_CRIT', IRET )
            IF ( IRET .NE. 0 ) THEN
               CALL RSADPA(NOMSD,'L',1,'CHAR_CRIT',NUMOR,0,IAD,K8BID)
            ELSE
               K8BID = NOMSD(1:8)
               CALL U2MESK('F','PREPOST_31',1,K8BID)
            ENDIF
         ENDIF
         FREQ  = ZR(IAD)
         CALL RSEXPA ( NOMSD, 2, 'MASS_GENE', IRET )
         IF ( IRET .NE. 0 ) THEN
            CALL RSADPA(NOMSD,'L',1,'MASS_GENE',NUMOR,0,IAD,K8BID)
            MASGEN= ZR(IAD)
         ELSE
            MASGEN= 0.D0
         ENDIF
C-MOD    CALL RSADPA(                  'AMORTISSEMENT VISQUEUX
C-MOD    CALL RSADPA(                  'AMORTISSEMENT STRUCTURAL
         CALL RSEXPA(NOMSD,2,'AMOR_REDUIT',IRET)
         IF ( IRET .NE. 0 ) THEN
           CALL RSADPA(NOMSD,'L',1,'AMOR_REDUIT',NUMOR,0,IAD,K8BID)
           AMOR1 = ZR(IAD)
           IF(AMOR1.EQ.RVIDE) AMOR1 = 0.0D0
         ELSE
           AMOR1 = 0.0D0
         ENDIF
         AMOR2 = 0.0D0
         WRITE (ENTETE(8),1000) MODTYP,ANATYP,DATCAR,NUTYPE
     &        ,ITYPE,NBCMP
         WRITE (ENTETE(9),2000) 2,4,NUMOR,IMODE
         WRITE (ENTETE(10),3000) FREQ,MASGEN,AMOR1,AMOR2
      ELSE IF (ANATYP.EQ.4) THEN
         CALL RSADPA(NOMSD,'L',1,'INST',NUMOR,0,IAD,K8BID)
         WRITE (ENTETE(8),1000) MODTYP,ANATYP,DATCAR,NUTYPE
     &        ,ITYPE,NBCMP
         WRITE (ENTETE(9),2000) 2,1,1,NUMOR
         WRITE (ENTETE(10),3000) ZR(IAD)
      ELSE IF (ANATYP.EQ.5) THEN
         CALL RSADPA(NOMSD,'L',1,'FREQ',NUMOR,0,IAD,K8BID)
         WRITE (ENTETE(8),1000) MODTYP,ANATYP,DATCAR,NUTYPE
     &        ,ITYPE,NBCMP
         WRITE (ENTETE(9),2000) 2,1,1,NUMOR
         WRITE (ENTETE(10),3000) ZR(IAD)
      END IF
 1000 FORMAT(6I10)
 2000 FORMAT(8I10)
 3000 FORMAT(6(1PE13.5E3))
      CALL JEDEMA()
      END
