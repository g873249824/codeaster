      SUBROUTINE TITREA(NIV,NOMCON,NOMCHA,NOMOBJ,ST,MOTFAC,IOCC,BASE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*1       NIV,              ST,                   BASE
      CHARACTER*(*)         NOMCON,NOMCHA,NOMOBJ,   MOTFAC
      INTEGER                                              IOCC
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/02/96   AUTEUR VABHHTS J.PELLET 
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
C     CREATION D'UN TITRE ATTACHE A UN CONCEPT
C     ------------------------------------------------------------------
C IN  NIV    : K1  : NIVEAU DU TITRE 'T': TITRE 'S': SOUS-TITRE
C                                    'E': EXCEPTION
C IN  NOMCON : K8  : NOM DU RESULTAT
C IN  NOMCHA : K19 : NOM DU CHAMP A TRAITER DANS LE CAS D'UN RESULTAT
C IN  NOMOBJ : K24 : NOM DE L'OBJET DE STOCKAGE
C IN  ST     : K1  : STATUT 'D': ECRASEMENT DU (SOUS-)TITRE PRECEDENT
C                           'C': CONCATENATION (SOUS-)TITRE PRECEDENT
C IN  MOTFAC : K16 : NOM DU MOT CLE FACTEUR SOUS LEQUEL EST LE TITRE
C IN  IOCC   : IS  : OCCURRENCE CONCERNEE SI L'ON A UN MOT CLE FACTEUR
C IN  BASE   : IS  : NOM DE LA BASE OU EST CREE L'OBJET
C     ------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8    CRES
      CHARACTER*16   NOMCMD, CBID, MOTCLE
      CHARACTER*8    NOMRES,CONCEP
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CBID   = '  '
      IF ( MOTFAC .NE. '  ' ) THEN
         CALL GETFAC(MOTFAC, NBOCC)
         IF ( IOCC .GT. NBOCC .OR. IOCC .LT. 1 ) THEN
            CALL GETRES(NOMRES,CONCEP,NOMCMD)
            CALL UTDEBM('A',NOMCMD//'.TITRE (ERREUR 01)',
     +                     ' NUMERO D''OCCURRENCE INVALIDE ')
            CALL UTIMPI('S',' ',1,IOCC)
            CALL UTIMPK('S','POUR LE MOT CLE FACTEUR',1,MOTFAC)
            CALL UTFINM()
            GOTO 9999
         ENDIF
      ENDIF
C
      CALL GETRES(CRES,CBID,CBID)
      IF ( NIV .EQ. 'T' ) THEN
         MOTCLE = 'TITRE'
      ELSEIF ( NIV .EQ. 'E' ) THEN
         MOTCLE = 'SOUS_TITRE'
      ELSEIF ( CRES .EQ. '  ' ) THEN
         MOTCLE = 'SOUS_TITRE'
      ELSE
         MOTCLE = '   '
      ENDIF
C
      IF ( MOTCLE .NE. '   ' ) THEN
         CALL GETVTX(MOTFAC,MOTCLE,IOCC,1,0,CBID,NBTITR)
         NBTITR = - NBTITR
      ELSE
         NBTITR = 0
      ENDIF
C
      IF ( NBTITR .EQ. 0 ) THEN
C        --- TITRE PAR DEFAUT  ---
         CALL TITRED(NIV,NOMCON,NOMCHA,NBTITR)
         CALL JEVEUO('&&TITRE .TAMPON.ENTREE','E',LDON)
         CALL JEVEUO('&&TITRE .LONGUEUR','E',LLON)
      ELSE
C        --- TITRE UTILISATEUR ---
         CALL WKVECT('&&TITRE .TAMPON.ENTREE','V V K80',NBTITR,LDON)
         CALL WKVECT('&&TITRE .LONGUEUR     ','V V I  ',NBTITR,LLON)
         CALL GETVTX(MOTFAC,MOTCLE,IOCC,1,NBTITR,ZK80(LDON),L)
         CALL GETLTX(MOTFAC,MOTCLE,IOCC,1,NBTITR,ZI(LLON),L)
      ENDIF
      CALL TITRE1(ST,NOMOBJ,BASE,NBTITR,ZK80(LDON),ZI(LLON))
      CALL JEDETR('&&TITRE .TAMPON.ENTREE')
      CALL JEDETR('&&TITRE .LONGUEUR     ')
 9999 CONTINUE
      CALL JEDEMA()
      END
