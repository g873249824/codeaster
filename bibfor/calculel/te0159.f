      SUBROUTINE TE0159(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  PASSAGE DES POINTS DE GAUSS AUX NOEUDS
C                          POUR MECABL2 ET MEPOULI.(SIEF ET VARI)
C                          POUR MEPOUDE MEPOUDT ET MEDITRL.(VARI)

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER ISIGGA,ISIGNO,JTAB(7)

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------


      IF (OPTION(1:14).EQ.'SIEF_ELNO_ELGA') THEN
C     -----------------------------------------------
        CALL JEVECH('PCONTRR','L',ISIGGA)
        CALL JEVECH('PSIEFNOR','E',ISIGNO)

        IF (NOMTE(1:7).EQ.'MEPOULI') THEN
          ZR(ISIGNO) = ZR(ISIGGA)
          ZR(ISIGNO+1) = ZR(ISIGGA)
          ZR(ISIGNO+2) = ZR(ISIGGA)
        ELSE IF (NOMTE(1:7).EQ.'MECABL2') THEN
          ZR(ISIGNO) = ZR(ISIGGA)
          ZR(ISIGNO+1) = ZR(ISIGGA)
        END IF


      ELSE IF (OPTION(1:14).EQ.'VARI_ELNO_ELGA') THEN
C     -----------------------------------------------
        CALL JEVECH('PVARIGR','L',IVARGA)
        CALL JEVECH('PVARINR','E',IVARNO)
        IF (NOMTE(1:7).EQ.'MEPOULI') THEN
          ZR(IVARNO) = ZR(IVARGA)
          ZR(IVARNO+1) = ZR(IVARGA)
          ZR(IVARNO+2) = ZR(IVARGA)
        ELSE IF (NOMTE(1:7).EQ.'MECABL2') THEN
          ZR(IVARNO) = ZR(IVARGA)
          ZR(IVARNO+1) = ZR(IVARGA)
        ELSE IF (NOMTE(1:10).EQ.'MECA_POU_D' .OR.
     &           NOMTE.EQ.'MECA_DIS_TR_L') THEN
          CALL JEVECH('PCOMPOR','L',ICOMPO)
          IF (ZK16(ICOMPO) (1:4).EQ.'ELAS') GO TO 30
          CALL TECACH('OON','PVARIGR',7,JTAB,IRET)
          LGPG = MAX(JTAB(6),1)*JTAB(7)
          READ (ZK16(ICOMPO+1),'(I16)') NBVAR
          DO 10 I = 1,NBVAR
            ZR(IVARNO+I-1) = ZR(IVARGA+I-1)
            ZR(IVARNO+LGPG+I-1) = ZR(IVARGA+LGPG+I-1)
   10     CONTINUE
        END IF


      ELSE IF (OPTION(1:14).EQ.'VARI_ELGA_ELNO') THEN
C     -----------------------------------------------
        CALL JEVECH('PCOMPOR','L',ICOMPO)
        READ (ZK16(ICOMPO+1),'(I16)') NBVAR

        CALL JEVECH('PVARINR','L',IVARNO)
        CALL JEVECH('PVARIGR','E',IVARGA)

        CALL TECACH('OON','PVARINR',7,JTAB,IRET)
        LGPG1= MAX(JTAB(6),1)*JTAB(7)
        CALL TECACH('OON','PVARIGR',7,JTAB,IRET)
        LGPG2= MAX(JTAB(6),1)*JTAB(7)

        IF (LGPG2.NE.NBVAR) CALL U2MESS('F','CALCULEL_2')

        DO 20 I = 1,NBVAR
          ZR(IVARGA+I-1) = ZR(IVARNO+I-1)
          ZR(IVARGA+LGPG2+I-1) = ZR(IVARNO+LGPG1+I-1)
   20   CONTINUE
      END IF
   30 CONTINUE

      END
