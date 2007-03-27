      SUBROUTINE RCVAD2(FAMI,KPG,KSP,POUM,JMAT,PHENOM,NBRES,NOMRES,
     &                  VALRES,DEVRES,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER           KPG,KSP,IMAT,NBRES,JMAT
      CHARACTER*(*)     FAMI,POUM,CODRET(NBRES)
      CHARACTER*8       NOMRES(NBRES)
      CHARACTER*(*)     PHENOM
      REAL*8            TEMP,VALRES(NBRES),DEVRES(NBRES)
C ......................................................................
C     OBTENTION DE LA VALEUR DES COEFFICIENTS DU MATERIAU ET DE LEURS
C     DERIVEES PAR RAPPORT A LA TEMPERATURE
C
C IN   IMAT   : ADRESSE DU MATERIAU CODE
C IN   PHENOM : PHENOMENE
C IN   TEMP   : TEMPERATURE AU POINT DE GAUSS CONSIDERE
C IN   NBRES  : NOMBRE DES COEFFICIENTS
C IN   NOMRES : NOM DES COEFFICIENTS
C
C OUT  VALRES : VALEURS DES COEFFICIENTS
C OUT  DEVRES : DERIVEE DES COEFFICIENTS
C OUT  CODRET : POUR CHAQUE RESULTAT, 'OK' SI ON A TROUVE, 'NO' SINON
C ......................................................................
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C
      INTEGER            NBOBJ,NBF,NBR,IVALR,IVALK,IR,IDF,IRES,NBRESP
      INTEGER            LMAT,LFCT,IMATPR,ICOMP,IPI,IFON,IK, NBMAT,IRET
      CHARACTER*10       PHEN,PHEPRE
C
      LOGICAL            CHANGE
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
      PARAMETER        ( LMAT = 7 , LFCT = 9 )
C DEB ------------------------------------------------------------------
C

      PHEN = PHENOM
      CALL RCVARC('F','TEMP',POUM,FAMI,KPG,KSP,TEMP,IRET)
      NBMAT=ZI(JMAT)
C     UTILISABLE SEULEMENT AVEC UN MATERIAU PAR MAILLE
      CALL ASSERT(NBMAT.EQ.1)
      IMAT = JMAT+ZI(JMAT+NBMAT+1)

      DO 30 IRES = 1, NBRES
        CODRET(IRES)(1:2) = 'NO'
30    CONTINUE
C
      DO 40 ICOMP=1,ZI(IMAT+1)
        IF ( PHEN .EQ. ZK16(ZI(IMAT)+ICOMP-1)(1:10) ) THEN
          IPI = ZI(IMAT+2+ICOMP-1)
          GOTO 888
        ENDIF
40    CONTINUE
      CALL U2MESS('F','MODELISA5_46')
      GOTO 999
888   CONTINUE
C
      NBOBJ = 0
      NBR   = ZI(IPI)
      IVALK = ZI(IPI+3)
      IVALR = ZI(IPI+4)
      DO 150 IR = 1, NBR
        DO 140 IRES = 1, NBRES
          IF (NOMRES(IRES) .EQ. ZK8(IVALK+IR-1)) THEN
            VALRES(IRES) = ZR(IVALR-1+IR)
            DEVRES(IRES) = 0.D0
            CODRET(IRES)(1:2) = 'OK'
            NBOBJ = NBOBJ + 1
          ENDIF
140     CONTINUE
150   CONTINUE
C
      IF (NBOBJ .NE. NBRES) THEN
        IDF = ZI(IPI)+ZI(IPI+1)
        NBF = ZI(IPI+2)
        DO 170 IRES = 1,NBRES
          DO 160 IK = 1,NBF
            IF (NOMRES(IRES) .EQ. ZK8(IVALK+IDF+IK-1)) THEN
              IFON = IPI+LMAT-1+LFCT*(IK-1)
              CALL RCFODE(IFON,TEMP,VALRES(IRES),DEVRES(IRES))
              CODRET(IRES)(1:2) = 'OK'
            ENDIF
160       CONTINUE
170     CONTINUE
      ENDIF

999   CONTINUE
C FIN ------------------------------------------------------------------
      END
