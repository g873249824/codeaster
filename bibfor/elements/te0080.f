      SUBROUTINE TE0080 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/07/2009   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'CHAR_THER_SOUR_F'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      INTEGER            NDIM,NNO,NNOS,KP,NPG,I,K,ITEMPS,IVECTT,ISOUR
      INTEGER            IPOIDS,IVF,IDFDE,IGEOM,J,ICODE
      INTEGER            NNOP2,C(6,9),ISE,NSE,NBRES,JGANO,IBID
      PARAMETER         ( NBRES=3 )
      CHARACTER*8        NOMPAR(NBRES), ELREFE, ALIAS8
      REAL*8             VALPAR(NBRES),DFDX(9),DFDY(9),POIDS,R,Z,SOUR
      REAL*8             COORSE(18),VECTT(9),THETA,SOUN,SOUNP1
      LOGICAL            LTEATT
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
C
      IF ( LTEATT(' ','LUMPE','OUI')) THEN
         CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)
         IF(ALIAS8(6:8).EQ.'QU9')  ELREFE='QU4'
         IF(ALIAS8(6:8).EQ.'TR6')  ELREFE='TR3'
      ENDIF
C
      CALL ELREF4(ELREFE,'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,
     &            JGANO)
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PSOURCF','L',ISOUR)
      CALL JEVECH('PVECTTR','E',IVECTT)
      THETA = ZR(ITEMPS+2)
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'INST'
C
      CALL CONNEC ( NOMTE, NSE, NNOP2, C )
C
      DO 10 I=1,NNOP2
        VECTT(I)=0.D0
10    CONTINUE
C
C BOUCLE SUR LES SOUS-ELEMENTS
C
      DO 100 ISE=1,NSE
        DO 105 I=1,NNO
          DO 105 J=1,2
            COORSE(2*(I-1)+J) = ZR(IGEOM-1+2*(C(ISE,I)-1)+J)
105     CONTINUE
        DO 101 KP=1,NPG
          K=(KP-1)*NNO
          CALL DFDM2D ( NNO,KP,IPOIDS,IDFDE,COORSE,DFDX,DFDY,POIDS )
          R = 0.D0
          Z = 0.D0
          DO 102 I=1,NNO
            R = R + COORSE(2*(I-1)+1) * ZR(IVF+K+I-1)
            Z = Z + COORSE(2*(I-1)+2) * ZR(IVF+K+I-1)
102       CONTINUE
          IF ( LTEATT(' ','AXIS','OUI') ) POIDS = POIDS*R
          VALPAR(1) = R
          VALPAR(2) = Z
          VALPAR(3) = ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(ISOUR),3,NOMPAR,VALPAR,SOUNP1,ICODE)
          IF ( THETA .NE. 1.0D0 ) THEN
            VALPAR(3) = ZR(ITEMPS)-ZR(ITEMPS+1)
            CALL FOINTE('FM',ZK8(ISOUR),3,NOMPAR,VALPAR,SOUN,ICODE)
          ELSE
            SOUN = 0.D0
          ENDIF
          SOUR = THETA*SOUNP1 + (1.0D0-THETA)*SOUN
CDIR$ IVDEP
          DO 103 I=1,NNO
             K=(KP-1)*NNO
             VECTT(C(ISE,I)) = VECTT(C(ISE,I)) + POIDS
     &                      * ZR(IVF+K+I-1) * SOUR
103       CONTINUE
101     CONTINUE
100   CONTINUE
C
      DO 200 I=1,NNOP2
        ZR(IVECTT-1+I)=VECTT(I)
200   CONTINUE
C
      END
