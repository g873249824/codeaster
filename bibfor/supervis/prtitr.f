      SUBROUTINE PRTITR(TEXTE )
      IMPLICIT NONE
      CHARACTER*(*)     TEXTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 23/11/2010   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C     ECRITURE D'UN TITRE CENTRE
C     ------------------------------------------------------------------
C IN  TEXTE : CH*(*) : TEXTE
C     ------------------------------------------------------------------
C
C     --- AFFICHAGE SUR "MXCOLS" COLONNES ------------------------------
      INTEGER      MXCOLS
      PARAMETER   (MXCOLS = 132 )
      CHARACTER*(MXCOLS)  BLANC, TIRET
      CHARACTER*6                       DEBUT
      CHARACTER*1                              FIN
      COMMON /PRCC00/     BLANC, TIRET, DEBUT, FIN
C
      INTEGER I, LONG, IBL, IFR, IUNIFI
      INTEGER       MXIMPR
      PARAMETER   ( MXIMPR = 3)
      CHARACTER*16  NOMPR (MXIMPR)
      DATA          NOMPR  /'MESSAGE'  , 'RESULTAT', 'ERREUR'/
C     ------------------------------------------------------------------
C
      LONG  = MIN (LEN(TEXTE), MXCOLS)
C
      IBL   = (MXCOLS - LONG ) / 2
      DO 10 I = 1, MXIMPR
         IFR = IUNIFI(NOMPR(I))
         WRITE(IFR,'(1X,2A)') BLANC(1:IBL), TEXTE(1:LONG)
         WRITE(IFR,'(1X)')
   10 CONTINUE
C
      END
