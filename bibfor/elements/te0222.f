      SUBROUTINE TE0222(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 19/10/1999   AUTEUR CIBHHGB G.BERTRAND 
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
C.......................................................................
C
C     BUT: SYMETRISATION DES MATRICES ELEMENTAIRES NON_SYMETRIQUES
C          DE LA MANIERE SUIVANTE :
C          MAT2 = 1/2*(MAT1 + MAT1_T)
C
C          OPTION : 'SYME_MDNS_R  ' POUR LA MECANIQUE
C                   'SYME_MTNS_R  ' POUR LA THERMIQUE
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16       OPTION, NOMTE
      REAL*8             UNDEMI
      INTEGER            ITAB1(3), ITAB2(3)
      INTEGER            IJ, IDDL, JDDL, NDDL, IDMAT1, IDMAT2
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      UNDEMI = 0.5D0
C
      CALL TECACH(.TRUE.,.TRUE.,'PNOSYM',3,ITAB1)
      CALL TECACH(.TRUE.,.TRUE.,'PSYM',3,ITAB2)
C
      IF (ITAB1(1).LE.0) THEN
        CALL UTMESS('F','TE0222','LE PARAMETRE "PNOSYM" N''EXISTE PAS '
     +           //'DANS LE CATALOGUE DE L''ELEMENT '//NOMTE//' .')
      ENDIF
C
C --- NOMBRE DE LIGNES DE LA MATRICE ELEMENTAIRE NON-SYMETRIQUE 
C --- EN ENTREE :
C     ---------
      NDDL = NINT(SQRT(DBLE(ITAB1(2))))
C
      IF (ITAB1(2).NE.(NDDL*NDDL)) THEN
        CALL UTMESS('F','TE0222', 'LA TAILLE DE LA MATRICE '//
     +              'NON-SYMETRIQUE EN ENTREE EST FAUSSE.')
      ENDIF
C
      IF (2*ITAB2(2).NE.(NDDL*(NDDL+1))) THEN
        CALL UTMESS('F','TE0222', 'LA TAILLE DE LA MATRICE '//
     +              'SYMETRIQUE EN SORTIE EST FAUSSE.')
      ENDIF
C
      IJ = 0
      IDMAT1 = ITAB1(1)
      IDMAT2 = ITAB2(1)
C
      DO 10 IDDL = 1, NDDL
        DO 20 JDDL = 1, IDDL
          IJ = IJ + 1
          ZR(IDMAT2+IJ-1) = UNDEMI*(ZR(IDMAT1+NDDL*(IDDL-1)+JDDL-1)
     +                            + ZR(IDMAT1+NDDL*(JDDL-1)+IDDL-1))
  20    CONTINUE
  10  CONTINUE
C
      END
