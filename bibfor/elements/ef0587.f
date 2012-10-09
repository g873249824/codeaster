      SUBROUTINE EF0587(NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE
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

      INTEGER NBCOUM,NBSECM,JNBSPI
      REAL*8 H,A
      PARAMETER(NBSECM=32,NBCOUM=10)
      REAL*8 POICOU(2*NBCOUM+1),POISEC(2*NBSECM+1)
      REAL*8 PI,DEUXPI,SIG(6),FNO(4,6)
      REAL*8 EFG(6),ALPHAF,BETAF,ALPHAM,BETAM,XA,XB,XC,XD
      REAL*8 PGL(3,3),PGL4(3,3),VNO(4),VPG(4)
      REAL*8 COSFI,SINFI,HK(4,4)
      REAL*8 FI,POIDS,R,R8PI,OMEGA
      REAL*8 PGL1(3,3),PGL2(3,3),PGL3(3,3),RAYON,THETA,L
      REAL*8 CP(2,2),CV(2,2),CO(4,4),SI(4,4),TK(4),XPG(4)
      REAL*8 VEQG(16)
      INTEGER NNO,NNOS,JGANO,NDIM,NPG,NBCOU,NBSEC,LORIEN
      INTEGER IPOIDS,IVF,ICOUDE,IC,KP,JIN,JCOOPG,JDFD2
      INTEGER ICAGEP,I1,I2,IH,IDFDK
      INTEGER IGAU,ICOU,ISECT,I,JOUT,INO
      INTEGER INDICE,K,IP,ICOUD2,MMT
      INTEGER KPGS

      INTEGER VALI

      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,JCOOPG,IVF,IDFDK,
     &            JDFD2,JGANO)


      PI=R8PI()
      DEUXPI=2.D0*PI

C=====RECUPERATION NOMBRE DE COUCHES ET DE SECTEURS ANGULAIRES

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU=ZI(JNBSPI-1+1)
      NBSEC=ZI(JNBSPI-1+2)
      IF (NBCOU*NBSEC.LE.0) THEN
        CALL U2MESS('F','ELEMENTS4_46')
      ENDIF
      IF (NBCOU.GT.NBCOUM) THEN
        VALI=NBCOUM
        CALL U2MESG('F','ELEMENTS5_2',0,' ',1,VALI,0,0.D0)
      ENDIF
      IF (NBSEC.GT.NBSECM) THEN
        VALI=NBSECM
        CALL U2MESG('F','ELEMENTS5_3',0,' ',1,VALI,0,0.D0)
      ENDIF



C     PREMIERE FAMILLE DE POINTS DE GAUSS POUR LES CHAMPS


      DO 10 I=1,NPG
        XPG(I)=ZR(JCOOPG-1+I)
   10 CONTINUE

C  LES POIDS POUR L'INTEGRATION DANS L'EPAISSEUR

      POICOU(1)=1.D0/3.D0
      DO 20 I=1,NBCOU-1
        POICOU(2*I)=4.D0/3.D0
        POICOU(2*I+1)=2.D0/3.D0
   20 CONTINUE
      POICOU(2*NBCOU)=4.D0/3.D0
      POICOU(2*NBCOU+1)=1.D0/3.D0

C  LES POIDS POUR L'INTEGRATION SUR LA CIRCONFERENCE

      POISEC(1)=1.D0/3.D0
      DO 30 I=1,NBSEC-1
        POISEC(2*I)=4.D0/3.D0
        POISEC(2*I+1)=2.D0/3.D0
   30 CONTINUE
      POISEC(2*NBSEC)=4.D0/3.D0
      POISEC(2*NBSEC+1)=1.D0/3.D0

C   FIN DES POIDS D'INTEGRATION


C  CONTRUCTION DE LA MATRICE H(I,J) = MATRICE DES VALEURS DES
C  FONCTIONS DE FORMES AUX POINT DE GAUSS

      DO 50,K=1,NNO
        DO 40,IGAU=1,NPG
          HK(K,IGAU)=ZR(IVF-1+NNO*(IGAU-1)+K)
   40   CONTINUE
   50 CONTINUE



      CALL JEVECH('PCAGEPO','L',ICAGEP)
      CALL JEVECH('PCAORIE','L',LORIEN)
      CALL JEVECH('PCONTRR','L',JIN)
      CALL JEVECH('PEFFORR','E',JOUT)

C       -- A= RMOY, H = EPAISSEUR
      H=ZR(ICAGEP+1)
      A=ZR(ICAGEP)-H/2.D0

C       -- ORIENTATION :
      CALL CARCOU(ZR(LORIEN),L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,NNO,
     &            OMEGA,ICOUD2)
      IF (ICOUD2.GE.10) THEN
        ICOUDE=ICOUD2-10
        MMT=0
      ELSE
        ICOUDE=ICOUD2
        MMT=1
      ENDIF

      IF (NNO.EQ.3) THEN
        TK(1)=0.D0
        TK(2)=THETA
        TK(3)=THETA/2.D0
      ELSEIF (NNO.EQ.4) THEN
        TK(1)=0.D0
        TK(2)=THETA
        TK(3)=THETA/3.D0
        TK(4)=2.D0*THETA/3.D0
      ENDIF


      KPGS=0
C       -- CALCUL DES EFFORTS SUR LES POINTS DE GAUSS (VFNO)
      DO 100 IGAU=1,NPG

        DO 60,I=1,6
          EFG(I)=0.D0
   60   CONTINUE

C         -- BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR
        DO 80 ICOU=1,2*NBCOU+1
          IF (MMT.EQ.0) THEN
            R=A
          ELSE
            R=A+(ICOU-1)*H/(2.D0*NBCOU)-H/2.D0
          ENDIF

C           -- BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE
          DO 70 ISECT=1,2*NBSEC+1

            KPGS=KPGS+1
            FI=(ISECT-1)*DEUXPI/(2.D0*NBSEC)
            COSFI=COS(FI)
            SINFI=SIN(FI)

            INDICE=JIN-1+6*(KPGS-1)
            SIG(1)=ZR(INDICE+1)
            SIG(2)=ZR(INDICE+2)
            SIG(3)=ZR(INDICE+4)
            SIG(4)=ZR(INDICE+5)

            POIDS=POICOU(ICOU)*POISEC(ISECT)*H*DEUXPI/
     &            (4.D0*NBCOU*NBSEC)*R


            EFG(1)=EFG(1)+POIDS*SIG(1)
            EFG(2)=EFG(2)-POIDS*(SINFI*SIG(4)+COSFI*SIG(3))
            EFG(3)=EFG(3)+POIDS*(SINFI*SIG(3)-COSFI*SIG(4))

            EFG(4)=EFG(4)-POIDS*SIG(3)*R
            EFG(5)=EFG(5)-POIDS*SIG(1)*R*COSFI
            EFG(6)=EFG(6)+POIDS*SIG(1)*R*SINFI
   70     CONTINUE
   80   CONTINUE

        DO 90,I=1,6
          FNO(IGAU,I)=EFG(I)
   90   CONTINUE
  100 CONTINUE


      IF ((NNO.EQ.3) .AND. (NPG.EQ.3)) THEN
C         -- LA BELLE PROGRAMMATION DE PATRICK
C            EST-ELLE MIEUX QUE PPGAN2 ?
        DO 120 IGAU=1,NPG
          DO 110 INO=1,NNO
            IF (ICOUDE.EQ.0) THEN
              CO(IGAU,INO)=1.D0
              SI(IGAU,INO)=0.D0
            ELSE
              CO(IGAU,INO)=COS((1.D0+XPG(IGAU))*THETA/2.D0-TK(INO))
              SI(IGAU,INO)=SIN((1.D0+XPG(IGAU))*THETA/2.D0-TK(INO))
            ENDIF
  110     CONTINUE
  120   CONTINUE
        DO 160,INO=1,NNO
          IF (INO.EQ.1) THEN
            IH=2
            IP=1
            I1=1
            I2=3
          ELSEIF (INO.EQ.2) THEN
            IH=1
            IP=2
            I1=3
            I2=1
          ELSE
            DO 130,I=1,6
              EFG(I)=FNO(2,I)
  130       CONTINUE
            GOTO 140

          ENDIF

          CP(1,1)=CO(1,IH)*CO(1,3)+SI(1,IH)*SI(1,3)
          CP(1,2)=-CO(1,IH)*SI(1,3)+SI(1,IH)*CO(1,3)
          CP(2,1)=-CP(1,2)
          CP(2,2)=CP(1,1)
          CV(1,1)=CO(3,IH)*CO(3,3)+SI(3,IH)*SI(3,3)
          CV(1,2)=-CO(3,IH)*SI(3,3)+SI(3,IH)*CO(3,3)
          CV(2,1)=-CP(1,2)
          CV(2,2)=CP(1,1)

          ALPHAF=HK(IH,3)*(CO(1,IH)*FNO(1,1)+SI(1,IH)*FNO(1,2))-
     &           HK(IH,3)*HK(3,1)*(CP(1,1)*FNO(2,1)+CP(1,2)*FNO(2,2))-
     &           HK(IH,1)*(CO(3,IH)*FNO(3,1)+SI(3,IH)*FNO(3,2))+
     &           HK(IH,1)*HK(3,3)*(CV(1,1)*FNO(2,1)+CV(1,2)*FNO(2,2))

          BETAF=HK(IH,3)*(-SI(1,IH)*FNO(1,1)+CO(1,IH)*FNO(1,2))-
     &          HK(IH,3)*HK(3,1)*(CP(2,1)*FNO(2,1)+CP(2,2)*FNO(2,2))-
     &          HK(IH,1)*(-SI(3,IH)*FNO(3,1)+CO(3,IH)*FNO(3,2))+
     &          HK(IH,1)*HK(3,3)*(CV(2,1)*FNO(2,1)+CV(2,2)*FNO(2,2))

          ALPHAM=HK(IH,3)*(CO(1,IH)*FNO(1,4)+SI(1,IH)*FNO(1,5))-
     &           HK(IH,3)*HK(3,1)*(CP(1,1)*FNO(2,4)+CP(1,2)*FNO(2,5))-
     &           HK(IH,1)*(CO(3,IH)*FNO(3,4)+SI(3,IH)*FNO(3,5))+
     &           HK(IH,1)*HK(3,3)*(CV(1,1)*FNO(2,4)+CV(1,2)*FNO(2,5))

          BETAM=HK(IH,3)*(-SI(1,IH)*FNO(1,4)+CO(1,IH)*FNO(1,5))-
     &          HK(IH,3)*HK(3,1)*(CP(2,1)*FNO(2,4)+CP(2,2)*FNO(2,5))-
     &          HK(IH,1)*(-SI(3,IH)*FNO(3,4)+CO(3,IH)*FNO(3,5))+
     &          HK(IH,1)*HK(3,3)*(CV(2,1)*FNO(2,4)+CV(2,2)*FNO(2,5))

          CP(1,1)=CO(1,IH)*CO(1,IP)+SI(1,IH)*SI(1,IP)
          CP(1,2)=-CO(1,IH)*SI(1,IP)+SI(1,IH)*CO(1,IP)
          CP(2,1)=-CP(1,2)
          CP(2,2)=CP(1,1)
          CV(1,1)=CO(3,IH)*CO(3,IP)+SI(3,IH)*SI(3,IP)
          CV(1,2)=-CO(3,IH)*SI(3,IP)+SI(3,IH)*CO(3,IP)
          CV(2,1)=-CP(1,2)
          CV(2,2)=CP(1,1)

          XA=HK(IP,1)*HK(IH,3)*CP(1,1)-HK(IP,3)*HK(IH,1)*CV(1,1)
          XB=HK(IP,1)*HK(IH,3)*CP(1,2)-HK(IP,3)*HK(IH,1)*CV(1,2)
          XC=HK(IP,1)*HK(IH,3)*CP(2,1)-HK(IP,3)*HK(IH,1)*CV(2,1)
          XD=HK(IP,1)*HK(IH,3)*CP(2,2)-HK(IP,3)*HK(IH,1)*CV(2,2)

          EFG(1)=(XD*ALPHAF-XB*BETAF)/(XA*XD-XB*XC)
          EFG(2)=(-XC*ALPHAF+XA*BETAF)/(XA*XD-XB*XC)
          EFG(3)=(HK(IH,I2)*FNO(I1,3)-HK(IH,I1)*FNO(I2,3)-
     &           FNO(2,3)*(HK(3,I1)*HK(IH,I2)-HK(3,I2)*HK(IH,I1)))/
     &           (HK(1,1)*HK(2,3)-HK(1,3)*HK(2,1))
          EFG(4)=(XD*ALPHAM-XB*BETAM)/(XA*XD-XB*XC)
          EFG(5)=(-XC*ALPHAM+XA*BETAM)/(XA*XD-XB*XC)
          EFG(6)=(HK(IH,I2)*FNO(I1,6)-HK(IH,I1)*FNO(I2,6)-
     &           FNO(2,6)*(HK(3,I1)*HK(IH,I2)-HK(3,I2)*HK(IH,I1)))/
     &           (HK(1,1)*HK(2,3)-HK(1,3)*HK(2,1))

  140     CONTINUE

          DO 150,I=1,6
            ZR(JOUT-1+6*(INO-1)+I)=EFG(I)
  150     CONTINUE
  160   CONTINUE

      ELSE
C         -- UNE PROGRAMMATION STANDARD POUR MET3SEG4 :
        DO 190 IC=1,6
          DO 170 KP=1,NPG
            VPG(KP)=FNO(KP,IC)
  170     CONTINUE
          CALL PPGAN2(JGANO,1,1,VPG,VNO)
          DO 180 INO=1,NNO
            ZR(JOUT+6*(INO-1)+IC-1)=VNO(INO)
  180     CONTINUE
  190   CONTINUE
      ENDIF


      END
