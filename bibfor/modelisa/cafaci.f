      SUBROUTINE CAFACI(FONREE, CHAR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 22/01/2004   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_20
      IMPLICIT NONE
C
      CHARACTER*4               FONREE
      CHARACTER*8                       CHAR
C
C     BUT: CREER LES CARTES CHAR.CHME.CMULT ET CHAR.CHME.CIMPO
C          ET REMPLIR LIGRCH POUR FACE_IMPO
C
C ARGUMENTS D'ENTREE:
C      FONREE  : TYPE DE LA VALEUR IMPOSEE :
C                REEL OU FONC OU COMP
C      CHAR  : NOM UTILISATEUR DU RESULTAT DE CHARGE
C
C ROUTINES APPELEES:
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      INTEGER      NMOCL
      PARAMETER    (NMOCL=300)
C
      INTEGER      I,J,K,N,JGROUP,JLISTI,JLISTK,JJJ,IGR,NGR,NGRO,NENT
      INTEGER      NBNOEU,JVAL,NDDLA,JDIREC,NBML,NG,NBNO
      INTEGER      IDIM,IN,JNORM,JTANG,JNUNOE,JNBN,JNONO,NFACI,NBGM
      INTEGER      NBGT,NBET,NBEGT,IBID,JNOMA,IER,IOCC,NDIM,NNO
      INTEGER      NBEM,NBEGM,IRET,N1,N2,INO,JPRNM,NBEC,NMCL,INOR,ICMP
      INTEGER      NCMP,NBTYP,IE,NBMA,JGR0

      INTEGER      DDLIMP(NMOCL)
      REAL*8       VALIMR(NMOCL), COEF(3), DIRECT(3)
      COMPLEX*16   VALIMC(NMOCL), COEFC(3)
      CHARACTER*2  TYPLAG
      CHARACTER*3  TYMOCL(NMOCL)
      CHARACTER*3  CDIM
      CHARACTER*4  TYPCOE
      CHARACTER*8  MOMA, MOGROU, K8BID, NOMA, MOD, LITYP(10)
      CHARACTER*8  VALIMF(NMOCL), NOMNOE, DDL(3), NOEUD(3)
      CHARACTER*16 MOTFAC, MOTCLE(NMOCL)
      CHARACTER*24 TRAV, OBJ1, OBJ2, GRMA
      CHARACTER*19 LIGRMO
      CHARACTER*19  LISREL
      CHARACTER*1 K1BID
C
      CALL JEMARQ()
      CALL GETFAC ('FACE_IMPO',NFACI)
      IF (NFACI.EQ.0) GOTO 9999
C
      LISREL = '&&CAFACI.RLLISTE'
C
      MOTFAC  = 'FACE_IMPO     '
      MOMA    = 'MAILLE  '
      MOGROU  = 'GROUP_MA'
      TYPLAG  = '12'
C
      DDL(1) = 'DX      '
      DDL(2) = 'DY      '
      DDL(3) = 'DZ      '
C
      NBGM  = 0
      NBEM  = 0
      NBEGM = 0
      NBGT  = 0
      NBET  = 0
      NBEGT = 0
C
      COEFC(1) = (1.0D0,0.0D0)
      COEFC(2) = (1.0D0,0.0D0)
      COEFC(3) = (1.0D0,0.0D0)
C
      TYPCOE = 'REEL'
      IF (FONREE.EQ.'COMP') THEN
        TYPCOE = 'COMP'
      ENDIF
C
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
C
      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,MOD,IER)
C
C ---  LIGREL DU MODELE ---
C
      LIGRMO = MOD(1:8)//'.MODELE'
C
C --- MAILLAGE ASSOCIE AU MODELE ---
C
      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
C
      OBJ1 = NOMA//'.GROUPE'//'MA'
      OBJ2 = NOMA//'.NOMMAI'
C
      DO 10 IOCC = 1, NFACI
         CALL GETVID(MOTFAC,MOGROU,IOCC,1,0,K8BID,NGRO)
         CALL GETVID(MOTFAC,MOMA,IOCC,1,0,K8BID,NENT)
         NGRO = -NGRO
         NBGM = MAX(NBGM,NGRO)
         NBGT = NBGT + NGRO
         NENT = -NENT
         NBEM = MAX(NBEM,NENT)
         NBET = NBET + NENT
 10   CONTINUE
C
      NDIM = MAX(NBGM,NBEM)
      IF (NDIM .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,'IL N''Y A AUCUN GROUPE DE '//
     +                   'MAILLES NI AUCUNE MAILLE DEFINI APRES LE '//
     +                   'MOT FACTEUR '//MOTFAC )
      ENDIF
      TRAV = '&&CAFACI.'//MOTFAC
      CALL WKVECT(TRAV,'V V K8',NDIM,JJJ)
      DO 20 IOCC = 1, NFACI
         CALL GETVID(MOTFAC,MOGROU,IOCC,1,NDIM,ZK8(JJJ),NGR)
         DO 30 IGR = 1, NGR
            CALL JEEXIN (JEXNOM(OBJ1,ZK8(JJJ+IGR-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,'LE GROUPE '//ZK8(JJJ+IGR-1)//
     +                      'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ELSE
               CALL JELIRA (JEXNOM(OBJ1,ZK8(JJJ+IGR-1)),'LONMAX',N1,
     +                      K1BID)
               NBEGM = MAX(NBEGM,N1)
               NBEGT = NBEGT + N1
            ENDIF
 30      CONTINUE
         CALL GETVID(MOTFAC,MOMA,IOCC,1,NDIM,ZK8(JJJ),NNO)
         DO 40 INO = 1, NNO
            CALL JENONU (JEXNOM(OBJ2,ZK8(JJJ+INO-1)),IRET)
            IF (IRET .EQ. 0) THEN
            CALL UTMESS('F',MOTFAC,MOMA//' '//ZK8(JJJ+INO-1)//
     +                     'NE FAIT PAS PARTIE DU MAILLAGE : '//NOMA )
            ENDIF
 40      CONTINUE
 20   CONTINUE

C
C ---------------------------------------------------
C *** RECUPERATION DU DESCRIPTEUR GRANDEUR .PRNM
C *** DU MODELE
C ---------------------------------------------------
      CALL DISMOI('F','NB_NO_MAILLA',LIGRMO,'LIGREL',N1,K8BID,IER)
      CALL JELIRA (LIGRMO//'.PRNM','LONMAX',N2,K1BID)
      NBEC= N2/N1
      IF (NBEC.GT.10) THEN
         CALL UTMESS('F','CAFACI',
     +                   'LE DESCRIPTEUR_GRANDEUR DES DEPLACEMENTS'//
     +                    ' NE TIENT PAS SUR DIX ENTIERS CODES')
      ELSE
         CALL JEVEUO (LIGRMO//'.PRNM','L',JPRNM)
      END IF
C
      NBGT  = MAX(NBGT,1)
      NBET  = MAX(NBET,1)
      NBEGT = MAX(NBEGT,1)
C     ---------------------------------
C     ALLOCATION DE TABLEAUX DE TRAVAIL
C     ---------------------------------
      CALL WKVECT ('&&CAFACI.GROUP','V V K8',NBGT, JGROUP)
      CALL WKVECT ('&&CAFACI.LISTI','V V I' ,NBEGT,JLISTI)
      CALL WKVECT ('&&CAFACI.LISTK','V V K8',NBET, JLISTK)
C     --------------------------------------------------------
C     RECUPERATION DE LA DIMENSION DE L'ESPACE DES COORDONNEES
C     --------------------------------------------------------
      CALL DISMOI('F','Z_CST' ,MOD,'MODELE',IBID,CDIM,IE)
      IF (CDIM.EQ.'OUI') THEN
        NDIM=2
      ELSE
        NDIM=3
      END IF

      IF (NDIM.EQ.2) THEN
         NBTYP=3
         LITYP(1)='SEG2'
         LITYP(2)='SEG3'
         LITYP(3)='SEG4'
      ELSE IF (NDIM.EQ.3) THEN
         NBTYP=10
         LITYP(1)='TRIA3'
         LITYP(2)='TRIA6'
         LITYP(3)='TRIA9'
         LITYP(4)='QUAD4'
         LITYP(5)='QUAD8'
         LITYP(6)='QUAD9'
         LITYP(7)='QUAD12'
         LITYP(8)='SEG2'
         LITYP(9)='SEG3'
         LITYP(10)='SEG4'
      END IF
C      ***************************************
C      TRAITEMENT DES COMPOSANTES DNOR ET DTAN
C      ***************************************
C
C     MISE A JOUR DE LIGRCH ET STOCKAGE DANS LES CARTES
C
      DO 70 I = 1, NFACI
        NCMP=0
        ICMP = 0
        INOR = 0
C ---------------------------------------------------
C     RECUPERATION DES MOTS-CLES DDL SOUS FACE_IMPO
C     MOTCLE(J) : K8 CONTENANT LE J-EME MOT-CLE DDL
C     NDDLA     : NOMBRE DE MOTS CLES DU TYPE DDL
C ---------------------------------------------------
        CALL GETMJM('FACE_IMPO',I-1,0  ,MOTCLE,TYMOCL,N)
        NMCL = -N
        IF (NMCL.GT.NMOCL) THEN
          CALL UTDEBM('F','CAFACI','NOMBRE DE MOTCLES SUPERIEUR AU MAX')
          CALL UTIMPI('L','NMAXOCL= ',1,NMOCL)
          CALL UTIMPI('L','NMOCL  = ',1,NMCL)
          CALL UTFINM()
        ENDIF
        CALL GETMJM('FACE_IMPO',I-1,NMCL,MOTCLE,TYMOCL,N)
        NDDLA =1
        DO 50 J = 1, NMCL
          IF(MOTCLE(J).NE.'MAILLE'.AND.MOTCLE(J).NE.'GROUP_MA'.AND.
     +      MOTCLE(J).NE.'DNOR'.AND.MOTCLE(J).NE.'DTAN') THEN
            MOTCLE(NDDLA) = MOTCLE(J)
            NDDLA = NDDLA + 1
          ENDIF
50      CONTINUE
        NDDLA = NDDLA - 1
        MOTCLE(NDDLA+1) = 'DNOR'
        MOTCLE(NDDLA+2) = 'DTAN'
        IF (FONREE.EQ.'REEL') THEN
         DO 80 J=1,NDDLA+2
           CALL GETVR8('FACE_IMPO',MOTCLE(J),I,1,1,VALIMR(J),DDLIMP(J))
           IF (J.LE.NDDLA) THEN
              ICMP = ICMP+DDLIMP(J)
           ELSE
              INOR = INOR+DDLIMP(J)
           ENDIF
80       CONTINUE
         IF (NDIM.EQ.3.AND.DDLIMP(NDDLA+2).NE.0) THEN
           CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'
     +     //' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     +     //'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL')
         ENDIF
        ELSE
         DO 90 J=1,NDDLA+2
           CALL GETVID('FACE_IMPO',MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
           IF (J.LE.NDDLA) THEN
              ICMP = ICMP+DDLIMP(J)
           ELSE
              INOR = INOR+DDLIMP(J)
           ENDIF
90       CONTINUE
         IF (NDIM.EQ.3.AND.DDLIMP(NDDLA+2).NE.0) THEN
           CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'
     +     //' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     +   //'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL')
         END IF
        END IF
        NCMP=NCMP+ICMP
C    ------------------------------------------------------
C    FILTRAGE SUR LES COMPOSANTES NORMALES OU TANGENTIELLES
C    ------------------------------------------------------
        IF(INOR.NE.0.AND.ICMP.EQ.0) THEN
C
C        ---------------
C        CAS DE GROUP_MA
C        ---------------
         CALL GETVEM(NOMA,'GROUP_MA','FACE_IMPO','GROUP_MA',
     +               I,1,0,ZK8(JGROUP),NG)
         IF (NG .NE.0) THEN
            NG = -NG
            CALL GETVEM(NOMA,'GROUP_MA','FACE_IMPO','GROUP_MA',
     +                  I,1,NG,ZK8(JGROUP),N)
            GRMA=NOMA//'.GROUPEMA'
            NBMA=0
            DO 100 J = 1, NG
               CALL JEVEUO (JEXNOM(GRMA,ZK8(JGROUP-1+J)),'L',JGR0)
               CALL JELIRA (JEXNOM(GRMA,ZK8(JGROUP-1+J)),'LONMAX',N,
     +                      K1BID)
               DO 110 K = 1, N
                  ZI(JLISTI-1+NBMA+K) = ZI(JGR0-1+K)
  110          CONTINUE
               NBMA=NBMA+N
  100       CONTINUE
            CALL NBNLMA(NOMA,NBMA,ZI(JLISTI),' ',NBTYP,LITYP,NBNO)
            CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
            CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)
C
         ENDIF
C        -------------------------------------
C        CAS DE MAILLE,NBMA < 0 , C'EST NORMAL
C        -------------------------------------
         CALL GETVEM(NOMA,'MAILLE','FACE_IMPO','MAILLE',
     +             I,1,0,ZK8(JLISTK),NBML)
         IF (NBML .NE. 0) THEN
            NBML = -NBML
            CALL GETVEM(NOMA,'MAILLE','FACE_IMPO','MAILLE',
     +                I,1,NBML,ZK8(JLISTK),N)
            CALL NBNLMA(NOMA,-NBML,0,ZK8(JLISTK),NBTYP,LITYP,NBNO)
            CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
            CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)
C
            NBMA=-NBML
         ENDIF
C   -------------------------------------------
C   CALCUL DES NORMALES ET TANGENTES AUX NOEUDS
C   -------------------------------------------
         IF(DDLIMP(NDDLA+1).NE.0) THEN
             CALL CANORT(NOMA,NBMA,ZI(JLISTI),ZK8(JLISTK),NDIM,NBNO,
     +               ZI(JNBN),ZI(JNUNOE),1)
             CALL JEVEUO('&&CANORT.NORMALE','L',JNORM)
         ENDIF
         IF(DDLIMP(NDDLA+2).NE.0) THEN
             CALL CANORT(NOMA,NBMA,ZI(JLISTI),ZK8(JLISTK),NDIM,NBNO,
     +               ZI(JNBN),ZI(JNUNOE),2)
             CALL JEVEUO('&&CANORT.TANGENT','L',JTANG)
         ENDIF
C   ----------------------
C   AFFECTATION DES COMPOSANTES DE LA RELATION A LA RELATION COURANTE
C   ----------------------
         COEF(1) = 1.0D0
         DDL(1) = 'DEPL'
         DO 120 INO=1,NBNO
           IN=ZI(JNUNOE+INO-1)
           CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
           IF (DDLIMP(NDDLA+1).NE.0) THEN
               DO  130 IDIM=1,NDIM
                  DIRECT(IDIM) = ZR(JNORM-1+NDIM*(INO-1)+IDIM)
 130           CONTINUE
               CALL AFRELA(COEF,COEFC,DDL,NOMNOE,NDIM,DIRECT,1,
     +                     VALIMR(NDDLA+1),VALIMC(NDDLA+1),
     +                     VALIMF(NDDLA+1),TYPCOE,FONREE,TYPLAG,LISREL)
           ENDIF
           IF (DDLIMP(NDDLA+2).NE.0) THEN
               DO  140 IDIM=1,NDIM
                  DIRECT(IDIM) = ZR(JTANG-1+NDIM*(INO-1)+IDIM)
 140          CONTINUE
               CALL AFRELA(COEF,COEFC,DDL,NOMNOE,NDIM,DIRECT,1,
     +                     VALIMR(NDDLA+2),VALIMC(NDDLA+2),
     +                     VALIMF(NDDLA+2),TYPCOE,FONREE,TYPLAG,LISREL)
           ENDIF
 120     CONTINUE
        ENDIF
C
C      ***************************************************
C      TRAITEMENT DES COMPOSANTES DX DY DZ DRX DRY DRZ ...
C      ***************************************************
C
        IF(NCMP.EQ.0) GOTO 9998
C
C     RECUPERATION DES DONNEES DU MOT-CLE FACTEUR ET PRISE EN COMPTE
C     DE LA SURCHARGE
C
C ---------------------------------------------------
C     RECUPERATION DES MOTS-CLES DDL SOUS FACE_IMPO
C     MOTCLE(J) : K8 CONTENANT LE J-EME MOT-CLE DDL
C     NDDLA     : NOMBRE DE MOTS CLES DU TYPE DDL
C ---------------------------------------------------
        CALL GETMJM('FACE_IMPO',I-1,0  ,MOTCLE,TYMOCL,N)
        NMCL = -N
        IF (NMCL.GT.NMOCL) THEN
          CALL UTDEBM('F','CAFACI','NOMBRE DE MOTCLES SUPERIEUR AU MAX')
          CALL UTIMPI('L','NMAXOCL= ',1,NMOCL)
          CALL UTIMPI('L','NMOCL  = ',1,NMCL)
          CALL UTFINM()
        ENDIF
        CALL GETMJM('FACE_IMPO',I-1,NMCL,MOTCLE,TYMOCL,N)
        NDDLA =1
        DO 155 J = 1, NMCL
          IF(MOTCLE(J).NE.'MAILLE'.AND.MOTCLE(J).NE.'GROUP_MA'.AND.
     +      MOTCLE(J).NE.'DNOR'.AND.MOTCLE(J).NE.'DTAN') THEN
            MOTCLE(NDDLA) = MOTCLE(J)
            NDDLA = NDDLA + 1
          ENDIF
155     CONTINUE
        NDDLA = NDDLA - 1
C
        CALL JELIRA(NOMA//'.NOMNOE','NOMMAX',NBNOEU,K1BID)
C
C    ALLOCATION DE 3 OBJETS INTERMEDIAIRES PERMETTANT D'APPLIQUER
C    LA REGLE DE SURCHARGE :
C
C       	- VECTEUR (K8) CONTENANT LES NOMS DES NOEUDS
C       	- TABLEAU DES VALEURS DES DDLS DES NOEUDS BLOQUES
C       	  DIM NBNOEU * NBCOMP
C       	- VECTEUR (IS) CONTENANT LE DESCRIPTEUR GRANDEUR
C       	  ASSOCIE AUX DDLS IMPOSES PAR NOEUD
C
        CALL WKVECT('&&CAFACI.NOMS_NOEUDS','V V K8',NBNOEU,JNONO)
        IF (FONREE.EQ.'REEL') THEN
         CALL WKVECT('&&CAFACI.VALDDL','V V R',NDDLA*NBNOEU,JVAL)
        ELSE
         CALL WKVECT('&&CAFACI.VALDDL','V V K8',NDDLA*NBNOEU,JVAL)
        ENDIF
C
        CALL WKVECT('&&CAFACI.DIRECT','V V R',3*NBNOEU,JDIREC)
C
        MOTCLE(NDDLA+1) = 'DNOR'
        MOTCLE(NDDLA+2) = 'DTAN'
        ICMP = 0
        INOR = 0
        IF (FONREE.EQ.'REEL') THEN
          DO 160 J=1,NDDLA+2
            CALL GETVR8('FACE_IMPO',MOTCLE(J),I,1,1,VALIMR(J),DDLIMP(J))
            IF (NDIM.EQ.3.AND.DDLIMP(NDDLA+2).NE.0) THEN
              CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'
     +        //' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     +        //'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL')
            ENDIF
            IF (J.LE.NDDLA) THEN
               ICMP = ICMP+DDLIMP(J)
            ELSE
               INOR = INOR+DDLIMP(J)
            ENDIF
160       CONTINUE
        ELSE
          DO 170 J=1,NDDLA+2
            CALL GETVID('FACE_IMPO',MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
            IF (NDIM.EQ.3.AND.DDLIMP(NDDLA+2).NE.0) THEN
              CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'
     +        //' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     +        //'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL')
            END IF
            IF (J.LE.NDDLA) THEN
               ICMP = ICMP+DDLIMP(J)
            ELSE
               INOR = INOR+DDLIMP(J)
            ENDIF
170       CONTINUE
         END IF
         IF (INOR.EQ.0) THEN
C        ---------------
C        CAS DE GROUP_MA
C        ---------------
         CALL GETVEM(NOMA,'GROUP_MA','FACE_IMPO','GROUP_MA',
     +               I,1,0,ZK8(JGROUP),NG)
         IF (NG .NE.0) THEN
            NG = -NG
            CALL GETVEM(NOMA,'GROUP_MA','FACE_IMPO','GROUP_MA',
     +                  I,1,NG,ZK8(JGROUP),N)
            GRMA=NOMA//'.GROUPEMA'
            NBMA=0
            DO 180 J = 1, NG
               CALL JEVEUO (JEXNOM(GRMA,ZK8(JGROUP-1+J)),'L',JGR0)
               CALL JELIRA (JEXNOM(GRMA,ZK8(JGROUP-1+J)),'LONMAX',
     +                      N,K1BID)
               DO 190 K = 1, N
                  ZI(JLISTI-1+NBMA+K) = ZI(JGR0-1+K)
  190          CONTINUE
               NBMA=NBMA+N
  180       CONTINUE
            CALL NBNLMA(NOMA,NBMA,ZI(JLISTI),' ',NBTYP,LITYP,NBNO)
            CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
            CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)
C
            DO 200 INO = 1, NBNO
               IN = ZI(JNUNOE-1+INO)
               CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
               ZK8(JNONO-1+IN) = NOMNOE
               CALL AFDDLI(ZR(JVAL),ZK8(JVAL),ZC(JVAL),
     +             ZI(JPRNM-1+(IN-1)*NBEC+1),
     +             NDDLA,FONREE,NOMNOE,IN,DDLIMP,
     +             VALIMR,VALIMF,VALIMC,MOTCLE,NBEC,
     +             ZR(JDIREC+3*(IN-1)),0,LISREL)
  200       CONTINUE
C
         ENDIF
C        -------------------------------------
C        CAS DE MAILLE,NBNO < 0 , C'EST NORMAL
C        -------------------------------------
         CALL GETVEM(NOMA,'MAILLE','FACE_IMPO','MAILLE',
     +             I,1,0,ZK8(JLISTK),NBML)
         IF (NBML .NE. 0) THEN
            NBML = -NBML
            CALL GETVEM(NOMA,'MAILLE','FACE_IMPO','MAILLE',
     +                I,1,NBML,ZK8(JLISTK),N)
            CALL NBNLMA(NOMA,-NBML,0,ZK8(JLISTK),NBTYP,LITYP,NBNO)
            CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
            CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)
C
            DO 210 INO = 1, NBNO
               IN = ZI(JNUNOE-1+INO)
               CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
               ZK8(JNONO-1+IN) = NOMNOE
               CALL AFDDLI(ZR(JVAL),ZK8(JVAL),ZC(JVAL),
     +             ZI(JPRNM-1+(IN-1)*NBEC+1),
     +             NDDLA,FONREE,NOMNOE,IN,DDLIMP,
     +             VALIMR,VALIMF,VALIMC,MOTCLE,NBEC,
     +             ZR(JDIREC+3*(IN-1)),0,LISREL)
  210       CONTINUE
C
            NBMA=NBML
           ENDIF
         ENDIF
         CALL JEEXIN ('&&CAFACI.NOMS_NOEUDS',IRET)
         IF (IRET.NE.0) CALL JEDETR ('&&CAFACI.NOMS_NOEUDS')
         CALL JEEXIN ('&&CAFACI.VALDDL',IRET)
         IF (IRET.NE.0) CALL JEDETR ('&&CAFACI.VALDDL')
         CALL JEEXIN ('&&NBNLMA.LN',IRET)
         CALL JEEXIN ('&&CAFACI.DIRECT',IRET)
         IF (IRET.NE.0) CALL JEDETR ('&&CAFACI.DIRECT')
C
 9998    CONTINUE
C
  70  CONTINUE
C        -------------------------------------
C        AFFECTATION DE LA LISTE DE RELATIONS A LA CHARGE
C        (I.E. AFFECTATION DES OBJETS .CMULT, .CIMPO,
C        LIGRCH ET .NEMA)
C        -------------------------------------
      CALL AFLRCH(LISREL, CHAR)
C
      CALL JEDETR ('&&CAFACI.GROUP')
      CALL JEDETR ('&&CAFACI.LISTK')
      CALL JEDETR ('&&CAFACI.LISTI')
      CALL JEDETR (TRAV)
 9999 CONTINUE
      CALL JEEXIN ('&&NBNLMA.LN',IRET)
      IF (IRET.NE.0) CALL JEDETR ('&&NBNLMA.LN')
      CALL JEEXIN ('&&NBNLMA.NBN',IRET)
      IF (IRET.NE.0) CALL JEDETR ('&&NBNLMA.NBN')
      CALL JEEXIN ('&&CANORT.NORMALE',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&CANORT.NORMALE')
      CALL JEEXIN ('&&CANORT.TANGENT',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&CANORT.TANGENT')
C
      CALL JEDEMA()
      END
