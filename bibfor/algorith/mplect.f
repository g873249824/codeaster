      SUBROUTINE MPLECT ( NOMCHA , NBMESU , NBINST )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/05/2000   AUTEUR CIBHHAB N.RAHNI 
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
C
C     PROJ_MESU_MODAL : LECTURE DES DONNEES DE MESURE
C
C     OUT : NBMESU : NOMBRE DE NOEUDS DE MESURE
C     OUT : NBINST : NOMBRE D'INSTANTS
C     ------------------------------------------------------------------
C
      IMPLICIT NONE 
C
      CHARACTER * 16 NOMCHA
C
      INTEGER NBMESU , NBINST
C
      CALL JEMARQ ( )
C
C --- LECTURE DU MAILLAGE ET DES REPERES LOCAUX ---
C
      CALL MPMAIL
C
C --- LECTURE DES DONNEES DE MESURE SUR FICHIER IDEAS ---
C
      CALL MPMESU ( NOMCHA , NBMESU , NBINST )
C
      CALL JEDEMA()
C
      END
