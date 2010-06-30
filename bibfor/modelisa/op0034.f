      SUBROUTINE OP0034()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
C      OPERATEURS :     AFFE_CHAR_THER AFFE_CHAR_THER_F
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*4  TYPE
      CHARACTER*8  CHAR
      CHARACTER*16 CONCEP,OPER
      INTEGER      IATYPE
C
      CALL JEMARQ()
      CALL INFMAJ
C
      CALL GETRES (CHAR, CONCEP, OPER)
      CALL WKVECT(CHAR//'.TYPE','G V K8',1,IATYPE)
      IF ( OPER .EQ. 'AFFE_CHAR_THER' ) THEN
         TYPE = 'REEL'
         ZK8(IATYPE) = 'THER_RE'
      ELSEIF ( OPER .EQ. 'AFFE_CHAR_THER_F' ) THEN
         TYPE = 'FONC'
         ZK8(IATYPE) = 'THER_FO'
      ENDIF

      CALL CHARTH(TYPE)

      CALL JEDEMA()
      END
