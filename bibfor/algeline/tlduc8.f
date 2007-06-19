      SUBROUTINE TLDUC8(NOMMAT,HCOL,ADIA,ABLO,NPIVOT,NEQ,NBBLOC,ILDEB,
     +                  ILFIN,EPS)
      IMPLICIT NONE
      CHARACTER*(*) NOMMAT
C  ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 19/06/2006   AUTEUR VABHHTS J.PELLET 
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
C  ------------------------------------------------------------------
C BUT : DECOMPOSTION D'UNE MATRICE NON_SYMETRIQUE A COEFFICIENTS
C       COMPLEXES SOUS LA FORME DE CROUT LDU
C       ELLE CORRESPOND AU SOLVEUR 'LDLT' + COMPLEXE + NON SYM
C       (CETTE ROUTINE EST LA SOEUR JUMELLE DE TLDUR8)
C  ------------------------------------------------------------------
C
C  IN  NOMMAT  :    : NOM UTILISATEUR DE LA MATRICE A FACTORISER
C  IN  HCOL    : IS : HCOL DE LA MATRICE
C  HCOL(I) RENVOIE LA HAUTEUR DE LA I-EME COLONNE
C  IN  ADIA    : IS : ADRESSE DU TERME DIAGONALE DANS SON BLOC
C  ADIA(I) RENVOIE L'ADRESSE DE LA I-EME LIGNE DANS SON BLOC
C  IN  ABLO    :  :   POINTEUR DE BLOC
C  ABLO(I+1) RENVOIE LE NO DE LA DERNIERE LIGNE DU I-EME BLOC
C
C  LES TABLEAUX RELATIFS AUX BLOCS ONT ETE CONSTRUITS A PARTIR
C  DES NBBLOCS PREMIERS BLOCS (I.E LES BLOCS SUP)
C  MAIS ILS RESTENT VALABLES POUR LES NBBLOCS BLOCS SUIVANTS
C  (I.E LES BLOCS INF)
C  PUISQUE LES POFILS SUP ET INF SONT IDENTIQUES
C
C  VAR PIVOT   : IS :
C  : EN SORTIE : NPIVOT  = 0 ==> R.A.S.
C  :             NPIVOT  > 0 ==> MATRICE SINGULIERE
C                                POUR L'EQUATION DE NUMERO NPIVOT
C  :             NPIVOT  < 0 ==> -NPIVOT TERMES DIAGONAUX < 0
C
C  IN  NEQ     : IS : NOMBRE TOTAL D'EQUATION
C  IN  NBBLOC  : IS : NOMBRE DE BLOC DE LA MATRICE
C  IN  ILDEB   : IS : NUMERO DE LA LIGNE DE DEPART DE LA FACTORISATION
C  IN  ILFIN   : IS : NUMERO DE LA LIGNE DE FIN DE FACTORISITION
C  ------------------------------------------------------------------
C
C  CREATION DE DEUX OBJETS DE TRAVAIL (SUR LA VOLATILE)
C  1)  UN TABLEAU POUR LA DIAGONALE
C  2)  UN TABLEAU POUR LA COLONNE COURANTE
C
C
C  --- RAPPEL SOMMAIRE DE L'ALGORITHME ------------------------------
C
C  POUR S = 2,3, ... ,N
C  !  POUR I = 1,2, ... ,S-1
C  !  !  POUR M = 1,2, ... ,I-1
C  !  !  !  K(S,I) = K(S,I) - K(S,M)*K(M,I) % MODIFIE   LA LIGNE
C  !  !  !  K(I,S) = K(I,S) - K(I,M)*K(M,S) % MODIFIE   LA COLONNE
C  !  !  FIN_POUR
C  !  !  K(I,S) = K(I,S)/K(I,I)           % NORMALISATION DE LA COLONNE
C  !  FIN_POUR
C  !  POUR M = 1,2, ... ,S-1
C  !  !  K(S,S) = K(S,S) - K(S,M) * K(M,S)  % MODIFICATION DU PIVOT
C  !  FIN_POUR
C  FIN_POUR
C  ------------------------------------------------------------------
C  REFERENCE (HISTORIQUE) :
C  (1) P.D. CROUT,
C      A SHORT METHOD FOR EVALUATING DETERMINANTS AND SOLVING SYSTEMS
C      OF LINEAR EQUATIONS WITH REAL OR COMPLEX COEFFICIENTS.
C      AIEE TRANSACTION VOL 60, PP 1235-1240  (1941)
C  ------------------------------------------------------------------
C
C  ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C  -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C  ------------------------------------------------------------------
      INTEGER HCOL(*),ADIA(*),ABLO(*)
      INTEGER NPIVOT,NEQ,NBBLOC,ILDEB,ILFIN
      INTEGER IER,LDIAG,LTRAV,IBLOC,IL1,IL2,IAA,IL
      INTEGER IAAS,IAAI,KL1,IMINI,IEQUA,I,JBLMIN,JBLOC,JL1,JL2
      INTEGER IABS,IABI,ILONG,IADIAI,IDEI,IADIAS,IDES,IDL,JNMINI
      INTEGER IADIGS,JEQUA,JLONG,JADIAS,JDES,JADIAI,JDEI,JDL,IBCL1
      INTEGER LM,ICAI,ICAS,ICBI,ICBS,ICD,JREFA

      REAL*8 EPS
      COMPLEX*16 C8VALI,C8VALS
      CHARACTER*24 NOMDIA,UALF,NOMTRA
      CHARACTER*32 JEXNUM
      CHARACTER*19 NOMA19
C  ------------------------------------------------------------------
      DATA UALF/'                   .UALF'/
      DATA NOMDIA/'                   .&VDI'/
      DATA NOMTRA/'                   .&TRA'/
C  ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      NOMA19 = NOMMAT
      UALF(1:19) = NOMMAT
      NOMDIA(1:19) = NOMMAT
      NOMTRA(1:19) = NOMMAT
C
C  --- CREATION/RAPPEL D'UN TABLEAU POUR STOCKER LA DIAGONALE ---
      CALL JEEXIN(NOMDIA,IER)
      IF (IER.EQ.0) THEN
        CALL JECREO(NOMDIA,'V V C')
        CALL JEECRA(NOMDIA,'LONMAX',NEQ,'  ')
      END IF
      CALL JEVEUO(NOMDIA,'E',LDIAG)
      CALL JEVEUO(NOMA19//'.DIGS','E',IADIGS)
C
C  --- CREATION/RAPPEL D'UN TABLEAU INTERMEDIAIRE (D'UNE COLONNE)---
      CALL JEEXIN(NOMTRA,IER)
      IF (IER.EQ.0) THEN
        CALL JECREO(NOMTRA,'V V C')
        CALL JEECRA(NOMTRA,'LONMAX',NEQ,'  ')
      END IF
      CALL JEVEUO(NOMTRA,'E',LTRAV)
C
C  --- INITIALISATIONS ET ALLOCATION ---
C
      NPIVOT = 0
C
C  ------- BOUCLE SUR LES BLOCS A TRANSFORMER -----------------------
      DO 150 IBLOC = 1,NBBLOC
C
        IL1 = ABLO(IBLOC) + 1
        IL2 = ABLO(IBLOC+1)
C
C
        IF (IL2.LT.ILDEB) THEN
C        --- C'EST TROP TOT : MAIS ON REMPLIT LA DIAGONALE ---
          CALL JEVEUO(JEXNUM(UALF,IBLOC),'L',IAA)
          DO 10 IL = IL1,IL2
            ZC(LDIAG+IL-1) = ZC(IAA+ADIA(IL)-1)
   10     CONTINUE
          CALL JELIBE(JEXNUM(UALF,IBLOC))
          GO TO 150
        ELSE IF (IL1.GT.ILFIN) THEN
C        --- C'EST FINI ---
          GO TO 160
        ELSE
C
C- RECUPERATION DES BLOCS SUP ET INF COURANTS
C
          CALL JEVEUO(JEXNUM(UALF,IBLOC),'E',IAAS)
          CALL JEVEUO(JEXNUM(UALF,IBLOC+NBBLOC),'E',IAAI)
          IF (IL1.LT.ILDEB) THEN
            KL1 = ILDEB
            DO 20 IL = IL1,KL1 - 1
              ZC(LDIAG+IL-1) = ZC(IAAI+ADIA(IL)-1)
   20       CONTINUE
          ELSE
            KL1 = IL1
          END IF
          IF (IL2.GT.ILFIN) IL2 = ILFIN
        END IF
C
C
C     --- RECHERCHE DE LA PLUS PETITE EQUATION EN RELATION AVEC UNE
C     --- EQUATION DES LIGNES EFFECTIVES DU BLOC COURANT
        IMINI = IL2 - 1
        DO 30 IEQUA = KL1,IL2
          IMINI = MIN(IEQUA-HCOL(IEQUA),IMINI)
   30   CONTINUE
        IMINI = IMINI + 1
C
C     --- RECHERCHE DU BLOC D'APPARTENANCE DE L'EQUATION IMINI ---
        DO 40 I = 1,IBLOC
          JBLMIN = I
          IF (ABLO(1+I).GE.IMINI) GO TO 50
   40   CONTINUE
   50   CONTINUE
C
C     --- BOUCLE  SUR  LES  BLOCS  DEJA  TRANSFORMES ---
        DO 90 JBLOC = JBLMIN,IBLOC - 1
C
          JL1 = MAX(IMINI,ABLO(JBLOC)+1)
          JL2 = ABLO(JBLOC+1)
          CALL JEVEUO(JEXNUM(UALF,JBLOC),'L',IABS)
          CALL JEVEUO(JEXNUM(UALF,JBLOC+NBBLOC),'L',IABI)
C
          DO 80 IEQUA = KL1,IL2
C
C           --- RECUPERATION DE L'ADRESSE ET LA LONGUEUR DE LA LIGNE
            ILONG = HCOL(IEQUA) - 1
C-   ADRESSE DU TERME DIAGONAL DE LA LIGNE IEQUA DANS LE BLOC INF
            IADIAI = IAAI + ADIA(IEQUA) - 1
C-   ADRESSE DU DEBUT DE LA LIGNE IEQUA DANS LE BLOC INF
            IDEI = IADIAI - ILONG
C-   ADRESSE DU TERME DIAGONAL DE LA COLONNE IEQUA DANS LE BLOC SUP
            IADIAS = IAAS + ADIA(IEQUA) - 1
C-   ADRESSE DU DEBUT DE LA COLONNE IEQUA DANS LE BLOC SUP
            IDES = IADIAS - ILONG
C-   INDICE DU DEBUT DE LA LIGNE (COLONNE) IEQUA
            IDL = IEQUA - ILONG
C
C           --- UTILISATION DES LIGNES (IDL+1) A (JL2) ---
C
C- MODIFICATION DES LIGNES   IDLI+1 A JL2
C-          ET  DES COLONNES IDLS+1 A JL2
C- POUR LES BLOCS SUP ET INF COURANTS AUXQUELS ON A ACCEDE EN ECRITURE
C
            JNMINI = MAX(IDL,JL1)
            DO 70 JEQUA = JNMINI,JL2
              JLONG = HCOL(JEQUA) - 1
C-    ADRESSE DU TERME DIAGONAL KII DANS LE BLOC SUP
              JADIAS = IABS + ADIA(JEQUA) - 1
C-    ADRESSE DANS LE BLOC SUP DU PREMIER TERME NON NUL DE LA COLONNE I
              JDES = JADIAS - JLONG
C-    ADRESSE DU TERME DIAGONAL KII DANS LE BLOC INF
              JADIAI = IABI + ADIA(JEQUA) - 1
C-    ADRESSE DANS LE BLOC INF DU PREMIER TERME NON NUL DE LA LIGNE I
              JDEI = JADIAI - JLONG
C-    INDICE DU PREMIER TERME NON NUL DE LA COLONNE (LIGNE) I
              JDL = JEQUA - JLONG
C-    INDICE DU PREMIER TERME A PARTIR DUQUEL ON VA FAIRE LE PRODUIT
C-    SCALAIRE K(S,M)*K(M,I) DES TERMES LIGNE-COLONNE
              IBCL1 = MAX(IDL,JDL)
C-    LONGUEUR SUR LAQUELLE ON FAIT LE PRODUIT SCALAIRE LIGNE-COLONNE
              LM = JEQUA - IBCL1
C-    ADRESSE DANS LE BLOC INF DU PREMIER TERME A MODIFIER SUR LA LIGNE
C-    IEQUA
              ICAI = IDEI + IBCL1 - IDL
C-    ADRESSE DANS LE BLOC SUP DU PREMIER TERME A MODIFIER SUR LA
C-    COLONNE IEQUA
              ICAS = IDES + IBCL1 - IDL
C-    ADRESSE DANS LE BLOC INF DU PREMIER TERME DE LA LIGNE
C-    A PARTIR DUQUEL ON FAIT LE PRODUIT SCALAIRE POUR MODIFIER LA
C-    COLONNE = K(I,M)
              ICBI = JDEI + IBCL1 - JDL
C-    ADRESSE DANS LE BLOC SUP DU PREMIER TERME DE LA COLONNE
C-    A PARTIR DUQUEL ON FAIT LE PRODUIT SCALAIRE POUR MODIFIER LA
C-    LIGNE = K(M,I)
              ICBS = JDES + IBCL1 - JDL
C-    TERME COURANT DE LA LIGNE S=IEQUA A MODIFIER ( = K(S,I))
              C8VALI = ZC(ICAI+LM)
C-    TERME COURANT DE LA COLONNE S=IEQUA A MODIFIER ( = K(I,S))
              C8VALS = ZC(ICAS+LM)
              DO 60 I = 0,LM - 1
C-                   K(S,I) = K(S,I) -  K(S,M)   * K(M,I)
                C8VALI = C8VALI - ZC(ICAI+I)*ZC(ICBS+I)
C-                   K(I,S) = K(I,S) -  K(M,S)   * K(I,M)
                C8VALS = C8VALS - ZC(ICAS+I)*ZC(ICBI+I)
   60         CONTINUE
              ZC(ICAI+LM) = C8VALI
              ZC(ICAS+LM) = C8VALS
              ICD = LDIAG + JEQUA - 1
C                    ZC(ICAI+LM) = ZC(ICAI+LM) / ZC(ICD)
              ZC(ICAS+LM) = ZC(ICAS+LM)/ZC(ICD)
C
   70       CONTINUE
   80     CONTINUE
C
C-  DEVEROUILLAGE DES BLOCS SUP ET INF DEJA TRANSFORMES
C
          CALL JELIBE(JEXNUM(UALF,JBLOC))
          CALL JELIBE(JEXNUM(UALF,JBLOC+NBBLOC))
   90   CONTINUE
C
C     --- UTILISATION DU BLOC EN COURS DE TRANSFORMATION ---
        JL1 = MAX(IMINI,IL1)
        DO 140 IEQUA = KL1,IL2
C
C        --- RECUPERATION DE L ADRESSE ET LA LONGUEUR DE LA LIGNE
C            (COLONNE) ---
C           IADIAI : ADRESSE DU TERME DIAGONAL COURANT DS LE BLOC INF
C           IADIAS : ADRESSE DU TERME DIAGONAL COURANT DS LE BLOC SUP
C           IDEI   : ADRESSE DU DEBUT DE LA LIGNE COURANTE
C           IDES   : ADRESSE DU DEBUT DE LA COLONNE COURANTE
C           IDL   : 1-ER DDL A VALEUR NON NULLE DANS LA LIGNE (COLONNE)
          ILONG = HCOL(IEQUA) - 1
C-  ADRESSE DE K(S,S) DANS LE BLOC INF
          IADIAI = IAAI + ADIA(IEQUA) - 1
C-  ADRESSE DU PREMIER TERME NON NUL SUR LA LIGNE S (IEQUA) DANS
C-  LE BLOC INF
          IDEI = IADIAI - ILONG
C-  ADRESSE DE K(S,S) DANS LE BLOC SUP
          IADIAS = IAAS + ADIA(IEQUA) - 1
C-  ADRESSE DU PREMIER TERME NON NUL SUR LA COLONNE S (IEQUA)
C-  DANS LE BLOC SUP
          IDES = IADIAS - ILONG
C-  INDICE DU PREMIER TERME NON NUL SUR LA LIGNE (COLONNE) S (IEQUA)
          IDL = IEQUA - ILONG
C
C        --- UTILISATION DES LIGNES (IDL+1) A (IEQUA-1) ---
          JNMINI = MAX(IEQUA-ILONG,JL1)
          DO 120 JEQUA = JNMINI,IEQUA - 1
            JLONG = HCOL(JEQUA) - 1
C-      ADRESSE DE K(I,I) DANS LE BLOC INF
            JADIAI = IAAI + ADIA(JEQUA) - 1
C-      ADRESSE DU PREMIER TERME NON NUL SUR LA LIGNE I (JEQUA)
C-      DANS LE BLOC INF
            JDEI = JADIAI - JLONG
C-      ADRESSE DE K(I,I) DANS LE BLOC SUP
            JADIAS = IAAS + ADIA(JEQUA) - 1
C-      ADRESSE DU PREMIER TERME NON NUL SUR LA COLONNE I (JEQUA)
C-      DANS LE BLOC SUP
            JDES = JADIAS - JLONG
C-      INDICE DU PREMIER TERME NON NUL SUR LA LIGNE (COLONNE) I
C-      (JEQUA)
            JDL = JEQUA - JLONG
C-      INDICE DU PREMIER TERME A PARTIR DUQUEL ON VA FAIRE LES
C-      PRODUITS SCALAIRES (LIGNE I X COLONNE S) ET
C-      (LIGNE S X COLONNE I)
            IBCL1 = MAX(IDL,JDL)
C-      LONGUEUR SUR LAQUELLE ON FAIT LES PRODUITS SCALAIRES
C-      VECTEUR LIGNE X VECTEUR COLONNE
            LM = JEQUA - IBCL1
C-      ADRESSE DANS LE BLOC INF DU PREMIER TERME A PARTIR DUQUEL ON
C-      FAIT LE PRODUIT SCALAIRE POUR CALCULER LE TERME LIGNE K(S,I)
            ICAI = IDEI + IBCL1 - IDL
C-      ADRESSE DANS LE BLOC SUP DU PREMIER TERME A PARTIR DUQUEL ON
C-      FAIT LE PRODUIT SCALAIRE POUR CALCULER LE TERME LIGNE K(S,I)
            ICBS = JDES + IBCL1 - JDL
C-      ADRESSE DANS LE BLOC SUP DU PREMIER TERME A PARTIR DUQUEL ON
C-      FAIT LE PRODUIT SCALAIRE POUR CALCULER LE TERME COLONNE
            ICAS = IDES + IBCL1 - IDL
C-      ADRESSE DANS LE BLOC INF DU PREMIER TERME A PARTIR DUQUEL ON
C-      FAIT LE PRODUIT SCALAIRE POUR CALCULER LE TERME COLONNE
            ICBI = JDEI + IBCL1 - JDL
C-      TERME COURANT DE LA LIGNE S (IEQUA) = K(S,I)
            C8VALI = ZC(ICAI+LM)
C-      TERME COURANT DE LA COLONNE S (IEQUA) = K(I,S)
            C8VALS = ZC(ICAS+LM)
            DO 100 I = 0,LM - 1
C-                K(S,I) = K(S,I) -  K(S,M)   * K(M,I)
              C8VALI = C8VALI - ZC(ICAI+I)*ZC(ICBS+I)
C-                K(I,S) = K(I,S) -  K(M,S)   * K(I,M)
              C8VALS = C8VALS - ZC(ICAS+I)*ZC(ICBI+I)
  100       CONTINUE
            ZC(ICAI+LM) = C8VALI
            ZC(ICAS+LM) = C8VALS
C
C        --- UTILISATION DE LA LIGNE IEQUA (CALCUL DU PIVOT) ---
  110       CONTINUE
            ICD = LDIAG + JEQUA - 1
            ZC(ICAS+LM) = ZC(ICAS+LM)/ZC(ICD)
  120     CONTINUE

C
C        --- CALCUL DU TERME DIAGONAL ---
          LM = ILONG - 1
C-      INDICE DU PREMIER TERME NON NUL DE LA LIGNE COURANTE IEQUA
C-      DS LE BLOC
          ICAI = IADIAI - ILONG
          ICAS = IADIAS - ILONG
C
C        --- SAUVEGARDE DE LA COLONNE ---
C        --- NORMALISATION DE LA LIGNE ---
C-      INDICE DU PREMIER TERME DIAGONAL DANS LE VECTEUR DES TERMES
C-      DIAGONAUX NON ENCORE DECOMPOSES CORRESPONDANT AU PREMIER
C-      TERME DE LA LIGNE COURANTE A NORMALISER
          ICD = LDIAG + IEQUA - ILONG - 1
          C8VALI = ZC(IADIAI)
          DO 130 I = 0,LM
            C8VALI = C8VALI - ZC(ICAI+I)*ZC(ICAS+I)
  130     CONTINUE
          ZC(IADIAI) = C8VALI
          ZR(IADIGS-1+NEQ+IEQUA) = ABS(ZC(IADIAI))
          ZC(LDIAG+IEQUA-1) = C8VALI

C
C           --- LE PIVOT EST-IL NUL ? ----------------------------------
          IF (ABS(C8VALI).LE.EPS) THEN
            NPIVOT = IEQUA
            GO TO 9999
          END IF
C
  140   CONTINUE
        CALL JELIBE(JEXNUM(UALF,IBLOC))
        CALL JELIBE(JEXNUM(UALF,IBLOC+NBBLOC))
  150 CONTINUE
C
  160 CONTINUE
 9999 CONTINUE


      CALL JEVEUO(NOMA19//'.REFA','E',JREFA)
      IF (ILFIN.EQ.NEQ) THEN
         ZK24(JREFA-1+8)='DECT'
      ELSE
         ZK24(JREFA-1+8)='DECP'
      ENDIF

      CALL JEDEMA()
      END
