      SUBROUTINE MPMOD2(BASEMO,NOMMES,NBMESU,NBMTOT,BASEPR,
     &                  VNOEUD,VRANGE,VCHAM)
C
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/01/2011   AUTEUR PELLET J.PELLET 
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
C
C     PROJ_MESU_MODAL : PROJECTION DE LA MATRICE MODALE SUR LES CMP
C                       DES NOEUDS MESURE
C
C     IN  : BASEMO : NOM DE LA BASE DE PROJECTION
C     IN  : NOMMES : NOM DE LA MESURE
C     IN  : NBMESU : NOMBRE DE MESURE (DATASET 58)
C     IN  : NBMTOT : NOMBRE DE VECTEURS DE BASE
C     OUT  : BASEPR : NOM BASE PROJETEE SUIVANT DIRECTION MESURE
C     IN  : VNOEUD : NOM RANGEMENT NOEUD MESURE
C     IN  : VRANGE : NOM CORRESPONDANCE CMP SUIVANT VNOEUD
C     IN  : VCHAM : NOM CORRESPONDANCE NOMCHAMP SUIVANT VNOEUD
C
      IMPLICIT NONE
C     ------------------------------------------------------------------
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8   BASEMO, NOMMES
      CHARACTER*24  VNOEUD,VRANGE,BASEPR,VCHAM
      CHARACTER*24 VALK(2)
      INTEGER       NBMESU, NBMTOT
      INTEGER VALI
C
      CHARACTER*8  NOMRES,K8BID
      CHARACTER*16 NOMCHA, CORRES,NOMCH,TYPRES, K16BID,NOMCHM
      CHARACTER*19 CHAMNO, CH1S, CH2S
      CHARACTER*24 VORIEN

      INTEGER      LORD, LRED, LORI,LRANGE
      INTEGER      IMESU, II, IMODE, IRET
      INTEGER      IPOSD, ICMP, INO
      INTEGER      LNOEUD,NNOEMA,NCMPMA
      INTEGER      JCNSD,JCNSC,JCNSV,JCNSL,JCNSK
      INTEGER      IBID,NBCMPI,NBCHAM,LCH,ICH,LCHAM

      REAL*8       VORI(3)
      REAL*8       VAL,VECT(3),R8PREM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ( )
C
C RECUPERATION DU NOM DU CONCEPT RESULTAT
      CALL GETRES (NOMRES, TYPRES, K16BID)
C
C =============================================
C RECUPERATION DES OBJETS LIES A LA MESURE
C =============================================
C
      CALL MPMOD3(BASEMO,NOMMES,NBMESU,NBMTOT,VCHAM,
     &            VNOEUD,VRANGE,VORIEN,NNOEMA,NCMPMA)

      CALL JEVEUO ( VNOEUD,'L',LNOEUD )
      CALL JEVEUO ( VRANGE,'L',LRANGE )
      CALL JEVEUO ( VCHAM,'L',LCHAM )
      CALL JEVEUO ( VORIEN,'L',LORI )

C RECUPERATION DES NOMS DU CHAMP MESURE

      CALL GETVTX ('MODELE_MESURE','NOM_CHAM',1,1,0,NOMCHA,NBCHAM)
      IF (NBCHAM .NE. 0) THEN
        NBCHAM = -NBCHAM
      ELSE
        CALL U2MESS('A','ALGORITH10_93')
      ENDIF
      CALL WKVECT ('&&LISTE_CHAMP', 'V V K16', NBCHAM, LCH)
      CALL GETVTX ('MODELE_MESURE','NOM_CHAM',1,1,NBCHAM,ZK16(LCH),IBID)

C     -> OBJET MATRICE MODALE REDUITE SUIVANT DIRECTION DE MESURE
C
      BASEPR = NOMRES//'.PROJM    .PJMBP'

      CALL WKVECT(BASEPR,'G V R',NNOEMA*NCMPMA*NBMTOT,LRED)

C     INITIALISATION DE BASEPR
      DO 152 II = 1,NNOEMA*NCMPMA*NBMTOT
        ZR(LRED-1 + II) = 0.D0
152   CONTINUE

C RECUPERATION SD CORRESPONDANCE ENTRE MAILLAGE MODELE/MESURE
C
      CORRES = '&&PJEFTE.CORRESP'
      CALL MPJEFT (CORRES)
C
C BOUCLE SUR LES CHAMPS MESURES
C POUR L'INSTANT ON NE RAJOUTE PAS DE PONDERATION SUR LES MESURE
C A FAIRE EVENTUELLEMENT : EN FONCTION DU TYPE DE CHAMP

      DO 151 ICH = 1,NBCHAM
        NOMCHA = ZK16(LCH-1 +ICH)
        NOMCH = NOMCHA
C MEMES VECTEURS DE BASE POUR : DEPL, VITE ET ACCE
        IF (NOMCH .EQ. 'VITE' .OR. NOMCH .EQ. 'ACCE')
     &        NOMCH = 'DEPL'
C MEMES VECTEURS DE BASE POUR LES CONTRAINTES
        IF (NOMCH(1:4) .EQ. 'SIEF')
     &        NOMCH = 'SIGM_NOEU_DEPL'
C MEMES VECTEURS DE BASE POUR LES DEFORMATIONS
        IF (NOMCH(1:4) .EQ. 'EPSI')
     &        NOMCH = 'EPSI_NOEU'
C
        CALL JEVEUO ( BASEMO//'           .ORDR' , 'L' , LORD )
C
        CH1S='&&PJEFPR.CH1S'
        CH2S='&&PJEFPR.CH2S'
C
C BOUCLE SUR TOUS LES MODES
C 
        DO 10 IMODE = 1,NBMTOT
C
          CALL RSEXCH (BASEMO,NOMCH,ZI(LORD-1+IMODE),CHAMNO,IRET)
C
          IF (IRET .NE. 0) THEN
            VALK (1) = BASEMO
            VALK (2) = NOMCH
            VALI = ZI (LORD-1+IMODE)
            CALL U2MESG('F', 'SOUSTRUC_84',2,VALK,1,VALI,0,0.D0)
          END IF
C
C       2-1 : TRANSFORMATION DE CHAMNO EN CHAM_NO_S : CH1S
          CALL DETRSD('CHAM_NO_S',CH1S)
          CALL CNOCNS(CHAMNO,'V',CH1S)

C       2-2 : PROJECTION DU CHAM_NO_S : CH1S -> CH2S
          CALL DETRSD('CHAM_NO_S',CH2S)
          CALL CNSPRJ(CH1S,CORRES,'V',CH2S,IRET)
          IF (IRET.GT.0) CALL U2MESS('F','ALGORITH6_25')

          CALL JEVEUO(CH2S//'.CNSK','L',JCNSK)
          CALL JEVEUO(CH2S//'.CNSD','L',JCNSD)
          CALL JEVEUO(CH2S//'.CNSC','L',JCNSC)
          CALL JEVEUO(CH2S//'.CNSV','L',JCNSV)
          CALL JEVEUO(CH2S//'.CNSL','L',JCNSL)

          NBCMPI = ZI(JCNSD-1 + 2)

C BOUCLE SUR LES POINTS DE MESURE

          DO 20 IMESU = 1,NBMESU

            NOMCHM = ZK16(LCHAM-1+IMESU)
C MEMES VECTEURS DE BASE POUR : DEPL, VITE ET ACCE
            IF (NOMCHM .EQ. 'VITE' .OR. NOMCHM .EQ. 'ACCE')
     &        NOMCHM = 'DEPL'
C MEMES VECTEURS DE BASE POUR LES CONTRAINTES
            IF (NOMCHM(1:4) .EQ. 'SIEF')
     &        NOMCHM = 'SIGM_NOEU_DEPL'
C MEMES VECTEURS DE BASE POUR LES DEFORMATIONS
            IF (NOMCHM(1:4) .EQ. 'EPSI')
     &        NOMCHM = 'EPSI_NOEU'

C NUMERO DU NOEUD ASSOCIE A IMESU : INO
            INO = ZI(LNOEUD-1 + IMESU)

            IF ((NOMCH(1:4) .EQ. 'DEPL') .AND.
     &        (NOMCHM(1:4) .EQ. 'DEPL')) THEN
C
C RECUPERATION DIRECTION DE MESURE (VECTEUR DIRECTEUR)
              DO 21 II = 1 , 3
                VORI(II) = ZR(LORI-1 + (IMESU-1)*3 +II)
 21           CONTINUE

C NORMALISATION DU VECTEUR DIRECTEUR
              VAL = 0.D0
              DO 22 II = 1,3
                VAL = VAL + VORI(II)*VORI(II)
 22           CONTINUE
              VAL = SQRT(VAL)
              IF (VAL.LT.R8PREM()) THEN
                CALL U2MESS('F','ALGORITH6_26')
              ENDIF
              DO 23 II = 1,3
                VORI(II) = VORI(II)/VAL
 23           CONTINUE
C
C RECUPERATION DU CHAMP AU NOEUD (BASE)
C 
              DO 101 ICMP = 1,NBCMPI
                IF (ZK8(JCNSC-1 +ICMP) .EQ. 'DX')
     &            VECT(1) = ZR(JCNSV-1 +(INO-1)*NBCMPI+ICMP)
                IF (ZK8(JCNSC-1 +ICMP) .EQ. 'DY')
     &            VECT(2) = ZR(JCNSV-1 +(INO-1)*NBCMPI+ICMP)
                IF (ZK8(JCNSC-1 +ICMP) .EQ. 'DZ')
     &            VECT(3) = ZR(JCNSV-1 +(INO-1)*NBCMPI+ICMP)
 101          CONTINUE

C CALCUL DE LA BASE RESTREINTE
C
              IPOSD = (IMODE-1)*NBMESU + IMESU
              ZR(LRED-1 + IPOSD) = 0.D0

              DO 300 II = 1 , 3
                ZR(LRED-1 + IPOSD) = ZR(LRED-1 + IPOSD)
     &                 + VECT(II) * VORI(II)
 300          CONTINUE
C
            ELSE IF ( (NOMCH(1:14) .EQ. 'EPSI_NOEU') .AND.
     &              (NOMCHM(1:14) .EQ. 'EPSI_NOEU') ) THEN
C
              IPOSD = (IMODE-1)*NBMESU + IMESU
              DO 401 ICMP = 1,NBCMPI
                IF (ZK8(JCNSC-1 +ICMP) .EQ. ZK8(LRANGE-1 +IMESU))
     &            ZR(LRED-1 +IPOSD) = ZR(JCNSV-1 +(INO-1)*NBCMPI+ICMP)
 401          CONTINUE
C
            ELSE IF ( (NOMCH(1:14) .EQ. 'SIGM_NOEU_DEPL') .AND.
     &              (NOMCHM(1:14) .EQ. 'SIGM_NOEU_DEPL') ) THEN

              IPOSD = (IMODE-1)*NBMESU + IMESU
              DO 501 ICMP = 1,NBCMPI
                IF (ZK8(JCNSC-1 +ICMP) .EQ. ZK8(LRANGE-1 +IMESU))
     &            ZR(LRED-1 +IPOSD) = ZR(JCNSV-1 +(INO-1)*NBCMPI+ICMP)
 501          CONTINUE
C
            ENDIF
C
C FIN DE LA BOUCLE SUR LES POINTS DE MESURE
C
 20       CONTINUE

C FIN DE LA BOUCLE SUR LES MODES
C
 10     CONTINUE

C FIN BOUCLE SUR LES NOMCHA

 151  CONTINUE

      CALL JEECRA (BASEPR,'LONUTI',NBMESU*NBMTOT,K8BID )
C
C DESTRUCTION DES VECTEURS DE TRAVAIL
C
      CALL DETRSD('CHAM_NO_S',CH1S)
      CALL DETRSD('CHAM_NO_S',CH2S)
      CALL DETRSD('CORRESP_2_MAILLA',CORRES)

      CALL JEDEMA ( )
C
      END
