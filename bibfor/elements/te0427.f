      SUBROUTINE TE0427(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE
C.......................................................................
C          MODELISATION : VF1
C          OPTION       : 'RIGI_MECA' OU 'CHAR_MECA_PESA_R'
C.......................................................................
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI

      CHARACTER*16 CODVOI
      INTEGER NVOIMA,NSCOMA,NBVOIS
      PARAMETER(NVOIMA=100,NSCOMA=4)
      INTEGER LIVOIS(1:NVOIMA),TYVOIS(1:NVOIMA),NBNOVO(1:NVOIMA)
      INTEGER NBSOCO(1:NVOIMA),LISOCO(1:NVOIMA,1:NSCOMA,1:2)

      CHARACTER*4 FAMI
      INTEGER NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO
      INTEGER IGEOM,IMATE,IMATU,IADZI,IAZK24,NUMA,IGEOM2
      INTEGER KVOIS,NUMAV,NNOV,K1,K2
      INTEGER ICO2,IMATU2,IRET,IVECTU


      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)


C     -- OPTION CHAR_MECA_PESA_R (BIDON):
C     -----------------------------------
      IF (OPTION.EQ.'CHAR_MECA_PESA_R') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        DO 21, K1=1,NNO
          ZR(IVECTU-1+K1)=13.D0
 21     CONTINUE
        GOTO 9999
      ENDIF


C     -- OPTION RIGI_MECA (BIDON):
C     ----------------------------
      CODVOI='A2'

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PMATUNS','E',IMATU)
      CALL TECACH('OOO','PMATUNS',1,IMATU2,IRET)
      CALL ASSERT(IRET.EQ.0)
      CALL ASSERT(IMATU2.EQ.IMATU)

      CALL TECAEL(IADZI,IAZK24)
      NUMA=ZI(IADZI-1+1)

      ICO2=0
      NUMAV=NUMA
      DO 10,K2=1,NNO
        DO 11, K1=1,NNO
          ICO2=ICO2+1
          ZR(IMATU-1+ICO2)=1000.D0*NUMA+NUMAV
 11     CONTINUE
 10   CONTINUE

      CALL VOIUTI(NUMA,CODVOI,NVOIMA,NSCOMA,JREPE,JPTVOI,JELVOI,
     &                  NBVOIS,LIVOIS,TYVOIS,NBNOVO,NBSOCO,LISOCO)
      DO 1,KVOIS=1,NBVOIS
        NNOV=NBNOVO(KVOIS)
        NUMAV=LIVOIS(KVOIS)
        CALL TECAC2('OOO',NUMAV,'PGEOMER',1,IGEOM2,IRET)
        CALL ASSERT(IRET.EQ.0)
        DO 2, K2=1,NNOV
          DO 3, K1=1,NNO
            ICO2=ICO2+1
            ZR(IMATU-1+ICO2)=1000.D0*NUMA+NUMAV
 3        CONTINUE
 2      CONTINUE
 1    CONTINUE

 9999 CONTINUE
      END
