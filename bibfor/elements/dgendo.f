      SUBROUTINE DGENDO(EM,EF,H,SYT,SYC,NUM,NUF,
     &                  PENDT,PELAST,PENDF,PELASF,
     &                  IENDO,ICISAI,ICOMPR,GT,GF,GC,
     &                  IPENTE,NP,DXP)

      IMPLICIT   NONE

C PARAMETRES ENTRANTS
      INTEGER IENDO,ICOMPR,ICISAI,IPENTE
      REAL*8  EM,EF,H,SYT,SYC,NUM,NUF,NP,DXP
      REAL*8  PENDT,PENDC,PELAST,PENDF,PELASF

C PARAMETRES SORTANTS
      REAL*8  GT,GF,GC

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/01/2011   AUTEUR SFAYOLLE S.FAYOLLE 
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
C RESONSABLE
C ----------------------------------------------------------------------
C
C BUT : CALCUL DES PARAMETRES D'ENDOMMAGEMENT GAMMA_T, GAMMA_C
C       ET GAMMA_F
C
C IN:
C       EM    : MODULE D YOUNG EN MEMBRANE
C       EF    : MODULE D YOUNG EN FLEXION
C       H     : EPAISSEUR DE LA PLAQUE
C       SYT   : SEUIL D'ENDOMMAGEMENT EN TRACTION
C       SYC   : SEUIL D'ENDOMMAGEMENT EN COMPRESSION
C       NUM   : COEFF DE POISSON EN MEMBRANE
C       NUF   : COEFF DE POISSON EN FLEXION
C       PENDT : PENTE POST ENDOMMAGEMENT EN MEMBRANNE
C       PELAST: PENTE ELASTIQUE EN TRACTION
C       PENDF : PENTE POST ENDOMMAGEMENT EN FLEXION
C       PELASF: PENTE ELASTIQUE EN FLEXION
C       IENDO :
C       ICISAI: INDICATEUR DE CISAILLEMENT
C       ICOMPR: METHODE DE COMPRESSION
C       IPENTE: OPTION DE CALCUL DES PENTES POST ENDOMMAGEMENT
C               1 : RIGI_ACIER
C               2 : PLAS_ACIER
C               3 : UTIL
C       NP    : EFFORT A PLASTICITE
C       DXP   : DEPLACEMENT A PLASTICITE
C OUT:
C       GT    : GAMMA DE TRACTION
C       GF    : GAMMA DE FLEXION
C       GC    : GAMMA DE CISAILLEMENT
C ----------------------------------------------------------------------
C PARAMETRES INTERMEDIAIRES
      INTEGER NS,II
      REAL*8  C1,C2,C3,ALPHA,BETA,X(3),GT3(3)
      REAL*8  XF,GF1,GF2,SYTXY,DXD

C DETERMINATION DE GAMMA_T ET DE GAMMA_C PAR ESSAI DE TRACTION
C METHODE 1
        IF (IENDO .EQ. 1) THEN
          IF (ICOMPR .EQ. 1) THEN
      GT=(-16.D0*PENDT*SYC**4*NUM**3+9.D0*PENDT*NUM**8*SYC**4+4.D0*
     &PENDT*SYC**4*NUM-2.D0*PENDT*SYC**4*NUM**2+6.D0*PENDT*SYC**4*NUM**4
     &+2.D0*PENDT*SYT**4*NUM**4+26.D0*PENDT*SYC**4*NUM**5+6.D0*PENDT*
     &SYT**4*NUM**5-14.D0*PENDT*NUM**6*SYC**4+PENDT*NUM**6*SYT**4-14.D0*
     &PENDT*NUM**7*SYC**4-2.D0*PENDT*NUM**7*SYT**4-PENDT*SYT**4*NUM**2-
     &2.D0*PENDT*SYT**4*NUM**3-EM*H*SYC**2*SYT**2*NUM**2+EM*H*SYC**2*
     &NUM**3*SYT**2+7.D0*EM*H*SYC**2*NUM**4*SYT**2+EM*H*SYC**2*NUM**5
     &*SYT**2-5.D0*EM*H*NUM**6*SYC**2*SYT**2-EM*H*NUM**7*SYC**2*SYT**2
     &+PENDT*SYC**2*SYT**2*NUM**2-PENDT*SYC**2*NUM**3*SYT**2-7.D0*
     &PENDT*SYC**2*NUM**4*SYT**2-PENDT*SYC**2*NUM**5*SYT**2+5.D0*PENDT
     &*NUM**6*SYC**2*SYT**2+PENDT*NUM**7*SYC**2*SYT**2+PENDT*SYC**4-
     &4.D0*EM*H*SYC**4*NUM**3-7.D0*EM*H*SYC**4*NUM**4-2.D0*EM*H*SYT**4*
     &NUM**4+10.D0*EM*H*SYC**4*NUM**5-6.D0*EM*H*SYT**4*NUM**5+12.D0*EM*
     &H*
     &NUM**6*SYC**4-EM*H*NUM**6*SYT**4-10.D0*EM*H*NUM**7*SYC**4+2.D0*EM*
     &H*NUM**7*SYT**4+EM*H*SYT**4*NUM**2+2.D0*EM*H*SYT**4*NUM**3)
      GT=GT/(4.D0*
     &EM*H*SYC**4*NUM+EM*H*SYC**4-2.D0*PENDT*SYC**4*NUM**3+9.D0*PENDT*
     &NUM**8*SYC**4-2.D0*PENDT*SYC**4*NUM**2+12.D0*PENDT*SYC**4*NUM**4+
     &2.D0*PENDT*SYT**4*NUM**4+10.D0*PENDT*SYC**4*NUM**5+6.D0*PENDT*
     &SYT**4*NUM**5-19.D0*PENDT*NUM**6*SYC**4+PENDT*NUM**6*SYT**4-8.D0*
     &PENDT*NUM**7*SYC**4-2.D0*PENDT*NUM**7*SYT**4-PENDT*SYT**4*NUM**2-
     &2.D0*PENDT*SYT**4*NUM**3-2.D0*EM*H*SYC**2*SYT**2*NUM**2-2.D0*EM*H*
     &SYC**2*NUM**3*SYT**2+8.D0*EM*H*SYC**2*NUM**4*SYT**2+8.D0*EM*H*
     &SYC**2*NUM**5*SYT**2-4.D0*EM*H*NUM**6*SYC**2*SYT**2-4.D0*EM*H*
     &NUM**7*SYC**2*SYT**2+2.D0*PENDT*SYC**2*SYT**2*NUM**2+2.D0*PENDT*
     &SYC**2*NUM**3*SYT**2-8.D0*PENDT*SYC**2*NUM**4*SYT**2-8.D0*PENDT*
     &SYC**2*NUM**5*SYT**2+4.D0*PENDT*NUM**6*SYC**2*SYT**2+4.D0*PENDT*
     &NUM**7*SYC**2*SYT**2-18.D0*EM*H*SYC**4*NUM**3-13.D0*EM*H*SYC**4* 
     &NUM**4-2.D0*EM*H*SYT**4*NUM**4+26.D0*EM*H*SYC**4*NUM**5-6.D0*EM*H*
     &SYT**4*NUM**5+17.D0*EM*H*NUM**6*SYC**4-EM*H*NUM**6*SYT**4-16.D0*
     &EM*H*NUM**7*SYC**4+2.D0*EM*H*NUM**7*SYT**4+EM*H*SYT**4*NUM**2+
     &2.D0*EM*H*SYT**4*NUM**3)
      GC=1.D0-(1.D0-GT)*(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*
     &NUM**2)/(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2)
          ELSEIF (ICOMPR .EQ. 2) THEN
C            GT1=1.D0/2.D0*(PENDT-4.D0*EM*H*NUM**3*GC+EM*H+2.D0*PENDT*
C    &NUM-3.D0*PENDT*
C    &NUM**2+2.D0*EM*H*NUM-EM*H*NUM**2+4.D0*PENDT*NUM**4-2.D0*PENDT*
C    &NUM**2*GC+4.D0*PENDT*NUM**4*GC-6.D0*EM*H*NUM**3+2.D0*PENDT*NUM**3*
C    &GC+sqrt(EM**2*H**2+PENDT**2-8.D0*PENDT*EM*H*NUM**3*GC+4.D0*PENDT*
C    &EM*H*NUM**2*GC**2-24.D0*EM*H*NUM**5*GC**2*PENDT-28.D0*EM*H*NUM**6*
C    &GC**2*PENDT-8.D0*EM*H*NUM**7*GC**2*PENDT-24.D0*EM*H*NUM**4*GC*
C    &PENDT+8.D0*EM*H*NUM**5*GC*PENDT+40.D0*EM*H*NUM**6*GC*PENDT+16.D0*
C    &EM*H*NUM**7*GC*PENDT-24.D0*EM**2*H**2*NUM**6*GC+16.D0*PENDT*EM*H*
C    &NUM**3+4.D0*PENDT**2*NUM+6.D0*PENDT**2*NUM**2-4.D0*PENDT**2*NUM**3
C    &-23.D0*PENDT**2*NUM**4-4.D0*PENDT**2*NUM**2*GC-4.D0*PENDT**2*
C    &NUM**4*GC**2+24.D0*EM**2*H**2*NUM**5*GC**2-4.D0*PENDT**2*NUM**3*
C    &GC+16.D0*EM**2*H**2*NUM**6*GC**2+20.D0*PENDT**2*NUM**4*GC-16.D0*
C    &PENDT**2*NUM**5-16.D0*PENDT**2*NUM**6*GC+12.D0*PENDT**2*NUM**6*
C    &GC**2+8.D0*EM**2*H**2*NUM**5-16.D0*PENDT**2*NUM**7*GC+20.D0*
C    &PENDT**2*NUM**5*GC-12.D0*EM**2*H**2*NUM**3+4.D0*EM**2*H**2*
C    &NUM**2*GC+12.D0*EM**2*H**2*NUM**3*GC-4.D0*EM**2*H**2*NUM**2*
C    &GC**2-8.D0*EM*H*PENDT*NUM-8.D0*EM*H*PENDT*NUM**2+38.D0*EM*H*PENDT*
C    &NUM**4+8.D0*PENDT**2*NUM**6+8.D0*PENDT*NUM**3*EM*H*GC**2+8.D0*
C    &PENDT*NUM**5*EM*H+4.D0*EM**2*H**2*NUM**4*GC-8.D0*EM**2*H**2*NUM**3
C    &*GC**2-2.D0*EM*H*PENDT+12.D0*EM**2*H**2*NUM**6+8.D0*PENDT**2*
C    &NUM**7*GC**2+8.D0*PENDT**2*NUM**7-28.D0*EM**2*H**2*NUM**5*GC+4.D0*
C    &EM**2*H**2*NUM**4*GC**2-20.D0*EM*H*NUM**6*PENDT-8.D0*PENDT*NUM**7*
C    &EM*H-15.D0*EM**2*H**2*NUM**4+4.D0*EM**2*H**2*NUM+2.D0*EM**2*H**2*
C    &NUM**2))/(-6.D0*EM*H*NUM**3+2.D0*EM*H*NUM-EM*H*NUM**2-2.D0*PENDT*
C    &NUM**2+2.D0*PENDT*NUM**3+4.D0*PENDT*NUM**4+EM*H)
      GT=-2.D0*EM*H*PENDT+4.D0*PENDT**2*NUM+6.D0*PENDT**2*NUM**2
     &-4.D0*PENDT**2*NUM**3-23.D0*PENDT**2*NUM**4-16.D0*PENDT**2*NUM**5+
     &8.D0*PENDT**2*NUM**6+8.D0*
     &PENDT**2*NUM**7+PENDT**2-12.D0*EM**2*H**2*NUM**3-4.D0*PENDT**2*
     &NUM**3*GC+20.D0*PENDT**2*NUM**4*GC+20.D0*PENDT**2*NUM**5*GC+12.D0*
     &PENDT**2*NUM**6*GC**2+8.D0*PENDT**2*NUM**7*GC**2-16.D0*PENDT**2*
     &NUM**6*GC-16.D0*PENDT**2*NUM**7*GC-4.D0*PENDT**2*NUM**4*GC**2-
     &4.D0*PENDT**2*NUM**2*GC-15.D0*EM**2*H**2*NUM**4+8.D0*EM**2*H**2*
     &NUM**5+12.D0*EM**2*H**2*NUM**6+4.D0*EM**2*H**2*NUM**2*GC
      GT=GT+12.D0*
     &EM**2*H**2*NUM**3*GC-4.D0*EM**2*H**2*NUM**2*GC**2-8.D0*EM*H*PENDT
     &*NUM-8.D0*EM*H*PENDT*NUM**2+16.D0*EM*H*PENDT*NUM**3+38.D0*EM*H*
     &PENDT*NUM**4+24.D0*EM**2*H**2*NUM**5*GC**2+16.D0*EM**2*H**2*
     &NUM**6*GC**2-24.D0*EM**2*H**2*NUM**6*GC-8.D0*PENDT*NUM**7*EM*H+
     &8.D0*PENDT*NUM**5*EM*H+4.D0*EM**2*H**2*NUM**4*GC-8.D0*EM**2*H**2*
     &NUM**3*GC**2-28.D0*EM**2*H**2*NUM**5*GC+4.D0*EM**2*H**2*NUM**4*
     &GC**2-20.D0*EM*H*NUM**6*PENDT-8.D0*EM*H*PENDT*NUM**3*GC+4.D0*EM*H*
     &PENDT*NUM**2*GC**2-24.D0*EM*H*PENDT*NUM**4*GC+8.D0*PENDT*NUM**3*
     &EM*H*GC**2-28.D0*PENDT*NUM**6*GC**2*EM*H-8.D0*PENDT*NUM**7*GC**2*
     &EM*H+16.D0*PENDT*NUM**7*GC*EM*H-24.D0*EM*H*NUM**5*GC**2*PENDT+
     &8.D0*EM*H*NUM**5*GC*PENDT+40.D0*EM*H*NUM**6*GC*PENDT+4.D0*EM**2*
     &H**2*NUM+EM**2*H**2+2.D0*EM**2*H**2*NUM**2
      GT=0.5D0*(EM*H+2.D0*PENDT*NUM+4.D0*PENDT*NUM**4*GC-4.D0*EM*H*
     &NUM**3*GC+4.D0*PENDT*NUM**4-3.D0*PENDT*NUM**2-2.D0*PENDT*NUM**2*GC
     &+2.D0*EM*H*NUM-EM*H*NUM**2-6.D0*EM*H*NUM**3+2.D0*PENDT*NUM**3*GC+
     &PENDT-SQRT(GT))
      GT=GT/(-6.D0*EM*H*NUM**3-EM*H*NUM**2
     &-2.D0*PENDT*NUM**2+2.D0*PENDT*NUM**3+4.D0*PENDT*NUM**4+EM*H+2.D0*
     &EM*H*NUM)

C            IF ((GT1 .LT. 1.D0) .AND. (GT1 .GT. 0.D0) .AND.
C     &(GT2 .LT. 1.D0) .AND. (GT2 .GT. 0.D0))THEN
C              GT=MIN(GT1,GT2)
C            ELSE IF ((GT1 .LT. 1.D0) .AND. (GT1 .GT. 0.D0)) THEN
C              GT=GT1
C            ELSE
C              GT=GT2
C            ENDIF

                    SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC
     &*NUM**2+1.D0)*(NUM**2-1.D0-NUM+GT+GT*NUM-2.D0*GT*NUM**2+GC*
     &NUM**2))
     &*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2+1.D0)
          ENDIF
C METHODE 2
        ELSEIF (IENDO .EQ. 2) THEN
          IF (ICOMPR .EQ. 1) THEN
            ALPHA=(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*NUM**2)/
     &(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2) 
            BETA=EM*H/(1.D0+NUM)/NUM
            C1=(BETA*NUM-2.D0*BETA*ALPHA+4.D0*BETA*ALPHA*NUM-PENDT*
     &ALPHA)/(ALPHA*BETA)
            C2=(4.D0*BETA*NUM**2+BETA*ALPHA-BETA*NUM-PENDT*NUM*ALPHA+
     &PENDT*ALPHA-2.D0*PENDT*NUM-5.D0*BETA*ALPHA*NUM+5.D0*BETA*ALPHA
     &*NUM**2)/(BETA*ALPHA)
            C3=(4.D0*BETA*NUM**3-3.D0*BETA*ALPHA*NUM**2+2.D0*BETA*ALPHA*
     &NUM**3
     &+BETA*ALPHA*NUM-2.D0*PENDT*NUM**2+PENDT*NUM-2.D0*BETA*NUM**2)/
     &(ALPHA*BETA)
            CALL ZEROP3(C1,C2,C3,X,NS)
            DO 10 II=1,NS
              GT3(II)=(X(II)+2.D0*NUM-1.D0)/NUM
                IF ((GT3(II) .GT. 0.D0) .AND. (GT3(II) .LT. 1.D0)) THEN
                  GT=GT3(II)
                ENDIF
 10         CONTINUE
            GC=1.D0-(1.D0-GT)*ALPHA
          ELSEIF (ICOMPR .EQ. 2) THEN
      GT=1.D0/2.D0*(NUM**2*PENDT*GC+NUM**2*PENDT+PENDT*GC*NUM+PENDT*NUM-
     &EM*H*NUM-EM*H*GC+EM*H*GC*NUM+SQRT(2.D0*NUM**4*PENDT**2*GC+NUM**4*
     &PENDT**2+2.D0*NUM**3*PENDT**2+PENDT**2*NUM**2-2.D0*NUM**3*PENDT*EM
     &*H-2.D0*PENDT*NUM**2*EM*H+EM**2*H**2*NUM**2+2.D0*NUM**2*PENDT**2*
     &GC+2.D0*NUM**3*PENDT**2*GC**2-2.D0*EM**2*H**2*GC**2*NUM+EM**2*
     &H**2*GC**2*NUM**2+EM**2*H**2*GC**2+2.D0*EM*H*GC**2*PENDT*NUM-6.D0
     &*EM*H*GC**2*NUM**3*PENDT-2.D0*EM*H*NUM**2*PENDT*GC-2.D0*EM*H*NUM*
     &PENDT*GC+2.D0*EM**2*H**2*NUM*GC-2.D0*EM**2*H**2*NUM**2*GC+NUM**4
     &*PENDT**2*GC**2+NUM**2*PENDT**2*GC**2+4.D0*NUM**3*PENDT**2*GC-
     &4.D0*EM*H*GC**2*NUM**2*PENDT))/(EM*H*GC*NUM)
                    SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC
     &*NUM**2+1.D0)*(NUM**2-1.D0-NUM+GT+GT*NUM-2.D0*GT*NUM**2+GC*
     &NUM**2))*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2+1.D0)
          ENDIF
C  METHODE 3
        ELSE
          GT=PENDT/PELAST
          IF (ICOMPR .EQ. 1) THEN
            GC=1.D0-(1.D0-GT)*(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*
     &NUM**2)/(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2)
          ELSEIF (ICOMPR .EQ. 2) THEN
               SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*
     &GC*NUM**2+1.D0)*(NUM**2-1.D0-NUM+GT+GT*NUM-2.D0*GT*NUM**2+GC*
     &NUM**2))*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2
     &+1.D0)
          ENDIF
        ENDIF


C - PARAMETRES D'ENDOMMAGEMENT MENBRANAIRE EN CISAILLEMENT
C   PUR DANS LE PLAN
      IF (ICISAI .EQ. 1) THEN
C - On calule SYTXY a partir de GT et GC calcul� en traction
        SYTXY=SYT/(1.D0+NUM)*SQRT(((1.D0-NUM)*(1.D0+2.D0*NUM)*
     &(1.D0-GT)+NUM**2*(1.D0-GC))/(2.D0-GC-GT))
        SYT=SYTXY
C - PENTE='PENTE_LIM'
        IF (IPENTE .EQ. 1) THEN
          PENDC=PENDT
C - PENTE ='EPSI_MAX' OU PENTE = 'PLAS'
        ELSEIF ((IPENTE .EQ. 3) .OR. (IPENTE .EQ. 2)) THEN
          DXD=SYTXY/PELAST
          PENDC=(NP-SYTXY)/(DXP-DXD)
        ENDIF
C - METHODE 1
        IF (IENDO .EQ. 1) THEN
          IF (ICOMPR .EQ. 1) THEN
          GT=-(EM*H*SYC**2+EM*H*SYC**2*NUM-3.D0*EM*H*SYC**2*NUM**2-3.D0*
     &EM*H*SYT**2*NUM**2+EM*H*SYT**2+EM*H*SYT**2*NUM-2.D0*PENDC*SYC**2-
     &4.D0*PENDC*SYC**2*NUM+2.D0*PENDC*SYC**2*NUM**2+4.D0*PENDC*SYC**2*
     &NUM**3+2.D0*PENDC*SYT**2*NUM**2+2.D0*PENDC*SYT**2*NUM**3)/(EM*H*
     &(SYC**2+SYC**2*NUM-SYC**2*NUM**2+SYT**2*NUM**2-SYT**2-SYT**2*NUM))
          GC=1.D0-(1.D0-GT)*(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*
     &NUM**2)/(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2)
          ELSEIF (ICOMPR .EQ. 2) THEN
          GT=(-2.D0*EM*H+EM*H*GC+2.D0*PENDC+2.D0*PENDC*NUM)/(EM*H)
          SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*
     &NUM**2+1.D0)*(GC*NUM**2-NUM+GT+NUM**2-1.D0+GT*NUM-2.D0*GT*NUM**2))
     &*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2+1.D0)
          ENDIF
C - METHODE 2
        ELSEIF (IENDO .EQ. 2) THEN
          IF (ICOMPR .EQ. 1) THEN
            GT=(EM*H*SYC**2+EM*H*SYC**2*NUM-EM*H*SYC**2*NUM**2+EM*H*
     &SYT**2*NUM**2-EM*H*SYT**2-EM*H*SYT**2*NUM-2.D0*PENDC*SYC**2-4.D0*
     &PENDC*SYC**2*NUM+2.D0*PENDC*SYC**2*NUM**2+4.D0*PENDC*SYC**2*NUM**3
     &+2.D0*PENDC*SYT**2*NUM**2+2.D0*PENDC*SYT**2*NUM**3)/(EM*H*
     &(-SYC**2-SYC**2*NUM+3.D0*SYC**2*NUM**2+3.D0*SYT**2*NUM**2-SYT**2-
     &SYT**2*NUM))
            GC=1.D0-(1.D0-GT)*(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*
     &NUM**2)/(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2)
          ELSEIF (ICOMPR .EQ. 2) THEN
            GT=-(EM*H*GC-2.D0*PENDC-2.D0*PENDC*NUM)/(EM*H)
            SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*
     &NUM**2+1.D0)*(GC*NUM**2-NUM+GT+NUM**2-1.D0+GT*NUM-2.D0*GT*NUM**2))
     &*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2+1.D0)
          ENDIF
C - METHODE 3
        ELSE
          GT=PENDC/((EM*H)/2.D0/(1.D0+NUM))
          IF (ICOMPR .EQ. 1) THEN
            GC=1.D0-(1.D0-GT)*(SYT**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYC**2*
     &NUM**2)/(SYC**2*(1.D0-NUM)*(1.D0+2.D0*NUM)-SYT**2*NUM**2)
          ELSEIF (ICOMPR .EQ. 2) THEN
            SYC=SQRT(-(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*
     &GC*NUM**2+1.D0)*(NUM**2-1.D0-NUM+GT+GT*NUM-2.D0*GT*NUM**2+GC*
     &NUM**2))*SYT/(NUM-NUM**2-GT*NUM**2-GC-GC*NUM+2.D0*GC*NUM**2
     &+1.D0)
          ENDIF
        ENDIF
      ENDIF


C - CALCUL DES PARAMETRES D'ENDOMMAGEMENT EN FLEXION
      IF (IENDO .EQ. 1) THEN
        XF=12.D0*PENDF/EF/H**3
        GF=(XF*(1.D0+NUF)*(1.D0+NUF-2.D0*NUF**2+NUF**3)-NUF**3)/(1.D0+
     &2.D0*NUF-2.D0*NUF**3-XF*NUF**2*(1.D0-NUF**2))
      ELSEIF (IENDO .EQ. 2) THEN
        GF1=1.D0/2.D0*(12.D0*PENDF*NUF**2+12.D0*PENDF*NUF-EF*H**3+SQRT
     &(144.D0*PENDF**2*NUF**4+288.D0*PENDF**2*NUF**3-24.D0*EF*H**3*PENDF
     &*NUF**2+144.D0*PENDF**2*NUF**2+24.D0*PENDF*NUF*EF*H**3+EF**2*
     &H**6-48.D0*EF*H**3*NUF**3*PENDF))/(EF*H**3*NUF)
        GF2=1.D0/2.D0*(12.D0*PENDF*NUF**2+12.D0*PENDF*NUF-EF*H**3-
     &SQRT(144.D0*PENDF**2*NUF**4+288.D0*PENDF**2*NUF**3-24.D0*EF*H**3*
     &PENDF*NUF**2+144.D0*PENDF**2*NUF**2+24.D0*PENDF*NUF*EF*H**3+
     &EF**2*H**6-48.D0*EF*H**3*NUF**3*PENDF))/(EF*H**3*NUF)
        GF=MAX(GF1,GF2)
       ELSE
        GF=PENDF/PELASF
      ENDIF

      IF (GT .LT. 0.D0) THEN
        CALL U2MESK('A','ALGORITH6_4',1,'GAMMAT')
      ENDIF
      IF (GC .LT. 0.D0) THEN
        CALL U2MESK('A','ALGORITH6_4',1,'GAMMAC')
      ENDIF
      IF (GF .LT. 0.D0) THEN
        CALL U2MESK('A','ALGORITH6_4',1,'GAMMAF')
      ENDIF

      END
