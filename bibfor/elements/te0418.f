      SUBROUTINE TE0418 ( OPTION , NOMTE )
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
C                          OPTION : 'CHAR_ME_FR1D3D  '
C                                   'CHAR_ME_FF1D3D  '
C                        ELEMENT  : 'MEBOCQ3'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      CHARACTER*8        ELREFE
      REAL*8             FX,FY,FZ,MX,MY,MZ,JAC,JACP,EFFGLB(18)
      INTEGER            I
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR ,VALPAR(4)
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8 ,NOMPAR(4)
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL ELREF1(ELREFE)
      ZERO=0.D0
C
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO = ZI(ICARAC)
      NPG = ZI(ICARAC+2)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS = IFF
      IVF    = IPOIDS + NPG
      IDFDK  = IVF    + NPG*NNO
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      CALL R8INIR(18,0.D0,EFFGLB,1)
C
C     -- CALCUL DE LA FORCE MOYENNE :
      IF (OPTION(11:16).EQ.'FR1D3D') THEN
         CALL JEVECH('PFR1D3D','L',IFORC)
         FX= ZR(IFORC-1+1)
         FY= ZR(IFORC-1+2)
         FZ= ZR(IFORC-1+3)
         MX= ZR(IFORC-1+4)
         MY= ZR(IFORC-1+5)
         MZ= ZR(IFORC-1+6)
      ELSE IF (OPTION(11:16).EQ.'FF1D3D') THEN
         CALL JEVECH('PFF1D3D','L',IFORC)
         CALL JEVECH('PTEMPSR','L',ITPSR)
C
         NOMPAR(1) = 'X'
         NOMPAR(2) = 'Y'
         NOMPAR(3) = 'Z'
         NOMPAR(4) = 'INST'
         VALPAR(4) = ZR(ITPSR)
      ELSE
         CALL UTMESS('F','TE0418','OPTION : '//OPTION//' INTERDITE')
      ENDIF
C
      DO 101 KP=1,NPG
        K=(KP-1)*NNO
C       CALL DFDM1D( NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),
C    &               ZR(IGEOM),DFDX,COUR,JACP,COSA,SINA)
C
        DXDK=ZERO
        DYDK=ZERO
        DZDK=ZERO
C
        DO 102 I=1,NNO
           DXDK=DXDK+ZR(IGEOM+3*(I-1)  )*ZR(IDFDK+K+I-1)
           DYDK=DYDK+ZR(IGEOM+3*(I-1)+1)*ZR(IDFDK+K+I-1)
           DZDK=DZDK+ZR(IGEOM+3*(I-1)+2)*ZR(IDFDK+K+I-1)
 102    CONTINUE
           JAC =SQRT ( DXDK**2 + DYDK**2 + DZDK**2 )
           JACP=JAC*ZR(IPOIDS+KP-1)
      IF (OPTION(11:16).EQ.'FF1D3D') THEN
         X = ZERO
         Y = ZERO
         Z = ZERO
         DO 15 I=1,NNO
            X=X+ZR(IGEOM+3*(I-1)  )*ZR(IVF+K+I-1)
            Y=Y+ZR(IGEOM+3*(I-1)+1)*ZR(IVF+K+I-1)
            Z=Z+ZR(IGEOM+3*(I-1)+2)*ZR(IVF+K+I-1)
 15      CONTINUE
         VALPAR(1)=X
         VALPAR(2)=Y
         VALPAR(3)=Z
         CALL FOINTE('FM',ZK8(IFORC-1+1),4,NOMPAR,VALPAR,FX,ICOD1)
         CALL FOINTE('FM',ZK8(IFORC-1+2),4,NOMPAR,VALPAR,FY,ICOD2)
         CALL FOINTE('FM',ZK8(IFORC-1+3),4,NOMPAR,VALPAR,FZ,ICOD3)
         CALL FOINTE('FM',ZK8(IFORC-1+4),4,NOMPAR,VALPAR,MX,ICOD4)
         CALL FOINTE('FM',ZK8(IFORC-1+5),4,NOMPAR,VALPAR,MY,ICOD5)
         CALL FOINTE('FM',ZK8(IFORC-1+6),4,NOMPAR,VALPAR,MZ,ICOD6)
      END IF
C
      DO 30 I=1,NNO
         I1=6*(I-1)
         EFFGLB(I1+1)=EFFGLB(I1+1)+JACP*ZR(IVF+K+I-1)*FX
         EFFGLB(I1+2)=EFFGLB(I1+2)+JACP*ZR(IVF+K+I-1)*FY
         EFFGLB(I1+3)=EFFGLB(I1+3)+JACP*ZR(IVF+K+I-1)*FZ
         EFFGLB(I1+4)=EFFGLB(I1+4)+JACP*ZR(IVF+K+I-1)*MX
         EFFGLB(I1+5)=EFFGLB(I1+5)+JACP*ZR(IVF+K+I-1)*MY
         EFFGLB(I1+6)=EFFGLB(I1+6)+JACP*ZR(IVF+K+I-1)*MZ
 30   CONTINUE
C
 101  CONTINUE
C
C     -- AFFECTATION DU RESULTAT:
C
      DO 1 INO=1,NNO
         ZR(IVECTU-1+(INO-1)*6 +1) = EFFGLB((INO-1)*6+1)
         ZR(IVECTU-1+(INO-1)*6 +2) = EFFGLB((INO-1)*6+2)
         ZR(IVECTU-1+(INO-1)*6 +3) = EFFGLB((INO-1)*6+3)
         ZR(IVECTU-1+(INO-1)*6 +4) = EFFGLB((INO-1)*6+4)
         ZR(IVECTU-1+(INO-1)*6 +5) = EFFGLB((INO-1)*6+5)
         ZR(IVECTU-1+(INO-1)*6 +6) = EFFGLB((INO-1)*6+6)
 1    CONTINUE
C
      END
