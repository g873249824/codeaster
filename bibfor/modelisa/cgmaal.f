      SUBROUTINE CGMAAL ( MOFAZ, IOCC, NOMAZ, LISMAZ, NBMA )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXATR
      INTEGER             IOCC, NBMA
      CHARACTER*(*)       MOFAZ, NOMAZ, LISMAZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C       CGMAAL -- TRAITEMENT DE L'OPTION APPUI_LACHE
C                 DU MOT FACTEUR CREA_GROUP_MA DE
C                 LA COMMANDE DEFI_GROUP
C
C -------------------------------------------------------
C  MOFAZ         - IN    - K16  - : MOT FACTEUR 'CREA_GROUP_MA'
C  IOCC          - IN    - I    - : NUMERO D'OCCURENCE DU MOT-FACTEUR
C  NOMAZ         - IN    - K8   - : NOM DU MAILLAGE
C  LISMAZ        - JXVAR - K24  - : NOM DE LA LISTE DE MAILLES QUI
C                                   CONTIENNENT NOEUD UTILISATEUR
C  NBMA          - OUT   -  I   - : LONGUEUR DE CETTE LISTE
C -------------------------------------------------------
C
      INTEGER        IBID, NBMC, NBNO, NCI, ADRVLC, ACNCIN, IER,
     &               I, J, NBMAT, ITYP, NUNO, JADR, NUMA, IDLIST,
     &               JNOEU, IDLIMA
      CHARACTER*8    NOMA, K8BID, MOTCLE(2), TYMOCL(2)
      CHARACTER*16   MOTFAC
      CHARACTER*24   MESNOE, LISMAI, LISTRV, NCNCIN
C     -----------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS :
C     ---------------
      MOTFAC    = MOFAZ
      NOMA      = NOMAZ
      LISMAI    = LISMAZ
      LISTRV    = '&&CGMAAL.MAILLES_TRAV'
      MESNOE    = '&&CGMAAL.NOEUDS'
C
C --- RECUPERATION DES NOEUDS :
C     -----------------------
      NBMC = 2
      MOTCLE(1) = 'NOEUD'
      TYMOCL(1) = 'NOEUD'
      MOTCLE(2) = 'GROUP_NO'
      TYMOCL(2) = 'GROUP_NO'
      CALL RELIEM ( ' ', NOMA, 'NU_NOEUD', MOTFAC, IOCC, NBMC, MOTCLE,
     &                                          TYMOCL, MESNOE, NBNO )
      CALL JEVEUO ( MESNOE, 'L', JNOEU )
C
      NCNCIN = '&&OP0104.CONNECINVERSE  '
      CALL JEEXIN ( NCNCIN, NCI )
      IF (NCI .EQ. 0) CALL CNCINV (NOMA, IBID, 0, 'V', NCNCIN )
C
      CALL JEVEUO ( JEXATR(NCNCIN,'LONCUM'), 'L', ADRVLC )
      CALL JEVEUO ( JEXNUM(NCNCIN,1)       , 'L', ACNCIN )
C
C
C --- RECUPERATION DU NOMBRE DE MAILLES DU MAILLAGE :
C     ---------------------------------------------
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMAT,K8BID,IER)
C
C --- RECUPERATION DU TYPE DES MAILLES DU MAILLAGE :
C     --------------------------------------------
      CALL JEVEUO ( NOMA//'.TYPMAIL', 'L', ITYP )
C
C --- ALLOCATION D'UN VECTEUR DE TRAVAIL :
C     ----------------------------------
      CALL WKVECT ( LISTRV, 'V V I', NBMAT, IDLIMA )
C
C --- TRAITEMENT DES NOEUDS "UTILISATEUR" :
C     -----------------------------------
      DO 10 I = 1 , NBNO
         NUNO = ZI(JNOEU+I-1)
         NBMA = ZI(ADRVLC+NUNO+1-1) - ZI(ADRVLC+NUNO-1)
         JADR = ZI(ADRVLC+NUNO-1)
         DO 20 J = 1 , NBMA
            NUMA = ZI(ACNCIN+JADR-1+J-1)
            ZI(IDLIMA+NUMA-1) = 1
 20      CONTINUE
 10   CONTINUE
C
      NBMA = 0
      DO 30 I = 1 , NBMAT
         IF ( ZI(IDLIMA+I-1) .EQ. 1 )  NBMA = NBMA + 1
 30   CONTINUE
      IF ( NBMA .EQ. 0 ) THEN
         CALL U2MESS('F','MODELISA3_66')
      ENDIF
C
C --- ALLOCATION DU VECTEUR DES NOMS DES MAILLES CONTENANT
C     LES NOEUDS LISTES :
C     -----------------
      CALL WKVECT ( LISMAI, 'V V I', NBMA, IDLIST )
      NBMA = 0
      DO 40 I = 1 , NBMAT
         IF ( ZI(IDLIMA+I-1) .EQ. 1 )  THEN
            NBMA = NBMA + 1
            ZI(IDLIST+NBMA-1) = I
         ENDIF
 40   CONTINUE
C
      CALL JEDETR ( LISTRV )
      CALL JEDETR ( MESNOE )
C
      CALL JEDEMA()
C
      END
