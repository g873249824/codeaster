      SUBROUTINE OP0032()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 09/10/2012   AUTEUR MACOCCO K.MACOCCO 
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
C     VERIFICATION DU NOMBRE DE FREQUENCES DANS UNE BANDE DONNEE PAR LA
C     METHODE DITE DE STURM
C     ------------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      REAL*8       OMEGA2,OMGMIN,OMGMAX,OMIN,OMAX,FCORIG,OMECOR
      REAL*8       FMIN,FMAX,PRECDC,RBID,FREQOM,MANTIS
      COMPLEX*16   CBID
      INTEGER      IUNIFI, N1, ISLVK, ISLVI, JREFA, NPREC
      INTEGER      EXPO  , PIVOT1, PIVOT2, MXDDL, NBRSS,IERD
      INTEGER      NBLAGR, NBCINE, NEQACT, NEQ, IBID
      INTEGER      LTYPRE, L, LPR, LBRSS, LMASSE, LRAIDE, LDDL, LDYNAM,
     &             LPROD, IFR, IRET, ICOMP, IERX, NBFREQ, KREFA
      LOGICAL      ULEXIS
      CHARACTER*19 MASSE ,RAIDE,DYNAM,SOLVEU
      CHARACTER*24 VALK(2),METRES
      CHARACTER*8  KBID
      CHARACTER*16 CONCEP,NOMCMD,TYPRES,FICHIE
      PARAMETER   ( MXDDL=1 )
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
C
C
C --- POUR NE PAS DECLANCHER INUTILEMENT LE CALCUL DU DETERMINANT DANS
C     VPSTUR
      EXPO=-9999

      FMIN = 0.D0
C     --- TYPE DE CALCUL : DYNAMIQUE OU FLAMBEMENT ---
C     TYPE_RESU : 'DYNAMIQUE' OU 'FLAMBEMENT'
      CALL GETVTX(' ','TYPE_RESU',1,1,1,TYPRES,LTYPRE)
      IF (TYPRES . EQ. 'DYNAMIQUE') THEN
        CALL GETVR8(' ','FREQ_MIN' ,1,1,1,FMIN,L)
        CALL GETVR8(' ','FREQ_MAX' ,1,1,1,FMAX,L)
        OMIN = OMEGA2(FMIN)
        OMAX = OMEGA2(FMAX)
      ELSE
        CALL GETVR8(' ','CHAR_CRIT_MIN' ,1,1,1,OMIN,L)
        CALL GETVR8(' ','CHAR_CRIT_MAX' ,1,1,1,OMAX,L)
      ENDIF
      CALL GETVR8(' ','SEUIL_FREQ',1,1,1,FCORIG,L)
      CALL GETVR8(' ','PREC_SHIFT',1,1,1,PRECDC,L)
CC
C     --- RECUPERATION DES ARGUMENTS CONCERNANT LA NOMBRE DE SHIFT ---
      CALL GETVIS(' ','NMAX_ITER_SHIFT',1,1,1,NBRSS,LBRSS)
C
      IF (OMIN .GE. OMAX ) THEN
         CALL U2MESS('F','ALGELINE2_29')
      ENDIF

C
C     --- FICHIER D'IMPRESSION ---
C
      IFR    = 0
      FICHIE = ' '
      CALL GETVIS ( ' ', 'UNITE'  , 1,1,1, IFR   , N1 )
      IF ( .NOT. ULEXIS( IFR ) ) THEN
         CALL ULOPEN ( IFR, ' ', FICHIE, 'NEW', 'O' )
      ENDIF
C
      CALL GETRES( KBID , CONCEP , NOMCMD )
C
C     --- CONTROLE DES REFERENCES ---
      CALL GETVID(' ','MATR_A',1,1,1,RAIDE,L)
      CALL GETVID(' ','MATR_B',1,1,1,MASSE,L)
      CALL VRREFE(MASSE,RAIDE,IRET)
      IF ( IRET .NE. 0 ) THEN
          VALK(1) = RAIDE
          VALK(2) = MASSE
          CALL U2MESK('F','ALGELINE2_30', 2 ,VALK)
      ENDIF

C     ------------------------------------------------------------------
C     ----------- LECTURE/TRAITEMENT SD SOLVEUR LINEAIRE  -----------
C     ------------------------------------------------------------------
C     -- LECTURE DES PARAMETRES SOLVEURS LINEAIRES ET CREATION DE
C        LA SD SOLVEUR ASSOCIEE. CETTE SD SOLVEUR EST LOCALE A L'OPERA
C        TEUR. POUR CE CALCUL, C'EST ELLE QUI EST UTILISEE POUR PARAME
C        TREE LE SOLVEUR LINEAIRE, ET NON PAS LA SD SOLVEUR CREE PAR LA
C        CMDE ECLATEE NUME_DDL LORS DE LA CONSTITUTION DES MATRICES.
      CALL JEVEUO(RAIDE//'.REFA','L',JREFA)
      SOLVEU='&&OP0032.SOLVEUR'
      CALL CRESOL(SOLVEU,' ')
      CALL JEVEUO(SOLVEU//'.SLVK','L',ISLVK)
      CALL JEVEUO(SOLVEU//'.SLVI','L',ISLVI)
      NPREC=ZI(ISLVI)
      METRES=ZK24(ISLVK)
      IF ((METRES(1:4).NE.'LDLT').AND.(METRES(1:8).NE.'MULT_FRO').AND.
     &    (METRES(1:5).NE.'MUMPS')) CALL U2MESS('F','ALGELINE5_71')

C     -- CAS PARTICULIER 1: NUME_DDL_GENE, ON IMPOSE METRES=MUMPS
      IF ((ZK24(JREFA+9)(1:4).EQ.'GENE').AND. 
     &  (METRES(1:8).EQ.'MULT_FRO')) THEN        
        CALL CRSVL2(SOLVEU,NPREC,RAIDE)
      ENDIF
      NPREC=ZI(ISLVI)
      METRES=ZK24(ISLVK)
C
C     CREATION DE LA MATRICE DYNAMIQUE
      DYNAM = '&&OP0032.MATR_DYNAM'
      CALL MTDEFS ( DYNAM, RAIDE, 'V', ' ' )
      CALL JEVEUO(DYNAM(1:19)//'.REFA','E',KREFA)
      ZK24(KREFA-1+7)=SOLVEU

C
      CALL MTDSCR(MASSE)
      CALL JEVEUO(MASSE(1:19)//'.&INT','E',LMASSE)
      CALL MTDSCR(RAIDE)
      CALL JEVEUO(RAIDE(1:19)//'.&INT','E',LRAIDE)
      CALL MTDSCR(DYNAM)
      CALL JEVEUO(DYNAM(1:19)//'.&INT','E',LDYNAM)

C     TEST DE LA VALIDITE DES MATRICES PAR RAPPORT AU PERIMETRE DU
C     TEST DE STURM
      IF ((ZI(LMASSE+3).NE.1).OR.(ZI(LMASSE+4).NE.1)) THEN
         VALK(1)=MASSE
         CALL U2MESK('F','ALGELINE3_48', 1 ,VALK)
      ENDIF
      IF ((ZI(LRAIDE+3).NE.1).OR.(ZI(LRAIDE+4).NE.1)) THEN      
         VALK(1)=RAIDE
         CALL U2MESK('F','ALGELINE3_48', 1 ,VALK)
      ENDIF



C     CALCUL DU NOMBRE DE LAGRANGE
      NEQ = ZI(LRAIDE+2)
      CALL WKVECT('&&OP0032.POSITION.DDL','V V I',NEQ*MXDDL,LDDL)
      CALL WKVECT('&&OP0032.DDL.BLOQ.CINE','V V I',NEQ,LPROD)
      CALL VPDDL(RAIDE, MASSE, NEQ, NBLAGR, NBCINE, NEQACT, ZI(LDDL),
     &           ZI(LPROD),IERD)
C
      IF (TYPRES.EQ.'DYNAMIQUE') THEN
        OMECOR=OMEGA2(FCORIG)
      ELSE
        OMECOR=FCORIG
      ENDIF

C     --- STURM AVEC LA BORNE MINIMALE ---
      OMGMIN = OMIN
      ICOMP = 0
  10  CONTINUE
         CALL VPSTUR(LRAIDE,OMGMIN,LMASSE,LDYNAM,MANTIS,
     &               EXPO,PIVOT1,IERX,SOLVEU)
         IF (IERX .NE. 0 ) THEN
           IF (ABS(OMGMIN) .LT. OMECOR) THEN
              OMGMIN=-OMECOR
              IF (TYPRES.EQ.'DYNAMIQUE') THEN
                WRITE(6,1600) FREQOM(OMGMIN)
              ELSE
                WRITE(6,3600) OMGMIN
              ENDIF
           ELSE
              IF (OMGMIN .GT. 0.D0) THEN
                  OMGMIN = (1.D0-PRECDC) * OMGMIN
              ELSE
                  OMGMIN = (1.D0+PRECDC) * OMGMIN
              ENDIF
           ENDIF
           ICOMP = ICOMP + 1
           IF (ICOMP.GT.NBRSS) THEN
              CALL U2MESS('A','ALGELINE2_31')
           ELSE
              IF (TYPRES.EQ.'DYNAMIQUE') THEN
                WRITE(6,1700) (PRECDC*100.D0),FREQOM(OMGMIN)
              ELSE
                WRITE(6,3700) (PRECDC*100.D0),OMGMIN
              ENDIF
              GOTO 10
           ENDIF
         ENDIF
C
C     --- STURM AVEC FREQ_MAX ---
      OMGMAX = OMAX
      ICOMP = 0
  20  CONTINUE
         CALL VPSTUR(LRAIDE,OMGMAX,LMASSE,LDYNAM,MANTIS,
     &               EXPO,PIVOT2,IERX,SOLVEU)
         IF (IERX .NE. 0 ) THEN
            IF (ABS(OMGMAX) .LT. OMECOR) THEN
                OMGMAX=OMECOR
                IF (TYPRES.EQ.'DYNAMIQUE') THEN
                  WRITE(6,1800) FREQOM(OMGMAX)
                ELSE
                  WRITE(6,3800) OMGMAX
                ENDIF
            ELSE
                IF (OMGMAX .GT. 0.D0 ) THEN
                   OMGMAX = (1.D0 + PRECDC) * OMGMAX
                ELSE
                   OMGMAX = (1.D0 - PRECDC) * OMGMAX
                ENDIF
            ENDIF
            ICOMP = ICOMP + 1
            IF (ICOMP.GT.NBRSS) THEN
               CALL U2MESS('A','ALGELINE2_32')
            ELSE
               IF (TYPRES.EQ.'DYNAMIQUE') THEN
                WRITE(6,1900) (PRECDC*100.D0),FREQOM(OMGMAX)
               ELSE
                WRITE(6,3900) (PRECDC*100.D0),OMGMAX
               ENDIF
               GOTO 20
            ENDIF
         ENDIF
C
C     --- IMPRESSION DU NOMBRE DE FREQUENCE DANS LA BORNE ---
      CALL VPECST(IFR,TYPRES,OMGMIN,OMGMAX,PIVOT1,PIVOT2,
     &            NBFREQ,NBLAGR)
C

C     --- DESTRUCTION DE LA MATRICE DYNAMIQUE
      CALL DETRSD('MATR_ASSE',DYNAM)
      CALL JEDEMA()

 1600 FORMAT('LA BORNE MINIMALE EST INFERIEURE A LA FREQUENCE ',
     &       'DE CORPS RIGIDE ON LA MODIFIE, ELLE DEVIENT',1PE12.5)
 1700 FORMAT('ON DIMINUE LA BORNE MINIMALE DE: ',1PE12.5,' POURCENTS',/,
     &        'LA BORNE MINIMALE DEVIENT: ',6X,1PE12.5)
 1800 FORMAT('LA BORNE MAXIMALE EST INFERIEURE A LA FREQUENCE ',
     &       'DE CORPS RIGIDE ON LA MODIFIE, ELLE DEVIENT: ',1PE12.5)
 1900 FORMAT('ON AUGMENTE LA BORNE MAXIMALE DE: ',1PE12.5,' POURCENTS',/
     &       ,'LA BORNE MAXIMALE DEVIENT:',8X,1PE12.5,/)
 3600 FORMAT('LA BORNE MINIMALE EST INFERIEURE A LA CHARGE CRITIQUE ',
     &       'NULLE ON LA MODIFIE, ELLE DEVIENT',1PE12.5)
 3700 FORMAT('ON DIMINUE LA BORNE MINIMALE DE: ',1PE12.5,' POURCENTS',/,
     &        'LA BORNE MINIMALE DEVIENT: ',6X,1PE12.5)
 3800 FORMAT('LA BORNE MAXIMALE EST INFERIEURE A LA CHARGE CRITIQUE ',
     &       'NULLE ON LA MODIFIE, ELLE DEVIENT: ',1PE12.5)
 3900 FORMAT('ON AUGMENTE LA BORNE MAXIMALE DE: ',1PE12.5,' POURCENTS',/
     &       ,'LA BORNE MAXIMALE DEVIENT:',8X,1PE12.5,/)
      END
