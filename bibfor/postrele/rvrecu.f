      SUBROUTINE RVRECU ( MCF, IOCC, CHAMP, CHAMPN, SENSOP, NOMVEC )
      IMPLICIT NONE
      INTEGER                  IOCC
      CHARACTER*18 SENSOP
      CHARACTER*(*)       MCF,       CHAMP, CHAMPN, NOMVEC
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 27/11/2006   AUTEUR GNICOLAS G.NICOLAS 
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
C     ------------------------------------------------------------------
C IN  IOCC   : INDICE DE L' OCCURENCE
C IN  CHAMP  : NOM DU CHAMP A TRAITER
C IN  SENSOP : OPTION POUR LA SENSIBILITE
C     ------------------------------------------------------------------
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CHARACTER*1   TYPE
      CHARACTER*8   K8B, FORM
      CHARACTER*19  NCH19, NCH19N
      CHARACTER*24  VECTEU
C
      REAL*8 A, B, C
      REAL*8 R8VIDE, R8PREM
      REAL*8 EPSIL, RUNDF
      INTEGER I, IBID, JVAL, JVALN, KVAL, N1, NEQ 
C
C==================== CORPS DE LA ROUTINE =============================
C
      CALL JEMARQ()
      NCH19 = CHAMP
      VECTEU = NOMVEC
      CALL JELIRA ( NCH19//'.VALE', 'TYPE', IBID, TYPE )
      IF ( TYPE .NE. 'C' ) THEN
         CALL U2MESS('F','POSTRELE_63')
      ENDIF
      CALL JELIRA ( NCH19//'.VALE', 'LONMAX', NEQ, K8B )
      CALL JEVEUO (NCH19//'.VALE', 'L', JVAL )
      CALL WKVECT ( VECTEU, 'V V R', NEQ, KVAL)
C
      CALL GETVTX ( MCF, 'FORMAT_C', IOCC, 1, 1, FORM, N1 )
C
      IF ( SENSOP.EQ.'SENSIBILITE_MODULE' ) THEN
        NCH19N = CHAMPN
        CALL JEVEUO (NCH19N//'.VALE', 'L', JVALN )
        EPSIL = R8PREM( )
        RUNDF = R8VIDE()
      ENDIF
C
      IF ( FORM .EQ. 'MODULE' ) THEN
C
        IF ( SENSOP.EQ.'MODULE_SENSIBILITE' ) THEN
          DO 11 I = 0 , NEQ-1
            A = DBLE( ZC(JVAL+I) )
            B = DIMAG( ZC(JVAL+I) )
            ZR(KVAL+I) = SQRT( A*A + B*B )
   11     CONTINUE
        ELSE
          DO 12 I = 0 , NEQ-1
            A = DBLE( ZC(JVALN+I) )
            B = DIMAG( ZC(JVALN+I) )
            C = A*A + B*B
            IF ( C.LT.EPSIL ) THEN
              C = RUNDF
            ELSE
              C = ( A*DBLE(ZC(JVAL+I)) + B*DIMAG(ZC(JVAL+I)) ) / SQRT(C)
            ENDIF
            ZR(KVAL+I) = C
   12     CONTINUE
        ENDIF
C
      ELSEIF ( FORM .EQ. 'REEL' ) THEN
        DO 20 I = 0 , NEQ-1
           ZR(KVAL+I) = DBLE( ZC(JVAL+I) )
 20     CONTINUE
C
      ELSEIF ( FORM .EQ. 'IMAG' ) THEN
        DO 30 I = 0 , NEQ-1
           ZR(KVAL+I) = DIMAG( ZC(JVAL+I) )
 30     CONTINUE
C
      ELSE
         CALL U2MESS('F','PREPOST_37')
      ENDIF
C
      CALL JEDEMA()
      END
