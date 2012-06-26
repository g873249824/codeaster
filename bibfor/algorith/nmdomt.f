      SUBROUTINE NMDOMT(METHOD,PARMET,NOMCMD)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/06/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*16 METHOD(*),NOMCMD
      REAL*8       PARMET(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (LECTURE)
C
C LECTURE DES DONNEES DE RESOLUTION
C
C ----------------------------------------------------------------------
C
C
C IN  NOMCMD  : COMMANDE APPELANTE
C OUT METHOD  : DESCRIPTION DE LA METHODE DE RESOLUTION
C                 1 : NOM DE LA METHODE NON LINEAIRE (NEWTON OU IMPLEX)
C                     (NEWTON OU NEWTON_KRYLOV OU IMPLEX)
C                 2 : TYPE DE MATRICE (TANGENTE OU ELASTIQUE)
C                 3 : -- INUTILISE --
C                 4 : -- INUTILISE --
C                 5 : METHODE D'INITIALISATION
C                 6 : NOM CONCEPT EVOL_NOLI SI PREDICTION 'DEPL_CALCULE'
C                 7 : METHODE DE RECHERCHE LINEAIRE
C OUT PARMET  : PARAMETRES DE LA METHODE
C                 1 : REAC_INCR
C                 2 : REAC_ITER
C                 3 : PAS_MINI_ELAS
C                 4 : REAC_ITER_ELAS
C             5 - 9 : -- INUTILISE --
C                10 : ITER_LINE_MAXI
C                11 : RESI_LINE_RELA
C                12 : -- INUTILISE --
C                13 : -- INUTILISE --
C                14 : RHO_MIN
C                15 : RHO_MAX
C                16 : RHO_EXCL
C           17 - 30 : -- INUTILISE --
C
C ----------------------------------------------------------------------
C
      INTEGER      IRET, ITMP,REINCR, REITER, NOCC
      REAL*8       PASMIN,R8PREM
      INTEGER      IFM,NIV
      INTEGER      IARG, IBID
C
C ----------------------------------------------------------------------
C
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... LECTURE DONNEES RESOLUTION'
      ENDIF

C
C --- RECUPERATION DE LA METHODE DE RESOLUTION
C
      CALL GETVTX(' ','METHODE',1,IARG,1,METHOD(1),IBID)

C
C --- INITIALISATIONS
C
      IF ((METHOD(1) .EQ. 'NEWTON').OR.
     &      (METHOD(1) .EQ. 'NEWTON_KRYLOV')) THEN
        CALL GETVTX('NEWTON','MATRICE',1,IARG,1,METHOD(2),IRET)

        CALL GETVIS('NEWTON','REAC_INCR',1,IARG,1,REINCR,IRET)
        IF (REINCR.LT.0) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          PARMET(1) = REINCR
        ENDIF

        CALL GETVIS('NEWTON','REAC_ITER',1,IARG,1,REITER,IRET)
        IF(REITER.LT.0) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          PARMET(2) = REITER
        ENDIF

        CALL GETVIS('NEWTON','REAC_ITER_ELAS',1,IARG,1,REITER,IRET)
        IF(REITER.LT.0) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          PARMET(4) = REITER
        ENDIF

        CALL GETVR8('NEWTON','PAS_MINI_ELAS',1,IARG,1,PASMIN,IRET)
        IF ( IRET .LE. 0 ) THEN
          PARMET(3) = -9999.0D0
        ELSE
          PARMET(3) = PASMIN
        ENDIF

        CALL GETVTX('NEWTON','PREDICTION',1,IARG,1,METHOD(5),IRET)
        IF (IRET.LE.0) THEN
          METHOD(5) = METHOD(2)
        END IF

        IF (METHOD(5).EQ.'DEPL_CALCULE') THEN
          CALL GETVID('NEWTON','EVOL_NOLI',1,IARG,1,METHOD(6),IRET)
          IF (IRET.LE.0) CALL U2MESS('F','MECANONLINE5_45')
        END IF

      ELSEIF (METHOD(1) .EQ. 'IMPLEX') THEN
        PARMET(1) = 1
        METHOD(5) = 'TANGENTE'
      ELSE
C   LA METHODE EST INEXISTANTE
       CALL ASSERT(.FALSE.)
      END IF
C
C --- PARAMETRES DE LA RECHERCHE LINEAIRE
C
      METHOD(7) = 'CORDE'

      CALL GETFAC('RECH_LINEAIRE',NOCC)
      IF (NOCC.NE.0) THEN
        CALL GETVTX('RECH_LINEAIRE','METHODE',1,IARG,1,METHOD(7),IRET)
        CALL GETVR8('RECH_LINEAIRE','RESI_LINE_RELA',1,IARG,1,
     &              PARMET(11),
     &             IRET)
        CALL GETVIS('RECH_LINEAIRE','ITER_LINE_MAXI',1,IARG,1,ITMP,IRET)
        PARMET(10) = ITMP
        CALL GETVR8('RECH_LINEAIRE','RHO_MIN' ,1,IARG,1,PARMET(14),IRET)
        CALL GETVR8('RECH_LINEAIRE','RHO_MAX' ,1,IARG,1,PARMET(15),IRET)
        CALL GETVR8('RECH_LINEAIRE','RHO_EXCL',1,IARG,1,PARMET(16),IRET)
C   VERIFICATION SUR LES PARAMETRES DE RECHERCHES LINEAIRES
        IF (PARMET(14).GE.-PARMET(16).AND.PARMET(14).LE.PARMET(16)) THEN
          CALL U2MESS('A','MECANONLINE5_46')
          PARMET(14) = PARMET(16)
        ENDIF

        IF (PARMET(15).GE.-PARMET(16).AND.PARMET(15).LE.PARMET(16)) THEN
          CALL U2MESS('A','MECANONLINE5_47')
          PARMET(15) = -PARMET(16)
        ENDIF

        IF (PARMET(15).LT.PARMET(14)) THEN
          CALL U2MESS('A','MECANONLINE5_44')
          CALL GETVR8('RECH_LINEAIRE','RHO_MIN',1,IARG,1,
     &                PARMET(15),IRET)
          CALL GETVR8('RECH_LINEAIRE','RHO_MAX',1,IARG,1,
     &                PARMET(14),IRET)
        ENDIF

        IF (ABS(PARMET(14)-PARMET(15)).LE.R8PREM())THEN
          CALL U2MESS('F','MECANONLINE5_43')
        ENDIF

      ELSE
        PARMET(10) = 0
      END IF
      END
