      SUBROUTINE TE0131(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2004   AUTEUR CIBHHLV L.VIVAN 
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
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     BUT: CALCUL DES MATRICES TANGENTES ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU TERME D'ECHANGE
C          (LE COEFFICIENT D'ECHANGE EST UNE FONCTION DU TEMPS ET DE
C           L'ESPACE)
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'MTAN_THER_COEF_F'
C          OPTION : 'MTAN_THER_RAYO_F'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      CHARACTER*8        ELREFE,NOMPAR(4)
      CHARACTER*16       NOMTE,OPTION
      CHARACTER*24       CHVAL,CHCTE
      REAL*8             NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC,THETA
      REAL*8             VALPAR(4),ECHAN,XX,YY,ZZ
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER            IER,NDIM,NNO,NDI,IPG,NPG1,NPG2,IMATTT,IECH
      INTEGER            IRAY,ITEMP,NNOS,JGANO
      INTEGER            IDEC,JDEC,KDEC,LDEC
      INTEGER            NBPG(10)
      REAL*8             SIGMA,EPSIL,TPG,TZ0,R8T0
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C -----------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      TZ0  = R8T0()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG2,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
      NDI = NNO*(NNO+1)/2
C
      IF     (OPTION(11:14).EQ.'COEF') THEN
         CALL JEVECH('PCOEFHF','L',IECH)
      ELSEIF (OPTION(11:14).EQ.'RAYO') THEN
         CALL JEVECH('PRAYONF','L',IRAY)
         CALL JEVECH('PTEMPEI','L',ITEMP)
      ENDIF
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      THETA     = ZR(ITEMPS+2)
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
      NOMPAR(4) = 'INST'
C
      DO 10 I = 1,NDI
         ZR(IMATTT+I-1) = 0.0D0
10    CONTINUE
C
C    CALCUL DES PRODUITS VECTORIELS OMI X OMJ
C
      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
          DO 2 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
              SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
              SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
              SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
2         CONTINUE
1     CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 IPG=1,NPG2
        KDEC = (IPG-1)*NNO*NDIM
        LDEC = (IPG-1)*NNO
C
        NX = 0.0D0
        NY = 0.0D0
        NZ = 0.0D0
        DO 12 I=1,NNO
        IDEC = (I-1)*NDIM
          DO 12 J=1,NNO
          JDEC = (J-1)*NDIM
          NX = NX + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
          NY = NY + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
          NZ = NZ + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
12     CONTINUE
        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
C
        XX = 0.D0
        YY = 0.D0
        ZZ = 0.D0
        DO 102 I = 1,NNO
           XX = XX + ZR(IGEOM+3*I-3) * ZR(IVF+LDEC+I-1)
           YY = YY + ZR(IGEOM+3*I-2) * ZR(IVF+LDEC+I-1)
           ZZ = ZZ + ZR(IGEOM+3*I-1) * ZR(IVF+LDEC+I-1)
 102    CONTINUE
        VALPAR(1) = XX
        VALPAR(2) = YY
        VALPAR(3) = ZZ
        VALPAR(4) = ZR(ITEMPS)
        IF     (OPTION(11:14).EQ.'COEF') THEN
          CALL FOINTE('A',ZK8(IECH),4,NOMPAR,VALPAR,ECHAN,IER)
          IF (IER.NE.0) THEN
          CALL UTMESS('F','TE0131','ERREUR DANS LE CALCUL DE COEF_F')
          ENDIF
C
          DO 103 I=1,NNO
CCDIR$ IVDEP
            DO 104 J=1,I
            IJ = (I-1)*I/2 + J
C
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) + JAC * THETA *
     &      ZR(IPOIDS+IPG-1) * ECHAN *
     &      ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1)
C
104         CONTINUE
103       CONTINUE
        ELSEIF (OPTION(11:14).EQ.'RAYO') THEN
           CALL FOINTE('A',ZK8(IRAY),4,NOMPAR,VALPAR,SIGMA,IER)
           IF ( IER .NE. 0 ) THEN
             CALL UTMESS('F','TE0131',
     &                       'ERREUR LORS DE L APPEL A FOINTE')
           ENDIF
           CALL FOINTE('A',ZK8(IRAY+1),4,NOMPAR,VALPAR,EPSIL,IER)
           IF ( IER .NE. 0 ) THEN
             CALL UTMESS('F','TE0131',
     &                       'ERREUR LORS DE L APPEL A FOINTE')
           ENDIF
C
           TPG = 0.D0
           DO 105 I=1,NNO
             TPG = TPG + ZR(ITEMP+I-1) * ZR(IVF+LDEC+I-1)
105        CONTINUE
           DO 106 I=1,NNO
CCDIR$ IVDEP
            DO 107 J=1,I
            IJ = (I-1)*I/2 + J
C
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) + JAC * THETA *
     &      ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1) * ZR(IPOIDS+IPG-1) *
     &      SIGMA * EPSIL * 4.D0 * (TPG+TZ0)**3
C
107         CONTINUE
106        CONTINUE
        ENDIF
C
101     CONTINUE
      END
