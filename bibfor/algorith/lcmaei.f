      SUBROUTINE LCMAEI (FAMI,KPG,KSP,POUM,NMATER,IMAT,NECRIS,NECOUL,
     &            NBVAL,VALRES,NMAT,HSR,IFA,NOMFAM,NBSYS,NBHSR)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/07/2010   AUTEUR PROIX J-M.PROIX 
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
C                  MATER(*,2) = COEF ECRO ISOT ET CALCUL DE LA
C                  MATRICE D'INTERACTION HSR
C     ----------------------------------------------------------------
C     IN  IMAT   :  ADRESSE DU MATERIAU CODE
C         NMATER :  NOM DU MATERIAU
C         NMAT   :  DIMENSION  DE MATER
C         NECRIS :  NOM DE LA LOI D'ECOULEMENT
C         IFA    :  NUMERO DE LA FAMILLE DE GLISSEMENT
C         NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C     OUT VALRES :  COEFFICIENTS MATERIAU
C     OUT NBVAL  :  NB DE COEFFICIENTS MATERIAU
C     OUT HSR    :  MATRICE D'INTERACTION
C     ----------------------------------------------------------------
      INTEGER         KPG,KSP,N,IDIFF
      INTEGER         NMAT,NBVAL,IMAT,I,NBSYS,IS,IR,IFA,J,NBHSR,NBCOEF
      REAL*8          MATER(NMAT,2),VALH(6),R8PREM,EPSI
      REAL*8          VALRES(NMAT),HSRI(24,24),H,E,NU,MU
      REAL*8          HSR(5,24,24),VALLUE(NMAT)
      CHARACTER*(*)   FAMI,POUM
      CHARACTER*8     NOMRES(NMAT)
      CHARACTER*2     CODRET(NMAT)
      CHARACTER*16    NMATER, NECRIS, NOMFAM,NECOUL, PHENOM
C     ----------------------------------------------------------------
C
      NBVAL=0
      
      IF(NECOUL.EQ.'KOCKS_RAUCH') GOTO 9999
      
      IF (NECRIS.EQ.'ECRO_ISOT1') THEN                               
          NBVAL=3                                                    
          NOMRES(1)='R_0'                                            
          NOMRES(2)='Q'                                              
          NOMRES(3)='B'                                              
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECRIS,0,' ',  
     &                0.D0, 3,NOMRES, VALLUE,CODRET,'FM')            
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECRO_ISOT1 A LE NUMERO 1
          VALRES(1)=1
          
      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN                           
          NBVAL=5                                                    
          NOMRES(1)='R_0'                                            
          NOMRES(2)='Q1'                                             
          NOMRES(3)='B1'                                             
          NOMRES(4)='Q2'                                             
          NOMRES(5)='B2'                                             
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECRIS,0,' ',  
     &                 0.D0,NBVAL,NOMRES, VALLUE,CODRET,'FM')
     
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECRO_ISOT2 A LE NUMERO 2
          VALRES(1)=2
          
      ELSEIF (NECRIS.EQ.'ECRO_DD_CFC') THEN                           
          NBVAL=3                                                    
          NOMRES(1)='ALPHA'                                            
          NOMRES(2)='BETA'                                             
          NOMRES(3)='RHO_REF'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECRIS,0,' ',  
     &                 0.D0,NBVAL,NOMRES, VALLUE,CODRET,'FM')     
C         CALCUL ET STOCKAGE DE MU          
          CALL RCCOMA(IMAT,'ELAS',PHENOM,CODRET)

          IF (PHENOM.EQ.'ELAS') THEN
             CALL RCVALB(FAMI,KPG,KSP,POUM,IMAT,' ','ELAS',0,' ', 0.D0,
     &                   1,'E',E,CODRET,'FM')
             CALL RCVALB(FAMI,KPG,KSP,POUM,IMAT,' ','ELAS',0,' ', 0.D0,
     &                   1,'NU',NU,CODRET,'FM')
             MU=E/(2.0D0+2.0D0*NU)
          ELSE
             CALL RCVALB(FAMI,KPG,KSP,POUM,IMAT,' ',PHENOM,0,' ', 0.D0,
     &                   1,'G_LN',MU,CODRET,'FM')
          ENDIF
          VALLUE(4)=MU
          NBVAL=4                                                    
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECRO_DD_CFC A LE NUMERO 3
          VALRES(1)=3
          
      ENDIF                                                          

C     DEFINITION DE LA MATRICE D'INTERACTION
C     SOIT UN SEUL COEF H, SOIT H1,...H4,H5,H6
      NOMRES(1)='H'
      
      CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECRIS,0,' ',0.D0,
     &             1, NOMRES, H,CODRET,' ')
      IF (CODRET(1).EQ.'OK') THEN
         NBCOEF=1                          
         VALH(1)=H                                        
      ELSE
         NOMRES(1)='H1'
         NOMRES(2)='H2'
         NOMRES(3)='H3'
         NOMRES(4)='H4'
         NOMRES(5)='H5'
         NOMRES(6)='H6'
         CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECRIS,0,' ',0.D0,
     &               6,NOMRES, VALH,CODRET,' ')
C        IL FAUT AU MOINS H1 A H4
         DO 1 I=1,4
            IF (CODRET(I).NE.'OK') THEN
               CALL ASSERT(.FALSE.)
            ENDIF
 1       CONTINUE
         
         IF (CODRET(5).EQ.'OK') THEN 
            IF (CODRET(6).EQ.'OK') THEN
               NBCOEF=6
            ELSE
               NBCOEF=5
            ENDIF 
         ELSE
            NBCOEF=4
         ENDIF 
      ENDIF

      CALL LCMHSR (NBSYS, NBCOEF, VALH, HSRI)
      NBHSR=NBHSR+1
      IF (NBHSR.GT.5) CALL U2MESS('F','COMPOR1_22')
      DO 7 I=1,NBSYS
      DO 8 J=1,NBSYS
          HSR(NBHSR,I,J)=HSRI(I,J)
  8   CONTINUE
  7   CONTINUE
      NBVAL=NBVAL+1
      VALRES(NBVAL)=NBHSR
 9999 CONTINUE
      END
