      SUBROUTINE TE0494 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_MECA_SECH_R'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*8        MODELI,ELREFE
      CHARACTER*24       CARAC,FF
      REAL*8             BSIGMA(81), SIGTH(162), REPERE(7), INSTAN
      REAL*8             NHARM
      INTEGER            NBSIGM
C
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
C
C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
C
      CALL ELREF1(ELREFE)
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS=IFF
      IVF   =IPOIDS+NPG1
      IDFDE =IVF   +NPG1*NNO
      IDFDK =IDFDE +NPG1*NNO
C
C --- INITIALISATIONS :
C     -----------------
      ZERO   = 0.0D0
      INSTAN = ZERO
      NHARM  = ZERO
      BIDON  = ZERO
      NDIM   = 2
      MODELI(1:2) = NOMTE(3:4)
C
C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM(MODELI)
C
      DO 10 I = 1, NBSIG*NPG1
         SIGTH(I) = ZERO
 10   CONTINUE
C
      DO 20 I = 1, NDIM*NNO
         BSIGMA(I) = ZERO
 20   CONTINUE
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
C ---- RECUPERATION DU CHAMP DE TEMPERATURE SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PTEMPER','L',ITEMPE)
C
C ---- RECUPERATION DE LA TEMPERATURE DE REFERENCE
C      -------------------------------------------
      CALL JEVECH('PTEREF','L',ITREF)
C
C ---- RECUPERATION DU CHAMP DE L'HDRATATION SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PHYDRER','L',IHYDR)
C
C ---- RECUPERATION DU CHAMP DU SECHAGE SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PSECHER','L',ISECH)
C
C ---- RECUPERATION DE L'INSTANT
C      -------------------------
      CALL TECACH(.TRUE.,.FALSE.,'PTEMPSR',1,ITEMPS)
      IF (ITEMPS.NE.0) INSTAN = ZR(ITEMPS)
C
C ---- CALCUL DES CONTRAINTES DE SECHAGE AUX POINTS D'INTEGRATION
C ---- DE L'ELEMENT :
C      ------------
      CALL SIGTMC(MODELI,NNO,NDIM,NBSIG,NPG1,ZR(IVF),ZR(IGEOM),
     +            ZR(ITEMPE),ZR(ITREF),ZR(IHYDR),ZR(ISECH),INSTAN,
     +            ZI(IMATE),REPERE,OPTION,SIGTH)
C
C ---- CALCUL DU VECTEUR DES FORCES D'ORIGINE HYDRIQUE (BT*SIGTH)
C      ----------------------------------------------------------
      CALL BSIGMC(MODELI,NNO,NDIM,NBSIG,NPG1,ZR(IVF),ZR(IDFDE),
     +            ZR(IDFDK),BIDON,ZR(IPOIDS),ZR(IGEOM),NHARM,SIGTH,
     +            BSIGMA)
C
C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE AVEC LE
C ---- VECTEUR DES FORCES D'ORIGINE THERMIQUE
C      -------------------------------------
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      DO 30 I = 1, NDIM*NNO
         ZR(IVECTU+I-1) = BSIGMA(I)
 30   CONTINUE
C
C FIN ------------------------------------------------------------------
      END
