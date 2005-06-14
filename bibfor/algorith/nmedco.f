      SUBROUTINE NMEDCO(COMPOR,OPTION,IMATE,NPG,LGPG,S,Q,
     &                  VIM,VIP,ALPHAP,DALFS)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2005   AUTEUR LAVERNE J.LAVERNE 
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
 
      IMPLICIT NONE
          
      INTEGER IMATE,NPG,LGPG    
      REAL*8 S(2),Q(2,2),ALPHAP(2),DALFS(2,2)
      REAL*8 VIM(LGPG,NPG),VIP(LGPG,NPG)
      CHARACTER*16 COMPOR(*), OPTION      
      
C ----------------------------------------------------------------------
C     INTEGRATION DES LOIS DE COMPORTEMENT NON LINEAIRE POUR LES
C     ELEMENTS A DISCONTINUITE INTERNE.
C     LE COMPORTEMENT ETANT PARTICULIER, CETTE ROUTINE FAIT OFFICE DE 
C     'NMCOMP.F' POUR DE TELS ELEMENTS.
C
C     REMARQUE : CETTE ROUTINE N'EST PAS DANS UNE BOULCE SUR LES PG CAR
C                LES VI SONT CONSTANTES SUR CHAQUE ELEMENT.
C-----------------------------------------------------------------------
C IN 
C     NPG     : NOMBRE DE POINTS DE GAUSS
C     LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C     IMATE   : ADRESSE DU MATERIAU CODE
C     COMPOR  : COMPORTEMENT :  (1) = TYPE DE RELATION COMPORTEMENT
C                               (2) = NB VARIABLES INTERNES / PG
C                               (3) = HYPOTHESE SUR LES DEFORMATIONS
C     OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C     VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C     S,Q     : QUANTITES CINEMATIQUES NECESSAIRES POUR CALCUL DU SAUT
C
C OUT 
C     ALPHAP  : SAUT A L'INSTANT PLUS
C     VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C     DALFS   : DEVIVEE DU SAUT PAR RAPPORT A S 
C      
C-----------------------------------------------------------------------
                  
      IF ( COMPOR(1) .EQ. 'CZM_EXP' ) THEN
        
        CALL LCEDEX(OPTION,IMATE,NPG,LGPG,S,Q,VIM,VIP,ALPHAP,DALFS)
          
      ELSE
        
        CALL UTMESS('F','NMEDCO','LOI'//COMPOR(1) //
     &              ' NON IMPLANTEE POUR LES ELEMDISC ')
     
      ENDIF
              
      END
