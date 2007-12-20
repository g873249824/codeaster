      SUBROUTINE EXFONC(FONACT,SOLVEU,DEFICO,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      LOGICAL      FONACT(*)
      CHARACTER*19 SOLVEU,SDDYNA
      CHARACTER*24 DEFICO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C FONCTIONNALITES INCOMPATIBLES
C      
C ----------------------------------------------------------------------
C
C      
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  SOLVEU : NOM DU SOLVEUR DE NEWTON
C IN  SDDYNA : SD DYNAMIQUE
C IN  FONACT : FONCTIONNALITES SPECIFIQUES ACTIVEES
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER      IBID,NBPROC
      INTEGER      TYPALC,TYPALF
      INTEGER      JSOLVE
      LOGICAL      ISFONC,NDYNLO
      LOGICAL      LFETI,LCTCC,LCTCD,LPILO,LRELI,LMACR,LUNIL
      LOGICAL      LVERIF,LFROTT,LMVIBR,LFLAMB
      LOGICAL      LMUMPS,LGCPC,LSYME,LMUMPD
      LOGICAL      LONDE,LGRFL,LDYNA,LSENS
      CHARACTER*24 K24BID
      INTEGER      IFM,NIV
C
C ---------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- FONCTIONNALITES ACTIVEES
C
      LFETI  = ISFONC(FONACT,'FETI')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU')
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LVERIF = ISFONC(FONACT,'CONT_VERIF')
      LUNIL  = ISFONC(FONACT,'LIAISON_UNILATER')
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LRELI  = ISFONC(FONACT,'RECH_LINE')
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')
      LMVIBR = ISFONC(FONACT,'MODE_VIBR')
      LFLAMB = ISFONC(FONACT,'CRIT_FLAMB')  
      LONDE  = NDYNLO(SDDYNA,'ONDE_PLANE')
      LGRFL  = NDYNLO(SDDYNA,'FORCE_FLUIDE')
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LSENS  = ISFONC(FONACT,'SENSIBILITE')
C
C --- TYPE DE CONTACT
C      
      TYPALC = 0
      TYPALF = 0
      IF (LCTCD) THEN
        CALL CFDISC(DEFICO,' ',TYPALC,TYPALF,IBID,IBID)    
      ENDIF
      LFROTT = ABS(TYPALF).NE.0
C
C --- TYPE DE SOLVEUR      
C
      CALL  JEVEUO(SOLVEU//'.SLVK','L',JSOLVE)
      LMUMPS = .FALSE.
      LGCPC  = .FALSE.
      LMUMPD = .FALSE.
      IF (ZK24(JSOLVE)(1:4).EQ.'GCPC') THEN
        LGCPC = .TRUE.
      ENDIF
      IF (ZK24(JSOLVE)(1:5).EQ.'MUMPS') THEN
        LMUMPS = .TRUE.
        IF (ZK24(JSOLVE+6)(1:4).EQ.'DIST') THEN
          LMUMPD = .TRUE.
        ENDIF
      ENDIF
      LSYME  = ZK24(JSOLVE+4).EQ.'OUI'
      IF (LMUMPD) THEN
        CALL INFNIV(IFM,NIV)
        CALL MUMMPI(3,IFM,NIV,K24BID,NBPROC,IBID)
      ENDIF     
C
C --- FETI
C
      IF (LFETI) THEN
        IF (LMACR) THEN
          CALL U2MESS('F','MECANONLINE3_70')
        ENDIF  
        IF (LONDE) THEN
          CALL U2MESS('F','MECANONLINE3_71')
        ENDIF
        IF (LGRFL) THEN
          CALL U2MESS('F','MECANONLINE3_72')
        ENDIF      
        IF (LDYNA) THEN
          CALL U2MESS('F','MECANONLINE3_73')
        ENDIF   
        IF (LSENS) THEN
          CALL U2MESS('F','MECANONLINE3_75')
        ENDIF                 
        IF (LCTCD) THEN
          CALL U2MESS('F','MECANONLINE3_78')
        ENDIF         
      ENDIF
C
C --- CONTACT DISCRET
C
      IF (LCTCD) THEN
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE_43')
        ENDIF
        IF (LRELI.AND.(.NOT.LVERIF)) THEN
          CALL U2MESS('A','MECANONLINE3_89')
        ENDIF
        IF (LGCPC) THEN
          IF (LFROTT) THEN
            CALL U2MESS('F','MECANONLINE3_90')
          ENDIF
        ELSE IF (LMUMPS) THEN
C
C --- MUMPS DISTRIBUE INTERDIT EN FROTTEMENT PENALISE OU LAGRANGIEN
C --- PARALLELE
C --- A PRIORI MUMPS CENTRALISE LICITE PARTOUT EN CONTACT AVEC OU
C --- SANS FROTTEMENT (SEQ/PARALLELE)
C
          IF (LMUMPD) THEN
            IF ((NBPROC.GT.1).AND.((TYPALF.EQ.1).OR.(TYPALF.EQ.2))) THEN
              CALL U2MESS('F','FACTOR_51')
            ENDIF   
          ENDIF         
        ENDIF
C       ON FORCE SYME='OUI' AVEC LE CONTACT DISCRET
        IF (.NOT.LSYME) THEN
          ZK24(JSOLVE+4)='OUI'
          CALL U2MESS('A','CONTACT_1')
        ENDIF
      ENDIF
C
C --- CONTACT CONTINU
C
      IF (LCTCC) THEN
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE3_91')
        ENDIF
        IF (LRELI) THEN
          CALL U2MESS('F','MECANONLINE3_92')
        ENDIF
        IF (LGCPC) THEN
          CALL U2MESS('F','MECANONLINE3_93')
        ENDIF
      ENDIF
C
C --- LIAISON UNILATERALE
C
      IF (LUNIL) THEN
        IF (LRELI) THEN
          CALL U2MESS('A','MECANONLINE3_95')
        ENDIF
        IF (LGCPC) THEN
          CALL U2MESS('F','FACTOR_51')
        ENDIF
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE3_94')
        ENDIF
        IF (LMUMPS) THEN
          IF (LMUMPD) THEN
            IF (NBPROC.GT.1) THEN
              CALL U2MESS('F','FACTOR_51')
            ENDIF   
          ENDIF         
        ENDIF        
      ENDIF
C
C --- CALCUL DE MODES/FLAMBEMENT: PAS MUMPS, PAS GCPC
C
      IF (LMVIBR.OR.LFLAMB) THEN
        IF ((LMUMPS).OR.(LGCPC)) THEN
          CALL U2MESS('F','FACTOR_52')
        ENDIF
      ENDIF      
C
      CALL JEDEMA()
      END
