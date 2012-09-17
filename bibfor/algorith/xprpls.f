      SUBROUTINE XPRPLS(DNOMO,DCNSLN,DCNSLT,NOMO,NOMA,CNSLN,CNSLT,GRLN,
     &                  GRLT,CORRES,NDIM,NDOMP,EDOMG)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      CHARACTER*8    DNOMO,NOMO,NOMA
      CHARACTER*16   CORRES
      CHARACTER*19   DCNSLN,DCNSLT,CNSLN,CNSLT,GRLN,GRLT,NDOMP,EDOMG
      INTEGER        NDIM

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR LADIER A.LADIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C     ------------------------------------------------------------------
C
C       XPRPLS   : X-FEM PROPAGATION : PROJECTION DES LEVEL SETS
C       ------     -     --            -              -     -
C
C  DANS LE CADRE DE LA PROPAGATION X-FEM AVEC LA METHODE UPWIND, ON PEUT
C  UTILISER DEUX MAILLAGES DIFFERENTS POUR LE MODELE PHYSIQUE ET POUR LA
C  REPRESENTATION DES LEVEL SETS. DANS CE CAS, ON DOIT PROJECTER
C  LES LEVEL SETS SUR LE MAILLAGE PHYSIQUE A PARTIR DU MAILLAGE UTILISE
C  POUR LA REPRESENTATION DES LEVEL SETS.
C
C  ENTREE
C  ------
C
C    * MODELE POUR LA REPRESENTATION DES LEVEL SETS
C      --------------------------------------------
C     DNOMO  = NOM DU MODELE
C     DCNSLN = CHAMP_NO_S DES VALEURS DE LA LEVEL SET NORMALE
C     DCNSLT = CHAMP_NO_S DES VALEURS DE LA LEVEL SET TANGENTE
C     EDOMG  = VOIR XPRDOM.F
C
C
C    * MODELE PHYSIQUE
C      ---------------
C     NOMO   = NOM DU MODELE
C     NOMA   = NOME DU MAILLAGE
C     CNSLN  = CHAMP_NO_S DES VALEURS DE LA LEVEL SET NORMALE
C     CNSLT  = CHAMP_NO_S DES VALEURS DE LA LEVEL SET TANGENTE
C     GRLN   = CHAMP_NO_S DES VALEURS DU GRADIENT DE CNSLN
C     GRLT   = CHAMP_NO_S DES VALEURS DU GRADIENT DE CNSLT
C     NDOMP  = VOIR XPRDOM.F
C
C     NDIM   = DIMENSION DU MODELE (DNOMO OU NOMO)
C
C
C  SORTIE
C  ------
C     CORRES = NOM DU OBJET JEVEUX OU ON PEUT STOCKER LA CORRESPONDANCE
C              ENTRE LES DEUX MAILLAGES
C     CNSLN  = CHAMP_NO_S DES NOUVELLES VALEURS DE LA LEVEL SET NORMALE
C              POUR LE MODELE PHYSIQUE
C     CNSLT  = CHAMP_NO_S DES NOUVELLES VALEURS DE LA LEVEL SET TANGENTE
C              POUR LE MODELE PHYSIQUE
C     GRLN   = CHAMP_NO_S DES NOUVELLES VALEURS DU GRADIENT DE CNSLN
C              POUR LE MODELE PHYSIQUE
C     GRLT   = CHAMP_NO_S DES NOUVELLES VALEURS DU GRADIENT DE CNSLT
C              POUR LE MODELE PHYSIQUE
C
C     ------------------------------------------------------------------


C     CHARACTERISTICS OF THE MESHES

C     PROJECTION LEVEL SETS MESH
      INTEGER       NBELPR,JEFROM,JCNLNV,
     &              JCNLTV,JCNLNL,JCNLTL

C     PROJECTION PHYSICAL MESH
      CHARACTER*19  TMPLSN,TMPLST
      INTEGER       JNTO,NUNOPR,
     &              JTMPLT,JTMPLN

C     PROJECTION CODE
      LOGICAL        LDMAX
      REAL*8         DISTMA
      CHARACTER*8    LPAIN(4),LPAOUT(2)
      CHARACTER*19   CNOLS,CELGLS,CHAMS
      CHARACTER*24   LCHIN(4),LCHOUT(2),LIGREL

C     GENERAL PURPOSE
      INTEGER       I,IBID
      CHARACTER*8   K8B
      REAL*8        R8MAEM
      INTEGER       IFM,NIV

C-----------------------------------------------------------------------
C     DEBUT
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

      IF (NIV.GE.0) THEN
            WRITE(IFM,*)
            WRITE(IFM,*)'   PROJECTION DES LEVEL SETS SUR LE MAILLAGE'//
     &                  ' PHYSIQUE'
      ENDIF

C     RETREIVE THE LIST OF THE NODES IN THE DOMAIN ON THE PHYSICAL MESH
      CALL JELIRA(NDOMP,'LONMAX',NUNOPR,K8B)
      CALL JEVEUO(NDOMP,'L',JNTO)

C     RETREIVE THE LIST OF THE ELEMENTS IN THE DOMAIN ON THE AUXILIARY
C     GRID
      CALL JELIRA(EDOMG,'LONMAX',NBELPR,K8B)
      CALL JEVEUO(EDOMG,'L',JEFROM)

C        PROJECT THE LEVELSETS FROM THE AUXILIARY MESH TO THE PHYSICAL
C        MESH. THE NODAL FIELD IS EXTRAPOLATED OUTSIDE THE AUXILIARY
C        MESH.
         LDMAX = .FALSE.
         DISTMA = R8MAEM()

C        CREATE THE "CONNECTION" TABLE BETWEEN THE PHYSICAL AND
C        AUXILIARY MESHES
         IF (NDIM.EQ.2) THEN
            CALL PJ2DCO('PARTIE',DNOMO,NOMO,NBELPR,ZI(JEFROM),NUNOPR,
     &                   ZI(JNTO),' ',' ',CORRES,LDMAX,DISTMA)
         ELSE
            CALL PJ3DCO('PARTIE',DNOMO,NOMO,NBELPR,ZI(JEFROM),NUNOPR,
     &                  ZI(JNTO),' ',' ',CORRES,LDMAX,DISTMA)
         ENDIF

C        CREATE TWO TEMPORARY FIELDS WHERE THE PROJECTED VALUES WILL BE
C        STORED
         TMPLSN = '&&OP0010.TMPLSN'
         TMPLST = '&&OP0010.TMPLST'

C        PROJECTION OF THE NORMAL LEVELSET. THE EXISTING FIELD DATA
C        STRUCTURES ARE AUTOMATICALLY DESTROYED BY THE SUBROUTINE
C        "CNSPRJ"
         CALL CNSPRJ(DCNSLN,CORRES,'G',TMPLSN,IBID)
         CALL ASSERT(IBID.EQ.0)

C        PROJECTION OF THE TANGENTIAL LEVELSET. THE EXISTING FIELD DATA
C        STRUCTURES ARE AUTOMATICALLY DESTROYED BY THE SUBROUTINE
C        "CNSPRJ"
         CALL CNSPRJ(DCNSLT,CORRES,'G',TMPLST,IBID)
         CALL ASSERT(IBID.EQ.0)

         CALL JEDETR(CORRES)

C        RETREIVE THE EXISTING NORMAL LEVEL SET FIELD
         CALL JEVEUO(CNSLN//'.CNSV','E',JCNLNV)
         CALL JEVEUO(CNSLN//'.CNSL','E',JCNLNL)

C        RETREIVE THE EXISTING TANGENTIAL LEVEL SET FIELD
         CALL JEVEUO(CNSLT//'.CNSV','E',JCNLTV)
         CALL JEVEUO(CNSLT//'.CNSL','E',JCNLTL)

C        RETREIVE THE TEMPORARY FIELDS WHERE THE PROJECTED VALUES OF THE
C        LEVEL SET HAVE BEEN STORED
         CALL JEVEUO(TMPLSN//'.CNSV','L',JTMPLN)
         CALL JEVEUO(TMPLST//'.CNSV','L',JTMPLT)

C        SUBSTITUTE THE PROJECTED VALUES OF THE LEVEL SETS INTO THE
C        EXISTING LEVEL SET FIELDS ONLY FOR THE NODES IN THE PHYSICAL
C        MESH INVOLVED IN THE PROJECTION
         DO 3000 I=1,NUNOPR

C           SUBSTITUTE THE PROJECTED VALUES OF THE NORMAL LEVEL SET INTO
C           THE EXISTING NORMAL LEVEL SET OF THE PHYSICAL MESH
            ZR(JCNLNV-1+ZI(JNTO-1+I)) = ZR(JTMPLN-1+ZI(JNTO-1+I))
            ZL(JCNLNL-1+ZI(JNTO-1+I)) = .TRUE.

C           SUBSTITUTE THE PROJECTED VALUES OF THE TANGENTIAL LEVEL SET
C           INTO THE EXISTING TANGENTIAL LEVEL SET OF THE PHYSICAL MESH
            ZR(JCNLTV-1+ZI(JNTO-1+I)) = ZR(JTMPLT-1+ZI(JNTO-1+I))
            ZL(JCNLTL-1+ZI(JNTO-1+I)) = .TRUE.

3000     CONTINUE

C        DESTROY THE TEMPORARY PROJECTED LEVEL SETS
         CALL DETRSD('CHAM_NO_S',TMPLSN)
         CALL DETRSD('CHAM_NO_S',TMPLST)

C ----------------------------------------------------------------------
C        CALCULATE THE GRADIENTS OF THE LEVEL SETS OF THE PHYSICAL MESH
C ----------------------------------------------------------------------

         IF (NIV.GE.0) THEN
            WRITE(IFM,*)'   CALCUL DES GRADIENTS DES LEVEL SETS SUR'//
     &                  ' LE MAILLAGE PHYSIQUE'
         ENDIF

C        NORMAL LEVEL SET
         LIGREL = NOMO//'.MODELE'
         CNOLS = '&&OP0010.GR.CNOLS'
         CELGLS =  '&&OP0010.GR.CELGLS'
         CHAMS =  '&&OP0010.GR.CHAMS'

         CALL CNSCNO(CNSLN,' ','NON','V',CNOLS,'F',IBID)
         LPAIN(1)='PGEOMER'
         LCHIN(1)=NOMA//'.COORDO'
         LPAIN(2)='PNEUTER'
         LCHIN(2)=CNOLS
         LPAOUT(1)='PGNEUTR'
         CELGLS =  '&&OP0010.GR.CELGLS'
         LCHOUT(1)=CELGLS

         CALL CALCUL('S','GRAD_NEUT_R',LIGREL,2,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,'V','OUI')

         CALL CELCES (CELGLS, 'V', CHAMS)
         CALL CESCNS (CHAMS, ' ', 'V', GRLN, ' ', IBID)

         CALL DETRSD('CHAM_NO',CNOLS)
         CALL DETRSD('CHAM_ELEM',CELGLS)
         CALL DETRSD('CHAM_ELEM_S',CHAMS)

C        TANGENTIAL LEVEL SET
         CALL CNSCNO(CNSLT,' ','NON','V',CNOLS,'F',IBID)
         LPAIN(1)='PGEOMER'
         LCHIN(1)=NOMA//'.COORDO'
         LPAIN(2)='PNEUTER'
         LCHIN(2)=CNOLS
         LPAOUT(1)='PGNEUTR'
         CELGLS =  '&&OP0010.GR.CELGLS'
         LCHOUT(1)=CELGLS

         CALL CALCUL('S','GRAD_NEUT_R',LIGREL,2,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,'V','OUI')

         CALL CELCES (CELGLS, 'V', CHAMS)
         CALL CESCNS (CHAMS, ' ', 'V', GRLT, ' ', IBID)

         CALL DETRSD('CHAM_NO',CNOLS)
         CALL DETRSD('CHAM_ELEM',CELGLS)
         CALL DETRSD('CHAM_ELEM_S',CHAMS)

C-----------------------------------------------------------------------
C     FIN
C-----------------------------------------------------------------------
      CALL JEDEMA()
      END
