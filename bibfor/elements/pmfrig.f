      SUBROUTINE PMFRIG(NOMTE,E,XNU,KLV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/01/2003   AUTEUR DURAND C.DURAND 
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
      IMPLICIT NONE
      CHARACTER*(*) NOMTE
      REAL*8 E,XNU,KLV(*)
C     ------------------------------------------------------------------
C     CALCULE LA MATRICE DE RIGIDITE DES ELEMENTS DE POUTRE MULTIFIBRES

C IN  NOMTE : NOM DU TYPE ELEMENT
C             'MECA_POU_D_EM'
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CHARACTER*16 CH16
      INTEGER NBFIB,NCARFI,JACF
      INTEGER LX,LSECT,I ,JTAB(7),KK,KKK
      REAL*8 CASECT(6),G,XJX,GXJX,XL
      REAL*8 ZERO,UN,DEUX
      PARAMETER (ZERO=0.0D+0,UN=1.D+0,DEUX=2.D+0)
C     ------------------------------------------------------------------

C        --- POUTRE DROITE D'EULER A 6 DDL ---
      IF (NOMTE.NE.'MECA_POU_D_EM') THEN
        CH16 = NOMTE
        CALL UTMESS('F','ELEMENTS DE POUTRE',
     +              '"'//CH16//'"    NOM D''ELEMENT INCONNU.')
      END IF

      G = E/ (DEUX* (UN+XNU))

C     --- RECUPERATION DE LA CONSTANTE DE TORSION
C     --- (A PARTIR DES CARACTERISTIQUES GENERALES DES SECTIONS
C          POUR L'INSTANT)
      CALL JEVECH('PCAGNPO','L',LSECT)
      XJX = ZR(LSECT)
      GXJX = G*XJX

C     --- RECUPERATION DES CARACTERISTIQUES DES FIBRES :
      CALL JEVECH('PNBSP_I','L',I)
      NBFIB = ZI(I)
      CALL JEVECH('PFIBRES','L',JACF)
      NCARFI = 3


C     --- VERIFICATIONS PRUDENTES :
      CALL TECACH(.TRUE.,.TRUE.,'PFIBRES',7,JTAB)
      IF(JTAB(7).NE.NBFIB) CALL UTMESS('F','PMFRIG','STOP1')
      IF(JTAB(2).NE.NCARFI) CALL UTMESS('F','PMFRIG','STOP1')


C     --- CALCUL DES CARACTERISTIQUES INTEGREES DE LA SECTION ---
      CALL PMFITG(NBFIB,NCARFI,ZR(JACF),CASECT)

C     --- ON MULTIPLIE PAR E (CONSTANT SUR LA SECTION EN ELASTICITE)
      DO 10 I = 1,6
        CASECT(I) = E*CASECT(I)
   10 CONTINUE

C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH('PGEOMER','L',LX)
      LX = LX - 1
      XL = SQRT((ZR(LX+4)-ZR(LX+1))**2+ (ZR(LX+5)-ZR(LX+2))**2+
     +     (ZR(LX+6)-ZR(LX+3))**2)
      IF (XL.EQ.ZERO) THEN
        CH16 = ' ?????????'
        CALL UTMESS('F','ELEMENTS DE POUTRE',
     +              'NOEUDS CONFONDUS POUR UN ELEMENT: '//CH16(:8))
      END IF

C     --- CALCUL DE LA MATRICE DE RIGIDITE LOCALE
C        --- POUTRE DROITE A SECTION CONSTANTE ---
      CALL PMFK01(CASECT,GXJX,XL,KLV)


      END
