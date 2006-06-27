      SUBROUTINE NMDOMT (METHOD, PARMET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/06/2006   AUTEUR CIBHHPD L.SALMONA 
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
C RESPONSABLE MABBAS M.ABBAS

      IMPLICIT NONE
      CHARACTER*16 METHOD(6)
      REAL*8       PARMET(22)

C ----------------------------------------------------------------------
C     SAISIE DES DONNEES DE LA METHODE DE RESOLUTION
C
C OUT METHOD  : DESCRIPTION DE LA METHODE DE RESOLUTION
C                 1 : NOM DE LA METHODE NON LINEAIRE : NEWTON
C                 2 : TYPE DE MATRICE (TANGENTE OU ELASTIQUE)
C                 3 : (DECHARGE OU RIEN)       --> PAS UTILISE
C                 4 : (NON , BGFGS OU BROYDEN) --> PAS UTILISE
C                 5 : METHODE D'INITIALISATION
C                 6 : NOM CONCEPT EVOL_NOLI SI PREDICTION 'DEPL_CALCULE'
C OUT PARMET  : PARAMETRES DE LA METHODE
C                 1 : REAC_INCR
C                 2 : REAC_ITER
C                 3 : PAS_MINI_ELAS
C                 4 : REAC_ITER_ELAS
C                10 : ITER_LINE_MAXI
C                11 : RESI_LINE_RELA
C                12 : ITER_LINE_CRIT
C                13 : PAS_MINI_CRIT
C                14 : RHO_MIN
C                15 : RHO_MAX
C                16 : RHO_EXCL
C                20 : RHO (LAGRANGIEN)
C                21 : ITER_GLOB_MAXI (LAGRANGIEN)
C                22 : ITER_INTE_MAXI (LAGRANGIEN)
C ----------------------------------------------------------------------
      INTEGER            IRET, ITMP,REINCR, REITER, NOCC
      REAL*8             PASMIN
C ----------------------------------------------------------------------

      METHOD(1) = 'NEWTON'
      METHOD(3) = 'RIEN'
      METHOD(4) = 'NON'

      CALL GETVTX('NEWTON','MATRICE',1,1,1,METHOD(2),IRET)

      CALL GETVIS('NEWTON','REAC_INCR',1,1,1,REINCR,IRET)
      IF(REINCR.LT.0) THEN
        CALL UTMESS('F','NMDOMT',' REAC_INCR NEGATIF')
      ELSE
        PARMET(1) = REINCR
      ENDIF

      CALL GETVIS('NEWTON','REAC_ITER',1,1,1,REITER,IRET)
      IF(REITER.LT.0) THEN
        CALL UTMESS('F','NMDOMT',' REAC_ITER NEGATIF')
      ELSE
        PARMET(2) = REITER
      ENDIF
      CALL GETVIS('NEWTON','REAC_ITER_ELAS',1,1,1,REITER,IRET)
      IF(REITER.LT.0) THEN
        CALL UTMESS('F','NMDOMT',' REAC_ITER_ELAS NEGATIF')
      ELSE
        PARMET(4) = REITER
      ENDIF
      
      CALL GETVR8('NEWTON','PAS_MINI_ELAS',1,1,1,PASMIN,IRET)
      PARMET(3) = PASMIN

      CALL GETVTX('NEWTON','PREDICTION',1,1,1,METHOD(5),IRET)
      IF (IRET.LE.0) THEN
        METHOD(5) = METHOD(2)
      ELSE IF (METHOD(2).EQ.'ELASTIQUE'
     &   .AND. METHOD(5).EQ.'TANGENTE') THEN
        METHOD(5) = 'ELASTIQUE'
      END IF
      
      IF (METHOD(5).EQ.'DEPL_CALCULE') THEN
        CALL GETVID('NEWTON','EVOL_NOLI',1,1,1,METHOD(6),IRET)
        IF (IRET.LE.0) CALL UTMESS('F','NMDOMT','IL FAUT PRECISER '
     &   //  'UN CONCEPT EVOL_NOLI EN PREDICTION ''DEPL_CALCULE''')
      END IF

      CALL GETFAC('RECH_LINEAIRE',NOCC)
      IF (NOCC.NE.0) THEN
        CALL GETVR8('RECH_LINEAIRE','RESI_LINE_RELA',1,1,1,PARMET(11),
     &             IRET)
        CALL GETVIS('RECH_LINEAIRE','ITER_LINE_MAXI',1,1,1,ITMP,IRET)
        PARMET(10) = ITMP
        CALL GETVIS('RECH_LINEAIRE','ITER_LINE_CRIT',1,1,1,ITMP,IRET)
        PARMET(12) = ITMP
        CALL GETVR8('RECH_LINEAIRE','PAS_MINI_CRIT',1,1,1,PARMET(13),
     &             IRET)
        CALL GETVR8('RECH_LINEAIRE','RHO_MIN' ,1,1,1,PARMET(14),IRET)
        CALL GETVR8('RECH_LINEAIRE','RHO_MAX' ,1,1,1,PARMET(15),IRET)
        CALL GETVR8('RECH_LINEAIRE','RHO_EXCL',1,1,1,PARMET(16),IRET)
C   VERIFICATION SUR LES PARAMETRES DE RECHERCHES LINEAIRES
        IF (PARMET(14).GE.-PARMET(16).AND.PARMET(14).LE.PARMET(16)) THEN
          CALL UTMESS('A','NMDOMT','LA DEFINITION DES PARAMETRES'//
     &    ' RHO_MIN ET RHO_EXCL EST CONTRADICTOIRE, ON PREND RHO_MIN'//
     &    ' A RHO_EXCL')
          PARMET(14)=PARMET(16)
        ENDIF

        IF (PARMET(15).GE.-PARMET(16).AND.PARMET(15).LE.PARMET(16)) THEN
          CALL UTMESS('A','NMDOMT','LES VALEURS DES PARAMETRES'//
     &    ' RHO_MAX ET RHO_EXCL SONT CONTRADICTOIRES, ON PREND'//
     &    ' RHO_MAX A -RHO_EXCL')
          PARMET(15)=-PARMET(16)
        ENDIF
      ELSE
        PARMET(10) = 0
      END IF

      END
