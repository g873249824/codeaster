      SUBROUTINE ASCARM(NOMSY,MONOAP,NBSUP,NSUPP,NEQ,NBMODE,VECMOD,
     +                  PARMOD,ID,REASUP,SPECTR,REPMOD,
     +                  CORFRE,AMORT)
      IMPLICIT  REAL*8 (A-H,O-Z)
      INTEGER           NSUPP(*)
      REAL*8            VECMOD(NEQ,*),SPECTR(*),AMORT(*)
      REAL*8            PARMOD(NBMODE,*)
      REAL*8            REPMOD(NBMODE,NBSUP,NEQ,*)
      REAL*8            REASUP(NBSUP,NBMODE,*)
      CHARACTER*(*)     NOMSY
      LOGICAL           MONOAP,CORFRE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/10/2000   AUTEUR PIBAT01 J.PIGAT 
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
C     COMMANDE : COMB_SISM_MODAL
C        CALCUL DE LA REPONSE POUR CHAQUE MODE
C     ------------------------------------------------------------------
C IN  : NOMSY  : OPTION DE CALCUL
C IN  : MONOAP : =.TRUE. , CAS DU MONO-APPUI
C IN  : NBSUP  : NOMBRE DE SUPPORT
C IN  : NSUPP  : MAX DU NOMBRE DE SUPPORT PAR DIRECTION
C IN  : NEQ    : NOMBRE D'EQUATIONS
C IN  : NBMODE : NOMBRE DE MODES
C IN  : VECMOD : VECTEUR DES MODES
C IN  : PARMOD : VECTEUR DES PARAMETRES MODAUX
C IN  : ID     : DIRECTION
C IN  : REASUP : TABLEAU DES REACTIONS MODALES AUX SUPPORTS
C IN  : SPECTR : TABLEAU DES VALEURS DU SPECTRE
C OUT : REPMOD : VECTEUR DES REPONSES MODALES
C IN  : CORFRE : = .TRUE.  , CORRECTION DES FREQUENCES
C IN  : AMORT  : VECTEUR DES AMORTISSEMENTS MODAUX

C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CALL JEMARQ()
      UN = 1.D0
C
C     --- CAS DU MONO-APPUI ---
      IF ( MONOAP ) THEN
         DO 10 IM = 1,NBMODE
            OMEGA = SQRT(PARMOD(IM,1))
            XAMO  = AMORT(IM)
            IF ( CORFRE ) OMEGA = OMEGA * SQRT( UN - XAMO*XAMO )
            OMEGA2 = OMEGA * OMEGA
            IND = ID + 3*(IM-1)
            XXX = ( PARMOD(IM,2+ID) * SPECTR(IND) ) / OMEGA2
            IF (NOMSY(1:4).EQ.'VITE') XXX = XXX * OMEGA
            IF (NOMSY(1:4).EQ.'ACCE') XXX = XXX * OMEGA2
            DO 12 IN = 1,NEQ
               REPMOD(IM,NBSUP,IN,ID) = XXX * VECMOD(IN,IM)
 12         CONTINUE
 10      CONTINUE
C
C     --- CAS DU MULTI-APPUI ---
      ELSE
         DO 20 IM = 1,NBMODE
            OMEGA = SQRT(PARMOD(IM,1))
            XAMO  = AMORT(IM)
            IF ( CORFRE ) OMEGA = OMEGA * SQRT( UN - XAMO*XAMO )
            OMEGA2 = OMEGA * OMEGA
            XXM = -UN / ( PARMOD(IM,2) * OMEGA2 * OMEGA2 )
            IF (NOMSY(1:4).EQ.'VITE') XXM = XXM * OMEGA
            IF (NOMSY(1:4).EQ.'ACCE') XXM = XXM * OMEGA2
            DO 22 IS = 1,NSUPP(ID)
               IND = ID + 3*(IM-1) + 3*NBMODE*(IS-1)
               XXX = REASUP(IS,IM,ID) * XXM * SPECTR(IND)
               DO 24 IN = 1,NEQ
                  REPMOD(IM,IS,IN,ID) = XXX * VECMOD(IN,IM)
 24            CONTINUE
 22         CONTINUE
 20      CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
