      SUBROUTINE TE0086 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/08/2003   AUTEUR JMBHH01 J.M.PROIX 
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
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES CONTRAINTES EN 2D
C                          OPTION : 'SIGM_ELNO_DEPL  '
C                             OU  : 'SIEF_ELGA_DEPL  '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*8      MODELI,ELREFE
      CHARACTER*24     CARAC,FF
      REAL*8           SIGMA(54), REPERE(7),SIGM2(54)
      REAL*8           NHARM, INSTAN, BIDON
      LOGICAL          LSENS
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C
      CALL ELREF1(ELREFE)

      MODELI(1:2) = NOMTE(3:4)
C
C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
      NPG2 = ZI(ICARAC+3)
      NPG3 = ZI(ICARAC+4)
      NPG4 = ZI(ICARAC+5)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
C
      IF ( (OPTION.EQ.'SIGM_ELNO_DEPL')
     &     .OR.(OPTION.EQ.'SIGM_ELNO_SENS') ) THEN
        IF(NOMTE(5:7).EQ.'TR3' .OR. NOMTE(5:7).EQ.'QU4' .OR.
     &     NOMTE(5:7).EQ.'QS4') THEN
           NNOS = NNO
           IPOIDS = IFF + NPG1*(1+3*NNO)
           IVF  = IPOIDS+NPG2
           IDFDE = IVF  +NPG2*NNO
           IDFDK = IDFDE +NPG2*NNO
           NPG  = NPG2
        ELSE IF(NOMTE(5:7).EQ.'TR6' .OR. NOMTE(5:7).EQ.'QU8' .OR.
     &          NOMTE(5:7).EQ.'QS8' .OR. NOMTE(5:7).EQ.'QU9' ) THEN
           NNOS = NNO/2
           IPOIDS = IFF + (NPG1+NPG2+NPG3)*(1+3*NNO)
           IVF  = IPOIDS+NPG4
           IDFDE = IVF  +NPG4*NNO
           IDFDK = IDFDE +NPG4*NNO
           NPG  = NPG4
        ENDIF
      ELSE
         IPOIDS = IFF
         IVF    = IPOIDS+NPG1
         IDFDE  = IVF   +NPG1*NNO
         IDFDK  = IDFDE +NPG1*NNO
         NPG    = NPG1
      ENDIF
C
C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG1  = NBSIGM(MODELI)
      NBSIG2  = 6
      NBSIG   = NBSIG1
C
C --- INITIALISATIONS :
C     -----------------
      ZERO     = 0.0D0
      INSTAN   = ZERO
      NHARM    = ZERO
      BIDON    = ZERO
      NDIM     = 2
      IF (OPTION(11:14).EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE
        LSENS = .FALSE.
      ENDIF
C
      DO 10 I = 1, NBSIG2*NPG
         SIGMA(I)  = ZERO
 10   CONTINUE
C
C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)
C
C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)
C
C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
      CALL ORTREP(ZI(IMATE),NDIM,REPERE)
C
C ---- RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PDEPLAR','L',IDEPL)
C
C ---- RECUPERATION DU CHAMP DE DEPLACEMENT DERIVE SUR L'ELEMENT
C      ---------------------------------------------------------
      IF (LSENS) CALL JEVECH('PDEPSEN','L',IDEPS)
C
C ---- RECUPERATION DU CHAMP DE TEMPERATURE SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PTEMPER','L',ITEMPE)
C
C ---- RECUPERATION DE LA TEMPERATURE DE REFERENCE
C      -------------------------------------------
      CALL JEVECH('PTEREF','L',ITREF)
C
C ---- RECUPERATION DU VECTEUR DES CONTRAINTES EN SORTIE
C      -------------------------------------------------
      CALL JEVECH('PCONTRR','E',ICONT)
C
C ---- CALCUL DES CONTRAINTES 'VRAIES' AUX POINTS D'INTEGRATION
C ---- DE L'ELEMENT :
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
C      ------------------------------------
      CALL SIGVMC(MODELI,NNO,NDIM,NBSIG1,NPG,ZR(IVF),ZR(IDFDE),ZR(IDFDK)
     +            ,BIDON,ZR(IPOIDS),ZR(IGEOM),ZR(IDEPL),ZR(ITEMPE),
     +            ZR(ITREF),INSTAN,REPERE,ZI(IMATE),NHARM,SIGMA,.FALSE.)
C
C
C ---- CALC DU TERME COMPLEMENTAIRE DE CONTR 'VRAIES' SUR L'ELEMENT
C ---- DANS LE CAS DE LA SENSIBILITE (TERME DA/DP*B*U)
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
C ATTENTION!! POUR L'INSTANT(30/9/02) ON DOIT AVOIR SIGMA_THERMIQUE=0
C      ------------------------------------
      IF (LSENS) THEN
        CALL SIGVMC(MODELI,NNO,NDIM,NBSIG1,NPG,ZR(IVF),ZR(IDFDE),
     +            ZR(IDFDK),
     +            BIDON,ZR(IPOIDS),ZR(IGEOM),ZR(IDEPS),ZR(ITEMPE),
     +            ZR(ITREF),INSTAN,REPERE,ZI(IMATE),NHARM,SIGM2,.TRUE.)
        DO 15 I=1, NBSIG*NPG
          SIGMA(I) = SIGMA(I) + SIGM2(I)
15      CONTINUE
      ENDIF
C
      IF (OPTION(6:9).EQ.'ELGA') THEN
C         --------------------
C ---- AFFECTATION DU VECTEUR EN SORTIE AVEC LES CONTRAINTES AUX
C ---- POINTS D'INTEGRATION
C      --------------------
        DO 60 IGAU = 1, NPG
        DO 60 ISIG = 1, NBSIG
          ZR(ICONT+NBSIG*(IGAU-1)+ISIG-1) = SIGMA(NBSIG*(IGAU-1)+ISIG)
60     CONTINUE
C
      ELSE
C
        CALL PPGANO (NNOS,NPG,NBSIG,SIGMA,ZR(ICONT))
C
      ENDIF
C
      END
