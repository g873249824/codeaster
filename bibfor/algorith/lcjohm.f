      SUBROUTINE  LCJOHM(IMATE ,RESI  ,RIGI  ,KPI   ,NPG   ,NOMAIL,
     &                   ADDEME,ADVICO,NDIM  ,DIMDEF,DIMCON,NBVARI,
     &                   DEFGEM,DEFGEP,VARIM ,VARIP ,SIGM  ,SIGP  ,
     &                   DRDE  ,OUVH  ,RETCOM)

      IMPLICIT NONE

C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/07/2010   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C TOLE CRP_21
C ======================================================================
C - VARIABLES D'ENTREE

      INTEGER IMATE,KPI,NPG,ADDEME,ADVICO,NDIM,DIMDEF,DIMCON,NBVARI
      REAL*8  DEFGEM(DIMDEF),VARIM(NBVARI),SIGM(DIMCON)
      CHARACTER*8 NOMAIL
      LOGICAL RESI,RIGI

C - VARIABLES DE SORTIE

      INTEGER RETCOM
      REAL*8 DEFGEP(DIMDEF),VARIP(NBVARI),SIGP(DIMCON)
      REAL*8 DRDE(DIMDEF,DIMDEF),OUVH

C - VARIABLES LOCALES

      INTEGER IBID,I
      REAL*8 KNI,UMC,GAMMA,KT,CLO,PARA(4),VALR(2),TMECN,TMECS
      CHARACTER*8 NCRA1(4)
      CHARACTER*2 CODRET(18)

      DATA NCRA1 / 'K','DMAX','GAMMA','KT' /

C - RECUPERATION DES PARAMETRES MATERIAU

      CALL RCVALA(IMATE,' ','JOINT_BANDIS',0,' ', 0.D0,4,
     &                                 NCRA1(1),PARA(1),CODRET,'FM')
         KNI    = PARA(1)
         UMC    = PARA(2)
         GAMMA     = PARA(3)
         KT = PARA(4)

C - MISE A JOUR FERMETURE
         CLO = 0.D0
         OUVH = VARIM(ADVICO)
         CLO = UMC - OUVH
         CLO = CLO - DEFGEP(ADDEME) + DEFGEM(ADDEME)

C - CALCUL CONTRAINTES

        IF (RESI) THEN
          IF ((CLO.GT.UMC) .OR.(CLO.LT.-1.D-3))  THEN
            VALR(1) = CLO
            VALR(2) = UMC
            CALL U2MESG('A','ALGORITH17_11',1,NOMAIL,0,IBID,2,VALR)
            RETCOM = 1
            GO TO 9000
          ENDIF

          OUVH = UMC-CLO  
          VARIP(ADVICO) = OUVH

          DO 10 I=1,DIMCON
            SIGP(I)=0.D0
 10       CONTINUE
            SIGP(1)=SIGM(1)
     &        -KNI/(1-CLO/UMC)**GAMMA*(VARIM(ADVICO)-VARIP(ADVICO))
            DO 20 I=2,NDIM
              SIGP(I)=SIGM(I)+KT*(DEFGEP(ADDEME+1)-DEFGEM(ADDEME+1))
 20         CONTINUE
        END IF

C - CALCUP OPERATEUR TANGENT

        IF (RIGI .AND. (KPI .LE. NPG)) THEN
          TMECN = KNI/(1-CLO/UMC)**GAMMA
          TMECS = KT

          DRDE(ADDEME,ADDEME)= TMECN
          DO 30 I=2,NDIM
            DRDE(ADDEME+I-1,ADDEME+I-1)= TMECS
 30       CONTINUE
        END IF

 9000 CONTINUE

      END
