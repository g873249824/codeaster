      SUBROUTINE XPTFON(NOMA,NMAFON,CNSLT,CNSLN,JMAFON,NXPTFF,JFON,NFON,
     &                                          JBORD,NPTBOR,ARMIN,FISS)
      IMPLICIT NONE

      INTEGER       NMAFON,JMAFON,JFON,NFON,NXPTFF,JBORD,NPTBOR
      REAL*8        ARMIN
      CHARACTER*8   NOMA,FISS
      CHARACTER*19  CNSLT,CNSLN
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/01/2008   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C       RECHERCHE DES POINTS DU FOND DE FISSURE DANS LE CADRE DE XFEM
C
C  ENTREES :
C     NOMA         :    NOM DE L'OBJET MAILLAGE
C     NMAFON       :    NOMBRE DE MAILLES DE LA ZONE FOND DE FISSURE
C     JMAFON       :    MAILLES DE LA ZONE FOND DE FISSURE
C     NXPTFF       :    NOMBRE MAXIMUM DE POINTS DU FOND DE FISSURE
C     CNSLT,CNSLN  :    LEVEL-SETS
C     FISS         :   SD FISS_XFEM (POUR RECUP DES GRADIENTS)  
C
C  SORTIES :
C     JFON         :   ADRESSE DES POINTS DU FOND DE FISSURE
C     NFON         :   NOMBRE DE POINTS DU FOND DE FISSURE
C     JBORD        :   ADRESSE DE L'ATTRIBUT LOGIQUE 'POINT DE BORD'
C     NPTBOR       :   NOMBRE DE POINTS 'DE BORD' DU FOND DE FISSURE
C     ARMIN        :   ARETE MINIMALE DU MAILLAGE
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
      CHARACTER*32    JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER         IN,IMA,IFT,I,J,IBID,IRET,ITYPMA,IBID2(6,4),NDIM
      INTEGER         NMAABS,FT(12,3),NBFT,NA,NB,NC,NUNOA,NUNOB,NUNOC
      INTEGER         JCONX1,JCONX2,JCOOR,JLTSV,JLNSV,JMA,IPT,ADDIM
      INTEGER         JGT
      REAL*8          LSTA,LSNA,LSTB,LSNB,LSTC,LSNC,L(2,2),DETL,LL(2,2)
      REAL*8          R8PREM,EPS1,EPS2,A(3),B(3),C(3),M(3),P(3),PADIST
      REAL*8          R8B,EPS3
      REAL*8          G1A,G1B,G1C,G2A,G2B,G2C,DIRX(2),DIRY(2)
      COMPLEX*16      C16B
      CHARACTER*8     K8BID,TYPMA
      CHARACTER*19    NOMT19,MAI,CNXINV,GRLT,CHGRS
      CHARACTER*24    PARA
      CHARACTER*32    JEXATR
      LOGICAL         DEJA,FABORD
C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
      CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)
      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)

C     GRADIENT LST
      GRLT = FISS//'.GRLTNO'
      CHGRS = '&&XPTFON.GRLT'
      CALL CNOCNS(GRLT,'V',CHGRS)
      CALL JEVEUO(CHGRS//'.CNSV','L',JGT)

      CALL JEVEUO(NOMA//'.DIME','L',ADDIM)
      NDIM=ZI(ADDIM-1+6)

C     ON R�CUP�RE LA VALEUR DE LA PLUS PETITE ARETE DU MAILLAGE : ARMIN
      CALL LTNOTB(NOMA,'CARA_GEOM',NOMT19)
      PARA = 'AR_MIN                  '
      CALL TBLIVA(NOMT19,0,' ',IBID,R8B,C16B,K8BID,K8BID,R8B,PARA,K8BID,
     &            IBID,ARMIN,C16B,K8BID,IRET)
C     PROBLEME POUR RECUPERER AR_MIN DANS LA TABLE "CARA_GEOM"
      CALL ASSERT(IRET.EQ.0)
C     ARMIN NEGATIF OU NUL
      CALL ASSERT(ARMIN.GT.0)

      DO 100 I=1,NXPTFF
         ZL(JBORD-1+I)=.FALSE.
 100  CONTINUE

C     CONNECTIVITE INVERSEE
      CNXINV = '&&XPTFON.CNCINV'
      CALL CNCINV (NOMA,IBID,0,'V',CNXINV)

C     COMPTEUR : NOMBRE DE POINTS DE FONFIS TROUV�S
      IN=0
C     COMPTEUR : NOMBRE DE POINTS DE FONFIS DE BORD TROUVES
      NPTBOR=0

C     BOUCLE SUR LES MAILLES DE MAFOND
      DO 400 IMA=1,NMAFON

        NMAABS=ZI(JMAFON-1+(IMA-1)+1)
        ITYPMA=ZI(JMA-1+NMAABS)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
        CALL CONFAC(TYPMA,FT,NBFT,IBID2,IBID)
C       BOUCLE SUR LES FACES TRIANGULAIRES
        DO 410 IFT=1,NBFT
          NA=FT(IFT,1)
          NB=FT(IFT,2)
          NC=FT(IFT,3)
          NUNOA=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+NA-1)
          NUNOB=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+NB-1)
          NUNOC=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+NC-1)
          LSNA=ZR(JLNSV-1+(NUNOA-1)+1)
          LSNB=ZR(JLNSV-1+(NUNOB-1)+1)
          LSNC=ZR(JLNSV-1+(NUNOC-1)+1)
          LSTA=ZR(JLTSV-1+(NUNOA-1)+1)
          LSTB=ZR(JLTSV-1+(NUNOB-1)+1)
          LSTC=ZR(JLTSV-1+(NUNOC-1)+1)
          L(1,1)=LSNB-LSNA
          L(1,2)=LSNC-LSNA
          L(2,1)=LSTB-LSTA
          L(2,2)=LSTC-LSTA
          DETL=L(1,1)*L(2,2)-L(2,1)*L(1,2)
          IF (ABS(DETL).GT.R8PREM()) THEN
            LL(1,1)=L(2,2)/DETL
            LL(2,2)=L(1,1)/DETL
            LL(1,2)=-1*L(1,2)/DETL
            LL(2,1)=-1*L(2,1)/DETL
            EPS1=-LL(1,1)*LSNA-LL(1,2)*LSTA
            EPS2=-LL(2,1)*LSNA-LL(2,2)*LSTA
            EPS3=1.D0-(EPS1+EPS2)
            DO 411 I=1,3
              A(I)=ZR(JCOOR-1+3*(NUNOA-1)+I)
              B(I)=ZR(JCOOR-1+3*(NUNOB-1)+I)
              C(I)=ZR(JCOOR-1+3*(NUNOC-1)+I)
              M(I)=A(I)+EPS1*(B(I)-A(I))+EPS2*(C(I)-A(I))
 411        CONTINUE
C           ON CONTINUE SSI M EST DANS LE TRIANGLE
            IF (-R8PREM().LE.EPS1.AND.EPS1.LE.1.D0+R8PREM().AND.
     &          -R8PREM().LE.EPS2.AND.EPS2.LE.1.D0+R8PREM().AND.
     &          -R8PREM().LE.EPS3.AND.EPS3.LE.1.D0+R8PREM()) THEN
C             V�RIFICATION SI CE POINT A D�J� �T� TROUV�
              DEJA=.FALSE.
               DO 412 J=1,IN
                P(1)=ZR(JFON-1+4*(J-1)+1)
                P(2)=ZR(JFON-1+4*(J-1)+2)
                P(3)=ZR(JFON-1+4*(J-1)+3)
                IF (PADIST(3,P,M).LT.(ARMIN*1.D-2)) THEN
                  DEJA=.TRUE.
                  IPT=J
                ENDIF
 412          CONTINUE
              IF (.NOT.DEJA) THEN
C               CE POINT N'A PAS D�J� �T� TROUV�, ON LE GARDE
                IN=IN+1
                IPT=IN
C               AUGMENTER NXPTFF
                CALL ASSERT(IN.LT.NXPTFF)

                ZR(JFON-1+4*(IN-1)+1)=M(1)
                ZR(JFON-1+4*(IN-1)+2)=M(2)
                ZR(JFON-1+4*(IN-1)+3)=M(3)

C               SPECIAL 2d : DIRECTION DE PROPA
                IF (NDIM.EQ.2) THEN
                  G1A = ZR(JGT-1+NDIM*(NUNOA-1)+1)
                  G1B = ZR(JGT-1+NDIM*(NUNOB-1)+1)
                  G1C = ZR(JGT-1+NDIM*(NUNOC-1)+1)
                  G2A = ZR(JGT-1+NDIM*(NUNOA-1)+2)
                  G2B = ZR(JGT-1+NDIM*(NUNOB-1)+2)
                  G2C = ZR(JGT-1+NDIM*(NUNOC-1)+2)
                  DIRX(IN)=G1A+EPS1*(G1B-G1A)+EPS2*(G1C-G1A)
                  DIRY(IN)=G2A+EPS1*(G2B-G2A)+EPS2*(G2C-G2A)
                ENDIF

              ENDIF

C             ON VERIFIE SI LA FACE COURANTE EST UNE FACE DE BORD
C             CELA N'A DE SENS QU'EN 3D
              IF (NDIM.EQ.3) THEN
                 CALL XFABOR(NOMA,CNXINV,NUNOA,NUNOB,NUNOC,FABORD)
                 IF (FABORD) THEN
                    ZL(JBORD-1+IPT)=.TRUE.
                    NPTBOR=NPTBOR+1
                 ENDIF
              ENDIF
            ENDIF

          ENDIF
 410    CONTINUE
 400  CONTINUE

      NFON=IN

C     SPECIAL 2d : ON STOCKE EN POSITION 3 ET 4 LA DIRECTION DE PROPA
      IF (NDIM.EQ.2) THEN
        DO 444 I=1,NFON
          ZR(JFON-1+4*(I-1)+3)=DIRX(I)
          ZR(JFON-1+4*(I-1)+4)=DIRY(I)
 444    CONTINUE
      ENDIF

      CALL JEDETR(CNXINV)
      CALL JEDEMA()
      END
