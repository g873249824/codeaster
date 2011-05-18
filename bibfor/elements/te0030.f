      SUBROUTINE TE0030(OPTION,NOMTE)
C =====================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 19/05/2011   AUTEUR MACOCCO K.MACOCCO 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C =====================================================================
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C =====================================================================
C    - FONCTION REALISEE:  CALCUL DE L'OPTIONS INDL_ELGA
C                          QUI EST UN INDICATEUR SUR LA LOCALISATION
C                          AUX POINTS DE GAUSS
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C =====================================================================
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C =====================================================================
      LOGICAL      LOGTHM
      INTEGER      IMATE, ICOMPO, IVARIP, ICONTP, ILOCAL,IBID
      INTEGER      NBVARI, NBRAC4, RINDIC, KPG, II, NBSIG
      INTEGER      NBSIGM, ICODE, IRET, TABTHM(3), DIMMAX, NPGU
      INTEGER      NDIM, NNO, NNOS, NPG, IPOIDS, IVF, IDFDE, JGANO
      REAL*8       VBIFUR, RACINE(4), DSDE(6,6)
      CHARACTER*8  MOD, ALIAS8
      CHARACTER*16 RELCOM
C =====================================================================
C --- RINDIC EST LE NOMBRE DE PARAMETRE DE LOCALISATION DEFINIT -------
C --- SOUS LE MOT-CLE INDL_R DANS GRANDEUR_SIMPLE.CATA --------------
C =====================================================================
      PARAMETER ( RINDIC  = 5 )
C =====================================================================
      CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)
      IF ( OPTION.EQ.'INDL_ELGA' ) THEN
C =====================================================================
C --- VERIFICATION DE COHERENCE ---------------------------------------
C --- LE TENSEUR ACOUSTIQUE EST DEVELOPPE EN 2D UNIQUEMENT ------------
C =====================================================================
C --- CAS D'UN POST-TRAITEMENT EN MECANIQUE DRAINE --------------------
C =====================================================================
         LOGTHM  = .FALSE.
         IF ((ALIAS8(3:5).EQ.'DPL').OR.(ALIAS8(3:5).EQ.'DPS')) THEN
            MOD(1:6) = 'D_PLAN'
            NBSIG = NBSIGM()
         ELSE IF (ALIAS8(3:5).EQ.'CPL') THEN
            MOD(1:6) = 'C_PLAN'
            NBSIG = NBSIGM()
         ELSE IF (ALIAS8(3:5).EQ.'AX_') THEN
            MOD(1:4) = 'AXIS'
            NBSIG = NBSIGM()
         ELSE
C =====================================================================
C --- CAS D'UN POST-TRAITEMENT EN MECANIQUE THM -----------------------
C =====================================================================
            LOGTHM  = .TRUE.
            IF (ALIAS8(3:5).EQ.'AH2')THEN
               MOD(1:4) = 'AXIS'
            ELSE IF ((ALIAS8(3:5).EQ.'DH2').OR.
     &               (ALIAS8(3:5).EQ.'DR1'))THEN
               MOD(1:6) = 'D_PLAN'
            ELSE
C =====================================================================
C --- CAS NON TRAITE --------------------------------------------------
C =====================================================================
               CALL U2MESK('F','ELEMENTS_11',1,NOMTE)
            ENDIF
         ENDIF
C =====================================================================
C --- RECUPERATION DU ELREFE ------------------------------------------
C =====================================================================
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C =====================================================================
C --- PARAMETRES EN ENTREE --------------------------------------------
C =====================================================================
         CALL JEVECH('PMATERC','L',IMATE )
         CALL JEVECH('PCOMPOR','L',ICOMPO)
         CALL JEVECH('PVARIPR','L',IVARIP)
         IF (LOGTHM) THEN
C =====================================================================
C --- DANS LE CADRE THM ON FAIT UN TECACH PLUTOT QU'UN JEVECH POUR ----
C --- RECUPERER EGALEMENT LA DIMENSION DU VECTEUR QUI DIFFERE SUIVANT -
C --- LA MODELISATION THM ---------------------------------------------
C =====================================================================
            CALL TECACH('OOO','PCONTPR',3,TABTHM,IRET)
            ICONTP = TABTHM(1)
            DIMMAX = TABTHM(2)
            NPGU   = TABTHM(3)
C =====================================================================
C --- ON TESTE LA COHERENCE DES RECUPERATIONS ELREF4 ET TECACH SUR ----
C --- LE NOMBRE DE POINTS DE GAUSS ------------------------------------
C =====================================================================
            CALL ASSERT(NPGU.EQ.NPG)
            NBSIG = DIMMAX / NPG
C =====================================================================
C --- DANS LE CADRE DE LA THM ON RECUPERE DIRECTEMENT LA RELATION -----
C --- DE COMPORTEMENT DE TYPE MECANIQUE -------------------------------
C =====================================================================
            RELCOM = ZK16(ICOMPO-1+11)
         ELSE
            CALL JEVECH('PCONTPR','L',ICONTP)
            RELCOM = ZK16(ICOMPO-1+ 1)
         ENDIF
C =====================================================================
C --- NOMBRE DE VARIABLES INTERNES ASSOCIE A LA LOI DE COMPORTEMENT ---
C =====================================================================
         READ (ZK16(ICOMPO-1+2),'(I16)') NBVARI
C =====================================================================
C --- PARAMETRES EN SORTIE --------------------------------------------
C =====================================================================
         CALL JEVECH('PINDLOC','E',ILOCAL)
C =====================================================================
C --- BOUCLE SUR LES POINTS DE GAUSS ----------------------------------
C =====================================================================
         DO 10 KPG = 1, NPG
C =====================================================================
C --- INITIALISATIONS -------------------------------------------------
C =====================================================================
            VBIFUR    = 0.0D0
            RACINE(1) = 0.0D0
            RACINE(2) = 0.0D0
            RACINE(3) = 0.0D0
            RACINE(4) = 0.0D0
C =====================================================================
C --- CALCUL DE LA MATRICE TANGENTE -----------------------------------
C --- (FONCTION DE LA RELATION DE COMPORTEMENT) -----------------------
C =====================================================================
            IF (RELCOM.EQ.'DRUCK_PRAGER') THEN
C =====================================================================
C --- LOI DE TYPE DRUCKER_PRAGER --------------------------------------
C =====================================================================
               CALL REDRPR(MOD,ZI(IMATE),ZR(ICONTP-1+(KPG-1)*NBSIG+1 ),
     &                                   ZR(IVARIP-1+(KPG-1)*NBVARI+1),
     &                                                      DSDE,ICODE)
               IF (ICODE.EQ.0) GO TO 10
C =====================================================================
C ----------- LOI DE TYPE HUJEUX --------------------------------------
C =====================================================================
            ELSEIF (RELCOM.EQ.'HUJEUX') THEN
               CALL HUJTID(MOD,ZI(IMATE),ZR(ICONTP-1+(KPG-1)*NBSIG+1 ),
     &                                  ZR(IVARIP-1+(KPG-1)*NBVARI+1), 
     &                                  DSDE, ICODE)
            ELSE
CC RELATION DE COMPORTEMENT INVALIDE
               CALL ASSERT(.FALSE.)
            ENDIF
C =====================================================================
C --- CALCUL DU TENSEUR ACOUSTIQUE ------------------------------------
C =====================================================================
            CALL CRIBIF( MOD, DSDE, VBIFUR , NBRAC4, RACINE )
C =====================================================================
C --- SURCHARGE DE L'INDICATEUR DE LOCALISATION -----------------------
C =====================================================================
            ZR(ILOCAL-1+1+(KPG-1)*RINDIC) = VBIFUR
            DO 20 II=1, NBRAC4
               ZR(ILOCAL-1+1+II+(KPG-1)*RINDIC) = RACINE(II)
 20         CONTINUE
 10      CONTINUE
      ELSE
CC OPTION DE CALCUL INVALIDE
        CALL ASSERT(.FALSE.)
      END IF
C =====================================================================
      END
