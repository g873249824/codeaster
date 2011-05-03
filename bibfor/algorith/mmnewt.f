        SUBROUTINE  MMNEWT(ALIAS ,NNO   ,NDIM  ,COORMA,COORPT,
     &                     ITEMAX,EPSMAX,KSI1  ,KSI2  ,TAU1  ,
     &                     TAU2  ,NIVERR)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/05/2011   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  ALIAS      
      INTEGER      NNO
      INTEGER      NDIM
      REAL*8       COORMA(27)
      REAL*8       COORPT(3)     
      REAL*8       KSI1,KSI2
      REAL*8       TAU1(3),TAU2(3)
      INTEGER      NIVERR
      INTEGER      ITEMAX
      REAL*8       EPSMAX
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
C
C ALGORITHME DE NEWTON POUR CALCULER LA PROJECTION D'UN POINT SUR UNE
C MAILLE - VERSION GENERALE
C      
C ----------------------------------------------------------------------
C
C
C IN  ALIAS  : TYPE DE MAILLE
C IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
C IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
C IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
C IN  COORPT : COORDONNEES DU NOEUD A PROJETER SUR LA MAILLE
C IN  ITEMAX : NOMBRE MAXI D'ITERATIONS DE NEWTON POUR LA PROJECTION
C IN  EPSMAX : RESIDU POUR CONVERGENCE DE NEWTON POUR LA PROJECTION 
C OUT KSI1   : PREMIERE COORDONNEE PARAMETRIQUE DU POINT PROJETE
C OUT KSI2   : SECONDE COORDONNEE PARAMETRIQUE DU POINT PROJETE
C OUT TAU1   : PREMIER VECTEUR TANGENT EN KSI1,KSI2
C OUT TAU2   : SECOND VECTEUR TANGENT EN KSI1,KSI2
C OUT NIVERR : RETOURNE UN CODE ERREUR
C                0  TOUT VA BIEN
C                1  ECHEC NEWTON
C
C ----------------------------------------------------------------------
C
      REAL*8       FF(9),DFF(2,9),DDFF(3,9)  
      REAL*8       VEC1(3)
      REAL*8       MATRIX(2,2),PAR11(3),PAR12(3),PAR22(3)
      REAL*8       RESIDU(2),EPS
      REAL*8       DKSI1,DKSI2
      REAL*8       DET,TEST,EPSREL,EPSABS,REFE
      INTEGER      INO,IDIM,ITER
      REAL*8       ZERO
      PARAMETER    (ZERO=0.D0)   
      REAL*8       DIST,DMIN,R8GAEM,KSI1M,KSI2M      
C
C ----------------------------------------------------------------------
C
C
C --- VERIF CARACTERISTIQUES DE LA MAILLE
C
      IF (NNO.GT.9)  CALL ASSERT(.FALSE.) 
      IF (NDIM.GT.3) CALL ASSERT(.FALSE.) 
      IF (NDIM.LE.1) CALL ASSERT(.FALSE.)
C
C --- POINT DE DEPART
C
      NIVERR = 0
      KSI1   = ZERO
      KSI2   = ZERO
      ITER   = 0
      EPSABS = EPSMAX/100.D0
      EPSREL = EPSMAX
      ITEMAX = 200  
      DMIN   = R8GAEM()  
C
C --- DEBUT DE LA BOUCLE
C      
 20   CONTINUE 
C
C --- INITIALISATIONS
C 
        DO 10 IDIM  = 1,3
          VEC1(IDIM)  = ZERO
          TAU1(IDIM)  = ZERO
          TAU2(IDIM)  = ZERO
          PAR11(IDIM) = ZERO
          PAR12(IDIM) = ZERO
          PAR22(IDIM) = ZERO
 10     CONTINUE
        RESIDU(1)   = ZERO
        RESIDU(2)   = ZERO
        MATRIX(1,1) = ZERO
        MATRIX(1,2) = ZERO
        MATRIX(2,1) = ZERO
        MATRIX(2,2) = ZERO
C       
C --- CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT 
C --- DANS LA MAILLE
C
        CALL MMFONF(NDIM  ,NNO   ,ALIAS  ,KSI1   ,KSI2  ,
     &              FF    ,DFF   ,DDFF   )          
C
C --- CALCUL DU VECTEUR POSITION DU POINT COURANT SUR LA MAILLE
C
        DO 40 IDIM = 1,NDIM
          DO 30 INO = 1,NNO
            VEC1(IDIM)  = COORMA(3*(INO-1)+IDIM)*FF(INO) + VEC1(IDIM) 
 30       CONTINUE
 40     CONTINUE
C
C --- CALCUL DES TANGENTES
C
        CALL MMTANG(NDIM  ,NNO   ,COORMA,DFF   ,
     &              TAU1  ,TAU2)         
C
C --- CALCUL DE LA QUANTITE A MINIMISER
C
        DO 35 IDIM = 1,NDIM
          VEC1(IDIM) = COORPT(IDIM) - VEC1(IDIM)
 35     CONTINUE     
        DIST  = SQRT(VEC1(1)*VEC1(1)+
     &               VEC1(2)*VEC1(2)+
     &               VEC1(3)*VEC1(3))
C
C --- CALCUL DU RESIDU
C
        RESIDU(1) = VEC1(1)*TAU1(1) + VEC1(2)*TAU1(2) + 
     &              VEC1(3)*TAU1(3)
        IF (NDIM.EQ.3) THEN
          RESIDU(2) = VEC1(1)*TAU2(1) + VEC1(2)*TAU2(2) + 
     &                VEC1(3)*TAU2(3)
        ENDIF 
C
C --- CALCUL DES COURBURES LOCALES
C
        DO 42 IDIM = 1,NDIM
          DO 32 INO = 1,NNO
            PAR11(IDIM) = COORMA(3*(INO-1)+IDIM)*DDFF(1,INO) + 
     &                    PAR11(IDIM)
            IF (NDIM.EQ.3) THEN
              PAR22(IDIM) = COORMA(3*(INO-1)+IDIM)*DDFF(2,INO) + 
     &                      PAR22(IDIM)
              PAR12(IDIM) = COORMA(3*(INO-1)+IDIM)*DDFF(3,INO) + 
     &                      PAR12(IDIM)
            ENDIF  
 32      CONTINUE
 42     CONTINUE 
C
C --- CALCUL DE LA MATRICE TANGENTE
C
        DO 60 IDIM = 1,NDIM
          MATRIX(1,1) = -TAU1(IDIM)*TAU1(IDIM) +  
     &                  PAR11(IDIM)*VEC1(IDIM) + MATRIX(1,1)
          IF (NDIM.EQ.3) THEN
            MATRIX(1,2) = -TAU2(IDIM)*TAU1(IDIM) + 
     &                    PAR12(IDIM)*VEC1(IDIM) + MATRIX(1,2)
            MATRIX(2,1) = -TAU1(IDIM)*TAU2(IDIM) + 
     &                    PAR12(IDIM)*VEC1(IDIM) + MATRIX(2,1)
            MATRIX(2,2) = -TAU2(IDIM)*TAU2(IDIM) + 
     &                    PAR22(IDIM)*VEC1(IDIM) + MATRIX(2,2)
          ENDIF  
   60   CONTINUE
C
C --- RESOLUTION K.dU=RESIDU
C
        IF (NDIM.EQ.2) THEN
          DET = MATRIX(1,1)
        ELSE IF (NDIM.EQ.3) THEN
          DET = MATRIX(1,1)*MATRIX(2,2) - MATRIX(1,2)*MATRIX(2,1) 
        ENDIF
C
        IF (DET.EQ.0.D0) THEN
          NIVERR = 1
          GOTO 999
        END IF
C
        IF (NDIM.EQ.2) THEN
          DKSI1 = -RESIDU(1)/MATRIX(1,1)
          DKSI2 = 0.D0
        ELSE IF (NDIM.EQ.3) THEN  
          DKSI1 = (MATRIX(2,2)* (-RESIDU(1))-MATRIX(1,2)* 
     &               (-RESIDU(2)))/DET
          DKSI2 = (MATRIX(1,1)* (-RESIDU(2))-MATRIX(2,1)* 
     &               (-RESIDU(1)))/DET
        END IF
C  
C --- ACTUALISATION
C  
        KSI1 = KSI1 + DKSI1
        KSI2 = KSI2 + DKSI2     
        ITER = ITER + 1  
        IF (DIST.LE.DMIN) THEN
          DMIN  = DIST
          KSI1M = KSI1
          KSI2M = KSI2
        ENDIF
C
C --- CALCUL DE LA REFERENCE POUR TEST DEPLACEMENTS
C
        REFE = (KSI1*KSI1+KSI2*KSI2)
        IF (REFE.LE.EPSREL) THEN  
          REFE = 1.D0   
          EPS  = EPSABS
        ELSE            
          EPS  = EPSREL
        ENDIF       
C
C --- CALCUL POUR LE TEST DE CONVERGENCE 
C      
        TEST = SQRT(DKSI1*DKSI1+DKSI2*DKSI2)/SQRT(REFE)
C
C --- EVALUATION DE LA CONVERGENCE
C       
        IF ((TEST.GT.EPS) .AND. (ITER.LT.ITEMAX)) THEN
          GOTO 20
        ELSEIF ((ITER.GE.ITEMAX).AND.(TEST.GT.EPS)) THEN
          KSI1 = KSI1M
          KSI2 = KSI2M
          CALL MMFONF(NDIM  ,NNO   ,ALIAS  ,KSI1   ,KSI2  ,
     &                FF    ,DFF   ,DDFF   )          
          CALL MMTANG(NDIM  ,NNO   ,COORMA,DFF   ,
     &                TAU1  ,TAU2)            
        ENDIF  
C
C --- FIN DE LA BOUCLE
C 

  999 CONTINUE      
C
      IF (NIVERR.EQ.1) THEN
        WRITE(6,*) 'POINT A PROJETER: ',COORPT(1),COORPT(2),COORPT(3)
        WRITE(6,*) 'MAILLE          ',ALIAS,NNO
        WRITE(6,*) 'DISTANCE        ',DIST
        
        DO 70 INO = 1,NNO 
          WRITE(6,*) '  NOEUD ',INO
          WRITE(6,*) '   (X,Y,Z)',COORMA(3*(INO-1)+1) ,
     &                          COORMA(3*(INO-1)+2),
     &                          COORMA(3*(INO-1)+3)
  70    CONTINUE     
        WRITE(6,*) 'KSI : ',KSI1,KSI2
        WRITE(6,*) 'DKSI: ',DKSI1,DKSI2        
      ENDIF                  
C      
      END
