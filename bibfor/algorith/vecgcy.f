      SUBROUTINE VECGCY(NOMRES,NUMEG)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
C
C***********************************************************************
C    O. NICOLAS      DATE 12/05/05
C-----------------------------------------------------------------------
C  BUT: INITIALISER UN VECTEUR GENERALISE A ZERO
C
C     CONCEPT CREE: VECT_ASSE_GENE
C
C-----------------------------------------------------------------------
C
C
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*8 NOMRES,NUMEG,MODGEN
      CHARACTER*19 NOMNUM,NOMSTO
      INTEGER      LLREF,IAVALE,IAREFE,IADESC,J,NEQ
C
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER JSCDE 
C-----------------------------------------------------------------------
      CALL JEMARQ()

C     1/ LECTURE ET STOCKAGE DES INFORMATIONS
C     =======================================
      NOMNUM = NUMEG//'      .NUME'
      NOMSTO = NUMEG//'      .SLCS'
      CALL JEVEUO(NOMNUM//'.REFN','L',LLREF)
      MODGEN=ZK24(LLREF)(1:8)

      CALL JEVEUO(NOMSTO//'.SCDE','L',JSCDE)
      NEQ=ZI(JSCDE-1+1)
C
      CALL WKVECT(NOMRES//'           .VALE','G V R',NEQ,IAVALE)
      CALL WKVECT(NOMRES//'           .REFE','G V K24',2,IAREFE)
      CALL WKVECT(NOMRES//'           .DESC','G V I',3,IADESC)
      ZK24(IAREFE) = MODGEN
      ZK24(IAREFE+1) = NOMNUM
      ZI(IADESC) = 1
      ZI(IADESC+1) = NEQ

      DO 60 J = 1,NEQ
          ZR(IAVALE+J) = 0.D0
   60   CONTINUE
C
C
C
      CALL JEDEMA()
      END
