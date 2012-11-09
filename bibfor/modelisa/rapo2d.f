      SUBROUTINE RAPO2D(NUMDLZ,IOCC,FONREZ,LISREZ,CHARGZ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  TOLE CRP_20
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      CHARACTER*(*) NUMDLZ,CHARGZ,FONREZ,LISREZ
C -------------------------------------------------------
C     RACCORD POUTRE-2D PAR DES RELATIONS LINEAIRES
C     ENTRE LE NOEUD DES MAILLES DE BORD DE LA STRUCTURE 2D
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


C --------- VARIABLES LOCALES ---------------------------
      INTEGER NMOCL
      PARAMETER (NMOCL=300)
      CHARACTER*1 K1BID
      CHARACTER*2 TYPLAG
      CHARACTER*4 TYPVAL,TYPCOE
      CHARACTER*8 BETAF,MOD,NOMG,K8BID,POSLAG
      CHARACTER*8 NOMA,NOMCMP(NMOCL)
      CHARACTER*8 NOEPOU,NOCMP(3),KCMP(3),NOGRNO
      CHARACTER*8 LPAIN(2),LPAOUT(2)
      CHARACTER*9 NOMTE
      CHARACTER*16 MOTFAC,MOTCLE(2),TYPMCL(2),OPTION
      CHARACTER*19 LIGRMO,LIGREL
      CHARACTER*24 LCHIN(2),LCHOUT(2),NOLILI,LISMAI
      CHARACTER*24 LISNOE,NOEUMA,VALE1,VALE2,GRNOMA
      CHARACTER*8 CHARGE
      CHARACTER*14 NUMDDL
      CHARACTER*19 LISREL
      INTEGER NTYPEL(NMOCL),ICMP(6),NIV,IFM,VALI(2)
      INTEGER IOP,NLIAI,I,NARL,NRL,IBID,JNOMA,JCOOR,INOM
      INTEGER NBCMP,NDDLA,NBEC,JPRNM,NLILI,K,IAPRNO,LONLIS,ILISNO
      INTEGER JLISMA,NBMA,NBNO,NBGNO,NNO,N1,JGRO,IN,NUMNOP
      INTEGER INO,IDINER,IDCH1,IDCH2,NBTERM
      INTEGER JLISNO,JLISDL,JLISCR,JLISCC,JLISDI,JLISDM,IVAL
      INTEGER IOCC,IER,IARG
      REAL*8 IGZZ,COORIG(3),BETA,EPS,UN,R8PREM
      REAL*8 XPOU,YPOU,S,S1,XG,YG,DNORME
      REAL*8 AX,AY,AXX,AYY
      COMPLEX*16  CBID,BETAC,CCMP(3)
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
      IF (OPTION.NE.'2D_POU')THEN
        CALL U2MESK('F','MODELISA6_39',1,OPTION)
      END IF

      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GO TO 9999

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
      CCMP(1) = (0.0D0,0.0D0)
      CCMP(2) = (0.0D0,0.0D0)
      CCMP(3) = (0.0D0,0.0D0)
      DO 10 I = 1,6
         ICMP(I) = 0
   10 CONTINUE

      LIGREL    = '&&RAPO2D'
      LISNOE    = '&&RAPO2D.LISTE_NOEUDS'
      LISMAI    = '&&RAPO2D.LISTE_MAILLES'
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
C --- CONSTITUTION DU LIGREL FORME DES MAILLES DE BORD DE LA SURFACE 2D
C
C --- CREATION ET AFFECTATION DU VECTEUR DE K8 DE NOM LISMAI
C     CONTENANT LES NOMS DES MAILLES FORMANT LE LIGREL A CREER
      CALL RELIEM(' ',NOMA,'NU_MAILLE',MOTFAC,IOCC,2,MOTCLE(1),
     &            TYPMCL(1),LISMAI,NBMA)
      CALL JEVEUO(LISMAI,'L',JLISMA)

C     CREATION ET AFFECTATION DU LIGREL
      CALL EXLIM1(ZI(JLISMA),NBMA,MOD,'V',LIGREL)

C --- -----------------------------------------------------------------
C --- ACQUISITION DES MOTS-CLES NOEUD_2 OU GROUP_NO_2
      NBNO = 0
      NBGNO = 0

      CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD_2',IOCC,IARG,0,K8BID,NBNO)

      IF (NBNO.EQ.0) THEN
         CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO_2',IOCC,IARG,
     &               0,K8BID,NBGNO)
         IF (NBGNO.EQ.0) THEN
            CALL U2MESK('F','MODELISA6_40',1,MOTFAC)
         END IF
      END IF

      IF (NBNO.NE.0) THEN
         NBNO = -NBNO
         IF (NBNO.NE.1) THEN
            CALL U2MESS('F','MODELISA6_41')
         END IF
         CALL GETVEM(NOMA,'NOEUD',MOTFAC,'NOEUD_2',IOCC,IARG,
     &               NBNO,NOEPOU,NNO)
      END IF

      IF (NBGNO.NE.0) THEN
         NBGNO = -NBGNO
         IF (NBGNO.NE.1) THEN
            CALL U2MESS('F','MODELISA6_42')
         END IF
         CALL GETVEM(NOMA,'GROUP_NO',MOTFAC,'GROUP_NO_2',IOCC,IARG,
     &               NBGNO,NOGRNO,NNO)
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

C --- -----------------------------------------------------------------
C --- CALCUL SUR CHAQUE ELEMENT DE BORD A RELIER A LA POUTRE
C     DES CARACTERISTIQUES GEOMETRIQUES SUIVANTES :
C        SOMME/B_ELEMENT(1,X,Y,X*X,Y*Y,X*Y)DS
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = NOMA//'.COORDO'
      LPAOUT(1) = 'PCASECT'
      LCHOUT(1) = '&&RAPO2D.PSECT'

      CALL CALCUL('S','CARA_SECT_POUT3',LIGREL,1,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V','OUI')

C --- -----------------------------------------------------------------
C --- VECTEUR DES QUANTITES GEOMETRIQUES PRECITEES SOMMEES
C     SUR LA SURFACE DE RACCORD, CES QUANTITES SERONT NOTEES :
C        A1 = S,AX,AY,AXX,AYY
      CALL WKVECT('&&RAPO2D.INERTIE_RACCORD','V V R',6,IDINER)
C --- -----------------------------------------------------------------
C     SOMMATION DES QUANTITES GEOMETRIQUES ELEMENTAIRES
C     DANS LE VECTEUR &&RAPO2D.INERTIE_RACCORD :
      CALL MESOMM(LCHOUT(1),6,IBID,ZR(IDINER),CBID,0,IBID)

      S   = ZR(IDINER+1-1)
      AX  = ZR(IDINER+2-1)
      AY  = ZR(IDINER+3-1)
      AXX = ZR(IDINER+4-1)
      AYY = ZR(IDINER+5-1)

      IF (ABS(S).LT.R8PREM()) THEN
         CALL U2MESS('F','MODELISA6_46')
      END IF
      S1 = 1.0D0/S

C --- -----------------------------------------------------------------
C --- COORDONNEES DU CENTRE GEOMETRIQUE G DE LA SECTION DE RACCORD
C     XG = AX/S, YG = AY/S
      XG = S1*AX
      YG = S1*AY

C --- -----------------------------------------------------------------
C     VERIFICATION DE L'IDENTITE GEOMETRIQUE DE G AVEC LE
C     NOEUD POUTRE A RACCORDER :
      DNORME = SQRT((XPOU-XG)*(XPOU-XG)+ (YPOU-YG)*(YPOU-YG))
      IF (DNORME.GT.EPS) THEN
         CALL ASSERT(.FALSE.)
      ENDIF


C --- -----------------------------------------------------------------
C     CALCUL DE LA COMPOSANTE IZZ DU TENSEUR D'INERTIE EN G
      IGZZ = AXX + AYY - S*(XG*XG+YG*YG)

C --- -----------------------------------------------------------------
C     NOTATION DANS LA CARTE DE NOM '&&RAPO2D.CAORIGE' DES
C     COORDONNEES DU CENTRE GEOMETRIQUE G DE LA SECTION DE RACCORD
      NOCMP(1) = 'X'
      NOCMP(2) = 'Y'

      COORIG(1) = XG
      COORIG(2) = YG

      CALL MECACT('V','&&RAPO2D.CAORIGE','LIGREL',LIGREL,'GEOM_R',2,
     &            NOCMP,ICMP,COORIG,CCMP,KCMP)

C --- DETERMINATION DE 2 LISTES  DE VECTEURS PAR ELEMENT PRENANT
C     LEURS VALEURS AUX NOEUDS DES ELEMENTS.
C --- LA PREMIERE LISTE DE NOM 'VECT_NI' A POUR VALEURS AU NOEUD
C     I D'UN ELEMENT : SOMME/S_ELEMENT(NI,0)DS
C --- LA SECONDE LISTE DE NOM 'VECT_XYNI' A POUR VALEURS AU NOEUD
C     I D'UN ELEMENT : SOMME/S_ELEMENT(X*NI,Y*NI)DS
C        AVEC  X = XM - XG = NJ*XJ - XG
C              Y = YM - YG = NJ*YJ - YG

      LPAIN(1)  = 'PGEOMER'
      LPAIN(2)  = 'PORIGIN'
      LCHIN(1)  = NOMA//'.COORDO'
      LCHIN(2)  = '&&RAPO2D.CAORIGE'
      LPAOUT(1) = 'PVECTU1'
      LPAOUT(2) = 'PVECTU2'
      LCHOUT(1) = '&&RAPO2D.VECT_NI'
      LCHOUT(2) = '&&RAPO2D.VECT_XYZNI'

      CALL CALCUL('S','CARA_SECT_POUT4',LIGREL,2,LCHIN,LPAIN,2,LCHOUT,
     &            LPAOUT,'V','OUI')

C --- -----------------------------------------------------------------
C --- CREATION DES .RERR DES VECTEURS EN SORTIE DE CALCUL
      CALL MEMARE('V','&&RAPO2D',MOD,' ',' ','CHAR_MECA')

C --- -----------------------------------------------------------------
C     ASSEMBLAGE DE LCHOUT(1) DANS LE CHAMNO DE NOM 'CH_DEPL_1'
      CALL JEDETR('&&RAPO2D           .RELR')
      CALL REAJRE('&&RAPO2D',LCHOUT(1),'V')
      CALL ASSVEC('V','CH_DEPL_1',1,'&&RAPO2D           .RELR',
     &            UN,NUMDDL,' ','ZERO',1)

C --- -----------------------------------------------------------------
C     ASSEMBLAGE DE LCHOUT(2) DANS LE CHAMNO DE NOM 'CH_DEPL_2'
      CALL JEDETR('&&RAPO2D           .RELR')
      CALL REAJRE('&&RAPO2D',LCHOUT(2),'V')
      CALL ASSVEC('V','CH_DEPL_2',1,'&&RAPO2D           .RELR',
     &            UN,NUMDDL,' ','ZERO',1)

      VALE1 = 'CH_DEPL_1          .VALE'
      VALE2 = 'CH_DEPL_2          .VALE'
      CALL JEVEUO(VALE1,'L',IDCH1)
      CALL JEVEUO(VALE2,'L',IDCH2)

C --- -----------------------------------------------------------------
C --- CREATION DES TABLEAUX NECESSAIRES A L'AFFECTATION DE LISREL
C --- MAJORANT DU NOMBRE DE TERMES DANS UNE RELATION
      NBTERM = 2*LONLIS + 2
C --- VECTEUR DU NOM DES NOEUDS
      CALL WKVECT('&&RAPO2D.LISNO','V V K8',NBTERM,JLISNO)
C --- VECTEUR DU NOM DES DDLS
      CALL WKVECT('&&RAPO2D.LISDDL','V V K8',NBTERM,JLISDL)
C --- VECTEUR DES COEFFICIENTS REELS
      CALL WKVECT('&&RAPO2D.COER','V V R',NBTERM,JLISCR)
C --- VECTEUR DES COEFFICIENTS COMPLEXES
      CALL WKVECT('&&RAPO2D.COEC','V V C',NBTERM,JLISCC)
C --- VECTEUR DES DIRECTIONS DES DDLS A CONTRAINDRE
      CALL WKVECT('&&RAPO2D.DIRECT','V V R',2*NBTERM,JLISDI)
C --- VECTEUR DES DIMENSIONS DE CES DIRECTIONS
      CALL WKVECT('&&RAPO2D.DIME','V V I',NBTERM,JLISDM)

C --- -----------------------------------------------------------------
C --- RELATIONS ENTRE LES NOEUDS DU BORD ET LE NOEUD POUTRE
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


C --- -----------------------------------------------------------------
C --- DEUXIEME GROUPE DE RELATIONS TRADUISANT :
C        SOMME/S_RACCORD(GM X U_3D) = I.OMEGA(NOEUD_POUTRE)
C

C --- TOISIEME RELATION :
C        (SOMME/S_RACCORD(X*NI.DS)).DY(NOEUD_I) -
C        (SOMME/S_RACCORD(Y*NI.DS)).DX(NOEUD_I) -
C        IZZ.DRZ(NOEUD_POUTRE)                            = 0
      NBTERM = 2*LONLIS + 1
C     BOUCLE SUR LES NOEUDS DES MAILLES DE SURFACE DU MASSIF
      DO 120 I = 1,LONLIS
         CALL JENONU(JEXNOM(NOEUMA,ZK8(ILISNO+I-1)),INO)
C        ADRESSE DE LA PREMIERE COMPOSANTE DU NOEUD INO DANS LES CHAMNO
         IVAL = ZI(IAPRNO+ (INO-1)* (NBEC+2))

         ZK8(JLISNO+2*(I-1)  ) = ZK8(ILISNO+I-1)
         ZK8(JLISNO+2*(I-1)+1) = ZK8(ILISNO+I-1)
         ZK8(JLISDL+2*(I-1)  ) = 'DY'
         ZK8(JLISDL+2*(I-1)+1) = 'DX'
         ZR(JLISCR+2*(I-1)  )  =  ZR(IDCH2+IVAL-1)
         ZR(JLISCR+2*(I-1)+1)  = -ZR(IDCH2+IVAL-1+1)
120   CONTINUE

      ZK8(JLISNO+2*LONLIS+1-1) = NOEPOU
      ZK8(JLISDL+2*LONLIS+1-1) = 'DRZ'
      ZR(JLISCR+2*LONLIS+1-1)  = -IGZZ

      CALL AFRELA(ZR(JLISCR),ZC(JLISCC),ZK8(JLISDL),ZK8(JLISNO),
     &            ZI(JLISDM),ZR(JLISDI),NBTERM,BETA,BETAC,BETAF,TYPCOE,
     &            TYPVAL,TYPLAG,0.D0,LISREL)
      CALL IMPREL(MOTFAC,NBTERM,ZR(JLISCR),ZK8(JLISDL),ZK8(JLISNO),BETA)


C --- -----------------------------------------------------------------
C --- DESTRUCTION DES OBJETS DE TRAVAIL

      CALL JEDETR('&&RAPO2D.LISTE_NOEUDS')
      CALL JEDETR('&&RAPO2D.LISTE_MAILLES')
      CALL DETRSD('CHAMP_GD','&&RAPO2D.PSECT')
      CALL JEDETR('&&RAPO2D.INERTIE_RACCORD')
      CALL DETRSD('CARTE','&&RAPO2D.CAORIGE')
      CALL DETRSD('RESUELEM','&&RAPO2D.VECT_NI')
      CALL DETRSD('RESUELEM','&&RAPO2D.VECT_XYZNI')
      CALL JEDETR('&&RAPO2D           .RELR')
      CALL JEDETR('&&RAPO2D           .RERR')
      CALL JEDETR('&&RAPO2D.LISNO')
      CALL JEDETR('&&RAPO2D.LISDDL')
      CALL JEDETR('&&RAPO2D.COER')
      CALL JEDETR('&&RAPO2D.COEC')
      CALL JEDETR('&&RAPO2D.DIRECT')
      CALL JEDETR('&&RAPO2D.DIME')
      CALL DETRSD('LIGREL',LIGREL)
      CALL DETRSD('CHAMP_GD','CH_DEPL_1')
      CALL DETRSD('CHAMP_GD','CH_DEPL_2')

9999  CONTINUE
      CALL JEDEMA()
      END
