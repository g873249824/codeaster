      SUBROUTINE TE0142(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) OPTION,NOMTE
C     ------------------------------------------------------------------
C MODIF ELEMENTS  DATE 21/02/2006   AUTEUR FLANDI L.FLANDI 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     CALCUL
C       - DU VECTEUR ELEMENTAIRE EFFORT GENERALISE,
C       - DU VECTEUR ELEMENTAIRE CONTRAINTE
C     POUR LES ELEMENTS DE POUTRE D'EULER ET DE TIMOSHENKO.
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'EFGE_ELNO_DEPL'
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C        'MECA_POU_D_E' : POUTRE DROITE D'EULER (SECTION VARIABLE)
C        'MECA_POU_D_EM': POUTRE DROITE D'EULER (SECTION MULTIFIBRES)
C        'MECA_POU_D_T' : POUTRE DROITE DE TIMOSHENKO (SECTION VARIABLE)
C        'MECA_POU_C_T' : POUTRE COURBE DE TIMOSHENKO(SECTION CONSTANTE)
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

      PARAMETER (NBRES=4,NBREF=6)
      REAL*8 VALRES(NBRES),VALREF(NBREF)
      CHARACTER*2 CODRES(NBRES),CODREF(NBREF)
      CHARACTER*8 NOMPAR,NOMRES(NBRES),NOMREF(NBREF)
      CHARACTER*16 CH16
      REAL*8 ZERO,E,NU,ALPHA,RHO
      REAL*8 KLV(78),KLC(12,12)
      CHARACTER*24 SUROPT
C     ------------------------------------------------------------------
      DATA NOMRES/'E','NU','ALPHA','RHO'/
      DATA NOMREF/'E','NU','RHO','RHO_F_IN','RHO_F_EX','CM'/
C     --------------------------------------------------
      ZERO = 0.D0

C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---

      CALL JEVECH('PMATERC','L',LMATER)
      CALL TECACH('ONN','PTEMPER',1,ITEMPE,IRET)
      IF (ITEMPE.EQ.0) THEN
        NBPAR = 0
        NOMPAR = ' '
        VALPAR = ZERO
      ELSE
        NBPAR = 1
        NOMPAR = 'TEMP'
        VALPAR = 0.5D0*(ZR(ITEMPE) + ZR(ITEMPE+1))
      END IF
      CALL JEVECH('PSUROPT','L',LOPT)
      SUROPT = ZK24(LOPT)
      IF (SUROPT.EQ.'MASS_FLUI_STRU') THEN
        CALL JEVECH('PABSCUR','L',LABSC)
        CALL JEVECH('PCAGEPO','L',LCAGE)
        ABSMOY = (ZR(LABSC-1+1)+ZR(LABSC-1+2))/2.D0
        CALL RCVALA(ZI(LMATER),' ','ELAS_FLUI',1,'ABSC',ABSMOY,NBREF,
     &             NOMREF, VALREF,CODREF,'FM')
        E = VALREF(1)
        NU = VALREF(2)
        ALPHA = 0.D0
        RHOS = VALREF(3)
        RHOFI = VALREF(4)
        RHOFE = VALREF(5)
        CM = VALREF(6)
        PHIE = ZR(LCAGE-1+1)*2.D0
        IF (PHIE.EQ.0.D0) THEN
          CALL UTMESS('F','ELEMENTS DE POUTRE (TE0141)',
     &          'MAUVAISE DEFINITION DES CARACTERISTIQUES DE LA SECTION'
     &                )
        END IF
        PHII = (PHIE-2.D0*ZR(LCAGE-1+2))
        CALL RHOEQU(RHO,RHOS,RHOFI,RHOFE,CM,PHII,PHIE)

      ELSE
        CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,CODRES,'FM')
        CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,
     &             NOMRES(3), VALRES(3),CODRES(3),'  ')
        IF (CODRES(3).NE.'OK') VALRES(3) = ZERO
        IF (CODRES(4).NE.'OK') VALRES(4) = ZERO
        E = VALRES(1)
        NU = VALRES(2)
        ALPHA = VALRES(3)
        RHO = VALRES(4)
      END IF

C     --- CALCUL DE LA MATRICE DE RIGIDITE LOCALE ---

      IF (NOMTE(1:13).EQ.'MECA_POU_D_EM') THEN
        CALL PMFRIG(NOMTE,E,NU,KLV)
      ELSE
        CALL PORIGI(NOMTE,E,NU,KLV)
      END IF

C     ---- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE

      CALL VECMA(KLV,78,KLC,12)

      IF (OPTION.EQ.'EFGE_ELNO_DEPL') THEN
        CALL JEVECH('PEFFORR','E',JEFFO)
        CALL POEFGR(NOMTE,KLC,E,NU,RHO,ALPHA,ZR(JEFFO))
        DO 10 I = 1,6
          ZR(JEFFO+I-1) = -ZR(JEFFO+I-1)
          ZR(JEFFO+I+6-1) = ZR(JEFFO+I+6-1)
   10   CONTINUE

      ELSE
        CH16 = OPTION
        CALL UTMESS('F','ELEMENTS DE POUTRE (TE0142)',
     &              'L''OPTION  "'//CH16//'"  N''EST PAS PROGRAMMEE')
      END IF

      END
