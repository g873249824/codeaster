      SUBROUTINE  SOFOSU(NNO,NPG,POIDSG,VFF,DFF,GEOM,SIG,VECTU,DT,TA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/97   AUTEUR AUBERT1 P.AUBERT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C
      IMPLICIT NONE
      INTEGER       NNO, NPG
      REAL*8        POIDSG(NPG), VFF(NNO,NPG), DFF(2,NNO,NPG)
      REAL*8        GEOM(3,NNO), SIG(7,NPG), VECTU(2,NNO), DT, TA
C.......................................................................
C
C     BUT:  CALCUL  DE FORC_NODA
C     EN MECANIQUE DES MILIEUX POREUX AVEC COUPLAGE THM 3D_JOINT_*
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFF     : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  SIG     : CONTRAINTES LAGRANGIENNES THM
C OUT VECTU   : FORCES NODALES
C IN  DT      : INCREMENT DE TEMPS
C IN  TA      : THETA
C......................................................................
C
      INTEGER KPG,I7,I8,II
      REAL*8  POIDS,S4(2),S5(2),S2,S3,S3B,A(2,2),METR(2,2)
      REAL*8  TMP1,TMP2,TA1,COVA(3,3),CNVA(3,2),JAC
C ....................................................................
C
      TA1 = 1.D0-TA
      DO 10 KPG = 1, NPG
C
C        RECUPERATION DES CONTRAINTES
C        NOMENCLATURE : C.F. DOC. R
         S2  =   SIG (1,KPG)
         S3  =   SIG (2,KPG)
         S3B =   SIG (3,KPG)
C        S3B EST NUL EN 3D_JOINT_CT
         S4(1) = SIG (4,KPG)
         S4(2) = SIG (5,KPG)
         S5(1) = SIG (6,KPG)
         S5(2) = SIG (7,KPG)
C
C        CALCUL DU CORRECTIF DS D INTEGRATION  JAC SUR LA SURFACE
C
         CALL SUBACO(NNO,DFF(1,1,KPG),GEOM,COVA)
         CALL SUMETR(COVA,METR,JAC)
         CALL SUBACV(COVA,METR,JAC,CNVA,A)
         POIDS=POIDSG(KPG)*JAC
C
         DO 101 II=1,NNO
            TMP1 = 0.D0
            TMP2 = 0.D0
            DO 102 I7=1,2
               DO 103 I8=1,2
                  TMP1 = TMP1 - A(I7,I8)*DFF(I8,II,KPG)*S4(I7)*DT*TA1
                  TMP2 = TMP2 - A(I7,I8)*DFF(I8,II,KPG)*S5(I7)*DT*TA1
 103              CONTINUE
 102           CONTINUE
 101        CONTINUE
            VECTU(1,II)=-(VFF(II,KPG)*S2+TMP1)*POIDS + VECTU(1,II)
            VECTU(2,II)=-(VFF(II,KPG)*(S3+TA1*DT*S3B)+TMP2)*POIDS
     &                 +VECTU(2,II)
 180     CONTINUE
 10   CONTINUE
      END
