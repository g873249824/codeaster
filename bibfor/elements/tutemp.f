      SUBROUTINE TUTEMP(OPTION,NOMTE,NBRDDL,F,B,VOUT,PASS,VTEMP)
      IMPLICIT NONE
C MODIF ELEMENTS  DATE 21/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION
C ......................................................................

C    - FONCTION REALISEE:  CALCUL DU SECOND MEMBRE : TRAVAIL DE LA
C                          DILATATION THERMIQUE
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C ......................................................................

      INTEGER NBRDDL,NBSECM,NBCOUM
      PARAMETER (NBSECM=32,NBCOUM=10)
      REAL*8 H,A,L,VALPAR,BETA,R
      REAL*8 POICOU(2*NBCOUM+1),POISEC(2*NBSECM+1)
      REAL*8 F(NBRDDL),B(4,NBRDDL),VOUT(NBRDDL),SIG(4)
      REAL*8 PI,DEUXPI,FI,E,NU,VALRES(3)
      REAL*8 PGL(3,3),PGL1(3,3),PGL2(3,3),PGL3(3,3),OMEGA
      REAL*8 C(2,2),COE1,PGL4(3,3)
      REAL*8 POIDS,R8PI,RAYON,THETA,SINFI,XPG(4)
      REAL*8 VTEMP(NBRDDL),PASS(NBRDDL,NBRDDL)
      INTEGER CODRES(3)
      CHARACTER*8 NOMRES(3),NOMPAR
      CHARACTER*16 PHENOM,NOMTE
      INTEGER NNO,NPG,NBCOU,NBSEC,M,LORIEN,ICOUDE,I
      INTEGER IPOIDS,IVF,ICOU,NBPAR
      INTEGER ICAGEP,IGEOM,JOUT,IMATE,J
      INTEGER IGAU,ISECT,ICOUD2,MMT,NSPG
      INTEGER JNBSPI,IRET,IRET2
      INTEGER NDIM,NNOS,JCOOPG,IDFDK,JDFD2,JGANO

      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,JCOOPG,IVF,IDFDK,
     &            JDFD2,JGANO)

      PI = R8PI()
      DEUXPI = 2.D0*PI

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
      NBSEC = ZI(JNBSPI-1+2)


      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCAGEPO','L',ICAGEP)
      CALL JEVECH('PCAORIE','L',LORIEN)
      H = ZR(ICAGEP+1)
      A = ZR(ICAGEP) - H/2.D0

C A= RMOY, H = EPAISSEUR
C RINT = RAYON INTERIEUR


      M = 3
      IF (NOMTE.EQ.'MET6SEG3') M = 6


      DO 10 I = 1,NPG
        XPG(I) = ZR(JCOOPG-1+I)
   10 CONTINUE


C     LES POIDS POUR L'INTEGRATION DANS L'EPAISSEUR

      POICOU(1) = 1.D0/3.D0
      DO 20 I = 1,NBCOU - 1
        POICOU(2*I) = 4.D0/3.D0
        POICOU(2*I+1) = 2.D0/3.D0
   20 CONTINUE
      POICOU(2*NBCOU) = 4.D0/3.D0
      POICOU(2*NBCOU+1) = 1.D0/3.D0

C     LES POIDS POUR L'INTEGRATION SUR LA CIRCONFERENCE

      POISEC(1) = 1.D0/3.D0
      DO 30 I = 1,NBSEC - 1
        POISEC(2*I) = 4.D0/3.D0
        POISEC(2*I+1) = 2.D0/3.D0
   30 CONTINUE
      POISEC(2*NBSEC) = 4.D0/3.D0
      POISEC(2*NBSEC+1) = 1.D0/3.D0

C     FIN DES POIDS D'INTEGRATION

C CALCUL DE L = LONGUEUR DU COUDE

      CALL CARCOU(ZR(LORIEN),L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,NNO,
     &            OMEGA,ICOUD2)

      IF (ICOUD2.GE.10) THEN
        ICOUDE = ICOUD2 - 10
        MMT = 0
      ELSE
        ICOUDE = ICOUD2
        MMT = 1
      END IF

C---- RECUPERATION TEMPERATURE
C===============================================================
C          -- RECUPERATION DE LA TEMPERATURE :
C     -- SI LA TEMPERATURE N'EST PAS DONNEE:
      NSPG=(2*NBSEC + 1)*(2*NBCOU + 1)
      IRET2=0
      CALL MOYTEM('RIGI',NPG,NSPG,'+',VALPAR,IRET2)
      NBPAR = 1
      NOMPAR = 'TEMP'
C===============================================================

C---- RECUPERATION DU COMPORTEMENT

      CALL JEVECH('PMATERC','L',IMATE)
      CALL RCCOMA(ZI(IMATE),'ELAS',1,PHENOM,CODRES)
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'

      CALL RCVALB('RIGI',1,1,'+',ZI(IMATE),' ',PHENOM,
     &            NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &            VALRES,CODRES,1)
      E = VALRES(1)
      NU = VALRES(2)


C DEFINITION DE LA MATRICE DE COMPORTEMENT C
C POUR LA DILATATION

      BETA = 1.D0/ (1.D0-NU**2)

      C(1,1) = E*BETA
      C(1,2) = E*NU*BETA

      C(2,1) = E*NU*BETA
      C(2,2) = E*BETA


C     FIN DE LA CONSTRUCTION DE LA MATRICE DE COMPORTEMENT C

      IF (OPTION.EQ.'CHAR_MECA_TEMP_R') THEN

C----- CAS DILATATION THERMIQUE

C===============================================================



        DO 80,I = 1,NBRDDL
          F(I) = 0.D0
   80   CONTINUE

C     DEBUT CONSTRUCTION DE B

C BOUCLE SUR LES POINTS DE GAUSS
        NSPG=(2*NBSEC + 1)*(2*NBCOU + 1)
        DO 130 IGAU = 1,NPG
C ATTENTION IRET NON INITIALISE PAR VERIFG
          IRET=0
          CALL VERIFG('RIGI',IGAU,NSPG,'+',ZI(IMATE),'ELAS',1,COE1,IRET)
          IF (IRET.NE.0) COE1=0.D0
          SIG(1) = (C(1,1)+C(1,2))*COE1
          SIG(2) = (C(2,1)+C(2,2))*COE1
          SIG(3) = 0.D0
          SIG(4) = 0.D0

C BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR

          DO 120 ICOU = 1,2*NBCOU + 1
            IF (MMT.EQ.0) THEN
              R = A
            ELSE
              R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
            END IF


C BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE

            DO 110 ISECT = 1,2*NBSEC + 1
              IF (ICOUDE.EQ.0) THEN
                CALL BCOUDE(IGAU,ICOU,ISECT,L,H,A,M,NNO,NBCOU,
     &                      NBSEC,ZR(IVF),ZR(IDFDK),ZR(JDFD2),MMT,B)
              ELSE IF (ICOUDE.EQ.1) THEN
                FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)

                SINFI = SIN(FI)
                L = THETA* (RAYON+R*SINFI)
                CALL BCOUDC(IGAU,ICOU,ISECT,H,A,M,OMEGA,XPG,NNO,
     &                      NBCOU,NBSEC,ZR(IVF),ZR(IDFDK),ZR(JDFD2),
     &                      RAYON,THETA,MMT,B)
              END IF

              DO 90 J = 1,NBRDDL
                VOUT(J) = B(1,J)*SIG(1) + B(2,J)*SIG(2)
   90         CONTINUE


C  STOCKAGE DU VECTEUR VOUT DANS FI

              POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R

              DO 100 I = 1,NBRDDL
                F(I) = F(I) + VOUT(I)*POIDS
  100         CONTINUE

C  FIN STOCKAGE

  110       CONTINUE
  120     CONTINUE
  130   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,F,'LG',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,F,'LG',PASS,VTEMP)
        END IF
        CALL JEVECH('PVECTUR','E',JOUT)
        DO 140,I = 1,NBRDDL
          ZR(JOUT-1+I) = F(I)
  140   CONTINUE
      END IF
      END
