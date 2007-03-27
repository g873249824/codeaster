      SUBROUTINE DXEFGV (NOMTE,OPTION,XYZL,PGL ,DEPL,
     +                   EFFGT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 NOMTE, OPTION
      REAL*8       XYZL(3,1) , PGL(3,1)
      REAL*8       DEPL(1)
      REAL*8       EFFGT(1)
C     ------------------------------------------------------------------
C --- EFFORTS GENERALISES 'VRAIS' (I.E. EFFOR_MECA - EFFOR_THERM)
C --- AUX POINTS D'INTEGRATION POUR LES ELEMENTS COQUES A
C --- FACETTES PLANES : DST, DKT, DSQ, DKQ, Q4G
C     ------------------------------------------------------------------
C     IN  NOMTE        : NOM DU TYPE D'ELEMENT
C     IN  OPTION       : NOM DE L'OPTION
C     IN  XYZL(3,NNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
C                        DANS LE REPERE LOCAL DE L'ELEMENT
C     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                        LOCAL
C     IN  DEPL(1)      : VECTEUR DES DEPLACEMENTS AUX NOEUDS
C     IN  TSUP(1)      : TEMPERATURES AUX NOEUDS DU PLAN SUPERIEUR
C                        DE LA COQUE
C     IN  TINF(1)      : TEMPERATURES AUX NOEUDS DU PLAN INFERIEUR
C                        DE LA COQUE
C     IN  TMOY(1)      : TEMPERATURES AUX NOEUDS DU PLAN MOYEN
C                        DE LA COQUE
C     OUT EFFGT(1)     : EFFORTS  GENERALISES VRAIS AUX POINTS
C                        D'INTEGRATION (I.E.
C                           EFFORTS_MECA - EFFORTS_THERM)
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      REAL*8     SIGTH(32)
C
C --- CALCUL DES EFFORTS GENERALISES D'ORIGINE MECANIQUE
C --- AUX POINTS DE CALCUL
C     --------------------
      CALL DXEFGM(NOMTE, OPTION, XYZL, PGL, DEPL, EFFGT)
C
C --- CALCUL DES EFFORTS GENERALISES D'ORIGINE THERMIQUE
C --- AUX POINTS DE CALCUL
C     --------------------
C ---     POINTS D'INTEGRATION
      IF (OPTION(8:9).EQ.'GA') THEN
         CALL DXEFGT(NOMTE, XYZL, PGL, SIGTH)
C ---     POINTS DE CALCUL
      ELSEIF (OPTION(8:9).EQ.'NO') THEN
         CALL DXEFNT(NOMTE, XYZL, PGL, SIGTH)
      ENDIF
C
C --- CALCUL DES EFFORTS GENERALISES 'VRAIS'
C --- AUX POINTS DE CALCUL
C     --------------------
      DO 10 I =1, 32
            EFFGT(I) = EFFGT(I) - SIGTH(I)
 10   CONTINUE
C
      END
