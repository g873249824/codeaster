      SUBROUTINE XMMJAC(ALIAS ,GEOM ,DFF,JAC   )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      CHARACTER*8  ALIAS
      REAL*8       DFF(3,9),GEOM(9),JAC
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEM GR GLISS - UTILITAIRE)
C
C CALCUL DU JACOBIEN D'UN ELEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
C IN  GEOM   : VECTEUR GEOMETRIE ACTUALISEE
C IN  DFF    : DERIVEES PREMIERES DES FONCTIONS DE FORME EN XI YI
C OUT JAC    : VALEUR DU JACOBIEN
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C      
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER I
      REAL*8  DXDS,DYDS,DZDS
      REAL*8  DXDE,DXDK,DYDE,DYDK,DZDE,DZDK
C
C ----------------------------------------------------------------------
C
      DXDS = 0.D0
      DYDS = 0.D0
      DZDS = 0.D0 
      DXDE = 0.D0
      DYDE = 0.D0
      DZDE = 0.D0
      DXDK = 0.D0
      DYDK = 0.D0
      DZDK = 0.D0               
C

      IF (ALIAS(1:5).EQ.'SE2') THEN
        DO 10 I = 1,2
          DXDS = DXDS + GEOM(2*(I-1)+1)*DFF(1,I)
          DYDS = DYDS + GEOM(2*(I-1)+2)*DFF(1,I)
   10   CONTINUE
        JAC = SQRT(DXDS**2+DYDS**2+DZDS**2)
      ELSE IF (ALIAS(1:5).EQ.'TR3') THEN
        DO 20 I = 1,3
          DXDE = DXDE + GEOM(3*I-2)*DFF(1,I)
          DXDK = DXDK + GEOM(3*I-2)*DFF(2,I)
          DYDE = DYDE + GEOM(3*I-1)*DFF(1,I)
          DYDK = DYDK + GEOM(3*I-1)*DFF(2,I)
          DZDE = DZDE + GEOM(3*I)*DFF(1,I)
          DZDK = DZDK + GEOM(3*I)*DFF(2,I)
          IF (DZDE.NE.0) THEN
          ENDIF
   20   CONTINUE
        JAC = SQRT((DYDE*DZDK-DZDE*DYDK)**2+ (DZDE*DXDK-DXDE*DZDK)**2+
     &        (DXDE*DYDK-DYDE*DXDK)**2)
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      END
