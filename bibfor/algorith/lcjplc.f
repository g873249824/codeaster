        SUBROUTINE LCJPLC ( LOI  ,MOD , NMAT, MATER, 
     &            TIMED, TIMEF, COMP,NBCOMM, CPMONO, PGL,NR,NVI,
     &                  SIGF,VINF,SIGD,VIND, 
     &                   DSDE )
        IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C       MATRICE SYMETRIQUE DE COMPORTEMENT TANGENT ELASTO-PLASTIQUE OU
C       VISCO-PLASTIQUE COHERENT A T+DT OU T
C       COHERENT A T+DT OU T
C       IN  LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION MATER
C           MATER  :  COEFFICIENTS MATERIAU
C       OUT DSDE   :  MATRICE DE COMPORTEMENT TANGENT = DSIG/DEPS
C       ----------------------------------------------------------------
        INTEGER         NMAT , NMOD, NR, NVI
        REAL*8          DSDE(6,6)
        REAL*8          MATER(NMAT,2)
        CHARACTER*3     INST
        CHARACTER*8     MOD
        CHARACTER*16    LOI
      
      INTEGER         NBCOMM(NMAT,3)
      REAL*8  SIGF(*),SIGD(*),VIND(*),VINF(*),TIMED,TIMEF,PGL(3,3)
      CHARACTER*16    CPMONO(5*NMAT+1),COMP(*)
C       ----------------------------------------------------------------
         IF     ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
            CALL  CVMJPL (MOD,NMAT,MATER,DSDE)
         ELSEIF ( LOI(1:5) .EQ. 'LMARC'     ) THEN
            CALL  LMAJPL (MOD,NMAT,MATER,DSDE)
         ELSEIF ( LOI(1:8) .EQ. 'MONOCRIS'     ) THEN
            CALL  LCMMJP (MOD,NMAT,MATER,
     &            TIMED, TIMEF, COMP,NBCOMM, CPMONO, PGL,NR,NVI,
     &                  SIGF,VINF,SIGD,VIND, 
     &                   DSDE )
         ENDIF
C
         END
