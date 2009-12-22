      SUBROUTINE MMREMA(NOMA  ,DEFICO,NEWGEO,COORPT,POSNOM,
     &                  ITEMAX,EPSMAX,TOLEOU,DIRAPP,DIR   ,
     &                  POSMAM,NUMMAM,JEU   ,TAU1M ,TAU2M ,
     &                  KSI1  ,KSI2  ,PROJIN)
C       
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  NOMA
      CHARACTER*24 NEWGEO,DEFICO
      REAL*8       COORPT(3)
      INTEGER      POSNOM
      LOGICAL      DIRAPP
      REAL*8       DIR(3)
      INTEGER      POSMAM,NUMMAM
      REAL*8       JEU
      REAL*8       TAU1M(3),TAU2M(3)
      REAL*8       KSI1,KSI2
      LOGICAL      PROJIN
      INTEGER      ITEMAX
      REAL*8       EPSMAX,TOLEOU            
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C RECHERCHER LA MAILLE MAITRE LA PLUS PROCHE CONNAISSANT LE NOEUD 
C MAITRE LE PLUS PROCHE DU POINT DE CONTACT ET FAIRE LA PROJECTION 
C SELON UNE DIRECTION DE RECHERCHE DONNEE
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : NOUVELLE GEOMETRIE (AVEC DEPLACEMENT GEOMETRIQUE)
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  COORPT : COORDONNEES DU POINT DE CONTACT
C IN  POSNOM : POSITION DU NOEUD MAITRE LE PLUS PROCHE
C IN  ITEMAX : NOMBRE MAXI D'ITERATIONS DE NEWTON POUR LA PROJECTION
C IN  EPSMAX : RESIDU POUR CONVERGENCE DE NEWTON POUR LA PROJECTION 
C IN  TOLEOU : TOLERANCE POUR LE PROJETE HORS SURFACE MAITRE
C IN  DIRAPP : VAUT .TRUE. SI APPARIEMENT DANS UNE DIRECTION DE 
C              RECHERCHE DONNEE (PAR DIR)
C IN  DIR    : DIRECTION D'APPARIEMENT
C OUT POSMAM : POSITION DE LA MAILLE MAITRE LA PLUS PROCHE
C OUT NUMMAM : NUM. ABS. DE LA MAILLE MAITRE LA PLUS PROCHE
C OUT JEU    : JEU MINIMUM
C OUT TAU1M  : PREMIERE TANGENTE SUR LA MAILLE MAITRE EN KSI1
C OUT TAU2M  : SECONDE TANGENTE SUR LA MAILLE MAITRE EN KSI1 
C OUT KSI1   : COORDONNEE X DE LE PROJECTION MINIMALE DU POINT DE 
C              CONTACT SUR LA MAILLE MAITRE
C OUT KSI2   : COORDONNEE Y DE LE PROJECTION MINIMALE DU POINT DE 
C              CONTACT SUR LA MAILLE MAITRE
C OUT PROJIN : VAUT .TRUE. SI LA PROJECTION DU POINT DE CONTACT N'EST
C              PAS LE RESULTAT DU RABATTEMENT 
C              .FALSE. S'IL Y A EU RABATTEMENT PARCE QU'ELLE SERAIT
C              TOMBEEE HORS DE LA MAILLE MAITRE (A LA TOLERANCE PRES)
C
C ----------------------------------------------------------------------
C 
      LOGICAL      LDIST      
C
C ----------------------------------------------------------------------
C               
C
C --- PROJECTION SUR LA MAILLE MAITRE
C --- CALCUL DU JEU MINIMUM, DES COORDONNEES DU POINT PROJETE
C --- ET DES DEUX VECTEURS TANGENTS
C      
      CALL CFPROJ(NOMA  ,DEFICO,NEWGEO,POSNOM,ITEMAX,
     &            EPSMAX,TOLEOU,DIRAPP,DIR   ,COORPT,
     &            POSMAM,NUMMAM,JEU   ,KSI1  ,KSI2  ,
     &            TAU1M ,TAU2M     ,LDIST )
C
C --- TRAITEMENT DU CAS DU RABATTEMENT
C
      PROJIN = .TRUE.
      IF (.NOT.LDIST)      PROJIN = .FALSE.
      IF (DIRAPP)          PROJIN = .TRUE.
      END
