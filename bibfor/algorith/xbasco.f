      SUBROUTINE XBASCO(NDIM  ,MAQUA,NUNOA ,NUNOB ,NUNOM ,
     &                  A     ,B     ,C     ,S     ,
     &                  JGRLNV,JGRLTV,JCNSV ,JCNSL )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      INTEGER       NUNOA,NUNOB,NUNOM
      INTEGER       NDIM
      REAL*8        A(NDIM),B(NDIM),C(NDIM),S
      INTEGER       JGRLNV,JGRLTV,JCNSV,JCNSL
      LOGICAL       MAQUA
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION)
C
C REMPLISSAGE DU CHAM_NO_S DE LA BASE COVARIANTE 
C (POUR LE MOMENT, SEULEMENT POUR LES POINTS DE CONTACT SUR LES ARETES)
C (COMME DANS TE0510)
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  MAQUA  : .TRUE. SI LES MAILLES SONT QUADRATIQUES
C IN  NUNOA  : NUMERO DU NOEUD EXTREMITE 1 DE L'ARETE
C IN  NUNOB  : NUMERO DU NOEUD EXTREMITE 2 DE L'ARETE
C IN  NUNOM  : NUMERO DU NOEUD MILIEU      DE L'ARETE
C IN  A      : COORDONNEES DU NOEUD EXTREMITE 1 DE L'ARETE
C IN  B      : COORDONNEES DU NOEUD EXTREMITE 2 DE L'ARETE
C IN  C      : COORDONNEES DU POINT DE CONTACT SUR L'ARETE
C IN  S      : POSITION RELATIVE DU POINT DE CONTACT SUR L'ARETE
C IN  JGRLTV : ADRESSE DU GRADIENT DE LA LEVEL SET TANGENTE
C IN  JGRLNV : ADRESSE DU GRADIENT DE LA LEVEL SET NORMALE
C OUT JCNSV  : ADRESSE VALEUR DU CHAM_NO_S DE LA BASE COVARIANTE
C OUT JCNSL  : ADRESSE LOGIQUE DU CHAM_NO_S DE LA BASE COVARIANTE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      REAL*8     ZERO,UN
      PARAMETER (ZERO=0.D0,UN=1.D0)
C
      INTEGER    J
      REAL*8     ND(3),GRLT(NDIM),NORME,PS,NORM2,DDOT
      REAL*8     TAU1(3),TAU2(3)
      INTEGER    XXMMVD,ZXBAS
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      TAU1(3) = ZERO
      ND(3)   = ZERO
      TAU2(1) = ZERO
      TAU2(2) = ZERO
      TAU2(3) = ZERO
      ZXBAS   = XXMMVD('ZXBAS')
C
C --- CALCUL DE LA NORMALE AU POINT DE CONTACT
C
      DO 132 J=1,NDIM
        ND(J)  = (1-S) * ZR(JGRLNV-1+NDIM*(NUNOA-1)+J)
     &         +    S  * ZR(JGRLNV-1+NDIM*(NUNOB-1)+J)
 132  CONTINUE
C
C --- CALCUL DU GRADIENT DE LST AU POINT DE CONTACT
C
      DO 133 J=1,NDIM
        GRLT(J)= (1-S) * ZR(JGRLTV-1+NDIM*(NUNOA-1)+J)
     &         +    S  * ZR(JGRLTV-1+NDIM*(NUNOB-1)+J)
 133  CONTINUE
C
C --- NORMALISATION DE LA NORMALE ND
C
      CALL NORMEV(ND,NORME)
C
C --- TAU1 = PROJETE DU GRADIENT SUR LE PLAN DE NORMALE ND
C
      PS = DDOT(NDIM,GRLT,1,ND,1)
      DO 134 J=1,NDIM
        TAU1(J)=GRLT(J)-PS*ND(J)
 134  CONTINUE
C 
      CALL NORMEV(TAU1,NORME)
C
      IF (NORME.LT.1.D-12) THEN
C
C --- ESSAI AVEC LE PROJETE DE OX
C
        TAU1(1) = UN   - ND(1)*ND(1)
        TAU1(2) = ZERO - ND(1)*ND(2)
        IF (NDIM .EQ. 3) THEN
          TAU1(3) = ZERO - ND(1)*ND(3)
        ENDIF        
        CALL NORMEV(TAU1,NORM2)
C        
        IF (NORM2.LT.1.D-12) THEN
C
C --- ESSAI AVEC LE PROJETE DE OY
C
          TAU1(1) = ZERO - ND(2)*ND(1)
          TAU1(2) = UN   - ND(2)*ND(2)
          IF (NDIM .EQ. 3) THEN
            TAU1(3) = ZERO - ND(2)*ND(3)
          ENDIF  
          CALL NORMEV(TAU1,NORM2)
        ENDIF
        CALL ASSERT(NORM2.GT.1.D-12)
      ENDIF
      IF (NDIM .EQ. 3) THEN
        CALL PROVEC(ND,TAU1,TAU2)
      ENDIF
C
C --- ARCHIVAGE DE LA BASE COVARIANTE
C
      IF (NDIM.EQ.2) THEN
        IF (MAQUA) THEN
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+3)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+6)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+9)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+10) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+11) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+12) = ZERO
        ELSE
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+3)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+6)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+9)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+10) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+11) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+12) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+3)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+6)  = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+9)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+10) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+11) = ZERO
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+12) = ZERO
        ENDIF
      ELSEIF (NDIM.EQ.3) THEN
        IF (MAQUA) THEN
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+3)  = C(3)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+6)  = ND(3)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+9)  = TAU1(3)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+10) = TAU2(1)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+11) = TAU2(2)
          ZR(JCNSV-1+ZXBAS*(NUNOM-1)+12) = TAU2(3)
        ELSE
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+3)  = C(3)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+6)  = ND(3)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+9)  = TAU1(3)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+10) = TAU2(1)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+11) = TAU2(2)
          ZR(JCNSV-1+ZXBAS*(NUNOA-1)+12) = TAU2(3)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+1)  = C(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+2)  = C(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+3)  = C(3)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+4)  = ND(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+5)  = ND(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+6)  = ND(3)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+7)  = TAU1(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+8)  = TAU1(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+9)  = TAU1(3)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+10) = TAU2(1)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+11) = TAU2(2)
          ZR(JCNSV-1+ZXBAS*(NUNOB-1)+12) = TAU2(3)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)  
      ENDIF
C
      DO 900 J=1,ZXBAS
        IF (MAQUA) THEN
          ZL(JCNSL-1+ZXBAS*(NUNOM-1)+J)=.TRUE.
        ELSE
          ZL(JCNSL-1+ZXBAS*(NUNOA-1)+J)=.TRUE.
          ZL(JCNSL-1+ZXBAS*(NUNOB-1)+J)=.TRUE.
        ENDIF
 900  CONTINUE
C
      CALL JEDEMA()
      END
