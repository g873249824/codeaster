      SUBROUTINE TE0142(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) OPTION,NOMTE
C     ------------------------------------------------------------------
C MODIF ELEMENTS  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
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

      PARAMETER (NBRES=3,NBREF=6)
      PARAMETER (NDDL=12,NL=NDDL*(NDDL+1)/2)
      REAL*8 VALRES(NBRES),VALREF(NBREF)
      CHARACTER*2 CODRES(NBRES),CODREF(NBREF),DERIVE
      CHARACTER*8 NOMPAR,NOMRES(NBRES),NOMREF(NBREF)
      CHARACTER*16 CH16
      REAL*8 ZERO,E,NU,RHO
      REAL*8 KLV(78),KLC(12,12),KLCS(12,12)
      REAL*8 MLV(78),MLC(12,12)
      REAL*8 EFGE(12)
      CHARACTER*24 SUROPT
      INTEGER ICOMPO,ISDCOM,IRET
C     ------------------------------------------------------------------
      DATA NOMRES/'E','NU','RHO'/
      DATA NOMREF/'E','NU','RHO','RHO_F_IN','RHO_F_EX','CM'/
C     --------------------------------------------------
      ZERO = 0.D0
 
C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---

      CALL JEVECH('PMATERC','L',LMATER)
      CALL MOYTEM('NOEU',2,1,'+',VALPAR,IRET)
      NOMPAR = 'TEMP'
      NBPAR = 1

      CALL JEVECH('PSUROPT','L',LOPT)
      SUROPT = ZK24(LOPT)
      IF (SUROPT.EQ.'MASS_FLUI_STRU') THEN
        CALL JEVECH('PABSCUR','L',LABSC)
        CALL JEVECH('PCAGEPO','L',LCAGE)
        ABSMOY = (ZR(LABSC-1+1)+ZR(LABSC-1+2))/2.D0
        CALL RCVALB('NOEU',1,1,'+',ZI(LMATER),' ','ELAS_FLUI',
     &             1,'ABSC',ABSMOY,NBREF,
     &             NOMREF, VALREF,CODREF,'FM')
        E = VALREF(1)
        NU = VALREF(2)
        RHOS = VALREF(3)
        RHOFI = VALREF(4)
        RHOFE = VALREF(5)
        CM = VALREF(6)
        PHIE = ZR(LCAGE-1+1)*2.D0
        IF (PHIE.EQ.0.D0) THEN
          CALL U2MESS('F','ELEMENTS3_26')
        END IF
        PHII = (PHIE-2.D0*ZR(LCAGE-1+2))
        CALL RHOEQU(RHO,RHOS,RHOFI,RHOFE,CM,PHII,PHIE)

      ELSE
        IF(NOMTE(1:13).NE.'MECA_POU_D_EM')THEN
          CALL RCVALB('NOEU',1,1,'+',ZI(LMATER),' ','ELAS',
     &              NBPAR,NOMPAR,VALPAR,2,
     &              NOMRES,VALRES,CODRES,'FM')
          CALL RCVALB('NOEU',1,1,'+',ZI(LMATER),' ','ELAS',
     &             NBPAR,NOMPAR,VALPAR,1,
     &             NOMRES(3), VALRES(3),CODRES(3),'  ')
          IF (CODRES(3).NE.'OK') VALRES(3) = ZERO
          E = VALRES(1)
          NU = VALRES(2)
          RHO = VALRES(3)
        ELSE
C    --- RECUPERATION DU MATERIAU TORSION POUR ALPHA
          CALL JEVECH('PCOMPOR','L',ICOMPO)
          CALL JEVEUO(ZK16(ICOMPO-1+6),'L',ISDCOM)
        ENDIF
      END IF

C     --- CALCUL DE LA MATRICE DE RIGIDITE LOCALE ---

      IF (NOMTE(1:13).EQ.'MECA_POU_D_EM') THEN
        CALL PMFRIG(NOMTE,ZI(LMATER),KLV)
      ELSE
        CALL PORIGI(NOMTE,E,NU,KLV)
      END IF

C     ---- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE

      CALL VECMA(KLV,78,KLC,12)

      IF (OPTION.EQ.'EFGE_ELNO_DEPL') THEN
        CALL JEVECH('PEFFORR','E',JEFFO)
        CALL POEFGR(NOMTE,KLC,ZI(LMATER),E,NU,RHO,ZR(JEFFO))
        DO 10 I = 1,6
          ZR(JEFFO+I-1) = -ZR(JEFFO+I-1)
          ZR(JEFFO+I+6-1) = ZR(JEFFO+I+6-1)
   10   CONTINUE

C
C---- SENSIBILITE: CALCUL DE EFGE_ELNO_SENS
C
      ELSE IF (OPTION.EQ.'EFGE_ELNO_SENS'   .OR.
     &         OPTION.EQ.'SIPO_ELNO_SENS'   ) THEN
C
C ON SE LIMITE POUR L'INSTANT AUX : POU_D_E
C
        IF (NOMTE.NE.'MECA_POU_D_E') THEN
          CALL U2MESS ('F','ELEMENTS3_25')
        ENDIF
C
C     --- CALCUL DE LA MATRICE DE MASSE LOCALE ---
C         EQUIVALENT OPTION MASS_MECA
C
        CALL POMASS(NOMTE,E,NU,RHO,1,MLV)
        CALL VECMA(MLV,NL,MLC,NDDL)
C
C     --- CALCUL DE LA MATRICE DE RIGIDITE SENSIBLE LOCALE ---
C
        CALL JEVECH('PMATSEN','L',IMATE)
        CALL RCVALB('NOEU',1,1,'+',ZI(IMATE),' ','ELAS',
     &            NBPAR,NOMPAR,VALPAR,2,
     &            NOMRES,VALRES,CODRES,'FM')
        E   = VALRES(1)
        XNU = VALRES(2)
C
C A CE NIVEAU : LA PROCEDURE HABITUELLE DE CALCUL DE SENSIBILITE DONNE :
C   SI : DERIVATION PAR RAPPORT A E ALORS : E = 1 ET XNU = 0
C   SI : DERIVATION PAR RAPPORT A NU ALORS : E = 0 ET XNU = 1
C ICI, LA FORMULATION DE LA DERIVEE EST PLUS COMPLEXE
C
        CALL JEVECH('PMATERC','L',IMATE)
        CALL RCVALB('NOEU',1,1,'+',ZI(IMATE),' ','ELAS',
     &            NBPAR,NOMPAR,VALPAR,2,
     &            NOMRES,VALRES,CODRES,'FM')
        IF(ABS(XNU).LT.R8PREM()) THEN
          DERIVE = 'E'
          XNU = VALRES(2)
        ELSE IF(ABS(E).LT.R8PREM()) THEN
          DERIVE = 'NU'
          E   = VALRES(1)
          XNU = VALRES(2)
        END IF
        CALL PORIGI(NOMTE,E,XNU,KLV)
C
        IF(DERIVE(1:2).EQ.'NU') THEN
C VALEUR NULLE SAUF POUR LES DDL DE TORSION
            VALTOR = -KLV(10)/(1.D0 + XNU)
            DO 300 I = 1,NL
              KLV(I) = 0.D0
300         CONTINUE
            KLV(10) =  VALTOR
            KLV(49) = -VALTOR
            KLV(55) =  VALTOR
        ENDIF
        CALL VECMA(KLV,NL,KLCS,NDDL)
C
        CALL JEVECH('PDEPLAR','L',IDEPL)
        CALL JEVECH('PDEPSEN','L',IDEPSE)
        CALL JEVECH('PACCSEN','L',IACCSE)
        IF(OPTION.NE.'SIPO_ELNO_SENS') THEN
           CALL JEVECH('PEFFORR','E',JEFFO)
        ELSE
           CALL JEVECH('PCONTPO','E',JEFFO)
        ENDIF
C
          DO 100 I = 1,NDDL
            EFGE(I) = 0.D0
            DO 110 J = 1,NDDL
              EFGE(I) = EFGE(I)
     &                        + KLC(I,J) * ZR(IDEPL-1+J)
     &                        + KLCS(I,J)* ZR(IDEPSE-1+J)
     &                        + MLC(I,J) * ZR(IACCSE-1+J)
110         CONTINUE
100       CONTINUE
          IF ( OPTION.EQ.'EFGE_ELNO_SENS'  ) THEN
             DO 130 I = 1,NDDL
                 ZR(JEFFO-1+I) = EFGE(I)
130          CONTINUE
          ELSE
             CALL POSIPR(NOMTE,EFGE,ZR(JEFFO))
          ENDIF
      ELSE
        CH16 = OPTION
        CALL U2MESK('F','ELEMENTS3_27',1,CH16)
      END IF

      END
