      SUBROUTINE NXRECH (MODELE,MATE,CARELE,CHARGE,
     &                   INFOCH,NUMEDD,TIME,LONCH,COMPOR,
     &                   VTEMPM,VTEMPP,VTEMPR,VTEMP,VHYDR,VHYDRP,
     &                   TMPCHI,TMPCHF,VEC2ND,CNVABT,CNRESI,RHO,
     &                   ITERHO,PARMER,PARMEI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE                            DURAND C.DURAND
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER      PARMEI(2),LONCH
      REAL*8       PARMER(2),RHO
      CHARACTER*24 MODELE,MATE,CARELE,CHARGE,INFOCH,NUMEDD,TIME
      CHARACTER*24 VTEMP,VTEMPM,VTEMPP,VTEMPR,CNVABT,CNRESI,VEC2ND
      CHARACTER*24 VHYDR,VHYDRP,COMPOR,TMPCHI,TMPCHF
C
C ----------------------------------------------------------------------
C
C COMMANDE THER_NON_LINE : RECHERCHE LINEAIRE
C DANS LA DIRECTION DONNEE PAR NEWTON (ON CHERCHE RHO).
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXATR
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      CONVRL,STITE,OPTI
      INTEGER      I,INDRO,ISNNEM,TEST,ACT,OPT,LICOPT,ITERFI
      INTEGER      JTEMPM,JTEMPP,JTEMPR,J2ND,JVARE,JBTL,JBTLA
      INTEGER      JCHMP,JFPIP,JCGMP,JTP,JCNRE,JDIRI,JATMU
      REAL*8       RHOT,F0,F1,VRLMAX,RHO0,PENT
      REAL*8       RHOF,FFINAL,VALEUR,SENS,RHOEXC,FCVG
      REAL*8       R8PREM,TESTM,R8BID,MEM(2,10),PARMUL,REXM,REXP
      CHARACTER*8  KBID
      CHARACTER*16 OPTIOZ
      CHARACTER*24 VEBTLA,VERESI,VARESI,BIDON,VABTLA
      CHARACTER*24 K24BID
      CHARACTER*1  TYPRES
      INTEGER      ITRMAX,K,ITERHO
      DATA TYPRES        /'R'/
      DATA BIDON         /'&&FOMULT.BIDON'/
      DATA VERESI        /'&&VERESI           .RELR'/
      DATA VEBTLA        /'&&VETBTL           .RELR'/
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      VARESI = '&&VARESI'
C
C --- RECUPERATION D'ADRESSES JEVEUX
C
      CALL JEVEUO (VTEMPM(1:19)//'.VALE','E',JTEMPM )
      CALL JEVEUO (VTEMPP(1:19)//'.VALE','E',JTEMPP )
      CALL JEVEUO (VTEMPR(1:19)//'.VALE','E',JTEMPR )
      CALL JEVEUO (VEC2ND(1:19)//'.VALE','L',J2ND)
      CALL JEVEUO (CNRESI(1:19)//'.VALE','L',JVARE)
      CALL JEVEUO (CNVABT(1:19)//'.VALE','L',JBTLA)
C
C --- RECHERCHE LINEAIRE (CALCUL DE RHO) SUR L'INCREMENT VTEMPP
C
      F0 = 0.D0
      PARMUL = 3
      RHOEXC = 0.D0
      DO 330 I = 1,LONCH
         F0 = F0 + ZR(JTEMPP+I-1)*( ZR(J2ND+I-1) -
     &                              ZR(JVARE+I-1) - ZR(JBTLA+I-1) )
  330 CONTINUE
C HYPOTHESE DE L'ALGORITHME MIXTE
      F0 = -F0
      IF (F0.LE.0) THEN
        SENS = 1
      ELSE
        SENS = -1
      ENDIF
      CALL ZBINIT(SENS*F0,PARMUL,RHOEXC,10,MEM)
      FCVG = ABS(PARMER(2) * F0)

C
      PENT = 1.D0
      RHO = SENS
      RHO0 = 0.D0
      ACT=1
      ITRMAX = PARMEI(2)+1
      DO 20 ITERHO=1,ITRMAX
        
        ITERFI = ITERHO
        DO 345 I = 1,LONCH
            ZR(JTEMPR+I-1) = ZR(JTEMPM+I-1) + RHO * ZR(JTEMPP+I-1)
  345   CONTINUE
C
C --- VECTEURS RESIDUS ELEMENTAIRES - CALCUL ET ASSEMBLAGE
C
        CALL VERSTP (MODELE,CHARGE,INFOCH,CARELE,MATE,TIME,COMPOR,
     &               VTEMP,VTEMPR,VHYDR,VHYDRP,TMPCHI,TMPCHF,VERESI)
        CALL ASASVE (VERESI,NUMEDD,TYPRES,VARESI)
        CALL ASCOVA('D',VARESI,BIDON,'INST',R8BID,TYPRES,CNRESI)
        CALL JEVEUO (CNRESI(1:19)//'.VALE','L',JVARE)
C
C --- BT LAMBDA - CALCUL ET ASSEMBLAGE
C
        CALL VETHBT (MODELE,CHARGE,INFOCH,CARELE,MATE,VTEMPR,VEBTLA)
        CALL ASASVE (VEBTLA,NUMEDD,TYPRES,VABTLA)
        CALL ASCOVA('D',VABTLA,BIDON,'INST',R8BID,TYPRES,CNVABT)
        CALL JEVEUO (CNVABT(1:19)//'.VALE','L',JBTLA)
C
C CALCUL DE F1

        F1 = 0.D0
        DO 360 I = 1,LONCH
          F1 = F1 + ZR(JTEMPP+I-1) * ( ZR(J2ND+I-1) -
     &                                 ZR(JVARE+I-1) - ZR(JBTLA+I-1) )
  360   CONTINUE
C HYPOTHESE DE L'ALGORITHME MIXTE
        F1 = -F1

C TESTS 
        IF (ITERHO.EQ.1) THEN
          IF ((F1-F0)*(RHO-RHO0).LE.0.D0) PENT = -1.D0
        ELSE
          IF (((F1-F0)*(RHO-RHO0)*PENT).LT.R8PREM()) THEN
            CALL U2MESS('A','MECANONLINE_87')
            RHO = 1.D0
            ITERFI = 1
            GOTO 9999
          ENDIF
        ENDIF
        F0 = F1
        RHO0 = RHO

        TESTM = 0.D0
        DO 100 K = 1,LONCH
          TESTM = MAX( TESTM,
     &                 ABS(ZR(J2ND+K-1)-ZR(JVARE+K-1)-ZR(JBTLA+K-1)))
 100    CONTINUE
        IF (TESTM.LT.PARMER(2)) GO TO 9999
        CALL NMREBO(F1,MEM,SENS,RHO,RHOF,LICOPT,0,FFINAL,FCVG,
     &             OPT,ACT,OPTI,STITE)    
        IF (STITE) GOTO 40



 20   CONTINUE
 40   CONTINUE
C
C-----------------------------------------------------------------------
 9999 CONTINUE
      ITERHO = ITERFI - 1
      CALL JEDEMA()
      END
