      SUBROUTINE DXEFN2(NOMTE,PGL,SIGT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      REAL*8 PGL(3,3),SIGT(1)
      CHARACTER*16  NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------
C --- EFFORTS GENERALISES D'ORIGINE THERMIQUE AUX NOEUDS
C --- POUR LES ELEMENTS DKTG  DUS:
C ---  .A UN CHAMP DE TEMPERATURES SUR LE PLAN MOYEN DONNANT
C ---        DES EFFORTS DE MEMBRANE
C ---  .A UN GRADIENT DE TEMPERATURES DANS L'EPAISSEUR DE LA COQUE
C     ------------------------------------------------------------------
C     IN  NOMTE        : NOM DU TYPE D'ELEMENT
C     IN  XYZL(3,NNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
C                        DANS LE REPERE LOCAL DE L'ELEMENT
C     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                        LOCAL
C     OUT SIGT(1)      : EFFORTS  GENERALISES D'ORIGINE THERMIQUE
C                        AUX NOEUDS
      INTEGER ICODRE(56)
      CHARACTER*10 PHENOM
      REAL*8 DF(3,3),DM(3,3),DMF(3,3)
      REAL*8 T2EV(4),T2VE(4),T1VE(9)
      REAL*8 TSUP(4),TINF(4),TMOY(4),RBID
C     ------------------------------------------------------------------

C --- INITIALISATIONS :
C     -----------------
C-----------------------------------------------------------------------
      INTEGER I ,INDITH ,INO ,IRET1 ,IRET ,IRETM
      INTEGER JCARA ,JMATE ,NNO
      REAL*8 COE1 ,COE2 ,EPAIS ,SOMIRE ,TREF ,ZERO
C-----------------------------------------------------------------------
      ZERO = 0.0D0
      IRET1 = 0
      IRET = 0
      IRETM = 0

      DO 10 I = 1,32
        SIGT(I) = ZERO
   10 CONTINUE

C     -- S'IL N'Y A PAS DE TEMPERATURE, IL N'Y A RIEN A CALCULER :
      CALL RCVARC(' ','TEMP_INF','+','NOEU',1,1,RBID,IRET)
      IF (IRET.NE.0) GOTO 30
      CALL RCVARC(' ','TEMP_MIL','REF','NOEU',1,1,TREF,IRET1)


      IF (NOMTE.EQ.'MEDKTR3 ' .OR. NOMTE.EQ.'MEDSTR3 ' .OR.
     &    NOMTE.EQ.'MEDKTG3 ' .OR. NOMTE.EQ.'MET3TR3 ') THEN
         NNO = 3
      ELSE IF (NOMTE.EQ.'MEDKQU4 ' .OR.
     &         NOMTE.EQ.'MEDKQG4 ' .OR.
     &         NOMTE.EQ.'MEDSQU4 ' .OR.
     &         NOMTE.EQ.'MEQ4QU4 ') THEN
         NNO = 4
      ELSE
         CALL U2MESK('F','ELEMENTS_14',1,NOMTE(1:8))
      END IF

C===============================================================
C          -- RECUPERATION DE LA TEMPERATURE  AUX NOEUDS
C COQUE MULTI-COUCHE.
C ON RECUPERE LA TEMPERATURE INFERIEURE, SUPERIEURE ET DANS LA FIBRE
C MOYENNE
      DO 42 INO = 1,NNO
        CALL RCVARC(' ','TEMP_INF','+','NOEU',INO,1,TINF(INO),IRET)
        CALL RCVARC(' ','TEMP_SUP','+','NOEU',INO,1,TSUP(INO),IRET)
        CALL RCVARC(' ','TEMP_MIL','+','NOEU',INO,1,TMOY(INO),IRETM)
        IF(IRET.EQ.0.AND.IRETM.NE.0) THEN
           TMOY(INO)=(TINF(INO)+TSUP(INO))/2.D0
        ENDIF
  42  CONTINUE

      CALL JEVECH('PMATERC','L',JMATE)
      CALL RCCOMA(ZI(JMATE),'ELAS',1,PHENOM,ICODRE)

      IF ((PHENOM.EQ.'ELAS') .OR. (PHENOM.EQ.'ELAS_COQUE') .OR.
     &    (PHENOM.EQ.'ELAS_COQMU')) THEN

C --- RECUPERATION DE L'EPAISSEUR DE LA COQUE
C     --------------------------

        CALL JEVECH('PCACOQU','L',JCARA)
        EPAIS = ZR(JCARA)

C --- CALCUL DES MATRICES DE HOOKE DE FLEXION, MEMBRANE,
C --- MEMBRANE-FLEXION, CISAILLEMENT, CISAILLEMENT INVERSE
C     ----------------------------------------------------
        CALL DXMAT1('NOEU',EPAIS,DF,DM,DMF,PGL,INDITH,
     &                                   T2EV,T2VE,T1VE,NNO)
        IF (INDITH.EQ.-1) GO TO 30

        SOMIRE = IRET
        IF (SOMIRE.EQ.0) THEN
          IF (IRET1.EQ.1) THEN
            CALL U2MESS('F','CALCULEL_31')
          ELSE

C --- BOUCLE SUR LES NOEUDS
C     ---------------------
        DO 20 INO = 1,NNO

C  --      LES COEFFICIENTS SUIVANTS RESULTENT DE L'HYPOTHESE SELON
C  --      LAQUELLE LA TEMPERATURE EST PARABOLIQUE DANS L'EPAISSEUR.
C  --      ON NE PREJUGE EN RIEN DE LA NATURE DU MATERIAU.
C  --      CETTE INFORMATION EST CONTENUE DANS LES MATRICES QUI
C  --      SONT LES RESULTATS DE LA ROUTINE DXMATH.
C          ----------------------------------------
          COE1 = (TSUP(INO)+TINF(INO)+4.D0*TMOY(INO))/6.D0 - TREF
          COE2 = (TSUP(INO)-TINF(INO))/EPAIS

          SIGT(1+8* (INO-1)) = COE1* (DM(1,1)+DM(1,2)) +
     &                         COE2* (DMF(1,1)+DMF(1,2))
          SIGT(2+8* (INO-1)) = COE1* (DM(2,1)+DM(2,2)) +
     &                         COE2* (DMF(2,1)+DMF(2,2))
          SIGT(3+8* (INO-1)) = COE1* (DM(3,1)+DM(3,2)) +
     &                         COE2* (DMF(3,1)+DMF(3,2))
          SIGT(4+8* (INO-1)) = COE2* (DF(1,1)+DF(1,2)) +
     &                         COE1* (DMF(1,1)+DMF(1,2))
          SIGT(5+8* (INO-1)) = COE2* (DF(2,1)+DF(2,2)) +
     &                         COE1* (DMF(2,1)+DMF(2,2))
          SIGT(6+8* (INO-1)) = COE2* (DF(3,1)+DF(3,2)) +
     &                         COE1* (DMF(3,1)+DMF(3,2))
   20   CONTINUE

        ENDIF
       ENDIF

      END IF

   30 CONTINUE

      END
