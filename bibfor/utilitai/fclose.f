      SUBROUTINE FCLOSE ( UNIT )
      IMPLICIT   NONE
      INTEGER             UNIT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 05/09/2005   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_6
C
C     FERMETURE DE L'UNITE LOGIQUE fort.UNIT
C     UTILE POUR APPEL DEPUIS PYTHON UNE FOIS LES BASES JEVEUX FERMEES
C     CAR ULOPEN N EST ALORS PLUS UTILISABLE (CONFER E_JDC.py)
C
C IN  : UNIT   : NUMERO D'UNITE LOGIQUE
C     ------------------------------------------------------------------
      INTEGER       IERR
      CHARACTER*4   K4B
C     ------------------------------------------------------------------
C     
      CLOSE (UNIT=UNIT, IOSTAT=IERR)
      IF ( IERR .GT. 0 ) THEN
        WRITE(K4B,'(I3)') UNIT
        CALL UTMESS('F','ULOPEN20','UNITE LOGIQUE '//K4B
     &        //', PROBLEME LORS DU CLOSE ')
      ENDIF
C
      END
