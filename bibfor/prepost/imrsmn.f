      SUBROUTINE IMRSMN(FICHIE,NOMSDZ,OPTIOZ,NBNO,LISNOZ,NBCMP,LISCMZ,
     &                  NBCHIF,EPS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C TOLE CRP_20
C.======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)

C      IMRSMN -- IMPRESSION DE LA MATR_ASSE DE NOM NOMSD, REELLE,
C                SYMETRIQUE,  STOCKEE MORSE
C                DANS LE FICHIER DE NOM FICHIER.
C                LE GRAIN DE L'IMPRESSION EST 'NOEUD'
C                (I.E. IL EST CONSTITUE PAR UNE SOUS-MATRICE DONT LES
C                      TERMES COUPLENT 2 NOEUDS)


C   ARGUMENT        E/S  TYPE         ROLE
C    FICHIE          IN    K*     NOM DU FICHIER OU L'ON IMPRIME
C                                 LA MATR_ASSE,
C    NOMSDZ          IN    K*     NOM DE LA MATR_ASSE
C    OPTIOZ          IN    K*     OPTION D'IMPRESSION
C                                     = 'SOUS_MATRICE'
C                                  OU = 'LIGNE'
C                                  OU = 'COLONNE'
C                                  SI = 'SOUS_MATRICE' ON IMPRIME
C                                       UNIQUEMENT LES COMPOSANTES
C                                       LICITES DES NOEUDS DE LA LISTE
C                                       LISNOZ ET SI CELLE-CI EST VIDE
C                                       (NBNO = 0)
C                                       ON IMPRIME CELLES DE TOUS LES
C                                       NOEUDS (PHYSIQUES) DU MAILLAGE
C                                  SI = 'LIGNE' ON IMPRIME TOUTES LES
C                                       LES LIGNES RELATIVES AUX
C                                       COMPOSANTES LICITES DES NOEUDS
C                                       DE LA LISTE LISNOZ ET DE TOUS
C                                       LES NOEUDS SI CETTE LISTE EST
C                                       VIDE (NBNO =0 )
C                                  SI = 'COLONNE' ON IMPRIME TOUTES LES
C                                       LES COLONNES RELATIVES AUX
C                                       COMPOSANTES LICITES DES NOEUDS
C                                       DE LA LISTE LISNOZ ET DE TOUS
C                                       LES NOEUDS SI CETTE LISTE EST
C                                       VIDE (NBNO =0)
C    NBNO            IN    I     NOMBRE DE NOEUDS DE LA LISTE LISNOZ
C                                SI = 0 LA LISTE LISNOZ EST VIDE ET
C                                L'ON PREND EN COMPTE TOUS LES NOEUDS
C                                (PHYSIQUES) DU MAILLAGE
C    LISNOZ          IN    K*    LISTE DES NOEUDS POUR-LESQUELS ON
C                                DESIRE L'IMPRESSION DES VALEURS
C                                DE LA MATRICE
C    NBCMP           IN    I     NOMBRE DE COMPOSANTES DE LA LISTE
C                                LISCMZ DES COMPOSANTES
C    LISCMZ          IN    K*    LISTE DES COMPOSANTES POUR-LESQUELLES
C                                ON DESIRE L'IMPRESSION DES VALEURS
C                                DE LA MATRICE
C    NBCHIF          IN    I     NOMBRE DE CHIFFRES A METTRE APRES
C                                LA VIRGULE DANS LE FORMAT D'IMPRESSION
C    EPS             IN    R     PRECISION SERVANT A TESTER LA NULLITE
C                                D'UN TERME DE LA MATRICE
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 JEXNUM,JEXNOM
C -----  ARGUMENTS
      CHARACTER*(*) FICHIE,NOMSDZ,OPTIOZ,LISNOZ,LISCMZ
C -----  VARIABLES LOCALES
      CHARACTER*1 K1BID
      CHARACTER*8 K8BID,NOMA,NOMGD,NOMNO1,NOMCM1,NOMNO2,NOMCM2
      CHARACTER*8 M8BLAN,NOMNOU
      CHARACTER*12 OPTION
      CHARACTER*14 NUMDDL
      CHARACTER*19 NOMSD,PRCHNO
      CHARACTER*24 LISNOT,LISCMT,LISVAT,LISBI1,LISBI2
      CHARACTER*24 LNOCM1,LINBCM,LISICM,LNOVAL,LILICM,LISINO
      CHARACTER*24 LISNOE,LISCMP,LNOCM2,LISIND
      CHARACTER*24 NOLILI,VALE,NOEUMA
      INTEGER GD,TYPSYM
      LOGICAL IMPLIG
C.========================= DEBUT DU CODE EXECUTABLE ==================

      CALL JEMARQ()

C --- INITIALISATIONS :
C     ---------------
      NOMSD = NOMSDZ
      LISNOE = LISNOZ
      LISCMP = LISCMZ

      ZERO = 0.0D0
      M8BLAN = '        '

C --- RECUPERATION DES NOEUDS POUR-LESQUELS ON VEUT L'IMPRESSION
C --- DE LA MATRICE :
C     -------------
      IF (NBNO.EQ.0) THEN

C ---    ON FABRIQUE UN VECTEUR BIDON DE K8 D'1 SEUL TERME SI LA
C ---    EST VIDE :
C        --------
        LISBI1 = '&&IMRSMN.BID1'
        CALL WKVECT(LISBI1,'V V K8',1,IDLINO)
      ELSE
        CALL JEVEUO(LISNOE,'L',IDLINO)
      END IF

C --- RECUPERATION DES COMPOSANTES POUR-LESQUELLES ON VEUT L'IMPRESSION
C --- DE LA MATRICE :
C     -------------
      IF (NBCMP.EQ.0) THEN

C ---    ON FABRIQUE UN VECTEUR BIDON DE K8 D'1 SEUL TERME SI LA
C ---    EST VIDE :
C        --------
        LISBI2 = '&&IMRSMN.BID2'
        CALL WKVECT(LISBI2,'V V K8',1,IDLICM)
      ELSE
        CALL JEVEUO(LISCMP,'L',IDLICM)
      END IF

C --- CONSTRUCTION DU DESCRIPTEUR DE LA MATRICE :
C     -----------------------------------------
      CALL MTDSCR(NOMSD)

C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE :
C     -----------------------------------------
      CALL JEVEUO(NOMSD//'.&INT','L',LMAT)

C --- RECUPERATION DU .REFA DE LA MATRICE :
C     -----------------------------------
      CALL JEVEUO(NOMSD//'.REFA','L',IDREFE)

C --- NOMBRE D'EQUATIONS :
C     ------------------
      NEQ = ZI(LMAT+2)

C --- INDICATEUR DE LA SYMETRIE DE LA MATRICE :
C     ---------------------------------------

C --- ADRESSE DU TABLEAU DES ADRESSES DES TERMES DIAGONAUX DANS
C --- LES BLOCS :
C     ---------
      CALL MTDSC2(ZK24(ZI(LMAT+1)),'ADIA','L',IDADIA)

C --- ADRESSE DU TABLEAU DES ADRESSES DU DEBUT DES BLOCS :
C     --------------------------------------------------
      CALL MTDSC2(ZK24(ZI(LMAT+1)),'ABLO','L',IDBLOC)

C --- NOMBRE DE BLOCS DE LA DEMI-MATRICE :
C     ----------------------------------
      NBBLOC = ZI(LMAT+13)

C --- LONGUEUR D'UN BLOC :
C     ------------------

C --- RECUPERATION DU NUME_DDL ASSOCIE A LA MATRICE :
C     ---------------------------------------------
      CALL DISMOI('F','NOM_NUME_DDL',NOMSD,'MATR_ASSE',IBID,NUMDDL,IER)

C --- RECUPERATION DU MAILLAGE ASSOCIE A LA MATRICE :
C     ---------------------------------------------
      CALL DISMOI('F','NOM_MAILLA',NOMSD,'MATR_ASSE',IBID,NOMA,IER)

C --- RECUPERATION DU NOMBRE DE NOEUDS DU MAILLAGE :
C     --------------------------------------------
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNOMA,K8BID,IER)

C --- RECUPERATION DU TABLEAU DES NUMEROS DE COLONNES DES TERMES
C --- DE LA MATRICE :
C     -------------
      CALL JEVEUO(NUMDDL//'.SMOS.HCOL','L',IDHCOL)

C --- RECUPERATION DU PROF_CHNO :
C     -------------------------
      PRCHNO = NUMDDL//'.NUME'

C --- .VALE DE LA MATRICE :
C     -------------------
      VALE = NOMSD//'.VALE'

C --- RECUPERATION DU .DEEQ DU PROF_CHNO :
C     ----------------------------------
      CALL JEVEUO(PRCHNO//'.DEEQ','L',IDEEQ)

C --- RECUPERATION DU .DELG DU PROF_CHNO :
C     ----------------------------------
      CALL JEVEUO(PRCHNO//'.DELG','L',IDELG)

C --- TABLEAU DES NUMEROS D'EQUATIONS :
C     -------------------------------
      CALL JEVEUO(PRCHNO//'.NUEQ','L',IANUEQ)

C --- RECUPERATION DU .PRNO ASSOCIE AU MAILLAGE :
C     -----------------------------------------
      CALL JELIRA(PRCHNO//'.PRNO','NMAXOC',NLILI,K8BID)
      K = 0
      DO 10 I = 1,NLILI
        CALL JENUNO(JEXNUM(PRCHNO//'.LILI',I),NOLILI)
        IF (NOLILI(1:8).NE.'&MAILLA ') GO TO 10
        K = I
   10 CONTINUE
      IF (K.EQ.0) THEN
        CALL UTMESS('F','IMRSMN',
     &              'ERREUR DANS LA RECUPERATION DU NUME.PRNO')
      END IF
      CALL JEVEUO(JEXNUM(PRCHNO//'.PRNO',K),'L',IDPRNO)

C --- RECUPERATION DE LA GRANDEUR ASSOCIEE A LA MATRICE  :
C     -------------------------------------------------
      CALL DISMOI('F','NOM_GD',NUMDDL,'NUME_DDL',IBID,NOMGD,IER)

C --- NUMERO DE LA GRANDEUR  :
C     ---------------------
      CALL JENONU(JEXNOM('&CATA.GD.NOMCMP',NOMGD),GD)

C --- NOMBRE D'ENTIERS CODES ASSOCIE A LA GRANDEUR  :
C     --------------------------------------------
      NEC = NBEC(GD)

C --- NOMBRE DE COMPOSANTES ASSOCIEES A LA GRANDEUR :
C     ---------------------------------------------
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'LONMAX',NCMPMX,K1BID)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'L',INOCMP)

C --- COLLECTION DES NOMS DES NOEUDS DU MAILLAGE  :
C     ------------------------------------------
      NOEUMA = NOMA//'.NOMNOE'

C --- PAR GROUPE DE LIGNES, ON ENTEND LES LIGNES DE LA MATRICE
C --- CORRESPONDANTES A TOUS LES DDLS D'UN NOEUD DONNE

C --- CREATION DU TABLEAU  DES NOMS DES NOEUDS DU GROUPE
C --- DE LIGNES COURANT DE LA MATRICE :
C     -------------------------------
      LISNOT = '&&IMRSMN.NOMNOE'
      CALL WKVECT(LISNOT,'V V K8',NEQ*NCMPMX,IDNOMN)

C --- CREATION DU TABLEAU DES NOMS DES COMPOSANTES DU GROUPE
C --- DE LIGNES COURANT DE LA MATRICE :
C     -------------------------------
      LISCMT = '&&IMRSMN.NOMCMP'
      CALL WKVECT(LISCMT,'V V K8',NEQ*NCMPMX,IDNOMC)

C --- CREATION DU TABLEAU DES VALEURS DU GROUPE
C --- DE LIGNES COURANT DE LA MATRICE :
C     -------------------------------
      LISVAT = '&&IMRSMN.LIGVAL'
      CALL WKVECT(LISVAT,'V V R',NEQ*NCMPMX,IDVALL)

C --- CREATION DU TABLEAU INDIQUANT SI LES VALEURS RELATIVES
C --- A UN NOEUD DU MAILLAGE ONT ETE TRAITEES OU NON :
C     ----------------------------------------------
      LISINO = '&&IMRSMN.IDINO'
      CALL WKVECT(LISINO,'V V I',NBNOMA,IDIDNO)

C --- CREATION DU TABLEAU INDIQUANT A QUELS NOEUDS EST CONNECTE
C --- UN NOEUD DONNE :
C     --------------
      LISIND = '&&IMRSMN.INDNOE'
      CALL WKVECT(LISIND,'V V I',NBNOMA,INDNOE)

C --- CREATION DU TABLEAU D'INDICATEURS DISANT SI UNE COMPOSANTE EST
C ---  A PRENDRE EN COMPTE OU NON :
C     ---------------------------
      LISICM = '&&IMRSMN.INDCMP'
      CALL WKVECT(LISICM,'V V I',NEQ*NCMPMX,IDINCM)

C --- CREATION DU TABLEAU D'INDICATEURS DISANT A QUELLE LIGNE
C --- APPARTIENT UNE COMPOSANTE A IMPRIMER :
C     ------------------------------------
      LILICM = '&&IMRSMN.INDLICM'
      CALL WKVECT(LILICM,'V V I',NEQ*NCMPMX,IDIDCM)

C --- CREATION D'UN TABLEAU BIDON (POUR TRNOR1) :
C     -----------------------------------------
      CALL WKVECT('&&IMRSMN.BIDON','V V I',NEQ*NCMPMX,IDNUNO)

C --- CREATION DU TABLEAU DES NOMS DES COMPOSANTES DU NOEUD COURANT :
C     -------------------------------------------------------------
      LNOCM1 = '&&IMRSMN.NOMCM1'
      CALL WKVECT(LNOCM1,'V V K8',NCMPMX,IDNCM1)

C --- CREATION DU TABLEAU DES NOMS DES COMPOSANTES DES LIGNES A
C --- IMPRIMER :
C     --------
      LNOCM2 = '&&IMRSMN.NOMCM2'
      CALL WKVECT(LNOCM2,'V V K8',NCMPMX*NCMPMX,IDNCM2)

C --- CREATION DU TABLEAU DES VALEURS DES COMPOSANTES DES LIGNES A
C --- IMPRIMER :
C     --------
      LNOVAL = '&&IMRSMN.NOVALE'
      CALL WKVECT(LNOVAL,'V V R',NCMPMX*NCMPMX,IDNVAL)

C --- CREATION DU TABLEAU DU NOMBRE DE COMPOSANTES PAR LIGNE
C --- DU NOEUD COURANT A IMPRIMER :
C     ---------------------------
      LINBCM = '&&IMRSMN.NBCMPX'
      CALL WKVECT(LINBCM,'V V I',NCMPMX,IDNBCM)

C --- BOUCLE SUR LES NOEUDS DU MAILLAGE :
C     ---------------------------------
      DO 140 INO = 1,NBNOMA

C ---  RECUPERATION DU NOM DU NOEUD INO :
C      --------------------------------
        CALL JENUNO(JEXNUM(NOEUMA,INO),NOMNO1)

C ---  ON NE FAIT L'IMPRESSION DU NOEUD NOMNO1 QUE SI CELUI-CI
C ---  EST VALIDE :
C      ----------
        IF (IMPLIG(NOMNO1,NBNO,ZK8(IDLINO))) THEN

C ---   RECUPERATION DU NOMBRE DE COMPOSANTES DU NOEUD INO :
C       --------------------------------------------------
          NBCM1 = ZI(IDPRNO+ (INO-1)* (NEC+2)+2-1)

C ---   RECUPERATION DU NUMERO D'EQUATION DE LA PREMIERE COMPOSANTE
C ---   DU NOEUD INO :
C       ------------
          IEQ1 = ZI(IDPRNO+ (INO-1)* (NEC+2)+1-1)

C ---   RECUPERATION DU NUMERO DU BLOC AUQUEL APPARTIENT LA LIGNE
C ---   IEQ1 DE LA MATRICE :
C       ------------------
          NUBLOC = 0
          DO 20 IBLOC = 1,NBBLOC

C ---     IL2 : NUMERO DE LA DERNIERE LIGNE (OU COLONNE) DU BLOC :
C         ------------------------------------------------------
            IL2 = ZI(IDBLOC+IBLOC)

            IF (IEQ1.GT.IL2) GO TO 20
            NUBLOC = IBLOC
            GO TO 30
   20     CONTINUE
   30     CONTINUE

          IF (NUBLOC.EQ.0) THEN
            CALL UTMESS('F','IMRSMN','PROBLEME DANS LA RECUPERATION'//
     &                  ' DU NUMERO DE BLOC AUQUEL APPARTIENT'//
     &                  ' LA LIGNE COURANTE.')
          END IF

C ---     RECUPERATION DU BLOC  :
C         --------------------
          CALL JEVEUO(JEXNUM(VALE,NUBLOC),'L',IABLOC)

C ---     INITIALISATION DES TABLEAUX DE TRAVAIL  :
C         --------------------------------------
          DO 40 IEQ = 1,NEQ*NCMPMX
            ZK8(IDNOMN+IEQ-1) = M8BLAN
            ZK8(IDNOMC+IEQ-1) = M8BLAN
            ZR(IDVALL+IEQ-1) = ZERO
            ZI(IDIDCM+IEQ-1) = 0
            ZI(IDINCM+IEQ-1) = 0
   40     CONTINUE

          DO 50 INOMA = 1,NBNOMA
            ZI(IDIDNO+INOMA-1) = 0
            ZI(INDNOE+INOMA-1) = 0
   50     CONTINUE

          DO 60 IEQ = 1,NCMPMX
            ZK8(IDNCM1+IEQ-1) = M8BLAN
   60     CONTINUE

          DO 70 IEQ = 1,NCMPMX*NCMPMX
            ZR(IDNVAL+IEQ-1) = ZERO
            ZK8(IDNCM2+IEQ-1) = M8BLAN
   70     CONTINUE

          K = 0
          NBCMP1 = 0

C ---     BOUCLE SUR LES COMPOSANTES DU NOEUD COURANT :
C         --------------------------------------------
          DO 130 ICMP = 1,NBCM1

C ---      NUMERO D'EQUATION CORRESPONDANT A LA COMPOSANTE ICMP :
C          ----------------------------------------------------
            IEQUA = IEQ1 + ICMP - 1

C ---      NUMCM1 NUMERO DE COMPOSANTE CORRESPONDANTE AU DDL IEQUA :
C          -------------------------------------------------------
            NUMCM1 = ZI(IDEEQ+2* (IEQUA-1)+2-1)

C ---       RECUPERATION DU NOM DE LA COMPOSANTE NUMCM1 DANS LE CAS
C ---       OU IL S'AGIT D'UN DDL PHYSIQUE (I.E. NUMCM1 > 0) :
C           ------------------------------------------------
            IF (NUMCM1.GT.0) THEN
              NOMCM1 = ZK8(INOCMP+NUMCM1-1)

C ---       ON NE FAIT L'IMPRESSION DE LA LIGNE DE LA MATRICE
C ---       CORRESPONDANTE AU DDL NOMCM1 DU NOEUD NOMNO1 QUE
C ---       SI CETTE COMPOSANTE EST LICITE :
C           ------------------------------
              IF (IMPLIG(NOMCM1,NBCMP,ZK8(IDLICM))) THEN

                NBCMP1 = NBCMP1 + 1
                ZK8(IDNCM1+NBCMP1-1) = NOMCM1

C ---       INDICE DU DEBUT DE LIGNE :
C           ------------------------
                IF (IEQUA.EQ.1) THEN
                  IDEBLI = 1
                ELSE
                  IDEBLI = ZI(IDADIA+IEQUA-2) + 1
                END IF

C ---       INDICE DU TERME DIAGONAL :
C           ------------------------
                IFINLI = ZI(IDADIA+IEQUA-1)

C ---       LONGUEUR DE LA LIGNE COURANTE :
C           -----------------------------
                ILONG = IFINLI - IDEBLI + 1

                IF (ILONG.LE.0) GO TO 130

C ---       BOUCLE SUR LES TERMES DE LA LIGNE IEQUA
C ---       (JUSQU'AU TERME DIAGONAL) :
C           -------------------------
                DO 80 ITERM = IDEBLI,IFINLI

C ---          POSITION DU TERME COURANT DANS LE BLOC :
C              --------------------------------------
                  INDB = IABLOC + ITERM - 1

C ---          INDICE DE LA COLONNE DU TERME COURANT :
C              -------------------------------------
                  INDL = ZI(IDHCOL+ITERM-1)

C ---          RECUPERATION DU NOEUD CORRESPONDANT AU DDL COURANT :
C              --------------------------------------------------
                  JNO = ZI(IDEEQ+2* (INDL-1)+1-1)

C ---          STOCKAGE DU TERME POUR L'IMPRESSION S'IL EST NON-NUL :
C              ----------------------------------------------------
                  IF (ABS(ZR(INDB)).GT.EPS) THEN

                    IF (JNO.GT.0) THEN

C ---            NUMCM2 NUMERO DE COMPOSANTE CORRESPONDANT
C ---            AU DDL ITERM :
C                ------------
                      NUMCM2 = ZI(IDEEQ+2* (INDL-1)+2-1)

C ---            RECUPERATION DU NOM DU NOEUD JNO :
C                --------------------------------
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)

C ---            RECUPERATION DU NOM DE LA COMPOSANTE NUMCM2 DANS LE CAS
C ---            OU IL S'AGIT D'UN DDL PHYSIQUE (I.E. NUMCM2 > 0) :
C                ------------------------------------------------
                      IF (NUMCM2.GT.0) THEN
                        NOMCM2 = ZK8(INOCMP+NUMCM2-1)

C ---            RECUPERATION DU NOMBRE DE COMPOSANTES DU NOEUD JNO :
C                --------------------------------------------------

C ---            AFFECTATION DES TABLEAUX DE TRAVAIL :
C                -----------------------------------
                        K = K + 1
                        ZI(INDNOE+JNO-1) = 1

                        ZI(IDIDCM+K-1) = NBCMP1
                        ZK8(IDNOMN+K-1) = NOMNO2
                        ZK8(IDNOMC+K-1) = NOMCM2
                        ZR(IDVALL+K-1) = ZR(INDB)

                      END IF
                    END IF
                  ELSE IF (ZI(INDNOE+JNO-1).EQ.1) THEN

                    IF (JNO.GT.0) THEN

C ---            NUMCM2 NUMERO DE COMPOSANTE CORRESPONDANT
C ---            AU DDL ITERM :
C                ------------
                      NUMCM2 = ZI(IDEEQ+2* (INDL-1)+2-1)

C ---            RECUPERATION DU NOM DU NOEUD JNO :
C                --------------------------------
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)

C ---            RECUPERATION DU NOM DE LA COMPOSANTE NUMCM2 DANS LE CAS
C ---            OU IL S'AGIT D'UN DDL PHYSIQUE (I.E. NUMCM2 > 0) :
C                ------------------------------------------------
                      IF (NUMCM2.GT.0) THEN
                        NOMCM2 = ZK8(INOCMP+NUMCM2-1)

C ---            RECUPERATION DU NOMBRE DE COMPOSANTES DU NOEUD JNO :
C                --------------------------------------------------

C ---            AFFECTATION DES TABLEAUX DE TRAVAIL :
C                -----------------------------------
                        K = K + 1

                        ZI(IDIDCM+K-1) = NBCMP1
                        ZK8(IDNOMN+K-1) = NOMNO2
                        ZK8(IDNOMC+K-1) = NOMCM2
                        ZR(IDVALL+K-1) = ZR(INDB)

                      END IF
                    END IF
                  END IF
   80           CONTINUE
C           -----------------------------------------
C ---       - RECONSTITUTION DE LA LIGNE IEQUA      -
C ---       -  (POUR LES TERMES APRES LA DIAGONALE) -
C           -----------------------------------------

C ---       INITIALISATION DE L'INDICE DE DEBUT DE LA LIGNE JEQUA :
C           -----------------------------------------------------
                JDEBLI = ZI(IDADIA+IEQUA-1) + 1

C ---       BOUCLE SUR LES LIGNES SUIVANT LA LIGNE IEQUA DANS LE
C ---       BLOC COURANT  :
C           ------------
                DO 120 JEQUA = IEQUA + 1,IL2

C ---          INDICE DE COLONNE DU PREMIER TERME DE LA LIGNE JEQUA :
C              ----------------------------------------------------
                  JCOL1 = ZI(IDHCOL+JDEBLI-1)

C ---          SI CET INDICE EST PLUS GRAND QUE IEQUA
C ---          PAS DE TRAITEMENT A FAIRE :
C              -------------------------
                  IF (JCOL1.GT.IEQUA) GO TO 110

C ---          INDICE DE FIN DE LA LIGNE JEQUA :
C              -------------------------------
                  JFINLI = ZI(IDADIA+JEQUA-1)

C ---          LONGUEUR DE LA LIGNE COURANTE :
C              -----------------------------
                  JLONG = JFINLI - JDEBLI + 1

                  IF (JLONG.LE.0) GO TO 110

                  JTERM1 = 0

C ---          BOUCLE SUR LES TERMES DE LA LIGNE JEQUA POUR
C ---          RECUPERER LE TERME SUR LA COLONNE IEQUA
C ---          S'IL Y EN A UN ET AUQUEL CAS JTERM1 N'EST PAS NUL
C ---          ET EST L'INDICE DE CE TERME DANS LA MATRICE :
C              -------------------------------------------
                  DO 90 JTERM = JDEBLI,JFINLI
                    JNDCOL = ZI(IDHCOL+JTERM-1)
                    IF (JNDCOL.EQ.IEQUA) THEN
                      JTERM1 = JTERM
                      GO TO 100
                    END IF
   90             CONTINUE
  100             CONTINUE
                  IF (JTERM1.EQ.0) GO TO 110

C ---          POSITION DE CE TERME DANS LE BLOC :
C              ---------------------------------
                  JNDB = IABLOC + JTERM1 - 1

C ---          RECUPERATION DU NOEUD CORRESPONDANT AU DDL JEQUA :
C              --------------------------------------------------
                  JNO = ZI(IDEEQ+2* (JEQUA-1)+1-1)

C ---          STOCKAGE DU TERME POUR L'IMPRESSION S'IL EST NON-NUL :
C              ----------------------------------------------------
                  IF (ABS(ZR(JNDB)).GT.EPS) THEN

C ---            NUMCM2 NUMERO DE COMPOSANTE CORRESPONDANT
C ---            AU DDL JEQUA :
C                ------------
                    NUMCM2 = ZI(IDEEQ+2* (JEQUA-1)+2-1)

C ---            RECUPERATION DU NOM DU NOEUD JNO :
C                --------------------------------
                    IF (JNO.GT.0) THEN
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)

C ---            RECUPERATION DU NOM DE LA COMPOSANTE NUMCM2 DANS LE CAS
C ---            OU IL S'AGIT D'UN DDL PHYSIQUE (I.E. NUMCM2 > 0) :
C                ------------------------------------------------
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)
                      IF (NUMCM2.GT.0) THEN
                        NOMCM2 = ZK8(INOCMP+NUMCM2-1)
                      END IF

C ---            RECUPERATION DU NOMBRE DE COMPOSANTES DU NOEUD JNO :
C                --------------------------------------------------

C ---            AFFECTATION DES TABLEAUX DE TRAVAIL :
C                -----------------------------------
                      IF (NUMCM2.GT.0) THEN

                        K = K + 1
                        ZI(INDNOE+JNO-1) = 1

                        ZI(IDIDCM+K-1) = NBCMP1
                        ZK8(IDNOMN+K-1) = NOMNO2
                        ZK8(IDNOMC+K-1) = NOMCM2
                        ZR(IDVALL+K-1) = ZR(JNDB)

                      END IF
                    END IF
                  ELSE IF (ZI(INDNOE+JNO-1).EQ.1) THEN

C ---            NUMCM2 NUMERO DE COMPOSANTE CORRESPONDANT
C ---            AU DDL JEQUA :
C                ------------
                    NUMCM2 = ZI(IDEEQ+2* (JEQUA-1)+2-1)

C ---            RECUPERATION DU NOM DU NOEUD JNO :
C                --------------------------------
                    IF (JNO.GT.0) THEN
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)

C ---            RECUPERATION DU NOM DE LA COMPOSANTE NUMCM2 DANS LE CAS
C ---            OU IL S'AGIT D'UN DDL PHYSIQUE (I.E. NUMCM2 > 0) :
C                ------------------------------------------------
                      CALL JENUNO(JEXNUM(NOEUMA,JNO),NOMNO2)
                      IF (NUMCM2.GT.0) THEN
                        NOMCM2 = ZK8(INOCMP+NUMCM2-1)
                      END IF

C ---            RECUPERATION DU NOMBRE DE COMPOSANTES DU NOEUD JNO :
C                --------------------------------------------------

C ---            AFFECTATION DES TABLEAUX DE TRAVAIL :
C                -----------------------------------
                      IF (NUMCM2.GT.0) THEN

                        K = K + 1

                        ZI(IDIDCM+K-1) = NBCMP1
                        ZK8(IDNOMN+K-1) = NOMNO2
                        ZK8(IDNOMC+K-1) = NOMCM2
                        ZR(IDVALL+K-1) = ZR(JNDB)

                      END IF
                    END IF
                  END IF
  110             CONTINUE
                  JDEBLI = ZI(IDADIA+JEQUA-1) + 1
  120           CONTINUE
              END IF
            END IF
  130     CONTINUE

C ---       RECONSTRUCTION DES TABLEAUX DE TRAVAIL  PAR FILTRAGE
C ---       LONLI1 : LONGUEUR UTILE DES TABLEAUX DES NOMS DES NOEUDS,
C ---                DES COMPOSANTES ET DE LEURS VALEURS AVANT
C ---                UN FILTRAGE EVENTUEL SELON DES NOMS DE NOEUDS ET
C ---                DE COMPOSANTES SPECIFIES PAR L'UTILISATEUR :
C                    ------------------------------------------
          LONLI1 = K

C ---       RECONSTRUCTION DES TABLEAUX DE TRAVAIL  PAR FILTRAGE
C ---       EN FONCTION DES NOEUDS ET DES COMPOSANTES SPECIFIES
C ---       PAR L'UTILISATEUR :
C           -----------------
          CALL TRNOR2(NBNO,ZK8(IDLINO),NBCMP,ZK8(IDLICM),OPTIOZ,LONLI1,
     &                ZK8(IDNOMN),ZK8(IDNOMC),ZR(IDVALL),ZI(IDINCM),
     &                ZI(IDNUNO),ZI(IDIDCM),LONLI2)

C ---       IMPRESSION DE LA LIGNE COURANTE SELON LE GRAIN 'NOEUD':
C           -----------------------------------------------------
          CALL IMPFR2(NOMNO1,NBNOMA,LONLI2,ZK8(IDNOMN),
     &                ZK8(IDNOMC),ZR(IDVALL),ZI(IDIDCM),ZI(IDIDNO),
     &                ZK8(IDNCM2),ZR(IDNVAL),ZI(IDNBCM),NCMPMX,NBCMP1,
     &                ZK8(IDNCM1),NBCMP,ZK8(IDLICM),NOEUMA,NBCHIF,
     &                FICHIE)


          CALL JELIBE(JEXNUM(VALE,NUBLOC))
        END IF
  140 CONTINUE

C --- DESTRUCTION DU DESCRIPTEUR DE LA MATRICE :
C     ----------------------------------------
      CALL JEDETR(NOMSD//'.&INT')

      CALL JEDETC('V','&&IMRSMN',1)

      CALL JEDEMA()

      END
