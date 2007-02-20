      SUBROUTINE CALISO (CHARGZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
      CHARACTER*8  CHARGE
      CHARACTER*(*) CHARGZ
C -------------------------------------------------------
C     TRAITEMENT DU MOT CLE LIAISON_SOLIDE DE AFFE_CHAR_MECA
C -------------------------------------------------------
C  CHARGE        - IN    - K8   - : NOM DE LA SD CHARGE
C                - JXVAR -      -   LA  CHARGE EST ENRICHIE
C                                   DES RELATIONS LINEAIRES NECESSAIRES
C -------------------------------------------------------
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC,CBID
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE /ZK8(1),ZK16(1),ZK24(1),ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ------
C
C --------- VARIABLES LOCALES ---------------------------
      PARAMETER    (NMOCL = 300)
      CHARACTER*1   K1BID
      CHARACTER*2   TYPLAG
      CHARACTER*8   MOD, NOMG, K8BID, POSLAG
      CHARACTER*8   NOMA, CMP, NOMCMP(NMOCL)
      CHARACTER*8   CMP4, CMP5, CMP6
      CHARACTER*9   NOMTE
      CHARACTER*16  MOTFAC
      CHARACTER*19  LIGRMO,LISREL,NOMTAB
      CHARACTER*24  LISNOE
      CHARACTER*123 TEXTE
      INTEGER       NTYPEL(NMOCL)
      INTEGER VALI(2)
      LOGICAL       VERIF, EXISDG
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------

      CALL JEMARQ()
      LISNOE = '&&CALISO.LISTNOE'
      CHARGE = CHARGZ
      TYPLAG = '12'
C
C --- NOM DE LA LISTE DE RELATIONS
      LISREL = '&&CALISO.RLLISTE'
C
      MOTFAC = 'LIAISON_SOLIDE'
      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GOTO 99999
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
C
C ---  LIGREL DU MODELE
      LIGRMO = MOD(1:8)//'.MODELE'
C
C --- MAILLAGE ASSOCIE AU MODELE
      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)

C     CALCUL D'UN DIMENSION DE REFERENCE : DMIN
      CALL LTNOTB ( NOMA , 'CARA_GEOM' , NOMTAB )
      CALL TBLIVA(NOMTAB,1,'APPLAT_Z',IBID,0.D0,CBID,K1BID,'ABSO',
     &             R8GAEM(),'AR_MIN',K1BID,IBID,DMIN,CBID,K1BID,IER )

C
C --- DIMENSION ASSOCIEE AU MODELE
C
      CALL DISMOI('F','Z_CST',MOD,'MODELE',NDIMMO,K8BID,IER)
      NDIMMO = 3
      IF (K8BID.EQ.'OUI') NDIMMO = 2
C
C --- RECUPERATION DES NOMS DES DDLS ET DES NUMEROS
C --- D'ELEMENTS DE LAGRANGE ASSOCIES
C
      NOMG = 'DEPL_R'
      NOMTE = 'D_DEPL_R_'
C
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)
      NDDLA = NBCMP-1
      IF (NDDLA.GT.NMOCL) THEN
        VALI (1) = NMOCL
        VALI (2) = NDDLA
        CALL U2MESG('F', 'MODELISA8_50',0,' ',2,VALI,0,0.D0)
      ENDIF
      DO 10 I=1,NDDLA
        NOMCMP(I)=ZK8(INOM-1+I)
        CALL JENONU(JEXNOM('&CATA.TE.NOMTE',
     &                     NOMTE//NOMCMP(I)(1:7)),NTYPEL(I))
 10   CONTINUE
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IERD)
C
C --- ACCES A L'OBJET .PRNM
C
      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ELSE
         CALL JEVEUO (LIGRMO//'.PRNM','L',JPRNM)
      END IF
C
C --- BOUCLE SUR LES OCCURENCES DU MOT-FACTEUR LIAISON_SOLIDE
C
      DO 20 IOCC =1, NLIAI
C
C --- ON REGARDE SI LES MULTIPLICATEURS DE LAGRANGE SONT A METTRE
C --- APRES LES NOEUDS PHYSIQUES LIES PAR LA RELATION DANS LA MATRICE
C --- ASSEMBLEE :
C --- SI OUI TYPLAG = '22'
C --- SI NON TYPLAG = '12'
C
      CALL GETVTX (MOTFAC,'NUME_LAGR',IOCC,1,0,K8BID,NARL)
      IF (NARL.NE.0) THEN
          CALL GETVTX (MOTFAC,'NUME_LAGR',IOCC,1,1,POSLAG,NRL)
          IF (POSLAG(1:5).EQ.'APRES') THEN
              TYPLAG = '22'
          ELSE
              TYPLAG = '12'
          ENDIF
      ELSE
         TYPLAG = '12'
      ENDIF
C
C --- ACQUISITION DE LA LISTE DES NOEUDS A LIER
C --- (CETTE LISTE EST NON REDONDANTE)
C
      CALL MALINO(MOTFAC, CHARGE, IOCC, LISNOE, LONLIS)
      CALL JEVEUO (LISNOE,'L',ILISNO)
C
C --- CAS OU LA LISTE DES NOEUDS A LIER EST UN SINGLETON
C
      IF (LONLIS.EQ.1) THEN
          CALL U2MESS('I','MODELISA3_17')
          GOTO 9999
      ENDIF
C
C --- CAS OU LA DIMENSION DU MODELE EST EGALE A 2
C
      IF (NDIMMO.EQ.2) THEN
C
C ---      ON REGARDE S'IL Y A UN NOEUD DE LA LISTE PORTANT LE DDL DRZ
C
         CMP  = 'DRZ'
         ICMP = INDIK8(NOMCMP,CMP,1,NDDLA)
         IDRZ = 0
         DO 30 I = 1, LONLIS
C ---        NUMERO DU NOEUD COURANT DE LA LISTE
               CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),IN)
C
               IF (EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP)) THEN
                    IDRZ = 1
                    GOTO 40
               ENDIF
  30     CONTINUE
C
  40     CONTINUE
C
C ---      CAS OU L'ON A UN NOEUD DE LA LISTE PORTANT LE DDL DRZ
C
         IF (IDRZ.EQ.1) THEN
             CALL DRZ12D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL)
C
C ---      CAS OU AUCUN NOEUD DE LA LISTE NE PORTE LE DDL DRZ
C
         ELSEIF (IDRZ.EQ.0) THEN
             CALL DRZ02D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL,DMIN)
C
C ---      FIN DU CAS 2D SANS DDL DE ROTATION
         ENDIF
C
C --- CAS OU LA DIMENSION DU MODELE EST EGALE A 3
C
      ELSEIF (NDIMMO.EQ.3) THEN
C
C ---      ON REGARDE S'IL Y A UN NOEUD DE LA LISTE PORTANT LES 3 DDLS
C ---      DE ROTATION
C
         CMP4  = 'DRX'
         CMP5  = 'DRY'
         CMP6  = 'DRZ'
         ICMP4 = INDIK8(NOMCMP,CMP4,1,NDDLA)
         ICMP5 = INDIK8(NOMCMP,CMP5,1,NDDLA)
         ICMP6 = INDIK8(NOMCMP,CMP6,1,NDDLA)
         IDRXYZ = 0
         DO 50 I = 1, LONLIS
C ---        NUMERO DU NOEUD COURANT DE LA LISTE
               CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),IN)
C
               IF    ((EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP4))
     &           .AND.(EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP5))
     &           .AND.(EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP6))) THEN
                    IDRXYZ = 1
                    GOTO 60
               ENDIF
  50     CONTINUE
C
  60     CONTINUE
C
C ---      CAS OU L'ON A UN NOEUD DE LA LISTE PORTANT LES 3 DDLS
C ---      DE ROTATION
         IF (IDRXYZ.EQ.1) THEN
             CALL DRZ13D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL)
C
C ---      CAS MASSIF (PAS DE COMPOSANTES DE ROTATION)
         ELSEIF (IDRXYZ.EQ.0) THEN
             CALL DRZ03D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL,DMIN)
C
C ---      FIN DU CAS 3D MASSIF (IDRXYZ=0)
         ENDIF
C ---    FIN DU CAS 3D
      ENDIF
 9999 CONTINUE
C ---    DESTRUCTION DE LA LISTE DES NOEUDS A LIER
      CALL JEDETR(LISNOE)
C
C ---       FIN DE LA BOUCLE SUR LES OCCURENCES DU MOT-FACTEUR
C ---       LIAISON_SOLIDE
 20   CONTINUE
C
C     -- AFFECTATION DE LA LISTE_RELA A LA CHARGE :
C     ---------------------------------------------
      CALL AFLRCH(LISREL,CHARGE)
C
99999 CONTINUE
      CALL JEDEMA()
      END
