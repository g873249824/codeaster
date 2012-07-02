      SUBROUTINE GIINCO()
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
      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C     BUT: CREER LA COLLECTION '&&GILIRE.CORR_GIBI_ASTER'
C          QUI DONNE LA PERMUTATION DES NOEUDS DES MAILLES
C          (GIBI--> ASTER)
C          CETTE COLLECTION EST UTILISEE DANS GIECMA.
C
C ----------------------------------------------------------------------
C
C     VARIABLES LOCALES:
      INCLUDE 'jeveux.h'
      CHARACTER*24 NOMCOL
C
C
C-----------------------------------------------------------------------
      INTEGER IACORR 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      NOMCOL='&&GILIRE.CORR_GIBI_ASTER'
C
      CALL JECREC(NOMCOL,'V V I','NO','CONTIG','VARIABLE',17)
C
C     ON DIMENSIONNE LA COLLECTION:
C     -----------------------------
      CALL JECROC(JEXNOM(NOMCOL,'POI1'))
      CALL JEECRA(JEXNOM(NOMCOL,'POI1'),'LONMAX',1,' ')
      CALL JECROC(JEXNOM(NOMCOL,'SEG2'))
      CALL JEECRA(JEXNOM(NOMCOL,'SEG2'),'LONMAX',2,' ')
      CALL JECROC(JEXNOM(NOMCOL,'SEG3'))
      CALL JEECRA(JEXNOM(NOMCOL,'SEG3'),'LONMAX',3,' ')
      CALL JECROC(JEXNOM(NOMCOL,'TRI3'))
      CALL JEECRA(JEXNOM(NOMCOL,'TRI3'),'LONMAX',3,' ')
      CALL JECROC(JEXNOM(NOMCOL,'TRI6'))
      CALL JEECRA(JEXNOM(NOMCOL,'TRI6'),'LONMAX',6,' ')
      CALL JECROC(JEXNOM(NOMCOL,'QUA4'))
      CALL JEECRA(JEXNOM(NOMCOL,'QUA4'),'LONMAX',4,' ')
      CALL JECROC(JEXNOM(NOMCOL,'QUA8'))
      CALL JEECRA(JEXNOM(NOMCOL,'QUA8'),'LONMAX',8,' ')
      CALL JECROC(JEXNOM(NOMCOL,'QUA9'))
      CALL JEECRA(JEXNOM(NOMCOL,'QUA9'),'LONMAX',9,' ')
      CALL JECROC(JEXNOM(NOMCOL,'CUB8'))
      CALL JEECRA(JEXNOM(NOMCOL,'CUB8'),'LONMAX',8,' ')
      CALL JECROC(JEXNOM(NOMCOL,'CU20'))
      CALL JEECRA(JEXNOM(NOMCOL,'CU20'),'LONMAX',20,' ')
      CALL JECROC(JEXNOM(NOMCOL,'CU27'))
      CALL JEECRA(JEXNOM(NOMCOL,'CU27'),'LONMAX',27,' ')
      CALL JECROC(JEXNOM(NOMCOL,'PRI6'))
      CALL JEECRA(JEXNOM(NOMCOL,'PRI6'),'LONMAX', 6,' ')
      CALL JECROC(JEXNOM(NOMCOL,'PR15'))
      CALL JEECRA(JEXNOM(NOMCOL,'PR15'),'LONMAX',16,' ')
      CALL JECROC(JEXNOM(NOMCOL,'TET4'))
      CALL JEECRA(JEXNOM(NOMCOL,'TET4'),'LONMAX',4,' ')
      CALL JECROC(JEXNOM(NOMCOL,'TE10'))
      CALL JEECRA(JEXNOM(NOMCOL,'TE10'),'LONMAX',10,' ')
      CALL JECROC(JEXNOM(NOMCOL,'PYR5'))
      CALL JEECRA(JEXNOM(NOMCOL,'PYR5'),'LONMAX',5,' ')
      CALL JECROC(JEXNOM(NOMCOL,'PY13'))
      CALL JEECRA(JEXNOM(NOMCOL,'PY13'),'LONMAX',13,' ')
C
C     POI1:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'POI1'),'E',IACORR)
      ZI(IACORR-1+1)= 1
C
C     SEG2:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'SEG2'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
C
C     SEG3:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'SEG3'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 2
C
C     TRI3:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'TRI3'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
C
C     TRI6:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'TRI6'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 2
      ZI(IACORR-1+5)= 4
      ZI(IACORR-1+6)= 6
C
C     QUA4:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'QUA4'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
      ZI(IACORR-1+4)= 4
C
C     QUA8:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'QUA8'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 7
      ZI(IACORR-1+5)= 2
      ZI(IACORR-1+6)= 4
      ZI(IACORR-1+7)= 6
      ZI(IACORR-1+8)= 8
C
C     QUA9:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'QUA9'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 7
      ZI(IACORR-1+5)= 2
      ZI(IACORR-1+6)= 4
      ZI(IACORR-1+7)= 6
      ZI(IACORR-1+8)= 8
      ZI(IACORR-1+9)= 9
C
C     CUB8:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'CUB8'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
      ZI(IACORR-1+4)= 4
      ZI(IACORR-1+5)= 5
      ZI(IACORR-1+6)= 6
      ZI(IACORR-1+7)= 7
      ZI(IACORR-1+8)= 8
C
C     CU20:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'CU20'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 7
      ZI(IACORR-1+5)= 13
      ZI(IACORR-1+6)= 15
      ZI(IACORR-1+7)= 17
      ZI(IACORR-1+8)= 19
      ZI(IACORR-1+9)= 2
      ZI(IACORR-1+10)= 4
      ZI(IACORR-1+11)= 6
      ZI(IACORR-1+12)= 8
      ZI(IACORR-1+13)= 9
      ZI(IACORR-1+14)= 10
      ZI(IACORR-1+15)= 11
      ZI(IACORR-1+16)= 12
      ZI(IACORR-1+17)= 14
      ZI(IACORR-1+18)= 16
      ZI(IACORR-1+19)= 18
      ZI(IACORR-1+20)= 20
C
C     CU27:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'CU27'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 7
      ZI(IACORR-1+5)= 13
      ZI(IACORR-1+6)= 15
      ZI(IACORR-1+7)= 17
      ZI(IACORR-1+8)= 19
      ZI(IACORR-1+9)= 2
      ZI(IACORR-1+10)= 4
      ZI(IACORR-1+11)= 6
      ZI(IACORR-1+12)= 8
      ZI(IACORR-1+13)= 9
      ZI(IACORR-1+14)= 10
      ZI(IACORR-1+15)= 11
      ZI(IACORR-1+16)= 12
      ZI(IACORR-1+17)= 14
      ZI(IACORR-1+18)= 16
      ZI(IACORR-1+19)= 18
      ZI(IACORR-1+20)= 20
      ZI(IACORR-1+21)= 25
      ZI(IACORR-1+22)= 21
      ZI(IACORR-1+23)= 22
      ZI(IACORR-1+24)= 23
      ZI(IACORR-1+25)= 24
      ZI(IACORR-1+26)= 26
      ZI(IACORR-1+27)= 27
C
C     PRI6:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'PRI6'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
      ZI(IACORR-1+4)= 4
      ZI(IACORR-1+5)= 5
      ZI(IACORR-1+6)= 6
C
C     PR15:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'PR15'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 10
      ZI(IACORR-1+5)= 12
      ZI(IACORR-1+6)= 14
      ZI(IACORR-1+7)= 2
      ZI(IACORR-1+8)= 4
      ZI(IACORR-1+9)= 6
      ZI(IACORR-1+10)= 7
      ZI(IACORR-1+11)= 8
      ZI(IACORR-1+12)= 9
      ZI(IACORR-1+13)= 11
      ZI(IACORR-1+14)= 13
      ZI(IACORR-1+15)= 15
C
C     TET4:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'TET4'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
      ZI(IACORR-1+4)= 4
C
C     TE10:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'TE10'),'E',IACORR)
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 3
      ZI(IACORR-1+3)= 5
      ZI(IACORR-1+4)= 10
      ZI(IACORR-1+5)= 2
      ZI(IACORR-1+6)= 4
      ZI(IACORR-1+7)= 6
      ZI(IACORR-1+8)= 7
      ZI(IACORR-1+9)= 8
      ZI(IACORR-1+10)= 9
C
C     PYR5:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'PYR5'),'E',IACORR)
C     ON NE CONNAIT PAS ENCORE LA NUMEROTATION ASTER ...
      ZI(IACORR-1+1)= 1
      ZI(IACORR-1+2)= 2
      ZI(IACORR-1+3)= 3
      ZI(IACORR-1+4)= 4
      ZI(IACORR-1+5)= 5
C
C     PY13:
C     -----
      CALL JEVEUO(JEXNOM(NOMCOL,'PY13'),'E',IACORR)
C     ON NE CONNAIT PAS ENCORE LA NUMEROTATION ASTER ...
      ZI(IACORR-1+1) = 1
      ZI(IACORR-1+6) = 2
      ZI(IACORR-1+2) = 3
      ZI(IACORR-1+7) = 4
      ZI(IACORR-1+3) = 5
      ZI(IACORR-1+8) = 6
      ZI(IACORR-1+4) = 7
      ZI(IACORR-1+9) = 8
      ZI(IACORR-1+10)= 9
      ZI(IACORR-1+11)= 10
      ZI(IACORR-1+12)= 11
      ZI(IACORR-1+13)= 12
      ZI(IACORR-1+5) = 13
C
C
C
      CALL JEDEMA()
      END
