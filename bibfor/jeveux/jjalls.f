      SUBROUTINE JJALLS(LONOI,IC,GENRI,TYPEI,LTY,CI,ITAB,JITAB,IADMI,
     &                  IADYN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 04/12/2012   AUTEUR LEFEBVRE J-P.LEFEBVRE 
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
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
C TOLE CRP_6 CRS_505
      IMPLICIT NONE
      INCLUDE 'jeveux_private.h'
      INTEGER            LONOI,LTY,ITAB(*),JITAB,IADMI,IADYN
      CHARACTER*(*)            GENRI,TYPEI     ,CI
C ----------------------------------------------------------------------
C ALLOUE UN SEGMENT DE VALEUR EN MEMOIRE
C
C IN  LONOI  : LONGUEUR EN OCTETS DU SEGMENT DE VALEUR
C IN  IC     : CLASSE DE L'OBJET
C IN  GENRI  : GENRE DE L'OBJET JEVEUX
C IN  TYPEI  : TYPE DE L'OBJET JEVEUX
C IN  LTY    : LONGUEUR DU TYPE DE L'OBJET JEVEUX
C IN  CI     : = 'INIT' POUR INITIALISER LE SEGMENT DE VALEUR
C IN  ITAB   : TABLEAU PAR RAPPORT AUQUEL ON DETERMINE JITAB
C OUT JITAB  : ADRESSE DANS ITAB DU SEGMENT DE VALEUR
C OUT IADMI  : ADRESSE DU PREMIER MOT DU SEGMENT DE VALEUR
C OUT IADYN  : ADRESSE DU TABLEAU ALLOUE DYNAMIQUEMENT
C ----------------------------------------------------------------------
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON 
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
C-----------------------------------------------------------------------
      INTEGER I ,IADA ,IDM ,IERR ,IESSAI ,ILDYNA ,JCARA
      INTEGER JDATE ,JHCOD ,JIADD ,JIADM ,JISZO2 ,JLONG ,JLONO
      INTEGER JLTYP ,JLUTI ,JMARQ ,LGBL ,LSI ,LSO
      INTEGER LTOT ,N ,NDE
C-----------------------------------------------------------------------
      PARAMETER      ( N = 5 )
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
      INTEGER          NBLMAX    , NBLUTI    , LONGBL    ,
     &                 KITLEC    , KITECR    ,             KIADM    ,
     &                 IITLEC    , IITECR    , NITECR    , KMARQ
      COMMON /IFICJE/  NBLMAX(N) , NBLUTI(N) , LONGBL(N) ,
     &                 KITLEC(N) , KITECR(N) ,             KIADM(N) ,
     &                 IITLEC(N) , IITECR(N) , NITECR(N) , KMARQ(N)
C ----------------------------------------------------------------------
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
      INTEGER          LBIS , LOIS , LOLS , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOR8 , LOC8
      INTEGER          LDYN , LGDYN , NBDYN , NBFREE
      COMMON /IDYNJE/  LDYN , LGDYN , NBDYN , NBFREE
      REAL *8         MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO
      COMMON /R8DYJE/ MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO(2)
C ----------------------------------------------------------------------
      INTEGER          INIT,IBLANC,VALLOC,LSIC
      INTEGER          IC,IVAL(4),UNMEGA
      LOGICAL          LINIT,LDEPS
      CHARACTER *8     CBLANC
      EQUIVALENCE    ( CBLANC,IBLANC )
      PARAMETER      ( NDE = 6)
C ----------------------------------------------------------------------
C REMARQUE : LE PARAMETER NDE EST AUSSI DEFINI DANS JXLIRO JXECRO
C ----------------------------------------------------------------------
      DATA CBLANC     /'        '/
C DEB ------------------------------------------------------------------
      LTOT  = 0
      JITAB = 0
      IADMI = 0
      IADYN = 0
      LINIT = ( CI(1:4) .EQ. 'INIT' )
      LSO = LONOI
C
C     LA TAILLE DU SEGMENT DE VALEURS EST AJUSTEE POUR S'ALLIGNER
C     SUIVANT LA LONGUEUR DU TYPE (SI SUPERIEUR A L'ENTIER)
C

      IF ( LTY .NE. LOIS ) THEN
        LSO = LSO + LTY
        IF ( MOD(LSO,LOIS) .NE. 0 ) LSO = (1 + LSO/LOIS) * LOIS
      ENDIF
C
C     LA TAILLE DU SEGMENT DE VALEURS EST AJUSTEE A LA LONGUEUR DE BLOC
C     SI ON EST COMPRIS ENTRE LGBL-(NDE*LOIS) ET LGBL POUR DISPOSER DE
C     LA PLACE MINIMUM NECESSAIRE POUR LES GROS OBJETS
C
      IF ( IC .NE. 0 ) THEN
        IF ( LONGBL(IC) .GT. 1 ) THEN
          LGBL = 1024*LONGBL(IC)*LOIS
          IF (LSO .GE. LGBL-NDE*LOIS .AND. LSO .LT. LGBL) THEN
            LSO = LGBL
          ENDIF
        ENDIF
      ENDIF
      CALL ASSERT(LSO.NE.0)
      LSI = LSO / LOIS
C
C     LE SEGMENT DE VALEURS EST ALLOUE DYNAMIQUEMENT 
C
      IESSAI = 0
      ILDYNA = 0
C
      LSIC = LSI + 8
 50   CONTINUE
      ILDYNA = ILDYNA+1
C
C     ON TESTE SI LE CUMUL DES ALLOCATIONS RESTE INFERIEUR A LA LIMITE  
C
      IF ( MCDYN+LSIC .GT. VMXDYN ) THEN
        IF ( ILDYNA .GT. 1 ) THEN
          UNMEGA=1048576
          IVAL(1)=(LSIC*LOIS)/UNMEGA
          IVAL(2)=NINT(VMXDYN*LOIS)/UNMEGA
          IVAL(3)=NINT(MCDYN*LOIS)/UNMEGA
          IVAL(4)=(LTOT*LOIS)/UNMEGA
          CALL JEIMPM ( 6 )
          CALL U2MESI('F','JEVEUX_62',4,IVAL)
        ELSE
C
C  ON APPELLE JJLDYN AVEC L'ARGUMENT -2 POUR EVITER DE REACTUALISER
C  LA LIMITE MEMOIRE VMXDYN
C       
          CALL JJLDYN(2,-2,LTOT)
          IF ( MCDYN+LSIC .GT. VMXDYN ) THEN
             CALL JJLDYN(0,-1,LTOT)
          ENDIF   
          GOTO 50
        ENDIF
      ENDIF
      IESSAI = IESSAI+1
      CALL  HPALLOC ( IADA , LSIC , IERR , 0 )
      IF ( IERR .EQ. 0 ) THEN
        VALLOC = LOC(ISZON)
        JISZO2 = (IADA - VALLOC)/LOIS
        IADMI  = JISZO2 + 5 - JISZON
        IDM    = JISZO2 + 1
        IADYN  = IADA
        MCDYN  = MCDYN + LSIC
        MXDYN  = MAX(MXDYN,MCDYN*LOIS)
        NBDYN  = NBDYN + 1
      ELSE
        IF ( IESSAI .GT. 1 ) THEN
          CALL JEIMPM ( 6 )
          IVAL(1)=LSIC*LOIS
          IVAL(2)=LTOT*LOIS
          CALL U2MESI('F','JEVEUX_60',2,IVAL)
        ELSE
          CALL JJLDYN(2,-2,LTOT)
          IF ( MCDYN+LSIC .GT. VMXDYN ) THEN
             CALL JJLDYN(0,-1,LTOT)
          ENDIF
          GOTO 50
        ENDIF
      ENDIF
C
      ISZON( IDM        ) = IDM + LSI + 8 - JISZON
      ISZON( IDM     +1 ) = 0
      ISZON( IDM     +2 ) = 0
      ISZON( IDM     +3 ) = ISTAT(1)
      ISZON( IDM+LSI+ 4 ) = ISTAT(1)
      ISZON( IDM+LSI+ 5 ) = 0
      ISZON( IDM+LSI+ 6 ) = 0
      ISZON( IDM+LSI+ 7 ) = 0
C
      LDEPS = .TRUE.
      CALL JXLOCS (ITAB, GENRI, LTY, LONOI, IADMI, LDEPS, JITAB)
C
      IF ( LINIT ) THEN
         INIT = 0
         IF ( TYPEI(1:1) .EQ. 'K' ) INIT = IBLANC
         DO 20 I = 1 , LSI
            ISZON ( JISZON+IADMI+I-1 ) = INIT
 20      CONTINUE
      END IF
C FIN ------------------------------------------------------------------
      END
