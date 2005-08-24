      SUBROUTINE IMPFOI(UNITE,LONG,VALI,CHAINE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2005   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      INTEGER       UNITE
      INTEGER       LONG
      INTEGER       VALI
      CHARACTER*(*) CHAINE
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : 
C ----------------------------------------------------------------------
C
C IMPRESSION D'UN ENTIER SUR UNE UNITE LOGICIELLE
C 
C IN  UNITE  : UNITE LOGICIELLE D'IMPRESSION
C IN  LONG   : LONGUEUR D'AFFICHAGE DU NOMBRE
C IN  VALI   : VALEUR ENTIERE A AFFICHER
C OUT CHAINE : CHAINE DE SORTIE SI UNITE = 0
C
C ----------------------------------------------------------------------
C
      CHARACTER*4  FOR4
      CHARACTER*5  FOR5
      CHARACTER*1  FOR1
      INTEGER      LONFOR
C
C ----------------------------------------------------------------------
C
 
      IF (LONG.LE.9) THEN
        LONFOR = 4
        FOR4(1:2) = '(I'
        WRITE(FOR1,'(I1)') LONG
        FOR4(3:3) = FOR1
        FOR4(4:4) = ')'
      ELSE IF (LONG.LE.19) THEN 
        LONFOR = 5
        FOR5(1:2) = '(I'
        FOR5(3:3) = '1'
        WRITE(FOR1,'(I1)') LONG-10
        FOR5(4:4) = FOR1
        FOR5(5:5) = ')'
      ELSE
        CALL UTMESS('F','IMPFOI','FORMAT D''AFFICHAGE TROP GRAND')
      ENDIF

      IF (UNITE.NE.0) THEN
        IF (LONFOR.EQ.4) THEN
          WRITE(UNITE,FOR4) VALI
        ELSE IF (LONFOR.EQ.5) THEN
          WRITE(UNITE,FOR5) VALI
        ELSE
          CALL UTMESS('F','IMPFOI','LONGUEUR FORMAT EXCESSIF (DVLP)')
        ENDIF
      ELSE
        IF (LONFOR.EQ.4) THEN
          WRITE(CHAINE,FOR4) VALI
        ELSE IF (LONFOR.EQ.5) THEN
          WRITE(CHAINE,FOR5) VALI
        ELSE
          CALL UTMESS('F','IMPFOI','LONGUEUR FORMAT EXCESSIF (DVLP)')
        ENDIF
      ENDIF
   

      END
