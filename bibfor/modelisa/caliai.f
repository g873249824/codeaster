      SUBROUTINE CALIAI(FONREE, CHARGE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*4       FONREE
      CHARACTER*8               CHARGE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/04/99   AUTEUR CIBHHPD P.DAVID 
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
C     TRAITER LE MOT CLE LIAISON_DDL DE AFFE_CHAR_XXX
C     ET ENRICHIR LA CHARGE (CHARGE) AVEC LES RELATIONS LINEAIRES
C
C IN       : FONREE : 'REEL' OU 'FONC' OU 'COMP'
C IN/JXVAR : CHARGE : NOM D'UNE SD CHARGE
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
      COMPLEX*16    BETAC
      CHARACTER*2   TYPLAG
      CHARACTER*4   TYPCOE, TYPVAL
      CHARACTER*7   TYPCHA
      CHARACTER*8   BETAF
      CHARACTER*8   K8BID, MOTCLE, MOGROU, MOD, NOMA, NOMNOE
      CHARACTER*16  MOTFAC
      CHARACTER*19  LISREL
      CHARACTER*24  TRAV, GROUMA, NOEUMA
      CHARACTER*19  LIGRMO
      CHARACTER*1 K1BID
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      MOTFAC = 'LIAISON_DDL     '
      MOTCLE = 'NOEUD'
      MOGROU = 'GROUP_NO'
      TYPLAG = '12'
C
      LISREL = '&&CALIAI.RLLISTE'
      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GOTO 9999
C
      BETAC  = (1.0D0,0.0D0)
C
      CALL DISMOI('F','TYPE_CHARGE',CHARGE,'CHARGE',IBID,
     +             TYPCHA,IER)
      CALL DISMOI('F','NOM_MODELE',CHARGE,'CHARGE',IBID,MOD,IER)
      CALL DISMOI('F','NOM_MAILLA',CHARGE,'CHARGE',IBID,NOMA,IER)
C
      NOEUMA = NOMA//'.NOMNOE'
      GROUMA = NOMA//'.GROUPENO'
C
C     -- CALCUL DE NDIM1 : NBRE DE TERMES MAXI D'UNE LISTE
C        DE GROUP_NO OU DE NOEUD
C        --------------------------------------------------
      NDIM1   = 0
      DO 10 I=1,NLIAI
         CALL GETVID(MOTFAC,MOGROU,I,1,0,K8BID,NENT)
         NDIM1 = MAX(NDIM1,-NENT)
         CALL GETVID(MOTFAC,MOTCLE,I,1,0,K8BID,NENT)
         NDIM1 = MAX(NDIM1,-NENT)
  10  CONTINUE

      TRAV = '&&CALIAI.'//MOTFAC
      CALL WKVECT(TRAV,'V V K8',NDIM1,JJJ)


C     -- CALCUL DE NDIM2 ET VERIFICATION DES NOEUDS ET GROUP_NO
C        NDIM2 EST LE NOMBRE MAXI DE NOEUDS IMPLIQUES DANS UNE
C        RELATION LINEAIRE
C        -------------------------------------------------------
      NDIM2   = NDIM1
      DO 20 IOCC = 1, NLIAI
         CALL GETVID(MOTFAC,MOGROU,IOCC,1,NDIM1,ZK8(JJJ),NGR)
         NBGT = 0
         DO 30 IGR = 1, NGR
            CALL JEEXIN (JEXNOM(GROUMA,ZK8(JJJ+IGR-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,'LE GROUPE '//ZK8(JJJ+IGR-1)//
     +                      'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ELSE
               CALL JELIRA (JEXNOM(GROUMA,ZK8(JJJ+IGR-1)),'LONMAX',
     +                      N1,K1BID)
               NBGT = NBGT + N1
            ENDIF
 30      CONTINUE
         NDIM2 = MAX (NDIM2,NBGT)
         CALL GETVID(MOTFAC,MOTCLE,IOCC,1,NDIM1,ZK8(JJJ),NNO)
         DO 40 INO = 1, NNO
            CALL JENONU (JEXNOM(NOEUMA,ZK8(JJJ+INO-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,MOTCLE//' '//ZK8(JJJ+INO-1)//
     +                     'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ENDIF
 40      CONTINUE
 20   CONTINUE
C
C     -- ALLOCATION DE TABLEAUX DE TRAVAIL
C    -------------------------------------
      CALL WKVECT ('&&CALIAI.LISTE1','V V K8',NDIM1,JLIST1)
      CALL WKVECT ('&&CALIAI.LISTE2','V V K8',NDIM2,JLIST2)
      CALL WKVECT ('&&CALIAI.DDL  ','V V K8',NDIM2  ,JDDL  )
      CALL WKVECT ('&&CALIAI.COEMUR','V V R' ,NDIM2  ,JCMUR  )
      CALL WKVECT ('&&CALIAI.COEMUC','V V C' ,NDIM2  ,JCMUC  )
      CALL WKVECT ('&&CALIAI.DIRECT','V V R' ,3*NDIM2  ,JDIREC  )
      CALL WKVECT ('&&CALIAI.DIMENSION','V V I' ,NDIM2  ,JDIME  )
C
C     BOUCLE SUR LES RELATIONS LINEAIRES
C     -----------------------------------
      DO 50 I = 1, NLIAI
         CALL GETVR8 (MOTFAC,'COEF_MULT',I,1,NDIM2,ZR(JCMUR),N2)
         CALL GETVTX (MOTFAC,'DDL',I,1,NDIM2,ZK8(JDDL),N1)
C
         TYPCOE = 'REEL'
C
C        EXCEPTION :SI LE MOT-CLE DDL N'EXISTE PAS DANS AFFE_CHAR_THER,
C        ON CONSIDERE QUE LES RELATIONS LINEAIRES PORTENT
C        SUR LE DDL 'TEMP'
         IF (N1.EQ.0.AND.TYPCHA(1:4).EQ.'THER')  THEN
           N1 = NDIM2
           DO 60 K=1,N1
             ZK8(JDDL-1+K) = 'TEMP'
 60        CONTINUE
         ENDIF

        IF (N1.NE.N2) THEN
         CALL UTDEBM('F','CALIAI','LE NOMBRE DE DDLS FIGURANT DANS'
     +    //' LA LIAISON N''EST PAS EGAL AU NOMBRE DE COEF_MULT :')
          CALL UTIMPI('S',' ',1,N1)
          CALL UTIMPI('S',' ',1,N2)
          CALL UTFINM()
        ENDIF


C       -- RECUPERATION DU 2ND MEMBRE :
C       ------------------------------
        IF (FONREE.EQ.'REEL') THEN
           CALL GETVR8 (MOTFAC, 'COEF_IMPO', I, 1, 1,BETA, NB)
           TYPVAL = 'REEL'
        ELSE IF (FONREE.EQ.'FONC') THEN
           CALL GETVID(MOTFAC,'COEF_IMPO',I,1,1,BETAF,NB)
           TYPVAL = 'FONC'
        ELSE IF (FONREE.EQ.'COMP') THEN
           CALL GETVC8 (MOTFAC, 'COEF_IMPO', I, 1, 1,BETAC, NB)
           TYPVAL = 'COMP'
        ELSE
           CALL UTMESS('F','CALIAI','CAS NON PREVU')
        ENDIF
C
C
         CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO',
     +          I,1,0,ZK8(JLIST1),NG)
         IF (NG .NE.0) THEN
C
C           -- CAS DE GROUP_NO :
C           --------------------
            NG = -NG
            CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO',
     +             I,1,NG,ZK8(JLIST1),N)
            INDNOE = 0
            DO 80 J = 1, NG
               CALL JEVEUO (JEXNOM(GROUMA,ZK8(JLIST1-1+J)),'L',JGR0)
               CALL JELIRA (JEXNOM(GROUMA,ZK8(JLIST1-1+J)),'LONMAX',
     +                      N,K1BID)
               DO 90 K = 1, N
                  IN = ZI(JGR0-1+K)
                  INDNOE = INDNOE + 1
                  CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
                  ZK8(JLIST2+INDNOE-1) = NOMNOE
  90           CONTINUE
  80        CONTINUE
C
C           -- ON VERIFIE QUE LE NOMBRE DE NOEUDS DES GROUP_NO
C              EST EGAL AU NOMBRE DE DDLS DE LA RELATION :
C              -----------------------------------------
            IF (N1.NE.INDNOE) THEN
             CALL UTDEBM('F','CALIAI','LE NOMBRE DE DDLS FIGURANT DANS'
     +    //' LA LIAISON N''EST PAS EGAL AU NOMBRE DE NOEUDS :')
             CALL UTIMPI('S',' ',1,N1)
             CALL UTIMPI('S',' ',1,INDNOE)
             CALL UTFINM()
            ENDIF
C
C           AFFECTATION A LA LISTE DE RELATIONS
C
            CALL AFRELA(ZR(JCMUR),ZC(JCMUC),ZK8(JDDL),ZK8(JLIST2),
     +            ZI(JDIME),ZR(JDIREC),INDNOE,BETA,BETAC,BETAF,
     +            TYPCOE, TYPVAL, TYPLAG, LISREL )
C
         ELSE
C
C           CAS DE NOEUD :
C           -------------
            CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD',
     +          I,1,0,ZK8(JLIST1),NBNO)
            IF (NBNO .NE. 0) THEN
                NBNO=-NBNO
                CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD',
     +              I,1,NBNO,ZK8(JLIST1),N)
            ENDIF
C
C           -- ON VERIFIE QUE LE NOMBRE DE NOEUDS DE LA LISTE DE
C              NOEUDS EST EGAL AU NOMBRE DE DDLS DE LA RELATION :
C              ------------------------------------------------
            IF (N1.NE.NBNO) THEN
             CALL UTDEBM('F','CALIAI','LE NOMBRE DE DDLS FIGURANT DANS'
     +    //' LA LIAISON N''EST PAS EGAL AU NOMBRE DE NOEUDS :')
             CALL UTIMPI('S',' ',1,N1)
             CALL UTIMPI('S',' ',1,NBNO)
             CALL UTFINM()
            ENDIF
            CALL AFRELA(ZR(JCMUR),ZC(JCMUC),ZK8(JDDL),ZK8(JLIST1),
     +              ZI(JDIME),ZR(JDIREC),NBNO,BETA,BETAC,BETAF,
     +              TYPCOE, TYPVAL, TYPLAG, LISREL )
         ENDIF
C
  50  CONTINUE
C
C     -- AFFECTATION DE LA LISTE_RELA A LA CHARGE :
C     ---------------------------------------------
      CALL AFLRCH(LISREL,CHARGE)
C
C     -- MENAGE :
C     -----------
      CALL JEDETR (TRAV)
      CALL JEDETR ('&&CALIAI.LISTE1')
      CALL JEDETR ('&&CALIAI.LISTE2')
      CALL JEDETR ('&&CALIAI.DDL  ')
      CALL JEDETR ('&&CALIAI.COEMUR')
      CALL JEDETR ('&&CALIAI.COEMUC')
      CALL JEDETR ('&&CALIAI.DIRECT')
      CALL JEDETR ('&&CALIAI.DIMENSION')
C
 9999 CONTINUE
      CALL JEDEMA()
      END
