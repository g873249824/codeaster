      SUBROUTINE TE0225 ( OPTION , NOMTE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
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
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          COQUE 1D
C                          OPTION : 'CHAR_MECA_TEMP_R'
C                          ELEMENT: MECXSE3,METCSE3,METDSE3
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
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
C --------- FIN  DECLARATIONS NORMALISEES JEVEUX -----------------------
C
      INTEGER       I,IP,K,KP,IGEOM,ICACO,IVECTT,ITREF,ITEMP,IMATE
      INTEGER       ICARAC,IFF,IVF,IDFDK,NNO,NPG1,NPGS,ICOPG,J,NBRES
      PARAMETER     (NBRES=3)
      CHARACTER*24  CARAC,FF
      CHARACTER*16  PHENOM
      CHARACTER*8   NOMRES(NBRES),ELREFE
      CHARACTER*2   BL2, CODRET(NBRES)
      REAL*8        VALRES(NBRES),DFDX(3),R,COUR,JAC,COSA,SINA
      REAL*8        TPG1,TPG2,TPG3,TPG,ZERO,UN,DEUX,X3
      REAL*8        H,ALPHAE,NU,COEF,AXIS
C
      DATA          ZERO,UN,DEUX /0.D0, 1.D0, 2.D0/
C     ------------------------------------------------------------------
C
      CALL ELREF1(ELREFE)
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IVF    = IFF   + NPG1
      IDFDK  = IVF   + NPG1*NNO
      ICOPG  = IDFDK + NPG1*NNO
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCACOQU','L',ICACO)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PTEREF' ,'L',ITREF)
      CALL JEVECH('PVECTUR','E',IVECTT)
C
C --- RECUPERATION DE LA NATURE DU MATERIAU DANS PHENOM
C     -------------------------------------------------
      CALL RCCOMA ( ZI(IMATE), 'ELAS', PHENOM, CODRET )
C
      IF ( PHENOM .EQ. 'ELAS' ) THEN
C
C ==== CALCUL ISOTROPE HOMOGENE =====
C
        NOMRES(1)='E'
        NOMRES(2)='NU'
        NOMRES(3)='ALPHA'
C
        H     = ZR(ICACO  )
        AXIS  = ZERO
        IF(NOMTE(1:8).EQ.'MECXSE3 ') AXIS  =  UN
C
C     ** BOUCLE CONCERNANT LES POINTS DE GAUSS **************
C
        DO 80  KP=1,NPG1
          K=(KP-1)*NNO
          CALL DFDM1D(NNO,ZR(IFF+KP-1),ZR(IDFDK+K),ZR(IGEOM),
     &                DFDX,COUR,JAC,COSA,SINA)
          R   = ZERO
          TPG = ZERO
          TPG1= ZERO
          TPG2= ZERO
          TPG3= ZERO
          DO 102 I=1,NNO
            R    = R    + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
            TPG1 = TPG1 + ZR(ITEMP+3*I-3)*ZR(IVF+K+I-1)
            TPG2 = TPG2 + ZR(ITEMP+3*I-2)*ZR(IVF+K+I-1)
            TPG3 = TPG3 + ZR(ITEMP+3*I-1)*ZR(IVF+K+I-1)
102       CONTINUE
          IF(NOMTE(1:8).EQ.'MECXSE3 ') JAC = JAC*R
C
C---- UTILISATION DE 4 POINTS DE GAUSS DANS L'EPAISSEUR
C---- COMME POUR LA LONGUEUR
C
          DO 135 IP=1,NPG1
            X3  = ZR(ICOPG+IP-1)
            TPG = TPG1*(UN-X3**2)+X3*(TPG3*(UN+X3)-TPG2*(UN-X3))/DEUX
            ALPHAE = ZERO
            CALL RCVALA ( ZI(IMATE),'ELAS',1,'TEMP',TPG,2,NOMRES,
     &                    VALRES,CODRET, 'FM' )
            CALL RCVALA ( ZI(IMATE),'ELAS',1,'TEMP',TPG,1,NOMRES(3),
     &                    VALRES(3),CODRET(3), BL2 )
            IF (CODRET(3).EQ.'OK') ALPHAE = VALRES(3)*VALRES(1)
            NU    =  VALRES(2)
            COEF  = (TPG-ZR(ITREF))*JAC*ALPHAE*ZR(IFF+IP-1)*(H/DEUX)
            IF(NOMTE(1:8).NE.'METCSE3 ') COEF  =  COEF/(UN-NU)
C
            DO 100 I=1,NNO
              J=3*(I-1)
              ZR(IVECTT+J)  =ZR(IVECTT+J  )+COEF*
     &                              (AXIS*ZR(IVF+K+I-1)/R-DFDX(I)*SINA)
              ZR(IVECTT+J+1)=ZR(IVECTT+J+1)+COEF*         DFDX(I)*COSA
              ZR(IVECTT+J+2)=ZR(IVECTT+J+2)-COEF*X3*H/DEUX*
     &                              (AXIS*ZR(IVF+K+I-1)*SINA/R-DFDX(I))
 100        CONTINUE
 135      CONTINUE
 80     CONTINUE
      ELSE
C  ==== CALCUL ANISOTROPE  =====
        CALL UTMESS ('F','TE0225','ANISOTROPIE NON PREVUE POUR COQUE1D')
      ENDIF
      END
