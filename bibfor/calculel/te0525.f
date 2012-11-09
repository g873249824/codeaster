      SUBROUTINE TE0525(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
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

      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 NOMTE,OPTION
C ----------------------------------------------------------------------

C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_TNL'
C                          ELEMENTS 3D ISO PARAMETRIQUES
C                            - PROBLEME  DE  TRANSPORT  -

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT



      REAL*8 ULOC(3,50),UL(3,50),JACOB(50),RBID,RR,TPG
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS,XKPT,XKPTT(50)
      REAL*8 DTPGDX(50),DTPGDY(50),DTPGDZ(50),VECT(50)
      REAL*8 DBPGDX(50),DBPGDY(50),DBPGDZ(50),DUPGDZ(50)
      REAL*8 BETAA,TPN,BETAI,DUPGDX(50),DUPGDY(50),RES(50)
      REAL*8 XR,XRR,XAUX,TPG0,XK0,PN,PNP1,XK1
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO,NNO,KP,NPG1,I,IVECTT,ITEMPS,IFON(3)
      INTEGER ITEMP,ITEMPI,ILAGRM,IVITE,ILAGRP,IVERES
      INTEGER NBVF,JVALF,K,L,IDIM,NDIM,NNOS

C DEB ------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PLAGRM ','L',ILAGRM)
      CALL JEVECH('PVITESR','L',IVITE)
      CALL JEVECH('PLAGRP ','E',ILAGRP)
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PRESIDU','E',IVERES)

      CALL NTFCMA(ZI(IMATE),IFON)
      NBVF = ZI(IFON(1))
      JVALF = ZI(IFON(1)+2)
      XR = 0.D0
      DO 10 I = 1,NBVF
        XAUX = ZR(JVALF+I-1)
        CALL RCFODI(IFON(1),XAUX,RBID,XRR)
        IF (XRR.GT.XR) THEN
          XR = XRR
        END IF
   10 CONTINUE
      RR = 0.6D0/XR

      K = 0
      DO 30 I = 1,NNO
        DO 20 IDIM = 1,3
          K = K + 1
          ULOC(IDIM,I) = ZR(IVITE+K-1)
   20   CONTINUE
   30 CONTINUE

      DO 50 KP = 1,NPG1
        UL(1,KP) = 0.D0
        UL(2,KP) = 0.D0
        UL(3,KP) = 0.D0
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        TPG = 0.D0
        TPG0 = 0.D0
        DTPGDX(KP) = 0.D0
        DTPGDY(KP) = 0.D0
        DTPGDZ(KP) = 0.D0

        DO 40 I = 1,NNO
          TPG  = TPG  + ZR(ITEMPI+I-1)*ZR(IVF+L+I-1)
          TPG0 = TPG0 +  ZR(ITEMP+I-1)*ZR(IVF+L+I-1)
          UL(1,KP) = UL(1,KP) + ULOC(1,I)*ZR(IVF+L+I-1)
          UL(2,KP) = UL(2,KP) + ULOC(2,I)*ZR(IVF+L+I-1)
          UL(3,KP) = UL(3,KP) + ULOC(3,I)*ZR(IVF+L+I-1)
          DTPGDX(KP) = DTPGDX(KP) + ZR(ITEMPI+I-1)*DFDX(I)
          DTPGDY(KP) = DTPGDY(KP) + ZR(ITEMPI+I-1)*DFDY(I)
          DTPGDZ(KP) = DTPGDZ(KP) + ZR(ITEMPI+I-1)*DFDZ(I)
   40   CONTINUE

        CALL RCFODE(IFON(2),TPG,XK1,XKPT)
        CALL RCFODE(IFON(2),TPG0,XK0,XKPT)
        PN = ZR(ILAGRM+KP-1)
        CALL RCFODI(IFON(1),PN,BETAA,RBID)
        PNP1 = PN + ((TPG-BETAA)*RR)
        ZR(ILAGRP+KP-1) = PNP1
        VECT(KP) = PNP1
        JACOB(KP) = POIDS
        XKPTT(KP) = XK1 - XK0
   50 CONTINUE
      CALL PROJET(3,NPG1,NNO,VECT,RES)

      DO 70 KP = 1,NPG1
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        DBPGDX(KP) = 0.D0
        DBPGDY(KP) = 0.D0
        DBPGDZ(KP) = 0.D0
        DUPGDX(KP) = 0.D0
        DUPGDY(KP) = 0.D0
        DUPGDZ(KP) = 0.D0

        DO 60 I = 1,NNO
          DUPGDX(KP) = DUPGDX(KP) + RES(I)*DFDX(I)
          DUPGDY(KP) = DUPGDY(KP) + RES(I)*DFDY(I)
          DUPGDZ(KP) = DUPGDZ(KP) + RES(I)*DFDZ(I)
          TPN = RES(I)
          CALL RCFODI(IFON(1),TPN,BETAI,RBID)
          DBPGDX(KP) = DBPGDX(KP) + BETAI*DFDX(I)
          DBPGDY(KP) = DBPGDY(KP) + BETAI*DFDY(I)
          DBPGDZ(KP) = DBPGDZ(KP) + BETAI*DFDZ(I)
   60   CONTINUE

   70 CONTINUE

      DO 90 KP = 1,NPG1
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

        DO 80 I = 1,NNO
          ZR(IVERES+I-1) = ZR(IVERES+I-1) +
     &                     JACOB(KP)*ZR(IVF+L+I-1)* (RR*
     &                     (UL(1,KP)*DBPGDX(KP)+UL(2,
     &                     KP)*DBPGDY(KP)+UL(3,KP)*DBPGDZ(KP))-
     &                     (UL(1,KP)*DUPGDX(KP)+UL(2,
     &                     KP)*DUPGDY(KP)+UL(3,KP)*DUPGDZ(KP))) +
     &                     JACOB(KP)*XKPTT(KP)* (DFDX(I)*DTPGDX(KP)+
     &                     DFDY(I)*DTPGDY(KP)+DFDZ(I)*DTPGDZ(KP))

   80   CONTINUE

   90 CONTINUE

C FIN ------------------------------------------------------------------
      END
