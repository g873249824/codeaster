      SUBROUTINE DRZ12D (LISNOZ ,LONLIS, CHARGZ, TYPLAZ, LISREZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 25/11/98   AUTEUR CIBHHGB G.BERTRAND 
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
      CHARACTER*19 LISREL
      CHARACTER*24 LISNOE
      CHARACTER*(*) CHARGZ, LISNOZ, TYPLAZ, LISREZ
C -------------------------------------------------------
C     BLOCAGE DES DEPLACEMENTS RELATIFS D'UNE LISTE DE NOEUDS
C     SPECIFIEE PAR L'UTILISATEUR DANS LE CAS OU L' ON EST
C     EN 2D ET AU-MOINS L'UN DES NOEUDS PORTE LE DDL DRZ
C -------------------------------------------------------
C  LISNOE        - IN    - K24 - : NOM DE LA LISTE DES
C                -       -     -   NOEUDS A LIER
C -------------------------------------------------------
C  LONLIS        - IN    - I   - : LONGUEUR DE LA LISTE DES
C                -       -     -   NOEUDS A LIER
C -------------------------------------------------------
C  CHARGE        - IN    - K8  - : NOM DE LA SD CHARGE
C                - JXIN  -     -
C -------------------------------------------------------
C TYPLAG         - IN    - K2  - : TYPE DES MULTIPLICATEURS DE LAGRANGE
C                                  ASSOCIES A LA RELATION :
C                              SI = '12'  LE PREMIER LAGRANGE EST AVANT
C                                         LE NOEUD PHYSIQUE
C                                         LE SECOND LAGRANGE EST APRES
C                              SI = '22'  LE PREMIER LAGRANGE EST APRES
C                                         LE NOEUD PHYSIQUE
C                                         LE SECOND LAGRANGE EST APRES
C -------------------------------------------------------
C  LISREL        - IN    - K19 - : NOM DE LA SD
C                - JXVAR -     -   LISTE DE RELATIONS
C -------------------------------------------------------
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
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
      COMPLEX*16    BETAC
      CHARACTER*2   TYPLAG
      CHARACTER*4   TYPVAL, TYPCOE
      CHARACTER*8   BETAF
      CHARACTER*8   MOD, NOMG, NOMNOE, K8BID, NO1
      CHARACTER*8   NOMA, CMP, NOMCMP(NMOCL)
      CHARACTER*9   NOMTE
      CHARACTER*19  LIGRMO
      INTEGER       NTYPEL(NMOCL)
      LOGICAL       VERIF, EXISDG
      CHARACTER*1 K1BID
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------
      CALL JEMARQ()
      LISREL = LISREZ
      CHARGE = CHARGZ
      TYPLAG = TYPLAZ
      LISNOE = LISNOZ
C
C --- INITIALISATIONS
C
      CALL FOZERO('&FOZERO')
      BETAF =  '&FOZERO'
      BETA  = 0.0D0
      BETAC = (0.0D0,0.0D0)
      UN    = 1.0D0
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE
C
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
C
C ---  LIGREL DU MODELE
C
      LIGRMO = MOD(1:8)//'.MODELE'
C
C --- MAILLAGE ASSOCIE AU MODELE
C
      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
C
C --- TYPE DES VALEURS DES COEFFICIENTS DES RELATIONS
C
      TYPCOE = 'REEL'
C
C --- TYPE DES VALEURS AU SECOND MEMBRE DES RELATIONS
C
      TYPVAL = 'REEL'
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
        CALL UTDEBM('F','DRZ12D','NOMBRE DE CMPS SUPERIEUR AU MAX')
        CALL UTIMPI('L','NMAXCMP= ',1,NMOCL)
        CALL UTIMPI('L','NCMP   = ',1,NDDLA)
        CALL UTFINM()
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
         CALL UTMESS('F','DRZ12D',
     &                   'LE DESCRIPTEUR_GRANDEUR DES DEPLACEMENTS'//
     &                    ' NE TIENT PAS SUR DIX ENTIERS CODES')
      ELSE
         CALL JEVEUO (LIGRMO//'.PRNM','L',JPRNM)
      END IF
C
C --- CREATION DES TABLEAUX DE TRAVAIL NECESSAIRES A L'AFFECTATION
C --- DE LISREL
C
C ---  MAJORANT DU NOMBRE DE TERMES DANS UNE RELATION
      NBTERM = 12
C ---  VECTEUR DU NOM DES NOEUDS
      CALL WKVECT ('&&DRZ12D.LISNO','V V K8',NBTERM,JLISNO)
C ---  VECTEUR DU NOM DES DDLS
      CALL WKVECT ('&&DRZ12D.LISDDL','V V K8',NBTERM,JLISDL)
C ---  VECTEUR DES COEFFICIENTS REELS
      CALL WKVECT ('&&DRZ12D.COER','V V R',NBTERM,JLISCR)
C ---  VECTEUR DES COEFFICIENTS COMPLEXES
      CALL WKVECT ('&&DRZ12D.COEC','V V C',NBTERM,JLISCC)
C ---  VECTEUR DES DIRECTIONS DES DDLS A CONTRAINDRE
      CALL WKVECT ('&&DRZ12D.DIRECT','V V R',3*NBTERM,JLISDI)
C ---  VECTEUR DES DIMENSIONS DE CES DIRECTIONS
      CALL WKVECT ('&&DRZ12D.DIME','V V I',NBTERM,JLISDM)
C
C --- RECUPERATION DU TABLEAU DES COORDONNEES
C
      CALL JEVEUO (NOMA//'.COORDO    .VALE','L',JCOOR)
C
C --- ACQUISITION DE LA LISTE DES NOEUDS A LIER
C --- (CETTE LISTE EST NON REDONDANTE)
C
      CALL JEVEUO (LISNOE,'L',ILISNO)
C
C
C ---      ON REGARDE S'IL Y A UN NOEUD DE LA LISTE PORTANT LE DDL DRZ
C
      CMP  = 'DRZ'
      DO 20 I = 1, LONLIS
C ---        NUMERO DU NOEUD COURANT DE LA LISTE
          CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),IN)
C
          ICMP = INDIK8(NOMCMP,CMP,1,NDDLA)
          IF (EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP)) THEN
              NOMNOE = ZK8(ILISNO+I-1)
              INO = IN
              GOTO 30
          ENDIF
  20  CONTINUE
C
      CALL UTMESS('F','DRZ12D',
     +             'INCOHERENCE CAR AUCUN NOEUD N''A DE DDL DRZ'//
     +             ' ET LA ROUTINE TRAITE LE CAS 2D OU IL Y A'//
     +             ' AU-MOINS UN DDL DRZ')
C
  30     CONTINUE
C
         ZK8(JLISNO+2-1) = NOMNOE
         ZK8(JLISNO+3-1) = NOMNOE
C
         DO 40 I=1, LONLIS
            IF (ZK8(ILISNO+I-1).EQ.NOMNOE) GOTO 40
            CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(ILISNO+I-1)),IN)
            X =  ZR(JCOOR-1+3*(IN-1)+1)
     +          -ZR(JCOOR-1+3*(INO-1)+1)
            Y =  ZR(JCOOR-1+3*(IN-1)+2)
     +          -ZR(JCOOR-1+3*(INO-1)+2)
C
C ---    PREMIERE RELATION
C ---    DX(M) - DX(A) + Y*DRZ(A) = 0
C
            NBTERM = 3
C
            ZK8(JLISNO+1-1) = ZK8(ILISNO+I-1)
C
            ZK8(JLISDL+1-1) = 'DX'
            ZK8(JLISDL+2-1) = 'DX'
            ZK8(JLISDL+3-1) = 'DRZ'
C
            ZR(JLISCR+1-1) =  UN
            ZR(JLISCR+2-1) = -UN
            ZR(JLISCR+3-1) =  Y
C
            CALL AFRELA (ZR(JLISCR), ZC(JLISCC), ZK8(JLISDL),
     +                   ZK8(JLISNO), ZI(JLISDM), ZR(JLISDI),
     +                   NBTERM, BETA, BETAC, BETAF, TYPCOE,
     +                   TYPVAL, TYPLAG, LISREL)
C
C ---    DEUXIEME RELATION
C ---    DY(M) - DY(A) - X*DRZ(A) = 0
C
            NBTERM = 3
C
            ZK8(JLISNO+1-1) = ZK8(ILISNO+I-1)
C
            ZK8(JLISDL+1-1) = 'DY'
            ZK8(JLISDL+2-1) = 'DY'
            ZK8(JLISDL+3-1) = 'DRZ'
C
            ZR(JLISCR+1-1) =  UN
            ZR(JLISCR+2-1) = -UN
            ZR(JLISCR+3-1) = -X
C
            CALL AFRELA (ZR(JLISCR), ZC(JLISCC), ZK8(JLISDL),
     +                   ZK8(JLISNO), ZI(JLISDM), ZR(JLISDI),
     +                   NBTERM, BETA, BETAC, BETAF, TYPCOE,
     +                   TYPVAL, TYPLAG, LISREL)
C
C ---    TROISIEME RELATION SI LE NOEUD COURANT PORTE LE DDL DRZ
C ---    DRZ(M) - DRZ(A)  = 0
C
            ICMP = INDIK8(NOMCMP,CMP,1,NDDLA)
            IF (EXISDG(ZI(JPRNM-1+(IN-1)*NBEC+1),ICMP)) THEN
C
                   NBTERM = 2
C
                   ZK8(JLISNO+1-1) = ZK8(ILISNO+I-1)
                   ZK8(JLISNO+2-1) = NOMNOE
C
                   ZK8(JLISDL+1-1) = 'DRZ'
                   ZK8(JLISDL+2-1) = 'DRZ'
C
                   ZR(JLISCR+1-1)  =  UN
                   ZR(JLISCR+2-1)  = -UN
C
                   CALL AFRELA (ZR(JLISCR), ZC(JLISCC), ZK8(JLISDL),
     +                         ZK8(JLISNO), ZI(JLISDM), ZR(JLISDI),
     +                         NBTERM, BETA, BETAC, BETAF, TYPCOE,
     +                         TYPVAL, TYPLAG, LISREL)
            ENDIF
  40     CONTINUE
C
C --- DESTRUCTION DES OBJETS DE TRAVAIL
C
      CALL JEDETR('&&DRZ12D.LISNO')
      CALL JEDETR('&&DRZ12D.LISDDL')
      CALL JEDETR('&&DRZ12D.COER')
      CALL JEDETR('&&DRZ12D.COEC')
      CALL JEDETR('&&DRZ12D.DIRECT')
      CALL JEDETR('&&DRZ12D.DIME')
C
      CALL JEDEMA()
      END
