      SUBROUTINE ELREF6 ( ELRZ,NOMTZ,FAMIZ,NDIM,NNO,NNOS,NPG,IPOIDS,
     &                    JCOOPG,IVF,IDFDE,JDFD2,JGANO )
      IMPLICIT NONE
      CHARACTER*(*) ELRZ,NOMTZ,FAMIZ
      INTEGER NDIM,NNO,NNOS,NPG,IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 05/10/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C BUT: RECUPERER DANS UNE ROUTINE LES ADRESSES DANS ZR
C      - DES POIDS DES POINTS DE GAUSS  : IPOIDS
C      - DES COORDONNEES DES POINTS DE GAUSS  : JCOOPG
C      - DES VALEURS DES FONCTIONS DE FORME : IVF
C      - DES VALEURS DES DERIVEES 1ERES DES FONCTIONS DE FORME : IDFDE
C      - DES VALEURS DES DERIVEES 2EMES DES FONCTIONS DE FORME : JDFD2
C      - DE LA MATRICE DE PASSAGE GAUSS -> NOEUDS : JGANO
C ----------------------------------------------------------------------
C   IN   ELRZ  : NOM DE L'ELREFA (K8)
C        NOMTE : NOM DU TYPE D'ELEMENT (K16)
C        FAMIL  : NOM (LOCAL) DE LA FAMILLE DE POINTS DE GAUSS :
C                 'STD','RICH',...
C   OUT  NDIM   : DIMENSION DE L'ESPACE (=NB COORDONNEES)
C        NNO    : NOMBRE DE NOEUDS DU TYPE_MAILLE
C        NNOS   : NOMBRE DE NOEUDS SOMMETS DU TYPE_MAILLE
C        NPG    : NOMBRE DE POINTS DE GAUSS
C        IPOIDS : ADRESSE DANS ZR DU TABLEAU POIDS(IPG)
C        JCOOPG : ADRESSE DANS ZR DU TABLEAU COOPG(IDIM,IPG)
C        IVF    : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
C        IDFDE  : ADRESSE DANS ZR DU TABLEAU DFF(IDIM,INO,IPG)
C        JDFD2  : ADRESSE DANS ZR DU TABLEAU DFF2(IDIM,JDIM,INO,IPG)
C        JGANO  : ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
C                      GAUSS -> NOEUDS (DIM= 2+NNO*NPG)
C                 ATTENTION : LES 2 1ERS TERMES SONT LES
C                             DIMMENSIONS DE LA MATRICE: NNO ET NPG

C   -------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*16  NOMTE
      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG


      CHARACTER*8 ELRF,FAMIL,FAPG(20)
      CHARACTER*16 NOFGPG
      CHARACTER*32 NOFLPG
      INTEGER  NBFPG,NBPG(20),JVR,DECAL,IFAM,LONFAM
      INTEGER  INDK32,INDIK8,NUFPG,NUFGPG,NUFLPG,JDFD2L,JGANOL
      INTEGER  NDIML,NNOSL,NNOL,NPGL,IPOIDL,JCOOPL,IVFL,IDFDEL
      REAL*8   VOL, X(3*27)

C     -- POUR FAIRE DES "SAVE" ET GAGNER EN PERFORMANCE :
      INTEGER MAXSAV
      PARAMETER (MAXSAV=5)
      INTEGER NBSAV
      COMMON /CAII13/NBSAV
      INTEGER ADDSAV(5,10),K1,K2,NUSAV
      CHARACTER*32 NOMSAV(MAXSAV)
      SAVE NOMSAV,ADDSAV
C DEB ------------------------------------------------------------------

      FAMIL = FAMIZ
      ELRF  = ELRZ
      NOMTE = NOMTZ
      NOFLPG = NOMTE//ELRF//FAMIL


C     -- POUR GAGNER DU TEMPS, ON REGARDE SI LA FAMILLE A ETE SAUVEE:
C     ---------------------------------------------------------------
      NUSAV = INDK32(NOMSAV,NOFLPG,1,NBSAV)
      IF (NUSAV.GT.0) THEN
        NDIML  = ADDSAV(NUSAV,1)
        NNOL   = ADDSAV(NUSAV,2)
        NNOSL  = ADDSAV(NUSAV,3)
        NPGL   = ADDSAV(NUSAV,4)
        IPOIDL = ADDSAV(NUSAV,5)
        JCOOPL = ADDSAV(NUSAV,6)
        IVFL   = ADDSAV(NUSAV,7)
        IDFDEL = ADDSAV(NUSAV,8)
        JDFD2L = ADDSAV(NUSAV,9)
        JGANOL = ADDSAV(NUSAV,10)
        GO TO 40
      END IF


C     -- CALCUL DE NUFPG :
C     --------------------
      NUFLPG = INDK32(ZK32(JPNLFP),NOFLPG,1,NBLFPG)
      IF (NUFLPG.EQ.0) THEN
        CALL UTDEBM('F','ELREF6','ELREFE MAL PROGRAMME')
        CALL UTIMPK('L','NOM LOCAL CHERCHE (NOMTE//ELREFE//FAMILLE) ',1,
     &              NOFLPG)
        CALL UTIMPK('L','PARMI LES EXISTANTS ',NBLFPG,ZK32(JPNLFP))
        CALL UTFINM()
      END IF
      NUFGPG = ZI(JNOLFP-1+NUFLPG)
      IF (NUFGPG.EQ.0) CALL UTMESS('F','ELREF6',
     &        'FAMILLE DE PG "LISTE" INTERDITE:'//NOFLPG)
      CALL JENUNO(JEXNUM('&CATA.TM.NOFPG',NUFGPG),NOFGPG)
      CALL ASSERT(NOFGPG(1:8).EQ.ELRF)
      CALL ELRACA(ELRF,NDIML,NNOL,NNOSL,NBFPG,FAPG,NBPG,X,VOL)
      CALL ASSERT(NBFPG.LT.20)
      NUFPG = INDIK8(FAPG,NOFGPG(9:16),1,NBFPG)
      CALL ASSERT(NUFPG.GT.0)


      CALL JEVEUO('&INEL.'//ELRF//'.ELRA_R','L',JVR)

      DECAL = 0
      DO 10,IFAM = 1,NUFPG - 1
        NPGL = NBPG(IFAM)

        LONFAM = NPGL
        LONFAM = LONFAM + NPGL*NDIML
        LONFAM = LONFAM + NPGL*NNOL
        LONFAM = LONFAM + NPGL*NNOL*NDIML
        LONFAM = LONFAM + NPGL*NNOL*NDIML*NDIML
        LONFAM = LONFAM + 2 + NPGL*NNOL

        DECAL = DECAL + LONFAM
   10 CONTINUE

      NPGL = NBPG(NUFPG)

      IPOIDL = JVR    + DECAL
      JCOOPL = IPOIDL + NPGL
      IVFL   = JCOOPL + NPGL*NDIML
      IDFDEL = IVFL   + NPGL*NNOL
      JDFD2L = IDFDEL + NPGL*NNOL*NDIML
      JGANOL = JDFD2L + NPGL*NNOL*NDIML*NDIML


C     -- ON SAUVEGARDE LES VALEURS CALCULEES :
C     ----------------------------------------
C     -- ON DECALE TOUT LE MONDE VERS LE BAS:
      NBSAV = MIN(NBSAV+1,MAXSAV)
      DO 30,K1 = NBSAV - 1,1,-1
        NOMSAV(K1+1) = NOMSAV(K1)
        DO 20,K2 = 1,10
          ADDSAV(K1+1,K2) = ADDSAV(K1,K2)
   20   CONTINUE
   30 CONTINUE

C     -- ON RECOPIE LES NOUVELLES VALEURS EN POSITION 1 :
      NOMSAV(1) = NOFLPG
      ADDSAV(1,1) = NDIML
      ADDSAV(1,2) = NNOL
      ADDSAV(1,3) = NNOSL
      ADDSAV(1,4) = NPGL
      ADDSAV(1,5) = IPOIDL
      ADDSAV(1,6) = JCOOPL
      ADDSAV(1,7) = IVFL
      ADDSAV(1,8) = IDFDEL
      ADDSAV(1,9) = JDFD2L
      ADDSAV(1,10) = JGANOL


   40 CONTINUE
C
      NDIM   = NDIML
      NNOS   = NNOSL
      NNO    = NNOL
      NPG    = NPGL
      IPOIDS = IPOIDL
      JCOOPG = JCOOPL
      IVF    = IVFL
      IDFDE  = IDFDEL
      JDFD2  = JDFD2L
      JGANO  = JGANOL

      END
