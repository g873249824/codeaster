      SUBROUTINE TE0242 ( OPTION , NOMTE )
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
      IMPLICIT NONE
      CHARACTER*16        OPTION , NOMTE
C ----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'MTAN_RIGI_MASS'
C                          ELEMENTS 2D LUMPES
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C THERMIQUE NON LINEAIRE
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
      CHARACTER*24       CARAC,FF
      CHARACTER*8        ELREFE
      REAL*8             BETA0,LAMBDA,R8BID,RHOCP,DELTAT
      REAL*8             DFDX(9),DFDY(9),POIDS,R,THETA,KHI,TPGI
      REAL*8             MT(9,9),COORSE(18)
      INTEGER            NNO,KP,NPG1,NPG2,NPG3,I,J,IJ,K,ITEMPS,IFON(3)
      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM,IMATE
      INTEGER            ICOMP,ITEMPI,IMATTT
      INTEGER            C(6,9),ISE,NSE,NNOP2
C DEB ------------------------------------------------------------------
      CALL ELREF1(ELREFE)
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
      NPG2 = ZI(ICARAC+3)
      NPG3 = ZI(ICARAC+4)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
C
      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PMATERC','L',IMATE )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      IF ( (ZK16(ICOMP)(1:5).EQ.'SECH_')     .OR.
     &     (ZK16(ICOMP)(1:9).EQ.'THER_HYDR'))     THEN
        CALL UTMESS('F','TE0243','PAS D ELEMENTS LUMPES POUR'//
     &              'HYDRATATION ET SECHAGE')
      ENDIF
C
      DELTAT= ZR(ITEMPS+1)
      THETA = ZR(ITEMPS+2)
      KHI   = ZR(ITEMPS+3)

C     CALCUL LUMPE
C     ------------
C  CALCUL ISO-P2 : ELTS P2 DECOMPOSES EN SOUS-ELTS LINEAIRES

      CALL CONNEC ( NOMTE, ZR(IGEOM), NSE, NNOP2, C )

      DO 10 I=1,NNOP2
         DO 10 J=1,NNOP2
            MT(I,J)=0.D0
10    CONTINUE

C ----- TERME DE RIGIDITE : 2EME FAMILLE DE PTS DE GAUSS ---------

C BOUCLE SUR LES SOUS-ELEMENTS

      DO 200 ISE=1,NSE

        DO 205 I=1,NNO
          DO 205 J=1,2
              COORSE(2*(I-1)+J) = ZR(IGEOM-1+2*(C(ISE,I)-1)+J)
205     CONTINUE

        IPOIDS=IFF   +NPG1*(1+3*NNO)
        IVF   =IPOIDS+NPG2
        IDFDE =IVF   +NPG2*NNO
        IDFDK =IDFDE +NPG2*NNO

        CALL NTFCMA (ZI(IMATE),IFON)
        DO 101 KP=1,NPG2
          K=(KP-1)*NNO
          CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                  COORSE,DFDX,DFDY,POIDS )
          R      = 0.D0
          TPGI   = 0.D0
          DO 102 I=1,NNO
            R      = R      + COORSE(2*(I-1)+1)     * ZR(IVF+K+I-1)
            TPGI   = TPGI   + ZR(ITEMPI-1+C(ISE,I)) * ZR(IVF+K+I-1)
102       CONTINUE
          IF ( NOMTE(3:4) .EQ. 'AX' ) POIDS = POIDS*R
          CALL RCFODE (IFON(2),TPGI,LAMBDA,R8BID)
C
          IJ = IMATTT - 1
          DO 103 I=1,NNO
CDIR$ IVDEP
            DO 103 J=1,NNO
              IJ = IJ + 1
              MT(C(ISE,I),C(ISE,J)) = MT(C(ISE,I),C(ISE,J))+POIDS*
     &               LAMBDA*THETA*(DFDX(I)*DFDX(J)+DFDY(I)*DFDY(J))
103       CONTINUE
101     CONTINUE

C ------- TERME DE MASSE : 3EME FAMILLE DE PTS DE GAUSS -----------

        IPOIDS=IFF   +(NPG1+NPG2)*(1+3*NNO)
        IVF   =IPOIDS+NPG3
        IDFDE =IVF   +NPG3*NNO
        IDFDK =IDFDE +NPG3*NNO

        DO 405 I=1,NNO
          DO 405 J=1,2
             COORSE(2*(I-1)+J) = ZR(IGEOM-1+2*(C(ISE,I)-1)+J)
405     CONTINUE

        CALL NTFCMA (ZI(IMATE),IFON)
        DO 401 KP=1,NPG3
          K=(KP-1)*NNO
          CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                  COORSE,DFDX,DFDY,POIDS )
          R      = 0.D0
          TPGI   = 0.D0
          DO 402 I=1,NNO
            R      = R      + COORSE(2*(I-1)+1)     * ZR(IVF+K+I-1)
            TPGI   = TPGI   + ZR(ITEMPI-1+C(ISE,I)) * ZR(IVF+K+I-1)
402       CONTINUE
          IF ( NOMTE(3:4) .EQ. 'AX' ) POIDS = POIDS*R
          CALL RCFODE (IFON(1),TPGI,R8BID, RHOCP)
C
          IJ = IMATTT - 1
          DO 403 I=1,NNO
CDIR$ IVDEP
            DO 403 J=1,NNO
              IJ = IJ + 1
              MT(C(ISE,I),C(ISE,J)) = MT(C(ISE,I),C(ISE,J))+POIDS*
     &             KHI*RHOCP*ZR(IVF+K+I-1)*ZR(IVF+K+J-1)/DELTAT
403       CONTINUE
401     CONTINUE

200   CONTINUE

C MISE SOUS FORME DE VECTEUR
      IJ = IMATTT-1
      DO 406 I=1,NNOP2
         DO 406 J=1,I
           IJ = IJ +1
           ZR(IJ)=MT(I,J)
406   CONTINUE
C FIN ------------------------------------------------------------------
      END
