      SUBROUTINE LCEJEX(NDIM,MATE,OPTION,AM,DA,TM,TP,SIGMA,
     &                  DSIDEP,VIM,VIP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/03/2007   AUTEUR LAVERNE J.LAVERNE 
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

      IMPLICIT NONE   
      INTEGER MATE,NDIM
      REAL*8  AM(NDIM),DA(NDIM),SIGMA(NDIM),DSIDEP(NDIM,NDIM)
      REAL*8  VIM(*),VIP(*),TM,TP
      CHARACTER*16 OPTION

C-----------------------------------------------------------------------
C                  LOI DE COMPORTEMENT D'INTERFACE
C                  POUR LES ELEMENTS DE JOINT 2D ET 3D : CZM_EXP_REG
C
C IN : AM SAUT INSTANT - : AM(1) = SAUT NORMAL, AM(2) = SAUT TANGENTIEL
C IN : DA    INCREMENT DE SAUT
C IN : MATE, OPTION, VIM, TM, TP
C OUT : SIGMA , DSIDEP , VIP
C-----------------------------------------------------------------------

      LOGICAL RESI, RIGI, ELAS
      INTEGER DISS,I,J
      REAL*8  SC,GC,LC,K0,VAL(4),VALPA,RTAN
      REAL*8  A(NDIM),NA,KA,KAP,R0,RC,BETA,RK,RA,COEF,COEF2
      CHARACTER*2 COD(4)
      CHARACTER*8 NOM(4)
      
C OPTION CALCUL DU RESIDU OU CALCUL DE LA MATRICE TANGENTE

      RESI = OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION.EQ.'RAPH_MECA'
      RIGI = OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION(1:9).EQ.'RIGI_MECA'
      ELAS = OPTION.EQ.'FULL_MECA_ELAS' .OR. OPTION.EQ.'RIGI_MECA_ELAS'


C CALCUL DU SAUT EN T+

      CALL DCOPY(NDIM,AM,1,A,1)
      IF (RESI) CALL DAXPY(NDIM,1.D0,DA,1,A,1)
      
       
C RECUPERATION DES PARAMETRES PHYSIQUES

      NOM(1) = 'GC'
      NOM(2) = 'SIGM_C'
      NOM(3) = 'PENA_ADHERENCE'
      NOM(4) = 'PENA_CONTACT'
      
      IF (OPTION.EQ.'RIGI_MECA_TANG') THEN
        VALPA=TM
      ELSE
        VALPA=TP
      ENDIF
      
      CALL RCVALA(MATE,' ','RUPT_FRAG',1,'TEMP',VALPA,4,
     &            NOM,VAL,COD,'F ')

      GC   = VAL(1)      
      SC   = VAL(2)  
      LC   = GC/SC
      K0   = LC*VAL(3)
      R0   = SC*EXP(-K0/LC)/K0 
      BETA = VAL(4)

C -- INITIALISATION

      KA   = MAX(K0,VIM(1)) 
      RTAN = 0.D0
      DO 10 I = 2,NDIM
        RTAN=RTAN+A(I)**2
10    CONTINUE
      NA   = SQRT( MAX(0.D0,A(1))**2 + RTAN )
      RK   = SC * EXP(-KA/LC) / KA
      RC   = RK + BETA*(R0-RK)
 
 
C INITIALISATION COMPLEMENTAIRE POUR RIGI_MECA_TANG (SECANTE PENALISEE)

      IF (.NOT. RESI) THEN
        IF (ELAS) THEN
          DISS = 0
        ELSE
          DISS = NINT(VIM(2))
        ENDIF
        GOTO 5000
      ENDIF        


C -- CALCUL DE LA CONTRAINTE          
      
C    CONTRAINTE DE CONTACT PENALISE
      SIGMA(1) = RC * MIN(0.D0,A(1))
      DO 15 I=2,NDIM
        SIGMA(I) = 0.D0
15    CONTINUE
     
      
C    CONTRAINTE DE FISSURATION
      IF (NA .LE. KA) THEN
        DISS     = 0
        SIGMA(1) = SIGMA(1) + RK*MAX(0.D0,A(1))
        DO 20 I=2,NDIM
          SIGMA(I) = SIGMA(I) + RK*A(I)
20      CONTINUE
      ELSE
        DISS     = 1
        RA       = SC * EXP(-NA/LC) / NA
        SIGMA(1) = SIGMA(1) + RA*MAX(0.D0,A(1))
        DO 30 I=2,NDIM
          SIGMA(I) = SIGMA(I) + RA*A(I)
30      CONTINUE
      ENDIF

      
C -- ACTUALISATION DES VARIABLES INTERNES
C   V1 :  SEUIL, PLUS GRANDE NORME DU SAUT
C   V2 :  INDICATEUR DE DISSIPATION (0 : NON, 1 : OUI)
C   V3 :  INDICATEUR D'ENDOMMAGEMENT  (0 : SAIN, 1: ENDOM)    
C   V4 :  POURCENTAGE D'ENERGIE DISSIPEE
C   V5 :  VALEUR DE L'ENERGIE DISSIPEE (V4*GC)
C   V6 :  VALEUR DE L'ENERGIE RESIDUELLE COURANTE
C   V7 A V9 : VALEURS DU SAUT

      KAP    = MAX(KA,NA)
      VIP(1) = KAP
      VIP(2) = DISS
      IF (NA.LE.K0) THEN
        VIP(3) = 0.D0
      ELSE
        VIP(3) = 1.D0      
      ENDIF      
      VIP(4) = 1.D0 - EXP(-KAP/LC) - 0.5D0*KAP*SC*EXP(-KAP/LC)/GC      
      VIP(5) = GC*VIP(4)
      VIP(6) = 0.5D0*(NA**2)*SC*EXP(-KAP/LC)/KAP
      VIP(7) = A(1)
      VIP(8) = A(2)      
      IF (NDIM.EQ.3) THEN
        VIP(9) = A(3)
      ELSE
        VIP(9) = 0.D0
      ENDIF

C -- MATRICE TANGENTE

 5000 CONTINUE
      IF (.NOT. RIGI) GOTO 9999
      
      CALL R8INIR(NDIM*NDIM, 0.D0, DSIDEP,1)

C    MATRICE TANGENTE DE CONTACT PENALISE
      IF (A(1).LE.0.D0) DSIDEP(1,1) = DSIDEP(1,1) + RC

C    MATRICE TANGENTE DE FISSURATION
      IF ((DISS.EQ.0) .OR. ELAS) THEN
      
        IF (A(1).GT.0.D0) DSIDEP(1,1) = DSIDEP(1,1) + RK
        DO 40 I=2,NDIM
          DSIDEP(I,I) = DSIDEP(I,I) + RK
40      CONTINUE
      
      ELSE

        COEF        = (SC/LC + SC/NA) / NA**2
        COEF2       = EXP(-NA/LC)
      
        IF (A(1).LE.0.D0) THEN
        
          DO 42 I=2,NDIM
            DSIDEP(I,I)=DSIDEP(I,I) + SC*COEF2/NA - COEF*COEF2*A(I)*A(I)
42        CONTINUE
         
          IF (NDIM.EQ.3) THEN 
            DSIDEP(2,3) = DSIDEP(2,3) - COEF*COEF2*A(2)*A(3)  
            DSIDEP(3,2) = DSIDEP(3,2) - COEF*COEF2*A(3)*A(2) 
          ENDIF

        ELSE
                  
          DO 44 I=1,NDIM
            DSIDEP(I,I)=DSIDEP(I,I) + SC*COEF2/NA - COEF*COEF2*A(I)*A(I)
44        CONTINUE    
          
          DO 46 J=1,NDIM-1
            DO 47 I=J+1,NDIM
              DSIDEP(J,I) = DSIDEP(J,I) - COEF*COEF2*A(J)*A(I)    
              DSIDEP(I,J) = DSIDEP(I,J) - COEF*COEF2*A(I)*A(J)    
47          CONTINUE
46        CONTINUE

        ENDIF
        
      ENDIF
      
 9999 CONTINUE  
      END
