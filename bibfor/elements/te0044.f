      SUBROUTINE TE0044(OPTION,NOMTE)
      IMPLICIT      NONE
      CHARACTER*(*) OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/05/2011   AUTEUR SELLENET N.SELLENET 
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
C     ------------------------------------------------------------------
C     CALCUL DE L'ENERGIE DE DEFORMATION, ET CINETIQUE
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'EPOT_ELEM' : CALCUL DE L'ENERGIE DE DEFORMATION
C        'ECIN_ELEM' : CALCUL DE L'ENERGIE CINETIQUE
C IN  NOMTE  : K16 : NOM DU TYPE D'ELEMENT DISCRET :
C         MECA_DIS_T_N
C         MECA_DIS_T_L
C         MECA_DIS_TR_N
C         MECA_DIS_TR_L

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      REAL*8         R8BID,UL(12),PGL(3,3),KLC(12,12),MAT(144)
      INTEGER        INFODI,NBTERM,NNO,NC,NDIM,ITYPE,NEQ,KANL,IREP,IIFF
      INTEGER        I,LORIE,LDEPL,JENDE,LDIS,JFREQ,IBID
      CHARACTER*8    K8BID
      CHARACTER*16   CH16,NOMCMD,TYPRES
      CHARACTER*19   NOMFON

C     ------------------------------------------------------------------

      INFODI = 1
      CALL GETRES(NOMFON,TYPRES,NOMCMD)
      CALL ASSERT( NOMCMD.EQ.'POST_ELEM' )

C     ON VERIFIE QUE LES CARACTERISTIQUES ONT ETE AFFECTEES
C     LE CODE DU DISCRET
      CALL INFDIS('CODE',IBID,R8BID,NOMTE)
C     LE CODE STOKE DANS LA CARTE
      CALL INFDIS('TYDI',INFODI,R8BID,K8BID)
      IF (INFODI.NE.IBID) THEN
         CALL U2MESK('F+','DISCRETS_25',1,NOMTE)
         CALL INFDIS('DUMP',IBID,R8BID,'F+')
      ENDIF

      IF     ( OPTION.EQ.'EPOT_ELEM' ) THEN
C        DISCRET DE TYPE RAIDEUR
         CALL INFDIS('DISK',INFODI,R8BID,K8BID)
         IF (INFODI.EQ.0) THEN
            CALL U2MESK('A+','DISCRETS_27',1,NOMTE)
            CALL INFDIS('DUMP',IBID,R8BID,'A+')
         ENDIF
         CALL INFDIS('SYMK',INFODI,R8BID,K8BID)
      ELSEIF ( OPTION.EQ.'ECIN_ELEM' ) THEN
C        DISCRET DE TYPE MASSE
         CALL INFDIS('DISM',INFODI,R8BID,K8BID)
         IF (INFODI.EQ.0) THEN
            CALL U2MESK('A+','DISCRETS_26',1,NOMTE)
            CALL INFDIS('DUMP',IBID,R8BID,'A+')
         ENDIF
         CALL INFDIS('SYMM',INFODI,R8BID,K8BID)
      ELSE
         CALL U2MESK('F','ELEMENTS2_47',1,OPTION)
      ENDIF

C --- INFORMATIONS SUR LES DISCRETS :
C        NBTERM   = NOMBRE DE COEFFICIENTS DANS K
C        NNO      = NOMBRE DE NOEUDS
C        NC       = NOMBRE DE COMPOSANTE PAR NOEUD
C        NDIM     = DIMENSION DE L'ELEMENT
C        ITYPE    = TYPE DE L'ELEMENT
      CALL INFTED(NOMTE,INFODI,NBTERM,NNO,NC,NDIM,ITYPE)
      NEQ = NNO*NC

C     TYPE DE LA MATRICE DE MASSE
      KANL = 0
C     --- MATRICE DE ROTATION PGL ---
      CALL JEVECH('PCAORIE','L',LORIE)
      CALL MATROT(ZR(LORIE),PGL)

C     --- VECTEUR DEPLACEMENT LOCAL  UL = PGL * UG  ---
      CALL JEVECH('PDEPLAR','L',LDEPL)
      IF (NDIM.EQ.3) THEN
         CALL UTPVGL(NNO,NC,PGL,ZR(LDEPL),UL)
      ELSE IF (NDIM.EQ.2) THEN
         CALL UT2VGL(NNO,NC,PGL,ZR(LDEPL),UL)
      END IF

      IF (OPTION.EQ.'EPOT_ELEM') THEN
         CALL JEVECH('PENERDR','E',JENDE)

C        --- MATRICE DE RIGIDITE ---
         CALL JEVECH('PCADISK','L',LDIS)
C        --- GLOBAL VERS LOCAL ? ---
C        --- IREP EQ 1 : MATRICE EN REPERE GLOBAL
C        --- IREP NE 1 : MATRICE EN REPERE LOCAL
         CALL INFDIS('REPK',IREP,R8BID,K8BID)
         IF (IREP.EQ.1) THEN
            IF (NDIM.EQ.3) THEN
               IF (INFODI.EQ.1) THEN
                  CALL UTPSGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ELSEIF (INFODI.EQ.2) THEN
                  CALL UTPPGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ENDIF
            ELSE IF (NDIM.EQ.2) THEN
               IF (INFODI.EQ.1) THEN
                  CALL UT2MGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ELSEIF (INFODI.EQ.2) THEN
                  CALL UT2PGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ENDIF
            END IF
         ELSE
            DO 10 I = 1,NBTERM
               MAT(I) = ZR(LDIS+I-1)
10          CONTINUE
         ENDIF

C        ---- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE
         IF (INFODI.EQ.1) THEN
            CALL VECMA(MAT,NBTERM,KLC,NEQ)
         ELSEIF (INFODI.EQ.2) THEN
            CALL VECMAP(MAT,NBTERM,KLC,NEQ)
         ENDIF

C        --- ENERGIE DE DEFORMATION ---
         IIFF = 1
         CALL PTENPO(NEQ,UL,KLC,ZR(JENDE),ITYPE,IIFF)

      ELSEIF (OPTION.EQ.'ECIN_ELEM') THEN
         CALL JEVECH('PENERCR','E',JENDE)

C        --- MATRICE DE MASSE ---
         CALL JEVECH('PCADISM','L',LDIS)
C        --- GLOBAL VERS LOCAL ? ---
C        --- IREP EQ 1 : MATRICE EN REPERE GLOBAL
C        --- IREP NE 1 : MATRICE EN REPERE LOCAL
         CALL INFDIS('REPM',IREP,R8BID,K8BID)
         IF (IREP.EQ.1) THEN
            IF (NDIM.EQ.3) THEN
               IF (INFODI.EQ.1) THEN
                  CALL UTPSGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ELSEIF (INFODI.EQ.2) THEN
                  CALL UTPPGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ENDIF
            ELSE IF (NDIM.EQ.2) THEN
               IF (INFODI.EQ.1) THEN
                  CALL UT2MGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ELSEIF (INFODI.EQ.2) THEN
                  CALL UT2PGL(NNO,NC,PGL,ZR(LDIS),MAT)
               ENDIF
            END IF
         ELSE
            DO 20 I = 1,NBTERM
               MAT(I) = ZR(LDIS+I-1)
20          CONTINUE
         ENDIF

C        ---- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE
         IF (INFODI.EQ.1) THEN
            CALL VECMA(MAT,NBTERM,KLC,NEQ)
         ELSEIF (INFODI.EQ.2) THEN
            CALL VECMAP(MAT,NBTERM,KLC,NEQ)
         ENDIF

C        --- FREQUENCE ---
         CALL JEVECH('POMEGA2','L',JFREQ)

C        --- ENERGIE CINETIQUE  ---
        IIFF = 1
        CALL PTENCI(NEQ,UL,KLC,ZR(JFREQ),ZR(JENDE),ITYPE,KANL,IIFF)

      ELSE
         CH16 = OPTION
         CALL U2MESK('F','ELEMENTS2_47',1,CH16)
      ENDIF
      END
