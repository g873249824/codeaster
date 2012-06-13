      SUBROUTINE RVCHGR (MAILLA,COURBE,NLSNAC,REPERE,SDNEWR,IRET)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 NLSNAC
      CHARACTER*19 SDNEWR
      CHARACTER*8  COURBE, MAILLA, REPERE
      INTEGER      IRET
C
C***********************************************************************
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C  OPERATION REALISEE
C  ------------------
C
C     CALCUL DU REPERE DE TRAVAIL (LOCALE, DIRECTION OU POLAIRE)
C
C  ARGUMENTS EN ENTREE
C  -------------------
C
C     COURBE : NOM DU CONCEPT COURBE LIEU DU POST-TRAITEMENT
C     MAILLA : NOM DU CONCEPT MAILLAGE
C     NLSNAC : NOM DU VECTEUR DES NOEUDS LIEU DE POST-TRAITEMENT
C     REPERE : VAUT 'LOCAL' OU 'POLAIRE'
C
C  ARGUMENTS EN SORTIE
C  -------------------
C
C     IRET   : CODE RETOUR : 1 RAS, 0 ERREUR (EMISSION D' UN MESSAGE)
C     SDNEWR : NOM DE LA SD CONSERVANT LE NOUVEAU REPERE
C
C              .VEC1 : XD V R8 -->   COORD. DU VECTEUR 1 DANS (X,Y)
C              .VEC2 : XD V R8 -->   COORD. DU VECTEUR 2 DANS (X,Y)
C
C              VECJ(2I-1) <--  X(VECT_J,POINT_I)
C              VECJ(2I  ) <--  Y(VECT_J,POINT_I)
C
C              NB_OC = NB_PARTIE DU LIEU
C
C***********************************************************************
C
C  -----------------------------------------
C
C
      CHARACTER*1 K1BID
C
C  ---------------------------------
C
C  VARIABLES LOCALES
C  -----------------
C
      INTEGER I,ND,NBNAC,IND,ALSNAC,ACOORD,IBID,IERD
      LOGICAL EGAL
      REAL*8  ZND,ZREF,AUX
      CHARACTER*8   K8B
      CHARACTER*24 VALK(2)
C
C====================== CORPS DE LA ROUTINE ===========================
C
      CALL JEMARQ()
      I    = 0
      IRET = 1
C
      IF ( REPERE(1:7) .EQ. 'POLAIRE' ) THEN
         CALL DISMOI('C','Z_CST',MAILLA,'MAILLAGE',IBID,K8B,IERD)
         IF ( K8B(1:3) .EQ. 'NON' ) THEN
            IRET = 0
            CALL U2MESS('A', 'POSTRELE_28')
            GOTO 9999
         ENDIF
      ENDIF
C
      IF ( COURBE(1:1) .NE. '&' ) THEN
C
         CALL JEEXIN (COURBE//'.TYPCOURBE', IERD )
         IF ( IERD .EQ. 0 ) THEN
            IRET = 0
            VALK (1) = COURBE
            VALK (2) = REPERE
            CALL U2MESK('A', 'POSTRELE_29',2,VALK)
            GOTO 9999
         ENDIF
C
         CALL JEVEUO(COURBE//'.TYPCOURBE','L',I)
C
         IF ( ZK8(I) .EQ. 'LISTMAIL' ) THEN
C
            CALL RVREPM(MAILLA,COURBE,REPERE,SDNEWR)
C
         ELSE
C
            CALL RVREPC(COURBE,REPERE,SDNEWR)
C
         ENDIF
C
      ELSE
C
         IND = 1
C
         CALL JELIRA(NLSNAC,'LONMAX',NBNAC,K1BID)
         CALL JEVEUO(NLSNAC,'L',ALSNAC)
         CALL JEVEUO(MAILLA//'.COORDO    .VALE','L',ACOORD)
C
         ND = ZI(ALSNAC + 1-1)
C
         ZREF = ZR(ACOORD + 3-1)
C
10       CONTINUE
         IF ( (IRET .NE. 0) .AND. (IND .LE. NBNAC) ) THEN
C
            ND  = ZI(ALSNAC + IND-1)
            ZND = ZR(ACOORD + 3*ND-1)
C
            CALL RVEGAL(1.0D-3,'R',ZREF,ZND,EGAL,AUX)
C
            IF ( .NOT. EGAL ) THEN
C
               IRET = 0
C
            ENDIF
C
            IND = IND + 1
C
            GOTO 10
C
         ENDIF
C
         IF ( IRET .NE. 0 ) THEN
C
            CALL RVREPN(MAILLA,NLSNAC,REPERE,SDNEWR)
C
         ELSE
C
            CALL U2MESS('A', 'POSTRELE_28')
C
         ENDIF
C
      ENDIF
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
