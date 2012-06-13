      SUBROUTINE TE0546(OPTION,NOMTE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE,OPTION
C.......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE PELLET J.PELLET

C     BUT: CALCUL DES OPTIONS SIGM_ELA ET EFGE_ELGA
C          POUR TOUS LES ELEMENTS
C.......................................................................

      CHARACTER*8 ELREFE,KBID
      INTEGER  IBID, ITAB1(8),ITAB2(8),IRET,NBPG,NBCMP,NBSP
      INTEGER  KPG,KSP,KCMP,JIN,JOUT,ICO,N1
C.......................................................................


      CALL TECACH('OOO','PSIEFR',8,ITAB1,IRET)
      CALL ASSERT(IRET.EQ.0)

      IF (OPTION.EQ.'SIGM_ELGA') THEN
        CALL TECACH('OOO','PSIGMR',8,ITAB2,IRET)
      ELSEIF (OPTION.EQ.'EFGE_ELGA') THEN
        CALL TECACH('OOO','PEFGER',8,ITAB2,IRET)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF


C     -- VERIFICATIONS DE COHERENCE :
C     --------------------------------
      NBPG=ITAB1(3)
      CALL ASSERT(NBPG.GE.1)
      CALL ASSERT(NBPG.EQ.ITAB2(3))

      NBSP=ITAB1(7)
      CALL ASSERT(NBSP.GE.1)
      CALL ASSERT(NBSP.EQ.ITAB2(7))

      N1=ITAB1(2)
      NBCMP=N1/NBPG
      CALL ASSERT(NBCMP*NBPG.EQ.N1)
      CALL ASSERT(NBCMP*NBPG.EQ.ITAB2(2))

      CALL ASSERT(ITAB1(6).LE.1)
      CALL ASSERT(ITAB2(6).LE.1)


C     -- RECOPIE DES VALEURS :
C     --------------------------
      JIN=ITAB1(1)
      JOUT=ITAB2(1)
      ICO=0
      DO 1, KPG=1,NBPG
        DO 2, KSP=1,NBSP
          DO 3, KCMP=1,NBCMP
            ICO=ICO+1
            ZR(JOUT-1+ICO)=ZR(JIN-1+ICO)
3         CONTINUE
2       CONTINUE
1     CONTINUE


      END
