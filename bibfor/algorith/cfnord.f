      SUBROUTINE CFNORD(NOMA  ,TYPENT,NUMENT,ITYPE ,VECTOR,
     &                  TAU1  ,TAU2  ,LNFIXE)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMA
      CHARACTER*4   TYPENT
      INTEGER       NUMENT
      REAL*8        TAU1(3),TAU2(3)
      REAL*8        VECTOR(3)
      INTEGER       ITYPE
      LOGICAL       LNFIXE
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
C
C MODIFIE LES VECTEURS TANGENTS LOCAUX QUAND NORMALE DONNEE PAR 
C UTILISATEUR
C      
C ----------------------------------------------------------------------
C
C  NB: LE REPERE EST ORTHORNORME ET TEL QUE LA NORMALE POINTE VERS
C  L'EXTERIEUR DE LA MAILLE
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  TYPENT : TYPE DE L'ENTITE 
C               'MAIL' UNE MAILLE
C               'NOEU' UN NOEUD
C IN  NUMENT : NUMERO ABSOLU DE L'ENTITE DANS LE MAILLAGE 
C IN  ITYPE  : TYPE DE NORMALE
C                0 AUTO
C                1 FIXE   (DONNE PAR VECTOR)
C                2 VECT_Y (DONNE PAR VECTOR)
C IN  VECTOR : VALEUR DE LA NORMALE FIXE OU VECT_Y
C I/O TAU1   : PREMIER VECTEUR TANGENT LOCAL 
C I/O TAU2   : SECOND VECTEUR TANGENT LOCAL 
C OUT LNFIXE : VAUT .TRUE. SI NORMALE='FIXE' OU 'VECT_Y'
C                   .FALSE. SI NORMALE='AUTO'
C
C
C
C
      CHARACTER*8  NOMENT
      REAL*8       NORM(3),NOOR,R8PREM,NOOR2
C
C ----------------------------------------------------------------------
C  
      CALL JEMARQ() 
C
C --- INITIALISATIONS
C       
      LNFIXE = .FALSE.
C
C --- NOM DE L'ENTITE (NOEUD OU MAILLE)
C 
      IF (TYPENT.EQ.'MAIL') THEN
        CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMENT),NOMENT) 
      ELSEIF (TYPENT.EQ.'NOEU') THEN
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMENT),NOMENT)   
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF           
C
C --- NORMALE AUTOMATIQUE: ON SORT 
C
      IF (ITYPE.EQ.0) THEN
        LNFIXE = .FALSE.
        GOTO 999
      ELSE
        CALL NORMEV(VECTOR,NOOR )
        IF (NOOR.LE.R8PREM()) THEN
          CALL ASSERT(.FALSE.)
        ENDIF 
        LNFIXE = .TRUE.  
      ENDIF      
C      
C --- REDEFINITION SI VECT_ == 'FIXE' (ON GARDE T1 COMME REFERENCE)
C
      IF (ITYPE.EQ.1) THEN
        CALL PROVEC(VECTOR,TAU1  ,TAU2  )
        CALL NORMEV(TAU2  ,NOOR  )       
        IF (NOOR.LE.R8PREM()) THEN
          IF (TYPENT.EQ.'MAIL') THEN
            CALL U2MESK('F','CONTACT_14',1,NOMENT) 
          ELSEIF (TYPENT.EQ.'NOEU') THEN
            CALL U2MESK('F','CONTACT_13',1,NOMENT) 
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF                           
        ENDIF
      ENDIF
C      
C --- REDEFINITION SI VECT_ == 'VECT_Y' 
C              
      IF (ITYPE.EQ.2) THEN
C
C --- VECTEUR TAU2 NUL OU POUTRE !
C      
        CALL NORMEV(TAU2  ,NOOR  )
        IF (NOOR.LE.R8PREM()) THEN
          CALL DCOPY(3,VECTOR,1,TAU2,1)
          CALL PROVEC(TAU1  ,TAU2  ,NORM  )
          CALL NORMEV(NORM  ,NOOR2 )
          IF (NOOR2.LE.R8PREM()) THEN
            IF (TYPENT.EQ.'MAIL') THEN
              CALL U2MESK('F','CONTACT3_27',1,NOMENT)
            ELSEIF (TYPENT.EQ.'NOEU') THEN
              CALL U2MESK('F','CONTACT3_26',1,NOMENT)
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF 
          ENDIF
        ELSE
          CALL DCOPY(3,VECTOR,1,TAU2,1)
          CALL PROVEC(TAU1  ,TAU2  ,NORM  )
          CALL NORMEV(NORM  ,NOOR2 )
          IF (NOOR2.LE.R8PREM()) THEN
            IF (TYPENT.EQ.'MAIL') THEN
              CALL U2MESK('F','CONTACT3_27',1,NOMENT)
            ELSEIF (TYPENT.EQ.'NOEU') THEN 
              CALL U2MESK('F','CONTACT3_26',1,NOMENT)
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF          
          ENDIF
          CALL PROVEC(TAU2,NORM,TAU1) 
        ENDIF      
      ENDIF
C
      IF (ITYPE.GE.3) THEN
        CALL ASSERT(.FALSE.)
      ENDIF      
C
 999  CONTINUE 
C
      CALL JEDEMA()      
C
      END
