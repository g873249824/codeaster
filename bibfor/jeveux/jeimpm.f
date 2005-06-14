      SUBROUTINE JEIMPM ( CUNIT , CMESS )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 16/06/2000   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C TOLE CFT_720 CFT_726 CRP_18 CRS_508 CRS_512
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       CUNIT , CMESS
C ----------------------------------------------------------------------
C IMPRIME LA SEGMENTATION DE LA MEMOIRE
C
C IN  CUNIT  : NOM LOCAL DU FICHIER D'IMPRESSION
C IN  CMESS  : MESSAGE D'INFORMATION
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
C ----------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     +                 LONO    , HCOD    , CARA    , LUTI    , IMARQ
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     +                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     +                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     +                 DN2(N)
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
C
      INTEGER          ISSTAT
      COMMON /ICONJE/  ISSTAT
      CHARACTER *4     KSTAT
      COMMON /KSTAJE/  KSTAT
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      INTEGER          IDINIT   ,IDXAXD   ,ITRECH,ITIAD,ITCOL,LMOTS,IDFR
      COMMON /IXADJE/  IDINIT(2),IDXAXD(2),ITRECH,ITIAD,ITCOL,LMOTS,IDFR
C ----------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     ,IDIADD     , IDIADM     ,
     +               IDMARQ     , IDNOM      ,IDREEL     , IDLONG     ,
     +               IDLONO     , IDLUTI     ,IDNUM
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 ,IDIADD = 2 , IDIADM = 3 ,
     +               IDMARQ = 4 , IDNOM  = 5 ,IDREEL = 6 , IDLONG = 7 ,
     +               IDLONO = 8 , IDLUTI = 9 ,IDNUM  = 10 )
C DEB ------------------------------------------------------------------

      CHARACTER*32     NOM32
      CHARACTER*1      CLA
      INTEGER          ICL , K
C     ------------------------------------------------------------------
CDEB
      JULIST = IUNIFI ( CUNIT )
      IF ( JULIST .EQ. 0 ) GOTO 9999
      WRITE (JULIST,'(4A)' ) ('--------------------',K=1,4)
      WRITE (JULIST,'(A,/,2A)' ) '---- SEGMENTATION MEMOIRE',
     +                   '---- ',CMESS(1:MIN(72,LEN(CMESS)))
      WRITE (JULIST,'(4A)' ) ('--------------------',K=1,4)
      K  = 1
      DO 100 IZ=1,2
        ID = IDINIT(IZ)
        IF (ID .EQ. 0) GOTO 100
        WRITE (JULIST,'(4A)' ) ('--------------------',K=1,4)
        WRITE (JULIST,'(A,I4)') 'PARTITION : ',IZ
        WRITE (JULIST,'(4A)' ) ('--------------------',K=1,4)
   10   CONTINUE
        IS = ISZON ( JISZON + ID )
        IF ( IS .NE. 0 ) THEN
          ISD  = ISZON(JISZON + ID + 3 ) / ISSTAT
          IDOS = ISZON(JISZON + ID + 2 )
          ISF  = ISZON(JISZON + IS - 4 ) / ISSTAT
          ICL  = ISZON(JISZON + IS - 2 )
          IDCO = ISZON(JISZON + IS - 3 )
          CLA = ' '
          IF ( ICL .GT. 0 ) CLA = CLASSE(ICL:ICL)
          IDM = ID + 4
          NOM32 = ' '
          IM = 0
          IF ( ISF .NE. 1 .AND. IDOS .NE. 0 ) THEN
            IF ( IDCO .EQ. 0 ) THEN
              NOM32 = RNOM(JRNOM(ICL)+IDOS)
              IM = IMARQ(JMARQ(ICL)+2*IDOS-1)
            ELSE
              NOM32(1:24) = RNOM(JRNOM(ICL)+IDCO)
              IBACOL = IADM(JIADM(ICL)+IDCO)
              IXMARQ = ISZON( JISZON+IBACOL+IDMARQ )
              IBMARQ = IADM(JIADM(ICL)+IXMARQ)
              IM = ISZON(JISZON+IBMARQ-1+2*IDOS-1)
              WRITE ( NOM32(25:32) , '(I8)') IDOS
            ENDIF
          ENDIF
          IL  = ( IS - ID - 8 )
          IF (KSTAT(ISD:ISD) .EQ.'X' .AND. KSTAT(ISF:ISF) .EQ.'X') THEN
            IDOS = 0
            IDCO = 0
            NOM32 = '<<<<         LIBRE          >>>>'
          ENDIF
          IF ( MOD (K,50) .EQ. 1 ) THEN
             WRITE ( JULIST , '(/A,A/)')
     +       ' CL-  --NUM-- -MA- --IADM-- -U- - LON UA -  -S- ',
     +       '------------- NOM --------------'
          END IF
          WRITE(JULIST,
     +    '(1X,A1,1X,I4,1X,I6,1X,I4,1X,I9,1X,A1,1X,I11,2X,A1,2X,A)')
     +     CLA,IDCO,IDOS,IM,IDM,KSTAT(ISD:ISD),IL,KSTAT(ISF:ISF),NOM32
          K   = K + 1
          ID  = IS
          GO TO 10
        ENDIF
 100  CONTINUE
 9999 CONTINUE
C FIN ------------------------------------------------------------------
      END
