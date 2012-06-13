      SUBROUTINE CFADUF(RESOCO,NDIM  ,NBLIAI,NBLIAC,LLF   ,
     &                  LLF1  ,LLF2  )
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
       IMPLICIT      NONE
      INCLUDE 'jeveux.h'
       INTEGER       NDIM,NBLIAI
       INTEGER       NBLIAC,LLF,LLF1,LLF2
       CHARACTER*24  RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C CALCUL DU SECOND MEMBRE - CAS DU FROTTEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C IN  LLF    : NOMBRE DE LIAISONS DE FROTTEMENT (EN 2D)
C              NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LES DEUX 
C               DIRECTIONS SIMULTANEES (EN 3D)
C IN  LLF1   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA 
C               PREMIERE DIRECTION (EN 3D)
C IN  LLF2   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA 
C               SECONDE DIRECTION (EN 3D)
C
C
C
C
      CHARACTER*19 LIAC,MU
      INTEGER      JLIAC,JMU
      CHARACTER*24 JEUX
      INTEGER      JJEUX
      REAL*8       JEUINI,JEXINI,JEYINI
      INTEGER      ILIAI,ILIAC,TYPE0,DEKLAG,BTOTAL
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DEKLAG = 0
      BTOTAL = NBLIAC + LLF + LLF1 + LLF2
C
C --- ACCES STRUCTURES DE DONNEES DE CONTACT
C          
      LIAC   = RESOCO(1:14)//'.LIAC'
      JEUX   = RESOCO(1:14)//'.JEUX'
      MU     = RESOCO(1:14)//'.MU' 
      CALL JEVEUO(LIAC,  'L',JLIAC )
      CALL JEVEUO(JEUX  ,'L',JJEUX )
      CALL JEVEUO(MU,    'E',JMU   )
C
C --- INITIALISATION MU
C
      CALL R8INIR(NDIM*NBLIAI,0.D0,ZR(JMU),1)
C 
C --- ON MET {JEU(DEPTOT)} - [A].{DDEPL0} DANS MU
C
      DO 10 ILIAC = 1, BTOTAL
C
C ----- TYPE DE LA LIAISON
C   
        ILIAI  = ZI(JLIAC-1+ILIAC)
        CALL CFTYLI(RESOCO,ILIAC,TYPE0)
C
        GOTO (1000,2000,3000,4000) TYPE0
C
C ----- CALCUL DE MU_C
C
 1000   CONTINUE
          JEUINI = ZR(JJEUX+3*(ILIAI-1)+1-1)
          ZR(JMU+ILIAC+DEKLAG-1) = JEUINI
          GOTO 10
C
C ----- CALCUL DE MU_A - 2D OU 3D DANS LES DEUX DIRECTIONS
C ----- DEPUIS LE DEBUT DU PAS DE TEMPS
C
 2000   CONTINUE
          JEXINI = ZR(JJEUX+3*(ILIAI-1)+2-1)
          ZR(JMU+ILIAC+DEKLAG-1) = - JEXINI
          IF (NDIM.EQ.3) THEN
            JEYINI = ZR(JJEUX+3*(ILIAI-1)+3-1)
            DEKLAG = DEKLAG + 1
            ZR(JMU+ILIAC+DEKLAG-1) = - JEYINI
          ENDIF
          GOTO 10
C
C ----- CALCUL DE MU_A 3D - 3D PREMIERE DIRECTION
C ----- DEPUIS LE DEBUT DU PAS DE TEMPS
C
 3000   CONTINUE
          JEXINI = ZR(JJEUX+3*(ILIAI-1)+2-1)
          ZR(JMU+ILIAC+DEKLAG-1) = - JEXINI
          GOTO 10
C
C ----- CALCUL DE MU_A 3D - 3D SECONDE DIRECTION
C ----- DEPUIS LE DEBUT DU PAS DE TEMPS
C
 4000   CONTINUE
          JEYINI = ZR(JJEUX+3*(ILIAI-1)+3-1)
          ZR(JMU+ILIAC+DEKLAG-1) = - JEYINI
C
 10    CONTINUE
C
       CALL JEDEMA()
       END
