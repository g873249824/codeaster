      SUBROUTINE AGLIGR(LONG,LIGRCH)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER LONG
      CHARACTER*19 LIGRCH
C --------------------------------------------------------------------
C   AGRANDISSEMENT DU LIGREL DE CHARGE LIGRCH, LONG ETANT SON NOUVEAU-
C   NOMBRE D'ELEMENTS
C --------------------------------------------------------------------
C  LONG         - IN     - I    - : NOUVEAU NOMBRE D'ELEMENTS DU
C               -        -      -   LIGREL DE CHARGE
C --------------------------------------------------------------------
C  LIGRCH       - IN     - K24  - : NOM DU LIGREL DE CHARGE
C               - JXVAR  -      -   ON AGRANDIT EN CONSERVANT LEURS
C               -        -      -   ANCIENNES VALEURS
C               -        -      -   LES COLLECTIONS :
C               -        -      -                     LIGRCH.LIEL
C               -        -      -                     LIGRCH.NEMA
C               -        -      -   ET LE VECTEUR   : LIGRCH.LGNS
C --------------------------------------------------------------------
C
C
C DEB-------------------------------------------------------------------
C
      CHARACTER*8 K8BID
      CHARACTER*1 BASE
      CHARACTER*24 LIGR1, LIGR2
C
C-----------------------------------------------------------------------
      INTEGER IBID ,LON1 ,LON2 ,LONG1 ,LONG2 ,LONG3 ,NMAX1 
      INTEGER NMAX2 
C-----------------------------------------------------------------------
      LIGR1 = LIGRCH//'.TRA1'
      LIGR2 = LIGRCH//'.TRA2'


      CALL JELIRA(LIGRCH//'.LIEL','CLAS',IBID,BASE)

C
C --- COPIE DE LIGRCH.LIEL ET LIGRCH.NEMA SUR LIGR1 ET LIGR2
C
      CALL JELIRA(LIGRCH//'.LIEL','LONT',LON1,K8BID)
      CALL JELIRA(LIGRCH//'.LIEL','NMAXOC',NMAX1,K8BID)
      CALL JEDUPO(LIGRCH//'.LIEL', 'V', LIGR1,.FALSE.)
      CALL JEDETR(LIGRCH//'.LIEL')

      CALL JELIRA(LIGRCH//'.NEMA','LONT',LON2,K8BID)
      CALL JELIRA(LIGRCH//'.NEMA','NMAXOC',NMAX2,K8BID)
      CALL JEDUPO(LIGRCH//'.NEMA', 'V', LIGR2,.FALSE.)
      CALL JEDETR(LIGRCH//'.NEMA')
C
C --- COPIE DE LIGR1 ET LIGR2 SUR LIGRCH.LIEL ET LIGRCH.NEMA
C
      LONG1 = 2*LONG
      LONG1 = MAX(LONG1,LON1+2*ABS((LONG-NMAX1)))
      LONG2 = 4*LONG
      LONG2 = MAX(LONG2,LON2+4*ABS((LONG-NMAX2)))
C
      LONG3=MAX(LONG,NMAX1,NMAX2)
      CALL JEAGCO(LIGR1, LIGRCH//'.LIEL', LONG3, LONG1, BASE)
      CALL JEAGCO(LIGR2, LIGRCH//'.NEMA', LONG3, LONG2, BASE)
C
C --- AGRANDISSEMENT DE LIGRCH.LGNS
C
      CALL JUVECA(LIGRCH//'.LGNS',2*LONG3)
C
C --- MENAGE
C
      CALL JEDETR(LIGR1)
      CALL JEDETR(LIGR2)
C
      END
