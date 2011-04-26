      SUBROUTINE STOCK(RESU,NOMCMD,CHS,NOCHAM,LIGREL,TYCHAS,NUMORD,
     &                 IOUF,NUMODE,MASGEN,AMRGE,PRCHNO)
      IMPLICIT NONE
      INTEGER NUMORD ,NUMODE
      REAL*8 IOUF,MASGEN,AMRGE
      CHARACTER*(*) RESU,NOMCMD,CHS,NOCHAM,LIGREL,TYCHAS

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C----------------------------------------------------------------------
C     TRANSFERT DES RESULTATS DU CHAMP SIMPLE VERS LE CHAMP VRAI
C     PRESENT DANS LA STRUCTURE DE DONNEES RESULTATS

C IN  : CHS    : K19 : NOM DU CHAMP SIMPLE
C IN  : TYCHAS : K4  : TYPE DU CHAMP 'NOEU' 'ELNO' 'ELGA'
C IN  : NOCHAM : K16 : NOM DU CHAMP LU 'DEPL', 'SIEF_ELNO'
C IN  : NUMORD : I   : NUMERO D'ORDRE
C IN  : RESU   : K8  : NOM DE LA STRUCTURE DE DONNEES RESULTATS
C IN  : IOUF   : R   : IOUF DE L'INSTANT OU DE LA FREQUENCE
C IN  : PRCHNO : K19 : PROFIL DE STOCKAGE

C----------------------------------------------------------------------

C ----- DEBUT COMMUNS NORMALISES  JEVEUX ------------------------------
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

C-----  FIN  COMMUNS NORMALISES  JEVEUX -------------------------------

      INTEGER IRET,JIOUF,IAD,NNCP
      INTEGER VALI(2),IBID,NIVINF,IFM
      REAL*8  R8DEPI,DEPI
      CHARACTER*8 K8B,ACCE
      CHARACTER*24 VALK(2)
      CHARACTER*16 PARAM
      CHARACTER*19 NOMCH,PRCHNO

C- RECHERCHE DU NOM DU CHAMP RESULTAT
      DEPI = R8DEPI()

      CALL RSEXCH(RESU,NOCHAM,NUMORD,NOMCH,IRET)

      IF (IRET.EQ.100) THEN
      ELSE IF (IRET.EQ.0) THEN
      ELSE IF (IRET.EQ.110) THEN
        CALL RSAGSD(RESU,0)
        CALL RSEXCH(RESU,NOCHAM,NUMORD,NOMCH,IRET)
      ELSE
        VALK (1) = RESU
        VALK (2) = NOMCH
        VALI (1) = NUMORD
        VALI (2) = IRET
        CALL U2MESG('F', 'PREPOST5_73',2,VALK,2,VALI,0,0.D0)
      END IF

C - TRANSFERT DU CHAMP SIMPLE VERS LE CHAMP VRAI

C      CALL UTIMSD('MESSAGE',0,.TRUE.,.TRUE.,PRCHNO,1,' ')
C      CALL UTIMSD('MESSAGE',1,.TRUE.,.TRUE.,
C     &             PRCHNO//".PRNO",1,' ')
      IF (TYCHAS.EQ.'NOEU') THEN
        CALL CNSCNO(CHS,PRCHNO,'NON','G',NOMCH,'F',IBID)
      ELSE
        CALL CESCEL(CHS,LIGREL,' ',' ','OUI',NNCP,'G',NOMCH,'F',IBID)
      END IF


C-    ON NOTE LE CHAMP
C     ---------------------------------
      CALL INFNIV(IFM,NIVINF)
      IF ( NIVINF.GE.1 ) THEN
        WRITE (IFM,*) '<LRIDEA> LECTURE DU CHAMP  : ',NOCHAM,NUMORD
      ENDIF
      CALL RSNOCH(RESU,NOCHAM,NUMORD,' ')


C-    S: ON STOCKE LES PARAMETRES :
C     ---------------------------------

C     S.1 : INST OU FREQ :
C     --------------------
      ACCE = 'INST'
      CALL RSEXPA(RESU,0,'FREQ',IRET)
      IF (IRET.GT.0)  ACCE = 'FREQ'

      CALL RSEXPA(RESU,0,ACCE,IRET)
      CALL ASSERT(IRET.GT.0)
      CALL RSADPA(RESU,'E',1,ACCE,NUMORD,0,JIOUF,K8B)
      ZR(JIOUF) = IOUF

C     S.2 : NUME_MODE, MASS_GENE et AMOR_GENE :
C     ------------------------------
      PARAM = 'NUME_MODE'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        ZI(IAD) = NUMODE
      END IF

      PARAM = 'MASS_GENE'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        ZR(IAD) = MASGEN
      END IF

      PARAM = 'AMOR_REDUIT'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        ZR(IAD) = AMRGE
      END IF

      PARAM = 'AMOR_GENE'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        IF (AMRGE.LT.1.D92) THEN
          ZR(IAD) = 2*AMRGE*MASGEN*DEPI*IOUF
        ELSE
          ZR(IAD) = 0.D0
        ENDIF
      END IF

      PARAM = 'RIGI_GENE'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        IF (MASGEN.LT.1.D92) THEN
          ZR(IAD) = MASGEN*(DEPI*IOUF)**2
        ELSE
          ZR(IAD) = 0.D0
        ENDIF
      END IF

      PARAM = 'OMEGA2'
      CALL RSEXPA(RESU,2,PARAM,IRET)
      IF (IRET.GT.0) THEN
        CALL RSADPA(RESU,'E',1,PARAM,NUMORD,0,IAD,K8B)
        ZR(IAD) = (DEPI*IOUF)**2
      END IF



      END
