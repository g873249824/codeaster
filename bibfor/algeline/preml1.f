      SUBROUTINE PREML1(NEQ,N2,DIAG,DELG,COL,XADJ,
     &     ADJNCY,PARENT,ADRESS,
     &     SUPND,NNZ,QSIZE,LLIST,SUIV,P,Q,
     &     INVP,PERM,LGIND,DDLMOY,NBSN,OPTNUM,LGADJN,
     &     NRL,DEB,VOIS,SUIT,IER,NEC,PRNO,DEEQ,
     &     NOEUD,DDL,INVPND,PERMND,SPNDND,XADJD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 06/04/2007   AUTEUR PELLET J.PELLET 
C RESPONSABLE JFBHHUC C.ROSE
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
C     TOLE CRP_21
      IMPLICIT NONE

      INTEGER NEQ,DIAG(0:NEQ),LGIND,LGADJN
      INTEGER COL(*),XADJ(NEQ+1),ADJNCY(LGADJN)
      INTEGER DELG(NEQ),NBSN,ADRESS(NEQ),PARENT(NEQ)
      INTEGER SUPND(NEQ),OPTNUM,ISMAEM
      INTEGER INVP(NEQ),PERM(NEQ)
      INTEGER DEB(*),VOIS(*),SUIT(*),IER
      INTEGER NOEUD(*),DDL(*), PERMND(*), INVPND(*),SPNDND(*),XADJD(*)
C     VARIABLES LOCALES
      INTEGER I,J,FIN,IDELTA,MAXINT,NADJ,IFET3,IFET4,ILIMPI
      INTEGER N2,FCTNZS,INNZ,NUMI,NUMJ,NUML,NUM,II,IRET,IFET1,IFET2
      REAL*8 NBOPS
      INTEGER NNZ(1:NEQ),QSIZE(NEQ),LLIST(NEQ),SUIV(NEQ)
      INTEGER LIBRE,IOVFLO,NCMPA,IFM,NIV,P(NEQ),Q(N2),NRL
      INTEGER IT,NBPAR,IERRC,DEBUT,LRM
      CHARACTER*80 TXT80(4)
      CHARACTER*128 REP,LOGIEL
      INTEGER NEC,PRNO(*),DEEQ(*),INO,NBCMP,ULNUME,IULM1,IULM2
      LOGICAL LFETI
C--------------------------------------------------------------
C
C     VERSION RENUMEROTATION PAR NOEUD
      INTEGER NBND,ND,NBND1, DDLMOY
C     PARAMETER(MAXND=300, MAXDDL=300)
C     INTEGER NOEUD(1:MAXDDL), DDL(1:MAXND), INVPND(1:MAXND)
C     INTEGER PERMND(1:MAXND), SPNDND(1:MAXND)
      INTEGER NDI, NDJ, PAS, K,  NDANC, IDDL, SNI, IND, NDDL
      INTEGER AD,ADD,ITEM,ITEMM,NDD,NBSD,IAUX,NIV2

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      INTEGER VALI(2)
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C****************************************************************
C     CALL UTTCPU(2,'DEBUT',6,TEMPS)
C****************************************************************
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV(IFM,NIV)
C FETI OR NOT FETI ?
      CALL JEEXIN('&FETI.MAILLE.NUMSD',IRET)
      IF (IRET.NE.0) THEN
        CALL INFMUE()
        CALL INFNIV(IFM,NIV)
        LFETI=.TRUE.
      ELSE
        LFETI=.FALSE.
      ENDIF
C--------------------------------------------------------------
C     LA RENUMEROTATION VA ETRE FAITE AVEC LA CONNECTIVITE NODALE
C     ET NON PLUS LA CONNECTIVITE PAR DDL COMME AVANT
C
C     1) ON CALCULE   NOEUD ET DDL A PARTIR DE PRNO ET DEEQ
C     NOEUD(1:NEQ) SURJECTION VERS (1:NBND) OU NBND EST LE NOMBRE
C     DE NOEUDS AU SENS DE LA DISCRETISATION
C     LA FONCTION INVERSE EST DDL(1:NBND)
      DO 1 I=1,NEQ
         NOEUD(I) = 0
 1    CONTINUE
      NBND=0
      I = 1
      DDL(I)= 1
 101  CONTINUE
C      DO WHILE(I.LE.NEQ)
       IF(I.LE.NEQ) THEN
         IF(DEEQ(2*I).GT.0) THEN
            INO = DEEQ(2*I-1)
            NBND = NBND +1
            NBCMP =  PRNO( (INO-1)*(2+NEC) + 2)
            DO 2 J=I, I+NBCMP-1
               NOEUD(J)= NBND
 2          CONTINUE
            DDL(NBND+1) = DDL(NBND) + NBCMP
            PAS = NBCMP
         ELSE
            PAS = 1
         ENDIF
         I = I+PAS
         GOTO 101
      ENDIF
      DDLMOY = ( DDL(NBND+1) - 1 )/NBND
C--------------------------------------------------------------------
C     2) CALCUL DE (ADJNCY, XADJ) EN DDL DANS LA NUMEROTATION DE 1 � N2
C     COMME DANS LA VERSION INITIALE
C     INITIALISATION DE NNZ : NBRE DE TERMES A AJOUTER
C     POUR CHAQUE LIGNE
      NUM = 0
      DO 320 I = 1,NEQ
         IF (DELG(I).EQ.0) THEN
            NUM = NUM +1
C     ON COMPTE LES NON-ZEROS
            INNZ=0
            DO 315 J = DIAG(I-1)+1, DIAG(I)-1
               IF( DELG(COL(J)).EQ.0)THEN
C     PARTIE TRIANGULAIRE INFERIEURE
                  INNZ = INNZ + 1
C     PARTIE TRIANGULAIRE SUPERIEURE
                  NNZ(P(COL(J) )) = NNZ(P(COL(J))) + 1
               ENDIF
 315        CONTINUE
            NNZ(NUM) = INNZ
         ENDIF
 320  CONTINUE
      IF(NRL.NE.0) THEN
         DO 220 J=1,NEQ
            IT = DEB(J)
 219        CONTINUE
            IF(IT.GT.0) THEN
               NNZ(P(J)) = NNZ(P(J)) + 1
               IT = SUIT(IT)
               GOTO 219
            ENDIF
 220     CONTINUE
C     VERIFICATION

         DO  325  J = 1, NEQ
C     TERMES A AJOUTER PARTIE SUPERIEURE
            IT = DEB(J)
 324        CONTINUE
            IF(IT.GT.0) THEN
               NNZ(P(VOIS(IT))) = NNZ(P(VOIS(IT))) + 1
               IT = SUIT(IT)
               GOTO 324
            ENDIF
 325     CONTINUE
      ENDIF
C
      XADJ(1) = 1
      DO  330  J = 1, N2
         XADJ(J+1) = XADJ(J) + NNZ(J)
         NNZ(J) = 0
 330  CONTINUE
      IF( (XADJ(NEQ+1)-1).GT.LGADJN) THEN
C     TEST D'ESPACE SUFFISANT DANS ADJNCY
         VALI (1) = LGADJN
         VALI (2) = XADJ(NEQ+1)-1
         CALL U2MESG('F', 'ALGELINE4_4',0,' ',2,VALI,0,0.D0)
      ENDIF
C
      DO  350  J = 1, NEQ
         IF(DELG(J).EQ.0) THEN
            NUMJ=P(J)
            DO  340  II = DIAG(J-1)+1, DIAG(J)-1
               I = COL(II)
               IF(DELG(I).EQ.0) THEN
                  NUMI=P(I)
                  ADJNCY(XADJ(NUMJ)+NNZ(NUMJ)) = NUMI
                  NNZ(NUMJ) = NNZ(NUMJ) + 1
                  ADJNCY(XADJ (NUMI)+NNZ(NUMI)) = NUMJ
                  NNZ(NUMI) = NNZ(NUMI) + 1
               ENDIF
 340        CONTINUE
            IF(NRL.NE.0) THEN
               IT = DEB(J)
 344           CONTINUE
               IF(IT.GT.0) THEN
                  NUML =  P(VOIS(IT))
                  ADJNCY(XADJ(NUMJ)+NNZ(NUMJ)) = NUML
                  NNZ(NUMJ) = NNZ(NUMJ) + 1
                  ADJNCY(XADJ(NUML)+NNZ(NUML)) = NUMJ
                  NNZ(NUML) = NNZ(NUML) + 1
                  IT = SUIT(IT)
                  GOTO 344
               ENDIF
            ENDIF
         ENDIF
 350  CONTINUE
      NBND1 = NBND + 1
      LIBRE = XADJ(NBND1)
      NADJ = LIBRE - 1
C-----------------------------------------------------------
C     3) MODIFICATION DE (ADJNCY, XADJ) VOISINAGE PAR DDL EN
C     (ADJNCY,XADJD) VOISINAGE PAR  NOEUD POUR LA RENUMEROTATION
      CALL PRMADJ(NBND,NEQ,N2,ADJNCY,XADJ, XADJD,LLIST,Q,NOEUD)
C-----------------------------------------------------------
      NBND1 = NBND + 1
      LIBRE = XADJD(NBND1)
      NADJ = LIBRE - 1
      IF(OPTNUM.EQ.0) THEN
C----------------------------------MINIMUM DEGRE : GENMMD
         IDELTA = 0
         MAXINT = 2*NBND

         CALL GENMMD(NBND,NBND1,NADJ,XADJD,ADJNCY,MAXINT,IDELTA,INVPND,
     &        PERMND,NBSN,SPNDND,ADRESS,PARENT,LGIND,FCTNZS,NBOPS,NNZ,
     &        QSIZE,LLIST,SUIV)
      ELSE IF(OPTNUM.EQ.1) THEN
C----------------------------------MINIMUM DEGRE : APPROXIMATE MIN DEG
         IOVFLO = ISMAEM()
         DO 250 I=1,N2
            QSIZE(I)=XADJD(I+1)-XADJD(I)
 250     CONTINUE
         CALL AMDBAR(NBND,XADJD,ADJNCY,QSIZE,LGADJN,LIBRE,SUIV,LLIST,
     &        PERMND,NNZ,INVPND,PARENT,NCMPA,ADRESS,IOVFLO)
         CALL AMDAPT(NEQ,NBND,NBSN,XADJD,SUIV,INVPND,
     &        PARENT,SPNDND,ADRESS,LGIND,FCTNZS,NBOPS,
     &        LLIST,QSIZE)
      ELSE IF(OPTNUM.EQ.2) THEN
C----------------------------------METIS 4 : METHODE DE BISSECTION
         IULM1 = ULNUME ()
         IF ( IULM1 .EQ. -1 ) THEN
           CALL U2MESS('F','UTILITAI_81')
         ENDIF
         CALL ULOPEN ( IULM1,' ',' ','NEW','O')
         IULM2 = ULNUME ()
         IF ( IULM2 .EQ. -1 ) THEN
           CALL U2MESS('F','UTILITAI_81')
         ENDIF
         WRITE(IULM1,1001) NBND,INT(NADJ)/2,NIV,IFM
         WRITE(IULM1,1001) (XADJD(I),I=1,NBND+1)
         DO 510 I=1,NBND
            DEBUT=XADJD(I)
            FIN= XADJD(I+1)-1
            WRITE (IULM1,1000) (ADJNCY(J),J=DEBUT,FIN)
 1000       FORMAT(10I8)
 1001       FORMAT(8I10)
 510     CONTINUE
C     FERMETURE DU FICHIER
         CALL ULOPEN (-IULM1,' ',' ',' ',' ')
         NBPAR=4
         CALL REPOUT(1,LRM,REP)
         LOGIEL = REP(1:LRM)//'onmetis'
         TXT80(1)=LOGIEL
         TXT80(2)='fort.'
         CALL CODENT(IULM1,'G',TXT80(2)(6:80))

         TXT80(4)='fort.'
         CALL CODENT(IULM2,'G',TXT80(4)(6:80))
         IF (NIV.LE.1) THEN
           NIV2 = 0
         ELSE
           NIV2 = NIV
         ENDIF
         CALL CODENT( NIV2 , 'G' , TXT80(3)  )
         CALL APLEXT(NIV2,NBPAR,TXT80,IERRC)
         IF (IERRC .NE. 0) THEN
C     TRAITEMENT D'ERREUR
            IER = 1
            CALL U2MESS('F','ALGELINE3_25')
            GOTO 999
         ENDIF
         CALL ULOPEN ( IULM2,' ',' ','OLD','O')
         CALL PREMLE(IULM2,INVPND,PERMND,NBSN,SPNDND,PARENT,NBND,NBOPS,
     &        FCTNZS,LGIND)
C     FERMETURE DU FICHIER
         CALL ULOPEN (-IULM2,' ',' ',' ',' ')
C     CLOSE(UNIT=85)
      ENDIF
C****************************************************************
C     CALL UTTCPU(2,'FIN  ',6,TEMPS)
C****************************************************************
C.....................................................................
      LGIND = LGIND * DDLMOY
C     4) TRAITEMENT POUR LE PASSAGE DE LA RENUMEROTATION PAR NOEUD
C     A CELLE PAR DDL
C     PERM, INVP, SUPND SONT RECONSTITUES
      IND=0
      DO 405 ND = 1 , NBND
         NDANC = PERMND(ND)
         NDDL = DDL(NDANC+1) -DDL(NDANC)
         DO 400 K=1,NDDL
            IND = IND +1
            PERM(IND) = DDL(NDANC) +K - 1
 400     CONTINUE
 405  CONTINUE
         IF(NIV.EQ.2.AND.IND.NE.N2) THEN
         VALI (1) = N2
         VALI (2) = IND
         CALL U2MESG('F', 'ALGELINE4_60',0,' ',2,VALI,0,0.D0)
         ENDIF
      DO 406 IDDL = 1, N2
         INVP(PERM(IDDL)) = IDDL
 406  CONTINUE
C     SUPND
      SUPND(NBSN+1)=N2+1
      DO 407 SNI = 1, NBSN
C        ND 1ER NOEUD DU SNI
         ND  = SPNDND(SNI)
C        ND : ANCIEN NUMERO DE ND
         ND = PERMND(ND)
C        IDDL : 1ER DDL DE CE NOEUD
         IDDL = DDL(ND)
         SUPND(SNI) = INVP(IDDL)
C        INVP(IDDL) 1ER DDL DU SNI
 407  CONTINUE
C.....................................................................
      IF (NIV.GE.1) THEN
C     WRITE(IFM,*)'RENUMEROTATION PAR MINIMUM DEGRE'//
C     *  'TEMPS CPU',TEMPS(3),
C     *  ' + TEMPS CPU SYSTEME ',TEMPS(6)
      ENDIF
      FCTNZS = FCTNZS + NEQ

      IF (NIV.GE.2) THEN
         WRITE(IFM,*)'--- RESULTATS DE LA RENUMEROTATION : '
         WRITE(IFM,*)'   --- NOMBRE DE NOEUDS ',NBND
         WRITE(IFM,*)'   --- LONGUEUR DE LA MATRICE INITIALE ',DIAG(NEQ)
         WRITE(IFM,*)'   --- NOMBRE DE SUPERNOEUDS ',NBSN
         IF(OPTNUM.EQ.2) THEN
            WRITE(IFM,*)'   --- NOMBRE D''OP. FLOTTANTES ',NBOPS
         ENDIF

C STOCKAGE INFO SI FETI
       ENDIF
       IF (LFETI) THEN
C INTRODUIT POUR PRENDRE EN COMPTE LES TROUS DANS LA LISTE DES SOUS
C -DOMAINES TRAITES EN PARALLELE PAR UN PROCESSEUR
         CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
         ILIMPI=ILIMPI+1
         CALL JEVEUO('&FETI.INFO.STOCKAGE.FIDD','E',IFET1)
         NBSD=ZI(IFET1+1)
         IFET2=ZI(IFET1)
C SI ON COMMENCE LE PROCESSUS, IL FAUT TROUVER LE PREMIER SD CONCERNE
C PAR LE PROCESSUS
         IF (IFET2.EQ.0) THEN
           DO 445 I=0,NBSD-1
             IAUX=ZI(ILIMPI+I)
             IF (IAUX.EQ.1) THEN
               IFET2=I
               ZI(IFET1)=I
               GOTO 446
             ENDIF
  445      CONTINUE
           CALL U2MESS('A','ALGELINE3_26')
  446      CONTINUE
         ENDIF
         CALL JEVEUO('&FETI.INFO.STOCKAGE.FVAL','E',IFET3)
         ZI(IFET3+IFET2)=DIAG(NEQ)
         CALL JEVEUO('&FETI.INFO.STOCKAGE.FNBN','E',IFET4)
         ZI(IFET4+IFET2)=NBND
C MISE A JOUR DES SOMMES FINALES
         ZI(IFET3+NBSD)=ZI(IFET3+NBSD)+DIAG(NEQ)
         ZI(IFET4+NBSD)=ZI(IFET4+NBSD)+NBND
         CALL INFBAV()
       ENDIF

 999  CONTINUE
      END
