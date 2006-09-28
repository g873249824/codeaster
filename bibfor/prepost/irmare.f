      SUBROUTINE IRMARE(IFC,NDIM,NNO,COORDO,NBMA,CONNEX,POINT,NOMA,
     &                  TYPMA,TYPEL,LMOD,TITRE,NBTITR,NBGRN,NOGN,NBGRM,
     &                  NOGM,NOMAI,NONOE)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*80 TITRE(*)
      CHARACTER*8  NOGN(*),NOGM(*),NOMAI(*),NONOE(*),NOMA
      REAL*8       COORDO(*)
      INTEGER      CONNEX(*),TYPMA(*),POINT(*),TYPEL(*),IFC,NBTITR
      LOGICAL      LMOD
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C
C     BUT :   ECRITURE DU MAILLAGE AU FORMAT ASTER
C     ENTREE:
C       IFC    : NUMERO D'UNITE LOGIQUE DU FICHIER ASTER
C       NDIM   : DIMENSION DU PROBLEME (2  OU 3)
C       NNO    : NOMBRE DE NOEUDS DU MAILLAGE
C       COORDO : VECTEUR DES COORDONNEES DES NOEUDS
C       NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C       CONNEX : CONNECTIVITES
C       POINT  : POINTEUR DANS LES CONNECTIVITES
C       NOMAT  : NOM DU MAILLAGE
C       TYPMA  : TYPES DES MAILLES
C       TYPEL  : TYPES DES ELEMENTS
C       LMOD   : LOGIQUE INDIQUANT SI IMPRESSION MODELE OU MAILLAGE
C                 .TRUE. MODELE
C       TITRE  : TITRE ASSOCIE AU MAILLAGE
C       TOUT CE QUI SUIT CONCERNE LES GROUPES:
C          NBGRN: NOMBRE DE GROUPES DE NOEUDS
C          NOGN : NOM DES GROUPES DE NOEUDS
C          NBGRM: NOMBRE DE GROUPES DE MAILLES
C          NOGM : NOM DES GROUPES DE MAILLES
C          NOMAI: NOMS DES MAILLES
C          NONOE: NOMS DES NOEUDS
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C     ------------------------------------------------------------------
C ---------------------------------------------------------------------
C
      CHARACTER*8   NOMM
      CHARACTER*8 KBID
C
C     ECRITURE DU TITRE
C
      CALL JEMARQ()
      WRITE (IFC,*)      'TITRE'
      DO 10 IT = 1 , NBTITR
         WRITE (IFC,'(A)')   TITRE(IT)
 10   CONTINUE
      WRITE (IFC,*)      'FINSF'
      WRITE (IFC,*)      '%'
C
C     ECRITURE DES NOEUDS
C
      IF (NDIM.EQ.3)  THEN
         WRITE (IFC,*)   'COOR_3D'
      ELSEIF (NDIM.EQ.2) THEN
         WRITE (IFC,*)   'COOR_2D'
      ELSEIF (NDIM.EQ.1) THEN
         WRITE (IFC,*)   'COOR_1D'
      ELSE
         CALL U2MESS('F','PREPOST2_77')
      ENDIF
      DO 1 INO = 1,NNO
        WRITE (IFC,1001) NONOE(INO),(COORDO(3*(INO-1)+J),J=1,NDIM)
  1   CONTINUE
C
C     ECRITURE DES MAILLES
C
      ITYPP = 0
      IFIN = 0
      DO 21 IMA = 1,NBMA
         ITYPE = TYPMA(IMA)
         IPOIN=POINT(IMA)
         NNOE=POINT(IMA+1)-IPOIN
C
C        -- SI LMOD =.TRUE. ON IMPRIME LE MODELE SINON LE MAILLAGE
         IF (LMOD) THEN
           IF (TYPEL(IMA).EQ.0) THEN
             GOTO 21
           ENDIF
         ENDIF
         IF (ITYPE.NE.ITYPP) THEN
           CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPE),NOMM)
           WRITE(IFC,*)    'FINSF'
           WRITE(IFC,*)    '%'
           ITYPP = ITYPE
           WRITE(IFC,*)  NOMM
           IFIN = 1
         ENDIF
         NBFOIS = NNOE/7
         NBREST = NNOE - 7*NBFOIS
         IF (NBFOIS.GE.1) THEN
           WRITE(IFC,1003) NOMAI(IMA),(NONOE(CONNEX(IPOIN-1+I)),I=1,7)
           ICO = 8
           DO 12 I=2,NBFOIS
             WRITE(IFC,1004) (NONOE(CONNEX(IPOIN-1+K)),K=ICO,ICO+6)
             ICO=ICO+7
  12       CONTINUE
           IF(NBREST.NE.0) THEN
             WRITE(IFC,1004) (NONOE(CONNEX(IPOIN-1+I)),I=ICO,NNOE)
           ENDIF
         ELSE
           WRITE(IFC,1003) NOMAI(IMA),
     &            (NONOE(CONNEX(IPOIN-1+I)),I=1,NNOE)
         ENDIF
   21  CONTINUE
      IF (IFIN.EQ.1) THEN
        WRITE(IFC,*)  'FINSF'
        WRITE(IFC,*)  '%'
      ENDIF

C
C     ECRITURE DES GROUPES DE NOEUDS
C
      DO 752 IGN = 1,NBGRN
         WRITE(IFC,*) 'GROUP_NO'
         WRITE(IFC,*) NOGN(IGN)
         CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN),'L',IAGRNO)
         CALL JELIRA(JEXNUM(NOMA//'.GROUPENO',IGN),'LONMAX',NBN,KBID)
         WRITE(IFC,'(7(1X,A8))') (NONOE(ZI(IAGRNO-1+JN)),JN=1,NBN)
         WRITE(IFC,*) 'FINSF'
         WRITE(IFC,*) '%'
  752 CONTINUE
C
C     ECRITURE DES GROUPES DE MAILLES
C
      DO 754 IGM = 1,NBGRM
         CALL JEVEUO(JEXNUM(NOMA//'.GROUPEMA',IGM),'L',IAGRMA)
         CALL JELIRA(JEXNUM(NOMA//'.GROUPEMA',IGM),'LONMAX',NBM,KBID)
         CALL WKVECT('&&IRMARE.NOMAI','V V K8',NBM,JMAI)
         IPO = 0
         DO 756 JM=1,NBM
           IF (LMOD) THEN
              IF(TYPEL(ZI(IAGRMA-1+JM)).EQ.0) GOTO 756
           ENDIF
           ZK8(JMAI-1+IPO+1)= NOMAI(ZI(IAGRMA-1+JM))
           IPO=IPO+1
  756    CONTINUE
         IF (IPO.NE.0) THEN
           WRITE(IFC,*) 'GROUP_MA'
           WRITE(IFC,*) NOGM(IGM)
           WRITE(IFC,'(7(1X,A8))')  (ZK8(JMAI-1+JM),JM=1,IPO)
           WRITE(IFC,*) 'FINSF'
           WRITE(IFC,*) '%'
         ENDIF
         CALL JEDETR('&&IRMARE.NOMAI')
  754 CONTINUE
      WRITE(IFC,*) 'FIN'
 1001 FORMAT (1X,A8,1X,1PD21.14,1X,1PD21.14,1X,1PD21.14)
 1003 FORMAT (8(1X,A8))
 1004 FORMAT (9X,7(1X,A8))
 9999 CONTINUE
      CALL JEDEMA()
      END
