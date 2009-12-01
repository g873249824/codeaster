      SUBROUTINE WPPGEN(LMASSE,LAMOR,LRAIDE,MASSEG,AMORG,RAIDEG,VECT,
     +                  NEQ,NBVECT,IDDL)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           LMASSE,LAMOR,LRAIDE  ,NEQ,NBVECT,IDDL(*)
      REAL*8                             MASSEG(*),AMORG(*),RAIDEG(*)
      COMPLEX*16                                             VECT(NEQ,*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 24/03/2009   AUTEUR REZETTE C.REZETTE 
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
C     CALCUL DES PARAMETRES MODAUX :
C            MASSE, AMORTISSEMENT ET RAIDEUR GENERALISES
C     ------------------------------------------------------------------
C IN  LMASSE : IS : DESCRIPTEUR NORMALISE DE LA MATRICE DE MASSE
C                   = 0  ON NE CALCULE PAS LA MASSE GENERALISEE
C IN  LAMOR  : IS : DESCRIPTEUR NORMALISE DE LA MATRICE D'AMORTISSEMENT
C                   = 0  ON NE CALCULE PAS L'AMORTISSEMENT GENERALISE
C IN  LRAIDE : IS : DESCRIPTEUR NORMALISE DE LA MATRICE DE RIGIDITE
C                   = 0  ON NE CALCULE PAS LA RIGIDITE GENERALISEE
C     ------------------------------------------------------------------
C     REMARQUE : ON FAIT LES CALCULS VECTEURS APRES VECTEURS
C              : C'EST PLUS LONG MAIS PAS DE PB DE TAILLE MEMOIRE
C     ------------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      COMPLEX*16   RVAL,  ZERO
      CHARACTER*24 VECAUX,VECAU1
C     ------------------------------------------------------------------
      DATA  VECAUX/'&&VPPGEN.VECTEUR.AUX0'/
      DATA  VECAU1/'&&VPPGEN.VECTEUR.AUX1'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
      ZERO = 0.D0
      CALL WKVECT( VECAUX,'V V C', NEQ , LAUX )
      CALL WKVECT( VECAU1,'V V C', NEQ , LAUX1)
      LAUX = LAUX - 1
      LAUX1= LAUX1- 1
C
C     --- CALCUL DE LA MASSE GENERALISEE ---
      IF ( LMASSE .NE. 0 ) THEN
         DO 100 IVECT = 1, NBVECT
            CALL MCMULT('ZERO',LMASSE,VECT(1,IVECT),'C',ZC(LAUX+1),1)
            RVAL = ZERO
            DO 110 IEQ = 1, NEQ
               RVAL = RVAL + DCONJG(VECT(IEQ,IVECT)) * ZC(LAUX+IEQ)
  110       CONTINUE
            MASSEG(IVECT) = DBLE(RVAL)
  100    CONTINUE
      ENDIF
C
C     --- CALCUL DE L'AMORTISSEMENT GENERALISE ---
      IF ( LAMOR .NE. 0 ) THEN
         DO 200 IVECT = 1, NBVECT
            CALL MCMULT('ZERO',LAMOR,VECT(1,IVECT),'C',ZC(LAUX+1),1)
            RVAL = ZERO
            DO 210 IEQ = 1, NEQ
               RVAL = RVAL + DCONJG(VECT(IEQ,IVECT)) * ZC(LAUX+IEQ)
  210       CONTINUE
            AMORG(IVECT) = DBLE(RVAL)
  200    CONTINUE
      ELSE
         DO 250 IVECT = 1, NBVECT
            AMORG(IVECT) = 0.D0
  250    CONTINUE
      ENDIF
C
C     --- CALCUL DE LA RAIDEUR GENERALISEE ---
      IF ( LRAIDE .NE. 0 ) THEN
         DO 300 IVECT = 1, NBVECT
            DO 305 IEQ = 1, NEQ
               ZC(LAUX1+IEQ) = VECT(IEQ,IVECT)*IDDL(IEQ)
  305       CONTINUE
            CALL MCMULT('ZERO',LRAIDE, ZC(LAUX1+1),'C',ZC(LAUX+1),1)
            RVAL = ZERO
            DO 310 IEQ = 1, NEQ
               RVAL = RVAL +
     +                   DCONJG(VECT(IEQ,IVECT))*ZC(LAUX+IEQ)*IDDL(IEQ)
  310       CONTINUE
            RAIDEG(IVECT) = DBLE(RVAL)
  300    CONTINUE
      ENDIF
C
      CALL JEDETR( VECAUX )
      CALL JEDETR( VECAU1 )
C
      CALL JEDEMA()
      END
