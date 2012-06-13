      SUBROUTINE TE0221(OPTION,NOMTE)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          COQUE 1D
C                          OPTION : 'RIGI_MECA      '
C                          ELEMENT: MECXSE3,METCSE3,METDSE3

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES),NOMPAR
      CHARACTER*8 ELREFE
      INTEGER ICODRE(NBRES)
      REAL*8 VALRES(NBRES),VALPAR
      REAL*8 DFDX(3),ZERO,UN,DEUX,TROIS,DOUZE
      REAL*8 TEST,TEST2,EPS,NU,H,COSA,SINA,COUR,R
      REAL*8 COEFXX,COEFYY,COEFXY,COEFF1,COEFF2
      REAL*8 CSS,CTT,CTS,DSS,DTS,DTT,BSS,BTT,BTS,VFI,VFJ
      REAL*8 C1,C2,C3,CONS,CONS2,JACP,KAPPA,CORREC
      INTEGER NNO,KP,NPG,IMATUU,ICACO
      INTEGER II,JJ,I,J,K,IJ1,IJ2,IJ3,KD1,KD2,KD3
      INTEGER IPOIDS,IVF,IDFDK,IGEOM,IMATE
      INTEGER NBPAR,IRET


      DATA ZERO,UN,DEUX,TROIS,DOUZE/0.D0,1.D0,2.D0,3.D0,12.D0/
      CALL ELREF1(ELREFE)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)
      EPS = 1.D-3




      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCACOQU','L',ICACO)
      H = ZR(ICACO)
      KAPPA = ZR(ICACO+1)
      CORREC = ZR(ICACO+2)

      CALL JEVECH('PMATERC','L',IMATE)
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      CALL JEVECH('PMATUUR','E',IMATUU)

      DO 90 KP = 1,NPG
        K = (KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     &              JACP,COSA,SINA)
        R = ZERO
        DO 10 I = 1,NNO
          R = R + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
   10   CONTINUE
C===============================================================
C     -- RECUPERATION DE LA TEMPERATURE POUR LE MATERIAU:

C     -- SI LA TEMPERATURE EST CONNUE AUX POINTS DE GAUSS :

        CALL MOYTPG('RIGI',KP,3,'+',VALPAR,IRET)
        NBPAR = 1
        NOMPAR = 'TEMP'
C===============================================================
        TEST = ABS(H*COUR/DEUX)
        IF (TEST.GE.UN) CORREC = ZERO
        CALL RCVALA(ZI(IMATE),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,ICODRE,1)

        NU = VALRES(2)
        COEFF1 = VALRES(1)/ (UN- (NU*NU))
        COEFF2 = VALRES(1)/ (UN+NU)

C     CALCUL DES COEFFICIENTS RIGIDITE COQUE AXI
C     COUR : COURBURE RS
C     H    : EPAISSEUR
C     COSA : COSINUS ANGLE ALPHA: NORMALE/ HORIZONTALE
C     R    : RAYON VECTEUR

        C1 = -COUR*H/ (UN- (COUR*H/DEUX)**2)
        IF (NOMTE.EQ.'MECXSE3') THEN
          C2 = -COSA*H/ (R**2- (COSA*H/DEUX)**2)
          IF (TEST.LE.EPS .OR. CORREC.EQ.ZERO) THEN
            CSS = COEFF1*H
            BSS = ZERO
            DSS = COEFF1*H**3/DOUZE
            GSS = COEFF2*KAPPA*H/DEUX
          ELSE
            CONS = LOG((UN+ (H*COUR/DEUX))/ (UN- (H*COUR/DEUX)))
            CSS = ((C1+CONS)*COSA/ (R*COUR**2)+CONS/COUR)
            BSS = - ((C1+DEUX*CONS-H*COUR)*COSA/ (R*COUR**3)+
     &            CONS/ (COUR**2)-H/COUR)*COEFF1
            DSS = ((CONS-H*COUR)/COUR**3+
     &            COSA* (C1+CONS*TROIS-DEUX*H*COUR)/ (COUR**4*R))*COEFF1
            GSS = CSS*COEFF2*KAPPA/DEUX
            CSS = CSS*COEFF1
          END IF
          TEST2 = ABS(H*COSA/ (DEUX*R))
          IF (TEST2.GE.UN) CORREC = ZERO
          IF (TEST2.LE.EPS .OR. CORREC.EQ.ZERO) THEN
            CTT = COEFF1*H
            BTT = ZERO
            DTT = COEFF1*H**3/DOUZE
          ELSE
            CONS2 = LOG((R+ (H*COSA/DEUX))/ (R- (H*COSA/DEUX)))
            C3 = R/COSA
            CTT = (CONS2*C3+COUR*C3*C3* (R*C2+CONS2))*COEFF1
            BTT = - (C3**3*C2*R*COUR+COUR*C3*C3* (DEUX*CONS2*C3-H)+
     &            C3* (C3*CONS2-H))*COEFF1
            DTT = (COUR*C3**4*R*C2-H*C3*C3* (UN+DEUX*COUR*C3)+
     &            CONS2*C3**3* (UN+TROIS*C3*COUR))*COEFF1
          END IF
          IF (ABS(COSA).LE.EPS .OR. ABS(COUR*R).LE.EPS .OR.
     &        ABS(COSA-COUR*R).LE.EPS .OR. CORREC.EQ.ZERO) THEN
            CTS = COEFF1*H
            BTS = ZERO
            DTS = COEFF1*H**3/DOUZE
          ELSE
            C3 = R/COSA
            CTS = ((COUR*R**2*CONS2-COSA**2*CONS/COUR)/
     &            (COSA* (COUR*R-COSA)))*COEFF1
            BTS = - (-H* (UN/COUR+C3)+COSA*CONS/
     &            (COUR**2* (COSA-COUR*R))+CONS2*COUR*COSA*C3**3/
     &            (R*COUR-COSA))*COEFF1
            DTS = (-H* (UN+C3*COUR+C3*C3*COUR*COUR)/COUR**2+
     &            CONS2*COUR*C3**3*R/ (R*COUR-COSA)-
     &            CONS/ (COUR**3* (COUR*C3-UN)))*COEFF1
          END IF
          JACP = JACP*R
        ELSE

C     CALCUL DES COEFFICIENTS RIGIDITE TRANCHE COQUE
C     CONTRAINTES PLANES ET DEFORMATIONS PLANES
C     COUR : COURBURE RS
C     H    : EPAISSEUR

          IF (NOMTE.EQ.'METDSE3 ') VALRES(1) = COEFF1
          IF (TEST.LE.EPS .OR. CORREC.EQ.ZERO) THEN
            CSS = VALRES(1)*H
            BSS = ZERO
            DSS = VALRES(1)*H**3/DOUZE
            GSS = COEFF2*KAPPA*H/DEUX
          ELSE
            CONS = LOG((UN+ (H*COUR/DEUX))/ (UN- (H*COUR/DEUX)))
            CSS = CONS/COUR
            BSS = - (H*COUR**2-CONS*COUR)*VALRES(1)/ (COUR**3)
            DSS = (CONS-H*COUR)*VALRES(1)/ (COUR**3)
            GSS = CSS*KAPPA*COEFF2/DEUX
            CSS = CSS*VALRES(1)
          END IF
        END IF

        COEFXX = SINA*SINA
        COEFYY = COSA*COSA
        COEFXY = -COSA*SINA
        KD1 = 5
        KD2 = 3
        KD3 = 2
        DO 50 I = 1,3*NNO,3
          KD1 = KD1 + 3*I - 6
          KD2 = KD2 + 3*I - 3
          KD3 = KD3 + 3*I
          II = (I+2)/3
          DO 30 J = 1,I,3
            JJ = (J+2)/3
            IJ1 = IMATUU + KD1 + J - 3
            IJ2 = IMATUU + KD2 + J - 3
            IJ3 = IMATUU + KD3 + J - 3
            VFI = ZR(IVF+K+II-1)
            VFJ = ZR(IVF+K+JJ-1)
            ZR(IJ1) = ZR(IJ1) + DFDX(II)*DFDX(JJ)*JACP*
     &                (COEFXX*CSS+COEFYY*GSS)
            ZR(IJ2) = ZR(IJ2) + DFDX(II)*DFDX(JJ)*JACP*COEFXY* (CSS-GSS)
            ZR(IJ2+1) = ZR(IJ2+1) + DFDX(II)*DFDX(JJ)*JACP*
     &                  (COEFYY*CSS+COEFXX*GSS)
            ZR(IJ3) = ZR(IJ3) + DFDX(JJ)*JACP*
     &                (COSA*GSS*VFI+SINA*BSS*DFDX(II))
            ZR(IJ3+1) = ZR(IJ3+1) - DFDX(JJ)*JACP*
     &                  (COSA*BSS*DFDX(II)-SINA*GSS*VFI)
            ZR(IJ3+2) = ZR(IJ3+2) + JACP*
     &                  (DSS*DFDX(II)*DFDX(JJ)+GSS*VFI*VFJ)
   30     CONTINUE
          DO 40 J = 1,I - 3,3
            JJ = (J+2)/3
            IJ1 = IMATUU + KD1 + J - 3
            IJ2 = IMATUU + KD2 + J - 3
            VFI = ZR(IVF+K+II-1)
            VFJ = ZR(IVF+K+JJ-1)
            ZR(IJ1+1) = ZR(IJ1+1) + DFDX(II)*DFDX(JJ)*JACP*COEFXY*
     &                  (CSS-GSS)
            ZR(IJ1+2) = ZR(IJ1+2) + DFDX(II)*JACP*
     &                  (COSA*GSS*VFJ+SINA*BSS*DFDX(JJ))
            ZR(IJ2+2) = ZR(IJ2+2) + DFDX(II)*JACP*
     &                  (SINA*GSS*VFJ-COSA*BSS*DFDX(JJ))
   40     CONTINUE
   50   CONTINUE

        IF (NOMTE(3:4).EQ.'CX') THEN
          KD1 = 5
          KD2 = 3
          KD3 = 2
          DO 80 I = 1,3*NNO,3
            KD1 = KD1 + 3*I - 6
            KD2 = KD2 + 3*I - 3
            KD3 = KD3 + 3*I
            II = (I+2)/3
            DO 60 J = 1,I,3
              JJ = (J+2)/3
              IJ1 = IMATUU + KD1 + J - 3
              IJ2 = IMATUU + KD2 + J - 3
              IJ3 = IMATUU + KD3 + J - 3
              VFI = ZR(IVF+K+II-1)
              VFJ = ZR(IVF+K+JJ-1)
              ZR(IJ1) = ZR(IJ1) + JACP* (CTT*VFI*VFJ/ (R*R)-
     &                  NU*CTS*SINA* (DFDX(II)*VFJ+DFDX(JJ)*VFI)/R)
              ZR(IJ2) = ZR(IJ2) + JACP*NU*CTS*COSA*DFDX(II)*VFJ/R
              ZR(IJ3) = ZR(IJ3) + JACP*NU*BTS*DEUX*
     &                  (COEFXX*VFI*DFDX(JJ)-DFDX(II)*VFJ)/R -
     &                  JACP*BTT*SINA*VFI*VFJ/R
              ZR(IJ3+1) = ZR(IJ3+1) + JACP*NU*BTS*DEUX*COEFXY*DFDX(JJ)*
     &                    VFI/R
              ZR(IJ3+2) = ZR(IJ3+2) + JACP*SINA*
     &                    (DTT*SINA*VFI*VFJ/ (R*R)+
     &                    NU*DTS* (VFI*DFDX(JJ)+DFDX(II)*VFJ)/R)
   60       CONTINUE
            DO 70 J = 1,I - 3,3
              JJ = (J+2)/3
              IJ1 = IMATUU + KD1 + J - 3
              IJ2 = IMATUU + KD2 + J - 3
              VFI = ZR(IVF+K+II-1)
              VFJ = ZR(IVF+K+JJ-1)
              ZR(IJ1+1) = ZR(IJ1+1) + JACP*NU*CTS*COSA*DFDX(JJ)*VFI/R
              ZR(IJ1+2) = ZR(IJ1+2) + JACP*NU*BTS*DEUX*
     &                    (COEFXX*VFJ*DFDX(II)-DFDX(JJ)*VFI)/R -
     &                    JACP*BTT*SINA*VFJ*VFI/R
              ZR(IJ2+2) = ZR(IJ2+2) + JACP*NU*BTS*DEUX*COEFXY*DFDX(II)*
     &                    VFJ/R
   70       CONTINUE
   80     CONTINUE
        END IF

   90 CONTINUE
      END
