      SUBROUTINE RCVALE( NOMMAZ,PHENOM,NBPAR,NOMPAR,VALPAR,
     &                   NBRES,NOMRES,VALRES,CODRET, STOP )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            NBPAR,NBRES
      CHARACTER*(*)      PHENOM, CODRET(NBRES), STOP
      CHARACTER*(*)      NOMMAZ, NOMPAR(NBPAR), NOMRES(NBRES)
      REAL*8             VALPAR(NBPAR), VALRES(NBRES)
C ----------------------------------------------------------------------
C     OBTENTION DE LA VALEUR VALRES D'UN "ELEMENT" D'UNE RELATION DE
C     COMPORTEMENT D'UN MATERIAU DONNE (NOUVELLE FORMULE RAPIDE)
C
C     ARGUMENTS D'ENTREE:
C        NOMMAT : NOM UTILISATEUR DU MATERIAU
C        PHENOM : NOM DU PHENOMENE
C        NBPAR  : NOMBRE DE PARAMETRES DANS NOMPAR ET VALPAR
C        NOMPAR : NOMS DES PARAMETRES(EX: TEMPERATURE )
C        VALPAR : VALEURS DES PARAMETRES
C        NBRES  : NOMBRE DE RESULTATS
C        NOMRES : NOM DES RESULTATS (EX: E,NU,... )
C                 TELS QU'IL FIGURENT DANS LA COMMANDE MATERIAU
C     ARGUMENTS DE SORTIE:
C     VALRES : VALEURS DES RESULTATS APRES RECUPERATION ET INTERPOLATION
C     CODRET : POUR CHAQUE RESULTAT, 'OK' SI ON A TROUVE, 'NO' SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM  , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      PARAMETER        ( NBMX=30 )
      INTEGER            NBFP
      REAL*8             VALREP(NBMX)
      LOGICAL            CHANGE
      CHARACTER*2        CODREP(NBMX)
      CHARACTER*10       PHEN,PHEPRE
      CHARACTER*8        MATPRE,NOMREP(NBMX),NOMFOP(NBMX),K8BID
      CHARACTER*10       NOMPHE
      CHARACTER*8        NOMMAT
      SAVE


      CALL JEMARQ()
      NOMMAT = NOMMAZ
      PHEN = PHENOM
C
C --- TESTS: CELA A-T-IL CHANGE ?
C
      CHANGE = .FALSE.
      IF (NBRES .GT. NBMX) THEN
        CALL UTMESS('F','RCVALE','NB PARAM. > 30 MATERIAU '//NOMMAT)
      ENDIF
      IF (NOMMAT .NE. MATPRE) CHANGE = .TRUE.
      IF (PHEN   .NE. PHEPRE) CHANGE = .TRUE.
      IF (NBRES  .NE. NBRESP) CHANGE = .TRUE.
      DO 100 IRES = 1, NBRES
        IF (NOMRES(IRES) .NE. NOMREP(IRES)) CHANGE = .TRUE.
  100 CONTINUE
C
      IF (.NOT.CHANGE) THEN
        DO 110 IRES = 1, NBRES
          VALRES(IRES) = VALREP(IRES)
          CODRET(IRES)(1:2) = CODREP(IRES)
  110   CONTINUE
        IF (NBFP .EQ. 0) GOTO 9999
        DO 120 IRES = 1, NBRES
          IF (NOMFOP(IRES) .NE. ' ') THEN
            CALL FOINTE(STOP,NOMFOP(IRES),NBPAR,NOMPAR,VALPAR,
     &                  VALRES(IRES),IER)
          ENDIF
  120   CONTINUE
      ELSE
        NOMPHE = PHEN
        CALL JEEXIN (NOMMAT//'.'//NOMPHE//'.VALR',IRET)
        IF ( IRET .EQ. 0 ) THEN
          DO 113 IRES = 1, NBRES
            CODRET(IRES)(1:2) = 'NO'
  113     CONTINUE
          GOTO 999
        ENDIF
        CALL JEVEUS (NOMMAT//'.'//NOMPHE//'.VALR', 'L', IVALR)
        CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALR', 'LONUTI', NBR,
     &               K8BID)
        CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALC', 'LONUTI', NBC,
     &               K8BID)
        CALL JEVEUS (NOMMAT//'.'//NOMPHE//'.VALK', 'L', IVALK)
        CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALK', 'LONUTI', NBK,
     &               K8BID)
        DO 130 IRES = 1, NBRES
          CODRET(IRES)(1:2) = 'NO'
          NOMFOP(IRES) = ' '
  130   CONTINUE
        NBOBJ = 0
        DO 150 IR = 1, NBR
          DO 140 IRES = 1, NBRES
            IF (NOMRES(IRES) .EQ. ZK8(IVALK-1+IR)) THEN
              VALRES(IRES) = ZR(IVALR-1+IR)
              CODRET(IRES)(1:2) = 'OK'
              NBOBJ = NBOBJ + 1
            ENDIF
  140     CONTINUE
  150   CONTINUE
        IF (NBOBJ .NE. NBRES) THEN
          NBF = (NBK-NBR-NBC)/2
          DO 170 IRES = 1, NBRES
            DO 160 IK = 1, NBF
              IF (NOMRES(IRES) .EQ. ZK8(IVALK-1+NBR+NBC+IK)) THEN
                NOMFOP(IRES) = ZK8(IVALK-1+NBR+NBC+NBF+IK)
                CALL FOINTE (STOP,NOMFOP(IRES),NBPAR,NOMPAR,
     &                            VALPAR,VALRES(IRES),IER)
                CODRET(IRES)(1:2) = 'OK'
              ENDIF
  160       CONTINUE
  170     CONTINUE
        ENDIF
        MATPRE = NOMMAT
        PHEPRE = PHEN
        NBFP = NBF
        NBRESP = NBRES
        DO 180 IRES = 1, NBRESP
          NOMREP(IRES) = NOMRES(IRES)
          VALREP(IRES) = VALRES(IRES)
          CODREP(IRES)(1:2) = CODRET(IRES)(1:2)
  180   CONTINUE
      ENDIF
 999  CONTINUE
 9999 CONTINUE
C
      CALL RCVALS( STOP, CODRET, NBRES, NOMRES )
C
      CALL JEDEMA()
      END
