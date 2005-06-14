         SUBROUTINE COMPTV( NBPT,FN,OFFSET,T,NBCHOC,TCHMIN,TCHMAX,
     &                      TCHOCT,TCHOCM,NBREBO,TREBOT,TREBOM)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/06/96   AUTEUR KXBADNG T.FRIOU 
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
C ----------------------------------------------------------------------
C        COMPTAGE DES CHOCS 
C        ALGORITHME TEMPOREL A PAS VARIABLE
C
C IN  : NBPT   : NB DE POINTS DU SIGNAL
C IN  : FN     : TABLEAU DU SIGNAL
C IN  : T      : TABLEAU DU TEMPS
C IN  : OFFSET : VALEUR DU SEUIL DE DETECTION D UN CHOC
C OUT : NBCHOC : NB DE CHOC GLOBAUX ( CRITERE ELAPSE )
C OUT : NBREBO : NB DE REBONDS ( RETOUR AU SEUIL )
C OUT : TCHOCM : TEMPS DE CHOC GLOBAL MOYEN
C OUT : TREBOM : TEMPS DE REBOND MOYEN
C OUT : TCHOCT : TEMPS DE CHOC CUMULE
C ----------------------------------------------------------------------
C
         IMPLICIT REAL*8 (A-H,O-Z)
         REAL*8   FN(*), T(*)
C
         ZERO   = 0.D0
         NBCHOC = 0
         NBREBO = 0
         TCHOCM = ZERO
         TCHOCT = ZERO
         TREBOM = ZERO
         TREBOT = ZERO
         TCHMAX = ZERO
         TCHMIN = 1.0D20
         IREBO  = 0
         ICHOC  = 0
         IDEBUT = 1
         IDEBUR = 1
         IFIN   = 1
C
         DO 10 I = 1,NBPT
C
           IF (ABS(FN(I)).LE.OFFSET) THEN
C
             IF (IREBO.EQ.1) THEN
               IFINR  = I
               TREBO  = T(IFINR) - T(IDEBUR)
               TREBOM = TREBOM + TREBO
               NBREBO = NBREBO + 1
             ENDIF
C
             IDECH = 0
               IF (ABS(FN(I+1)).GT.OFFSET) IDECH =1
C
             IF ( IDECH.EQ.0 .AND. ICHOC.EQ.1 ) THEN
C
               IFIN   = I
               TCHOC  = T(IFIN) - T(IDEBUT)
               TCHOCM = TCHOCM + TCHOC
C
               IF ( TCHOC.GT.TCHMAX ) TCHMAX = TCHOC
C
               IF ( TCHOC.LT.TCHMIN ) TCHMIN = TCHOC
C
               NBCHOC = NBCHOC + 1
               ICHOC  = 0
C
             ENDIF
C
             IREBO = 0
C
           ELSE
C
             IF (ICHOC.EQ.0) IDEBUT = I
C
             IF (IREBO.EQ.0) IDEBUR = I
             IREBO = 1
             ICHOC = 1
C
           ENDIF
C
 10      CONTINUE
C
         TCHOCT = TCHOCM
         IF (NBCHOC.NE.0) THEN
           TCHOCM=TCHOCM/NBCHOC
         ELSE
           TCHOCM = ZERO
         ENDIF
C
         TREBOT = TREBOM
         IF (NBREBO.NE.0) THEN
           TREBOM = TREBOM / NBREBO
         ELSE
           TREBOM = ZERO
         ENDIF
C
         END
