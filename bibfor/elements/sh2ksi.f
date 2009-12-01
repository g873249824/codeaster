      SUBROUTINE SH2KSI(NPINT,XXG,XYG,XZG,BKSI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/08/2008   AUTEUR DESROCHES X.DESROCHES 
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
C*
C*     -----------------------------------------------------------------
C*
C*         DERIVEE P/R VARIABLES CANONIQUE AUX POINTS D INTEGRATION
C*          POUR LES ELEMENTS CUBES A 20 NOEUDS
C*     -----------------------------------------------------------------
C*
C*
C*   ENTREES 
C*     NPINT   : NBRE DE  PTS D INTEGRATION
C*     XXG,XYG,XZG      : COOR. CANONIQUES DES  PTS D INTEGRATION
C*
C*   SORTIES :  
C*     BKSI(3,20,NPINT) : LES DERIVEES
C*
      IMPLICIT NONE
C*
C*---    VARIABLES GLOBALES 
C*
      INTEGER NPINT
      REAL *8 XG(3),XXG(20),XYG(20),XZG(20)
      REAL *8 BKSI(3,20,20)
C*
C*---    VARIABLES LOCALES 
      INTEGER IP,I
C
      DO 10 IP=1,NPINT
        XG(1)=XXG(IP)
        XG(2)=XYG(IP)
        XG(3)=XZG(IP)
C
        BKSI(1,1,IP)= -0.125D0*(1.D0-XG(2))*(1.D0-XG(3))*
     &                (-1.D0-2.D0*XG(1)-XG(2)-XG(3))
        BKSI(1,2,IP)= 0.125D0*(1.D0-XG(2))*(1.D0-XG(3))*
     &                (-1.D0+2.D0*XG(1)-XG(2)-XG(3))
        BKSI(1,3,IP)= 0.125D0*(1.D0+XG(2))*(1.D0-XG(3))*
     &                (-1.D0+2.D0*XG(1)+XG(2)-XG(3))
        BKSI(1,4,IP)= -0.125D0*(1.D0+XG(2))*(1.D0-XG(3))*
     &                (-1.D0-2.D0*XG(1)+XG(2)-XG(3))
        BKSI(1,5,IP)= -0.125D0*(1.D0-XG(2))*(1+XG(3))*
     &                (-1.D0-2.D0*XG(1)-XG(2)+XG(3))
        BKSI(1,6,IP)= 0.125D0*(1.D0-XG(2))*(1.D0+XG(3))*
     &                (-1.D0+2.D0*XG(1)-XG(2)+XG(3))
        BKSI(1,7,IP)= 0.125D0*(1.D0+XG(2))*(1.D0+XG(3))*
     &                (-1.D0+2.D0*XG(1)+XG(2)+XG(3))
        BKSI(1,8,IP)= -0.125D0*(1.D0+XG(2))*(1.D0+XG(3))*
     &                (-1.D0-2.D0*XG(1)+XG(2)+XG(3))
        BKSI(1,9,IP)= -0.5D0*XG(1)*(1.D0-XG(2))*(1.D0-XG(3))
        BKSI(1,10,IP)= 0.25D0*(1.D0-XG(2)*XG(2))*(1.D0-XG(3))
        BKSI(1,11,IP)= -0.5D0*XG(1)*(1.D0+XG(2))*(1.D0-XG(3))
        BKSI(1,12,IP)= -0.25D0*(1.D0-XG(2)*XG(2))*(1.D0-XG(3))
        BKSI(1,13,IP)= -0.25D0*(1.D0-XG(2))*(1.D0-XG(3)*XG(3))
        BKSI(1,14,IP)= 0.25D0*(1.D0-XG(2))*(1.D0-XG(3)*XG(3))
        BKSI(1,15,IP)= 0.25D0*(1.D0+XG(2))*(1.D0-XG(3)*XG(3))
        BKSI(1,16,IP)= -0.25D0*(1.D0+XG(2))*(1.D0-XG(3)*XG(3))
        BKSI(1,17,IP)= -0.5D0*XG(1)*(1.D0-XG(2))*(1.D0+XG(3))
        BKSI(1,18,IP)= 0.25D0*(1.D0-XG(2)*XG(2))*(1.D0+XG(3))
        BKSI(1,19,IP)= -0.5D0*XG(1)*(1.D0+XG(2))*(1.D0+XG(3))
        BKSI(1,20,IP)= -0.25D0*(1.D0-XG(2)*XG(2))*(1.D0+XG(3))
C
        BKSI(2,1,IP)= -0.125D0*(1.D0-XG(1))*(1.D0-XG(3))*
     &                (-1.D0-XG(1)-2.D0*XG(2)-XG(3))
        BKSI(2,2,IP)= -0.125D0*(1.D0+XG(1))*(1.D0-XG(3))*
     &                (-1.D0+XG(1)-2.D0*XG(2)-XG(3))
        BKSI(2,3,IP)= 0.125D0*(1.D0+XG(1))*(1.D0-XG(3))*
     &                (-1.D0+XG(1)+2.D0*XG(2)-XG(3))
        BKSI(2,4,IP)= 0.125D0*(1.D0-XG(1))*(1.D0-XG(3))*
     &                (-1.D0-XG(1)+2.D0*XG(2)-XG(3))
        BKSI(2,5,IP)= -0.125D0*(1.D0-XG(1))*(1+XG(3))*
     &                (-1.D0-XG(1)-2.D0*XG(2)+XG(3))
        BKSI(2,6,IP)= -0.125D0*(1.D0+XG(1))*(1.D0+XG(3))*
     &                (-1.D0+XG(1)-2.D0*XG(2)+XG(3))
        BKSI(2,7,IP)= 0.125D0*(1.D0+XG(1))*(1.D0+XG(3))*
     &                (-1.D0+XG(1)+2.D0*XG(2)+XG(3))
        BKSI(2,8,IP)= 0.125D0*(1.D0-XG(1))*(1.D0+XG(3))*
     &                (-1.D0-XG(1)+2.D0*XG(2)+XG(3))
        BKSI(2,9,IP)= -0.25D0*(1.D0-XG(1)*XG(1))*(1.D0-XG(3))
        BKSI(2,10,IP)= -0.5D0*XG(2)*(1.D0+XG(1))*(1.D0-XG(3))
        BKSI(2,11,IP)= 0.25D0*(1.D0-XG(1)*XG(1))*(1.D0-XG(3))
        BKSI(2,12,IP)= -0.5D0*XG(2)*(1.D0-XG(1))*(1.D0-XG(3))
        BKSI(2,13,IP)= -0.25D0*(1.D0-XG(1))*(1.D0-XG(3)*XG(3))
        BKSI(2,14,IP)= -0.25D0*(1.D0+XG(1))*(1.D0-XG(3)*XG(3))
        BKSI(2,15,IP)= 0.25D0*(1.D0+XG(1))*(1.D0-XG(3)*XG(3))
        BKSI(2,16,IP)= 0.25D0*(1.D0-XG(1))*(1.D0-XG(3)*XG(3))
        BKSI(2,17,IP)= -0.25D0*(1.D0-XG(1)*XG(1))*(1.D0+XG(3))
        BKSI(2,18,IP)= -0.5D0*XG(2)*(1.D0+XG(1))*(1.D0+XG(3))
        BKSI(2,19,IP)= 0.25D0*(1.D0-XG(1)*XG(1))*(1.D0+XG(3))
        BKSI(2,20,IP)= -0.5D0*XG(2)*(1.D0-XG(1))*(1.D0+XG(3))
C
        BKSI(3,1,IP)= -0.125D0*(1.D0-XG(1))*(1.D0-XG(2))*
     &                (-1.D0-XG(1)-XG(2)-2.D0*XG(3))
        BKSI(3,2,IP)= -0.125D0*(1.D0+XG(1))*(1.D0-XG(2))*
     &                (-1.D0+XG(1)-XG(2)-2.D0*XG(3))
        BKSI(3,3,IP)= -0.125D0*(1.D0+XG(1))*(1.D0+XG(2))*
     &                (-1.D0+XG(1)+XG(2)-2.D0*XG(3))
        BKSI(3,4,IP)= -0.125D0*(1.D0-XG(1))*(1.D0+XG(2))*
     &                (-1.D0-XG(1)+XG(2)-2.D0*XG(3))
        BKSI(3,5,IP)= 0.125D0*(1.D0-XG(1))*(1-XG(2))*
     &                (-1.D0-XG(1)-XG(2)+2.D0*XG(3))
        BKSI(3,6,IP)= 0.125D0*(1.D0+XG(1))*(1.D0-XG(2))*
     &                (-1.D0+XG(1)-XG(2)+2.D0*XG(3))
        BKSI(3,7,IP)= 0.125D0*(1.D0+XG(1))*(1.D0+XG(2))*
     &                (-1.D0+XG(1)+XG(2)+2.D0*XG(3))
        BKSI(3,8,IP)= 0.125D0*(1.D0-XG(1))*(1.D0+XG(2))*
     &                (-1.D0-XG(1)+XG(2)+2.D0*XG(3))
        BKSI(3,9,IP)= -0.25D0*(1.D0-XG(1)*XG(1))*(1.D0-XG(2))
        BKSI(3,10,IP)= -0.25D0*(1.D0-XG(2)*XG(2))*(1.D0+XG(1))
        BKSI(3,11,IP)= -0.25D0*(1.D0-XG(1)*XG(1))*(1.D0+XG(2))
        BKSI(3,12,IP)= -0.25D0*(1.D0-XG(2)*XG(2))*(1.D0-XG(1))
        BKSI(3,13,IP)= -0.5D0*XG(3)*(1.D0-XG(1))*(1.D0-XG(2))
        BKSI(3,14,IP)= -0.5D0*XG(3)*(1.D0+XG(1))*(1.D0-XG(2))
        BKSI(3,15,IP)= -0.5D0*XG(3)*(1.D0+XG(1))*(1.D0+XG(2))
        BKSI(3,16,IP)= -0.5D0*XG(3)*(1.D0-XG(1))*(1.D0+XG(2))
        BKSI(3,17,IP)= 0.25D0*(1.D0-XG(1)*XG(1))*(1.D0-XG(2))
        BKSI(3,18,IP)= 0.25D0*(1.D0-XG(2)*XG(2))*(1.D0+XG(1))
        BKSI(3,19,IP)= 0.25D0*(1.D0-XG(1)*XG(1))*(1.D0+XG(2))
        BKSI(3,20,IP)= 0.25D0*(1.D0-XG(2)*XG(2))*(1.D0-XG(1))
C
   10 CONTINUE
C
      END
