      SUBROUTINE PROJSQ(NDIM,COORDA,COORDB,COORDC,COORDP,MOYEN,TANGDF,
     &                  NORM,TANG,
     &                  COORDM,LAMBDA,DEBORD,
     &                  OLDJEU,JEU)

C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================

      IMPLICIT NONE

      INTEGER NDIM
      REAL*8  COORDA(3)
      REAL*8  COORDB(3)
      REAL*8  COORDC(3)
      REAL*8  COORDP(3)
      INTEGER MOYEN
      INTEGER TANGDF
      REAL*8  NORM(3)
      REAL*8  TANG(6)
      REAL*8  COORDM(3)
      REAL*8  LAMBDA
      REAL*8  DEBORD
      REAL*8  OLDJEU
      REAL*8  JEU
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJSE
C ----------------------------------------------------------------------
C
C "PROJECTION" D'UN NOEUD ESCLAVE P SUR UN SEGMENT QUADRATIQUE AB.
C ON UTILISE LA NORMALE ENTRANTE A LA MAILLE MAITRE AB.
C
C IN  NDIM   : DIMENSION DU PB
C IN  COORDA : COORDONNEES DU SOMMET A DU SEGMENT
C IN  COORDB : COORDONNEES DU SOMMET B DU SEGMENT
C IN  COORDC : COORDONNEES DU MILIEU C DU SEGMENT
C IN  COORDP : COORDONNEES DU NOEUD ESCLAVE P
C IN  MOYEN  : INDICATEUR DES NORMALES D'APPARIEMENT 
C               0 NORMALE A LA MAILLE MAITRE
C               1 NORMALE MOYENNE A LA MAILLE MAITRE ET MAILLE ESCALVE
C IN  TANGDF : INDICATEUR DE PRESENCE D'UN VECT_Y DEFINI L'UTILISATEUR
C               0 PAS DE VECT_Y
C               1 UN VECT_Y EST DEFINI
C OUT NORM   : NORMALE ENTRANTE A LA MAILLE MAITRE
C I/O TANG   : VECTEURS TANGENTS 
C OUT LAMBDA : COORDONNEE PARAMETRIQUE DE LA "PROJECTION" M
C OUT DEBORD : PROJECTION HORS DE LA MAILLE
C              >0 : PROJECTION HORS DE LA MAILLE
C              <0 : PROJECTION SUR LA MAILLE
C OUT COORDM : COORDONNEES DE LA "PROJECTION" M
C OUT OLDJEU : JEU AVANT CORRECTION DES PROJECTIONS TOMBANT HORS DE
C              LA MAILLE MAITRE
C OUT JEU    : JEU DANS LA DIRECTION (NORM) DE LA NORMALE ENTRANTE
C              A LA MAILLE MAITRE (PM.NORM)
C
C ----------------------------------------------------------------------

       INTEGER K,J
       REAL*8 DENOM,R8DOT
       REAL*8 DIST,DIST1,DIST2,LAMBD1,LAMBD2,PREC
       REAL*8 COEF(3),VECSEG(3)

C ----------------------------------------------------------------------

       DEBORD = -1.D0
C
C --- CALCUL DE LA COORDONNEE PARAMETRIQUE LAMBDA DE M DANS AB
C
       DENOM = (COORDB(1)-COORDA(1))**2 + (COORDB(2)-COORDA(2))**2
       IF (NDIM.EQ.3) THEN
         DENOM = DENOM + (COORDB(3)-COORDA(3))**2
       END IF
       IF (DENOM.EQ.0.D0) THEN
         CALL UTMESS('F','PROJSQ','UNE MAILLE MAITRE EST DE '//
     &               'LONGUEUR NULLE')
       END IF


       DIST1 = (COORDP(1)-COORDA(1))**2 + (COORDP(2)-COORDA(2))**2
       DIST2 = (COORDP(1)-COORDB(1))**2 + (COORDP(2)-COORDB(2))**2
       IF (NDIM.EQ.3) THEN
         DIST1 = DIST1 + (COORDP(3)-COORDA(3))**2
         DIST2 = DIST2 + (COORDP(3)-COORDB(3))**2
       END IF


       IF(DIST2.LT.DIST1) THEN
         DIST1 = (COORDP(1)-COORDB(1))**2 + (COORDP(2)-COORDB(2))**2
         DIST2 = (COORDP(1)-COORDA(1))**2 + (COORDP(2)-COORDA(2))**2
         IF (NDIM.EQ.3) THEN
           DIST1 = DIST1 + (COORDP(3)-COORDB(3))**2
           DIST2 = DIST2 + (COORDP(3)-COORDA(3))**2
         END IF
         LAMBD1 = 1.0D0
         LAMBD2 = 0.0D0
       ELSE
         LAMBD1 = 0.0D0
         LAMBD2 = 1.0D0
       ENDIF

       LAMBDA = (LAMBD1 + LAMBD2)/2.D0


C --- BOUCLE POUR TROUVER M
       DO 10 J = 1,10000

         COEF(1) = 2.D0* (1.D0-LAMBDA)* (0.5D0-LAMBDA)
         COEF(2) = 2.D0*LAMBDA* (LAMBDA-0.5D0)
         COEF(3) = 4.D0*LAMBDA* (1.D0-LAMBDA)

         DO 15 K = 1,2
           COORDM(K) = COEF(1)*COORDA(K)+COEF(2)*COORDB(K)
     &                +COEF(3)*COORDC(K)
   15    CONTINUE
         IF (NDIM.EQ.3) THEN
           COORDM(3) = COEF(1)*COORDA(3)+COEF(2)*COORDB(3)
     &              +COEF(3)*COORDC(3)
         ELSE
           COORDM(3) = 0.D0
         END IF

         DIST = (COORDP(1)-COORDM(1))**2 + (COORDP(2)-COORDM(2))**2
         IF (NDIM.EQ.3) THEN 
           DIST = DIST + (COORDP(3)-COORDM(3))**2
         ENDIF
         IF(DIST.LT.DIST1) THEN
           DIST2 = DIST1
           DIST1 = DIST
           LAMBD2 = LAMBD1
           LAMBD1 = LAMBDA
         ELSE
           DIST2 = DIST
           LAMBD2 = LAMBDA
         ENDIF
       
         IF(LAMBD1.LT.LAMBD2) THEN
            LAMBDA = LAMBD1 + (LAMBD2-LAMBD1)/2.D0
         ELSE
            LAMBDA = LAMBD2 + (LAMBD1-LAMBD2)/2.D0
         ENDIF

         PREC = ABS(LAMBD2-LAMBD1)/DENOM
         IF(PREC.LT.1.D-3) GOTO 20

   10    CONTINUE
   20  CONTINUE

C --- CALCUL DU JEU ET DE LA DIRECTION DE PROJECTION (UNITAIRE)

       DO 30 K = 1,3
         NORM(K) = COORDM(K) - COORDP(K)
   30  CONTINUE
       OLDJEU = SQRT(R8DOT(3,NORM,1,NORM,1))
       IF (NDIM.EQ.3) THEN
         VECSEG(1) = (COORDB(1)-COORDA(1))/SQRT(DENOM)
         VECSEG(2) = (COORDB(2)-COORDA(2))/SQRT(DENOM)
         VECSEG(3) = (COORDB(3)-COORDA(3))/SQRT(DENOM)
         NORM(1) = VECSEG(2)*TANG(3) - VECSEG(3)*TANG(2)
         NORM(2) = VECSEG(3)*TANG(1) - VECSEG(1)*TANG(3)
         NORM(3) = VECSEG(1)*TANG(2) - VECSEG(2)*TANG(1)
       ELSE
         NORM(1) = - (COORDB(2)-COORDA(2))/SQRT(DENOM)
         NORM(2) = (COORDB(1)-COORDA(1))/SQRT(DENOM)
         NORM(3) = 0.D0
       END IF
C ----------------------------------------------------------------------

C JEU SUIVANT LA NORMALE A LA MAILLE MAITRE
      JEU = (COORDM(1)-COORDP(1))*NORM(1) +
     &      (COORDM(2)-COORDP(2))*NORM(2)
      IF (NDIM.EQ.3) THEN 
        JEU = JEU + (COORDM(3)-COORDP(3))*NORM(3)
      ENDIF
C NOUVELLE TANGENTE A LA MAILLE MAITRE
      CALL CFTANG(3,NORM,TANG,TANGDF)


C ----------------------------------------------------------------------

      END
