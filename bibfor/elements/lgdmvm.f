      SUBROUTINE LGDMVM(IMATE,COMPOR,EPSM,DEPS,VIM,OPTION,SIGM,
     &                  SIG,VIP,DSIDEP,CRIT,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/01/2012   AUTEUR PROIX J-M.PROIX 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE SFAYOLLE S.FAYOLLE

      IMPLICIT NONE
      CHARACTER*16       OPTION,COMPOR
      REAL*8             EPSM(6),DEPS(6),VIM(*),EP
      REAL*8               R8BID, CRIT(*)
      REAL*8             SIGM(*),SIG(*),VIP(*),DSIDEP(6,*)
      INTEGER            IMATE, IRET
C ----------------------------------------------------------------------
C
C      LOI GLOBALE COUPLEE POUR LES PLAQUES/COQUES DKTG
C      - GLRC_DM ET VMIS_CINE_LINE
C IN:
C       VIM     : VARIABLES INTERNES EN T-
C       OPTION  : OPTION NON LINEAIRE A CALCULER
C                'RAPH_MECA' ,'FULL_MECA', OU 'RIGI_MECA_TANG'
C       EP      : EPAISSEUR
C OUT:
C       SIG     : CONTRAINTE
C       VIP     : VARIABLES INTERNES EN T+
C       DSIDEP  : MATRICE TANGENTE
C ----------------------------------------------------------------------

      REAL*8 ZR
      COMMON /RVARJE/ZR(1)

      REAL*8   EMMP(6),DEMP(6),CEL(6,6),CELINV(6,6),CELDAM(6,6),EMEL(6)
      REAL*8   TANDAM(6,6),TANEPL(6,6),SIGPD(6),DEDA(6),RESIDU
      INTEGER  I,J,K,IERR,NVV,ICP,NCPMAX,NSGMAX,ISG,ICARA,T(2,2)
      REAL*8   CRBID,INBID,SIGPP(6),RAC2,EMDA(6)
      REAL*8   EMPL(6),DEPZZ,EPS2D(6),DEPS2D(6),D22,D21EPS,TAN3D(6,6)
      REAL*8   SIG2DM(6),SIG2DP(6),SCM(4),SIGPEQ,CRITCP,SIGNUL,PREC
      REAL*8   DDEMP(6),TANLOC(6,6),TANPOM(6,6),PRECR
      REAL*8   LAMBDA,DEUXMU,LAMF,DEUMUF,GT,GC,GF,SEUIL,ALPHA,ALFMC
      LOGICAL  RIGI,RESI
      CHARACTER*8   TYPMOD(2)

      RAC2 = SQRT(2.D0)
C ---EPAISSEUR TOTALE :
      CALL JEVECH('PCACOQU','L',ICARA)
      EP = ZR(ICARA)

C -- OPTION
      RIGI  = (OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL')
      RESI  = (OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL')

C-----NOMBRE DE VARIABLES INTERNES DU MODELE, SANS CELLE POUR
C-----LA CONTRAINTE PLANE
      IF (COMPOR(1:14) .EQ. 'VMIS_CINE_LINE') THEN
       NVV  = 17
      ELSE IF (COMPOR(1:10) .EQ. 'VMIS_ISOT_') THEN
       NVV  = 12
      ENDIF

C-----TOLERANCE POUR LA CONTRAINTE HORS PLAN


      CRITCP = CRIT(3)
      SIGNUL = CRIT(3)
      NCPMAX = NINT(CRIT(9))

      IF (NCPMAX.LE.1) THEN
        NCPMAX = 15
      ENDIF

      PREC = CRIT(8)

      IF(RESI) THEN
        NSGMAX = NINT(CRIT(1))
      ELSE
        NSGMAX = 1
      ENDIF

C-----LECTURE DES PARAMETRES D ENDOMMAGEMENT
      CALL CRGDM(IMATE,'GLRC_DM         ',T,LAMBDA,DEUXMU,LAMF,DEUMUF,
     &                 GT,GC,GF,SEUIL,ALPHA,ALFMC,EP,.FALSE.)

C-----OBTENTION DU MODULE ELASTIQUE INITIAL
      DO 100, I = 1,6
        DEMP(I) = 0.0D0
 100  CONTINUE
      DO 110, I = 1,4
        VIP(I) = 0.0D0
 110  CONTINUE

      CALL LCGLDM(DEMP,DEMP,VIP,'RIGI_MECA_TANG  ',DEMP,VIP,CEL,T,
     &   LAMBDA,DEUXMU,LAMF,DEUMUF,GT,GC,GF,SEUIL,ALPHA,ALFMC,CRIT,IRET)

      DO 115, J = 1,6
        DO 115, I = 1,6
          CELDAM(I,J) = CEL(I,J)
 115  CONTINUE

C-----TRIANGULATION DU MODULE ELASTIQUE
      CALL TRLDS(CELDAM,6,6,IERR)
      CALL ASSERT(IERR.EQ.0)


C-----INVERSION DU MODULE ELASTIQUE
      CALL R8INIR(36,0.D0,CELINV,1)
      DO 130, J = 1,6
        CELINV(J,J) = 1.0D0
 130  CONTINUE

      CALL RRLDS(CELDAM,6,6,CELINV,6)

C-----CALCUL DE LA DEFORMATION ELASTIQUE A L INSTANT -
      CALL R8INIR(6,0.D0,EMEL,1)
      DO 150 J = 1,6
        DO 150 I = 1,6
          EMEL(I) = EMEL(I) + CELINV(I,J)*SIGM(J)
 150  CONTINUE

C-----INITIALISATION DES VARIABLES DEPS^(-P), EPS^(-P) ET EMDA
      CALL R8INIR(6,0.D0,DEMP,1)
      DO 200, I = 1,6
        DDEMP(I) = DEPS(I)
        EMMP(I)  = VIM(NVV-6 + I)
        EMDA(I)  = EMMP(I) - EMEL(I)
        EMPL(I)  = EPSM(I) - EMDA(I)
 200  CONTINUE

C-------DEBUT BOUCLE INTERNE
      DO 2000 ISG = 1,NSGMAX

C       CORRECTION DE LA VARIABLE PRINCIPALE
        DO 205, I = 1,6
          DEMP(I) = DEMP(I) + DDEMP(I)
 205    CONTINUE

C-------CALCUL DE L ENDOMMAGEMENT
        CALL R8INIR(6,0.D0,SIGPD,1)
        CALL LCGLDM(EMMP,DEMP,VIM,'FULL_MECA       ',SIGPD,VIP,TANDAM,T,
     &              LAMBDA,DEUXMU,LAMF,DEUMUF,GT,GC,GF,
     &              SEUIL,ALPHA,ALFMC,CRIT,IRET)

C-------CALCUL DE L INCREMENT DE LA DEFORMATION ELASTIQUE
C        PUIS DEPS - DEPS^D
        CALL R8INIR(6,0.D0,DEDA,1)
        DO 210 J = 1,6
          DO 210 I = 1,6
            DEDA(I) = DEDA(I) + CELINV(I,J)*SIGPD(J)
 210    CONTINUE
        DO 220 I = 1,6
          DEDA(I) = DEPS(I) - (DEMP(I) - (DEDA(I)- EMEL(I)))
 220    CONTINUE

C-------CALCUL DE LA PLASTICITE

C-------BOUCLE POUR SATISFAIRE LA CONDITION DE CONTRAINTES PLANES

        DEPZZ=VIP(NVV+1)
     &       -VIP(NVV+2)*DEPS(1)-VIP(NVV+3)*DEPS(2)
     &       -VIP(NVV+4)*DEPS(4)/RAC2

        DO 1000, ICP = 1,NCPMAX

          EPS2D(1) = EMPL(1)
          EPS2D(2) = EMPL(2)
          EPS2D(3) = 0.0D0
          EPS2D(4) = EMPL(3)/RAC2
          EPS2D(5) = 0.D0
          EPS2D(6) = 0.D0
          DEPS2D(1) = DEDA(1)
          DEPS2D(2) = DEDA(2)
          DEPS2D(3) = DEPZZ
          DEPS2D(4) = DEDA(3)/RAC2
          DEPS2D(5) = 0.D0
          DEPS2D(6) = 0.D0

          SIG2DM(1) = SIGM(1)/EP
          SIG2DM(2) = SIGM(2)/EP
          SIG2DM(3) = 0.0D0
          SIG2DM(4) = SIGM(3)/EP*RAC2
          SIG2DM(5) = 0.0D0
          SIG2DM(6) = 0.0D0

C---------VMIS_CINE_LINE--------------------
          CALL R8INIR(6,0.D0,SIG2DP,1)
          IF (COMPOR(1:14) .EQ. 'VMIS_CINE_LINE') THEN
            CALL NMCINE ('RIGI',1,1,3,IMATE,COMPOR,CRBID,
     &                   INBID,INBID,EPS2D,DEPS2D,SIG2DM,VIM(5),
     &            'FULL_MECA       ',SIG2DP,VIP(5),TAN3D,IRET)

C---------VMIS_ISOT_LINE--------------------
          ELSEIF (COMPOR (1:14) .EQ. 'VMIS_ISOT_LINE') THEN
C     --    POUR POUVOIR UTILISER NMISOT
            TYPMOD(1) = '3D  '
            TYPMOD(2) = '        '
            CALL NMISOT ('RIGI',1,1,3,TYPMOD,IMATE,'VMIS_ISOT_LINE  ',
     &                   CRBID,DEPS2D,SIG2DM,VIM(5),
     &                   'FULL_MECA       ',SIG2DP,VIP(5),TAN3D,
     &                   R8BID,R8BID,IRET)
          ENDIF

          D22    = TAN3D(3,3)

          IF (PREC .GT. 0D0) THEN
            SIGPEQ=0.D0
            DO 301 J = 1,4
              SIGPEQ = SIGPEQ + SIG2DP(J)**2
 301        CONTINUE
            SIGPEQ = SQRT(SIGPEQ)
            IF (SIGPEQ.LT.SIGNUL) THEN
              PRECR = CRITCP
            ELSE
              PRECR = CRITCP*SIGPEQ
            ENDIF
          ELSE
            PRECR = ABS(PREC)
          ENDIF

          IF((ICP.GE.NCPMAX .OR. ABS(SIG2DP(3)).LT.PRECR)) GOTO 1001

          DEPZZ = DEPZZ - SIG2DP(3)/D22

 1000   CONTINUE
 1001   CONTINUE

        IF (ABS(SIG2DP(3)).GT.PRECR) THEN
           IRET = 1
        ELSE
           IRET = 0
        ENDIF

        D21EPS = TAN3D(3,1)*DEDA(1)+TAN3D(3,2)*DEDA(2)
     &          + TAN3D(3,4)*DEDA(4)/RAC2

        VIP(NVV+1)=DEPZZ+D21EPS/D22-SIG2DP(3)/D22
        VIP(NVV+2)=TAN3D(3,1)/D22
        VIP(NVV+3)=TAN3D(3,2)/D22
        VIP(NVV+4)=TAN3D(3,4)/D22

        SCM(1) = -TAN3D(1,3)*SIG2DP(3)/D22
        SCM(2) = -TAN3D(2,3)*SIG2DP(3)/D22
        SCM(3) = 0.D0
        SCM(4) = -TAN3D(4,3)*SIG2DP(3)/D22*RAC2

        DO 310 J=1,4
           SIG2DP(J)=SIG2DP(J)+SCM(J)
 310    CONTINUE

        DO 336 J=1,6
           IF (J.EQ.3) GO TO 336
           DO 337 I=1,6
              IF (I.EQ.3) GO TO 337
              TAN3D(J,I) = TAN3D(J,I)
     &                     - 1.D0/TAN3D(3,3)*TAN3D(J,3)*TAN3D(3,I)
 337       CONTINUE
 336    CONTINUE

C-------COPIE DES CONTRAINTES ET
C-------DE LA MATRICE TANGENTE POUR LE MODULE PLASTIQUE

C       PARTIE MEMBRANE (ELASTO-PLASTIQUE)
        CALL R8INIR(36,0.D0,TANEPL,1)
        DO 410 J = 1,2
          DO 400 I = 1,2
            TANEPL(I,J) = TAN3D(I,J)*EP
 400      CONTINUE
          TANEPL(3,J) = TAN3D(4,J)*EP/RAC2
          TANEPL(J,3) = TAN3D(J,4)*EP/RAC2
 410    CONTINUE
        TANEPL(3,3) = TAN3D(4,4)*EP/2.0D0

C       PARTIE FLEXION (ELASTIQUE)
        DO 420 J = 4,6
          DO 420 I = 4,6
            TANEPL(I,J) = CEL(I,J)
 420    CONTINUE

C       CONTRAINTES EN MEMBRANE (ELASTO-PLASTIQUE)
        SIGPP(1) = SIG2DP(1)*EP
        SIGPP(2) = SIG2DP(2)*EP
        SIGPP(3) = SIG2DP(4)*EP/RAC2

C       CONTRAINTES EN MEMBRANE (ELASTIQUE)
        CALL R8INIR(3,0.D0,SIGPP(4),1)
        DO 450 I = 4,6
          DO 440 J = 4,6
            SIGPP(J) = SIGPP(J) + TANEPL(J,I)*DEDA(I)
 440      CONTINUE
          SIGPP(I) = SIGPP(I) + SIGM(I)
 450    CONTINUE


C-------CALCUL DU RESIDU
        RESIDU = 0.0D0
        DO 500 I = 1,6
          SIGPP(I) = SIGPP(I) - SIGPD(I)
          RESIDU   = RESIDU + SIGPP(I)*DDEMP(I)
          DDEMP(I) = SIGPP(I)
 500    CONTINUE

        IF(ABS(RESIDU) .LT. CRITCP) GOTO 2001

C-------CONSTRUCTION DU MODULE TANGENT LOCAL
C       ET ITERATION NEWTON

C-------Cp*Ce^(-1)*Cd
        CALL R8INIR(36,0.D0,TANLOC,1)
        CALL R8INIR(36,0.D0,TANPOM,1)
        DO 560 I = 1,6
          DO 560 J = 1,6
            DO 560 K = 1,6
              TANLOC(I,J) = TANLOC(I,J) + CELINV(K,I)*TANDAM(K,J)
 560    CONTINUE

        DO 600 I = 1,6
          DO 600 J = 1,6
            DO 600 K = 1,6
              TANPOM(I,J) = TANPOM(I,J) + TANEPL(I,K)*TANLOC(K,J)
 600    CONTINUE

C-------Cd + Cp - Cp*Ce^(-1)*Cd
        DO 650 I = 1,6
          DO 650 J = 1,6
            TANLOC(I,J) = TANEPL(I,J) + TANDAM(I,J) - TANPOM(I,J)
 650    CONTINUE

C-------TRIANGULATION DE (Cd + Cp - Cp*Ce^(-1)*Cd)
        CALL TRLDS(TANLOC,6,6,IERR)
        CALL ASSERT(IERR.EQ.0)

C-------RESOLUTION DU DDEMP
        CALL RRLDS(TANLOC,6,6,DDEMP,1)

 2000 CONTINUE
C-----FIN DE BOUCLE INTERNE
 2001 CONTINUE

C-----TEST DE CV SIG = SIGPD = SIDPP
      IF (ABS(RESIDU) .LT. CRITCP .AND. IRET .EQ. 0 ) THEN
         IRET = 0
      ELSE
         IRET = 1
      ENDIF

      DO 660 J = 1,6
        SIG(J)      = SIGPD(J)
        VIP(NVV-6 + J) = EMMP(J) + DEMP(J)
 660  CONTINUE

C-----CALCUL DE LA MATRICE TANGENTE
      IF (RIGI) THEN

C-------INVERSION DU MODULE DE PLASTICITE

C-------TRIANGULATION
        CALL TRLDS(TANEPL,6,6,IERR)
        CALL ASSERT(IERR.EQ.0)

        CALL R8INIR(36,0.D0,TANPOM,1)
        DO 700, J = 1,6
          TANPOM(J,J) = 1.0D0
 700    CONTINUE

        CALL RRLDS(TANEPL,6,6,TANPOM,6)

C       Cp^(-1) - Ce^(-1)
        DO 710 J = 1,6
          DO 710 I = 1,6
              TANPOM(I,J) = TANPOM(I,J) - CELINV(I,J)
 710    CONTINUE

C-------INVERSION DU MODULE D ENDOMMAGEMENT

C-------TRIANGULATION
        CALL TRLDS(TANDAM,6,6,IERR)
        CALL ASSERT(IERR.EQ.0)

        CALL R8INIR(36,0.D0,TANEPL,1)
        DO 720, J = 1,6
          TANEPL(J,J) = 1.0D0
 720    CONTINUE

        CALL RRLDS(TANDAM,6,6,TANEPL,6)

C       Cd^(-1) + Cp^(-1) - Ce^(-1)
        DO 730 J = 1,6
          DO 730 I = 1,6
            TANPOM(I,J) = TANPOM(I,J) + TANEPL(I,J)
 730    CONTINUE

C-------INVERSION DU (Cd^(-1) + Cp^(-1) - Ce^(-1))

C-------TRIANGULATION
        CALL TRLDS(TANPOM,6,6,IERR)
        CALL ASSERT(IERR.EQ.0)

        CALL R8INIR(36,0.D0,DSIDEP,1)
        DO 740, J = 1,6
          DSIDEP(J,J) = 1.0D0
 740    CONTINUE

        CALL RRLDS(TANPOM,6,6,DSIDEP,6)

      ENDIF
C-----FIN RIGI

      END
