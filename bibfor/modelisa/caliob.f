      SUBROUTINE CALIOB(FONREE, CHARGE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*4       FONREE
      CHARACTER*8               CHARGE
C ---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/05/2001   AUTEUR CIBHHPD D.NUNEZ 
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
C     CREER LES CARTES CHAR.CHME.CMULT ET CHAR.CHME.CIMPO
C          ET REMPLIR LIGRCH, POUR LE MOT-CLE 'LIAISON_OBLIQUE'
C
C IN  : FONREE : 'REEL' OU 'FONC'
C IN  : CHARGE : NOM UTILISATEUR DU RESULTAT DE CHARGE
C ---------------------------------------------------------------------
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
      PARAMETER    ( NBDDL= 6)
      INTEGER       IMP
      COMPLEX*16    BETAC
      CHARACTER*2   TYPLAG
      CHARACTER*4   TYPCOE
      CHARACTER*8   K8BID, MOTCLE, KBETA, MOGROU, MOD, NOMA
      CHARACTER*8   NOMNOE
      CHARACTER*16  MOTFAC
      CHARACTER*19  LISREL
      CHARACTER*24  TRAV, GROUMA, NOEUMA
      CHARACTER*19  LIGRMO
      REAL*8        DIRECT(3)
      REAL*8        MAT(3,3)
      REAL*8        DGRD, R8DGRD, ZERO
      REAL*8        ANGL(3), REEL
      CHARACTER*8   KDDL(NBDDL), KFONC
      CHARACTER*1 K1BID
C ----------------------------------------------------------------------
      DATA KDDL / 'DX' , 'DY' , 'DZ' , 'DRX' , 'DRY' , 'DRZ' /
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      LISREL = '&&CALIOB.RLLISTE'
      MOTFAC = 'LIAISON_OBLIQUE '
      TYPCOE = 'REEL'
      IF (FONREE.EQ.'COMP') THEN
        TYPCOE = 'COMP'
      ENDIF
      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GOTO 9999
C
      DGRD = R8DGRD()
      ZERO = 0.D0
C
      MOTCLE = 'NOEUD   '
      MOGROU = 'GROUP_NO'
      TYPLAG = '12'
C --- INITIALISATION PROVISOIRE ---
      BETAC  = (1.0D0,0.0D0)
C
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
C
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
C
C ---  LIGREL DU MODELE ---
C
      LIGRMO = MOD//'.MODELE'
C
C --- MAILLAGE ASSOCIE AU MODELE ---
C
      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
C
C --- DIMENSION ASSOCIEE AU MODELE ---
C
      CALL DISMOI('F','Z_CST',MOD,'MODELE',NDIMMO,K8BID,IER)
      NDIMMO = 3
      IF (K8BID.EQ.'OUI') NDIMMO = 2
C
      NOEUMA = NOMA//'.NOMNOE'
      GROUMA = NOMA//'.GROUPENO'
C
      NDIM   = 0
      NGRO   = 0
      NBGM   = 0
      NBEM   = 0
      NBET   = 0
      NENT   = 0
C
C --- DETERMINATION DU NOMBRE TOTAL DE NOEUDS INTERVENANT ---
C --- DANS TOUTES LES LIAISONS                            ---
C
      DO 10 I=1,NLIAI
         CALL GETVID(MOTFAC,MOGROU,I,1,0,K8BID,NGRO)
         CALL GETVID(MOTFAC,MOTCLE,I,1,0,K8BID,NENT)
C
         NGRO = -NGRO
         NBGM = MAX(NBGM,NGRO)
         NENT = -NENT
         NBEM = MAX(NBEM,NENT)
         NBET = NBET + NENT
  10  CONTINUE
C
      NDIM = MAX(NBGM,NBEM)
      IF (NDIM .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,'IL N''Y A AUCUN GROUPE DE '//
     +                   'NOEUDS NI AUCUN NOEUD DEFINI APRES LE '//
     +                   'MOT FACTEUR '//MOTFAC )
      ENDIF
      TRAV = '&&CALIOB.'//MOTFAC
      CALL WKVECT(TRAV,'V V K8',NDIM,JJJ)
C
      DO 20 IOCC = 1, NLIAI
         CALL GETVID(MOTFAC,MOGROU,IOCC,1,NDIM,ZK8(JJJ),NGR)
         DO 30 IGR = 1, NGR
            CALL JEEXIN (JEXNOM(GROUMA,ZK8(JJJ+IGR-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,'LE GROUPE '//ZK8(JJJ+IGR-1)//
     +                      'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ELSE
               CALL JELIRA (JEXNOM(GROUMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      N1,K1BID)
            ENDIF
 30      CONTINUE
         CALL GETVID(MOTFAC,MOTCLE,IOCC,1,NDIM,ZK8(JJJ),NNO)
         DO 40 INO = 1, NNO
            CALL JENONU (JEXNOM(NOEUMA,ZK8(JJJ+INO-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,MOTCLE//' '//ZK8(JJJ+INO-1)//
     +                     'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ENDIF
 40      CONTINUE
 20   CONTINUE
C
C     ALLOCATION DE TABLEAUX DE TRAVAIL
C
      CALL WKVECT ('&&CALIOB.LISTE','V V K8',NDIM,JLISTE)
      CALL WKVECT ('&&CALIOB.DDL  ','V V K8',NBDDL  ,JDDL  )
      CALL WKVECT ('&&CALIOB.COEMU','V V R' ,NBDDL  ,JCMU  )
      CALL WKVECT ('&&CALIOB.COEMUC','V V C' ,NBDDL  ,JCMUC  )
C
C     MISE A JOUR DE LIGRCH ET STOCKAGE DANS LES CARTES
C
      DO 50 I = 1, NLIAI
         ANGL(1) = ZERO
         ANGL(2) = ZERO
         ANGL(3) = ZERO
         CALL GETVR8(MOTFAC,'ANGL_NAUT',I,1,3,ANGL,NA)
C
         DO 60 I1 = 1,MIN(3,ABS(NA))
            ANGL(I1) = ANGL(I1) * DGRD
 60      CONTINUE
C
C  --- MATRICE DE PASSAGE AU REPERE GLOBAL ---
C
      CALL MATROT ( ANGL , MAT )
C
         N1 = 0
         DO 70 I1 = 1,NBDDL
C
            IF (FONREE.EQ.'REEL') THEN
               CALL GETVR8(MOTFAC,KDDL(I1),I,1,1,REEL,IMP)
C
               IF (IMP.NE.0) THEN
                  ZK8(JDDL) = KDDL(I1)
                  ZR(JCMU) = 1.0D0
                  BETA = REEL
               ENDIF
            ELSE
               CALL GETVID(MOTFAC,KDDL(I1),I,1,1,KFONC,IMP)
C
               IF (IMP.NE.0) THEN
                  ZK8(JDDL) = KDDL(I1)
                  ZR(JCMU) = 1.0D0
                  KBETA = KFONC
               ENDIF
            ENDIF
            IF (IMP.EQ.0) GOTO 70
C
            CALL LXCAPS(ZK8(JDDL))
            CALL LXCADR(ZK8(JDDL))
C
            IF (ZK8(JDDL).EQ.'DX'.OR.ZK8(JDDL).EQ.'DRX') THEN
               DIRECT(1) = MAT(1,1)
               DIRECT(2) = MAT(1,2)
               DIRECT(3) = MAT(1,3)
            ELSEIF (ZK8(JDDL).EQ.'DY'.OR.ZK8(JDDL).EQ.'DRY') THEN
               DIRECT(1) = MAT(2,1)
               DIRECT(2) = MAT(2,2)
               DIRECT(3) = MAT(2,3)
            ELSEIF (ZK8(JDDL).EQ.'DZ'.OR.ZK8(JDDL).EQ.'DRZ') THEN
               DIRECT(1) = MAT(3,1)
               DIRECT(2) = MAT(3,2)
               DIRECT(3) = MAT(3,3)
            ENDIF
C
            IF (ZK8(JDDL).EQ.'DX'.OR.ZK8(JDDL).EQ.'DY'.OR.
     +          ZK8(JDDL).EQ.'DZ') THEN
                   ZK8(JDDL) = 'DEPL'
            ELSE IF (ZK8(JDDL).EQ.'DRX'.OR.ZK8(JDDL).EQ.'DRY'.OR.
     +          ZK8(JDDL).EQ.'DRZ') THEN
                   ZK8(JDDL) = 'ROTA'
            ENDIF
C
C ---   CAS DE GROUP_NO ---
C
            CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO',
     +             I,1,0,ZK8(JLISTE),NG)
            IF (NG .NE.0) THEN
                NG = -NG
                CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO',
     +                 I,1,NG,ZK8(JLISTE),N)
                DO 80 J = 1, NG
                 CALL JEVEUO (JEXNOM(GROUMA,ZK8(JLISTE-1+J)),'L',JGR0)
                 CALL JELIRA (JEXNOM(GROUMA,ZK8(JLISTE-1+J)),'LONMAX',
     +                      N,K1BID)
                 DO 90 K = 1, N
                   IN = ZI(JGR0-1+K)
                   CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
C
C --- CREATION ET CALCUL DE LA RELATION      ---
C --- ET AFFECTATION A LA LISTE DE RELATIONS ---
C
                   CALL AFRELA(ZR(JCMU),ZC(JCMUC),ZK8(JDDL),NOMNOE,
     +                         NDIMMO,DIRECT,1,BETA,BETAC,KBETA,TYPCOE,
     +                         FONREE,TYPLAG,LISREL)
  90           CONTINUE
  80        CONTINUE
C
C
            ELSE
C
C ---   CAS DE NOEUD ---
C
                CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD',
     +              I,1,0,ZK8(JLISTE),NBNO)
                IF (NBNO .NE. 0) THEN
                  NBNO=-NBNO
                  CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD',
     +                I,1,NBNO,ZK8(JLISTE),N)
C
                  DO 100 K = 1, NBNO
C
C --- CREATION ET CALCUL DE LA RELATION      ---
C --- ET AFFECTATION A LA LISTE DE RELATIONS ---
C
                    CALL AFRELA(ZR(JCMU),ZC(JCMUC),ZK8(JDDL),
     +                          ZK8(JLISTE+K-1),NDIMMO,DIRECT,1,BETA,
     +                          BETAC,KBETA,TYPCOE,FONREE,TYPLAG,LISREL)
 100             CONTINUE
C
               ENDIF
C
            ENDIF
 70      CONTINUE
C
  50  CONTINUE
C
C --- AFFECTATION DE LA LISTE DE RELATIONS A LA CHARGE ---
C
      CALL AFLRCH(LISREL,CHARGE)
C
      CALL JEDETC ('V','&&CALIOB',1)
C
 9999 CONTINUE
      CALL JEDEMA()
      END
