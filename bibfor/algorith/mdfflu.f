      SUBROUTINE MDFFLU( DNORM,VNORM,ANORM,VITLOC,ACCLOC, COST,SINT,
     +                   COEFA, COEFB, COEFC, COEFD, FFLUID, FLOCAL )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C***********************************************************************
C 01/01/91    G.JACQUART AMV/P61 47 65 49 41
C***********************************************************************
C     FONCTION  : CALCULE LA FORCE FLUIDE NORMALE A L'OBSTACLE
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C        NOCM       MODE                    ROLE
C  ________________ ____ ______________________________________________
C                         VARIABLES DU SYSTEME DYNAMIQUE MODAL
C  ________________ ____ ______________________________________________
C    DNORM          <--   DISTANCE NORMALE
C    VNORM          -->   VITESSE  NORMALE
C    ANORM          -->   ACCELERATION NORMALE
C    VITLOC         <--   VITESSE DANS LE REPERE LOCAL
C    ACCLOC         <--   ACCELERATION DANS LE REPERE LOCAL
C    COST,SINT      <--   DIRECTION DE LA NORMALE A L'OBSTACLE
C    COEFA          <--   COEFFICIENT DE MASSE AJOUTEE
C    COEFB          <--   COEFFICIENT DE PERTE DE CHARGE >0
C    COEFC          <--   COEFFICIENT DE FORCE VISQUEUSE
C    COEFD          <--   COEFFICIENT DE PERTE DE CHARGE <0
C    CNORM          <--   AMORTISSEUR NORMALE DE CHOC
C    FFLUID          -->  FORCE NORMALE FLUIDE
C    FLOCAL          -->  FORCE NORMALE DE CHOC REP. LOCAL
C-----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 VITLOC(3),ACCLOC(3),FLOCAL(3),FFLUID
      REAL*8 COEFA, COEFB, COEFC, COEFD, COST, SINT
C-----------------------------------------------------------------------
      REAL*8 ANORM ,DNORM ,VNORM 
C-----------------------------------------------------------------------
      VNORM = VITLOC(2)*COST + VITLOC(3)*SINT
      ANORM = ACCLOC(2)*COST + ACCLOC(3)*SINT
      FFLUID = COEFA*ANORM/DNORM + COEFB*(VNORM/DNORM)**2
     +     + COEFC*VNORM/DNORM**3 + COEFD*VNORM*ABS(VNORM)/DNORM/DNORM
      FLOCAL(1)=0.D0
      FLOCAL(2)=FFLUID*COST
      FLOCAL(3)=FFLUID*SINT
      END
