      SUBROUTINE ACEVMA(NBOCC,NLM,NLG,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           NBOCC,NLM,NLG,IER
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 01/03/2000   AUTEUR CIBHHPD P.DAVID 
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
C ----------------------------------------------------------------------
C     AFFE_CARA_ELEM
C     VERIFICATION DES MOTS CLES POUR L'ELEMENT MASSIF
C ----------------------------------------------------------------------
C IN  : NBOCC  : NOMBRE D'OCCURENCE
C OUT : NLM    : NOMBRE TOTAL DE MAILLE
C OUT : NLG    : NOMBRE TOTAL DE GROUPE DE MAILLE
C ----------------------------------------------------------------------
      CHARACTER*8  K8B, TOU, NOMU
      CHARACTER*16 CONCEP, CMD
C     ------------------------------------------------------------------
C
      NLM = 0
      NLG = 0
      DO 10 IOC = 1,NBOCC
         CALL GETVID('MASSIF','GROUP_MA' ,IOC,1,0,K8B,NG  )
         CALL GETVID('MASSIF','MAILLE'   ,IOC,1,0,K8B,NM  )
C
         NSOM = NG + NM
         IF (NSOM.EQ.NG .OR. NSOM.EQ.NM) THEN
            NLM = MAX(NLM,-NM)
            NLG = MAX(NLG,-NG)
         ENDIF
C
 10   CONTINUE
C
      END
