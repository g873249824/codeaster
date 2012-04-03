      SUBROUTINE NMPILA(NUMEDD,SDPILO,ISXFE ,DTAU  ,DEPDEL,
     &                  DDEPL0,DDEPL1,NBEFFE,ETA   ,PILCVG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INTEGER      PILCVG,NBEFFE
      CHARACTER*19 SDPILO
      CHARACTER*24 NUMEDD
      CHARACTER*19 DDEPL0,DDEPL1,DEPDEL
      REAL*8       DTAU, ETA(2)
      LOGICAL      ISXFE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE - CALCUL DE ETA)
C
C RESOLUTION DE L'EQUATION DE PILOTAGE PAR LONGUEUR D'ARC
C
C ----------------------------------------------------------------------
C
C
C IN  NUMEDD : NUME_DDL
C IN  SDPILO : SD PILOTAGE
C IN  ISXFE  : INDIQUE S'IL S'AGIT D'UN MODELE XFEM
C IN  DEPDEL : INCREMENT DE DEPLACEMENT DEPUIS DEBUT PAS DE TEMPS
C IN  DDEPL0 : INCREMENT DE DEPLACEMENT K-1.F_DONNE
C IN  DDEPL1 : INCREMENT DE DEPLACEMENT K-1.F_PILO
C IN  DTAU   : SECOND MEMBRE DE L'EQUATION DE PILOTAGE
C OUT NBEFFE : NOMBRE DE SOLUTIONS EFFECTIVES
C OUT ETA    : ETA_PILOTAGE
C OUT PILCVG : CODE DE CONVERGENCE POUR LE PILOTAGE
C                -1 : PAS DE CALCUL DU PILOTAGE
C                 0 : CAS DU FONCTIONNEMENT NORMAL
C                 1 : PAS DE SOLUTION
C                 2 : BORNE ATTEINTE -> FIN DU CALCUL
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
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
C ---------- FIN  DECLARATIONS  NORMALISEES  JEVEUX -------------------

      INTEGER      I, J ,NRAC
      REAL*8       R0, D0, R1, D1, R2, DTAU2, RAC(2)
      INTEGER      JDEP0,JDEP1,JDEPDE,JCOEF,JCOEE
      INTEGER      NEQ,IRET
      CHARACTER*8  K8BID
      INTEGER      IFM,NIV
      CHARACTER*19 CHAPIL,CHAPIC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('PILOTAGE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<PILOTAGE> ...... PILOTAGE PAR LONGUEUR D''ARC'
      ENDIF
C
C --- INITIALISATIONS
C
      PILCVG = -1
      DTAU2  = DTAU**2
      R0     = - DTAU2
      R1     = 0.D0
      R2     = 0.D0
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- ACCES OBJETS JEVEUX
C
      CALL JEVEUO(DDEPL0(1:19)//'.VALE','L',JDEP0)
      CALL JEVEUO(DDEPL1(1:19)//'.VALE','L',JDEP1)
      CALL JEVEUO(DEPDEL(1:19)//'.VALE','L',JDEPDE)
      CHAPIL = SDPILO(1:14)//'.PLCR'
      CALL JEVEUO(CHAPIL(1:19)//'.VALE','L',JCOEF)
      IF(ISXFE) THEN
      CHAPIC = SDPILO(1:14)//'.PLCI'
      CALL JEVEUO(CHAPIC(1:19)//'.VALE','L',JCOEE)
      ENDIF
C
C --- CALCUL DES COEFFICIENTS DU POLYNOME DE DEGRE 2
C
      IF(ISXFE) THEN
        DO 20 I = 1, NEQ
          IF(ZR(JCOEE+I-1).EQ.0.D0) THEN
            R0 = R0 + ZR(JCOEF+I-1)**2*
     &          (ZR(JDEPDE+I-1)+ZR(JDEP0+I-1))**2
            R1 = R1 + ZR(JCOEF+I-1)**2*
     &          (ZR(JDEPDE+I-1)+ZR(JDEP0+I-1))*ZR(JDEP1+I-1)
            R2 = R2 + ZR(JCOEF+I-1)**2*
     &           ZR(JDEP1+I-1) * ZR(JDEP1+I-1)
          ELSE
            D0  = 0.D0
            D1  = 0.D0
            DO 30 J = I+1, NEQ
              IF (ZR(JCOEE+I-1).EQ.ZR(JCOEE+J-1)) THEN
                D0 = D0 +
     &               ZR(JCOEF+I-1)*(ZR(JDEPDE+I-1)+ZR(JDEP0+I-1))+
     &               ZR(JCOEF+J-1)*(ZR(JDEPDE+J-1)+ZR(JDEP0+J-1))
                D1 = D1 + ZR(JCOEF+I-1)*ZR(JDEP1+I-1)+
     &               ZR(JCOEF+J-1)*ZR(JDEP1+J-1)
              ENDIF
 30         CONTINUE
            R0 = R0 + D0**2
            R1 = R1 + D1*D0
            R2 = R2 + D1**2
          ENDIF
 20     CONTINUE
      ELSE
        DO 10 I = 1, NEQ
          R0 = R0 + ZR(JCOEF+I-1) *
     &        (ZR(JDEPDE+I-1)+ZR(JDEP0+I-1))**2
          R1 = R1 + ZR(JCOEF+I-1) *
     &        (ZR(JDEPDE+I-1)+ZR(JDEP0+I-1))*ZR(JDEP1+I-1)
          R2 = R2 + ZR(JCOEF+I-1) *
     &         ZR(JDEP1+I-1) * ZR(JDEP1+I-1)
 10     CONTINUE
      ENDIF

      R1 = 2.D0*R1
      IF (R2.EQ.0) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<PILOTAGE> ....EQUATION X2+BX+C: ',R1/R2,R0/R2
      ENDIF
C
C --- RESOLUTION DE L'EQUATION DE DEGRE DEUX
C
      CALL ZEROP2(R1/R2,R0/R2,RAC,NRAC)
C
      IF (NRAC.EQ.0) THEN
        PILCVG    = 1
      ELSEIF (NRAC.EQ.1) THEN
        PILCVG    = 0
        NBEFFE    = 1
        ETA(1)    = RAC(1)
      ELSE
        PILCVG    = 0
        NBEFFE    = 2
        ETA(1)    = RAC(1)
        ETA(2)    = RAC(2)
      ENDIF
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<PILOTAGE> ...... SOLUTIONS: ',NRAC,RAC
      ENDIF
C
      CALL JEDEMA()
C
      END
