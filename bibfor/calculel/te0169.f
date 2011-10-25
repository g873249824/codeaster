      SUBROUTINE TE0169 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 24/10/2011   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C SUPPRESSION D'INSTRUCTIONS INUTILES
      IMPLICIT NONE
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES FORCES NODALES DE MEPOULI
C                          REFE_FORC_NODA
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
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
      REAL*8   W(9),L1(3),L2(3),FORREF
      REAL*8   NORML1,NORML2,DDOT,COEF1,COEF2
      INTEGER  JEFINT,LSIGMA,IGEOM,IDEPLA,IDEPLP,IVECTU,NNO,NC
      INTEGER  INO,I,KC,IRET
C ----------------------------------------------------------------------
C
      IF(OPTION.EQ.'REFE_FORC_NODA')THEN
         NNO = 3
         NC  = 3
         CALL TEREFE('EFFORT_REFE','MECA_POULIE',FORREF)
         CALL JEVECH('PVECTUR','E',IVECTU)
         DO 101 INO=1,NNO
            DO 102  I=1,NC
               ZR(IVECTU+(INO-1)*NC+I-1)=FORREF
102         CONTINUE
101      CONTINUE

      ELSEIF(OPTION.EQ.'FORC_NODA')THEN

C        PARAMETRES EN ENTREE
         CALL JEVECH('PGEOMER','L',IGEOM)
C
         CALL JEVECH('PDEPLMR','L',IDEPLA)
         CALL TECACH('ONN','PDEPLPR',1,IDEPLP,IRET)
         CALL JEVECH('PCONTMR','L',LSIGMA)
C        PARAMETRES EN SORTIE
         CALL JEVECH('PVECTUR','E',JEFINT)
C
         IF (IDEPLP.EQ.0) THEN
            DO 10 I=1,9
               W(I)=ZR(IDEPLA-1+I)
10          CONTINUE
         ELSE
            DO 11 I=1,9
               W(I)=ZR(IDEPLA-1+I)+ZR(IDEPLP-1+I)
11          CONTINUE
         END IF
C
         DO 21 KC=1,3
            L1(KC) = W(KC  )+ZR(IGEOM-1+KC)-W(6+KC)-ZR(IGEOM+5+KC)
21       CONTINUE
         DO 22 KC=1,3
            L2(KC) = W(3+KC)+ZR(IGEOM+2+KC)-W(6+KC)-ZR(IGEOM+5+KC)
22       CONTINUE
         NORML1=DDOT(3,L1,1,L1,1)
         NORML2=DDOT(3,L2,1,L2,1)
         NORML1 = SQRT (NORML1)
         NORML2 = SQRT (NORML2)
C
         COEF1 = ZR(LSIGMA) / NORML1
         COEF2 = ZR(LSIGMA) / NORML2
C
         DO 15 I=1,3
            ZR(JEFINT+I-1)   = COEF1 * L1(I)
            ZR(JEFINT+I+2) = COEF2 * L2(I)
            ZR(JEFINT+I+5) = -ZR(JEFINT+I-1) - ZR(JEFINT+I+2)
15       CONTINUE
      ENDIF
      END
