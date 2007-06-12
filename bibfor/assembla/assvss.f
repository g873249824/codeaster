      SUBROUTINE ASSVSS(BASE,VEC,VECEL,NU,VECPRO,MOTCLE,TYPE,FOMULT,
     &                  INSTAP)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 12/03/2007   AUTEUR DEVESA G.DEVESA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20  
      CHARACTER*(*) VEC,VECPRO,BASE,NU
      CHARACTER*8 VECEL
      CHARACTER*4 MOTCLE
      CHARACTER*24 FOMULT
      INTEGER TYPE
      REAL*8 R,INSTAP
C ----------------------------------------------------------------------
C OUT K19 VEC   : NOM DU CHAM_NO RESULTAT
C                CHAM_NO ::= CHAM_NO_GD + OBJETS PROVISOIRES POUR L'ASS.
C IN  K* BASE   : NOM DE LA BASE SUR LAQUELLE ON VEUT CREER LE CHAM_NO
C IN  K* VECEL  : VECT_ELEM A ASSEMBLER
C IN  K* NU     : NOM D'UN NUMERO_DDL
C IN  K* VECPRO : NOM D'UN CHAM_NO MODELE(NU OU VECPRO EST OBLIGATOIRE)
C IN  K4 MOTCLE : 'ZERO' OU 'CUMU'
C IN  K24 FOMULT: TABLEAU DE FONCTIONS MULTIPLICATRICES DE CHARGES
C IN  R8 INSTAP : INSTANT D'INTERPOLATION
C IN  I  TYPE   : TYPE DU VECTEUR ASSEMBLE : 1 --> REEL
C                                            2 --> COMPLEXE
C
C  S'IL EXISTE UN OBJET '&&POIDS_MAILLE' VR, PONDERATIONS POUR CHAQUE
C  MAILLE, ON S'EN SERT POUR LES OPTIONS RAPH_MECA ET FULL_MECA
C
C----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
C     COMMUNS   JEVEUX
C ----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8,NOMACR,EXIELE
      CHARACTER*14 NUM2
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C ----------------------------------------------------------------------
C     COMMUNS   LOCAUX DE L'OPERATEUR ASSE_VECTEUR
C ----------------------------------------------------------------------
      INTEGER GD,NEC,NLILI,DIGDEL
C ---------------------------------------------------------------------
C     VARIABLES LOCALES
C ---------------------------------------------------------------------
      PARAMETER (NBECMX=10)

      CHARACTER*1  K1BID,BAS
      CHARACTER*8  NOMSD,K8BID,MA,MO,MO2,NOGDSI,NOGDCO,NOMCAS,
     &             KBID
      CHARACTER*11 K11B
      CHARACTER*14 K14B,NUDEV
      CHARACTER*19 K19B,VECAS,VPROF
      CHARACTER*24 METHOD,SDFETI,K24B,SDFETS,KNUEQ,KMAILA,K24PRN,
     &             KVELIL,KVEREF,KVEDSC,RESU,NOMLI,KNEQUA,
     &             KVALE,NOMOPT,NOMLOG,NOMLID,INFOFE,SDFETA
C      CHARACTER*24 KNULIL
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
      LOGICAL      LFETI,LLIMO,LLICH,LLICHD,IDDOK,LFEL2,LLICHP,LFETIC,
     &             LSAUTE
      INTEGER      ICODLA(NBECMX),ICODGE(NBECMX),NBEC,EPDMS,JPDMS,NBSD,
     &             IDIME,IDD,ILIGRP,IFETN,IFETC,IREFN,NBREFN,ILIGRT,
     &             ADMODL,LCMODL,ILIGRB,IRET1,ILIGRC,IFEL1,IFEL2,IFEL3,
     &             IINF,IFCPU,IBID,IFM,NIV,ILIMPI,IFEL4,IFEL5,ILIMPB,
     &             IRET2,IRET3,IAUX1,JFEL4,IAUX2,IAUX3,IAUX4,COMPT,
     &             NIVMPI,RANG,NBLOG,JFONCT
      REAL*8       TEMPS(6),RBID,RCOEF
C ----------------------------------------------------------------------
C     FONCTIONS LOCALES D'ACCES AUX DIFFERENTS CHAMPS DES
C     S.D. MANIPULEES DANS LE SOUS PROGRAMME
C ----------------------------------------------------------------------
      INTEGER ZZCONX,ZZNBNE,ZZLIEL,ZZNGEL,ZZNSUP,ZZNELG,ZZNELS
      INTEGER ZZNEMA,ZZPRNO,IZZPRN

      ZZCONX(IMAIL,J) = ZI(ICONX1-1+ZI(ICONX2+IMAIL-1)+J-1)

C --- NBRE DE NOEUDS DE LA MAILLE IMAIL DU MAILLAGE
      ZZNBNE(IMAIL) = ZI(ICONX2+IMAIL) - ZI(ICONX2+IMAIL-1)

C --- FONCTION D ACCES AUX ELEMENTS DES CHAMPS LIEL DES S.D. LIGREL
C     REPERTORIEES DANS LE REPERTOIRE TEMPORAIRE .MATAS.LILI
C     ZZLIEL(ILI,IGREL,J) =
C      SI LA JIEME MAILLE DU LIEL IGREL DU LIGREL ILI EST:
C          -UNE MAILLE DU MAILLAGE : SON NUMERO DANS LE MAILLAGE
C          -UNE MAILLE TARDIVE : -POINTEUR DANS LE CHAMP .NEMA
      ZZLIEL(ILI,IGREL,J) = ZI(ZI(IADLIE+3* (ILI-1)+1)-1+
     &                      ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1)+J-1)

C --- NBRE DE GROUPES D'ELEMENTS (DE LIEL) DU LIGREL ILI
      ZZNGEL(ILI) = ZI(IADLIE+3* (ILI-1))

C --- NBRE DE NOEUDS DE LA MAILLE TARDIVE IEL ( .NEMA(IEL))
C     DU LIGREL ILI REPERTOIRE .LILI
C     (DIM DU VECTEUR D'ENTIERS .LILI(ILI).NEMA(IEL) )
      ZZNSUP(ILI,IEL) = ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL) -
     &                  ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1) - 1

C --- NBRE D ELEMENTS DU LIEL IGREL DU LIGREL ILI DU REPERTOIRE TEMP.
C     .MATAS.LILI(DIM DU VECTEUR D'ENTIERS .LILI(ILI).LIEL(IGREL) )
      ZZNELG(ILI,IGREL) = ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL) -
     &                    ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1) - 1

C --- NBRE D ELEMENTS SUPPLEMENTAIRE (.NEMA) DU LIGREL ILI DU
C     REPERTOIRE TEMPORAIRE .MATAS.LILI
      ZZNELS(ILI) = ZI(IADNEM+3* (ILI-1))

C --- FONCTION D ACCES AUX ELEMENTS DES CHAMPS NEMA DES S.D. LIGREL
C     REPERTORIEES DANS LE REPERTOIRE TEMPO. .MATAS.LILI
C     ZZNEMA(ILI,IEL,J) =  1.LE. J .GE. ZZNELS(ILI)
C      SI LE J IEME NOEUD DE LA MAILE TARDIVE IEL DU LIGREL ILI EST:
C          -UN NOEUD DU MAILLAGE : SON NUMERO DANS LE MAILLAGE
C          -UN NOEUD TARDIF : -SON NUMERO DANS LA NUMEROTATION LOCALE
C                              AU LIGREL ILI
C     ZZNEMA(ILI,IEL,ZZNELS(ILI)+1)=NUMERO DU TYPE_MAILLE DE LA MAILLE
C                                   IEL DU LIGREL ILI
      ZZNEMA(ILI,IEL,J) = ZI(ZI(IADNEM+3* (ILI-1)+1)-1+
     &                    ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1)+J-1)

C --- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
C     REPERTORIEES DANS NU.LILI DE LA S.D. PROF_CHNO ET A LEURS ADRESSES
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

C --- DEBUT ------------------------------------------------------------
      CALL JEMARQ()

C-----RECUPERATION DU NIVEAU D'IMPRESSION

      CALL INFNIV(IFM,NIV)
      INFOFE='FFFFFFFFFFFFFFFFFFFFFFFF'

C     IFM = IUNIFI('MESSAGE')
C----------------------------------------------------------------------

C --- VERIF DE MOTCLE:
      IF (MOTCLE(1:4).EQ.'ZERO') THEN

      ELSE IF (MOTCLE(1:4).EQ.'CUMU') THEN

      ELSE
        CALL U2MESK('F','ASSEMBLA_8',1,MOTCLE)
      END IF
C
      CALL JEVEUO(JEXATR('&CATA.TE.MODELOC','LONCUM'),'L',LCMODL)
      CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',1),'L',ADMODL)

      VECAS = VEC
      BAS = BASE

C --- SI LE CONCEPT VECAS EXISTE DEJA,ON LE DETRUIT:
      CALL DETRSD('CHAMP_GD',VECAS)
      CALL WKVECT(VECAS//'.LIVE',BAS//' V K8 ',1,ILIVEC)
      ZK8(ILIVEC) = VECEL

C --- NOMS DES PRINCIPAUX OBJETS JEVEUX LIES A VECAS
      KMAILA = '&MAILLA                 '
      KVELIL = VECAS//'.LILI'


C --- CALCUL D UN LILI POUR VECAS
C --- CREATION D'UN VECAS(1:19).ADNE ET VECAS(1:19).ADLI SUR 'V'
      CALL CRELIL(1,ILIVEC,KVELIL,'V',KMAILA,VECAS,GD,MA,NEC,NCMP,
     &            ILIM,NLILI,NBELM)
      CALL JEVEUO(VECAS(1:19)//'.ADLI','E',IADLIE)
      CALL JEVEUO(VECAS(1:19)//'.ADNE','E',IADNEM)
      CALL JEEXIN(MA(1:8)//'.CONNEX',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(MA(1:8)//'.CONNEX','L',ICONX1)
        CALL JEVEUO(JEXATR(MA(1:8)//'.CONNEX','LONCUM'),'L',ICONX2)
      END IF

C --- ON SUPPOSE QUE LE LE LIGREL DE &MAILLA EST LE PREMIER DE LILINU
      ILIMNU = 1

C --- NOMS DES PRINCIPAUX OBJETS JEVEUX LIES A NU
C --- IL FAUT ESPERER QUE LE CHAM_NO EST EN INDIRECTION AVEC UN
C     PROF_CHNO APPARTENANT A UNE NUMEROTATION SINON CA VA PLANTER
C     DANS LE JEVEUO SUR KNEQUA
      NUDEV = NU
      IF (NUDEV(1:1).EQ.' ') THEN
        VPROF = VECPRO
        CALL JEVEUO(VPROF//'.REFE','L',IDVREF)
        NUDEV = ZK24(IDVREF-1+2) (1:14)
      END IF

C --- TEST POUR SAVOIR SI LE SOLVEUR EST DE TYPE FETI
C --- NUME_DDL ET DONC CHAM_NO ETENDU, OUI OU NON ?
      CALL JELIRA(NUDEV(1:14)//'.NUME.REFN','LONMAX',NBREFN,K8BID)
      IF (NBREFN.NE.4) THEN
        WRITE(IFM,*)'<FETI/ASSVEC> NUME_DDL/CHAM_NO NON ETENDU '
     &              //'POUR FETI',NUDEV(1:14)//'.NUME.REFN'
        METHOD='XXXX'
        SDFETI='XXXX'
      ELSE
        CALL JEVEUO(NUDEV(1:14)//'.NUME.REFN','L',IREFN)
        METHOD=ZK24(IREFN+2)
        SDFETI=ZK24(IREFN+3)
        SDFETS=SDFETI
        SDFETA=SDFETS(1:19)//'.FETA'
      ENDIF

      LFETI=.FALSE.
      LFETIC = .FALSE.
      NBSD=0
      IF (METHOD(1:4).EQ.'FETI') THEN
        LFETI=.TRUE.
        CALL JEVEUO(SDFETI(1:19)//'.FDIM','L',IDIME)
C NOMBRE DE SOUS-DOMAINES
        NBSD=ZI(IDIME)
C CONSTITUTION DE L'OBJET JEVEUX VECAS.FETC COMPLEMENTAIRE
        CALL WKVECT(VECAS//'.FETC',BAS//' V K24',NBSD,IFETC)
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE=ZK24(IINF)
        IF (INFOFE(11:11).EQ.'T') LFETIC=.TRUE.
      ENDIF

      CALL DISMOI('F','NOM_MODELE',NUDEV,'NUME_DDL',IBID,MO,IERD)
      CALL DISMOI('F','NOM_MAILLA',NUDEV,'NUME_DDL',IBID,MA,IERD)
      CALL DISMOI('F','NB_NO_SS_MAX',MA,'MAILLAGE',NBNOSS,KBID,IERD)

C     100 EST SUPPOSE ETRE LA + GDE DIMENSION D'UNE MAILLE STANDARD:
      NBNOSS = MAX(NBNOSS,100)
C     -- NUMLOC(K,INO) (K=1,3)(INO=1,NBNO(MAILLE))
      CALL WKVECT('&&ASSVEC.NUMLOC','V V I',3*NBNOSS,IANULO)

      CALL DISMOI('F','NOM_GD',NUDEV,'NUME_DDL',IBID,NOGDCO,IERD)
      CALL DISMOI('F','NOM_GD_SI',NOGDCO,'GRANDEUR',IBID,NOGDSI,IERD)
      CALL DISMOI('F','NB_CMP_MAX',NOGDSI,'GRANDEUR',NMXCMP,KBID,IERD)
      CALL DISMOI('F','NUM_GD_SI',NOGDSI,'GRANDEUR',NUGD,KBID,IERD)
      NEC = NBEC(NUGD)
      NCMP = NMXCMP

      DO 20 I = 1,NBECMX
        ICODLA(I) = 0
        ICODGE(I) = 0
   20 CONTINUE

C     -- POSDDL(ICMP) (ICMP=1,NMXCMP(GD_SI))
      CALL WKVECT('&&ASSVEC.POSDDL','V V I',NMXCMP,IAPSDL)

C     -- ON PREPARE L'ASSEMBLAGE DES SOUS-STRUCTURES:
C     -----------------------------------------------
      CALL DISMOI('F','NB_NO_MAILLA',MO,'MODELE',NM,KBID,IER)

      CALL JEEXIN(MA//'.NOMACR',IRET)
      IF (IRET.GT.0) THEN
        IF (LFETI)
     &    CALL U2MESK('F','ASSEMBLA_12',1,MA(1:8))
        CALL JEVEUO(MA//'.NOMACR','L',IANMCR)
        CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'L',IANCMP)
        CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'LONMAX',LGNCMP,
     &              KBID)
        ICMP = INDIK8(ZK8(IANCMP),'LAGR',1,LGNCMP)
        IF (ICMP.EQ.0) CALL U2MESS('F','ASSEMBLA_9')
        IF (ICMP.GT.30) CALL U2MESS('F','ASSEMBLA_10')
C       -- ICODLA EST L'ENTIER CODE CORRESPONDANT A LA CMP "LAGR"
        JEC = (ICMP-1)/30 + 1
        ICODLA(JEC) = 2**ICMP
C        ICODLA = 2**ICMP
      END IF

C ADRESSE JEVEUX DE LA LISTE DES NUME_DDL ASSOCIES AUX SOUS-DOMAINES
      IF (LFETI) THEN
        CALL JEVEUO(NUDEV//'.FETN','L',IFETN)
C STOCKE &&//NOMPRO(1:6)//'.2.' POUR COHERENCE AVEC L'EXISTANT
        K11B=VECAS(1:10)//'.'
C ADRESSE JEVEUX DE L'OBJET '&FETI.MAILLE.NUMSD'
        NOMLOG='&FETI.MAILLE.NUMSD'
        CALL JEVEUO(NOMLOG,'L',ILIGRP)
        ILIGRP=ILIGRP-1
C ADRESSE JEVEUX OBJET AFFICHAGE CPU
        CALL JEVEUO('&FETI.INFO.CPU.ASSE','E',IFCPU)
C ADRESSE JEVEUX OBJET FETI & MPI
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
        CALL JEVEUO('&FETI.LISTE.SD.MPIB','L',ILIMPB)
        IF (INFOFE(10:10).EQ.'T') THEN
          NIVMPI=2
        ELSE
          NIVMPI=1
        ENDIF
        CALL FETMPI(2,IBID,IFM,NIVMPI,RANG,IBID,K24B,K24B,K24B,RBID)
      ENDIF

C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
C IDD=0 --> DOMAINE GLOBAL/ IDD=I --> IEME SOUS-DOMAINE
      DO 195 IDD=0,NBSD

C TRAVAIL PREALABLE POUR DETERMINER SI ON EFFECTUE LA BOUCLE SUIVANT
C LE SOLVEUR (FETI OU NON), LE TYPE DE RESOLUTION (PARALLELE OU
C SEQUENTIELLE) ET L'ADEQUATION "RANG DU PROCESSEUR-NUMERO DU SD"
        IF (.NOT.LFETI) THEN
          IDDOK=.TRUE.
        ELSE
          IF (ZI(ILIMPI+IDD).EQ.1) THEN
            IDDOK=.TRUE.
          ELSE
            IDDOK=.FALSE.
          ENDIF
        ENDIF
        IF (IDDOK) THEN

        IF (LFETI) CALL JEMARQ()
C CALCUL TEMPS
        IF ((NIV.GE.2).OR.(LFETIC)) THEN
          CALL UTTCPU(90,'INIT ',6,TEMPS)
          CALL UTTCPU(90,'DEBUT',6,TEMPS)
        ENDIF
C ---  RECUPERATION DE PRNO/LILI/NUEQ/NEQU
        IF (IDD.EQ.0) THEN
          K24PRN = NUDEV//'.NUME.PRNO'
C          KNULIL = NUDEV//'.NUME.LILI'
          KNUEQ  = NUDEV//'.NUME.NUEQ'
          KNEQUA = NUDEV//'.NUME.NEQU'
        ELSE
          K14B=ZK24(IFETN+IDD-1)(1:14)
          K24PRN(1:14)=K14B
C          KNULIL(1:14)=K14B
          KNUEQ(1:14)=K14B
          KNEQUA(1:14)=K14B
        ENDIF
        CALL JEVEUO(K24PRN,'L',IDPRN1)
        CALL JEVEUO(JEXATR(K24PRN,'LONCUM'),'L',IDPRN2)
        CALL JEVEUO(KNUEQ,'L',IANUEQ)
        CALL JEVEUO(KNEQUA,'L',IDNEQU)
        NEQUA = ZI(IDNEQU)

C ---  REMPLISSAGE DES .REFE ET .DESC
        IF (IDD.EQ.0) THEN
C SI NON FETI OU FETI DOMAINE GLOBAL
          KVEREF = VECAS//'.REFE'
          KVALE  = VECAS//'.VALE'
          KVEDSC = VECAS//'.DESC'
        ELSE
C SI SOUS-DOMAINE FETI
          CALL JENUNO(JEXNUM(SDFETA,IDD),NOMSD)
C          K19B=K11B//NOMSD
C NOUVELLE CONVENTION POUR LES CHAM_NOS FILS, GESTTION DE NOMS
C ALEATOIRES
          CALL GCNCON('.',K8BID)
          K8BID(1:1)='F'
          K19B=K11B(1:11)//K8BID
          ZK24(IFETC+IDD-1)=K19B
          KVEREF(1:19)=K19B
          KVEDSC(1:19)=K19B
          KVALE(1:19)=K19B
C RECUPERATION DANS LE .NUME.REFN DU NOM DE LA METHODE
          CALL JEVEUO(K14B//'.NUME.REFN','L',IREFN)
          METHOD=ZK24(IREFN+2)
          SDFETI=ZK24(IREFN+3)
        ENDIF
        CALL JECREO(KVEREF,BAS//' V K24')
        CALL JEECRA(KVEREF,'LONMAX',4,' ')
        CALL JEVEUO(KVEREF,'E',IDVERF)
        CALL JECREO(KVEDSC,BAS//' V I')
        CALL JEECRA(KVEDSC,'LONMAX',2,' ')
        CALL JEECRA(KVEDSC,'DOCU',IBID,'CHNO')
        CALL JEVEUO(KVEDSC,'E',IDVEDS)
        ZK24(IDVERF) = MA
        ZK24(IDVERF+1) = K24PRN(1:14)//'.NUME'
        ZK24(IDVERF+2) = METHOD
        ZK24(IDVERF+3) = SDFETI
        ZI(IDVEDS) = GD
        ZI(IDVEDS+1) = 1

C --- ALLOCATION .VALE EN R OU C SUIVANT TYPE
        IF (TYPE.EQ.1) THEN
          CALL JECREO(KVALE,BAS//' V R8')
        ELSE IF (TYPE.EQ.2) THEN
          CALL JECREO(KVALE,BAS//' V C16')
        ELSE
          CALL U2MESS('F','ASSEMBLA_11')
        ENDIF
        CALL JEECRA(KVALE,'LONMAX',NEQUA,' ')
        CALL JEVEUO(KVALE,'E',IADVAL)


C --- REMPLISSAGE DE .VALE
C ------------------------
C==========================
C BOUCLE SUR LES VECT_ELEM
C==========================
        CALL DISMOI('F','NOM_MODELE',VECEL,'VECT_ELEM',IBID,MO2,IERD)
        IF (MO2.NE.MO) CALL U2MESS('F','ASSEMBLA_5')

C       -- TRAITEMENT DES SOUS-STRUCTURES (JUSQU A FIN BOUCLE 738)
C       ----------------------------------------------------------
        CALL DISMOI('F','EXI_ELEM',MO,'MODELE',IBID,EXIELE,IERD)
        CALL DISMOI('F','NB_SS_ACTI',VECEL,'VECT_ELEM',NBSSA,KBID,
     &              IERD)
        IF (NBSSA.GT.0) THEN
          NOMCAS = ' '
          CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
          CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MA,IERD)
          CALL JEVEUO(MO//'.SSSA','L',IASSSA)
          CALL SSVALV('DEBUT',NOMCAS,MO,MA,0,IDRESL,NCMPEL)
          CALL JELIRA(VECEL//'.LISTE_CHAR','NUTIOC',NBCHAR,KBID)
C            WRITE(6,*) 'NBCHAR ',NBCHAR
          CALL JEVEUO(FOMULT,'L',JFONCT)
C            WRITE(6,*) 'FOMULT ',(ZK24(JFONCT+ICHAR-1),ICHAR=1,NBCHAR)

          DO 90 ICHAR = 1,NBCHAR
            CALL JENUNO(JEXNUM(VECEL//'.LISTE_CHAR',ICHAR),NOMCAS)
            CALL JEVEUO(JEXNUM(VECEL//'.LISTE_CHAR',ICHAR),'L',IALCHA)
            IF (ZK24(JFONCT+ICHAR-1)(1:8).EQ.'&&CONSTA') THEN
              RCOEF = 1.0D0
            ELSE
              CALL FOINTE('F ',ZK24(JFONCT+ICHAR-1)(1:8),1,'INST',
     &                    INSTAP,RCOEF,IERD)
            ENDIF
C              WRITE(6,*) 'ICHAR NOMCAS RCOEF ',ICHAR,NOMCAS,RCOEF
            DO 80 IMA = 1,NBSMA
C             -- ON N'ASSEMBLE QUE LES SSS VRAIMENT ACTIVES :
              IF (ZI(IASSSA-1+IMA).EQ.0) GO TO 80
              IF (ZI(IALCHA-1+IMA).EQ.0) GO TO 80
              CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',IAMAIL)
              CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NNOE,
     &                    KBID)
              CALL SSVALV(' ',NOMCAS,MO,MA,IMA,IDRESL,NCMPEL)
              NOMACR = ZK8(IANMCR-1+IMA)
              CALL DISMOI('F','NOM_NUME_DDL',NOMACR,'MACR_ELEM_STAT',
     &                    IBID,NUM2,IERD)
              CALL JEVEUO(NOMACR//'.CONX','L',IACONX)
              CALL JEVEUO(JEXNUM(NUM2//'.NUME.PRNO',1),'L',IAPROL)
              IL = 0
              DO 70 K1 = 1,NNOE
                N1 = ZI(IAMAIL-1+K1)
                IF (N1.GT.NM) THEN
                  DO 30 IEC = 1,NBECMX
                    ICODGE(IEC) = ICODLA(IEC)
   30             CONTINUE
                ELSE
                  INOLD = ZI(IACONX-1+3* (K1-1)+2)
                  DO 40 IEC = 1,NEC
                    ICODGE(IEC)=ZI(IAPROL-1+(NEC+2)*(INOLD-1)+2+IEC)
   40             CONTINUE
                END IF

                IAD1=ZI(IDPRN1-1+ZI(IDPRN2+ILIMNU-1)+ (N1-1)* (NEC+2))
                CALL CORDD2(IDPRN1,IDPRN2,ILIMNU,ICODGE,NEC,NCMP,N1,
     &                      NDDL1,ZI(IAPSDL))

                IF (TYPE.EQ.1) THEN
                  DO 50 I1 = 1,NDDL1
                    IL = IL + 1
                    ZR(IADVAL-1+ZI(IANUEQ-1+IAD1+ZI(IAPSDL-1+I1)-
     &              1)) = ZR(IADVAL-1+ZI(IANUEQ-1+IAD1+ZI(IAPSDL-1+
     &              I1)-1)) + ZR(IDRESL+IL-1)*RCOEF
   50             CONTINUE
                ELSE IF (TYPE.EQ.2) THEN
                  DO 60 I1 = 1,NDDL1
                    IL = IL + 1
                    ZC(IADVAL-1+ZI(IANUEQ-1+IAD1+ZI(IAPSDL-1+I1)-
     &              1)) = ZC(IADVAL-1+ZI(IANUEQ-1+IAD1+ZI(IAPSDL-1+
     &              I1)-1)) + ZC(IDRESL+IL-1)*RCOEF
   60             CONTINUE
                END IF
   70         CONTINUE
   80       CONTINUE
   90     CONTINUE
          CALL SSVALV('FIN',NOMCAS,MO,MA,0,IDRESL,NCMPEL)
        ENDIF


C MONITORING
        IF (LFETI.AND.(INFOFE(1:1).EQ.'T')) THEN
          WRITE(IFM,*)
          WRITE(IFM,*)'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'
          IF (IDD.EQ.0) THEN
            WRITE(IFM,*)'<FETI/ASSVEC> DOMAINE GLOBAL'
          ELSE
            WRITE(IFM,*)'<FETI/ASSVEC>NUMERO DE SOUS-DOMAINE: ',IDD
          ENDIF
          WRITE(IFM,*)'<FETI/ASSVEC> REMPLISSAGE OBJETS JEVEUX ',
     &        KVALE(1:19)
          WRITE(IFM,*)
        ENDIF
        IF ((INFOFE(3:3).EQ.'T').AND.(IDD.NE.0))
     &    CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,KVALE(1:19),1,' ')
        IF ((INFOFE(3:3).EQ.'T').AND.(IDD.EQ.NBSD))
     &    CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,VECAS(1:19),1,' ')

        IF ((NIV.GE.2).OR.(LFETIC)) THEN
          CALL UTTCPU(90,'FIN  ',6,TEMPS)
          IF (NIV.GE.2) WRITE(IFM,'(A44,D11.4,D11.4)')
     &      'TEMPS CPU/SYS ASSEMBLAGE V                : ',TEMPS(5),
     &       TEMPS(6)
          IF (LFETIC) ZR(IFCPU+IDD)=ZR(IFCPU+IDD)+TEMPS(5)+TEMPS(6)
        ENDIF
        IF (LFETI) CALL JEDEMA()

C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
        ENDIF
  195 CONTINUE

      CALL JEDETR(VECAS//'.LILI')
      CALL JEDETR(VECAS//'.LIVE')
      CALL JEDETR(VECAS//'.ADNE')
      CALL JEDETR(VECAS//'.ADLI')
C      IF (NIV.EQ.2) THEN
C        WRITE (IFM,*) ' --- '
C        WRITE (IFM,*) ' --- VECTEUR ASSEMBLE '
C        WRITE (IFM,*) ' --- '
C        IF (TYPE.EQ.1) THEN
C          DO 1000 IEQUA = 1,NEQUA
C            WRITE (IFM,*) ' -   CHAM_NO( ',IEQUA,' ) = ',
C     +        ZR(IADVAL+IEQUA-1)
C 1000     CONTINUE
C        ELSE
C          DO 1001 IEQUA = 1,NEQUA
C            WRITE (IFM,*) ' -   CHAM_NO( ',IEQUA,' ) = ',
C     +        ZC(IADVAL+IEQUA-1)
C 1001     CONTINUE
C        END IF
C        WRITE (IFM,*) ' --------------------------- '
C      END IF
C      IF (NIV.EQ.2) THEN
C        WRITE (IFM,*) ' --- '
C        WRITE (IFM,*) ' --- REFE DU VECTEUR    CREE '
C        WRITE (IFM,*) ' --- '
C        WRITE (IFM,*) ' -   REFE(1) = MAILLAGE        ',ZK24(IDVERF)
C        WRITE (IFM,*) ' -   REFE(2) = NUMEROTATION    ',ZK24(IDVERF+1)
C        WRITE (IFM,*) ' --------------------------- '
C      END IF
      CALL JEDETR('&&ASSVEC.POSDDL')
      CALL JEDETR('&&ASSVEC.NUMLOC')
      CALL JEDEMA()
      END
