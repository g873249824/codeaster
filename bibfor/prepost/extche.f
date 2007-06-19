      SUBROUTINE EXTCHE ( NCHME2, NCHMEN, SENSOP, NMAILE, NUMMAI, NCMP,
     &                    NBM, NBC, INDIC, NSSCHE,
     &                    MCF,IOCC, NBNAC, NNOEUD )
      IMPLICIT   NONE
      INTEGER       NBM, NBC, NUMMAI(*), IOCC, NBNAC, NNOEUD(*)
      CHARACTER*6   INDIC
      CHARACTER*8   NMAILE(*), NCMP(*)
      CHARACTER*18  SENSOP
      CHARACTER*19  NCHMEL, NCHMEN, NSSCHE, NCHME2
      CHARACTER*(*) MCF
C*********************************************************************
C MODIF PREPOST  DATE 19/06/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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

C   OPERATION REALISEE
C   ------------------

C     CONSTRUCTION DE LA SD ASSOCIEE A L' EXTRACTION SUR UN CHAM_ELEM

C   ARGUMENTS
C   ---------

C     NCHME2 (IN) : NOM DE LA SD DE TYPE CHAM_ELEM SUR LAQUELLE
C                   ON EXTRAIT
C
C     NCHMNE (IN) : NOM DE LA SD NOMINALE DANS LE CAS DE SENSIBILITE
C
C     SENSOP (IN) : OPTION POUR LA SENSIBILITE
C
C     NMAILE (IN) : TABLEAU DES NOMS DE MAILLE SUR LESQUELS
C                   ON EXTRAIT
C     NUNMAI (IN) : TABLEAU DES NUMEROS DE MAILLE SUR LESQUELS
C                   ON EXTRAIT
C     NCMP   (IN) : TABLEAU DES NOMS DE COMPOSANTES SUR LESQUELS
C                   ON EXTRAIT
C     NBM    (IN) : NBR DE MAILLE DE NMAILE
C     NBC    (IN) : NBR DE COMPOSANTES DE NCMP
C     INDIC  (IN) : INDICATEUR DU MODE DE PASSAGE DES MAILLES
C                   'NOMME'  <=> PAR NOMS,    ALORS NMAILE EST UTILISE
C                   'NUMERO' <=> PAR NUMEROS, ALORS NUMMAI EST UTILISE

C     NSSCHE (IN) : NOM DE LA SD DE TYPE SOUS_CHAM_NO CONSTRUITE

C                    .CELV     : OJB V R8 --> SGT DE VALEURS
C                                DOCU = 'CHLM'

C                    .PADR     : OJB V I  --> POINTEUR DES NOEUDS
C                                             SUR .CELV

C                    .PCMP     : OJB V I  --> TABLE DES CMP ACTIVES
C                                               POUR L' EXTRACTION

C                    .PNBN     : OJB V I  --> TABLE DES NBR DE NOEUDS
C                                             PAR MAILLES
C                    .PNCO     : OJB V I  --> TABLE DES NBR DE COUCHES
C                                             PAR MAILLES

C                    .PNSP     : OJB V I  --> TABLE DES NBR DE
C                                             SOUS POINTS PAR MAILLES

C                    .NOMA     : OJB E K8 --> NOM DU MAILLAGE

C                    .NUGD     : OJB E I  --> NUMERO DE LA GRANDEUR

C                    .ERRE     : XD  V I  --> VERIFICATION DE LA DEFINI-
C                                             TION DES CMP SUR LES
C                                             NOEUDS DES MAILLES

C     DESCRIPTION DE LA SD SOUS_CHAM_ELEM
C     -----------------------------------

C       SI PADR(IM) = 0 ALORS
C       --              -----

C           LA MAILLE NUMERO IM N' EST PAS CONCERNE PAR L' EXTRACTION

C       SINON
C       -----

C           PADR(IM) EST L' ADRESSE DU SOUS-SGT DE VALEURS
C           DANS VALE, ASSOCIEE A LA MAILLE NUMERO IM

C       FSI
C       ---

C       SI PNBN(IM) = 0 ALORS
C       --              -----

C           LA MAILLE NUMERO IM N' EST PAS CONCERNE PAR L' EXTRACTION

C       SINON
C       -----

C           PNBN(IM) EST LE NOMBRE DE NOEUDS DE LA MAILLE NUMERO IM

C       FSI
C       ---

C       SI PCMP(ICMP) = 0 ALORS
C       --                -----

C           LA CMP NUMERO ICMP N' EST PAS CONCERNE PAR L' EXTRACTION

C       SINON
C       -----

C           PCMP(ICMP) EST L' ADRESSE DE LA VALEUR DE LA CMP
C           NUMERO ICMP (DANS LE CATALOGUE DES GRANDEURS) DANS
C           TOUS LES SOUS-SGT ASSOCIES AUX NOEUDS

C       FSI
C       ---

C       MEME CONVENTION (0 OU <>0) POUR PNCO ET PNSP

C       IMALOC EST LE NUMERO LOCALE D' UNE MAILLE DE L' EXTRACTION
C       IL LUI CORRESPOND UN VECTEUR V DANS LA XD '.ERRE' :

C          V(JLOCCMP) = 0 <=> LA CMP NUMERO JLOCCMP POUR L' EXTRACTION
C                             EST DEFINIE SUR TOUS LES NOEUDS DE LA
C                             MAILLE

C*********************************************************************

C   FONCTIONS EXTERNES
C   ------------------

      CHARACTER*32 JEXNUM,JEXNOM

C   COMMUNS NORMALISES JEVEUX
C   -------------------------

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

C   NOMS ET ADRESSES DES OJB ASSOCIES AU CHAM_ELEM
C   ---------------------------------------------

      CHARACTER*3 TYPE
      CHARACTER*24 NDESC,NVALE,NCELK,NOMVEC
      INTEGER JCELD,AVALE,ACELK

C   NOMS ET ADRESSES DES OJB ASSOCIES AU LIGREL SOUS-JACENT
C   -------------------------------------------------------

      CHARACTER*24 NREPE,NNOMA
      CHARACTER*19 NLIGRL
      CHARACTER*8 NMAILA,NOMGD
      INTEGER AREPE,ANOMA

C   NOMS ET ADRESSES DES OJB ASSOCIES AU SOUS CHAM_ELEM
C   --------------------------------------------------

      CHARACTER*24 NPNBN,NPADR,NPCMP,NVALCP,NNUGD,NPERR,NPNCO,NPNSP
      INTEGER APNBN,APADR,APCMP,AVALCP,ANUGD,APERR,APNCO,APNSP

C   ENTIER REPERANT UNE MAILLE DANS UN LIGREL
C   -----------------------------------------

      INTEGER GREL,POSM

C   ADRESSES DES SEGMENTS DE VALEURS DANS LE '.CELV'
C   ------------------------------------------------

      INTEGER AGREL,ASGTM

C   ADRESSES LIEES AUX MODE LOCAUX
C   ------------------------------

      INTEGER AMODLO,MOD

C   ADRESSE DE NUMERO DE CMP CONCERNEES PAR L' EXTRACTION
C   -----------------------------------------------------

      INTEGER ANUMCP

C   DIVERS
C   ------

      INTEGER I,M,NBSCAL,NUMM,NBTMAI,GD,ACMPGD,NBTCMP,ADESGD
      INTEGER NBVAL,NBN,NBCO,NBSP,IBID,N1,IE,KK
      REAL*8 ANGL(3),PGL(3,3),R8DGRD,ORIG(3),AXEZ(3)
      REAL*8 ZERO,XNORMZ,EPSI
      LOGICAL UTILI
      CHARACTER*8 K8B,REPERE
      CHARACTER*24 NOMJV,NOMAUX

C================= FIN DES DECLARATIONS ============================


C   CONSTRUCTIONS DES NOMS ET RECUPERATIONS DES SEGMENTS DE VALEURS
C   ---------------------------------------------------------------

      CALL JEMARQ()
      NCHMEL=NCHME2


C     -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
      CALL CELCEL('NBVARI_CST',NCHMEL,'V','&&EXTCHE.CHAMEL1')
      NCHMEL= '&&EXTCHE.CHAMEL1'
      CALL CELVER(NCHMEL,'NBSPT_1','COOL',KK)
      IF (KK.EQ.1) THEN
        CALL DISMOI('F','NOM_GD',NCHMEL,'CHAMP',IBID,NOMGD,IE)
        CALL U2MESK('I','PREPOST_36',1,NOMGD)
        CALL CELCEL('PAS_DE_SP',NCHMEL,'V','&&EXTCHE.CHAMEL2')
        NCHMEL= '&&EXTCHE.CHAMEL2'
      END IF


      NDESC = NCHMEL//'.CELD'
      NVALE = NCHMEL//'.CELV'
      NCELK = NCHMEL//'.CELK'
      ZERO = 0.0D0
      EPSI = 1.0D-6
      CALL DISMOI('F','NOM_MAILLA',NCHMEL,'CHAMP',IBID,NMAILA,IE)

C   TRADUCTION DES NOMS DE MAILLES EN NUMERO (SI NECESSAIRE)
C   --------------------------------------------------------

      IF (INDIC.EQ.'NOMME') THEN

        DO 10,M = 1,NBM,1

          CALL JENONU(JEXNOM(NMAILA//'.NOMMAI',NMAILE(M)),NUMMAI(M))

   10   CONTINUE

      END IF

      CALL JELIRA(NVALE,'TYPE',IBID,TYPE)
      IF (TYPE(1:1).EQ.'R') THEN
        CALL JEVEUO(NVALE,'L',AVALE)
      ELSE IF (TYPE(1:1).EQ.'C') THEN
        NOMVEC = 'EXTCHE.VECTEUR'
        CALL RVRECU( MCF, IOCC, NCHMEL, NCHMEN, SENSOP, NOMVEC )
        CALL JEVEUO(NOMVEC,'L',AVALE)
      ELSE
        CALL U2MESS('F','PREPOST_37')
      END IF
      CALL JEVEUO(NDESC,'L',JCELD)
      CALL JEVEUO(NCELK,'L',ACELK)

C   EST-CE UN REPERE "UTILISATEUR"
C   ------------------------------

      UTILI = .FALSE.
      IF (MCF(1:6).EQ.'ACTION') THEN
        CALL GETVTX(MCF,'REPERE',IOCC,1,1,REPERE,N1)
        IF (REPERE.EQ.'UTILISAT') THEN
          UTILI = .TRUE.
          NOMJV = '&&EXTCHE.NEW_CHAMP'
          CALL GETVR8(MCF,'ANGL_NAUT',IOCC,1,3,ANGL,N1)
          ANGL(1) = ANGL(1)*R8DGRD()
          ANGL(2) = ANGL(2)*R8DGRD()
          ANGL(3) = ANGL(3)*R8DGRD()
          CALL MATROT(ANGL,PGL)
          CALL RVCHE1(NCHMEL,NOMJV,NBM,NUMMAI,PGL)
          CALL JEVEUO(NOMJV,'L',AVALE)
        ELSE IF (REPERE.EQ.'CYLINDRI') THEN
          UTILI = .TRUE.
          NOMJV = '&&EXTCHE.NEW_CHAMP'
          CALL GETVR8(MCF,'ORIGINE',IOCC,1,3,ORIG,N1)
          CALL GETVR8(MCF,'AXE_Z',IOCC,1,3,AXEZ,N1)
          XNORMZ = ZERO
          DO 20 I = 1,3
            XNORMZ = XNORMZ + AXEZ(I)*AXEZ(I)
   20     CONTINUE
          IF (XNORMZ.LT.EPSI) THEN
            CALL U2MESS('F','PREPOST_38')
          END IF
          XNORMZ = 1.0D0/SQRT(XNORMZ)
          DO 30 I = 1,3
            AXEZ(I) = AXEZ(I)*XNORMZ
   30     CONTINUE
          CALL RVCHE2(NCHMEL,NOMJV,NBM,NUMMAI,ORIG,AXEZ,NBNAC,NNOEUD)
          CALL JEVEUO(NOMJV,'L',AVALE)
        END IF
      END IF

      NNUGD = NSSCHE//'.NUGD'
      NPNBN = NSSCHE//'.PNBN'
      NPNCO = NSSCHE//'.PNCO'
      NPNSP = NSSCHE//'.PNSP'
      NPADR = NSSCHE//'.PADR'
      NPCMP = NSSCHE//'.PCMP'
      NVALCP = NSSCHE//'.VALE'
      NPERR = NSSCHE//'.ERRE'

      NOMAUX = ZK24(ACELK+1-1)
      NLIGRL = NOMAUX(1:19)

      NREPE = NLIGRL//'.REPE'
      NNOMA = NLIGRL//'.NOMA'

      CALL JEVEUO(NNOMA,'L',ANOMA)
      CALL JEVEUO(NREPE,'L',AREPE)

      NMAILA = ZK8(ANOMA)

      CALL WKVECT(NSSCHE//'.NOMA','V V K8',1,ANOMA)

      ZK8(ANOMA) = NMAILA

C   RECUPERATION DES NBR TOTAUX DE MAILLE ET DE GRELS
C   -------------------------------------------------

      CALL JELIRA(NMAILA//'.CONNEX','NMAXOC',NBTMAI,K8B)


C   CONSERVATION DU NUMERO DE LA GRANDEUR
C   -------------------------------------

      CALL WKVECT(NNUGD,'V V I',1,ANUGD)

      GD = ZI(JCELD+1-1)

      ZI(ANUGD) = GD

C   TRADUCTION DES NOMS DE CMP EN NUMEROS
C   -------------------------------------

      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',ACMPGD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NBTCMP,K8B)
      CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',GD),'L',ADESGD)

      CALL WKVECT('&&EXTRCHE.NUMCP','V V I',NBC,ANUMCP)

      CALL NUMEK8(ZK8(ACMPGD),NCMP,NBTCMP,NBC,ZI(ANUMCP))

C   CONSTRUCTION DU POINTEUR SUR LES POSITIONS DE CMP
C   -------------------------------------------------

      CALL WKVECT(NPCMP,'V V I',NBTCMP,APCMP)
      DO 40,I = 1,NBC,1
        ZI(APCMP+ZI(ANUMCP+I-1)-1) = I
   40 CONTINUE

C   CONSTRUCTION DES POINTEURS SUR : NBR DE NDS, DE COUCHES ET DE SSPT
C   ------------------------------------------------------------------

      CALL WKVECT(NPNBN,'V V I',NBTMAI,APNBN)
      CALL WKVECT(NPNCO,'V V I',NBTMAI,APNCO)
      CALL WKVECT(NPNSP,'V V I',NBTMAI,APNSP)

      NBVAL = 0

      DO 50,M = 1,NBM,1

        NUMM = NUMMAI(M)
        GREL = ZI(AREPE+2* (NUMM-1)+1-1)
        AGREL = ZI(JCELD-1+ZI(JCELD-1+4+GREL)+8)
        MOD = ZI(JCELD-1+ZI(JCELD-1+4+GREL)+2)


        CALL JELIRA(JEXNUM(NMAILA//'.CONNEX',NUMM),'LONMAX',NBN,K8B)

        IF (MOD.NE.0) THEN

          CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',MOD),'L',AMODLO)

          NBCO = ZI(AMODLO+4-1)
          NBCO = MAX(NBCO,NBCO-10000)/NBN
          NBCO = MAX(1,NBCO)
          NBSP = MAX(1,ZI(JCELD-1+4))

        ELSE

          NBN = 0
          NBCO = 0
          NBSP = 0

        END IF

        ZI(APNBN+NUMM-1) = NBN
        ZI(APNCO+NUMM-1) = NBCO
        ZI(APNSP+NUMM-1) = NBSP
        NBVAL = NBVAL + NBN*NBC*NBCO*NBSP

   50 CONTINUE

C   CONSTRUCTION DU POINTEUR SUR LES ADR DES SGT EXTRAITS PAR MAILLES
C   -----------------------------------------------------------------

      CALL WKVECT(NPADR,'V V I',NBTMAI,APADR)

      NUMM = NUMMAI(1)

      ZI(APADR+NUMM-1) = 1

      DO 60,M = 2,NBM,1

        NUMM = NUMMAI(M-1)

        ZI(APADR+NUMMAI(M)-1) = ZI(APADR+NUMM-1) +
     &                          NBC*ZI(APNBN+NUMM-1)*ZI(APNSP+NUMM-1)*
     &                          ZI(APNCO+NUMM-1)

   60 CONTINUE

C   CONSTRUCTION DE LA TABLE DES VALEURS DES CMP EXTRAITES
C   ------------------------------------------------------

      CALL WKVECT(NVALCP,'V V R',NBVAL,AVALCP)
      CALL JEECRA(NVALCP,'DOCU',NBVAL,'CHLM')

      CALL JECREC(NPERR,'V V I','NU','DISPERSE','VARIABLE',NBM)

      DO 70,M = 1,NBM,1

        CALL JECROC(JEXNUM(NPERR,M))
        CALL JEECRA(JEXNUM(NPERR,M),'LONMAX',NBC,' ')
        CALL JEVEUO(JEXNUM(NPERR,M),'E',APERR)

        NUMM = NUMMAI(M)

        GREL = ZI(AREPE+2* (NUMM-1)+1-1)
        POSM = ZI(AREPE+2* (NUMM-1)+2-1)

        AGREL = ZI(JCELD-1+ZI(JCELD-1+4+GREL)+8)
        MOD = ZI(JCELD-1+ZI(JCELD-1+4+GREL)+2)

        IF (MOD.NE.0) THEN

          CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',MOD),'L',AMODLO)

          NBSCAL = ZI(AMODLO+3-1)
          NBSP = ZI(APNSP+NUMM-1)
          ASGTM = AGREL + (POSM-1)*NBSCAL*NBSP - 1

          CALL EXCHEM(ZI(AMODLO),ZI(ANUMCP),NBC,NBSP,ZR(AVALE+ASGTM),
     &                ZR(AVALCP+ZI(APADR+NUMM-1)-1),ZI(APERR))

        END IF

   70 CONTINUE

      IF (UTILI) CALL JEDETR(NOMJV)
      CALL JEDETR('&&EXTRCHE.NUMCP')
      IF (TYPE(1:1).EQ.'C') CALL JEDETR(NOMVEC)

      CALL DETRSD('CHAM_ELEM','&&EXTCHE.CHAMEL1')
      CALL DETRSD('CHAM_ELEM','&&EXTCHE.CHAMEL2')
      CALL JEDEMA()
      END
