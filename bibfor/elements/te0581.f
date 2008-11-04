      SUBROUTINE TE0581 ( OPTION , NOMTE )
      IMPLICIT NONE
C-----------------------------------------------------------------------
C MODIF ELEMENTS  DATE 03/11/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C-----------------------------------------------------------------------
C  DESCRIPTION : REALISE L'OPTION ADD_SIGM :
C  -----------   ADDITION DE CONTRAINTES AUX ELEMENTS
C
C  IN     : OPTION : CHARACTER*16 , SCALAIRE
C                    OPTION DE CALCUL
C  IN     : NOMTE  : CHARACTER*16 , SCALAIRE
C                    NOM DU TYPE ELEMENT
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C ARGUMENTS
C ---------
      CHARACTER*16  OPTION, NOMTE
C
C VARIABLES LOCALES
C -----------------
      INTEGER       JTAB1(7),JTAB2(7),JTAB3(7),IRET
      INTEGER       J1,J2,J3,NBCMP,NBSP,NBSP2,NBSP1,NBPT
      CHARACTER*24  VALK(2)
      REAL*8 V1,V2
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------

      CALL TECACH('ONN','PEPCON1',7,JTAB1,IRET)
      CALL TECACH('ONN','PEPCON2',7,JTAB2,IRET)
      CALL TECACH('ONN','PEPCON3',7,JTAB3,IRET)

      IF ( (JTAB1(1).EQ.0).OR.(JTAB2(1).EQ.0).OR.(JTAB3(1).EQ.0)) THEN
         VALK(1) = OPTION
         VALK(2) = NOMTE
         CALL U2MESK('F','ELEMENTS4_38', 2 ,VALK)
      ENDIF

      IF (( JTAB1(2).NE.JTAB2(2) ).OR.( JTAB1(3).NE.JTAB2(3) ))
     &   CALL U2MESK('F','ELEMENTS4_39',1,OPTION)


      NBPT=JTAB3(3)
      CALL ASSERT(NBPT.EQ.JTAB1(3))

      NBSP=JTAB3(7)
      NBSP1=JTAB1(7)
      NBSP2=JTAB2(7)
      CALL ASSERT(NBSP.EQ.NBSP1)
      CALL ASSERT((NBSP2.EQ.NBSP).OR.(NBSP2.EQ.1))

      NBCMP=JTAB3(2)/NBPT
      CALL ASSERT(JTAB3(2).EQ.NBCMP*NBPT)

      DO 20 J1 = 1, NBPT
         DO 21 J2 = 1, NBSP
            DO 22 J3 = 1, NBCMP
               V1= ZR(JTAB1(1)+(J1-1)*NBSP*NBCMP+(J2-1)*NBCMP+J3-1)
               IF (NBSP.EQ.NBSP2) THEN
                 V2= ZR(JTAB2(1)+(J1-1)*NBSP*NBCMP+(J2-1)*NBCMP+J3-1)
               ELSE
                 CALL ASSERT(NBSP2.EQ.1)
                 V2= ZR(JTAB2(1)+(J1-1)*NBCMP+J3-1)
               END IF
               ZR(JTAB3(1)+(J1-1)*NBSP*NBCMP+(J2-1)*NBCMP+J3-1)=V1+V2
  22        CONTINUE
  21     CONTINUE
  20  CONTINUE

9999  CONTINUE
      END
