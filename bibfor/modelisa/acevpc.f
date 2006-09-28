      SUBROUTINE ACEVPC(NBOCC,NLM,NLG,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           NBOCC,NLM,NLG,IER
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C ----------------------------------------------------------------------
C     AFFE_CARA_ELEM
C     VERIFICATION DES MOTS CLES POUR L'ELEMENT POUTRE COURBE
C ----------------------------------------------------------------------
C IN  : NBOCC  : NOMBRE D'OCCURENCE
C OUT : NLM    : NOMBRE TOTAL DE MAILLE
C OUT : NLG    : NOMBRE TOTAL DE GROUPE DE MAILLE
C ----------------------------------------------------------------------
      REAL*8       XRC, XOA, XFL, XSI
      CHARACTER*8  TOU, NOMU
      CHARACTER*16 CONCEP, CMD
      CHARACTER*8 K8BID
C     ------------------------------------------------------------------
C
      CALL GETRES(NOMU,CONCEP,CMD)
C
      NLM = 0
      NLG = 0
      DO 10 IOC = 1,NBOCC
         CALL GETVID('DEFI_ARC','GROUP_MA'  ,IOC,1,0,K8BID,NG)
         CALL GETVID('DEFI_ARC','MAILLE'    ,IOC,1,0,K8BID,NM)
         CALL GETVR8('DEFI_ARC','RAYON'     ,IOC,1,1,XRC,NR)
         CALL GETVR8('DEFI_ARC','ORIE_ARC'  ,IOC,1,1,XOA,NA)
         CALL GETVR8('DEFI_ARC','CENTRE'    ,IOC,1,0,XOC,NC)
         CALL GETVR8('DEFI_ARC','POIN_TANG' ,IOC,1,0,XOP,NP)
         CALL GETVR8('DEFI_ARC','COEF_FLEX' ,IOC,1,1,XFL,NF)
         CALL GETVR8('DEFI_ARC','INDI_SIGM' ,IOC,1,1,XSI,NS)
C
         IF (NR.NE.0) THEN
            IF (XRC.LE.0.D0) THEN
            CALL U2MESS('E','MODELISA_61')
            IER = IER + 1
            ENDIF
         ENDIF
         IF (NC.NE.0 .AND. NC.NE.-3) THEN
            CALL U2MESS('E','MODELISA_62')
            IER = IER + 1
         ENDIF
         IF (NP.NE.0 .AND. NP.NE.-3) THEN
            CALL U2MESS('E','MODELISA_63')
            IER = IER + 1
         ENDIF
         IF (NF.NE.0) THEN
            IF (XFL.LE.0.D0) THEN
            CALL U2MESS('E','MODELISA_64')
            IER = IER + 1
            ENDIF
         ENDIF
         IF (NS.NE.0) THEN
            IF (XSI.LE.0.D0) THEN
            CALL U2MESS('E','MODELISA_65')
            IER = IER + 1
            ENDIF
         ENDIF
C
         NSOM =  NG + NM
         IF (NSOM.EQ.NG .OR. NSOM.EQ.NM) THEN
            NLM = MAX(NLM,-NM)
            NLG = MAX(NLG,-NG)
         ENDIF
C
 10   CONTINUE
C
      END
