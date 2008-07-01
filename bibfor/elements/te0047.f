      SUBROUTINE TE0047(OPTIOZ,NOMTEZ)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
      CHARACTER*(*) OPTIOZ,NOMTEZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/06/2008   AUTEUR FLEJOU J-L.FLEJOU 
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
C RESPONSABLE FLEJOU J-L.FLEJOU
C TOLE  CRP_20
C     ELEMENTS CONCERNES :  MECA_DIS_TR_L : SUR UNE MAILLE A 2 NOEUDS
C                           MECA_DIS_T_L  : SUR UNE MAILLE A 2 NOEUDS
C                           MECA_DIS_TR_N : SUR UNE MAILLE A 1 NOEUD
C                           MECA_DIS_T_N  : SUR UNE MAILLE A 1 NOEUD
C    ON CALCULE LES OPTIONS FULL_MECA
C                           RAPH_MECA
C                           RIGI_MECA_TANG
C     ELEMENTS CONCERNES :  MECA_2D_DIS_TR_L : SUR UNE MAILLE A 2 NOEUDS
C                           MECA_2D_DIS_T_L  : SUR UNE MAILLE A 2 NOEUDS
C                           MECA_2D_DIS_TR_N : SUR UNE MAILLE A 1 NOEUD
C                           MECA_2D_DIS_T_N  : SUR UNE MAILLE A 1 NOEUD
C    ON CALCULE LES OPTIONS FULL_MECA
C                           RAPH_MECA
C                           RIGI_MECA_TANG
C     POUR LE COMPORTEMENT  ELAS
C ----------------------------------------------------------------------
C IN  : OPTIOZ : NOM DE L'OPTION A CALCULER
C       NOMTEZ : NOM DU TYPE_ELEMENT
C ----------------------------------------------------------------------

C **************** DEBUT COMMUNS NORMALISES JEVEUX *********************

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

C ***************** FIN COMMUNS NORMALISES JEVEUX **********************


C *************** DECLARATION DES VARIABLES LOCALES ********************

      REAL*8 ANG(3),PGL(3,3),KLV(78),KLV2(78),KLV3(144),XD(3)
      REAL*8 UGM(12),UGP(12),DUG(12),COORG(12)
      REAL*8 ULM(12),ULP(12),DUL(12),KTY2,DVL(12),DPE(12),DVE(12)
      REAL*8 VARMO(7),VARPL(7),VARIPC(7)
      REAL*8 DTEMPS,TEMPER,IRRAP
      REAL*8 DDOT,DULY,FOR2,FOR3,PLOUF,TET1,TET2,VARIP,XL,XL0,XL2

      INTEGER NBT,NNO,NC,NEQ,IGEOM,ICONTM,IDEPLM,IDEPLP,ICOMPO,LORIEN
      INTEGER I,JDC,IREP,IMAT,IFONO,ICONTP,ILOGIC,IITER,IMATE,IVARIM
      INTEGER IRMETG,ITERAT,IVARIP,NDIM,JCRET
      INTEGER IADZI,IAZK24
      INTEGER II,JTP,JTM,IDEPEN,IRET,IRET2,IVITEN,IVITP,JINST

      CHARACTER*8 NOMAIL
      CHARACTER*4 FAMI

      LOGICAL PREAC

      CHARACTER*24 MESSAK(5)

      REAL*8 ZERO,MOINS1
      PARAMETER (ZERO = 0.0D0, MOINS1=-1.0D0)
C  ===========================================================
C
C         COMPORTEMENT NON-LINEAIRE POUR LES DISCRETS
C
C  ===========================================================
      INTEGER      NBPAR
      REAL*8       VALPA
      CHARACTER*8  NOMPA

C     LOI VISQUEUSE SUR 6 COMPOSANTES
C     NBRE2  : 2 PARAMETRES PAR COMPOSANTE
C     NBVIN2 : 2 VARIABLES INTERNES PAR COMPOSANTES
      INTEGER      NBRE2, NBVIN2
      PARAMETER   (NBRE2  = 2*6 , NBVIN2 = 2*6)
C     VALRE2 : VALEUR PARAMETRES DE LA LOI
C     NOMRE2 : NOM DES PARAMETRES DE LA LOI
      REAL*8       VALRE2(NBRE2)
      CHARACTER*2  CODRE2(NBRE2)
      CHARACTER*8  NOMRE2(NBRE2)

C     LOI CINEMATIQUE SUR 6 COMPOSANTES
C     NBRE3  : 4 PARAMETRES PAR COMPOSANTE
C     NBVIN3 : 3 VARIABLES INTERNES PAR COMPOSANTES
      INTEGER      NBRE3, NBVIN3
      PARAMETER   (NBRE3  = 4*6 , NBVIN3 = 3*6)
C     VALRE2 : VALEUR PARAMETRES DE LA LOI
C     NOMRE2 : NOM DES PARAMETRES DE LA LOI
      REAL*8       VALRE3(NBRE3)
      CHARACTER*2  CODRE3(NBRE3)
      CHARACTER*8  NOMRE3(NBRE3)

C     LOI BI-LINEAIRE SUR 6 COMPOSANTES
C     NBRE4  : 3 PARAMETRES PAR COMPOSANTE
C     NBVIN4 : 1 VARIABLES INTERNES PAR COMPOSANTES
      INTEGER      NBRE4, NBVIN4
      PARAMETER   (NBRE4  = 3*6 , NBVIN4 = 1*6)
C     VALRE4 : VALEUR PARAMETRES DE LA LOI
C     NOMRE4 : NOM DES PARAMETRES DE LA LOI
      REAL*8       VALRE4(NBRE4)
      CHARACTER*2  CODRE4(NBRE4)
      CHARACTER*8  NOMRE4(NBRE4)

C     LES DISCRETS ONT 6 DDL AU MAXIMUM
C     RAIDE : EXISTE POUR TOUS LES DISCRETS, TANGENTE AU COMPORTEMENT
C     OKDIRE : VRAI SI LE COMPORTEMENT AFFECTE CETTE DIRECTION
C     COEFLO(6,NBPARA) : PARAMETRES NECESSAIRES A LA LOI
C     NBPARA : NOMBRE MAXIMAL DE PARAMETRES TOUTES LOIS CONFONDUES
C        LOI 2 VISQUEUSE         NBRE2 = 2 PARAMETRES PAR COMPOSANTE
C        LOI 3 CINEMATIQUE       NBRE3 = 4 PARAMETRES PAR COMPOSANTE
C        LOI 4 BILINEAIRE        NBRE4 = 3 PARAMETRES PAR COMPOSANTE
      INTEGER      NBPARA
      PARAMETER   (NBPARA=NBRE3)
      REAL*8       RAIDE(6),COEFLO(6,NBPARA)
      LOGICAL      OKDIRE(6)

C     DOIT ETRE DIMENSIONNE EN COHERENCE AVEC LE CATALOGUE C_COMP_INCR
C     NOMBRE MAXIMAL DE VARIABLES INTERNES SUR LES DISCRETS
C              TOUTES LOIS CONFONDUES
C        LOI 2 VISQUEUX       NBVIN2= 2  : F+  Energie
C        LOI 3 CINEMATIQUE    NBVIN3= 3  : Uan  alpha  Energie
C        LOI 4 BILINIAIRE     NBVIN4= 1  : indicateur
      INTEGER      NBVINT,NUMLOI
      PARAMETER   (NBVINT = NBVIN3)
      REAL*8       VARDNL(NBVINT)
C     LOI 2 : VISQUEUSE         NBRE2  : 2 PARAMETRES PAR COMPOSANTE
      DATA NOMRE2 /'PUIS_DX','COEF_DX',
     &             'PUIS_DY','COEF_DY',
     &             'PUIS_DZ','COEF_DZ',
     &             'PUIS_RX','COEF_RX',
     &             'PUIS_RY','COEF_RY',
     &             'PUIS_RZ','COEF_RZ'/
C     LOI 3 : CINEMATIQUE       NBRE3  : 4 PARAMETRES PAR COMPOSANTE
      DATA NOMRE3 /'LIMU_DX','PUIS_DX','KCIN_DX','LIMY_DX',
     &             'LIMU_DY','PUIS_DY','KCIN_DY','LIMY_DY',
     &             'LIMU_DZ','PUIS_DZ','KCIN_DZ','LIMY_DZ',
     &             'LIMU_RX','PUIS_RX','KCIN_RX','LIMY_RX',
     &             'LIMU_RY','PUIS_RY','KCIN_RY','LIMY_RY',
     &             'LIMU_RZ','PUIS_RZ','KCIN_RZ','LIMY_RZ'/
C     LOI 4 : BILINEAIRE        NBRE4  : 3 PARAMETRES PAR COMPOSANTE
      DATA NOMRE4 /'KDEB_DX','KFIN_DX','FPRE_DX',
     &             'KDEB_DY','KFIN_DY','FPRE_DY',
     &             'KDEB_DZ','KFIN_DZ','FPRE_DZ',
     &             'KDEB_RX','KFIN_RX','FPRE_RX',
     &             'KDEB_RY','KFIN_RY','FPRE_RY',
     &             'KDEB_RZ','KFIN_RZ','FPRE_RZ'/

C *********** FIN DES DECLARATIONS DES VARIABLES LOCALES ***************


C ********************* DEBUT DE LA SUBROUTINE *************************

      FAMI = 'RIGI'
C --- DEFINITIONS DE PARAMETRES : NBT = NOMBRE DE COEFFICIENTS DANS K
C                                 NEQ = NOMBRE DE DDL EN DEPLACEMENT
      OPTION = OPTIOZ
      NOMTE = NOMTEZ

      NDIM = 3
      IF      (NOMTE.EQ.'MECA_DIS_TR_L') THEN
         NBT  = 78
         NNO  = 2
         NC   = 6
         NEQ  = 12
      ELSE IF (NOMTE.EQ.'MECA_DIS_TR_N') THEN
         NBT  = 21
         NNO  = 1
         NC   = 6
         NEQ  = 6
      ELSE IF (NOMTE.EQ.'MECA_DIS_T_L') THEN
         NBT  = 21
         NNO  = 2
         NC   = 3
         NEQ  = 6
      ELSE IF (NOMTE.EQ.'MECA_DIS_T_N') THEN
         NBT  = 6
         NNO  = 1
         NC   = 3
         NEQ  = 3
      ELSE IF (NOMTE.EQ.'MECA_2D_DIS_T_N') THEN
         NBT  = 3
         NNO  = 1
         NC   = 2
         NEQ  = 2
         NDIM = 2
      ELSE IF (NOMTE.EQ.'MECA_2D_DIS_T_L') THEN
         NBT  = 10
         NNO  = 2
         NC   = 2
         NEQ  = 4
         NDIM = 2
      ELSE IF (NOMTE.EQ.'MECA_2D_DIS_TR_N') THEN
         NBT  = 6
         NNO  = 1
         NC   = 3
         NEQ  = 3
         NDIM = 2
      ELSE IF (NOMTE.EQ.'MECA_2D_DIS_TR_L') THEN
         NBT  = 21
         NNO  = 2
         NC   = 3
         NEQ  = 6
         NDIM = 2
      ELSE
         MESSAK(1) = NOMTE
         MESSAK(2) = OPTION
         MESSAK(3) = '????????'
         MESSAK(4) = '????????'
         CALL TECAEL ( IADZI, IAZK24 )
         MESSAK(5) = ZK24(IAZK24-1+3)
        CALL U2MESK('F','DISCRETS_9',5,MESSAK)
      END IF

C --- RECUPERATION DES ADRESSES JEVEUX
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
C--- RECUPERATION DES INFOS CONCERNANT LES COMPORTEMENTS
C                       12345678901234
C     ZK16(ICOMPO)      ELAS
C                       DIS_GRICRA
C                       DIS_VISC
C                       DIS_ECRO_CINE
C                       DIS_BILI_ELAS
C                       ASSE_CORN
C                       ARME
C                       DIS_CHOC
C                       DIS_GOUJ2E
C     ZK16(ICOMPO+1)    NBVAR = READ (ZK16(ICOMPO+1),'(I16)')
C     ZK16(ICOMPO+2)    PETIT_REAC
C                       GREEN
C     ZK16(ICOMPO+3)    COMP_ELAS
C                       COMP_INCR
      PREAC = ZK16(ICOMPO+2)(6:10).EQ.'_REAC'

C         OPTION           MATRICE     FORCES
C      12345678901234      TANGENTE    NODALES
C      FULL_MECA             OUI        OUI
C      RAPH_MECA                        OUI
C      RIGI_MECA_TANG        OUI
C      RIGI_MECA_ELAS        OUI
C      FULL_MECA_ELAS        OUI

C     On peut avoir COMP_ELAS et seulement comportement ELAS
      IF ( (ZK16(ICOMPO+3).EQ.'COMP_ELAS').AND.
     &     (ZK16(ICOMPO).NE.'ELAS') ) THEN
         MESSAK(1) = NOMTE
         MESSAK(2) = OPTION
         MESSAK(3) = ZK16(ICOMPO+3)
         MESSAK(4) = ZK16(ICOMPO)
         CALL TECAEL ( IADZI, IAZK24 )
         MESSAK(5) = ZK24(IAZK24-1+3)
         CALL U2MESK('F','DISCRETS_8',5,MESSAK)
      END IF

C     Dans les cas *_ELAS, les comportements qui ont une matrice de
C     d�charge sont : ELAS DIS_GRICRA
      IF ( (OPTION(10:14).EQ.'_ELAS').AND.
     &     (ZK16(ICOMPO).NE.'ELAS').AND.
     &     (ZK16(ICOMPO).NE.'DIS_GRICRA') ) THEN
         MESSAK(1) = NOMTE
         MESSAK(2) = OPTION
         MESSAK(3) = ZK16(ICOMPO+3)
         MESSAK(4) = ZK16(ICOMPO)
         CALL TECAEL ( IADZI, IAZK24 )
         MESSAK(5) = ZK24(IAZK24-1+3)
         CALL U2MESK('F','DISCRETS_10',5,MESSAK)
      ENDIF

C ======================================================================
C   ORIENTATION DE L'ELEMENT ET DEPLACEMENTS DANS LES REPERES G ET L
C ======================================================================
C --- RECUPERATION DES ORIENTATIONS (ANGLES NAUTIQUES -> VECTEUR ANG)
      CALL TECACH ( 'ONN','PCAORIE', 1, LORIEN ,IRET)
      IF ( IRET .NE. 0 ) THEN
         MESSAK(1) = NOMTE
         MESSAK(2) = OPTION
         MESSAK(3) = ZK16(ICOMPO+3)
         MESSAK(4) = ZK16(ICOMPO)
         CALL TECAEL ( IADZI, IAZK24 )
         MESSAK(5) = ZK24(IAZK24-1+3)
         CALL U2MESK('F','DISCRETS_6',5,MESSAK)
      ENDIF
      CALL DCOPY ( 3, ZR(LORIEN), 1, ANG, 1 )

C --- DEPLACEMENTS DANS LE REPERE GLOBAL
C        UGM = DEPLACEMENT PRECEDENT
C        DUG = INCREMENT DE DEPLACEMENT
C        UGP = DEPLACEMENT COURANT
C        XD  = VECTEUR JOIGNANT LES DEUX NOEUDS AU REPOS (NORME XL0)
      DO 10 I = 1,NEQ
         UGM(I) = ZR(IDEPLM+I-1)
         DUG(I) = ZR(IDEPLP+I-1)
         UGP(I) = UGM(I) + DUG(I)
   10 CONTINUE

      IF (NNO.EQ.2)  THEN
         CALL VDIFF(NDIM,ZR(IGEOM+NDIM),ZR(IGEOM),XD)
         XL2=DDOT(NDIM,XD,1,XD,1)
         XL0 = SQRT(XL2)
      END IF

C --- CHANGEMENT DE REPERE POUR L'ELEMENT TRANSLATION/ROTATION LIAISON
      IF ( PREAC ) THEN
C        REACTUALISATION DES POSITIONS DES 2 NOEUDS ET CALCUL
C        DE LEUR DISTANCE
         DO 20 I = 1,NDIM
            COORG(I)      = UGP(I)    + ZR(IGEOM+I-1)
            COORG(I+NDIM) = UGP(I+NC) + ZR(IGEOM+I+NDIM-1)
   20    CONTINUE
         CALL VDIFF(NDIM,COORG(NDIM+1),COORG(1),XD)
         XL2=DDOT(NDIM,XD,1,XD,1)
         XL = SQRT(XL2)
      ENDIF

      IF (NOMTE.EQ.'MECA_DIS_TR_L'.AND. PREAC ) THEN
C     ANGLE DE VRILLE MOYEN SI ELEMENT DE LONGUEUR NON NULLE
         TET1=DDOT(3,UGP(4),1,XD,1)
         TET2=DDOT(3,UGP(10),1,XD,1)
         IF (XL.NE.0.D0) THEN
            TET1 = TET1/XL
            TET2 = TET2/XL
         ELSE
            TET1 = 0.D0
            TET2 = 0.D0
         END IF
         IF (XL0.NE.0.D0) CALL ANGVX(XD,ANG(1),ANG(2))
         ANG(3) = ANG(3) + (TET1+TET2)/2.D0
      END IF

C --- MATRICE MGL DE PASSAGE REPERE GLOBAL -> REPERE LOCAL
      CALL MATROT(ANG,PGL)

C --- DEPLACEMENTS DANS LE REPERE LOCAL
C        ULM = DEPLACEMENT PRECEDENT    = PLG * UGM
C        DUL = INCREMENT DE DEPLACEMENT = PLG * DUG
C        ULP = DEPLACEMENT COURANT      = PLG * UGP
      IF (NDIM.EQ.3) THEN
         CALL UTPVGL(NNO,NC,PGL,UGM,ULM)
         CALL UTPVGL(NNO,NC,PGL,DUG,DUL)
         CALL UTPVGL(NNO,NC,PGL,UGP,ULP)
      ELSE IF (NDIM.EQ.2) THEN
         CALL UT2VGL(NNO,NC,PGL,UGM,ULM)
         CALL UT2VGL(NNO,NC,PGL,DUG,DUL)
         CALL UT2VGL(NNO,NC,PGL,UGP,ULP)
      END IF

C ======================================================================
C                      COMPORTEMENT ELASTIQUE
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'ELAS') THEN
C ------ PARAMETRES EN ENTREE
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))
C        ABSOLU VERS LOCAL ? ---
C        IREP = 1 = MATRICE EN REPERE GLOBAL ==> PASSER EN LOCAL ---
         IF (IREP.EQ.1) THEN
            IF (NDIM.EQ.3) THEN
               CALL UTPSGL(NNO,NC,PGL,ZR(JDC),KLV)
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MGL(NNO,NC,PGL,ZR(JDC),KLV)
            END IF
         ELSE
            CALL DCOPY(NBT,ZR(JDC),1,KLV,1)
         END IF

C --- CALCUL DE LA MATRICE TANGENTE
         IF ( OPTION(1: 9).EQ.'FULL_MECA' .OR.
     &        OPTION(1:10).EQ.'RIGI_MECA_' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            IF (NDIM.EQ.3) THEN
               CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MLG(NNO,NC,PGL,KLV,ZR(IMAT))
            END IF
         END IF

C --- CALCUL DES EFFORTS GENERALISES ET DES FORCES NODALES
         IF ( OPTION(1:9).EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            ILOGIC = 0
            PLOUF = 0.D0
            CALL DISIEF(NBT,NEQ,NNO,NC,PGL,KLV,DUL,ZR(ICONTM),ILOGIC,
     &                PLOUF,PLOUF,ZR(ICONTP),ZR(IFONO),PLOUF,PLOUF)
         END IF
         GOTO 800
      END IF
C ======================================================================
C                  FIN DU COMPORTEMENT ELASTIQUE
C ======================================================================

C ======================================================================
C            DEBUT COMPORTEMENT DIS_VISC : DISCRET_NON_LINE
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'DIS_VISC') THEN
C ------ RECUPERATION DU MATERIAU
         CALL JEVECH('PMATERC','L',IMATE)

C ------ VARIABLES INTERNES A T-
         CALL JEVECH('PVARIMR','L',IVARIM)
C ------ RECUPERATION DES CARACTERISTIQUES ELASTIQUE
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))

         NUMLOI = 2
         NBPAR = 0
         NOMPA = ' '
         VALPA = 0.D0
C --- -- RECUPERE TOUS LES PARAMETRES
         CALL R8INIR(NBRE2,ZERO,VALRE2,1)
         CALL RCVALA(ZI(IMATE),' ','DIS_VISC',NBPAR,NOMPA,VALPA,
     &               NBRE2,NOMRE2,VALRE2,CODRE2,'  ')

C --- -- MATRICE EN REPERE GLOBAL ==> IREP = 1
         IF (IREP.EQ.1) THEN
            MESSAK(1) = NOMTE
            MESSAK(2) = OPTION
            MESSAK(3) = ZK16(ICOMPO+3)
            MESSAK(4) = ZK16(ICOMPO)
            CALL TECAEL ( IADZI, IAZK24 )
            MESSAK(5) = ZK24(IAZK24-1+3)
            CALL U2MESK('F','DISCRETS_5',5,MESSAK)
         ENDIF

C --- -- LES CARACTERISTIQUES SONT TOUJOURS DANS LE REPERE LOCAL
C        ON FAIT SEULEMENT UNE COPIE
         CALL DCOPY(NBT,ZR(JDC),1,KLV,1)

C --- -- SI UN DDL N'EST PAS AFFECTE D'UN COMPORTEMENT NON-LINEAIRE
C        IL EST DONC ELASTIQUE DANS CETTE DIRECTION. ==> DINONC
         CALL R8INIR(6, ZERO,  RAIDE, 1)
C --- -- EXAMEN DES CODRE2, VALRE2. ON AFFECTE RAIDE, LES PARAMETRES
         CALL DINONC(NOMTE,CODRE2,VALRE2,KLV,RAIDE,NBPARA,COEFLO,2,
     &               OKDIRE)

C --- -- LOI DE COMPORTEMENT NON-LINEAIRE
         CALL R8INIR(NBVINT, ZERO, VARDNL, 1)
C        RECUPERATION DU TEMPS + et -. CALCUL DE DT
         CALL JEVECH('PINSTPR','L',JTP)
         CALL JEVECH('PINSTMR','L',JTM)
         DTEMPS = ZR(JTP) - ZR(JTM)
         CALL DINON2(NEQ,ULM,DUL,ULP,NNO,
     &               NC,ZR(IVARIM),RAIDE,NBPARA,COEFLO,OKDIRE,
     &               VARDNL,DTEMPS)

C --- -- ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         CALL DINONA(NOMTE,RAIDE,KLV)

C        ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         IF (OPTION.EQ.'FULL_MECA' .OR.
     &       OPTION.EQ.'RIGI_MECA_TANG') THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            IF (NDIM.EQ.3) THEN
               CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MLG(NNO,NC,PGL,KLV,ZR(IMAT))
            END IF
         END IF

C ------ CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET MISE A JOUR DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)

            CALL DINOSI(NBT,NEQ,NNO,NC,PGL,
     &                  KLV,DUL,ZR(ICONTM),ZR(ICONTP),ZR(IFONO),
     &                  NUMLOI,VARDNL)
            DO 122 II = 1 , NBVIN2
               ZR(IVARIP+II-1) = VARDNL(II)
122         CONTINUE
         ENDIF
         GOTO 800
      ENDIF
C ======================================================================
C            FIN COMPORTEMENT VISQUEUX DISCRET_NON_LINE
C ======================================================================

C ======================================================================
C            DEBUT COMPORTEMENT DIS_ECRO_CINE : DISCRET_NON_LINE
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'DIS_ECRO_CINE') THEN
C ------ RECUPERATION DU MATERIAU
         CALL JEVECH('PMATERC','L',IMATE)

C ------ VARIABLES INTERNES A T-
         CALL JEVECH('PVARIMR','L',IVARIM)
C ------ RECUPERATION DES CARACTERISTIQUES
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))

         NUMLOI = 3
         NBPAR = 0
         NOMPA = ' '
         VALPA = 0.D0
C --- -- RECUPERE TOUS LES PARAMETRES
         CALL R8INIR(NBRE3,ZERO,VALRE3,1)
         CALL RCVALA(ZI(IMATE),' ','DIS_ECRO_CINE',NBPAR,NOMPA,VALPA,
     &               NBRE3,NOMRE3,VALRE3,CODRE3,'  ')

C --- -- MATRICE EN REPERE GLOBAL ==> IREP = 1
         IF (IREP.EQ.1) THEN
            MESSAK(1) = NOMTE
            MESSAK(2) = OPTION
            MESSAK(3) = ZK16(ICOMPO+3)
            MESSAK(4) = ZK16(ICOMPO)
            CALL TECAEL ( IADZI, IAZK24 )
            MESSAK(5) = ZK24(IAZK24-1+3)
            CALL U2MESK('F','DISCRETS_5',5,MESSAK)
         ENDIF

C --- -- LES CARACTERISTIQUES SONT TOUJOURS DANS LE REPERE LOCAL
C        ON FAIT SEULEMENT UNE COPIE
         CALL DCOPY(NBT,ZR(JDC),1,KLV,1)

C --- -- SI UN DDL N'EST PAS AFFECTE D'UN COMPORTEMENT NON-LINEAIRE
C        IL EST DONC ELASTIQUE DANS CETTE DIRECTION. ==> DINONC
         CALL R8INIR(6, ZERO,  RAIDE, 1)
         CALL R8INIR(6*NBPARA, MOINS1,  COEFLO, 1)
C --- -- EXAMEN DES CODRE3, VALRE3. ON AFFECTE RAIDE, LES PARAMETRES
         CALL DINONC(NOMTE,CODRE3,VALRE3,KLV,RAIDE,NBPARA,COEFLO,4,
     &               OKDIRE)
C --- -- LOI DE COMPORTEMENT NON-LINEAIRE
         CALL R8INIR(NBVINT, ZERO, VARDNL, 1)
         CALL DINON3(NEQ,ULM,DUL,ULP,NNO,
     &               NC,ZR(IVARIM),RAIDE,NBPARA,COEFLO,OKDIRE,
     &               VARDNL)

C --- -- ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         CALL DINONA(NOMTE,RAIDE,KLV)

C        ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         IF (OPTION.EQ.'FULL_MECA' .OR.
     &       OPTION.EQ.'RIGI_MECA_TANG') THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            IF (NDIM.EQ.3) THEN
               CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MLG(NNO,NC,PGL,KLV,ZR(IMAT))
            END IF
         END IF

C ------ CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET MISE A JOUR DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)

            CALL DINOSI(NBT,NEQ,NNO,NC,PGL,
     &                  KLV,DUL,ZR(ICONTM),ZR(ICONTP),ZR(IFONO),
     &                  NUMLOI,VARDNL)
            DO 123 II = 1 , NBVIN3
               ZR(IVARIP+II-1) = VARDNL(II)
123         CONTINUE
         ENDIF
         GOTO 800
      ENDIF
C ======================================================================
C              FIN COMPORTEMENT CINEMATIQUE DISCRET_NON_LINE
C ======================================================================

C ======================================================================
C            DEBUT COMPORTEMENT DIS_BILI_ELAS : DISCRET_NON_LINE
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'DIS_BILI_ELAS') THEN
C ------ RECUPERATION DU MATERIAU
         CALL JEVECH('PMATERC','L',IMATE)

C ------ VARIABLES INTERNES A T-
         CALL JEVECH('PVARIMR','L',IVARIM)
C ------ RECUPERATION DES CARACTERISTIQUES
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))

C --- -- MATRICE EN REPERE GLOBAL ==> IREP = 1
         IF (IREP.EQ.1) THEN
            MESSAK(1) = NOMTE
            MESSAK(2) = OPTION
            MESSAK(3) = ZK16(ICOMPO+3)
            MESSAK(4) = ZK16(ICOMPO)
            CALL TECAEL ( IADZI, IAZK24 )
            MESSAK(5) = ZK24(IAZK24-1+3)
            CALL U2MESK('F','DISCRETS_5',5,MESSAK)
         ENDIF
C --- -- LES CARACTERISTIQUES SONT TOUJOURS DANS LE REPERE LOCAL
C        ON FAIT SEULEMENT UNE COPIE
         CALL DCOPY(NBT,ZR(JDC),1,KLV,1)

         NUMLOI = 4
C --- -- RECUPERE TOUS LES PARAMETRES
         CALL R8INIR(NBRE4,ZERO,VALRE4,1)
C --- -- TEMPERATURE : SI 2 NOEUDS ==> MOYENNE
         CALL RCVARC(' ','TEMP','+','RIGI',1,1,VALPA,IRET)
         IF ( NNO .EQ. 2 ) THEN
            CALL RCVARC(' ','TEMP','+','RIGI',2,1,TEMPER,IRET)
            VALPA = (VALPA+TEMPER)*0.5D0
         ENDIF
         NBPAR = 1
         NOMPA = 'TEMP'
         CALL RCVALA(ZI(IMATE),' ','DIS_BILI_ELAS',NBPAR,NOMPA,VALPA,
     &               NBRE4,NOMRE4,VALRE4,CODRE4,'  ')

C --- -- SI UN DDL N'EST PAS AFFECTE D'UN COMPORTEMENT NON-LINEAIRE
C        IL EST DONC ELASTIQUE DANS CETTE DIRECTION. ==> DINONC
         CALL R8INIR(6, ZERO,  RAIDE, 1)
C --- -- EXAMEN DES CODRE4 VALRE4. ON AFFECTE RAIDE, LES PARAMETRES
         CALL DINONC(NOMTE,CODRE4,VALRE4,KLV,RAIDE,NBPARA,COEFLO,3,
     &               OKDIRE)

C --- -- LOI DE COMPORTEMENT NON-LINEAIRE
         CALL R8INIR(NBVINT, ZERO, VARDNL, 1)
         CALL DINON4(NEQ,ULM,DUL,ULP,NNO,
     &               NC,ZR(IVARIM),RAIDE,NBPARA,COEFLO,OKDIRE,
     &               VARDNL)

C --- -- ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         CALL DINONA(NOMTE,RAIDE,KLV)

C        ACTUALISATION DE LA MATRICE QUASI-TANGENTE
         IF (OPTION.EQ.'FULL_MECA' .OR.
     &       OPTION.EQ.'RIGI_MECA_TANG') THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            IF (NDIM.EQ.3) THEN
               CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MLG(NNO,NC,PGL,KLV,ZR(IMAT))
            END IF
         END IF

C ------ CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET MISE A JOUR DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)

            CALL DINOSI(NBT,NEQ,NNO,NC,PGL,
     &                  KLV,DUL,ZR(ICONTM),ZR(ICONTP),ZR(IFONO),
     &                  NUMLOI,VARDNL)
            DO 124 II = 1 , NBVIN4
               ZR(IVARIP+II-1) = VARDNL(II)
124         CONTINUE
         ENDIF
         GOTO 800
      ENDIF
C ======================================================================
C              FIN COMPORTEMENT DIS_BILI_ELAS DISCRET_NON_LINE
C ======================================================================

C ======================================================================
C                      COMPORTEMENT CORNIERE
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'ASSE_CORN') THEN
C ---    PARAMETRES EN ENTREE
         CALL JEVECH('PITERAT','L',IITER)
         CALL JEVECH('PMATERC','L',IMATE)
         CALL JEVECH('PVARIMR','L',IVARIM)
C ---    RELATION DE COMPORTEMENT DE LA CORNIERE
         IRMETG = 0
         IF (OPTION.EQ.'RIGI_MECA_TANG') IRMETG = 1
         ITERAT = NINT(ZR(IITER))
         CALL DICORN(IRMETG,NBT,NEQ,ITERAT,ZI(IMATE),ULM,DUL,ULP,
     &               ZR(ICONTM),ZR(IVARIM),KLV,KLV2,VARIPC)

C ---    ACTUALISATION DE LA MATRICE TANGENTE
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RIGI_MECA_TANG' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            CALL UTPSLG(NNO,NC,PGL,KLV2,ZR(IMAT))
         END IF

C ---    CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)
            ILOGIC = 0
            PLOUF = 0.D0
            CALL DISIEF(NBT,NEQ,NNO,NC,PGL,KLV,DUL,ZR(ICONTM),ILOGIC,
     &                  PLOUF,PLOUF,ZR(ICONTP),ZR(IFONO),PLOUF,PLOUF)
            DO 25 I = 1,7
               ZR(IVARIP+I-1) = VARIPC(I)
               ZR(IVARIP+I+6) = VARIPC(I)
25          CONTINUE
         END IF
         GOTO 800
      END IF
C ======================================================================
C                 FIN DU COMPORTEMENT CORNIERE
C ======================================================================

C ======================================================================
C                    COMPORTEMENT ARMEMENT
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'ARME') THEN
C ---    PARAMETRES EN ENTREE
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))
         CALL DCOPY(NBT,ZR(JDC),1,KLV,1)
         IF (IREP.EQ.1) THEN
            CALL UTPSGL(NNO,NC,PGL,ZR(JDC),KLV)
         END IF
         CALL JEVECH('PMATERC','L',IMATE)
         CALL JEVECH('PVARIMR','L',IVARIM)
C ---    RELATION DE COMPORTEMENT DE L'ARMEMENT
         CALL DIARME(NBT,NEQ,ZI(IMATE),ULM,DUL,ULP,ZR(ICONTM),
     &               ZR(IVARIM),KLV,VARIP,KTY2,DULY)
C ---    ACTUALISATION DE LA MATRICE TANGENTE
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RIGI_MECA_TANG' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
         END IF
C ---    CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)
            ILOGIC = 1
            PLOUF = 0.D0
            CALL DISIEF(NBT,NEQ,NNO,NC,PGL,KLV,DUL,ZR(ICONTM),ILOGIC,
     &             KTY2,DULY,ZR(ICONTP),ZR(IFONO),PLOUF,PLOUF)
            ZR(IVARIP) = VARIP
            ZR(IVARIP+1) = VARIP
         END IF
         GOTO 800
      END IF
C ======================================================================
C                 FIN DU COMPORTEMENT ARMEMENT
C ======================================================================

C ======================================================================
C  COMPORTEMENT DIS_GRICRA : APPLICATION : LIAISON GRILLE-CRAYON COMBU
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'DIS_GRICRA') THEN
         IF (NOMTE.NE.'MECA_DIS_TR_L') THEN
            MESSAK(1) = NOMTE
            MESSAK(2) = OPTION
            MESSAK(3) = ZK16(ICOMPO+3)
            MESSAK(4) = ZK16(ICOMPO)
            CALL TECAEL ( IADZI, IAZK24 )
            MESSAK(5) = ZK24(IAZK24-1+3)
            CALL U2MESK('F','DISCRETS_11',5,MESSAK)
         ENDIF
C
         CALL JEVECH('PMATERC','L',IMATE)
         CALL JEVECH('PVARIMR','L',IVARIM)
         CALL JEVECH('PINSTPR','L',JTP)
C
C        ON RECUPERE L'IRRADIATION A T+ SUR LE 1ER PG :
         CALL RCVARC(' ','IRRA','+','RIGI',1,1,IRRAP,IRET2)
         IF (IRET2.GT.0) IRRAP=0.D0

C         IF (OPTION(1:9).EQ.'RIGI_MECA' .OR.
C      &    OPTION(1:9).EQ.'FULL_MECA') THEN
C           CALL JEVECH('PMATUNS','E',IMAT)
C         ENDIF

         IF ( OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &        OPTION(1:9).EQ.'FULL_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)
         END IF
         CALL DICRGR(FAMI,OPTION,NEQ,NC,ZI(IMATE),
     &              ULM,DUL,ZR(ICONTM),ZR(IVARIM),
     &              PGL,KLV,ZR(IVARIP),ZR(IFONO),ZR(ICONTP),
     &              IRRAP)

         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RIGI_MECA_TANG' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
         END IF
         GOTO 800
      END IF
C ======================================================================
C                 FIN DU COMPORTEMENT DIS_GRICRA
C ======================================================================

C ======================================================================
C                    COMPORTEMENT CHOC
C ======================================================================
      IF (ZK16(ICOMPO).EQ.'DIS_CHOC') THEN
C ---    PARAMETRES EN ENTREE
         CALL JEVECH('PCADISK','L',JDC)
         IREP = NINT(ZR(JDC+NBT))
         CALL DCOPY(NBT,ZR(JDC),1,KLV,1)
         IF (IREP.EQ.1) THEN
            CALL UTPSGL(NNO,NC,PGL,ZR(JDC),KLV)
         END IF
         CALL JEVECH('PMATERC','L',IMATE)
         CALL JEVECH('PVARIMR','L',IVARIM)
         DO 30 I = 1,7
            VARMO(I) = ZR(IVARIM+I-1)
30       CONTINUE
         CALL JEVECH('PINSTPR','L',JINST)
         CALL TECACH('ONN','PVITPLU',1,IVITP,IRET)
         IF (IRET.EQ.0) THEN
            CALL UTPVGL(NNO,NC,PGL,ZR(IVITP),DVL)
         ELSE
            DO 40 I = 1,12
               DVL(I) = 0.D0
40          CONTINUE
         END IF
         CALL TECACH('ONN','PDEPENT',1,IDEPEN,IRET)
         IF (IRET.EQ.0) THEN
            CALL UTPVGL(NNO,NC,PGL,ZR(IDEPEN),DPE)
         ELSE
            DO 50 I = 1,12
               DPE(I) = 0.D0
50          CONTINUE
         END IF
         CALL TECACH('ONN','PVITENT',1,IVITEN,IRET)
         IF (IRET.EQ.0) THEN
            CALL UTPVGL(NNO,NC,PGL,ZR(IVITEN),DVE)
         ELSE
            DO 60 I = 1,12
               DVE(I) = 0.D0
60          CONTINUE
         END IF
C ---    RELATION DE COMPORTEMENT DE CHOC
         CALL DICHOC(NBT,NEQ,NNO,NC,ZI(IMATE),DUL,ULP,ZR(IGEOM),PGL,
     &              KLV,KTY2,DULY,DVL,DPE,DVE,FOR2,
     &              FOR3,VARMO,VARPL)

C ---    ACTUALISATION DE LA MATRICE TANGENTE
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RIGI_MECA_TANG' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
         END IF

C ---    CALCUL DES EFFORTS GENERALISES, DES FORCES NODALES
C        ET DES VARIABLES INTERNES
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)
            ILOGIC = 2
            CALL DISIEF(NBT,NEQ,NNO,NC,PGL,KLV,DUL,ZR(ICONTM),ILOGIC,
     &               KTY2,DULY,ZR(ICONTP),ZR(IFONO),FOR2,FOR3)
            DO 70 I = 1,7
               ZR(IVARIP+I-1) = VARPL(I)
               IF (NNO.EQ.2) ZR(IVARIP+I+6) = VARPL(I)
70          CONTINUE
         END IF
         GOTO 800
      END IF
C ======================================================================
C                 FIN DU COMPORTEMENT CHOC
C ======================================================================

C ======================================================================
C  COMPORTEMENT DIS_GOUJON : APPLICATION : GOUJ2ECH
C ======================================================================
      IF (ZK16(ICOMPO) (1:10).EQ.'DIS_GOUJ2E') THEN
         CALL JEVECH('PCADISK','L',JDC)
C        MATRICE DE RIGIDITE EN REPERE LOCAL
         IREP = NINT(ZR(JDC+NBT))
         IF (IREP.EQ.1) THEN
            IF (NDIM.EQ.3) THEN
               CALL UTPSGL(NNO,NC,PGL,ZR(JDC),KLV)
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MGL(NNO,NC,PGL,ZR(JDC),KLV)
            END IF
         ELSE
            CALL DCOPY(NBT,ZR(JDC),1,KLV,1)
         END IF
         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RAPH_MECA' ) THEN
            CALL JEVECH('PMATERC','L',IMATE)
            CALL JEVECH('PVARIMR','L',IVARIM)
            CALL JEVECH('PVECTUR','E',IFONO)
            CALL JEVECH('PCONTPR','E',ICONTP)
            CALL JEVECH('PVARIPR','E',IVARIP)
         ELSE IF (OPTION.EQ.'RIGI_MECA_TANG') THEN
            CALL JEVECH('PMATERC','L',IMATE)
            CALL JEVECH('PVARIMR','L',IVARIM)
         END IF
C        RELATION DE COMPORTEMENT : ELASTIQUE PARTOUT
C        SAUF SUIVANT Y LOCAL : ELASTOPLASTIQUE VMIS_ISOT_TRAC
         CALL DIGOUJ(OPTION,ZK16(ICOMPO),NNO,NBT,NEQ,NC,ZI(IMATE),
     &              DUL,ZR(ICONTM),ZR(IVARIM),PGL,KLV,KLV2,ZR(IVARIP),
     &              ZR(IFONO),ZR(ICONTP),NOMTE)

         IF ( OPTION.EQ.'FULL_MECA' .OR.
     &        OPTION.EQ.'RIGI_MECA_TANG' ) THEN
            CALL JEVECH('PMATUUR','E',IMAT)
            IF (NDIM.EQ.3) THEN
               CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMAT))
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2MLG(NNO,NC,PGL,KLV,ZR(IMAT))
            END IF
         END IF
         GOTO 800
      END IF
C ======================================================================
C                 FIN DU COMPORTEMENT DIS_GOUJON
C ======================================================================

C     SI ON PASSE PAR ICI C'EST QU'AUCUN COMPORTEMENT N'EST VALIDE
      MESSAK(1) = NOMTE
      MESSAK(2) = OPTION
      MESSAK(3) = ZK16(ICOMPO+3)
      MESSAK(4) = ZK16(ICOMPO)
      CALL TECAEL ( IADZI, IAZK24 )
      MESSAK(5) = ZK24(IAZK24-1+3)
      CALL U2MESK('F','DISCRETS_7',5,MESSAK)

C     TOUS LES COMPORTEMENTS PASSE PAR ICI
800   CONTINUE
      IF ( OPTION(1:9).EQ.'FULL_MECA'  .OR.
     &     OPTION(1:9).EQ.'RAPH_MECA'  ) THEN
         CALL JEVECH ( 'PCODRET', 'E', JCRET )
         ZI(JCRET) = 0
      ENDIF
C
      END
