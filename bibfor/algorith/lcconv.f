        SUBROUTINE LCCONV ( LOI,  DY,     DDY,  NR, ITMAX, TOLER, ITER,
     &                      INTG, TYPESS, ESSAI, ICOMP, IRTETI)
        IMPLICIT   NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/10/2001   AUTEUR ADBHHVV V.CANO 
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
C       ----------------------------------------------------------------
C       ROUTINE D AIGUILLAGE
C       ----------------------------------------------------------------
C       CONTROLE DE LA CONVERGENCE DE LA METHODE DE NEWTON (LCPLNL):
C
C                       - CONTROLE DU NOMBRE D ITERATIONS
C                       - CONTROLE DE LA PRECISION DE CONVERGENCE
C                       - CONTROLE DE LA VALIDITE SOLUTION A CONVERGENCE
C                       - CONTROLE DES RE-INTEGRATIONS EVENTUELLES
C                       - CONTROLE DU REDECOUPAGE DU PAS DE TEMPS
C
C       ----------------------------------------------------------------
C       IN  LOI    :  MODELE DE COMPORTEMENT
C           TYPESS :  TYPE DE SOLUTION D ESSAI POUR DY(DEPEND DU MODELE)
C                      > VOIR XXXCVG ET XXXINI
C           ESSAI  :  VALEUR SOLUTION D ESSAI
C           ITMAX  :  NB MAXI D ITERATIONS LOCALES
C           TOLER  :  TOLERANCE A CONVERGENCE
C           ITER   :  NUMERO ITERATION COURANTE
C           INTG   :  NUMERO INTEGRATION COURANTE
C           NR     :  DIMENSION DY DDY
C           DY     :  VECTEUR SOLUTION = ( DSIG DVIN (DEPS3) )
C           DDY    :  VECTEUR CORRECTION SUR LA SOLUTION
C           ICOMP  :  COMPTEUR POUR LE REDECOUPAGE DU PAS DE TEMPS
C       OUT IRTETI = 0:  CONVERGENCE
C           IRTETI = 1:  ITERATION SUIVANTE
C           IRTETI = 2:  RE-INTEGRATION
C           IRTETI = 3:  REDECOUPAGE DU PAS DE TEMPS
C       ----------------------------------------------------------------
        INTEGER         TYPESS, ITMAX,  ITER,   INTG, NR,  ICOMP
        INTEGER         IRTET, IRTETI
        REAL*8          TOLER,  ESSAI,  DDY(*), DY(*)
        CHARACTER*16    LOI
C       ----------------------------------------------------------------
C
         IRTETI = 0
C         IF     ( LOI(1:8) .EQ. 'ROUSS_PR' ) THEN
C         CALL RSLCVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
C     &                 INTG, TYPESS, ESSAI, IRTET )
C         IF ( IRTET.NE.0 ) GOTO( 1, 2 ), IRTET
C
      IF ( LOI(1:8) .EQ. 'CHABOCHE' ) THEN
         CALL CHBCVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, ICOMP, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1,2,3), IRTET
C
      ELSEIF ( LOI(1:4) .EQ. 'OHNO' ) THEN
         CALL ONOCVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, ICOMP, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1,2,3), IRTET
C
      ELSEIF ( LOI(1:5) .EQ. 'LMARC' ) THEN
         CALL LMACVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, ICOMP, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1,2,3), IRTET
C
      ELSEIF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMCVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, ICOMP, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1,2,3), IRTET
C
      ELSEIF ( LOI(1:7) .EQ. 'NADAI_B' ) THEN
         CALL INSCVG (       DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, ICOMP, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1,2,3), IRTET
C
      ELSE
         CALL LCCTRL ( LOI,  DY,     DDY,   NR, ITMAX,  TOLER, ITER,
     &                 INTG, TYPESS, ESSAI, IRTET)
         IF ( IRTET.GT.0 ) GOTO (1), IRTET
      ENDIF
C
      IRTETI = 0
      GOTO 9999
C
 1    CONTINUE
      IRTETI = 1
      GOTO 9999
C
 2    CONTINUE
      IRTETI = 2
      GOTO 9999
C
 3    CONTINUE
      IRTETI = 3
      GOTO 9999
C
 9999 CONTINUE
      END
