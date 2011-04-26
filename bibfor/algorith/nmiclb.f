      SUBROUTINE NMICLB(FAMI,KPG,KSP,OPTION,COMPOR,IMATE,XLONG0,A,
     &   TMOINS,TPLUS,DLONG0,EFFNOM,VIM,EFFNOP,VIP,KLV,FONO,EPSM,
     &   CRILDC,CODRET)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C ------------------------------------------------------------------
      IMPLICIT NONE
      INTEGER IMATE,NEQ,NBT,KPG,KSP,CODRET
      PARAMETER (NEQ=6,NBT=21)

      CHARACTER*16 COMPOR(*),OPTION
      CHARACTER*(*) FAMI
      REAL*8 XLONG0,A
      REAL*8 EM,EP
      REAL*8 DLONG0,CRILDC(3)
      REAL*8 EFFNOM,VIM(*)
      REAL*8 EFFNOP,VIP(*),FONO(NEQ),KLV(NBT)
      INTEGER CODRES
      REAL*8 DSDE,EPSM
C -------------------------------------------------------------------

C    TRAITEMENT DE LA RELATION DE COMPORTEMENT -ELASTOPLASTICITE-
C    ECROUISSAGE ISOTROPE ET CINEMATIQUE- LINEAIRE - VON MISES-
C    POUR UN MODELE BARRE ELEMENT MECA_BARRE

C -------------------------------------------------------------------
C IN  : IMATE : POINTEUR MATERIAU CODE
C       COMPOR : LOI DE COMPORTEMENT
C       XLONG0 : LONGUEUR DE L'ELEMENT DE BARRE AU REPOS
C       A      : SECTION DE LA BARRE
C       TMOINS : INSTANT PRECEDENT
C       TPLUS  : INSTANT COURANT
C       DLONG0 : INCREMENT D'ALLONGEMENT DE L'ELEMENT
C       EFFNOM : EFFORT NORMAL PRECEDENT
C       TREF   : TEMPERATURE DE REFERENCE
C       TEMPM  : TEMPERATURE IMPOSEE A L'INSTANT PRECEDENT
C       TEMPP  : TEMPERATURE IMPOSEE A L'INSTANT COURANT
C       OPTION : OPTION DEMANDEE (R_M_T,FULL OU RAPH_MECA)
C OUT : EFFNOP : CONTRAINTE A L'INSTANT ACTUEL
C       VIP    : VARIABLE INTERNE A L'INSTANT ACTUEL
C       FONO   : FORCES NODALES COURANTES
C       KLV    : MATRICE TANGENTE

C----------VARIABLES LOCALES

      INTEGER IRET
      REAL*8 SIGM,DEPS,DEPSTH,DEPSM,TMOINS,TPLUS
      REAL*8 SIGP,XRIG
      LOGICAL ISOT,CINE,ELAS,CORR,IMPL, ISOTLI


C----------INITIALISATIONS

      ELAS = .FALSE.
      ISOT = .FALSE.
      CINE = .FALSE.
      CORR = .FALSE.
      IMPL = .FALSE.
      ISOTLI = .FALSE.
      IF (COMPOR(1).EQ.'ELAS') THEN
        ELAS = .TRUE.
      ELSE IF ((COMPOR(1).EQ.'VMIS_ISOT_LINE') .OR.
     &         (COMPOR(1).EQ.'VMIS_ISOT_TRAC')) THEN
        ISOT = .TRUE.
        IF (COMPOR(1).EQ.'VMIS_ISOT_LINE') THEN
            ISOTLI = .TRUE.
        END IF
        IF (CRILDC(2).EQ.9) THEN
            IMPL = .TRUE.
        END IF
        IF (IMPL.AND.(.NOT.ISOTLI)) THEN
            CALL U2MESS('F','ELEMENTS5_50')
        END IF
      ELSE IF (COMPOR(1).EQ.'VMIS_CINE_LINE') THEN
        CINE = .TRUE.
      ELSE IF (COMPOR(1).EQ.'CORR_ACIER') THEN
        CORR = .TRUE.
      END IF

      CALL R8INIR(NBT,0.D0,KLV,1)
      CALL R8INIR(NEQ,0.D0,FONO,1)

C----------RECUPERATION DES CARACTERISTIQUES

      DEPS = DLONG0/XLONG0
      SIGM = EFFNOM/A

C --- CARACTERISTIQUES ELASTIQUES A TMOINS

      CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',0,' ',0.D0,1,'E',EM,
     &       CODRES,1)

C --- CARACTERISTIQUES ELASTIQUES A TPLUS

      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',0.D0,1,'E',EP,
     &              CODRES,1)


      IF (ISOT.AND.(.NOT.IMPL)) THEN
        CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS',1,DEPSTH,IRET)
        DEPSM=DEPS-DEPSTH
        CALL NM1DIS(FAMI,KPG,KSP,IMATE,EM,EP,SIGM,
     &              DEPSM,VIM,OPTION,COMPOR,' ',SIGP,VIP,DSDE)
      ELSE IF (CINE) THEN
        CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS',1,DEPSTH,IRET)
        DEPSM = DEPS-DEPSTH
        CALL NM1DCI(FAMI,KPG,KSP,IMATE,EM,EP,SIGM,
     &              DEPSM,VIM,OPTION,' ',SIGP,VIP,DSDE)
      ELSE IF (ELAS) THEN
        DSDE = EP
        VIP(1) = 0.D0
        CALL VERIFT(FAMI,KPG,KSP,'T',IMATE,'ELAS',1,DEPSTH,IRET)
        SIGP = EP* (SIGM/EM+DEPS-DEPSTH)
      ELSE IF (CORR) THEN
        CALL NM1DCO(FAMI,KPG,KSP,OPTION,IMATE,' ',EP,SIGM,
     &              EPSM,DEPS,VIM,SIGP,VIP,DSDE,CRILDC,CODRET)
      ELSE IF (IMPL) THEN
        CALL LCIMPL(FAMI,KPG,KSP,IMATE,EM,EP,SIGM,TMOINS,TPLUS,
     &                  DEPS,VIM,OPTION,COMPOR,SIGP,VIP,DSDE)
      ELSE
        CALL U2MESS('F','ALGORITH6_87')
      END IF

C --- CALCUL DU COEFFICIENT NON NUL DE LA MATRICE TANGENTE

      IF (OPTION(1:10).EQ.'RIGI_MECA_' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN

        XRIG = DSDE*A/XLONG0
        KLV(1) = XRIG
        KLV(7) = -XRIG
        KLV(10) = XRIG
      END IF

C --- CALCUL DES FORCES NODALES

      IF (OPTION(1:14).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        EFFNOP = SIGP*A
        FONO(1) = -EFFNOP
        FONO(4) = EFFNOP
      END IF
C      EFFNOP = SIGP*A

      IF(OPTION(1:16).EQ.'RIGI_MECA_IMPLEX') THEN
        IF ( (.NOT.IMPL).AND.(.NOT.ELAS)) THEN
           CALL U2MESS('F','ELEMENTS5_49')
        END IF
        EFFNOP = SIGP*A
        FONO(1) = -EFFNOP
        FONO(4) = EFFNOP
      END IF

C -------------------------------------------------------------

      END
