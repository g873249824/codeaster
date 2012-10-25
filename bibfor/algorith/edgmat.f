      SUBROUTINE EDGMAT (FAMI,KPG,KSP,IMAT,C1,ZALPHA,TEMP,DT,MUM,MU,
     &                   TROIKM,TROISK,ALPHAM,ALPHAP,ANI,M,N,GAMMA)

      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/10/2012   AUTEUR CHANSARD F.CHANSARD 

      INTEGER         KPG,KSP,IMAT
      REAL*8          ZALPHA,TEMP,DT
      REAL*8          MUM,MU,TROIKM,TROISK,ALPHAM,ALPHAP,ANI(6,6)
      REAL*8          M(3),N(3),GAMMA(3)
      CHARACTER*(*)   FAMI
      CHARACTER*1    C1

C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C ----------------------------------------------------------------------
C    MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
C    RECUPERATION DES CARACTERISTIQUES MATERIAUX
C  IN  FAMI :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C  IN  KPG  :  NUMERO DU POINT DE GAUSS
C  IN  KSP  :  NUMERO DU SOUS-POINT DE GAUSS
C  IN  IMAT :  ADRESSE DU MATERIAU CODE
C  IN  C1   :  VAUT '-' SI RIGI VAUT '+' SINON

C  OUT MUM    : COEFFICIENT DE L ELASTICITE A L INSTANT MOINS
C  OUT MU     : COEFFICIENT DE L ELASTICITE A L INSTANT COURANT
C  OUT TROIKM : COEFFICIENT DE L ELASTICITE A L INSTANT MOINS
C  OUT TROISK : COEFFICIENT DE L ELASTICITE A L INSTANT COURANT
C  OUT ALPHAM : DILATATION THERMIQUE A L INSTANT MOINS
C  OUT ALPHAP : DILATATION THERMIQUE A L INSTANT COURANT
C  OUT ANI    : MATRICE D ANISOTROPIE DE HILL
C  OUT M, N ET GAMMA : COEFFICIENT DE VISCOSITE A L INSTANT COURANT
C ----------------------------------------------------------------------
     
      INTEGER        I,J,K
      REAL*8         VALRES(27),A(3),Q(3),FMEL(3)
      REAL*8         M11(2),M22(2),M33(2),M44(2),M55(2),M66(2)
      REAL*8         M12(2),M13(2),M23(2)
      CHARACTER*2   CODRET(27)
      CHARACTER*8   NOMC(27)
      
C 1 - CARACTERISTIQUES ELASTIQUES
C     YOUNG ET NU OBLIGATOIRES
C     ALPHA FACULTATIFS 

      NOMC(1) = 'E       '
      NOMC(2) = 'NU      '
      NOMC(3) = 'F_ALPHA '

      CALL RCVALB(FAMI,KPG,KSP,'-',IMAT,' ','ELAS_META',0,' ',0.D0,
     &            2,NOMC,VALRES,CODRET,'F ')
      MUM = VALRES(1)/(2.D0*(1.D0+VALRES(2)))
      TROIKM = VALRES(1)/(1.D0-2.D0*VALRES(2))
      
      CALL RCVALB(FAMI,KPG,KSP,C1,IMAT,' ','ELAS_META',0,' ',0.D0,
     1            2,NOMC,VALRES,CODRET,'F ')
      MU = VALRES(1)/(2.D0*(1.D0+VALRES(2)))
      TROISK = VALRES(1)/(1.D0-2.D0*VALRES(2))
      
      CALL RCVALB(FAMI,KPG,KSP,'-',IMAT,' ','ELAS_META',0,' ',0.D0,
     &            1,NOMC(3),ALPHAM,CODRET(3),'F ')      
      
      CALL RCVALB(FAMI,KPG,KSP,C1,IMAT,' ','ELAS_META',0,' ',0.D0,
     1            1,NOMC(3),ALPHAP,CODRET(3),'F ')

C 2 - MATRICE D ANISOTROPIE      
C 2.1 - DONNEES UTILISATEUR - UNIQUEMENT LA PHASE FROIDE ET CHAUDE      
C       PHASE FROIDE => INDICE 1
C       PHASE CHAUDE => INDICE 2

        NOMC(16)= 'F_MRR_RR'
        NOMC(17)= 'C_MRR_RR'
        NOMC(18)= 'F_MTT_TT'
        NOMC(19)= 'C_MTT_TT'
        NOMC(20)= 'F_MZZ_ZZ'
        NOMC(21)= 'C_MZZ_ZZ'
        NOMC(22)= 'F_MRT_RT'
        NOMC(23)= 'C_MRT_RT'
        NOMC(24)= 'F_MRZ_RZ'
        NOMC(25)= 'C_MRZ_RZ'
        NOMC(26)= 'F_MTZ_TZ'
        NOMC(27)= 'C_MTZ_TZ'

        CALL RCVALB(FAMI,KPG,KSP,C1,IMAT,' ','META_LEMA_ANI',0,' ',
     1              0.D0,12,NOMC(16),VALRES(16),CODRET(16) , 'F ')

        M11(1)=VALRES(16)
        M22(1)=VALRES(18)
        M33(1)=VALRES(20)
        M44(1)=VALRES(22)
        M55(1)=VALRES(24)
        M66(1)=VALRES(26)
      
        M11(2)=VALRES(17)
        M22(2)=VALRES(19)
        M33(2)=VALRES(21)
        M44(2)=VALRES(23)
        M55(2)=VALRES(25)
        M66(2)=VALRES(27)

C 2.2 - ON COMPLETE LA MATRICE MIJ(1) ET MIJ(2)
      
        DO 5 K=1,2
          M12(K)=(-M11(K)-M22(K)+M33(K))/2.D0 
          M13(K)=(-M11(K)+M22(K)-M33(K))/2.D0 
          M23(K)=( M11(K)-M22(K)-M33(K))/2.D0 
 5      CONTINUE
       
C 2.3 - ON CONSTRUIT ANI(I,J) SUIVANT LE % DE PHASE FROIDE
C SI 0   <ZALPHA<0.01 => ANI(I,J)=MIJ(2)
C SI 0.01<ZALPHA<0.99 => ANI(I,J)=ZALPHA*MIJ(1)+(1-ZALPHA)*MIJ(2)
C SI 0.99<ZALPHA<1    => ANI(I,J)=MIJ(1)      
      
        DO 10 I=1,6
          DO 15 J=1,6
            ANI(I,J)=0.D0
 15       CONTINUE
 10     CONTINUE
 
        IF (ZALPHA.LE.0.01D0) THEN      
          ANI(1,1)=M11(2)
          ANI(2,2)=M22(2)
          ANI(3,3)=M33(2)
          ANI(1,2)=M12(2)
          ANI(2,1)=M12(2)
          ANI(1,3)=M13(2)
          ANI(3,1)=M13(2)
          ANI(2,3)=M23(2)
          ANI(3,2)=M23(2)
          ANI(4,4)=M44(2)
          ANI(5,5)=M55(2)
          ANI(6,6)=M66(2)
        ENDIF

        IF ((ZALPHA.GT.0.01D0).AND.(ZALPHA.LE.0.99D0)) THEN
          ANI(1,1)=ZALPHA*M11(1)+(1.D0-ZALPHA)*M11(2)
          ANI(2,2)=ZALPHA*M22(1)+(1.D0-ZALPHA)*M22(2)
          ANI(3,3)=ZALPHA*M33(1)+(1.D0-ZALPHA)*M33(2)
          ANI(1,2)=ZALPHA*M12(1)+(1.D0-ZALPHA)*M12(2)
          ANI(2,1)=ANI(1,2)
          ANI(1,3)=ZALPHA*M13(1)+(1.D0-ZALPHA)*M13(2)
          ANI(3,1)=ANI(1,3)
          ANI(2,3)=ZALPHA*M23(1)+(1.D0-ZALPHA)*M23(2)
          ANI(3,2)=ANI(2,3)
          ANI(4,4)=ZALPHA*M44(1)+(1.D0-ZALPHA)*M44(2)
          ANI(5,5)=ZALPHA*M55(1)+(1.D0-ZALPHA)*M55(2)
          ANI(6,6)=ZALPHA*M66(1)+(1.D0-ZALPHA)*M66(2)
        ENDIF

        IF (ZALPHA.GT.0.99D0) THEN
          ANI(1,1)=M11(1)
          ANI(2,2)=M22(1)
          ANI(3,3)=M33(1)
          ANI(1,2)=M12(1)
          ANI(2,1)=M12(1)
          ANI(1,3)=M13(1)
          ANI(3,1)=M13(1)
          ANI(2,3)=M23(1)
          ANI(3,2)=M23(1)
          ANI(4,4)=M44(1)
          ANI(5,5)=M55(1)
          ANI(6,6)=M66(1)
        ENDIF            

C 3 - CARACTERISTIQUES PLASTIQUES
C 3.1 - DONNEES UTILISATEUR

        NOMC(4) = 'F1_A    '
        NOMC(5) = 'F2_A    '
        NOMC(6) = 'C_A     '
        NOMC(7) = 'F1_M    '
        NOMC(8) = 'F2_M    '
        NOMC(9) = 'C_M     '
        NOMC(10)= 'F1_N    '
        NOMC(11)= 'F2_N    '
        NOMC(12)= 'C_N     '
        NOMC(13)= 'F1_Q    '
        NOMC(14)= 'F2_Q    '
        NOMC(15)= 'C_Q     '

        CALL RCVALB(FAMI,KPG,KSP,C1,IMAT,' ','META_LEMA_ANI',0,' ',
     1              0.D0,12,NOMC(4),VALRES(4),CODRET(4) , 'F ')
      
        DO 20 K=1,3
          A(K)=VALRES(4+K-1)
          M(K)=VALRES(7+K-1)
          N(K)=1.D0/VALRES(10+K-1)
          Q(K)=VALRES(13+K-1)
 20     CONTINUE

C 3.2 - LOI DES MELANGES FMEL SUR LA CONTRAINTE VISQUEUSE

        IF (ZALPHA.LE.0.01D0) THEN
          FMEL(1)=0.D0
          FMEL(2)=0.D0
          FMEL(3)=1.D0
        ENDIF

        IF ((ZALPHA.GT.0.01D0).AND.(ZALPHA.LE.0.1D0)) THEN
          FMEL(1)=0.D0
          FMEL(2)=1.D0-((0.1D0-ZALPHA)/0.09D0)
          FMEL(3)=(0.1D0-ZALPHA)/0.09D0      
        ENDIF

        IF ((ZALPHA.GT.0.1D0).AND.(ZALPHA.LE.0.9D0)) THEN
          FMEL(1)=0.D0
          FMEL(2)=1.D0
          FMEL(3)=0.D0            
        ENDIF

        IF ((ZALPHA.GT.0.9D0).AND.(ZALPHA.LE.0.99D0)) THEN
          FMEL(1)=(ZALPHA-0.9D0)/0.09D0
          FMEL(2)=1.D0-((ZALPHA-0.9D0)/0.09D0)
          FMEL(3)=0.D0            
        ENDIF

        IF (ZALPHA.GT.0.99D0) THEN
          FMEL(1)=1.D0
          FMEL(2)=0.D0
          FMEL(3)=0.D0      
        ENDIF

C 3.3 - PARAMETRE INTERVENANT DANS LA CONTRAINTE VISQUEUSE

        DO 25 K=1,3
          GAMMA(K)=FMEL(K)*A(K)
          IF (GAMMA(K).NE.0.D0) THEN
            GAMMA(K)=LOG(GAMMA(K))-LOG(2.D0*MU)-N(K)*LOG(DT)
            GAMMA(K)=GAMMA(K)+(N(K)*Q(K)/(TEMP+273.D0))
            GAMMA(K)=EXP(GAMMA(K))
          ENDIF
 25     CONTINUE 

      END
