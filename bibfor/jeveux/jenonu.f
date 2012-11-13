      SUBROUTINE JENONU ( NOMLU , NUMO )
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
      CHARACTER *(*)      NOMLU
      INTEGER                     NUMO
C     ==================================================================
C-----------------------------------------------------------------------
      INTEGER IADMEX ,IADMI ,IBACOL ,IPGCEX ,JCARA ,JCTAB ,JDATE 
      INTEGER JHCOD ,JIADD ,JIADM ,JLONG ,JLONO ,JLTYP ,JLUTI 
      INTEGER JMARQ ,N 
C-----------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
      CHARACTER *32    NOML32
      INTEGER          ICRE , IRET, ITAB
C     ------------------------------------------------------------------
      NUMO = 0
      IPGCEX = IPGC
      IPGC = -2
C
      IF ( LEN(NOMLU) .NE. 32 ) CALL U2MESK('F','JEVEUX_24',1,NOMLU)
C
      ICRE = 0
      NOML32 = NOMLU
      CALL JJVERN ( NOML32 , ICRE , IRET )
C
      IF ( IRET .EQ. 0 ) CALL U2MESK('F','JEVEUX_23',1,NOML32)

      IF ( IRET .EQ. 1 ) THEN
C       ----- OBJET DE TYPE REPERTOIRE
        IADMI  = IADM ( JIADM(ICLAOS) + 2*IDATOS-1 )
        IADMEX = IADMI
        IF ( IADMEX .EQ. 0 ) THEN
           CALL JXVEUO ( 'L' , ITAB , IRET , JCTAB )
        ENDIF
        CALL JJCROC ( '        ' , ICRE )
        IF ( IADMEX .EQ. 0 ) THEN
           CALL JJLIDE ( 'JENONU' , NOML32 , IRET )
        ENDIF

      ELSE IF ( IRET .EQ. 2 ) THEN
C       ----- REPERTOIRE DE COLLECTION --
        CALL JJALLC ( ICLACO , IDATCO , 'L' , IBACOL )
        CALL JJCROC ( NOML32(25:32) , ICRE )
        CALL JJLIDE ('JENONU' , NOML32(1:24) , IRET )
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      NUMO = IDATOC
      IPGC = IPGCEX
C
      END
