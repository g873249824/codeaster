      SUBROUTINE OP0177 ( IER )
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 16/06/2004   AUTEUR DURAND C.DURAND 
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
C
C     COMMANDE:  TEST_TABLE
C
C ----------------------------------------------------------------------
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER             IER
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='OP0177')
C
      INTEGER IBID, N1, N2, N3, IRET, IUNIFI, IFIC, NPARFI
      INTEGER VALI, REFI
      INTEGER NRPASS,NBPASS,ADRECG
      INTEGER IAUX, JAUX
      LOGICAL       ULEXIS
C
      REAL*8       R8B, VALR, REFR, PREC
C
      COMPLEX*16   CBID, VALC, REFC
C
      CHARACTER*1  TYPR
      CHARACTER*4  TESTOK
      CHARACTER*8  K8B, CRIT, CTYPE, TYPTES, TABLE0
      CHARACTER*8 LATABL,NOPASE
      CHARACTER*12 LABEL
      CHARACTER*16 NOMFI
      CHARACTER*19 NEWTAB, NEWTA1
      CHARACTER*24 PARA
      CHARACTER*24 NORECG
      CHARACTER*38 TITRES
      CHARACTER*80 VALK
C     ------------------------------------------------------------------
C
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      IER = 0
C
      TESTOK = 'NOOK'
      LABEL  = ' '
      NORECG = '&&'//NOMPRO//'_RESULTA_GD     '
C
      IFIC  = 0
      NOMFI = ' ' 
      CALL GETVIS ( ' ', 'UNITE'  , 1,1,1, IFIC , N1 )
      CALL GETVTX ( ' ', 'FICHIER', 1,1,1, NOMFI, N1 )
      IF ( N1 .NE. 0 ) THEN
         CALL UTMESS('A','TEST_TABLE',
     +               'LE MOT CLE "FICHIER" EST APPELE A DISPARAITRE.'//
     +               ' UTILISER LE MOT CLE "UNITE"')
         IFIC = IUNIFI( NOMFI )
      ENDIF
      IF ( .NOT. ULEXIS( IFIC ) ) THEN
         CALL ULOPEN ( IFIC, ' ', NOMFI, 'NEW', 'O' )
      ENDIF
      WRITE(IFIC,1000)
C
      CALL GETVID ( ' ', 'TABLE' ,1,1,1, TABLE0, N1 )
      LABEL(1:8) = TABLE0
C
      CALL GETFAC ( 'FILTRE' , NPARFI )
C
      CALL GETVR8 ( ' ', 'PRECISION', 1,1,1, PREC, N1 )
      CALL GETVTX ( ' ', 'CRITERE'  , 1,1,1, CRIT, N1 )
C
      CALL GETVR8 ( ' ', 'VALE'  , 1,1,1, REFR, N1 )
      CALL GETVIS ( ' ', 'VALE_I', 1,1,1, REFI, N2 )
      CALL GETVC8 ( ' ', 'VALE_C', 1,1,1, REFC, N3 )
      TYPR = 'R'
      IF ( N2 .NE. 0 ) TYPR = 'I'
      IF ( N3 .NE. 0 ) TYPR = 'C'
C
      CALL GETVTX ( ' ', 'NOM_PARA', 1,1,1, PARA, N1 )
C
      CALL GETVTX ( ' ', 'TYPE_TEST', 1,1,1, TYPTES, N1 )
C
C=======================================================================
C -- SENSIBILITE : NOMBRE DE PASSAGES
C=======================================================================
      IAUX = 1
      JAUX = 1
      CALL PSRESE(' ',IBID,IAUX,TABLE0,JAUX,NBPASS,NORECG,IRET)
      CALL JEVEUO(NORECG,'L',ADRECG)
C=======================================================================
C
      DO 60,NRPASS = 1,NBPASS

C      POUR LE PASSAGE NUMERO NRPASS :
C      . NOM DU CHAMP DE RESULTAT OU DE GRANDEUR
C      . NOM DU PARAMETRE DE SENSIBILITE

      LATABL = ZK24(ADRECG+2*NRPASS-2) (1:8)
      NOPASE = ZK24(ADRECG+2*NRPASS-1) (1:8)
      IF (NOPASE.EQ.' ') THEN
C                 12345678901234567890123456789012345678
        TITRES = '                                      '
      ELSE
        TITRES = ' ... SENSIBILITE AU PARAMETRE '//NOPASE
      END IF

C
C     ------------------------------------------------------------------
C
C                 --- TRAITEMENT DU MOT CLE "FILTRE" ---
C
C     ------------------------------------------------------------------
      NEWTAB = LATABL
      IF ( NPARFI .NE. 0 ) THEN
         NEWTA1 = '&&'//NOMPRO//'.FILTRE '
         CALL TBIMFI ( NPARFI, NEWTAB, NEWTA1 )
         NEWTAB = NEWTA1
      ENDIF 
C     ------------------------------------------------------------------
C
      WRITE (IFIC,*) '---- TABLE: ', LATABL, ' NOM_PARA: ', PARA,TITRES
      CALL UTEST3 ( IFIC, ' ', 1 )
C
      IF ( N1. NE. 0 ) THEN
         CALL UTEST0 ( NEWTAB, PARA, TYPTES, TYPR, REFI, REFR, REFC, 
     +                                       PREC, CRIT, IFIC )
         GOTO 9999 
      ENDIF
C
      CALL TBLIVA ( NEWTAB, 0, K8B, IBID, R8B, CBID, K8B, K8B, R8B, 
     +                      PARA, CTYPE, VALI, VALR, VALC, VALK, IRET )
      IF ( IRET .EQ. 0 ) THEN
      ELSEIF ( IRET .EQ. 1 ) THEN
         WRITE (IFIC,*) TESTOK,' LE NOM_PARA N''EXISTE PAS '
         GOTO 9999
      ELSEIF ( IRET .EQ. 2 ) THEN
         WRITE (IFIC,*) TESTOK,' 0 LIGNE TROUVEE POUR LES NOM_PARA '
         GOTO 9999
      ELSEIF ( IRET .EQ. 3 ) THEN
         WRITE (IFIC,*) TESTOK,' PLUSIEURS LIGNES TROUVEES '
         GOTO 9999
      ELSE
         WRITE (IFIC,*) TESTOK,' CODE RETOUR DE "TBLIVA" INCONNU '
         GOTO 9999
      ENDIF
      IF ( CTYPE(1:1) .NE. TYPR ) THEN
         WRITE (IFIC,*) TESTOK,' LES TYPES NE CORRESPONDENT PAS '
         GOTO 9999
      ENDIF
      CALL UTITES ( LABEL, PARA, TYPR, REFI, REFR, REFC,
     +                           VALI, VALR, VALC, PREC, CRIT, IFIC )
C
 9999 CONTINUE
      IF ( NPARFI .NE. 0 )  CALL DETRSD ( 'TABLE' , NEWTA1 )
   60 CONTINUE
      CALL JEDETR(NORECG)
C
1000  FORMAT(/,80('-'))
      CALL JEDEMA ( )
C
      END
