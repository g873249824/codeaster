      SUBROUTINE APM012(NK,K24RC,LTEST,ITEST,RAYONC,CENTRC,LRAIDE,
     &                  LMASSE,SOLVEU)
      IMPLICIT NONE
      INTEGER      NK,LRAIDE,LMASSE,ITEST
      REAL*8       RAYONC
      COMPLEX*16   CENTRC
      LOGICAL      LTEST
      CHARACTER*19 SOLVEU
      CHARACTER*24 K24RC             
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 10/10/2011   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C     STEPS 0/1/2 OF THE ARGUMENT PRINCIPAL METHOD THAT COUNT THE 
C     EIGENVALUES WITHIN A GIVEN SHAPE OF THE COMPLEX PLANE
C     ------------------------------------------------------------------
C IN NK     : IN : SIZE OF THE EIGENVALUE PROBLEM
C OUT K24RC  :K24 : COEFFICIENTS OF THE CHARACTERISTIC POLYNOMIAL
C IN LTEST  : LOG: RUN OF INTERNAL TEST FOR DEBUGING IF LTEST=.TRUE.
C IN ITEST  : IN : NUMBER OF THE TEST FOR DEBUGING
C IN RAYONC  : R8 : RADIUS OF THE DISC OF THE GIVEN SHAPE
C IN CENTRC : C16: CENTRE OF THE DISC
C IN LRAIDE : IN : JEVEUX DESCRIPTOR OF THE STIFFNESS MATRIX
C IN LMASSE : IN : JEVEUX DESCRIPTOR OF THE MASSE MATRIX
C IN SOLVEU : K19: JEVEUX SD OF THE LINEAR SOLVER
C     ------------------------------------------------------------------
C RESPONSABLE BOITEAU O.BOITEAU
C TOLE CRP_4

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER*4        ZI4
      COMMON  /I4VAJE/ ZI4(1)
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER*4    NK4,ILO,IHI,LWORK4,INFO4
      INTEGER      IFM,NIV,IMATA,NK2,NKM1,I,IVECT,IWORK,VALI,IDEEQ,
     &             IRET,J,IMATB,IMATC,NKJ,LWORK,K,IDEB,IFIN,JM1,IM1,
     &             IAUXH,IAUXH1,RAUXR,IVALR,IVALM,IHCOL,IADIA,IBID,
     &             IVALB,IDELG,IMULT,IFIN1,IMATA0,IWR,IWI,ICONL,IAUX1,
     &             IMAT1,IMAT2,IMAT3,IMAT4,IMAT5,IMAT6,IMAT7,IX
      REAL*8       RAUX1,RAUXX,RBID,CONST(2),RAUXY,RAUXM
      COMPLEX*16   CUN,CZERO,CBD(100),CAUX1,CAUX2,CAUX(100),CBID,ZA,ZB,
     &             ZZC,ZAUX1
      CHARACTER*1  KBID,TYPCST(2)
      CHARACTER*19 NUMEDD,MAS19,K19B,RAI19
      CHARACTER*24 NOMRAI,NOMMAS,NMAT(2)
      CHARACTER*32 JEXNUM

C   --- MISCELLANEOUS ---
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
      CUN=DCMPLX(1.D0,0.D0)
      CZERO=DCMPLX(0.D0,0.D0)
C   --- VERBOSE MODE FOR APM STEPS ---
      NIV=2
      
C   --- STEP 0: INITIALIZATIONS AND BUILDING OF THE WORKING MATRIX ---
      NK4=NK
      NK2=NK*NK
      NKM1=NK-1

      IF (.NOT.LTEST) THEN
C   --- BUILD THE MATRICES M1 AND K1 WHICH ARE THE SAME AS ---
C   --- THE MATRICES M AND K WITHOUT THE CONSTRAINTS       ---
        NOMMAS=ZK24(ZI(LMASSE+1))
        MAS19='&&INVER.MASSMATRIX'
        CALL COPISD('MATR_ASSE','V',NOMMAS(1:19),MAS19)
        CALL JEVEUO(JEXNUM(MAS19//'.VALM',1),'E',IVALM)

        NOMRAI=ZK24(ZI(LRAIDE+1))
        RAI19='&&INVER.STIFFMATRIX'
        CALL COPISD('MATR_ASSE','V',NOMRAI(1:19),RAI19)
        CALL JEVEUO(JEXNUM(RAI19//'.VALM',1),'E',IVALR)

        CALL DISMOI('F','NOM_NUME_DDL',NOMRAI,'MATR_ASSE',IBID,
     &               NUMEDD,IRET)
        CALL JEVEUO(NUMEDD(1:14)//'.SMOS.SMHC','L',IHCOL)
        CALL JEVEUO(NUMEDD(1:14)//'.SMOS.SMDI','L',IADIA)
        CALL JEVEUO(NUMEDD(1:14)//'.NUME.DELG','L',IDELG)
        CALL JEVEUO(NUMEDD(1:14)//'.NUME.DEEQ','L',IDEEQ)

        RAUXX=DBLE(CENTRC)
        RAUXY=DIMAG(CENTRC)
        RAUXM=SQRT(RAUXX*RAUXX+RAUXY*RAUXY)
        RAUX1=RAUXM+2.D0*RAYONC
        IDEB=1
        DO 18 J=1,NK
          JM1=J-1
          IFIN=ZI(IADIA+JM1)
          IFIN1=IFIN-1
C   --- TO FILTER LAGRANGIAN AND PASSIVE PHYSICAL COLUMNS ---
          IF (ZI(IDELG+JM1).NE.0) THEN
C   --- COLUMN CORRESPONDING TO A LAGRANGIAN MULTIPLIER ---
            IMULT=0
          ELSE
C   --- COLUMN CORRESPONDING TO A PHYSICAL VARIABLE (ACTIVE OR PASSIVE)
C   --- ACTIVE ---
            IMULT=1
            DO 15 I=IDEB,IFIN
              IM1=I-1
              IAUXH=ZI4(IHCOL+IM1)
              RAUXX=ABS(ZR(IVALR+IM1))
C   --- PASSIVE (ONLY FIXED DOF NOT LINK ONE ) ---
              IF ((ZI(IDELG+IAUXH-1).NE.0).AND.(RAUXX.NE.0.D0)) THEN
                IF ((ZI(IDEEQ-1+2*(IAUXH-1)+1).GT.0).AND.
     &            (ZI(IDEEQ-1+2*(IAUXH-1)+2).LT.0)) THEN
                  IMULT=0
                ENDIF
              ENDIF
   15       CONTINUE
          ENDIF
          DO 16 I=IDEB,IFIN
            IM1=I-1
            ZR(IVALR+IM1)=ZR(IVALR+IM1)*IMULT
            ZR(IVALM+IM1)=ZR(IVALM+IM1)*IMULT
   16     CONTINUE
          IF (IMULT.EQ.0) THEN
            ZR(IVALR+IFIN1)=RAUX1
            ZR(IVALM+IFIN1)=1.D0
          ENDIF   
          IDEB=IFIN+1
   18   CONTINUE

C   --- FOR DEBUGING ONLY ---
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,'.NUME.DELG',15,'G')
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,'.SMOS',15,'G')      
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,'MATASSR',1,'G')
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,'MATASSM',1,'G')
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,RAI19,1,'V')
C        CALL UTIMSD(6,2,.FALSE.,.TRUE.,MAS19,1,'V')

        K19B=' '  
        CALL PRERES(SOLVEU,'V',IRET,K19B,MAS19,IBID,1)

C   --- CASE K REAL SYMETRIC ---
        CALL WKVECT('&&APM012.MATRICE.A0','V V R',NK2,IMATA0)
        DO 34 I=1,NK2
          ZR(IMATA0+I-1)=0.D0
   34   CONTINUE
        IDEB=1
        DO 38 J=1,NK
          JM1=J-1
          IFIN=ZI(IADIA+JM1)
          DO 36 I=IDEB,IFIN
            IM1=I-1
            IAUXH=ZI4(IHCOL+IM1)
            IAUXH1=IAUXH-1
            RAUXR=ZR(IVALR+IM1)
C   --- UPPER PARTS
            ZR(IMATA0+JM1*NK+IAUXH1)=RAUXR
C   --- LOWER PARTS
            ZR(IMATA0+NK*IAUXH1+JM1)=RAUXR
   36     CONTINUE
          IDEB=IFIN+1
   38   CONTINUE

C   --- BUILDING OF M-1*K AND STORE IN ZC(IMATA)
        CALL RESOUD(MAS19,K19B,K19B,SOLVEU,K19B,'V',K19B,
     &            ' ',NK,ZR(IMATA0),CBID,.FALSE.)
        CALL WKVECT('&&APM012.MATRICE.A','V V C',NK2,IMATA)
        DO 41 I=1,NK2
          IM1=I-1
          ZC(IMATA+IM1)=ZR(IMATA0+IM1)*CUN
   41   CONTINUE
C
C   --- FOR DEBUGGING ONLY
C   --- COMPUTATIONS OF THE EIGENVALUES OF THE                     ---
C   --- WORKING MATRIX A THANKS TO THE LAPACK DGEEV                ---
C        LWORK=10*NK
C        LWORK4=LWORK
C        CALL WKVECT('&&APM012.TEST.DGEEV.WR','V V R',NK,IWR)
C        CALL WKVECT('&&APM012.TEST.DGEEV.WI','V V R',NK,IWI)
C        CALL WKVECT('&&APM012.TEST.DGEEV.WO','V V R',LWORK,IWORK)
C        CALL DGEEV('N','N',NK4,ZR(IMATA0),NK4,ZR(IWR),ZR(IWI),
C     &               RBID,NK4,RBID,NK4,ZR(IWORK),LWORK4,INFO4)
C        WRITE(IFM,*)'**** EIGENVALUE WORKING MATRIX *******'
C        WRITE(IFM,*)'    INFO LAPACK= ',INFO4
C        DO 2 I=1,NK
C          WRITE(IFM,*)I,ZR(IWR-1+I),ZR(IWI-1+I)
C   2    CONTINUE
C        CALL JEDETR('&&APM012.TEST.DGEEV.WR')
C        CALL JEDETR('&&APM012.TEST.DGEEV.WI')
C        CALL JEDETR('&&APM012.TEST.DGEEV.WO')
C
       CALL JEDETR('&&APM012.MATRICE.A0')
        
      ELSE
C   --- FOR TEST ISSUE ONLY ---

        CALL WKVECT('&&APM012.MATRICE.A','V V C',NK2,IMATA)
        CALL APTEST(NK,IMATA,ITEST,CBD)    
      ENDIF

C   --- STEP 1: COMPUTING OF THE HESSENBERG FORM OF DENSE MATRIX ---
C   --- ZC(IMATA) THANKS TO THE LAPACK ROUTINE DGEHRD            ---
      CALL WKVECT('&&APM012.ZGEHRD.TAU','V V C',NK-1,IVECT)
      CALL WKVECT('&&APM012.ZGEHRD.WORK','V V C',NK,IWORK)
      ILO=1
      IHI=NK4                 
      CALL ZGEHRD(NK4,ILO,IHI,ZC(IMATA),NK4,ZC(IVECT),ZC(IWORK),-1,
     &            INFO4)
      IF (INFO4.EQ.0) THEN
        LWORK4=INT(DBLE(ZC(IWORK)))
        LWORK =INT(DBLE(ZC(IWORK)))
        CALL JEDETR('&&APM012.ZGEHRD.WORK')
        CALL WKVECT('&&APM012.ZGEHRD.WORK','V V C',LWORK,IWORK)
        CALL ZGEHRD(NK4,ILO,IHI,ZC(IMATA),NK4,ZC(IVECT),ZC(IWORK),
     &              LWORK4,INFO4)       
      ENDIF
      VALI=INFO4
      IF (VALI.NE.0) CALL U2MESI('F','ALGELINE4_12',1,VALI)
      CALL JEEXIN('&&APM012.ZGEHRD.WORK',IRET)
      IF (IRET.NE.0) THEN
        CALL JEDETR('&&APM012.ZGEHRD.TAU')    
        CALL JEDETR('&&APM012.ZGEHRD.WORK')
      ENDIF

C   --- TO CLARIFY THE SITUATION, ZEROING THE LOWER TRIANGULAR ---
C   --- PART OF THE HESSENBERG MATRIX                          ---
      DO 90 J=1,NK
        DO 89 I=1,NK
          IF (I.GE.(J+2)) ZC(IMATA+(J-1)*NK+I-1)=CZERO
  89    CONTINUE
  90  CONTINUE


C   --- STEP 2: COMPUTATION OF THE COEFFICIENTS OF THE CHARACTERISTIC --
C   --- POLYNOMIAL THANKS TO THE ROMBOUTS ALGORITHM                  ---
C   --- COEFFICIENTS OF THE CHARACTERISTIC POLYNOMIAL AK             ---
C   --- P(X)=A0+A1*X+A2*(X**2)+....+A(NK-1)*(X**(NK-1))+1.D0*X**NK   ---
C   --- WITH AI=ZK(IMATC+I)                                          ---
      K24RC='&&APM012.ROMBOUT.COEFF'
      CALL WKVECT('&&APM012.ROMBOUT.MAT','V V C',NK2,IMATB)
      CALL WKVECT(K24RC,'V V C',NK+1,IMATC)
      DO 100 I=1,NK2
        ZC(IMATB+I-1)=CZERO
  100 CONTINUE
      DO 120 J=NK,1,-1
        NKJ=NK-J      
        DO 110 I=1,J
          DO 105 K=NKJ,1,-1
            CAUX1=DCONJG(ZC(IMATA+(J-1)*NK+I-1))*
     &                   ZC(IMATB+(J+1-1)*NK+K-1)

            CAUX2=DCONJG(ZC(IMATA+(J-1)*NK+J+1-1))*
     &                   ZC(IMATB+(I-1)*NK+K-1)           
            ZC(IMATB+(I-1)*NK+K+1-1)=CAUX1-CAUX2
  105     CONTINUE
          ZC(IMATB+(I-1)*NK+1-1)=DCONJG(ZC(IMATA+(J-1)*NK+I-1))
  110   CONTINUE
        DO 115 K=1,NKJ
          ZC(IMATB+(J-1)*NK+K-1)=ZC(IMATB+(J-1)  *NK+K-1)+
     &                             ZC(IMATB+(J+1-1)*NK+K-1)
  115   CONTINUE
  120 CONTINUE
      ZC(IMATC+NK+1-1)=CUN
      DO 125 I=1,NK
        NKJ=NK-(I-1)
        ZC(IMATC+I-1)=((-1)**NKJ)*ZC(IMATB+(1-1)*NK+NKJ-1)
  125 CONTINUE
      CALL JEDETR('&&APM012.MATRICE.A')
      CALL JEDETR('&&APM012.ROMBOUT.MAT')
      
      IF ((NIV.GE.2).OR.(LTEST)) THEN
        WRITE(IFM,*)'COEFFICIENTS OF ROMBOUT POLYNOMIAL'
        WRITE(IFM,*)'----------------------------------'
        DO 150 I=0,NK
          WRITE(IFM,*)'I/AI ',I,ZC(IMATC+I)
  150   CONTINUE
      ENDIF

C   --- INTERMEDIARY TEST RESULT ---
      IF (LTEST) THEN
        DO 130 J=1,NK
          CAUX(J)=ZC(IMATC+NK)
  130   CONTINUE
        DO 132 I=NKM1,0,-1
          DO 131 J=1,NK
            CAUX(J)=CAUX(J)*CBD(J)+ZC(IMATC+I)              
  131     CONTINUE
  132   CONTINUE
        DO 133 J=1,NK
          RAUXX=DBLE(CAUX(J))
          RAUXY=DIMAG(CAUX(J))
          RAUXM=SQRT(RAUXX*RAUXX+RAUXY*RAUXY)
          WRITE(IFM,*)'STEP 2: ROOT  I/P(LBD_I)',J,RAUXM,CAUX(J)
  133   CONTINUE
      ENDIF

      CALL JEDEMA()
      END
