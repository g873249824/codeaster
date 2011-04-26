      SUBROUTINE CRLINU ( NONU, MLGNNO, NBNOE, NUMNOE, NOMNOE,
     +                    NBMTRD, JDNW, NUMMAI, KK )
      IMPLICIT  NONE
      INTEGER            NBNOE,NUMNOE(*),NUMMAI(*),NBMTRD,JDNW(*),KK
      CHARACTER*(*)      MLGNNO, NONU, NOMNOE(*)
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     -----------------------------------------------------------------
C     TRANSFORME UNE LISTE DE NOMS DE NOEUDS EN UNE LISTE DE
C     NUMEROS DE MAILLES TARDIVES POUR NOCART
C     -----------------------------------------------------------------
C     ---- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) ,ZK80(1)
      CHARACTER*32     JEXNOM
C     ----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER         J, K, INOE
      CHARACTER*8     NNOE
C     -----------------------------------------------------------------
C
      KK = 0
      DO 10 J = 1 , NBNOE
         IF ( NONU(1:3) .EQ. 'NUM' ) THEN
            INOE = NUMNOE(J)
         ELSE
            NNOE = NOMNOE(J)
            CALL JENONU(JEXNOM(MLGNNO,NNOE),INOE)
         ENDIF
         DO 20 K = 1 , NBMTRD
            IF ( JDNW(K*2-1) .EQ. INOE ) THEN
               KK = KK + 1
               NUMMAI(KK) = -K
               GOTO 10
            ENDIF
 20      CONTINUE
 10   CONTINUE
C
      END
