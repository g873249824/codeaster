      SUBROUTINE IRMARE(IFC,NDIM,NNO,COORDO,NBMA,CONNEX,POINT,NOMA,
     &                  TYPMA,TYPEL,LMOD,TITRE,NBTITR,NBGRN,NBGRM,
     &                  NOMAI,NONOE,FORMAR)
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      CHARACTER*80 TITRE(*)
      CHARACTER*8  NOMAI(*),NONOE(*),NOMA
      CHARACTER*16 FORMAR
      REAL*8       COORDO(*)
      INTEGER      CONNEX(*),TYPMA(*),POINT(*),TYPEL(*),IFC,NBTITR
      LOGICAL      LMOD
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C                 .TRUE. : ON N'IMPRIME QUE LES MAILLES DU MODELE
C       TITRE  : TITRE ASSOCIE AU MAILLAGE
C       TOUT CE QUI SUIT CONCERNE LES GROUPES:
C          NBGRN: NOMBRE DE GROUPES DE NOEUDS
C          NBGRM: NOMBRE DE GROUPES DE MAILLES
C          NOMAI: NOMS DES MAILLES
C          NONOE: NOMS DES NOEUDS
C
C     ------------------------------------------------------------------
C ---------------------------------------------------------------------
C
      CHARACTER*8   NOMM,NOMGR,KBID
      CHARACTER*10  FORMAT
      CHARACTER*50  FMT
C
C     ECRITURE DU TITRE
C
C-----------------------------------------------------------------------
      INTEGER I ,IAGRMA ,IAGRNO ,ICO ,IFIN ,IGM ,IGN 
      INTEGER IMA ,INO ,IPO ,IPOIN ,IT ,ITYPE ,ITYPP 
      INTEGER J ,JM ,JMAI ,JN ,K ,NBFOIS ,NBGRM 
      INTEGER NBGRN ,NBM ,NBMA ,NBN ,NBREST ,NDIM ,NNO 
      INTEGER NNOE 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      FORMAT = FORMAR
      FMT='(1X,A8,1X,'//FORMAT//',1X,'//FORMAT//',1X,'//FORMAT//')'
      WRITE (IFC,*)      'TITRE'
      DO 10 IT = 1 , NBTITR
         WRITE (IFC,'(A)')   TITRE(IT)
 10   CONTINUE
      WRITE (IFC,*)      'FINSF'
      WRITE (IFC,*)      '%'


C     ECRITURE DES NOEUDS
C     --------------------
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
        WRITE (IFC,FMT) NONOE(INO),(COORDO(3*(INO-1)+J),J=1,NDIM)
  1   CONTINUE


C     ECRITURE DES MAILLES
C     ---------------------
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


C     ECRITURE DES GROUPES DE NOEUDS
C     -------------------------------
      DO 752 IGN = 1,NBGRN
         CALL JENUNO(JEXNUM(NOMA//'.GROUPENO',IGN),NOMGR)
         CALL JELIRA(JEXNUM(NOMA//'.GROUPENO',IGN),'LONUTI',NBN,KBID)
         WRITE(IFC,*) 'GROUP_NO'
         WRITE(IFC,*) NOMGR
         IF (NBN.GT.0) THEN
           CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN),'L',IAGRNO)
           WRITE(IFC,'(7(1X,A8))') (NONOE(ZI(IAGRNO-1+JN)),JN=1,NBN)
         ENDIF
         WRITE(IFC,*) 'FINSF'
         WRITE(IFC,*) '%'
  752 CONTINUE


C     ECRITURE DES GROUPES DE MAILLES
C     --------------------------------
      DO 754 IGM = 1,NBGRM
         CALL JENUNO(JEXNUM(NOMA//'.GROUPEMA',IGM),NOMGR)
         CALL JELIRA(JEXNUM(NOMA//'.GROUPEMA',IGM),'LONUTI',NBM,KBID)
         WRITE(IFC,*) 'GROUP_MA'
         WRITE(IFC,*) NOMGR
         IF (NBM.GT.0) THEN
           CALL JEVEUO(JEXNUM(NOMA//'.GROUPEMA',IGM),'L',IAGRMA)
           CALL WKVECT('&&IRMARE.NOMAI','V V K8',MAX(NBM,1),JMAI)
           IPO = 0
           DO 756 JM=1,NBM
             IF (LMOD) THEN
                IF(TYPEL(ZI(IAGRMA-1+JM)).EQ.0) GOTO 756
             ENDIF
             ZK8(JMAI-1+IPO+1)= NOMAI(ZI(IAGRMA-1+JM))
             IPO=IPO+1
  756      CONTINUE
           IF (IPO.NE.0) THEN
             WRITE(IFC,'(7(1X,A8))')  (ZK8(JMAI-1+JM),JM=1,IPO)
           ENDIF
           CALL JEDETR('&&IRMARE.NOMAI')
         ENDIF
         WRITE(IFC,*) 'FINSF'
         WRITE(IFC,*) '%'
  754 CONTINUE


      WRITE(IFC,*) 'FIN'

 1003 FORMAT (8(1X,A8))
 1004 FORMAT (9X,7(1X,A8))
      CALL JEDEMA()
      END
