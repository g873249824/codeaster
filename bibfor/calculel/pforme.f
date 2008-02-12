      SUBROUTINE PFORME(TYPEMA,NG    ,G     ,FG    ,DFG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
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
      INTEGER       NNM,NGM
      PARAMETER     (NNM = 27)
      PARAMETER     (NGM = 64)  
C      
      CHARACTER*8   TYPEMA        
      INTEGER       NG  
      REAL*8        FG(NGM*NNM)
      REAL*8        DFG(3*NGM*NNM)
      REAL*8        G(3*NGM)
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN - UTILITAIRE
C
C FONCTIONS DE FORME ET LEURS DERIVEES PREMIERES AUX POINTS DE GAUSS
C
C ----------------------------------------------------------------------
C
C
C PAR NNM    : NOMBRE MAXI DE NOEUDS PAR MAILLE
C PAR NGM    : NOMBRE MAXI DE POINTS DE GAUSS PAR MAILLE
C IN  TYPEMA : TYPE DE LA MAILLE
C IN  G      : POINTS DE GAUSS
C IN  NG     : NOMBRE DE POINTS DE GAUSS
C OUT FG     : FONCTIONS DE FORME AUX POINTS DE GAUSS
C OUT DFG    : DERIV./PARAM DES FONCTIONS DE FORME 
C               AUX POINTS DE GAUS
C
C DERIV./PARAM: DERIVEES PAR RAPPORT AUX COORDONNEES DE L'ESPACE
C               PARAMETRIQUE
C
C ----------------------------------------------------------------------
C
       INTEGER P0,P1,P2
       INTEGER IPG,DIME,NN
C
C ----------------------------------------------------------------------
C         
      P0 = 1
      P1 = 1
      P2 = 1
      DO 10 IPG = 1, NG
        CALL FORME0(G(P0),TYPEMA,FG(P1) ,NN)
        CALL FORME1(G(P0),TYPEMA,DFG(P2),NN,DIME)
        IF (NN.GT.NNM) THEN
          CALL U2MESK('F','ARLEQUIN_99',1,'PFORME_1')
        ENDIF    
        IF (DIME.GT.3) THEN
          CALL U2MESK('F','ARLEQUIN_99',1,'PFORME_2')
        ENDIF       
        P0 = P0 + DIME
        P1 = P1 + NN
        P2 = P2 + NN*DIME 
 10   CONTINUE

      END
