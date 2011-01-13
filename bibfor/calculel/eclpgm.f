      SUBROUTINE ECLPGM(MA2,MO,LIGREL,SHRINK,LONMIN,NCH,LISCH)
      IMPLICIT   NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/01/2011   AUTEUR PELLET J.PELLET 
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
C   - TRAITEMENT DU MOT CLE CREA_MAILLAGE/ECLA_PG
C-----------------------------------------------------------------------
C BUT : CREER LE MAILLAGE (MA2) CORRESPONDANT AUX POINTS DE GAUSS
C       DES ELEMENTS DU LIGREL (LIGREL).
C
C ARGUMENTS :
C  IN/JXIN  MO : MODELE DONT ON VEUT "ECLATER" LES POINTS DE GAUSS
C  IN/JXIN  LIGREL : NOM DU LIGREL (D'ELEMENTS DU MODELE) CORRESPONDANT
C           AUX MAILLES QUI INTERESSENT L'UTILISATEUR.
C           SI LIGREL=' ', ON PREND LE LIGREL DU MODELE (TOUT='OUI')
C  IN       LISCH(*) : LISTE DES NOMS SYMBOLIQUES DES CHAMPS AUXQUELS
C           ON S'INTERESSE. EX: (SIEF_ELGA, VARI_ELGA_DEPL, ...)
C  IN NCH : DIMENSION DE LISCH
C  IN/JXOUT MA2 : NOM DU MAILLAGE A CREER (1 MAILLE PAR POINT DE GAUSS)
C           LES MAILLES DE MA2 SONT TOUTES DECONNECTEES LES UNES DES
C           DES AUTRES.
C  IN  SHRINK : COEFFICENT DE "CONTRACTION" DES MAILLES POUR QUE
C       CELLES-CI NE SE CHEVAUCHENT PAS.
C       SHRINK=0.9 DONNE UN BEAU VITRAIL AVEC 10% DE NOIR.
C  IN  LONMIN : LONGUEUR MINIMALE POUR LES ARETES DES MAILLES CREEES.
C      (IGNORE SI LONMIN <=0)
C      CETTE FONCTIONNALITE PERMET D'"EPAISSIR" DES ELEMENTS DE JOINT
C      POUR QU'ON PUISSE LES VOIR.
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      CHARACTER*32  JEXNOM,JEXNUM,JEXATR
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER K,NBGREL,TE,TABNO(27),TYPELE,IRET1,JOBJ,NUMA,NCH
      INTEGER IGR,IEL,IACOOR,IAMACO,ILMACO,IALIEL,ILLIEL,NBELEM
      INTEGER DIMGEO,IACOSE,IBID,NBPG,INO,INO1,INO2
      INTEGER NUMGLM,NBMAIL,NBNOEU,NBCOOR,IADIME,IPG
      INTEGER NBNO2T,IANNO2,IATYPM,NUNO2,NUPOI2
      INTEGER NPG1,NBPI,IAGEPI,IAGESE,NNO2,NBNOMA,NUPG
      INTEGER IMA,NBELGR,NUMAIL,NUPOIN,NPOINI,ITERM,IPOINI
      INTEGER IRET,ICH,JREFE
      CHARACTER*8 MO, MA1,MA2,NOM ,KBID, ELREFA, FAPG, FAMIL, NOMPAR
      CHARACTER*16 TYPRES,NOMCMD,NOMTE,K16BID,LISCH(NCH)
      CHARACTER*19 LIGREL,LIGRMO, CEL
      CHARACTER*24 NOMOBJ
      CHARACTER*24 VALK(2)
      REAL*8 X,XC,XM,SHRINK,LONMIN

C ----------------------------------------------------------------------
C     VARIABLES NECESSAIRES A L'APPEL DE ECLATY :
C     ON COMPREND LE SENS DE CES VARIABLES EN REGARDANT ECLATY
      INTEGER  MXNBN2,MXNBPG,MXNBPI,MXNBTE
C     MXNBN2 : MAX DU NOMBRE DE NOEUDS D'UN SOUS-ELEMENT (HEXA8)
      PARAMETER (MXNBN2=8)
C     MXNBPG : MAX DU NOMBRE DE POINTS DE GAUSS D'UN TYPE_ELEM
      PARAMETER (MXNBPG=27)
C     MXNBPI : MAX DU NOMBRE DE POINT_I (HEXA A 27 POINTS DE GAUSS)
C     MXNBPI = 4X4X4
      PARAMETER (MXNBPI=64)
C     MXNBTE : MAX DU NOMBRE DE TERMES DE LA C.L. DEFINISSANT 1 POINT_I
C              AU PLUS LES 8 SOMMETS D'UN HEXA8
      PARAMETER (MXNBTE=8)

      INTEGER  CONNX(MXNBN2,MXNBPG),NSOMM1(MXNBPI,MXNBTE)
      INTEGER  NTERM1(MXNBPI),NBNO2(MXNBPG)
      REAL*8 CSOMM1(MXNBPI,MXNBTE)
      INTEGER TYMA(MXNBPG)
      INTEGER ICO
      INTEGER OPT,IADESC,IAOPPA,NBIN
C ----------------------------------------------------------------------

C     FONCTIONS FORMULES :
C     NUMAIL(IGR,IEL)=NUMERO DE LA MAILLE ASSOCIEE A L'ELEMENT IEL
      NUMAIL(IGR,IEL)=ZI(IALIEL-1+ZI(ILLIEL+IGR-1)+IEL-1)
C     NBNOMA(IMA)=NOMBRE DE NOEUDS DE LA MAILLE IMA
      NBNOMA(IMA)=ZI(ILMACO-1+IMA+1)-ZI(ILMACO-1+IMA)
C     NUMGLM(IMA,INO)=NUMERO GLOBAL DU NOEUD INO DE LA MAILLE IMA
C                     IMA ETANT UNE MAILLE DU MAILLAGE.
      NUMGLM(IMA,INO)=ZI(IAMACO-1+ZI(ILMACO+IMA-1)+INO-1)

C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      DIMGEO = 3


      CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MA1,IBID)
      CALL JEVEUO(MA1//'.COORDO    .VALE','L',IACOOR)
      CALL JEVEUO(MA1//'.CONNEX','L',IAMACO)
      CALL JEVEUO(JEXATR(MA1//'.CONNEX','LONCUM'),'L',ILMACO)



C    0.1 : ON CHERCHE LE NOM DES FAMILLES DE POINTS DE GAUSS A ECLATER
C          SI NOM_CHAM NEST PAS UTILISE, ON PREND 'RIGI'
C          SORTIES : NCH  [+ JOBJ SI NCH>0]
C    -----------------------------------------------------------------
      NOMOBJ = '&&ECLPGM.NOMOBJ'
      CEL = '&&ECLPGM.CHAM_ELEM'


      ICO=0
      IF ( NCH .GT. 0 ) THEN
         CALL DISMOI('F','NOM_LIGREL',MO,'MODELE',IBID,LIGRMO,IBID)
         DO 30, ICH=1,NCH

           IF(LISCH(ICH)(6:9).NE.'ELGA') CALL U2MESS('F',
     &                                        'CALCULEL2_41')
           CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',LISCH(ICH)),OPT)
           IF (OPT.EQ.0) GOTO 30

           CALL JEVEUO(JEXNUM('&CATA.OP.DESCOPT',OPT),'L',IADESC)
           CALL JEVEUO(JEXNUM('&CATA.OP.OPTPARA',OPT),'L',IAOPPA)
           NBIN = ZI(IADESC-1+2)
           NOMPAR = ZK8(IAOPPA-1+NBIN+1)

           CALL ALCHML(LIGRMO,LISCH(ICH),NOMPAR,
     &                 'V',CEL,IRET1,' ')

           IF (IRET1.NE.0) CALL U2MESK('F','CALCULEL5_32',1,LISCH(ICH))

           ICO=ICO+1
           CALL CELFPG(CEL,NOMOBJ,IRET)
           IF (IRET.EQ.1) THEN
              VALK(1) = MO
              VALK(2) = LISCH(ICH)
              CALL U2MESK('F','CALCULEL2_33', 2 ,VALK)
           ENDIF
           CALL JEEXIN ( NOMOBJ, IRET1 )
           CALL ASSERT(IRET1.GT.0)
           CALL JEVEUO ( NOMOBJ, 'L', JOBJ )
30       CONTINUE
C        -- ON N'A PAS TROUVE DE CHAMP ELGA CORRECT :
         IF (ICO.EQ.0) NCH=0
      ENDIF
29    CONTINUE
      CALL DETRSD ('CHAMP',CEL)



C     0.2 : ON SE RESTREINT AUX MAILLES EVENTUELLEMENT SPECIFIEES PAR
C           L'UTILISATEUR :
C     ----------------------------------------------------------------
      IF (LIGREL.EQ.' ') LIGREL=LIGRMO
      CALL JEVEUO(LIGREL//'.LIEL','L',IALIEL)
      CALL JEVEUO(JEXATR(LIGREL//'.LIEL','LONCUM'),'L',ILLIEL)



C     1. ON COMPTE LES POINTS DE GAUSS (ET LES FUTURS SOUS-ELEMENTS)
C        ET LES POINT_I ET LES NOEUDS DU FUTUR MAILLAGE
C     ---------------------------------------------------------------
      NBPG   = 0
      NBPI   = 0
      NBNO2T = 0
      DO 1,IGR = 1 , NBGREL(LIGREL)
         TE = TYPELE(LIGREL,IGR)
         NBELGR = NBELEM(LIGREL,IGR)
         CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

         IF ( NCH .NE. 0 ) THEN
            NUMA   = NUMAIL(IGR,1)
            ELREFA = ZK16(JOBJ-1+NUMA)(1:8)
            FAPG   = ZK16(JOBJ-1+NUMA)(9:16)
         ELSE
            FAMIL = 'RIGI'
            CALL ECLAU1 ( NOMTE, FAMIL, ELREFA, FAPG )
         ENDIF
         IF ( FAPG .EQ. ' ' ) GOTO 1

         CALL ECLATY ( NOMTE, ELREFA, FAPG, NPG1, NPOINI,
     &                 NTERM1, NSOMM1, CSOMM1, TYMA, NBNO2, CONNX,
     &                 MXNBN2, MXNBPG, MXNBPI, MXNBTE )
         NBPG = NBPG+NBELGR*NPG1
         NBPI = NBPI+NBELGR*NPOINI
         DO 500,IPG = 1,NPG1
           NBNO2T = NBNO2T+NBELGR*NBNO2(IPG)
500      CONTINUE
1     CONTINUE


C     2. ON ALLOUE 4 OBJETS DE TRAVAIL (+ MAILLAGE//'.TYPMAIL') :
C        .GEOPOINI : GEOMETRIE DES POINT_I
C        .CONNEXSE : NUMEROS DES POINT_I DES SOUS-ELEMENTS
C        .GEOSE    : GEOMETRIE DES SOUS-ELEMENTS
C        .NBNO2    : NOMBRE DE NOEUDS DES SOUS-ELEMENTS
C        .TYPMAIL  : TYPE_MAILLE DES SOUS-ELEMENTS
C     ---------------------------------------------------------------
      IF (NBPI.EQ.0) CALL U2MESS('F','CALCULEL2_35')
      CALL WKVECT('&&ECLPGM.GEOPOINI','V V R',NBPI*DIMGEO,IAGEPI)
      CALL WKVECT('&&ECLPGM.CONNEXSE','V V I',NBNO2T,IACOSE)
      CALL WKVECT('&&ECLPGM.GEOSE','V V R',NBNO2T*DIMGEO,IAGESE)
      CALL WKVECT('&&ECLPGM.NBNO2','V V I',NBPG,IANNO2)

      IF (NBPG.EQ.0) CALL U2MESS('F','CALCULEL2_36')
      CALL WKVECT(MA2//'.TYPMAIL','G V I',NBPG,IATYPM)



C     3. ON CALCULE DES COORDONNEES DES SOUS-ELEMENTS
C        ET LEUR CONNECTIVITE
C     ---------------------------------------------------------------

      NUPG   = 0
      NUPOIN = 0
      NUNO2  = 0
      DO 2,IGR = 1,NBGREL(LIGREL)
         TE = TYPELE(LIGREL,IGR)
         NBELGR = NBELEM(LIGREL,IGR)
         CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

         IF ( NCH .NE. 0 ) THEN
            NUMA   = NUMAIL(IGR,1)
            ELREFA = ZK16(JOBJ-1+NUMA)(1:8)
            FAPG   = ZK16(JOBJ-1+NUMA)(9:16)
         ELSE
            FAMIL = 'RIGI'
            CALL ECLAU1 ( NOMTE, FAMIL, ELREFA, FAPG )
         ENDIF
         IF ( FAPG .EQ. ' ' ) GOTO 2

         CALL ECLATY ( NOMTE, ELREFA, FAPG, NPG1, NPOINI,
     &                 NTERM1, NSOMM1, CSOMM1, TYMA, NBNO2, CONNX,
     &                 MXNBN2, MXNBPG, MXNBPI, MXNBTE )
         IF (NPG1.EQ.0) GO TO 2

         DO 3,IEL = 1,NBELGR
C          ON RECUPERE LE NUMERO DE LA MAILLE ET LE NUMERO
C          DE SES SOMMETS :
           IMA = NUMAIL(IGR,IEL)
           DO 31,INO1=1,NBNOMA(IMA)
             TABNO(INO1)=NUMGLM(IMA,INO1)
31         CONTINUE

C          -- CALCUL DES COORDONNEES DES POINT_I :
           DO 32,IPOINI=1,NPOINI
             NUPOIN=NUPOIN+1
             DO 33,K=1,DIMGEO
               X=0.D0
               DO 34,ITERM=1,NTERM1(IPOINI)
                 X=X+CSOMM1(IPOINI,ITERM)*
     &             ZR(IACOOR-1+3*(TABNO(NSOMM1(IPOINI,ITERM))-1)+K)
34             CONTINUE
               ZR(IAGEPI-1+(NUPOIN-1)*DIMGEO+K)=X
33           CONTINUE
32         CONTINUE

C          -- STOCKAGE DES NUMEROS DES POINT_I DES SOUS-ELEMENTS
C             ET DE LEURS COORDONNEES :
           DO 40,IPG=1,NPG1
             NUPG=NUPG+1
             ZI(IATYPM-1+NUPG)=TYMA(IPG)
             ZI(IANNO2-1+NUPG)=NBNO2(IPG)
             NNO2=NBNO2(IPG)
             DO 41, INO2=1,NNO2
               NUNO2=NUNO2+1
               ZI(IACOSE-1+NUNO2)=CONNX(INO2,IPG)+
     &            NUPOIN-NPOINI
                  NUPOI2=ZI(IACOSE-1+NUNO2)
                  DO 779,K=1,DIMGEO
                     ZR(IAGESE-1+(NUNO2-1)*DIMGEO+K)=
     &               ZR(IAGEPI-1+(NUPOI2-1)*DIMGEO+K)
779               CONTINUE
41           CONTINUE
C           DANS LE CAS DU QUADRILATERE ON CONTROLE L'APPLATISSEMENT
             IF (NNO2.EQ.4) THEN
               CALL ECLAPP(DIMGEO,NNO2,LONMIN,
     &                     ZR(IAGESE+(NUNO2-4)*DIMGEO))
             END IF
40         CONTINUE

3        CONTINUE
2     CONTINUE

      CALL JEDETR ( NOMOBJ )

C     3. CONSTRUCTION DES OBJETS DU MAILLAGE RESULTAT :
C     -------------------------------------------------
      NBMAIL=NBPG
      NBNOEU=NBNO2T
      NBCOOR=DIMGEO

C     3.1 CREATION DE L'OBJET .DIME  :
C     ------------------------------------
      CALL WKVECT(MA2//'.DIME','G V I',6,IADIME)
      ZI(IADIME-1+1)= NBNOEU
      ZI(IADIME-1+3)= NBMAIL
      ZI(IADIME-1+6)= NBCOOR


C     3.2 CREATION DES OBJETS .NOMNOE ET .NOMMAI :
C     --------------------------------------------
      CALL JECREO(MA2//'.NOMNOE','G N K8')
      CALL JEECRA(MA2//'.NOMNOE','NOMMAX',NBNOEU,' ')
      CALL JECREO(MA2//'.NOMMAI','G N K8')
      CALL JEECRA(MA2//'.NOMMAI','NOMMAX',NBMAIL,' ')

      NOM(1:1)='N'
      DO 51,K=1,NBNOEU
          CALL CODENT(K,'G',NOM(2:8))
          CALL JECROC(JEXNOM(MA2//'.NOMNOE',NOM))
51    CONTINUE
      NOM(1:1)='M'
      DO 52,K=1,NBMAIL
          CALL CODENT(K,'G',NOM(2:8))
          CALL JECROC(JEXNOM(MA2//'.NOMMAI',NOM))
52    CONTINUE


C     3.3 CREATION DES OBJETS  .CONNEX ET .TYPMAIL
C     ---------------------------------------------
      CALL JECREC(MA2//'.CONNEX','G V I','NU','CONTIG',
     &            'VARIABLE',NBMAIL)
      CALL JEECRA(MA2//'.CONNEX','LONT',NBNOEU,' ')
      CALL JEVEUO(MA2//'.CONNEX','E',IBID)

      NUNO2=0
      DO 53,IMA=1,NBMAIL
        NNO2=ZI(IANNO2-1+IMA)
        CALL JECROC(JEXNUM(MA2//'.CONNEX',IMA))
        CALL JEECRA(JEXNUM(MA2//'.CONNEX',IMA),'LONMAX',NNO2,KBID)
        DO 54,INO2=1,NNO2
          NUNO2=NUNO2+1
          ZI(IBID-1+NUNO2)=NUNO2
54      CONTINUE
53    CONTINUE



C     3.4 CREATION DU CHAMP DE GEOMETRIE (.COORDO)
C     ---------------------------------------------
      CALL COPISD('CHAMP_GD','G',MA1//'.COORDO',MA2//'.COORDO')
      CALL JEDETR(MA2//'.COORDO    .VALE')
      CALL WKVECT(MA2//'.COORDO    .VALE','G V R',3*NBNOEU,IBID)
      CALL JEVEUO(MA2//'.COORDO    .REFE','E',JREFE)
      ZK24(JREFE-1+1)=MA2

      DO 56,K=1,DIMGEO
        NUNO2=0
        DO 57,IMA=1,NBMAIL
          NNO2=ZI(IANNO2-1+IMA)
C         -- ON FAIT UN PETIT "SHRINK" SUR LES MAILLES :
          XC=0.D0
          DO 58,INO=1,NNO2
            NUNO2=NUNO2+1
            XC= XC+ZR(IAGESE-1+(NUNO2-1)*DIMGEO+K)/DBLE(NNO2)
58        CONTINUE
          NUNO2=NUNO2-NNO2

          DO 59,INO=1,NNO2
            NUNO2=NUNO2+1
            XM= ZR(IAGESE-1+(NUNO2-1)*DIMGEO+K)
            XM=XC+SHRINK*(XM-XC)
            ZR(IBID-1+(NUNO2-1)*3+K)=XM
59        CONTINUE
57      CONTINUE
56    CONTINUE


C
      CALL JEDETR ('&&ECLPGM.NOMOBJ')
      CALL JEDETR ('&&ECLPGM.GEOPOINI')
      CALL JEDETR ('&&ECLPGM.CONNEXSE')
      CALL JEDETR ('&&ECLPGM.GEOSE')
      CALL JEDETR ('&&ECLPGM.NBBO2')
      CALL JEDEMA()
C
 9999 CONTINUE
C FIN ------------------------------------------------------------------
      END
