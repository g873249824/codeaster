      INTEGER FUNCTION ULNUME ()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C     RETOURNE UN NUMERO D'UNITE LOGIQUE NON UTILISE   
C              -1 SI AUCUN DE DISPONIBLE
C     LA RECHERCHE EST LIMITEE A L'INTERVALLE 70-99           
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 10/10/2003   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C ======================================================================
C RESPONSABLE D6BHHJP J.P.LEFEBVRE
C
      INTEGER          MXF
      PARAMETER       (MXF=100)
      CHARACTER*1      TYPEFI(MXF),ACCEFI(MXF),ETATFI(MXF),MODIFI(MXF)
      CHARACTER*16     DDNAME(MXF)
      CHARACTER*255    NAMEFI(MXF)
      INTEGER          FIRST, UNITFI(MXF) , NBFILE
      COMMON/ ASGFI1 / FIRST, UNITFI      , NBFILE
      COMMON/ ASGFI2 / NAMEFI,DDNAME,TYPEFI,ACCEFI,ETATFI,MODIFI
C
      INTEGER          I,IVAL,K
C
      IF ( FIRST .NE. 17111990 ) CALL ULINIT
C
      IVAL = -1
      DO 1 I = 99,70,-1
        DO 10 K = 1,NBFILE
          IF( UNITFI(K) .EQ. I) THEN
            GOTO 1
          ENDIF
   10   CONTINUE
        IVAL = I
        GOTO 2
   1  CONTINUE
      CALL UTMESS('A','ULNUME01','AUCUN NUMERO D''UNITE LOGIQUE'
     &            //'DISPONIBLE')
   2  CONTINUE
      ULNUME = IVAL
      END
