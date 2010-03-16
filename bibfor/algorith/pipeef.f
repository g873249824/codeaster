      SUBROUTINE PIPEEF(NDIM  ,TYPMOD,TAU   ,MATE  ,VIM   ,
     &                  EPSP  ,EPSD  ,A0    ,A1    ,A2    ,
     &                  A3    ,ETAS  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/03/2010   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      CHARACTER*8        TYPMOD(2)
      INTEGER            NDIM,MATE
      REAL*8             EPSP(6), EPSD(6), TAU
      REAL*8             VIM(2)
      REAL*8             A0, A1, A2, A3, ETAS
C       
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (PILOTAGE - PRED_ELAS)
C
C LOI DE COMPORTEMENT ELASTIQUE FRAGILE (EN DELOCALISE)
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  TYPMOD : TYPE DE MODELISATION
C IN  TAU    : 2ND MEMBRE DE L'EQUATION F(ETA)=TAU
C IN  MATE   : MATERIAU CODE
C IN  VIM    : VARIABLES INTERNES EN T-
C IN  EPSP   : CORRECTION DE DEFORMATIONS DUES AUX CHARGES FIXES
C IN  EPSD   : CORRECTION DE DEFORMATIONS DUES AUX CHARGES PILOTEES
C OUT A0     : LINEARISATION DU CRITERE : FEL = A0 + A1*ETA
C OUT A1     : IDEM A0
C OUT A2     : IDEM A0 POUR LA 2E SOLUTION EVENTUELLE. R8VIDE SINON
C OUT A3     : IDEM A1 POUR LA 2E SOLUTION EVENTUELLE. R8VIDE SINON
C OUT ETAS   : SI PAS DE SOLUTION : LE MINIMUM. R8VIDE SINON
C
C ----------------------------------------------------------------------
C
      INTEGER     NBRES
      PARAMETER   (NBRES=2)
      CHARACTER*2 CODRET(NBRES)
      CHARACTER*8 NOMRES(NBRES)
      REAL*8      VALRES(NBRES)
C
      LOGICAL     CPLAN
      INTEGER     NDIMSI, K, NRAC
      REAL*8      TREPSP, TREPSD, COPLAN, SIGELP(6), SIGELD(6)
      REAL*8      KRON(6)
      REAL*8      P0, P1, P2, ETA, RAC(2)
      REAL*8      E, NU, LAMBDA, DEUXMU, GAMMA, SY, WY, WREL
      REAL*8      DM,DTAU,GM,GTAU,S
      REAL*8      R8VIDE,DDOT
C
      DATA  KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
C
C ----------------------------------------------------------------------
C


C -- OPTION ET MODELISATION

      CPLAN  = (TYPMOD(1).EQ.'C_PLAN  ')
      NDIMSI = 2*NDIM


C -- CAS DE L'ENDOMMAGEMENT SATURE

      IF (NINT(VIM(2)) .EQ. 2) THEN
        A0 = 0.D0
        A1 = 0.D0
        A2 = 0.D0
        A3 = 0.D0
        ETAS = R8VIDE()
        GOTO 9999
      END IF

C -- LECTURE DES CARACTERISTIQUES THERMOELASTIQUES

      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      CALL RCVALA(MATE  ,' '   ,'ELAS',0     ,' '   ,
     &            0.D0  ,NBRES ,NOMRES,VALRES,CODRET,
     &            'FM'  )
      E      = VALRES(1)
      NU     = VALRES(2)
      LAMBDA = E * NU / (1.D0+NU) / (1.D0 - 2.D0*NU)
      DEUXMU = E/(1.D0+NU)


C -- LECTURE DES CARACTERISTIQUES D'ENDOMMAGEMENT

      NOMRES(1) = 'SY'
      NOMRES(2) = 'D_SIGM_EPSI'
      CALL RCVALA(MATE  ,' '   ,'ECRO_LINE',0     ,' '   ,
     &            0.D0  ,NBRES ,NOMRES     ,VALRES,CODRET,
     &            'FM'  )
      SY    = VALRES(1)
      GAMMA = - VALRES(2)/E
      WY    = SY**2 / (2*E)

C -- CALCUL DES DEFORMATIONS EN PRESENCE DE CONTRAINTES PLANES

      IF (CPLAN) THEN
        COPLAN   = - NU/(1.D0-NU)
        EPSP(3)  = COPLAN * (EPSP(1)+EPSP(2))
        EPSD(3)  = COPLAN * (EPSD(1)+EPSD(2))
      END IF
C
C ======================================================================
C                CALCUL DES DEFORMATIONS POUR LINEARISATION
C ======================================================================
C
C    ETAT MECANIQUE EN T-

      DM     = VIM(1)
      DTAU   = MIN(1+GAMMA/2, DM+TAU)
      GM     = WY * ((1+GAMMA)/(1+GAMMA-DM))**2
      GTAU   = WY * ((1+GAMMA)/(1+GAMMA-DTAU))**2      
      WREL   = (GTAU - GM)/TAU
      S      = GM / WREL

C    COEFFICIENTS DE LA FORME QUADRATIQUE DU CRITERE

      TREPSP = EPSP(1)+EPSP(2)+EPSP(3)
      TREPSD = EPSD(1)+EPSD(2)+EPSD(3)
      DO 60 K=1,NDIMSI
        SIGELP(K) = LAMBDA*TREPSP*KRON(K) + DEUXMU*EPSP(K)
        SIGELD(K) = LAMBDA*TREPSD*KRON(K) + DEUXMU*EPSD(K)
 60   CONTINUE
      P0 = 0.5D0 * DDOT(NDIMSI,EPSP,1,SIGELP,1) / WREL
      P1 = 1.0D0 * DDOT(NDIMSI,EPSP,1,SIGELD,1) / WREL
      P2 = 0.5D0 * DDOT(NDIMSI,EPSD,1,SIGELD,1) / WREL

  
C    RECHERCHE DES INTERSECTIONS ELLIPSE / DROITE
      CALL ZEROP2(P1/P2, (P0-S-TAU)/P2, RAC, NRAC)

C    PAS DE SOLUTION : POINT LE PLUS PROCHE
      IF (NRAC .EQ. 0) THEN
        ETAS   = 0.D0

C    UNE OU DEUX SOLUTIONS : ON LINEARISE AUTOUR DES DEUX
      ELSE IF (NRAC.EQ.1) THEN
        ETA   = RAC(1)
        A1    = 2*P2*ETA+P1
        A0    = TAU - A1*ETA
      ELSE
        ETA   = RAC(1)
        A1    = 2*P2*ETA+P1
        A0    = TAU - A1*ETA
        ETA   = RAC(2)
        A3    = 2*P2*ETA+P1
        A2    = TAU - A3*ETA
      ENDIF
C
 9999 CONTINUE
      END
