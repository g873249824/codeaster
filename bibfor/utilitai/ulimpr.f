      SUBROUTINE ULIMPR (IMPR)
      IMPLICIT NONE
      INTEGER            IMPR
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
C
C     IMPRESSION DES TABLES DECRIVANT LES UNITES LOGIQUE OUVERTES
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
      INTEGER I
      CHARACTER*8      KTYP,KACC,KETA
C      
      WRITE(IMPR,999) 'LA TABLE A CONTENU JUSQU''A ',NBFILE,
     &                ' ASSOCIATION(S)'
      DO 1 I = 1, NBFILE
        WRITE(IMPR,1000) NAMEFI(I)
        KTYP='?'
        IF ( TYPEFI(I) .EQ. 'A' ) THEN
          KTYP='ASCII'
        ELSE IF ( TYPEFI(I) .EQ. 'B' ) THEN
          KTYP='BINARY'
        ELSE IF ( TYPEFI(I) .EQ. 'L' ) THEN
          KTYP='LIBRE'
        ENDIF      
        KACC='?'
        IF ( ACCEFI(I) .EQ. 'N' ) THEN
          KACC='NEW'
        ELSE IF ( ACCEFI(I) .EQ. 'O' ) THEN
          KACC='OLD'
        ELSE IF ( ACCEFI(I) .EQ. 'A' ) THEN
          KACC='APPEND'
        ENDIF      
        KETA='?'
        IF      ( ETATFI(I) .EQ. 'O' ) THEN
          KETA='OPEN'
        ELSE IF ( ETATFI(I) .EQ. 'F' ) THEN
          KETA='CLOSE'
        ELSE IF ( ETATFI(I) .EQ. 'R' ) THEN
          KETA='RESERVE '
        ENDIF
        WRITE(IMPR,1001) DDNAME(I),UNITFI(I),KTYP,KACC,KETA,MODIFI(I)
   1  CONTINUE
C
  999 FORMAT (A,I4,A)
 1000 FORMAT (1X,A)
 1001 FORMAT (6X,A16,I3,3(1X,A8),1X,A1)
      END
