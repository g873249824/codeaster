      SUBROUTINE TANBUL(OPTION, NDIM, KPG, IMATE, COMPOR, ALPHA, DSBDEP,
     &                  TREPST)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER NDIM, KPG, IMATE

      REAL*8 ALPHA, DSBDEP(6,6), TREPST

      CHARACTER*16 COMPOR

C......................................................................
C     BUT:  CALCUL DE LA MATRICE TANGENTE BULLE
C......................................................................
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  KPG     : NUMERO DU POINT DE GAUSS
C IN  IMATE   : NUMERO DU MATERIAU
C IN  COMPOR  : NOM DU COMPORTEMENT
C OUT  ALPHA  : INVERSE DU MODULE DE COMPRESSIBILITE 1/KAPPA
C OUT  DSBDEP : MATRICE TANGENTE BULLE
C OUT  TREPST : TRACE DU TENSEUR DES DEFORMATIONS THERMIQUES
C......................................................................

      INTEGER K, L
      INTEGER ICODRE(2),ITEMPS,IRET,IEPSV

      REAL*8 E, NU, DEUXMU, TROISK, VALRES(2),VALPAR
      REAL*8 XYZGAU(3), REPERE(7), EPSTH(6), R8MIEM

      CHARACTER*4  FAMI
      CHARACTER*8  NOMRES(2),NOMPAR
      CHARACTER*16 OPTION


C - INITIALISATION
      CALL R8INIR(36, 0.D0, DSBDEP, 1)
      CALL R8INIR( 3, 0.D0, XYZGAU, 1)
      CALL R8INIR( 7, 0.D0, REPERE, 1)
      CALL R8INIR( 6, 0.D0, EPSTH, 1)

      NOMPAR = 'INST'
      FAMI   = 'RIGI'

C - LA FORMULATION INCO A 2 CHAMPS UP NE FONCTIONNE QU AVEC ELAS OU VMIS
C - POUR L INSTANT.
C - POUR L ANISOTROPIE IL FAUDRAIT CALCULER XYZGAU ET REPERE
      IF (.NOT.( COMPOR(1:4) .EQ. 'ELAS'.OR.
     &     COMPOR(1:9) .EQ. 'VMIS_ISOT' )) THEN
        CALL U2MESK('F','ALGORITH4_50',1,COMPOR)
      ENDIF

C - RECUPERATION DE L INSTANT
      CALL TECACH('NNN','PTEMPSR',1,ITEMPS,IRET)
      IF (ITEMPS.NE.0) THEN
        VALPAR = ZR(ITEMPS)
      ELSE
        VALPAR = 0.D0
      ENDIF

C - RECUPERATION DE E ET NU DANS LE FICHIER PYTHON
      NOMRES(1)='E'
      NOMRES(2)='NU'

      CALL RCVALB('RIGI',KPG,1,'+',IMATE,' ','ELAS',1,NOMPAR,VALPAR,2,
     &            NOMRES,VALRES,ICODRE,1)

      E  = VALRES(1)
      NU = VALRES(2)
      ALPHA=(3.D0*(1.D0-2.D0*NU))/E

      DEUXMU = E/(1.D0+NU)
      TROISK = E/(1.D0-2.D0*NU)

      DO 10 K=1,3
        DO 20 L=1,3
          DSBDEP(K,L)=DSBDEP(K,L)+(TROISK/3.D0-DEUXMU/(3.D0))
 20     CONTINUE
 10   CONTINUE
      DO 30 K=1,2*NDIM
        DSBDEP(K,K) = DSBDEP(K,K) + DEUXMU
 30   CONTINUE

      IF(OPTION(1:9)  .NE. 'FORC_NODA' .AND.
     &   OPTION(1:10) .NE. 'RIGI_MECA ') THEN
        CALL EPSTMC(FAMI, NDIM,VALPAR,'+',KPG,1,
     &              XYZGAU,REPERE,IMATE, OPTION, EPSTH)
      ENDIF

C - TEST DE LA NULLITE DES DEFORMATIONS DUES AUX VARIABLES DE COMMANDE
      IEPSV = 0
      TREPST = 0.D0
      DO 90 K = 1, 6
        IF ( ABS(EPSTH(K)).GT.R8MIEM() ) IEPSV=1
 90   CONTINUE
C - TOUTES DES COMPOSANTES SONT NULLES. ON EVITE DE CALCULER TREPST
      IF (IEPSV.NE.0) THEN
        DO 50 K = 1, NDIM
          TREPST = TREPST + EPSTH(K)
 50     CONTINUE
      ENDIF

      END
