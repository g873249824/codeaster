      SUBROUTINE LCMMFI( COEFT,IFA,NMAT,NBCOMM,NECRIS,
     &                IS,NBSYS,VIND,NSFV,DY,NFS,NSG,HSR,IEXP,EXPBP,RP)
      IMPLICIT NONE
      INTEGER IFA,NMAT,NBCOMM(NMAT,3),NBSYS,IS,IEXP,NFS,NSG,NSFV
      REAL*8 COEFT(NMAT),DY(*),VIND(*),HSR(NSG,NSG),SQ,EXPBP(*)
      CHARACTER*16 NECRIS
      INTEGER IRR,DECIRR,NBSYST,DECAL,GDEF
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL,GDEF
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PROIX J.M.PROIX
C  COMPORTEMENT MONOCRISTALLIN : ECROUISSAGE ISOTROPE
C     IN  COEFT   :  PARAMETRES MATERIAU
C         IFA     :  NUMERO DE FAMILLE
C         NMAT    :  NOMBRE MAXI DE MATERIAUX
C         NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C         NECRIS  :  NOM DE LA LOI D'ECROUISSAGE ISTROPE
C         IS      :  NUMERO DU SYSTEME DE GLISSEMET EN COURS
C         NBCOMM  :  INCIDES DES COEF MATERIAU
C         NBSYS   :  NOMBRE DE SYSTEMES DE GLISSEMENT DE LA FAMILLE
C         VIND    :  VARIABLES INTERNES A L'INSTANT PRECEDENT
C         DY      :  SOLUTION
C         HSR     :  MATRICE D'INTERACTION
C         IEXP    :  Indice pour recalculer EXPBP (0 si deja calcule)
C         EXPBP   :  TERMES 1.-EXP(-BPr)  pour tous les systemes Ir
C     OUT:
C         RP      :  R(P)
C ======================================================================

C     ----------------------------------------------------------------
      REAL*8 P,R0,Q,B,RP,B1,B2,Q1,Q2
      REAL*8 PR,MU,CEFF,ALPHAM(12),ALPHAS(12),R8B
      REAL*8 ALLOOP,ALPVID,FILOOP,RHOVID
      INTEGER IEI,IR,NUEISO
C     ----------------------------------------------------------------

      IEI=NBCOMM(IFA,3)
      NUEISO=NINT(COEFT(IEI))

C--------------------------------------------------------------------
C     POUR UN NOUVEAU TYPE D'ECROUISSAGE ISOTROPE, AJOUTER UN BLOC IF
C--------------------------------------------------------------------
C      IF (NECRIS.EQ.'ECRO_ISOT1') THEN
      IF (NUEISO.EQ.1) THEN

         R0    =COEFT(IEI+1)
         Q     =COEFT(IEI+2)
         B     =COEFT(IEI+3)

         IF (IEXP.EQ.1) THEN
           DO 10 IR = 1, NBSYS
            PR=VIND(NSFV+3*(IR-1)+3)+ABS(DY(IR))
            EXPBP(IR) = (1.D0-EXP(-B*PR))
  10      CONTINUE
         ENDIF

C       VIND commence en fait au d�but de systemes de glissement
C      de LA famille courante;
         SQ=0.D0
           DO 11 IR = 1, NBSYS
            PR=VIND(NSFV+3*(IR-1)+3)+ABS(DY(IR))
            SQ = SQ + HSR(IS,IR)*EXPBP(IR)
  11      CONTINUE
            RP=R0+Q*SQ

C      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN
      ELSEIF (NUEISO.EQ.2) THEN

         R0=COEFT(IEI+1)
         Q1=COEFT(IEI+2)
         B1=COEFT(IEI+3)
         Q2=COEFT(IEI+4)
         B2=COEFT(IEI+5)

C        VIND COMMENCE EN FAIT AU D�BUT DE SYSTEMES DE GLISSEMENT
C        DE LA FAMILLE COURANTE;

         SQ=0.D0
         DO 12 IR = 1, NBSYS
            PR=VIND(NSFV+3*(IR-1)+3)+ABS(DY(IR))
            SQ = SQ + HSR(IS,IR)*(1.D0-EXP(-B1*PR))
  12     CONTINUE
         P=VIND(NSFV+3*(IS-1)+3)+ABS(DY(IS))
         RP=R0+Q1*SQ+Q2*(1.D0-EXP(-B2*P))

C      ELSEIF ((NECRIS.EQ.'ECRO_DD_CFC').OR.
C             (NECRIS.EQ.'ECRO_ECP_CFC')) THEN
      ELSEIF ((NUEISO.EQ.3).OR.(NUEISO.EQ.4)) THEN

         IF (NUEISO.EQ.3) THEN
           MU    =COEFT(IEI+4)
C           NUMHSR=NINT(COEFT(IEI+5))
         ELSE
C          CAS NUEISO = 4 C'EST A DIRE NECRIS = 'ECRO_ECP_CFC'
           MU    =COEFT(IEI+1)
C           NUMHSR=NINT(COEFT(IEI+2))
         ENDIF

C        VIND COMMENCE EN FAIT AU D�BUT DE SYSTEMES DE GLISSEMENT
C        DE LA FAMILLE COURANTE;
C        VARIABLE INTERNE PRINCIPALE : ALPHA=RHO*B**2

         DO 55 IR=1,NBSYS
            ALPHAM(IR)=VIND(NSFV+3*(IR-1)+1)
            ALPHAS(IR)= ALPHAM(IR)+DY(IR)
 55      CONTINUE

         RP=0.D0
         DO 23 IR = 1, NBSYS
            IF (ALPHAS(IR).GT.0.D0) THEN
            RP=RP+ALPHAS(IR)*HSR(IS,IR)
            ENDIF
  23     CONTINUE

         IF (NUEISO.EQ.3) THEN
           CALL LCMMDC(COEFT,IFA,NMAT,NBCOMM,ALPHAS,IS,CEFF,R8B)
         ELSE
C          CAS NUEISO = 4 C'EST A DIRE NECRIS = 'ECRO_ECP_CFC'
           CEFF = 1.D0
         ENDIF

C        CE QUE L'ON APPELLE RP CORRESPOND ICI A TAU_S_FOREST
         RP=MU*SQRT(RP)*CEFF

C        DD_CFC_IRRA
      ELSEIF (NUEISO.EQ.8) THEN

         RHOVID =COEFT(IEI+4)
         FILOOP =COEFT(IEI+5)
         ALPVID =COEFT(IEI+6)
         ALLOOP =COEFT(IEI+7)
         MU     =COEFT(IEI+12)

C        VIND COMMENCE EN FAIT AU D�BUT DE SYSTEMES DE GLISSEMENT
C        DE LA FAMILLE COURANTE;
C        VARIABLE INTERNE PRINCIPALE : ALPHA=RHO*B**2
         DO 56 IR=1,NBSYS
            ALPHAM(IR)=VIND(NSFV+3*(IR-1)+1)
            ALPHAS(IR)= ALPHAM(IR)+DY(IR)
 56      CONTINUE

         RP=0.D0
         DO 24 IR = 1, NBSYS
            IF (ALPHAS(IR).GT.0.D0) THEN
            RP=RP+ALPHAS(IR)*HSR(IS,IR)
            ENDIF
  24     CONTINUE
         CALL LCMMDC(COEFT,IFA,NMAT,NBCOMM,ALPHAS,IS,CEFF,R8B)

         RP=RP*CEFF*CEFF
         RP=RP+ALLOOP*FILOOP*VIND(DECIRR+(IS-1)+1)
         RP=RP+ALPVID*RHOVID*VIND(DECIRR+12+(IS-1)+1)

C        CE QUE L'ON APPELLE RP CORRESPOND ICI A TAU_S_FOREST
         RP=MU*SQRT(RP)

C        DD_CC : ON SORT UNIQUEMENT TAU_F
      ELSEIF (NUEISO.EQ.7) THEN
         RP=COEFT(IEI+1)

      ELSE
          CALL U2MESS('F','COMPOR1_21')
      ENDIF


      END
