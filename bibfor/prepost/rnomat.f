      SUBROUTINE RNOMAT(ICESD,ICESL,ICESV, IMAP, NOMCRI, ADRMA, JTYPMA,
     &                  K, OPTIO, VALA, VALB, COEFPA, NOMMAT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE ANGLES J.ANGLES
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER       ICESD, ICESL, ICESV, IMAP, ADRMA, JTYPMA, K
      REAL*8        VALA, VALB, COEFPA
      CHARACTER*8   NOMMAT
      CHARACTER*10  OPTIO
      CHARACTER*16  NOMCRI
C ----------------------------------------------------------------------
C BUT: RECUPERER POUR LA MAILLE COURANTE LE NOM DU MATERIAU DONNE PAR
C      L'UTILISATEUR.
C ----------------------------------------------------------------------
C ARGUMENTS :
C  ICESD    IN   I  : ADRESSE DE L'OBJET CHAM_ELEM_S.CESD.
C  ICESL    IN   I  : ADRESSE DE L'OBJET CHAM_ELEM_S.CESL.
C  ICESV    IN   I  : ADRESSE DE L'OBJET CHAM_ELEM_S.CESV.
C  IMAP     IN   I  : NUMERO DE LA MAILLE COURANTE.
C  NOMCRI   IN   K  : NOM DU CRITERE.
C  ADRMA*   IN   I  : ADRESSE DE LA MAILLE CORRESPONDANT AU NOEUD.
C  JTYPMA*  IN   I  : ADRESSE DU TYPE DE LA MAILLE.
C  K*       IN   I  : POINTEUR SERVANT AU TEST : MATERIAU UNIQUE OU NON.
C  OPTIO    IN   K  : CALCUL AUX POINTS DE GAUSS OU AUX NOEUDS.
C  VALA     OUT  R  : VALEUR DU COEFFICIENT A.
C  VALB     OUT  R  : VALEUR DU COEFFICIENT B.
C  COEFPA   OUT  R  : COEFFICIENT DE PASSAGE CISAILLEMENT-TRACTION.
C  NOMMAT   OUT  K  : NOM DU MATERIAU AFFECTE A LA MAILLE COURANTE.
C
C REMARQUE : * ==> VARIABLES N'AYANT DE SENS QUE DANS LE CAS DU CALCUL
C                  DE LA FATIGUE AUX NOEUDS.
C ----------------------------------------------------------------------
C     ------------------------------------------------------------------
      INTEGER      IAD, NUMA, JTYP, IBID, IRET
      REAL*8        R8B
      INTEGER ICODRE
      CHARACTER*8  KTYP, DIMK, K8B
      CHARACTER*16 PHENOM
C     ------------------------------------------------------------------

C234567                                                              012
      K8B = '        '
      CALL JEMARQ()

      IF ( OPTIO .EQ. 'DOMA_ELGA' ) THEN

C 1. RECUPERATION DU NOM DU MATERIAU AFFECTE A LA MAILLE COURANTE
C      _____________________________________________________
C     I                                                     I
C     I       CALCUL DE LA FATIGUE AUX POINTS DE GAUSS      I
C     I_____________________________________________________I

         CALL CESEXI('C',ICESD,ICESL,IMAP,1,1,1,IAD)
CC VERIFICATION HORS BORNES DEFINIES DANS CESMAT
CC OU COMPOSANTE NON AFFECTEE
         CALL ASSERT(IAD .GT. 0)
         NOMMAT = ZK8(ICESV - 1 + IAD)

      ELSEIF ( OPTIO .EQ. 'DOMA_NOEUD' ) THEN

C      _____________________________________________________
C     I                                                     I
C     I           CALCUL DE LA FATIGUE AUX NOEUDS           I
C     I_____________________________________________________I

         NUMA = ZI(ADRMA-1 + IMAP)
         JTYP = JTYPMA - 1 + NUMA
         CALL JENUNO( JEXNUM( '&CATA.TM.NOMTM', ZI(JTYP)), KTYP )
         CALL DISMOI( 'F', 'TYPE_TYPMAIL',KTYP,'TYPE_MAILLE',IBID,
     &                DIMK, IRET )

         IF (DIMK .EQ. 'VOLU') THEN
            K = K + 1
            CALL CESEXI('C',ICESD,ICESL,NUMA,1,1,1,IAD)
CC VERIFICATION HORS BORNES DEFINIES DANS CESMAT
CC OU COMPOSANTE NON AFFECTEE
            CALL ASSERT(IAD .GT. 0)
            IF ( (K .GT. 1) .AND.
     &           (NOMMAT .NE. ZK8(ICESV - 1 + IAD)) ) THEN
               CALL U2MESS('F','FATIGUE1_33')
            ELSE
               NOMMAT = ZK8(ICESV - 1 + IAD)
            ENDIF
         ENDIF

C CAS OU LES 1ERES MAILLES SCRUTEES NE SONT PAS VOLUMIQUE
C (ON PASSE A LA SUIVANTE)
         IF (K .EQ. 0) GOTO 999

      ENDIF

C CAS CRITERE EST UNE FORMULE, ON NE RECUPERE QUE LE MATERIAU
      IF ( NOMCRI(1:7) .EQ. 'FORMULE' ) THEN
         VALA = 0.D0
         VALB = 0.D0
         COEFPA = 1.D0
         GOTO 999
      ENDIF

      CALL RCCOME (NOMMAT,'CISA_PLAN_CRIT',PHENOM,ICODRE)
      IF(ICODRE .EQ. 1) THEN
        CALL U2MESS('F','FATIGUE1_63')
      ENDIF

C 2.1 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE MATAKE POUR
C     LA MAILLE COURANTE

      IF (NOMCRI(1:14) .EQ. 'MATAKE_MODI_AC') THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                                 'MATAKE_A',VALA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_64')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                                 'MATAKE_B',VALB,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_65')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                        'COEF_FLE',COEFPA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_66')
         ENDIF

C 2.2 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE DE DANG VAN POUR
C     LA MAILLE COURANTE

      ELSEIF (NOMCRI(1:16) .EQ. 'DANG_VAN_MODI_AC') THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_A ',VALA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_67')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_B ',VALB,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_68')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_69')
         ENDIF
      ENDIF

C 2.3 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE MATAKE_MODI_AV
C     POUR LA MAILLE COURANTE

      IF ( NOMCRI(1:14) .EQ. 'MATAKE_MODI_AV' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'MATAKE_A',VALA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_70')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'MATAKE_B',VALB,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_71')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_FLE',COEFPA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_72')
         ENDIF
      ENDIF

C 2.4 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE DANG_VAN_MODI_AV
C     POUR LA MAILLE COURANTE

      IF ( NOMCRI(1:16) .EQ. 'DANG_VAN_MODI_AV' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_A ',VALA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_73')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_B ',VALB,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_74')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_72')
         ENDIF
      ENDIF

C 2.5 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE FATEMI_SOCIE
C     POUR LA MAILLE COURANTE

      IF ( NOMCRI(1:16) .EQ. 'FATESOCI_MODI_AV' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'FATSOC_A',VALA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_75')
         ENDIF

         VALB = 1.0D0

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,ICODRE,0)
         IF (ICODRE .EQ. 1) THEN
            CALL U2MESS('F','FATIGUE1_72')
         ENDIF

      ENDIF

 999  CONTINUE

      CALL JEDEMA()

      END
