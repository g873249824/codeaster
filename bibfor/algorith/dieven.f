      SUBROUTINE DIEVEN(SDDISC,EVEN  ,LACTI )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT   NONE
      CHARACTER*19  SDDISC
      CHARACTER*(*) EVEN
      LOGICAL       LACTI
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE EVENEMENT
C
C RETOURNE LA VALEUR D'UN EVENEMENT
C
C ----------------------------------------------------------------------
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  EVEN   : NOM D'EVENEMENT A ACTIVER
C OUT LACTI  : .TRUE. SI ACTIVE
C              .FALSE. SI DESACTIVE
C
C ----------------------------------------------------------------------
C
      INTEGER      NECHEC,IECHEC,IEVENT
      CHARACTER*8  K8BID
      INTEGER      IBID
      REAL*8       R8BID
      CHARACTER*16 NOMEVE,ACTIVE
C
C ----------------------------------------------------------------------
C      
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IBID  ,'NB_OCC',
     &            R8BID ,NECHEC,K8BID )
      IEVENT = 0
      LACTI  = .FALSE.
C
C --- RECHERCHE DU NUMERO D'OCCURENCE DE L'EVENEMENT
C
      DO 10 IECHEC = 1,NECHEC
        CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'NOM_EVEN',
     &              R8BID ,IBID  ,NOMEVE)
        IF (EVEN.EQ.NOMEVE) IEVENT = IECHEC
 10   CONTINUE      
C
C --- LECTURE DE L'EVENEMENT
C
      IF (IEVENT.NE.0) THEN
        CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVENT,'VERIF_EVEN',
     &              R8BID ,IBID  ,ACTIVE)
        IF (ACTIVE.EQ.'OUI') THEN
          LACTI  = .TRUE.
        ELSEIF (ACTIVE.EQ.'NON') THEN
          LACTI  = .FALSE.
        ELSE
          WRITE(6,*) 'DIEVEN: ',NOMEVE,IEVENT,ACTIVE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF      
C    
      END
