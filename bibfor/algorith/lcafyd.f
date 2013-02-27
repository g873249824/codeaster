        SUBROUTINE LCAFYD (COMP,MATERF,NBCOMM,CPMONO,NMAT,MOD,NVI,VIND,
     &                     NR,YD)
C RESPONSABLE PROIX J-M.PROIX
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/02/2013   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ----------------------------------------------------------------
C     CHOIX DES VALEURS DE VIND A AFFECTER A YD
C     CAS PARTICULIER DU  MONOCRISTAL  :
C     ON GARDE 1 VARIABLE INTERNE PAR SYSTEME DE GLISSEMENT SUR 3
C     ----------------------------------------------------------------
C     IN
C          COMP   :  NOM MODELE DE COMPORTEMENT
C          MATERF :  COEF MATERIAU
C          NBCOMM :  INDICES DES COEF MATERIAU
C          NMAT   :  DIMENSION MATER
C          COMP   :  TYPE DE MODELISATION
C          NVI    :  NOMBRE DE VARIABLES INTERNES
C          VIND   :  VARIABLES INTERNES A T
C          NR     :  DIMENSION VECTEUR INCOONUES
C     OUT  YD     :  VECTEUR INITIAL
C     ----------------------------------------------------------------
      INTEGER         NDT,NVI,NMAT,NDI,NS,I,NBCOMM(NMAT,3),NR
      REAL*8          YD(*),MATERF(NMAT,2),VIND(*),FE(3,3)
      REAL*8          ID(3,3),HOOKF(6,6),EPSEGL(6)
      REAL*8          EISP, EPSFI(6)
      CHARACTER*16    LOI,COMP(*),NECOUL
      CHARACTER*24    CPMONO(5*NMAT+1)
      CHARACTER*8     MOD
      COMMON /TDIM/   NDT  , NDI
      INTEGER IRR,DECIRR,NBSYST,DECAL,GDEF
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL,GDEF
      DATA ID/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/
C     ----------------------------------------------------------------

C     INITIALISATION DE YD EN IMPLICITE
      LOI=COMP(1)
      
      IF (LOI(1:8).EQ.'MONOCRIS') THEN
C ATTENTION !         NS=(NVI-8)/3
         NS=NR-NDT
         IRR=0
         DECIRR=0
         IF ( MATERF(NBCOMM(1,1),2).GE.4) THEN
C           KOCKS-RAUCH ET DD_CFC : VARIABLE PRINCIPALE=DENSITE DISLOC
C           UNE SEULE FAMILLE
            CALL ASSERT(NBCOMM(NMAT,2).EQ.1)
            DO 102 I=1,NS
               YD(NDT+I)=VIND(6+3*(I-1)+1)
 102        CONTINUE
            NECOUL=CPMONO(3)
            IF (NECOUL.EQ.'MONO_DD_CC_IRRA') THEN
               IRR=1
               DECIRR=6+3*NS
            ENDIF
            IF (NECOUL.EQ.'MONO_DD_CFC_IRRA') THEN
               IRR=1
               DECIRR=6+3*NS
            ENDIF
         ELSE
C           AUTRES COMPORTEMENTS MONOCRISTALLINS
            DO 103 I=1,NS
               YD(NDT+I)=VIND(6+3*(I-1)+2)
 103        CONTINUE
         ENDIF
         

         IF (GDEF.EQ.1) THEN
C les 9 variables internes  de 6+3*ns+1 � 6+3*ns+9
C REPRESENTENT FE - ID       
            CALL DCOPY(9,VIND(NVI-3-18+10),1,FE,1)
            CALL DAXPY(9,+1.D0,ID,1,FE,1)
            CALL LCGRLA(FE,EPSEGL)
            IF (MATERF(NMAT,2).EQ.0) THEN
               CALL LCOPLI  ( 'ISOTROPE' , MOD , MATERF(1,1) , HOOKF )
            ELSEIF (MATERF(NMAT,2).EQ.1) THEN
               CALL LCOPLI  ( 'ORTHOTRO' , MOD , MATERF(1,1) , HOOKF )
            ENDIF
C Y contient H*(FeT.Fe-Id)/2, ce ne sont pas exactement les PK2
C Y contient ensuite les ns alpha_s ou gamma_s suivant la loi
            CALL LCPRMV(HOOKF,EPSEGL,YD)
         ENDIF
         
         
         
      ELSEIF ( LOI(1:7) .EQ. 'IRRAD3M' ) THEN
C        CORRESPONDANCE ENTRE LES VARIABLES INTERNES ET LES EQUATIONS
C        DU SYSTEME DIFFERENTIEL
C        DEFORMATION PLASTIQUE CUMULEE
         YD(NDT+1) = VIND(1)
C        FONCTION SEUIL DE FLUAGE
         YD(NDT+2) = VIND(2)
C        DEFORMATION EQUIVALENTE DE FLUAGE
         YD(NDT+3) = VIND(3)
C        DEFORMATION DE GONFLEMENT
         YD(NDT+4) = VIND(4)
      ELSEIF ( LOI(1:15) .EQ. 'BETON_BURGER_FP' ) THEN
C ===    ============================================================
C        CONSTRUCTION DES DEFORMATIONS IRREVERSIBLES DE FLUAGE PROPRE 
C ===    ============================================================
C ---    RECUPERATION PARTIE SPHERIQUE         
C ===    ============================================================
         EISP = VIND(2)
C ===    ============================================================
C ---    RECUPERATION PARTIE DEVIATOIRE
C ===    ============================================================
         EPSFI(1) = VIND(4)
         EPSFI(2) = VIND(6)
         EPSFI(3) = VIND(8)
         EPSFI(4) = VIND(13)
         EPSFI(5) = VIND(15)
         EPSFI(6) = VIND(17)
C ===    ============================================================
C ---    ASSEMBLAGE PARTIE DEVIATOIRE ET SPHERIQUE
C ===    ============================================================
         DO 200 I = 1, NDI
           EPSFI(I)=EPSFI(I)+EISP
 200     CONTINUE
C ===    ============================================================
C ---    AFFECTATION DES VALEURS AU VECTEUR YD(NDT+I)
C ===    ============================================================
         DO 210 I = 1, NDT
           YD(NDT+I) = EPSFI(I)
 210     CONTINUE

      ELSEIF(LOI(1:4) .EQ. 'LETK')THEN
C --- INITIALISATION A ZERO DU MULTIPLICATEUR PLASTIQUE
         YD(NDT+1) = 0.D0
C --- INITIALISATION A XIP 
         YD(NDT+2) = VIND(1)
C --- INITIALISATION A XIVP 
         YD(NDT+3) = VIND(3)
         
      ELSEIF ( LOI .EQ. 'HAYHURST' ) THEN
C        CORRESPONDANCE ENTRE LES VARIABLES INTERNES ET LES EQUATIONS
C        DU SYSTEME DIFFERENTIEL
C        DEFORMATION PLASTIQUE CUMULEE
         YD(NDT+1) = VIND(7)
C        H1
         YD(NDT+2) = VIND(8)
C        H2
         YD(NDT+3) = VIND(9)
C        D
         YD(NDT+4) = VIND(11)
         
      ELSE
C     CAS GENERAL :
C        TOUTES LES VARIABLES INTERNES SONT RECOPIES
C        LA DERNIERE C'EST TOUJOURS L'INDICATEUR PLASTIQUE
         CALL LCEQVN ( NVI-1,  VIND , YD(NDT+1) )
      ENDIF

      END
