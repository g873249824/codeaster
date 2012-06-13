      SUBROUTINE DGLRDA()
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRP_20
C ----------------------------------------------------------------------
C
C BUT : DETERMINATION DES PARAMETRES MATERIAU POUR LE MODELE GLRC_DAMAGE
C
C-----------------------------------------------------------------------

      INCLUDE 'jeveux.h'
      INTEGER  NA
      PARAMETER (NA=10)
      INTEGER NNAP,NPREC,NLINER,IBID,II,ILIT,NLIT,JLM,JMELK
      INTEGER JMELR,JMELC,LONOBJ,IFON0,LONGF,IFON1,LONUTI
      REAL*8  EB,NUB,FT,FC,GAMMA
      INTEGER NIMPR,IMPR,IFR,IBID1
      REAL*8  QP1,QP2,CN(2,3),CM(2,3),PREX,PREY,NMAX2,NMIN0
      REAL*8  EA(3*NA),OMX(3*NA),OMY(3*NA),SY(3*NA),NUA(3*NA)
      REAL*8  RX(3*NA),RY(3*NA),RLR(NA),LINER(3*NA),BN11,BN12,BN22,BN33
      REAL*8  HH,BM11,BM12,BM22,BM33,BC11,BC22,MF1X,MF1Y,NMAX1
      REAL*8  MF2X,MF2Y,RHO,AMORA,AMORB,EEQ,NUEQ,MF1,MF2,NMIN1,NMIN2
      REAL*8  NORMM,NORMN,VALRES(5),MP1N0,MP2N0,AUX,MAXMP(2),MINMP(2)
      REAL*8  NMAX0,NMIN(2),NMAX(2),OML(NA),R8B,PAR1,PAR2,ELB(2)
      REAL*8  MP1CST(2),MP2CST(2),OMT,EAT,BT1,BT2
      INTEGER ICODR2(5)
      CHARACTER*8 MATER,FON(4),K8B,NOMRES(5)
      CHARACTER*8 FSNCX,FSNCY,FSCXD,FSCYD,FSCXD2,FSCYD2
      CHARACTER*8 FINCX,FINCY,FICXD,FICYD,FICXD2,FICYD2
      CHARACTER*16 TYPE,NOMCMD,FICHIE
      LOGICAL ULEXIS
      INTEGER IARG, IMPF, ICST, ICIS

      CALL JEMARQ()

      CALL GETFAC('NAPPE'     ,NNAP  )
      CALL GETFAC('CABLE_PREC',NPREC )
      CALL GETFAC('LINER'     ,NLINER)

      NLIT = NNAP + NPREC + NLINER

      IF (NLIT .EQ. 0) THEN
        NLIT   = 1
        EA(1)  = 0.0D0
        NUA(1) = 0.0D0
        OMX(1) = 0.0D0
        OMY(1) = 0.0D0
        RX(1)  = 0.0D0
        RY(1)  = 0.0D0
      ENDIF


      NIMPR = 0

      CALL GETVIS(' ','INFO',1,IARG,1,IMPR,IBID1)

      IF (IMPR .EQ. 2) THEN
        NIMPR  = 1
        IFR    = 0
        FICHIE = ' '
        IF ( .NOT. ULEXIS( IMPR ) ) THEN
          CALL ULOPEN ( IMPR, ' ', FICHIE, 'NEW', 'O' )
        ENDIF
      END IF

      CALL GETVID('BETON','MATER',1,IARG,1,MATER,IBID)

      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'RHO'

      K8B = ' '
      CALL RCVALE(MATER,'ELAS            ',0,K8B,R8B,3,
     &            NOMRES,VALRES,ICODR2,1)

      EB  = VALRES(1)
      NUB = VALRES(2)
      RHO = VALRES(3)

      NOMRES(1) = 'AMOR_ALP'
      NOMRES(2) = 'AMOR_BET'

      CALL RCVALE(MATER,'ELAS            ',0,K8B,R8B,2,
     &            NOMRES,VALRES,ICODR2,0)

      IF(ICODR2(1) .NE. 0) THEN
        AMORA = 0.0D0
      ELSE
        AMORA = VALRES(1)
      ENDIF

      IF(ICODR2(2) .NE. 0) THEN
        AMORB = 0.0D0
      ELSE
        AMORB = VALRES(2)
      ENDIF

      NOMRES(1) = 'SYT'
      NOMRES(2) = 'SYC'
      CALL RCVALE(MATER,'BETON_ECRO_LINE ',0,K8B,R8B,2,
     &            NOMRES,VALRES,ICODR2,1)
      FT = VALRES(1)
      FC = VALRES(2)

      CALL GETVR8('BETON','EPAIS',1,IARG,1,HH,IBID)
      CALL GETVR8('BETON','GAMMA',1,IARG,1,GAMMA,IBID)
      CALL GETVR8('BETON','QP1',1,IARG,1,QP1,IBID)
      CALL GETVR8('BETON','QP2',1,IARG,1,QP2,IBID)
      CALL GETVR8('BETON','C1N1',1,IARG,1,CN(1,1),IBID)
      CALL GETVR8('BETON','C1N2',1,IARG,1,CN(1,2),IBID)
      CALL GETVR8('BETON','C1N3',1,IARG,1,CN(1,3),IBID)
      CALL GETVR8('BETON','C2N1',1,IARG,1,CN(2,1),IBID)
      CALL GETVR8('BETON','C2N2',1,IARG,1,CN(2,2),IBID)
      CALL GETVR8('BETON','C2N3',1,IARG,1,CN(2,3),IBID)
      CALL GETVR8('BETON','C1M1',1,IARG,1,CM(1,1),IBID)
      CALL GETVR8('BETON','C1M2',1,IARG,1,CM(1,2),IBID)
      CALL GETVR8('BETON','C1M3',1,IARG,1,CM(1,3),IBID)
      CALL GETVR8('BETON','C2M1',1,IARG,1,CM(2,1),IBID)
      CALL GETVR8('BETON','C2M2',1,IARG,1,CM(2,2),IBID)
      CALL GETVR8('BETON','C2M3',1,IARG,1,CM(2,3),IBID)

      IF(NNAP .GT. 0) THEN
        DO 10, ILIT = 1,NNAP
          CALL GETVID('NAPPE','MATER',ILIT,IARG,1,MATER,IBID)
          NOMRES(1) = 'E'
          CALL RCVALE(MATER,'ELAS            ',0,K8B,R8B,1,
     &            NOMRES,VALRES,ICODR2,1)
          EA(ILIT) = VALRES(1)
          NOMRES(1) = 'SY'
          CALL RCVALE(MATER,'ECRO_LINE       ',0,K8B,R8B,1,
     &            NOMRES,VALRES,ICODR2,1)
          SY(ILIT) = VALRES(1)
          CALL GETVR8('NAPPE','OMX',ILIT,IARG,1,OMX(ILIT),IBID)
          CALL GETVR8('NAPPE','OMY',ILIT,IARG,1,OMY(ILIT),IBID)
          CALL GETVR8('NAPPE','RX',ILIT,IARG,1,RX(ILIT),IBID)
          CALL GETVR8('NAPPE','RY',ILIT,IARG,1,RY(ILIT),IBID)
          NUA(ILIT) = 0.0D0
          LINER(ILIT) = 0.0D0
 10     CONTINUE
        ILIT = NNAP
      ENDIF

      IF(NPREC .GT. 0) THEN
        DO 20, II = 1,NPREC
          ILIT = ILIT + 1
          CALL GETVID('CABLE_PREC','MATER',II,IARG,1,MATER,IBID)
          NOMRES(1) = 'E'
          CALL RCVALE(MATER,'ELAS            ',0,K8B,R8B,1,
     &            NOMRES,VALRES,ICODR2,1)
          EA(ILIT) = VALRES(1)
          NOMRES(1) = 'SY'
          CALL RCVALE(MATER,'ECRO_LINE       ',0,K8B,R8B,1,
     &            NOMRES,VALRES,ICODR2,1)
          SY(ILIT) = VALRES(1)
          CALL GETVR8('CABLE_PREC','OMX',II,IARG,1,OMX(ILIT),IBID)
          CALL GETVR8('CABLE_PREC','OMY',II,IARG,1,OMY(ILIT),IBID)
          CALL GETVR8('CABLE_PREC','RX',II,IARG,1,RX(ILIT),IBID)
          CALL GETVR8('CABLE_PREC','RY',II,IARG,1,RY(ILIT),IBID)
          CALL GETVR8('CABLE_PREC','PREX',II,IARG,1,PREX,IBID)
          CALL GETVR8('CABLE_PREC','PREY',II,IARG,1,PREY,IBID)
          NUA(ILIT) = 0.0D0
          LINER(ILIT) = 0.0D0
 20     CONTINUE
      ELSE
        PREX = 0.0D0
        PREY = 0.0D0
      ENDIF

      IF(NLINER .GT. 0) THEN
        DO 30, II = 1,NLINER
          ILIT = ILIT + 1
          CALL GETVID('LINER','MATER',II,IARG,1,MATER,IBID)
          NOMRES(1) = 'E'
          NOMRES(2) = 'NU'
          CALL RCVALE(MATER,'ELAS            ',0,K8B,R8B,2,
     &            NOMRES,VALRES,ICODR2,1)
          EA(ILIT)  = VALRES(1)
          NUA(ILIT) = VALRES(2)
          NOMRES(1) = 'SY'
          CALL RCVALE(MATER,'ECRO_LINE       ',0,K8B,R8B,1,
     &            NOMRES,VALRES,ICODR2,1)
          SY(ILIT) = VALRES(1)
          CALL GETVR8('LINER','OML',II,IARG,1,OML(II),IBID)
          CALL GETVR8('LINER','RLR',II,IARG,1,RLR(II),IBID)
          RX(ILIT)  = RLR(II)
          RY(ILIT)  = RLR(II)
          OMX(ILIT) = OML(II)
          OMY(ILIT) = OML(II)
          LINER(ILIT) = 1.0D0
 30     CONTINUE
      ENDIF

C CALCUL DES COEFFICIENTS DE LA MATRICE ELASTIQUE
      CALL GETRES(MATER,TYPE,NOMCMD)
      ELB(1) = EB
      ELB(2) = NUB
      CALL PARGLR(NLIT,ELB,EA,NUA,LINER,OMX,OMY,RX,RY,HH,
     &                  BN11,BN12,BN22,BN33,BM11,BM12,BM22,BC11,BC22)

C E ET NU EQUIVALENTS EN FLEXION
      NUEQ = 2.0D0*BM12/(BM11+BM22)
      EEQ  = (BM11+BM22)*6.D0/HH**3   *(1.D0-NUEQ**2)
      PAR1 = EEQ*HH / (1.0D0 - NUEQ*NUEQ)
      PAR2 = PAR1*HH*HH/12.0D0
      BM11 = PAR2
      BM12 = PAR2*NUEQ
      BM22 = PAR2
      BM33 = PAR2*(1.0D0 - NUEQ)/2.0D0

C MOMENT DE FISSURATION
      MF1X=((BN11*FT/EB-PREX)*BM11+(PREX*HH/2-FT/EB*BC11)*BC11)
     &         / (BN11*HH/2-BC11)
      MF1Y=((BN22*FT/EB-PREY)*BM22+(PREY*HH/2-FT/EB*BC22)*BC22)
     &         / (BN22*HH/2-BC22)
      MF2X=((BN11*FT/EB-PREX)*BM11+(-PREX*HH/2-FT/EB*BC11)*BC11)
     &         / (-BN11*HH/2-BC11)
      MF2Y=((BN22*FT/EB-PREY)*BM22+(-PREY*HH/2-FT/EB*BC22)*BC22)
     &         / (-BN22*HH/2-BC22)

C MOYENNE DANS CHAQUE DIRECTION
      MF1 = (MF1X+MF1Y)/2.D0
      MF2 = (MF2X+MF2Y)/2.D0


      CALL GETVR8('BETON','BT1',1,IARG,1,BT1,ICIS)
      CALL GETVR8('BETON','BT2',1,IARG,1,BT2,ICIS)

      IF(ICIS .EQ. 0)THEN
        CALL GETVR8('BETON','OMT',1,IARG,1,OMT,ICIS)
        CALL GETVR8('BETON','EAT',1,IARG,1,EAT,ICIS)
        IF(ICIS .NE. 0) THEN
          BT1 = 5.D0/6.D0*HH/2.D0*(EB/(1+NUB)+EAT*OMT)
          BT2 = 5.D0/6.D0*HH/2.D0*(EB/(1+NUB)+EAT*OMT)
        ELSE
          BT1 = -1.D0
          BT2 = -1.D0
        ENDIF
      ENDIF

C-----REMPLISSAGE DU MATERIAU
      CALL WKVECT(MATER//'.MATERIAU.NOMRC ','G V K16',2,JLM)
      ZK16(JLM  ) = 'GLRC_DAMAGE     '
      ZK16(JLM+1) = 'ELAS            '
C---------ELASTIQUE---------------
      LONOBJ = 5
      CALL WKVECT(MATER//'.ELAS      .VALK','G V K8',2*LONOBJ,JMELK)
      CALL JEECRA(MATER//'.ELAS      .VALK','LONUTI',LONOBJ,' ')
      CALL WKVECT(MATER//'.ELAS      .VALR','G V R',LONOBJ,JMELR)
      CALL JEECRA(MATER//'.ELAS      .VALR','LONUTI',LONOBJ,' ')
      CALL WKVECT(MATER//'.ELAS      .VALC','G V C',LONOBJ,JMELC)
      CALL JEECRA(MATER//'.ELAS      .VALC','LONUTI',0,' ')
      ZK8(JMELK  ) = 'E       '
      ZR(JMELR   ) = EEQ
      ZK8(JMELK+1) = 'NU      '
      ZR(JMELR+1 ) = NUEQ
      ZK8(JMELK+2) = 'RHO     '
      ZR(JMELR+2 ) = RHO
      IF(AMORA .GT. 0.0D0) THEN
        ZK8(JMELK+3) = 'AMOR_ALP'
        ZR(JMELR+3 ) = AMORA
      ENDIF
      IF(AMORB .GT. 0.0D0) THEN
        ZK8(JMELK+4) = 'AMOR_BET'
        ZR(JMELR+4 ) = AMORB
      ENDIF
C---------GLRC_DAMAGE---------------
      LONOBJ = 48
      LONUTI = 35

      CALL WKVECT(MATER//'.GLRC_DAMAG.VALK','G V K8',2*LONOBJ,JMELK)

      CALL GETVR8('BETON','MP1X',1,IARG,1,MP1CST(1),ICST)

      IF(ICST .EQ. 0) THEN
        CALL JEECRA(MATER//'.GLRC_DAMAG.VALK','LONUTI',59,' ')
      ELSE
        CALL JEECRA(MATER//'.GLRC_DAMAG.VALK','LONUTI',LONUTI,' ')
      ENDIF

C       CALL JEECRA(MATER//'.GLRC_DAMAG.VALK','LONUTI',59,' ')
      CALL WKVECT(MATER//'.GLRC_DAMAG.VALR','G V R',LONOBJ,JMELR)
      CALL JEECRA(MATER//'.GLRC_DAMAG.VALR','LONUTI',LONUTI,' ')
      CALL WKVECT(MATER//'.GLRC_DAMAG.VALC','G V C',LONOBJ,JMELC)
      CALL JEECRA(MATER//'.GLRC_DAMAG.VALC','LONUTI',0,' ')
      IFON0 = JMELK + LONUTI
      LONGF = 12
      IFON1 = IFON0 + LONGF
      ZK8(JMELK  )  = 'BN11    '
      ZR(JMELR   )  = BN11
      ZK8(JMELK+1)  = 'BN12    '
      ZR(JMELR+1 )  = BN12
      ZK8(JMELK+2)  = 'BN22    '
      ZR(JMELR+2 )  = BN22
      ZK8(JMELK+3)  = 'BN33    '
      ZR(JMELR+3 )  = BN33
      ZK8(JMELK+4)  = 'MF1     '
      ZR(JMELR+4 )  = MF1
      ZK8(JMELK+5)  = 'MF2     '
      ZR(JMELR+5 )  = MF2
      ZK8(JMELK+6)  = 'QP1     '
      ZR(JMELR+6 )  = QP1
      ZK8(JMELK+7)  = 'QP2     '
      ZR(JMELR+7 )  = QP2
      ZK8(JMELK+8)  = 'GAMMA   '
      ZR(JMELR+8 )  = GAMMA
      ZK8(JMELK+9)  = 'BT1     '
      ZR(JMELR+9 )  = BT1
      ZK8(JMELK+10) = 'BT2     '
      ZR(JMELR+10 ) = BT2
      ZK8(JMELK+11) = 'C1N1    '
      ZR(JMELR+11 ) = CN(1,1)
      ZK8(JMELK+12) = 'C1N2    '
      ZR(JMELR+12 ) = CN(1,2)
      ZK8(JMELK+13) = 'C1N3    '
      ZR(JMELR+13 ) = CN(1,3)
      ZK8(JMELK+14) = 'C2N1    '
      ZR(JMELR+14 ) = CN(2,1)
      ZK8(JMELK+15) = 'C2N2    '
      ZR(JMELR+15 ) = CN(2,2)
      ZK8(JMELK+16) = 'C2N3    '
      ZR(JMELR+16 ) = CN(2,3)
      ZK8(JMELK+17) = 'C1M1    '
      ZR(JMELR+17 ) = CM(1,1)
      ZK8(JMELK+18) = 'C1M2    '
      ZR(JMELR+18 ) = CM(1,2)
      ZK8(JMELK+19) = 'C1M3    '
      ZR(JMELR+19 ) = CM(1,3)
      ZK8(JMELK+20) = 'C2M1    '
      ZR(JMELR+20 ) = CM(2,1)
      ZK8(JMELK+21) = 'C2M2    '
      ZR(JMELR+21 ) = CM(2,2)
      ZK8(JMELK+22) = 'C2M3    '
      ZR(JMELR+22 ) = CM(2,3)
      ZK8(JMELK+23) = 'MAXMP1  '
      ZR(JMELR+23 ) = 0.0D0
      ZK8(JMELK+24) = 'MAXMP2  '
      ZR(JMELR+24 ) = 0.0D0
      ZK8(JMELK+25) = 'MINMP1  '
      ZR(JMELR+25 ) = 0.0D0
      ZK8(JMELK+26) = 'MINMP2  '
      ZR(JMELR+26 ) = 0.0D0
      ZK8(JMELK+27) = 'NORMM  '
      ZR(JMELR+27 ) = 1.0D0
      ZK8(JMELK+27) = 'NORMN  '
      ZR(JMELR+27 ) = 1.0D0
C---------IMPRESSION-------------
      IF (NIMPR.GT.0) THEN
        WRITE (IFR,1000)
        WRITE (IFR,*) 'PARAMETRES HOMOGENEISES POUR GLRC_DAMAGE :'
        WRITE (IFR,*) 'BN11, BN12, BN22, BN33 =   :',BN11,' ',BN12,' ',
     &                BN22,' ',BN33
        IF (ICIS .EQ. 0) THEN
          WRITE (IFR,*) 'BT1, BT2 =   :',BT1,' ',BT2
        ENDIF
        WRITE (IFR,*) 'MF1, MF2 =   :',MF1,' ',MF2
        WRITE (IFR,*) 'GAMMA, QP1, QP2 =   :',GAMMA,' ',QP1,' ',QP2
        WRITE (IFR,*) 'C1N1, C1N2, C1N3 =   :',CN(1,1),' ',CN(1,2),' ',
     &                 CN(1,3)
        WRITE (IFR,*) 'C2N1, C2N2, C2N3 =   :',CN(2,1),' ',CN(2,2),' ',
     &                 CN(2,3)
        WRITE (IFR,*) 'C1M1, C1M2, C1M3 =   :',CM(1,1),' ',CM(1,2),' ',
     &                 CM(1,3)
        WRITE (IFR,*) 'C2M1, C2M2, C2M3 =   :',CM(2,1),' ',CM(2,2),' ',
     &                 CM(2,3)
        WRITE (IFR,*) 'MODULE D YOUNG ET COEFFICIENT DE POISSON '
     &                ,'EFFECTIFS EN FLEXION:'
        WRITE (IFR,*) 'EF, NUF =   :',EEQ,' ',NUEQ
      END IF
C--------CREER LES FONCTIONS SEUILS---------

C--------L UTILISATEUR A ENTRE DES CONSTANTES

      CALL GETVR8('BETON','MP1Y',1,IARG,1,MP1CST(2),ICST)
      CALL GETVR8('BETON','MP2X',1,IARG,1,MP2CST(1),ICST)
      CALL GETVR8('BETON','MP2Y',1,IARG,1,MP2CST(2),ICST)

      IF(ICST .EQ. 0) THEN
C--------L UTILISATEUR A ENTRE DES FONCTIONS

        CALL GETVID('BETON','MP1X_FO',1,IARG,1,FSNCX,IMPF)
        CALL GETVID('BETON','MP2X_FO',1,IARG,1,FINCX,IMPF)
        CALL GETVID('BETON','MP1Y_FO',1,IARG,1,FSNCY,IMPF)
        CALL GETVID('BETON','MP2Y_FO',1,IARG,1,FINCY,IMPF)

        IF (IMPF .EQ. 1) THEN
          CALL GCNCON('_',FSCXD)
          CALL GCNCON('_',FSCYD)
          CALL GCNCON('_',FSCXD2)
          CALL GCNCON('_',FSCYD2)
          CALL GCNCON('_',FICXD)
          CALL GCNCON('_',FICYD)
          CALL GCNCON('_',FICXD2)
          CALL GCNCON('_',FICYD2)
C-----Mx/Nx -------------
          CALL MOCON2(FC,SY,HH,NLIT,OMX,RX,FSNCX,FINCX,
     &            FSCXD,FICXD,FSCXD2,FICXD2,PREX)
C-----My/Ny -------------
          CALL MOCON2(FC,SY,HH,NLIT,OMY,RY,FSNCY,FINCY,
     &            FSCYD,FICYD,FSCYD2,FICYD2,PREY)
        ELSE
C--------L UTILISATEUR N A RIEN RENSEIGNE

          CALL GCNCON('_',FSNCX)
          CALL GCNCON('_',FSNCY)
          CALL GCNCON('_',FINCX)
          CALL GCNCON('_',FINCY)
          CALL GCNCON('_',FSCXD)
          CALL GCNCON('_',FSCYD)
          CALL GCNCON('_',FSCXD2)
          CALL GCNCON('_',FSCYD2)
          CALL GCNCON('_',FICXD)
          CALL GCNCON('_',FICYD)
          CALL GCNCON('_',FICXD2)
          CALL GCNCON('_',FICYD2)
C-----Mx/Nx -------------
          CALL MOCONM(FC,SY,HH,NLIT,OMX,RX,FSNCX,FINCX,
     &            FSCXD,FICXD,FSCXD2,FICXD2,PREX)
C-----My/Ny -------------
          CALL MOCONM(FC,SY,HH,NLIT,OMY,RY,FSNCY,FINCY,
     &            FSCYD,FICYD,FSCYD2,FICYD2,PREY)
        ENDIF

        ZK8(IFON0  ) = 'FMEX1   '
        ZK8(IFON1  ) = FSNCX
        ZK8(IFON0+1) = 'FMEY1   '
        ZK8(IFON1+1) = FSNCY
        ZK8(IFON0+2) = 'DFMEX1  '
        ZK8(IFON1+2) = FSCXD
        ZK8(IFON0+3) = 'DFMEY1  '
        ZK8(IFON1+3) = FSCYD
        ZK8(IFON0+4) = 'DDFMEX1 '
        ZK8(IFON1+4) = FSCXD2
        ZK8(IFON0+5) = 'DDFMEY1 '
        ZK8(IFON1+5) = FSCYD2
        ZK8(IFON0+6) = 'FMEX2   '
        ZK8(IFON1+6) = FINCX
        ZK8(IFON0+7) = 'FMEY2   '
        ZK8(IFON1+7) = FINCY
        ZK8(IFON0+8) = 'DFMEX2  '
        ZK8(IFON1+8) = FICXD
        ZK8(IFON0+9) = 'DFMEY2  '
        ZK8(IFON1+9) = FICYD
        ZK8(IFON0+10) = 'DDFMEX2 '
        ZK8(IFON1+10) = FICXD2
        ZK8(IFON0+11) = 'DDFMEY2 '
        ZK8(IFON1+11) = FICYD2
C---------IMPRESSION-------------
        IF (NIMPR.GT.0) THEN
          WRITE (IFR,1000)
          WRITE (IFR,*) 'FONCTIONS SEUIL POUR GLRC:'
          WRITE (IFR,*) 'FMEX1, FMEY1, FMEX2, FMEY2 =   :',FSNCX,' ',
     &                FSNCY,' ',FINCX,' ',FINCY
          WRITE (IFR,*) 'DERIVEES PREMIERES :'
          WRITE (IFR,*) 'DFMEX1, DFMEY1, DFMEX2, DFMEY2 =   :',FSCXD,
     &                ' ',FSCYD,' ',FICXD,' ',FICYD
          WRITE (IFR,*) 'DERIVEES SECONDES :'
          WRITE (IFR,*) 'DDFMEX1, DDFMEY1, DDFMEX2, DDFMEY2 =   :',
     &                FSCXD2,' ',FSCYD2,' ',FICXD2,' ',FICYD2
        END IF

        NOMRES(1) = 'FMEX1'
        FON(1) = FSNCX
        NOMRES(2) = 'FMEX2'
        FON(2) = FINCX
        NOMRES(3) = 'FMEY1'
        FON(3) = FSNCY
        NOMRES(4) = 'FMEY2'
        FON(4) = FINCY
      ENDIF

C------CALCULER MAXMP,MINMP,NORMM,NORMN-----------------
      DO 35, II = 1,2
        IF(ICST .EQ. 0)THEN
          K8B = 'X '
          CALL FOINTE ('F',FON(2*(II-1)+1),1,'X ',0.0D0,MP1N0,IBID )
          CALL FOINTE ('F',FON(2*II      ),1,'X ',0.0D0,MP2N0,IBID )
          CALL MMFONC(FON(2*(II-1)+1),AUX,MAXMP(II))
          CALL MMFONC(FON(2*II),MINMP(II),AUX)
          IF ( (MP1N0  .LT.  0.D0).OR.(MP2N0  .GT.  0.D0).OR.
     &       (MAXMP(II)-MINMP(II) .LE. 0.D0)   ) THEN
            CALL U2MESS('F','ELEMENTS_87')
          ENDIF
        ELSE
          MAXMP(II)=MP1CST(II)
          MINMP(II)=MP2CST(II)
        ENDIF
 35   CONTINUE

      NORMM=0.5D0*MAX(MAXMP(1)-MINMP(1),MAXMP(2)-MINMP(2))

      DO 40, II = 1,2
        IF(ICST .EQ. 0)THEN
          NMAX0 =  1.0D20
          NMIN0 = -1.0D20
          CALL INTERF(MATER,NOMRES(2*(II-1)+1),NOMRES(2*II),
     &              NORMM,NMIN0,NMIN(II))
          CALL INTERF(MATER,NOMRES(2*(II-1)+1),NOMRES(2*II),
     &                NORMM,NMAX0,NMAX(II))
        ELSE
          NMAX(II)=0.D0
          NMIN(II)=0.D0
        ENDIF
 40   CONTINUE

      NORMN=0.5D0*MAX(ABS(NMAX(1)-NMIN(1)),ABS(NMAX(2)-NMIN(2)))

      ZK8(JMELK+23) = 'MAXMP1  '
      ZR(JMELR+23 ) = MAXMP(1)
      ZK8(JMELK+24) = 'MAXMP2  '
      ZR(JMELR+24 ) = MAXMP(2)
      ZK8(JMELK+25) = 'MINMP1  '
      ZR(JMELR+25 ) = MINMP(1)
      ZK8(JMELK+26) = 'MINMP2  '
      ZR(JMELR+26 ) = MINMP(2)
      ZK8(JMELK+27) = 'NORMM  '
      ZR(JMELR+27 ) = NORMM
      ZK8(JMELK+28) = 'NORMN  '
      ZR(JMELR+28 ) = NORMN
      ZK8(JMELK+29) = 'EPAIS  '
      ZR(JMELR+29 ) = HH
      ZK8(JMELK+30) = 'BM11    '
      ZR(JMELR+30 ) = BM11
      ZK8(JMELK+31) = 'BM12    '
      ZR(JMELR+31 ) = BM12
      ZK8(JMELK+32) = 'BM22    '
      ZR(JMELR+32 ) = BM22
      ZK8(JMELK+33) = 'BM33    '
      ZR(JMELR+33 ) = BM33
      ZK8(JMELK+34) = 'MPCST    '
      IF (ICST .NE. 0) THEN
        ZR(JMELR+34 ) = 0.D0
      ELSE
        ZR(JMELR+34 ) = 1.D0
      ENDIF
 1000 FORMAT (/,80 ('-'))
      CALL JEDEMA()

      END
