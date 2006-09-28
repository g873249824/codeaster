      SUBROUTINE RNOMAT(ICESD,ICESL,ICESV, IMAP, NOMCRI, ADRMA, JTYPMA,
     &                  K, OPTIO, VALA, VALB, COEFPA, NOMMAT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE F1BHHAJ J.ANGLES
      IMPLICIT      NONE
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
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32  JEXNOM,JEXNUM,JEXATR,        ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ------------------------------------------------------------------
      INTEGER      IAD, NVAL, I, NUMA, JTYP, IBID, IRET
      REAL*8       PHI, R8B, MYOUNG, NU
      CHARACTER*2  CODRET
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
         IF (IAD .LE. 0) THEN
            CALL U2MESS('F','PREPOST4_61')
         ELSE
            NOMMAT = ZK8(ICESV - 1 + IAD)
         ENDIF

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
            IF (IAD .LE. 0) THEN
               CALL U2MESS('F','PREPOST4_61')
            ELSE
               IF ( (K .GT. 1) .AND.
     &              (NOMMAT .NE. ZK8(ICESV - 1 + IAD)) ) THEN
                  CALL U2MESS('F','PREPOST4_62')
               ELSE
                  NOMMAT = ZK8(ICESV - 1 + IAD)
               ENDIF
            ENDIF
         ENDIF

C CAS OU LES 1ERES MAILLES SCRUTEES NE SONT PAS VOLUMIQUE
C (ON PASSE A LA SUIVANTE)
         IF (K .EQ. 0) GOTO 999

      ENDIF

      CALL RCCOME (NOMMAT,'CISA_PLAN_CRIT',PHENOM,CODRET)
      IF(CODRET(1:2) .EQ. 'NO') THEN
        CALL U2MESS('F','PREPOST4_63')
      ENDIF

C 2.1 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE MATAKE POUR
C     LA MAILLE COURANTE

      IF (NOMCRI(1:6) .EQ. 'MATAKE') THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                                 'MATAKE_A',VALA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_64')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                                 'MATAKE_B',VALB,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_65')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                        'COEF_FLE',COEFPA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_66')
         ENDIF

C 2.2 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE DE DANG VAN POUR
C     LA MAILLE COURANTE

      ELSEIF (NOMCRI(1:16) .EQ. 'DANG_VAN_MODI_AC') THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_A ',VALA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_67')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_B ',VALB,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_68')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_69')
         ENDIF
      ENDIF

C 2.3 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE DOMM_MAXI POUR
C     LA MAILLE COURANTE

      IF ( NOMCRI(1:9) .EQ. 'DOMM_MAXI' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'DOMM_A  ',VALA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_70')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'DOMM_B  ',VALB,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_71')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_72')
         ENDIF
      ENDIF

C 2.4 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE DANG_VAN_MODI_AV
C     POUR LA MAILLE COURANTE

      IF ( NOMCRI(1:16) .EQ. 'DANG_VAN_MODI_AV' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_A ',VALA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_73')
         ENDIF
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'D_VAN_B ',VALB,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_74')
         ENDIF

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_72')
         ENDIF
      ENDIF

C 2.5 RECUPERATION DES PARAMETRES ASSOCIES AU CRITERE FATEMI_SOCIE
C     POUR LA MAILLE COURANTE

      IF ( NOMCRI(1:12) .EQ. 'FATEMI_SOCIE' ) THEN
         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'FATSOC_A',VALA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_75')
         ENDIF

         VALB = 1.0D0

         CALL RCVALE(NOMMAT,'CISA_PLAN_CRIT',0,K8B,R8B,1,
     &                      'COEF_CIS',COEFPA,CODRET,'  ')
         IF (CODRET(1:2) .EQ. 'NO') THEN
            CALL U2MESS('F','PREPOST4_72')
         ENDIF

      ENDIF

 999  CONTINUE

      CALL JEDEMA()

      END
