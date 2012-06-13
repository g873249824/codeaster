      SUBROUTINE CFRESO(RESOCO,LDSCON,NDIM  ,NBLIAC,LLF   ,
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
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 RESOCO
      INTEGER      NDIM
      INTEGER      NBLIAC,LLF,LLF1,LLF2
      INTEGER      LDSCON
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C RESOLUTION DE [-A.C-1.AT].{MU} = {JEU(DEPTOT) - A.DDEPL0}
C
C ----------------------------------------------------------------------
C
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LDSCON : DESCRIPTEUR DE LA MATRICE DE CONTACT
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  ISTO   : INDICATEUR D'ARRET EN CAS DE PIVOT NUL
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
      INTEGER      ILIFIN,NEQMAX
      COMPLEX*16   C16BID      
      CHARACTER*19 MU
      INTEGER      JMU
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C 
      MU     = RESOCO(1:14)//'.MU'
      CALL JEVEUO(MU    ,'E',JMU   )
C      
C --- INITIALISATIONS
C      
      ILIFIN = NBLIAC+(NDIM-1)*LLF+LLF1+LLF2
C
C --- ON NE RESOUD LE SYSTEME QUE DE 1 A ILIFIN
C
      NEQMAX       = ZI(LDSCON+2)
      ZI(LDSCON+2) = ILIFIN
C
C --- RESOLUTION : [-A.C-1.AT].{MU} = {JEU(DEPTOT) - A.DDEPL0}
C
      CALL RLDLGG(LDSCON,ZR(JMU),C16BID,1)
      ZI(LDSCON+2) = NEQMAX
C 
      CALL JEDEMA() 
C
      END 
