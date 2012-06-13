      SUBROUTINE FONDPL(MODELE,MATE,NUMEDD,NEQ,CHONDP,NCHOND,VECOND,
     &                  VEONDE,VAONDE,TEMPS,FOONDE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*8 LPAIN(5),LPAOUT(1),K8BID,CHONDP(NCHOND)
      CHARACTER*24 MODELE,MATE,NUMEDD,VECOND
      CHARACTER*24 CHINST
      CHARACTER*24 VEONDE,VAONDE,LCHIN(5),LCHOUT(1)
      CHARACTER*24 CHGEOM,LIGREL
      REAL*8 FOONDE(NEQ),TEMPS
      COMPLEX*16 CBID

      CALL JEMARQ()

      DO 10 I = 1,NEQ
        FOONDE(I) = 0.D0
   10 CONTINUE

      CHINST = '&&CHINST'
      CALL MECACT('V',CHINST,'MODELE',MODELE(1:8)//'.MODELE','INST_R',1,
     &            'INST',IBID,TEMPS,CBID,K8BID)
      LIGREL = MODELE(1:8)//'.MODELE'
      CALL JEVEUO(LIGREL(1:19)//'.LGRF','L',JNOMA)
      CHGEOM = ZK8(JNOMA)//'.COORDO'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE

      LPAIN(3) = 'PTEMPSR'
      LCHIN(3) = CHINST

      LPAIN(4) = 'PONDPLA'
      LPAIN(5) = 'PONDPLR'

      NPAIN = 5

      LPAOUT(1) = 'PVECTUR'
      LCHOUT(1) = VECOND

      DO 30 I = 1,NCHOND
        CALL EXISD('CARTE',CHONDP(I)//'.CHME.ONDPL',IRET)
        CALL EXISD('CARTE',CHONDP(I)//'.CHME.ONDPR',IBID)
        IF (IRET.NE.0 .AND. IBID.NE.0) THEN
          LCHIN(4) = CHONDP(I)//'.CHME.ONDPL.DESC'
          LCHIN(5) = CHONDP(I)//'.CHME.ONDPR.DESC'
          
          CALL CALCUL('S','ONDE_PLAN',LIGREL,NPAIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,'V','OUI')

          CALL CORICH('E',LCHOUT(1),-1,IBID)
          CALL JEDETR(VEONDE(1:19)//'.RELR')
          CALL REAJRE(VEONDE,LCHOUT(1),'V')
          CALL ASASVE(VEONDE,NUMEDD,'R',VAONDE)

          CALL JEVEUO(VAONDE,'L',JVAOND)
          CALL JEVEUO(ZK24(JVAOND) (1:19)//'.VALE','L',JREOND)

          DO 20 J = 1,NEQ
            FOONDE(J) = FOONDE(J) + ZR(JREOND+J-1)
   20     CONTINUE
          CALL DETRSD('CHAMP_GD',ZK24(JVAOND) (1:19))

        END IF
   30 CONTINUE


      CALL JEDEMA()
      END
