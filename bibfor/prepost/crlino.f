      SUBROUTINE CRLINO(MOTFAZ, MATREZ, IOCC, LISNOZ, LONLIS)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     MOTFAZ, MATREZ, LISNOZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 04/05/99   AUTEUR CIBHHPD P.DAVID 
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
C
C     CREATION DU VECTEUR DE K8 DE NOM LISNOZ ET DE LONGUEUR
C     LONLIS.
C     CE VECTEUR CONTIENT LA LISTE DES NOMS DES NOEUDS DEFINIS
C     PAR LES MOTS-CLES : GROUP_MA, GROUP_NO, MAILLE OU NOEUD
C     CETTE LISTE NE CONTIENT QU'UNE OCCURENCE DES NOEUDS.
C
C IN       : MOTFAZ : MOT-CLE FACTEUR 'MATR_ASSE'
C IN       : MATREZ : NOM D'UN MATR_ELEM OU D'UN VECT_ELEM
C IN       : IOCC   : NUMERO D'OCCURENCE DU MOT-FACTEUR
C OUT      : LISNOZ : NOM DE LA LISTE DES NOEUDS
C OUT      : LONLIS : LONGUEUR DE LA LISTE DES NOEUDS
C ----------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32      JEXNOM, JEXNUM
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
C
      CHARACTER*1   K1BID
      CHARACTER*8   MATRAS
      CHARACTER*8   K8BID, NOMA, NOMNOE, NOMAIL
      CHARACTER*8   MONOEU, MOGRNO, MOMAIL, MOGRMA, MOTOUI
      CHARACTER*16  MOTFAC
      CHARACTER*24  NOEUMA, GRNOMA, MAILMA, GRMAMA, LISNOE
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      MATRAS = MATREZ
      MOTFAC = MOTFAZ
      LISNOE = LISNOZ
C
      MONOEU = 'NOEUD'
      MOGRNO = 'GROUP_NO'
      MOMAIL = 'MAILLE'
      MOGRMA = 'GROUP_MA'
C
      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GOTO 9999
C
      CALL GETVTX (MOTFAC,'TOUT' ,IOCC,1,0,MOTOUI,NOUI)
      IF (NOUI.NE.0) GOTO 9999
C
C --- RECUPERATION DU MAILLAGE ASSOCIE A LA MATR_ASSE :
C     -----------------------------------------------
      CALL DISMOI('F','NOM_MAILLA',MATRAS,'MATR_ASSE',IBID,NOMA,IER)
C
      NOEUMA = NOMA//'.NOMNOE'
      GRNOMA = NOMA//'.GROUPENO'
      MAILMA = NOMA//'.NOMMAI'
      GRMAMA = NOMA//'.GROUPEMA'
C
      IDIMAX = 0
      IDIM1  = 0
      IDIM2  = 0
      IDIM3  = 0
      IDIM4  = 0
C
C     -- CALCUL DE IDIM1 = NB_NOEUD/GROUP_NO*NB_GROUP_NO
C        ET VERIFICATION DE L'APPARTENANCE DES GROUP_NO
C        AUX GROUP_NO DU MAILLAGE
C        -------------------------------------------------------
      CALL GETVID (MOTFAC,MOGRNO,IOCC,1,0,K8BID,NG)
      IF (NG.NE.0) THEN
          NG = -NG
          CALL WKVECT ('&&CRLINO.TRAV1','V V K8',NG,JJJ)
          CALL GETVEM (NOMA,'GROUP_NO',
     .                 MOTFAC,MOGRNO,IOCC,1,NG,ZK8(JJJ),NGR)
          DO 10 IGR = 1, NGR
               CALL JELIRA (JEXNOM(GRNOMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      N1,K1BID)
               IDIM1 = IDIM1 + N1
 10       CONTINUE
      ENDIF
C
C     -- CALCUL DE IDIM2 = NB_NOEUD DE LA LISTE DE NOEUDS
C        ET VERIFICATION DE L'APPARTENANCE DES NOEUDS
C        AUX NOEUDS DU MAILLAGE
C        -------------------------------------------------------
      CALL GETVID (MOTFAC,MONOEU,IOCC,1,0,K8BID,NBNO)
      IF (NBNO.NE.0) THEN
          NBNO = -NBNO
          CALL WKVECT ('&&CRLINO.TRAV2','V V K8',NBNO,JJJ)
          CALL GETVEM (NOMA,'NOEUD',
     .                 MOTFAC,MONOEU,IOCC,1,NBNO,ZK8(JJJ),NNO)
          IDIM2 = IDIM2 + NNO
      ENDIF
C
C     -- CALCUL DE IDIM3=NB_NOEUD/MAILLE*NB_MAILLE/GROUP_MA*NB_GROUP_MA
C        ET VERIFICATION DE L'APPARTENANCE DES GROUP_MA
C        AUX GROUP_MA DU MAILLAGE
C        -------------------------------------------------------
      CALL GETVID (MOTFAC,MOGRMA,IOCC,1,0,K8BID,NG)
      IF (NG.NE.0) THEN
          NG = -NG
          CALL WKVECT ('&&CRLINO.TRAV3','V V K8',NG,JJJ)
          CALL GETVEM (NOMA,'GROUP_MA',
     .                 MOTFAC,MOGRMA,IOCC,1,NG,ZK8(JJJ),NGR)
          DO 20 IGR = 1, NGR
                CALL JEVEUO (JEXNOM(GRMAMA,ZK8(JJJ+IGR-1)),'L',JGRO)
                CALL JELIRA (JEXNOM(GRMAMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      NBMAIL,K1BID)
                DO 30 M = 1, NBMAIL
                  NUMAIL = ZI(JGRO-1+M)
                  CALL JENUNO(JEXNUM(MAILMA,NUMAIL),NOMAIL)
                  CALL JENONU(JEXNOM(NOMA//'.NOMMAI',NOMAIL),IBID)
                  CALL JELIRA (JEXNUM(NOMA//'.CONNEX',IBID),'LONMAX',
     +                         N3,K1BID)
                  IDIM3 = IDIM3 + N3
 30            CONTINUE
 20         CONTINUE
      ENDIF
C
C     -- CALCUL DE IDIM4=NB_NOEUD/MAILLE*NB_MAILLE DE LISTE DE MAILLES
C        ET VERIFICATION DE L'APPARTENANCE DES MAILLES
C        AUX MAILLES DU MAILLAGE
C        -------------------------------------------------------
      CALL GETVID (MOTFAC,MOMAIL,IOCC,1,0,K8BID,NBMA)
      IF (NBMA.NE.0) THEN
          NBMA = -NBMA
          CALL WKVECT ('&&CRLINO.TRAV4','V V K8',NBMA,JJJ)
          CALL GETVEM (NOMA,'MAILLE',
     .                 MOTFAC,MOMAIL,IOCC,1,NBMA,ZK8(JJJ),NMAI)
          DO 40 IMA = 1, NMAI
                CALL JENONU(JEXNOM(NOMA//'.NOMMAI',ZK8(JJJ+IMA-1)),IBID)
                CALL JELIRA (JEXNUM(NOMA//'.CONNEX',IBID),
     +                       'LONMAX',  N4,K1BID)
                IDIM4 = IDIM4 + N4
 40      CONTINUE
      ENDIF
C
C     -- IDIMAX = MAJORANT DE LA LONGUEUR DE LA LISTE DE NOEUDS
C    ----------------------------------------------------------
      IDIMAX = IDIM1 + IDIM2 + IDIM3 + IDIM4
C
      IF (IDIMAX .EQ.0) GOTO 9999
C
C     -- ALLOCATION DES TABLEAUX DES NOMS DE NOEUDS
C    ----------------------------------------------
      CALL WKVECT (LISNOE,'V V K8',IDIMAX,JLIST)
C
      INDNOE = 0
      CALL GETVID (MOTFAC,MOGRNO,IOCC,1,0,K8BID,NG)
      IF (NG.NE.0) THEN
          NG = -NG
          CALL GETVID (MOTFAC,MOGRNO,IOCC,1,NG,ZK8(JJJ),NGR)
          DO 50 IGR = 1, NGR
               CALL JEVEUO (JEXNOM(GRNOMA,ZK8(JJJ+IGR-1)),'L',JGRO)
               CALL JELIRA (JEXNOM(GRNOMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      N1,K1BID)
               DO 60 INO = 1, N1
                  IN = ZI(JGRO+INO-1)
                  INDNOE = INDNOE + 1
                  CALL JENUNO(JEXNUM(NOEUMA,IN),NOMNOE)
                  ZK8(JLIST+INDNOE-1) = NOMNOE
 60           CONTINUE
 50       CONTINUE
      ENDIF
C
      CALL GETVID (MOTFAC,MONOEU,IOCC,1,0,K8BID,NBNO)
      IF (NBNO.NE.0) THEN
          NBNO = -NBNO
          CALL GETVID (MOTFAC,MONOEU,IOCC,1,NBNO,ZK8(JJJ),NNO)
          DO 70 INO = 1, NNO
                  INDNOE = INDNOE + 1
                  ZK8(JLIST+INDNOE-1) = ZK8(JJJ+INO-1)
 70      CONTINUE
      ENDIF
C
      CALL GETVID (MOTFAC,MOGRMA,IOCC,1,0,K8BID,NG)
      IF (NG.NE.0) THEN
          NG = -NG
          CALL GETVID (MOTFAC,MOGRMA,IOCC,1,NG,ZK8(JJJ),NGR)
          DO 80 IGR = 1, NGR
               CALL JEVEUO (JEXNOM(GRMAMA,ZK8(JJJ+IGR-1)),'L',JGRO)
               CALL JELIRA (JEXNOM(GRMAMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      NBMAIL,K1BID)
               DO 90 M = 1, NBMAIL
                  NUMAIL = ZI(JGRO-1+M)
                  CALL JENUNO(JEXNUM(MAILMA,NUMAIL),NOMAIL)
                  CALL JENONU(JEXNOM(NOMA//'.NOMMAI',NOMAIL),IBID)
                  CALL JEVEUO (JEXNUM(NOMA//'.CONNEX',IBID),'L',JDES)
                  CALL JELIRA (JEXNUM(NOMA//'.CONNEX',IBID),'LONMAX',
     +                         N3,K1BID)
                  DO 100 INO = 1, N3
                    CALL JENUNO(JEXNUM(NOEUMA,ZI(JDES+INO-1)),NOMNOE)
                    INDNOE = INDNOE + 1
                    ZK8(JLIST+INDNOE-1) = NOMNOE
 100             CONTINUE
 90           CONTINUE
 80       CONTINUE
      ENDIF
C
      CALL GETVID (MOTFAC,MOMAIL,IOCC,1,0,K8BID,NBMA)
      IF (NBMA.NE.0) THEN
          NBMA = -NBMA
          CALL GETVID (MOTFAC,MOMAIL,IOCC,1,NBMA,ZK8(JJJ),NMAI)
          DO 110 IMA = 1, NMAI
                CALL JENONU(JEXNOM(NOMA//'.NOMMAI',ZK8(JJJ+IMA-1)),IBID)
                CALL JEVEUO (JEXNUM(NOMA//'.CONNEX',IBID),
     +                       'L',JDES)
                CALL JENONU(JEXNOM(NOMA//'.NOMMAI',ZK8(JJJ+IMA-1)),IBID)
                CALL JELIRA (JEXNUM(NOMA//'.CONNEX',IBID),
     +                       'LONMAX',  N4,K1BID)
                DO 120 INO = 1, N4
                    CALL JENUNO(JEXNUM(NOEUMA,ZI(JDES+INO-1)),NOMNOE)
                    INDNOE = INDNOE + 1
                    ZK8(JLIST+INDNOE-1) = NOMNOE
 120            CONTINUE
 110      CONTINUE
      ENDIF
C
C     -- ELIMINATION DES REDONDANCES EVENTUELLES DES NOEUDS
C        DE LA LISTE
C    -------------------------------------------------------------
      CALL WKVECT ('&&CRLINO.INDICE','V V I',IDIMAX,JIND)
C
      DO 130 INO = 1, IDIMAX
          DO 140 IN1 = INO+1, IDIMAX
                IF (ZK8(JLIST+IN1-1).EQ.ZK8(JLIST+INO-1)) THEN
                      ZI(JIND+IN1-1) = 1
                ENDIF
 140      CONTINUE
 130   CONTINUE
C
      INDLIS = 0
      DO 150 INO = 1, IDIMAX
         IF (ZI(JIND+INO-1).EQ.0) THEN
              INDLIS = INDLIS + 1
              ZK8(JLIST+INDLIS-1) = ZK8(JLIST+INO-1)
         ENDIF
 150  CONTINUE
C
      LONLIS = INDLIS
C
      CALL JEDETR ('&&CRLINO.TRAV1')
      CALL JEDETR ('&&CRLINO.TRAV2')
      CALL JEDETR ('&&CRLINO.TRAV3')
      CALL JEDETR ('&&CRLINO.TRAV4')
      CALL JEDETR ('&&CRLINO.INDICE')
C
 9999 CONTINUE
      CALL JEDEMA()
      END
