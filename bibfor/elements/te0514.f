      SUBROUTINE TE0514(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 06/07/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C.......................................................................
C
C       CALCUL DES DONNÉES TOPOLOGIQUES CONCERNANT CONCERNANT
C       LA DÉCOUPE DES ÉLÉMENTS POUR L'INTÉGRATION AVEC X-FEM
C                   (VOIR BOOK IV 27/10/04)
C
C  OPTION : 'TOPOSE' (X-FEM TOPOLOGIE DES SOUS-ÉLÉMENTS)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      CHARACTER*8   ELP,NOMA,TYPMA,LAG,ENR,K8BID
      CHARACTER*24  PINTER,AINTER,COORSE,HEAV,PMILIE
      INTEGER       IGEOM,JLSN,JOUT1,JOUT2,JOUT3,JOUT4,JOUT5,JOUT6,JOUT7
      INTEGER       JPTINT,JAINT,JHEAV,IADZI,IAZK24,JDIM,NNO,NNN,NODOUB
      INTEGER       NINTER,CONNEC(6,6),AREPAR(6,6),NIT,NSE,NSETOT
      INTEGER       NPTS,CNSE(6,6),I,J,IT,NPI,IPT,ISE,IN,NI,NSEMX,CPT
      INTEGER       NDIM,IBID,NDIME,IAPAR
      INTEGER       JPTMIL,NPM,NMILIE,PMMAX,CPCNSE,NMFIS,PMDOUB,JGRLSN
      INTEGER       ZXAIN,XXMMVD,IRET
      REAL*8        NMIL(3),RBID,R8PREM
      REAL*8        NEWPT(3),P(3),PADIST,LONREF,CRIT
      LOGICAL       ISMALI,DEJA,AJN

C......................................................................

      CALL JEMARQ()
      ZXAIN = XXMMVD('ZXAIN')
C   INFO: LE NB DE SOUS-TETRAS MAX POUR CHAQUE TETRA EST NSEMX=6 (3D)
C   INFO: LE NB DE SOUS-TRIAS MAX POUR CHAQUE TRIA EST NSEMX=3 (2D)

      CALL ELREF1(ELP)
      CALL ELREF4(' ','RIGI',NDIME,NNO,IBID,IBID,IBID,IBID,IBID,IBID)

      CALL TECAEL(IADZI,IAZK24)
      NOMA=ZK24(IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8BID,IRET)

C     ATTENTION, NE PAS CONFONDRE NDIM ET NDIME  !!
C     NDIM EST LA DIMENSION DU MAILLAGE
C     NDIME EST DIMENSION DE L'ELEMENT FINI
C     PAR EXEMPLE, POUR LES ELEMENT DE BORDS D'UN MAILLAGE 3D :
C     NDIME = 2 ALORS QUE NDIM = 3

      IF (NDIME.EQ. 3) THEN
         NSEMX=6
      ELSEIF (NDIME.EQ. 2) THEN
         NSEMX=3
         PMMAX=10
      ELSEIF (NDIME.EQ. 1) THEN
         NSEMX=2
         PMMAX=2
      ENDIF
C
C     RECUPERATION DES ENTREES / SORTIE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PLEVSET','L',JLSN)
      CALL JEVECH('PPINTTO','E',JOUT1)
      CALL JEVECH('PCNSETO','E',JOUT2)
      CALL JEVECH('PHEAVTO','E',JOUT3)
      CALL JEVECH('PLONCHA','E',JOUT4)
      CALL JEVECH('PAINTER','E',JOUT5)

      CALL TEATTR (NOMTE,'S','XFEM',ENR,IBID)
      IF (IBID.EQ.0 .AND.(ENR.EQ.'XH'.OR.ENR.EQ.'XHC')
     &   .AND. NDIM.LE.2) THEN
        CALL JEVECH('PPMILTO','E',JOUT6)
        IF(NDIME.EQ.2) CALL JEVECH('PGRADLN','L',JGRLSN)
      ENDIF
      IF (NDIME.EQ.3)CALL JEVECH('PCRITER','E',JOUT7)

      NPI=0
      NPM=0
      CPT=0
      NSETOT=0
      AJN=.FALSE.
      CPCNSE=0
      NMFIS=0

C     CALCUL D'UNE LONGUEUR CARACTERISTIQUE DE L'ELEMENT
      CALL LONCAR(NDIM,TYPMA,ZR(IGEOM),LONREF)

C     ON SUBDIVISE L'ELEMENT PARENT EN NIT SOUS-ELEMENTS
      CALL XDIVTE(TYPMA,CONNEC,AREPAR,NIT)

C     ARCHIVAGE DE LONCHAM
      ZI(JOUT4-1+1)=NIT

C     BOUCLE SUR LES NIT TETRAS
      DO 100 IT=1,NIT

C       DECOUPAGE EN NSE SOUS-ELEMENTS
        PINTER='&&TE0514.PTINTER'
        AINTER='&&TE0514.ATINTER'

        NMILIE = 0
        NINTER = 0
        NPTS   = 0


        IF (.NOT.ISMALI(ELP) .AND. NDIM.LE.2) THEN
          PMILIE='&&TE0514.PTMILIE'
          CALL XDECQU(IT,NDIM,CONNEC,JLSN,JGRLSN,IGEOM,
     &          PINTER,NINTER,NPTS,AINTER,PMILIE,NMILIE,NMFIS)      
          HEAV='&&TE0514.HEAV'
          CALL XDECQV(IT,CONNEC,ZR(JLSN),IGEOM,PINTER,NINTER,
     &                      NPTS,AINTER,NSE,CNSE,HEAV)
        ELSE
          CALL XDECOU(IT,CONNEC,ZR(JLSN),IGEOM,PINTER,NINTER,
     &                                           NPTS,AINTER)
          COORSE='&&TE0514.COORSE'
          HEAV='&&TE0514.HEAV'
          CALL XDECOV(IT,CONNEC,ZR(JLSN),IGEOM,PINTER,NINTER,
     &                      NPTS,AINTER,NSE,CNSE,COORSE,HEAV)
        ENDIF

        CALL JEVEUO(HEAV,'L',JHEAV)
        CALL JEVEUO(AINTER,'L',JAINT)

C       ARCHIVAGE DE LONCHAM
        NSETOT=NSETOT+NSE

C       NOMBRE TOTAL DE SOUS-ELEMENTS LIMITE A 32
        CALL ASSERT(NSETOT.LE.32)
        ZI(JOUT4-1+IT+1)=NSE

C ----- BOUCLE SUR LES NINTER POINTS D'INTER : ARCHIVAGE DE PINTTO
        CALL JEVEUO(PINTER,'L',JPTINT)
        DO 200 IPT=1,NINTER
          DO 210 J=1,NDIM
            NEWPT(J)=ZR(JPTINT-1+NDIM*(IPT-1)+J)
 210      CONTINUE

C         VERIF SI EXISTE DEJA DANS PINTTO
          DEJA=.FALSE.
          DO 220 I=1,NPI
            DO 221 J=1,NDIM
              P(J) = ZR(JOUT1-1+NDIM*(I-1)+J)
 221        CONTINUE
            IF (PADIST(NDIM,P,NEWPT) .LT. (LONREF*1.D-3)) THEN
              DEJA = .TRUE.
              NI=I
            ENDIF
 220      CONTINUE
          IF (.NOT.DEJA) THEN
            NPI=NPI+1
C           NOMBRE TOTAL DE POINTS D'INTERSECTION LIMITE A 11
            CALL ASSERT(NPI.LE.11)
C           ARCHIVAGE DE PINTTO
            DO 230 J=1,NDIM
              ZR(JOUT1-1+NDIM*(NPI-1)+J)=ZR(JPTINT-1+NDIM*(IPT-1)+J)
 230        CONTINUE

C           ARCHIVAGE DE AINTER
C           ON STOCKE LE NUMERO DE L'ARETE DE L'ELEMENT PARENT
C           SI C'EN EST UNE, SINON ZERO
            IAPAR=ZR(JAINT-1+ZXAIN*(IPT-1)+1)
            IF (IAPAR.NE.0.D0) THEN
              ZR(JOUT5-1+2*(NPI-1)+1)=AREPAR(IT,IAPAR)
            ELSE
              ZR(JOUT5-1+2*(NPI-1)+1)=0
            ENDIF
            ZR(JOUT5-1+2*(NPI-1)+2)=ZR(JAINT-1+ZXAIN*(IPT-1)+2)
  
C           MISE A JOUR DU CNSE (TRANSFORMATION DES 100 EN 1000...)
            DO 240 ISE=1,NSE
              DO 241 IN=1,NDIME+1
                IF (CNSE(ISE,IN).EQ.100+IPT) CNSE(ISE,IN)=1000+NPI
 241          CONTINUE
 240        CONTINUE
          ELSE
            DO 114 ISE=1,NSE
              DO 115 IN=1,NDIME+1
                IF (CNSE(ISE,IN).EQ.100+IPT) CNSE(ISE,IN)=1000+NI
 115          CONTINUE
 114        CONTINUE
          ENDIF

 200    CONTINUE

C ----- BOUCLE SUR LES NMILIE POINTS MILIEUX : ARCHIVAGE DE PMILTO
        IF (.NOT.ISMALI(ELP).AND.NDIM.LE.2) THEN
        CALL JEVEUO(PMILIE,'L',JPTMIL)
        DO 300 IPT=1,NMILIE
          DO 310 J=1,NDIM
            NEWPT(J)=ZR(JPTMIL-1+NDIM*(IPT-1)+J)
 310      CONTINUE

C         VERIF SI EXISTE DEJA DANS PMILTO
          DEJA=.FALSE.
          DO 320 I=1,NPM
            DO 321 J=1,NDIM
              P(J) = ZR(JOUT6-1+NDIM*(I-1)+J)
 321        CONTINUE
            IF (PADIST(NDIM,P,NEWPT) .LT. (LONREF*1.D-3)) THEN
              DEJA = .TRUE.
              NI=I
            ENDIF
 320      CONTINUE
          IF (.NOT.DEJA) THEN
            NPM=NPM+1
C           NOMBRE TOTAL DE POINTS MILIEUX LIMITE A PMMAX
            CALL ASSERT(NPM.LE.PMMAX)
C           ARCHIVAGE DE PMILTO
            DO 330 J=1,NDIM
              ZR(JOUT6-1+NDIM*(NPM-1)+J)=ZR(JPTMIL-1+NDIM*(IPT-1)+J)
 330        CONTINUE
 
C           MISE A JOUR DU CNSE (TRANSFORMATION DES 200 EN 2000...)
            DO 340 ISE=1,NSE
              DO 341 IN=1,6
                IF (CNSE(ISE,IN).EQ.200+IPT) CNSE(ISE,IN)=2000+NPM
 341          CONTINUE
 340        CONTINUE
          ELSE
            DO 350 ISE=1,NSE
              DO 351 IN=1,6
                IF (CNSE(ISE,IN).EQ.200+IPT) CNSE(ISE,IN)=2000+NI
 351          CONTINUE
 350        CONTINUE
          ENDIF

 300    CONTINUE
        CALL JEDETR(PMILIE)
        ENDIF

C ----- BOUCLE SUR LES NSE SOUS-ELE : ARCHIVAGE DE PHEAVTO, PHEAVTO
        DO 120 ISE=1,NSE
          CPT=CPT+1
C         ARCHIVAGE DE PHEAVTO
          ZI(JOUT3-1+NSEMX*(IT-1)+ISE)=NINT(ZR(JHEAV-1+ISE))
C         ARCHIVAGE DE PCNSETO
          IF (.NOT.ISMALI(ELP) .AND. NDIM.LE.2) THEN
            IF (NDIME.NE.1) THEN
              DO 121 IN=1,6
                CPCNSE=CPCNSE+1
                ZI(JOUT2-1+6*(CPT-1)+IN)=CNSE(ISE,IN)
 121          CONTINUE
            ELSE
              DO 124 IN=1,3
                ZI(JOUT2-1+3*(CPT-1)+IN)=CNSE(ISE,IN)
 124          CONTINUE
            ENDIF
          ELSE
            DO 123 IN=1,NDIME+1
              ZI(JOUT2-1+(NDIME+1)*(CPT-1)+IN)=CNSE(ISE,IN)
 123        CONTINUE
          ENDIF
 120    CONTINUE

        CALL JEDETR(PINTER)
        CALL JEDETR(AINTER)
        CALL JEDETR(COORSE)
        CALL JEDETR(HEAV)
 
 100  CONTINUE

C --- LE NOEUD N- CALCULE, STOCKE ET RENUMEROTE
      IF (ELP.EQ.'QU8') THEN
        DO 400 I=1,CPCNSE
          IF (ZI(JOUT2-1+I).EQ.9) THEN
            CALL NDCENT(IGEOM,ZR(JLSN),NMIL,RBID)          
            DO 401 J=1,NDIM  
              ZR(JOUT6+NPM*NDIM+J-1)=NMIL(J)
 401        CONTINUE
            ZI(JOUT2-1+I)=3000+NPM+1
            AJN=.TRUE.
          ENDIF
 400    CONTINUE
      ENDIF

C     ARCHIVAGE DE LONCHAM POINTS D'INTERSECTION
      ZI(JOUT4-1+NIT+2)=NPI

C-----------------------------------------
C     SERT UNIQUEMENT POUR LA VISU
C     NOMBRE DE NOUVEAUX POINTS : NNN

C  -  ON AJOUTE LES POINTS D'INTERSECTION
      NNN = NPI * 2

C  -  ON AJOUTE LES NOEUDS DU MAILLAGE
      DO 30 I=1,NNO
        NODOUB = 1
        IF (ZR(JLSN-1+I).EQ.0) NODOUB = 2
        NNN = NNN + NODOUB
 30   CONTINUE

C  -  ON AJOUTE LES POINTS MILIEUX
      IF (.NOT.ISMALI(ELP).AND. NDIM.LE.2) THEN
        PMDOUB=0
C       LE NOEUD CENTRAL N'EST PAS INTERSECTE
        IF (AJN) PMDOUB=1
C  -    NMFIS = NBRE POINTS MILIEUX INTERSECTES
        NNN=NNN+NMFIS+NPM+PMDOUB
      ENDIF

      ZI(JOUT4-1+NIT+3)=NNN
      ZI(JOUT4-1+NIT+4)=0

C     ARCHIVAGE DE LONCHAM POINTS MILIEUX
      IF (.NOT.ISMALI(ELP).AND. NDIM.LE.2) THEN
        IF (AJN) THEN
          ZI(JOUT4-1+NIT+4)=NPM+1
        ELSE
          ZI(JOUT4-1+NIT+4)=NPM
        ENDIF
      ENDIF
C
C-----------------------------------------

C     CRITERE SUR LES VOLUMES
      IF (NDIME .EQ. 3) THEN
        CALL XCRVOL(IGEOM,ZR(JOUT1),ZI(JOUT2),ZI(JOUT3),ZI(JOUT4),CRIT)
        ZR(JOUT7)=CRIT
      ENDIF

      CALL JEDEMA()
      END
