      SUBROUTINE TE0419 ( OPTION , NOMTE )
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          POUR LES ELEMENTS MEC3QU9H, MEC3TR7H
C                          OPTIONS : 'CHAR_MECA_TEMP_R'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      INTEGER NB1,NB2,NDDLE,NPGE,NPGSR,NPGSN
      REAL*8 VECTA(9,2,3),VECTN(9,3),VECTPT(9,2,3),VECPT(9,3,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 HSFM(3,9),HSS(2,9),HSJ1M(3,9),HSJ1S(2,9)
      REAL*8 BTDM(4,3,42),BTDS(4,2,42)
      REAL*8 HSF(3,9),HSJ1FX(3,9),WGT
      REAL*8 BTDF(3,42),BTILD(5,42)
      REAL*8 FORTHI(42),FORCTH(42),VECL(51)
      REAL*8 YOUNG,NU,ALPHA
      PARAMETER (NPGE=2)
      REAL*8 EPSVAL(NPGE),KSI3S2,KSI3
      DATA EPSVAL / -0.577350269189626D0,  0.577350269189626D0 /
C
      CALL JEVECH ( 'PGEOMER' , 'L' , JGEOM )
      CALL JEVECH ( 'PVECTUR' , 'E' , JVECG )
C
C     RECUPERATION DES OBJETS
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESI',' ', LZI )
      NB1  =ZI(LZI-1+1)
      NB2  =ZI(LZI-1+2)
      NPGSR=ZI(LZI-1+3)
      NPGSN=ZI(LZI-1+4)
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ', LZR )
C
      CALL JEVECH ('PCACOQU' , 'L' , JCARA)
      EPAIS = ZR(JCARA)
C
      NDDLE = 5*NB1+2


C     RECUPERATION DE LA TEMPERATURE DE REFERENCE

C
      DO 5 I=1,NDDLE
         FORCTH(I)=0.D0
 5    CONTINUE
C
      CALL VECTAN(NB1,NB2,ZR(JGEOM),ZR(LZR),VECTA,VECTN,VECTPT)
C
      KWGT=0
      DO 100 INTE=1,NPGE
         KSI3S2=EPSVAL(INTE)/2.D0
C
C     CALCUL DE BTDMR, BTDSR : M=MEMBRANE , S=CISAILLEMENT , R=REDUIT
C
      DO 150 INTSR=1,NPGSR
      CALL MAHSMS(0,NB1,ZR(JGEOM),KSI3S2,INTSR,ZR(LZR),EPAIS,VECTN,
     &                                       VECTG,VECTT,HSFM,HSS)
C
      CALL HSJ1MS(EPAIS,VECTG,VECTT,HSFM,HSS,HSJ1M,HSJ1S)
C
      CALL BTDMSR(NB1,NB2,KSI3S2,INTSR,ZR(LZR),EPAIS,VECTPT,
     &                                       HSJ1M,HSJ1S,BTDM,BTDS)
 150  CONTINUE
C
      DO 200 INTSN=1,NPGSN
C
C     CALCUL DE BTDFN : F=FLEXION , N=NORMAL
C     ET DEFINITION DE WGT=PRODUIT DES POIDS ASSOCIES AUX PTS DE GAUSS
C                          (NORMAL) ET DU DETERMINANT DU JACOBIEN
C
      CALL MAHSF(1,NB1,ZR(JGEOM),KSI3S2,INTSN,ZR(LZR),EPAIS,VECTN,
     &                                             VECTG,VECTT,HSF)
C
      CALL HSJ1F(INTSN,ZR(LZR),EPAIS,VECTG,VECTT,HSF,KWGT,HSJ1FX,WGT)
C
      CALL BTDFN(1,NB1,NB2,KSI3S2,INTSN,ZR(LZR),EPAIS,VECTPT,
     &                                                      HSJ1FX,BTDF)
C
C     CALCUL DE BTDMN, BTDSN
C     ET
C     FORMATION DE BTILD
C
      CALL BTDMSN(1,NB1,INTSN,NPGSR,ZR(LZR),BTDM,BTDF,BTDS,BTILD)
C
      CALL MATRTH('MASS',NPGSN,YOUNG,NU,ALPHA,INDITH)
C
C     CALCUL DU CHAMP DE TEMPERATURE ET(OU) DES EFFORTS THERMIQUES
C     INDIC=1 : TEMPERATURE ET EFFORTS THERMIQUES
C     INDIC=0 : TEMPERATURE
C
      INDIC=1
      KSI3=EPSVAL(INTE)
      CALL BTLDTH('MASS',KSI3,NB1,INTSN,BTILD,WGT,INDIC,YOUNG,NU,
     &             ALPHA,TEMPER,FORTHI)
C
      DO 11 I=1,NDDLE
         FORCTH(I)=FORCTH(I)+FORTHI(I)
 11   CONTINUE
C
 200  CONTINUE
 100  CONTINUE
C
      CALL VEXPAN(NB1,FORCTH,VECL)
      DO 90 I=1,3
         VECL(6*NB1+I)=0.D0
 90   CONTINUE
C
      DO 15 IB=1,NB2
      DO 16  I=1,2
      DO 17  J=1,3
         VECPT(IB,I,J)=VECTPT(IB,I,J)
 17   CONTINUE
 16   CONTINUE
         VECPT(IB,3,1)=VECTN(IB,1)
         VECPT(IB,3,2)=VECTN(IB,2)
         VECPT(IB,3,3)=VECTN(IB,3)
 15   CONTINUE
C
      CALL TRNFLG(NB2,VECPT,VECL,ZR(JVECG))
C
      END
