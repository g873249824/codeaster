      SUBROUTINE LC0019(FAMI,KPG,KSP,NDIM,IMATE,COMPOR,CRIT,INSTAM,
     &              INSTAP,EPSM,DEPS,SIGM,VIM,OPTION,ANGMAS,SIGP,VIP,
     &                  TAMPON,TYPMOD,ICOMP,NVI,DSIDEP,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/05/2013   AUTEUR MACOCCO K.MACOCCO 
C TOLE CRP_21
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
      IMPLICIT NONE
      INTEGER         IMATE,NDIM,KPG,KSP,CODRET,ICOMP,NVI
      REAL*8          CRIT(*),ANGMAS(*)
      REAL*8          INSTAM,INSTAP,TAMPON(*)
      REAL*8          EPSM(6),DEPS(6)
      REAL*8          SIGM(6),SIGP(6)
      REAL*8          VIM(*),VIP(*)
      REAL*8          DSIDEP(6,6)
      CHARACTER*16    COMPOR(*),OPTION
      CHARACTER*8     TYPMOD(*)
      CHARACTER*(*)   FAMI
C ======================================================================
      CALL HYPINC(FAMI  ,KPG   ,KSP   ,'-'   ,NDIM  ,
     &            TYPMOD,IMATE ,COMPOR,CRIT  ,EPSM  ,
     &            DEPS  ,SIGM  ,SIGP  ,DSIDEP,CODRET)
      END
