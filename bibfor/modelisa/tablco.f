      SUBROUTINE TABLCO(NOMA,PZONE,NZOCO,NSUCO,NMACO,NNOCO,PSURMA,
     &                  PSURNO,CONTMA,CONTNO,MANOCO,PMANO,NMANO,NOMACO,
     &                  PNOMA,NNOMA,MAMACO,PMAMA,NMAMA,NOZOCO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_21

      IMPLICIT NONE

      INTEGER NZOCO,NSUCO,NMACO,NNOCO,NMANO,NNOMA,NMAMA
      CHARACTER*8 NOMA
      CHARACTER*24 PZONE,PSURMA,PSURNO,CONTMA,CONTNO
      CHARACTER*24 MANOCO,PMANO,NOMACO,PNOMA,MAMACO,PMAMA,NOZOCO

C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------

C CONSTRUCTION DU TABLEAU INVERSE DONNANT POUR CHAQUE NOEUD DE CONTACT
C LA LISTE DES MAILLES QUI LE CONTIENNENT AU SEIN DE LA MEME SURFACE.
C CONSTRUCTION DU TABLEAU DIRECT DONNANT POUR CHAQUE MAILLE DE CONTACT
C LA LISTE DES NOEUDS QU'ELLE CONTIENT AU SEIN DE LA MEME SURFACE.

C IN  NOMA   : NOM DU MAILLAGE
C IN  PZONE  : POINTEUR DES ZONES DE CONTACT
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NSUCO  : NOMBRE TOTAL DE SURFACES DE CONTACT
C IN  NMACO  : NOMBRE TOTAL DE MAILLES DES SURFACES
C IN  NNOCO  : NOMBRE TOTAL DE NOEUDS DES SURFACES
C IN  PSURMA : POINTEUR DES MAILLES DES SURFACES
C IN  PSURNO : POINTEUR DES NOEUDS DES SURFACES
C IN  CONTMA : LISTE DES NUMEROS DES MAILLES DE CONTACT
C IN  CONTNO : LISTE DES NUMEROS DES NOEUDS DE CONTACT
C OUT MANOCO : TABLEAU INVERSE NOEUDS->MAILLES
C OUT PMANO  : POINTEUR DE CE TABLEAU NOEUDS->MAILLES
C OUT NMANO  : DIMENSION DU TABLEAU INVERSE NOEUDS->MAILLES
C OUT NOMACO : TABLEAU DIRECT MAILLES->NOEUDS
C OUT PNOMA  : POINTEUR DE CE TABLEAU DIRECT MAILLES->NOEUDS
C OUT NNOMA  : DIMENSION DU TABLEAU DIRECT MAILLES->NOEUDS
C OUT MAMACO : TABLEAU DONNANT POUR CHAQUE MAILLE DE CONTACT LA LISTE
C              DES MAILLES DE CONTACT DE LA MEME SURFACE ADJACENTES
C              (ON STOCKE LA POSITION DANS CONTMA, PAS LE NUMERO ABSOLU)
C OUT PMAMA  : POINTEUR DE CE TABLEAU
C OUT NOZOCO : TABLEAU DONNANT LE NUMERO DE ZONE POUR CHAQUE NOEUD DE
C              CONTACT

C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
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

C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX ----------------

      INTEGER IFM,NIV,IBID,I1,I2
      INTEGER JSUMA,JSUNO,JMACO,JNOCO,JMANO,JNOMA,JPOMA,JPONO
      INTEGER JMAMA,JPOIN,JZOCO,NO1(9),NO2(9)
      INTEGER IMA2,JJNO1,JJNO2,NBNO1,NBNO2,JZONE,IZONE,IZOCO
      INTEGER ISUCO,JDECNO,JDECMA,INO,IMA,NBNO,NBMA,NUMNO,NUMA,NBID
      INTEGER NO,I,K,INC,NMAX,JDES,JTRAV,LONG
      REAL*8 RBID,VECNOR(3)
      CHARACTER*1 K1BID
      CHARACTER*8 K8BID
      INTEGER IAMACO,ILMACO,NBNOM,NUMGLM
C     FONCTION "FORMULE" D'ACCES AU NOMBRE DE NEOUDS DES MAILLES
      NBNOM(IMA)=ZI(ILMACO+IMA)-ZI(ILMACO-1+IMA)
C     FONCTION "FORMULE" D'ACCES A LA CONNECTIVITE DES MAILLES
      NUMGLM(IMA,INO)=ZI(IAMACO-1+ZI(ILMACO+IMA-1)+INO-1)

C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)

      CALL JEVEUO(NOMA//'.CONNEX','L',IAMACO)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',ILMACO)



      CALL JEVEUO(PSURMA,'E',JSUMA)
      CALL JEVEUO(PSURNO,'E',JSUNO)
      CALL JEVEUO(CONTMA,'E',JMACO)
      CALL JEVEUO(CONTNO,'E',JNOCO)

      NMAX = MAX(NNOCO,NMACO)
      NBID = 20*NMAX

      CALL WKVECT('&&TABLCO.TRAV','V V I',NMAX,JTRAV)

C ======================================================================
C         REMPLISSAGE DU TABLEAU INVERSE NOEUDS->MAILLES MANOCO
C            ET CONSTRUCTION DU POINTEUR PAMANO CORRESPONDANT
C            CALCUL DE LA NORMALE EN CHAQUE NOEUD DE CONTACT
C                        BOUCLE SUR LES SURFACES
C ======================================================================

      CALL WKVECT(MANOCO,'G V I',NBID,JMANO)
      CALL WKVECT(PMANO,'G V I',NNOCO+1,JPOMA)
      ZI(JPOMA) = 0

      INC = 0
      LONG = NBID

      DO 40 ISUCO = 1,NSUCO

C ------- ADRESSES DE DEBUT DANS LES LISTES CONTNO ET CONTMA
C ------- ET NOMBRE DE NOEUDS ET MAILLES POUR LA SURFACE ISUCO

        JDECNO = ZI(JSUNO+ISUCO-1)
        JDECMA = ZI(JSUMA+ISUCO-1)
        NBNO = ZI(JSUNO+ISUCO) - ZI(JSUNO+ISUCO-1)
        NBMA = ZI(JSUMA+ISUCO) - ZI(JSUMA+ISUCO-1)

C ------- EXAMEN DES NOEUDS DE LA SURFACE

        DO 30 INO = 1,NBNO

          ZI(JTRAV+JDECNO+INO-1) = 0

C ----- NUMERO DU NOEUD

          NUMNO = ZI(JNOCO+JDECNO+INO-1)

C ----- EXAMEN DE TOUTES LES MAILLES DE LA SURFACE

          DO 20 IMA = 1,NBMA

            NUMA = ZI(JMACO+JDECMA+IMA-1)

C --- TEST SUR LES NOEUDS DE LA MAILLE ET STOCKAGE EVENTUEL
C --- LA NORMALE N'EST PAS CALCULEE LA PUISQU'ELLE EST RECALCULEE
C --- AUTOMATIQUEMENT A CHAQUE FOIS AU NIVEAU DE STAT_NON_LINE (ACNORM)

            DO 10 I = 1,NBNOM(NUMA)
              NO=NUMGLM(NUMA,I)
              IF (NO.EQ.NUMNO) THEN
                INC = INC + 1
                IF (INC.GT.LONG) THEN
                  LONG = 2*LONG
                  CALL JUVECA(MANOCO,LONG)
                  CALL JEVEUO(MANOCO,'E',JMANO)
                END IF
                ZI(JMANO+INC-1) = JDECMA + IMA
                ZI(JTRAV+JDECNO+INO-1) = ZI(JTRAV+JDECNO+INO-1) + 1
                GO TO 20
              END IF
   10       CONTINUE

   20     CONTINUE

C ----- INCREMENTATION DU POINTEUR PMANO

          ZI(JPOMA+JDECNO+INO) = ZI(JPOMA+JDECNO+INO-1) +
     &                           ZI(JTRAV+JDECNO+INO-1)

   30   CONTINUE

   40 CONTINUE

C ======================================================================
C       VERIFICATION DE LA LONGUEUR DU TABLEAU MANOCO ET STOCKAGE
C ======================================================================

      NMANO = ZI(JPOMA+NNOCO)
      IF (NMANO.GT.LONG) THEN
        CALL UTMESS('F','TABLCO_01',
     &              'ERREUR PROGRAMMEUR SUR DIMENSION DE MANOCO')
      END IF
      CALL JEECRA(MANOCO,'LONUTI',NMANO,K8BID)

C ======================================================================
C         REMPLISSAGE DU TABLEAU DIRECT MAILLES->NOEUDS NOMACO
C            ET CONSTRUCTION DU POINTEUR PNOMA CORRESPONDANT
C                        BOUCLE SUR LES SURFACES
C ======================================================================

      CALL WKVECT(NOMACO,'G V I',NBID,JNOMA)
      CALL WKVECT(PNOMA,'G V I',NMACO+1,JPONO)
      ZI(JPONO) = 0

      INC = 0
      LONG = NBID

      DO 80 ISUCO = 1,NSUCO

C ------- ADRESSES DE DEBUT DANS LES LISTES CONTNO ET CONTMA
C ------- ET NOMBRE DE NOEUDS ET MAILLES POUR LA SURFACE ISUCO

        JDECNO = ZI(JSUNO+ISUCO-1)
        JDECMA = ZI(JSUMA+ISUCO-1)
        NBNO = ZI(JSUNO+ISUCO) - ZI(JSUNO+ISUCO-1)
        NBMA = ZI(JSUMA+ISUCO) - ZI(JSUMA+ISUCO-1)

C ------- EXAMEN DES MAILLES DE LA SURFACE

        DO 70 IMA = 1,NBMA

          ZI(JTRAV+JDECMA+IMA-1) = 0

C ----- NUMERO DE LA MAILLE ET ADRESSE DE SES NOEUDS

          NUMA = ZI(JMACO+JDECMA+IMA-1)

C --- COMPARAISON AVEC LES NOEUDS DE CONTACT DE LA SURFACE :
C --- ON STOCKERA LES NOEUDS DE LA MAILLE DANS L'ORDRE OU ILS
C --- APPARAISSENT, D'OU L'INVERSION DES BOUCLES 130 ET 140

          DO 60 I = 1,NBNOM(NUMA)
            NO=NUMGLM(NUMA,I)
            DO 50 INO = 1,NBNO
              NUMNO = ZI(JNOCO+JDECNO+INO-1)
              IF (NO.EQ.NUMNO) THEN
                INC = INC + 1
                IF (INC.GT.LONG) THEN
                  LONG = 2*LONG
                  CALL JUVECA(NOMACO,LONG)
                  CALL JEVEUO(NOMACO,'E',JNOMA)
                END IF
                ZI(JNOMA+INC-1) = JDECNO + INO
                ZI(JTRAV+JDECMA+IMA-1) = ZI(JTRAV+JDECMA+IMA-1) + 1
                GO TO 60
              END IF
   50       CONTINUE
   60     CONTINUE

C ----- INCREMENTATION DU POINTEUR PNOMA

          ZI(JPONO+JDECMA+IMA) = ZI(JPONO+JDECMA+IMA-1) +
     &                           ZI(JTRAV+JDECMA+IMA-1)

   70   CONTINUE

   80 CONTINUE

C ======================================================================
C       VERIFICATION DE LA LONGUEUR DU TABLEAU NOMACO ET STOCKAGE
C ======================================================================

      NNOMA = ZI(JPONO+NMACO)
      IF (NNOMA.GT.LONG) THEN
        CALL UTMESS('F','TABLCO_01',
     &              'ERREUR PROGRAMMEUR SUR DIMENSION DE NOMACO')
      END IF
      CALL JEECRA(NOMACO,'LONUTI',NNOMA,K8BID)

C ======================================================================
C    CONSTRUCTION DU TABLEAU MAMACO DONNANT POUR CHAQUE MAILLE D'UNE
C     SURFACE DE CONTACT LA LISTE DES MAILLES DE CONTACT ADJACENTES
C      (IE AYANT AU MOINS UN NOEUD EN COMMUN) DANS LA MEME SURFACE
C ======================================================================

      CALL WKVECT(MAMACO,'G V I',NBID,JMAMA)
      CALL WKVECT(PMAMA,'G V I',NMACO+1,JPOIN)
      ZI(JPOIN) = 0

      INC = 0
      LONG = NBID

      DO 140 ISUCO = 1,NSUCO

C ------- ADRESSE DE DEBUT DE LA LISTE DES MAILLES DANS CONTMA ET NOMBRE

        JDECMA = ZI(JSUMA+ISUCO-1)
        NBMA = ZI(JSUMA+ISUCO) - ZI(JSUMA+ISUCO-1)

C ------- BOUCLE SUR LES MAILLES DE LA SURFACE ISUCO

        DO 130 IMA = 1,NBMA

          ZI(JTRAV+JDECMA+IMA-1) = 0

C ----- ADRESSE DE RANGEMENT DES NOEUDS DE LA MAILLE, NOMBRE ET NUMEROS

          JJNO1 = ZI(JPONO+JDECMA+IMA-1)
          NBNO1 = ZI(JPONO+JDECMA+IMA) - ZI(JPONO+JDECMA+IMA-1)
          DO 90 INO = 1,NBNO1
            NO1(INO) = ZI(JNOMA+JJNO1+INO-1)
   90     CONTINUE

C ----- BOUCLE SUR LES AUTRES MAILLES DE LA SURFACE : COMPARAISON DES
C ----- NOEUDS DES AUTRES MAILLES AVEC CEUX DE LA MAILLE EXAMINEE :
C ----- LES MAILLES SONT ADJACENTES SI AU MOINS UN NOEUD COMMUN

          DO 120 IMA2 = 1,NBMA
            IF (IMA2.EQ.IMA) GO TO 120
            JJNO2 = ZI(JPONO+JDECMA+IMA2-1)
            NBNO2 = ZI(JPONO+JDECMA+IMA2) - ZI(JPONO+JDECMA+IMA2-1)
            DO 110 INO = 1,NBNO2
              NO2(INO) = ZI(JNOMA+JJNO2+INO-1)
              DO 100 I = 1,NBNO1
                IF (NO1(I).EQ.NO2(INO)) THEN
                  INC = INC + 1
                  IF (INC.GT.LONG) THEN
                    LONG = 2*LONG
                    CALL JUVECA(MAMACO,LONG)
                    CALL JEVEUO(MAMACO,'E',JMAMA)
                  END IF
                  ZI(JMAMA+INC-1) = JDECMA + IMA2
                  ZI(JTRAV+JDECMA+IMA-1) = ZI(JTRAV+JDECMA+IMA-1) + 1
                  GO TO 120
                END IF
  100         CONTINUE
  110       CONTINUE
  120     CONTINUE

C ----- INCREMENTATION DU POINTEUR PMAMA

          ZI(JPOIN+JDECMA+IMA) = ZI(JPOIN+JDECMA+IMA-1) +
     &                           ZI(JTRAV+JDECMA+IMA-1)

  130   CONTINUE

  140 CONTINUE

C ======================================================================
C       VERIFICATION DE LA LONGUEUR DU TABLEAU MAMACO ET STOCKAGE
C ======================================================================

      NMAMA = ZI(JPOIN+NMACO)
      IF (NMAMA.GT.LONG) THEN
        CALL UTMESS('F','TABLCO_01',
     &              'ERREUR PROGRAMMEUR SUR DIMENSION DE MAMACO')
      END IF
      CALL JEECRA(MAMACO,'LONUTI',NMAMA,K8BID)

C ======================================================================
C    CONSTRUCTION DU TABLEAU NOZOCO DONNANT POUR CHAQUE NOEUD DE CONTACT
C             LE NUMERO DE LA ZONE A LAQUELLE IL APPARTIENT
C ======================================================================

      CALL JEVEUO(PZONE,'L',JZONE)
      CALL WKVECT(NOZOCO,'G V I',NNOCO,JZOCO)

      DO 180 ISUCO = 1,NSUCO

        DO 150 IZONE = 1,NZOCO
          I1 = ZI(JZONE+IZONE-1) + 1
          I2 = ZI(JZONE+IZONE)
          IF ((ISUCO.GE.I1) .AND. (ISUCO.LE.I2)) THEN
            IZOCO = IZONE
            GO TO 160
          END IF
  150   CONTINUE
  160   CONTINUE

        NBNO = ZI(JSUNO+ISUCO) - ZI(JSUNO+ISUCO-1)
        JDECNO = ZI(JSUNO+ISUCO-1)
        DO 170 INO = 1,NBNO
          ZI(JZOCO+JDECNO+INO-1) = IZOCO
  170   CONTINUE

  180 CONTINUE

C ======================================================================
C                    IMPRESSIONS POUR LES DEVELOPPEURS
C ======================================================================

      IF (NIV.EQ.2) THEN
        WRITE (IFM,*)
        WRITE (IFM,1090) '--------------------------------------'
        WRITE (IFM,1090) '     IMPRESSIONS DE VERIFICATION      '
        WRITE (IFM,1090) '   APRES CONSTRUCTION DES TABLEAUX    '
        WRITE (IFM,1090) '      INVERSES (ROUTINE TABLCO)       '
        WRITE (IFM,1090) '--------------------------------------'
        WRITE (IFM,*)
        WRITE (IFM,1070) 'NMANO  : ',NMANO
        WRITE (IFM,1070) 'NNOMA  : ',NNOMA
        WRITE (IFM,1070) 'NMAMA  : ',NMAMA
        WRITE (IFM,*)
        WRITE (IFM,1080) 'MANOCO : '
        WRITE (IFM,1060) (ZI(JMANO+K-1),K=1,NMANO)
        WRITE (IFM,1080) 'PMANO  : '
        WRITE (IFM,1060) (ZI(JPOMA+K),K=0,NNOCO)
        WRITE (IFM,1080) 'NOMACO : '
        WRITE (IFM,1060) (ZI(JNOMA+K-1),K=1,NNOMA)
        WRITE (IFM,1080) 'PNOMA  : '
        WRITE (IFM,1060) (ZI(JPONO+K),K=0,NMACO)
        WRITE (IFM,1080) 'MAMACO : '
        WRITE (IFM,1060) (ZI(JMAMA+K-1),K=1,NMAMA)
        WRITE (IFM,1080) 'PMAMA  : '
        WRITE (IFM,1060) (ZI(JPOIN+K),K=0,NMACO)
        WRITE (IFM,1080) 'NOZOCO : '
        WRITE (IFM,1060) (ZI(JZOCO+K-1),K=1,NNOCO)
        WRITE (IFM,*)
        WRITE (IFM,1090) '--------------------------------------'
        WRITE (IFM,*)
      END IF

      CALL JEDETR('&&TABLCO.TRAV')

C ----------------------------------------------------------------------

 1060 FORMAT (('<CONTACT_3> ',9X,8 (I5,1X)))
 1070 FORMAT ('<CONTACT_3> ',A9,I5)
 1080 FORMAT ('<CONTACT_3> ',A9)
 1090 FORMAT ('<CONTACT_3> ',A38)

      CALL JEDEMA()
      END
