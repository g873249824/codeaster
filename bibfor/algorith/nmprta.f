      SUBROUTINE NMPRTA(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &                   COMPOR, LISCHA, MEDIRI, METHOD, SOLVEU,
     &                   PARMET, CARCRI, PILOTE, PARTPS, NUMINS,
     &                   INST  , DEPOLD, VALMOI, POUGD , VALPLU,
     &                   SECMBR, DEPDEL, ETA   , LICCVG, STADYN,
     &                   LAMORT, VITPLU, ACCPLU, MASSE,  AMORT,
     &                   CMD,    PREMIE, MEMASS, DEPENT, VITENT,
     &                   COEVIT, COEACC, VITKM1, NMODAM, VALMOD,
     &                   BASMOD, NREAVI,  LIMPED, LONDE,  NONDP,
     &                   CHONDP)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/10/2002   AUTEUR UFBHHLL C.CHAVANT 
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
C RESPONSABLE ADBHHVV V.CANO
C TOLE CRP_21

      IMPLICIT NONE
      INTEGER      NUMINS, LICCVG(*)
      REAL*8       PARMET(*), INST(3), ETA, COEVIT, COEACC
      CHARACTER*14 PILOTE
      CHARACTER*16 METHOD(*), CMD
      CHARACTER*19 LISCHA, SOLVEU, PARTPS
      CHARACTER*24 MODELE, NUMEDD, MATE, CARELE, COMREF, COMPOR
      CHARACTER*24 CARCRI, VALMOI, VALPLU, POUGD, SECMBR
      CHARACTER*24 DEPOLD, DEPDEL, MEDIRI
      CHARACTER*24 VITPLU, ACCPLU, MASSE, AMORT, MEMASS
      CHARACTER*24 DEPENT, VITENT, STADYN
      LOGICAL      LAMORT, PREMIE, LBID, LIMPED, LONDE
      CHARACTER*24 VITKM1, VALMOD, BASMOD, CHONDP
      INTEGER      NMODAM, NREAVI, NONDP      

C ----------------------------------------------------------------------
C COMMANDE STAT_NON_LINE : PREDICTION PAR METHODE DE NEWTON
C ----------------------------------------------------------------------
C
C IN       MODELE K24  MODELE
C IN       NUMEDD K24  NUME_DDL
C IN       MATE   K24  CHAMP MATERIAU
C IN       CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24  VARI_COM DE REFERENCE
C IN       COMPOR K24  COMPORTEMENT
C IN       LISCHA K19  L_CHARGES
C IN       MEDIRI K24  MATRICES ELEMENTAIRES DE DIRICHLET (B)
C IN       METHOD K16  INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN       SOLVEU K19  SOLVEUR
C IN       PARMET  R8  PARAMETRES DES METHODES DE RESOLUTION
C IN       CARCRI K24  PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN       PILOTE K14  SD PILOTAGE
C IN       PARTPS K19  SD DISC_INST
C IN       NUMINS  I   NUMERO D'INSTANT
C IN       INST    R8  PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C IN       DEPOLD K24  ANCIEN INCREMENT DE TEMPS (PAS PRECEDENT)
C IN       VALMOI K24  ETAT EN T-
C IN       POUGD  K24  DONNES POUR POUTRES GRANDES DEFORMATIONS
C IN       VALPLU K24  ETAT EN T+
C IN       SECMBR K24  VECTEURS ASSEMBLES DES CHARGEMENTS FIXES
C IN/JXOUT DEPDEL K24  PREDICTION DE L'INCREMENT DE DEPLACEMENT
C OUT      ETA     R8  ETA_PILOTAGE
C OUT      LICCVG  I   CODES RETOURS 
C                      (1) - PILOTAGE
C                      (5) - MATASS SINGULIERE
C
C ----------------------------------------------------------------------

      LOGICAL      GRAND
      LOGICAL      FNOEVO
C
C IN  FNOEVO  : VRAI SI FORCES NODALES EVOLUTIVES I E INSTANT PLUS ET
C               MOINS NECESSAIRES 5 STAT NON LINE TRAITANT DES PROBLEMES
C               PARABOLIQUES : APPLICATION A THM
C               ICI VRAI
      INTEGER      NOCC, IBID
      REAL*8       INSTAM, INSTAP, TR8BID(3), CODONN(6), COPILO(3)
      REAL*8       DINST, DIINST
      CHARACTER*8  VEFINT, VEBUDI
      CHARACTER*16 DEFO, CONFIG, K16BID
      CHARACTER*19 MATRIX(2), CNDONN(6), CNPILO(3), CNVCPR
      CHARACTER*24 K24BID
      CHARACTER*24 DEPMOI, SIGMOI, COMMOI, COMPLU, TEMMOI, TEMPLU
      CHARACTER*24 DEPDE0
      CHARACTER*24 CNFEDO, CNFEPI, CNDIDO, CNDIPI, CNFSDO, CNFSPI
      CHARACTER*24 CNCINE
      CHARACTER*24 CNFINT, CNBUDI

      DATA VEFINT, VEBUDI /'&&VEFINT', '&&VEBUDI'/
      DATA CNFINT, CNBUDI /'&&NMPRTA.FINT', '&&NMPRTA.BUDI'/
      DATA CNVCPR         /'&&NMPRTA.VCPR'/
C ----------------------------------------------------------------------


C -- INITIALISATION

      CALL DESAGG (VALMOI, DEPMOI, SIGMOI, K24BID, COMMOI,
     &                     K24BID, K24BID, K24BID, K24BID)
      CALL DESAGG (SECMBR, CNFEDO, CNFEPI, CNDIDO, CNDIPI,
     &                     CNFSDO, CNFSPI, K24BID, CNCINE)
      CALL DESAGG (VALPLU, K24BID, K24BID, K24BID, COMPLU,
     &                     K24BID, K24BID, K24BID, K24BID)

      INSTAM = DIINST(PARTPS, NUMINS-1)
      INSTAP = DIINST(PARTPS, NUMINS)
      DEPDE0 = '&&CNPART.ZERO'


C ======================================================================
C                   REASSEMBLAGE EVENTUEL DES MATRICES
C ======================================================================

      CALL NMMATR('PREDICTION', MODELE, NUMEDD, MATE  , CARELE,
     &                  COMREF, COMPOR, LISCHA, MEDIRI, ' '   ,
     &                  METHOD, SOLVEU, PARMET, CARCRI, PARTPS,
     &                  NUMINS, 0     , VALMOI, POUGD ,  ' '  ,
     &                  VALPLU, MATRIX, K16BID, K24BID, STADYN,
     &                  PREMIE, CMD,    DEPENT, VITENT, LAMORT,
     &                  MEMASS, MASSE,  AMORT,  COEVIT, COEACC,
     &                  LICCVG(5))
      
      IF (LICCVG(5).NE.0) GOTO 9999



C ======================================================================
C             DETERMINATION DU SECOND MEMBRE (DONNE ET PILOTE)
C ======================================================================


C -- CALCUL DES FORCES INTERIEURES (QT.SIGMA)

C    TABLEAU DES INSTANTS BIDON POUR THM
      TR8BID(1) = INSTAM
      TR8BID(2) = INSTAP
      TR8BID(3) = 0.D0
      FNOEVO=.TRUE.

C    TEMPERATURE POUR LE MATERIAU DES POUTRES POUX
      CALL NMVCEX('TEMP',COMMOI,TEMMOI)

C    CALCUL DE L'OPTION FORC_NODA
      CALL VEFNME (MODELE, SIGMOI, CARELE, DEPMOI,
     &             DEPDE0, VEFINT, MATE  , COMPOR, 0,
     &             FNOEVO,TR8BID, CARCRI, TEMMOI, ' '   )
      CALL ASSVEC ('V',CNFINT,1,VEFINT,1.D0,NUMEDD,' ','ZERO',1)


C -- DIRICHLET : BT.LAMBDA ET B.U
      CALL VEBUME (MODELE, DEPMOI, LISCHA, VEBUDI)
      CALL ASSVEC ('V',CNBUDI,1,VEBUDI,1.D0,NUMEDD,' ','ZERO',1)


C -- CALCUL DES FORCES EXTERIEURES SUIVEUSES (EN U- ET T+)

      CALL NMVCEX ('TEMP', COMPLU, TEMPLU)
      CALL NMCHAR ('SUIV', MODELE, NUMEDD, MATE  , CARELE,
     &             COMPOR, LISCHA, CARCRI, INST  , DEPMOI,
     &             DEPDE0, 
     &             LAMORT, VITPLU, ACCPLU, K24BID, K24BID,
     &             K24BID, K24BID, IBID, K24BID, K24BID, IBID,
     &             LBID, LBID, IBID, K24BID,     
     &             TEMPLU, SECMBR)
       
      IF (CMD(1:4).EQ.'DYNA') THEN 
        CALL NMCHAR ('INER', MODELE, NUMEDD, MATE  , CARELE,
     &               COMPOR, LISCHA, CARCRI, INST  , DEPMOI,
     &               DEPDE0, 
     &               LAMORT, VITPLU, ACCPLU, MASSE, AMORT,
     &               VITKM1,VITENT,NMODAM,VALMOD,BASMOD,NREAVI,
     &               LIMPED,LONDE,NONDP,CHONDP,      
     &               TEMPLU, SECMBR)
      ENDIF

C -- CALCUL DU SECOND MEMBRE DE VARIABLES DE COMMANDE

      CALL NMVCPR(MODELE(1:8), NUMEDD, MATE  , CARELE, COMREF,
     &            COMPOR     , VALMOI, COMPLU, CNVCPR)


C -- PREPARATION DU SECOND MEMBRE
      CNDONN(1) = CNFEDO
      CNDONN(2) = CNFSDO
      CNDONN(3) = CNDIDO
      CNDONN(4) = CNFINT
      CNDONN(5) = CNBUDI
      CNDONN(6) = CNVCPR
      CODONN(1) =  1
      CODONN(2) =  1
      CODONN(3) =  1
      CODONN(4) = -1
      CODONN(5) = -1
      CODONN(6) =  1

      CNPILO(1) = CNFEPI
      CNPILO(2) = CNFSPI
      CNPILO(3) = CNDIPI
      COPILO(1) = 1
      COPILO(2) = 1
      COPILO(3) = 1


C ======================================================================
C             CALCUL DE L'INCREMENT DE DEPLACEMENT
C ======================================================================

C -- RESOLUTION EN TENANT COMPTE DU PILOTAGE

      DINST  = INSTAP - INSTAM
      CALL NMRESO (PILOTE, 6     , CODONN, CNDONN, 3     ,
     &             COPILO, CNPILO, CNCINE, SOLVEU, MATRIX,
     &             DEPDE0, DINST , DEPOLD, MODELE, MATE  ,
     &             COMPOR, VALMOI, DEPDEL, ETA   , LICCVG(1))

9999  CONTINUE
      END
