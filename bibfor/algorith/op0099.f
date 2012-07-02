      SUBROUTINE OP0099()
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C=====================================================================
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
C  P. RICHARD - DATE 09/07/91
C-----------------------------------------------------------------------
C  BUT : OPERATEUR DE DEFINITION DE BASE MODALE POUR SUPERPOSITION OU
C        SYNTHESE MODALE : DEFI_BASE_MODALE
C
C  DEUX TYPES DE BASE MODALE : CLASSIQUE
C                              RITZ
C
C CLASSIQUE : BASE MODALE DE TYPE MIXTE CRAIG-BAMPTON - MAC-NEAL (1)
C --------
C DETERMINEE A PARTIR D'UNE 'INTERF_DYNA' DE TYPE CONNU ET D'UN OU
C DE 'MODE_MECA' BASES SUR LE MEME 'NUME_DDL'
C L'OPERATEUR POINTE SUR LES MODES CALCULES DU OU DES 'MODE_MECA'
C ET CALCULE LES DEFORMEES STATIQUES IMPOSEES PAR LA DEFINITION
C DES INTERFACES
C
C RITZ: BASE DE RITZ (A RE-DEVELOPPER)
C -----
C L'OPERATEUR COLLECTE TOUS LES RESULTATS ET LES MET SOUS UNE MEME
C NUMEROTATION DITE DE REFERENCE
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMRES
      CHARACTER*16 NOMOPE,NOMCON
      CHARACTER*19 SOLVEU
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C --- PHASE DE VERIFICATION
C
C-----------------------------------------------------------------------
      INTEGER IFM ,IOC1 ,IOC3 ,IOC4 ,IOC5 ,NIV 
C-----------------------------------------------------------------------
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
C --- ECRITURE TITRE ET RECUPERATION NOM ARGUMENT
C
      CALL TITRE
      CALL GETRES(NOMRES,NOMCON,NOMOPE)
C
C --- CONTROLE DE LA COHERENCE ET CREATION DU .REFE
C
      CALL REFE99(NOMRES)
C
C --- TYPE DE BASE MODALE CREE
C
      CALL GETFAC('CLASSIQUE',IOC1)
      CALL GETFAC('RITZ',IOC3)
      CALL GETFAC('DIAG_MASS',IOC4)
      CALL GETFAC('ORTHO_BASE',IOC5)


C     -- CREATION DU SOLVEUR :
      SOLVEU='&&OP0099.SOLVEUR'
      CALL CRESOL(SOLVEU)

C
C --- CAS D'UNE BASE MODALE CLASSIQUE
C
      IF (IOC1.GT.0) THEN
        CALL CLAS99(NOMRES)
C
C --- CAS D'UNE BASE MODALE DE RITZ
C
      ELSEIF (IOC3.GT.0) THEN
        CALL RITZ99(NOMRES)
        CALL ORTH99(NOMRES,1)
C
C --- CAS D'UNE DIAGONALISATION DE LA MASSE
C
      ELSEIF (IOC4.GT.0) THEN

        CALL DIAG99(NOMRES)

      ELSEIF (IOC5.GT.0) THEN

        CALL ORTH99(NOMRES,0)
      ENDIF


C --- IMPRESSION SUR FICHIER
      IF (NIV.GT.1) CALL IMBAMO(NOMRES,IFM)
C
      
      END
