      SUBROUTINE JEDETC ( CLAS , SOUCH , IPOS )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 13/11/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux_private.h'
      CHARACTER*(*)       CLAS , SOUCH
      INTEGER                            IPOS
C ----------------------------------------------------------------------
C DESTRUCTION D'UN ENSEMBLE D'OBJETS JEVEUX
C
C IN  CLAS   : CLASSE DES OBJETS ( ' ' TOUTES LES BASES OUVERTES)
C IN  SOUCH  : SOUS-CHAINE RECHERCHEE
C IN  IPOS   : POSITION DE LA SOUS-CHAINE RECHERCHEE
C ----------------------------------------------------------------------
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON 
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      CHARACTER *24                     NOMCO
      CHARACTER *32    NOMUTI , NOMOS ,         NOMOC , BL32
      COMMON /NOMCJE/  NOMUTI , NOMOS , NOMCO , NOMOC , BL32
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
C-----------------------------------------------------------------------
      INTEGER IADMAR ,IADMI ,IADMOC ,IADYN ,IADYOC ,IBACOL ,IBIADD 
      INTEGER IBIADM ,IBLONO ,IBMARQ ,IXDESO ,IXIADD ,IXIADM ,IXLONO 
      INTEGER IXMARQ ,JCARA ,JDATE ,JDOCU ,JGENR ,JHCOD ,JIADD 
      INTEGER JIADM ,JLONG ,JLONO ,JLTYP ,JLUTI ,JMARQ ,JORIG 
      INTEGER JRNOM ,JTYPE ,K ,KK ,L ,LONOI ,N 

C-----------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
C
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
      INTEGER          NRHCOD    , NREMAX    , NREUTI
      COMMON /ICODJE/  NRHCOD(N) , NREMAX(N) , NREUTI(N)
      INTEGER          IFNIVO, NIVO
      COMMON /JVNIVO/  IFNIVO, NIVO
      INTEGER          LDYN , LGDYN , NBDYN , NBFREE
      COMMON /IDYNJE/  LDYN , LGDYN , NBDYN , NBFREE
C     ------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     ,IDIADD     , IDIADM     ,
     &               IDMARQ     ,
     &               IDLONO     , IDNUM
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 ,IDIADD = 2 , IDIADM = 3 ,
     &               IDMARQ = 4 ,
     &               IDLONO = 8 , IDNUM  = 10 )
C     ------------------------------------------------------------------
      INTEGER          NCLA1,NCLA2,IC,J,IRET,ID(IDNUM),NMAX,IADDI(2)
      CHARACTER*32     CRNOM,NOM32
      CHARACTER*1      KCLAS
C DEB ------------------------------------------------------------------
      L = LEN ( SOUCH )
      CALL ASSERT (IPOS+L .LE. 25 .AND. IPOS .GE. 0 .AND. L .NE. 0)
      KCLAS  = CLAS (1:MIN(1,LEN(CLAS)))
      IF ( KCLAS .EQ. ' ' ) THEN
        NCLA1 = 1
        NCLA2 = INDEX ( CLASSE , '$' ) - 1
        IF ( NCLA2 .LT. 0 ) NCLA2 = N
      ELSE
        NCLA1 = INDEX ( CLASSE , KCLAS)
        NCLA2 = NCLA1
      ENDIF
      DO 100 IC = NCLA1 , NCLA2
        DO 160 KK = 1, 2
          DO 150 J = 1 , NREMAX(IC)
            CRNOM = RNOM(JRNOM(IC)+J)
            IF ( CRNOM(1:1) .EQ. '?' .OR.
     &          CRNOM(25:32) .NE. '        ' ) GOTO 150
            IF ( SOUCH .EQ. CRNOM(IPOS:IPOS+L-1) ) THEN
              CALL JJCREN ( CRNOM(1:24) , 0 , IRET )
              IF ( IRET .EQ. 1 .AND. KK .EQ. 2) THEN
                IADMI = IADM (JIADM(IC) + 2*IDATOS-1 )
                IADYN = IADM (JIADM(IC) + 2*IDATOS   )
                CALL JJLIDY( IADYN , IADMI )
                IADDI(1) = IADD (JIADD(IC) + 2*IDATOS-1 )
                IADDI(2) = IADD (JIADD(IC) + 2*IDATOS   )
                IF ( IADDI(1) .GT. 0 ) THEN
                  LONOI = LONO(JLONO(IC)+IDATOS)*LTYP(JLTYP(IC)+IDATOS)
                  CALL JXLIBD ( 0, IDATOS , IC , IADDI , LONOI )
                ENDIF
                IF (NIVO .GE. 2) THEN
                  CALL U2MESK('I','JEVEUX_7',1,CRNOM(1:24))
                ENDIF
                CALL JJCREN ( CRNOM(1:24) , -1 , IRET )
                NOMOS = '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
                CALL JJMZAT ( ICLAOS , IDATOS )
              ELSE IF( IRET .GT. 1 ) THEN
                CALL JJALLC (IC ,IDATCO ,'E' ,IBACOL )
                IXIADM = ISZON( JISZON + IBACOL + IDIADM )
                IXIADD = ISZON( JISZON + IBACOL + IDIADD )
                IXLONO = ISZON( JISZON + IBACOL + IDLONO )
                IXDESO = ISZON( JISZON + IBACOL + IDDESO )
                IXMARQ = ISZON( JISZON + IBACOL + IDMARQ )
                IF ( IXIADM .GT. 0 ) THEN
                  IBIADM = IADM ( JIADM(IC) + 2*IXIADM-1 )
                  IBIADD = IADM ( JIADM(IC) + 2*IXIADD-1 )
                  IBMARQ = IADM ( JIADM(IC) + 2*IXMARQ-1 )
                  NMAX   = ISZON(JISZON+IBACOL+IVNMAX )
                  DO 10 K = 1,NMAX
                    IADMAR = ISZON( JISZON + IBMARQ -1 + 2*K )
                    IF ( IADMAR .NE. 0 ) THEN
                      ISZON(JISZON+KDESMA(1)+IADMAR-1) = 0
                    ENDIF
                    IADMOC = ISZON( JISZON + IBIADM - 1 + 2*K-1 )
                    IADYOC = ISZON( JISZON + IBIADM - 1 + 2*K )
                    CALL JJLIDY( IADYOC , IADMOC )
                    IADDI(1) = ISZON( JISZON + IBIADD - 1 + 2*K-1 )
                    IADDI(2) = ISZON( JISZON + IBIADD - 1 + 2*K   )
                    IF ( IADDI(1) .GT. 0 ) THEN
                      IF ( IXLONO .GT. 0 ) THEN
                         IBLONO=IADM(JIADM(IC)+2*IXLONO-1)
                         LONOI =ISZON(JISZON+IBLONO+K-1)
     &                        *LTYP(JLTYP(IC)+IXDESO)
                      ELSE
                         LONOI = LONO(JLONO(IC)+IXDESO)
     &                        *LTYP(JLTYP(IC)+IXDESO)
                      ENDIF
                      CALL JXLIBD (IDATCO, K, IC, IADDI, LONOI)
                    ENDIF
 10               CONTINUE
                ENDIF
                DO 1 K = 1 , IDNUM
                  ID(K) = ISZON ( JISZON + IBACOL + K )
                  IF ( ID(K) .GT. 0 ) THEN
                    NOM32 = RNOM ( JRNOM(IC) + ID(K) )
                    IF ( NOM32(1:24) .EQ. CRNOM(1:24) .OR.
     &                  NOM32(25:26) .EQ. '&&'          ) THEN
                      IADMI = IADM (JIADM(IC) + 2*ID(K)-1 )
                      IADYN = IADM (JIADM(IC) + 2*ID(K)   )
                      CALL JJLIDY( IADYN , IADMI )
                      IADDI(1) = IADD (JIADD(IC) + 2*ID(K)-1 )
                      IADDI(2) = IADD (JIADD(IC) + 2*ID(K)   )
                      IF ( IADDI(1) .GT. 0 ) THEN
                        LONOI=LONO(JLONO(IC)+ID(K))
     &                        *LTYP(JLTYP(IC)+ID(K))
                        CALL JXLIBD ( 0 , ID(K) , IC , IADDI , LONOI )
                      ENDIF
                    ELSE
                      ID(K) = 0
                    ENDIF
                  ENDIF
 1              CONTINUE
                DO 2 K = 1 , IDNUM
                  IF ( ID(K) .GT. 0 ) THEN
                    NOM32 = RNOM ( JRNOM(IC) + ID(K) )
                    IF (NIVO .GE. 2) THEN
                      CALL U2MESK('I','JEVEUX_7',1,NOM32)
                    ENDIF
                    CALL JJCREN ( NOM32 , -2 , IRET )
                    CALL JJMZAT ( IC , ID(K) )
                  ENDIF
2               CONTINUE
                CRNOM = RNOM ( JRNOM(IC) + IDATCO )
                IADYN = IADM (JIADM(IC) + 2*IDATCO )
                CALL JJLIDY( IADYN , IBACOL )
                IADDI(1) = IADD (JIADD(IC) + 2*IDATCO-1)
                IADDI(2) = IADD (JIADD(IC) + 2*IDATCO  )
                IF ( IADDI(1) .GT. 0 ) THEN
                  LONOI = LONO(JLONO(IC)+IDATCO)*LTYP(JLTYP(IC)+IDATCO)
                  CALL JXLIBD ( 0 ,IDATCO, IC , IADDI , LONOI )
                ENDIF
                IF (NIVO .GE. 2) THEN
                  CALL U2MESK('I','JEVEUX_7',1,CRNOM(1:24))
                ENDIF
                CALL JJCREN ( CRNOM(1:24) , -2 , IRET )
                CALL JJMZAT ( IC , IDATCO )
                NOMCO = '$$$$$$$$$$$$$$$$$$$$$$$$'
              ENDIF
            ENDIF
 150      CONTINUE
 160    CONTINUE
 100  CONTINUE
C FIN ------------------------------------------------------------------
      END
