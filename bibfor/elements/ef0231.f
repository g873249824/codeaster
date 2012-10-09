      SUBROUTINE EF0231(NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/10/2012   AUTEUR PELLET J.PELLET 
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
C     CALCUL DE EFGE_ELNO
C     ------------------------------------------------------------------

      CHARACTER*8 NOMRES(3),ELREFE
      INTEGER ICODRE(3)
      REAL*8 E,NU,TPG,TGMOY,TGSUP,TGINF,TREF
      REAL*8 X3,EPS(5),C,H,EPSTHE,VALRES(3)
      REAL*8 E11,E22,K11,K22,EP11,EP22
      REAL*8 DFDX(3),EFFOPG(24)
      REAL*8 JAC,R,COSA,SINA,COUR
      INTEGER I,K,KP,IGEOM,IMATE,ICACO,IDEPL
      INTEGER NNO,NPG,IDFDK,IVF,IRET,IRET2,IRET1,IRET3,IRET4
      INTEGER JCOOPG,IP,CORREC,JDFD2

C-----------------------------------------------------------------------
      INTEGER IEFFOR,IPOIDS,JGANO,NDIM,NNOS
      REAL*8 R8NNEM
C-----------------------------------------------------------------------
      CALL ELREF1(ELREFE)


      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,JCOOPG,IVF,IDFDK,
     &            JDFD2,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCACOQU','L',ICACO)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PEFFORR','E',IEFFOR)
      CALL RCVARC(' ','TEMP','REF','RIGI',1,1,TREF,IRET)

      H=ZR(ICACO)
CJMP  CORREC = CORRECTION DE METRIQUE = 0 (NON) OU 1 (OUI)
CJMP  CORREC = ZR(ICACO+2)
      CORREC=NINT(ZR(ICACO+2))

      DO 10 I=1,NPG*6
        EFFOPG(I)=0.D0
   10 CONTINUE


      DO 50 KP=1,NPG
        K=(KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     &              JAC,COSA,SINA)

        DO 20 I=1,5
          EPS(I)=0.D0
   20   CONTINUE
        R=0.D0
        DO 30 I=1,NNO
          EPS(1)=EPS(1)+DFDX(I)*ZR(IDEPL+3*I-3)
          EPS(2)=EPS(2)+DFDX(I)*ZR(IDEPL+3*I-2)
          EPS(3)=EPS(3)+DFDX(I)*ZR(IDEPL+3*I-1)
          EPS(4)=EPS(4)+ZR(IVF+K+I-1)*ZR(IDEPL+3*I-3)
          EPS(5)=EPS(5)+ZR(IVF+K+I-1)*ZR(IDEPL+3*I-1)
          R=R+ZR(IVF+K+I-1)*ZR(IGEOM+2*I-2)
   30   CONTINUE

        E11=EPS(2)*COSA-EPS(1)*SINA
        K11=EPS(3)
        IF (NOMTE.EQ.'MECXSE3') THEN
          E22=EPS(4)/R
          K22=-EPS(5)*SINA/R
        ELSE
          E22=0.D0
          K22=0.D0
        ENDIF

        CALL RCVARC(' ','TEMP','+','RIGI',KP,1,TGINF,IRET1)
        CALL RCVARC(' ','TEMP','+','RIGI',KP,2,TGMOY,IRET2)
        CALL RCVARC(' ','TEMP','+','RIGI',KP,3,TGSUP,IRET3)
        IRET4=IRET1+IRET2+IRET3
        CALL ASSERT(IRET4.EQ.0 .OR. IRET4.EQ.3)


C---- UTILISATION DE 4 POINTS DE GAUSS DANS L'EPAISSEUR
C---- COMME POUR LA LONGUEUR

        DO 40 IP=1,NPG
          X3=ZR(JCOOPG-1+IP)
          IF (IRET4.EQ.0) THEN
            TPG=TGMOY*(1.D0-(X3)**2)+TGSUP*X3*(1.D0+X3)/2.D0-
     &          TGINF*X3*(1.D0-X3)/2.D0
          ELSE
            TPG=R8NNEM()
          ENDIF
          X3=X3*H/2.D0
          EP11=(E11+X3*K11)/(1.D0+(CORREC*X3*COUR))
          NOMRES(1)='E'
          NOMRES(2)='NU'
          NOMRES(3)='ALPHA'
          CALL RCVALB('RIGI',1,1,'+',ZI(IMATE),' ','ELAS',1,'TEMP',TPG,
     &                2,NOMRES,VALRES,ICODRE,1)
          CALL RCVALB('RIGI',1,1,'+',ZI(IMATE),' ','ELAS',1,'TEMP',TPG,
     &                1,NOMRES(3),VALRES(3),ICODRE(3),0)
          E=VALRES(1)
          NU=VALRES(2)
          IF (IRET4.EQ.0) THEN
            IF ((ICODRE(3).NE.0) .OR. (IRET.EQ.1)) THEN
              CALL U2MESS('F','CALCULEL_15')
            ELSE
              EPSTHE=(TPG-TREF)*VALRES(3)*E/(1.D0-NU)
            ENDIF
          ELSE
            EPSTHE=0.D0
          ENDIF

          C=E/(1.D0-NU*NU)
          IF (NOMTE(3:4).EQ.'CX') THEN
            EP22=(E22+X3*K22)/(1.D0+(CORREC*COSA*X3/R))
            EFFOPG(6*(KP-1)+1)=EFFOPG(6*(KP-1)+1)+
     &                         ZR(IPOIDS-1+IP)*(H/2.D0)*
     &                         (C*(EP11+NU*EP22)-EPSTHE)
            EFFOPG(6*(KP-1)+2)=EFFOPG(6*(KP-1)+2)+
     &                         ZR(IPOIDS-1+IP)*(H/2.D0)*
     &                         (C*(NU*EP11+EP22)-EPSTHE)
            EFFOPG(6*(KP-1)+4)=EFFOPG(6*(KP-1)+4)+
     &                         ZR(IPOIDS-1+IP)*X3*(H/2.D0)*
     &                         (C*(EP11+NU*EP22)-EPSTHE)
            EFFOPG(6*(KP-1)+5)=EFFOPG(6*(KP-1)+5)+
     &                         ZR(IPOIDS-1+IP)*X3*(H/2.D0)*
     &                         (C*(NU*EP11+EP22)-EPSTHE)
          ELSEIF (NOMTE.EQ.'METCSE3 ') THEN
            EFFOPG(6*(KP-1)+1)=EFFOPG(6*(KP-1)+1)+
     &                         ZR(IPOIDS-1+IP)*(H/2.D0)*
     &                         (E*(EP11-EPSTHE))
            EFFOPG(6*(KP-1)+4)=EFFOPG(6*(KP-1)+4)+
     &                         ZR(IPOIDS-1+IP)*X3*(H/2.D0)*
     &                         (E*(EP11-EPSTHE))
            EFFOPG(6*(KP-1)+2)=0.D0
            EFFOPG(6*(KP-1)+5)=0.D0
          ELSE
            EFFOPG(6*(KP-1)+1)=EFFOPG(6*(KP-1)+1)+
     &                         ZR(IPOIDS-1+IP)*(H/2.D0)*(C*EP11-EPSTHE)
            EFFOPG(6*(KP-1)+2)=EFFOPG(6*(KP-1)+2)+
     &                         ZR(IPOIDS-1+IP)*(H/2.D0)*
     &                         (C*NU*EP11-EPSTHE)
            EFFOPG(6*(KP-1)+4)=EFFOPG(6*(KP-1)+4)+
     &                         ZR(IPOIDS-1+IP)*X3*(H/2.D0)*
     &                         (C*EP11-EPSTHE)
            EFFOPG(6*(KP-1)+5)=EFFOPG(6*(KP-1)+5)+
     &                         ZR(IPOIDS-1+IP)*X3*(H/2.D0)*
     &                         (C*NU*EP11-EPSTHE)
          ENDIF

   40   CONTINUE
        EFFOPG(6*(KP-1)+3)=0.D0
        EFFOPG(6*(KP-1)+6)=0.D0

   50 CONTINUE

      CALL PPGAN2(JGANO,1,6,EFFOPG,ZR(IEFFOR))
      END
