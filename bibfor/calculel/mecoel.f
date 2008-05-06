      SUBROUTINE MECOEL()
      IMPLICIT NONE
C TOLE CRS_230
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 06/05/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE                            VABHHTS J.PELLET

C    ROUTINE BIDON POUR CONSERVER DANS LE SOURCE
C    LA DOC DES COMMON DE LA ROUTINE CALCUL

C======================================================================
      CHARACTER*16 OPTION,NOMTE,NOMTM,PHENO,MODELI
      COMMON /CAKK01/OPTION,NOMTE,NOMTM,PHENO,MODELI
C     CE COMMON EST ECRIT  PAR CALCUL :
C         OPTION : OPTION CALCULEE
C         NOMTE  : TYPE_ELEMENT COURANT
C         NOMTM  : TYPE_MAILLE ASSOCIE AU TYPE_ELEMENT
C         PHENO  : PHENOMENE ASSOCIE AU TYPE_ELEMENT
C         MODELI : MODELISATION ASSOCIEE AU TYPE_ELEMENT

C======================================================================
      INTEGER IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,ILCHLO
      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &       ILCHLO

C======================================================================
      CHARACTER*8 TYPEGD
      COMMON /CAKK02/TYPEGD
C     CES COMMONS SONT MIS A JOUR PAR EXTRAI.
C     IGD : NUMERO DE LA GRANDEUR ASSOCIEE AU CHAMP A EXTRAIRE
C     NEC : NOMBRE D'ENTIERS CODES DE IGD
C     NCMPMX: NOMBRE MAX DE CMPS POUR IGD
C     IACHIN: ADRESSE JEVEUX DE CHIN.VALE
C     IACHLO: ADRESSE JEVEUX DE CHLOC//".VALE"  (&&CALCUL.NOMPAR)
C     ILCHLO: ADRESSE JEVEUX DE CHLOC//".EXIS"  (&&CALCUL.NOMPAR)
C     IICHIN: NUMERO DU CHAMP CHIN DANS LA LISTE LCHIN.
C     IANUEQ: ADRESSE DE L'OBJET .NUEQ DU PROF_CHNO ASSOCIE EVENTUELLE
C            -MENT AU CHAMP CHIN. (SI LPRNO=1).
C     LPRNO : 1-> L'OBJET .NUEQ EST A PRENDRE EN COMPTE
C                 (CHAM_NO A PROF_CHNO)
C             0-> L'OBJET .NUEQ N'EST PAS A PRENDRE EN COMPTE
C                 (CHAM_NO A REPRESENTATION CONSTANTE OU AUTRE CHAMP)
C     TYPEGD: TYPE SCALAIRE DE LA GRANDEUR IGD : 'R', 'I', 'K8', ...

C======================================================================
      INTEGER        IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
C     CE COMMON EST INITIALISE PAR DEBCA1
C     CE COMMON EST UTILISE UN PEU PARTOUT
C     IAOPTT : ADRESSE DE L'OBJET DU CATALOGUE : '&CATA.TE.OPTTE'
C     LGCO   : LONGUEUR D'UNE COLONNE DE '&CATA.TE.OPTTE'
C              ( NOMBRE TOTAL D'OPTIONS POSSIBLES DU CATALOGUE)
C     IAOPMO : ADRESSE DE '&CATA.TE.OPTMOD'
C     ILOPMO : ADRESSE DU PT_LONG DE '&CATA.TE.OPTMOD'
C     IAOPNO : ADRESSE DE '&CATA.TE.OPTNOM'
C     ILOPNO : ADRESSE DU PT_LONG DE '&CATA.TE.OPTNOM'
C     IAOPDS : ADRESSE DE '&CATA.OP.DESCOPT(OPT)'
C     IAOPPA : ADRESSE DE '&CATA.OP.OPTPARA(OPT)'
C     NPARIO : LONGUEUR DE '&CATA.OP.OPTPARA(OPT)'
C              = NB_PARAM "IN" + NB_PARAM "OUT"
C     NPARIN : NOMBRE DE PARAMETRES "IN" POUR L'OPTION OPT.
C     CE NOMBRE PERMET DE SAVOIR SI UN PARAMETRE EST "IN" OU "OUT"
C              (IPAR <= NPARIN) <=> (IPAR EST "IN")
C     IAMLOC : ADRESSE DE '&CATA.TE.MODELOC'
C     ILMLOC : ADRESSE DU PT_LONG DE '&CATA.TE.MODELOC'
C     IADSGD : ADRESSE DE '&CATA.GD.DESCRIGD'

C======================================================================
      INTEGER        IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
      COMMON /CAII03/IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
C     CE COMMON EST MIS A JOUR PAR DEBCAL (OU TERLIG)
C     CE COMMON EST UTILISE DANS NUMAIL,EXCHNO,...
C     IAMACO  : ADRESSE DE LA CONNECTIVITE DU MAILLAGE
C     ILMACO  : ADRESSE DU POINTEUR DE LONGUEUR DE IAMACO
C     IAMSCO  : ADRESSE DE LA CONNECTIVITE DES MAILLES SUPPL. D'1 LIGREL
C     ILMSCO  : ADRESSE DU POINTEUR DE LONGUEUR DE IAMSCO
C     IALIEL  : ADRESSE DE L'OBJET '.LIEL' DU LIGREL.
C     ILLIEL  : ADRESSE DU POINTEUR DE LONGUEUR DE '.LIEL'.

C======================================================================
      INTEGER        IACHII,IACHIK,IACHIX
      COMMON /CAII04/IACHII,IACHIK,IACHIX
C     CE COMMON EST MIS A JOUR PAR DEBCAL
C     CE COMMON EST UTILISE DANS EXTRAI,EXCHNO,EXCART,EXRESL,EXCHML
C                               ,DCHLMX
C     IACHII : ADRESSE DE '&&CALCUL.LCHIN_I'
C     IACHIK : ADRESSE DE '&&CALCUL.LCHIN_K8'
C     IACHIX : ADRESSE DE '&&CALCUL.LCHIN_EXI'

C     '&&CALCUL.LCHIN_EXI' ::= V(L)    (DIM = NIN)
C             V(1) :  .FALSE.    : LE CHAMP PARAMETRE N'EXISTE PAS.

C     '&&CALCUL.LCHIN_K8'  ::= V(K8)    (DIM = NIN*2)
C             V(1) :  TYPE_CHAMP : 'CHNO','CART','CHML' OU 'RESL'.
C             V(2) :  TYPE_GD    : 'C', 'R', 'I', 'K8', ...

C     '&&CALCUL.LCHIN_I'  ::= V(I)     (DIM = NIN*11)
C             V(1) :  IGD   GRANDEUR ASSOCIEE A LCHIN(I)
C             V(2) :  NEC   NOMBRE D'ENTIERS CODES
C             V(3) :  NCMPMX NOMBRE MAX DE CMP POUR IGD
C             V(4) :  IADESC ADRESSE DE .DESC  (OU .CELD)
C             V(5) :  IAVALE ADRESSE DE .VALE
C             V(6) :  IAPTMA ADRESSE DE .PTMA (POUR 1 CARTE)
C             V(7) :  IAPTMS ADRESSE DE .PTMS (POUR 1 CARTE)
C             V(8) :  IAPRN1 ADRESSE DU PRNO($MAILLA) (POUR 1 CHAM_NO)
C             V(9) :  IAPRN2 ADRESSE DU PRNO(LIGREL)  (POUR 1 CHAM_NO)
C             V(10):  IANUEQ ADRESSE    .NUEQ         (POUR 1 CHAM_NO)
C             V(11):  LPRNO  (DIT SI IANUEQ EST UTILISE POUR 1 CHAM_NO)

C======================================================================
      INTEGER        IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
      COMMON /CAII05/IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
C     CE COMMON EST MIS A JOUR PAR DEBCAL
C     CE COMMON EST UTILISE DANS TE0000 POUR
C     IANOOP : ADRESSE DANS ZK16 DE '&&CALCUL.NOMOP' V(K16)
C          V(IOP) --> NOM DE L'OPTION IOP
C     IANOTE : ADRESSE DANS ZK16 DE '&&CALCUL.NOMTE' V(K16)
C          V(ITE) --> NOM DU TYPE_ELEMENT ITE
C     CE COMMON EST UTILISE DANS ALCHLO,ALRSLT ET CALCUL POUR :
C          NBOBTR : NOMBRE D'OBJETS DE TRAVAIL '&&CALCUL....' QUI
C                   DEVRONT ETRE DETRUITS A LA FIN DE CALCUL.
C          IAOBTR : ADRESSE DANS ZK24 DE L'OBJET '&&CALCUL.OBJETS_TRAV'
C          NBOBMX : LONGUEUR DE L'OBJET '&&CALCUL.OBJETS_TRAV'

C======================================================================
      INTEGER        IEL
      COMMON /CAII08/IEL
C     IEL    : NUMERO DE L'ELEMENT (DANS LE GREL IGR)
C         (IEL EST MIS A JOUR PAR EXTRAI,TE0000,MONTEE,...)

C======================================================================
      INTEGER        IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT
      COMMON /CAII06/IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT

C     CE COMMON EST INITIALISE PAR ALCHLO
C     CE COMMON EST MODIFIE  PAR MECOE1 (OBJET .IA_CHLOC)
C     CE COMMON EST MODIFIE  PAR EXTRAI,MONTEE,CALCUL,ZECHLO
C                                (OBJET .MODELO)
C     CE COMMON EST MODIFIE  UN PEU PARTOUT POUR NBELGR,IGR
C     CE COMMON EST UTILISE DANS EXTRAI,MONTEE,CALCUL,
C                                JEVECH,ZECHLO,TECACH

C     IGR    : NUMERO DU GREL QUE L'ON TRAITE
C     NBELGR : NOMBRE D'ELEMENTS DANS LE GREL IGR
C         (IGR ET NBELGR SONT MIS A JOUR PAR CALCUL)

C     JCTEAT : ADRESSE DANS ZK16 DE L'OBJET &CATA.TE.CTE_ATTR(NOMTE)
C     LCTEAT : LONGUEUR DE L'OBJET &CATA.TE.CTE_ATTR(NOMTE)
C         (JCTEAT ET LCTEAT SONT MIS A JOUR PAR CALCUL)
C     REM: SI NOMTE N'A PAS D'ATTRIBUT : JCTEAT=LCTEAT=0

C     IAWLOC : ADRESSE DANS ZI DE '&&CALCUL.IA_CHLOC' V(I)
C           CET OBJET CONTIENT DES INFORMATIONS SUR LES CHAMP_LOCAUX
C   V(7*(IPAR-1)+1) --> IACHLO
C            ADRESSE DU CHAMP_LOCAL '&&CALCUL.//NOMPAR(IPAR)
C            =-1 <=> / LE CHAMP "IN" N'EXISTE PAS :
C                      /  NOMPAR N'APPARTIENT PAS A LPAIN
C                      /  CHIN//'.DESC' (OU .CELD) N'EXISTE PAS
C                    /  NOMPAR N'APPARTIENT PAS A LPAOUT
C            =-2 <=> AUCUN TYPE_ELEM DU LIGREL NE DECLARE
C                    NOMPAR DANS SON CATALOGUE

C   V(7*(IPAR-1)+2) --> ILCHLO :
C          ADRESSE D'UN VECTEUR DE BOOLEENS (//CHAMP LOCAL)
C          DE NOM : '&&CALCUL.//NOMPAR(IPAR)//'.EXIS'
C          SI ILCHLO = -1 :
C              =>  LE CHAMP LOCAL EST "OUT"
C                  ET/OU LE CHAMP GLOBAL N'EXISTE PAS
C                  ET/OU LE PARAMETRE N'EST PAS UTILISE
C   V(7*(IPAR-1)+3) --> MODE LOCAL (ATTENDU) POUR LE PARAMETRE (IPAR)
C   V(7*(IPAR-1)+4) --> LONGUEUR DU CHAMP_LOCAL POUR 1 ELEMENT
C                       (LUE DANS LE CATALOGUE). CETTE LONGUEUR NE
C                       TIENT PAS COMPTE DE NBSPT ET NCDYN.
C             =-1 <=> LE PARAMETRE N'EXISTE PAS DANS LE CATALOGUE
C                     DU TYPE_ELEMENT
C   V(7*(IPAR-1)+5) --> INUTILISE
C   V(7*(IPAR-1)+6) --> NOMBRE DE POINTS DE DISCRETIS. DU CHAMP_LOCAL
C                      (0 SI VECTEUR OU MATRICE)
C   V(7*(IPAR-1)+7) --> ICH : NUMERO DU CHAMP ASSOCIE AU PARAMETRE.
C                 I.E : INDICE DANS LCHIN (OU LCHOUT SELON LE CAS)
C                 ICH = 0 S'IL N'Y A PAS DE CHAMP ASSOCIE A IPAR

C     IAWTYP : ADRESSE DANS ZK8 DE '&&CALCUL.TYPE_SCA' V(K8)
C          V(IPAR) --> TYPE_SCALAIRE DU CHAMP_LOCAL

C======================================================================
      INTEGER        IACHOI,IACHOK
      COMMON /CAII07/IACHOI,IACHOK
C     CE COMMON EST MIS A JOUR PAR ALRSLT
C     CE COMMON EST UTILISE DANS MONTEE ,DCHLMX
C     IACHOI : ADRESSE DE '&&CALCUL.LCHOU_I'
C     IACHOK : ADRESSE DE '&&CALCUL.LCHOU_K8'

C     '&&CALCUL.LCHOU_K8'  ::= V(K8)    (DIM = NIN*2)
C             V(1) :  TYPE_CHAMP : 'CHML' OU 'RESL'.
C             V(2) :  TYPE_GD    : 'C', 'R'

C     '&&CALCUL.LCHOU_I'  ::= V(I)     (DIM = NOUT*3)
C         -- SI CHML :
C             V(1) :  ADRESSE DE L_CHOUT(I).CELD
C             V(2) :  ADRESSE DE L_CHOUT(I).CELV
C         -- SI RESL :
C             V(1) :  ADRESSE DE L_CHOUT(I).DESC
C             V(2) :  ADRESSE DE L_CHOUT(I).RSVI
C             V(3) :  ADRESSE DE LONCUM DE L_CHOUT(I).RSVI

C======================================================================
      INTEGER        NBOBJ,IAINEL,ININEL
      COMMON /CAII09/NBOBJ,IAINEL,ININEL
C     NBOBJ  : NOMBRE D'OBJETS '&INEL.XXXX' CREE PAR L'INITIALISATION
C              DU TYPE_ELEM
C     ININEL : ADRESSE DANS ZK24 DE L'OBJET '&&CALCUL.NOM_&INEL'
C              QUI CONTIENT LES NOMS DES OBJETS '&INEL.XXXX'
C     IAINEL : ADRESSE DANS ZI DE L'OBJET '&&CALCUL.IAD_&INEL'
C              QUI CONTIENT LES ADRESSES DES OBJETS '&INEL.XXXX'
C     CE COMMON EST INITIALISE PAR DEBCAL
C     CE COMMON EST UTILISE PAR CALCUL ET JEVETE

C======================================================================
      INTEGER        ICAELI,ICAELK
      COMMON /CAII10/ICAELI,ICAELK
C     CE COMMON EST CREE PAR DEBCAL.
C     IL EST UTILISE PAR TECAEL
C     ICAELK EST L'ADRESSE D'UN VECTEUR DE K24 CONTENANT :
C       V(1) : NOM DU MAILLAGE  (K8)
C       V(2) : NOM DU LIGREL    (K19)
C       V(3) : NOM DE LA MAILLE    (K8)
C       V(3+  1) : NOM DU 1ER NOEUD DE LA MAILLE  (K8)
C       V(3+  I) : ...
C       V(3+NBNO) : NOM DU DER NOEUD DE LA MAILLE  (K8)
C       V(3+NBNO+1) : NOM DU TYPE_ELEMENT (K16)
C       V(3+NBNO+2) : NOM DE L'OPTION     (K16)
C     ICAELI EST L'ADRESSE D'UN VECTEUR DE IS CONTENANT :
C       V(1) : NUMERO DE LA MAILLE
C       V(2) : NOMBRE DE NOEUDS DE LA MAILLE (NBNO)
C       V(2+   1) : NUMERO DU 1ER NOEUD DE LA MAILLE
C       V(2+NBNO) : NUMERO DU DER NOEUD DE LA MAILLE
C       V(2+NBNO +1) : NUMERO DU GREL
C       V(2+NBNO +2) : NUMERO DE L'ELEMENT DANS LE GREL

C======================================================================
      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
C     CE COMMON EST INITIALISE PAR DEBCA1 (JNBELR,JNOELR,JPNLFP,JNOLFP)
C                              ET CALCUL (NUTE,IACTIF).
C     NUTE : NUMERO DU TYPE_ELEM NOMTE.
C     JNBELR : ADRESSE DANS ZI  DE '&CATA.TE.NBELREFE'
C     JNOELR : ADRESSE DANS ZK8 DE '&CATA.TE.NOELREFE'
C     IACTIF :  1 : LA ROUTINE CALCUL EST ACTIVE
C               0 : LA ROUTINE CALCUL EST INACTIVE.
C         CE "BOOLEEN" PERMET D'ARRETER LES UTILISATIONS DES
C         ROUTINES QUI DOIVENT ETRE APPELLEES "SOUS" LES TE00IJ:
C         JEVECH,TECACH,TECAEL,ELREF1,...
C     JPNLFP : ADRESSE DANS ZK32 DE '&CATA.TE.PNLOCFPG'
C     JNOLFP : ADRESSE DANS ZI DE '&CATA.TE.NOLOCFPG'
C     NBLFPG : DIMENSION DES OBJETS PNLOCFPG ET NOLOCFPG
C======================================================================
      INTEGER CAINDZ(512),CAPOIZ
      COMMON /CAII12/CAINDZ,CAPOIZ
C     CE COMMON EST UTILISE POUR GAGNER DU TEMPS DANS JEVECH ET TECACH
C======================================================================
      INTEGER NBSAV
      COMMON /CAII13/NBSAV
C     CE COMMON EST INITIALISE PAR DEBCAL
C     CE COMMON EST UTILISE POUR GAGNER DU TEMPS DANS ELREF4
C======================================================================
      INTEGER NBCVRC,JVCNOM
      COMMON /CAII14/NBCVRC,JVCNOM
C     CE COMMON EST UTILISE POUR LES VARIABLES DE COMMANDE :
C       ROUTINES : RCMFMC,RCVARC,RCVALB
C     NBCVRC : NOMBRE DE CVRC (VARIABLE DE COMMANDE SCALAIRE)
C     JVCNOM : ADRESSE DANS ZK8 DES NOMS DES CVRC
C======================================================================
      INTEGER NFPGMX
      PARAMETER (NFPGMX=10)
      INTEGER NFPG,JFPGL,DECALA(NFPGMX),KM,KP,KR,IREDEC
      COMMON /CAII17/NFPG,JFPGL,DECALA,KM,KP,KR,IREDEC
C     CE COMMON DECRIT LES FAMILLES DE PG DE LA FAMILLE "MATER"
C       ROUTINES : VRCDEC, RCVARC, REDECE
C     NFPG   : NOMBRE DE FAMILLES DE LA FAMILLE LISTE "MATER"
C     JFPGL  : ADRESSE DANS ZK8 DE LA LISTE DES NOMS DES FAMILLES
C     DECALA : TABLEAU DES DECALAGE DES NUMEROS DES PG :
C         DECALA(1) : 0
C         DECALA(K) : NOMBRE CUMULE DES PG DES FAMILLES (1:K-1)
C     KM,KP,KR : SAUVEGARDE DES NUMEROS D'ELEMENTS UTILISES DANS
C                RCVARC. ILS EVITENT DES APPELS COUTEUX A TECACH.
C     IREDEC : 0 : ON N'EST PAS "SOUS" REDECE.F
C              1 : ON EST  "SOUS" REDECE.F  (VOIR CARR01 CI-DESSOUS)
C======================================================================
      REAL*8 TIMED1,TIMEF1,TD1,TF1
      COMMON /CARR01/TIMED1,TIMEF1,TD1,TF1
C     CE COMMON SERT POUR LE REDECOUPAGE EVENTUEL DU PAS DE TEMPS
C     PAR REDECE.F
C     IL EST UTILISE PAR LES ROUTINES :  REDECE ET RCVARC
C     TIMED1  : VALEUR DE L'INSTANT "-" DU "GROS" PAS DE TEMPS
C     TIMEF1  : VALEUR DE L'INSTANT "+" DU "GROS" PAS DE TEMPS
C     TD      : VALEUR DE L'INSTANT "-" DU "PETIT" PAS DE TEMPS
C     TF      : VALEUR DE L'INSTANT "+" DU "PETIT" PAS DE TEMPS
C======================================================================
      INTEGER CADIST
      COMMON /CAII18/CADIST
C     CE COMMON SERT POUR CALCUL PARALLELE MPI
C     IL EST (POUR L'INSTANT) REMPLI PAR CRESOL ET REINITIALISE ENTRE
C     LES COMMANDES (EXECOP).
C     REMARQUE : LA SITUATION N'EST PAS BONNE CAR SI UNE COMMANDE
C     AVAIT 2 MOTS CLES SOLVEUR 1 DISTRIBUE ET L'AUTRE NON !!
C
C     CADIST  = -1 : ON SE SAIT PAS ENCORE SI LES CALCULS ELEMENTAIRES
C                SERONT DISTRIBUES SUR LES DIFFERENTS PROCESSEURS
C                C'EST EN PARTICULIER LE CAS AVANT L'APPEL A CRESOL
C     CADIST  = 0 : LE CALCUL N'EST PAS DISTRIBUE :
C                => TOUS LES ELEMENTS SONT CALCULES SUR TOUS LES PROCS
C                C'EST EN PARTICULIER LE CAS EN SEQUENTIEL (1 PROC)
C     CADIST  = 1 : LE CALCUL EST DISTRIBUE :
C                => CHAQUE PROCESSEUR NE CALCULE QU'UN SOUS-ENSEMBLE
C                   DES ELEMENTS => IL FAUT PARFOIS COMMUNIQUER ...
C======================================================================
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
C     CE COMMON EST INITIALISE PAR DEBCA1
C
C     EVFINI  = 1 : LE LIGREL CONTIENT DES "VOLUMES FINIS"
C     EVFINI  = 0 : SINON
C     CALVOI  = 1 : DANS UNE ROUTINE TE00IJ, ON VEUT POUVOIR ACCEDER
C                   AUX CHAMPS "IN" DES ELEMENTS VOISINS (TECAC2.F)
C     CALVOI  = 0 : SINON
C
C     LES 3 ADRESSES SUIVANTES SONT REMPLIES SI CALVOI=1 OU EVFINI=1 :
C      * JREPE   : ADRESSE JEVEUX DE LIGREL.REPE
C      * JPTVOI  : ADRESSE JEVEUX DE MAILLAGE.VGE.PTVOIS
C      * JELVOI  : ADRESSE JEVEUX DE MAILLAGE.VGE.ELVOIS

      END
