      SUBROUTINE TE0034 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/02/99   AUTEUR VABHHTS J.PELLET 
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
C                        ELEMENT  : 'MEBODKT'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      REAL*8             DX,DY,DZ,LONG,FX,FY,FZ,MX,MY,MZ
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
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
C     -- CALCUL DE LA LONGUEUR DU SEGMENT :
      DX = ZR(IGEOM-1+4)-ZR(IGEOM-1+1)
      DY = ZR(IGEOM-1+5)-ZR(IGEOM-1+2)
      DZ = ZR(IGEOM-1+6)-ZR(IGEOM-1+3)
      LONG= SQRT(DX**2 + DY**2 + DZ**2)
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
C
         VALPAR(1) = (ZR(IGEOM-1+1) +ZR(IGEOM-1+4))/2.0D0
         VALPAR(2) = (ZR(IGEOM-1+2) +ZR(IGEOM-1+5))/2.0D0
         VALPAR(3) = (ZR(IGEOM-1+3) +ZR(IGEOM-1+6))/2.0D0
         VALPAR(4) =  ZR(ITPSR)
C
         CALL FOINTE('FM',ZK8(IFORC-1+1),4,NOMPAR,VALPAR,FX,ICOD1)
         CALL FOINTE('FM',ZK8(IFORC-1+2),4,NOMPAR,VALPAR,FY,ICOD2)
         CALL FOINTE('FM',ZK8(IFORC-1+3),4,NOMPAR,VALPAR,FZ,ICOD3)
         CALL FOINTE('FM',ZK8(IFORC-1+4),4,NOMPAR,VALPAR,MX,ICOD4)
         CALL FOINTE('FM',ZK8(IFORC-1+5),4,NOMPAR,VALPAR,MY,ICOD5)
         CALL FOINTE('FM',ZK8(IFORC-1+6),4,NOMPAR,VALPAR,MZ,ICOD6)
      ELSE
         CALL UTMESS('F','TE0034','OPTION : '//OPTION//' INTERDITE')
      END IF
C
C     -- AFFECTATION DU RESULTAT:
C
      DO 1 , INO=1,2
         ZR(IVECTU-1+(INO-1)*6 +1) = FX*LONG/2.0D0
         ZR(IVECTU-1+(INO-1)*6 +2) = FY*LONG/2.0D0
         ZR(IVECTU-1+(INO-1)*6 +3) = FZ*LONG/2.0D0
         ZR(IVECTU-1+(INO-1)*6 +4) = MX*LONG/2.0D0
         ZR(IVECTU-1+(INO-1)*6 +5) = MY*LONG/2.0D0
         ZR(IVECTU-1+(INO-1)*6 +6) = MZ*LONG/2.0D0
 1    CONTINUE
C
 9999 CONTINUE
      END
