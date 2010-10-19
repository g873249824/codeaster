      SUBROUTINE MMTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &                  NDEXFR,POSNOE,KSI1  ,KSI2  ,POSMAM,
     &                  NUMMAM,TAU1M ,TAU2M ,TAU1  ,TAU2  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/10/2010   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*8   NOMA
      INTEGER       IZONE
      INTEGER       NDIMG
      INTEGER       POSNOE,POSMAM,NUMMAM
      REAL*8        KSI1,KSI2   
      CHARACTER*24  DEFICO,RESOCO
      REAL*8        TAU1M(3),TAU2M(3)
      REAL*8        TAU1(3),TAU2(3)
      INTEGER       NDEXFR
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C MOD. LES VECTEURS TANGENTS LOCAUX SUIVANT OPTIONS
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT 
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  NDIMG  : DIMENSION DE L'ESPACE
C IN  IZONE  : ZONE DE CONTACT ACTIVE
C IN  POSMAM : POSITION DE LA MAILLE MAITRE DANS LES SD CONTACT
C IN  NUMMAM : NUMERO ABSOLU MAILLE MAITRE QUI RECOIT LA PROJECTION
C IN  POSNOE : POSITION DU PT INTEG DANS LES SD CONTACT SI INTEG.NOEUDS
C IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE 
C              SUR MAILLE MAITRE
C IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE 
C              SUR MAILLE MAITRE
C IN  TAU1M  : PREMIERE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
C              PROJETE
C IN  TAU2M  : SECONDE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
C              PROJETE
C OUT TAU1   : PREMIERE TANGENTE LOCALE AU POINT ESCLAVE PROJETE
C OUT TAU2   : SECONDE TANGENTE LOCALE AU POINT ESCLAVE PROJETE
C
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C         
      IF (NUMMAM.LE.0) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CHOIX DE LA NORMALE
C
      CALL CFTANR(NOMA  ,NDIMG ,DEFICO,RESOCO,IZONE ,
     &            POSNOE,'MAIL',POSMAM,NUMMAM,KSI1  ,
     &            KSI2  ,TAU1M ,TAU2M ,TAU1  ,TAU2  )              
C                 
C --- REPERE LOCAL TANGENT AVEC SANS_GROUP_NO_FR -> FIXE
C 
      IF (NDEXFR.NE.0) THEN 
        CALL MMEXFR(DEFICO,IZONE ,TAU1  ,TAU2  )
      ENDIF
C
      END
