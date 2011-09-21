      SUBROUTINE CALISO (CHARGZ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE PELLET
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*32       JEXNOM
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
      INTEGER I,IBID,ICMP,ICMP4,ICMP5,ICMP6,IDRXYZ,IDRZ,IER,IERD
      INTEGER ILISNO,IN,INDIK8,INOM,IOCC,JNOMA,JPRNM,LONLIS,N1,N2
      INTEGER NARL,NBCMP,NBEC,NDDLA,NDIMMO,NLIAI,NMOCL,NRL
      PARAMETER    (NMOCL = 300)
      CHARACTER*1   K1BID
      CHARACTER*2   TYPLAG
      CHARACTER*8   MOD, NOMG, K8BID, POSLAG
      REAL*8  DMIN, ARMIN,R8GAEM,X
      CHARACTER*8   NOMA, CMP, NOMCMP(NMOCL)
      CHARACTER*8   CMP4, CMP5, CMP6
      CHARACTER*9   NOMTE
      CHARACTER*19  LIGRMO,LISREL,NOMTAB
      CHARACTER*24  LISNOE
      INTEGER       NTYPEL(NMOCL)
      INTEGER VALI(2)
      LOGICAL       EXISDG
      INTEGER      IARG
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------

      CALL JEMARQ()
      LISNOE = '&&CALISO.LISTNOE'
      CHARGE = CHARGZ
      TYPLAG = '12'

C --- NOM DE LA LISTE DE RELATIONS
      LISREL = '&&CALISO.RLLISTE'

      CALL GETFAC('LIAISON_SOLIDE',NLIAI)
      IF (NLIAI.EQ.0) GOTO 99999

C --- MODELE ASSOCIE AU LIGREL DE CHARGE
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)

C ---  LIGREL DU MODELE
      LIGRMO = MOD(1:8)//'.MODELE'

C --- MAILLAGE ASSOCIE AU MODELE
      CALL JEVEUO(LIGRMO//'.LGRF','L',JNOMA)
      NOMA = ZK8(JNOMA)

C     RECUPERATION DE L'ARETE MIN : ARMIN
      CALL LTNOTB ( NOMA , 'CARA_GEOM' , NOMTAB )
      CALL TBLIVA(NOMTAB,1,'APPLAT_Z',IBID,0.D0,CBID,K1BID,'ABSO',
     &             R8GAEM(),'AR_MIN',K1BID,IBID,ARMIN,CBID,K1BID,IER )
      CALL ASSERT(ARMIN.GT.0.D0)


C --- DIMENSION ASSOCIEE AU MODELE
      CALL DISMOI('F','DIM_GEOM',MOD,'MODELE',NDIMMO,K8BID,IER)
      IF (.NOT.(NDIMMO.EQ.2.OR.NDIMMO.EQ.3))
     &    CALL U2MESS('F','MODELISA2_6')

C --- RECUPERATION DES NOMS DES DDLS ET DES NUMEROS
C --- D'ELEMENTS DE LAGRANGE ASSOCIES

      NOMG = 'DEPL_R'
      NOMTE = 'D_DEPL_R_'

      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMG),'LONMAX',NBCMP,K1BID)
      NDDLA = NBCMP-1
      IF (NDDLA.GT.NMOCL) THEN
        VALI (1) = NMOCL
        VALI (2) = NDDLA
        CALL U2MESG('F', 'MODELISA8_29',0,' ',2,VALI,0,0.D0)
      ENDIF
      DO 10 I=1,NDDLA
        NOMCMP(I)=ZK8(INOM-1+I)
        CALL JENONU(JEXNOM('&CATA.TE.NOMTE',
     &                     NOMTE//NOMCMP(I)(1:7)),NTYPEL(I))
 10   CONTINUE
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IERD)

C --- ACCES A L'OBJET .PRNM

      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ELSE
         CALL JEVEUO (LIGRMO//'.PRNM','L',JPRNM)
      END IF

C --- BOUCLE SUR LES OCCURENCES DU MOT-FACTEUR LIAISON_SOLIDE

      DO 20 IOCC =1, NLIAI

C --- ON REGARDE SI LES MULTIPLICATEURS DE LAGRANGE SONT A METTRE
C --- APRES LES NOEUDS PHYSIQUES LIES PAR LA RELATION DANS LA MATRICE
C --- ASSEMBLEE :
C --- SI OUI TYPLAG = '22'
C --- SI NON TYPLAG = '12'

      CALL GETVTX('LIAISON_SOLIDE','NUME_LAGR',IOCC,IARG,0,K8BID,NARL)
      CALL GETVR8('LIAISON_SOLIDE','DIST_MIN',IOCC,IARG,0,DMIN,N1)
      IF (N1.EQ.0) DMIN=ARMIN*1.D-3

      IF (NARL.NE.0) THEN
          CALL GETVTX('LIAISON_SOLIDE','NUME_LAGR',IOCC,IARG,1,
     &                POSLAG,NRL)
          IF (POSLAG(1:5).EQ.'APRES') THEN
              TYPLAG = '22'
          ELSE
              TYPLAG = '12'
          ENDIF
      ELSE
         TYPLAG = '12'
      ENDIF

C --- ACQUISITION DE LA LISTE DES NOEUDS A LIER
C --- (CETTE LISTE EST NON REDONDANTE)
      CALL MALINO('LIAISON_SOLIDE', CHARGE, IOCC, LISNOE, LONLIS)
      CALL JEVEUO (LISNOE,'L',ILISNO)


C --- SI LES MOTS CLES TRAN OU ANGL_NAUT SONT UTILISES :
      CALL GETVR8('LIAISON_SOLIDE','TRAN',IOCC,IARG,0,X,N1)
      CALL GETVR8('LIAISON_SOLIDE','ANGL_NAUT',IOCC,IARG,0,X,N2)
      IF (N1+N2.LT.0) THEN
          CALL DRZROT (LISNOE,LONLIS,CHARGE,TYPLAG,LISREL,IOCC,NDIMMO)
          GOTO 9999
      ENDIF


C --- CAS OU LA LISTE DES NOEUDS A LIER EST UN SINGLETON
      IF (LONLIS.EQ.1) THEN
          CALL U2MESS('I','MODELISA3_17')
          GOTO 9999
      ENDIF


C --- CAS OU LA DIMENSION DU MODELE EST EGALE A 2
      IF (NDIMMO.EQ.2) THEN

C ---      ON REGARDE S'IL Y A UN NOEUD DE LA LISTE PORTANT LE DDL DRZ

         CMP  = 'DRZ'
         ICMP = INDIK8(NOMCMP,CMP,1,NDDLA)
         IDRZ = 0
         DO 30 I = 1, LONLIS
C ---        NUMERO DU NOEUD COURANT DE LA LISTE
               CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),IN)
               IF (EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP)) THEN
                    IDRZ = 1
                    GOTO 40
               ENDIF
  30     CONTINUE
  40     CONTINUE

C ---      CAS OU L'ON A UN NOEUD DE LA LISTE PORTANT LE DDL DRZ

         IF (IDRZ.EQ.1) THEN
             CALL DRZ12D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL)

C ---      CAS OU AUCUN NOEUD DE LA LISTE NE PORTE LE DDL DRZ

         ELSEIF (IDRZ.EQ.0) THEN
             CALL DRZ02D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL,DMIN)

C ---      FIN DU CAS 2D SANS DDL DE ROTATION
         ENDIF

C --- CAS OU LA DIMENSION DU MODELE EST EGALE A 3

      ELSEIF (NDIMMO.EQ.3) THEN

C ---      ON REGARDE S'IL Y A UN NOEUD DE LA LISTE PORTANT LES 3 DDLS
C ---      DE ROTATION

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

               IF    ((EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP4))
     &           .AND.(EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP5))
     &           .AND.(EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP6))) THEN
                    IDRXYZ = 1
                    GOTO 60
               ENDIF
  50     CONTINUE
  60     CONTINUE

C ---      CAS OU L'ON A UN NOEUD DE LA LISTE PORTANT LES 3 DDLS
C ---      DE ROTATION
         IF (IDRXYZ.EQ.1) THEN
             CALL DRZ13D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL)

C ---      CAS MASSIF (PAS DE COMPOSANTES DE ROTATION)
         ELSEIF (IDRXYZ.EQ.0) THEN
             CALL DRZ03D (LISNOE ,LONLIS, CHARGE, TYPLAG, LISREL,DMIN)

C ---      FIN DU CAS 3D MASSIF (IDRXYZ=0)
         ENDIF
C ---    FIN DU CAS 3D
      ENDIF
 9999 CONTINUE
C ---    DESTRUCTION DE LA LISTE DES NOEUDS A LIER
      CALL JEDETR(LISNOE)

C ---       FIN DE LA BOUCLE SUR LES OCCURENCES DU MOT-FACTEUR
C ---       LIAISON_SOLIDE
 20   CONTINUE

C     -- AFFECTATION DE LA LISTE_RELA A LA CHARGE :
C     ---------------------------------------------
      CALL AFLRCH(LISREL,CHARGE)

99999 CONTINUE
      CALL JEDEMA()
      END
