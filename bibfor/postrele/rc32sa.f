      SUBROUTINE RC32SA ( TYPZ, NOMMAT, MATI, MATJ, SNPQ, SPIJ, 
     &        TYPEKE, SPMECA, SPTHER, KEMECA, KETHER, SALTIJ, SM,FUIJ )
      IMPLICIT   NONE
      REAL*8            MATI(*), MATJ(*), SNPQ, SPIJ(2), SALTIJ(2), SM
      REAL*8            TYPEKE, SPMECA(2), SPTHER(2),FUIJ(2)
      CHARACTER*8       NOMMAT
      CHARACTER*(*)     TYPZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 16/02/2009   AUTEUR GALENNE E.GALENNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
C     CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE  SALT
C     CALCUL DU FACTEUR D'USAGE ET DE SON CUMUL
C
C IN  : NOMMAT : NOM MATERIAU
C IN  : MATI   : MATERIAU ASSOCIE A L'ETAT STABILISE I
C IN  : MATJ   : MATERIAU ASSOCIE A L'ETAT STABILISE J
C IN  : SNPQ   : AMPLITUDE DE VARIATION DES CONTRAINTES LINEARISEES
C IN  : SPIJ   : AMPLITUDE DE VARIATION DES CONTRAINTES TOTALES
C IN  : TYPEKE    : =-1 SI KE_MECA, =1 SI KE_MIXTE
C IN  : SPMECA   : AMPLITUDE DE VARIATION DES CONTRAINTES MECANIQUES
C IN  : SPTHER   : AMPLITUDE DE VARIATION DES CONTRAINTES THERMIQUES
C OUT : SALTIJ : AMPLITUDE DE CONTRAINTE ENTRE LES ETATS I ET J
C OUT : FUIJ : FACTEUR D USAGE POUR LA COMBINAISON ENTRE I ET J
C
C     ------------------------------------------------------------------
C
      REAL*8    R8VIDE, E, EC, PARA(3), M, N, NADM, SALTM, SALTH,
     +          KEMECA, KETHER, KETHE1, VALR(2),R8MAEM
      CHARACTER*2  CODRET
      LOGICAL       ENDUR
C DEB ------------------------------------------------------------------
C
C --- LE MATERIAU
C
      E      = MIN ( MATI(1) , MATJ(1) )
      EC     = MAX ( MATI(4) , MATJ(4) )
      SM     = MIN ( MATI(5) , MATJ(5) )
      M      = MAX ( MATI(6) , MATJ(6) )
      N      = MAX ( MATI(7) , MATJ(7) )
C
      PARA(1) = M
      PARA(2) = N
      PARA(3) = EC / E
      
      SALTIJ(1) = 0.D0
      SALTIJ(2) = 0.D0
      FUIJ(1) = 0.D0
      FUIJ(2) = 0.D0
C
C --- CALCUL DU COEFFICIENT DE CONCENTRATION ELASTO-PLASTIQUE KE
C --- CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE SALT
C --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM
C
      IF (TYPEKE.LT.0.D0) THEN
         CALL PRCCM3 ( NOMMAT,PARA,SM,SNPQ,SPIJ(1),KEMECA,SALTIJ(1),
     +                 NADM )
         FUIJ(1) = 1.D0 / NADM
         IF (TYPZ.EQ.'COMB') THEN
           CALL PRCCM3 ( NOMMAT,PARA,SM,SNPQ,SPIJ(2),KEMECA,SALTIJ(2),
     +                 NADM )
           FUIJ(2) = 1.D0 / NADM
         ENDIF  
         KETHER = R8VIDE()
      ELSE
C
C --- CAS KE_MIXTE
C
         KETHE1 = 1.86D0*(1.D0-(1.D0/(1.66D0+SNPQ/SM)))
         KETHER = MAX(1.D0,KETHE1)
         CALL PRCCM3 ( NOMMAT,PARA,SM,SNPQ,SPMECA(1),KEMECA,SALTM,NADM )
         SALTH =  0.5D0 * PARA(3) * KETHER * SPTHER(1)
         SALTIJ(1) = SALTM + SALTH

C --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM : TR. 1
C
         CALL LIMEND( NOMMAT,SALTIJ(1),'WOHLER',ENDUR)
         IF (ENDUR) THEN
            NADM=R8MAEM()
         ELSE
           CALL RCVALE (NOMMAT,'FATIGUE', 1, 'SIGM    ',SALTIJ(1), 1,
     +                      'WOHLER  ', NADM, CODRET, 'F ' )
           IF ( NADM .LT. 0 ) THEN
             VALR (1) = SALTIJ(1)
             VALR (2) = NADM
             CALL U2MESG('A','POSTRELE_61',0,' ',0,0,2,VALR)
           ENDIF
         ENDIF
         FUIJ(1) = 1.D0 / NADM
         
         IF (TYPZ.EQ.'COMB') THEN
           CALL PRCCM3 (NOMMAT,PARA,SM,SNPQ,SPMECA(2),KEMECA,SALTM,NADM)
           SALTH =  0.5D0 * PARA(3) * KETHER * SPTHER(2)
           SALTIJ(2) = SALTM + SALTH
C --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM : TR. 2
C
           CALL LIMEND( NOMMAT,SALTIJ(2),'WOHLER',ENDUR)
           IF (ENDUR) THEN
              NADM=R8MAEM()
           ELSE
             CALL RCVALE (NOMMAT,'FATIGUE', 1, 'SIGM    ',SALTIJ(2), 1,
     +                      'WOHLER  ', NADM, CODRET, 'F ' )
             IF ( NADM .LT. 0 ) THEN
               VALR (1) = SALTIJ(1)
               VALR (2) = NADM
               CALL U2MESG('A','POSTRELE_61',0,' ',0,0,2,VALR)
             ENDIF
           ENDIF
           FUIJ(2) = 1.D0 / NADM
         ENDIF
        
      ENDIF
C
      END
