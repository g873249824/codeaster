      SUBROUTINE AVGRDO( NBVEC, NBORDR, VECTN, VWORK, TDISP, KWORK,
     &                   SOMMW, TSPAQ, I, NOMMAT, NOMCRI,
     &                   NOMFOR,GRDVIE, FORVIE, VALA, COEFPA,
     &                   NCYCL,VMIN,VMAX, OMIN, OMAX,POST,CUDOMX,VNORMX)

      IMPLICIT      NONE
      INCLUDE 'jeveux.h'

      INTEGER       NBVEC, NBORDR, TDISP, KWORK, SOMMW, TSPAQ, I
      REAL*8        VECTN(3*NBVEC)
      REAL*8        VWORK(TDISP)
      CHARACTER*16  NOMCRI, FORVIE,NOMFOR
      CHARACTER*8   NOMMAT,GRDVIE
      INTEGER       OMIN(NBVEC*(NBORDR+2)), OMAX(NBVEC*(NBORDR+2))
      REAL*8        VALA, COEFPA
      REAL*8        VMIN(NBVEC*(NBORDR+2)), VMAX(NBVEC*(NBORDR+2))
      INTEGER       VNORMX, NCYCL(NBVEC)
      LOGICAL       POST
      REAL*8        CUDOMX

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRS_1404 CRP_21
C---------------------------------------------------------------------
C BUT:    POUR LA FATIGUE A AMPLITUDE VARIABLE
C         A PARTIR DES PICS PAR LE COMPTAGE DE RAINFLOW,DETERMINER
C         LE PLAN CRITIQUE OU LE DOMMAGE TOTAL MAXIMAL
C ----------------------------------------------------------------------
C ARGUMENTS :
C  NBVEC  : IN   I  : NOMBRE DE VECTEURS NORMAUX.
C  NBORDR : IN   I  : NOMBRE DE NUMEROS D'ORDRE.
C  VECTN  : IN   R  : VECTEUR CONTENANT LES COMPOSANTES DES
C                     VECTEURS NORMAUX.
C  VWORK  : IN   R  : VECTEUR DE TRAVAIL CONTENANT
C                     L'HISTORIQUE DES TENSEURS DES CONTRAINTES
C                     ATTACHES A CHAQUE POINT DE GAUSS DES MAILLES
C                     DU <<PAQUET>> DE MAILLES.
C  TDISP  : IN   I  : TAILLE DU VECTEUR DE TRAVAIL.
C  KWORK  : IN   I  : KWORK = 0 ON TRAITE LA 1ERE MAILLE DU PAQUET
C                               MAILLES OU LE 1ER NOEUD DU PAQUET DE
C                               NOEUDS;
C                     KWORK = 1 ON TRAITE LA IEME (I>1) MAILLE DU PAQUET
C                               MAILLES OU LE IEME NOEUD DU PAQUET
C                               DE NOEUDS.
C  SOMMW  : IN   I  : SOMME DES POINTS DE GAUSS OU DES NOEUDS DES N
C                     MAILLES PRECEDANT LA MAILLE COURANTE.
C  TSPAQ  : IN   I  : TAILLE DU SOUS-PAQUET DU <<PAQUET>> DE MAILLES
C                     OU DE NOEUDS COURANT.
C  I      : IN   I  : IEME POINT DE GAUSS OU IEME NOEUD.
C  NOMMAT   IN   K  : NOM DU MATERIAU.
C  NOMCRI : IN  K16 : NOM DU CRITERE D'ENDOMMAGEMENT PAR FATIGUE.
C  VALA     IN   R  : VALEUR DU PARAMETRE a ASSOCIE AU CRITERE.
C  COEFPA   IN   R  : COEFFICIENT DE PASSAGE CISAILLEMENT - UNIAXIAL.
C  NCYCL    IN   I  : NOMBRE DE CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C  VMIN     IN   R  : VALEURS MIN DES CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C  VMAX     IN   R  : VALEURS MAX DES CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C  OMIN     IN   I  : NUMEROS D'ORDRE ASSOCIES AUX VALEURS MIN DES
C                     CYCLES ELEMENTAIRES POUR TOUS LES VECTEURS
C                     NORMAUX.
C  OMAX     IN   I  : NUMEROS D'ORDRE ASSOCIES AUX VALEURS MAX DES
C                     CYCLES ELEMENTAIRES POUR TOUS LES VECTEURS
C                     NORMAUX.
C  VNORMX   OUT  I  : NUMERO DU VECTEUR NORMAL ASSOCIE AU MAX DES CUMULS
C                     DE DOMMAGE.
C  CUDOMX   OUT  R  : VALEUR DU MAX DES CUMULS DE DOMMAGE.
C ----------------------------------------------------------------------
C     ------------------------------------------------------------------
C  VSIGN  VECTEUR CONTENANT LES VALEURS DE LA CONTRAINTE
C         NORMALE, POUR TOUS LES NUMEROS D'ORDRE
C         DE CHAQUE VECTEUR NORMAL.
C  VPHYDR VECTEUR CONTENANT LA PRESSION HYDROSTATIQUE A
C         TOUS LES INSTANTS.
C  GDREQ  VECTEUR CONTENANT LES VALEURS DE LA GRANDEUR
C         EQUIVALENTE, POUR TOUS LES NUMEROS D'ORDRE
C         DE CHAQUE VECTEUR NORMAL.
C  DOMEL  VECTEUR CONTENANT LES VALEURS DES DOMMAGES
C         ELEMENTAIRES, POUR TOUS LES SOUS CYCLES
C         DE CHAQUE VECTEUR NORMAL.
C  NRUPT  VECTEUR CONTENANT LES NOMBRES DE CYCLES
C         ELEMENTAIRES, POUR TOUS LES SOUS CYCLES
C         DE CHAQUE VECTEUR NORMAL.
C  DOMTOT VECTEUR CONTENANT LES DOMMAGES TOTAUX (CUMUL)
C         DE CHAQUE VECTEUR NORMAL

      REAL*8     GDREQ(NBVEC*NBORDR)
      REAL*8     NRUPT(NBVEC*NBORDR), DOMEL(NBVEC*NBORDR),DOMTOT(NBVEC)
C  ------------------------------------------------------------------
C  ---------------------
C C ------------------------------------------------------------------
C       DATA  NOMPAR/  'TAUPR_1','TAUPR_2','SIGN_1','SIGN_2',
C      &               'PHYDR_1','PHYDR_2','EPSPR_1', 'EPSPR_2'  /
C C-------------------------------------------------------------------

C 1.3 CALCUL DE LA GRANDEUR EQUIVALENTE AU SENS DU CRITERE CHOISI :
C     MATAKE_MODI_AV, FATEMI ET SOCIE (ELASTIQUE OU PLASTIQUE), DANG VAN
         CALL AVCRIT( NBVEC, NBORDR, VECTN, VWORK, TDISP, KWORK,
     &                   SOMMW, TSPAQ,I,VALA, COEFPA, NCYCL, VMIN,
     &        VMAX, OMIN, OMAX, NOMCRI, NOMFOR, GDREQ)

C          CALL AVCRIT(NBVEC, NBORDR, VALA, COEFPA, NCYCL,
C      &               VMIN, VMAX, OMIN, OMAX,NOMCRI,NOMFOR,
C      &               VSIGN, VPHYDR, GDREQ)

C 2. CALCUL DU DOMMAGE ELEMENTAIRE DE WOHLER

         CALL AVDOWH(NBVEC, NBORDR, NOMMAT, NOMCRI, NCYCL,
     &                  GDREQ, GRDVIE, FORVIE,POST, DOMEL, NRUPT)

C 3. CALCUL DU DOMMAGE TOTAL (CUMUL)

         CALL AVDOMT(NBVEC, NBORDR, NCYCL, DOMEL, DOMTOT)

C 4. CALCUL DU CUMUL DE DOMMAGE MAXIMAL ET VECTEUR NORMAL ASSOCIE

         CALL AVCDMX(NBVEC, DOMTOT, CUDOMX, VNORMX)

      END
