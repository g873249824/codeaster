      SUBROUTINE STATVT(IMATE,MECA,DIMCON,ADCOME,CONGEP,ATMP,S3,P1,P2,
     &                  J1,J2,J3, BT,DF,DC,RDBTDT,RDBTP1,RDBTP2,PHI)
C
C     CETTE ROUTINE CALCULE LES DERIVEES DE 
C     LA SURFACE D'ETAT DE L'INDICE DES VIDES 
C     POUR LA MODELISATION DE THM DE B. GATMIRI (CERMES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_21
C
C
      IMPLICIT NONE
C
      CHARACTER*16  MECA
      INTEGER  DIMCON,ADCOME,I,IMATE
      REAL*8   CONGEP(DIMCON)
      REAL*8   P2,P1,SUC,SY,ATMP,SUCN,SYN
      REAL*8   EVAE,EVBE,EVCE,EVCTE,EVSIGB,EVKB,EVXM
      REAL*8   SIGBN,ASIG,BSUC,DNOM1,DNOM2
C      REAL*8   EV,DNEXP,EVDE
      REAL*8   BT,XM1,XMT,DC,DF,J1,J2,J3,PHI
      REAL*8   SMEAN,S3,AP1,TENS,TEN,BB
      REAL*8   RDBTDT,RDBTP1,RDBTP2

      INTEGER   NBPAR,NSUREV,NRESMA
      PARAMETER ( NSUREV=7 )
      PARAMETER (NRESMA = 18)
      REAL*8    VALPAR,VALSUR(NSUREV)
      CHARACTER*8 NOMPAR,BGCR4(NSUREV)
      CHARACTER*2 CODRET(NRESMA)

      DATA BGCR4 /'EV_A','EV_B','EV_CT',
     &            'EV_SIGB','EV_KB','EV_XM','RESI_TRAC'/
C
C
      SUC=P2-P1
      IF(SUC.LE.0.D0) SUC=0.D0
      SUCN=ABS(SUC)/ATMP
      SY=0.D0
         DO 102 I=1,3
            SY=SY+CONGEP(ADCOME-1+I)
 102    CONTINUE
      SY=SY/3.D0
      SYN=ABS(SY)/ATMP
          IF (MECA.EQ.'SURF_ETAT_NSAT')THEN
C         LIRE LES COEFFICIENTS CALCUL LES LOIS
            NBPAR  = 0
            VALPAR = 0.D0
            NOMPAR = ' '
             CALL RCVALA ( IMATE,'SURF_ETAT_NSAT',NBPAR,NOMPAR,VALPAR,
     &              NSUREV,BGCR4,VALSUR,CODRET, 'FM' )
            EVAE    = VALSUR(1)
            EVBE    = VALSUR(2)        
            EVCTE   = VALSUR(3)
            EVSIGB  = VALSUR(4)
            EVKB    = VALSUR(5)
            EVXM    = VALSUR(6)
            TEN     = VALSUR(7)
          ENDIF
      EVCE= EVKB*ATMP
      SIGBN=EVSIGB/ATMP
      ASIG=EVAE*SIGBN
      BSUC=EVBE*SUCN
      IF(BSUC.GE.ASIG)THEN
        WRITE (6,*) 'STATVT>EVAE,SIGBN,EVBE,SUCN,ASIG,BSUC',
     &        EVAE,SIGBN,EVBE,SUCN,ASIG,BSUC
        CALL UTMESS('F','STATEVT','STATE SURFACE OF VOID RATIO'//
     &                 ' IS NOT CORRECT') 
      ENDIF
C      DNEXP=EVCE*(1.D0-EVXM)/ATMP
      DNOM1=EVAE-EVBE*SUCN/SIGBN
      DNOM2=DNOM1*SYN+EVBE*SUCN
      IF(EVXM.EQ.1.D0)THEN
C      EV=(1.D0+EVDE)/(EXP(DT*EVCTE))-1.D0
      BT=(EVCE/DNOM1)*(DNOM2)
      XM1=(EVBE*(1.D0-SYN/SIGBN))/(EVCE*DNOM2)
      XMT=-EVCTE
      RDBTDT =0.D0
      RDBTP1 =((EVCE*DNOM1)*(EVBE*(1.D0
     &       -SYN/SIGBN))/ATMP+EVBE*EVCE*(DNOM2)/EVSIGB)
     &        /DNOM1/DNOM1
      RDBTP2 =((EVCE*DNOM1)*(EVBE*(-1.D0
     &       +SYN/SIGBN))/ATMP-EVBE*EVCE*(DNOM2)/EVSIGB)
     &        /DNOM1/DNOM1
      GO TO 1000
      ENDIF
      IF(SUCN.NE.0.D0) GO TO 200
      SMEAN=S3
      AP1=0.1D0*ATMP
      TENS=S3+TEN
      IF(S3.GT.0.D0) GO TO 400
      IF(TENS.GT.0.D0)THEN
      SMEAN=TENS
      GO TO 400
      ENDIF
      SMEAN=AP1
      BB=1.D0
      IF(EVXM.GT.0.001D0) BB=(SMEAN/ATMP)**EVXM
      BT=EVCE*BB
      RDBTDT =0.D0
      RDBTP1 =0.D0
      RDBTP2 =0.D0
      GO TO 1000
400   CONTINUE   
C      IF(SYN.EQ.0.D0)THEN
C      EV=(1.D0+EVDE)/(EXP(DT*EVCTE))-1.D0
C      ELSE
C      EV=(1.D0+EVDE)/
C     > (EXP(((EVAE*SYN)**(1.D0-EVXM))/DNEXP+DT*EVCTE))-1.D0
C      ENDIF
      BT=EVCE*(SMEAN/ATMP)**EVXM
      XM1=0.D0
      XMT=-EVCTE
      RDBTDT =0.D0
      RDBTP1 =0.D0
      RDBTP2 =0.D0
      GO TO 1000
200   CONTINUE
C      EV=(1.D0+EVDE)/(EXP((DNOM2)**(1.D0-EVXM)/DNEXP+DT*EVCTE))-1.D0
      XMT=-EVCTE
      RDBTDT =0.D0
      IF(DNOM2.EQ.0.D0)THEN
      RDBTP1 =0.D0
      RDBTP2 =0.D0
      XM1=0.D0
      BT=EVCE/DNOM1
      ELSE
      BT=(EVCE/DNOM1)*(DNOM2**EVXM)
      RDBTP1 =((EVCE*DNOM1)*EVXM*(DNOM2**(EVXM-1.D0))*(EVBE*(1.D0
     &       -SYN/SIGBN))/ATMP+EVBE*EVCE*(DNOM2**EVXM)/EVSIGB)
     &        /DNOM1/DNOM1
      RDBTP2 =((EVCE*DNOM1)*EVXM*(DNOM2**(EVXM-1.D0))*(EVBE*(-1.D0
     &       +SYN/SIGBN))/ATMP-EVBE*EVCE*(DNOM2**EVXM)/EVSIGB)
     &        /DNOM1/DNOM1
      XM1=(EVBE*(1.D0-SYN/SIGBN))/(EVCE*DNOM2**EVXM)
      ENDIF
1000  CONTINUE
      DF=3.D0*BT*XM1
      DC=3.D0*BT*XMT
      IF(EVXM.EQ.0.D0)THEN
      J1=-(PHI-1.D0)/EVCE*DNOM1
      J2=-(PHI-1.D0)*EVBE*(1.D0-SYN/SIGBN)/EVCE
      ELSE
          IF(DNOM2.EQ.0.D0)THEN
          J1=-(PHI-1.D0)/EVCE*DNOM1
          J2=-(PHI-1.D0)*EVBE*(1.D0-SYN/SIGBN)/EVCE
          ELSE
          J1=-(PHI-1.D0)/EVCE*DNOM1/(DNOM2**EVXM)
          J2=-(PHI-1.D0)*EVBE*(1.D0-SYN/SIGBN)/(DNOM2**EVXM)/EVCE
          ENDIF
      ENDIF
      J3=-(PHI-1.D0)*XMT
      END
