      SUBROUTINE OP0176 ( IER )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/06/2005   AUTEUR CIBHHPD L.SALMONA 
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
C     OPERATEUR D'EXTRACTION
C     ------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER            IER
C
C 0.2. ==> COMMUNS
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
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0176' )
C
      INTEGER       IBID, NBORDR, JORDR, NBEXCL, JEXCL, NBARCH, JARCH
      INTEGER       NBAC, NBPA, JPA, IRET, NBNOSY, NBPARA
      INTEGER       IAUX, JAUX, IZERO,NIVE,VERSIO,IUL,IUNIFI
      INTEGER NRPASS, NBPASS
      INTEGER ADRECG
      REAL*8        R8B
      CHARACTER*1   CECR
      CHARACTER*8   K8B, FICH, FORM, FORMAR
      CHARACTER*8 LERES0, LERES1, NOPASE
      CHARACTER*8 NOSIMP
      CHARACTER*16  TYPCON, NOMCMD
      CHARACTER*19  RESUOU, RESUIN
      CHARACTER*24  LISARC, LICHEX, NOMPAR
      CHARACTER*24 NORECG
      LOGICAL       FALS, TRUE , LMOD,LBID
      COMPLEX*16    C16B
C     ------------------------------------------------------------------
C
      CALL JEMARQ( )
      CALL INFMAJ()
      TRUE = .TRUE.
      FALS = .FALSE.
      LMOD = .FALSE.
C               12   345678   9012345678901234
      LISARC = '&&'//NOMPRO//'.LISTE.ARCH'
      LICHEX = '&&'//NOMPRO//'.LISTE.CHAM'
      NOMPAR = '&&'//NOMPRO//'.NOMS_PARA '
      NORECG = '&&'//NOMPRO//'_PARA_SENSI     '
      FORMAR = '1PE12.5'
      NIVE   = 3
      VERSIO = 0
C
      CALL GETRES ( RESUOU, TYPCON, NOMCMD )
C
      CALL GETVID ( ' ', 'RESULTAT', 1,1,1, RESUIN, IBID )
C
C     --- CHAMPS ---
C
      CALL JELIRA ( RESUIN//'.DESC', 'NOMMAX', NBNOSY, K8B )
      IF ( NBNOSY .EQ. 0 ) GOTO 9997
C
C     --- NOMBRE DE NUMERO D'ORDRE ---
C
      CALL RSORAC ( RESUIN, 'LONUTI', IBID, R8B, K8B, C16B, R8B, K8B,
     >                                               NBORDR, 1, IBID )
      CALL WKVECT ( '&&'//NOMPRO//'.NUME_ORDRE', 'V V I', NBORDR, JORDR)
      CALL RSORAC ( RESUIN, 'TOUT_ORDRE', IBID, R8B, K8B, C16B, R8B,K8B,
     >                                         ZI(JORDR), NBORDR, IBID )
C
C     --- ACCES ET PARAMETRES ---
C
      CALL RSNOPA ( RESUIN, 2, NOMPAR, NBAC, NBPA )
      NBPARA = NBAC + NBPA
      CALL JEVEUO ( NOMPAR, 'L', JPA )
C
C     --- CHAMPS EXCLUS ET PAS D'ARCHIVAGE ---
C
      CALL DYARC0 ( RESUIN, NBNOSY, NBARCH, LISARC, NBEXCL, LICHEX )
      IF ( NBARCH .EQ. 0 ) GOTO 9997
      CALL JEVEUO ( LICHEX, 'L', JEXCL )
      CALL JEVEUO ( LISARC, 'L', JARCH )
C
C     --- ALLOCATION DE LA STRUCTURE SORTIE SI ELLE N'EXISTE PAS ---
C     --- IL FAUT LE FAIRE AVANT L'APPEL A PSRESE, SINON IL Y A  ---
C     --- PLANTAGE SI ON VEUT ARCHIVER UN RESULTAT SENSIBLE SEUL  ---
C
      CALL JEEXIN (RESUOU//'.DESC',IRET)
      IF ( IRET.EQ.0 ) THEN
        CALL RSCRSD (RESUOU,TYPCON,NBARCH)
      ENDIF
C
C     --- SENSIBILITE : NOMBRE DE PASSAGES ---
      IAUX = 1
      JAUX = 1
      CALL PSRESE ( ' ', IBID, IAUX, RESUOU, JAUX,
     >              NBPASS, NORECG, IRET )
      CALL JEVEUO ( NORECG, 'L', ADRECG )
C
C============ DEBUT DE LA BOUCLE SUR LE NOMBRE DE PASSAGES =============
      DO 30 , NRPASS = 1 , NBPASS
C
C        POUR LE PASSAGE NUMERO NRPASS :
C        . NOPASE : NOM DU PARAMETRE DE SENSIBILITE EVENTUELLEMENT
C        . LERES1 : NOM DU CHAMP DE RESULTAT A COMPLETER
C                   C'EST RESUOU POUR UN CALCUL STANDARD, UN NOM
C                   COMPOSE A PARTIR DE RESUOU ET NOPASE POUR UN CALCUL
C                   DE SENSIBILITE
C        . LERES0 : IDEM POUR RESUIN
C
        NOPASE = ZK24(ADRECG+2*NRPASS-1)(1:8)
        LERES1 = ZK24(ADRECG+2*NRPASS-2)(1:8)
C
C DANS LE CAS D'UN CALCUL STANDARD :
C
        IF ( NOPASE.EQ.' ' ) THEN
C
          LERES0 = RESUIN(1:8)
          NOSIMP = '        '
C
C DANS LE CAS D'UN CALCUL DE DERIVE :
C
        ELSE
C
          NOSIMP = RESUOU(1:8)
          CALL PSRENC ( RESUIN, NOPASE, LERES0, IRET )
          IF ( IRET.NE.0 ) THEN
            CALL UTMESS ('A', NOMCMD,
     >  'IMPOSSIBLE DE TROUVER LE RESULTAT DERIVE ASSOCIE AU RESULTAT '
     >  //RESUIN//' ET AU PARAMETRE SENSIBLE '//NOPASE)
            GOTO 30
          ENDIF
C
        ENDIF
C
C
        IF ( LERES0 .EQ. LERES1 ) THEN
          CALL EXTRS1 ( LERES0,
     >                  NBORDR, ZI(JORDR), NBPARA, ZK16(JPA),
     >                  NBARCH, ZI(JARCH), NBEXCL, ZK16(JEXCL), NBNOSY )
        ELSE
          CALL EXTRS2 ( LERES0, LERES1, TYPCON,
     >                  NBORDR, ZI(JORDR), NBPARA, ZK16(JPA),
     >                  NBARCH, ZI(JARCH), NBEXCL, ZK16(JEXCL), NBNOSY )
        ENDIF
C
        CALL TITRE( )
C
C     --- IMPRESSION ---
C
        FORM = 'RESULTAT'
        FICH = 'MESSAGE'
        IUL  = IUNIFI( FICH )
        CALL RSINFO ( LERES1, IUL )
C
        CALL RSORAC ( LERES1,'LONUTI',IBID,R8B,K8B,C16B,R8B,K8B,
     >                                                 NBORDR,1,IBID)
        CALL RSORAC ( LERES1,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     >                                          ZI(JORDR),NBORDR,IBID)
        K8B  = '        '
        CECR = 'T'
        IZERO = 0
        CALL IRECRI ( LERES1,NOSIMP,NOPASE,FORM,IUL,K8B,LBID,
     >                IZERO,K8B,' ',NBPARA,ZK16(JPA),
     >               NBORDR,ZI(JORDR),TRUE,'RESU',1,K8B,CECR,FALS,IZERO,
     >                IBID,IZERO,IBID,IZERO,K8B,FALS,R8B,FALS,R8B,FALS,
     >                FALS,FORMAR,LMOD,NIVE,VERSIO)
C
   30 CONTINUE
C============= FIN DE LA BOUCLE SUR LE NOMBRE DE PASSAGES ==============
 9997 CONTINUE
C
C
      CALL JEDEMA( )
C
      END
