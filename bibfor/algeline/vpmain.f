      SUBROUTINE VPMAIN(MODELE,MATE,CARA,XMASTR,NBPARA)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*(*) MODELE,MATE,CARA
      REAL*8 XMASTR
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C TOLE CRS_512
C ======================================================================
C     OPERATEUR   NORM_MODE
C     CALCUL DE LA MASSE DU MODELE
C     ------------------------------------------------------------------

      INTEGER MXVALE,IBID,NB,I,IORIG,ICAGE, NBPARA
      PARAMETER (MXVALE=16)
      REAL*8  RBI3(3), ZMAS(MXVALE)
      CHARACTER*8 LPAIN(15),LPAOUT(5)
      CHARACTER*19 CHELEM
      CHARACTER*24 LCHIN(15),LCHOUT(1),MATECO
      CHARACTER*24 CHGEOM,CHCARA(18),LIGRMO,COMPOR
      LOGICAL LRET

C     ------------------------------------------------------------------

      CALL JEMARQ()

      CALL MEGEOM(MODELE,' ',LRET,CHGEOM)
      IF (.NOT.LRET) CALL U2MESS('F','CALCULEL2_81')
      CALL ASSERT(CHGEOM.NE.' ')

      CALL MECARA(CARA,LRET,CHCARA)

      LIGRMO = MODELE(1:8)//'.MODELE'

      IF ( MATE .NE. '        ') THEN
         CALL RCMFMC (MATE , MATECO )
      ELSE
         MATECO = ' '
      ENDIF
C     POUR LES MULTIFIBRES ON SE SERT DE COMPOR
      COMPOR = MATE(1:8)//'.COMPOR'

C     --- CALCUL DE L'OPTION ---
      CHELEM = '&&PEMAIN.MASS_INER'
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM
      LPAIN(2)  = 'PMATERC'
      LCHIN(2)  = MATECO
      LPAIN(3)  = 'PCAORIE'
      LCHIN(3)  = CHCARA(1)
      LPAIN(4)  = 'PCADISM'
      LCHIN(4)  = CHCARA(3)
      LPAIN(5)  = 'PCAGNPO'
      LCHIN(5)  = CHCARA(6)
      LPAIN(6)  = 'PCACOQU'
      LCHIN(6)  = CHCARA(7)
      LPAIN(7)  = 'PCASECT'
      LCHIN(7)  = CHCARA(8)
      LPAIN(8)  = 'PCAARPO'
      LCHIN(8)  = CHCARA(9)
      LPAIN(9)  = 'PCAGNBA'
      LCHIN(9)  = CHCARA(11)
      LPAIN(10) = 'PCAGEPO'
      LCHIN(10) = CHCARA(5)
      LPAIN(11) = 'PNBSP_I'
      LCHIN(11) = CHCARA(16)
      LPAIN(12) = 'PFIBRES'
      LCHIN(12) = CHCARA(17)
      LPAIN(13) = 'PCOMPOR'
      LCHIN(13) = COMPOR
      LPAIN(14) = 'PCINFDI'
      LCHIN(14) = CHCARA(15)
      NB = 14
      LPAOUT(1) = 'PMASSINE'
      LCHOUT(1) = CHELEM

      CALL CALCUL('S','MASS_INER',LIGRMO,NB,LCHIN ,LPAIN,
     &                                    1,LCHOUT,LPAOUT,'V','OUI')

      DO 33 I=1,MXVALE
         ZMAS(I)=0.D0
 33   CONTINUE

      IORIG=0
      ICAGE=0

      CALL PEMICA(CHELEM,MXVALE,ZMAS,0,IBID,RBI3,IORIG,ICAGE)
      XMASTR=ZMAS(1)

      CALL DETRSD('CHAM_ELEM','&&PEMAIN.MASS_INER')

      CALL JEDEMA()
      END
