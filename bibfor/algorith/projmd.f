      SUBROUTINE PROJMD(TESTC,NP1,NB1,NB2,MAT,VG,VD,MATPR,MTMP1,MTMP2)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/12/2006   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C DESCRIPTION : PROJECTION DE LA MATRICE MAT SUR LA NOUVELLE BASE
C -----------   MODALE DEFINIE PAR SES VECTEURS PROPRES A GAUCHE
C               ET A DROITE, VG ET VD
C
C               APPELANTS : ALITMI, NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER   TESTC, NP1, NB1, NB2
      REAL*8    MAT(NP1,*), VG(NP1,*), VD(NP1,*), MATPR(*),
     &          MTMP1(NP1,*), MTMP2(NP1,*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER   I, IER, IPROD
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL  PRMAMA
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      IF ( TESTC.EQ.1 ) THEN
C
         IPROD = 1
         IER = 0
C
         CALL PRMAMA(IPROD,  MAT,NP1,NB1,NB1,VD,NP1,NB1,NB2,
     &                     MTMP1,NP1,NB1,NB2,IER)
         IF ( IER.NE.0 )
     &      CALL U2MESS('F','ALGORITH10_2')
C
         CALL PRMAMA(IPROD,    VG,NP1,NB2,NB1,MTMP1,NP1,NB1,NB2,
     &                      MTMP2,NP1,NB2,NB2,IER)
         IF ( IER.NE.0 )
     &      CALL U2MESS('F','ALGORITH10_2')
C
         DO 10 I = 1, NB2
            MATPR(I) = MTMP2(I,I)
  10     CONTINUE
C
      ELSE
C
         DO 20 I = 1, NB2
            MATPR(I) = MAT(I,I)
  20     CONTINUE
C
      ENDIF
C
C --- FIN DE PROJMD.
      END
