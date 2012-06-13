      SUBROUTINE CFINVM(DEFICO,JDECIV,IMA   ,POSMA )
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 DEFICO
      INTEGER      JDECIV,IMA,POSMA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
C
C MAILLE ATTACHEE AU NOEUD (CONNECTIVITE INVERSE)
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE CONTACT (DEFINITION)
C IN  IMA    : NUMERO ORDRE DE LA MAILLE DANS SD CONN. INVERSE.
C IN  JDECIV : DECALAGE POUR LECTURE DANS SD CONN. INVERSE. 
C OUT POSMA  : POSITION DE LA MAILLE
C
C
C
C
      CHARACTER*24 MANOCO
      INTEGER      JMANO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
C --- ACCES SD DE CONTACT
C               
      MANOCO = DEFICO(1:16)//'.MANOCO'
      CALL JEVEUO(MANOCO,'L',JMANO) 
C  
C --- REPONSE
C          
      IF (JDECIV.EQ.-1) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
      POSMA  = ZI(JMANO+JDECIV+IMA-1)      
C
      CALL JEDEMA()
C 
      END
