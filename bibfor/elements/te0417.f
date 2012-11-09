      SUBROUTINE TE0417(OPTION,NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*(*)     OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C     OPTION : 'MASS_INER'              (ELEMENTS COQUE_3D)
C     ------------------------------------------------------------------
C
      REAL*8 XI(3,9),XG(3),IX2(3),IX1X2,IX1X3,IX2X3,MATINE(6)
      REAL*8 VECTA(9,2,3),VECTN(9,3),VECTPT(9,2,3),R8PREM
C
C     RECUPERATION DES OBJETS
C
C-----------------------------------------------------------------------
      INTEGER I ,INTSN ,INTSX ,J ,JGEOM ,K ,L1
      INTEGER L2 ,LCASTR ,LZI ,LZR ,NB1 ,NB2 ,NPGSN

      REAL*8 EPAIS ,EPAIS2 ,EPAIS3 ,RHO ,RNORMC ,VOLUME ,WGT
      REAL*8 XX ,XY ,XZ ,YY ,YZ ,ZZ
C-----------------------------------------------------------------------
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESI',' ', LZI )
      NB1  =ZI(LZI-1+1)
      NB2  =ZI(LZI-1+2)
      NPGSN=ZI(LZI-1+4)
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ', LZR )
C
      CALL JEVECH ('PGEOMER' , 'L' , JGEOM)
C
      DO 5 I=1,NB2
         XI(1,I)=ZR(JGEOM+3*(I-1))
         XI(2,I)=ZR(JGEOM+3*(I-1)+1)
         XI(3,I)=ZR(JGEOM+3*(I-1)+2)
 5    CONTINUE
C
      CALL DXROEP(RHO,EPAIS)
      IF(RHO.LE.R8PREM()) THEN
         CALL U2MESS('F','ELEMENTS5_45')
      ENDIF
      EPAIS2=EPAIS*EPAIS
      EPAIS3=EPAIS*EPAIS2
C
      CALL JEVECH('PMASSINE','E',LCASTR)
C
      CALL VECTAN(NB1,NB2,XI,ZR(LZR),VECTA,VECTN,VECTPT)
C
      VOLUME=0.D0
C
      DO 10 K=1,3
         XG(K) =0.D0
         IX2(K)=0.D0
 10   CONTINUE
         IX1X2 =0.D0
         IX1X3 =0.D0
         IX2X3 =0.D0
C
      DO 200 INTSN=1,NPGSN
C
C     RNORMC EST LE DETERMINANT DE LA SURFACE MOYENNE
C
      CALL VECTCI(INTSN,NB1,XI,ZR(LZR),RNORMC)
C
C     WGT= ZR(9-1+INTE) * ZR(LZR+126-1+INTSN)
C        =    1.D0      * ZR(LZR+126-1+INTSN)
      WGT=                ZR(LZR+126-1+INTSN)
C
      VOLUME=VOLUME+EPAIS*WGT*RNORMC
C
C     CENTRE DE GRAVITE
C
      L1=LZR-1+135
      INTSX=8*(INTSN-1)
      L2=L1+INTSX
C
      WGT=WGT*RNORMC
C
      DO 20 J=1,NB1
        DO 25 K=1,3
         XG(K)=XG(K)+EPAIS*WGT*ZR(L2+J)*XI(K,J)
 25     CONTINUE
C
C     MOMENTS ET PRODUITS D'INERTIE
C
      DO 30 I=1,NB1
        DO 35 K=1,3
         IX2(K)=IX2(K)+EPAIS*WGT*ZR(L2+J)*XI(K,J)*ZR(L2+I)*XI(K,I)
     &         +EPAIS3/12.D0*WGT*ZR(L2+J)*VECTN(J,K)*ZR(L2+I)*VECTN(I,K)
 35     CONTINUE
C
         IX1X2=IX1X2+EPAIS*WGT*ZR(L2+J)*XI(1,J)*ZR(L2+I)*XI(2,I)
     &         +EPAIS3/12.D0*WGT*ZR(L2+J)*VECTN(J,1)*ZR(L2+I)*VECTN(I,2)
         IX1X3=IX1X3+EPAIS*WGT*ZR(L2+J)*XI(1,J)*ZR(L2+I)*XI(3,I)
     &         +EPAIS3/12.D0*WGT*ZR(L2+J)*VECTN(J,1)*ZR(L2+I)*VECTN(I,3)
         IX2X3=IX2X3+EPAIS*WGT*ZR(L2+J)*XI(2,J)*ZR(L2+I)*XI(3,I)
     &         +EPAIS3/12.D0*WGT*ZR(L2+J)*VECTN(J,2)*ZR(L2+I)*VECTN(I,3)
 30   CONTINUE
C
 20   CONTINUE
C
 200  CONTINUE
C
         MATINE(1)=RHO*(IX2(2)+IX2(3))
         MATINE(2)=RHO*IX1X2
         MATINE(3)=RHO*(IX2(1)+IX2(3))
         MATINE(4)=RHO*IX1X3
         MATINE(5)=RHO*IX2X3
         MATINE(6)=RHO*(IX2(1)+IX2(2))
C
         ZR(LCASTR)  =RHO*VOLUME
         ZR(LCASTR+1)=XG(1)/VOLUME
         ZR(LCASTR+2)=XG(2)/VOLUME
         ZR(LCASTR+3)=XG(3)/VOLUME
C
         XX=ZR(LCASTR+1)*ZR(LCASTR+1)
         YY=ZR(LCASTR+2)*ZR(LCASTR+2)
         ZZ=ZR(LCASTR+3)*ZR(LCASTR+3)
         XY=ZR(LCASTR+1)*ZR(LCASTR+2)
         XZ=ZR(LCASTR+1)*ZR(LCASTR+3)
         YZ=ZR(LCASTR+2)*ZR(LCASTR+3)
C
         ZR(LCASTR+4)=MATINE(1)-ZR(LCASTR)*(YY+ZZ)
         ZR(LCASTR+5)=MATINE(3)-ZR(LCASTR)*(XX+ZZ)
         ZR(LCASTR+6)=MATINE(6)-ZR(LCASTR)*(XX+YY)
         ZR(LCASTR+7)=MATINE(2)-ZR(LCASTR)*XY
         ZR(LCASTR+8)=MATINE(4)-ZR(LCASTR)*XZ
         ZR(LCASTR+9)=MATINE(5)-ZR(LCASTR)*YZ
C
      END
