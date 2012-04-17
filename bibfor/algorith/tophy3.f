      SUBROUTINE TOPHY3(ICHO,IA,DPLMOD,NBCHOC,NBMODE,XGENE,
     &                  UX,UY,UZ,NBEXCI,PSIDEL,COEF)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2004   AUTEUR BOYERE E.BOYERE 
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
C-----------------------------------------------------------------------
C    CONVERTIT EN BASE PHYSIQUE POUR DES DDLS GENERALISES DONNES
C
C    IN  : ICHO      :   INDICE CARACTERISANT LA NON-LINEARITE
C    IN  : IA        :   INDICE = 0 => TRAITEMENT DU NOEUD_1
C                               = 3 => TRAITEMENT DU NOEUD_2
C    IN  : DPLMOD    :   VECTEUR DES DEPL MODAUX AUX NOEUDS DE CHOC
C    IN  : NBCHOC    :   NOMBRE DE CHOCS
C    IN  : NBMODE    :   NB DE MODES NORMAUX CONSIDERES
C    IN  : XGENE     :   VECTEUR DES COORDONNEES GENERALISEES
C    OUT : UX,Y,Z    :   VALEURS DES DDLS CORRESPONDANTS
C
C    IN  : TEMPS     :   INSTANT DE CALCUL DES DEPL_IMPO
C    IN  : NBEXCI    :   NOMBRE D'ACCELERO DIFFERENTS
C    IN  : PSIDEL    :   VALEUR DU VECTEUR PSI*DELTA
C    IN  : COEF      :   INTENSITE DE L'EXCITATION A L'INSTANT T
C-----------------------------------------------------------------------
C
      INTEGER      ICHO,IA,NBMODE,NBCHOC
      REAL*8       XGENE(NBMODE),DPLMOD(NBCHOC,NBMODE,*)
      REAL*8       PSIDEL(NBCHOC,NBEXCI,*),UX,UY,UZ,COEF(NBEXCI)
C
C ----------------------------------------------------------------------
C
C      ----DEBUT DES COMMUNS JEVEUX--------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C      ----FIN DES COMMUNS JEVEUX----------
C

      UX=0.0D0
      UY=0.0D0
      UZ=0.0D0
C
C
      DO 10 I=1,NBMODE
        UX = UX + DPLMOD(ICHO,I,1+IA)*XGENE(I)
10    CONTINUE
      DO 11 IEX=1,NBEXCI
        UX = UX + PSIDEL(ICHO,IEX,1+IA)*COEF(IEX)
11    CONTINUE
C
      DO 20 I=1,NBMODE
        UY = UY + DPLMOD(ICHO,I,2+IA)*XGENE(I)
20    CONTINUE
      DO 21 IEX=1,NBEXCI
        UY = UY + PSIDEL(ICHO,IEX,2+IA)*COEF(IEX)
21    CONTINUE
C
      DO 30 I=1,NBMODE
        UZ = UZ + DPLMOD(ICHO,I,3+IA)*XGENE(I)
30    CONTINUE
      DO 31 IEX=1,NBEXCI
        UZ = UZ + PSIDEL(ICHO,IEX,3+IA)*COEF(IEX)
31    CONTINUE
C
      END
