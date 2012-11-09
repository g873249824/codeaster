      SUBROUTINE RAORFI(NOMA,LIGREL,NOEPOU,CARA,COORIG,
     &                  EG1,EG2,EG3,TYPRAC,RAYON)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER INFO,IUNIFI,IFM
      CHARACTER*8 NOEPOU,NOMA,CARA
      CHARACTER*19  LIGREL
      REAL*8 COORIG(3),EG1(3),EG2(3),EG3(3),R
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C -------------------------------------------------------
C     POUR LE RACCORD (COQUE OU 3D)_TUYAU
C
C
      INTEGER NMA,IMA,INOPOU,ICONEX,NBNO,IER,I,J,NTSEG3,JDTM,NUTYMA
      INTEGER IDESC,NCMPMX,IVALE,IPTMA,IGD,IDEBGD,JCOOR
      INTEGER INOPO1, INOPO2,ICOUDE, NNO, NTSEG4
      CHARACTER*8 K8BID,NOMGD,NOCMP(3),NOEPO1,NOEPO2,TYPRAC
      CHARACTER*19  CHCARA
      REAL*8 COORIF(3),GPL(3),GPG(3),PGL(3,3)
      REAL*8 EL1(3),EL2(3),EL3(3),COONO1(3),COONO2(3),E1(3),NORE1,RAYON
      REAL*8 PGL1(3,3),PGL2(3,3),PGL3(3,3),L,OMEGA,THETA,PGL4(3,3)
      COMPLEX*16 CCMP(3)
C
      CALL JEMARQ()
      CALL INFNIV(IFM,INFO)
C
C     RECHERCHE DE LA MAILLE IMA  CONTENANT LE NOEUD NOEPOU
C
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NMA,K8BID,IER)
      IMA = 0
      CALL JENONU(JEXNOM(NOMA//'.NOMNOE',NOEPOU),INOPOU)
      DO 55 I=1,NMA
         CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',I),'L',ICONEX)
         CALL JELIRA(JEXNUM(NOMA//'.CONNEX',I),'LONMAX',NBNO,K8BID)
         DO 56 J=1,NBNO
            IF (ZI(ICONEX+J-1).EQ.INOPOU) THEN
               IF (IMA.EQ.0) THEN
                  IMA = I
                  INOPO1=ZI(ICONEX)
                  INOPO2=ZI(ICONEX+1)
               ELSE
                  CALL U2MESK('F','MODELISA6_36',1,NOEPOU)
               ENDIF
            ENDIF
56       CONTINUE
55    CONTINUE
C
C     VERIFICATION QUE LA MAILLE IMA EST UN SEG3
C
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','SEG3') ,NTSEG3)
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','SEG4') ,NTSEG4)
      CALL JEVEUO(NOMA//'.TYPMAIL','L',JDTM)
      NUTYMA = ZI(JDTM+IMA-1)
      IF (NUTYMA.EQ.NTSEG3) THEN
         NNO=3
      ELSEIF (NUTYMA.EQ.NTSEG4) THEN
         NNO=4
      ELSE
         CALL U2MESK('F','MODELISA6_37',1,NOEPOU)
      ENDIF
C
C     RECUPERATION DES ANGLES NAUTIQUES DANS LA CARTE ORIENTATION
C
      CHCARA = CARA(1:8)//'.CARORIEN'
      CALL ETENCA(CHCARA, LIGREL, IER)
      CALL ASSERT (IER.EQ.0)
      NOMGD = 'CAORIE'
      CALL JEVEUO(CHCARA//'.DESC','L',IDESC)
C
C --- NOMBRE DE COMPOSANTES ASSOCIEES A LA GRANDEUR CF NUROTA
C
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'LONMAX',NCMPMX,K8BID)
C
C --- TABLEAU DE VALEURS DE LA CARTE CHCARA
C
      CALL JEVEUO(CHCARA//'.VALE','L',IVALE)
C
C --- RECUPERATION DU VECTEUR D'ADRESSAGE DANS LA CARTE CREE PAR ETENCA
C
      CALL JEVEUO(CHCARA//'.PTMA','L',IPTMA)
C
C     RECUPERATION DES ANGLES NAUTIQUES
C
      IF (ZI(IPTMA+IMA-1).NE.0) THEN
         IGD   = ZI(IPTMA+IMA-1)
         IDEBGD = (IGD-1)*NCMPMX
C        RECUPERATION DE L'ORIENTATION
C         DO 10 I=1,3
C            ORIEN(I) = ZR(IVALE+IDEBGD+I-1)
C10       CONTINUE
        CALL CARCOU(ZR(IVALE+IDEBGD),
     &              L,PGL,R,THETA,PGL1,PGL2,PGL3,PGL4,NNO,OMEGA,ICOUDE)
      ELSE
         CALL U2MESS('F','MODELISA6_38')
      ENDIF
C
C     CALCUL DU VECTEUR E1 ORIENTANT LA MAILLE TUYAU
C
      CALL JEVEUO (NOMA//'.COORDO    .VALE','L',JCOOR)
      COONO1(1) = ZR(JCOOR-1+3*(INOPO1-1)+1)
      COONO1(2) = ZR(JCOOR-1+3*(INOPO1-1)+2)
      COONO1(3) = ZR(JCOOR-1+3*(INOPO1-1)+3)
      COONO2(1) = ZR(JCOOR-1+3*(INOPO2-1)+1)
      COONO2(2) = ZR(JCOOR-1+3*(INOPO2-1)+2)
      COONO2(3) = ZR(JCOOR-1+3*(INOPO2-1)+3)
      CALL VDIFF(3,COONO2,COONO1,E1)
      CALL NORMEV(E1,NORE1)
      NOCMP(1) = 'X'
      NOCMP(2) = 'Y'
      NOCMP(3) = 'Z'
C
      CALL MECACT('V',TYPRAC//'.CAXE_TUY','LIGREL',LIGREL,'GEOM_R',
     &            3,NOCMP,IER,E1,CCMP,K8BID)
C
C     CALCUL DU VECTEUR GPL, AVEC P ORIGINE DE PHI
C
      GPL(1)=0.D0
      GPL(2)=0.D0
C1      GPL(3)=RAYON FORTRAN ACTUEL
C2      GPL(3)=-RAYON  LOGIQUE SUIVANT DOC R
      GPL(3)=-RAYON
C
C     PASSAGE DE GPL DANS LE REPERE GLOBAL ET COORDONNEES DE P
C
C      CALL MATROT (ORIEN,PGL)
      CALL UTPVLG ( 1, 3, PGL, GPL,GPG )
      COORIF(1) =  GPG(1) + COORIG(1)
      COORIF(2) =  GPG(2) + COORIG(2)
      COORIF(3) =  GPG(3) + COORIG(3)
C
C --- NOTATION DANS LA CARTE DE NOM '&&RAPOCO.CAORIFI' DES
C --- COORDONNEES DU POINT ORGINE DE PHI SUR LA SECTION DE RACCORD
C
      NOCMP(1) = 'X'
      NOCMP(2) = 'Y'
      NOCMP(3) = 'Z'
C
      CALL MECACT('V',TYPRAC//'.CAORIFI','LIGREL',LIGREL,'GEOM_R',
     &            3,NOCMP,IER,COORIF,CCMP,K8BID)
C
C     COORDONNEES DES VECTEURS UNITAIRES DANS LE REPERE GLOBAL
C
      EL1(1)=1.D0
      EL1(2)=0.D0
      EL1(3)=0.D0
C
      EL2(1)=0.D0
      EL2(2)=1.D0
      EL2(3)=0.D0
C
C        A CAUSE DE LA DEFINITION DU REPERE LOCAL, OU Z EST OPPOSE A
C        CELUI OBTENU PAR ROTATION DE ALPHA, BETA, GAMMA, IL FAUT
C        MODIFIER LE SIGNE DE Z (VERIF FAITE SUR LA FLEXION HORS PLAN)
C
      EL3(1)=0.D0
      EL3(2)=0.D0
C      EL3(3)=-1.D0 NON DIRECT  MAIS FTN ACTUEL
C      EL3(3)=1.D0   SERAIT LOGIQUE
      EL3(3)=1.D0
C
      CALL UTPVLG ( 1, 3, PGL, EL1,EG1 )
      CALL UTPVLG ( 1, 3, PGL, EL2,EG2 )
      CALL UTPVLG ( 1, 3, PGL, EL3,EG3 )
C
      IF(INFO.EQ.2) THEN
         CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',INOPO1),NOEPO1)
         CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',INOPO2),NOEPO2)
         IFM = IUNIFI('MESSAGE')
         WRITE(IFM,*) 'RAYON DE LA SECTION COQUE OU 3D ',RAYON
         WRITE(IFM,*) 'BARYCENTRE DE LA SECTION COQUE OU 3D ',COORIG
         WRITE(IFM,*) 'POINT ORIGINE DE LA GENERATRICE ',COORIF
         WRITE(IFM,*) 'VECTEUR AXE DU TUYAU : E1 ',E1
         WRITE(IFM,*) 'NOEUDS AXE DU TUYAU :  ',NOEPO1,NOEPO2
         WRITE(IFM,*) 'VECTEURS UNITAIRES DU TUYAU : E1 ',EG1
         WRITE(IFM,*) 'VECTEURS UNITAIRES DU TUYAU : E2 ',EG2
         WRITE(IFM,*) 'VECTEURS UNITAIRES DU TUYAU : E3 ',EG3
      ENDIF
C
      CALL JEDETR(CHCARA//'.PTMA')
      CALL JEDEMA()
      END
