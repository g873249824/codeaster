      SUBROUTINE CHPREC(CHOU)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/04/2002   AUTEUR GNICOLAS G.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================

C     TRAITEMENT DE COMMANDE:   CREA_CHAMP / OPTION: 'EXTR'

C     ------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*(*) CHOU
C
C 0.2. ==> COMMUNS
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'CHPREC' )
C
      INTEGER IBID,ICORET,IRET,JORDR,N1,N2,N3,N4,N5,NBORDR,NC,NP
      INTEGER IAUX, JAUX
      INTEGER NRPASS, NBPASS
      INTEGER ADRECG
      REAL*8 INST,EPSI
      CHARACTER*1 BASE
      CHARACTER*8 RESUCO,INTERP,CRIT,PROLDR,PROLGA,TYPMAX
CC      CHARACTER*8 LERESU, NOPASE
      CHARACTER*8 LERESU
      CHARACTER*16 K16BID,NOMCMD,NOMCH,ACCES,TYSD
      CHARACTER*19 CHEXTR,NOCH19,KNUM
      CHARACTER*24 NORECG
      CHARACTER*8 K8BID,MA
C     ------------------------------------------------------------------

      CALL JEMARQ()
C               12   345678   9012345678901234
      NORECG = '&&'//NOMPRO//'_PARA_SENSI     '
C
      BASE = 'G'
      CALL GETRES(K8BID,K16BID,NOMCMD)
      NOCH19 = CHOU

      CALL GETVTX(' ','NOEUD_CMP',0,1,0,K8BID,N1)
      IF (N1.NE.0 .AND. N1.NE.-2) CALL UTMESS('F',NOMCMD,
     &    'AVEC "NOEUD_CMP", IL FAUT DONNER '//
     &    'UN NOM ET UNE COMPOSANTE.')
      CALL GETVTX(' ','NOM_CHAM',0,1,1,NOMCH,N2)


C     1. CAS DE LA RECUPERATION DU CHAMP DE GEOMETRIE D'UN MAILLAGE
C     ==============================================================
      IF (NOMCH.EQ.'GEOMETRIE') THEN
        CALL GETVID(' ','MAILLAGE',0,1,1,MA,N1)
        IF (N1.EQ.0) CALL UTMESS('F',NOMPRO,'POUR RECUPERER '//
     &     'LE CHAMP DE GEOMETRIE, IL FAUT UTILISER LE MOT CLE MAILLAGE'
     &                           )

        CALL COPISD('CHAMP_GD','G',MA//'.COORDO',NOCH19)
        GO TO 20
      END IF



C     2. CAS DE LA RECUPERATION D'UN CHAMP D'UNE SD RESULTAT
C     ==============================================================
      CALL GETVID(' ','RESULTAT',0,1,1,RESUCO,N1)
      CALL GETVTX(' ','INTERPOL',0,1,1,INTERP,N3)
      CALL GETVTX(' ','TYPE_MAXI',0,1,1,TYPMAX,N5)
      CALL GETTCO(RESUCO,TYSD)
C
C     --- SENSIBILITE : NOMBRE DE PASSAGES ---
C
      IAUX = 1
      JAUX = 1
      CALL PSRESE ( ' ', IBID, IAUX, RESUCO, JAUX,
     >              NBPASS, NORECG, IRET )
      CALL JEVEUO ( NORECG, 'L', ADRECG )
C
C============ DEBUT DE LA BOUCLE SUR LE NOMBRE DE PASSAGES =============
      DO 30 , NRPASS = 1 , NBPASS
C
C        POUR LE PASSAGE NUMERO NRPASS :
C        . NOM DU CHAMP DE RESULTAT
C        . NOM DU PARAMETRE DE SENSIBILITE
C
        LERESU = ZK24(ADRECG+2*NRPASS-2)(1:8)
CC        NOPASE = ZK24(ADRECG+2*NRPASS-1)(1:8)
C
C     --- ON PEUT FAIRE UNE INTERPOLATION ---
C         ===============================
      IF (TYSD.EQ.'EVOL_THER' .OR. TYSD.EQ.'EVOL_ELAS' .OR.
     &    TYSD.EQ.'EVOL_NOLI' .OR. TYSD.EQ.'DYNA_TRANS') THEN

        IF (INTERP(1:3).EQ.'LIN') THEN
          CALL GETVR8(' ','INST',0,1,1,INST,N4)
          PROLDR = 'CONSTANT'
          PROLGA = 'CONSTANT'
          ACCES = 'INST'
          CALL RSINCH(LERESU,NOMCH,ACCES,INST,NOCH19,PROLDR,PROLGA,2,
     &                BASE,ICORET)
        ELSE
          IF (N5.NE.0) THEN
            CALL CHMIMA(LERESU,NOMCH,TYPMAX,NOCH19)
          ELSE
            KNUM = '&&'//NOMPRO//'.NUME_ORDRE'
            CALL GETVR8(' ','PRECISION',1,1,1,EPSI,NP)
            CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)
            CALL RSUTNU(LERESU,' ',0,KNUM,NBORDR,EPSI,CRIT,IRET)
            IF ((IRET.NE.0) .OR. (NBORDR.GT.1)) GO TO 10
            IF (NBORDR.EQ.0) THEN
              CALL UTMESS('F',NOMCMD,'ON NE TROUVE AUCUN CHAMP.')
            END IF
            CALL JEVEUO(KNUM,'L',JORDR)
            CALL RSEXCH(LERESU,NOMCH,ZI(JORDR),CHEXTR,IRET)
            IF (IRET.EQ.0) THEN
              CALL COPISD('CHAMP_GD','G',CHEXTR,NOCH19)
            ELSE IF (IRET.EQ.101 .OR. IRET.EQ.111) THEN
              CALL UTMESS('F',NOMCMD,'LE NOM SYMBOLIQUE : '//NOMCH//
     &                    ' EST ILLICITE POUR CE RESULTAT')
            ELSE
              CALL UTMESS('F',NOMCMD,'LE CHAMP CHERCHE N''A PAS '//
     &                    'ENCORE ETE CALCULE.')
            END IF
            CALL JEDETR(KNUM)
          END IF
        END IF

C     --- ON NE FAIT QU'UNE EXTRACTION ---
C         ===========================
      ELSE
        IF (INTERP(1:3).EQ.'LIN') THEN
          CALL UTDEBM('F',NOMCMD,'INTERPOLATION INTERDITE')
          CALL UTIMPK('L','POUR UN RESULTAT DE TYPE : ',1,TYSD)
          CALL UTFINM()
        ELSE
          KNUM = '&&'//NOMPRO//'.NUME_ORDRE'
          CALL GETVR8(' ','PRECISION',1,1,1,EPSI,NP)
          CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)
          CALL RSUTNU(LERESU,' ',0,KNUM,NBORDR,EPSI,CRIT,IRET)
          IF ((IRET.NE.0) .OR. (NBORDR.GT.1)) GO TO 10
          IF (NBORDR.EQ.0) THEN
            CALL UTMESS('F',NOMCMD,'ON NE TROUVE AUCUN CHAMP.')
          END IF
          CALL JEVEUO(KNUM,'L',JORDR)
          CALL RSEXCH(LERESU,NOMCH,ZI(JORDR),CHEXTR,IRET)
          IF (IRET.EQ.0) THEN
            CALL COPISD('CHAMP_GD','G',CHEXTR,NOCH19)
          ELSE IF (IRET.EQ.101 .OR. IRET.EQ.111) THEN
            CALL UTMESS('F',NOMCMD,'LE NOM SYMBOLIQUE : '//NOMCH//
     &                  ' EST ILLICITE POUR CE RESULTAT')
          ELSE
            CALL UTMESS('F',NOMCMD,'LE CHAMP CHERCHE N''A PAS '//
     &                  'ENCORE ETE CALCULE.')
          END IF
          CALL JEDETR(KNUM)
        END IF
      END IF
C
   30 CONTINUE
C============= FIN DE LA BOUCLE SUR LE NOMBRE DE PASSAGES ==============

      GO TO 20
   10 CONTINUE
      CALL UTMESS('F',NOMCMD,'L''ALARME PRECEDENTE EST ICI FATALE :'//
     &          ' IL EXISTE PLUSSIEURS CHAMPS CORRESPONDANT A L''ACCES.'
     &            )
      CALL TITRE
   20 CONTINUE
C
      CALL JEDETC ( 'V', '&&'//NOMPRO, 1)

      CALL JEDEMA()
      END
