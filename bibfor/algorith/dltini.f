      SUBROUTINE DLTINI (NEQ,DEPINI,VITINI,ACCINI,LCREA,NUME,
     &                   NUMEDD,INCHAC )
      IMPLICIT  REAL*8  (A-H,O-Z)
      REAL*8             DEPINI(*), VITINI(*), ACCINI(*)
      CHARACTER*24       NUMEDD
      LOGICAL            LCREA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/01/2001   AUTEUR ACBHHCD G.DEVESA 
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
C     CALCUL MECANIQUE TRANSITOIRE PAR INTEGRATION DIRECTE
C     RECUPERATION DES CONDITIONS INITIALES
C     ------------------------------------------------------------------
C IN  : NEQ    : NOMBRE D'EQUATIONS
C OUT : DEPINI : CHAMP DE DEPLACEMENT INITIAL OU DE REPRISE
C OUT : VITINI : CHAMP DE VITESSE INITIALE OU DE REPRISE
C OUT : ACCINI : CHAMP D'ACCELERATION INITIALE OU DE REPRISE
C OUT : LCREA  : CREATION OU NON DU RESULTAT
C OUT : NUME   : NUMERO D'ORDRE DE REPRISE
C VAR : INCHAC : CALCUL OU NON DE L'ACCELERATION INITIALE
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      CHARACTER*8   K8B, NOMRES, DYNA, CRIT
      CHARACTER*16  TYPRES, NOMCMD
      CHARACTER*19  CHAMP, CHAM2
      COMPLEX*16    C16B
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL GETRES(NOMRES,TYPRES,NOMCMD)
C
C     --- EST-ON EN REPRISE ? ---
C
      CALL GETVID('ETAT_INIT','DYNA_TRANS',1,1,1,DYNA,NDY)
      IF ( NDY .NE. 0 ) THEN
         CALL GETVIS('ETAT_INIT','NUME_INIT' ,1,1,1,NUME,NNI)
         IF ( NNI .EQ. 0 ) THEN
            CALL GETVR8('ETAT_INIT','INST_INIT',1,1,1,TEMPS,NT)
            IF ( NT .EQ. 0 ) THEN
               CALL RSORAC(DYNA,'DERNIER',IBID,TEMPS,K8B,C16B,
     +                                         PREC,CRIT,NUME,1,NBTROU)
               IF (NBTROU.NE.1) THEN
                  CALL UTMESS('F',NOMCMD,'ON N''A PAS PU TROUVE LE '//
     +                                   'DERNIER INSTANT SAUVE.')
               ENDIF
            ELSE
               CALL GETVR8('ETAT_INIT','PRECISION',1,1,1,PREC ,NP)
               CALL GETVTX('ETAT_INIT','CRITERE'  ,1,1,1,CRIT ,NC)
               CALL RSORAC(DYNA,'INST',IBID,TEMPS,K8B,C16B,
     +                                        PREC,CRIT,NUME,1,NBTROU)
               IF (NBTROU.LT.0) THEN
                  CALL UTDEBM('F',NOMCMD,'PLUSIEURS CHAMPS '
     +                           //'CORRESPONDANT A L''ACCES DEMANDE.')
                  CALL UTIMPK('L','RESULTAT ',1,DYNA)
                  CALL UTIMPR('S',', ACCES "INST": ',1,TEMPS)
                  CALL UTIMPI('S',', NOMBRE :',1,-NBTROU)
                  CALL UTFINM()
               ELSEIF (NBTROU.EQ.0) THEN
                  CALL UTDEBM('F',NOMCMD,'PAS DE CHAMP '//
     +                             'CORRESPONDANT A UN ACCES DEMANDE.')
                  CALL UTIMPK('L','RESULTAT ',1,DYNA)
                  CALL UTIMPR('S',', ACCES "INST": ',1,TEMPS)
                  CALL UTFINM()
               ENDIF
            ENDIF
         ENDIF
C
C        --- RECUPERATION DES CHAMPS DEPL VITE ET ACCE ---
         CALL RSEXCH(DYNA,'DEPL',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL UTMESS('F',NOMCMD,'LE CHAMP "DEPL" N''EST PAS '//
     &                      'TROUVE DANS LE CONCEPT DYNA_TRANS '//DYNA)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL R8COPY(NEQ,ZR(JVALE),1,DEPINI,1)
         ENDIF
         CALL RSEXCH(DYNA,'VITE',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL UTMESS('F',NOMCMD,'LE CHAMP "VITE" N''EST PAS '//
     &                      'TROUVE DANS LE CONCEPT DYNA_TRANS '//DYNA)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL R8COPY(NEQ,ZR(JVALE),1,VITINI,1)
         ENDIF
         CALL RSEXCH(DYNA,'ACCE',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL UTMESS('F',NOMCMD,'LE CHAMP "ACCE" N''EST PAS '//
     &                      'TROUVE DANS LE CONCEPT DYNA_TRANS '//DYNA)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL R8COPY(NEQ,ZR(JVALE),1,ACCINI,1)
         ENDIF
C
C        --- CREE-T-ON UNE NOUVELLE STRUCTURE ? ---
         IF ( NOMRES .EQ. DYNA ) THEN
            LCREA = .FALSE.
            CALL RSRUSD ( NOMRES, NUME+1 )
         ENDIF
C
      ELSE
C
C     --- RECUPERATION DES CONDITIONS INITIALES ---
C
         NUME = 0
         CALL GETVID('ETAT_INIT','DEPL_INIT',1,1,1,CHAMP,NDI)
         IF (NDI.GT.0) THEN
            INCHAC = 1
            CHAM2 = '&&OP0048.DEPINI'
            CALL VTCREB (CHAM2, NUMEDD, 'V', 'R', NEQ)
            CALL VTCOPY(CHAMP,CHAM2,IRET)
            CALL JEVEUO(CHAM2//'.VALE','L',JVALE)
            CALL R8COPY(NEQ,ZR(JVALE),1,DEPINI,1)
         ELSE
            CALL UTMESS('I',NOMCMD,'DEPLACEMENTS INITIAUX NULS.')
         ENDIF
C
         CALL GETVID('ETAT_INIT','VITE_INIT',1,1,1,CHAMP,NVI)
         IF (NVI.GT.0) THEN
            INCHAC = 1
            CHAM2 = '&&OP0048.VITINI'
            CALL VTCREB (CHAM2, NUMEDD, 'V', 'R', NEQ)
            CALL VTCOPY(CHAMP,CHAM2,IRET)
            CALL JEVEUO(CHAM2//'.VALE','L',JVALE)
            CALL R8COPY(NEQ,ZR(JVALE),1,VITINI,1)
         ELSE
            CALL UTMESS('I',NOMCMD,'VITESSES INITIALES NULLES.')
         ENDIF
C
      ENDIF
C
      CALL JEDEMA()
      END
