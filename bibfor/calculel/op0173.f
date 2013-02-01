      SUBROUTINE OP0173()
      IMPLICIT   NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/01/2013   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     COMMANDE:  EXTR_TABLE
C
C ----------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER       IBID, N1, IRET, NPARFI, VALI
      REAL*8        R8B, VALR
      COMPLEX*16    CBID, VALC
      CHARACTER*8   K8B, NOMRES, CTYPE, TABLE
      CHARACTER*16  NOMCMD, CONCEP, TYPESD
      CHARACTER*19  NEWTAB, NEWTA1
      CHARACTER*24  PARA
      CHARACTER*80  VALK
      INTEGER      IARG
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL GETRES ( NOMRES , CONCEP , NOMCMD )
C
      CALL GETVID ( ' ', 'TABLE'    ,1,IARG,1, TABLE, N1 )
      NEWTAB = TABLE
C
      CALL GETVTX ( ' ', 'NOM_PARA' , 1,IARG,1, PARA, N1 )
C
      CALL GETVTX ( ' ', 'TYPE_RESU', 1,IARG,1, TYPESD, N1 )
C
      CALL GETFAC ( 'FILTRE' , NPARFI )
      IF ( NPARFI .NE. 0 ) THEN
         NEWTA1 = '&&OP0173.FILTRE '
         CALL TBIMFI ( NPARFI, NEWTAB, NEWTA1, IRET )
         IF ( IRET .NE. 0 ) CALL U2MESS('F', 'UTILITAI7_11')
        NEWTAB = NEWTA1
      ENDIF
C
      CALL TBLIVA ( NEWTAB, 0, K8B, IBID, R8B, CBID, K8B, K8B, R8B,
     &                      PARA, CTYPE, VALI, VALR, VALC, VALK, IRET )
      IF ( IRET .EQ. 0 ) THEN
      ELSEIF ( IRET .EQ. 1 ) THEN
         CALL U2MESS('F','CALCULEL4_43')
      ELSEIF ( IRET .EQ. 2 ) THEN
         CALL U2MESS('F','CALCULEL4_44')
      ELSEIF ( IRET .EQ. 3 ) THEN
         CALL U2MESS('F','CALCULEL4_45')
      ELSE
         CALL U2MESS('F','CALCULEL4_46')
      ENDIF
C
      IF ( TYPESD .EQ. 'MATR_ASSE_GENE_R' ) THEN
C          ------------------------------
         CALL COPISD ( 'MATR_ASSE_GENE', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'MATR_ELEM_DEPL_R' ) THEN
C          ------------------------------
         CALL COPISD ( 'MATR_ELEM', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'VECT_ELEM_DEPL_R' ) THEN
C          ------------------------------
         CALL COPISD ( 'VECT_ELEM', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'CHAM_GD_SDASTER'  .OR.
     &         TYPESD .EQ. 'CHAM_NO_SDASTER'  .OR.
     &         TYPESD .EQ. 'CARTE_SDASTER'    .OR.
     &         TYPESD .EQ. 'CHAM_ELEM' ) THEN
C          ----------------------------------------
         CALL COPISD ( 'CHAMP_GD', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'MODE_MECA' ) THEN
C          ------------------------------
         CALL COPISD ( 'RESULTAT', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'FONCTION_SDASTER' .OR.
     &         TYPESD .EQ. 'FONCTION_C' .OR.
     &         TYPESD .EQ. 'NAPPE_SDASTER' ) THEN
C          ------------------------------
         CALL COPISD ( 'FONCTION', 'G', VALK, NOMRES )
C
      ELSEIF ( TYPESD .EQ. 'ENTIER' ) THEN
         CALL PUTVIR(VALI)
C
      ELSEIF ( TYPESD .EQ. 'REEL' ) THEN
         CALL PUTVRR(VALR)
C
      ELSE
         CALL U2MESK('F','CALCULEL4_47',1,TYPESD)
      ENDIF
C
      IF (TYPESD .EQ. 'REEL' .AND. TYPESD .EQ. 'ENTIER') THEN
         CALL TITRE()
      ENDIF
C
      CALL JEDEMA ( )
C
      END
