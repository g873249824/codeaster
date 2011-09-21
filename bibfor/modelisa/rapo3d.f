      SUBROUTINE RAPO3D(NUMDLZ,IOCC,FONREZ,LISREZ,CHARGZ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8 CHARGE
      CHARACTER*14 NUMDDL
      CHARACTER*19 LISREL
      CHARACTER*(*) NUMDLZ,CHARGZ,FONREZ,LISREZ
C -------------------------------------------------------
C     RACCORD POUTRE-3D PAR DES RELATIONS LINEAIRES
C     ENTRE LES NOEUDS DES MAILLES DE SURFACE MODELISANT
C     LA TRACE DE LA SECTION DE LA POUTRE SUR LE MASSIF 3D
C     ET LE NOEUD DE LA POUTRE DONNE PAR L'UTILISATEUR
C -------------------------------------------------------
C  NUMDLZ        - IN    - K14  - : NOM DU NUMEDDL DU LIGREL DU MODELE
C                                     (IL A ETE CREE SUR LA VOLATILE)
C  IOCC          - IN    - I    - : NUMERO D'OCCURENCE DU MOT-FACTEUR
C  FONREZ        - IN    - K4   - : 'REEL'
C  LISREZ        - IN    - K19  - : NOM DE LA SD LISTE_RELA
C  CHARGE        - IN    - K8   - : NOM DE LA SD CHARGE
C                - JXVAR -      -
C -------------------------------------------------------

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
      CHARACTER*32 JEXNUM,JEXNOM
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ------

C --------- VARIABLES LOCALES ---------------------------
      INTEGER NMOCL
      PARAMETER (NMOCL=300)
      LOGICAL EXISDG,VEXCEN
      CHARACTER*1 K1BID
      CHARACTER*2 TYPLAG
      CHARACTER*4 TYPVAL,TYPCOE
      CHARACTER*8 BETAF,MOD,NOMG,K8BID,POSLAG,CARA
      CHARACTER*8 NOMA,NOMCMP(NMOCL)
      CHARACTER*8 NOEPOU,NOCMP(3),KCMP(3),CMP(6),NOGRNO
      CHARACTER*8 LPAIN(2),LPAOUT(2)
      CHARACTER*9 NOMTE
      CHARACTER*16 MOTFAC,MOTCLE(2),TYPMCL(2),OPTION
      CHARACTER*19 LIGRMO,LIGREL
      CHARACTER*24 LCHIN(2),LCHOUT(2),NOLILI,LISMAI,VALK(2)
      CHARACTER*24 LISNOE,NOEUMA,VALE1,VALE2,GRNOMA
      INTEGER NTYPEL(NMOCL),DG,ICMP(6),NIV,IFM,VALI(2)
      INTEGER IOP,NLIAI,I,NARL,NRL,IBID,JNOMA,JCOOR,INOM
      INTEGER NBCMP,NDDLA,NBEC,JPRNM,NLILI,K,IAPRNO,LONLIS,ILISNO
      INTEGER JLISMA,NBMA,NBNO,NBGNO,NNO,N1,JGRO,IN,NUMNOP
      INTEGER INO,J,INDIK8,IDINER,IDCH1,IDCH2,NBTERM
      INTEGER JLISNO,JLISDL,JLISCR,JLISCC,JLISDI,JLISDM,IVAL
      INTEGER NCARA,IOCC,IER
      REAL*8 IG(6),COORIG(3),ANGT,BETA,EPS,UN,R8PREM,VTANG(6)
      REAL*8 XPOU,YPOU,ZPOU,S,S1,XG,YG,ZG,DNORME
      REAL*8 AX,AY,AZ,AXX,AYY,AZZ,AXY,AXZ,AYZ,VALR(9)
      COMPLEX*16  CBID,BETAC,CCMP(3)
      INTEGER      IARG
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------

      CALL JEMARQ()
C --- RECUPERATION DES PARAMETRE D IMPRESSION
      CALL INFNIV(IFM,NIV)
C -------------------------------------------------------
      NUMDDL = NUMDLZ
      CHARGE = CHARGZ
      LISREL = LISREZ

      MOTFAC = 'LIAISON_ELEM'
      CALL GETVTX(MOTFAC,'OPTION',IOCC,IARG,1,OPTION,IOP)
      IF ( (OPTION.NE.'3D_POU')   .AND.
     &     (OPTION.NE.'3D_TUYAU') .AND.
     &     (OPTION.NE.'PLAQ_POUT_ORTH') ) THEN
        CALL U2MESK('F','MODELISA6_39',1,OPTION)
      END IF

      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GO TO 9999

C     VERIFIE-T'ON L'EXCENTREMENT DES POUTRES
      VEXCEN=.TRUE.
      IF (OPTION.EQ.'PLAQ_POUT_ORTH') THEN
         CALL GETVTX(MOTFAC,'VERIF_EXCENT',IOCC,IARG,0,K8BID,NARL)
         IF (NARL.NE.0) THEN
            CALL GETVTX(MOTFAC,'VERIF_EXCENT',IOCC,IARG,1,K8BID,NARL)
            IF (K8BID(1:3).EQ.'NON') VEXCEN=.FALSE.
         ENDIF
      ENDIF
C --- INITIALISATIONS
C     ---------------

C --- TYPE DES VALEURS AU SECOND MEMBRE DES RELATIONS
      TYPVAL = FONREZ
C --- TYPE DES VALEURS DES COEFFICIENTS DES RELATIONS
      TYPCOE = 'REEL'
C --- VALEUR DU SECOND MEMBRE DES RELATIONS QUAND C'EST UNE FONCTION
      BETAF = '&FOZERO'
C --- VALEUR DU SECOND MEMBRE DES RELATIONS QUAND C'EST UN REEL
      BETA = 0.0D0
C --- VALEUR DU SECOND MEMBRE DES RELATIONS QUAND C'EST UN COMPLEXE
      BETAC = (0.0D0,0.0D0)
      EPS = 1.0D-02
      UN = 1.0D0
      KCMP(1) = ' '
      KCMP(2) = ' '
      KCMP(3) = ' '
      CMP(1) = 'DX'
      CMP(2) = 'DY'
      CMP(3) = 'DZ'
      CMP(4) = 'DRX'
      CMP(5) = 'DRY'
      CMP(6) = 'DRZ'
      CCMP(1) = (0.0D0,0.0D0)
      CCMP(2) = (0.0D0,0.0D0)
      CCMP(3) = (0.0D0,0.0D0)
      DO 10 I = 1,6
         ICMP(I) = 0
   10 CONTINUE

      LIGREL = '&&RAPO3D'
      LISNOE = '&&RAPO3D.LISTE_NOEUDS'
      LISMAI = '&&RAPO3D.LISTE_MAILLES'
      MOTCLE(1) = 'GROUP_MA_1'
      MOTCLE(2) = 'MAILLE_1'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'

C --- ON REGARDE SI LES MULTIPLICATEURS DE LAGRANGE SONT A METTRE
C --- APRES LES NOEUDS PHYSIQUES LIES PAR LA RELATION DANS LA MATRICE
C --- ASSEMBLEE :
C --- SI OUI TYPLAG = '22'
C --- SI NON TYPLAG = '12'
C     -------------------
      CALL GETVTX(MOTFAC,'NUME_LAGR',IOCC,IARG,0,K8BID,NARL)
      IF (NARL.NE.0) THEN
         CALL GETVTX(MOTFAC,'NUME_LAGR',IOCC,IARG,1,POSLAG,NRL)
         IF (POSLAG(1:5).EQ.'APRES') THEN
            TYPLAG = '22'
         ELSE
            TYPLAG = '12'
         END IF
      ELSE
         TYPLAG = '12'
      END IF

C --- -----------------------------------------------------------------
C --- MODELE ASSOCIE AU LIGREL DE CHARGE
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
C --- -----------------------------------------------------------------
C     LIGREL DU MODELE
      LIGRMO = MOD(1:8)//'.MODELE'

C --- -----------------------------------------------------------------
C --- MAILLAGE ASSOCIE AU MODELE
      CALL JEVEUO(LIGRMO//'.LGRF','L',JNOMA)
      NOMA = ZK8(JNOMA)
      NOEUMA = NOMA//'.NOMNOE'
      GRNOMA = NOMA//'.GROUPENO'

C --- -----------------------------------------------------------------
C --- RECUPERATION DU TABLEAU DES COORDONNEES
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)

C --- -----------------------------------------------------------------
C --- RECUPERATION DES NOMS DES DDLS
      NOMG  = 'DEPL_R'
      NOMTE = 'D_DEPL_R_'

      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)
      NDDLA = NBCMP - 1
      IF (NDDLA.GT.NMOCL) THEN
         VALI (1) = NMOCL
         VALI (2) = NDDLA
         CALL U2MESG('F', 'MODELISA8_29',0,' ',2,VALI,0,0.D0)
      END IF
      DO 20 I = 1,NDDLA
         NOMCMP(I) = ZK8(INOM-1+I)
         CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMTE//NOMCMP(I) (1:7)),
     &               NTYPEL(I))
20    CONTINUE
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IER)

C --- -----------------------------------------------------------------
C --- ACCES A L'OBJET .PRNM
      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ELSE
         CALL JEVEUO(LIGRMO//'.PRNM','L',JPRNM)
      END IF

C --- -----------------------------------------------------------------
C --- RECUPERATION DU .PRNO ASSOCIE AU MAILLAGE
      CALL JELIRA(NUMDDL//'.NUME.PRNO','NMAXOC',NLILI,K1BID)
      K = 0
      DO 30 I = 1,NLILI
         CALL JENUNO(JEXNUM(NUMDDL//'.NUME.LILI',I),NOLILI)
         IF (NOLILI(1:8).NE.'&MAILLA') GO TO 30
         K = I
30    CONTINUE
      CALL ASSERT (K.NE.0)
      CALL JEVEUO(JEXNUM(NUMDDL//'.NUME.PRNO',K),'L',IAPRNO)

C --- -----------------------------------------------------------------
C --- ACQUISITION DE LA LISTE DES NOEUDS A LIER
C     (CETTE LISTE EST NON REDONDANTE)
      CALL MALIN1(MOTFAC,CHARGE,IOCC,1,LISNOE,LONLIS)
      CALL JEVEUO(LISNOE,'L',ILISNO)

C --- -----------------------------------------------------------------
C --- CONSTITUTION DU LIGREL FORME DES MAILLES DE SURFACE MODELISANT
C     LA TRACE DE LA SECTION DE LA POUTRE SUR LE MASSIF 3D
C
C --- CREATION ET AFFECTATION DU VECTEUR DE K8 DE NOM LISMAI
C     CONTENANT LES NOMS DES MAILLES FORMANT LE LIGREL A CREER
      CALL RELIEM(' ',NOMA,'NU_MAILLE',MOTFAC,IOCC,2,MOTCLE(1),
     &            TYPMCL(1),LISMAI,NBMA)
      CALL JEVEUO(LISMAI,'L',JLISMA)

C     CREATION ET AFFECTATION DU LIGREL
      CALL EXLIM1(ZI(JLISMA),NBMA,MOD,'V',LIGREL)

C     VERIFICATION DE LA PLANEITE DE LA SURFACE :
      CALL GETVR8(MOTFAC,'ANGL_MAX',IOCC,IARG,1,ANGT,IBID)
      IF (OPTION.EQ.'PLAQ_POUT_ORTH') THEN
         CALL VERIPL(NOMA,NBMA,ZI(JLISMA),ANGT,'F')
      ELSE
         CALL VERIPL(NOMA,NBMA,ZI(JLISMA),ANGT,'A')
      ENDIF

C --- -----------------------------------------------------------------
C --- ACQUISITION DES MOTS-CLES NOEUD_2 OU GROUP_NO_2
      NBNO = 0
      NBGNO = 0

      CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD_2',IOCC,IARG,0,K8BID,NBNO)

      IF (NBNO.EQ.0) THEN
         CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO_2',IOCC,IARG,0,
     &               K8BID,
     &               NBGNO)
         IF (NBGNO.EQ.0) THEN
            CALL U2MESK('F','MODELISA6_40',1,MOTFAC)
         END IF
      END IF

      IF (NBNO.NE.0) THEN
         NBNO = -NBNO
         IF (NBNO.NE.1) THEN
            CALL U2MESS('F','MODELISA6_41')
         END IF
         CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD_2',IOCC,IARG,NBNO,
     &               NOEPOU,
     &               NNO)
      END IF

      IF (NBGNO.NE.0) THEN
         NBGNO = -NBGNO
         IF (NBGNO.NE.1) THEN
            CALL U2MESS('F','MODELISA6_42')
         END IF
         CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO_2',IOCC,IARG,
     &               NBGNO,
     &               NOGRNO,NNO)
         CALL JELIRA(JEXNOM(GRNOMA,NOGRNO),'LONUTI',N1,K1BID)
         IF (N1.NE.1) THEN
            CALL U2MESK('F','MODELISA6_43',1,NOGRNO)
         ELSE
            CALL JEVEUO(JEXNOM(GRNOMA,NOGRNO),'L',JGRO)
            IN = ZI(JGRO+1-1)
            CALL JENUNO(JEXNUM(NOEUMA,IN),NOEPOU)
         END IF
      END IF

C --- -----------------------------------------------------------------
C --- NUMERO DU NOEUD POUTRE A LIER
      CALL JENONU(JEXNOM(NOEUMA,NOEPOU),NUMNOP)
C --- COORDONNEES DU NOEUD POUTRE
      XPOU = ZR(JCOOR-1+3*(NUMNOP-1)+1)
      YPOU = ZR(JCOOR-1+3*(NUMNOP-1)+2)
      ZPOU = ZR(JCOOR-1+3*(NUMNOP-1)+3)

C --- -----------------------------------------------------------------
C --- VERIFICATION DU FAIT QUE LES NOEUDS DE LISNOE :
C        SI MASSIF : NE PORTENT PAS DE COMPOSANTES DE ROTATION.
C        SI COQUE  : PORTENT DES COMPOSANTES DE ROTATION.
      IF (OPTION.EQ.'PLAQ_POUT_ORTH') THEN
         DO 52 I = 1,LONLIS
C           NUMERO DU NOEUD COURANT DE LA LISTE
            CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),INO)
C           IL DOIT ETRE DIFFERENT DU NOEUD DE LA POUTRE
            IF ( INO .EQ. NUMNOP ) THEN
               VALK(1) = NOEPOU
               VALR(1) = XPOU
               VALR(2) = YPOU
               VALR(3) = ZPOU
               VALI(1) = IOCC
               CALL U2MESG('F','MODELISA6_28',1,VALK,1,VALI,3,VALR)
            ENDIF
            DG = ZI(JPRNM-1+ (INO-1)*NBEC+1)
            DO 42 J = 4,6
               ICMP(J) = INDIK8(NOMCMP,CMP(J),1,NDDLA)
               IF (.NOT. EXISDG(DG,ICMP(J))) THEN
                  VALK(1) = ZK8(ILISNO+I-1)
                  VALK(2) = CMP(J)
                  CALL U2MESK('F','MODELISA6_32', 2 ,VALK)
               END IF
42          CONTINUE
52       CONTINUE
      ELSE
         DO 50 I = 1,LONLIS
C           NUMERO DU NOEUD COURANT DE LA LISTE
            CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),INO)
            DG = ZI(JPRNM-1+ (INO-1)*NBEC+1)
            DO 40 J = 4,6
               ICMP(J) = INDIK8(NOMCMP,CMP(J),1,NDDLA)
               IF (EXISDG(DG,ICMP(J))) THEN
                  VALK(1) = ZK8(ILISNO+I-1)
                  VALK(2) = CMP(J)
                  CALL U2MESK('F','MODELISA6_44', 2 ,VALK)
               END IF
40          CONTINUE
50       CONTINUE
      ENDIF

C --- -----------------------------------------------------------------
C --- VERIFICATION DU FAIT QUE LE NOEUD POUTRE A RACCORDER PORTE
C     LES 3 DDLS DE TRANSLATION ET LES 3 DDLS DE ROTATION.
      DG = ZI(JPRNM-1+ (NUMNOP-1)*NBEC+1)
      DO 60 J = 1,6
         ICMP(J) = INDIK8(NOMCMP,CMP(J),1,NDDLA)
         IF (.NOT.EXISDG(DG,ICMP(J))) THEN
            VALK(1) = NOEPOU
            VALK(2) = CMP(J)
            CALL U2MESK('F','MODELISA6_45', 2 ,VALK)
         END IF
60    CONTINUE

C --- -----------------------------------------------------------------
C --- CALCUL SUR CHAQUE ELEMENT DE SURFACE A RELIER A LA POUTRE
C     DES CARACTERISTIQUES GEOMETRIQUES SUIVANTES :
C        SOMME/S_ELEMENT(1,X,Y,Z,X*X,Y*Y,Z*Z,X*Y,X*Z,Y*Z)DS
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = NOMA//'.COORDO'
      LPAOUT(1) = 'PCASECT'
      LCHOUT(1) = '&&RAPO3D.PSECT'

      CALL CALCUL('S','CARA_SECT_POUT3',LIGREL,1,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V','OUI')

C --- -----------------------------------------------------------------
C --- VECTEUR DES QUANTITES GEOMETRIQUES PRECITEES SOMMEES
C     SUR LA SURFACE DE RACCORD, CES QUANTITES SERONT NOTEES :
C        A1 = S,AX,AY,AZ,AXX,AYY,AZZ,AXY,AXZ,AYZ
      CALL WKVECT('&&RAPO3D.INERTIE_RACCORD','V V R',16,IDINER)
C --- -----------------------------------------------------------------
C     SOMMATION DES QUANTITES GEOMETRIQUES ELEMENTAIRES
C     DANS LE VECTEUR &&RAPO3D.INERTIE_RACCORD :
C     SEULES LES 10 PREMIERES VALEURS SERONT UTILISEES
      CALL MESOMM(LCHOUT(1),16,IBID,ZR(IDINER),CBID,0,IBID)

      S   = ZR(IDINER+1-1)
      AX  = ZR(IDINER+2-1)
      AY  = ZR(IDINER+3-1)
      AZ  = ZR(IDINER+4-1)
      AXX = ZR(IDINER+5-1)
      AYY = ZR(IDINER+6-1)
      AZZ = ZR(IDINER+7-1)
      AXY = ZR(IDINER+8-1)
      AXZ = ZR(IDINER+9-1)
      AYZ = ZR(IDINER+10-1)

      IF (ABS(S).LT.R8PREM()) THEN
         CALL U2MESS('F','MODELISA6_46')
      END IF
      S1 = 1.0D0/S

C --- -----------------------------------------------------------------
C --- COORDONNEES DU CENTRE GEOMETRIQUE G DE LA SECTION DE RACCORD
C     XG = AX/S, YG = AY/S, ZG = AZ/S
      XG = S1*AX
      YG = S1*AY
      ZG = S1*AZ
C --- -----------------------------------------------------------------
C     VERIFICATION DE L'IDENTITE GEOMETRIQUE DE G AVEC LE
C     NOEUD POUTRE A RACCORDER :
      DNORME = SQRT((XPOU-XG)*(XPOU-XG)+ (YPOU-YG)*(YPOU-YG)+
     &         (ZPOU-ZG)*(ZPOU-ZG))/SQRT(S/3.14159265D0)
      IF (DNORME.GT.EPS) THEN
         VALR(1) = XG
         VALR(2) = YG
         VALR(3) = ZG
         VALR(4) = XPOU
         VALR(5) = YPOU
         VALR(6) = ZPOU
         VALR(7) = EPS*100.0D0
         VALR(8) = SQRT(S/3.14159265D0)
         VALR(9) = DNORME
         VALK(1) = OPTION
         VALI(1) = IOCC
         IF ( VEXCEN ) THEN
            CALL U2MESG('A','CALCULEL3_80',1,VALK,1,VALI,9,VALR)
         ELSE
            CALL U2MESG('I','CALCULEL3_78',1,VALK,1,VALI,9,VALR)
         ENDIF
      ENDIF

C --- -----------------------------------------------------------------
C     RECUPERATION DES VECTEURS TANGENTS ORTHONORMES DU 1ER ELEMENT
      IF (OPTION.EQ.'PLAQ_POUT_ORTH') THEN
         CALL MESOMM(LCHOUT(1),16,IBID,ZR(IDINER),CBID,1,ZI(JLISMA))
         VTANG(1) = ZR(IDINER+11-1)
         VTANG(2) = ZR(IDINER+12-1)
         VTANG(3) = ZR(IDINER+13-1)
         VTANG(4) = ZR(IDINER+14-1)
         VTANG(5) = ZR(IDINER+15-1)
         VTANG(6) = ZR(IDINER+16-1)
      ENDIF

C --- -----------------------------------------------------------------
C     CALCUL DU TENSEUR D'INERTIE EN G, CE TENSEUR EST SYMETRIQUE :
C     ON CALCULE LES COMPOSANTES DE LA PARTIE SUPERIEURE PAR LIGNE
C
C --- IGXX = AYY + AZZ -S*(YG*YG+ZG*ZG)
      IG(1) = AYY + AZZ - S*(YG*YG+ZG*ZG)
C --- IGXY = -AXY + S*XG*YG
      IG(2) = -AXY + S*XG*YG
C --- IGXZ = -AXZ + S*XG*ZG
      IG(3) = -AXZ + S*XG*ZG
C --- IGYY = AZZ + AXX -S*(ZG*ZG+XG*XG)
      IG(4) = AZZ + AXX - S*(ZG*ZG+XG*XG)
C --- IGYZ = -AYZ + S*YG*ZG
      IG(5) = -AYZ + S*YG*ZG
C --- IGZZ = AXX + AYY -S*(XG*XG+YG*YG)
      IG(6) = AXX + AYY - S*(XG*XG+YG*YG)

C --- -----------------------------------------------------------------
C     NOTATION DANS LA CARTE DE NOM '&&RAPO3D.CAORIGE' DES
C     COORDONNEES DU CENTRE GEOMETRIQUE G DE LA SECTION DE RACCORD
      NOCMP(1) = 'X'
      NOCMP(2) = 'Y'
      NOCMP(3) = 'Z'

      COORIG(1) = XG
      COORIG(2) = YG
      COORIG(3) = ZG

      CALL MECACT('V','&&RAPO3D.CAORIGE','LIGREL',LIGREL,'GEOM_R',3,
     &            NOCMP,ICMP,COORIG,CCMP,KCMP)

C --- DETERMINATION DE 2 LISTES  DE VECTEURS PAR ELEMENT PRENANT
C     LEURS VALEURS AUX NOEUDS DES ELEMENTS.
C --- LA PREMIERE LISTE DE NOM 'VECT_NI' A POUR VALEURS AU NOEUD
C     I D'UN ELEMENT : SOMME/S_ELEMENT(NI,0,0)DS
C --- LA SECONDE LISTE DE NOM 'VECT_XYZNI' A POUR VALEURS AU NOEUD
C     I D'UN ELEMENT : SOMME/S_ELEMENT(X*NI,Y*NI,Z*NI)DS
C        AVEC  X = XM - XG = NJ*XJ - XG
C              Y = YM - YG = NJ*YJ - YG
C              Z = ZM - ZG = NJ*ZJ - ZG

      LPAIN(1)  = 'PGEOMER'
      LPAIN(2)  = 'PORIGIN'
      LCHIN(1)  = NOMA//'.COORDO'
      LCHIN(2)  = '&&RAPO3D.CAORIGE'
      LPAOUT(1) = 'PVECTU1'
      LPAOUT(2) = 'PVECTU2'
      LCHOUT(1) = '&&RAPO3D.VECT_NI'
      LCHOUT(2) = '&&RAPO3D.VECT_XYZNI'

      CALL CALCUL('S','CARA_SECT_POUT4',LIGREL,2,LCHIN,LPAIN,2,LCHOUT,
     &            LPAOUT,'V','OUI')

C --- -----------------------------------------------------------------
C --- CREATION DES .RERR DES VECTEURS EN SORTIE DE CALCUL
      CALL MEMARE('V','&&RAPO3D',MOD,' ',' ','CHAR_MECA')

C --- -----------------------------------------------------------------
C     ASSEMBLAGE DE LCHOUT(1) DANS LE CHAMNO DE NOM 'CH_DEPL_1'
      CALL JEDETR('&&RAPO3D           .RELR')
      CALL REAJRE('&&RAPO3D',LCHOUT(1),'V')
      CALL ASSVEC('V','CH_DEPL_1',1,'&&RAPO3D           .RELR',
     &            UN,NUMDDL,' ','ZERO',1)

C --- -----------------------------------------------------------------
C     ASSEMBLAGE DE LCHOUT(2) DANS LE CHAMNO DE NOM 'CH_DEPL_2'
      CALL JEDETR('&&RAPO3D           .RELR')
      CALL REAJRE('&&RAPO3D',LCHOUT(2),'V')
      CALL ASSVEC('V','CH_DEPL_2',1,'&&RAPO3D           .RELR',
     &            UN,NUMDDL,' ','ZERO',1)

      VALE1 = 'CH_DEPL_1          .VALE'
      VALE2 = 'CH_DEPL_2          .VALE'
      CALL JEVEUO(VALE1,'L',IDCH1)
      CALL JEVEUO(VALE2,'L',IDCH2)

C --- -----------------------------------------------------------------
C --- CREATION DES TABLEAUX NECESSAIRES A L'AFFECTATION DE LISREL
C --- MAJORANT DU NOMBRE DE TERMES DANS UNE RELATION
      NBTERM = 3*LONLIS + 3
C --- VECTEUR DU NOM DES NOEUDS
      CALL WKVECT('&&RAPO3D.LISNO','V V K8',NBTERM,JLISNO)
C --- VECTEUR DU NOM DES DDLS
      CALL WKVECT('&&RAPO3D.LISDDL','V V K8',NBTERM,JLISDL)
C --- VECTEUR DES COEFFICIENTS REELS
      CALL WKVECT('&&RAPO3D.COER','V V R',NBTERM,JLISCR)
C --- VECTEUR DES COEFFICIENTS COMPLEXES
      CALL WKVECT('&&RAPO3D.COEC','V V C',NBTERM,JLISCC)
C --- VECTEUR DES DIRECTIONS DES DDLS A CONTRAINDRE
      CALL WKVECT('&&RAPO3D.DIRECT','V V R',3*NBTERM,JLISDI)
C --- VECTEUR DES DIMENSIONS DE CES DIRECTIONS
      CALL WKVECT('&&RAPO3D.DIME','V V I',NBTERM,JLISDM)

C --- -----------------------------------------------------------------
C --- RELATIONS ENTRE LES NOEUDS DE LA COQUE ET LE NOEUD POUTRE
C
C --- PREMIER GROUPE DE RELATIONS TRADUISANT :
C        SOMME/S_RACCORD(U_3D) = S_RACCORD*U_NOEUD_POUTRE
C
C --- -----------------------------------------------------------------
C --- PREMIERE RELATION :
C     -S.DX(NOEUD_POUTRE) + (SOMME/S_RACCORD(NI.DS)).DX(NOEUD_I) = 0
      NBTERM = LONLIS + 1
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA TRACE DE LA POUTRE
      DO 70 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+I-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+I-1) = 'DX'
         ZR(JLISCR+I-1)  = ZR(IDCH1+IVAL-1)
70    CONTINUE

      ZK8(JLISNO+LONLIS+1-1) = NOEPOU
      ZK8(JLISDL+LONLIS+1-1) = 'DX'
      ZR(JLISCR+LONLIS+1-1)  = -S

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- DEUXIEME RELATION :
C     -S.DY(NOEUD_POUTRE) + (SOMME/S_RACCORD(NI.DS)).DY(NOEUD_I) = 0
      NBTERM = LONLIS + 1
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA TRACE DE LA POUTRE
      DO 80 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+I-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+I-1) = 'DY'
         ZR(JLISCR+I-1)  = ZR(IDCH1+IVAL-1)
80    CONTINUE

      ZK8(JLISNO+LONLIS+1-1) = NOEPOU
      ZK8(JLISDL+LONLIS+1-1) = 'DY'
      ZR(JLISCR+LONLIS+1-1)  = -S

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- TROISIEME RELATION :
C     -S.DZ(NOEUD_POUTRE) + (SOMME/S_RACCORD(NI.DS)).DZ(NOEUD_I) = 0
      NBTERM = LONLIS + 1
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA TRACE DE LA POUTRE
      DO 90 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+I-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+I-1) = 'DZ'
         ZR(JLISCR+I-1)  = ZR(IDCH1+IVAL-1)
90    CONTINUE

      ZK8(JLISNO+LONLIS+1-1) = NOEPOU
      ZK8(JLISDL+LONLIS+1-1) = 'DZ'
      ZR(JLISCR+LONLIS+1-1)  = -S

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- -----------------------------------------------------------------
C --- DEUXIEME GROUPE DE RELATIONS TRADUISANT :
C        SOMME/S_RACCORD(GM X U_3D) = I.OMEGA(NOEUD_POUTRE)
C
C --- QUATRIEME RELATION :
C        (SOMME/S_RACCORD(Y*NI.DS)).DZ(NOEUD_I) -
C        (SOMME/S_RACCORD(Z*NI.DS)).DY(NOEUD_I) -
C        IXX.DRX(NOEUD_POUTRE) - IXY.DRY(NOEUD_POUTRE) -
C        IXZ.DRZ(NOEUD_POUTRE)                          = 0
      NBTERM = 2*LONLIS + 3
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA COQUE
      DO 100 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+2*(I-1)+1-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+2*(I-1)+2-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+2*(I-1)+1-1) = 'DZ'
         ZK8(JLISDL+2*(I-1)+2-1) = 'DY'
C        SOMME/S_RACCORD(Y*NI.DS) = ZR(IDCH2+IVAL+1-1)
C        SOMME/S_RACCORD(Z*NI.DS) = ZR(IDCH2+IVAL+2-1)
         ZR(JLISCR+2*(I-1)+1-1)  =  ZR(IDCH2+IVAL-1+1)
         ZR(JLISCR+2*(I-1)+2-1)  = -ZR(IDCH2+IVAL-1+2)
100   CONTINUE

      ZK8(JLISNO+2*LONLIS+1-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+2-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+3-1) = NOEPOU

      ZK8(JLISDL+2*LONLIS+1-1) = 'DRX'
      ZK8(JLISDL+2*LONLIS+2-1) = 'DRY'
      ZK8(JLISDL+2*LONLIS+3-1) = 'DRZ'

      ZR(JLISCR+2*LONLIS+1-1)  = -IG(1)
      ZR(JLISCR+2*LONLIS+2-1)  = -IG(2)
      ZR(JLISCR+2*LONLIS+3-1)  = -IG(3)

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- CINQUIEME RELATION :
C        (SOMME/S_RACCORD(Z*NI.DS)).DX(NOEUD_I) -
C        (SOMME/S_RACCORD(X*NI.DS)).DZ(NOEUD_I) -
C        IXY.DRX(NOEUD_POUTRE) - IYY.DRY(NOEUD_POUTRE) -
C        IYZ.DRZ(NOEUD_POUTRE)                            = 0
      NBTERM = 2*LONLIS + 3
C     BOUCLE SUR LES NOEUDS DES MAILLES DE SURFACE DU MASSIF
      DO 110 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO+ (INO-1)* (NBEC+2))

         ZK8(JLISNO+2*(I-1)+1-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+2*(I-1)+2-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+2*(I-1)+1-1) = 'DX'
         ZK8(JLISDL+2*(I-1)+2-1) = 'DZ'
C        SOMME/S_RACCORD(Z*NI.DS) = ZR(IDCH2+IVAL+2-1)
C        SOMME/S_RACCORD(X*NI.DS) = ZR(IDCH2+IVAL-1)
         ZR(JLISCR+2*(I-1)+1-1)  =  ZR(IDCH2+IVAL-1+2)
         ZR(JLISCR+2*(I-1)+2-1)  = -ZR(IDCH2+IVAL-1)
110   CONTINUE

      ZK8(JLISNO+2*LONLIS+1-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+2-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+3-1) = NOEPOU

      ZK8(JLISDL+2*LONLIS+1-1) = 'DRX'
      ZK8(JLISDL+2*LONLIS+2-1) = 'DRY'
      ZK8(JLISDL+2*LONLIS+3-1) = 'DRZ'

      ZR(JLISCR+2*LONLIS+1-1)  = -IG(2)
      ZR(JLISCR+2*LONLIS+2-1)  = -IG(4)
      ZR(JLISCR+2*LONLIS+3-1)  = -IG(5)

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- SIXIEME RELATION :
C        (SOMME/S_RACCORD(X*NI.DS)).DY(NOEUD_I) -
C        (SOMME/S_RACCORD(Y*NI.DS)).DX(NOEUD_I) -
C        IXZ.DRX(NOEUD_POUTRE) - IYZ.DRY(NOEUD_POUTRE) -
C        IZZ.DRZ(NOEUD_POUTRE)                            = 0
      NBTERM = 2*LONLIS + 3
C     BOUCLE SUR LES NOEUDS DES MAILLES DE SURFACE DU MASSIF
      DO 120 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO+ (INO-1)* (NBEC+2))

         ZK8(JLISNO+2*(I-1)+1-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+2*(I-1)+2-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+2*(I-1)+1-1) = 'DY'
         ZK8(JLISDL+2*(I-1)+2-1) = 'DX'
C        SOMME/S_RACCORD(X*NI.DS) = ZR(IDCH2+IVAL-1)
C        SOMME/S_RACCORD(Y*NI.DS) = ZR(IDCH2+IVAL+1-1)
         ZR(JLISCR+2*(I-1)+1-1)  =  ZR(IDCH2+IVAL-1)
         ZR(JLISCR+2*(I-1)+2-1)  = -ZR(IDCH2+IVAL-1+1)
120   CONTINUE

      ZK8(JLISNO+2*LONLIS+1-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+2-1) = NOEPOU
      ZK8(JLISNO+2*LONLIS+3-1) = NOEPOU

      ZK8(JLISDL+2*LONLIS+1-1) = 'DRX'
      ZK8(JLISDL+2*LONLIS+2-1) = 'DRY'
      ZK8(JLISDL+2*LONLIS+3-1) = 'DRZ'

      ZR(JLISCR+2*LONLIS+1-1)  = -IG(3)
      ZR(JLISCR+2*LONLIS+2-1)  = -IG(5)
      ZR(JLISCR+2*LONLIS+3-1)  = -IG(6)

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C === =================================================================
C === TRAITEMENT PLAQ_POUT_ORTH : DANS LE REPERE LOCAL DE LA COQUE
      IF (OPTION.EQ.'PLAQ_POUT_ORTH') THEN
C --- -----------------------------------------------------------------
C --- TROISIEME GROUPE DE RELATIONS TRADUISANT DANS LE PLAN TANGENT
C        SOMME/S_RACCORD(OMEGA_NOEUD_I) = S_RACCORD*OMEGA(NOEUD_POUTRE)
C
C --- -----------------------------------------------------------------
C --- PREMIERE RELATION :
C     -S.DRX(NOEUD_POUTRE) + (SOMME/S_RACCORD(NI.DS)).DRX(NOEUD_I) = 0
      NBTERM = 3*LONLIS + 3
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA TRACE DE LA POUTRE
      DO 130 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+3*(I-1)+1-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+3*(I-1)+2-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+3*(I-1)+3-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+3*(I-1)+1-1) = 'DRX'
         ZK8(JLISDL+3*(I-1)+2-1) = 'DRY'
         ZK8(JLISDL+3*(I-1)+3-1) = 'DRZ'
         ZR( JLISCR+3*(I-1)+1-1)  =  VTANG(1)*ZR(IDCH1+IVAL-1)
         ZR( JLISCR+3*(I-1)+2-1)  =  VTANG(2)*ZR(IDCH1+IVAL-1)
         ZR( JLISCR+3*(I-1)+3-1)  =  VTANG(3)*ZR(IDCH1+IVAL-1)
130   CONTINUE

      ZK8(JLISNO+3*LONLIS+1-1) = NOEPOU
      ZK8(JLISNO+3*LONLIS+2-1) = NOEPOU
      ZK8(JLISNO+3*LONLIS+3-1) = NOEPOU
      ZK8(JLISDL+3*LONLIS+1-1) = 'DRX'
      ZK8(JLISDL+3*LONLIS+2-1) = 'DRY'
      ZK8(JLISDL+3*LONLIS+3-1) = 'DRZ'
      ZR( JLISCR+3*LONLIS+1-1)  = -S*VTANG(1)
      ZR( JLISCR+3*LONLIS+2-1)  = -S*VTANG(2)
      ZR( JLISCR+3*LONLIS+3-1)  = -S*VTANG(3)

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

C --- PREMIERE RELATION :
C     -S.DRY(NOEUD_POUTRE) + (SOMME/S_RACCORD(NI.DS)).DRY(NOEUD_I) = 0
      NBTERM = 3*LONLIS + 3
C     BOUCLE SUR LES NOEUDS DES MAILLES DE LA TRACE DE LA POUTRE
      DO 140 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO + (INO-1)*(NBEC+2))

         ZK8(JLISNO+3*(I-1)+1-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+3*(I-1)+2-1) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+3*(I-1)+3-1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+3*(I-1)+1-1) = 'DRX'
         ZK8(JLISDL+3*(I-1)+2-1) = 'DRY'
         ZK8(JLISDL+3*(I-1)+3-1) = 'DRZ'
         ZR( JLISCR+3*(I-1)+1-1)  =  VTANG(4)*ZR(IDCH1+IVAL-1)
         ZR( JLISCR+3*(I-1)+2-1)  =  VTANG(5)*ZR(IDCH1+IVAL-1)
         ZR( JLISCR+3*(I-1)+3-1)  =  VTANG(6)*ZR(IDCH1+IVAL-1)
140   CONTINUE

      ZK8(JLISNO+3*LONLIS+1-1) = NOEPOU
      ZK8(JLISNO+3*LONLIS+2-1) = NOEPOU
      ZK8(JLISNO+3*LONLIS+3-1) = NOEPOU
      ZK8(JLISDL+3*LONLIS+1-1) = 'DRX'
      ZK8(JLISDL+3*LONLIS+2-1) = 'DRY'
      ZK8(JLISDL+3*LONLIS+3-1) = 'DRZ'
      ZR( JLISCR+3*LONLIS+1-1)  = -S*VTANG(4)
      ZR( JLISCR+3*LONLIS+2-1)  = -S*VTANG(5)
      ZR( JLISCR+3*LONLIS+3-1)  = -S*VTANG(6)

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)

      ENDIF
C === =================================================================

C --- -----------------------------------------------------------------
C --- RACCORD 3D - TUYAU : LIAISONS SUR DDLS DE FOURIER
      IF ( OPTION.EQ.'3D_TUYAU' ) THEN
         CALL GETVID(MOTFAC,'CARA_ELEM',IOCC,IARG,1,CARA,NCARA)
         IF (NCARA.EQ.0) THEN
            CALL U2MESS('F','MODELISA6_47')
         END IF
         CALL RATU3D(ZI(IAPRNO),LONLIS,ZK8(ILISNO),NOEPOU,NOMA,LIGREL,
     &               MOD,CARA,NUMDDL,TYPLAG,LISREL,COORIG,S)
      END IF

C --- -----------------------------------------------------------------
C --- DESTRUCTION DES OBJETS DE TRAVAIL
      CALL JEDETC('V','&&RAPO3D',1)
      CALL JEDETC('V','CH_DEPL_1',1)
      CALL JEDETC('V','CH_DEPL_2',1)

9999  CONTINUE
      CALL JEDEMA()
      END
