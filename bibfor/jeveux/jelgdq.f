      SUBROUTINE JELGDQ ( NOMLU , RLONG , NBSV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 20/10/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C BUT:
C   DETERMINER LA LONGUEUR DES SEGMENTS DE VALEURS STOCKES SUR LA BASE
C   ET LE NOMBRE DE SEGMENT DE VALEURS ASSOCIES A L'OBJET NOMLU
C
C  IN    NOMLU : NOM DE L'OBJET
C  OUT   RLONG : CUMUL DES TAILLES EN OCTETS DES OBJETS ASSOCIES
C  OUT   NBSV  : NOMBRE DE SEGMENTS DE VALEURS ASSOCIES
C
C
C ----------------------------------------------------------------------
C TOLE CRS_508  CRS_512  CRP_18
      IMPLICIT NONE
      CHARACTER *(*)      NOMLU
      REAL*8              RLONG
      INTEGER             NBSV
C     ------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
      INTEGER      N
      PARAMETER  ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     &                 LONO    , HCOD    , CARA    , LUTI    , IMARQ
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     &                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      INTEGER          JLTYP   , JLONG   , JDATE   , JIADD   , JIADM   ,
     &                 JLONO   , JHCOD   , JCARA   , JLUTI   , JMARQ
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
C
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      INTEGER          JGENR   , JTYPE   , JDOCU   , JORIG   , JRNOM
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)

      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
C     ------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     , IDIADD     , IDIADM     ,
     &               IDMARQ     , IDNOM      ,              IDLONG     ,
     &               IDLONO     , IDLUTI     , IDNUM
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 , IDIADD = 2 , IDIADM = 3 ,
     &               IDMARQ = 4 , IDNOM  = 5 ,              IDLONG = 7 ,
     &               IDLONO = 8 , IDLUTI = 9 ,IDNUM  = 10 )
C     ------------------------------------------------------------------
      CHARACTER *32   NOML32
      INTEGER         IPGCEX, ICRE, IRET, IVAL, IC, ID, IBACOL, K, IX
      INTEGER         LTYPI, IXLONO, IXIADD, IBLONO, NMAX
C
      IPGCEX = IPGC
      IPGC = -2
      NOML32 = NOMLU
      RLONG  = 0.0D0
      NBSV = 0
      ICRE = 0
      IRET = 0
      CALL JJVERN ( NOML32 , ICRE , IRET )
C
      IF ( IRET .EQ. 0 ) THEN
        CALL U2MESK('F','JEVEUX_26',1,NOML32(1:24))

      ELSE IF ( IRET .EQ. 1 ) THEN
        IC = ICLAOS
        ID = IDATOS
        RLONG = LONO(JLONO(IC)+ID)*LTYP(JLTYP(IC)+ID)
        NBSV = NBSV + 1

      ELSE IF ( IRET .EQ. 2 ) THEN
        IC = ICLACO
        CALL JJALLC ( ICLACO , IDATCO , 'L', IBACOL )
        ID     = ISZON(JISZON + IBACOL + IDDESO )
        IXLONO = ISZON(JISZON + IBACOL + IDLONO )
        IXIADD = ISZON(JISZON + IBACOL + IDIADD )
        RLONG = IDNUM*LTYP(JLTYP(IC)+ID)
        NBSV = NBSV + 1
C
C --------OBJETS ATTRIBUTS DE COLLECTION
C
        DO 20 K = 1,IDNUM
          IX  = ISZON( JISZON + IBACOL + K )
          IF ( IX .GT. 0 ) THEN
            RLONG = RLONG + LONO(JLONO(IC)+IX)*LTYP(JLTYP(IC)+IX)
            NBSV = NBSV + 1
          ENDIF
 20     CONTINUE
C
C ------- CAS D'UNE COLLECTION DISPERSEE
C
        IF ( IXIADD .NE. 0 ) THEN
          NMAX = ISZON(JISZON + IBACOL+IVNMAX)
          LTYPI = LTYP(JLTYP(IC)+ID)
          IF ( IXLONO .NE. 0 ) THEN
            NMAX = ISZON(JISZON + IBACOL+IVNMAX)
            IBLONO = IADM (JIADM(IC) + 2*IXLONO-1)
            DO 10 K = 1,NMAX
              RLONG = RLONG + ISZON(JISZON+IBLONO-1+K)*LTYPI
              NBSV = NBSV + 1
 10         CONTINUE
          ELSE
            RLONG = RLONG + NMAX*LONO(JLONO(IC)+ID)*LTYPI
            NBSV = NBSV + 1
          ENDIF
        ENDIF
C
        CALL JJLIDE ( 'JEIMPA' , NOML32(1:24) , 2 )
      ENDIF
      IPGC = IPGCEX
      END
