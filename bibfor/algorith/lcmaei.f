      SUBROUTINE LCMAEI (NMATER,IMAT,NECRIS,IFA,NBCOMM,NBPAR,NOMPAR,
     &                   VALPAR,MATER,NMAT)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2004   AUTEUR KANIT T.KANIT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ----------------------------------------------------------------
C     MONOCRISTAL : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
C                  MATER(*,2) = COEF ECRO ISOT
C     ----------------------------------------------------------------
C     IN  IMAT   :  ADRESSE DU MATERIAU CODE
C         NMATER :  NOM DU MATERIAU
C         NMAT   :  DIMENSION  DE MATER
C         NECRIS :  NOM DE LA LOI D'ECOULEMENT
C         IFA    :  NUMERO DE LA FAMILLE DE GLISSEMENT
C         NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C         VALPAR :  VALEUR DES PARAMETRES
C         NOMPAR :  NOM DES PARAMETRES
C     OUT MATER :  COEFFICIENTS MATERIAU A T
C     ----------------------------------------------------------------
      INTEGER NBVALM
      PARAMETER (NBVALM=10)
      INTEGER         NMAT,NBCOMM(NMAT,3),NBPAR,NVINI,IFA,NBVAL,IMAT,I
      REAL*8          MATER(NMAT,2)
      REAL*8          VALPAR(NBPAR),VALRES(NBVALM)
      CHARACTER*8     NOMPAR(NBPAR),NOMRES(NBVALM)
      CHARACTER*2     CODRET(NBVALM)
      CHARACTER*16    NMATER, NECRIS
C     ----------------------------------------------------------------
C
      NVINI=NBCOMM(IFA,3)
      IF (NECRIS.EQ.'ECRO_ISOT1') THEN
          NBVAL=4
          NOMRES(1)='R_0'
          NOMRES(2)='Q'
          NOMRES(3)='B'
          NOMRES(4)='H'
          CALL RCVALA (IMAT,NMATER, NECRIS,1, NOMPAR,VALPAR,NBVAL,
     &                 NOMRES, VALRES,CODRET,'FM')
          DO 1 I=1,NBVAL
             MATER(NVINI-1+I,2)=VALRES(I)
 1        CONTINUE
          NBCOMM(IFA+1,1)=NVINI+4
      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN
          NBVAL=6
          NOMRES(1)='R_0'
          NOMRES(2)='Q1'
          NOMRES(3)='B1'
          NOMRES(4)='H'
          NOMRES(5)='Q2'
          NOMRES(6)='B2'
          CALL RCVALA (IMAT,NMATER, NECRIS,1, NOMPAR,VALPAR,NBVAL,
     &                 NOMRES, VALRES,CODRET,'FM')
          DO 2 I=1,NBVAL
             MATER(NVINI-1+I,2)=VALRES(I)
 2        CONTINUE
          NBCOMM(IFA+1,1)=NVINI+NBVAL
      ENDIF
      END
