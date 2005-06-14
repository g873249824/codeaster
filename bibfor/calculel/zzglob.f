      SUBROUTINE ZZGLOB (CHAMP,OPTION)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)      CHAMP
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
C ----------------------------------------------------------------------
C     BUT :  CALCULER LES ESTIMATEURS GLOBAUX
C            A PARTIR DES ESTIMATEURS LOCAUX CONTENUS DANS CHAMP
C
C IN  : CHAMP  :  NOM DU CHAM_ELEM_ERREUR
C IN  : OPTION : 'ERRE_ELEM_NOZ1' OU 'ERRE_ELEM_NOZ2'OU 'ERRE_ELGA_NORE'
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
      CHARACTER*32     JEXNUM, JEXNOM, JEXATR
C     ------------------------------------------------------------------
      INTEGER      IFI, NBGREL, NBELEM, DIGDEL
      INTEGER      LONGT, LONG2, MODE, J
      REAL*8       RZERO, ERR, ERR0, NORS, NORV, NU0, NUEX, THETA
      REAL*8       Q, NORSEL, NORSUP, ERRSIG
      CHARACTER*4  CVAL, DOCU
      CHARACTER*8  SCAL,SCALAI
      CHARACTER*19 CHAMP2, LIGREL
      CHARACTER*(*) OPTION
      LOGICAL      FIRST
C
      CALL JEMARQ()
      IFI    = IUNIFI('RESULTAT')
      CHAMP2 = CHAMP
C
C     -- ON RETROUVE LE NOM DU LIGREL:
C     --------------------------------

C     -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
      CALL CELVER(CHAMP2,'NBVARI_CST','STOP',IBID)
      CALL CELVER(CHAMP2,'NBSPT_1','STOP',IBID)

      CALL JELIRA (CHAMP2//'.CELD','DOCU',IBID,DOCU)
      IF( DOCU.NE.'CHML' ) THEN
         CALL UTMESS('F','ZZGLOB','LE CHAMP DOIT ETRE UN CHAM_ELEM ')
      ENDIF
      CALL JEVEUO (CHAMP2//'.CELK','L',IACELK)
      LIGREL = ZK24(IACELK-1+1)(1:19)
C
      CALL JEVEUO (CHAMP2//'.CELD','L',JCELD)
C
C     -- ON VERIFIE LES LONGUEURS:
C     ----------------------------
      FIRST = .TRUE.
      NBGR  = NBGREL(LIGREL)
      DO 1 ,J = 1,NBGR
         MODE=ZI(JCELD-1+ZI(JCELD-1+4+J) +2)
         IF (MODE.EQ.0) GOTO 1
         LONG2 = DIGDEL(MODE)
         ICOEF=MAX(1,ZI(JCELD-1+4))
         LONG2 = LONG2 * ICOEF
         IF (FIRST) THEN
            LONGT = LONG2
         ELSE
            IF (LONGT.NE.LONG2) THEN
               CALL UTMESS('F','ZZGLOB','LONGUEURS DES MODES LOCAUX '
     +                     //'IMCOMPATIBLES ENTRE EUX.')
            ENDIF
         ENDIF
         FIRST = .FALSE.
   1  CONTINUE
C
C        -- ON CUMULE :
C        --------------
         CALL JEVEUO (CHAMP2//'.CELV','E',IAVALE)
C
         ERR0 = 0.D0
         NORS = 0.D0
         NBEL = 0
         DO 2 ,J = 1,NBGR
            MODE=ZI(JCELD-1+ZI(JCELD-1+4+J) +2)
            IF (MODE.EQ.0 ) GOTO 2
            NEL = NBELEM(LIGREL,J)
            IDECGR=ZI(JCELD-1+ZI(JCELD-1+4+J)+8)
            DO 3 , K = 1,NEL
               IAD  = IAVALE-1+IDECGR+(K-1)*LONGT
               ERR0 = ERR0 + ZR(IAD+1-1)**2
               NORS = NORS + ZR(IAD+3-1)**2
               NBEL = NBEL + 1
 3          CONTINUE
2        CONTINUE
      NU0  = 100.D0*SQRT(ERR0/(ERR0+NORS))
      ERR0 = SQRT(ERR0)
      NORS = SQRT(NORS)
      WRITE(IFI,*) ' '
      WRITE(IFI,*) ' ++++++++++++++++++++++++'
      IF(OPTION(1:14).EQ.'ERRE_ELEM_NOZ1') THEN
         WRITE(IFI,*) ' ESTIMATEUR D''ERREUR ZZ1'
      ELSEIF(OPTION(1:14).EQ.'ERRE_ELEM_NOZ2') THEN
         WRITE(IFI,*) ' ESTIMATEUR D''ERREUR ZZ2'
      ELSEIF(OPTION(1:14).EQ.'ERRE_ELGA_NORE') THEN
         WRITE(IFI,*) ' ESTIMATEUR D''ERREUR EN RESIDU'
      ENDIF
      WRITE(IFI,*) ' ++++++++++++++++++++++++'
         WRITE(IFI,*)
         WRITE(IFI,*) '   IMPRESSION DES NORMES GLOBALES :'
         WRITE(IFI,*)
         WRITE(IFI,101) NU0
101      FORMAT(5X,'ERREUR RELATIVE ESTIMEE = ',F7.3,' %')
         WRITE(IFI,104) ERR0
104      FORMAT(5X,'ERREUR ABSOLUE ESTIMEE  =  ',D10.3)
         WRITE(IFI,107) NORS
107      FORMAT(5X,'NORME DE SIGMA CALCULEE  =  ',D11.4)
C
C
      CALL JEDEMA()
      END
