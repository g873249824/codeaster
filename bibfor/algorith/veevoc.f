      SUBROUTINE VEEVOC(NOMO  ,MATE  ,CARELE,VARPLU,LISCHA,
     &                  PARTPS,TYPCAL,NOPASE,TYPESE,VECELE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  MATE,CARELE
      CHARACTER*8   NOMO
      CHARACTER*4   TYPCAL
      REAL*8        PARTPS(3)
      CHARACTER*19  LISCHA,VARPLU
      CHARACTER*(*) NOPASE
      CHARACTER*19  VECELE
      INTEGER       TYPESE
C
C ----------------------------------------------------------------------
C
C CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
C DE EVOL_CHAR
C
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DU MODELE
C IN  TYPCAL : TYPE DU CALCUL :
C               'MECA', POUR LA RESOLUTION DE LA MECANIQUE,
C               'DLAG', POUR LE CALCUL DE LA DERIVEE LAGRANGIENNE
C IN  LISCHA : SD LISTE DES CHARGES
C IN  PARTPS : TABLEAU DONNANT T+, DELTAT ET THETA (POUR LE THM)
C IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE   : MATERIAU CODE
C IN  VARPLU : VARIABLES DE COMMANDE A L'INSTANT T+
C IN  NOPASE : NOM DU PARAMETRE SENSIBLE
C              . POUR LA DERIVEE LAGRANGIENNE, C'EST UN CHAMP THETA
C IN  TYPESE : TYPE DE SENSIBILITE
C               0 : CALCUL STANDARD, NON DERIVE
C               SINON : DERIVE (VOIR METYSE)
C IN  NBIN   : NOMBRE MAXI DE CHAMPS D'ENTREE
C IN  LPAIN  : LISTE DES PARAMETRES IN
C IN  LCHIN  : LISTE DES CHAMPS IN
C IN  LASTIN : NOMBRE EFFECTIF DE CHAMPS IN
C OUT VECELE : VECT_ELEM RESULTAT
C
C
C
C
      INTEGER      NBIN
      PARAMETER    (NBIN=42)
      CHARACTER*8  LPAIN(NBIN)
      CHARACTER*19 LCHIN(NBIN)
C
      CHARACTER*19 NOMOBJ,LISCH2
      CHARACTER*13 PREFOB
      INTEGER      NBEVOC,LISNBG,LASTIN
      INTEGER      ICHAR,NBCHAR,ITYPOB
      LOGICAL      LEVOC,LISICO,LXFEM
      INTEGER      CODCHA
      CHARACTER*8  K8BID
      INTEGER      IBID,IPOSIT,IER
      CHARACTER*8  FNOCAL
      INTEGER      JFNOE
      REAL*8       INSTAN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL ASSERT(TYPCAL.EQ.'MECA' .OR. TYPCAL.EQ.'DLAG')
      INSTAN = PARTPS(1)
      CALL EXIXFE(NOMO,IER)
      LXFEM  = IER.NE.0
C
C --- NOMBRE DE CHARGES
C
      CALL LISNNB(LISCHA,NBCHAR)
C
C --- NOMBRE DE CHARGES DE TYPE EVOL_CHAR
C
      NBEVOC = LISNBG(LISCHA,'EVOL_CHAR')
      IF (NBEVOC.EQ.0) GOTO 99
C
C --- CHAMPS D'ENTREES STANDARDS
C
      CALL VECHMP(NOMO  ,MATE  ,CARELE,VARPLU,LXFEM ,
     &            PARTPS,TYPCAL,NOPASE,NBIN  ,LPAIN ,
     &            LCHIN ,LASTIN)
C
C --- BOUCLE SUR LES CHARGES
C
      DO 10 ICHAR = 1,NBCHAR
C
C ----- CODE DU GENRE DE LA CHARGE
C
        CALL LISLCO(LISCHA,ICHAR ,CODCHA)
        LEVOC  = LISICO('EVOL_CHAR',CODCHA)
        IF (LEVOC) THEN
C
C ------- PREFIXE DE L'OBJET DE LA CHARGE
C
          CALL LISLLC(LISCHA,ICHAR ,PREFOB)
C
C ------- NOM OBJET
C
          CALL LISDEF('POEC','EVOL_CHAR',IBID  ,K8BID ,IPOSIT)
          CALL LISDEF('OBJE',PREFOB,IPOSIT,NOMOBJ,ITYPOB)
C
C ------- ON N'ATTEND PAS UNE CARTE !
C
          CALL ASSERT(ITYPOB.NE.1)
          CALL JEEXIN(NOMOBJ,IER)
          CALL ASSERT(IER.NE.0)
C
C ------- NOM DE LA SD EVOL_CHAR
C
          CALL JEVEUO(NOMOBJ//'CHAR','L',JFNOE)
          FNOCAL = ZK8(JFNOE)
C
C ------- PREPARATION LISTE DES CHARGES EFFECTIVES
C
          LISCH2 = '&&VEEVOC.LISCHA'
          CALL VEEVOP(NOMO  ,FNOCAL,INSTAN,LISCH2)
C
C ------- CALCUL NEUMANN STANDARD
C
          CALL VECHMS(NOMO  ,MATE  ,CARELE,VARPLU,LISCH2,
     &                TYPCAL,NOPASE,TYPESE,PARTPS,VECELE)
C
          CALL JEDETR(LISCH2)
        ENDIF
 10   CONTINUE
C
 99   CONTINUE
C
      CALL JEDEMA()
      END
