      SUBROUTINE PSNOSD ( NOMSD, NBSTSE, NOSTNC, IRET )
C
C     PARAMETRES SENSIBLES - NOMS DES STRUCTURES DERIVEES
C     *          *           **       *          *
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 05/01/2004   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GNICOLAS G.NICOLAS
C ----------------------------------------------------------------------
C     CE PROGRAMME RETOURNE, POUR UN NOM DE STRUCTURE DONNE :
C     . SI LA STRUCTURE A DES DERIVEES :
C       . LE NOMBRE DE STRUCTURES SENSIBLES ASSOCIEES
C       . UN TABLEAU CONTENANT LES COUPLES :
C             (NOM COMPOSE, NOM DU PARAMETRE SENSIBLE)
C     . OU SI LA STRUCTURE EST UNE DERIVEE :
C       . NBSTSE = -1
C       . UN TABLEAU CONTENANT LE COUPLE :
C             (NOM PRIMITIF, NOM DU PARAMETRE SENSIBLE)
C     . SINON :
C       . NBSTSE = 0
C       . LE TABLEAU N'EST PAS ALLOUE
C     ------------------------------------------------------------------
C IN  NOMSD   : NOM DE LA SD DE BASE
C OUT NBSTSE  : NOMBRE DE STRUCTURES SENSIBLES ASSOCIEES A NOMSD
C               . -1 SI NOMSD EST UNE STRUCTURE DERIVEE
C               . LE NOMBRE DE STRUCTURES SENSIBLES ASSOCIEES, SI NOMSD
C                 EST DERIVEE
C               . 0 SINON
C OUT NOSTNC  : STRUCTURE QUI CONTIENT LES NBSTSE COUPLES
C               (NOM COMPOSE, NOM DU PARAMETRE SENSIBLE)
C               ELLE EST ALLOUEE ICI
C OUT IRET    : CODE_RETOUR :
C                     0 -> TOUT S'EST BIEN PASSE
C                     1 -> NOMSD APPARAIT PLUSIEURS FOIS EN DERIVE
C
C  REMARQUE : SI CETTE STRUCTURE DE MEMORISATION EST INCONNUE, ON EN
C             CONCLUT QU'AUCUN CALCUL DE SENSIBILITE N'A ETE DEMANDE
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*(*) NOMSD, NOSTNC
      INTEGER NBSTSE, IRET
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'PSNOSD' )
C
      CHARACTER*13 PREFIX
C
      INTEGER LXLGUT
C
      INTEGER ADMMEM, ADSTNC, NUTI, IER, LGNOCO
      INTEGER IAUX, JAUX, KAUX
C
      CHARACTER*8 NOMSD8, SAUX08
      CHARACTER*18 NOMMEM
C     ------------------------------------------------------------------
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
C
      CALL SEMECO ( 'PREFIXE', SAUX08, SAUX08,
     >               PREFIX,
     >               SAUX08, IAUX, SAUX08, SAUX08, SAUX08,
     >               IRET )
C
      NBSTSE = 0
C
C 1.1. ==> VERIFICATION DU NOM DE LA STRUCTURE
C
      LGNOCO = LXLGUT(NOMSD)
      IF ( LGNOCO.GT.8 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'LA CHAINE NOMSD' )
        CALL UTIMPI ( 'S', ' EST DE LONGUEUR : ', 1, LGNOCO )
        CALL UTFINM
        CALL UTMESS ( 'F', NOMPRO,
     >  'POUR UN CONCEPT, PAS PLUS DE 8 SVP.')
      ELSE
        NOMSD8 = '        '
        NOMSD8(1:LGNOCO) = NOMSD(1:LGNOCO)
      ENDIF
C
C 1.2. ==> DECODAGE DE LA STRUCTURE DE MEMORISATION
C
C                         45678
      NOMMEM = PREFIX // '.CORR'
      CALL JEEXIN (NOMMEM,IER)
C
      IF ( IER.EQ.0 ) THEN
C
        NUTI = 0
C
      ELSE
C
        CALL JELIRA ( NOMMEM, 'LONUTI', NUTI, SAUX08 )
C
      ENDIF
C
C====
C 2. DECODAGE
C====
C
      IF ( NUTI.NE.0 ) THEN
C
C 2.1. ==> RECHERCHE DU NOMBRE DE NOMS COMPOSES ASSOCIES AU NOM SIMPLE
C
      IF ( IRET.EQ.0 ) THEN
C
      CALL JEVEUO ( NOMMEM, 'L', ADMMEM )
      KAUX = 2*(NUTI-1)
      DO 211 , IAUX = 0 , KAUX, 2
        IF ( ZK80(ADMMEM+IAUX)(1:8).EQ.NOMSD8 ) THEN
          NBSTSE = NBSTSE + 1
        ENDIF
  211 CONTINUE
C
      IF ( NBSTSE.EQ.0 ) THEN
C
      KAUX = 2*(NUTI-1)
      DO 212 , IAUX = 0 , KAUX, 2
        IF ( ZK80(ADMMEM+IAUX)(17:24).EQ.NOMSD8 ) THEN
          IF ( NBSTSE.EQ.0 ) THEN
            NBSTSE = -1
          ELSE
            CALL UTMESS ( 'A', NOMPRO,
     >      'LA STRUCTURE '//NOMSD8//' APPARAIT PLUSIEURS FOIS EN '//
     >      'TANT QUE DERIVEE ?')
            IRET = 1
          ENDIF
        ENDIF
  212 CONTINUE
C
      ENDIF
C
      ENDIF
C
C 2.2. ==> ARCHIVAGE DU PARAMETRE ET DU NOM COMPOSE OU PRIMITIF
C
      IF ( IRET.EQ.0 ) THEN
C
      IF ( NBSTSE.NE.0 ) THEN
C
      IAUX = 2*ABS(NBSTSE)
      CALL WKVECT ( NOSTNC, 'V V K8', IAUX, ADSTNC )
C
      JAUX = ADSTNC - 1
      KAUX = 2*(NUTI-1)
      DO 22 , IAUX = 0 , KAUX, 2
C
        IF ( ZK80(ADMMEM+IAUX)(1:8).EQ.NOMSD8 ) THEN
          JAUX = JAUX + 1
          ZK8(JAUX) = ZK80(ADMMEM+IAUX) (17:24)
          JAUX = JAUX + 1
          ZK8(JAUX) = ZK80(ADMMEM+IAUX) (9:16)
        ELSEIF ( ZK80(ADMMEM-1+IAUX)(17:24).EQ.NOMSD8 ) THEN
          JAUX = JAUX + 1
          ZK8(JAUX) = ZK80(ADMMEM+IAUX) (1:8)
          JAUX = JAUX + 1
          ZK8(JAUX) = ZK80(ADMMEM+IAUX) (9:16)
        ENDIF
C
   22 CONTINUE
C
      ENDIF
C
      ENDIF
C
      ENDIF
C
      CALL JEDEMA()
C
      END
