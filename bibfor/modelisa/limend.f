      SUBROUTINE LIMEND( NOMMAZ,SALT,NOMRES,LIMIT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      LOGICAL            LIMIT
      CHARACTER*(*)      NOMMAZ,NOMRES
      REAL*8             SALT
C ----------------------------------------------------------------------
C     TEST PERMETTANT DE SAVOIR SI ON EST EN DESSOUS DE LA LIMITE
C     D'ENDURANCE POUR LA COURBE DE FATIGUE DEFINIE PAR LE
C     COMPORTEMENT FATIGUE ET LES MOTS CLES WOHLER OU MANSON_COFFIN
C
C     ARGUMENTS D'ENTREE:
C        NOMMAT : NOM UTILISATEUR DU MATERIAU
C        SALT   : VALEUR DE LA CONTRAINTE ALTERNEE A TESTER
C        NOMRES : NOM DU TYPE DE COURBE (WOHLER OU MANSON_COFFIN)
C     ARGUMENTS DE SORTIE:
C        LIMIT  : = .TRUE. SI SALT < LIMITE D'ENDURANCE =
C                   PREMIERE ABSCISSE DE LA COURBE DE WOHLER OU DE
C                   MANSON_COFFIN
C                 = .FALSE. SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER        IRET,IVALR,NBR,NBC,IVALK,NBK,NBF,IK,IVALF,IPROL
      REAL*8              VALLIM
      CHARACTER*10       NOMPHE
      CHARACTER*8        NOMFON,K8BID
      CHARACTER*8        NOMMAT

      CALL JEMARQ()

      NOMMAT = NOMMAZ
      NOMPHE = 'FATIGUE   '
      LIMIT = .FALSE.

      IF ( NOMRES(1:6) .EQ. 'WOHLER' ) THEN

C    DANS LE CAS OU LE MOT CLE EST WOHLER

         CALL JEEXIN (NOMMAT//'.'//NOMPHE//'.VALR',IRET)
         CALL ASSERT ( IRET .NE. 0 )

         CALL JEVEUO (NOMMAT//'.'//NOMPHE//'.VALR', 'L', IVALR)
         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALR','LONUTI',NBR,K8BID)

         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALC','LONUTI',NBC,K8BID)
         CALL JEEXIN (NOMMAT//'.'//NOMPHE//'.VALK',IRET)
         CALL JEVEUO (NOMMAT//'.'//NOMPHE//'.VALK', 'L',IVALK)
         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALK','LONUTI',NBK,K8BID)

C    NOMBRE DE FONCTIONS PRESENTES

         NBF = (NBK-NBR-NBC)/2

         DO 10 IK = 1, NBF
            IF (NOMRES .EQ. ZK8(IVALK-1+NBR+NBC+IK)) THEN
C         NOM DE LA FONCTION REPRESENTANT LA COURBE DE WOHLER
               NOMFON = ZK8(IVALK-1+NBR+NBC+NBF+IK)
C         VALEURS DE LA FONCTION REPRESENTANT LA COURBE DE WOHLER
               CALL JEVEUO(NOMFON//'           .VALE','L',IVALF)
C         PROLONGEMENT DE LA FONCTION REPRESENTANT LA COURBE DE WOHLER
               CALL JEVEUO(NOMFON//'           .PROL','L',IPROL)
C         PROLONGEMENT A GAUCHE DE LA COURBE DE WOHLER EXCLU OU CONSTANT
               IF ( (ZK24(IPROL-1+5)(1:1).EQ.'E') .OR.
     &              (ZK24(IPROL-1+5)(1:1).EQ.'C') ) THEN
                  VALLIM=ZR(IVALF)
                  IF (SALT.LT.VALLIM) THEN
                     LIMIT=.TRUE.
                  ENDIF
               ENDIF
               GOTO 20
            ENDIF
  10     CONTINUE
         CALL U2MESS('F','MODELISA4_89')
  20     CONTINUE

      ELSEIF ( NOMRES(1:8) .EQ. 'MANSON_C' ) THEN

C    DANS LE CAS OU LE MOT CLE EST MANSON_COFFIN

         CALL JEEXIN (NOMMAT//'.'//NOMPHE//'.VALR',IRET)
         CALL ASSERT ( IRET .NE. 0 )

         CALL JEVEUO (NOMMAT//'.'//NOMPHE//'.VALR', 'L', IVALR)
         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALR','LONUTI',NBR,K8BID)

         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALC','LONUTI',NBC,K8BID)
         CALL JEEXIN (NOMMAT//'.'//NOMPHE//'.VALK',IRET)
         CALL JEVEUO (NOMMAT//'.'//NOMPHE//'.VALK', 'L',IVALK)
         CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALK','LONUTI',NBK,K8BID)

C    NOMBRE DE FONCTIONS PRESENTES

         NBF = (NBK-NBR-NBC)/2

         DO 30 IK = 1, NBF
            IF (NOMRES .EQ. ZK8(IVALK-1+NBR+NBC+IK)) THEN
C        NOM DE LA FONCTION REPRESENTANT LA COURBE DE MANSON_COFFIN
               NOMFON = ZK8(IVALK-1+NBR+NBC+NBF+IK)
C        VALEURS DE LA FONCTION REPRESENTANT LA COURBE DE MANSON_COFFIN
               CALL JEVEUO(NOMFON//'           .VALE','L',IVALF)
C        PROLONGEMENT DE LA FONCTION REPRESENTANT LA COURBE DE
C        MANSON_COFFIN
               CALL JEVEUO(NOMFON//'           .PROL','L',IPROL)
C        PROLONGEMENT A GAUCHE DE LA COURBE DE MANSON_COFFIN EXCLU OU
C        CONSTANT
               IF ( (ZK24(IPROL-1+5)(1:1).EQ.'E') .OR.
     &              (ZK24(IPROL-1+5)(1:1).EQ.'C') ) THEN
                  VALLIM=ZR(IVALF)
                  IF (SALT.LT.VALLIM) THEN
                     LIMIT=.TRUE.
                  ENDIF
               ENDIF
               GOTO 40
            ENDIF
  30     CONTINUE
         CALL U2MESS('F','MODELISA4_91')
  40     CONTINUE

      ENDIF

      CALL JEDEMA()
      END
