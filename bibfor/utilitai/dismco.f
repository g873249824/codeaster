      SUBROUTINE DISMCO(QUESTI,NOMOB,REPI,REPK,IERD)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      CHARACTER*32 JEXNUM

      INTEGER REPI,IERD
      CHARACTER*(*) NOMOB,REPK
      CHARACTER*(*) QUESTI


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 17/12/2012   AUTEUR DELMAS J.DELMAS 
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
C
C     --     DISMOI(COMPOR)
C
C     IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE CARTE_COMPOR
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C ======================================================================
C
      CHARACTER*19 CHTMP,CHCALC
      INTEGER      IRET,JCALV,JCALD,JCALL,JCALK,NBMA,IMA,IADC
      CHARACTER*6  LCHAM(3)
      CHARACTER*8  NOMA,NOMAIL
      LOGICAL      INCR,ELAS
      DATA  LCHAM/ 'RELCOM', 'DEFORM', 'INCELA'/


      CALL JEMARQ()

      CALL ASSERT(QUESTI(1:9).EQ.'ELAS_INCR')

      REPK  = ' '
      REPI  = 0
      IERD = 0

      INCR = .FALSE.
      ELAS = .FALSE.

      CHTMP ='&&DISMCO_CHTMP'
      CHCALC='&&GVERLC_CHCALC'

C     PASSAGE CARTE COMPOR --> CHAMP SIMPLE,
C     PUIS REDUCTION DU CHAMP SUR LA COMPOSANTE 'RELCOM'
C     QUI CORRESPOND AU NOM DE LA LOI DE COMPORTEMENT
C
      CALL CARCES(NOMOB,'ELEM',' ','V',CHTMP,'A',IRET)
      CALL CESRED(CHTMP,0,0,3,LCHAM,'V',CHCALC)
      CALL DETRSD('CHAM_ELEM_S',CHTMP)

      CALL JEVEUO(CHCALC//'.CESD','L',JCALD)
      CALL JEVEUO(CHCALC//'.CESV','L',JCALV)
      CALL JEVEUO(CHCALC//'.CESL','L',JCALL)
      CALL JEVEUO(CHCALC//'.CESK','L',JCALK)

      NOMA = ZK8(JCALK-1+1)
      NBMA = ZI(JCALD-1+1)

      DO 10 IMA = 1,NBMA

        IF (INCR.AND.ELAS) GOTO 999

        CALL CESEXI('C',JCALD,JCALL,IMA,1,1,1,IADC)

        IF (IADC.GT.0 )THEN
          CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),NOMAIL)
          IF (ZK16(JCALV+IADC-1+2)(1:9) .EQ. 'COMP_INCR') THEN
             INCR = .TRUE.
          ENDIF
          IF (ZK16(JCALV+IADC-1+2)(1:9) .EQ. 'COMP_ELAS') THEN
             ELAS = .TRUE.
          ENDIF
        ENDIF

 10   CONTINUE

999   CONTINUE

      IF (INCR .AND. .NOT.ELAS) REPK='INCR'
      IF (ELAS .AND. .NOT.INCR) REPK='ELAS'
      IF (ELAS .AND. INCR)     REPK='MIXTE'

      IF (.NOT.ELAS .AND. .NOT.INCR) IERD = 1

      CALL JEDEMA()

      END
