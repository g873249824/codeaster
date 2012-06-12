      SUBROUTINE  CRIRUP(FAMI,IMAT,NDIM,NPG,LGPG,OPTION,COMPOR,
     & SIGP,VIP,VIM,INSTAM,INSTAP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/06/2012   AUTEUR PROIX J-M.PROIX 
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
      IMPLICIT NONE
C
C
C SOUS ROUTINE PERMETTANT L ELVALUATION DU CRITERE
C METHODE MISE EN OEUVRE : MOYENNE SUR LES POINTS DE GAUSS PUIS 
C EVALUATION DE LA CONTRAINTE PRINCIPALE MAXIMALE
C ------------------------------------------------------------------
C IN  FAMI  :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C    IMAT   :  ADRESSE DU MATERIAU CODE
C    NDIM   :  DIMENSION DE L'ESPACE
C    NPG    :  NOMBRE DE POINTS DE GAUSS
C    LGPG   :  NOMBRE TOTAL DE VI APRES AJOUT DES VI RUPTURE
C   OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG ,FULL_MECA ,RAPH_MECA
C   COMPOR  : CARTE DECRIVANT LES PARAMETRES K16 DU COMPORTEMENT
C     VIM   : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C    INSTAM : INSTANT PRECEDENT
C OUT  SIGP : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C     VIP   : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C    INSTAP : INSTANT DE CALCUL 
C-------------------------------------------------------------------
C DECLALRATION DES VARIABLES UTILES
      INTEGER NPG,KPG,I,NDIM,LGPG,IMAT,IVP,CERR

      REAL*8 SIGMOY(6),SIGP(2*NDIM,NPG),EQUI(20),SC,PRIN1,R8PREM
      REAL*8 VIP(LGPG,NPG),VIM(LGPG,NPG),PM,PP,DP,INSTAM,INSTAP,DT
C
      CHARACTER*(*) FAMI
      CHARACTER*16  OPTION, COMPOR(*)
C ---------------------------------------------------------------------
       
C CALCUL DU TENSEUR DES CONTRAINTES MOYEN PUIS DIAGONALISATION
      IF(OPTION(1:9).NE.'FULL_MECA'.AND.
     &   OPTION(1:9).NE.'RAPH_MECA') THEN
         GOTO 999
      ENDIF
 
      CALL RCVALB(FAMI,1,1,'+',IMAT,' ', 'CRIT_RUPT', 0,' ',
     &                0.D0, 1,'SIGM_C',  SC,  CERR, 1)     
      CALL R8INIR(6,0.D0,SIGMOY,1)

C     CALCUL DU TENSEUR MOYEN
      DO 200 I=1,2*NDIM
         DO 300 KPG=1,NPG
            SIGMOY(I)=SIGMOY(I)+SIGP(I,KPG)/NPG
 300     CONTINUE
 200  CONTINUE

C     EVALUATION DE LA CONTRAINTE PRINCIPALE MAXIMALE
      CALL FGEQUI ( SIGMOY, 'SIGM', NDIM, EQUI )
      PRIN1=MAX(EQUI(3),EQUI(4))
      PRIN1=MAX(EQUI(5),PRIN1)

C CALCUL DE P MOYEN
      PP=0
      PM=0
      IF (NDIM.EQ.2) THEN
         IVP=9
      ELSE
         IVP=13
      ENDIF
      DO 400 KPG=1,NPG
         PM=PM+VIM(IVP,KPG)/NPG
         PP=PP+VIP(IVP,KPG)/NPG
 400  CONTINUE
      DP=PP-PM
      DT=INSTAP-INSTAM

C     EVALUATION DE LA VITESSE DE DEFORMATION PLASTIQUE : DP/DT
C     ET DE DIFFERENTES ENERGIES :
C     V(LGPG-4) : ENERGIE DISSIPEE, DP*SIGMOY_EG
C     V(LGPG-3) : ENREGIE DISSIPEE CUMULEE à CHAQUE PAS,
C     V(LGPG-2) : PUISSANCE DISSIPEE, DP/DT*SIGMOY_EG
C     V(LGPG-1) : PUISSANCE DISSIPEE CUMULEE à CHAQUE PAS,
      DO 500 KPG=1,NPG
         VIP(LGPG-5,KPG)=DP/DT
         VIP(LGPG-4,KPG)=DP*EQUI(1)
         VIP(LGPG-3,KPG)=DP*EQUI(1)+VIM(LGPG-3,KPG)
         VIP(LGPG-2,KPG)=DP*EQUI(1)/DT
         VIP(LGPG-1,KPG)=DP*EQUI(1)/DT+VIM(LGPG-1,KPG)
 500  CONTINUE
 
C     CRITERE DE RUPTURE
      IF (PRIN1 . GT. SC) THEN
C LA CONTRAINTE PRINCIPALE MAXI DEPASSE LE SEUIL
         DO 600 KPG=1,NPG
            VIP(LGPG,KPG)=1.D0
 600     CONTINUE
      ELSEIF (ABS(VIM(LGPG,1)-1.D0).LT.R8PREM()) THEN
C LA MAILLE ETAIT DEJA CASSEE. ELLE LE RESTE
         DO 601 KPG=1,NPG
            VIP(LGPG,KPG)=1.D0
 601     CONTINUE
      ELSE
C MAILLE SAINE
         DO 602 KPG=1,NPG
            VIP(LGPG,KPG)=0.D0
 602     CONTINUE
      ENDIF

 999  CONTINUE
      END
