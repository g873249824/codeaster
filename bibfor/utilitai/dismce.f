      SUBROUTINE DISMCE(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
      IMPLICIT   NONE
      INTEGER             REPI, IERD
      CHARACTER*(*) QUESTI,NOMOBZ,REPKZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 12/09/2012   AUTEUR LADIER A.LADIER 
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
C
C     --     DISMOI(CHAM_ELEM)
C
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
C
C OUT : REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, -1 --> CHAMP INEXISTANT)
C
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
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       IBID, IRET, GD, JCELD, JCELK, L, LXLGUT
      CHARACTER*8   K8BID, NOGD,DOCU
      CHARACTER*19  NOMOB
      CHARACTER*24 QUESTL,K24
      CHARACTER*32  REPK
C DEB-------------------------------------------------------------------

      CALL JEMARQ()

      REPK  = ' '
      REPI  = 0
      IERD = 0

      NOMOB = NOMOBZ
      QUESTL = QUESTI

      CALL JEEXIN ( NOMOB//'.CELD', IRET )
      IF ( IRET .EQ. 0 ) THEN
          CALL U2MESK('F','UTILITAI_50',1,NOMOB)
          IERD = 1
          GOTO 9999
      END IF

      CALL JEVEUO ( NOMOB//'.CELD', 'L', JCELD )
      CALL JELIRA ( NOMOB//'.CELD', 'DOCU', IBID, DOCU)
      CALL ASSERT( DOCU.EQ. 'CHML' )
      GD = ZI(JCELD)
      CALL JENUNO ( JEXNUM('&CATA.GD.NOMGD',GD), NOGD )

      IF ( QUESTI .EQ. 'TYPE_CHAMP' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         REPK = ZK24(JCELK-1+3)(1:4)

      ELSEIF ( QUESTI .EQ. 'TYPE_SUPERVIS' ) THEN
         REPK = 'CHAM_ELEM_'//NOGD

      ELSEIF ( QUESTI .EQ. 'NOM_OPTION' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         REPK = ZK24(JCELK-1+2)(1:16)

      ELSEIF ( QUESTI .EQ. 'NOM_PARAM' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         REPK = ZK24(JCELK-1+6)(1:8)

      ELSEIF ( QUESTI .EQ. 'NOM_MAILLA') THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         CALL DISMLG (  QUESTI, ZK24(JCELK), REPI, REPK, IERD )

      ELSEIF ( QUESTL(1:6) .EQ. 'NUM_GD' ) THEN
         REPI = GD

      ELSEIF ( QUESTL(1:6) .EQ. 'NOM_GD' ) THEN
         REPK = NOGD

      ELSEIF ( QUESTI .EQ. 'NOM_LIGREL' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         REPK = ZK24(JCELK)

      ELSEIF ( QUESTI .EQ. 'MPI_COMPLET' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK', 'L', JCELK )
         K24 = ZK24(JCELK-1+7)
         CALL ASSERT(K24.EQ.'MPI_COMPLET'.OR.K24.EQ.'MPI_INCOMPLET')
         IF (K24.EQ.'MPI_COMPLET')THEN
            REPK='OUI'
         ELSE
            REPK='NON'
         ENDIF

      ELSEIF ( QUESTI .EQ. 'NOM_MODELE' ) THEN
         CALL JEVEUO ( NOMOB//'.CELK','L', JCELK )
         CALL DISMLG (  QUESTI, ZK24(JCELK), REPI, REPK, IERD )

      ELSEIF ( QUESTI .EQ. 'MXVARI' ) THEN
        REPI=MAX(1,ZI(JCELD-1+4))

      ELSEIF ( QUESTI .EQ. 'TYPE_SCA' ) THEN
          L    = LXLGUT(NOGD)
          REPK = NOGD(L:L)

      ELSE
         IERD = 1
      ENDIF

 9999 CONTINUE
      REPKZ = REPK

      CALL JEDEMA()
      END
