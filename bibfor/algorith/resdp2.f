      SUBROUTINE RESDP2( MATERF, SEQ, I1E, PMOINS,DP,DPDENO,PLAS)
C =====================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C =====================================================================
      IMPLICIT      NONE
      REAL*8        MATERF(4,2),PMOINS,DP,SEQ,I1E,PLAS,DPDENO
C =====================================================================
C --- RESOLUTION NUMERIQUE --------------------------------------------
C =====================================================================
      INTEGER  NDT, NDI
      REAL*8   YOUNG, NU, TROISK, DEUXMU, ALPHA, PHI, C, PULT
      REAL*8   TROIS, DEUX, UN, FCRIT, SCHDP2, VALPRO, GAMAPM, GAMARP
      REAL*8   NEUF, DOUZE, A1, B1, DELTA, QUATRE, VALCOE, B2
      PARAMETER ( DOUZE  = 12.0D0 )
      PARAMETER ( NEUF   =  9.0D0 )
      PARAMETER ( QUATRE =  4.0D0 )
      PARAMETER ( TROIS  =  3.0D0 )
      PARAMETER ( DEUX   =  2.0D0 )
      PARAMETER ( UN     =  1.0D0 )
C =====================================================================
      COMMON /TDIM/   NDT, NDI
C =====================================================================
C --- AFFECTATION DES VARIABLES ---------------------------------------
C =====================================================================
      YOUNG  = MATERF(1,1)
      NU     = MATERF(2,1)
      TROISK = YOUNG / (UN-DEUX*NU)
      DEUXMU = YOUNG / (UN+NU)
      ALPHA  = MATERF(1,2)
      PHI    = MATERF(2,2)
      C      = MATERF(3,2)
      PULT   = MATERF(4,2)
      GAMARP = SQRT ( TROIS / DEUX ) * PULT
      GAMAPM = SQRT ( TROIS / DEUX ) * PMOINS
C =====================================================================
C --- CALCUL ELASTIQUE ------------------------------------------------
C =====================================================================
      FCRIT  = SCHDP2(SEQ, I1E, PHI, ALPHA, C, PULT, PMOINS)
C =====================================================================
C --- CALCUL PLASTIQUE ------------------------------------------------
C =====================================================================
      IF ( FCRIT.GT.0.0D0 ) THEN
         PLAS = 1.0D0
         IF ( PMOINS.LT.PULT ) THEN
            A1 = - NEUF*C*COS(PHI)*
     +             (UN-ALPHA)*(UN-ALPHA)/GAMARP/GAMARP/(TROIS-SIN(PHI)) 
            B1 = - ( TROIS*DEUXMU/DEUX +
     +               TROIS*TROISK*DEUX*SIN(PHI)*DEUX*SIN(PHI)/
     +              (TROIS-SIN(PHI))/(TROIS-SIN(PHI)) -
     +              SQRT(TROIS/DEUX)*DOUZE*C*COS(PHI)/(TROIS-SIN(PHI))*
     +               (UN-(UN-ALPHA)/GAMARP*GAMAPM)*(UN-ALPHA)/GAMARP)
            DELTA  = B1*B1 - QUATRE*A1*FCRIT
            IF (A1.EQ.0.0D0) THEN
               CALL UTMESS('F','RESDP2','INCOHERENCE DE C, PHI OU A')
            ENDIF
            DP     = - (B1 + SQRT(DELTA))/DEUX/A1
            DPDENO = B1 + DEUX*A1*DP
            VALCOE = SQRT(DEUX/TROIS)*(GAMARP-GAMAPM)
            IF ( DP.GT.VALCOE ) THEN
               FCRIT  = SCHDP2(SEQ,I1E,PHI,ALPHA,C,PULT,PULT)
               B2 = - ( TROIS*DEUXMU/DEUX +
     +                  TROIS*TROISK*DEUX*SIN(PHI)*DEUX*SIN(PHI)/
     +                  (TROIS-SIN(PHI))/(TROIS-SIN(PHI)))
               IF (B2.EQ.0.0D0) THEN
                  CALL UTMESS('F','RESDP2','INCOHERENCE DE DONNEES')
               ENDIF
               DP     = - FCRIT / B2
               DPDENO = B2
            ENDIF
         ELSE
            B2 = - ( TROIS*DEUXMU/DEUX +
     +                  TROIS*TROISK*DEUX*SIN(PHI)*DEUX*SIN(PHI)/
     +                  (TROIS-SIN(PHI))/(TROIS-SIN(PHI)))
            IF (B2.EQ.0.0D0) THEN
               CALL UTMESS('F','RESDP2','INCOHERENCE DE DONNEES')
            ENDIF
            DP = - FCRIT / B2
            DPDENO = B2
         ENDIF
      ELSE
         PLAS   = 0.0D0
         DP = 0.0D0
      ENDIF
C =====================================================================
C --- PROJECTION AU SOMMET --------------------------------------------
C =====================================================================
      VALPRO = SEQ/(TROIS*DEUXMU/DEUX)
      IF ( DP.GT.VALPRO ) THEN
         DP   = VALPRO
         PLAS = 2.0D0
         B2 = - ( TROIS*DEUXMU/DEUX +
     +                  TROIS*TROISK*DEUX*SIN(PHI)*DEUX*SIN(PHI)/
     +                  (TROIS-SIN(PHI))/(TROIS-SIN(PHI)))
         IF (B2.EQ.0.0D0) THEN
            CALL UTMESS('F','RESDP2','INCOHERENCE DE DONNEES')
         ENDIF
         DPDENO = B2
      ENDIF
C =====================================================================
      END
