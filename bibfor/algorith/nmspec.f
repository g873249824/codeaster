      SUBROUTINE NMSPEC(MODELE,NUMEDD,NUMFIX,CARELE,COMPOR,
     &                  SOLVEU,NUMINS,MATE  ,COMREF,LISCHA,
     &                  DEFICO,RESOCO,PARMET,FONACT,CARCRI,
     &                  SDIMPR,SDSTAT,SDTIME,SDDISC,VALINC,
     &                  SOLALG,MEELEM,MEASSE,VEELEM,SDDYNA,
     &                  SDPOST,SDERRO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/02/2012   AUTEUR GREFFET N.GREFFET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21 
C
      IMPLICIT     NONE
      INTEGER      NUMINS
      REAL*8       PARMET(*)
      CHARACTER*19 MEELEM(*)
      CHARACTER*24 RESOCO,DEFICO
      CHARACTER*24 SDIMPR,SDSTAT,SDTIME,SDERRO
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA,SDPOST
      CHARACTER*24 MODELE,NUMEDD,NUMFIX,CARELE,COMPOR
      CHARACTER*19 VEELEM(*),MEASSE(*)
      CHARACTER*19 SOLALG(*),VALINC(*) 
      CHARACTER*24 MATE
      CHARACTER*24 CARCRI,COMREF
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C ANALYSE DE FLAMBEMENT OU STABILITE ET/OU MODES VIBRATOIRES
C      
C ----------------------------------------------------------------------
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  DEFICO : SD DEFINITION CONTACT
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISC_INST
C IN  PREMIE : SI PREMIER INSTANT DE CALCUL
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  MATASS : MATRICE ASSEMBLEE GLOBALE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      ISFONC,LMVIB,LFLAM
      LOGICAL      CALCUL
      INTEGER      IBID
      REAL*8       R8BID,INST,DIINST
      CHARACTER*16 OPTION
      CHARACTER*19 NOMLIS
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C      
      INST   = DIINST(SDDISC,NUMINS)
      CALCUL = .FALSE.
      NOMLIS = ' '
      OPTION = ' '
C
C --- FONCTIONNALITES ACTIVEES
C
      LMVIB  = ISFONC(FONACT,'MODE_VIBR')
      LFLAM  = ISFONC(FONACT,'CRIT_STAB')
C
C -- DOIT-ON FAIRE LE CALCUL ?
C      
      IF (LFLAM) THEN
        NOMLIS = SDPOST(1:14)//'.FLAM'
        CALL NMCRPO(NOMLIS,NUMINS,INST  ,CALCUL)   
      ELSEIF (LMVIB) THEN
        NOMLIS = SDPOST(1:14)//'.VIBR'
        CALL NMCRPO(NOMLIS,NUMINS,INST  ,CALCUL) 
      ELSE
        GOTO 999  
      ENDIF
C            
C -- CALCUL DE FLAMBEMENT EN STATIQUE ET DYNAMIQUE
C
      IF (LFLAM) THEN
        IF (CALCUL) THEN          
          CALL NMLESD('POST_TRAITEMENT',SDPOST,'OPTION_CALCUL_FLAMB',
     &                IBID             ,R8BID ,OPTION) 
          CALL NMIMPR(SDIMPR,'TITR',OPTION,' ',0.D0,0)
C
C ------- CALCUL EFFECTIF
C
          CALL NMFLAM(OPTION,MODELE,NUMEDD,NUMFIX,CARELE,
     &                COMPOR,SOLVEU,NUMINS,MATE  ,COMREF,
     &                LISCHA,DEFICO,RESOCO,PARMET,FONACT,
     &                CARCRI,SDIMPR,SDSTAT,SDDISC,SDTIME,
     &                SDDYNA,SDPOST,VALINC,SOLALG,MEELEM,
     &                MEASSE,VEELEM,SDERRO)
        ENDIF  
      ENDIF
C
C --- CALCUL DE MODES VIBRATOIRES EN DYNAMIQUE
C
      IF (LMVIB) THEN
        IF (CALCUL) THEN
          CALL NMLESD('POST_TRAITEMENT',SDPOST,'OPTION_CALCUL_VIBR',
     &                IBID             ,R8BID ,OPTION) 
          CALL NMIMPR(SDIMPR,'TITR',OPTION,' ',0.D0,0)
C
C ------- CALCUL EFFECTIF
C
          CALL NMFLAM(OPTION,MODELE,NUMEDD,NUMFIX,CARELE,
     &                COMPOR,SOLVEU,NUMINS,MATE  ,COMREF,
     &                LISCHA,DEFICO,RESOCO,PARMET,FONACT,
     &                CARCRI,SDIMPR,SDSTAT,SDDISC,SDTIME,
     &                SDDYNA,SDPOST,VALINC,SOLALG,MEELEM,
     &                MEASSE,VEELEM,SDERRO)
        ENDIF  
      ENDIF
C
 999  CONTINUE      
C
      CALL JEDEMA()      
C   
      END
