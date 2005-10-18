      SUBROUTINE UTELVF ( ELREFA, FAMIL, NOMJV, NPG, NNO )
      IMPLICIT NONE
      INTEGER       NPG, NNO
      CHARACTER*8   ELREFA, FAMIL
      CHARACTER*(*) NOMJV
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2005   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C BUT: RECUPERER LES VALEURS DES FONCTIONS DE FORME
C ----------------------------------------------------------------------
C   IN   ELREFA : NOM DE L'ELREFA (K8)
C        FAMIL  : NOM DE LA FAMILLE DE POINTS DE GAUSS :
C                 'FPG1','FPG3',...
C   IN   NOMJV  : NOM JEVEUX POUR STOCKER LES FONCTIONS DE FORME
C   OUT  NPG    : NOMBRE DE POINTS DE GAUSS
C        NNO    : NOMBRE DE NOEUDS DU TYPE_MAILLE
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN DECLARATIONS NORMALISEES  JEVEUX ---------------------

      INTEGER    NBPGMX,    NBNOMX,    NBFAMX
      PARAMETER (NBPGMX=27, NBNOMX=27, NBFAMX=10)
C
      INTEGER      NBPG(NBFAMX), NDIM, NNOS, NBFPG
      INTEGER      IFAM, DECAL, IPG, INO, JVR, VOL
      REAL*8       XNO(3*NBNOMX),XPG(3*NBPGMX),POIPG(NBPGMX),FF(NBNOMX)
      CHARACTER*8  NOFPG(NBFAMX)
C DEB ------------------------------------------------------------------
C
      CALL ELRACA ( ELREFA, NDIM,NNO,NNOS,NBFPG,NOFPG,NBPG,XNO,VOL )
C
      CALL ASSERT((NDIM.GE.0) .AND. (NDIM.LE.3))
      CALL ASSERT((NNO.GT.0) .AND. (NNO.LE.NBNOMX))
      CALL ASSERT((NBFPG.GT.0) .AND. (NBFPG.LE.NBFAMX))
C
      DO 10,IFAM = 1,NBFPG
        IF ( NOFPG(IFAM) .EQ. FAMIL ) GOTO 12
 10   CONTINUE
      CALL UTMESS('F','UTELVF','FAMILLE INEXISTANTE '//FAMIL)
 12   CONTINUE
C
      NPG = NBPG(IFAM)
      CALL ASSERT((NPG.GT.0) .AND. (NPG.LE.NBPGMX))
C
      CALL WKVECT ( NOMJV, 'V V R', NPG*NNO, JVR )
C
C       -- COORDONNEES ET POIDS DES POINTS DE GAUSS :
C       ------------------------------------------------
        CALL ELRAGA ( ELREFA, NOFPG(IFAM), NDIM, NPG, XPG, POIPG )
C
C     -- VALEURS DES FONCTIONS DE FORME :
C     ------------------------------------------------
      DECAL = 0
      DO 20 IPG = 1 , NPG
         CALL ELRFVF ( ELREFA, XPG(NDIM*(IPG-1)+1), NBNOMX, FF, NNO )
         DO 22 INO = 1 , NNO
            DECAL = DECAL + 1
            ZR(JVR-1+DECAL) = FF(INO)
 22      CONTINUE
 20   CONTINUE
C
      END
