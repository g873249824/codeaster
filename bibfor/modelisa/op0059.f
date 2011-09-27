      SUBROUTINE OP0059()
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/09/2011   AUTEUR PROIX J-M.PROIX 
C RESPONSABLE JMBHH01 J.M.PROIX
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     COMMANDE:  DEFI_COMPOR
      CHARACTER*8 COMPOR, MATERI, TYPPAR(5),MONO
      CHARACTER*16 OPER, TYPE, NOMPAR(5), ECOULE, ECROIS, ECROCI,ELASTI
      CHARACTER*16 FASYGL, KBID, NOMS(6),COMDES,LOCA,ROTA,TBINTE,SYSTGL
      CHARACTER*19 LISTR
      REAL*8  MS(6),NG(3),Q(3,3),LG(3)
      REAL*8 PGL(3,3),FVOL,ORIE(3),DL,DA,EULER(3)
      REAL*8 FVOLT
      COMPLEX*16 CBID
      INTEGER IOCC, NBMAT, NBECOU, NBECRO, NBCINE, NBELAS, NBFASY
      INTEGER TABDES(13),NLOC,NBOCCP,NBOCCM,NDL,NDA,ITBINT
      INTEGER I,J,NBELA1, NBSYS, NVI,NMONO,IMK,IMI,IPK,IPI,IPR,IORIE
      INTEGER NCPRI,NCPRK,NCPRR,JCPRK,JCPRR,JCPRI,NVIT,LMK,IFVOL,IPL
      INTEGER IMONO,NBMONO,INDIK8,NVLOC,IR,IROTA,IDBOR,IADLR
      INTEGER NBTBSY,NBFSYS,DECAL,IMR,IFA
      CHARACTER*1 K1BID
      INTEGER NBOCCI,IBID,NBG,NBGMAX,IMG,IG,IG1,JNFG,IAFF,ITAB,ITSG
      INTEGER NBVF,NBV,ICP,NBKIT,NBNVI(2),NCOMEL,NUMLC,NBROTA,NBSYST
      CHARACTER*8 SDGF,K8BID,KGROUP,MATOR
      CHARACTER*16 NOMREL,ALGO1D,DEFO,NOMKIT(2),LCOMEL(5),COMCOD,MOCLEF
      CHARACTER*24 VNBFIG,RNOMGF
C     POUR MONOCRISTAL) DIMENSIONS MAX
C        NSG=NOMBRE DE SYSTEMES DE GLISSEMENT MAXIMUM
C        NFS=NOMBRE DE FAMILLES DE SYSTEMES DE GLISSEMENT MAXIMUM
      INTEGER       NSG,NFS
      PARAMETER      ( NSG=30)
      PARAMETER      ( NFS=5)
      REAL*8        HSR(NFS,NSG,NSG)

C ----- DEBUT --- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON / IVARJE / ZI(1)
      REAL*8 ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16 ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER      IARG, INDTAB,IFM,NIV

C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CALL JEMARQ()
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
      CALL GETRES(COMPOR,TYPE,OPER)
      CALL GETFAC('MONOCRISTAL',NBOCCM)
      CALL GETFAC('POLYCRISTAL',NBOCCP)
      CALL GETFAC('MULTIFIBRE',NBOCCI)

      IF (NBOCCM.GT.0) THEN
         COMDES='&&OP0059.TABLETX'
         CALL TBCRSD(COMDES,'V')
         NOMPAR(1)='FAMI_SYST_GLIS'
         NOMPAR(2)='MAT_SYST'
         NOMPAR(3)='ECOULEMENT'
         NOMPAR(4)='ECRO_ISOT'
         NOMPAR(5)='ECRO_CINE'
         TYPPAR(1)='K16'
         TYPPAR(2)='K16'
         TYPPAR(3)='K16'
         TYPPAR(4)='K16'
         TYPPAR(5)='K16'
         NBSYST=0
         NBELAS=0
         NVI=6
C       DEFORMATION PLASTIQUE CUMULEE MACROSCOPIQUE EQUIVALENTE
         NVI=NVI+1
         CALL TBAJPA(COMDES, 5,NOMPAR,TYPPAR)
         CALL GETFAC('MONOCRISTAL',NBOCCM)
         CALL WKVECT(COMPOR//'.CPRK', 'G V K16',5*NBOCCM+1,IMK)
         NCPRR=1800
         CALL WKVECT(COMPOR//'.CPRR', 'G V R',NCPRR,IPR)         
         INDTAB=0
         DO 101 I=1,13
            TABDES(I)=0
 101     CONTINUE         
         DO 9 IOCC=1,NBOCCM
            CALL GETVID('MONOCRISTAL','MATER',IOCC,IARG,1,MATERI,NBMAT)
            CALL GETVTX('MONOCRISTAL','ECOULEMENT',IOCC,IARG,1,ECOULE,
     &                   NBECOU)
            CALL GETVTX('MONOCRISTAL','ECRO_ISOT',IOCC,IARG,1,ECROIS,
     &                   NBECRO)
            CALL GETVTX('MONOCRISTAL','ECRO_CINE',IOCC,IARG,1,ECROCI,
     &                   NBCINE)
            CALL GETVTX('MONOCRISTAL','ELAS',IOCC,IARG,1,ELASTI,NBELA1)
            IF (NBELA1.GT.0) THEN
               IF (NBELAS.EQ.0) THEN
                  NBELAS=1
               ELSE
                  CALL U2MESS('F','MODELISA5_64')
               ENDIF
            ENDIF
C           CAS DES LOIS DD
            IF (ECOULE(1:7).EQ.'MONO_DD')  THEN
               ECROIS=ECOULE
               ECROCI=' '
            ENDIF
            CALL GETVTX('MONOCRISTAL','FAMI_SYST_GLIS',IOCC,IARG,1,
     &                   FASYGL,NBFASY)
            NOMS(1)=FASYGL
            NOMS(2)=MATERI
            NOMS(3)=ECOULE
            NOMS(4)=ECROIS
            NOMS(5)=ECROCI
            IF (FASYGL.EQ.'UTILISATEUR') THEN
C              VERIF QU'IL Y SEULEMENT UNE FAMILLE DE SYSTEMES
               IF (NBOCCM.NE.1) THEN
                  CALL U2MESG('F','COMPOR2_16',0,' ',1,NBOCCM,0,0.D0)
               ENDIF
               CALL GETVID('MONOCRISTAL','TABL_SYST_GLIS',IOCC,IARG,1,
     &                      SYSTGL,ITSG)
               NOMS(1)='UTIL'
               CALL CODENT(IOCC,'G',NOMS(1)(5:5))
               NOMS(1)(6:8)='___'
               NOMS(1)(9:16)=SYSTGL(1:8)
               FASYGL=NOMS(1)
               LISTR = '&&LCMMAT.TABL_SYSGL'
               CALL TBEXLR ( SYSTGL, LISTR, 'V' )
               CALL JEVEUO ( LISTR//'.VALE' , 'L', IADLR )
               NBSYS=NINT(ZR(IADLR+2))
C              VERIF QUE LA MATRICE EST CARREE
               IF (6.NE.ZR(IADLR+1)) THEN
                  CALL U2MESG('F','COMPOR2_19',0,' ',0,0,1,ZR(IADLR+1))
               ENDIF
               CALL DCOPY(6*NBSYS,ZR(IADLR+3),1,ZR(IPR+INDTAB),1)
               TABDES(8+IOCC)=NBSYS
               CALL JEDETC('V',LISTR,1 )
               
               WRITE(IFM,*) ' TABLE SYSTEMES DE GLISSEMENT FAMILLE',IOCC
               WRITE(IFM,*) ' NX     NY     NZ     MX     MY     MZ '
               DO 4 I=1,NBSYS
                  WRITE(IFM,'(I2,6(1X,E11.4))') 
     &                  I,(ZR(IPR-1+INDTAB+6*(I-1)+J),J=1,6)
 4             CONTINUE
               INDTAB=INDTAB+6*NBSYS 
            ELSE
               IR=0
               CALL LCMMSG(FASYGL,NBSYS,0,PGL,MS,NG,LG,IR,Q)
            ENDIF
            CALL TBAJLI(COMDES,5, NOMPAR,0,0.D0,CBID,NOMS,0)
            DO 11 J=1,5
               ZK16(IMK-1+(IOCC-1)*5+J)=NOMS(J)
11          CONTINUE
            IR=0
            NVI=NVI+3*NBSYS
            NBSYST=NBSYST+NBSYS
9        CONTINUE
C        INDICATEUR PLASTIQUE
         NVI=NVI+1
C        CONTRAINTE DE CLIVAGE MAX
         NVI = NVI+1
C        ROTATION DE RESEAU
         CALL GETVTX(' ','ROTA_RESEAU',0,IARG,1,ROTA,NBROTA)
         IROTA=0
         IF (NBROTA.NE.0) THEN
             IF (ROTA.NE.'NON') THEN
                 NVI = NVI+16
                 IF (ROTA.EQ.'POST') IROTA=1
                 IF (ROTA.EQ.'CALC') IROTA=2
             ENDIF
         ENDIF
         ZK16(IMK+5*NBOCCM)=ELASTI
         CALL GETVID(' ','MATR_INTER',0,IARG,1,TBINTE,ITAB)
         IF (ITAB.NE.0) THEN
            LISTR = '&&LCMMAT.TABL_INTER'
            CALL TBEXLR ( TBINTE, LISTR, 'V' )
            CALL JEVEUO ( LISTR//'.VALE' , 'L', IADLR )
C           VERIF QUE LA MATRICE EST CARREE
            IF (ZR(IADLR+1).NE.ZR(IADLR+2)) THEN
               CALL U2MESG('F','COMPOR2_15',0,' ',0,0,2,ZR(IADLR+1))
            ENDIF
C           VERIF QU'IL Y SEULEMENT UNE FAMILLE DE SYSTEMES
            IF (NBOCCM.NE.1) THEN
               CALL U2MESG('F','COMPOR2_16',0,' ',1,NBOCCM,0,0.D0)
            ENDIF
C           VERIF QUE LE NB DE SYST EST OK
            IF (ZR(IADLR+1).NE.NBSYST) THEN
               CALL U2MESG('F','COMPOR2_17',0,' ',1,NBSYST,0,0.D0)
            ENDIF
            CALL DCOPY(NBSYST*NBSYST,ZR(IADLR+3),1,ZR(IPR+INDTAB),1)
C           VERIF QUE LA MATRICE EST SYMETRIQUE
            DO 5 I=1,NBSYST
            DO 5 J=1,NBSYST
               IF (ZR(IPR-1+INDTAB+NBSYS*(I-1)+J).NE.
     &             ZR(IPR-1+INDTAB+NBSYS*(J-1)+I)) THEN
                  CALL U2MESS('F','COMPOR2_18')
               ENDIF
 5          CONTINUE
            CALL JEDETC('V',LISTR,1 )
            WRITE(IFM,*) ' MATRICE INTERACTION UTILISATEUR'
            DO 6 I=1,NBSYS
               WRITE(IFM,'(I2,12(1X,E11.4))') 
     &               I,(ZR(IPR-1+INDTAB+NBSYS*(I-1)+J),J=1,NBSYS)
 6          CONTINUE
         ENDIF
         TABDES(1)=1
         TABDES(2)=1
         TABDES(3)=NVI
         TABDES(4)=ITAB
         TABDES(5)=NBOCCM
         TABDES(6)=IROTA
         TABDES(7)=NVI
         TABDES(8)=NBSYST         
C organisation de CPRI :
C        1 : TYPE =1 pour MONOCRISTAL
C        2 : NBPHAS=1 pour MONOCRISTAL
C        3 : NVI
C        4 : NOMBRE DE MONOCRISTAUX diff�rents  =1
C        5 : NBFAMILLES DE SYS GLIS
C        6 : 1 si ROTA=POST, 2 si CALC, 0 sinon
C        7 : NVI
C        8 : NOMBRE DE SYSTEMES DE GLISSEMENT TOTAL
         CALL WKVECT(COMPOR//'.CPRI', 'G V I',13,IMI)
         DO 999 I=1,13
            ZI(IMI+I-1)=TABDES(I)
999      CONTINUE
         CALL JEDETC('V',COMDES,1)

      ELSEIF (NBOCCP.GT.0) THEN

         CALL GETVTX(' ','LOCALISATION',0,IARG,1,LOCA,NLOC)
         DL=0.D0
         DA=0.D0
         NVLOC=0
         IF (LOCA.EQ.'BETA') THEN
           CALL GETVR8(' ','DL',0,IARG,1,DL,NDL)
           CALL GETVR8(' ','DA',0,IARG,1,DA,NDA)
           NVLOC=2
         ENDIF
         NCPRK=0
C organisation de CPRI :
C        1 : TYPE =2 pour POLYCRISTAL
C        2 : NBPHAS pour POLYCRISTAL
C        3 : NVITOT pour POLYCRISTAL
C        4 : NOMBRE DE MONOCRISTAUX diff�rents
C        5 : NBFAMILLES DE SYS GLIS pour Phase 1
C        6 : Numero du MONO 1
C        7 : NVI du Mono 1
C        8 : NBFAMILLES DE SYS GLIS pour Phase 2
C        9 : Numero du MONO 2
C        10 : NVI du Mono 2
C         etc...
C        avant dernier : dimension de CPRK
C        nombre de param�tres de localisation
         NCPRI=4+3*NBOCCP+1+1 +1
         CALL WKVECT(COMPOR//'.CPRI', 'G V I',NCPRI,IPI)
         ZI(IPI)=2
         ZI(IPI+1)=NBOCCP

         CALL WKVECT('&&OP0059.LISTEMONO','V V K8',NBOCCP,IPL)
         NBMONO=0
         DO 13 IOCC=1,NBOCCP
            CALL GETVID('POLYCRISTAL','MONOCRISTAL',IOCC,IARG,1,MONO,
     &                   NMONO)
C  On ne stocke pas les doublons
            IMONO=INDIK8(ZK8(IPL),MONO,1,NBMONO)
            IF (IMONO.EQ.0) THEN
               NBMONO=NBMONO+1
               ZK8(IPL-1+NBMONO)=MONO
               ZI(IPI-1+4+3*(IOCC-1)+2)=NBMONO
               CALL JELIRA(MONO//'.CPRK','LONMAX',LMK,KBID)
               NCPRK=NCPRK+LMK+2
            ELSE
               ZI(IPI-1+4+3*(IOCC-1)+2)=IMONO
            ENDIF
  13     CONTINUE
         NCPRK=NCPRK+1
         ZI(IPI-1+4)=NBMONO
C organisation de CPRK :
C      On ne stocke que les monocristaux DIFFERENTS
C        1   : Nom m�thode localisation
C        2   : Nom Monocristal 1 + NBFAM + CPRK du monocristal 1
C        n+2 : Nom Monocristal 2 + NBFAM + CPRK du monocristal 2
C       ...: etc...
         CALL WKVECT(COMPOR//'.CPRK', 'G V K16',NCPRK,IPK)
         JCPRK=1
         ITBINT=0
         DO 15 IMONO=1,NBMONO
            MONO=ZK8(IPL-1+IMONO)
            CALL JELIRA(MONO//'.CPRK','LONMAX',LMK,KBID)
            CALL JEVEUO(MONO//'.CPRK','L',IMK)
            CALL JEVEUO(MONO//'.CPRI','L',IMI)
C           RECOPIE DU VECTEUR K16 DU MONOCRISTAL DANS CELUI DU POLY
            ZK16(IPK-1+JCPRK+1)=MONO
            WRITE(ZK16(IPK-1+JCPRK+2),'(I16)') ZI(IMI-1+5)
            DO 14 I=1,LMK
               ZK16(IPK-1+JCPRK+2+I)=ZK16(IMK-1+I)
 14         CONTINUE
            JCPRK=JCPRK+LMK+2
            IF (ZI(IMI-1+4).NE.0) ITBINT=ITBINT+1
            NBTBSY=0
            NBFSYS=ZI(IMI-1+5)
            DO 3 IFA=1,NBFSYS
               NBTBSY=NBTBSY+ZI(IMI-1+8+IFA)
 3          CONTINUE
            IF (ITBINT.GT.0) THEN
               DECAL=6*NBTBSY
               CALL JEVEUO(MONO//'.CPRR','L',IMR)
               NBSYST=ZI(IMI-1+8)
               CALL DCOPY(NBSYST*NBSYST,ZR(IMR+DECAL),1,HSR,1)
            ELSE
               NBSYST=0
            ENDIF
 15      CONTINUE
         CALL ASSERT(ITBINT.LE.1)
C organisation de CPRR :
C        1 : Fraction volumique Phase 1
C        2 : angle d'Euler 1 phase 1
C        3 : angle d'Euler 2 phase 1
C        4 : angle d'Euler 3 phase 1
C        5 : Fraction volumique Phase 2
C        6 : angle d'Euler 1 phase 2
C        7 : angle d'Euler 2 phase 2
C        8 : angle d'Euler 3 phase 2
C        .. : etc..
C        n-1 : Variable localisation (ex : DA pour BETA)
C        n  :  Variable localisation (ex : DL pour BETA)
         NCPRR=4*NBOCCP+2
         IF (ITBINT.EQ.1) NCPRR=NCPRR+NBSYST*NBSYST
         CALL WKVECT(COMPOR//'.CPRR', 'G V R',NCPRR,IPR)
         JCPRR=0
         JCPRI=4
         NVIT=0
         FVOLT=0.D0
         DO 16 IOCC=1,NBOCCP
            IMONO=ZI(IPI-1+4+3*(IOCC-1)+2)
            MONO=ZK8(IPL-1+IMONO)
            CALL JEVEUO(MONO//'.CPRI','L',IMI)
            ZI(IPI-1+JCPRI+1)=ZI(IMI-1+5)
            ZI(IPI-1+JCPRI+3)=ZI(IMI-1+7)
C           NOMBRE DE VAR INT MONO + 6 (TENSEUR BETA OU EPSG)
C           On enl�ve 3 v.i. de chaque monocristal
C           nombre de variables internes par phase
C           6+3*Ns+6 = (Evp + Ns(alphas, gammas, ps) +  Sig)
            NVIT=NVIT-3+ZI(IMI-1+7)+6
            JCPRI=JCPRI+3
            CALL GETVR8('POLYCRISTAL','FRAC_VOL',IOCC,IARG,1,FVOL,
     &                   IFVOL)
            CALL GETVR8('POLYCRISTAL','ANGL_REP',IOCC,IARG,3,ORIE,
     &                   IORIE)
            IF (IORIE.EQ.0) THEN
                CALL GETVR8('POLYCRISTAL','ANGL_EULER',IOCC,IARG,3,
     &                      EULER,
     &                   IORIE)
                CALL EULNAU(EULER,ORIE)
            ENDIF
            FVOLT=FVOLT+FVOL
            ZR(IPR-1+JCPRR+1)=FVOL
            ZR(IPR-1+JCPRR+2)=ORIE(1)
            ZR(IPR-1+JCPRR+3)=ORIE(2)
            ZR(IPR-1+JCPRR+4)=ORIE(3)
            JCPRR=JCPRR+4
 16      CONTINUE
         IF (ABS(FVOLT-1.D0).GT.1.D-3) THEN
            CALL U2MESR ('F', 'COMPOR2_8', 1, FVOLT)
         ENDIF
         ZR(IPR-1+JCPRR+1)=DL
         ZR(IPR-1+JCPRR+2)=DA
         IF (ITBINT.EQ.1) THEN
            CALL DCOPY(NBSYST*NBSYST,HSR,1,ZR(IPR-1+JCPRR+3),1)
         ENDIF         
C         NOMBRE DE VAR INT TOTAL + 8 (TENSEUR B OU EVP + NORME+INDIC)
         ZI(IPI-1+3)=NVIT+8
         ZI(IPI-1+NCPRI-2)=JCPRK
         ZI(IPI-1+NCPRI-1)=NVLOC
C        ON STOCKE EN DERNIER LE NOMBRE DE SYST POUR HSR DONNEE, 0 SINON
         ZI(IPI-1+NCPRI)=NBSYST
         ZK16(IPK)=LOCA

C  MULTIFIBRE
C organisation de CPRK :
C      On ne stocke les noms des groupes, materiau, relation, algo,
C      defo et nb de fibre pour chaque groupe
      ELSEIF(NBOCCI.GT.0)THEN
C on recupere les renseignements dans la SD_GROUP_FIBRE :
C noms de tous les groupes, nb maxi de groupes, nb de fibres par groupe
        NBVF=0
        MOCLEF='MULTIFIBRE'
        CALL GETVID(' ','GEOM_FIBRE',0,IARG,1,SDGF,IBID)
        VNBFIG = SDGF//'.NB_FIBRE_GROUPE'
        RNOMGF = SDGF//'.NOMS_GROUPES'
        CALL JEVEUO(VNBFIG,'L',JNFG)
        CALL JELIRA(VNBFIG,'LONMAX',NBGMAX,K1BID)
        CALL WKVECT(COMPOR//'.CPRK','G V K16',6*NBGMAX+1,IMK)
        CALL WKVECT('&&OP0059.NOMS_GROUPES', 'V V K8',NBGMAX,IMG)
        CALL WKVECT('&&OP0059.VERIF_AFFECT', 'V V I',NBGMAX,IAFF)
        DO 50 IG=1,NBGMAX
           ZI(IAFF-1+IG)=0
 50     CONTINUE
        DO 25 IOCC=1,NBOCCI
          CALL GETVTX(MOCLEF,'GROUP_FIBRE',IOCC,IARG,0,K8BID,NBG)
          NBG=-NBG
          CALL GETVTX(MOCLEF,'GROUP_FIBRE',IOCC,IARG,NBG,ZK8(IMG),
     &                   IBID)
          CALL GETVID(MOCLEF,'MATER',IOCC,IARG,1,MATERI,IBID)
          CALL GETVTX(MOCLEF,'RELATION',IOCC,IARG,1,NOMREL,IBID)

          NCOMEL=1
          LCOMEL(NCOMEL)=NOMREL
C         POUR COMPORTEMENTS KIT_DDI A COMPLETER
          CALL NMDOKI(MOCLEF,' ',NOMREL,IOCC,2,NBKIT,NOMKIT,
     &                NBNVI,NCOMEL,LCOMEL,NUMLC,NBV)

C         SAISIE ET VERIFICATION DU TYPE DE DEFORMATION UTILISEE
          CALL NMDOGD(MOCLEF,NOMREL,IOCC,NCOMEL,LCOMEL,DEFO)

C         SAISIE ET VERIFICATION DE DEBORST
          CALL NMDOCP(MOCLEF,NOMREL,IOCC,NCOMEL,LCOMEL,ALGO1D)

C         APPEL A LCINFO POUR RECUPERER LE NOMBRE DE VARIABLES INTERNES
          CALL LCCREE(NCOMEL, LCOMEL, COMCOD)
          CALL LCINFO(COMCOD, NUMLC, NBV)

          DO 27 IG=1,NBG
C numero correspondant au nom
            CALL JENONU(JEXNOM(RNOMGF,ZK8(IMG+IG-1)),IG1)
            IF(IG1.EQ.0)THEN
              CALL U2MESK('F','MODELISA8_8',1,ZK8(IMG+IG-1))
            ENDIF
            ICP=IMK-1+(IG1-1)*6
            ZK16(ICP+1  )=ZK8(IMG+IG-1)
            ZK16(ICP+2)=MATERI
            ZK16(ICP+3)=NOMREL
            ZK16(ICP+4)=ALGO1D
            ZK16(ICP+5)=DEFO
            WRITE(ZK16(ICP+6),'(I16)')ZI(JNFG-1+IG1)
            ZI(IAFF-1+IG1)=1
 27       CONTINUE
C on met � jour le nombre de variables internes maxi
          NBVF=MAX(NBVF,NBV)
 25     CONTINUE
C verification de l'utilisation de comp_1d en lien avec fiche 15176
        IF (NBOCCI.GT.1) THEN
          IDBOR=0
          DO 28 IOCC=1,NBOCCI
            ALGO1D=' '
            CALL GETVTX(MOCLEF,'ALGO_1D',IOCC,IARG,1,ALGO1D,IBID)
            IF (ALGO1D.EQ.'DEBORST') IDBOR=IDBOR+1
 28       CONTINUE
          IF (IDBOR.GE.1) CALL U2MESS('F','COMPOR1_15')
        ENDIF
C Verif tout affecte au moins une fois
C On marque par VIDE les groupes non affectes
        DO 51 IG=1,NBGMAX
          IF(ZI(IAFF-1+IG).EQ.0)THEN
            CALL JENUNO(JEXNUM(RNOMGF,IG),KGROUP)
            ICP=IMK-1+(IG-1)*6
            ZK16(ICP+1  )=KGROUP
            ZK16(ICP+2)='VIDE'
          ENDIF
 51     CONTINUE
C On recupere le nom du materiau pour la torsion et on le met � la fin
        CALL GETVID(' ','MATER_SECT',0,IARG,1,MATOR,IBID)
        ZK16(IMK-1+NBGMAX*6+1)=MATOR
        CALL WKVECT(COMPOR//'.CPRI', 'G V I',3,IMI)
C type 3 = multifibre
        ZI(IMI)=3
        ZI(IMI+1)=NBVF
        ZI(IMI+2)=NBGMAX
      ENDIF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
