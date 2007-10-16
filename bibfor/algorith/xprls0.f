      SUBROUTINE XPRLS0(NOMA,FISS,NOESOM,CNSLN,CNSLT,ISOZRO,LEVSET)
      IMPLICIT NONE
      CHARACTER*2    LEVSET
      CHARACTER*8    NOMA,FISS
      CHARACTER*19   CNSLN,CNSLT,ISOZRO,NOESOM

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/10/2007   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MASSIN P.MASSIN
C     ------------------------------------------------------------------
C
C       XPRLS0   : X-FEM PROPAGATION : CALCUL DES LS PROCHE DES ISO-0
C       ------     -     --                       --                -
C    DANS LE CADRE DE LA PROPAGAGTION DE FISSURE XFEM, CALCUL DES VRAIES
C     FONCTIONS DE DISTANCE SIGNEE SUR LES NOEUDS DES MAILLES COUPEES
C     PAR L'ISOZERO D'UNE LEVEL SET.
C    SI LEVSET='LN' : ON CALCULE LN & LT AU VOISINAGE DE LN=0
C    SI LEVSET='LT' : ON CALCULE LT AU VOISINAGE DE LT=0
C
C    ENTREE
C        NOMA    :   NOM DU CONCEPT MAILLAGE
C        FISS    :   NOM DU CONCEPT FISSURE XFEM
C        NOESOM  :   VECTEUR LOGIQUE CONTENANT L'INFO. 'NOEUD SOMMET'
C        CNSLN   :   CHAM_NO_S LEVEL SET NORMALE
C        CNSLT   :   CHAM_NO_S LEVEL SET TANGENTE
C        LEVSET  :   ='LN' SI ON REINITIALISE LN
C                    ='LT' SI ON REINITIALISE LT
C    SORTIE
C        CNSLN   :   CHAM_NO_S LEVEL SET NORMALE
C(                   (CALCULEE SEULEMENT SI LEVSET = 'LN')
C        CNSLT   :   CHAM_NO_S LEVEL SET NORMALE CALCULEE
C        ISOZRO  :   VECTEUR LOGIQUE IDIQUANT SI LA "VRAIE" LEVEL SET
C                    (DISTANCE SIGNEE) A ETE CALCULEE
C
C     ------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32    JEXNUM,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER        I,INO,INOA,INOB,IMA,IFM,NIV,NBNO,NBMA,IRET,JCONX1,
     &               JCONX2,ADDIM,NDIM,JZERO,JMACO,NBMACO,NBNOMA,JMAI,
     &               NUNOA,NUNOB,JNOMCO,NBNOCO,NUNO,NMAABS,NPTINT,NTRI,
     &               ITYPMA,ITRI,JCOOR,JNOSOM,NBNOZO,IA,IB,IC,CPTZO,
     &               JLSNO,JLTNO,JNOULS,JNOULT,AR(12,2),NBAR,IAR,NA,NB
      REAL*8         R8PREM,P(3),X(6),Y(6),Z(6),XA,YA,ZA,XB,YB,
     &               ZB,S,A(3),B(3),C(3),EPS(3),M(3),D,VN(3),NORMGR,
     &               LSNA,LSNB,LSTA,LSTB,LSTC,LST(6),BESTD,BESTDI,LSN,
     &               BESTLT,BESTLI
      CHARACTER*2    NPTIK2
      CHARACTER*8    K8B,TYPMA,NOMAIL
      CHARACTER*19   MAICOU,NOMCOU,VNOULS,VNOULT,MAI
      CHARACTER*24 VALK(4)
      LOGICAL        DEJAIN,DEJADI,NOEMAI,IN

C  TRIANGLES ABC QUE L'ON PEUT FORMER A PARTIR DE N POINTS (N=3 A 6)
      REAL*8         IATRI(20),IBTRI(20),ICTRI(20)
C        ---------------------
C        |  I | TRIANGLE | N |
C        --------------------
C        |  1 |   1 2 3  | 3 |
C        --------------------
C        |  2 |   1 2 4  |   |
C        |  3 |   1 3 4  | 4 |
C        |  4 |   2 3 4  |   |
C        --------------------
C        |  5 |   1 2 5  |   |
C        |  6 |   1 3 5  |   |
C        |  7 |   1 4 5  | 5 |
C        |  8 |   2 3 5  |   |
C        |  9 |   2 4 5  |   |
C        | 10 |   3 4 5  |   |
C        --------------------
C        | 11 |   1 2 6  |   |
C        | 12 |   1 3 6  |   |
C        | 13 |   1 4 6  |   |
C        | 14 |   1 5 6  |   |
C        | 15 |   2 3 6  | 6 |
C        | 16 |   2 4 6  |   |
C        | 17 |   2 5 6  |   |
C        | 18 |   3 4 6  |   |
C        | 19 |   3 5 6  |   |
C        | 20 |   4 5 6  |   |
C        --------------------
      DATA   IATRI/1,1,1,2,1,1,1,2,2,3,1,1,1,1,2,2,2,3,3,4/
      DATA   IBTRI/2,2,3,3,2,3,4,3,4,4,2,3,4,5,3,4,5,4,5,5/
      DATA   ICTRI/3,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6/

C-----------------------------------------------------------------------
C     DEBUT
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

C      IF (NIV.GT.1)
      WRITE(IFM,*)'   CALCUL DES LEVEL SETS A PROXIMITE '
     &   //'DE L''ISOZERO DE '//LEVSET//'.'

C  RECUPERATION DES CARACTERISTIQUES DU MAILLAGE
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8B,IRET)
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8B,IRET)
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      MAI = NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMAI)
      CALL JEVEUO(NOMA//'.DIME','L',ADDIM)
      NDIM=ZI(ADDIM-1+6)

C   RECUPERATION DE L'ADRESSE DES VALEURS DES LS
      IF (LEVSET.EQ.'LN') THEN
         CALL JEVEUO(CNSLN//'.CNSV','E',JLSNO)
         CALL JEVEUO(CNSLT//'.CNSV','E',JLTNO)
      ELSEIF (LEVSET.EQ.'LT') THEN
         CALL JEVEUO(CNSLT//'.CNSV','E',JLSNO)
      ENDIF

C  RECUPERATION DE L'ADRESSE DE L'INFORMATION 'NOEUD SOMMET'
      CALL JEVEUO(NOESOM,'L',JNOSOM)

C  RECUPERATION DE L'ADRESSE DES VALEURS DE ISOZRO
      CALL JEVEUO(ISOZRO,'E',JZERO)
      DO 10 INO=1,NBNO
         ZL(JZERO-1+INO)=.FALSE.
 10   CONTINUE

C-----------------------------------------------------------------------
C     DANS UN PREMIER TEMPS,ON S'OCCUPE DES NOEUDS SOMMETS SUR L'ISOZERO
C     ( UTILE DANS LE CAS DE MAILLES 1 OU 2 NOEUDS SONT A 0 )
C-----------------------------------------------------------------------
      NBNOZO=0
      DO 50 INO=1,NBNO
         IF ( ABS(ZR(JLSNO-1+INO)).LT.R8PREM() .AND.
     &        ZL(JNOSOM-1+INO) ) THEN
            ZR(JLSNO-1+INO)=0.D0
            ZL(JZERO-1+INO)=.TRUE.
            NBNOZO = NBNOZO+1
         ENDIF
 50   CONTINUE

C--------------------------------------------------------------------
C     ON REPERE LES MAILLES VOLUMIQUES COUPEES OU TANGENTEES PAR LS=0
C     ( I.E. LES MAILLES OU L'ON PEUT INTERPOLER UN PLAN LS=0 )
C--------------------------------------------------------------------
C  VECTEUR CONTENANT LES NUMEROS DE MAILLES COUPEES
      MAICOU = '&&XPRLS0.MAICOU'
      CALL WKVECT(MAICOU,'V V I',NBMA,JMACO)

      NBMACO=0
      DO 100 IMA=1,NBMA

C   VERIFICATION DU TYPE DE MAILLE
         ITYPMA=ZI(JMAI-1+IMA)
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
         IF (NDIM.EQ.3.AND.TYPMA(1:5).NE.'TETRA'.AND.
     &       TYPMA(1:5).NE.'PENTA'.AND.TYPMA(1:4).NE.'HEXA') GOTO 100
         IF (NDIM.EQ.2.AND.
     &       TYPMA(1:4).NE.'TETRA'.AND.TYPMA(1:4).NE.'QUAD') GOTO 100
         NBNOMA = ZI(JCONX2+IMA) - ZI(JCONX2+IMA-1)

C  ON COMPTE D'ABORD LE NOMBRE DE NOEUDS DE LA MAILLE QUI S'ANNULENT
         CPTZO=0
         DO 105 INOA=1,NBNOMA
            NUNOA=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+INOA-1)
            LSNA = ZR(JLSNO-1+NUNOA)
            IF (ABS(LSNA).LT.R8PREM().AND.ZL(JNOSOM-1+NUNOA))
     &         CPTZO = CPTZO+1
 105     CONTINUE

C  SI AU MOINS TROIS NOEUDS S'ANNULENT,ON A UN PLAN D'INTERSECTION
         IF (CPTZO.GE.3) THEN
            NBMACO = NBMACO + 1
            ZI(JMACO-1+NBMACO) = IMA
            GOTO 100
         ENDIF

C  ON PARCOURS LES ARETES DE L'ELEMENT
         ITYPMA=ZI(JMAI-1+IMA)
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
         CALL CONARE(TYPMA,AR,NBAR)
         DO 110 IAR = 1,NBAR
            NA=AR(IAR,1)
            NB=AR(IAR,2)
            NUNOA=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NA-1)
            NUNOB=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NB-1)
            LSNA = ZR(JLSNO-1+NUNOA)
            LSNB = ZR(JLSNO-1+NUNOB)
C  SI UNE ARETE EST COUPEE,LA MAILLE L'EST FORCEMENT
            IF ((LSNA*LSNB).LT.0.D0.AND.
     &          (ABS(LSNA).GT.R8PREM()).AND.
     &          (ABS(LSNB).GT.R8PREM())) THEN
               NBMACO = NBMACO + 1
               ZI(JMACO-1+NBMACO) = IMA
               GOTO 100
            ENDIF
 110     CONTINUE

 100  CONTINUE

C-----------------------------------------------------
C     ON REPERE LES NOEUDS SOMMETS DES MAILLES COUPEES
C-----------------------------------------------------
C  VECTEUR CONTENANT LES NUMEROS DE NOEUD DES MAILLES COUPEES
      NOMCOU = '&&XPRLS0.NOMCOU'
      CALL WKVECT(NOMCOU,'V V I',NBMACO*6,JNOMCO)

      NBNOCO=0
C  BOUCLE SUR LES NOEUDS
      DO 200 INOA=1,NBNO
C  ON NE CONSIDERE QUE LE NOEUDS SOMMETS
         IF (ZL(JNOSOM-1+INOA)) THEN
C  BOUCLE SUR LES MAILLES COUPEES
            DO 210 IMA=1,NBMACO
               NMAABS = ZI(JMACO-1+IMA)
               NBNOMA = ZI(JCONX2+NMAABS)-ZI(JCONX2+NMAABS-1)
C  BOUCLE SUR LES NOEUDS DE LA MAILLE
               DO 220 INOB=1,NBNOMA
                  NUNOB = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INOB-1)
                  IF (NUNOB.EQ.INOA) THEN
                     NBNOCO = NBNOCO+1
                     ZI(JNOMCO-1+NBNOCO) = INOA
                     GOTO 200
                  ENDIF
 220           CONTINUE
 210        CONTINUE
         ENDIF
 200  CONTINUE

C----------------------------------------------
C     CALCUL DES LS SUR LES NOEUDS SELECTIONNES
C----------------------------------------------
C  VECTEURS CONTENANT LES NOUVELLES LS POUR LES NOEUDS DE NOMCOU
      VNOULS = '&&XPRLS0.VNOULS'
      CALL WKVECT(VNOULS,'V V R',NBNOCO,JNOULS)

      IF (LEVSET.EQ.'LN') THEN
         VNOULT = '&&XPRLS0.VNOULT'
         CALL WKVECT(VNOULT,'V V R',NBNOCO,JNOULT)
      ENDIF

C  BOUCLE SUR LES NOEUDS DES MAILLES COUPEES
C  -----------------------------------------
      DO 300 INO=1,NBNOCO
         NUNO = ZI(JNOMCO-1+INO)
         LSN = ZR(JLSNO-1+NUNO)

C  SI LE NOEUD EST SUR L'ISOZERO, ON L'A DEJA REPERE
         IF (ZL(JZERO-1+NUNO)) THEN
            ZR(JNOULS-1+INO) = 0.D0
            IF (LEVSET.EQ.'LN') ZR(JNOULT-1+INO) = ZR(JLTNO-1+NUNO)
            GOTO 300
         ENDIF

         DEJAIN=.FALSE.
         DEJADI=.FALSE.

C  BOUCLE SUR LES MAILLES COUPEES DONT LE NOEUD (INO) EST SOMMET
C  -------------------------------------------------------------
C  BOUCLE SUR LES MAILLES COUPEES
         DO 310 IMA=1,NBMACO
            NMAABS = ZI(JMACO-1+IMA)
            NBNOMA = ZI(JCONX2+NMAABS)-ZI(JCONX2+NMAABS-1)

C  ON CHERCHE SI LE NOEUD(NUNO) APPARTIENT A LA MAILLE(NMAABS)
            NOEMAI=.FALSE.
            DO 320 I=1,NBNOMA
               IF (ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+I-1).EQ.NUNO)
     &             NOEMAI=.TRUE.
 320         CONTINUE

C  SI LE NOEUD APPARTIENT A LA MAILLE
            IF (NOEMAI) THEN

               P(1)=ZR(JCOOR-1+3*(NUNO-1)+1)
               P(2)=ZR(JCOOR-1+3*(NUNO-1)+2)
               P(3)=ZR(JCOOR-1+3*(NUNO-1)+3)

C  ON RECUPERE LES POINTS D'INTERSECTION ISOZERO-ARETES
               NPTINT = 0

C  ON RECHERCHE D'ABORD LES NOEUDS QUI SONT DES POINTS D'INTERSECTIONS
               DO 340 INOA=1,NBNOMA
                  NUNOA = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INOA-1)
                  IF (.NOT.ZL(JNOSOM-1+NUNOA)) GOTO 340
                  LSNA = ZR(JLSNO-1+NUNOA)
                  IF (ABS(LSNA).LT.R8PREM()) THEN
                     NPTINT = NPTINT+1
                     X(NPTINT) = ZR(JCOOR-1+NDIM*(NUNOA-1)+1)
                     Y(NPTINT) = ZR(JCOOR-1+NDIM*(NUNOA-1)+2)
                     Z(NPTINT) = ZR(JCOOR-1+NDIM*(NUNOA-1)+3)
                     IF (LEVSET.EQ.'LN') LST(NPTINT)=ZR(JLTNO-1+NUNOA)

                  ENDIF
 340           CONTINUE

C  ON PARCOURT ENSUITE LES ARETES [AB] DE LA MAILLE
               ITYPMA=ZI(JMAI-1+NMAABS)
               CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
               CALL CONARE(TYPMA,AR,NBAR)
               DO 330 IAR = 1,NBAR
                  NA=AR(IAR,1)
                  NB=AR(IAR,2)

                  NUNOA=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+NA-1)
                  NUNOB=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+NB-1)
                  LSNA = ZR(JLSNO-1+NUNOA)
                  LSNB = ZR(JLSNO-1+NUNOB)

                  IF ((LSNA*LSNB.LT.0.D0).AND.
     &                (ABS(LSNA).GT.R8PREM()).AND.
     &                (ABS(LSNB).GT.R8PREM())) THEN
C  UN POINT D'INTERSECTION SE SITUE ENTRE LES NOEUDS (NUNOA) ET (NUNOB)
                     NPTINT = NPTINT+1
                     XA = ZR(JCOOR-1+NDIM*(NUNOA-1)+1)
                     YA = ZR(JCOOR-1+NDIM*(NUNOA-1)+2)
                     ZA = ZR(JCOOR-1+NDIM*(NUNOA-1)+3)
                     XB = ZR(JCOOR-1+NDIM*(NUNOB-1)+1)
                     YB = ZR(JCOOR-1+NDIM*(NUNOB-1)+2)
                     ZB = ZR(JCOOR-1+NDIM*(NUNOB-1)+3)
                     S = ABS(LSNA) / ( ABS(LSNA) + ABS(LSNB) )
                     X(NPTINT) = XA + S*(XB-XA)
                     Y(NPTINT) = YA + S*(YB-YA)
                     Z(NPTINT) = ZA + S*(ZB-ZA)
                     IF (LEVSET.EQ.'LN') THEN
                        LSTA = ZR(JLTNO-1+NUNOA)
                        LSTB = ZR(JLTNO-1+NUNOB)
                        LST(NPTINT) = LSTA + S*(LSTB-LSTA)
                     ENDIF

                  ENDIF
 330           CONTINUE

C  VERIFICATION SUR LE NOMBRE DE POINTS D'INTERSECTION TROUVES

C              LES ARETES DE LA MAILLE 'NOMMA' DE TYPE 'TYPMA' ONT  N
C              POINTS D'INTERSECTION AVEC L'ISO-Z�RO DE 'LEVSET'
               CALL ASSERT(.NOT.(
     &             (TYPMA(1:5).EQ.'TETRA'.AND.NPTINT.GT.4).OR.
     &             (TYPMA(1:5).EQ.'PENTA'.AND.NPTINT.GT.5).OR.
     &             (TYPMA(1:4).EQ.'HEXA'.AND.NPTINT.GT.6)))

               IF (NDIM.EQ.2.AND.NPTINT.LT.2) GOTO 310
               IF (NDIM.EQ.3.AND.NPTINT.LT.3) GOTO 310
               CALL ASSERT(NPTINT.LE.6)


C  CALCUL DE DISTANCE DU NOEUD (INO) A L'ISOZERO SUR LA MAILLE (NMAABS)
C  --------------------------------------------------------------------
C  ON PARCOURS TOUS LES TRIANGLES QUE L'ON PEUT FORMER AVEC LES POINTS
C  D'INTERSECTION ISOZERO-ARETES :
               IF (NPTINT.EQ.3)  NTRI=1
               IF (NPTINT.EQ.4)  NTRI=4
               IF (NPTINT.EQ.5)  NTRI=10
               IF (NPTINT.EQ.6)  NTRI=20

               DO 350 ITRI=1,NTRI
                  IA=IATRI(ITRI)
                  IB=IBTRI(ITRI)
                  IC=ICTRI(ITRI)
                  A(1)=X(IA)
                  A(2)=Y(IA)
                  A(3)=Z(IA)
                  B(1)=X(IB)
                  B(2)=Y(IB)
                  B(3)=Z(IB)
                  C(1)=X(IC)
                  C(2)=Y(IC)
                  C(3)=Z(IC)
                  IF (LEVSET.EQ.'LN') THEN
                     LSTA=LST(IA)
                     LSTB=LST(IB)
                     LSTC=LST(IC)
                  ENDIF

                  CALL XPROJ(P,A,B,C,M,D,VN,EPS,IN)

C  ON RECHERCHE LA DISTANCE MINIMALE TELLE QUE EPS1>0 & EPS2>0 & EPS3>0
C  --------------------------------------------------------------------
C  ON STOCKE LA PREMIERE DISTANCE CALCULEE
                  IF (.NOT.DEJADI) THEN
                     BESTD = D
                     IF (LEVSET.EQ.'LN')
     &                  BESTLT = EPS(1)*LSTB + EPS(2)*LSTC + EPS(3)*LSTA
                     DEJADI=.TRUE.
                  ENDIF

C  ON STOCKE LA DISTANCE MINIMALE
                  IF (D.LT.BESTD) THEN
                     BESTD = D
                     IF (LEVSET.EQ.'LN')
     &                  BESTLT = EPS(1)*LSTB + EPS(2)*LSTC + EPS(3)*LSTA
                  ENDIF

C  ON STOCKE LA DISTANCE MINIMALE AVEC PROJECTION DANS LE TRIANGLE ABC
                  IF (IN) THEN
                     IF (.NOT.DEJAIN) THEN
                        BESTDI = D
                        IF (LEVSET.EQ.'LN') BESTLI =
     &                     EPS(1)*LSTB + EPS(2)*LSTC + EPS(3)*LSTA
                        DEJAIN=.TRUE.
                     ENDIF
                     IF (D.LT.BESTDI) THEN
                        BESTDI = D
                        IF (LEVSET.EQ.'LN') BESTLI =
     &                     EPS(1)*LSTB + EPS(2)*LSTC + EPS(3)*LSTA
                     ENDIF
                  ENDIF
 350           CONTINUE
            ENDIF
 310     CONTINUE

C  ON ATTRIBUE LES LS CORRESPONDANT AUX MEILLEURES DISTANCES TROUVEES
C  ------------------------------------------------------------------
C  (INTERIEURES, LE CAS ECHEANT)
         ZR(JNOULS-1+INO) = BESTD * SIGN(1.0D0,LSN)
         IF (LEVSET.EQ.'LN') ZR(JNOULT-1+INO) = BESTLT
         IF (DEJAIN) THEN
            ZR(JNOULS-1+INO) = BESTDI*SIGN(1.0D0,LSN)
            IF (LEVSET.EQ.'LN') ZR(JNOULT-1+INO) = BESTLI
         ENDIF

         CALL ASSERT(DEJADI)
         ZL(JZERO-1+NUNO)=.TRUE.

 300  CONTINUE

C  REMPLACEMENT DES LEVEL SETS PAR CELLES CALCULEES
C  ------------------------------------------------
      DO 400 INO=1,NBNOCO
         NUNO=ZI(JNOMCO-1+INO)
         ZR(JLSNO-1+NUNO) = ZR(JNOULS-1+INO)
         IF (LEVSET.EQ.'LN') THEN
            ZR(JLTNO-1+NUNO) = ZR(JNOULT-1+INO)
         ENDIF
 400  CONTINUE

C      IF (NIV.GT.1)
      WRITE(IFM,*)'   NOMBRE DE LEVEL SETS CALCULEES :',NBNOCO+NBNOZO

C   DESTRUCTION DES OBJETS VOLATILES
      CALL JEDETR(MAICOU)
      CALL JEDETR(NOMCOU)
      CALL JEDETR(VNOULS)
      IF (LEVSET.EQ.'LN') CALL JEDETR(VNOULT)

C-----------------------------------------------------------------------
C     FIN
C-----------------------------------------------------------------------
      CALL JEDEMA()
      END
