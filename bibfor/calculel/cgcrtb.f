      SUBROUTINE CGCRTB(LATABL,OPTIO1,DIME,TROIDL,NDEP,NRES,NBPRUP,
     &                  NOPRUP,TYPRUP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/05/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------
C      BUT: CREATION DE LA TABLE ISSUE DE CALC_G 
C           ET AFFECTATION DES PARAMETRES
C           
C      APPELE PAR: OP0100 (OPERATEUR 'CALC_G')
C ----------------------------------------------
C     IN  LATABL    :  NOM DE LA TABLE
C     IN  OPTIO1    :  OPTION DE CALCUL
C     IN  DIME      :  DIMENSION GEOMETRIQUE
C     IN  TROIDL    :  = .TRUE.  SI 3D LOCAL
C                        .FALSE. SI 2D OU 3D GLOBAL
C     IN  NDEP      :  NON NUL SI UN CHAMP DEPL EST FOURNI A CALC_G
C     IN  NRES      :  NON NUL SI UNE SD RESULTAT EST FOURNIE A CALC_G
C     IN/OUT NBPRUP :  NOMBRE DE PARAMETRES
C     OUT NOPRUP    :  NOMS DES PARAMETRES
C     OUT TYPRUP    :  TYPES DES PARAMETRES
C
      IMPLICIT NONE
      INTEGER       NBPRUP,NDEP,NRES,DIME
      CHARACTER*8   LATABL,TYPRUP(NBPRUP)
      CHARACTER*16  OPTIO1,NOPRUP(NBPRUP)
      LOGICAL       TROIDL
C
      CALL JEMARQ()
C
      IF((  (OPTIO1.EQ.'CALC_G'.OR.
     &       OPTIO1.EQ.'CALC_DG'.OR.
     &       OPTIO1.EQ.'G_LAGR') .AND. DIME.EQ.2)
     &  .OR. (OPTIO1.EQ.'CALC_G_GLOB' .OR.
     &        OPTIO1.EQ.'G_LAGR_GLOB' )) THEN
        IF (NDEP .NE. 0 ) THEN
          NBPRUP = 1
          NOPRUP(1) = 'G'
          TYPRUP(1) = 'R'
        ELSE
          NBPRUP = 3
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'G'
          TYPRUP(3) = 'R'
        ENDIF
      ELSEIF((OPTIO1.EQ.'CALC_G'.OR.OPTIO1.EQ.'G_LAGR')
     &       .AND. TROIDL)THEN
        IF(NRES.NE.0)THEN
          NBPRUP = 5
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'NOEUD'
          TYPRUP(3) = 'K8'
          NOPRUP(4) = 'ABSC_CURV'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'G_LOCAL'
          TYPRUP(5) = 'R'
        ELSE
          NBPRUP = 3
          NOPRUP(1) = 'NOEUD'
          TYPRUP(1) = 'K8'
          NOPRUP(2) = 'ABSC_CURV'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'G_LOCAL'
          TYPRUP(3) = 'R'
        ENDIF
      ELSEIF (OPTIO1.EQ.'CALC_DG_E') THEN
        IF (NDEP .NE. 0 ) THEN
          NBPRUP = 1
          NOPRUP(1) = 'DG/DE'
          TYPRUP(1) = 'R'
        ELSE
          NBPRUP = 3
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DG/DE'
          TYPRUP(3) = 'R'
        ENDIF
      ELSEIF (OPTIO1.EQ.'CALC_DG_FORC')THEN
        IF (NDEP .NE. 0 ) THEN
          NBPRUP = 1
          NOPRUP(1) = 'DG/DF'
          TYPRUP(1) = 'R'
        ELSE
          NBPRUP = 3
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DG/DF'
          TYPRUP(3) = 'R'
        ENDIF
      ELSEIF (OPTIO1 .EQ.'CALC_DK_DG_E')THEN
        IF ( NDEP .NE. 0 ) THEN
          NBPRUP = 3
          NOPRUP(1) = 'DG/DE'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'DK1/DE'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DK2/DE'
          TYPRUP(3) = 'R'
        ELSE
          NBPRUP = 5
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DG/DE'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'DK1/DE'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'DK2/DE'
          TYPRUP(5) = 'R'
        ENDIF
      ELSEIF (OPTIO1.EQ.'CALC_DK_DG_FORC')THEN
        IF ( NDEP .NE. 0 ) THEN
          NBPRUP = 2
          NOPRUP(1) = 'DK1/DF'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'DK2/DF'
          TYPRUP(2) = 'R'
        ELSE
          NBPRUP = 4
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DK1/DF'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'DK2/DF'
          TYPRUP(4) = 'R'
        ENDIF
      ELSE IF( OPTIO1.EQ.'CALC_K_G' .AND. DIME.EQ.2)THEN
        IF (NDEP .NE. 0 ) THEN
          NBPRUP = 4
          NOPRUP(1) = 'G'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'K1'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'K2'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'G_IRWIN'
          TYPRUP(4) = 'R'
        ELSE
          NBPRUP = 6
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'G'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'K1'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'K2'
          TYPRUP(5) = 'R'
          NOPRUP(6) = 'G_IRWIN'
          TYPRUP(6) = 'R'
        ENDIF
      ELSEIF(OPTIO1.EQ.'CALC_K_G' .AND. TROIDL)THEN
          NBPRUP = 9
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'NUM_PT'
          TYPRUP(3) = 'I'
          NOPRUP(4) = 'ABS_CURV'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'K1_LOCAL'
          TYPRUP(5) = 'R'
          NOPRUP(6) = 'K2_LOCAL'
          TYPRUP(6) = 'R'
          NOPRUP(7) = 'K3_LOCAL'
          TYPRUP(7) = 'R'
          NOPRUP(8) = 'G_LOCAL'
          TYPRUP(8) = 'R'
          NOPRUP(9) = 'BETA_LOCAL'
          TYPRUP(9) = 'R'
      ELSEIF ( OPTIO1 .EQ. 'CALC_DK_DG_E' ) THEN
        IF ( NDEP .NE. 0 ) THEN
          NBPRUP = 3
          NOPRUP(1) = 'DG/DE'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'DK1/DE'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DK2/DE'
          TYPRUP(3) = 'R'
        ELSE
          NBPRUP = 5
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DG/DE'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'DK1/DE'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'DK2/DE'
          TYPRUP(5) = 'R'
        ENDIF
      ELSEIF ( OPTIO1 .EQ. 'CALC_DK_DG_FORC' ) THEN   
        IF ( NDEP .NE. 0 ) THEN
          NBPRUP = 2
          NOPRUP(1) = 'DK1/DF'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'DK2/DF'
          TYPRUP(2) = 'R'
        ELSE
          NBPRUP = 4
          NOPRUP(1) = 'NUME_ORDRE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'INST'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'DK1/DF'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'DK2/DF'
          TYPRUP(4) = 'R'
        ENDIF
      ELSEIF ( OPTIO1 .EQ. 'K_G_MODA' ) THEN
        IF(TROIDL)THEN
          NBPRUP = 8
          NOPRUP(1) = 'NUME_MODE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'NUM_PT'
          TYPRUP(2) = 'I'
          NOPRUP(3) = 'ABS_CURV'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'K1_LOCAL'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'K2_LOCAL'
          TYPRUP(5) = 'R'
          NOPRUP(6) = 'K3_LOCAL'
          TYPRUP(6) = 'R'
          NOPRUP(7) = 'G_LOCAL'
          TYPRUP(7) = 'R'
          NOPRUP(8) = 'BETA_LOCAL'
          TYPRUP(8) = 'R'
        ELSE
          NBPRUP = 5
          NOPRUP(1) = 'NUME_MODE'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'G'
          TYPRUP(2) = 'R'
          NOPRUP(3) = 'K1'
          TYPRUP(3) = 'R'
          NOPRUP(4) = 'K2'
          TYPRUP(4) = 'R'
          NOPRUP(5) = 'G_IRWIN'
          TYPRUP(5) = 'R'
        ENDIF
      ELSEIF ( OPTIO1 .EQ. 'G_BILI'
     &     .OR.OPTIO1 .EQ. 'G_MAX') THEN
          NBPRUP = 6
          NOPRUP(1) = 'INST'
          TYPRUP(1) = 'R'
          NOPRUP(2) = 'NUME_CMP_I'
          TYPRUP(2) = 'I'
          NOPRUP(3) = 'NUME_CMP_J'
          TYPRUP(3) = 'I'
          NOPRUP(4) = 'NOEUD'
          TYPRUP(4) = 'K8'
          NOPRUP(5) = 'ABSC_CURV'
          TYPRUP(5) = 'R'
          NOPRUP(6) = 'G_BILI_LOCAL'
          TYPRUP(6) = 'R'
      ELSEIF ( OPTIO1 .EQ. 'G_BILI_GLOB'
     &     .OR.OPTIO1 .EQ. 'G_MAX_GLOB') THEN
          NBPRUP = 3
          NOPRUP(1) = 'NUME_CMP_I'
          TYPRUP(1) = 'I'
          NOPRUP(2) = 'NUME_CMP_J'
          TYPRUP(2) = 'I'
          NOPRUP(3) = 'G_BILIN'
          TYPRUP(3) = 'R'
      ENDIF
      CALL TBCRSD ( LATABL, 'G' )
      CALL TBAJPA ( LATABL, NBPRUP, NOPRUP, TYPRUP )
C
      CALL JEDEMA()
C
      END
