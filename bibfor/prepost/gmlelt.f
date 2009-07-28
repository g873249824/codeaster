      SUBROUTINE  GMLELT(IGMSH, MAXNOD, NBTYMA, NBMAIL, NBNOMA, NUCONN,
     &                   VERSIO)
      IMPLICIT NONE
      INTEGER IGMSH,MAXNOD,NBTYMA,NBMAIL,NBNOMA(NBTYMA),NUCONN(19,32),
     &        VERSIO
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 22/07/2009   AUTEUR SELLENET N.SELLENET 
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
C TOLE CRS_512
C
C      GMLELT --   LECTURE DES NUMEROS DES ELEMENTS, DE LEUR TYPE,
C                  DE LEUR NUMERO DE GROUPE, DU NOMBRE DE LEURS
C                  CONNECTIVITES ET DE LEURS CONNECTIVITES
C
C   ARGUMENT        E/S  TYPE         ROLE
C    IGMSH          IN    I         UNITE LOGIQUE DU FICHIER GMSH
C    MAXNOD         IN    I         NOMBRE MAXIMUM DE NOEUDS POUR
C                                   UNE MAILLE DONNEE
C    NBTYMA         IN    I         NOMBRE  DE TYPES DE MAILLES
C    NBMAIL         OUT   I         NOMBRE TOTAL DE MAILLES
C    NBNOMA         IN    I         NOMBRE DE NOEUDS DE LA MAILLE
C                                    POUR UN TYPE DE MAILLE DONNEE
C    NUCONN         IN    I         PASSAGE DE LA NUMEROTATION DES NDS
C                                     D'UNE MAILLE : ASTER -> GMSH
C    VERSIO         IN    I         VERSION DU FICHIER GMSH
C	   
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
C
      INTEGER            ZI
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
      CHARACTER*32 JEXNOM, JEXNUM
C
C --------- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------
C
      CHARACTER*8 K8BID
      LOGICAL     EXISGR
      INTEGER     IMES,IUNIFI,NBMXTE,NBTAG,I,IJ,K,ICURGR
      INTEGER     NBGROU,INDGRO,IMA,IBID,ITYP,INO,NODE,INDMAX
      INTEGER     JNUMA,JTYPMA,JGROMA,JNBNMA,JNOMA,JNBMAG,JNBTYM
      INTEGER     JINDMA,JDETR,JTAG,JGR

      PARAMETER   (NBMXTE=19)
      INTEGER     NBNO(NBMXTE)
      DATA        NBNO/ 2, 3, 4, 4, 8, 6, 5, 3, 6, 9,10,27,
     &                      18,14, 1, 8,20,15,13/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATION :
C     --------------
      K8BID   = '        '
C
C --- RECUPERATION DES NUMEROS D'UNITE LOGIQUE :
C     ----------------------------------------
      IMES  = IUNIFI('MESSAGE')
C
C --- LECTURE DU NOMBRE D'ELEMENTS :
C     ----------------------------
      READ(IGMSH,'(I10)') NBMAIL
C
C --- CREATION DE VECTEURS DE TRAVAIL :
C     -------------------------------
      CALL JEDETR('&&PREGMS.NUMERO.MAILLES')
      CALL JEDETR('&&PREGMS.TYPE.MAILLES')
      CALL JEDETR('&&PREGMS.GROUPE.MAILLES')
      CALL JEDETR('&&PREGMS.NBNO.MAILLES')
      CALL JEDETR('&&PREGMS.CONNEC.MAILLES')
      CALL JEDETR('&&PREGMS.NBMA.GROUP_MA')
      CALL JEDETR('&&PREGMS.NBTYP.MAILLES')
      CALL JEDETR('&&PREGMS.LISTE.GROUP_MA')
      CALL JEDETR('&&PREGMS.INDICE.GROUP_MA')
      CALL JEDETR('&&PREGMS.TAGS')
C
C ---   VECTEUR DES NUMEROS DES MAILLES
      CALL WKVECT('&&PREGMS.NUMERO.MAILLES','V V I',NBMAIL,JNUMA)
C ---   VECTEUR DU TYPE DES MAILLES
      CALL WKVECT('&&PREGMS.TYPE.MAILLES','V V I',NBMAIL,JTYPMA)
C ---   VECTEUR DU NUMERO DE GROUPE DES MAILLES
      CALL WKVECT('&&PREGMS.GROUPE.MAILLES','V V I',NBMAIL,JGROMA)
C ---   VECTEUR DU NOMBRE DE CONNECTIVITES DES MAILLES
      CALL WKVECT('&&PREGMS.NBNO.MAILLES','V V I',NBMAIL,JNBNMA)
C ---   VECTEUR DES CONNECTIVITES DES MAILLES
      CALL WKVECT('&&PREGMS.CONNEC.MAILLES','V V I',MAXNOD*NBMAIL,JNOMA)
C ---   VECTEUR DU NOMBRE DE MAILLES POUR UN GROUPE DE MAILLES
      CALL WKVECT('&&PREGMS.NBMA.GROUP_MA','V V I',NBMAIL,JNBMAG)
C ---   VECTEUR DU NOMBRE DE MAILLES PAR TYPE DE MAILLES
      CALL WKVECT('&&PREGMS.NBTYP.MAILLES','V V I',NBTYMA,JNBTYM)
C --- CREATION DU VECTEUR FAISANT CORRESPONDRE LES INDICES AUX
C --- NUMEROS DES GROUPES DE MAILLES :
      CALL WKVECT('&&PREGMS.INDICE.GROUP_MA','V V I',NBMAIL,JINDMA)
C --- INDICATION DE DESTRUCTION DES NOEUDS
      CALL JEVEUO('&&PREGMS.DETR.NOEUDS','E',JDETR)
C --- TAGS POUR LE FORMAT VERSION 2 :
C --- DIMENSIONNE A 2*NBMAIL CAR 2 TAGS PAS DEFAUT DANS GMSH
      IF (VERSIO.EQ.2) THEN
        CALL JECREC('&&PREGMS.TAGS','V V I','NU',
     +                                   'DISPERSE','VARIABLE',NBMAIL)
      ENDIF
C
C --- LECTURE DES ENREGISTREMENTS RELATIFS AUX MAILLES ET AFFECTATION
C --- DES VECTEURS DE TRAVAIL :
C     -----------------------
      K      = 0
      IJ     = 0
      
C --- ICURGR : NUMERO DU GROUPE GMSH
C     NBGROU : NBRE DE GROUPES TROUVES
C     INDGRO : INDICE DU GROUPE
      ICURGR = 0
      NBGROU = 0
      INDGRO = 0
      DO 10 IMA = 1, NBMAIL

        IF (VERSIO.EQ.1) THEN
C
          READ(IGMSH,*) ZI(JNUMA+IMA-1),ZI(JTYPMA+IMA-1),
     +                  ZI(JGROMA+IMA-1),IBID,ZI(JNBNMA+IMA-1),
     +                 (ZI(JNOMA+IJ+K-1),K=1,ZI(JNBNMA+IMA-1))
C
        ELSEIF (VERSIO.EQ.2) THEN
C
          READ(IGMSH,*) IBID,IBID,NBTAG
C
          CALL JECROC(JEXNUM('&&PREGMS.TAGS',IMA))
          CALL JEECRA(JEXNUM('&&PREGMS.TAGS',IMA),'LONMAX',NBTAG,K8BID)
          CALL JEVEUO(JEXNUM('&&PREGMS.TAGS',IMA),'E',JTAG)
C
          BACKSPACE(IGMSH)
          READ(IGMSH,*) ZI(JNUMA+IMA-1),ZI(JTYPMA+IMA-1),
     +                  NBTAG,(ZI(JTAG-1+K),K=1,NBTAG),
     +                 (ZI(JNOMA+IJ+K-1),K=1,NBNO(ZI(JTYPMA+IMA-1)))
C
          ZI(JNBNMA+IMA-1)=NBNO(ZI(JTYPMA+IMA-1))
          ZI(JGROMA+IMA-1)=ZI(JTAG-1+1)
          IF (NBTAG.EQ.0) THEN
            ZI(JGROMA+IMA-1)=0
          ENDIF
C
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
C      INDICATION DES NOEUDS QUI NE SONT PAS ORPHELINS
        ITYP = ZI(JTYPMA+IMA-1)
        DO 12 INO = 1,NBNOMA(ITYP)
          NODE = ZI(JNOMA+IJ+NUCONN(ITYP,INO)-1)
          ZI(JDETR+NODE) = 1
 12     CONTINUE

        IF (ICURGR.NE.ZI(JGROMA+IMA-1)) THEN
          ICURGR = ZI(JGROMA+IMA-1)
          EXISGR = .FALSE.
          DO 20 I = 1, NBGROU
            IF (ICURGR.EQ.ZI(JINDMA+I-1)) THEN
              EXISGR = .TRUE.
              INDGRO = I
              GOTO 30
            ENDIF
  20      CONTINUE
  30      CONTINUE
          IF (.NOT.EXISGR) THEN
            NBGROU = NBGROU + 1
            INDGRO = NBGROU
            ZI(JINDMA+INDGRO-1) = ZI(JGROMA+IMA-1)
          ENDIF
        ENDIF
        ZI(JNBMAG+INDGRO-1) = ZI(JNBMAG+INDGRO-1) + 1
      
        IJ = IJ + ZI(JNBNMA+IMA-1)
        ZI(JNBTYM+ZI(JTYPMA+IMA-1)-1) = ZI(JNBTYM+ZI(JTYPMA+IMA-1)-1)+1
  10  CONTINUE
C
      IF (NBGROU.NE.0) THEN
C
        INDMAX = NBGROU
        CALL JEECRA('&&PREGMS.INDICE.GROUP_MA','LONUTI',INDMAX,K8BID)
C
C --- CREATION DE LA COLLECTION DES GROUPES DE MAILLES :
C     ------------------------------------------------
        CALL JECREC('&&PREGMS.LISTE.GROUP_MA','V V I','NU','CONTIG',
     +              'VARIABLE',INDMAX)
        CALL JEECRA('&&PREGMS.LISTE.GROUP_MA','LONT',NBMAIL,K8BID)
C
        DO 40 I = 1, INDMAX
            CALL JEECRA(JEXNUM('&&PREGMS.LISTE.GROUP_MA',I),
     +               'LONMAX',ZI(JNBMAG+I-1),K8BID)
            ZI(JNBMAG+I-1) = 0
  40    CONTINUE
C
C --- AFFECTATION DES OBJETS RELATIFS AUX GROUPES DE MAILLES :
C     ------------------------------------------------------
        K      = 0
C --- ICURGR : NUMERO DU GROUPE GMSH
C     NBGROU : NBRE DE GROUPES TROUVES
C     INDGRO : INDICE DU GROUPE
        ICURGR = 0
        NBGROU = 0
        INDGRO = 0
        DO 50 IMA = 1, NBMAIL
          IF (ICURGR.NE.ZI(JGROMA+IMA-1)) THEN
            ICURGR = ZI(JGROMA+IMA-1)
            EXISGR = .FALSE.
            DO 60 I = 1, NBGROU
              IF (ICURGR.EQ.ZI(JINDMA+I-1)) THEN
                EXISGR = .TRUE.
                INDGRO = I
                GOTO 70
              ENDIF
  60        CONTINUE
  70        CONTINUE
            IF (.NOT.EXISGR) THEN
              NBGROU = NBGROU + 1
              INDGRO = NBGROU
            ENDIF
          ENDIF
          ZI(JNBMAG+INDGRO-1) = ZI(JNBMAG+INDGRO-1) + 1
C
          ZI(JINDMA+INDGRO-1) = ZI(JGROMA+IMA-1)
          CALL JEVEUO(JEXNUM('&&PREGMS.LISTE.GROUP_MA',INDGRO),'E',JGR)
          ZI(JGR+ZI(JNBMAG+INDGRO-1)-1) = ZI(JNUMA+IMA-1)
  50    CONTINUE
C
      ENDIF
C
      WRITE(IMES,*) 'NOMBRE DE MAILLES : ',NBMAIL
C
      CALL JEDEMA()
C
C ============================ FIN DE LA ROUTINE ======================
      END
