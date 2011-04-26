      INTEGER FUNCTION NDDL(ILI,NUNOEL,NEC,IDPRN1,IDPRN2)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER ILI, NUNOEL
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C----------------------------------------------------------------------
C IN  ILI    I : NUMERO DU GROUPE DANS LE LIGREL
C IN  NUNOEL I : NUMERO DU NOEUD
C OUT NDDL   I : NOMBRE DE DDLS DE CE NOEUD
C----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C----------------------------------------------------------------------
C----------------------------------------------------------------------
C     COMMUNS   JEVEUX
C----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------------------------------------------------------------------
C     FONCTION D ACCES A PRNO
C----------------------------------------------------------------------
      INTEGER ZZPRNO
      ZZPRNO(ILI,NUNOEL,L) = ZI(IDPRN1-1+ZI(IDPRN2+ILI-1)+
     +                     (NUNOEL-1)* (NEC+2)+L-1)
C---- DEBUT
      NDDL = 0
      DO 100 IEC = 1,NEC
         DO 10 J = 1,30
            K = IAND(ZZPRNO(ILI,NUNOEL,IEC+2),2**J)
            IF (K.GT.0) THEN
               NDDL = NDDL + 1

            END IF
   10    CONTINUE
  100 CONTINUE
      END
