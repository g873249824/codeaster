      SUBROUTINE CALND2(IC,NP1,NP2,NP3,NBM,TYPCH,NBSEG,
     &                  ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &                  PHII,DEPG,VITGC,DDIST2)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C TOLE  CRP_21
C-----------------------------------------------------------------------
C DESCRIPTION : CALCUL DU DENOMINATEUR DE L'EXPRESSION DE L'INCREMENT
C -----------   TEMPOREL
C
C               APPELANT : NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER    IC, NP1, NP2, NP3, NBM, TYPCH(*), NBSEG(*)
      REAL*8     ALPHA(2,*), BETA(2,*), GAMMA(2,*),
     &           ORIG(6,*), RC(NP3,*), THETA(NP3,*),
     &           PHII(NP2,NP1,*), DEPG(*), VITGC(*), DDIST2
C
C VARIABLES LOCALES
C -----------------
      INTEGER    I, NBS, TYPOBS
      REAL*8     XGLO(3), XXGLO(3), XLOC(3), XTGLO(3), XTLOC(3),
     &           XORIG(3), SINA, COSA, SINB, COSB, SING, COSG,
     &           XJEU, RI, COST, SINT, DNORM, TY, TZ,
     &           TEMP2, TEMP3
C
C FONCTIONS INTRINSEQUES
C ----------------------
C     INTRINSIC  SQRT
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL   DISBUT, GLOLOC, PROJMG, UTMESS
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      TYPOBS = TYPCH(IC)
C
C 1.  PASSAGE DDLS PHYSIQUES
C     ----------------------
      CALL PROJMG(NP1,NP2,IC,NBM,PHII,DEPG,XGLO)
C
C 2.  PASSAGE REPERE GLOBAL -> LOCAL
C     ------------------------------
      XORIG(1) = ORIG(1,IC)
      XORIG(2) = ORIG(2,IC)
      XORIG(3) = ORIG(3,IC)
      XXGLO(1) = XGLO(1) + ORIG(4,IC)
      XXGLO(2) = XGLO(2) + ORIG(5,IC)
      XXGLO(3) = XGLO(3) + ORIG(6,IC)
      SINA = ALPHA(1,IC)
      COSA = ALPHA(2,IC)
      SINB = BETA(1,IC)
      COSB = BETA(2,IC)
      SING = GAMMA(1,IC)
      COSG = GAMMA(2,IC)
      CALL GLOLOC(XXGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,XLOC)
C
C 3.  CALCUL DU DENOMINATEUR DE L'EXPRESSION DE L'INCREMENT TEMPOREL
C     --------------------------------------------------------------
C 3.0 OBSTACLE PARALLELE A YLOCAL
C     ---------------------------
      IF ( TYPOBS.EQ.0 ) THEN
C
         TEMP2 = 0.0D0
         DO 10 I = 1, NBM
            XTGLO(1) = PHII(IC,I,1)
            XTGLO(2) = PHII(IC,I,2)
            XTGLO(3) = PHII(IC,I,3)
            CALL GLOLOC(XTGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,
     &                  XTLOC)
            TEMP2 = TEMP2 + XTLOC(2) * VITGC(I)
  10     CONTINUE
         DDIST2 = -2.0D0 * XLOC(2) * TEMP2
C
C 3.1 OBSTACLE PARALLELE A ZLOCAL
C     ---------------------------
      ELSE IF ( TYPOBS.EQ.1 ) THEN
C
         TEMP3 = 0.0D0
         DO 11 I = 1, NBM
            XTGLO(1) = PHII(IC,I,1)
            XTGLO(2) = PHII(IC,I,2)
            XTGLO(3) = PHII(IC,I,3)
            CALL GLOLOC(XTGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,
     &                  XTLOC)
            TEMP3 = TEMP3 + XTLOC(3) * VITGC(I)
  11     CONTINUE
         DDIST2 = -2.0D0 * XLOC(3) * TEMP3
C
C 3.2 OBSTACLE CIRCULAIRE
C     -------------------
      ELSE IF ( TYPOBS.EQ.2 ) THEN
C
         TEMP2 = 0.0D0
         TEMP3 = 0.0D0
         DO 12 I = 1, NBM
            XTGLO(1) = PHII(IC,I,1)
            XTGLO(2) = PHII(IC,I,2)
            XTGLO(3) = PHII(IC,I,3)
            CALL GLOLOC(XTGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,
     &                  XTLOC)
            TEMP2 = TEMP2 + XTLOC(2) * VITGC(I)
            TEMP3 = TEMP3 + XTLOC(3) * VITGC(I)
  12     CONTINUE
         DDIST2 = -2.0D0 * ( XLOC(2) * TEMP2 + XLOC(3) * TEMP3 )
C
C 3.3 OBSTACLE DISCRETISE
C     -------------------
      ELSE IF ( TYPOBS.EQ.3 ) THEN
C
C 3.3.1  CALCUL DU SIN ET DU COS DE L'ANGLE DE LA NORMALE
C        A L'OBSTACLE ET DE LA DISTANCE NORMALE DE CHOC
C
         NBS = NBSEG(IC)
         RI = SQRT(XLOC(2)*XLOC(2) + XLOC(3)*XLOC(3))
         CALL DISBUT(NP3,IC,XLOC,TYPOBS,XJEU,RC,THETA,NBS,
     &               COST,SINT,DNORM)
C
C 3.3.2  CALCUL DES DERIVEES PARTIELLES DE LA FONCTION TEST
C        PAR RAPPORT A XLOC(2) ET XLOC(3)
C
         TY = 2.0D0 * ( COST*(DNORM+RI) + DNORM*XLOC(2)/RI )
         TZ = 2.0D0 * ( SINT*(DNORM+RI) + DNORM*XLOC(3)/RI )
C
C 3.3.3  CALCUL DU DENOMINATEUR DE L'EXPRESSION DE L'INCREMENT TEMPOREL
C
         TEMP2 = 0.0D0
         TEMP3 = 0.0D0
         DO 13 I = 1, NBM
            XTGLO(1) = PHII(IC,I,1)
            XTGLO(2) = PHII(IC,I,2)
            XTGLO(3) = PHII(IC,I,3)
            CALL GLOLOC(XTGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,
     &                  XTLOC)
            TEMP2 = TEMP2 + XTLOC(2) * VITGC(I)
            TEMP3 = TEMP3 + XTLOC(3) * VITGC(I)
  13     CONTINUE
         DDIST2 = TY * TEMP2 + TZ * TEMP3
C
C 4.  SORTIE EN ERREUR FATALE SI TRAITEMENT NON PREVU POUR LE TYPE
C     D'OBSTACLE DEMANDE
C     ------------------
      ELSE
         CALL UTMESS('F','CALND2','TRAITEMENT NON PREVU POUR LE TYPE '//
     &               'D''OBSTACLE DEMANDE')
C
      ENDIF
C
C --- FIN DE CALND2.
      END
