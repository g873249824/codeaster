      SUBROUTINE CSMBC8(NOMMAT,CCLL,CCII,NEQ,VCINE,VSMB)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) NOMMAT
      COMPLEX*16 VSMB(*),VCINE(*)
      INTEGER CCLL(*),CCII(*),NEQ
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C-----------------------------------------------------------------------
C BUT : CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES DDLS IMPOSES
C       LORSQU'ILS SONT TRAITEES PAR ELIMINATION (CAS COMPLEXE)
C C.F. EXPLICATIONS DANS LA ROUTINE CSMBGG
C-----------------------------------------------------------------------
C IN  NOMMAT K19 : NOM DE LA MATR_ASSE
C IN  CCLL   I(*): TABLEAU .CCLL DE LA MATRICE
C IN  CCII   I(*): TABLEAU .CCII DE LA MATRICE
C IN  NEQ    I   : NOMBRE D'EQUATIONS
C VAR VSMB   R(*): VECTEUR SECOND MEMBRE
C IN  VCINE  R(*): VECTEUR DE CHARGEMENT CINEMATIQUE ( LE U0 DE U = U0
C                 SUR G AVEC VCINE = 0 EN DEHORS DE G )
C-----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CHARACTER*8 KBID
C-----------------------------------------------------------------------
C     VARIABLES LOCALES
C-----------------------------------------------------------------------
      INTEGER JCCVA,JCCID,NELIM,IELIM,IEQ,J,JREFA,JNULG,IEQG
      INTEGER DECIEL,KTERM,NTERM,IMATD,JNUGL
      COMPLEX*16 COEF
      CHARACTER*14 NU
      CHARACTER*19 MAT
C-----------------------------------------------------------------------
C     DEBUT
      CALL JEMARQ()
C-----------------------------------------------------------------------
      MAT = NOMMAT

      CALL JEVEUO(MAT//'.CCVA','L',JCCVA)
      CALL JELIRA(MAT//'.CCLL','LONMAX',NELIM,KBID)
      NELIM=NELIM/3
      
      CALL JEVEUO(MAT//'.REFA','L',JREFA)
      IF (ZK24(JREFA-1+11).EQ.'MATR_DISTR') THEN
        IMATD = 1
        NU = ZK24(JREFA-1+2)(1:14)
        CALL JEVEUO(NU//'.NUML.NULG','L',JNULG)
        CALL JEVEUO(NU//'.NUML.NUGL','L',JNUGL)
      ELSE
        IMATD = 0
      ENDIF

      DO 20 IELIM = 1,NELIM
        IEQ =    CCLL(3*(IELIM-1)+1)
        NTERM =  CCLL(3*(IELIM-1)+2)
        DECIEL = CCLL(3*(IELIM-1)+3)
        
        IF ( IMATD.EQ.0 ) THEN
          IEQG = IEQ
        ELSE
          IEQG = ZI(JNULG-1+IEQ)
        ENDIF
        COEF = VCINE(IEQG)
        
        IF (COEF.NE.0.D0) THEN
          DO 10 KTERM = 1,NTERM
            IF ( IMATD.EQ.0 ) THEN
              J=CCII(DECIEL+KTERM)
            ELSE
              J=ZI( JNULG-1 + CCII(DECIEL+KTERM) )
            ENDIF
            VSMB(J) = VSMB(J) - COEF*ZC(JCCVA-1+DECIEL+KTERM)
   10     CONTINUE
        END IF

   20 CONTINUE
      CALL JELIBE(MAT//'.CCVA')
      
      IF ( IMATD.NE.0 ) THEN
        DO 40 IEQ = 1,NEQ
          IF ( ZI(JNUGL+IEQ-1).EQ.0 ) VCINE(IEQ) = 0.D0
   40   CONTINUE
      ENDIF


      CALL JEVEUO(MAT//'.CCID','L',JCCID)
      DO 30 IEQ = 1,NEQ
        IF (ZI(JCCID-1+IEQ).EQ.1) THEN
          VSMB(IEQ) = VCINE(IEQ)
        ELSE
          IF (VCINE(IEQ).NE.DCMPLX(0.D0,0.D0)) CALL U2MESS('F','ALGELINE
     &_32')
        END IF

   30 CONTINUE

      CALL JEDEMA()
      END
