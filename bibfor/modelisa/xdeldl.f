      SUBROUTINE XDELDL(MOD,MA,GRMAEN,JSTANO,LISREL,NREL)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE

      INTEGER JSTANO,NREL
      CHARACTER*8 MOD,MA
      CHARACTER*19 LISREL
      CHARACTER*24 GRMAEN

C     BUT: SUPPRIMER LES DDLS "EN TROP" (VOIR BOOK III 09/06/04
C                                         ET  BOOK IV  30/07/07)

C ARGUMENTS D'ENTR�E:

C      MAILLE  : NOM DE LA COMMANDE
C      CHAR    : NOM UTILISATEUR DU RESULTAT DE CHARGE

C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
C-----------------------------------------------------------------------
C---------------- DECLARATION DES VARIABLES LOCALES  -------------------

      REAL*8 RBID,BETAR,COEFR(2)
      INTEGER IER,NBNO,JMA,LONG,IMA,NMAABS,NBNOMA,JCONX1,JCONX2
      INTEGER INO,NUNO,ISTATU,K,IRET,NDIM(2),JPRNM,NBEC,NBCMP,INOM
      INTEGER ICMP,INDIK8,NNOS,NFE,ICMP2,ICMP3
      INTEGER NDIME,ADDIM
      CHARACTER*1 K1BID
      CHARACTER*8 K8BID,NOMNO,DDLM(3),DDLC(3),DDLH(3),DDLE(12),DDL(2)
      CHARACTER*8 NOEUD(2),NOMG
      CHARACTER*19 LIGRMO
      COMPLEX*16 CBID
      LOGICAL EXISDG
      DATA DDLM/'DX','DY','DZ'/
      DATA DDLC/'DCX','DCY','DCZ'/
      DATA DDLH/'H1X','H1Y','H1Z'/
      DATA DDLE/'E1X','E1Y','E1Z','E2X','E2Y','E2Z','E3X','E3Y','E3Z',
     &     'E4X','E4Y','E4Z'/
      DATA BETAR/0.D0/
      DATA NFE/4/
C-------------------------------------------------------------

      CALL JEMARQ()

      CALL JEEXIN(GRMAEN,IER)
      IF (IER.EQ.0) GO TO 100

      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNO,K8BID,IRET)
      CALL JEVEUO(MA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)

      CALL JEVEUO(GRMAEN,'L',JMA)
      CALL JELIRA(GRMAEN,'LONMAX',LONG,K8BID)

C     R�CUP�RATION DES DONN�ES SERVANT � V�RIFIER L'EXISTENCE D'UN DDL
C     POUR UN NOEUD (COMME DANS AFLRCH.F)
      LIGRMO = MOD//'.MODELE'
      NOMG = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IER)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)
      CALL JEVEUO(LIGRMO//'.PRNM','L',JPRNM)
      ICMP = INDIK8(ZK8(INOM),'DX',1,NBCMP)

C     RECUPERATION DE LA DIMENSION
      CALL JEVEUO(MA//'.DIME','L',ADDIM)
      NDIME=ZI(ADDIM-1+6)

C     BOUCLE SUR LES MAILLES
      DO 90 IMA = 1,LONG

C       NUMERO ABS DE LA MAILLE TRAIT�E
        NMAABS = ZI(JMA-1+IMA)
        NBNOMA = ZI(JCONX2+NMAABS) - ZI(JCONX2+NMAABS-1)

C       ATTENTION : COMME MAINTENANT, ON A DES MAILLES � 10,15,20 NOEUDS
C       IL FAUT BOUCLER SEULEMENT SUR LES NOEUDS SOMMETS : NNOS
        IF (NDIME.EQ.2) THEN
          NNOS = NBNOMA/2
          ELSE
          NNOS = 2*NBNOMA/5
        ENDIF

        DO 80 INO = 1,NNOS

          NUNO = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INO-1)
          CALL JENUNO(JEXNUM(MA//'.NOMNOE',NUNO),NOMNO)
          ISTATU = ZI(JSTANO-1+NUNO)

          IF (GRMAEN(21:24).EQ.'HEAV') THEN

C           1) CAS DES MAILLES 'ROND'
C           -------------------------

            IF (ISTATU.GT.1) THEN
              CALL U2MESS('F','MODELISA7_94')
            ELSE IF (ISTATU.EQ.1) THEN
C             ON NE SUPPRIME AUCUN DDL
            ELSE IF (ISTATU.EQ.0) THEN
C             ON SUPPRIME LES DDLS H
              DO 10 K = 1,NDIME
                CALL AFRELA(1.D0,CBID,DDLH(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
   10         CONTINUE
            END IF

          ELSE IF (GRMAEN(21:24).EQ.'CTIP') THEN

C           2) CAS DES MAILLES 'CARR�'
C           --------------------------

            IF (ISTATU.GT.2 .OR. ISTATU.EQ.1) THEN
              CALL U2MESS('F','MODELISA7_94')
            ELSE IF (ISTATU.EQ.2) THEN
C             ON NE SUPPRIME AUCUN DDL
            ELSE IF (ISTATU.EQ.0) THEN
C             ON SUPPRIME LES DDLS E
              DO 20 K = 1,3*NFE
               IF (NDIME.EQ.3 .OR. K-3*INT(K/3) .NE. 0) THEN
                CALL AFRELA(1.D0,CBID,DDLE(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
               ENDIF
   20         CONTINUE
            END IF

          ELSE IF (GRMAEN(21:24).EQ.'HECT') THEN

C           3) CAS DES MAILLES 'ROND-CARR�'
C           ------------------------------

            IF (ISTATU.GT.3) THEN
              CALL U2MESS('F','MODELISA7_94')
            ELSE IF (ISTATU.EQ.3) THEN
C             ON NE SUPPRIME AUCUN DDL
            ELSE IF (ISTATU.EQ.2) THEN
C             ON SUPPRIME LES DDLS H
              DO 30 K = 1,NDIME
                CALL AFRELA(1.D0,CBID,DDLH(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
   30         CONTINUE
            ELSE IF (ISTATU.EQ.1) THEN
C             ON SUPPRIME LES DDLS E
              DO 40 K = 1,3*NFE
               IF (NDIME.EQ.3 .OR. K-3*INT(K/3) .NE. 0) THEN
                CALL AFRELA(1.D0,CBID,DDLE(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
               ENDIF
   40         CONTINUE
            ELSE IF (ISTATU.EQ.0) THEN
C             ON SUPPRIME LES DDLS H ET E
              DO 50 K = 1,NDIME
                CALL AFRELA(1.D0,CBID,DDLH(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
   50         CONTINUE
              DO 60 K = 1,3*NFE
               IF (NDIME.EQ.3 .OR. K-3*INT(K/3) .NE. 0) THEN
                CALL AFRELA(1.D0,CBID,DDLE(K),NOMNO,0,RBID,1,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
               ENDIF
   60         CONTINUE
            END IF

          ELSE
            CALL U2MESS('F','MODELISA7_95')
          END IF

C         POUR LES NOEUDS O� LE STATUT VAUT 0, IL FAUT IMPOSER
C         DX = DCX , DY = DCY ET DZ = DCZ SOUS R�SERVE QUE CES NOEUDS
C         PORTENT BIEN LES DDLS DX, DY ET DZ (ON NE V�RIFIE QUE 'DX')
          IF (ISTATU.EQ.0) THEN
            IF (EXISDG(ZI(JPRNM-1+ (NUNO-1)*NBEC+1),ICMP)) THEN
              DO 70 K = 1,NDIME
                DDL(1) = DDLM(K)
                DDL(2) = DDLC(K)
                COEFR(1) = 1
                COEFR(2) = -1
                NOEUD(1) = NOMNO
                NOEUD(2) = NOMNO
                NDIM(1) = 0
                NDIM(2) = 0
                CALL AFRELA(COEFR,CBID,DDL,NOEUD,NDIM,RBID,2,BETAR,CBID,
     &                      K8BID,'REEL','REEL','12',0.D0,LISREL)
                NREL = NREL + 1
   70         CONTINUE
            END IF
          END IF

   80   CONTINUE

   90 CONTINUE

  100 CONTINUE
      CALL JEDEMA()
      END
