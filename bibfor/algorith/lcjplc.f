        SUBROUTINE LCJPLC (LOI,MOD,NMAT,MATER,TIMED,TIMEF,COMP,
     &                     NBCOMM,CPMONO,PGL,NFS,NSG,TOUTMS,HSR,
     &                     NR,NVI,EPSD,DEPS,ITMAX,TOLER,SIGF,VINF,
     &                     SIGD,VIND,DSDE,DRDY,OPTION,IRET)
        IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/02/2013   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C       ----------------------------------------------------------------
C       MATRICE SYMETRIQUE DE COMPORTEMENT TANGENT ELASTO-PLASTIQUE OU
C       VISCO-PLASTIQUE COHERENT A T+DT OU T
C       COHERENT A T+DT OU T
C       IN  FAMI   :  FAMILLE DES POINTS DE GAUSS
C           KPG    :  NUMERO DU POINT DE GAUSS
C           KSP    :  NUMERO DU SOUS POINT DE GAUSS
C           LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION MATER
C           MATER  :  COEFFICIENTS MATERIAU
C       OUT DSDE   :  MATRICE DE COMPORTEMENT TANGENT = DSIG/DEPS
C       ----------------------------------------------------------------
        INTEGER         NMAT , NR, NVI, ITMAX, IRET, NFS, NSG,NDT,NDI,N2
        REAL*8          DSDE(6,6),EPSD(*),DEPS(*),TOLER
        REAL*8          MATER(NMAT,2)
        REAL*8 TOUTMS(NFS,NSG,6),HSR(NSG,NSG)
        CHARACTER*8     MOD
        CHARACTER*16    LOI,OPTION
      COMMON /TDIM/   NDT  , NDI

      INTEGER         NBCOMM(NMAT,3)
      REAL*8  SIGF(*),SIGD(*),VIND(*),VINF(*),TIMED,TIMEF,PGL(3,3)
      REAL*8  DRDY(NR,NR)
      CHARACTER*16    COMP(*)
      CHARACTER*24    CPMONO(5*NMAT+1)
C       ----------------------------------------------------------------
       IRET=0
         IF     ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
            CALL  CVMJPL (MOD,NMAT,MATER,
     &        TIMED, TIMEF,EPSD,DEPS,SIGF,VINF,SIGD,VIND,NVI,NR,DSDE)
         ELSEIF ( LOI(1:8) .EQ. 'MONOCRIS'     ) THEN
            CALL  LCMMJP (MOD,NMAT,MATER,TIMED, TIMEF, COMP,
     &                    NBCOMM, CPMONO, PGL,NFS,NSG,TOUTMS,HSR,
     &                    NR,NVI,ITMAX,TOLER,VINF,VIND,
     &                    DSDE , DRDY, OPTION, IRET)
         ELSEIF ( LOI(1:15) .EQ. 'BETON_BURGER_FP' ) THEN
            CALL BURJPL(NMAT,MATER,NR,DRDY,DSDE)
         ELSEIF ( LOI(1:4) .EQ. 'LETK' ) THEN
            CALL LKIJPL(NMAT,MATER,SIGF,NR,DRDY,DSDE)
         ELSE
            N2=NR-NDT
            CALL LCOPTG(NMAT,MATER,NR,N2,DRDY,DSDE,IRET)
         ENDIF
C
         END
