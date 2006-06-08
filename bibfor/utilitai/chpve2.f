      SUBROUTINE CHPVE2(KSTOP,NOMCH,NBTYP,TABTYP,IER)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/02/2006   AUTEUR REZETTE C.REZETTE 
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
C ======================================================================
C     VERIFICATIONS DE LA GRANDEUR ET DE LA LOCALISATION DES CHAMPS.
C
C  IN  KSTOP  : TYPE DE MESSAGE  (A/F)
C  IN  NOCHAM : NOM DU CHAMP 
C  IN  NBTYP  : DIMENSION DE TABTYP 
C  IN  TABTYP : TABLEAU CONTENANT LES TYPES DE CHAMPS ACCEPTABLES. 
C               UN ELEMENT DE TABTYP EST DE LA FORME : LOC#GD
C               OU : LOC = ELNO/ELGA/ELEM/ELXX/CART
C                    GD  = GRANDEUR
C  OUT   IERD  : CODE RETOUR  (0--> OK, 1--> PB )
C ======================================================================
      IMPLICIT NONE
C
      INTEGER IER, NBTYP
      CHARACTER*1 KSTOP
      CHARACTER*(*) TABTYP(NBTYP),NOMCH
C
      INTEGER IBID,LC,I,J
      CHARACTER*19 NOCH
      CHARACTER*4  LOCH,TYCH
      CHARACTER*8  GDCH,NOMGD
      CHARACTER*11 CHAINE
C
      CALL JEMARQ()
C
      IER=1
      NOCH=NOMCH
      DO 10 I=1,NBTYP
        LC=LEN(TABTYP(I))
        CHAINE=TABTYP(I)
C
        DO 20 J=1,LC
          IF(CHAINE(I:I).EQ.'#')THEN
             LOCH = CHAINE(1:I) 
             GDCH = CHAINE(I+1:LC)
             GOTO 30
           ENDIF
 20     CONTINUE
 30     CONTINUE
C
        CALL DISMOI(KSTOP,'TYPE_CHAMP',NOCH,'CHAMP',IBID,TYCH,IER)
        CALL DISMOI(KSTOP,'NOM_GD',NOCH,'CHAMP',IBID,NOMGD,IER)
C       
        IF((LOCH(3:4).NE.'XX'  .AND.   LOCH.EQ.TYCH ) .OR. 
     &     (LOCH(3:4).EQ.'XX'  .AND.   LOCH(1:2).EQ.TYCH(1:2)))THEN
           IF(GDCH.EQ.NOMGD)THEN
              IER=0
              GOTO 40
           ENDIF
        ENDIF
 10   CONTINUE
 40   CONTINUE
C
      IF(IER.EQ.1)THEN
         CALL UTDEBM(KSTOP,'CHPVE2','LE TYPE DE CHAMP')
         CALL UTIMPK('S',' ',1,LOCH//'_'//GDCH)
         CALL UTIMPK('S','N''EST PAS ACCEPTE. ',0,' ')
         CALL UTIMPK('L','VEUILLEZ CONSULTER LA',0,' ')
         CALL UTIMPK('S','DOC U CORRESPONDANTE',0,' ')
         CALL UTFINM()
      ENDIF
C
      CALL JEDEMA()

      END
