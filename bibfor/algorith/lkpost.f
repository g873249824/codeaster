      SUBROUTINE LKPOST(IMATE,TEMPD,SIGF,NVI,VIP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/09/2012   AUTEUR FOUCAULT A.FOUCAULT 
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
      IMPLICIT NONE
      INTEGER  IMATE,NVI
      REAL*8   TEMPD,SIGF(6),VIP(NVI)
C =================================================================
C IN  : IMATE  : ADRESSE DU MATERIAU CODE -------------------------
C --- : TEMPD  : TEMPERATURE BIDON --------------------------------
C --- : NVI    : NOMBRE DE VARIABLES INTERNES ---------------------
C OUT : VIP    : MISE A JOUR DES VARIABLES INTERNES DE POST -------
C =================================================================
      INTEGER     DIMPAR
      PARAMETER(DIMPAR=12)
      INTEGER     CERR(DIMPAR)
      REAL*8      MATER(DIMPAR),I1,SII,DEVSIG(6),LGLEPS,COS3T,RCOS3T
      REAL*8      LKCRIT,CRIT0,CRITE
      PARAMETER(LGLEPS=1.0D-8)
      CHARACTER*8 NOMC(DIMPAR)

C =================================================================
C --- RECUPERATION DES PROPRIETES MATERIAUX -----------------------
C =================================================================
      NOMC(1)  =  'XI_PIC   '
      NOMC(2)  =  'XI_E     '
      NOMC(3)  =  'XI_ULT   '
      NOMC(4)  =  'A_0      '
      NOMC(5)  =  'M_0      '
      NOMC(6)  =  'S_0      '
      NOMC(7)  =  'XIV_MAX  '
      NOMC(8)  =  'MV_MAX   '
      NOMC(9)  =  'SIGMA_C  '
      NOMC(10) =  'GAMMA_CJS'
      NOMC(11) =  'PA       '
      NOMC(12) =  'H0_EXT   '

      CALL RCVALA(IMATE,' ','LETK',1,'TEMP',TEMPD,DIMPAR,
     &            NOMC(1),MATER(1),CERR(1),0)

C =================================================================
C --- DEFINITION DU NIVEAU DE DEGRADATION DE LA ROCHE SUIVANT LE DOMAINE
C --- DOMAINE = 0 : LE COMPORTEMENT RESTE ELASTIQUE
C --- DOMAINE = 1 : LA ROCHE EST FISSUREE PRE-PIC
C --- DOMAINE = 2 : LA ROCHE EST FISSUREE POST-PIC
C --- DOMAINE = 3 : LA ROCHE EST FRACTUREE
C --- DOMAINE = 4 : LA ROCHE EST DANS SON ETAT RESIDUEL
C =================================================================
      IF (VIP(1).EQ.0.0D0) THEN
         VIP(8) = 0
      ELSE IF (VIP(1).LT.MATER(1)) THEN
         VIP(8) = 1
      ELSE IF (VIP(1).LT.MATER(2)) THEN
         VIP(8) = 2
      ELSE IF (VIP(1).LT.MATER(3)) THEN
         VIP(8) = 3
      ELSE
         VIP(8) = 4
      ENDIF

C =================================================================
C --- VARIABLE DE POST-TRAITEMENT POUR SUIVRE L'EVOLUTION DE
C --- L'ETAT DE CONTRAINTE PAR RAPPORT AUX DIFFERENTS SEUILS
C --- INDIC = 1 : LA POSITION DE L'ETAT DE CONTRAINTE EST EN-DESSOUS
C ---           : DU SEUIL D'ENDOMMAGEMENT INITIAL ET AU-DESSUS DU
C ---           : SEUIL DE VISCOSITE MAXIMAL (ATTENTION NOTION
C ---           : DIFFERENTE DE LA DEFINITION INITIALE)
C --- INDIC = 2 : LA POSITION DE L'ETAT DE CONTRAINTE EST EN-DESSOUS
C ---           : DU SEUIL D'ENDOMMAGEMENT INITIAL ET EN-DESSOUS DU
C ---           : SEUIL DE VISCOSITE MAXIMAL
C --- INDIC = 3 : LA POSITION DE L'ETAT DE CONTRAINTE EST AU-DESSUS
C ---           : DU SEUIL D'ENDOMMAGEMENT INITIAL ET EN-DESSOUS DU
C ---           : SEUIL DE VISCOSITE MAXIMAL
C --- INDIC = 4 : LA POSITION DE L'ETAT DE CONTRAINTE EST AU-DESSUS
C ---           : DU SEUIL D'ENDOMMAGEMENT INITIAL ET AU-DESSUS DU
C ---           : SEUIL DE VISCOSITE MAXIMAL
C =================================================================
      CALL LCDEVI(SIGF,DEVSIG)
      I1     = -SIGF(1)-SIGF(2)-SIGF(3)
      CALL LCPRSC(DEVSIG, DEVSIG, SII)
      SII    = SQRT(SII)
      RCOS3T = -COS3T(DEVSIG, MATER(11), LGLEPS)

      CRIT0 = LKCRIT(MATER(4),MATER(5),MATER(6),MATER(10),MATER(9),
     +               MATER(12),RCOS3T,I1,SII)
      CRITE = LKCRIT(1.0D0,MATER(8),MATER(6),MATER(10),MATER(9),
     +               MATER(12),RCOS3T,I1,SII)

      IF (CRIT0.LT.0.0D0.AND.CRITE.GT.0.0D0) THEN
         VIP(9) = 1
      ELSE IF (CRIT0.LT.0.0D0.AND.CRITE.LT.0.0D0) THEN
         VIP(9) = 2
      ELSE IF (CRIT0.GT.0.0D0.AND.CRITE.LT.0.0D0) THEN
         VIP(9) = 3
      ELSE
         VIP(9) = 4
      ENDIF
      END
