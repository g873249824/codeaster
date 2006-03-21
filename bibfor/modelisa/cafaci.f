      SUBROUTINE CAFACI ( FONREE, CHAR )
      IMPLICIT   NONE
      CHARACTER*4         FONREE
      CHARACTER*8                 CHAR
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/03/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_20

C     BUT: CREER LES CARTES CHAR.CHME.CMULT ET CHAR.CHME.CIMPO
C          ET REMPLIR LIGRCH POUR FACE_IMPO

C ARGUMENTS D'ENTREE:
C      FONREE  : TYPE DE LA VALEUR IMPOSEE :
C                REEL OU FONC OU COMP
C      CHAR  : NOM UTILISATEUR DU RESULTAT DE CHARGE

C ROUTINES APPELEES:
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------

      INTEGER NMOCL
      PARAMETER (NMOCL=300)

      INTEGER I,J,K,N,JLISTI,IGR,NGR,NGRO,NENT
      INTEGER NBNOEU,JVAL,NDDLA,JDIREC,NBML,NG,NBNO
      INTEGER IDIM,IN,JNORM,JTANG,JNUNOE,JNBN,JNONO,NFACI,NBGM
      INTEGER IBID,JNOMA,IER,IOCC,NDIM,NNO
      INTEGER IRET,N1,N2,INO,JPRNM,NBEC,NMCL,INOR,ICMP
      INTEGER NCMP,NBTYP,IE,NBMA,JGR0,NBCMP,INOM

      INTEGER DDLIMP(NMOCL)
      REAL*8 VALIMR(NMOCL),COEF(3),DIRECT(3)
      COMPLEX*16 VALIMC(NMOCL),COEFC(3)
      CHARACTER*2 TYPLAG
      CHARACTER*3 TYMOCL(NMOCL)
      CHARACTER*3 CDIM
      CHARACTER*4 TYPCOE
      CHARACTER*8 K8B,NOMA,MOD,LITYP(10),NOMG
      CHARACTER*8 VALIMF(NMOCL),NOMNOE,DDL(3),NOEUD(3)
      CHARACTER*16 MOTFAC,MOTCLE(NMOCL),NOMCMD,TYPMCL(2),MOCLM(2)
      CHARACTER*24 GRMA,MESMAI
      CHARACTER*19 LIGRMO
      CHARACTER*19 LISREL
      CHARACTER*1 K1BID

      CALL JEMARQ()
      CALL GETFAC('FACE_IMPO',NFACI)
      IF (NFACI.EQ.0) GO TO 220
      CALL GETRES(K8B,K8B,NOMCMD)

      LISREL = '&&CAFACI.RLLISTE'

      MESMAI = '&&CAFACI.MES_MAILLES'
      MOTFAC = 'FACE_IMPO     '
      MOCLM(1) = 'MAILLE'
      MOCLM(2) = 'GROUP_MA'
      TYPMCL(1) = 'MAILLE'
      TYPMCL(2) = 'GROUP_MA'
      TYPLAG = '12'

      DDL(1) = 'DX      '
      DDL(2) = 'DY      '
      DDL(3) = 'DZ      '

      COEFC(1) = (1.0D0,0.0D0)
      COEFC(2) = (1.0D0,0.0D0)
      COEFC(3) = (1.0D0,0.0D0)

      TYPCOE = 'REEL'
      IF (FONREE.EQ.'COMP')  TYPCOE = 'COMP'

C --- MODELE ASSOCIE AU LIGREL DE CHARGE ---

      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,MOD,IER)

C ---  LIGREL DU MODELE ---

      LIGRMO = MOD(1:8)//'.MODELE'

      IF (NOMCMD(11:14).EQ.'MECA') THEN
         NOMG='DEPL_R'
      ELSE IF (NOMCMD(11:14).EQ.'THER') THEN
         NOMG='TEMP_R'
      ELSE IF (NOMCMD(11:14).EQ.'ACOU') THEN
         NOMG='PRES_C'
      ELSE
         CALL ASSERT(.FALSE.)
      END IF
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)

C --- MAILLAGE ASSOCIE AU MODELE ---

      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)

C ---------------------------------------------------
C *** RECUPERATION DU DESCRIPTEUR GRANDEUR .PRNM
C *** DU MODELE
C ---------------------------------------------------
      CALL DISMOI('F','NB_NO_MAILLA',LIGRMO,'LIGREL',N1,K8B,IER)
      CALL JELIRA(LIGRMO//'.PRNM','LONMAX',N2,K1BID)
      NBEC = N2/N1
      IF (NBEC.GT.10) THEN
        CALL UTMESS('F','CAFACI',
     &              'LE DESCRIPTEUR_GRANDEUR DES DEPLACEMENTS'//
     &              ' NE TIENT PAS SUR DIX ENTIERS CODES')
      ELSE
        CALL JEVEUO(LIGRMO//'.PRNM','L',JPRNM)
      END IF

C     --------------------------------------------------------
C     RECUPERATION DE LA DIMENSION DE L'ESPACE DES COORDONNEES
C     --------------------------------------------------------
      CALL DISMOI('F','Z_CST',MOD,'MODELE',IBID,CDIM,IE)
      IF (CDIM.EQ.'OUI') THEN
        NDIM = 2
      ELSE
        NDIM = 3
      END IF

      IF (NDIM.EQ.2) THEN
        NBTYP = 3
        LITYP(1) = 'SEG2'
        LITYP(2) = 'SEG3'
        LITYP(3) = 'SEG4'
      ELSE IF (NDIM.EQ.3) THEN
        NBTYP = 10
        LITYP(1) = 'TRIA3'
        LITYP(2) = 'TRIA6'
        LITYP(3) = 'TRIA9'
        LITYP(4) = 'QUAD4'
        LITYP(5) = 'QUAD8'
        LITYP(6) = 'QUAD9'
        LITYP(7) = 'QUAD12'
        LITYP(8) = 'SEG2'
        LITYP(9) = 'SEG3'
        LITYP(10) = 'SEG4'
      END IF

C      ***************************************
C      TRAITEMENT DES COMPOSANTES DNOR ET DTAN
C      ***************************************

      DO 210 I = 1,NFACI
        NCMP = 0
        ICMP = 0
        INOR = 0
C
C ----- RECUPERATION DES MAILLES
C
        CALL RELIEM ( ' ', NOMA, 'NU_MAILLE', MOTFAC, I, 2,
     +                                    MOCLM, TYPMCL, MESMAI, NBMA )
        CALL JEVEUO ( MESMAI, 'L', JLISTI )
C ---------------------------------------------------
C     RECUPERATION DES MOTS-CLES DDL SOUS FACE_IMPO
C     MOTCLE(J) : K8 CONTENANT LE J-EME MOT-CLE DDL
C     NDDLA     : NOMBRE DE MOTS CLES DU TYPE DDL
C ---------------------------------------------------
        CALL GETMJM('FACE_IMPO',I,0,MOTCLE,TYMOCL,N)
        NMCL = -N
        IF (NMCL.GT.NMOCL) THEN
          CALL UTDEBM('F','CAFACI','NOMBRE DE MOTCLES SUPERIEUR AU MAX')
          CALL UTIMPI('L','NMAXOCL= ',1,NMOCL)
          CALL UTIMPI('L','NMOCL  = ',1,NMCL)
          CALL UTFINM()
        END IF
        CALL GETMJM('FACE_IMPO',I,NMCL,MOTCLE,TYMOCL,N)
        NDDLA = 1
        DO 50 J = 1,NMCL
          IF (MOTCLE(J).NE.'MAILLE' .AND. MOTCLE(J).NE.'GROUP_MA' .AND.
     &        MOTCLE(J).NE.'DNOR' .AND. MOTCLE(J).NE.'DTAN') THEN
            MOTCLE(NDDLA) = MOTCLE(J)
            NDDLA = NDDLA + 1
          END IF
   50   CONTINUE
        NDDLA = NDDLA - 1
        MOTCLE(NDDLA+1) = 'DNOR'
        MOTCLE(NDDLA+2) = 'DTAN'
        IF (FONREE.EQ.'REEL') THEN
          DO 60 J = 1,NDDLA + 2
            CALL GETVR8('FACE_IMPO',MOTCLE(J),I,1,1,VALIMR(J),DDLIMP(J))
            IF (J.LE.NDDLA) THEN
              ICMP = ICMP + DDLIMP(J)
            ELSE
              INOR = INOR + DDLIMP(J)
            END IF
   60     CONTINUE
          IF (NDIM.EQ.3 .AND. DDLIMP(NDDLA+2).NE.0) THEN
            CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'//
     &            ' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     &                  //
     &                 'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL'
     &                  )
          END IF
        ELSE
          DO 70 J = 1,NDDLA + 2
            CALL GETVID('FACE_IMPO',MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
            IF (J.LE.NDDLA) THEN
              ICMP = ICMP + DDLIMP(J)
            ELSE
              INOR = INOR + DDLIMP(J)
            END IF
   70     CONTINUE
          IF (NDIM.EQ.3 .AND. DDLIMP(NDDLA+2).NE.0) THEN
            CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'//
     &            ' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     &                  //
     &                 'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL'
     &                  )
          END IF
        END IF
        NCMP = NCMP + ICMP
C    ------------------------------------------------------
C    FILTRAGE SUR LES COMPOSANTES NORMALES OU TANGENTIELLES
C    ------------------------------------------------------
        IF (INOR.NE.0 .AND. ICMP.EQ.0) THEN

          CALL NBNLMA(NOMA,NBMA,ZI(JLISTI),NBTYP,LITYP,NBNO)
          CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
          CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)
C   -------------------------------------------
C   CALCUL DES NORMALES ET TANGENTES AUX NOEUDS
C   -------------------------------------------
          IF (DDLIMP(NDDLA+1).NE.0) THEN
            CALL CANORT(NOMA,NBMA,ZI(JLISTI),K8B,NDIM,NBNO,
     &                                       ZI(JNBN),ZI(JNUNOE),1)
            CALL JEVEUO('&&CANORT.NORMALE','L',JNORM)
          END IF
          IF (DDLIMP(NDDLA+2).NE.0) THEN
            CALL CANORT(NOMA,NBMA,ZI(JLISTI),K8B,NDIM,NBNO,
     &                                       ZI(JNBN),ZI(JNUNOE),2)
            CALL JEVEUO('&&CANORT.TANGENT','L',JTANG)
          END IF
C   ----------------------
C   AFFECTATION DES COMPOSANTES DE LA RELATION A LA RELATION COURANTE
C   ----------------------
          COEF(1) = 1.0D0
          DDL(1) = 'DEPL'
          DO 120 INO = 1,NBNO
            IN = ZI(JNUNOE+INO-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
            IF (DDLIMP(NDDLA+1).NE.0) THEN
              DO 100 IDIM = 1,NDIM
                DIRECT(IDIM) = ZR(JNORM-1+NDIM* (INO-1)+IDIM)
  100         CONTINUE
              CALL AFRELA(COEF,COEFC,DDL,NOMNOE,NDIM,DIRECT,1,
     &                    VALIMR(NDDLA+1),VALIMC(NDDLA+1),
     &                    VALIMF(NDDLA+1),TYPCOE,FONREE,TYPLAG,0.D0,
     &                    LISREL)
            END IF
            IF (DDLIMP(NDDLA+2).NE.0) THEN
              DO 110 IDIM = 1,NDIM
                DIRECT(IDIM) = ZR(JTANG-1+NDIM* (INO-1)+IDIM)
  110         CONTINUE
              CALL AFRELA(COEF,COEFC,DDL,NOMNOE,NDIM,DIRECT,1,
     &                    VALIMR(NDDLA+2),VALIMC(NDDLA+2),
     &                    VALIMF(NDDLA+2),TYPCOE,FONREE,TYPLAG,0.D0,
     &                    LISREL)
            END IF
  120     CONTINUE
        END IF

C      ***************************************************
C      TRAITEMENT DES COMPOSANTES DX DY DZ DRX DRY DRZ ...
C      ***************************************************

        IF (NCMP.EQ.0) GO TO 200

C     RECUPERATION DES DONNEES DU MOT-CLE FACTEUR ET PRISE EN COMPTE
C     DE LA SURCHARGE

C ---------------------------------------------------
C     RECUPERATION DES MOTS-CLES DDL SOUS FACE_IMPO
C     MOTCLE(J) : K8 CONTENANT LE J-EME MOT-CLE DDL
C     NDDLA     : NOMBRE DE MOTS CLES DU TYPE DDL
C ---------------------------------------------------
        CALL GETMJM('FACE_IMPO',I,0,MOTCLE,TYMOCL,N)
        NMCL = -N
        IF (NMCL.GT.NMOCL) THEN
          CALL UTDEBM('F','CAFACI','NOMBRE DE MOTCLES SUPERIEUR AU MAX')
          CALL UTIMPI('L','NMAXOCL= ',1,NMOCL)
          CALL UTIMPI('L','NMOCL  = ',1,NMCL)
          CALL UTFINM()
        END IF
        CALL GETMJM('FACE_IMPO',I,NMCL,MOTCLE,TYMOCL,N)
        NDDLA = 1
        DO 130 J = 1,NMCL
          IF (MOTCLE(J).NE.'MAILLE' .AND. MOTCLE(J).NE.'GROUP_MA' .AND.
     &        MOTCLE(J).NE.'DNOR' .AND. MOTCLE(J).NE.'DTAN') THEN
            MOTCLE(NDDLA) = MOTCLE(J)
            NDDLA = NDDLA + 1
          END IF
  130   CONTINUE
        NDDLA = NDDLA - 1

        CALL JELIRA(NOMA//'.NOMNOE','NOMMAX',NBNOEU,K1BID)

C    ALLOCATION DE 3 OBJETS INTERMEDIAIRES PERMETTANT D'APPLIQUER
C    LA REGLE DE SURCHARGE :

C               - VECTEUR (K8) CONTENANT LES NOMS DES NOEUDS
C               - TABLEAU DES VALEURS DES DDLS DES NOEUDS BLOQUES
C                 DIM NBNOEU * NBCOMP
C               - VECTEUR (IS) CONTENANT LE DESCRIPTEUR GRANDEUR
C                 ASSOCIE AUX DDLS IMPOSES PAR NOEUD

        CALL WKVECT('&&CAFACI.NOMS_NOEUDS','V V K8',NBNOEU,JNONO)
        IF (FONREE.EQ.'REEL') THEN
          CALL WKVECT('&&CAFACI.VALDDL','V V R',NDDLA*NBNOEU,JVAL)
        ELSE
          CALL WKVECT('&&CAFACI.VALDDL','V V K8',NDDLA*NBNOEU,JVAL)
        END IF

        CALL WKVECT('&&CAFACI.DIRECT','V V R',3*NBNOEU,JDIREC)

        MOTCLE(NDDLA+1) = 'DNOR'
        MOTCLE(NDDLA+2) = 'DTAN'
        ICMP = 0
        INOR = 0
        IF (FONREE.EQ.'REEL') THEN
          DO 140 J = 1,NDDLA + 2
            CALL GETVR8('FACE_IMPO',MOTCLE(J),I,1,1,VALIMR(J),DDLIMP(J))
            IF (NDIM.EQ.3 .AND. DDLIMP(NDDLA+2).NE.0) THEN
              CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'//
     &            ' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     &                    //
     &                 'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL'
     &                    )
            END IF
            IF (J.LE.NDDLA) THEN
              ICMP = ICMP + DDLIMP(J)
            ELSE
              INOR = INOR + DDLIMP(J)
            END IF
  140     CONTINUE
        ELSE
          DO 150 J = 1,NDDLA + 2
            CALL GETVID('FACE_IMPO',MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
            IF (NDIM.EQ.3 .AND. DDLIMP(NDDLA+2).NE.0) THEN
              CALL UTMESS('F','CAFACI','PAS DE BLOCAGE DE DEPLACEMENT'//
     &            ' TANGENT SUR DES FACES D''ELEMENTS 3D. RENTRER LA CO'
     &                    //
     &                 'NDITION AUX LIMITES PAR DDL_IMPO OU LIAISON_DDL'
     &                    )
            END IF
            IF (J.LE.NDDLA) THEN
              ICMP = ICMP + DDLIMP(J)
            ELSE
              INOR = INOR + DDLIMP(J)
            END IF
  150     CONTINUE
        END IF
C
        IF (INOR.EQ.0) THEN
          CALL NBNLMA(NOMA,NBMA,ZI(JLISTI),NBTYP,LITYP,NBNO)
          CALL JEVEUO('&&NBNLMA.LN','L',JNUNOE)
          CALL JEVEUO('&&NBNLMA.NBN','L',JNBN)

          IRET = 0
          DO 180 INO = 1,NBNO
            IN = ZI(JNUNOE-1+INO)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',IN),NOMNOE)
            ZK8(JNONO-1+IN) = NOMNOE
            CALL AFDDLI(ZR(JVAL),ZK8(JVAL),ZC(JVAL),
     &                    ZI(JPRNM-1+ (IN-1)*NBEC+1),NDDLA,FONREE,
     &                    NOMNOE,IN,DDLIMP,VALIMR,VALIMF,VALIMC,MOTCLE,
     &                    NBEC,ZR(JDIREC+3* (IN-1)),0,LISREL,
     &                    ZK8(INOM),NBCMP,IRET)
  180     CONTINUE
          IF ( IRET .EQ. 0 ) CALL UTMESS('F','CAFACI',
     &                        'AUCUN NOEUD NE CONNAIT LES DDL FOURNIS')

        END IF
        CALL JEEXIN('&&CAFACI.NOMS_NOEUDS',IRET)
        IF (IRET.NE.0) CALL JEDETR('&&CAFACI.NOMS_NOEUDS')
        CALL JEEXIN('&&CAFACI.VALDDL',IRET)
        IF (IRET.NE.0) CALL JEDETR('&&CAFACI.VALDDL')
        CALL JEEXIN('&&NBNLMA.LN',IRET)
        CALL JEEXIN('&&CAFACI.DIRECT',IRET)
        IF (IRET.NE.0) CALL JEDETR('&&CAFACI.DIRECT')

  200   CONTINUE

        CALL JEDETR ( MESMAI )

  210 CONTINUE
C        -------------------------------------
C        AFFECTATION DE LA LISTE DE RELATIONS A LA CHARGE
C        (I.E. AFFECTATION DES OBJETS .CMULT, .CIMPO,
C        LIGRCH ET .NEMA)
C        -------------------------------------
      CALL AFLRCH(LISREL,CHAR)

  220 CONTINUE
      CALL JEEXIN('&&NBNLMA.LN',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&NBNLMA.LN')
      CALL JEEXIN('&&NBNLMA.NBN',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&NBNLMA.NBN')
      CALL JEEXIN('&&CANORT.NORMALE',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&CANORT.NORMALE')
      CALL JEEXIN('&&CANORT.TANGENT',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&CANORT.TANGENT')

      CALL JEDEMA()
      END
