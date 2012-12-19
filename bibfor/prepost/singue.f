      SUBROUTINE SINGUE (CHERRS,CHENES,NOMAIL,NDIM,NNOEM,NELEM,XY,
     &                    PREC,LIGRMO,CHELEM,TYPES)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      INTEGER NDIM,NNOEM,NELEM
      REAL*8  XY(3,NNOEM),PREC
      CHARACTER*8 NOMAIL
      CHARACTER*16 TYPES
      CHARACTER*19 CHERRS,CHENES
      CHARACTER*24 LIGRMO,CHELEM
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
C TOLE CRS_1404
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
C
C     BUT:
C         1) RECUPERATION DE L ERREUR ET DE L ENERGIE EN CHAQUE EF
C         2) CALCUL DU DEGRE DE LA SINGULARITE
C         3) CALCUL DU RAPPORT ENTRE L ANCIENNE ET LA NOUVELLE TAILLE
C         4) CALCUL DE LA NOUVELLE TAILLE DES EF
C            RQ : CES TROIS QUANTITES SONT CALCULEES DANS CHAQUE ELEMENT
C                 ET SONT CONSTANTES PAR ELEMENT
C         5) STOCKAGE DE CES DEUX COMPOSANTES DANS CHELEM
C         OPTION : 'SING_ELEM'
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   CHERRS      : NOM SD_S OU EST STOCKE L ERREUR
C IN   CHENES      : NOM SD_S OU EST STOCKE L ENERGIE
C IN   NOMAIL      : NOM DU MAILLAGE
C IN   NDIM        : DIMENSION DU PROBLEME
C IN   NNOEM       : NOMBRE DE NOEUDS DU MAILLAGE
C IN   NELEM       : NOMBRE D ELEMENTS FINIS DU MAILLAGE
C IN   XY(3,NNOEM) : COORDONNEES DES NOEUDS
C IN   PREC        : % DE L ERREUR TOTALE SOUHAITE
C                   POUR CALCULER LA NOUVELLE CARTE DE TAILLE
C                   DES EF H*
C                   ERREUR_TOTALE(H*)=PREC*ERREUR_TOTALE
C IN   LIGRMO      : NOM DU LIGREL DU MODELE
C IN   CHELEM      : CHAM_ELEM QUI VA CONTENIR LE DEGRE ET LA TAILLE
C IN   TYPES       : TYPE DE L ESTIMATEUR D ERREUR (NOM DE L OPTION)
C
C      SORTIE :
C-------------
C
C ......................................................................
C
C
C
C
      INTEGER JDIME,JMESU,JCONN,JCINV
      INTEGER JCESC,JCESD,JCESL,JCESV,IAD
      INTEGER NSOMMX,NELCOM,DEGRE
      INTEGER NBCMP,NCMP
      INTEGER ICMP,INEL,NBR(NELEM),NALPHA
      REAL*8  ERREUR(NELEM),TAILLE(NELEM),ENERGI(NELEM)
      REAL*8  ALPHA(NELEM),RE(NELEM),HE(NELEM)
      CHARACTER*8  K8BID

      CALL JEMARQ()
C
C 1 - RECUPERATION DES ADRESSES DES OBJETS CREES DANS SINGUM
C
      CALL JEVEUO('&&SINGUM.DIME           ','L',JDIME)
      CALL JEVEUO('&&SINGUM.MESU           ','L',JMESU)
      CALL JEVEUO('&&SINGUM.CONN           ','L',JCONN)
      CALL JEVEUO('&&SINGUM.CINV           ','L',JCINV)
C
C 2 - NSOMMX = NBRE MAX DE NOEUDS SOMMETS CONNECTES AUX EF
C     NELCOM = NBRE MAX D EFS SURF EN 2D OU VOL EN 3D
C              CONNECTES AUX NOEUDS
C     DEGRE  = 1 EF LINEAIRE - 2 EF QUADRATIQUE

      NSOMMX=ZI(JDIME+1-1)
      NELCOM=ZI(JDIME+2-1)
      DEGRE =ZI(JDIME+3-1)
C
C 3 - RECUPERATION DE L'ERREUR EN CHAQUE EF ERREUR(EF)
C       ET DE LA TAILLE EN CHAQUE EF TAILLE(EF)
C     NOMBRE DE COMPOSANTES A STOCKER PAR EF NBR(NELEM)
C       2 SI EF SURFACIQUES EN 2D OU VOLUMIQUES EN 3D
C       0 SINON

      CALL JEVEUO(CHERRS//'.CESC','L',JCESC)
      CALL JELIRA(CHERRS//'.CESC','LONMAX',NBCMP,K8BID)
      CALL JEVEUO(CHERRS//'.CESD','L',JCESD)
      CALL JEVEUO(CHERRS//'.CESL','L',JCESL)
      CALL JEVEUO(CHERRS//'.CESV','L',JCESV)
C
C LECTURE DE LA SD .CESC
      DO 10 ICMP=1,NBCMP
        IF (ZK8(JCESC+ICMP-1)(1:6).EQ.'ERREST') NCMP=ICMP
 10   CONTINUE

      DO 20 INEL=1,NELEM
        CALL CESEXI('C',JCESD,JCESL,INEL,1,1,NCMP,IAD)
        IF (IAD.GT.0) THEN
          ERREUR(INEL)=ZR(JCESV+IAD-1)
          NBR(INEL)=3
        ELSE
          ERREUR(INEL)=0.D0
          NBR(INEL)=0
        ENDIF
 20   CONTINUE
C
C LECTURE DE LA SD .CESC
      DO 30 ICMP=1,NBCMP
        IF (ZK8(JCESC+ICMP-1)(1:6).EQ.'TAILLE') NCMP=ICMP
 30   CONTINUE

      DO 40 INEL=1,NELEM
        CALL CESEXI('C',JCESD,JCESL,INEL,1,1,NCMP,IAD)
        IF (IAD.GT.0) THEN
          TAILLE(INEL)=ZR(JCESV+IAD-1)
          NBR(INEL)=3
        ELSE
          TAILLE(INEL)=0.D0
          NBR(INEL)=0
        ENDIF
 40   CONTINUE
C
C 4 - RECUPERATION DE L'ENERGIE EN CHAQUE EF ENERGI(EF)
C
      CALL JEVEUO(CHENES//'.CESC','L',JCESC)
      CALL JELIRA(CHENES//'.CESC','LONMAX',NBCMP,K8BID)
      CALL JEVEUO(CHENES//'.CESD','L',JCESD)
      CALL JEVEUO(CHENES//'.CESL','L',JCESL)
      CALL JEVEUO(CHENES//'.CESV','L',JCESV)
C
C LECTURE DE LA SD .CESC
      DO 50 ICMP=1,NBCMP
        IF (ZK8(JCESC+ICMP-1)(1:6).EQ.'TOTALE') NCMP=ICMP
 50   CONTINUE

      DO 60 INEL=1,NELEM
        CALL CESEXI('C',JCESD,JCESL,INEL,1,1,NCMP,IAD)
        IF (IAD.GT.0) THEN
          ENERGI(INEL)=ZR(JCESV+IAD-1)
        ELSE
          ENERGI(INEL)=0.D0
        ENDIF
 60   CONTINUE
C
C 5 - CALCUL DU DEGRE DE LA SINGULARITE ALPHA(NELEM) PAR EF
C
      CALL DSINGU(NDIM,NELEM,NNOEM,NSOMMX,NELCOM,DEGRE,ZI(JCONN),
     &        ZI(JCINV),XY,ERREUR,ENERGI,ZR(JMESU),
     &        ALPHA,NALPHA)
C
C 6 - CALCUL DU RAPPORT DE TAILLE DES EF RE=HE*/HE
C     HE TAILLE DE L EF ACTUEL - HE* TAILLE DU NOUVEL EF
C
      CALL RSINGU(NDIM,NELEM,NBR,NALPHA,DEGRE,PREC,ERREUR,ALPHA,
     &            TYPES,RE)
C
C 7 - CALCUL DE LA NOUVELLE TAILLE DES EF HE*=RE*HE
C     HE TAILLE DE L EF ACTUEL - HE* TAILLE DU NOUVEL EF

      CALL TSINGU(NELEM,NBR,RE,TAILLE,HE)
C
C 8 - STOCKAGE DE ALPHA ET RE DANS CHELEM
C
      CALL SSINGU(NOMAIL,NELEM,NBR,LIGRMO,ALPHA,RE,HE,CHELEM)

      CALL JEDEMA()

      END
