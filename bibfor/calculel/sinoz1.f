      SUBROUTINE SINOZ1(MODELE,SIGMA,SIGNO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/02/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)

C     ARGUMENTS:
C     ----------
C ......................................................................
C     BUT:
C           CALCUL DES CONTRAINTES AUX NOEUDS PAR LA METHODE ZZ1

C     ENTREES:

C        MODELE : NOM DU MODELE
C        SIGMA  : NOM DU CHAMP DE CONTRAINTES AUX POINTS DE GAUSS
C        SIGNO  : NOM DU CHAMP DE CONTRAINTES AUX NOEUDS

C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       24/11/03 (OB): PAR ADHERENCE A NUMER2.
C----------------------------------------------------------------------

C ----------------------- DECLARATIONS --------------------------------

      CHARACTER*1 TYPRES
      CHARACTER*8 BLANC,TYPE,OPER,MODELE,CHMAT,LICHA
      CHARACTER*14 NUPGM
      CHARACTER*8 K8B,CHSIG,VECELE,KBID,CHTEMP,CHAR
      CHARACTER*8 NOMGD,LICMP(4),MA
      CHARACTER*19 LIGRMO,SIGEL,SIGTH,FO1,CHAM,INFCHA
      CHARACTER*19 SOLVEU
      CHARACTER*24 KMOCH,SIGNO,SIGMA
      CHARACTER*24 NUME,TIME,VECASS,VECT(4),FOMULT,LCHAR(1)
      REAL*8 TPS(6),RCMP(4)
      INTEGER IBID
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CALL JEMARQ()

C     CALCUL DE LA MATRICE DE MASSE ZZ1 (A 1 CMP)
      CALL MEMZME(MODELE,'&&MASSEL')

      TYPRES = 'R'


C     --  APPEL A NUMER2 POUR CONSTRUIRE UN NUME_DDL
C         SUR LA GRANDEUR SIZZ_R (1 CMP)
      NUPGM = '&&NUME'
      KMOCH = NUPGM//'.&LMODCHAR'
      INFCHA = '&&SINOZ1.INFCHA'
      SOLVEU = '&&SINOZ1.SOLVEUR'
C
      CALL NUMOCH('&&MASSEL',1,'V',KMOCH)
      CALL JEVEUO(KMOCH,'L',JKMOCH)
      CALL JELIRA(KMOCH,'LONUTI',NBLIGR,KBID)
      CALL CRSOLV('LDLT','RCMK',SOLVEU,'V')
      CALL NUMER2(' ',NBLIGR,ZK24(JKMOCH),'DDL_NOZ1',SOLVEU,'VV',NUPGM,
     &     IBID)
      CALL JEDETR(KMOCH)

      CALL ASMATR(1,'&&MASSEL',' ',NUPGM,SOLVEU,INFCHA,'ZERO',
     &                 'V',1,'&&MASSAS')

C     CALCUL DES SECONDS MEMBRES
      VECELE = '&&VECELE'
      CALL ME2ZME(MODELE,SIGMA(1:19),VECELE)


C     ASSEMBLAGE DES SECONDS MEMBRES
      NUME = '&&NUME                 '
      VECASS = '??????'
      CALL ASASVE(VECELE,NUME,TYPRES,VECASS)
      CALL JEVEUO(VECASS,'L',JVECAS)
      DO 10,I = 1,4
        VECT(I) = ZK24(JVECAS-1+I)
   10 CONTINUE


C      RESOLUTIONS SANS DIRICHLET


      CALL MTDSCR('&&MASSAS')
      CALL JEVEUO('&&MASSAS           .&INT','E',LMAT)
      CALL TLDLGG(1,LMAT,1,0,0,NDECI,ISINGU,NPVNEG,IER)

      DO 20 I = 1,4
        CALL RESLDL(SOLVEU,'&&MASSAS',' ',VECT(I))
   20 CONTINUE

C   CREATION DU CHAM_NO_SIEF_R A PARTIR DES 4 CHAM_NO_SIZZ_R (A 1 CMP)

      DO 30 I = 1,4
        RCMP(I) = 0.D0
   30 CONTINUE
      LICMP(1) = 'SIXX'
      LICMP(2) = 'SIYY'
      LICMP(3) = 'SIZZ'
      LICMP(4) = 'SIXY'
      CALL DISMOI('F','NOM_MAILLA',SIGMA(1:19),'CHAM_ELEM',IBID,MA,IER)
      CALL CRCNCT('G',SIGNO,MA,'SIEF_R',4,LICMP,RCMP)
      CALL JEVEUO(SIGNO(1:19)//'.VALE','E',JSIG)
      CALL JEVEUO(VECT(1) (1:19)//'.VALE','E',JSIXX)
      CALL JEVEUO(VECT(2) (1:19)//'.VALE','E',JSIYY)
      CALL JEVEUO(VECT(3) (1:19)//'.VALE','E',JSIZZ)
      CALL JEVEUO(VECT(4) (1:19)//'.VALE','E',JSIXY)
      CALL JEVEUO(JEXNUM(NUME(1:14)//'.NUME.PRNO',1),'L',JPRNO)
      CALL JEVEUO(NUME(1:14)//'.NUME.NUEQ','L',JNUEQ)

      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNO,KBID,IER)
      DO 40 I = 1,NBNO
        INDEQ = ZI(JPRNO-1+3* (I-1)+1)
        IEQ = ZI(JNUEQ-1+INDEQ)
        ZR(JSIG-1+4* (I-1)+1) = ZR(JSIXX-1+IEQ)
        ZR(JSIG-1+4* (I-1)+2) = ZR(JSIYY-1+IEQ)
        ZR(JSIG-1+4* (I-1)+3) = ZR(JSIZZ-1+IEQ)
        ZR(JSIG-1+4* (I-1)+4) = ZR(JSIXY-1+IEQ)
   40 CONTINUE

      CALL JEDETC('V','&&MASSAS',1)
      CALL JEDETC('V','&&NUME',1)
      CALL DETRSD('SOLVEUR',SOLVEU)

      DO 50,I = 1,4
        CALL DETRSD('CHAMP_GD',ZK24(JVECAS-1+I))
   50 CONTINUE
      CALL JEDETR(VECASS)


      CALL JEDEMA()
      END
