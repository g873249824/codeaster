      SUBROUTINE TE0283(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/04/2002   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT NONE
      CHARACTER*16       NOMTE,OPTION
C ----------------------------------------------------------------------
C
C    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
C                          OPTION : 'RESI_RIGI_MASS'
C                          ELEMENTS 3D ISO PARAMETRIQUES
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C THERMIQUE NON LINEAIRE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*8        ELREFE
      CHARACTER*2        CODRET
      REAL*8             BETA,LAMBDA,THETA,DELTAT,KHI,TPG,TPGM
      REAL*8             DFDX(27),DFDY(27),DFDZ(27),POIDS,R8BID
      REAL*8             DTPGDX,DTPGDY,DTPGDZ,RBID
      INTEGER            IPOIDS,IVF,IDFDE,IDFDN,IDFDK,IGEOM,IMATE,NPG
      INTEGER            NNO,KP,NPG1,I,ITEMPS,IFON(3),K,L,NDIM,JIN,JVAL
      INTEGER            ICOMP,ITEMPI,ITEMPR,IVERES
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
C
C --- INDMAT : INDICE SAUVEGARDE POUR LE MATERIAU
C
CCC      PARAMETER        ( INDMAT = 8 )
C ----------------------------------------------------------------------
C
C DEB ------------------------------------------------------------------
      CALL ELREF1(ELREFE)
      CALL JEVETE('&INEL.'//ELREFE//'.CARACTE','L',JIN)
      NDIM = ZI(JIN+1-1)
      NNO  = ZI(JIN+2-1)
      NPG1 = ZI(JIN+3)
C
      CALL JEVETE('&INEL.'//ELREFE//'.FFORMES','L',JVAL)
      IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      IVF    = IPOIDS + NPG1
      IDFDE  = IVF    + NPG1*NNO
      IDFDN  = IDFDE  + 1
      IDFDK  = IDFDN  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PMATERC','L',IMATE )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PRESIDU','E',IVERES)
C
      DELTAT= ZR(ITEMPS+1)
      THETA = ZR(ITEMPS+2)
      KHI   = ZR(ITEMPS+3)
      CALL NTFCMA(ZI(IMATE),IFON)
C
      DO 101 KP=1,NPG1
        K = (KP-1)*NNO*3
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     &              ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS )
        TPG    = 0.D0
        DTPGDX = 0.D0
        DTPGDY = 0.D0
        DTPGDZ = 0.D0
        DO 102 I=1,NNO
          TPG    = TPG    + ZR(ITEMPI+I-1) * ZR(IVF+L+I-1)
          DTPGDX = DTPGDX + ZR(ITEMPI+I-1) * DFDX(I)
          DTPGDY = DTPGDY + ZR(ITEMPI+I-1) * DFDY(I)
          DTPGDZ = DTPGDZ + ZR(ITEMPI+I-1) * DFDZ(I)
102     CONTINUE
C
        CALL RCFODE (IFON(2),TPG ,LAMBDA,RBID)
C
          DO 105 I=1,NNO
             ZR(IVERES+I-1) = ZR(IVERES+I-1) + POIDS *
     &          THETA*LAMBDA*
     &         (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ)
105       CONTINUE
101   CONTINUE
C
      IF ((NOMTE(12:13).EQ.'_D'.OR.NOMTE(11:12).EQ.'_D').AND.
     +     NOMTE(6:10).NE.'PYRAM') THEN  
        NPG    = NNO       
        IVF    = JVAL
        IDFDE  = IVF    + NPG*NNO
        IDFDN  = IDFDE  + 1
        IDFDK  = IDFDN  + 1
        IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      ELSE
        NPG = NPG1
      ENDIF
C
      DO 201 KP=1,NPG
        K = (KP-1)*NNO*3
        L = (KP-1)*NNO
        TPG    = 0.D0
        DO 202 I=1,NNO
          TPG    = TPG    + ZR(ITEMPI+I-1) * ZR(IVF+L+I-1)
202     CONTINUE
C
        CALL RCFODE (IFON(1),TPG ,BETA , RBID)
C
          DO 205 I=1,NNO
             ZR(IVERES+I-1) = ZR(IVERES+I-1) + POIDS *
     &           BETA/DELTAT*KHI*ZR(IVF+L+I-1)
205       CONTINUE
201   CONTINUE
C FIN ------------------------------------------------------------------
      END
