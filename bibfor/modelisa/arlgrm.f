      SUBROUTINE ARLGRM(MAIL  ,NOMGRP,DIME  ,IMA  ,
     &                  CONNEX,LONCUM,
     &                  NUMMAI,NOMMAI,ITYPM ,LCOQUE,NBNO  ,
     &                  CXNO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*19 NOMGRP
      CHARACTER*8  MAIL
      INTEGER      IMA,DIME
      INTEGER      CONNEX(*),LONCUM(*)
      INTEGER      NUMMAI
      CHARACTER*8  NOMMAI
      INTEGER      LCOQUE
      INTEGER      NBNO,ITYPM
      INTEGER      CXNO(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C DONNE LES COORDONNEES D'UNE MAILLE D'UN GROUPE
C
C ----------------------------------------------------------------------
C
C
C IN  NOMGRP : NOM DU GROUPE DE MAILLES ARLEQUIN
C IN  MAIL   : NOM DU MAILLAGE
C IN  NOM    : NOM DE LA SD DE STOCKAGE DES MAILLES ARLEQUIN GROUP_MA_*
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  IMA    : NUMERO D'ORDRE DE LA MAILLE DANS LE GROUPE ARLEQUIN
C IN  CONNEX : CONNEXITE DES MAILLES
C IN  LONCUM : LONGUEUR CUMULEE DE CONNEX
C OUT NUMMAI : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
C OUT NOMMAI : NOM DE LA MAILLE
C OUT ITYPM  : NUMERO ABSOLU DU TYPE DE LA MAILLE
C OUT NBNO   : NOMBRE DE NOEUDS DE LA MAILLE
C OUT CXNO   : CONNECTIVITE DE LA MAILLE
C                CONTIENT NUMEROS ABSOLUS DES NOEUDS DANS LE MAILLAGE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      JGRP,JTYP,AIMA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL ASSERT((DIME.GT.0).AND.(DIME.LE.3))
      AIMA = ABS(IMA)
C
C --- LECTURE DONNEES MAILLAGE
C
      CALL JEVEUO(MAIL(1:8)//'.TYPMAIL','L',JTYP)
C
C --- LECTURE DONNEES GROUPE DE MAILLES
C
      CALL JEVEUO(NOMGRP(1:19),'L',JGRP)
C
C --- NUMERO ABSOLU ET NOM DE LA MAILLE
C
      NUMMAI = ZI(JGRP-1+AIMA)
      CALL JENUNO(JEXNUM(MAIL(1:8)//'.NOMMAI',NUMMAI),NOMMAI)
C
C --- TYPE DE LA MAILLE
C
      ITYPM  = ZI(JTYP-1+NUMMAI)
C
C --- EXTENSION SI COQUE
C
C      TYPEMA = ZK8(hh)
C      CALL TMACOQ(TYPEMA,DIME  ,LCOQUE)
      LCOQUE = 0
      IF (LCOQUE.EQ.1) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CONNECTIVITE DE LA MAILLE
C
      CALL CNNOEU(NUMMAI,CONNEX,LONCUM,LCOQUE,NBNO,CXNO)
C
      CALL JEDEMA()

      END
