      SUBROUTINE EF0344(NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DE EFGE_ELNO
C     ------------------------------------------------------------------
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE
C
C
      INTEGER NBRES
      PARAMETER(NBRES=2)
      INTEGER LMATER,JMAT,NBMAT,IMAT,ICOMP,NBPAR,I,J,NPG,NNO,NC
      INTEGER NCC,JEFFO,IADZI,IAZK24,IRET,LSECT,ITYPE,LX
      INTEGER LORIEN,JDEPL,IRET1,LFORCR,LFORCF
      REAL*8 VALRES(NBRES)
      INTEGER CODRES(NBRES)
      CHARACTER*8 NOMPAR,NOMRES(NBRES),NOMAIL
      CHARACTER*16 MESSK(2)
      REAL*8 VALPAR,ZERO,ANGS2,RAD,E,G,A,XIZ,ALFAZ,ALFAY,EY,EZ
      REAL*8 XJX,XJG,XIY,XL,EPSITH
      REAL*8 NU,FE(12),FI(12),FLR(14),KLV(105)
      REAL*8 ULR(14),UGR(14),PGL(14,14),KLC(14,14)
      REAL*8 PGL1(3,3),PGL2(3,3)
C     ------------------------------------------------------------------
      DATA NOMRES/'E','NU'/
C     ------------------------------------------------------------------


C --- ------------------------------------------------------------------
C --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
      CALL JEVECH('PMATERC','L',LMATER)
C --- ------------------------------------------------------------------
C     BLINDAGE : OPTION VALIDE AVEC UN SEUL PHENOMENE : ELAS
      JMAT=ZI(LMATER)
      NBMAT=ZI(JMAT)
C     UN SEUL MATERIAU
      IF (NBMAT.NE.1) THEN
        MESSK(1)='EFGE_ELNO'
        CALL U2MESK('F','ELEMENTS4_59',1,MESSK)
      ENDIF
C     LE 1ER MATERIAU
      IMAT=JMAT+ZI(JMAT+NBMAT+1)
C     SEUL ELAS EST AUTORISE
      DO 10 ICOMP=1,ZI(IMAT+1)
        IF (ZK16(ZI(IMAT)+ICOMP-1)(1:4).NE.'ELAS') THEN
          MESSK(2)=ZK16(ZI(IMAT)+ICOMP-1)(1:10)
          CALL U2MESK('F','ELEMENTS4_64',2,MESSK)
        ENDIF
   10 CONTINUE
C --- ------------------------------------------------------------------
      NBPAR=0
      NOMPAR='  '
      VALPAR=0.D0
      ZERO=0.D0
      ANGS2=ZERO
      RAD=ZERO
      DO 20 I=1,NBRES
        VALRES(I)=ZERO
   20 CONTINUE
C
      DO 40 I=1,3
        DO 30 J=1,3
          PGL1(I,J)=ZERO
          PGL2(I,J)=ZERO
   30   CONTINUE
   40 CONTINUE
C
      NPG=3
      CALL MOYTEM('RIGI',NPG,1,'+',VALPAR,IRET)

      NBPAR=1
      NOMPAR='TEMP'
C
      CALL RCVALB('RIGI',1,1,'+',ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,
     &            VALPAR,2,NOMRES,VALRES,CODRES,1)
C
      E=VALRES(1)
      NU=VALRES(2)
      G=E/(2.D0*(1.D0+NU))
C --- ------------------------------------------------------------------
C --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS
      CALL JEVECH('PCAGNPO','L',LSECT)
      LSECT=LSECT-1
      A=ZR(LSECT+1)
      XIY=ZR(LSECT+2)
      XIZ=ZR(LSECT+3)
      ALFAY=ZR(LSECT+4)
      ALFAZ=ZR(LSECT+5)
      EY=-ZR(LSECT+6)
      EZ=-ZR(LSECT+7)
      XJX=ZR(LSECT+8)
      XJG=ZR(LSECT+12)
      ITYPE=NINT(ZR(LSECT+23))
      NNO=2
      NC=7
      NCC=6
C --- ------------------------------------------------------------------
C --- RECUPERATION DES COORDONNEES DES NOEUDS
      CALL JEVECH('PGEOMER','L',LX)
      LX=LX-1
      XL=SQRT((ZR(LX+4)-ZR(LX+1))**2+(ZR(LX+5)-ZR(LX+2))**2+
     &   (ZR(LX+6)-ZR(LX+3))**2)
      IF (XL.EQ.0.D0) THEN
        CALL TECAEL(IADZI,IAZK24)
        NOMAIL=ZK24(IAZK24-1+3)(1:8)
        CALL U2MESK('F','ELEMENTS2_43',1,NOMAIL)
      ENDIF
C --- ------------------------------------------------------------------
C --- RECUPERATION DES ORIENTATIONS ALPHA,BETA,GAMMA
      CALL JEVECH('PCAORIE','L',LORIEN)
      CALL MATROT(ZR(LORIEN),PGL)
C --- ------------------------------------------------------------------
C --- CALCUL DE LA MATRICE DE RIGIDITE LOCALE
      CALL PTKA21(KLV,E,A,XL,XIY,XIZ,XJX,XJG,G,ALFAY,ALFAZ,EY,EZ)
C --- ------------------------------------------------------------------
C --- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE
      CALL VECMA(KLV,105,KLC,14)
C
      CALL JEVECH('PDEPLAR','L',JDEPL)
      DO 50 I=1,14
        UGR(I)=ZR(JDEPL+I-1)
   50 CONTINUE
C --- VECTEUR DEPLACEMENT LOCAL  ULR = PGL * UGR
      CALL UTPVGL(NNO,NC,PGL,UGR,ULR)
C --- VECTEUR EFFORT       LOCAL  FLR = KLC * ULR
      CALL PMAVEC('ZERO',14,KLC,ULR,FLR)
C --- ------------------------------------------------------------------
C --- TENIR COMPTE DES EFFORTS DUS A LA DILATATION
      CALL VERIFT('RIGI',NPG,1,'+',ZI(LMATER),'ELAS',1,EPSITH,IRET1)
      DO 60 I=1,14
        UGR(I)=0.D0
   60 CONTINUE
      UGR(1)=-EPSITH*XL
      UGR(8)=-UGR(1)
C --- ------------------------------------------------------------------
C --- CALCUL DES FORCES INDUITES
      DO 70 I=1,7
        FLR(I)=FLR(I)-KLC(I,1)*UGR(1)
        FLR(I+7)=FLR(I+7)-KLC(I+7,1+7)*UGR(1+7)
   70 CONTINUE
C --- ------------------------------------------------------------------
C --- PRISE EN COMPTE DES EFFORTS REPARTIS
      CALL TECACH('ONN','PFR1D1D','L',1,LFORCR,IRET)
      IF (LFORCR.NE.0) THEN
        CALL PTFORP(ITYPE,'CHAR_MECA_FR1D1D',NOMTE,A,A,XL,RAD,ANGS2,1,
     &              NNO,NCC,PGL,PGL1,PGL2,FE,FI)
        DO 80 I=1,6
          FLR(I)=FLR(I)-FE(I)
          FLR(I+7)=FLR(I+7)-FE(I+6)
   80   CONTINUE
      ENDIF
C --- ------------------------------------------------------------------
C --- PRISE EN COMPTE DES EFFORTS REPARTIS (SOUS FORME DE FONCTION)
      CALL TECACH('ONN','PFF1D1D','L',1,LFORCF,IRET)
      IF (LFORCF.NE.0) THEN
        CALL PTFORP(ITYPE,'CHAR_MECA_FF1D1D',NOMTE,A,A,XL,RAD,ANGS2,1,
     &              NNO,NCC,PGL,PGL1,PGL2,FE,FI)
        DO 90 I=1,6
          FLR(I)=FLR(I)-FE(I)
          FLR(I+7)=FLR(I+7)-FE(I+6)
   90   CONTINUE
      ENDIF

C --- ------------------------------------------------------------------
C --- ARCHIVAGE
C ---    NOTER L INVERSION DU SIGNE DES EFFORTS SUR LE PREMIER NOEUD
C        (CONVENTION ADOPTEE/AL95-205)
      CALL JEVECH('PEFFORR','E',JEFFO)
      DO 100 I=1,7
        ZR(JEFFO-1+I)=-FLR(I)
        ZR(JEFFO-1+I+7)=FLR(I+7)
  100 CONTINUE

C
      END
