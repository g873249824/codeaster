      SUBROUTINE TE0351 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_MECA_TEMP_Z  '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      PARAMETER         ( NBRES=6 )
      CHARACTER*24       CARAC,FF


      CHARACTER*8        NOMRES(NBRES),ELREFE
      CHARACTER*2        CODRET(NBRES)
      REAL*8             TTRG,VK3AL,VALRES(NBRES)
      REAL*8             ZFBM,ZAUST,COEF1,COEF2,EPSTH
      REAL*8             DFDX(9),DFDY(9),TPG,POIDS,R
      INTEGER            NNO,KP,NPG1,I,ITEMPE,IVECTU,ITREF,NZ,JTAB(7)


      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM,IMATE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL ELREF1(ELREFE)
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS=IFF
      IVF   =IPOIDS+NPG1
      IDFDE =IVF   +NPG1*NNO
      IDFDK =IDFDE +NPG1*NNO
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      MATER=ZI(IMATE)


      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='F_ALPHA'
      NOMRES(4)='C_ALPHA'
      NOMRES(5)='PHASE_REFE'
      NOMRES(6)='EPSF_EPSC_TREF'



      CALL JEVECH('PTEREF','L',ITREF)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PPHASRR','L',IPHASE)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
C     INFORMATION DU NOMBRE DE PHASE
      CALL TECACH(.TRUE.,.TRUE.,'PPHASRR',7,JTAB)
       NZ= JTAB(6)



C
      DO 101 KP=1,NPG1
        K=(KP-1)*NNO
        CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDX,DFDY,POIDS )
        R       = 0.D0
        TPG     = 0.D0
        TTRG    = 0.D0
        DO 102 I=1,NNO
          R    = R    +  ZR(IGEOM+2*(I-1))        *ZR(IVF+K+I-1)
          TPG  = TPG  +  ZR(ITEMPE+I-1)           *ZR(IVF+K+I-1)
102     CONTINUE
        TTRG = TPG - ZR(ITREF)
        CALL RCVALA ( MATER,'ELAS_META',1,'TEMP',TPG,6,NOMRES,VALRES,
     &                CODRET, 'FM' )
        VK3AL = VALRES(1)/(1.D0-2.D0*VALRES(2))
        IF ( NOMTE(3:4) .EQ. 'AX') THEN
          POIDS = POIDS*R
          DO 103 I=1,NNO
            K=(KP-1)*NNO
            DFDX(I) = DFDX(I) + ZR(IVF+K+I-1)/R
103       CONTINUE
        ENDIF

        IF (NZ .EQ. 7) THEN
           ZALPHA  = ZR(IPHASE+7*(KP-1)) + ZR(IPHASE+7*KP-6) +
     &             ZR(IPHASE+7*KP-5) + ZR(IPHASE+7*KP-4)
        ELSEIF (NZ .EQ. 3) THEN
           ZALPHA  = ZR(IPHASE+3*KP-3) + ZR(IPHASE+3*KP-2)
        ENDIF



        COEF1 = (1.D0-ZALPHA)*(VALRES(4)*TTRG-(1-VALRES(5))*VALRES(6))
        COEF2 = ZALPHA*(VALRES(3)*TTRG+VALRES(5)*VALRES(6))
        EPSTH = COEF1+COEF2
        POIDS = POIDS*VK3AL*EPSTH
        DO 104 I=1,NNO
           K=(KP-1)*NNO
           ZR(IVECTU+2*I-2) = ZR(IVECTU+2*I-2) + POIDS * DFDX(I)
           ZR(IVECTU+2*I-1) = ZR(IVECTU+2*I-1) + POIDS * DFDY(I)
104     CONTINUE
101   CONTINUE
      END
