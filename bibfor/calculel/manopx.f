      SUBROUTINE MANOPX(LIGREL,OPTION,PARAM,CHSGEO,EXIXFM,KECONO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE GENIAUT S.GENIAUT
      IMPLICIT NONE
      CHARACTER*19 LIGREL,CHSGEO
      CHARACTER*16 OPTION
      CHARACTER*8 PARAM
      CHARACTER*3 EXIXFM
      CHARACTER*24 KECONO
C ------------------------------------------------------------------
C BUT: REGARDER DANS LE LIGREL S'IL Y A DES ELEMENTS XFEM
C      ET SI LE CHAMP ELGA (OPTION/PARAM) UTILISE UNE FAMILLE XFEM..
C
C      * CALCULER UN OBJET (KECONO) DISANT SI CHAQUE GREL
C          PEUT ETRE STOCKE "ECONOMIQUE"
C      SI FAMILLE XFEM :
C        * CALCULER LE CHAMP SIMPLE CHSGEO CONTENANT LES COORDONNNEES
C          DES POINTS DE GAUSS DES FAMILLES XFEM...
C ------------------------------------------------------------------
C     ARGUMENTS:
C     ----------
C LIGREL  IN/JXIN  K19 : LIGREL
C OPTION,PARAM  IN  K* : OPTION ET PARAMETRE PERMETTANT DE DETERMINER
C                        LA FAMILLE DE PG UTILISEE.
C EXIXFM  OUT K3 : 'OUI' : IL EXISTE DES GRELS AVEC FAMILLE XFEM...
C                  'NON' SINON
C KECONO  IN/JXOUT K24 : VECTEUR D'ENTIERS LONG=NBGREL(LIGREL)
C      V(IGR) = 1 : LE GREL IGR UTILISE UNE FAMILLE XFEM...
C             = 0 SINON
C CHSGEO  IN/JXOUT K19 : CHAM_ELEM_S (GEOM_R) DE TYPE 'ELGA'

C REMARQUE :
C   L'OBJET CHSGEO N'EST CREE QUE SI EXIXFM='OUI'
C ------------------------------------------------------------------

C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------

      INTEGER      NBOUT,NBIN
      PARAMETER   (NBOUT=1, NBIN=6)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)

      INTEGER IBID,IOPT,IOPT1,NUTE,NUMC,IGR,NUCALC,NBGREL
      INTEGER JECONO,IMOLO,JMOLO,NEC,KFPG,IERD,MODAT2
      INTEGER IGD,JPNLFP,NBLFPG,JNOLFP,TYPELE,NBFAM,JFPGL
      INTEGER K,NUFLPG,NUFGPG,INDK32
      CHARACTER*1 KBID
      CHARACTER*8 NOMGD,ELREFE,MA,MO
      CHARACTER*16 NOFPG,NOMTE
      CHARACTER*24 CHGEOM
      CHARACTER*32 NOFLPG
C     ------------------------------------------------------------------
      CALL JEMARQ()

      CALL DISMOI('F','NOM_MAILLA',LIGREL,'LIGREL',IBID,MA,IBID)
      CALL DISMOI('F','NOM_MODELE',LIGREL,'LIGREL',IBID,MO,IBID)
      CALL JELIRA(LIGREL//'.LIEL','NMAXOC',NBGREL,KBID)

      CALL JEVEUO('&CATA.TE.PNLOCFPG','L',JPNLFP)
      CALL JELIRA('&CATA.TE.NOLOCFPG','LONMAX',NBLFPG,KBID)
      CALL JEVEUO('&CATA.TE.NOLOCFPG','L',JNOLFP)


C     1. CALCUL DE KECONO ET EXIXFM :
C     ------------------------------------------------------------------
      EXIXFM='NON'
      CALL WKVECT(KECONO,'V V I', NBGREL, JECONO)
      DO 1, IGR=1,NBGREL
         ZI(JECONO-1+IGR)=1
 1    CONTINUE
      CALL JENONU(JEXNOM('&CATA.OP.NOMOPT','XFEM_XPG'),IOPT1)
      CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',OPTION),IOPT)
      DO 2, IGR=1,NBGREL
        NUTE = TYPELE(LIGREL,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTE),NOMTE)

C       L'ELEMENT SAIT-IL CALCULER XFEM_XPG ?
        NUMC = NUCALC(IOPT1,NUTE,1)
        IF (NUMC.LT.0) GO TO 2

        IMOLO = MODAT2(IOPT,NUTE,PARAM)
        IF (IMOLO.EQ.0) GO TO 2

        CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',IMOLO),'L',JMOLO)
        IGD = ZI(JMOLO-1+2)
        CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',IGD),NOMGD)
        CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,KBID,IERD)
        KFPG = ZI(JMOLO-1+4+NEC+1)

C       -- FAMILLE "LISTE"
        IF (KFPG.LT.0) THEN
C          FAMILLE "LISTE" :
           CALL JELIRA(JEXNUM('&CATA.TE.FPG_LISTE',-KFPG),'LONMAX',
     &                 NBFAM,KBID)
           NBFAM=NBFAM-1
           CALL JEVEUO(JEXNUM('&CATA.TE.FPG_LISTE',-KFPG),'L',JFPGL)
           ELREFE=ZK8(JFPGL-1+NBFAM+1)
           DO 3,K=1,NBFAM
              NOFLPG = NOMTE//ELREFE//ZK8(JFPGL-1+K)
              NUFLPG = INDK32(ZK32(JPNLFP),NOFLPG,1,NBLFPG)
              NUFGPG = ZI(JNOLFP-1+NUFLPG)
              CALL JENUNO(JEXNUM('&CATA.TM.NOFPG',NUFGPG),NOFPG)
              IF (NOFPG(9:12).EQ.'XFEM') THEN
                EXIXFM='OUI'
                ZI(JECONO-1+IGR)=0
              ENDIF
3         CONTINUE

C       -- FAMILLE "ORDINAIRE"
        ELSE
           CALL JENUNO(JEXNUM('&CATA.TM.NOFPG',KFPG),NOFPG)
           IF (NOFPG(9:12).EQ.'XFEM') THEN
              EXIXFM='OUI'
              ZI(JECONO-1+IGR)=0
           ENDIF
        END IF

2     CONTINUE
      IF (EXIXFM.EQ.'NON')  GO TO 9999


C     2. CALCUL DE CHSGEO :
C     ------------------------------------------------------------------
      CHGEOM='&&MANOPX.CHGEOM'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = MA//'.COORDO'
      LPAIN(2) = 'PPINTTO'
      LCHIN(2) = MO//'.TOPOSE.PIN'
      LPAIN(3) = 'PCNSETO'
      LCHIN(3) = MO//'.TOPOSE.CNS'
      LPAIN(4) = 'PHEAVTO'
      LCHIN(4) = MO//'.TOPOSE.HEA'
      LPAIN(5) = 'PLONCHA'
      LCHIN(5) = MO//'.TOPOSE.LON'
      LPAIN(6) = 'PPMILTO'
      LCHIN(6) = MO//'.TOPOSE.PMI'
      LPAOUT(1) = 'PXFGEOM'
      LCHOUT(1) = CHGEOM

      CALL CALCUL('S','XFEM_XPG',LIGREL,NBIN,LCHIN,LPAIN,NBOUT,LCHOUT,
     &            LPAOUT,'V','OUI')
      CALL CELCES(CHGEOM,'V',CHSGEO)
      CALL DETRSD('CHAMP',CHGEOM)

9999  CONTINUE
      CALL JEDEMA()
      END
