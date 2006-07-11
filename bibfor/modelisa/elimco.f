      SUBROUTINE ELIMCO(CHAR,NOMA,NZOCO,NSUCO,NMACO,NNOCO,NNOQUA)
      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 11/07/2006   AUTEUR KHAM M.KHAM 
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
      IMPLICIT     NONE 
      CHARACTER*8  CHAR
      CHARACTER*8  NOMA
      INTEGER      NZOCO
      INTEGER      NSUCO
      INTEGER      NMACO
      INTEGER      NNOCO
      INTEGER      NNOQUA
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------
C
C ELIMINATION AU SEIN DE CHAQUE SURFACE DE CONTACT POTENTIELLE DES
C NOEUDS ET MAILLES REDONDANTS. MODIFICATION DES POINTEURS ASSOCIES.
C STOCKAGE DES NOEUDS DONNES SOUS LES MOTS-CLES SANS_NOEUD ET
C SANS_GROUP_NO : ON NE POURRA PAS LES UTILISER COMME NOEUDS ESCLAVES.
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NSUCO  : NOMBRE TOTAL DE SURFACES DE CONTACT
C IN  NMACO  : NOMBRE TOTAL DE MAILLES DES SURFACES
C I/O NNOCO  : NOMBRE TOTAL DE NOEUDS DES SURFACES
C I/O NNOQUA : NOMBRE TOTAL DE NOEUDS DES SURFACES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER LSANNO,LSANMA
      
      CHARACTER*24 SANSNO,PSANS,PZONE,PSURMA,PSURNO,PNOQUA
      CHARACTER*24 BARSNO,PBARS,BARSMA,PBARM
      CHARACTER*24 RACCNO,PRACC
      INTEGER      JSANS,JPSANS,JZONE,JSUMA,JSUNO
      INTEGER      JBARS,JPBARS,STOCNB,NBARS,NBARSO,JEBARS
      INTEGER      JBARM,JPBARM,STOCMB,MBARS,MBARSO,JBARSM
      INTEGER      JRACC,JPRACC,STOCNQ,NRACC,NRACCQ,JERACC
      
      CHARACTER*24 CONTMA,CONTNO,CONOQU
      CHARACTER*16 MOTFAC,TYPF
      
      INTEGER JINDMA,JINDNO,JELIMA,JELINO,JELIQU,JINDQU
      
      INTEGER JNOQUA,JMACO,JNOCO,JNOQU,JDECMA,JDECNO,JDECQU
      
      INTEGER STOCNO,NSANS,IOCPRE,NNOCO0,NNOQU0,NMACO0
      INTEGER ISUCO,I,II,IZONE,IOC,J,K
      INTEGER NBMA,NBNO,NBNOQU,NELIM,JELIM
      INTEGER ELIMMA,ELIMNO,ELIMQU
      INTEGER ISUDEB,ISUFIN
      INTEGER JMA,JNO,JQU,NOC

      CHARACTER*8 K8BID

C ----------------------------------------------------------------------

      CALL JEMARQ()

C --- PREPARATION DES VECTEURS JEVEUX SSNOCO ET PSSNOCO
      MOTFAC = 'CONTACT'
      CALL GETVTX (MOTFAC,'METHODE',1,1,1,TYPF,NOC)
      LSANNO = NNOCO
      LSANMA = NMACO
      SANSNO = CHAR(1:8)//'.CONTACT.SSNOCO'
      PSANS = CHAR(1:8)//'.CONTACT.PSSNOCO'
      BARSNO = CHAR(1:8)//'.CONTACT.BANOCO'
      PBARS = CHAR(1:8)//'.CONTACT.PBANOCO'
      BARSMA = CHAR(1:8)//'.CONTACT.BAMACO'
      PBARM = CHAR(1:8)//'.CONTACT.PBAMACO'
      RACCNO = CHAR(1:8)//'.CONTACT.RANOCO'
      PRACC = CHAR(1:8)//'.CONTACT.PRANOCO'

      CALL WKVECT(SANSNO,'G V I',LSANNO,JSANS)
      CALL WKVECT(PSANS,'G V I',NZOCO+1,JPSANS)
      CALL WKVECT(BARSNO,'G V I',LSANNO,JBARS)
      CALL WKVECT(PBARS,'G V I',NZOCO+1,JPBARS)
      CALL WKVECT(BARSMA,'G V I',LSANMA,JBARM)
      CALL WKVECT(PBARM,'G V I',NZOCO+1,JPBARM)
      CALL WKVECT(RACCNO,'G V I',LSANNO,JRACC)
      CALL WKVECT(PRACC,'G V I',NZOCO+1,JPRACC)
      ZI(JPSANS) = 0
      ZI(JPBARS)= 0
      ZI(JPBARM)= 0
      ZI(JPRACC) = 0

C --- CREATION DES VECTEURS DE TRAVAIL TEMPORAIRES
      CALL WKVECT('&&ELIMCO.INDIMA','V V I',NMACO,JINDMA)
      CALL WKVECT('&&ELIMCO.INDINO','V V I',NNOCO,JINDNO)
      CALL WKVECT('&&ELIMCO.ELIMMA','V V I',NSUCO+1,JELIMA)
      CALL WKVECT('&&ELIMCO.ELIMNO','V V I',NSUCO+1,JELINO)
      CALL WKVECT('&&ELIMCO.ELIMQU','V V I',NSUCO+1,JELIQU)
      IF (NNOQUA.NE.0) THEN
        CALL WKVECT('&&ELIMCO.INDIQU','V V I',NNOQUA,JINDQU)
      END IF
      ZI(JELIMA) = 0
      ZI(JELINO) = 0
      ZI(JELIQU) = 0

C --- RECUPERATION DES VECTEURS 
      PZONE  = CHAR(1:8)//'.CONTACT.PZONECO'
      PSURMA = CHAR(1:8)//'.CONTACT.PSUMACO'
      PSURNO = CHAR(1:8)//'.CONTACT.PSUNOCO'
      PNOQUA = CHAR(1:8)//'.CONTACT.PNOEUQU'
      CONTMA = CHAR(1:8)//'.CONTACT.MAILCO'
      CONTNO = CHAR(1:8)//'.CONTACT.NOEUCO'
      CONOQU = CHAR(1:8)//'.CONTACT.NOEUQU'     

      CALL JEVEUO(PZONE,'L',JZONE)
      CALL JEVEUO(PSURMA,'E',JSUMA)
      CALL JEVEUO(PSURNO,'E',JSUNO)
      CALL JEVEUO(PNOQUA,'E',JNOQUA)
      CALL JEVEUO(CONTMA,'E',JMACO)
      CALL JEVEUO(CONTNO,'E',JNOCO)
      IF (NNOQUA.NE.0) THEN
        CALL JEVEUO(CONOQU,'E',JNOQU)
      END IF
      
C ======================================================================
C     REPERAGE DES MAILLES ET NOEUDS REDONDANTS POUR CHAQUE SURFACE
C ======================================================================

      STOCNO = 0
      STOCNB = 0
      STOCMB = 0
      STOCNQ = 0
      NSANS = 0
      NBARS = 0
      MBARS = 0
      NRACC = 0
      IOCPRE = 1
      ELIMMA = 0
      ELIMNO = 0
      ELIMQU = 0
      NMACO0 = NMACO
      NNOCO0 = NNOCO
      NNOQU0 = NNOQUA

      DO 110 ISUCO = 1,NSUCO

C --- TRAITEMENT DES MAILLES REDONDANTES

        ZI(JELIMA+ISUCO) = ZI(JELIMA+ISUCO-1)
        JDECMA = ZI(JSUMA+ISUCO-1)
        NBMA = ZI(JSUMA+ISUCO) - ZI(JSUMA+ISUCO-1)
        DO 20 I = 1,NBMA
          DO 10 II = 1,I - 1
            IF (ZI(JMACO+JDECMA+I-1).EQ.ZI(JMACO+JDECMA+II-1)) THEN
              ZI(JINDMA+JDECMA+I-1) = 1
              ZI(JELIMA+ISUCO) = ZI(JELIMA+ISUCO) + 1
              ELIMMA = ELIMMA + 1
              GO TO 20
            END IF
   10     CONTINUE
   20   CONTINUE

C --- TRAITEMENT DES NOEUDS REDONDANTS

        ZI(JELINO+ISUCO) = ZI(JELINO+ISUCO-1)
        JDECNO = ZI(JSUNO+ISUCO-1)
        NBNO = ZI(JSUNO+ISUCO) - ZI(JSUNO+ISUCO-1)
        DO 40 I = 1,NBNO
          DO 30 II = 1,I - 1
            IF (ZI(JNOCO+JDECNO+I-1).EQ.ZI(JNOCO+JDECNO+II-1)) THEN
              ZI(JINDNO+JDECNO+I-1) = 1
              ZI(JELINO+ISUCO) = ZI(JELINO+ISUCO) + 1
              ELIMNO = ELIMNO + 1
              GO TO 40
            END IF
   30     CONTINUE
   40   CONTINUE

C --- TRAITEMENT DES NOEUDS QUADRATIQUES REDONDANTS
        ZI(JELIQU+ISUCO) = ZI(JELIQU+ISUCO-1)
        IF (NNOQUA.NE.0) THEN
          JDECQU = ZI(JNOQUA+ISUCO-1)
          NBNOQU = ZI(JNOQUA+ISUCO) - ZI(JNOQUA+ISUCO-1)
          DO 60 I = 1,NBNOQU
            DO 50 II = 1,I - 1
              IF (ZI(JNOQU+3*JDECQU+3* (I-1)).EQ.
     &            ZI(JNOQU+3*JDECQU+3* (II-1))) THEN
                ZI(JINDQU+JDECQU+I-1) = 1
                ZI(JELIQU+ISUCO) = ZI(JELIQU+ISUCO) + 1
                ELIMQU = ELIMQU + 1
                GO TO 60
              END IF
   50       CONTINUE
   60     CONTINUE
        END IF

C --- REPERAGE DE LA ZONE A LAQUELLE APPARTIENT LA SURFACE
        DO 70 IZONE = 1,NZOCO
          ISUDEB = ZI(JZONE+IZONE-1) + 1
          ISUFIN = ZI(JZONE+IZONE)
          IF ((ISUCO.GE.ISUDEB) .AND. (ISUCO.LE.ISUFIN)) THEN
            IOC = IZONE
            GO TO 80
          END IF
   70   CONTINUE
   80   CONTINUE

C --- STOCKAGE DES NOEUDS DONNES SOUS SANS_NOEUD OU SANS_GROUP_NO
C -    DECALAGE DE LA ZONE DE RECHERCHE SI ON A CHANGE DE ZONE
        IF (IOC.NE.IOCPRE) THEN
          NSANS = NSANS + NELIM
          IOCPRE = IOC
        END IF
        CALL PALINO(NOMA,'CONTACT','SANS_GROUP_NO','SANS_NOEUD',IOC,
     &              '&&ELIMCO.SANSNO')
        CALL JEVEUO('&&ELIMCO.SANSNO','L',JELIM)
        NELIM = ZI(JELIM)
        DO 100 J = 1,NELIM
C -    ON REGARDE SI NOTRE NOEUD N'EST PAS DEJA ECRIT DANS LA LISTE
C -    DE CEUX A ELIMINER
          DO 90 I = 1,STOCNO
            IF (ZI(JELIM+J).EQ.ZI(JSANS+I-1+NSANS)) GO TO 100
   90     CONTINUE
C       -ON AGRANDIT L'OBJET SANSNO SI NECESSAIRE :
          STOCNO = STOCNO + 1
          IF (STOCNO.GT.LSANNO) THEN
            LSANNO = 2*LSANNO
            CALL JUVECA(SANSNO,LSANNO)
            CALL JEVEUO(SANSNO,'E',JSANS)
          END IF
C -      ON INSCRIT NOTRE NOUVEAU NOEUD
          ZI(JSANS-1+STOCNO) = ZI(JELIM+J)
  100   CONTINUE
C -    ON MODIFIE NOTRE POINTEUR QUI CORRESPOND AU DEBUT DE CHAQUE ZONE
        ZI(JPSANS+IOC) = STOCNO
C
C --- STOCKAGE DES NOEUDS DONNES SOUS NOEUD_FOND OU GROUP_NO_FOND
C -    DECALAGE DE LA ZONE DE RECHERCHE SI ON A CHANGE DE ZONE
        IF(TYPF(1:8).NE.'CONTINUE') GOTO 104
          
        IF (IOC.NE.IOCPRE) THEN
          NBARS = NBARS + NBARSO
          IOCPRE = IOC
        END IF
        CALL PALINO(NOMA,'CONTACT','GROUP_NO_FOND','NOEUD_FOND',IOC,
     &              '&&ELIMCO.BARSNO')
        CALL JEVEUO('&&ELIMCO.BARSNO','L',JEBARS)
        NBARSO = ZI(JEBARS)
        DO 101 J = 1,NBARSO
C -    ON REGARDE SI NOTRE NOEUD N'EST PAS DEJA ECRIT DANS LA LISTE
C -    DE CEUX A ELIMINER
          DO 91 I = 1,STOCNB
            IF (ZI(JEBARS+J).EQ.ZI(JBARS+I-1+NBARS)) GO TO 101
   91     CONTINUE
C       -ON AGRANDIT L'OBJET RACCNO SI NECESSAIRE :
          STOCNB = STOCNB + 1
          IF (STOCNB.GT.LSANNO) THEN
            LSANNO = 2*LSANNO
            CALL JUVECA(BARSNO,LSANNO)
            CALL JEVEUO(BARSNO,'E',JBARS)
          END IF
C -      ON INSCRIT NOTRE NOUVEAU NOEUD
          ZI(JBARS-1+STOCNB) = ZI(JEBARS+J)
  101   CONTINUE
C -    ON MODIFIE NOTRE POINTEUR QUI CORRESPOND AU DEBUT DE CHAQUE ZONE
        ZI(JPBARS+IOC) = STOCNB

C      
C --- STOCKAGE DES MAILLES DONNEES SOUS MAILLE_FOND OU GROUP_MA_FOND
C -    DECALAGE DE LA ZONE DE RECHERCHE SI ON A CHANGE DE ZONE
        IF (IOC.NE.IOCPRE) THEN
          MBARS = MBARS + MBARSO
          IOCPRE = IOC
        END IF
        CALL PALIMA(NOMA,'CONTACT','GROUP_MA_FOND','MAILLE_FOND',IOC,
     &              '&&ELIMCO.BARSMA')
        CALL JEVEUO('&&ELIMCO.BARSMA','L',JBARSM)
        MBARSO = ZI(JBARSM)
        DO 102 J = 1,MBARSO
C -    ON REGARDE SI NOTRE NOEUD N'EST PAS DEJA ECRIT DANS LA LISTE
C -    DE CEUX A ELIMINER
          DO 92 I = 1,STOCMB
            IF (ZI(JBARSM+2*(J-1)+1).EQ.ZI(JBARM+I-1+MBARS)) GO TO 102
   92     CONTINUE
C       -ON AGRANDIT L'OBJET RACCNO SI NECESSAIRE :
          STOCMB = STOCMB + 1
          IF (STOCMB.GT.LSANMA) THEN
            LSANMA = 2*LSANMA
            CALL JUVECA(BARSMA,LSANMA)
            CALL JEVEUO(BARSMA,'E',JBARM)
          END IF
C -      ON INSCRIT NOTRE NOUVEAU NOEUD
          ZI(JBARM-1+STOCMB) = ZI(JBARSM+2*(J-1)+1)
  102   CONTINUE
C -    ON MODIFIE NOTRE POINTEUR QUI CORRESPOND AU DEBUT DE CHAQUE ZONE
        ZI(JPBARM+IOC) = STOCMB
C
C --- STOCKAGE DES NOEUDS DONNES SOUS NOEUD_RACC OU GROUP_NO_RACC
C -    DECALAGE DE LA ZONE DE RECHERCHE SI ON A CHANGE DE ZONE
        IF (IOC.NE.IOCPRE) THEN
          NRACC = NRACC + NRACCQ
          IOCPRE = IOC
        END IF
        CALL PALINO(NOMA,'CONTACT','GROUP_NO_RACC','NOEUD_RACC',IOC,
     &              '&&ELIMCO.RACCNO')
        CALL JEVEUO('&&ELIMCO.RACCNO','L',JERACC)
        NRACCQ = ZI(JERACC)
        DO 103 J = 1,NRACCQ
C -    ON REGARDE SI NOTRE NOEUD N'EST PAS DEJA ECRIT DANS LA LISTE
C -    DE CEUX A ELIMINER
          DO 93 I = 1,STOCNQ
            IF (ZI(JERACC+J).EQ.ZI(JRACC+I-1+NRACC)) GO TO 103
   93     CONTINUE
C       -ON AGRANDIT L'OBJET RACCNO SI NECESSAIRE :
          STOCNQ = STOCNQ + 1
          IF (STOCNQ.GT.LSANNO) THEN
            LSANNO = 2*LSANNO
            CALL JUVECA(RACCNO,LSANNO)
            CALL JEVEUO(RACCNO,'E',JRACC)
          END IF
C -      ON INSCRIT NOTRE NOUVEAU NOEUD
          ZI(JRACC-1+STOCNQ) = ZI(JERACC+J)
  103   CONTINUE
C -    ON MODIFIE NOTRE POINTEUR QUI CORRESPOND AU DEBUT DE CHAQUE ZONE
        ZI(JPRACC+IOC) = STOCNQ
  104 CONTINUE  
  110 CONTINUE

      CALL JEECRA(SANSNO,'LONUTI',STOCNO,K8BID)
      CALL JEECRA(BARSNO,'LONUTI',STOCNB,K8BID)
      CALL JEECRA(BARSMA,'LONUTI',STOCMB,K8BID)
      CALL JEECRA(RACCNO,'LONUTI',STOCNQ,K8BID)
      

C ======================================================================
C   RECOPIE DES MAILLES ET NOEUDS NON ELIMINES DANS TABLEAU DE TRAVAIL
C ======================================================================

      NMACO = NMACO0 - ELIMMA
      NNOCO = NNOCO0 - ELIMNO
      NNOQUA = NNOQU0 - ELIMQU
      CALL WKVECT('&&ELIMCO.TRAVMA','V V I',NMACO,JMA)
      CALL WKVECT('&&ELIMCO.TRAVNO','V V I',NNOCO,JNO)

C --- TRAITEMENT DES MAILLES

      K = 0
      DO 120 I = 1,NMACO0
        IF (ZI(JINDMA+I-1).EQ.1) GO TO 120
        K = K + 1
        ZI(JMA+K-1) = ZI(JMACO+I-1)
  120 CONTINUE
      IF (K.NE.NMACO) CALL UTMESS('F','ELIMCO_01','ERREUR SUR NMACO')

C --- TRAITEMENT DES NOEUDS

      K = 0
      DO 130 I = 1,NNOCO0
        IF (ZI(JINDNO+I-1).EQ.1) GO TO 130
        K = K + 1
        ZI(JNO+K-1) = ZI(JNOCO+I-1)
  130 CONTINUE
      IF (K.NE.NNOCO) CALL UTMESS('F','ELIMCO_02','ERREUR SUR NNOCO')

C --- TRAITEMENT DES NOEUDS QUADRATIQUES

      IF (NNOQUA.NE.0) THEN
        CALL WKVECT('&&ELIMCO.TRAVQU','V V I',3*NNOQUA,JQU)
        K = 0
        DO 150 I = 1,NNOQU0
          IF (ZI(JINDQU+I-1).EQ.1) GO TO 150
          K = K + 1
          DO 140 II = 1,3
            ZI(JQU+3* (K-1)+II-1) = ZI(JNOQU+3* (I-1)+II-1)
  140     CONTINUE
  150   CONTINUE
        IF (K.NE.NNOQUA) CALL UTMESS('F','ELIMCO_03',
     &                               'ERREUR SUR NNOQUA')
      END IF
C ======================================================================
C            MODIFICATION DES POINTEURS PSURMA ET PSURNO
C ======================================================================

      DO 160 ISUCO = 1,NSUCO
        ZI(JSUMA+ISUCO) = ZI(JSUMA+ISUCO) - ZI(JELIMA+ISUCO)
        ZI(JSUNO+ISUCO) = ZI(JSUNO+ISUCO) - ZI(JELINO+ISUCO)
        ZI(JNOQUA+ISUCO) = ZI(JNOQUA+ISUCO) - ZI(JELIQU+ISUCO)
  160 CONTINUE

C ======================================================================
C        TRANSFERT DES VECTEURS DE TRAVAIL DANS CONTMA ET CONTNO
C                 ET MODIFICATION DE L'ATTRIBUT LONUTI
C ======================================================================

C --- TRAITEMENT DES MAILLES

      DO 170 I = 1,NMACO
        ZI(JMACO+I-1) = ZI(JMA+I-1)
  170 CONTINUE
      DO 180 I = NMACO + 1,NMACO0
        ZI(JMACO+I-1) = 0
  180 CONTINUE
      CALL JEECRA(CONTMA,'LONUTI',NMACO,K8BID)

C --- TRAITEMENT DES NOEUDS

      DO 190 I = 1,NNOCO
        ZI(JNOCO+I-1) = ZI(JNO+I-1)
  190 CONTINUE
      DO 200 I = NNOCO + 1,NNOCO0
        ZI(JNOCO+I-1) = 0
  200 CONTINUE
      CALL JEECRA(CONTNO,'LONUTI',NNOCO,K8BID)

C --- TRAITEMENT DES NOEUDS QUADRATIQUES
      DO 220 I = 1,NNOQUA
        DO 210 K = 1,3
          ZI(JNOQU+3* (I-1)+K-1) = ZI(JQU+3* (I-1)+K-1)
  210   CONTINUE
  220 CONTINUE
      DO 240 I = NNOQUA + 1,NNOQU0
        DO 230 K = 1,3
          ZI(JNOQU+3* (I-1)+K-1) = 0
  230   CONTINUE
  240 CONTINUE
  
  
C --- DESTRUCTION TOTAL DU VECTEUR DES NOEUDS QUADRATIQUES S'ILS SONT
C --- COMPLETEMENT ELIMINES
      IF (NNOQUA.EQ.0) THEN
        CALL JEDETR(CONOQU)
      ELSE
        CALL JEECRA(CONOQU,'LONUTI',3*NNOQUA,K8BID)
      END IF

C --- DESTRUCTION DES VECTEURS DE TRAVAIL TEMPORAIRES
      CALL JEDETR('&&ELIMCO.INDIMA')
      CALL JEDETR('&&ELIMCO.INDINO')
      CALL JEDETR('&&ELIMCO.INDIQU')
      CALL JEDETR('&&ELIMCO.ELIMMA')
      CALL JEDETR('&&ELIMCO.ELIMNO')
      CALL JEDETR('&&ELIMCO.ELIMQU')
      CALL JEDETR('&&ELIMCO.TRAVMA')
      CALL JEDETR('&&ELIMCO.TRAVNO')
      CALL JEDETR('&&ELIMCO.TRAVQU')
      CALL JEDETR('&&ELIMCO.SANSNO')
      CALL JEDETR('&&ELIMCO.BARSNO')
      CALL JEDETR('&&ELIMCO.BARSMA')
      CALL JEDETR('&&ELIMCO.RACCNO')

C ----------------------------------------------------------------------

      CALL JEDEMA()
      END
