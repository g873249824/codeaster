      SUBROUTINE CCLOPU(RESUIN,RESUOU,LISORD,NBORDR,LISOPT,
     &                  NBROPT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER      NBORDR,NBROPT
      CHARACTER*8  RESUIN,RESUOU
      CHARACTER*19 LISORD,LISOPT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/12/2012   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE SELLENET N.SELLENET
C ----------------------------------------------------------------------
C  CALC_CHAMP - DETERMINATION DE LA LISTE D'OPTIONS DE L'UTILISATEUR
C  -    -                           -       --           -
C ----------------------------------------------------------------------
C
C  ROUTINE SERVANT A RECUPERER LA LISTE D'OPTIONS DE CALC_CHAMP
C    SOUHAITEES PAR L'UTILISATEUR
C
C  LES OPTIONS SONT FOURNIES DANS DES MOTS-CLES SIMPLES :
C    - CONTRAINTE
C    - DEFORMATION
C    - ENERGIE
C    - CRITERES
C    - VARI_INTERNE
C    - HYDRAULIQUE
C    - THERMIQUE
C    - ACOUSTIQUE
C    - FORCE
C  ET LE MOT-CLE FACTEUR CHAM_UTIL.
C
C IN  :
C   RESUIN K8   NOM DE LA SD IN
C
C IN/OUT :
C   LISOPT K19  NOM DE LA LISTE D'OPTIONS
C
C OUT :
C   NBOPT  I    NOMBRE D'OPTIONS
C ----------------------------------------------------------------------
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 9)
C
      INTEGER      I,ITYP,N1,JOPT,JOPTY,POSTMP,NBOPFA,IOC,IBID
      INTEGER      NUTI,NSUP,JOPUT,JORD,IORDR,IRET,IARG
C
      CHARACTER*8  K8B
      CHARACTER*9  MCFACT
      CHARACTER*12 TYPOPT,TYGROP(NTYMAX)
      CHARACTER*16 OPTION,CHN
      PARAMETER   (MCFACT='CHAM_UTIL')
C
      LOGICAL      NEWCAL,VU
C
      DATA TYGROP  /'CONTRAINTE  ','DEFORMATION ','ENERGIE     ',
     &              'CRITERES    ','VARI_INTERNE','HYDRAULIQUE ',
     &              'THERMIQUE   ','ACOUSTIQUE  ','FORCE       '/
C
      CALL JEMARQ()
C
C --- PREMIERE BOUCLE POUR DETERMINER LE NOMBRE TOTAL D'OPTIONS
      CALL WKVECT('&&CCLOPU.NB_OP_TY','V V I',NTYMAX,JOPTY)
      NBROPT = 0
      DO 10 ITYP = 1,NTYMAX
        TYPOPT = TYGROP(ITYP)
        CALL GETVTX(' ',TYPOPT,1,IARG,0,K8B,N1)
        ZI(JOPTY+ITYP-1) = -N1
        NBROPT = NBROPT-N1
  10  CONTINUE
C
      CALL WKVECT(LISOPT,'V V K16',MAX(1,NBROPT),JOPT)
C
C     DEUXIEME BOUCLE POUR REMPLIR LE TABLEAU DES OPTIONS
      POSTMP = 0
      DO 20 ITYP = 1,NTYMAX
        TYPOPT = TYGROP(ITYP)
        NBOPFA = ZI(JOPTY+ITYP-1)
        IF ( NBOPFA.EQ.0 ) GOTO 20
        CALL GETVTX(' ',TYPOPT,1,IARG,NBOPFA,
     &              ZK16(JOPT+POSTMP),N1)
        POSTMP = POSTMP+NBOPFA
  20  CONTINUE
C
C --- MOT-CLE FACTEUR CHAM_UTIL
C     POUR EVITER L'ALARME LIE AU RECALCUL D'UNE OPTION DEJA PRESENTE
C     ON REGARDE SI ELLE A DEJA ETE CALCULEE ET SI ELLE N'EST PAS DEJA
C     DANS LA LISTE DES OPTIONS DEMANDEES PAR L'UTILISATEUR
      CALL GETFAC(MCFACT, NUTI)
      IF (NUTI.EQ.0) THEN
        GOTO 9999
      ENDIF
C
      NEWCAL = .FALSE.
      CALL JEEXIN(RESUOU//'           .DESC',IRET)
      IF (IRET.EQ.0) NEWCAL = .TRUE.
C
      CALL WKVECT('&&CCLOPU.OPUTIL','V V K16',NUTI,JOPUT)
      CALL JEVEUO(LISORD,'L',JORD)
      NSUP = 0
      DO 30 IOC=1, NUTI
        CALL GETVTX(MCFACT,'NOM_CHAM',IOC,IARG,1,OPTION,IBID)
        VU = .TRUE.
C       OPTION PRESENTE DANS RESUIN A TOUS LES NUME_ORDRE A CALCULER ?
        DO 31 I=1,NBORDR
          IORDR = ZI(JORD-1+I)
          CALL RSEXCH(' ',RESUIN,OPTION,IORDR,CHN,IRET)
          IF (IRET.EQ.0) THEN
            IF ( .NOT.NEWCAL )
     &        CALL RSEXCH(' ',RESUOU,OPTION,IORDR,CHN,IRET)
            IF (IRET.EQ.0) THEN
              VU = .FALSE.
              GOTO 32
            ENDIF
          ENDIF
  31    CONTINUE
        GOTO 38
C
  32    CONTINUE
C       OPTION DEJA DANS LA LISTE ?
        VU = .FALSE.
        DO 33 I=1,NBROPT
          IF (ZK16(JOPT-1+I).EQ.OPTION) THEN
            VU = .TRUE.
            GOTO 30
          ENDIF
  33    CONTINUE
        DO 34 I=1,NSUP
          IF (ZK16(JOPUT-1+I).EQ.OPTION) THEN
            VU = .TRUE.
            GOTO 30
          ENDIF
  34    CONTINUE
C
  38    CONTINUE
C       ON AJOUTE L'OPTION A LA LISTE
        IF (.NOT.VU) THEN
          NSUP = NSUP + 1
          ZK16(JOPUT-1+NSUP) = OPTION
        ENDIF
  30  CONTINUE
C
C --- REFAIRE OU AGRANDIR LISOPT
      IF (NSUP.GT.0) THEN
        IF (NBROPT.EQ.0) THEN
          CALL JEDETR(LISOPT)
          CALL WKVECT(LISOPT,'V V K16',NSUP,JOPT)
        ELSE
          CALL JUVECA(LISOPT, NBROPT+NSUP)
        ENDIF
        DO 41 I=1,NSUP
          ZK16(JOPT-1+NBROPT+I) = ZK16(JOPUT-1+I)
  41    CONTINUE
        NBROPT = NBROPT + NSUP
      ENDIF
C
 9999 CONTINUE
      CALL JEDETR('&&CCLOPU.NB_OP_TY')
      CALL JEDETR('&&CCLOPU.OPUTIL')
      CALL JEDEMA()
C
      END
