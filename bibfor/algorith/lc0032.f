      SUBROUTINE LC0032(FAMI,KPG,KSP,NDIM,IMATE,COMPOR,CRIT,INSTAM,
     &             INSTAP,EPSM,DEPS,SIGM,VIM,OPTION,ANGMAS,SIGP,VIP,
     &    TM,TP,TREF,TAMPON,TYPMOD,ICOMP,NVI,DSIDEP,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C TOLE CRP_21
C MODIF ALGORITH  DATE 07/12/2010   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INTEGER         IMATE,NDIM,KPG,KSP,CODRET,ICOMP,NVI,N
      REAL*8          CRIT(12),ANGMAS(3),INSTAM,INSTAP,TAMPON(*)
      REAL*8          EPSM(6),DEPS(6),SIGM(6),SIGP(6),VIM(*),VIP(*)
      REAL*8          DSIDEP(6,6),TM,TP,TREF
      CHARACTER*16    COMPOR(16),OPTION,ALGO
      CHARACTER*8     TYPMOD(*)
      CHARACTER*(*)   FAMI
      
C     Lois de comportement int�gr�es en IMPLICITE (NEWTON & CO) et en
C                                       EXPLICITE (RUNGE_KUTTA)

C     RECUP DU NOM DE L'ALGORITHME D'INTEGRATION LOCAL
      CALL UTLCAL('VALE_NOM',ALGO,CRIT(6))

      IF (ALGO.EQ.'NEWTON'.OR.ALGO.EQ.'NEWTON_RELI') THEN
      
        CALL PLASTI(FAMI,KPG,KSP,TYPMOD,IMATE,COMPOR,CRIT,INSTAM,INSTAP,
     &              TM,TP,TREF,EPSM,DEPS,SIGM,VIM,OPTION,ANGMAS,
     &              SIGP,VIP,DSIDEP,ICOMP,NVI,TAMPON,CODRET)

      ELSEIF (ALGO.EQ.'RUNGE_KUTTA') THEN

         CALL NMVPRK(FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,COMPOR,CRIT,INSTAM,
     &               INSTAP,EPSM,DEPS,SIGM,VIM,OPTION,ANGMAS,SIGP,VIP,
     &               DSIDEP)

      ELSE
      
        CALL ASSERT(.FALSE.)

      ENDIF
      
      END
