      SUBROUTINE DKQMAS ( XYZL , OPTION , PGL , MAS , ENER )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/11/2001   AUTEUR JMBHH01 J.M.PROIX 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8        XYZL(3,*) , PGL(*)
      CHARACTER*(*) OPTION
      REAL*8        MAS(*) , ENER(*)
C     ------------------------------------------------------------------
C     MATRICE MASSE DE L'ELEMENT DE PLAQUE DKQ
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES QUATRE NOEUDS
C     IN  OPTION : OPTION RIGI_MECA OU EPOT_ELEM_DEPL
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
C     OUT MAS    : MATRICE DE RIGIDITE
C     OUT ENER   : TERMES POUR ENER_CIN (ECIN_ELEM_DEPL)
C     ------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER      INT , II(8) , JJ(8), LL(16), P
      REAL*8       ROE , RHO , EPAIS, ROF, ZERO, DOUZE
      REAL*8       DETJ , WGT, NFX(12), NFY(12), NMI(4), NMX(8), NMY(8)
      REAL*8       WKQ(12) , DEPL(24)
      REAL*8       FLEX(12,12)
      REAL*8       MEMB(8,8) , AMEMB(64)
      REAL*8       MEFL(8,12)
      REAL*8       MASLOC(300), MASGLO(300)
      CHARACTER*24 DESR
      CHARACTER*8  TYPELE
      LOGICAL      EXCE, INER
C
C     ------------------ PARAMETRAGE QUADRANGLE ------------------------
      INTEGER NPG , NC , NNO
      INTEGER LDETJ,LJACO,LTOR,LQSI,LETA,LWGT,LXYC,LCOTE,LCOS,LSIN
      INTEGER LAIRE
               PARAMETER (NPG   = 4)
               PARAMETER (NNO   = 4)
               PARAMETER (NC    = 4)
               PARAMETER (LDETJ = 1)
               PARAMETER (LJACO = 2)
               PARAMETER (LTOR  = LJACO + 4)
               PARAMETER (LQSI  = LTOR  + 1)
               PARAMETER (LETA  = LQSI + NPG + NNO + 2*NC)
               PARAMETER (LWGT  = LETA + NPG + NNO + 2*NC)
               PARAMETER (LXYC  = LWGT  + NPG)
               PARAMETER (LCOTE = LXYC  + 2*NC)
               PARAMETER (LCOS  = LCOTE + NC)
               PARAMETER (LSIN  = LCOS  + NC)
               PARAMETER (LAIRE = LSIN  + NC)
C     ------------------------------------------------------------------
      REAL*8        CTOR
      DATA (II(K),K=1,8)
     &   / 1, 10, 19, 28, 37, 46, 55, 64 /
      DATA (JJ(K),K=1,8)
     &   / 5, 14, 23, 32, 33, 42, 51, 60 /
      DATA (LL(K),K=1,16)
     &   / 3, 7, 12, 16, 17, 21, 26, 30, 35, 39, 44, 48, 49, 53, 58, 62/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      ZERO   =  0.0D0
      UNQUAR =  0.25D0
      UNDEMI =  0.5D0
      UN     =  1.0D0
      NEUF   =  9.0D0
      DOUZE  = 12.0D0
C
      TYPELE = 'MEDKQU4 '
      CALL DXROEP ( RHO , EPAIS )
      ROE = RHO * EPAIS
      ROF = RHO*EPAIS*EPAIS*EPAIS/DOUZE
      EXCENT = ZERO
      DESR = '&INEL.'//TYPELE//'.DESR'
      CALL JEVETE ( DESR , ' ' , LZR )
C
      CALL JEVECH ('PCACOQU', 'L', JCOQU)
      CTOR   = ZR(JCOQU+3)
      EXCENT = ZR(JCOQU+4)
      XINERT = ZR(JCOQU+5)
C
      EXCE = .FALSE.
      INER = .FALSE.
      IF (ABS(EXCENT).GT.UN/R8GAEM()) EXCE = .TRUE.
      IF (ABS(XINERT).GT.UN/R8GAEM()) INER = .TRUE.
      IF ( .NOT. INER )  ROF = 0.0D0
C
C --- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE :
C     ---------------------------------------------------
      CALL GQUAD4 (XYZL , ZR(LZR))
C
C --- INITIALISATIONS :
C     ---------------
      DO  10 K = 1 , 96
         MEFL(K,1) = ZERO
   10 CONTINUE
      DO 20 K = 1 , 144
         FLEX(K,1) = ZERO
   20 CONTINUE
C
      DETJ     = ZR(LZR-1+LDETJ)
C
C======================================
C ---  CALCUL DE LA MATRICE DE MASSE  =
C======================================
C=====================================================================
C ---  CALCUL DE LA PARTIE MEMBRANE CLASSIQUE DE LA MATRICE DE MASSE =
C ---  LES TERMES SONT EN NK*NP                                      =
C=====================================================================
C
      COEFM = ZR(LZR-1+LAIRE) * ROE /  NEUF
      DO 30 K = 1 , 64
         AMEMB(K) = ZERO
  30  CONTINUE
      DO 40 K = 1 , 8
         AMEMB(II(K)) = UN
         AMEMB(JJ(K)) = UNQUAR
  40  CONTINUE
      DO 50 K = 1 , 16
         AMEMB(LL(K)) = UNDEMI
  50  CONTINUE
      DO 60 K = 1 , 64
         MEMB(K,1) = COEFM * AMEMB(K)
  60  CONTINUE
C
C --- BOUCLE SUR LES POINTS D'INTEGRATION :
C     ===================================
      DO 70 INT = 1, NPG
C
C ---    CALCUL DU JACOBIEN SUR LE QUADRANGLE :
C        ------------------------------------ 
         CALL JQUAD4 (INT , XYZL , ZR(LZR))
C
C===========================================================
C ---  CALCUL DE LA PARTIE FLEXION DE LA MATRICE DE MASSE  =
C===========================================================
C
C ---    CALCUL DES FONCTIONS D'INTERPOLATION DE LA FLECHE :
C        -------------------------------------------------
         CALL DKQNIW (INT , ZR(LZR) , WKQ)
C
         DETJ     = ZR(LZR-1+LDETJ)
C
C ---   LA MASSE VOLUMIQUE RELATIVE AUX TERMES DE FLEXION W
C ---   EST EGALE A RHO_E = RHO*EPAIS :
C       -----------------------------
         WGT = ZR(LZR-1+LWGT+INT-1) * DETJ * ROE
C
C ---   CALCUL DE LA PARTIE FLEXION DE LA MATRICE DE MASSE
C ---   DUE AUX SEULS TERMES DE LA FLECHE W :
C       -----------------------------------
         DO 80 I = 1 , 12
           DO 90 J = 1 , 12
             FLEX(I,J) = FLEX(I,J) + WKQ(I) * WKQ(J) * WGT
   90     CONTINUE
   80   CONTINUE
C
C ---   CALCUL DES FONCTIONS D'INTERPOLATION DES ROTATIONS :
C       --------------------------------------------------
        CALL DKQNIB(INT,ZR(LZR),NFX,NFY)
C
C ---   LA MASSE VOLUMIQUE RELATIVE AUX TERMES DE FLEXION BETA
C ---   EST EGALE A RHO_F = RHO*EPAIS**3/12 + D**2*EPAIS*RHO :
C       ----------------------------------------------------
          WGTF = ZR(LZR-1+LWGT+INT-1)*DETJ*(ROF+EXCENT*EXCENT*ROE)
C
C ---   PRISE EN COMPTE DES TERMES DE FLEXION DUS AUX ROTATIONS :
C       -------------------------------------------------------
          DO 100 I = 1, 12
            DO 110 J = 1, 12
              FLEX(I,J) = FLEX(I,J)+(NFX(I)*NFX(J)+NFY(I)*NFY(J))*WGTF
  110      CONTINUE
  100    CONTINUE
C
C====================================================================
C ---  CAS OU L'ELEMENT EST EXCENTRE                                =
C====================================================================
C
        IF (EXCE) THEN
C
C ---     FONCTIONS D'INTERPOLATION MEMBRANE :
C         ----------------------------------
          CALL DXQNIM(INT,ZR(LZR),NMI)
C
C====================================================================
C ---  CALCUL DE LA PARTIE MEMBRANE-FLEXION DE LA MATRICE DE MASSE  =
C====================================================================
C
C ---     POUR LE COUPLAGE MEMBRANE-FLEXION, ON DOIT TENIR COMPTE
C ---     DE LA MASSE VOLUMIQUE
C ---     RHO_MF = D*EPAIS*RHO  :
C         --------------------
          WGTMF = ZR(LZR-1+LWGT+INT-1)*DETJ*EXCENT*ROE
C
C ---     TERMES DE COUPLAGE MEMBRANE-FLEXION U*BETA :
C         ------------------------------------------
          DO 120 K = 1, 4
            I1 = 2*(K-1)+1
            I2 = I1     +1
            DO 130 J = 1,12
              MEFL(I1,J) = MEFL(I1,J)+NMI(K)*NFX(J)*WGTMF
              MEFL(I2,J) = MEFL(I2,J)+NMI(K)*NFY(J)*WGTMF
  130       CONTINUE
  120     CONTINUE
C
        ENDIF
C ---   FIN DU TRAITEMENT DU CAS D'UN ELEMENT EXCENTRE
C       ----------------------------------------------
   70 CONTINUE
C --- FIN DE LA BOUCLE SUR LES POINTS D'INTEGRATION
C     ---------------------------------------------
C
C
C --- INSERTION DES DIFFERENTES PARTIES CALCULEES DE LA MATRICE
C --- DE MASSE A LA MATRICE ELLE MEME :
C     ===============================   
      IF (( OPTION .EQ. 'MASS_MECA' ).OR.(OPTION.EQ.'M_GAMMA')) THEN
         CALL DXQLOC ( FLEX   , MEMB   , MEFL  , CTOR , MAS )
      ELSE IF ( OPTION .EQ. 'MASS_MECA_DIAG' ) THEN
         CALL DXQLOC ( FLEX   , MEMB   , MEFL  , CTOR , MASLOC )
         WGT = ZR(LZR-1+LAIRE) * ROE
         CALL UTPSLG ( 4 , 6 , PGL , MASLOC , MASGLO)
         CALL DIALUM ( 4 , 6 , 24 ,WGT , MASGLO , MAS )
      ELSE IF ( OPTION .EQ. 'ECIN_ELEM_DEPL' ) THEN
         CALL JEVECH ('PDEPLAR' , 'L' , JDEPG)
         CALL UTPVGL ( 4 , 6 , PGL , ZR(JDEPG) , DEPL )
         CALL DXQLOE ( FLEX   , MEMB   , MEFL  , CTOR ,
     &                 0 , DEPL , ENER )
      ENDIF
      CALL JEDEMA()
      END
