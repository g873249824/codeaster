      SUBROUTINE MEFPRE(NDIM,ALPHA,Z,CF,DH,VIT,RHO,PSTAT,DPSTAT,DVIT,
     &                  ITYPG,ZG,HG,AXG,PM,XIG,AFLUID,CDG,CFG,
     &                  VITG,RHOG)
      IMPLICIT   NONE
C
      INTEGER       NDIM(14)
      REAL*8        ALPHA,Z(*),CF(*),DH,VIT(*),RHO(*),PSTAT(*)
      REAL*8        DPSTAT(*),DVIT(*)
C
      INTEGER       ITYPG(*)
      REAL*8        ZG(*),HG(*),AXG(*),XIG(*),AFLUID,PM
      REAL*8        CDG(*),CFG(*),VITG(*),RHOG(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_21
C ----------------------------------------------------------------------
C     CALCUL DE LA PRESSION ET DU GRADIENT DE PRESSION STATIONNAIRE
C     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST
C ----------------------------------------------------------------------
C     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
C     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
C     DE TUBES SOUS ECOULEMENT AXIAL"
C ----------------------------------------------------------------------
C IN  : NDIM   : TABLEAU DES DIMENSIONS
C IN  : ALPHA  : COEFFICIENT DE PROPORTIONALITE DE LA PESENTEUR PAR
C                RAPPORT A LA VALEUR STANDARD (9.81). LA PROJECTION DU
C                VECTEUR V SUIVANT Z VAUT 9.81*ALPHA.
C IN  : Z      : COORDONNEES 'Z'  DES DES POINTS DE DISCRETISATION DANS
C                LE REPERE AXIAL
C IN  : CF     : COEFFICIENT DE TRAINEE VISQUEUSE DU FLUIDE LE LONG DES
C                PAROIS, AUX POINTS DE DISCRETISATION
C IN  : DH     : DIAMETRE HYDRAULIQUE
C IN  : VIT    : VITESSE D ECOULEMENT DU FLUIDE AUX POINTS DE
C                DISCRETISATION
C IN  : RHO    : MASSE VOLUMIQUE DU FLUIDE AUX POINTS DE DISCRETISATION
C OUT : PSTAT  : PROFIL DE PRESSION STATIONNAIRE
C OUT : DPSTAT : PROFIL DE GRADIENT DE PRESSION STATIONNAIRE
C --  : DVIT   : TABLEAU DE TRAVAIL, GRADIENT DE VITESSE D ECOULEMENT DU
C                FLUIDE
C
C IN  : ITYPG  : VECTEUR DES TYPES DE GRILLES
C IN  : ZG     : COORDONNEES 'Z' DES POSITIONS DES GRILLES DANS LE 
C                 REPERE AXIAL
C IN  : HG     :  VECTEUR DES HAUTEURS DE GRILLE
C IN  : AXG    : VECTEUR DES SECTIONS SOLIDE DES TYPES DE GRILLES
C IN  : XIG    : VECTEUR DES PERIMETRES MOUILLES DES TYPES DE GRILLES
C IN  : AFLUID: SECTION FLUIDE DE L'ECOULEMENT EN L'ABSENCE DE GRILLES
C IN  : PM     : PERIMETRE MOUILLE DE L'ECOULEMENT EN L'ABSENCE
C                DE GRILLES
C IN  : CDG    : VECTEUR DES COEFF DE TRAINEE DES TYPES DE GRILLES
C IN  : CFG    : VECTEUR DES COEEF DE FROTTEMENT DES TYPES DE GRILLES
C IN  : VITG   : VITESSE D'ECOULEMENT DU  FLUIDE AUX POINTS DE 
C                POSITIONNEMENT DES GRILLES
C IN  : RHOG   : MASSE VOLUMIQUE DU FLUIDE AUX MEMES POINTS
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER    I, J, K, N, ICFNEW, NBZ, NBGTOT, NTYPG, IDELTP
      REAL*8     ECART, G, PI, R8PI
C ----------------------------------------------------------------------
      CALL JEMARQ()
C
C --- LECTURE DES DIMENSIONS
      NBZ    = NDIM(1)
      NTYPG  = NDIM(13)
      NBGTOT = NDIM(14)
C
C --- CREATION DES OBJETS DE TRAVAIL
      IF(NTYPG.NE.0) THEN
        CALL WKVECT('&&MEFPRE.DELTAP','V V R',NBGTOT,IDELTP)
        CALL WKVECT('&&MEFPRE.CFNEW' ,'V V R',NBGTOT,ICFNEW)
      ENDIF
C
      PI = R8PI()
C
C --- ACCELERATION DE LA PESANTEUR
      G = 9.81D0*ALPHA
C
C --- VITESSE MOYENNE D ECOULEMENT ET MASSE VOLUMIQUE MOYENNE
C
C
C --- CALCUL DE VIT'(Z) -> G(Z)
C --- MINIMISATION QUADRATIQUE DES RESTES DES
C --- DEVELOPPEMENTS DE TAYLOR DE VIT(Z)
C --- A GAUCHE ET A DROITE
C
      DVIT(1) = ( VIT(2)-VIT(1) ) / (Z(2)-Z(1))

      DO 10 N = 2,NBZ-1
         DVIT(N) = (  (VIT(N+1)-VIT(N))*(Z(N+1)-Z(N))
     &               +(VIT(N-1)-VIT(N))*(Z(N-1)-Z(N)) )
     &            /(  (Z(N+1)-Z(N))*(Z(N+1)-Z(N))
     &               +(Z(N-1)-Z(N))*(Z(N-1)-Z(N)) )
  10  CONTINUE

      DVIT(NBZ) = ( VIT(NBZ)-VIT(NBZ-1) ) / (Z(NBZ)-Z(NBZ-1))
C
C --- CALCUL DU PROFIL DE GRADIENT DE PRESSION STATIONNAIRE
C
      DO 20 N = 1,NBZ
         DPSTAT(N) = -RHO(N)*VIT(N)*DVIT(N) + RHO(N)*G 
     &             -2.D0*RHO(N)*CF(N)*ABS(VIT(N))*VIT(N)/PI/DH
  20  CONTINUE
C
C --- CALCUL DU PROFIL DE PRESSION STATIONNAIRE
C
      PSTAT(1) = 0.D0
      DO 30 N = 2,NBZ
         PSTAT(N) = PSTAT(N-1)+(DPSTAT(N-1)+DPSTAT(N))*
     &                                              (Z(N)-Z(N-1))/2.D0
  30  CONTINUE
C
C--- CALCUL DU SAUT DE PRESSION AU PASSAGE DE CHAQUE GRILLE
C
      IF (NTYPG.NE.0) THEN
C
         DO 6 J = 1,NBGTOT
            ZR(IDELTP+J-1) = 0.D0
 6       CONTINUE
C
         DO 18 I=2,NBZ
            DO 19 J=1,NBGTOT
               ECART=(Z(I)-ZG(J))*(Z(I-1)-ZG(J))
C
               IF (ECART.LE.0.D0) THEN
                  ZR(ICFNEW+J-1)=( CF(I-1)*(Z(I)-ZG(J))+
     &                          CF(I)*(ZG(J)-Z(I-1)) ) / (Z(I)-Z(I-1)) 
               ENDIF
19          CONTINUE
18       CONTINUE     
C
         DO 7 J = 1,NBGTOT
            DO 25 K = 1,NTYPG
               IF (ITYPG(J).EQ.K) THEN
                  ZR(IDELTP+J-1) = 0.5D0*RHOG(J)*ABS(VITG(J))*VITG(J)*
     &                        (AXG(K)*CDG(K)+XIG(K)*HG(K)*CFG(J))/AFLUID
     &                       + 0.5D0*RHOG(J)*ABS(VITG(J))*VITG(J)*
     &    (1.D0-(1.D0-AXG(K)/AFLUID)**2)*PM*HG(K)*ZR(ICFNEW+J-1)/AFLUID
               ENDIF
25          CONTINUE
7        CONTINUE
C
         DO 40 N = 2,NBZ
            DO 42 J = 1,NBGTOT
               ECART = (Z(N)-ZG(J))*(Z(N-1)-ZG(J))
               IF (ECART.LE.0.D0) THEN
                  DO 44 K = N,NBZ
                     PSTAT(K) = PSTAT(K)-ZR(IDELTP+J-1)
 44               CONTINUE
               ENDIF
 42         CONTINUE
 40      CONTINUE
C
      ENDIF
C
      IF ( NTYPG .NE. 0 ) THEN
         CALL JEDETR ( '&&MEFPRE.DELTAP' )
         CALL JEDETR ( '&&MEFPRE.CFNEW'  )
      ENDIF
      CALL JEDEMA()
      END
