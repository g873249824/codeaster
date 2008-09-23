      SUBROUTINE NMOBSV(MAILLA,SDDISC,NUMINS,LISINS,SDIMPR,
     &                  SDSUIV,SDOBSE,SDDYNA,RESOCO,VALPLU,
     &                  LSUIVI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      NUMINS
      CHARACTER*8  MAILLA
      CHARACTER*24 VALPLU(8)
      CHARACTER*24 RESOCO
      CHARACTER*24 SDIMPR
      CHARACTER*24 SDSUIV
      CHARACTER*19 SDDYNA,SDDISC,LISINS
      CHARACTER*14 SDOBSE
      LOGICAL      LSUIVI        
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C REALISER UNE OBSERVATION OU UN SUIVI_DDL
C      
C ----------------------------------------------------------------------
C
C
C IN  MAILLA : NOM DU MAILLAGE
C IN  LISINS : LISTE DES INSTANTS
C IN  NUMINS : NUMERO D'INSTANT
C IN  SDOBSE : SD OBSERVATION
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDIMPR : SD AFFICHAGE
C IN  SDSUIV : SD POUR LE SUIVI DE DDL
C IN  SDDYNA : SD DYNAMIQUE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  LSUIVI : = TRUE  SI ON REALISE UN SUIVI DDL
C              = FALSE SI ON REALISE UNE OBSERVATION
C      
C ----------------------------------------------------------------------
C 
      REAL*8  DIINST,INSTAN
C      
C ----------------------------------------------------------------------
C   
C
C --- TEMPS COURANT
C
      INSTAN = DIINST(SDDISC,NUMINS)
C
C --- SUIVI/OBSERVATION
C
      CALL DYOBAR(MAILLA,INSTAN,LISINS,SDIMPR,SDSUIV,
     &            SDOBSE,SDDYNA,RESOCO,VALPLU,LSUIVI)      
C
      END
