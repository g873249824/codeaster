      SUBROUTINE U195TB(CHOU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     TRAITEMENT DE COMMANDE:   CREA_CHAMP / OPTION: 'EXTR' / TABLE
C
C     " CREATION D'UN CHAMP A PARTIR D'UNE TABLE "
C
      IMPLICIT   NONE

C     ------------------------------------------------------------------
C 0.1. ==> ARGUMENT
C
      CHARACTER*(*) CHOU
C
C 0.2. ==> COMMUNS
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C      ==> VARIABLES LOCALES
C
      INTEGER      N1,N2,JNOMA,IBID,IRET,NNCP
      CHARACTER*1  BASE
      CHARACTER*3  PROL0
      CHARACTER*4  TYCHS
      CHARACTER*8  NOMGD,MA,MO,K8B
      CHARACTER*16 TYCHLU,OPTION,K16BID,TYPCHS
      CHARACTER*19 CHS,TABIN,LIGREL
      PARAMETER(BASE='G')

      CALL JEMARQ()

      CHS='&&U195TB.CHAMP_S'

      CALL GETVID(' ','TABLE',0,1,1,TABIN,N1)
      CALL GETVTX(' ','TYPE_CHAM',0,1,1,TYCHLU,N1)

      TYPCHS=TYCHLU(1:4)
      NOMGD=TYCHLU(6:11)

C     VERIFICATIONS
      IF(TYPCHS.EQ.'NOEU')THEN
        CALL GETVID(' ','MAILLAGE',0,1,1,MA,N1)
        IF(N1.EQ.0)
     &       CALL U2MESS('F','MODELISA7_61')
        OPTION=' '
        MO=' '
      ELSEIF(TYPCHS(1:2).EQ.'EL')THEN
        CALL GETVID(' ','MODELE',0,1,0,K8B,N1)
        CALL GETVTX(' ','OPTION',0,1,0,K8B,N2)
        IF(N1.NE.0)THEN
          N1=-N1
          CALL GETVID(' ','MODELE',0,1,1,MO,N1)
        ENDIF
        IF(N2.NE.0)THEN
          N2=-N2
          CALL GETVTX(' ','OPTION',0,1,1,OPTION,N2)
        ENDIF
        IF(N1.EQ.0 .OR. N2.EQ.0)
     &       CALL U2MESS('F','MODELISA7_62')
        CALL JEVEUO(MO//'.MODELE    .LGRF','L',JNOMA)
        MA=ZK8(JNOMA)
      ENDIF

C     CREATION DU CHAMP SIMPLE
      CALL TABCHS(TABIN,TYPCHS,'V',NOMGD,MA,MO,OPTION,CHS)

C     TRANSFORMATION : CHAM_S --> CHAM
      CALL GETVTX(' ','PROL_ZERO',0,1,1,PROL0,N1)
      IF (N1.EQ.0) PROL0='NON'
      IF(TYPCHS.EQ.'NOEU')THEN
         CALL CNSCNO(CHS,' ',PROL0,BASE,CHOU)
      ELSE
         CALL DISMOI('F','NOM_LIGREL',MO,'MODELE',IBID,LIGREL,IRET)
         CALL CESCEL(CHS,LIGREL,OPTION,' ',PROL0,NNCP,BASE,CHOU)
      ENDIF
      CALL JEDEMA()

      END
