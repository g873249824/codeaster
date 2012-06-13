      SUBROUTINE CNSDOT(CNS1Z,CNS2Z,PSCAL,IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) CNS1Z,CNS2Z
      REAL*8 PSCAL
      INTEGER IER
C ---------------------------------------------------------------------
C BUT: CALCULER LE "PRODUIT SCALAIRE" DE 2 CHAM_NO_S
C ---------------------------------------------------------------------
C     ARGUMENTS:
C CNS1Z  IN/JXIN  K19 : SD CHAM_NO_S
C CNS2Z  IN/JXIN  K19 : SD CHAM_NO_S
C PSCAL  OUT      R   : "PRODUIT SCALAIRE"
C IER    OUT      I   : CODE_RETOUR :
C                       0 -> OK
C                       1 -> LES 2 CHAM_NO_S N'ONT PAS LES MEMES CMPS

C REMARQUE :
C CETTE ROUTINE BOUCLE SUR TOUS LES DDLS DE CNS1 ET CNS2PSCAL=0
C  POUR IN IN CNS1 :
C      CMP1=CNS2
C-----------------------------------------------------------------------

C     ------------------------------------------------------------------
      INTEGER JCNSK1,JCNSD1,JCNSV1,JCNSL1,JCNSC1
      INTEGER JCNSK2,JCNSD2,JCNSV2,JCNSL2,JCNSC2
      INTEGER NBNO,IBID,K,INO,NCMP,NBNO1,NBNO2,NCMP1,NCMP2
      CHARACTER*8 MA1,NOMGD1,MA2,NOMGD2
      CHARACTER*3 TSCA1
      CHARACTER*19 CNS1,CNS2
      REAL*8 X1,X2
C     ------------------------------------------------------------------
      CALL JEMARQ()


      CNS1=CNS1Z
      CNS2=CNS2Z

      CALL JEVEUO(CNS1//'.CNSK','L',JCNSK1)
      CALL JEVEUO(CNS1//'.CNSD','L',JCNSD1)
      CALL JEVEUO(CNS1//'.CNSC','L',JCNSC1)
      CALL JEVEUO(CNS1//'.CNSV','L',JCNSV1)
      CALL JEVEUO(CNS1//'.CNSL','L',JCNSL1)

      MA1=ZK8(JCNSK1-1+1)
      NOMGD1=ZK8(JCNSK1-1+2)
      NBNO1=ZI(JCNSD1-1+1)
      NCMP1=ZI(JCNSD1-1+2)


      CALL JEVEUO(CNS2//'.CNSK','L',JCNSK2)
      CALL JEVEUO(CNS2//'.CNSD','L',JCNSD2)
      CALL JEVEUO(CNS2//'.CNSC','L',JCNSC2)
      CALL JEVEUO(CNS2//'.CNSV','L',JCNSV2)
      CALL JEVEUO(CNS2//'.CNSL','L',JCNSL2)

      MA2=ZK8(JCNSK2-1+1)
      NOMGD2=ZK8(JCNSK2-1+2)
      NBNO2=ZI(JCNSD2-1+1)
      NCMP2=ZI(JCNSD2-1+2)

C     -- COHERENCE DES 2 CHAMPS :
      CALL ASSERT(MA1.EQ.MA2)
      CALL ASSERT(NOMGD1.EQ.NOMGD2)
      CALL ASSERT(NBNO1.EQ.NBNO2)
      CALL ASSERT(NCMP1.EQ.NCMP2)
      NBNO=NBNO1
      NCMP=NCMP1



      CALL DISMOI('F','TYPE_SCA',NOMGD1,'GRANDEUR',IBID,TSCA1,IBID)
      CALL ASSERT(TSCA1.EQ.'R')

      DO 10,K=1,NCMP
        CALL ASSERT(ZK8(JCNSC1-1+K).EQ.ZK8(JCNSC2-1+K))
   10 CONTINUE


C     CALCUL DE LA SOMME DES PRODUITS DES CMPS :
C     -------------------------------------------
      PSCAL=0.D0
      IER=0
      DO 30,INO=1,NBNO
        DO 20,K=1,NCMP
          IF (ZL(JCNSL1-1+(INO-1)*NCMP+K)) THEN
            IF (.NOT.ZL(JCNSL2-1+(INO-1)*NCMP+K)) THEN
              IER=1
              GOTO 40

            ENDIF
            X1=ZR(JCNSV1-1+(INO-1)*NCMP+K)
            X2=ZR(JCNSV2-1+(INO-1)*NCMP+K)
            PSCAL=PSCAL+X1*X2
          ELSE
            IF (ZL(JCNSL2-1+(INO-1)*NCMP+K)) THEN
              IER=1
              GOTO 40

            ENDIF
          ENDIF
   20   CONTINUE
   30 CONTINUE

   40 CONTINUE
      CALL JEDEMA()
      END
