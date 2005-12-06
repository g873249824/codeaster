      SUBROUTINE TE0326(OPTION,NOMTE)
      IMPLICIT NONE

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
C...................................................................
C
C BUT: CALCUL DES VECTEURS ELEMENTAIRES POUR CALCULER LE 2 IEME MEMBRE
C                          DE LA
C FORMULATION VARIATIONNELLE PERMETTANT D'OBTENIR LE POTENTIEL  PHI2
C          DANS LA DECOMPOSITION DU POTENTIEL FLUCTUANT
C          ELEMENTS ISOPARAMETRIQUES 2D
C
C          OPTION : CHAR_THER_PHID_R
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C..................................................................
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
      CHARACTER*2        CODRET
      CHARACTER*16       NOMTE,OPTION
      REAL*8             JAC(9),NX(9),NY(9),NZ(9)
      REAL*8             SX(9,9),SY(9,9),SZ(9,9)
      REAL*8             NORM(3,9),R8B,RHO
      REAL*8             ACLOC(3,9),ACC(3,9),FLUFN(9)
      REAL*8             VIBAR(2,9), E1(3,9),E2(3,9)
      REAL*8             DIVSIG(9),XIN(9),COVA(3,3),METR(2,2),A(2,2)
      REAL*8             JC,CNVA(3,3),E1N(3,9),E2N(3,9)
      REAL*8             SAN(9),CAN(9),DXN(2)
      REAL*8             DXINDE(9),DXINDK(9)
      REAL*8             DFDE(9,9),DFDK(9,9),NXN(9),NYN(9),NZN(9)
      REAL*8             NORMN(3,9),J1N(9),J2N(9),VIBARN(2,9),GPHGXN(9)
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER            NDIM,NNO,IPG,NPG1,IVECTT,IMATE
      INTEGER            IDEC,JDEC,KDEC,LDEC
      INTEGER            I,J,K,IACCE,IDIM,II,INO,ITEMP,JNO,NNOS,JGANO
C-----------------------------------------------------------------------
C
C     CALCUL DES DERIVEES PREMIERES DES FONCTIONS DE FORME
C     POUR LES ELEMENTS QUAD4 ET QUAD8
C
      CALL ELREF4(' ','NOEU',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
      DO 111 II=1,NNO
         KDEC=(II-1)*NNO*NDIM
         DO 211 J=1,NNO
            IDEC=(J-1)*NDIM
            DFDE(J,II) = ZR(IDFDX+KDEC+IDEC)
            DFDK(J,II) = ZR(IDFDY+KDEC+IDEC)
 211     CONTINUE
 111  CONTINUE
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PACCELR','L',IACCE)
      CALL JEVECH('PTEMPER','L',ITEMP)
C
      CALL RCVALA(ZI(IMATE),' ','THER',0,' ',R8B,1,'RHO_CP',RHO,
     &              CODRET,'FM')
C
      DO 1200 I=1,NNO
         ACLOC(1,I)=0.0D0
         ACLOC(2,I)=0.0D0
         ACLOC(3,I)=0.0D0
1200  CONTINUE
      K=0
      DO 1201 I=1,NNO
         DO 20 IDIM=1,3
            K=K+1
            ACLOC(IDIM,I) = ZR(IACCE+K-1)
20       CONTINUE
1201  CONTINUE
      DO 1052 IPG=1,NPG1
         ACC(1,IPG)=0.0D0
         ACC(2,IPG)=0.0D0
         ACC(3,IPG)=0.0D0
1052  CONTINUE
      DO 1051 IPG=1,NPG1
         LDEC=(IPG-1)*NNO
         DO 105 I=1,NNO
           ACC(1,IPG) = ACC(1,IPG) + ACLOC(1,I)*ZR(IVF+LDEC+I-1)
           ACC(2,IPG) = ACC(2,IPG) + ACLOC(2,I)*ZR(IVF+LDEC+I-1)
           ACC(3,IPG) = ACC(3,IPG) + ACLOC(3,I)*ZR(IVF+LDEC+I-1)
105      CONTINUE
1051  CONTINUE
C
      DO 11 I = 1,NNO
         ZR(IVECTT+I-1) = 0.D0
11    CONTINUE
C
C --- CALCUL DES VECTEURS E1, E2 TANGENTS A L'ELEMENT NON NORMALISES
C     ET DES VECTEURS UNITAIRES NORMES
C
      DO 90 IPG=1,NPG1
         KDEC=(IPG-1)*NNO*NDIM

         E1(1,IPG)=0.0D0
         E1(2,IPG)=0.0D0
         E1(3,IPG)=0.0D0

         E2(1,IPG)=0.0D0
         E2(2,IPG)=0.0D0
         E2(3,IPG)=0.0D0

         DO 91 J=1,NNO
            IDEC=(J-1)*NDIM

            E1(1,IPG)= E1(1,IPG)+ZR(IGEOM + 3*(J-1) -1+1)
     &                *ZR(IDFDX+KDEC+IDEC)
            E1(2,IPG)= E1(2,IPG)+ZR( IGEOM + 3*(J-1) -1+2)
     &                *ZR(IDFDX+KDEC+IDEC)
            E1(3,IPG)= E1(3,IPG)+ZR( IGEOM + 3*(J-1) -1+3)
     &                *ZR(IDFDX+KDEC+IDEC)

            E2(1,IPG)= E2(1,IPG)+ZR( IGEOM + 3*(J-1) -1+1)
     &                *ZR(IDFDY+KDEC+IDEC)
            E2(2,IPG)=E2(2,IPG)+ZR( IGEOM + 3*(J-1) -1+2)
     &                *ZR(IDFDY+KDEC+IDEC)
            E2(3,IPG)=E2(3,IPG)+ZR( IGEOM + 3*(J-1) -1+3)
     &                         *ZR(IDFDY+KDEC+IDEC)
 91      CONTINUE
 90   CONTINUE
C
C --- CALCUL DES PRODUITS VECTORIELS OMI X OMJ
C
      DO 21 INO = 1,NNO
         I = IGEOM + 3*(INO-1) -1
         DO 22 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
            SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
            SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
            SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
22       CONTINUE
21    CONTINUE
C
C --- BOUCLE SUR LES POINTS DE GAUSS

      DO 101 IPG=1,NPG1

         KDEC=(IPG-1)*NNO*NDIM
         LDEC=(IPG-1)*NNO

         NX(IPG) = 0.0D0
         NY(IPG) = 0.0D0
         NZ(IPG) = 0.0D0

         DO 102 I=1,NNO
            IDEC = (I-1)*NDIM
            DO 104 J=1,NNO
               JDEC = (J-1)*NDIM

               NX(IPG) = NX(IPG) + ZR(IDFDX+KDEC+IDEC)
     &                           * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
               NY(IPG) = NY(IPG) + ZR(IDFDX+KDEC+IDEC)
     &                           * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
               NZ(IPG) = NZ(IPG) + ZR(IDFDX+KDEC+IDEC)
     &                           * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
104         CONTINUE
102      CONTINUE

C ------ CALCUL DU JACOBIEN AU POINT DE GAUSS IPG

         JAC(IPG) = SQRT (NX(IPG)*NX(IPG) + NY(IPG)*NY(IPG)
     &            + NZ(IPG)*NZ(IPG))

C ------ CALCUL DE LA NORMALE UNITAIRE

         NORM(1,IPG) = NX(IPG)/JAC(IPG)
         NORM(2,IPG) = NY(IPG)/JAC(IPG)
         NORM(3,IPG) = NZ(IPG)/JAC(IPG)

101   CONTINUE

C --- CALCUL DU PRODUIT (XI.N) AUX NOEUDS

      CALL E1E2NN(NNO,DFDE,DFDK,E1N,E2N,NXN,NYN,NZN,NORMN,J1N,J2N,
     &             SAN,CAN)

      DO 200 I=1,NNO
         XIN(I)=ACLOC(1,I)*NORMN(1,I) + ACLOC(2,I)*NORMN(2,I)
     &                                + ACLOC(3,I)*NORMN(3,I)
200   CONTINUE

      DO 202 IPG=1,NPG1

C CALCUL DES DERIVEES DES (XIN) (GRADSIGMA(XI.N)) AUX POINTS DE GAUSS

         DXINDE(IPG)=0.0D0
         DXINDK(IPG)=0.0D0

         KDEC=(IPG-1)*NNO*NDIM
         DO 203 I=1,NNO
            IDEC=(I-1)*NDIM
            DXINDE(IPG)=DXINDE(IPG)+ZR(IDFDX+KDEC+IDEC)*XIN(I)
            DXINDK(IPG)=DXINDK(IPG)+ZR(IDFDY+KDEC+IDEC)*XIN(I)
203      CONTINUE

         DXN(1) = DXINDE(IPG)
         DXN(2) = DXINDK(IPG)

         VIBAR(1,IPG) = 0.0D0
         VIBAR(2,IPG) = 0.0D0

C ------ CALCUL DE GRAD(PHIBARRE):VITESSE FLUIDE PERMANENTE
C        VIBAR  AUX POINTS DE GAUSS

         DO 108 I=1,NNO
            IDEC=(I-1)*NDIM
            VIBAR(1,IPG)=VIBAR(1,IPG)+ZR(ITEMP+I-1)*ZR(IDFDX+KDEC+IDEC)
            VIBAR(2,IPG)=VIBAR(2,IPG)+ZR(ITEMP+I-1)*ZR(IDFDY+KDEC+IDEC)
 108     CONTINUE
C
C ------ CONSTITUTION DE LA BASE DES DEUX VECTEURS COVARIANTS
C        AUX POINTS DE GAUSS

         DO 204 I=1,3
            COVA(I,1)=E1(I,IPG)
            COVA(I,2)=E2(I,IPG)
204      CONTINUE

C ------ ON CALCULE LE TENSEUR METRIQUE

         CALL SUMETR(COVA,METR,JC)

C ------ CALCUL DE LA BASE CONTRAVARIANTE

         CALL SUBACV(COVA,METR,JC,CNVA,A)

C ------ CALCUL DU PRODUIT SCALAIRE GRAD(POTENTIEL PERMANENT)*
C        GRAD(DEPLACEMENT NORMAL) RELATIVEMENT A LA BASE CONTRAVARIANTE

         GPHGXN(IPG) = 0.D0
         DO 205 I=1,2
            DO 206 J=1,2
               GPHGXN(IPG) = GPHGXN(IPG) + A(I,J)*VIBAR(I,IPG)*DXN(J)
206         CONTINUE
205      CONTINUE

202   CONTINUE


C --- CALCUL DE LA DIVSIGMA(GRAD(PHIBAR)) AUX POINTS DE GAUSS

      CALL DIVGRA(E1,E2,DFDE,DFDK,VIBARN,DIVSIG)

C --- CALCUL DU FLUX FLUIDE NORMAL AUX POINTS DE GAUSS

      DO 1070 IPG=1,NPG1
         FLUFN(IPG) = 0.0D0
         FLUFN(IPG) = ACC(1,IPG)*NORM(1,IPG)+ACC(2,IPG)*NORM(2,IPG)
     &                                      +ACC(3,IPG)*NORM(3,IPG)
1070  CONTINUE

C --- CALCUL DU VECTEUR ASSEMBLE SECOND MEMBRE
C     POUR LE CALCUL DU SECOND POTENTIEL INSTATIONNAIRE PHI2

      DO 61 IPG=1,NPG1
         LDEC=(IPG-1)*NNO
         DO 103 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) 
     &                       + RHO*JAC(IPG)*ZR(IPOIDS+IPG-1)
     &                         *ZR(IVF+LDEC+I-1)
     &                         *(FLUFN(IPG)*DIVSIG(IPG) + GPHGXN(IPG))

103      CONTINUE
61    CONTINUE

      END
