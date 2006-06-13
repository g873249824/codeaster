      SUBROUTINE RCMOM2(JMAT,TEMPP,IRRAP,VALE,E,ITRAC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/05/2004   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            IMATE,ITRAC,JMAT,NBMAT
      REAL*8             E,VALR(10),TEMPP,IRRAP
C ----------------------------------------------------------------------
C     DETERMINATION DU MODULE DE YOUNG ET DE LA FONCTION D'ECROUISSAGE
C     A PARTIR DE LA COURBE DE TRACTION D'UN MATERIAU DONNE

C IN  IMATE  : ADRESSE DU MATERIAU CODE
C OUT VALE   :  VALEURS DE LA FONCTION MZ(ALPHA)
C OUT E      : MODULE DE YOUNG
C OUT ITRAC  : =1 SI LA COURBE EXISTE, =0 SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER       ICOMP, IPI, IDF, NBF, IVALK, IK, IPIF
      REAL*8        VALPAR(2),VALE(10)
      CHARACTER*8   NOMPAR(2)
     
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
      INTEGER       LMAT,   LFCT
      PARAMETER    (LMAT=7, LFCT=9)
      INTEGER            NBPTMS
      COMMON/ICOELJ/      NBPTMS
C DEB ------------------------------------------------------------------
      
      NBMAT=ZI(JMAT)
C     UTILISABLE SEULEMENT AVEC UN MATERIAU PAR MAILLE
      CALL ASSERT(NBMAT.EQ.1)
      IMATE = JMAT+ZI(JMAT+NBMAT+1)
      
      ITRAC=1
      DO 10 ICOMP=1,ZI(IMATE+1)
        IF ( 'DIS_CONTACT' .EQ. ZK16(ZI(IMATE)+ICOMP-1)(1:11) ) THEN
          IPI = ZI(IMATE+2+ICOMP-1)
          GOTO 11
        ENDIF
 10   CONTINUE
      ITRAC=0
      GOTO 9999
 11   CONTINUE
      IDF   = ZI(IPI)+ZI(IPI+1)
      NBF   = ZI(IPI+2)
      IVALK = ZI(IPI+3)
      NBPAR = 2
      NOMPAR(1) = 'TEMP'
      NOMPAR(2) = 'INST'
      VALPAR(1) = TEMPP
      VALPAR(2) = IRRAP
      DO 160 IK = 1,NBF
        IPIF = IPI+LMAT-1+LFCT*(IK-1)
        IF ('ANGLE_1'.EQ. ZK8(IVALK+IDF+IK-1)(1:7)) THEN
         ITRAC=1
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(1))
        ELSE IF ('MOMENT_1'.EQ. ZK8(IVALK+IDF+IK-1)(1:8)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(5))
        ELSE IF ('ANGLE_2' .EQ. ZK8(IVALK+IDF+IK-1)(1:7)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(2))
        ELSE IF ('MOMENT_2'.EQ. ZK8(IVALK+IDF+IK-1)(1:8)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(6))
        ELSE IF ('ANGLE_3' .EQ. ZK8(IVALK+IDF+IK-1)(1:7)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(3))
        ELSE IF ('MOMENT_3'.EQ. ZK8(IVALK+IDF+IK-1)(1:8)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(7))
        ELSE IF ('ANGLE_4' .EQ. ZK8(IVALK+IDF+IK-1)(1:7)) THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(4))
        ELSE IF('MOMENT_4'.EQ. ZK8(IVALK+IDF+IK-1)(1:8))THEN
         CALL FOINTA (IPIF,NBPAR,NOMPAR,VALPAR,VALE(8))
        ENDIF
 160  CONTINUE     
C
C
C --- CONSTRUCTION DE LA COURBE R(P) 
C CALCUL DE E = PENTE (0,0;ALPHA1,M1)

      E = VALE(5)/VALE(1)
C
      VALE(1) = 0.0D0
      DO 300 K=2,4
        VALE(K) = VALE(K) - VALE(4+K)/E
 300  CONTINUE
9999  CONTINUE
      END
