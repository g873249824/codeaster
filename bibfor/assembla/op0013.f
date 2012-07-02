      SUBROUTINE OP0013()
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*8 NU,VECAS,K8,VPROF
      CHARACTER*16 TYPV,OPER
      INTEGER TYPE
C
C     FONCTIONS JEVEUX
C
C
C
C
      CHARACTER*19 CH19
      INTEGER      IARG
C-----------------------------------------------------------------------
      INTEGER I ,IBID ,IFM ,ILICOE ,ILIVEC ,NBVEC ,NIV 

C-----------------------------------------------------------------------
      CALL JEMARQ()

      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
      CALL GETRES(VECAS,TYPV,OPER)
C
      CALL GETVID(' ','VECT_ELEM',0,IARG,0,K8,NBVEC)
      NBVEC = -NBVEC
C
C
      CALL JECREO(VECAS//'.LI2VECEL','V V K8 ')
      CALL JEECRA(VECAS//'.LI2VECEL','LONMAX',NBVEC,' ')
      CALL JEVEUO(VECAS//'.LI2VECEL','E',ILIVEC)
      CALL GETVID(' ','VECT_ELEM',0,IARG,NBVEC,ZK8(ILIVEC),NBVEC)
      CALL GETTCO(ZK8(ILIVEC),TYPV)
      IF (TYPV(16:16).EQ.'R') TYPE=1
      IF (TYPV(16:16).EQ.'C') TYPE=2

C
      CALL JECREO(VECAS//'.LICOEF','V V R ')
      CALL JEECRA(VECAS//'.LICOEF','LONMAX',NBVEC,' ')
      CALL JEVEUO(VECAS//'.LICOEF','E',ILICOE)
      DO 5 I = 1,NBVEC
         ZR(ILICOE-1+I) = 1.0D0
    5 CONTINUE
C
      CALL GETVID(' ','NUME_DDL',0,IARG,1,NU,IBID)
      VPROF = '        '
      CALL ASSVEC('G',VECAS,NBVEC,ZK8(ILIVEC),ZR(ILICOE),NU,VPROF,
     +            'ZERO',TYPE)
      CH19 = VECAS
      CALL JEDETR(CH19//'.LILI')
      CALL JEDETR(CH19//'.ADNE')
      CALL JEDETR(CH19//'.ADLI')
C
      CALL JEDEMA()
      END
