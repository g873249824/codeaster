      SUBROUTINE JEUNDF(OBJ)
C RESPONSABLE PELLET J.PELLET
C A_UTIL
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
      INCLUDE 'jeveux.h'
      CHARACTER*(*) OBJ
C ----------------------------------------------------------------------
C     BUT : METTRE A "UNDEF" UN OBJET JEVEUX
C             I   :  ISMAEM()
C             L   :  .FALSE.
C             R   :  R8NNEM()
C             C   :  DCMPLX(R8NNEM(),R8NNEM())
C             K*  : 'XXXXXXXXXXXXXX'
C
C     OBJ   IN/JXVAR  K24 : NOM DE L'OBJET
C
      CHARACTER*24 OBJ2
      REAL*8 R1UNDF,R8NNEM
      CHARACTER*8 TYPSCA,K8DF
      CHARACTER*16 K16DF
      CHARACTER*24 K24DF
      CHARACTER*32 K32DF
      CHARACTER*80 K80DF
      CHARACTER*1 XOUS,TYPE,KBID
      COMPLEX*16 C1UNDF
      INTEGER LONG,ISMAEM,I1UNDF,IBID,LTYP,IAD,K
C DEB-------------------------------------------------------------------
C
      CALL JEMARQ()
      OBJ2=OBJ

      I1UNDF=ISMAEM()
      R1UNDF=R8NNEM()
      C1UNDF=DCMPLX(R1UNDF,R1UNDF)
      K8DF='XXXXXXXX'
      K16DF=K8DF//K8DF
      K24DF=K16DF//K8DF
      K32DF=K24DF//K8DF
      K80DF=K32DF//K32DF//K16DF


C     -- DETERMINATION DE TYPSCA :
C     -----------------------------
      CALL JELIRA(OBJ2,'TYPE',IBID,TYPE)
      IF (TYPE.EQ.'K') THEN
        CALL JELIRA(OBJ2,'LTYP',LTYP,KBID)
        IF (LTYP.EQ.8) THEN
          TYPSCA='K8'
        ELSE IF (LTYP.EQ.16) THEN
          TYPSCA='K16'
        ELSE IF (LTYP.EQ.24) THEN
          TYPSCA='K24'
        ELSE IF (LTYP.EQ.32) THEN
          TYPSCA='K32'
        ELSE IF (LTYP.EQ.80) THEN
          TYPSCA='K80'
        ELSE
          CALL ASSERT(.FALSE.)
        END IF
      ELSE
        TYPSCA=TYPE
      END IF

      CALL JELIRA(OBJ2,'XOUS',IBID,XOUS)
C     TEST CAS NON PROGRAMME
      CALL ASSERT(XOUS.NE.'X')

      CALL JELIRA(OBJ2,'LONMAX',LONG,KBID)
      CALL JEVEUO(OBJ2,'E',IAD)


      IF (TYPSCA.EQ.'I') THEN
        DO 10,K=1,LONG
          ZI(IAD-1+K)=I1UNDF
10      CONTINUE
      ELSE IF (TYPSCA.EQ.'L') THEN
        DO 20,K=1,LONG
          ZL(IAD-1+K)=.FALSE.
20      CONTINUE
      ELSE IF (TYPSCA.EQ.'R') THEN
        DO 30,K=1,LONG
          ZR(IAD-1+K)=R1UNDF
30      CONTINUE
      ELSE IF (TYPSCA.EQ.'C') THEN
        DO 40,K=1,LONG
          ZC(IAD-1+K)=C1UNDF
40      CONTINUE
      ELSE IF (TYPSCA.EQ.'K8') THEN
        DO 50,K=1,LONG
          ZK8(IAD-1+K)=K8DF
50      CONTINUE
      ELSE IF (TYPSCA.EQ.'K16') THEN
        DO 60,K=1,LONG
          ZK16(IAD-1+K)=K16DF
60      CONTINUE
      ELSE IF (TYPSCA.EQ.'K24') THEN
        DO 70,K=1,LONG
          ZK24(IAD-1+K)=K24DF
70      CONTINUE
      ELSE IF (TYPSCA.EQ.'K32') THEN
        DO 80,K=1,LONG
          ZK32(IAD-1+K)=K32DF
80      CONTINUE
      ELSE IF (TYPSCA.EQ.'K80') THEN
        DO 90,K=1,LONG
          ZK80(IAD-1+K)=K80DF
90      CONTINUE
      ELSE
        CALL ASSERT(.FALSE.)
      END IF


      CALL JEDEMA()
      END
