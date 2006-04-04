      SUBROUTINE CSMBC8(NOMMAT,CCLL,CCJJ,NEQ,VCINE,VSMB)
      IMPLICIT NONE
      CHARACTER*(*) NOMMAT
      COMPLEX*16 VSMB(*),VCINE(*)
      INTEGER CCLL(*),CCJJ(*),NEQ
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 04/04/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C BUT : CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES DDLS IMPOSES
C       LORSQU'ILS SONT TRAITEES PAR ELIMINATION (CAS COMPLEXE)
C C.F. EXPLICATIONS DANS LA ROUTINE CSMBGG
C-----------------------------------------------------------------------
C IN  NOMMAT K19 : NOM DE LA MATR_ASSE
C IN  CCLL   I(*): TABLEAU .CCLL DE LA MATRICE
C IN  CCJJ   I(*): TABLEAU .CCJJ DE LA MATRICE
C IN  NEQ    I   : NOMBRE D'EQUATIONS
C VAR VSMB   R(*): VECTEUR SECOND MEMBRE
C IN  VCINE  R(*): VECTEUR DE CHARGEMENT CINEMATIQUE ( LE U0 DE U = U0
C                 SUR G AVEC VCINE = 0 EN DEHORS DE G )
C-----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C     COMMUNS JEVEUX
C-----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8,KBID
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C-----------------------------------------------------------------------
C     VARIABLES LOCALES
C-----------------------------------------------------------------------
      INTEGER JCCVA,JCCID,NELIM,IELIM,IEQ,J
      INTEGER DECIEL,KTERM,NTERM
      COMPLEX*16 COEF
      CHARACTER*19 MAT
C-----------------------------------------------------------------------
C     DEBUT
      CALL JEMARQ()
C-----------------------------------------------------------------------
      MAT = NOMMAT

      CALL JEVEUO(MAT//'.CCVA','L',JCCVA)
      CALL JELIRA(MAT//'.CCLL','LONMAX',NELIM,KBID)
      NELIM=NELIM/3

      DO 20 IELIM = 1,NELIM
        IEQ =    CCLL(3*(IELIM-1)+1)
        NTERM =  CCLL(3*(IELIM-1)+2)
        DECIEL = CCLL(3*(IELIM-1)+3)
        COEF = VCINE(IEQ)
        IF (COEF.NE.0.D0) THEN
          DO 10 KTERM = 1,NTERM
            J=CCJJ(DECIEL+KTERM)
            VSMB(J) = VSMB(J) - COEF*ZC(JCCVA-1+DECIEL+KTERM)
   10     CONTINUE
        END IF

   20 CONTINUE
      CALL JELIBE(MAT//'.CCVA')


      CALL JEVEUO(MAT//'.CCID','L',JCCID)
      DO 30 IEQ = 1,NEQ
        IF (ZI(JCCID-1+IEQ).EQ.1) THEN
          VSMB(IEQ) = VCINE(IEQ)
        ELSE
          IF (VCINE(IEQ).NE.DCMPLX(0.D0,0.D0)) CALL UTMESS('F',
     & 'CSMBC8','CHAM_CINE /= O. SUR DES DDLS NON ELIMINES.')
        END IF

   30 CONTINUE

      CALL JEDEMA()
      END
