      SUBROUTINE MPGLCP(TYPECP,NBNOLO,COORDO,ALPHA,BETA,
     &                  GAMMA,PGL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/10/2011   AUTEUR SELLENET N.SELLENET 
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
      IMPLICIT NONE
      CHARACTER*1 TYPECP
      INTEGER     NBNOLO
      REAL*8      COORDO(*),ALPHA,BETA,GAMMA,PGL(3,3)
C     --- ARGUMENTS ---
C ----------------------------------------------------------------------
C  CALCUL DE LA MATRICE DE PASSAGE GLOBAL -> LOCAL COQUES ET POUTRES
C               -          -       -         -     -         -
C ----------------------------------------------------------------------
C
C  ROUTINE CALCUL DE LA MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C    LOCAL DANS LE CAS DES COQUES ET DES POUTRES
C
C IN  :
C   TYPECP  K1   'P' OU 'C' POUR POUTRES OU COQUES
C   NBNOLO  I    NOMBRE DE NOEUDS, CLASSIQUEMENT 2 POUR LES POUTRES
C                  ET 3 OU 4 POUR LES COQUES
C   COORDO  R*   TABLEAU CONTENANT LES COORDOONEES DES NOEUDS
C                  DIMENSIONNE A NBNOLO*3
C   ALPHA   R    PREMIER ANGLE NAUTIQUE
C   BETA    R    DEUXIEME ANGLE NAUTIQUE
C   GAMMA   R    TROISIEME ANGLE NAUTIQUE
C
C  POUR LES POUTRES, SEUL GAMMA EST A FOURNIR (CAR ALPHA ET BETA SONT
C    RECALCULES A PARTIR DES COORDONNEES)
C  POUR LES COQUES, SEULS ALPHA ET BETA SONT A FOURNIR
C
C OUT :
C   PGL     R*   LA MATRICE DE PASSAGE DE DIMENSION 3*3
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      REAL*8  XD(3),ANGL(3),ALPHAL,BETAL,T2EV(2,2),T2VE(2,2)
C
      IF ( TYPECP.EQ.'P' ) THEN
C
        CALL ASSERT(NBNOLO.EQ.2)
C
C       CALCUL DE ALPHA ET BETA
        CALL VDIFF(3,COORDO(1),COORDO(4),XD)
        CALL ANGVX(XD,ALPHAL,BETAL)
C
        ANGL(1) = ALPHAL
        ANGL(2) = BETAL
        ANGL(3) = GAMMA
        CALL MATROT(ANGL,PGL)
C
      ELSEIF ( TYPECP.EQ.'C' ) THEN
C
C       CALCUL DE LA MATRICE DE PASSAGE GLOBAL -> INTRINSEQUE
        IF (NBNOLO.EQ.3) THEN
          CALL DXTPGL(COORDO,PGL)
        ELSEIF (NBNOLO.EQ.4) THEN
          CALL DXQPGL(COORDO,PGL)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
C       MODIFICATION DE LA MATRICE POUR PRENDRE EN COMPTE
C       LA CARCOQUE UTILISATEUR
        CALL COQREP(PGL,ALPHA,BETA,T2EV,T2VE)
        PGL(1,1) = T2VE(1,1)
        PGL(1,2) = T2VE(1,2)
        PGL(1,3) = 0.D0
        PGL(2,1) = T2VE(2,1)
        PGL(2,2) = T2VE(2,2)
        PGL(2,3) = 0.D0
        PGL(3,1) = 0.D0
        PGL(3,2) = 0.D0
        PGL(3,3) = 1.D0
C
      ENDIF
C
      END
