      SUBROUTINE MMNUMN(NOMA  ,TYPINT,NUMMAE,NNOMAE,IPTM  ,
     &                  NUMNOE)
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMA
      INTEGER      TYPINT
      INTEGER      NUMMAE,IPTM,NUMNOE,NNOMAE
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C NUMERO ABSOLU DU POINT DE CONTACT 
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  TYPINT : TYPE D'INTEGRATION
C IN  NUMMAE : NUMERO ABSOLU DE LA MAILLE ESCLAVE
C IN  NNOMAE : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  IPTM   : NUMERO DU POINT D'INTEGRATION DANS LA MAILLE 
C OUT NUMNOE : NUMERO ABSOLU DU POINT DE CONTACT
C                  VAUT -1 SI LE POINT N'EST PAS UN NOEUD
C            
C
C           
C
C
      INTEGER INOE,JCONNX
C  
C ----------------------------------------------------------------------
C
      CALL JEMARQ()          
C
C --- INITIALISATIONS
C
      NUMNOE = -1      
C
C --- ACCES MAILLAGE
C      
      CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',NUMMAE),'L',JCONNX)
C
C --- NUMERO ABSOLU DU NOEUD
C
      IF (TYPINT.EQ.1) THEN
        IF (IPTM.GT.NNOMAE) THEN
          NUMNOE = -1
        ELSE
          INOE   = IPTM
          NUMNOE = ZI(JCONNX+INOE-1)
        ENDIF 
      ELSE
        NUMNOE = -1  
      ENDIF  
C 
      CALL JEDEMA()
      END
