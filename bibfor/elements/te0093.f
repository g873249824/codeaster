      SUBROUTINE TE0093 ( OPTION , NOMTE )
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
C                          OPTION : 'CHAR_MECA_FR2D2D  '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      CHARACTER*8        ELREFE
      REAL*8             DFDX(9),DFDY(9),POIDS,R,FX,FY
      INTEGER            NNO,KP,NPG1,I,K,L,IFR2D,IVECTU
      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM

      INTEGER IADZI,IAZK24
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
      CHARACTER*6        PGC
      COMMON  / NOMAJE / PGC
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL ELREF1(ELREFE)

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
      CALL JEVECH('PVECTUR','E',IVECTU)
C

C     POUR LE CAS DES FORCES VOLUMIQUES EN 2D
      CALL TECACH(.TRUE.,.FALSE.,'PNFORCER',1,IFR2D)
      IF ( IFR2D .NE. 0 ) THEN
        CALL JEVECH('PNFORCER','L',IFR2D)

        DO 201 KP=1,NPG1
          K=(KP-1)*NNO
          CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDX,DFDY,POIDS )

C        --- CALCUL DE LA FORCE AUX PG (A PARTIR DES NOEUDS) ---
           FX = 0.D0
           FY = 0.D0
           DO 213 I=1,NNO
             II = 2 * (I-1)
             FX = FX + ZR(IVF+K+I-1) * ZR(IFR2D+II  )
             FY = FY + ZR(IVF+K+I-1) * ZR(IFR2D+II+1)
213        CONTINUE


          IF ( NOMTE(3:4) .EQ. 'AX' ) THEN
            R = 0.D0
            DO 202 I=1,NNO
              R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
202         CONTINUE
            POIDS = POIDS*R
          ENDIF
          DO 203 I=1,NNO
            ZR(IVECTU+2*I-2) = ZR(IVECTU+2*I-2) +
     &         POIDS * FX * ZR(IVF+K+I-1)
            ZR(IVECTU+2*I-1) = ZR(IVECTU+2*I-1) +
     &         POIDS * FY * ZR(IVF+K+I-1)
203       CONTINUE
201     CONTINUE


      ELSE
        CALL JEVECH('PFR2D2D','L',IFR2D)
        DO 101 KP=1,NPG1
          K=(KP-1)*NNO
          L=(KP-1)*2
          CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDX,DFDY,POIDS )
          IF ( NOMTE(3:4) .EQ. 'AX' ) THEN
            R = 0.D0
            DO 102 I=1,NNO
              R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
102         CONTINUE
            POIDS = POIDS*R
          ENDIF
          DO 103 I=1,NNO
            ZR(IVECTU+2*I-2) = ZR(IVECTU+2*I-2) +
     &         POIDS * ZR(IFR2D+L   ) * ZR(IVF+K+I-1)
            ZR(IVECTU+2*I-1) = ZR(IVECTU+2*I-1) +
     &         POIDS * ZR(IFR2D+L+1) * ZR(IVF+K+I-1)
103       CONTINUE
101     CONTINUE
      ENDIF
      END
