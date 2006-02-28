      SUBROUTINE XADHER(P,SAUT,LAMB1,RHOTK,
     &                            PBOUL,KN,PTKNP,IK)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/02/2006   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE
      REAL*8    P(3,3),SAUT(3),LAMB1(3),RHOTK,PBOUL(3)
      REAL*8    PTKNP(3,3),IK(3,3),KN(3,3)
          
C ----------------------------------------------------------------------
C                      TEST DE L'ADH�RENCE AVEC X-FEM 
C                ET CALCUL DES MATRICES DE FROTTEMENT UTILES

C IN    P           : OP�RATEUR DE PROJECTION 
C IN    SAUT        : SAUT DES INCR�MENTS DE D�PLACEMENTS 
C                     DEPUIS L'�QUILIBRE PR�C�DENT
C IN    LAMB1       : INCR�MENTS DU SEMI-MULTIPLICATEUR DE FROTTEMENT
C                     DEPUIS L'�QUILIBRE PR�C�DENT DANS LA BASE GLOBALE
C IN    RHOTK       : COEFFICIENT DE REGULARISATION DE FROTTEMENT 
C                       DIVIS� PAR L'INCR�MENT DE TEMPS 

C OUT   PBOUL       : PROJECTION SUR LA BOULE B(0,1)
C OUT   KN          : KN(LAMDBA + RHO [[DX]]/DELTAT )
C OUT   PTKNP       : MATRICE Pt.KN.P
C OUT   PTKNP       : MATRICE Id-KN

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL,EXIGEO
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)


C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER    NDIM,I,J,K,IBID
      REAL*8     VITANG(3),PREC,NORME,XAB(3,3),KNP(3,3),GT(3)
      REAL*8     THETA,XIK(3,2),P2(2,2),PTKNP2(2,2),KN2(2,2),XAB2(2,2)
      PARAMETER  (PREC=1.D-12)
      LOGICAL    ADHER

C-----------------------------------------------------------------------
C     CALCUL DE GT = LAMDBA + RHO [[DX]]/DELTAT ET DE SA PROJECTION

      CALL ELREF4(' ','RIGI',NDIM,IBID,IBID,IBID,IBID,IBID,IBID,IBID)

      DO 10 I=1,NDIM
        VITANG(I)=0.D0
C       "VITESSE TANGENTE" : PROJECTION DU SAUT
        DO 20  K=1,NDIM
          VITANG(I)=VITANG(I)+P(I,K)*SAUT(K)
 20     CONTINUE
        GT(I)=LAMB1(I)+RHOTK*VITANG(I)
 10   CONTINUE

C      WRITE(6,*)'GT ',GT
      IF (NDIM.EQ.3) THEN
        NORME=SQRT(GT(1)*GT(1)+GT(2)*GT(2)+GT(3)*GT(3))
      ELSE
        NORME=SQRT(GT(1)*GT(1)+GT(2)*GT(2))
      ENDIF
C      write(6,*)'norme GT ',NORME

C     ADHER : TRUE SI ADH�RENCE, FALSE SI GLISSEMENT      
      IF (NORME.LE.(1.D0+PREC)) THEN
        ADHER = .TRUE.
        DO 21 J=1,NDIM
          PBOUL(J)=GT(J)
 21   CONTINUE
      ELSE  
        ADHER = .FALSE.
        DO 22 J=1,NDIM
          PBOUL(J)=GT(J)/NORME
 22   CONTINUE
      ENDIF

C      write(6,*)'Adherence ? ',ADHER

C-----------------------------------------------------------------------
C     CALCUL DE KN(LAMDBA + RHO [[DX]]/DELTAT )

C     ADHERENCE
      IF (ADHER) THEN

        CALL MATINI(NDIM,NDIM,0.D0,KN)
        DO 30 I=1,NDIM
          KN(I,I)=1.D0
 30     CONTINUE

C     GLISSEMENT
      ELSEIF (.NOT.ADHER) THEN

        THETA=1.D0
        DO 40 I = 1,NDIM
          DO 41 J = 1,NDIM
            KN(I,J)=-THETA*GT(I)*GT(J)/(NORME*NORME)
 41       CONTINUE
 40     CONTINUE

        DO 42 I = 1,NDIM
          KN(I,I)= KN(I,I) + 1.D0
 42     CONTINUE

        DO 421 I = 1,NDIM
          DO 422 J = 1,NDIM
            KN(I,J)= KN(I,J)/NORME
 422      CONTINUE
 421    CONTINUE

      ENDIF

C-----------------------------------------------------------------------

C     CALCUL DE PT.KN.P
      IF (NDIM.EQ.3) THEN
        CALL UTBTAB('ZERO',NDIM,NDIM,KN,P,XAB,PTKNP)
      ELSE
        DO 43 I=1,NDIM
          DO 44 J=1,NDIM
            P2(I,J)=P(I,J)
            KN2(I,J)=KN(I,J)
 44       CONTINUE
 43     CONTINUE
        CALL UTBTAB('ZERO',NDIM,NDIM,KN2,P2,XAB2,PTKNP2)
        DO 45 I=1,NDIM
          DO 46 J=1,NDIM
            PTKNP(I,J)=PTKNP2(I,J)
 46       CONTINUE
 45     CONTINUE
      ENDIF
      
C     CALCUL DE Id-KN
      DO 50 I = 1,NDIM
        DO 51 J = 1,NDIM
          IK(I,J)= -1.D0 * KN(I,J)
 51     CONTINUE
 50   CONTINUE
      DO 52 I = 1,NDIM
        IK(I,I)= 1.D0 + IK(I,I)
 52   CONTINUE
      
C-----------------------------------------------------------------------

      END
