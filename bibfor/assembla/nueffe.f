      SUBROUTINE NUEFFE(LLIGR,BASE,NUZ,RENUM,MOLOC,SOLVEU,NEQUA)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19 SOLVEU
      INTEGER NEQUA
      CHARACTER*(*) LLIGR,NUZ,RENUM
      CHARACTER*2 BASE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C TOLE CRP_20

C ----------------------------------------------------------------------
C BUT : CONSTRUCTION DU NUME_EQUA D'UN NUME_DDL
C ----------------------------------------------------------------------
C IN/JXOUT K*14 NU  : LE CHAMP .NUME (SD NUME_EQUA) DE LA S.D. NUME_DDL
C                   EST CREE ET REMPLI.
C                   SI NU EXISTE DEJA ON LE DETRUIT COMPLETEMENT
C IN  K2   BASE    : BASE(1:1) : BASE POUR CREER LE NUME_DDL
C                    (SAUF LE PROF_CHNO)
C                  : BASE(2:2) : BASE POUR CREER LE PROF_CHNO
C IN  K24 LLIGR  : NOM D'UN OBJET JEVEUX REPRESENTANT UN VECTEUR
C                   DE K24 DONT LES ELEMENTS SONT LES NOMS(TOUS DIFF)
C                   DES S.D. DE TYPE LIGREL.
C IN  K*4  RENUM : METHODE DE RENUMEROTATION DES NOEUDS:
C                   SANS/RCMK/MD/MDA/METIS
C IN  K*   MOLOC : NOM D'UNE GRANDEUR 1ERE (OU ' ')
C                   SINON LA NUMEROTATION EST BASEE SUR CETTE GRANDEUR
C IN K*    SOLVEU : NOM DE LA SD SOLVEUR
C OUT  I   NEQUA  : NBRE EQUATIONS DU SOUS-DOMAINE (EXPLOITE QU'EN DD)
C-----------------------------------------------------------------------
C ATTENTION : NE PAS FAIRE JEMARQ/JEDEMA CAR NULILI
C             RECOPIE DES ADRESSES JEVEUX DANS .ADNE ET .ADLI
C-----------------------------------------------------------------------

C-----------------------------------------------------------------------
      CHARACTER*(*) MOLOC
      CHARACTER*8 NOMGDS,KBID
C-----------------------------------------------------------------------
      INTEGER N,IGDS,NEC,NLILI
C----------------------------------------------------------------------
C     VARIABLES LOCALES
C----------------------------------------------------------------------
      CHARACTER*8 CBID,NOMCMP
      CHARACTER*8 MAILLA
      CHARACTER*14 NU
      CHARACTER*16 NOMTE
      CHARACTER*24 LILI,NNLI,PSUIV,LSUIV,VSUIV,NUM21,NUNO,NOMLI,
     &             DERLI,NUM2,DSCLAG,EXI1,NEWN,OLDN
      INTEGER NBNO,NDDL,ILIM,ITYPEL,INDIK8
      INTEGER I,IAD,IADLIE,IADNEM,IANUEQ,IBID,ICDDLB
      INTEGER ICER1,ICER2,ICONX1,ICONX2,IDDLAG,IDERLI,IDLGNS
      INTEGER IDNBNO,IDNEQU,IDNOCM,IDPRN1,IDPRN2,IDREF
      INTEGER IEC,IEL,IER,IEXI1,IFM,IGR,IGREL,ILAG,ILAG2,ILAG3
      INTEGER ILI,ILSUIV,INEWN,INO,INULAG,INUM2,INUM21
      INTEGER INUNO1,INUNO2,IOLDN,IPRNM,IPRNS,IPSUIV,IRE,IRET
      INTEGER IVSUIV,J,J1,JNULAG,JPRNO,K,L,L1,L2,LONG,N0
      INTEGER N0RE,N1,N1M1RE,N1RE,N2,N21,N3,NBCMP,NBN,NBNL
      INTEGER NBNOM,NBNONU,NBNORE,NCMP,NDDL1,NDDLB
      INTEGER NEL,NIV,NLAG,NMA,NN
      INTEGER NS,NUMA,NUNOEL
      INTEGER ISLVK,VALI(4)
      LOGICAL LFETI

C     NBNOM  : NOMBRE DE NOEUDS DU MAILLAGE
C     DERLI  : NOM DE L'OBJET NU.DERLI CREE SUR 'V'
C              DERLI(N3)= MAX DES N1 TELS QUE IL EXISTE UNE MAILLE SUP
C              DE TYPE SEG3 MS TELLE QUE N1 1ER, N3 3EME NOEUD DE MS
C     DSCLAG : NOM DE L'OBJET NU.DSCLAG CREE SUR 'V'
C              DIM=3*NBRE LE LAGR.
C              SI ILAG LAGRANGE DE BLOCAGE
C              DSCLAG(3*(ILAG-1)+1)= +NUM DU NOEUD PH. BLOQUE
C              DSCLAG(3*(ILAG-1)+2)= -NUM DU DDL DU NOEUD PH. BLOQUE
C              DSCLAG(3*(ILAG-1)+3)= +1 SI 1ER LAGR.
C                                    +2 SI 2EME LAGR.
C              SI ILAG LAGRANGE DE LIAISON
C              DSCLAG(3*(ILAG-1)+1)= 0
C              DSCLAG(3*(ILAG-1)+2)= 0
C              DSCLAG(3*(ILAG-1)+3)= +1 SI 1ER LAGR.
C                                    +2 SI 2EME LAGR.
C-----------------------------------------------------------------------
C     FONCTIONS LOCALES D'ACCES AUX DIFFERENTS CHAMPS DES
C     S.D. MANIPULEES DANS LE SOUS PROGRAMME
C-----------------------------------------------------------------------
      INTEGER ZZLIEL,ZZNGEL,ZZNSUP,ZZNELG,ZZNELS
      INTEGER ZZNEMA,ZZPRNO,IZZPRN,SUIV,SUIVDI,IDSUIV

C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS LIEL DES S.D. LIGREL
C     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL
C     ZZLIEL(ILI,IGREL,J) =
C      SI LA JIEME MAILLE DU LIEL IGREL DU LIGREL ILI EST:
C          -UNE MAILLE DU MAILLAGE : SON NUMERO DANS LE MAILLAGE
C          -UNE MAILLE TARDIVE : -POINTEUR DANS LE CHAMP .NEMA

      ZZLIEL(ILI,IGREL,J) = ZI(ZI(IADLIE+3* (ILI-1)+1)-1+
     &                      ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1)+J-1)

C---- NBRE DE GROUPES D'ELEMENTS (DE LIEL) DU LIGREL ILI

      ZZNGEL(ILI) = ZI(IADLIE+3* (ILI-1))

C---- NBRE DE NOEUDS DE LA MAILLE TARDIVE IEL ( .NEMA(IEL))
C     DU LIGREL ILI REPERTOIRE .LILI
C     (DIM DU VECTEUR D'ENTIERS .LILI(ILI).NEMA(IEL) )

      ZZNSUP(ILI,IEL) = ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL) -
     &                  ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1) - 1

C---- NBRE D ELEMENTS DU LIEL IGREL DU LIGREL ILI DU REPERTOIRE .LILI
C     (DIM DU VECTEUR D'ENTIERS .LILI(ILI).LIEL(IGREL) )

      ZZNELG(ILI,IGREL) = ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL) -
     &                    ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1) - 1

C---- NBRE D ELEMENTS SUPPLEMENTAIRE (.NEMA) DU LIGREL ILI DE .LILI

      ZZNELS(ILI) = ZI(IADNEM+3* (ILI-1))

C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS NEMA DES S.D. LIGREL
C     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL
C     ZZNEMA(ILI,IEL,J) =  1.LE. J .GE. ZZNELS(ILI)
C      SI LE J IEME NOEUD DE LA MAILE TARDIVE IEL DU LIGREL ILI EST:
C          -UN NOEUD DU MAILLAGE : SON NUMERO DANS LE MAILLAGE
C          -UN NOEUD TARDIF : -SON NUMERO DANS LA NUMEROTATION LOCALE
C                              AU LIGREL ILI
C     ZZNEMA(ILI,IEL,ZZNELS(ILI)+1)=NUMERO DU TYPE_MAILLE DE LA MAILLE
C                                   IEL DU LIGREL ILI

      ZZNEMA(ILI,IEL,J) = ZI(ZI(IADNEM+3* (ILI-1)+1)-1+
     &                    ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1)+J-1)

C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
C     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL ET A LEURS ADRESSES
C     ZZPRNO(ILI,NUNOEL,1) = NUMERO DE L'EQUATION ASSOCIEES AU 1ER DDL
C                            DU NOEUD NUNOEL DANS LA NUMEROTATION LOCALE
C                            AU LIGREL ILI DE .LILI
C     ZZPRNO(ILI,NUNOEL,2) = NOMBRE DE DDL PORTES PAR LE NOEUD NUNOEL
C     ZZPRNO(ILI,NUNOEL,2+1) = 1ER CODE
C     ZZPRNO(ILI,NUNOEL,2+NEC) = NEC IEME CODE

      IZZPRN(ILI,NUNOEL,L) = (IDPRN1-1+ZI(IDPRN2+ILI-1)+
     &                       (NUNOEL-1)* (NEC+2)+L-1)
      ZZPRNO(ILI,NUNOEL,L) = ZI(IDPRN1-1+ZI(IDPRN2+ILI-1)+
     &                       (NUNOEL-1)* (NEC+2)+L-1)

C---- FONCTION D ACCES AUX ELEMENTS DES OBJETS VSUIV ET PSUIV DE LA
C     BASE VOLATILE
C     LES NOEUDS SUP SONT DES LAGRANGE. ON GENERE 2 LAGRANGE
C     "LAGR1" ET "LAGR2" PAR CONDITION DE BLOCAGE ET AUTANT DE MAILLE
C     SUP MSI QU'IL Y A DE NOEUDS NI CONCERNES PAR LE BLOCAGE,ON NOTE
C     NIINF LE NOEUD DE NI NUMERO INF ET NIMAX CELUI DE NUMERO MAX
C     CES MAILLES SUP MSI SONT CARACTERISEES PAR :
C     - TYPE_ELEM = SEG3 -1ER NOEUD NI -2EME NOEUD "LAGR1"-3EME "LAGR2"
C     PAR CONVENTION LE "LAGR1" EST NUMEROTE A LA SUITE DE NIINF-1
C     ET LE "LAGR2" EST NUMEROTE A LA SUITE DE NIMAX
C     SUIVDI(I) = PSUIV(I+1)-PSUIV(I) : NBRE DE NOEUDS SUP "LAGR1" EN
C     RELATION AVEC NI+1 + NBRE DE "LAGR2" EN RELATION AVEC NI
C     SUIVDI(I,J)= NUMERO DU JEME NOEUD SUP SI IL EST A NUMEROTE APRES
C     LE NOEUD NI, -1 "SINON" (NI/= NIMAX DU BLOCAGE RELATIF A J)
      SUIVDI(I) = ZI(IPSUIV+I) - ZI(IPSUIV+I-1)
      IDSUIV(I,J) = IVSUIV + (ZI(IPSUIV+I-1)+J-1) - 1
      SUIV(I,J) = ZI(IVSUIV+ (ZI(IPSUIV+I-1)+J-1)-1)
C----------------------------------------------------------------------

      CALL INFNIV(IFM,NIV)
      NU = NUZ

C --- FETI OR NOT FETI ?
      CALL JEEXIN('&FETI.MAILLE.NUMSD',IRET)
      IF (IRET.GT.0) THEN
        CALL INFMUE()
        CALL INFNIV(IFM,NIV)
        LFETI=.TRUE.
      ELSE
        LFETI=.FALSE.
      ENDIF

C --- SI LE CONCEPT : NU EXISTE DEJA, ON LE DETRUIT COMPLETEMENT :
C     ----------------------------------------------------------
      CALL DETRSD('NUME_DDL',NU)

C --- NOMS DES PRINCIPAUX OBJETS JEVEUX :
C     ---------------------------------
      LILI = NU//'.NUME.LILI'
      EXI1 = NU//'.EXI1'
      NEWN = NU//'.NEWN'
      OLDN = NU//'.OLDN'
      DERLI = NU//'.DERLI'
      PSUIV = NU//'.PSUIVE'
      LSUIV = NU//'.LSUIVE'
      VSUIV = NU//'.VSUIVE'
      NUNO = NU//'.NUNO'
      NNLI = NU//'.NNLI'
      NUM21 = NU//'.NUM21'
      NUM2 = NU//'.NUM2'
      DSCLAG = NU//'.DESCLAG'

C --- CREATION DE LA COLLECTION NU.NUME.LILI
C --- ET DE NU//'     .ADNE' ET NU//'     .ADLI' SUR 'V' :
C     --------------------------------------------------
      CALL NULILI(LLIGR,LILI,BASE(2:2),MOLOC,NOMGDS,IGDS,MAILLA,NEC,
     &            NCMP,NLILI)

      CALL JEVEUO(NU//'     .ADLI','E',IADLIE)
      CALL JEVEUO(NU//'     .ADNE','E',IADNEM)
      CALL JEEXIN(MAILLA(1:8)//'.CONNEX',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(MAILLA(1:8)//'.CONNEX','L',ICONX1)
        CALL JEVEUO(JEXATR(MAILLA(1:8)//'.CONNEX','LONCUM'),'L',ICONX2)
      END IF



C --- LILI(1)='&MAILLA'
C     -----------------
      ILIM = 1

C --- ALLOCATION DE L'OBJET NU.NNLI NOMBRE DE NOEUDS DECLARES DANS
C --- LE LIGREL ILI DE LILI :
C     ---------------------
      CALL JECREO(NNLI,'V V I')
      CALL JEECRA(NNLI,'LONMAX',NLILI,' ')
      CALL JEVEUO(NNLI,'E',IDNBNO)
      CALL JECREC(NUNO,'V V I ','NU','CONTIG','VARIABLE',NLILI)


C --- ALLOCATION DE PRNO :
C     -------------------------------------------------
      CALL JECREC(NU//'.NUME.PRNO',BASE(2:2)//' V I ','NU','CONTIG',
     &            'VARIABLE',NLILI)


C --- CALCUL DE N, CALCUL DES NNLI ET DU POINTEUR DE LONGUEUR DE
C --- PRNO :
C --- NBNOM NOMBRE DE NOEUDS TOTAL DU MAILLAGE :
C     ------------------------------------------
      CALL DISMOI('F','NB_NO_MAILLA',MAILLA,'MAILLAGE',NBNO,CBID,IER)
      CALL DISMOI('F','NB_NL_MAILLA',MAILLA,'MAILLAGE',NBNL,CBID,IER)
      NBNOM = NBNO + NBNL
      ZI(IDNBNO) = NBNOM
      CALL JEECRA(JEXNUM(NUNO,1),'LONMAX',NBNOM,KBID)
      CALL JEECRA(JEXNUM(NU//'.NUME.PRNO',1),'LONMAX',NBNOM* (NEC+2),
     &            KBID)


C --- N CONTIENDRA LE NOMBRE TOTAL (MAX) DE NOEUDS DE NUME_DDL
C --- TOUS LES NOEUDS DU MAILLAGE + TOUS LES NOEUDS SUPL. DES LIGRELS :
C     ---------------------------------------------------------------
      N = NBNOM
      DO 10 ILI = 2,NLILI
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEEXIN(NOMLI(1:19)//'.NBNO',IRET)
        IF (IRET.NE.0) THEN

C ---    ACCES AU NOMBRE DE NOEUDS SUP DU LIGREL DE NOM NOMLI :
C        ----------------------------------------------------
          CALL JEVEUO(NOMLI(1:19)//'.NBNO','L',IAD)
          NBN = ZI(IAD)
        ELSE
          NBN = 0
        END IF

C ---    AFFECTATION DU CHAMP .NNLI DE NU :
C        --------------------------------
        ZI(IDNBNO+ILI-1) = NBN
        CALL JEECRA(JEXNUM(NUNO,ILI),'LONMAX',NBN,KBID)

        CALL JEECRA(JEXNUM(NU//'.NUME.PRNO',ILI),'LONMAX',NBN* (NEC+2),
     &              KBID)
        N = N + NBN
   10 CONTINUE

      CALL JEVEUO(NU//'.NUME.PRNO','E',IDPRN1)
      CALL JEVEUO(JEXATR(NU//'.NUME.PRNO','LONCUM'),'L',IDPRN2)


C --- ALLOCATION DE LA COLLECTION NUNO NUMEROTEE DE VECTEUR DE LONGUEUR
C --- NNLI ET DE NBRE D'ELMT NLILI SUR LA BASE VOLATILE (.NUNO ET .NNLI
C --- SONT SUPPRIMES DE LA S.D. NUME_EQUA) :
C     ------------------------------------
      CALL JEVEUO(NUNO,'E',INUNO1)
      CALL JEVEUO(JEXATR(NUNO,'LONCUM'),'L',INUNO2)
      NLAG = ZI(INUNO2+NLILI) - ZI(INUNO2+1)


C --- RENUMEROTATION , CREATION DES OBJETS NU.EXI1, NU.NEWN ET NU.OLDN :
C     ----------------------------------------------------------------

      CALL RENUNO(NU,RENUM)
      CALL JEVEUO(EXI1,'L',IEXI1)
      CALL JEVEUO(NEWN,'L',INEWN)
      CALL JEVEUO(OLDN,'L',IOLDN)

C --- ALLOCATION DE PSUIV LSUIV OBJETS DE LA BASE VOLATILE :
C     ----------------------------------------------------
      CALL WKVECT(PSUIV,' V V I',N+2,IPSUIV)
      CALL WKVECT(LSUIV,' V V I',N+1,ILSUIV)

C --- CALCUL DE  PSUIV
C --- 1ERE ETAPE :
C --- PSUIV(K)= NOMBRE DE NOEUDS SUP A ECRIRE DERRIERE K :
C     ==================================================
      DO 30 ILI = 2,NLILI

C ---  INULAG EST UN INDICATEUR PERMETTANT DE SAVOIR SI LE
C ---  LIGREL CONTIENT DES MAILLES DE LAGRANGE (INFORMATION
C ---  EQUIVALENTE A L'EXISTENCE DE L'OBJET LIGREL.LGNS) :
C      -------------------------------------------------
        INULAG = 0
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEEXIN(NOMLI(1:19)//'.LGNS',IRET)
        IF (IRET.NE.0) THEN

C ---  SIGNIFICATION DE LIRGEL.LGNS :
C ---  C'EST L'INDICATEUR DE POSITION DU PREMIER LAGRANGE
C ---  SI = +1 ON LE PLACE AVANT LE PREMIER DDL PHYSIQUE
C ---          CONCERNE PAR LA RELATION OU LE BLOCAGE
C ---  SI = -1 ON LE PLACE APRES LE DERNIER DDL PHYSIQUE
C ---          CONCERNE PAR LA RELATION OU LE BLOCAGE :
C              --------------------------------------
          CALL JEVEUO(NOMLI(1:19)//'.LGNS','L',IDLGNS)
          INULAG = 1
        END IF

        DO 20 IEL = 1,ZZNELS(ILI)
          NN = ZZNSUP(ILI,IEL)

C ---   DOUBLE LAGRANGE :
C ---   N2 DERRIERE LE NOEUD DU MAILLAGE DE NUMERO NEWN(N1)-1
C ---   SI L'INDICATEUR DE POSITION DU PREMIER LAGRANGE = +1
C ---   N2 DERRIERE LE NOEUD DU MAILLAGE DE NUMERO NEWN(N1)
C ---   SI L'INDICATEUR DE POSITION DU PREMIER LAGRANGE = -1
C ---   N3 DERRIERE LE NOEUD DU MAILLAGE NEW(N1) :
C ---   SI L'INDICATEUR DE POSITION DU PREMIER LAGRANGE = +1
C ---   N3 DERRIERE N2
C ---   SI L'INDICATEUR DE POSITION DU PREMIER LAGRANGE = -1 :
C       ----------------------------------------------------
          IF (NN.EQ.3) THEN
            N1 = ZZNEMA(ILI,IEL,1)
            N2 = ZZNEMA(ILI,IEL,2)
            N3 = ZZNEMA(ILI,IEL,3)
            IF (((N1.GT.0).AND. (N2.LT.0)) .AND. (N3.LT.0)) THEN
              N21 = -N2
              N1RE = ZI(INEWN-1+N1)
              N1M1RE = N1RE - 1

C ---  RECUPERATION DE L'INDICATEUR DE POSITION DU PREMIER LAGRANGE :
C      ------------------------------------------------------------
              IF (INULAG.EQ.1) THEN

C ---    LE PREMIER LAGRANGE EST PLACE AVANT LE PREMIER DDL PHYSIQUE
C ---    CONCERNE PAR LE BLOCAGE OU LA RELATION :
C        --------------------------------------
                IF (ZI(IDLGNS+N21-1).EQ.1) THEN
                  N1M1RE = N1RE - 1

C ---    LE PREMIER LAGRANGE EST PLACE ALORS  APRES LE DERNIER DDL
C ---    PHYSIQUE CONCERNE PAR LE BLOCAGE OU LA RELATION :
C        ----------------------------------------------
                ELSE IF (ZI(IDLGNS+N21-1).EQ.-1) THEN
                  N1M1RE = N1RE
                ELSE
                  CALL U2MESS('F','ASSEMBLA_27')
                END IF
              END IF

              ZI(IPSUIV+N1M1RE) = ZI(IPSUIV+N1M1RE) + 1
              ZI(IPSUIV+N1RE) = ZI(IPSUIV+N1RE) + 1
            END IF
          END IF
   20   CONTINUE
   30 CONTINUE

C --- 2EME ETAPE :
C --- PSUIV = PROFIL DE PSUIV :
C     =======================
      L1 = ZI(IPSUIV)
      ZI(IPSUIV) = 1
      DO 40 I = 1,N + 1
        L2 = ZI(IPSUIV+I)
        ZI(IPSUIV+I) = ZI(IPSUIV+I-1) + L1
        L1 = L2
   40 CONTINUE

C --- ALLOCATION DE VSUIV :
C     -------------------
      LONG = ZI(IPSUIV+N+1) - 1
      IF (LONG.GT.0) THEN
        CALL WKVECT(VSUIV,' V V I',LONG,IVSUIV)
        CALL WKVECT(DERLI,' V V I',N+1,IDERLI)

C --- ALLOCATION DE DSCLAG LE DESCRIPTEUR DES "LAGRANGE"
C --- DIM(DSCLAG) = 3*NLAG NLAG:NOMBRE TOTAL DE "LAGRANGE"
C --- LES "LAGRANGE" SONT NUMEROTES SUR LA NUMEROTATION GLOBALE DE
C --- 1ER NIVEAU EN OUBLIANT LES NOEUDS DU MAILLAGE :
C     ---------------------------------------------
        CALL WKVECT(DSCLAG,' V V I',3*NLAG,IDDLAG)
      END IF

C --- CALCUL DE VSUIV ET LSUIV :
C     ========================
      DO 80 ILI = 2,NLILI

C ---  INULAG EST UN INDICATEUR PERMETTANT DE SAVOIR SI LE
C ---  LIGREL CONTIENT DES MAILLES DE LAGRANGE (INFORMATION
C ---  EQUIVALENTE A L'EXISTENCE DE L'OBJET LIGREL.LGNS) :
C      -------------------------------------------------
        INULAG = 0
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEEXIN(NOMLI(1:19)//'.LGNS',IRET)
        IF (IRET.NE.0) THEN

C ---  SIGNIFICATION DE LIRGEL.LGNS :
C ---  C'EST L'INDICATEUR DE POSITION DU PREMIER LAGRANGE
C ---  SI = +1 ON LE PLACE AVANT LE PREMIER DDL PHYSIQUE
C ---          CONCERNE PAR LA RELATION OU LE BLOCAGE
C ---  SI = -1 ON LE PLACE APRES LE DERNIER DDL PHYSIQUE
C ---          CONCERNE PAR LA RELATION OU LE BLOCAGE :
C              --------------------------------------
          CALL JEVEUO(NOMLI(1:19)//'.LGNS','L',IDLGNS)
          INULAG = 1
        END IF

        DO 70 IEL = 1,ZZNELS(ILI)
          NN = ZZNSUP(ILI,IEL)
          IF (NN.EQ.3) THEN
            N1 = ZZNEMA(ILI,IEL,1)
            N2 = ZZNEMA(ILI,IEL,2)
            N3 = ZZNEMA(ILI,IEL,3)
            IF (((N1.GT.0).AND. (N2.LT.0)) .AND. (N3.LT.0)) THEN

C ---    TRANSFORMATION DE N2 , NUMERO DU PREMIER LAGRANGE DANS LA
C ---    NUMEROTATION LOCALE AU LIGREL EN SON NUMERO DANS LA
C ---    NUMEROTATION GLOBALE :
C        --------------------
              N21 = -N2
              N2 = -N2
              N2 = ZI(INUNO2+ILI-1) + N2 - 1
              ILAG2 = N2 - NBNOM
              N1RE = ZI(INEWN-1+N1)
              N1M1RE = N1RE - 1

C ---  JNULAG EST UN INDICATEUR PERMETTANT DE SAVOIR OU L'ON
C ---  DOIT PLACER LE PREMIER LAGRANGE :
C ---  SI = 0 C'EST LA NUMEROTATION TRADITIONNELLE, ON PLACE LE
C ---         LE PREMIER LAGRANGE AVANT LE PREMIER DDL PHYSIQUE
C ---         CONCERNE PAR LA RELATION OU LE BLOCAGE
C ---  SI = 1 ON PLACE LE LE PREMIER LAGRANGE APRES LE DERNIER DDL
C ---          PHYSIQUE CONCERNE PAR LA RELATION OU LE BLOCAGE :
C              -----------------------------------------------
              JNULAG = 0


C ---  RECUPERATION DE L'INDICATEUR DE POSITION DU PREMIER LAGRANGE :
C      ------------------------------------------------------------
                IF (INULAG.EQ.1) THEN

C ---    LE PREMIER LAGRANGE EST PLACE AVANT LE PREMIER DDL PHYSIQUE
C ---    CONCERNE PAR LE BLOCAGE OU LA RELATION :
C        --------------------------------------
                  IF (ZI(IDLGNS+N21-1).EQ.1) THEN
                    JNULAG = 0

C ---    LE PREMIER LAGRANGE EST PLACE APRES LE DERNIER DDL PHYSIQUE
C ---    CONCERNE PAR LE BLOCAGE OU LA RELATION :
C        --------------------------------------
                  ELSE IF (ZI(IDLGNS+N21-1).EQ.-1) THEN
                    JNULAG = 1
                  ELSE
                    CALL U2MESS('F','ASSEMBLA_27')
                  END IF
                END IF

C ---    CAS JNULAG = 0 : ON PLACE LE PREMIER LAGRANGE AVANT LE
C ---    PREMIER DDL PHYSIQUE :
C ---    ZI(ILSUIV+N1M1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER AVANT N1
C ---    ZI(IDSUIV(N1M1RE+1,ZI(ILSUIV+N1M1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) PRECEDANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1M1RE) (DANS LA LISTE DES LAGRANGE
C ---    PRECEDANT N1) :
C        -------------
              IF (JNULAG.EQ.0) THEN
                ZI(ILSUIV+N1M1RE) = ZI(ILSUIV+N1M1RE) + 1
                ZI(IDSUIV(N1M1RE+1,ZI(ILSUIV+N1M1RE))) = N2
              END IF

C ---    TRANSFORMATION DE N3 , NUMERO DU SECOND LAGRANGE DANS LA
C ---    NUMEROTATION LOCALE AU LIGREL EN SON NUMERO DANS LA
C ---    NUMEROTATION GLOBALE :
C        --------------------
              N3 = -N3
              N3 = ZI(INUNO2+ILI-1) + N3 - 1
              ILAG3 = N3 - NBNOM

C ---    RECUPERATION DU NOEUD PHYSIQUE DE NUMERO LE PLUS GRAND
C ---    LIE AU SECOND LAGRANGE PAR LE TABLEAU DERLI, CETTE
C ---    VALEUR N'EST DIFFERENTE DE 0 QUE S'IL S'AGIT D'UNE
C ---    RELATION LINEAIRE :
C        -----------------
              N0 = ZI(IDERLI+N3)

              ZI(IDDLAG+3* (ILAG2-1)+1) = -1
              ZI(IDDLAG+3* (ILAG3-1)+1) = -1
              ZI(IDDLAG+3* (ILAG2-1)+2) = 1
              ZI(IDDLAG+3* (ILAG3-1)+2) = 2

C ---    CAS DES RELATIONS LINEAIRES ENTRE DDLS
C        ======================================
C ---    TRAITEMENT DU PREMIER LAGRANGE
C        -----------------------------
C ---    DANS LE CAS JNULAG = 0 :
C ---    LE TRAITEMENT DU PREMIER LAGRANGE A DEJA ETE FAIT :
C ---    ON LE MET SYSTEMATIQUEMENT AVANT LE NOEUD PHYSIQUE
C ---    DE L'ELEMENT DE LAGRANGE COURANT
C ---    C'EST AU MOMENT DE LA RENUMEROTATION OU L'ON COMMENCE
C ---    PAR LES NOEUDS DE PLUS PETIT INDICE QUE L'ON DECIDERA,
C ---    SI UN NUMERO LUI A DEJA ETE ATTRIBUE , DE NE PLUS LE
C ---    NUMEROTER.

C ---    DANS LE CAS JNULAG = 1 :
C ---    ON TRAITE LE PREMIER  LAGRANGE COMME LE SECOND :
C ---    ON PLACE LE PREMIER LAGRANGE APRES LE NOEUD PHYSIQUE
C ---    DE L'ELEMENT DE LAGRANGE COURANT
C ---    SI LE NUMERO DU NOEUD PHYSIQUE DE L'ELEMENT DE LAGRANGE
C ---    EST PLUS PETIT QUE LE PLUS GRAND NUMERO DE NOEUD PHYSIQUE
C ---    LIE AU SECOND LAGRANGE (PAR LE TABLEAU DERLI)
C ---    ON DESACTIVE LE POSITIONNEMENT DU LAGRANGE APRES CE NUMERO
C ---    EN LUI AFFECTANT UNE VALEUR -1 DANS LE TABLEAU SUIV

C ---    TRAITEMENT DU SECOND LAGRANGE
C        -----------------------------
C ---    DANS LES CAS JNULAG = 0 ET JNULAG = 1, ON TRAITE
C ---    LE SECOND LAGRANGE COMME CE QUI EST ENONCE CI-DESSUS
C ---    POUR LE PREMIER LAGRANGE DANS LE CAS JNULAG = 1,
C ---    A CECI PRES QUE DANS CE DERNIER CAS, ON PLACE
C ---    LE SECOND LAGRANGE APRES LE PREMIER :
C        -----------------------------------
              IF (N0.GT.0) THEN
                ZI(IDDLAG+3* (ILAG2-1)) = 0
                ZI(IDDLAG+3* (ILAG3-1)) = 0
                ZI(IDDLAG+3* (ILAG2-1)+1) = 0
                ZI(IDDLAG+3* (ILAG3-1)+1) = 0
                N0RE = ZI(INEWN-1+N0)

C ---    TRAITEMENT D 'UN ELEMENT DE LAGRANGE DONT LE NUMERO DU
C ---    NOEUD PHYSIQUE EST PLUS GRAND QUE LE PLUS GRAND NUMERO
C ---    DE NOEUD PHYSIQUE LIE PAR LA MEME RELATION LINEAIRE
C ---    ET DEJA TRAITE :
C        --------------
                IF (N0RE.LT.N1RE) THEN
                  ICER1 = 0
                  ICER2 = 0
                  IF (JNULAG.EQ.1) THEN
                    DO 50 J = 1,SUIVDI(N0RE+1)
                      NS = SUIV(N0RE+1,J)
                      IF (NS.EQ.N2) THEN
                        IF (ICER1.NE.0) THEN
                        VALI (1) = N2
                        VALI (2) = N1
      CALL U2MESG('F', 'ASSEMBLA_63',0,' ',2,VALI,0,0.D0)
                        END IF
                        ICER1 = ICER1 + 1
                        ZI(IDSUIV(N0RE+1,J)) = -1
                      END IF
   50               CONTINUE
                  END IF
                  DO 60 J = 1,SUIVDI(N0RE+1)
                    NS = SUIV(N0RE+1,J)
                    IF (NS.EQ.N3) THEN
                      IF (ICER2.NE.0) THEN
                        VALI (1) = N3
                        VALI (2) = N1
      CALL U2MESG('F', 'ASSEMBLA_64',0,' ',2,VALI,0,0.D0)
                      END IF
                      ICER2 = ICER2 + 1
                      ZI(IDSUIV(N0RE+1,J)) = -1
                    END IF
   60             CONTINUE

C ---    CAS JNULAG = 1 : ON PLACE LE PREMIER LAGRANGE APRES LE
C ---    NOEUD PHYSIQUE COURANT:
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1) :
C        -----------
                  IF (JNULAG.EQ.1) THEN
                    ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = N2
                  END IF

C ---    ON PLACE LE SECOND LAGRANGE APRES LE NOEUD PHYSIQUE
C ---    COURANT:
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1) :
C        -----------
                  ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                  ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = N3
                  ZI(IDERLI+N3) = N1
                ELSE

C ---    TRAITEMENT D 'UN ELEMENT DE LAGRANGE DONT LE NUMERO DU
C ---    NOEUD PHYSIQUE EST PLUS PETIT QUE LE PLUS GRAND NUMERO
C ---    DE NOEUD PHYSIQUE LIE PAR LA MEME RELATION LINEAIRE
C ---    ET DEJA TRAITE :
C        --------------
                  IF (JNULAG.EQ.1) THEN

C ---    CAS JNULAG = 1 : ON PLACE LE PREMIER LAGRANGE APRES LE
C ---    NOEUD PHYSIQUE COURANT:
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1), ON DESACTIVE CE POSITIONNEMENT EN METTANT CE
C ---    NUMERO A -1 :
C        -----------
                    ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = -1
                  END IF

C ---    ON PLACE LE SECOND LAGRANGE APRES LE NOEUD PHYSIQUE
C ---    COURANT:
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1), ON DESACTIVE CE POSITIONNEMENT EN METTANT CE
C ---    NUMERO A -1 :
C        -----------
                  ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                  ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = -1
                END IF
              ELSE

C ---    CAS DES BLOCAGES
C        ================
C ---    TRAITEMENT DU PREMIER LAGRANGE
C        -----------------------------
C ---    DANS LE CAS JNULAG = 0 :
C ---    LE TRAITEMENT DU PREMIER LAGRANGE A DEJA ETE FAIT :
C ---    ON LE MET SYSTEMATIQUEMENT AVANT LE NOEUD PHYSIQUE
C ---    DE L'ELEMENT DE LAGRANGE COURANT

C ---    DANS LE CAS JNULAG = 1 :
C ---    ON TRAITE LE PREMIER  LAGRANGE COMME LE SECOND :
C ---    ON PLACE LE PREMIER LAGRANGE APRES LE NOEUD PHYSIQUE
C ---    BLOQUE

C ---    TRAITEMENT DU SECOND LAGRANGE
C        -----------------------------
C ---    DANS LES CAS JNULAG = 0 ET JNULAG = 1, ON TRAITE
C ---    LE SECOND LAGRANGE COMME CE QUI EST ENONCE CI-DESSUS
C ---    POUR LE PREMIER LAGRANGE DANS LE CAS JNULAG = 1,
C ---    A CECI PRES QUE DANS CE DERNIER CAS, ON PLACE
C ---    LE SECOND LAGRANGE APRES LE PREMIER :
C        -----------------------------------
                ZI(IDDLAG+3* (ILAG2-1)) = N1
                ZI(IDDLAG+3* (ILAG3-1)) = N1

C ---    CAS JNULAG = 1 : ON PLACE LE PREMIER LAGRANGE APRES LE
C ---    NOEUD PHYSIQUE :
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1) :
C        -----------
                IF (JNULAG.EQ.1) THEN
                  ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                  ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = N2
                END IF

C ---    ON PLACE LE SECOND LAGRANGE APRES LE NOEUD PHYSIQUE :
C ---    ZI(ILSUIV+N1RE) EST LE COMPTEUR DU NOMBRE DE LAGRANGE
C ---    A PLACER APRES N1
C ---    ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE)))  EST LE NUMERO
C ---    DU LAGRANGE (DANS LA NUMEROTATION GLOBALE) SUIVANT N1 ET
C ---    D'INDICE ZI(ILSUIV+N1RE) (DANS LA LISTE DES LAGRANGE
C ---    SUIVANT N1) :
C        -----------
                ZI(ILSUIV+N1RE) = ZI(ILSUIV+N1RE) + 1
                ZI(IDSUIV(N1RE+1,ZI(ILSUIV+N1RE))) = N3
                ZI(IDERLI+N3) = N1
              END IF
            END IF
          END IF
   70   CONTINUE
   80 CONTINUE


C --- RENUMEROTATION :
C     ==============

C ---  ALLOCATION DE NUM21 ET NUM2
C ---  NUM2(I) = NUMERO DANS LA NOUVELLE NUMEROTATION NUNO DU NOEUD I
C ---  DANS LA NUMEROTATION GLOBALE DE 1ER NIVEAU
C ---  SI NUM2(I)=J ALORS NUM21(J)=I :
C      -----------------------------
      CALL WKVECT(NUM21,' V V I',N+1,INUM21)
      CALL WKVECT(NUM2,' V V I',N+1,INUM2)

C ---  CALCUL DE NUM2 ET NUM21 QUI REPRESENTE "L'INVERSE" DE NUM2
C ---  NBNONU : NOMBRE DE NOEUDS NUMEROTES DANS NUNO :
C      ---------------------------------------------
      NBNONU = 0

C ---  BOUCLE SUR LES LAGRANGE PRECEDANT LE PREMIER NOEUD PHYSIQUE :
C      -----------------------------------------------------------
      DO 90 J = 1,SUIVDI(1)
        J1 = SUIV(1,J)

C ---  SI LE LAGRANGE N'A PAS ETE RENUMEROTE, ON LE RENUMEROTE :
C      -------------------------------------------------------
        IF (ZI(INUM2+J1).EQ.0) THEN
          NBNONU = NBNONU + 1
          ZI(INUM2+J1) = NBNONU
          ZI(INUM21+NBNONU) = J1
        END IF
   90 CONTINUE

C ---  NBNORE EST LE NOMBRE DE NOEUDS DU MAILLAGE PARTICIPANTS A LA
C ---  NUMEROTATION:
C      ------------
      CALL JELIRA(OLDN,'LONUTI',NBNORE,CBID)

C ---  BOUCLE SUR LES NOEUDS PHYSIQUES :
C      -------------------------------
      DO 110 IRE = 1,NBNORE
        I = ZI(IOLDN-1+IRE)

C ---  SI LE NOEUD PHYSIQUE N'A PAS ETE RENUMEROTE, ON LE RENUMEROTE :
C      -------------------------------------------------------------
        IF (ZI(INUM2+I).EQ.0) THEN
          NBNONU = NBNONU + 1
          ZI(INUM2+I) = NBNONU
          ZI(INUM21+NBNONU) = I

C ---  BOUCLE SUR LES LAGRANGE SUIVANT LE NOEUD PHYSIQUE COURANT :
C      ---------------------------------------------------------
          DO 100 J = 1,SUIVDI(IRE+1)
            J1 = SUIV(IRE+1,J)

C ---  ON NE PREND EN COMPTE QUE LES LAGRANGE AYANT UN INDICE 'ACTIF':
C      -------------------------------------------------------------
            IF (J1.GT.0) THEN

C ---    SI LE LAGRANGE N'A PAS ETE RENUMEROTE, ON LE RENUMEROTE :
C        -------------------------------------------------------
              IF (ZI(INUM2+J1).EQ.0) THEN
                NBNONU = NBNONU + 1
                ZI(INUM2+J1) = NBNONU
                ZI(INUM21+NBNONU) = J1
              END IF
            END IF
  100     CONTINUE
        END IF
  110 CONTINUE

      IF (NBNONU.NE. (NBNORE+NLAG)) CALL U2MESS('F','ASSEMBLA_28')



C --- CALCUL DES DESCRIPTEURS DES PRNO
C     ================================


C --- DETERMINATION DES .PRNM ET DES .PRNS POUR CHAQUE LIGREL :
C     -------------------------------------------------------
      DO 120 ILI = 2,NLILI
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL CREPRN(NOMLI,MOLOC,'V',NOMLI(1:19)//'.QRNM',
     &              NOMLI(1:19)//'.QRNS')
  120 CONTINUE


C --- 1ERE ETAPE : NOEUDS DU MAILLAGE (PHYSIQUES ET LAGRANGES)
C --- SI NUNOEL NOEUD DU MAILLAGE
C --- PRNO(1,NUNOEL,L+2)= "SIGMA"(.QRNM(MA(NUNOEL))(L))
C     -------------------------------------------------
      DO 150 ILI = 2,NLILI
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEEXIN(NOMLI(1:19)//'.QRNM',IRET)
        IF (IRET.EQ.0) GO TO 150
        CALL JEVEUO(NOMLI(1:19)//'.QRNM','L',IPRNM)

        DO 140 I = 1,NBNORE
          NUNOEL = ZI(IOLDN-1+I)
          DO 130 L = 1,NEC
            IEC = ZI(IPRNM-1+NEC* (NUNOEL-1)+L)
            ZI(IZZPRN(1,NUNOEL,L+2)) = IOR(ZZPRNO(1,NUNOEL,L+2),IEC)
  130     CONTINUE
  140   CONTINUE
  150 CONTINUE


C --- 2EME ETAPE : NOEUDS SUPPLEMENTAIRES DES LIGRELS:
C --- SI NUNOEL NOEUD TARDIF DU LIGREL ILI NOMLI = LILI(ILI)
C --- PRNO(ILI,NUNOEL,L+2)= NOMLI.QRNS(NUNOEL)(L) :
C     -------------------------------------------
      DO 210 ILI = 2,NLILI
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEVEUO(NOMLI(1:19)//'.QRNM','L',IPRNM)
        CALL JEVEUO(NOMLI(1:19)//'.NBNO','L',IBID)
        IF (ZI(IBID).GT.0) CALL JEVEUO(NOMLI(1:19)//'.QRNS','L',IPRNS)

        DO 200 IGR = 1,ZZNGEL(ILI)
          NEL = ZZNELG(ILI,IGR)

          IF (NEL.GE.0) THEN
            ITYPEL = ZZLIEL(ILI,IGR,NEL+1)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
            ICDDLB = 0
            NDDLB = 0
          END IF

          DO 190 J = 1,NEL
            NUMA = ZZLIEL(ILI,IGR,J)
            IF (NUMA.LT.0) THEN
              NUMA = -NUMA
              DO 180 K = 1,ZZNSUP(ILI,NUMA)
                NUNOEL = ZZNEMA(ILI,NUMA,K)

                IF (NUNOEL.GT.0) THEN
                  DO 160 L = 1,NEC
                    IEC = ZI(IPRNM+NEC* (NUNOEL-1)+L-1)
                    ZI(IZZPRN(ILIM,NUNOEL,L+2)) = IOR(ZZPRNO(ILIM,
     &                NUNOEL,L+2),IEC)
  160             CONTINUE

                ELSE
                  NUNOEL = -NUNOEL

C                 -- CALCUL DU NUMERO DE LA CMP ASSO
                  IF (ICDDLB.EQ.0) THEN
                    CALL ASSERT(NOMGDS.EQ.NOMTE(3:8))
                    NOMCMP = NOMTE(10:16)

C                   "GLUTE" POUR TEMP_INF ET TEMP_SUP :
                    IF (NOMCMP.EQ.'TEMP_IN') THEN
                      NOMCMP = 'TEMP_INF'
                    ELSE IF (NOMCMP.EQ.'TEMP_SU') THEN
                      NOMCMP = 'TEMP_SUP'
                    END IF

                    CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMGDS),'L',
     &                          IDNOCM)
                    CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMGDS),
     &                          'LONMAX',NBCMP,KBID)
                    NDDLB = INDIK8(ZK8(IDNOCM),NOMCMP,1,NBCMP)
                    CALL ASSERT(NDDLB.NE.0)
                    ICDDLB = 1
                  END IF

                  DO 170 L = 1,NEC
                    IEC = ZI(IPRNS+NEC* (NUNOEL-1)+L-1)
                    ZI(IZZPRN(ILI,NUNOEL,L+2)) = IOR(ZZPRNO(ILI,NUNOEL,
     &                L+2),IEC)
  170             CONTINUE

                  ILAG = ZI(INUNO2+ILI-1) + NUNOEL - 1
                  ILAG = ILAG - NBNOM
                  ZI(IDDLAG+3* (ILAG-1)+1) = ZI(IDDLAG+3* (ILAG-1)+1)*
     &              NDDLB

                END IF
  180         CONTINUE

            END IF

  190     CONTINUE
  200   CONTINUE
  210 CONTINUE


C --- CALCUL DES ADRESSES DANS LES PRNO
C     =================================
      IAD = 1

      DO 220 I = 1,N
        CALL NUNO1(I,ILI,NUNOEL,N,INUM21,INUNO2,NLILI)
        IF (ILI.GT.0) THEN
          NDDL1 = ZZPRNO(ILI,NUNOEL,2)
          IF (NDDL1.EQ.0) THEN
            NDDL1 = NDDL(ILI,NUNOEL,NEC,IDPRN1,IDPRN2)

            ZI(IZZPRN(ILI,NUNOEL,2)) = NDDL1
          END IF
          ZI(IZZPRN(ILI,NUNOEL,1)) = IAD
          IAD = IAD + NDDL1
        END IF
  220 CONTINUE

      NEQUA = IAD - 1
      CALL WKVECT(NU//'.NUME.NEQU',BASE(1:1)//' V I',2,IDNEQU)
      ZI(IDNEQU) = NEQUA

      IF (NIV.GE.1) THEN

C ---   CALCUL DE NMA : NOMBRE DE NOEUDS DU MAILLAGE PORTEURS DE DDLS :
C       ----------------------------------------------------------------
        NMA = 0
        CALL JEVEUO(JEXNUM(NU//'.NUME.PRNO',1),'L',JPRNO)
        DO 230,INO = 1,NBNOM
          IF (ZI(JPRNO-1+ (INO-1)* (2+NEC)+2).GT.0) NMA = NMA + 1
  230   CONTINUE
        VALI(1) = NMA + NLAG
        VALI(2) = NMA
        VALI(3) = NLAG
        VALI(4) = NEQUA

        CALL U2MESI('I','FACTOR_1',4,VALI)
C        WRITE (IFM,*) '--- NOMBRE TOTAL DE NOEUDS : ',NMA + NLAG,
C     &    ' DONT : ',NLAG,' NOEUDS "LAGRANGE"'
C        WRITE (IFM,*) '--- NOMBRE TOTAL D''EQUATIONS : ',NEQUA
      END IF


C AUGMENTATION DE LA TAILLE DU .REFN (DE 2 A 4) POUR FETI
      CALL WKVECT(NU//'.NUME.REFN',BASE(1:1)//' V K24',4,IDREF)
      ZK24(IDREF) = MAILLA
      ZK24(IDREF+1) = NOMGDS
      CALL JEEXIN(SOLVEU(1:19)//'.SLVK',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(SOLVEU(1:19)//'.SLVK','L',ISLVK)
        ZK24(IDREF+2) = ZK24(ISLVK)
        ZK24(IDREF+3) = ZK24(ISLVK+5)
      END IF


C --- ON COMPLETE LE CONCEPT PROF_CHNO :
C        OBJET '.DEEQ' :
C        OBJET '.NUEQ' :
C     ---------------------------------------------------
      CALL WKVECT(NU//'.NUME.NUEQ',BASE(2:2)//' V I',NEQUA,IANUEQ)
      DO 310,I = 1,NEQUA
        ZI(IANUEQ-1+I) = I
  310 CONTINUE

      CALL NUDEEQ(BASE,NU,NEQUA,IGDS,IDDLAG)


C --- DESTRUCTION DES .PRNM ET DES .PRNS DE CHAQUE LIGREL :
C     ---------------------------------------------------
      DO 320 ILI = 1,NLILI
        CALL JENUNO(JEXNUM(LILI,ILI),NOMLI)
        CALL JEDETR(NOMLI(1:19)//'.QRNM')
        CALL JEDETR(NOMLI(1:19)//'.QRNS')
  320 CONTINUE

      CALL JEDETR(LSUIV)
      CALL JEDETR(PSUIV)
      CALL JEDETR(EXI1)
      CALL JEDETR(NUM2)
      CALL JEDETR(NUM21)
      CALL JEDETR(NUNO)
      CALL JEDETR(NNLI)
      CALL JEDETR(DERLI)
      CALL JEDETR(VSUIV)
      CALL JEDETR(DSCLAG)
      IF (LFETI) CALL INFBAV()

      END
