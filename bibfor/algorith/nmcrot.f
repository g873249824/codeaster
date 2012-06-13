      SUBROUTINE NMCROT(RESULT,SDOBSE)
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  RESULT
      CHARACTER*19 SDOBSE
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES - OBSERVATION)
C
C CREATION TABLE OBSERVATION
C
C ----------------------------------------------------------------------
C
C
C IN  RESULT : NOM SD RESULTAT
C IN  SDOBSE : NOM DE LA SD POUR OBSERVATION
C
C
C
C
      CHARACTER*24 OBSTAB
      INTEGER      JOBST
      INTEGER      IRET
      CHARACTER*19 NOMTAB
      INTEGER      NBPARA
      PARAMETER   (NBPARA=15)
      CHARACTER*8  TYPARA(NBPARA)
      CHARACTER*16 NOPARA(NBPARA)
C
      DATA NOPARA/'NOM_OBJET' ,'TYPE_OBJET','NOM_SD',
     &            'NUME_ORDRE','INST'   ,'NOM_CHAM',
     &            'EVAL_CHAM','NOM_CMP','EVAL_CMP',
     &            'NOEUD'     ,'MAILLE' ,
     &            'EVAL_ELGA' ,'POINT','SOUS_POINT',
     &            'VALE'      /
      DATA TYPARA/'K16','K16','K24',
     &            'I' ,'R' ,'K16',
     &            'K8','K8','K8' ,
     &            'K8','K8',
     &            'K8','I' ,'I'  ,
     &            'R' /
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
C
C --- SD NOM TABLE
C 
      OBSTAB = SDOBSE(1:14)//'     .TABL'
      CALL WKVECT(OBSTAB,'V V K24',     1,JOBST)      
C
C --- CREATION DE LA LISTE DE TABLES SI ELLE N'EXISTE PAS
C 
      CALL JEEXIN(RESULT//'           .LTNT',IRET)
      IF (IRET.EQ.0) THEN 
        CALL LTCRSD(RESULT,'G')
      ENDIF
C
C --- RECUPERATION DE LA TABLE CORRESPONDANT AUX OBSERVATIONS
C
      NOMTAB = ' '
      CALL LTNOTB(RESULT,'OBSERVATION',NOMTAB)
C
C --- CREATION DE LA TABLE CORRESPONDANT AUX OBSERVATIONS
C
      CALL EXISD('TABLE',NOMTAB,IRET)
      IF (IRET.EQ.0) THEN
        CALL TBCRSD(NOMTAB,'G')
        CALL TBAJPA(NOMTAB,NBPARA,NOPARA,TYPARA)  
      ENDIF  
C
C --- SAUVEGARDE NOM DU TABLEAU
C      
      ZK24(JOBST)   = NOMTAB 
C
      CALL JEDEMA()
      END
