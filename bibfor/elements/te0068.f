      SUBROUTINE TE0068 ( OPTION , NOMTE )
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
C                          OPTION : 'CHAR_TH_FLUX_F (OU _R)'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      PARAMETER         ( NBRES=3 )
      CHARACTER*24       CARAC,FF
      CHARACTER*8        NOMPAR(NBRES),MATER,NOMRES(NBRES)
      CHARACTER*8        ELREFE
      CHARACTER*2        CODRET(NBRES)
      REAL*8             VALRES(NBRES),DFDX(9),DFDY(9),PSFN,NX,NY
      REAL*8             VALPAR(NBRES),POIDS,R,Z,FLUX,FLUXX,FLUXY,A,B
      REAL*8             COORSE(18),VECTT(9)
      INTEGER            NNO,KP,NPG,ICARAC,IFF,IPOIDS,IVF,IDFDE,IGEOM
      INTEGER            ITEMPS,IVECTT,K,I,L,LI,IFLU,IDFDK
      INTEGER            IMATE
      INTEGER            NNOP2,C(6,9),ISE,NSE
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
      CALL ELREF1(ELREFE)

      IF (NOMTE(1:6).NE.'THPLSE' .AND.
     &    NOMTE(1:6).NE.'THPLSL') THEN
         CALL UTMESS('F','TE0068','STOP 1')
      END IF
      IF (OPTION(11:16).EQ.'FLUX_R') THEN
         CALL UTMESS('F','TE0068','STOP 2')
      END IF
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO=ZI(ICARAC)
      NPG=ZI(ICARAC+2)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS=IFF
      IVF   =IPOIDS+NPG
      IDFDE =IVF   +NPG*NNO
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PFLUXVF','L',IFLU)
      CALL JEVECH('PVECTTR','E',IVECTT)
C
      CALL CONNEC ( NOMTE, ZR(IGEOM), NSE, NNOP2, C )

      DO 10 I=1,NNOP2
        VECTT(I)=0.D0
10    CONTINUE

C BOUCLE SUR LES SOUS-ELEMENTS

      DO 100 ISE=1,NSE

        DO 105 I=1,NNO
          DO 105 J=1,2
            COORSE(2*(I-1)+J) = ZR(IGEOM-1+2*(C(ISE,I)-1)+J)
105     CONTINUE

        DO 101 KP=1,NPG
          K = (KP-1)*NNO
          CALL VFF2DN (NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),COORSE,NX,NY,
     &                 POIDS)
          R = 0.D0
          Z = 0.D0
          DO 102 I=1,NNO
            L = (KP-1)*NNO+I
            R = R + COORSE(2*(I-1)+1) * ZR(IVF+L-1)
            Z = Z + COORSE(2*(I-1)+2) * ZR(IVF+L-1)
102       CONTINUE
C       IF ( NOMTE(3:4) .EQ. 'AX' ) POIDS = POIDS*R
C
          VALPAR(1) = R
          NOMPAR(1) = 'X'
          VALPAR(2) = Z
          NOMPAR(2) = 'Y'
          VALPAR(3) = ZR(ITEMPS)
          NOMPAR(3) = 'INST'
          CALL FOINTE('FM',ZK8(IFLU)  ,3,NOMPAR,VALPAR,FLUXX,ICODE)
          CALL FOINTE('FM',ZK8(IFLU+1),3,NOMPAR,VALPAR,FLUXY,ICODE)
C
C  PRODUIT  SCALAIRE   (FLUXV.NORMALE EXT)
C**
          PSFN=NX*FLUXX+NY*FLUXY
CCDIR$ IVDEP
          DO 103 I=1,NNO
            LI = IVF+(KP-1)*NNO+I-1
            VECTT(C(ISE,I)) = VECTT(C(ISE,I)) + POIDS* ZR(LI)* PSFN
103       CONTINUE
101     CONTINUE
100   CONTINUE

      DO 200 I=1,NNOP2
        ZR(IVECTT-1+I)=VECTT(I)
200   CONTINUE

      END
