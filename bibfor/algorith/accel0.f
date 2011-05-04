      SUBROUTINE ACCEL0(MODELE,NUMEDD,NUMFIX,FONACT,LISCHA,
     &                  DEFICO,RESOCO,MAPREC,SOLVEU,VALINC,
     &                  SDDYNA,SDTIME,SDDISC,MEELEM,MEASSE,
     &                  VEELEM,VEASSE,SOLALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/05/2011   AUTEUR MACOCCO K.MACOCCO 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*19  SOLVEU,MAPREC,LISCHA
      CHARACTER*19  SDDYNA,SDDISC
      CHARACTER*24  NUMEDD,NUMFIX,MODELE,SDTIME
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  MEELEM(*),MEASSE(*),VEASSE(*),VEELEM(*)
      CHARACTER*19  SOLALG(*),VALINC(*)
      INTEGER       FONACT(*)    
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
C IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  LISCHA : LISTE DES CHARGES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDDISC : SD DISC_INST
C IN  SDTIME : SD TIMER
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
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
      CHARACTER*19 CNCINE,CNCINX,CNDONN,K19BLA  
      CHARACTER*19 ACCMOI
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
      CALL NMCHEX(VALINC,'VALINC','ACCMOI',ACCMOI)   
      CALL NMCHEX(VEASSE,'VEASSE','CNCINE',CNCINE)
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO1',DEPSO1)
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO2',DEPSO2)
C
C --- ASSEMBLAGE ET FACTORISATION DE LA MATRICE 
C
      CALL NMPRAC(FONACT,LISCHA,NUMEDD,NUMFIX,SOLVEU,
     &            SDDYNA,SDTIME,SDDISC,DEFICO,RESOCO,
     &            MEELEM,MEASSE,MAPREC,MATASS,FACCVG)
      IF (FACCVG.EQ.2) THEN
        CALL NULVEC(ACCMOI)
        CALL U2MESS('A','MECANONLINE_69')
        GOTO 9999
      ENDIF
C
C --- CALCUL DU SECOND MEMBRE
C
      CALL NMASSI(MODELE,NUMEDD,LISCHA,FONACT,SDDYNA,
     &            VALINC,VEELEM,VEASSE,CNDONN)
C
C --- POUR LE CALCUL DE DDEPLA, IL FAUT METTRE CNCINE A ZERO
C
      CALL COPISD('CHAMP_GD','V',CNCINE,CNCINX)
      CALL VTZERO(CNCINX)
C
C --- RESOLUTION DIRECTE
C
      CALL NMRESO(FONACT,CNDONN,K19BLA,CNCINX,SOLVEU,
     &            MAPREC,MATASS,DEPSO1,DEPSO2)
C
C --- DEPENDAMMENT DU SOLVEUR, TRAITEMENT PARTICULIER
C
      CALL LSPINI(SOLVEU)
C     
C --- RECOPIE SOLUTION
C
      CALL COPISD('CHAMP_GD','V',DEPSO1,ACCMOI)
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
