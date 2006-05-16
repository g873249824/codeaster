      SUBROUTINE STBAST ( NFIE, NFIS, LGRCOU )
      IMPLICIT  NONE
      INTEGER             NFIE, NFIS
      LOGICAL             LGRCOU
C TOLE CRS_513
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/05/2006   AUTEUR MCOURTOI M.COURTOIS 
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
C      FONCTION : LANCEMENT DE L'INTERFACE IDEAS (SUPERTAB)          
C                                                                  
C ======================================================================
C
      CHARACTER*16 K16NOM
      INTEGER      ULISOP
C
      IF ( ULISOP ( NFIE, K16NOM ) .EQ. 0 )  THEN 
        CALL ULOPEN ( NFIE,' ','IDEAS','NEW','O')
      ELSE
C       TANT QU'IL Y AURA DES IUNIFI...
        CALL ULDEFI ( NFIE,' ','IDEAS','L','NEW','O')
      ENDIF 
      IF ( ULISOP ( NFIS, K16NOM ) .EQ. 0 )  THEN 
        CALL ULOPEN ( NFIS,' ','FICHIER-MODELE','NEW','O')
      ENDIF 
C
      CALL PRESUP ( NFIE, NFIS, LGRCOU )
C
      WRITE(NFIS,*) 'FIN'
      REWIND NFIS
C
      CALL ULDEFI ( -NFIE, ' ', ' ', ' ', ' ', ' ' )
      CALL ULDEFI ( -NFIS, ' ', ' ', ' ', ' ', ' ' )
      END
