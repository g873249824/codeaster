      SUBROUTINE MMREDO(NUMEDD,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/12/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 NUMEDD
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C GESTION AUTOMATIQUE DES RELATIONS REDONDANTES
C
C ----------------------------------------------------------------------
C
C
C IN  NUMEDD : NOM DU NUME_DDL
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      INTEGER      IZONE
      INTEGER      CFDISI,NZOCO
      LOGICAL      MMINFL,LPIVOT,LDETEC
      CHARACTER*8  K8BID
      INTEGER      NEQ,IRET
      CHARACTER*24 VECNOD,VECNOX,VECNOY,VECNOZ
      INTEGER      JVECNO,JVECNX,JVECNY,JVECNZ
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- INITIALISATIONS
C
      LDETEC = .FALSE.
      NZOCO  = CFDISI(DEFICO,'NZOCO')
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES
C
      DO 11 IZONE = 1,NZOCO
        LPIVOT = MMINFL(DEFICO,'EXCLUSION_PIV_NUL',IZONE )
        IF (LPIVOT) THEN
          LDETEC = .TRUE.
        ENDIF
   11 CONTINUE
      IF (LDETEC) THEN
C
C --- CREATION DES STRUCTURES DE DONNEES POUR LA
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES
C
        VECNOD = RESOCO(1:14)//'.VECNOD'
        VECNOX = RESOCO(1:14)//'.VECNOX'
        VECNOY = RESOCO(1:14)//'.VECNOY'
        VECNOZ = RESOCO(1:14)//'.VECNOZ'
        CALL WKVECT(VECNOD,'V V I',NEQ,JVECNO)
        CALL WKVECT(VECNOX,'V V I',NEQ,JVECNX)
        CALL WKVECT(VECNOY,'V V I',NEQ,JVECNY)
        CALL WKVECT(VECNOZ,'V V I',NEQ,JVECNZ)
        CALL REDNEX(NUMEDD,NEQ   ,RESOCO)
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<CONTACT> ...... REPERAGE AUTOMATIQUE DES '//
     &                  'RELATIONS REDONDANTES'
        ENDIF
      ENDIF
C
      CALL JEDEMA()
      END
