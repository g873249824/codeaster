      SUBROUTINE TE0363 ( OPTION , NOMTE)
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
C----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DES FORCES NODALES
C                          ELEMENTS DE CONTACT-FROTTEMENT 2D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16       OPTION , NOMTE
      CHARACTER*8        ELREFE
      CHARACTER*24       CARAC,FF
      REAL*8             DFDL(2,12),POIDS,YB,JAC
      REAL*8             NU(12),NOR(2),VFFAUX(6)
      REAL*8             VECTOT(12),COEF
      INTEGER            NNO,KP,NPG1,IVECTU,NDDL,IVF,ICONTM
      INTEGER            ICARAC,IFF,IPOIDS,IDFDE,IGEOM
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
C---------- DECLARATION DES ELREFE -------------------------------------
C
      CALL ELREF1(ELREFE)
C
C
C----------------------------------------------------------------------
C
C --- FONCTIONS DE FORMES ET POINTS DE GAUSS
      CARAC = '&INEL.'//ELREFE//'.CARACON'
      CALL JEVETE(CARAC,'L',ICARAC)
      NDIM  = ZI(ICARAC)
      NNO   = ZI(ICARAC+1)
C     NBFPG = ZI(ICARAC+2)
      NPG1  = ZI(ICARAC+3)
      FF    = '&INEL.'//ELREFE//'.FORMESF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS = IFF + (NDIM+1)*NNO*NNO
      IVF    = IPOIDS + NPG1
      IDFDE  = IVF    + NPG1*NNO
C
C     PARAMETRES EN ENTREE
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTMR','L',ICONTM)
C
C     PARAMETRES EN SORTIE
C
      CALL JEVECH('PVECTUR','E',IVECTU)
C
C     RECUPERATION DU MATERIAU DE L ELEMENT DE CONTACT
C
      NDDL=NDIM*NNO
      DO 700 IDDL=1,NDDL
        VECTOT(IDDL)=0.0D0
        NU(IDDL)    =0.0D0
700   CONTINUE
C
      YB = -1.0D0
      DO 101 KP=1,NPG1
        K     = (KP-1)*NDDL
        IDIFF = IVF+(KP-1)*NNO
        ISIGN = ICONTM+(KP-1)*(NDIM+1)
        ISIGT = ISIGN+1
C
        CALL CODFDM ( NNO,ZR(IDIFF),VFFAUX,ZR(IPOIDS+KP-1),
     &  ZR(IDFDE+K),DFDL,POIDS,NDIM )

        CALL COBLOC(NNO,DFDL,ZR(IGEOM),NU,NOR,NDIM)

        CALL COJACB(ZR(IGEOM),DFDL,YB,JAC,NNO,NDDL,NU,NDIM)
        COEF=JAC*POIDS
        CALL COCVEC(NOR,VFFAUX,NNO,NDDL,ZR(ISIGN),
     &                                      ZR(ISIGT),VECTOT,COEF,NDIM)

101   CONTINUE
C
      CALL R8COPY(NDDL ,VECTOT,1,ZR(IVECTU),1)

      END
