      SUBROUTINE ACCEL0(MODELE,NUMEDD,FONACT,LISCHA,DEFICO,
     &                  RESOCO,MAPREC,SOLVEU,VALMOI,SDDYNA,
     &                  SDPILO,SDTIME,MEELEM,MEASSE,VEELEM,
     &                  VEASSE,SOLALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*19  SOLVEU,MAPREC,LISCHA,SDDYNA
      CHARACTER*24  NUMEDD,MODELE,SDTIME
      CHARACTER*24  DEFICO,RESOCO,VALMOI(8)
      CHARACTER*19  MEELEM(*),MEASSE(*),VEASSE(*),VEELEM(*)
      CHARACTER*19  SOLALG(*)
      LOGICAL       FONACT(*)
      CHARACTER*14  SDPILO     
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (DYNAMIQUE)
C
C CALCUL DE L'ACCELERATION INITIALE
C
C ----------------------------------------------------------------------
C
C
C     ==> ON SUPPOSE QUE LA VITESSE INITIALE EST NULLE
C                    QUE LES DEPLACEMENTS IMPOSES SONT NULS
C     ==> ON NE PREND EN COMPTE QUE LES CHARGES DYNAMIQUES, CAR LES
C         CHARGES STATIQUES SONT EQUILIBREES PAR LES FORCES INTERNES
C
C
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NOM DE LA NUMEROTATION
C IN  LISCHA : LISTE DES CHARGES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDTIME : SD TIMER
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NEQ,IRET
      INTEGER      FACCVG
      CHARACTER*19 MATASS,DEPSO1,DEPSO2
      REAL*8       Z, DZ
      LOGICAL      NDYNLO,LGRFL
      CHARACTER*24 CHGRFL
      CHARACTER*19 NMCHEX,CNCINE,CNCINX,CNDONN,K19BLA  
      CHARACTER*24 NDYNKK,K24BID
      CHARACTER*24 ACCMOI
      CHARACTER*8  K8BID
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CALCUL DE L''ACCELERATION '//
     &                'INITIALE'
      ENDIF
      CALL U2MESS('I','MECANONLINE_24')
C
C --- INITIALISATIONS
C    
      K19BLA = ' '
      CNDONN = '&&CNCHAR.DONN'
      CNCINX = '&&CNCHAR.CINE'
      MATASS = '&&ACCEL0.MATASS'
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)  
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL DESAGG(VALMOI,K24BID,K24BID,K24BID,K24BID,
     &            K24BID,ACCMOI,K24BID,K24BID)   
      CNCINE = NMCHEX(VEASSE,'VEASSE','CNCINE')
      DEPSO1 = NMCHEX(SOLALG,'SOLALG','DEPSO1')
      DEPSO2 = NMCHEX(SOLALG,'SOLALG','DEPSO2')     
C
C --- FONCTIONNALITES ACTIVEES
C
      LGRFL  = NDYNLO(SDDYNA,'FORCE_FLUIDE')
C
C --- ASSEMBLAGE ET FACTORISATION DE LA MATRICE 
C
      CALL NMPRAC(FONACT,LISCHA,NUMEDD,SOLVEU,SDDYNA,
     &            SDTIME,DEFICO,RESOCO,MEELEM,MEASSE,
     &            MAPREC,MATASS,FACCVG)
      IF (FACCVG.EQ.2) THEN
        CALL NULVEC(ACCMOI)
        CALL U2MESS('A','MECANONLINE_69')
        GOTO 9999
      ENDIF
C
C --- CALCUL DU SECOND MEMBRE
C
      CALL NMASSI(MODELE,NUMEDD,LISCHA,FONACT,SDDYNA,
     &            DEFICO,VALMOI,VEELEM,VEASSE,CNDONN)
C
C --- POUR LE CALCUL DE DDEPLA, IL FAUT METTRE CNCINE A ZERO
C
      CALL COPISD('CHAMP_GD','V',CNCINE,CNCINX)
      CALL VTZERO(CNCINX)
C
C --- RESOLUTION DIRECTE
C
      CALL NMRESO(FONACT,SDPILO,CNDONN,K19BLA,CNCINX,
     &            SOLVEU,MAPREC,MATASS,DEPSO1,DEPSO2)
C     
C --- RECOPIE SOLUTION
C
      CALL COPISD('CHAMP_GD','V',DEPSO1,ACCMOI)
C
C --- PRISE EN COMPTE DU CHARGEMENT FORCE_FLUIDE
C
      IF (LGRFL) THEN
        CHGRFL = NDYNKK(SDDYNA,'CHGRFL')
        Z      = 0.0D0
        DZ     = 0.0D0
        CALL GFACC0(Z     ,DZ    ,NUMEDD,ACCMOI,CHGRFL)
      ENDIF
C
9999  CONTINUE

      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... ACCMOI : '
        CALL NMDEBG('VECT',ACCMOI,IFM)
      ENDIF
C
C --- MENAGE
C
      CALL DETRSD('MATR_ASSE',MATASS)
C
      CALL JEDEMA()
      END
