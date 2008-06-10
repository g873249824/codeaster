      SUBROUTINE RC36SA ( NOMMAT, MATI, MATJ, SNPQ, SPIJ, 
     &                     TYPEKE, SPMECA, SPTHER, SALTIJ, SM )
      IMPLICIT   NONE
      REAL*8              MATI(*), MATJ(*), SNPQ, SPIJ, SALTIJ, SM
      REAL*8              TYPEKE, SPMECA, SPTHER
      CHARACTER*8         NOMMAT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 25/03/2003   AUTEUR JMBHH01 J.M.PROIX 
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
C
C     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
C
C     CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE  SALT
C     CALCUL DU FACTEUR D'USAGE ET DE SON CUMUL
C
C IN  : NOMMAT : NOM MATERIAU
C IN  : MATI   : MATERIAU ASSOCIE A L'ETAT STABILISE I
C IN  : MATJ   : MATERIAU ASSOCIE A L'ETAT STABILISE J
C IN  : SNPQ   : AMPLITUDE DE VARIATION DES CONTRAINTES LINEARISEES
C IN  : SPIJ   : AMPLITUDE DE VARIATION DES CONTRAINTES TOTALES
C OUT : SALTIJ : AMPLITUDE DE CONTRAINTE ENTRE LES ETATS I ET J
C
C     ------------------------------------------------------------------
C
      REAL*8  E,EC,PARA(3),M,N,KE,NADM,SALTM,SALTH,KEMECA,KETHER,KETHE1
C DEB ------------------------------------------------------------------
C
C --- LE MATERIAU
C
      E      = MIN ( MATI(1)  , MATJ(1)  )
      EC     = MAX ( MATI(10) , MATJ(10) )
      SM     = MIN ( MATI(11) , MATJ(11) )
      M      = MAX ( MATI(12) , MATJ(12) )
      N      = MAX ( MATI(13) , MATJ(13) )
C
      PARA(1) = M
      PARA(2) = N
      PARA(3) = EC / E
C
C --- CALCUL DU COEFFICIENT DE CONCENTRATION ELASTO-PLASTIQUE KE
C --- CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE SALT
C --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM
C
      IF (TYPEKE.LT.0.D0) THEN
         CALL PRCCM3 ( NOMMAT, PARA, SM, SNPQ, SPIJ, KE, SALTIJ, NADM )
      ELSE
         CALL PRCCM3 ( NOMMAT,PARA,SM,SNPQ,SPMECA,KEMECA,SALTM, NADM )
C
C       CALCUL DE KE THER
C
         KETHE1 = 1.86D0*(1.D0-(1.D0/(1.66D0+SNPQ/SM)))
         KETHER = MAX(1.D0,KETHE1)
C
C        CALCUL DE SALTH
         SALTH=  0.5D0 * PARA(3) * KETHER * SPTHER

         SALTIJ = SALTM + SALTH
      ENDIF
C
      END
