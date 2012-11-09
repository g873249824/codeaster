      SUBROUTINE RSUTRG(NOMSD,IORDR,IRANG,NBORDR)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      INTEGER IORDR,IRANG
      CHARACTER*(*) NOMSD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE PELLET J.PELLET
C      CORRESPONDANCE NUMERO D'ORDRE UTILISATEUR (IORDR) AVEC LE
C      NUMERO DE RANGEMENT (IRANG).
C ----------------------------------------------------------------------
C IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
C IN  : IORDR  : NUMERO D'ORDRE UTILISATEUR.
C OUT : IRANG  : NUMERO DE RANGEMENT.
C        = 0 , LE NUMERO D'ORDRE N'EXISTE PAS ENCORE DANS L'OBJET .ORDR
C OUT : NBORDR : NOMBRE DE NUMEROS DE RANGEMENT UTILISES DANS NOMSD
C ----------------------------------------------------------------------

      CHARACTER*19 NOMD2
      CHARACTER*1 K1BID
      INTEGER NBORDR,JORDR,I,DEBUT,MILIEU,FIN,DIFF,MAXIT
C ----------------------------------------------------------------------

      CALL JEMARQ()
      IRANG = -1
      NOMD2 = NOMSD

C     --- RECUPERATION DU .ORDR :
      CALL JELIRA(NOMD2//'.ORDR','LONUTI',NBORDR,K1BID)
      IF (NBORDR.EQ.0) THEN
        IRANG = 0
        GO TO 20
      ENDIF
      CALL JEVEUO(NOMD2//'.ORDR','L',JORDR)

C     --- ON REGARDE SI .ORDR(K)==K POUR EVITER UNE RECHERCHE
      IF ((IORDR.GE.1) .AND. (IORDR.LE.NBORDR)) THEN
        IF (ZI(JORDR-1+IORDR).EQ.IORDR) THEN
          IRANG = IORDR
          GO TO 20
        END IF
      END IF

C     --- ON REGARDE SI .ORDR(K+1)==K POUR EVITER UNE RECHERCHE
      IF ((IORDR.GE.0) .AND. (IORDR.LE.NBORDR-1)) THEN
        IF (ZI(JORDR-1+IORDR+1).EQ.IORDR) THEN
          IRANG = IORDR + 1
          GO TO 20
        END IF
      END IF


C     --- S'IL N'Y A QU'UN NUMERO D'ORDRE C'EST FACILE :
      IF ( NBORDR.EQ.1 ) THEN
        IF ( ZI(JORDR).EQ.IORDR ) THEN
          IRANG = 1
        ELSE
          IRANG = 0
        ENDIF
        GO TO 20
      ENDIF


C     --- RECHERCHE DU NUMERO DE RANGEMENT (DICHOTOMIE)
C         LA DICHOTOMIE N'EST POSSIBLE QUE PARCE QUE
C         LES NUMEROS D'ORDRE SONT CROISSANTS DANS .ORDR
      IRANG=0
      DEBUT = 0
      FIN   = NBORDR-1
      MAXIT = 1+LOG(1.D0*NBORDR+1.D0)/LOG(2.D0)
      DO 10 I = 1,MAXIT
        DIFF = (FIN-DEBUT)/2
        MILIEU = DEBUT+DIFF
        IF ( ZI(JORDR+MILIEU).EQ.IORDR ) THEN
          IRANG = MILIEU+1
          GO TO 20
        ELSEIF ( ZI(JORDR+MILIEU).GT.IORDR ) THEN
          FIN = MILIEU-1
        ELSE
          DEBUT = MILIEU+1
        ENDIF
        IF ( DEBUT.GE.FIN ) THEN
          DIFF = (FIN-DEBUT)/2
          MILIEU = DEBUT+DIFF
          IF ( ZI(JORDR+MILIEU).EQ.IORDR ) IRANG = MILIEU+1
          GO TO 20
        ENDIF
   10 CONTINUE
      CALL ASSERT(.FALSE.)

   20 CONTINUE
      CALL ASSERT(IRANG.GE.0)
      CALL JEDEMA()
      END
