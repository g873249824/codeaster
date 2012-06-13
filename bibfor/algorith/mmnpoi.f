      SUBROUTINE MMNPOI(NOMA  ,NOMMAE,NUMNOE,IPTM  ,NOMPT )
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
      CHARACTER*8  NOMMAE
      INTEGER      IPTM,NUMNOE
      CHARACTER*16 NOMPT
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - SD APPARIEMENT)
C
C NOM DU POINT DE CONTACT
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMMAE : NOM DE LA MAILLE ESCLAVE
C IN  NUMNOE : NOM DU NOEUD
C               VAUT -1 SI CE LE POINT DE CONTACT N'EST PAS UN NOEUD
C IN  IPTM   : NUMERO DU PT D'INTEGRATION ( SI PAS INTEG. AUX NOEUDS)
C OUT NOMPT  : NOM DU POINT DE CONTACT
C
C
C
C
      CHARACTER*4  FOR4
      CHARACTER*8  NOMNOE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
C
      WRITE(FOR4,'(I4)') IPTM
      IF (NUMNOE.GT.0) THEN
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOE),NOMNOE)
        NOMPT  = 'NOEUD   '//NOMNOE
      ELSE 
        WRITE(FOR4,'(I4)') IPTM
        NOMPT  = NOMMAE//'-PT '//FOR4
      ENDIF    
C      
      CALL JEDEMA()     
C
      END
