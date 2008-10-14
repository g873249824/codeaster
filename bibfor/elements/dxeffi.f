      SUBROUTINE DXEFFI ( NOMTE, XYZL, PGL, CONT, IND, EFFINT )
      IMPLICIT  NONE
      REAL*8              XYZL(3,*), PGL(3,3), CONT(*), EFFINT(*)
      CHARACTER*16        NOMTE
      INTEGER             IND
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     IN  NOMTE  : NOM DE L'ELEMENT TRAITE
C     IN  XYZL   : COORDONNEES DES NOEUDS
C     IN  UL     : DEPLACEMENT A L'INSTANT T
C     IN  IND    : =6 : 6 CMP D'EFFORT PAR NOEUD
C     IN  IND    : =8 : 8 CMP D'EFFORT PAR NOEUD
C     OUT EFFINT : EFFORTS INTERNES
C     ------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER  NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER  NBCON, NBCOU, NPGH, K, INO, IPG, ICOU, IGAUH, ICPG,
     &         ICACOQ, JNBSPI, JDEPL, IMATE, IADZI, IAZK24
      REAL*8   HIC, H, ZIC, ZMIN, COEF, ZERO, DEUX, DISTN, COEHSD,
     &         CDF, KHI(3), N(3), M(3), BF(3,9), MG(3), DH(9), DMF(9),
     &         UF(3,3), UL(6,3), ROT(9)
      REAL*8   QSI, ETA, CARAT3(21)
      CHARACTER*24 NOMELE
C     ------------------------------------------------------------------
C
      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     &                                         IVF,IDFDX,IDFD2,JGANO)
C
      ZERO = 0.0D0
      DEUX = 2.0D0
C
C     RECUPERATION DES OBJETS &INEL ET DES CHAMPS PARAMETRES :
C     --------------------------------------------------------
      IF (NOMTE(1:8).NE.'MEDKTR3 ' .AND.
     &        NOMTE(1:8).NE.'MEDSTR3 ' .AND.
     &        NOMTE(1:8).NE.'MEDKQU4 ' .AND.
     &        NOMTE(1:8).NE.'MEDSQU4 ' .AND.
     &        NOMTE(1:8).NE.'MEQ4QU4 ' ) THEN
         CALL U2MESK('F','ELEMENTS_34',1,NOMTE)
      END IF

      CALL JEVECH ( 'PNBSP_I', 'L', JNBSPI )
      NBCON = 6
      NBCOU = ZI(JNBSPI-1+1)
      IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_46')

C     -- GRANDEURS GEOMETRIQUES :
C     ---------------------------
      CALL JEVECH ( 'PCACOQU', 'L', ICACOQ )
      H = ZR(ICACOQ)
      HIC = H/NBCOU
      NPGH = 3
      DISTN = ZR(ICACOQ+4)
      ZMIN = -H/DEUX + DISTN

      CALL R8INIR ( 32, ZERO, EFFINT, 1 )

C===============================================================
C     -- BOUCLE SUR LES POINTS DE GAUSS DE LA SURFACE:
C     -------------------------------------------------
      DO 100, IPG = 1,NPG
         CALL R8INIR ( 3, ZERO, N, 1 )
         CALL R8INIR ( 3, ZERO, M, 1 )

         DO 110, ICOU = 1,NBCOU
            DO 120, IGAUH = 1,NPGH
               ICPG = NBCON*NPGH*NBCOU*(IPG-1) + NBCON*NPGH*(ICOU-1) +
     &                                           NBCON*(IGAUH-1)
               IF (IGAUH.EQ.1) THEN
                  ZIC = ZMIN + (ICOU-1)*HIC
                  COEF = 1.D0/3.D0
               ELSE IF (IGAUH.EQ.2) THEN
                  ZIC = ZMIN + HIC/2.D0 + (ICOU-1)*HIC
                  COEF = 4.D0/3.D0
               ELSE
                  ZIC = ZMIN + HIC + (ICOU-1)*HIC
                  COEF = 1.D0/3.D0
               END IF
C
C         -- CALCUL DES EFFORTS RESULTANTS DANS L'EPAISSEUR (N ET M) :
C         ------------------------------------------------------------
               COEHSD = COEF*HIC/2.D0
               N(1) = N(1) + COEHSD*CONT(ICPG+1)
               N(2) = N(2) + COEHSD*CONT(ICPG+2)
               N(3) = N(3) + COEHSD*CONT(ICPG+4)
               M(1) = M(1) + COEHSD*ZIC*CONT(ICPG+1) 
               M(2) = M(2) + COEHSD*ZIC*CONT(ICPG+2) 
               M(3) = M(3) + COEHSD*ZIC*CONT(ICPG+4) 
 120        CONTINUE
 110     CONTINUE
C
            DO 140,K = 1,3
               EFFINT((IPG-1)*IND+K)   = N(K)
               EFFINT((IPG-1)*IND+K+3) = M(K)
 140        CONTINUE
C
 100  CONTINUE
C
      END
