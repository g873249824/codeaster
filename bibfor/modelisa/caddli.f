      SUBROUTINE CADDLI(NOMCMD,MOTFAC,FONREE,CHAR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 31/10/2006   AUTEUR PABHHHH N.TARDIEU 
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
      IMPLICIT NONE

      CHARACTER*4 FONREE
      CHARACTER*8 CHAR
      CHARACTER*16 NOMCMD,MOTFAC

C     BUT: CREER LES CARTES CHAR.CHME.CMULT ET CHAR.CHME.CIMPO
C          ET REMPLIR LIGRCH, EN SE SERVANT DE L'OBJET .PRNM
C          POUR AFFECTER LE BON NOMBRE DE DEGRES DE LIBERTE A CHAQUE NOE

C ARGUMENTS D'ENTREE:

C      NOMCMD  : NOM DE LA COMMANDE
C      MOTFAC  : DDL_IMPO OU TEMP_IMPO OU PRES_IMPO
C      FONREE  : TYPE DE LA VALEUR IMPOSEE :
C                REEL OU FONC OU COMP
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
      CHARACTER*32 JEXNOM,JEXNUM
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
C-----------------------------------------------------------------------
C---------------- DECLARATION DES VARIABLES LOCALES  -------------------

      INTEGER NMOCL,IEVOL
      PARAMETER (NMOCL=300)
      INTEGER DDLIMP(NMOCL),NDDLI,N,NMCL,I,J,NDDLA,IBID
      INTEGER IER,NBEC,JNOMA,NBNOEU,JPRNM,JVAL
      INTEGER JDIREC,JDIMEN,NBNO,IALINO,K,INO
      REAL*8 VALIMR(NMOCL),RBID,COEFR
      COMPLEX*16 VALIMC(NMOCL),CBID

      CHARACTER*1 K1BID
      CHARACTER*3 TYMOCL(NMOCL)
      CHARACTER*8 MOD,NOMA,K8BID,EVOTH
      CHARACTER*8 NOMN,VALIMF(NMOCL),DDL
      CHARACTER*16 MOTCLE(NMOCL),MOTCL2(5),TYMOC2(5)
      CHARACTER*19 LIGRMO,LISREL,NOMFON
      CHARACTER*24 NOMNOE,NOOBJ

C--- Variables pour le mot-clef "LIAISON = ENCASTRE"
      INTEGER      NDLIA,LIAIMP,INDIK8,INOM,NBCMP,JCOMPT
      INTEGER      ICMP1,ICMP2,ICMP3,ICMP4,ICMP5,ICMP6
      LOGICAL      EXISDG
      CHARACTER*8  NOMG
      CHARACTER*72 VALLIA
      DATA         VALLIA  /'XXXXXXXX'/
C-------------------------------------------------------------

      CALL JEMARQ()

      MOTCL2(1) = 'NOEUD'
      TYMOC2(1) = 'NOEUD'
      MOTCL2(2) = 'GROUP_NO'
      TYMOC2(2) = 'GROUP_NO'
      MOTCL2(3) = 'MAILLE'
      TYMOC2(3) = 'MAILLE'
      MOTCL2(4) = 'GROUP_MA'
      TYMOC2(4) = 'GROUP_MA'
      MOTCL2(5) = 'TOUT'
      TYMOC2(5) = 'TOUT'

      LISREL = '&&CADDLI.RLLISTE'
      CALL GETFAC(MOTFAC,NDDLI)
      IF (NDDLI.EQ.0) GO TO 110

C --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,MOD,IER)
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
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IER)
      CALL ASSERT (NBEC.LE.10)

      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)

C --- MAILLAGE ASSOCIE AU MODELE ---

      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
      NOMNOE = NOMA//'.NOMNOE'
      CALL JELIRA(NOMNOE,'NOMMAX',NBNOEU,K1BID)

      CALL JEVEUO(LIGRMO//'.PRNM','L',JPRNM)

C --------------------------------------------------------------
C 3   BOUCLE SUR LES OCCURENCES DU MOT-CLE FACTEUR DDL IMPOSE
C --------------------------------------------------------------

      DO 100 I = 1,NDDLI

C ---------------------------------------------------
C 1.  RECUPERATION DES MOTS-CLES DDL SOUS XXX_IMPO
C     MOTCLE(J) : K8 CONTENANT LE J-EME MOT-CLE DDL
C     NDDLA     : NOMBRE DE MOTS CLES DU TYPE DDL
C ---------------------------------------------------
        CALL GETMJM(MOTFAC,I,0,MOTCLE,TYMOCL,N)
        NMCL = ABS(N)
        IF (NMCL.GT.NMOCL) THEN
          CALL UTDEBM('F','CADDLI','NOMBRE DE MOTCLES SUPERIEUR AU MAX')
          CALL UTIMPI('L','NMAXOCL= ',1,NMOCL)
          CALL UTIMPI('L','NMOCL  = ',1,NMCL)
          CALL UTFINM()
        END IF
        CALL GETMJM(MOTFAC,I,NMCL,MOTCLE,TYMOCL,N)

C --- RECUPERATION DU MOT-CLEF "LIAISON"


        NDDLA = 1
        DO 20 J = 1,NMCL
          IF (MOTCLE(J).NE.'TOUT' .AND. MOTCLE(J).NE.'GROUP_NO' .AND.
     &        MOTCLE(J).NE.'NOEUD' .AND. MOTCLE(J).NE.'GROUP_MA' .AND.
     &        MOTCLE(J).NE.'MAILLE' .AND. MOTCLE(J).NE.'EVOL_THER' .AND.
     &        MOTCLE(J).NE.'DDL' .AND. MOTCLE(J).NE.'LIAISON') THEN
            MOTCLE(NDDLA) = MOTCLE(J)
            NDDLA = NDDLA + 1
          END IF

   20   CONTINUE
        NDDLA = NDDLA - 1

        NDLIA = 0
        DO 30 J = 1,NMCL
          IF (MOTCLE(J).EQ.'LIAISON') THEN
            NDLIA = 1
            NDDLA = 6
            MOTCLE(1) = 'DX'
            MOTCLE(2) = 'DY'
            MOTCLE(3) = 'DZ'
            MOTCLE(4) = 'DRX'
            MOTCLE(5) = 'DRY'
            MOTCLE(6) = 'DRZ'

            ICMP1 = INDIK8(ZK8(INOM),MOTCLE(1) (1:8),1,NBCMP)
            ICMP2 = INDIK8(ZK8(INOM),MOTCLE(2) (1:8),1,NBCMP)
            ICMP3 = INDIK8(ZK8(INOM),MOTCLE(3) (1:8),1,NBCMP)
            ICMP4 = INDIK8(ZK8(INOM),MOTCLE(4) (1:8),1,NBCMP)
            ICMP5 = INDIK8(ZK8(INOM),MOTCLE(5) (1:8),1,NBCMP)
            ICMP6 = INDIK8(ZK8(INOM),MOTCLE(6) (1:8),1,NBCMP)
          END IF
   30   CONTINUE


C ---------------------------------------------------
C 2   ALLOCATION DE TABLEAUX DE TRAVAIL
C ---------------------------------------------------
C   OBJETS INTERMEDIAIRES PERMETTANT D'APPLIQUER LA REGLE DE SURCHARGE

C        -  VECTEUR (K8) CONTENANT LES NOMS DES NOEUDS
C        -  TABLEAU DES VALEURS DES DDLS DES NOEUDS BLOQUES
C                         DIM NBNOEU * NBCOMP
C        -  VECTEUR (IS) CONTENANT LE DESCRIPTEUR GRANDEUR ASSOCIE AUX
C                         DDLS IMPOSES PAR NOEUD

        IF (NDDLA.NE.0) THEN
          IF (FONREE.EQ.'REEL') THEN
            CALL WKVECT('&&CADDLI.VALDDL','V V R',NDDLA*NBNOEU,JVAL)
          ELSE IF (FONREE.EQ.'COMP') THEN
            CALL WKVECT('&&CADDLI.VALDDL','V V C',NDDLA*NBNOEU,JVAL)
          ELSE IF (FONREE.EQ.'FONC') THEN
            CALL WKVECT('&&CADDLI.VALDDL','V V K8',NDDLA*NBNOEU,JVAL)
          ELSE
            CALL U2MESS('F','CALCULEL_2')
          END IF
          CALL WKVECT('&&CADDLI.DIRECT','V V R',3*NBNOEU,JDIREC)
          CALL WKVECT('&&CADDLI.DIMENSION','V V I',NBNOEU,JDIMEN)
        END IF

C        3.1- RECUPERATION DE LA LISTE DES NOEUDS :
C        ----------------------------------------------
        CALL RELIEM(MOD,NOMA,'NU_NOEUD',MOTFAC,I,5,MOTCL2,TYMOC2,
     &              '&&CADDLI.NUNOTMP',NBNO)
        CALL JEVEUO('&&CADDLI.NUNOTMP','L',IALINO)



C        3.2- RECUPERATION DE LA VALEUR IMPOSEE  (MOCLE(J)):
C        ---------------------------------------------------
        IF (FONREE.EQ.'REEL') THEN
          DO 40 J = 1,NDDLA
            CALL GETVR8(MOTFAC,MOTCLE(J),I,1,1,VALIMR(J),DDLIMP(J))
   40     CONTINUE

        ELSE IF (FONREE.EQ.'COMP') THEN
          DO 50 J = 1,NDDLA
            CALL GETVC8(MOTFAC,MOTCLE(J),I,1,1,VALIMC(J),DDLIMP(J))
   50     CONTINUE


        ELSE IF (FONREE.EQ.'FONC') THEN
          DO 60 J = 1,NDDLA
            CALL GETVID(MOTFAC,MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
   60     CONTINUE
        END IF



C        3.3- AFFECTATION DES RELATIONS LINEAIRES :
C        ----------------------------------------------
C       -- ON VERIFIE QUE SI EVOL_THER, IL EST EMPLOYE SEUL :
        IEVOL = 0
        IF (NOMCMD.EQ.'AFFE_CHAR_THER_F') THEN
          CALL GETVID('TEMP_IMPO','EVOL_THER',I,1,1,EVOTH,IEVOL)
          IF (IEVOL.EQ.1) THEN
            DO 70 J = 1,NDDLA
              CALL GETVID(MOTFAC,MOTCLE(J),I,1,1,VALIMF(J),DDLIMP(J))
              IF (DDLIMP(J).NE.0) CALL U2MESK('F','MODELISA2_44',1,MOTCL
     &E(J))
   70       CONTINUE
          END IF
        END IF

        CALL WKVECT('&&CADDLI.ICOMPT','V V I',MAX(NDDLA,1),JCOMPT)
        DO 90 K = 1,NBNO
          INO = ZI(IALINO-1+K)
          CALL JENUNO(JEXNUM(NOMNOE,INO),NOMN)
C---  GESTION DU MOT-CLEF "LIAISON"
          DO 80 J = 1,NDLIA
            VALLIA='XXXXXXXX'
            CALL GETVTX(MOTFAC,'LIAISON',I,1,1,VALLIA,LIAIMP)
            IF (VALLIA.EQ.'ENCASTRE') THEN
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP1)) THEN
                VALIMR(1) = 0.D0
                VALIMC(1) = (0.D0,0.D0)
                VALIMF(1) = '&FOZERO'
                DDLIMP(1) = 1
              END IF
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP2)) THEN
                VALIMR(2) = 0.D0
                VALIMC(2) = (0.D0,0.D0)
                VALIMF(2) = '&FOZERO'
                DDLIMP(2) = 1
              END IF
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP3)) THEN
                VALIMR(3) = 0.D0
                VALIMC(3) = (0.D0,0.D0)
                VALIMF(3) = '&FOZERO'
                DDLIMP(3) = 1
              END IF
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP4)) THEN
                VALIMR(4) = 0.D0
                VALIMC(4) = (0.D0,0.D0)
                VALIMF(4) = '&FOZERO'
                DDLIMP(4) = 1
              END IF
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP5)) THEN
                VALIMR(5) = 0.D0
                VALIMC(5) = (0.D0,0.D0)
                VALIMF(5) = '&FOZERO'
                DDLIMP(5) = 1
              END IF
              IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP6)) THEN
                VALIMR(6) = 0.D0
                VALIMC(6) = (0.D0,0.D0)
                VALIMF(6) = '&FOZERO'
                DDLIMP(6) = 1
              END IF
            END IF
   80     CONTINUE

C         -- CAS EVOL_THER/DDL (POUR AFFE_CHAR_THER_F):
C         ---------------------------------------------
          IF (IEVOL.EQ.1) THEN

C           DETERMINATION DU NOM DE LA SD CACHEE FONCTION
            NOOBJ ='12345678.FONC.00000.PROL'
            CALL GNOMSD(NOOBJ,15,19)
            NOMFON=NOOBJ(1:19)

            DDL = 'TEMP'
            CALL FOCRR1(NOMFON,EVOTH,'G','TEMP',' ',NOMN,DDL,0,0)
            COEFR = 1.D0
            CALL AFRELA(COEFR,CBID,DDL,NOMN,0,RBID,1,RBID,CBID,NOMFON,
     &                  'REEL','FONC','12',0.D0,LISREL)

C         -- AUTRES CAS:
C         ---------------
          ELSE
            CALL AFDDLI(ZR(JVAL),ZK8(JVAL),ZC(JVAL),
     &                  ZI(JPRNM-1+ (INO-1)*NBEC+1),NDDLA,FONREE,NOMN,
     &                  INO,DDLIMP,VALIMR,VALIMF,VALIMC,MOTCLE,NBEC,
     &                  ZR(JDIREC+3*(INO-1)),0,LISREL,
     &                  ZK8(INOM),NBCMP,ZI(JCOMPT))
          END IF
   90   CONTINUE

C       -- IL NE FAUT PAS GRONDER L'UTILISATEUR SI 'ENCASTRE' :
        IF (VALLIA.NE.'ENCASTRE') THEN
          DO 91,K=1,NDDLA
             IF (ZI(JCOMPT-1+K).EQ.0) CALL U2MESK('F',
     &                                    'MODELISA2_45',1,MOTCLE(K))
  91      CONTINUE
        ENDIF
        CALL JEDETR('&&CADDLI.ICOMPT')

        CALL JEDETR('&&CADDLI.VALDDL')
        CALL JEDETR('&&CADDLI.DIRECT')
        CALL JEDETR('&&CADDLI.DIMENSION')
        CALL JEDETR('&&CADDLI.NUNOTMP')

  100 CONTINUE

      CALL AFLRCH(LISREL,CHAR)

  110 CONTINUE
      CALL JEDEMA()
      END
