      SUBROUTINE LCROMA (FAMI,KPG,KSP,POUM,MATE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

      IMPLICIT NONE
      INTEGER  KPG,KSP,MATE
      CHARACTER*(*) FAMI, POUM

C ******************************************************
C *       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL    *
C *        LECTURE DES CARACTERISTIQUES DU MATERIAU    *
C ******************************************************

C IN  MATE    : ADRESSE DU MATERIAU
C IN  TEMP    : TEMPERATURE A L'INSTANT DU CALCUL
C IN COMMON   : PM DOIT DEJA ETRE AFFECTE (PLASTICITE CUMULEE EN T-)
C ----------------------------------------------------------------------
C  COMMON LOI DE COMPORTEMENT ROUSSELIER

      INTEGER ITEMAX, JPROLP, JVALEP, NBVALP,IRET
      REAL*8  PREC,YOUNG,NU,SIGY,SIG1,ROUSD,F0,FCR,ACCE
      REAL*8  PM,RPM,FONC,FCD,DFCDDJ,DPMAXI
      COMMON /LCROU/ PREC,YOUNG,NU,SIGY,SIG1,ROUSD,F0,FCR,ACCE,
     &               PM,RPM,FONC,FCD,DFCDDJ,DPMAXI,
     &               ITEMAX, JPROLP, JVALEP, NBVALP
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
      INTEGER ICODRE(6)
      CHARACTER*8 NOMRES(6),TYPE
      REAL*8      R8BID,VALRES(6),PENTE,AIRE,TEMP,RESU
C ----------------------------------------------------------------------



C 1 - CARACTERISTIQUE ELASTIQUE E ET NU => CALCUL DE MU - K

      CALL RCVALB(FAMI,KPG,KSP,POUM,MATE,' ','ELAS',0,' ',0.D0,
     &            1,'NU',NU,ICODRE(1),2)
      CALL RCVARC(' ','TEMP',POUM,FAMI,KPG,KSP,TEMP,IRET)
      CALL RCTYPE(MATE,1,'TEMP',TEMP,RESU,TYPE)
      IF ((TYPE.EQ.'TEMP').AND.(IRET.EQ.1))
     &        CALL U2MESS('F','CALCULEL_31')
      CALL RCTRAC(MATE,1,'SIGM',RESU,JPROLP,JVALEP,NBVALP,
     &            YOUNG)


C 2 - SIGY ET ECROUISSAGE EN P-

      CALL RCFONC('S',1,JPROLP,JVALEP,NBVALP,SIGY,
     &           R8BID,R8BID,R8BID,R8BID,R8BID,R8BID,R8BID,R8BID)

      CALL RCFONC('V',1,JPROLP,JVALEP,NBVALP,R8BID,
     &           R8BID,R8BID,PM,RPM,PENTE,AIRE,R8BID,R8BID)


C 3 - PARAMETRES DE CROISSANCE DE CAVITES ET CONTROLE INCR. PLASTIQUE

      NOMRES(1) = 'D'
      NOMRES(2) = 'SIGM_1'
      NOMRES(3) = 'PORO_INIT'
      NOMRES(4) = 'PORO_CRIT'
      NOMRES(5) = 'PORO_ACCE'
      NOMRES(6) = 'DP_MAXI'

      CALL RCVALB(FAMI,KPG,KSP,POUM,MATE,' ','ROUSSELIER',0,' ',
     &            0.D0,6,NOMRES,VALRES,ICODRE,2)
      ROUSD = VALRES(1)
      SIG1  = VALRES(2)
      F0    = VALRES(3)
      FCR   = VALRES(4)
      ACCE  = VALRES(5)
      DPMAXI= VALRES(6)

      END
