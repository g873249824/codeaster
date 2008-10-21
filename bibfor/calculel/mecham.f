      SUBROUTINE MECHAM (OPTION,MODELE,NCHAR,LCHAR,CARA,NH,
     &                          CHGEOZ,CHCARA,CHHARZ,ICODE )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                          NCHAR,        ICODE,  NH
      CHARACTER*(*)      OPTION,MODELE,      LCHAR(*),CARA
      CHARACTER*(*)      CHGEOZ,CHCARA(*),CHHARZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 21/10/2008   AUTEUR NISTOR I.NISTOR 
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
C     VERIFICATION DES CHAMPS DONNES :
C        - ON VERIFIE LES EVENTUELLES SOUS-STRUCTURES STATIQUES
C        - ON VERIFIE S'IL Y A 1 LIGREL DANS LE MODELE
C     ------------------------------------------------------------------
C IN  : OPTION : OPTION DE CALCUL
C IN  : MODELE : MODELE
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : CARA   : CHAMP DE CARA_ELEM
C IN  : NH     : NUMERO D'HARMONIQUE DE FOURIER
C OUT : CHGEOZ : NOM DE CHAMP DE GEOMETRIE TROUVE
C OUT : CHCARA : NOMS DES CHAMPS DE CARACTERISTIQUES TROUVES
C OUT : CHHARZ : NOM DU CHAMP D'HARMONIQUE DE FOURIER TROUVE
C OUT : ICODE  : CODE RETOUR
C                = 0 : TOUT EST OK, LE MODELE EST DONNE EN ARGUMENT
C                = 1 : LE MODELE EST ISSU DU CHARGEMENT
C                = 2 : PAS D'ELEMENTS FINIS ET MODELE EN ARGUMENT
C                = 3 : PAS D'ELEMENTS FINIS ET MODELE ISSU DES CHARGES
C     ------------------------------------------------------------------
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8   K8B, NOMO, NOMA, NOMACR, EXIELE, MOD2
      CHARACTER*24  CHGEOM,CHHARM
      LOGICAL       EXIMOD, EXIGEO,  EXICAR
C
      CALL JEMARQ()
      CHGEOM = CHGEOZ
      CHHARM = CHHARZ
      ICODE = 1
      EXIMOD = .FALSE.
      IF (MODELE(1:1).NE.' ') THEN
         EXIMOD = .TRUE.
         ICODE = 0
         NOMO = MODELE
      ENDIF
      IF (ICODE.EQ.1 .AND. NCHAR.LE.0)
     &   CALL U2MESS('F','CALCULEL3_30')
C
C     --- ON RECUPERE LE MODELE DES CHARGES ---
      IF (NCHAR.GT.0)
     &   CALL DISMOI('F','NOM_MODELE',LCHAR(1),'CHARGE',IBID,NOMO,IER)
C
C     --- ON VERIFIE LES EVENTUELLES SOUS-STRUCTURES STATIQUES:
      IF ( EXIMOD ) THEN
         CALL DISMOI('F','NB_SS_ACTI',NOMO,'MODELE',NBSS,K8B,IER)
         IF (NBSS.GT.0) THEN
           CALL DISMOI('F','NB_SM_MAILLA',NOMO,'MODELE',NBSMA,K8B,IER)
            CALL DISMOI('F','NOM_MAILLA',NOMO,'MODELE',IBID,NOMA,IER)
            CALL JEVEUO(NOMA//'.NOMACR','L',IANMCR)
            CALL JEVEUO(NOMO//'.MODELE    .SSSA','L',IASSSA)
C
C           --- BOUCLE SUR LES (SUPER)MAILLES ---
            IER = 0
            IF (OPTION(1:9).EQ.'MASS_MECA') THEN
              DO 20 IMA = 1, NBSMA
                  IF (ZI(IASSSA-1+IMA).EQ.1) THEN
                     NOMACR = ZK8(IANMCR-1+IMA)
C                     CALL JEEXIN(NOMACR//'.MP_EE',IRET)
                     CALL JEEXIN(NOMACR//'.MAEL_MASS_VALE',IRET)
                     IF (IRET.EQ.0) THEN
                        IER = IER + 1
                        CALL U2MESK('E','CALCULEL3_31',1,NOMACR)
                     ENDIF
                  ENDIF
 20            CONTINUE
               IF (IER.GT.0) THEN
                  CALL U2MESS('F','CALCULEL3_32')
               ENDIF
            ELSEIF (OPTION(1:9).EQ.'RIGI_MECA') THEN
               DO 22 IMA = 1, NBSMA
                  IF (ZI(IASSSA-1+IMA).EQ.1) THEN
                     NOMACR = ZK8(IANMCR-1+IMA)
C                     CALL JEEXIN(NOMACR//'.KP_EE',IRET)
                     CALL JEEXIN(NOMACR//'.MAEL_RAID_VALE',IRET)
                     IF (IRET.EQ.0) THEN
                        IER = IER + 1
                        CALL U2MESK('E','CALCULEL3_33',1,NOMACR)
                     ENDIF
                  ENDIF
 22            CONTINUE
               IF (IER.GT.0) THEN
                  CALL U2MESS('F','CALCULEL3_34')
               ENDIF
            ELSEIF (OPTION(1:9).EQ.'AMOR_MECA') THEN
              DO 24 IMA = 1, NBSMA
                  IF (ZI(IASSSA-1+IMA).EQ.1) THEN
                     NOMACR = ZK8(IANMCR-1+IMA)
                     CALL JEEXIN(NOMACR//'.MAEL_AMOR_VALE',IRET)
                     IF (IRET.EQ.0) THEN
                        IER = IER + 1
                        CALL U2MESK('E','CALCULEL6_80',1,NOMACR)
                     ENDIF
                  ENDIF
 24            CONTINUE
               IF (IER.GT.0) THEN
                  CALL U2MESS('F','CALCULEL6_81')
               ENDIF
            ENDIF
         ENDIF
      ENDIF
C
C     --- ON REGARDE S'IL Y A 1 LIGREL DANS LE MODELE ---
      CALL DISMOI('F','EXI_ELEM',NOMO,'MODELE',IBID,EXIELE,IER)
      IF ( EXIELE(1:3).EQ.'NON' .AND. NBSS.EQ.0 ) THEN
         CALL U2MESS('F','CALCULEL3_35')
C
      ELSEIF (EXIELE(1:3).EQ.'NON') THEN
C        --- SI IL N'Y A PAS D'ELEMENTS, ON SORT ---
         ICODE = ICODE + 2
         GOTO 9999
      ENDIF
C
      IF ( NCHAR.GT.0 ) THEN
         CALL MEGEOM(NOMO,LCHAR(1),EXIGEO,CHGEOM)
      ELSE
         CALL MEGEOM(NOMO,'        ',EXIGEO,CHGEOM)
      ENDIF
      CALL MECARA(CARA,EXICAR,CHCARA)
C     --- ON CREE UN CHAMP D'HARMONIQUE DE FOURIER (CARTE CSTE) ---
      CALL MEHARM(NOMO,NH,CHHARM)
C
 9999 CONTINUE
C
C     --- RESTITUTION DES SORTIES
      CHGEOZ = CHGEOM
      CHHARZ = CHHARM
      CALL JEDEMA()
      END
