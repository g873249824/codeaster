      SUBROUTINE ULCLOS 
      IMPLICIT   NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 11/05/2005   AUTEUR MCOURTOI M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE D6BHHJP J.P.LEFEBVRE
C     ------------------------------------------------------------------
C     FERMETURE DE TOUS LES FICHIERS OUVERTS REFERENCES PAR ULDEFI
C
C     ------------------------------------------------------------------
      INTEGER          MXF
      PARAMETER       (MXF=100)
      CHARACTER*1      TYPEFI(MXF),ACCEFI(MXF),ETATFI(MXF),MODIFI(MXF)
      CHARACTER*16     DDNAME(MXF)
      CHARACTER*255    NAMEFI(MXF)
      INTEGER          FIRST, UNITFI(MXF) , NBFILE
      COMMON/ ASGFI1 / FIRST, UNITFI      , NBFILE
      COMMON/ ASGFI2 / NAMEFI,DDNAME,TYPEFI,ACCEFI,ETATFI,MODIFI
C     ------------------------------------------------------------------
      INTEGER          I , UNIT
C
      DO 10 I = 1 , NBFILE
        UNIT = UNITFI(I)
        IF ( UNIT.GT.0 ) THEN
          IF ( ETATFI(I) .EQ. 'O' ) THEN
            CLOSE ( UNIT=UNIT )
          ENDIF
          NAMEFI(I) = ' '
          DDNAME(I) = ' '
          UNITFI(I) = -1
          TYPEFI(I) = '?'
          ACCEFI(I) = '?'
          ETATFI(I) = 'F'
          MODIFI(I) = ' '
       ENDIF
 10   CONTINUE
C
      END
