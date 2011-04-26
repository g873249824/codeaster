      SUBROUTINE DGPLAS(EA,SYA,EB,NUB,SYTB,NUM,NUF,A,B1,B,SYT,SYF,
     &                  DXD,DRD,H,IPENTE,ICISAI,EMAXM,EMAXF,NNAP,RX,
     &                  RY,NP,DXP,PENDT,DRP,MP,PENDF)

      IMPLICIT NONE

C PARAMETRES ENTRANTS
      INTEGER NNAP,ILIT,ICISAI,IPENTE

      REAL*8 EA(*),SYA(*),EB,NUB,NUM,NUF,W,EMAXM,EMAXF
      REAL*8 A,B1,B,SYT,SYF,DXD,DRD,H,C,RX(*),RY(*)
      REAL*8 RMESG(2),SYTB

C PARAMETRES SORTANTS
      REAL*8 PENDT,PENDF


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRP_21
C ----------------------------------------------------------------------
C
C BUT : DETERMINATION DES PENTES POST ENDOMMAGEMENT
C
C IN:
C       EA       : MODULES D YOUNG DES ACIERS
C       SYA      : LIMITES ELASTIQUES DES ACIERS
C       EB       : MODULE D YOUNG DU BETON
C       NUB      : COEFF DE POISSON DU BETON
C       SYTB     : LIMITE A LA TRACTION DU BETON
C       NUM      : COEFF DE POISSON EN MEMBRANE
C       NUF      : COEFF DE POISSON EN FLEXION
C       A
C       B1
C       B        : SECTIONS DES ACIERS
C       SYT      : SEUIL D'ENDOMMAGEMENT EN TRACTION
C       SYF      : SEUIL D'ENDOMMAGEMENT EN FLEXION
C       DXD      : DEPLACEMENT A L'APPARITION DE L'ENDOMMAGEMENT
C       DRD      : ROTATION A L'APPARITION DE L'ENDOMMAGEMENT
C       H        : EPAISSEUR DE LA PLAQUE
C       IPENTE   : OPTION DE CALCUL DES PENTES POST ENDOMMAGEMENT
C                  1 : RIGI_ACIER
C                  2 : PLAS_ACIER
C                  3 : UTIL
C       ICISAI   : INDICATEUR DE CISAILLEMENT
C       EMAXM    : DEFO GENE MAX EN MEMBRANE
C       EMAXF    : DEFO GENE MAX EN FLEXION
C       NNAP     : NOMBRE DE NAPPE
C       RX       : POSITION ADIMENSIONNEE DU LIT DE CABLES SUIVANT X
C       RY       : POSITION ADIMENSIONNEE DU LIT DE CABLES SUIVANT Y
C       NP       : EFFORT A PLASTICITE
C       DXP      : DEPLACEMENT A PLASTICITE
C       DRP      : ROTATION A PLASTICITE
C       MP       : MOMENT A PLASTICITE
C
C OUT:
C       PENDT    : PENTE POST ENDOMMAGEMENT EN MEMBRANNE
C       PENDF    : PENTE POST ENDOMMAGEMENT EN FLEXION
C ----------------------------------------------------------------------

      REAL*8 NP,DXP,MP,DRP

C - DETERMINATION DE LA PENTE POST ENDOMMAGEMENT EN MEMBRANNE
      IF (IPENTE .EQ. 3) THEN
        IF (EMAXM .LT. DXD) THEN
          RMESG(1)=EMAXM
          RMESG(2)=DXD
          CALL U2MESR('F','ALGORITH6_5',2,RMESG)
        ENDIF
        DXP=EMAXM
        NP=B*DXP
        PENDT=(NP-SYT)/(DXP-DXD)
      ELSEIF (IPENTE .EQ. 1) THEN
        PENDT=B
      ELSEIF (IPENTE .EQ. 2) THEN
        DXP=SYA(1)/EA(1)
          DO 10, ILIT = 1,NNAP
            IF (SYA(ILIT)/EA(ILIT) .LT. DXP) THEN
              DXP=SYA(ILIT)/EA(ILIT)
            ENDIF
 10      CONTINUE
        NP=B*DXP
        PENDT=(NP-SYT)/(DXP-DXD)
      ENDIF

C - ESSAI DE CISAILLEMENT PUR DANS LE PLAN
      IF (ICISAI .EQ. 1) THEN
        IF (IPENTE .EQ. 1) THEN
          PENDT=B
        ELSEIF (IPENTE .EQ. 3) THEN
          IF (EMAXM .LT. DXD) THEN
            RMESG(1)=EMAXM
            RMESG(2)=DXD
            CALL U2MESR('F','ALGORITH6_5',2,RMESG)
          ENDIF
          DXP=EMAXM
          NP=B*DXD+SYTB/3.D0
        ELSEIF (IPENTE .EQ. 2) THEN
          DXP=SQRT(2.D0)*DXP+2.D0*DXD
          NP=B*DXP+SYTB/3.D0
        ENDIF
      ENDIF

C - DETERMINATION DE LA PENTE POST ENDOMMAGEMENT EN FLEXION
      IF (IPENTE .EQ. 3) THEN
        IF (EMAXF .LT. DRD) THEN
          RMESG(1)=EMAXF
          RMESG(2)=DRD
          CALL U2MESR('F','ALGORITH6_5',2,RMESG)
        ENDIF
        DRP=EMAXF
        CALL DGMMAX(EB,NUB,NUM,NUF,H,A,B1,B,MP,DRP,W,C)
        PENDF=(MP-SYF)/(DRP-DRD)
      ELSEIF (IPENTE .EQ. 1) THEN
        CALL DGMMAX(EB,NUB,NUM,NUF,H,A,B1,B,MP,DRP,W,C)
        PENDF=C
      ELSE IF (IPENTE .EQ. 2) THEN
        CALL DGMPLA(EB,NUB,EA,SYA,NUM,NUF,H,A,B1,B,NNAP,RX,RY,MP,
     &              DRP,W)
        PENDF=(MP-SYF)/(DRP-DRD)
      ENDIF

      END
