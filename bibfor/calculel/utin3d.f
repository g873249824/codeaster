      SUBROUTINE UTIN3D(IGEOM,NSOMM,INO,ITYP,INST,INSOLD,K8CART,LTHETA,
     &                  NIV,IFM,OPTION,VALFP,VALFM,NOE)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/02/2002   AUTEUR BOITEAU O.BOITEAU 
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
C RESPONSABLE  O.BOITEAU
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  UTILITAIRE D'INTERPOLATION 3D DE CHARGE 
C                          POUR AERER TE0003
C
C IN IGEOM : ADRESSE JEVEUX DE LA GEOMETRIE
C IN NSOMM    : NOMBRE DE SOMMETS DE LA FACE
C IN INO      : NUMERO DE FACE
C IN ITYP     : TYPE DE FACE
C IN INST/INSOLD : INSTANT + / INSTANT -
C IN K8CART   : CHAMP JEVEUX A INTERPOLER
C IN LTHETA   : LOGICAL = TRUE SI THETA DIFFERENT DE 1
C IN IFM/NIV/OPTION  : PARAMETRES D'AFFICHAGE
C IN NOE : TABLEAU NUMEROS NOEUDS PAR FACE ET PAR TYPE D'ELEMENT 3D
C OUT VALFP/M : VALEUR DU CHAMP RESULTAT AU INSTANTS +/- ET
C               AUX POINTS CI-DESSUS
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       FOINTE.
C
C     FONCTIONS INTRINSEQUES:
C       AUCUNE.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       24/09/01 (OB): CREATION POUR SIMPLIFIER TE0003.F.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER IGEOM,NSOMM,INO,ITYP,IFM,NIV,OPTION,NOE(9,6,3)
      REAL*8 INST,INSOLD,VALFP(9),VALFM(9)
      CHARACTER*8 K8CART
      LOGICAL LTHETA

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      
C DECLARATION VARIABLES LOCALES
      INTEGER ICODE,IN,IINO,IAUX,JAUX,KAUX
      REAL*8 VALPAR(4)
      CHARACTER*8 NOMPAR(4) 
     
C INIT
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
      NOMPAR(4) = 'INST'

C BOUCLE SUR LES SOMMETS DE LA FACE
      DO 100 IN=1,NSOMM

C NUMEROTATION LOCALE DU NOEUD A INTERPOLER
        IINO = NOE(IN,INO,ITYP)
        IAUX = IGEOM + 3*(IINO-1)
        JAUX = IAUX + 1
        KAUX = JAUX + 1
                    
C INTERPOLATION CHAMP K8CART A L'INSTANT +     
        VALPAR(1) = ZR(IAUX)
        VALPAR(2) = ZR(JAUX)
        VALPAR(3) = ZR(KAUX)
        VALPAR(4) = INST
        CALL FOINTE('FM',K8CART,4,NOMPAR,VALPAR,VALFP(IN),ICODE)
        IF (LTHETA) THEN
C INTERPOLATION CHAMP K8CART A L'INSTANT -    
          VALPAR(4) = INSOLD
          CALL FOINTE('FM',K8CART,4,NOMPAR,VALPAR,VALFM(IN),ICODE)
        ENDIF

C AFFICHAGES
        IF (NIV.EQ.2) THEN
          WRITE(IFM,*)' X/Y/Z ',VALPAR(1),VALPAR(2),VALPAR(3)
          IF (OPTION.EQ.1) THEN
            WRITE(IFM,*)' VALFP ',VALFP(IN)
          ELSE IF (OPTION.EQ.2) THEN
            WRITE(IFM,*)' VALHP ',VALFP(IN)
          ELSE
            WRITE(IFM,*)' VALTP ',VALFP(IN)
          ENDIF
          IF (LTHETA) WRITE(IFM,*)'     M ',VALFM(IN)
        ENDIF          
          
  100 CONTINUE
   
      END
