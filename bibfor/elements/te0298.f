      SUBROUTINE TE0298 ( OPTION , NOMTE )
      IMPLICIT   NONE
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'SIGM_ELNO_LGDE_R'
C                                OU 'SIEF_ELGA_LGDE_R'
C                                OU 'SIGM_ELNO_LGDE_F'
C                                OU 'SIEF_ELGA_LGDE_F'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
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
      INTEGER            NNO,NNOS,KP,I,K,ITEMPE,ITREF,IDEPL,ICONT
      INTEGER            IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER            IDEFOR,ITHET,IALPH,IDEFI,IFORC
      INTEGER            IE1,IE2,IE3,IE4,NDIM,JGANO
      INTEGER            NPG,NCMP,MATER,NBRES
      PARAMETER          ( NBRES=3 )
C
      REAL*8             VALRES(NBRES),CONTPG(54)
      REAL*8             A1,A2,A3,ADET,THETX,THETY,VALPAR(2)
      REAL*8             DDZDZ,DDRXDZ,DDRYDZ,VX,VY,MT,S,JJ
      REAL*8             DFDX(9),DFDY(9),TPG,POIDS,X,Y,EPS(5),LA,DEMU
      REAL*8             EXX,EYY,EXY,EZZ,DIVT,DGRT,A11,A22,A12,A21,AAX
      REAL*8             DUDM(7),DTDM(7),DFDM(7),ALPHA,TGD(2)
C
      CHARACTER*8        NOMRES(NBRES),NOMPAR(2)
      CHARACTER*2        BL2, CODRET(NBRES)
C ......................................................................
C
      IF ( OPTION(6:9).EQ.'ELNO' ) THEN
        IF(NOMTE(5:7).EQ.'TR3' .OR. NOMTE(5:7).EQ.'QU4' ) THEN
          CALL ELREF4(' ','MASS',NDIM,NNO,NNOS,NPG,IPOIDS,
     &                     IVF,IDFDE,JGANO)
        ELSEIF (NOMTE(5:7).EQ.'TR6' .OR. NOMTE(5:7).EQ.'QU8' .OR.
     &        NOMTE(5:7).EQ.'QS8' .OR. NOMTE(5:7).EQ.'QU9' ) THEN
          CALL ELREF4(' ','NOEU_S',NDIM,NNO,NNOS,NPG,IPOIDS,
     &                     IVF,IDFDE,JGANO)
        ENDIF
      ELSE
        CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,
     &                   IVF,IDFDE,JGANO)
      ENDIF
C
      NCMP = 4
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      MATER=ZI(IMATE)
      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='ALPHA'
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PTEREF' ,'L',ITREF)
      CALL JEVECH('PCONTRR','E',ICONT)
      CALL JEVECH('PTHETAR','L',ITHET)
      CALL JEVECH('PALPHAR','L',IALPH)
C
      BL2 = '  '
      MATER=ZI(IMATE)
      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='ALPHA'
C
       IF(OPTION(16:16).EQ.'R') THEN
C RECUPERATION DES VALEURS DES DEFORMATIONS
         CALL JEVECH('PEPSINR','L',IDEFI)
         EXX=ZR(IDEFI)
         EYY=ZR(IDEFI+1)
         EXY=ZR(IDEFI+3)
         EZZ=ZR(IDEFI+2)
         ELSE
         CALL JEVECH('PEPSINF','L',IDEFI)
         NOMPAR(1)='X'
         NOMPAR(2)='Y'
       ENDIF
C
      IFORC = ITHET
      ALPHA = ZR(IALPH)
      DO 111 I=1,NCMP*NPG
        CONTPG(I) = 0.D0
111   CONTINUE
C
      DO 101 KP=1,NPG
        K=(KP-1)*NNO
        CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
        X   = 0.D0
        Y   = 0.D0
        TPG = 0.D0
        THETX = 0.D0
        THETY = 0.D0
        DO 102 I=1,NNO
           X   = X   + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
           Y   = Y   + ZR(IGEOM+2*I-1)*ZR(IVF+K+I-1)
           TPG = TPG + ZR(ITEMPE+I-1) *ZR(IVF+K+I-1)
         THETX = THETX + ZR(IVF+K+I-1)*ZR(ITHET + 2*(I-1))
         THETY = THETY + ZR(IVF+K+I-1)*ZR(ITHET + 2*(I-1) + 1)
102     CONTINUE
C
         IF(OPTION(16:16).EQ.'F') THEN
C RECUPERATION DES VALEURS DES DEFORMATIONS, TENANT COMPTE DU
C TRANSPORT.
          VALPAR(1)=X + ALPHA*THETX
          VALPAR(2)=Y + ALPHA*THETY
          CALL FOINTE('FM',ZK8(IDEFI  ),2,NOMPAR,VALPAR,EXX,IE1)
          CALL FOINTE('FM',ZK8(IDEFI+1),2,NOMPAR,VALPAR,EYY,IE2)
          CALL FOINTE('FM',ZK8(IDEFI+3),2,NOMPAR,VALPAR,EXY,IE3)
          CALL FOINTE('FM',ZK8(IDEFI+2),2,NOMPAR,VALPAR,EZZ,IE4)
          ENDIF
C
        CALL RCVALA(MATER,' ','ELAS',1,'TEMP',TPG,2,NOMRES,
     &                VALRES, CODRET, 'FM' )
        CALL RCVALA(MATER,' ','ELAS',1,'TEMP',TPG,1,NOMRES(3),
     &                VALRES(3), CODRET(3), BL2 )
        IF ( CODRET(3) .NE. 'OK' )  VALRES(3) = 0.D0
        TPG = TPG - ZR(ITREF)
C
        CALL GDFONC ( DFDX,DFDY,KP,ZR(IVF),ZR(IDEPL),ZR(ITHET),
     &                ZR(IFORC),ZR(ITEMPE),NNO,DUDM,DTDM,DFDM,TGD)
C
        DIVT   = DTDM(1) + DTDM(2)
        DGRT   = DTDM(1) * DTDM(2) - DTDM(3) * DTDM(5)
        ADET  = 1+ALPHA*DIVT+ALPHA*ALPHA*DGRT
C
C CAS AXISYMETRIQUE :
C
        IF ( NOMTE(3:4) .EQ. 'AX' ) THEN
C
C  R <> 0 :
C
           IF ( X .NE. 0.D0 ) THEN
           DUDM(4) = DUDM(4)/X
           DTDM(4) = DTDM(4)/X
           A1 = DTDM(1)+DTDM(2)+DTDM(4)
           A2 =DTDM(4)*(DTDM(1)+DTDM(2)) + DTDM(1)*DTDM(2)
     &          - DTDM(3)*DTDM(5)
           A3 = DTDM(4)*(DTDM(1)*DTDM(2)-DTDM(3)*DTDM(5))
C
           ADET = 1.D0+ ALPHA*A1 + ALPHA*ALPHA*A2 + (ALPHA**3)*A3
C
           A11=(1.D0+ALPHA*DTDM(4))*(1.D0+ALPHA*DTDM(2))
           A12=-ALPHA*DTDM(3)*(1.D0+ALPHA*DTDM(4))
           A21=-ALPHA*DTDM(5)*(1.D0+ALPHA*DTDM(4))
           A22=(1.D0+ALPHA*DTDM(1))*(1.D0+ALPHA*DTDM(4))
           AAX=( (1.D0+ALPHA*DTDM(1))*(1.D0+ALPHA*DTDM(2)) )
     +          -ALPHA*ALPHA*DTDM(3)*DTDM(5)
           EPS(1) = (DUDM(1)*A11 + DUDM(3)*A21)/ADET
           EPS(3) = DUDM(4)*AAX/ADET
           EPS(2) = (A12*DUDM(5) + A22*DUDM(2))/ADET
           EPS(4) = (A22*DUDM(3) + A12*DUDM(1))/ADET
           EPS(5) = (A21*DUDM(2) + A11*DUDM(5))/ADET
C EPSI - EPSI0 :
           EPS(1) = EPS(1) - EXX
           EPS(2) = EPS(2) - EYY
           EPS(4) = EPS(4) - EXY
           EPS(5) = EPS(5) - EXY
           ELSE
C
C R = 0 :
C
           DTDM(4) = DTDM(1)
           DUDM(4) = DUDM(1)
           A1 = DTDM(1)+DTDM(2)+DTDM(4)
           A2 =DTDM(4)*(DTDM(1)+DTDM(2)) + DTDM(1)*DTDM(2)
     &          - DTDM(3)*DTDM(5)
           A3 = DTDM(4)*(DTDM(1)*DTDM(2)-DTDM(3)*DTDM(5))
C
           ADET = 1.D0+ ALPHA*A1 + ALPHA*ALPHA*A2 + (ALPHA**3)*A3
C
           A11=(1.D0+ALPHA*DTDM(4))*(1.D0+ALPHA*DTDM(2))
           A12=-ALPHA*DTDM(3)*(1.D0+ALPHA*DTDM(4))
           A21=-ALPHA*DTDM(5)*(1.D0+ALPHA*DTDM(4))
           A22=(1.D0+ALPHA*DTDM(1))*(1.D0+ALPHA*DTDM(4))
           AAX=( (1.D0+ALPHA*DTDM(1))*(1.D0+ALPHA*DTDM(2)) )
     +          -ALPHA*ALPHA*DTDM(3)*DTDM(5)
           EPS(1) = (DUDM(1)*A11 + DUDM(3)*A21)/ADET
           EPS(3) = DUDM(4)*AAX/ADET
           EPS(2) = (A12*DUDM(5) + A22*DUDM(2))/ADET
           EPS(4) = (A22*DUDM(3) + A12*DUDM(1))/ADET
           EPS(5) = (A21*DUDM(2) + A11*DUDM(5))/ADET
C EPSI - EPSI0 :
           EPS(1) = EPS(1) - EXX
           EPS(2) = EPS(2) - EYY
           EPS(4) = EPS(4) - EXY
           EPS(5) = EPS(5) - EXY
           ENDIF
C
C CAS CONTRAINTE PLANE :
C
        ELSE IF (NOMTE(3:4) .EQ. 'CP' ) THEN
          A22=1.D0+ALPHA*DTDM(1)
          A11=1.D0+ALPHA*DTDM(2)
          A12=-ALPHA*DTDM(3)
          A21=-ALPHA*DTDM(5)
          EPS(1) = (DUDM(1)*A11 + DUDM(3)*A21)/ADET
          EPS(2) = (A12*DUDM(5) + A22*DUDM(2))/ADET
          EPS(4) = (A22*DUDM(3) + A12*DUDM(1))/ADET
          EPS(5) = (A21*DUDM(2) + A11*DUDM(5))/ADET
          EPS(3) = ( -VALRES(2) * (EPS(1)+EPS(2)) +
     &          (1.D0+VALRES(2)) *VALRES(3) *TPG) / (1.D0-VALRES(2))
          EPS(3) = EPS(3)/ADET
C EPSI - EPSI0 :
           EPS(1) = EPS(1) - EXX
           EPS(2) = EPS(2) - EYY
           EPS(4) = EPS(4) - EXY
           EPS(5) = EPS(5) - EXY
           EPS(3) = EPS(3) - EZZ
        ELSE
C
C CAS DEFORMATION PLANE :
C
          A22=1.D0+ALPHA*DTDM(1)
          A11=1.D0+ALPHA*DTDM(2)
          A12=-ALPHA*DTDM(3)
          A21=-ALPHA*DTDM(5)
          EPS(1) = (DUDM(1)*A11 + DUDM(3)*A21)/ADET
          EPS(2) = (A12*DUDM(5) + A22*DUDM(2))/ADET
          EPS(4) = (A22*DUDM(3) + A12*DUDM(1))/ADET
          EPS(5) = (A21*DUDM(2) + A11*DUDM(5))/ADET
C EPSI - EPSI0 :
          EPS(3) = - EZZ
          EPS(1) = EPS(1) - EXX
          EPS(2) = EPS(2) - EYY
          EPS(4) = EPS(4) - EXY
          EPS(5) = EPS(5) - EXY
        ENDIF
C
C CALCUL :
C
        LA=VALRES(1)*VALRES(2)/((1.D0-2.D0*VALRES(2))*(1.D0+VALRES(2)))
        DEMU   = VALRES(1)/(1.D0+VALRES(2))
        CONTPG(NCMP*(KP-1)+1) = (LA+DEMU)*EPS(1)+
     &               LA*(EPS(3)+EPS(2))-(3.D0*LA+DEMU)*VALRES(3)*TPG
        CONTPG(NCMP*(KP-1)+2) = (LA+DEMU)*EPS(2)+
     &               LA*(EPS(1)+EPS(3))-(3.D0*LA+DEMU)*VALRES(3)*TPG
        CONTPG(NCMP*(KP-1)+3) = (LA+DEMU)*EPS(3)+
     &               LA*(EPS(1)+EPS(2))-(3.D0*LA+DEMU)*VALRES(3)*TPG
        CONTPG(NCMP*(KP-1)+4) = DEMU*(EPS(4)+EPS(5))/2.D0
101   CONTINUE
C
      IF (OPTION(6:9).EQ.'ELGA') THEN
        DO 105 KP=1,NPG
          ZR(ICONT+NCMP*(KP-1) )  = CONTPG(NCMP*(KP-1)+1)
          ZR(ICONT+NCMP*(KP-1)+1) = CONTPG(NCMP*(KP-1)+2)
          ZR(ICONT+NCMP*(KP-1)+2) = CONTPG(NCMP*(KP-1)+3)
          ZR(ICONT+NCMP*(KP-1)+3) = CONTPG(NCMP*(KP-1)+4)
105     CONTINUE
C
      ELSE
C
        CALL PPGAN2(JGANO,NCMP,CONTPG,ZR(ICONT))
C
      ENDIF
      END
