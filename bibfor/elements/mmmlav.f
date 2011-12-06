      SUBROUTINE MMMLAV(LCOMPL,LUSURE,LDYNA ,LFOVIT,ASPERI,
     &                  KAPPAN,KAPPAV,DELTAT,BETA  ,GAMMA ,
     &                  THETA ,PRFUSU,CWEAR ,JEUSUP,NDEXFR,
     &                  TYPBAR,TYPRAC,COEFAC,COEFAF)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      LOGICAL LCOMPL,LUSURE,LFOVIT,LDYNA
      REAL*8  DELTAT,BETA,GAMMA,THETA
      REAL*8  JEUSUP
      REAL*8  PRFUSU,CWEAR
      REAL*8  ASPERI,KAPPAN,KAPPAV
      INTEGER NDEXFR,TYPBAR,TYPRAC
      REAL*8  COEFAC,COEFAF
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
C
C PREPARATION DES CALCULS - LECTURE FONCTIONNALITES AVANCEES
C
C ----------------------------------------------------------------------
C
C
C OUT LCOMPL : .TRUE. SI COMPLIANCE ACTIVEE
C OUT LUSURE : .TRUE. SI USURE ACTIVEE
C OUT LDYNA  : .TRUE. SI DYNAMIQUE
C OUT LFOVIT : .TRUE. SI FORMULATION EN VITESSE
C OUT ASPERI : PARAMETRE A DU MODELE DE COMPLIANCE (PROF. ASPERITE)
C OUT KAPPAN : COEFFICIENT KN DU MODELE DE COMPLIANCE
C OUT KAPPAV : COEFFICIENT KV DU MODELE DE COMPLIANCE
C OUT DELTAT : INCREMENT DE TEMPS
C OUT BETA   : COEFFICIENT SCHEMA DE NEWMARK
C OUT GAMMA  : COEFFICIENT SCHEMA DE NEWMARK
C OUT THETA  : COEFFICIENT SCHEMA THETA
C OUT PRFUSU : JEU SUPPLEMENTAIRE PAR PROFONDEUR D'USURE
C OUT CWEAR  : COEFFICIENT D'USURE 
C OUT JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
C OUT TYPRAC : ARETE SUR LAQUELLE UN NOEUD MILIEU EST A LINEARISER
C OUT NDEXFR : ENTIER CODE POUR EXCLUSION DIRECTION DE FROTTEMENT
C OUT TYPBAR : ARETE OU POINT EN FOND DE FISSURE
C I/O COEFAC : COEF_AUGM_CONT
C I/O COEFAF : COEF_AUGM_FROT
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
      INTEGER      JPCF,JUSUP
      INTEGER      ICOMPL,IUSURE,IFORM
      REAL*8       KW,HW
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- RECUPERATION DES DONNEES DU CHAM_ELEM DU CONTACT
C
      CALL JEVECH('PCONFR','L',JPCF )
      JEUSUP   =      ZR(JPCF-1+14)
      NDEXFR   = NINT(ZR(JPCF-1+29))
      TYPBAR   = NINT(ZR(JPCF-1+30))
      TYPRAC   = NINT(ZR(JPCF-1+31))
      IFORM    = NINT(ZR(JPCF-1+32))
      DELTAT   =      ZR(JPCF-1+33)
      BETA     =      ZR(JPCF-1+34)
      GAMMA    =      ZR(JPCF-1+35)
      THETA    =      ZR(JPCF-1+36)
      ICOMPL   = NINT(ZR(JPCF-1+21))
      ASPERI   =      ZR(JPCF-1+22)
      KAPPAN   =      ZR(JPCF-1+23)
      KAPPAV   =      ZR(JPCF-1+24)
      IUSURE   = NINT(ZR(JPCF-1+26))
      KW       =      ZR(JPCF-1+27)
      HW       =      ZR(JPCF-1+28)   
C
C --- FONCTIONNALITES ACTIVEES
C
      LCOMPL   = ICOMPL.EQ.1
      LUSURE   = IUSURE.EQ.1
      LFOVIT   = IFORM.EQ.2
      LDYNA    = IFORM.NE.0
C
C --- RECUPERATION JEU USURE
C
      IF (LUSURE) THEN
        CALL JEVECH('PUSULAR','L',JUSUP )
        PRFUSU = ZR(JUSUP-1+1)
      ELSE
        PRFUSU = 0.D0
      END IF
C
      IF (HW.NE.0.D0) THEN
        CWEAR = KW/HW
      ELSE
        CWEAR = 0.D0
      ENDIF 
C
C --- COEFFICIENTS MODIFIES POUR FORMULATION EN THETA-VITESSE
C
      IF (LFOVIT) THEN
        COEFAF = COEFAF/DELTAT/THETA
        COEFAC = COEFAC/DELTAT/THETA
      ENDIF      
C
      CALL JEDEMA()
      END
