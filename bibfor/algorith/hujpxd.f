        SUBROUTINE HUJPXD (K, MATER, SIG ,VIN, PROX)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/11/2007   AUTEUR KHAM M.KHAM 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    ---------------------------------------------------------------
C    HUJEUX:  CRITERE DE PROXIMITE POUR LES SEUILS DEVIATOIRES 
C                        MONOTONES ET CYCLIQUES
C             FD(K) = QII(K) + M*PK*RK*( 1 - B*LOG(PK/PC) )
C    ---------------------------------------------------------------
C    IN  K      :  PLAN DE PROJECTION CONSIDERE (K = 1 A 3)
C        SIG    :  TENSEUR DES CONTRAINTES
C        MATER  :  PARAMETRES MATERIAU
C        VIN    :  VARIABLES INTERNES = ( R, X )
C    OUT PROX   :  CRITERE DE PROXIMITE
C                  .TRUE. MECANISMES ASSEZ PROCHES POUR ACTIVER 
C                  LE MECANISME MONOTONE
C    ---------------------------------------------------------------
        INTEGER      K, NDT, NDI
        INTEGER      IFM, NIV
        REAL*8       MATER(22,2), SIG(6), VIN(*), SEUILD
        REAL*8       UN, RK, EPSVP, PCR, PA, TOLE
        REAL*8       DEGR, BETA, B, M, PHI, PCREF
        REAL*8       SIGD(3), PK, QK, DIST, RH
        LOGICAL      DEBUG, PROX
        PARAMETER    (UN = 1.D0)
        PARAMETER    (TOLE = 1.D-6)
        PARAMETER    (DEGR = 0.0174532925199D0)
C       ------------------------------------------------------------
        COMMON /TDIM/   NDT, NDI
        COMMON /MESHUJ/ DEBUG

        CALL INFNIV (IFM, NIV)
        
C ==================================================================
C --- VARIABLES INTERNES -------------------------------------------
C ==================================================================
        EPSVP = VIN(23)
        RH    = VIN(K-4)
        
C ==================================================================
C --- CARACTERISTIQUES MATERIAU ------------------------------------
C ==================================================================
        BETA  = MATER(2, 2)
        B     = MATER(4, 2)
        PHI   = MATER(5, 2)
        PCREF = MATER(7, 2)
        PA    = MATER(8, 2)
        PCR   = PCREF*EXP(-BETA*EPSVP)
        M     = SIN(DEGR*PHI)
        
C ==================================================================
C --- PROJECTION DANS LE PLAN DEVIATEUR K ------------------------
C ==================================================================
        CALL HUJPRJ (K-4, SIG, SIGD, PK, QK)
        IF ((PK/PA) .LE. TOLE) THEN        
           IF (DEBUG) WRITE (IFM,'(A)')
     &                'HUJPRX :: LOG(PK/PA) NON DEFINI'
           PROX = .FALSE.
           GOTO 999
        ENDIF
        
C ==================================================================
C --- CALCUL DU SEUIL DU MECANISME DEVIATOIRE K ------------------
C ==================================================================
        RK = -QK /(M*PK*(UN-B*LOG(PK/PCR)))
        DIST = ABS(RK-RH)/RH

        IF (DIST .LT. 1.D-5) THEN
          PROX = .TRUE.
        ELSE
          PROX = .FALSE.
        ENDIF  
 999   CONTINUE
       END
