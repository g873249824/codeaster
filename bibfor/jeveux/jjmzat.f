      SUBROUTINE JJMZAT ( ICLAS , IDAT )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_18  CRS_508
      IMPLICIT NONE
C     ==================================================================
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
C-----------------------------------------------------------------------
      INTEGER IADMAR ,ICLAS ,IDAT ,JCARA ,JDATE ,JDOCU ,JGENR 
      INTEGER JHCOD ,JIADD ,JIADM ,JLONG ,JLONO ,JLTYP ,JLUTI 
      INTEGER JMARQ ,JORIG ,JRNOM ,JTYPE ,N 
C-----------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     +                 LONO    , HCOD    , CARA    , LUTI    , IMARQ   
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     +                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     +                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
C
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
C DEB ------------------------------------------------------------------
      LTYP( JLTYP(ICLAS) + IDAT ) = 0
      LONG( JLONG(ICLAS) + IDAT ) = 0
      DATE( JDATE(ICLAS) + IDAT ) = 0
      IADD( JIADD(ICLAS) + 2*IDAT-1 ) = 0
      IADD( JIADD(ICLAS) + 2*IDAT   ) = 0
      IADM( JIADM(ICLAS) + 2*IDAT-1 ) = 0
      IADM( JIADM(ICLAS) + 2*IDAT   ) = 0
      LONO( JLONO(ICLAS) + IDAT ) = 0
      LUTI( JLUTI(ICLAS) + IDAT ) = 0
      GENR( JGENR(ICLAS) + IDAT ) = ' '
      TYPE( JTYPE(ICLAS) + IDAT ) = ' '
      DOCU( JDOCU(ICLAS) + IDAT ) = '    '
      ORIG( JORIG(ICLAS) + IDAT ) = '        '
      IMARQ(JMARQ(ICLAS) + 2*IDAT-1 ) = 0
      IADMAR = IMARQ(JMARQ(ICLAS) + 2*IDAT)
      IF ( IADMAR.GT.0 ) THEN
        ISZON(JISZON+KDESMA(1)+IADMAR-1) = 0
        IMARQ(JMARQ(ICLAS) + 2*IDAT)  = 0
      ENDIF
C FIN ------------------------------------------------------------------
      END
