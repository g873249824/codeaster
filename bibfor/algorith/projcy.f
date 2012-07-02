      SUBROUTINE PROJCY(NOMRES)
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C***********************************************************************
C    P. RICHARD     DATE 11/03/91
C-----------------------------------------------------------------------
C  BUT:  CALCULER LES SOUS-MATRICES OBTENUES A PARTIR DES PROJECTIONS
      IMPLICIT NONE
C     DES MATRICES MASSE ET RAIDEUR SUR LES MODES ET LES DEFORMEES
C    STATIQUECS
C
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*8 NOMRES,TYPINT
      CHARACTER*24 REPMAT,SOUMAT
      CHARACTER*24 VALK
      LOGICAL NOOK
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER LDDTYP ,LLREF 
C-----------------------------------------------------------------------
      DATA NOOK /.TRUE./
C-----------------------------------------------------------------------
C
C--------------------RECUPERATION DES CONCEPTS AMONT--------------------
C
      CALL JEMARQ()
      CALL JEVEUO(NOMRES//'.CYCL_REFE','L',LLREF)
C
C-------------CAS DE LA DONNEE D'UNE BASE MODALE------------------------
C
      SOUMAT='&&OP0080.CYCLIC.SOUS.MAT'
      REPMAT='&&OP0080.CYCLIC.REPE.MAT'
C
C--------------RECUPERATION DU TYPE D'INTERFACE-------------------------
C
      CALL JEVEUO(NOMRES//'.CYCL_TYPE','L',LDDTYP)
      TYPINT=ZK8(LDDTYP)
C
C----------------CALCUL SOUS-MATRICES DANS LE CAS CRAIG-BAMPTON---------
C                        ET CRAIG-BAMPTON HARMONIQUE
C
      IF(TYPINT.EQ.'CRAIGB  '.OR.TYPINT.EQ.'CB_HARMO')THEN
        CALL PRCYCB(NOMRES,SOUMAT,REPMAT)
        NOOK=.FALSE.
      ENDIF
C
C----------------CALCUL SOUS-MATRICES DANS LE CAS MAC NEAL--------------
C
      IF(TYPINT.EQ.'MNEAL  ')THEN
        CALL PRCYMN(NOMRES,SOUMAT,REPMAT)
        NOOK=.FALSE.
      ENDIF
C
C----------------CALCUL SOUS-MATRICES DANS LE CAS AUCUN-----------------
C        (=MAC NEAL SANS FLEXIBILITE RESIDUELLE)
C
      IF(TYPINT.EQ.'AUCUN   ')THEN
        CALL PRCYMN(NOMRES,SOUMAT,REPMAT)
        NOOK=.FALSE.
      ENDIF
C
C--------------AUTRE CAS -----------------------------------------------
C
      IF(NOOK) THEN
        VALK = TYPINT
        CALL U2MESG('F', 'ALGORITH14_3',1,VALK,0,0,0,0.D0)
      ENDIF
C
      CALL JEDEMA()
      END
