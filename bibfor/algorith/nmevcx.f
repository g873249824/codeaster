      SUBROUTINE NMEVCX(SDDISC,NUMINS,DEFICO,RESOCO,IECHEC,
     &                  IEVDAC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/10/2012   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*24 DEFICO,RESOCO
      INTEGER      IECHEC,IEVDAC,NUMINS
      CHARACTER*19 SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
C
C DETECTION DE L'EVENEMENT COLLISION
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  NUMINS : NUMERO D'INSTANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  IECHEC : OCCURRENCE DE L'ECHEC
C OUT IEVDAC : VAUT IECHEC SI EVENEMENT DECLENCHE
C                   0 SINON
C
C ----------------------------------------------------------------------
C
      LOGICAL CFDISL,LCTCC,LCTCD
C
C ----------------------------------------------------------------------
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LCTCD  = CFDISL(DEFICO,'FORMUL_DISCRETE')
      IEVDAC = 0
C
      IF (LCTCD) THEN
        CALL NMEVCO(SDDISC,NUMINS,RESOCO,IECHEC,IEVDAC)
      ELSEIF (LCTCC) THEN
        CALL NMEVCC(SDDISC,NUMINS,DEFICO,RESOCO,IECHEC,
     &              IEVDAC)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END
