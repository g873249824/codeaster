      SUBROUTINE TE0551 ( OPTION , NOMTE )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16        OPTION , NOMTE
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C FONCTION REALISEE: CALCUL DE LA DURETE ASSOCIEE A LA METALLURGIE
C                    EN 2D ET AXI
C OPTION : 'DURT_ELNO'
C - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C----------------------------------------------------------------------
C
C
C
      CHARACTER*8 FAMI,POUM
      CHARACTER*24       NOMRES(5)
      INTEGER ICODRE(5)
      REAL*8             PHASE(5),VALRES(5),ZALPHA,DURTNO
      INTEGER            MATOS,IMATE,IPHASI,IDURT,KN,I,KPG,SPT
      INTEGER            NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PPHASIN','L',IPHASI)
      CALL JEVECH('PDURT_R','E',IDURT)
      MATOS = ZI(IMATE)
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
C
      DO 300 KN=1,NNO
C
C----RECUPERATION DES CARACTERISTIQUES
        NOMRES(1) = 'F1_DURT'
        NOMRES(2) = 'F2_DURT'
        NOMRES(3) = 'F3_DURT'
        NOMRES(4) = 'F4_DURT'
        NOMRES(5) = 'C_DURT'
        CALL RCVALB(FAMI,KPG,SPT,POUM,MATOS,' ','DURT_META',1,'TEMP',
     &              0.D0,5,NOMRES,VALRES,ICODRE,2)
C
C
C----RECUPERATION Z POUR CHAQUE PHASE
        ZALPHA = 0.D0
        DO 10 I=1,4
           PHASE(I) = ZR(IPHASI+7*(KN-1)+I-1)
           ZALPHA = ZALPHA + PHASE(I)
10      CONTINUE
           PHASE(5) = 1-ZALPHA
C
C----CALCUL DE LA DURETE ----------------------------------------------
C
        DURTNO = 0.D0
        DO 400 I=1,5
        DURTNO = DURTNO+PHASE(I)*VALRES(I)
400     CONTINUE
        ZR(IDURT+(KN-1))=DURTNO

C
300   CONTINUE
C

      CALL JEDEMA()
      END
