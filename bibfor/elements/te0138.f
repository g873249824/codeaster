      SUBROUTINE TE0138 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/04/2002   AUTEUR BOITEAU O.BOITEAU 
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
C----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
C                          OPTION : 'RESI_THER_FLUXNL'
C                          ELEMENTS DE FACE 2D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       04/04/02 (OB): CORRECTION BUG, OPTION NON PORTEE EN LUMPE
C       + MODIFS FORMELLES: IMPLICIT NONE, LAXI, IDENTATION...
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE
C PARAMETRES D'APPEL      
      CHARACTER*16        OPTION , NOMTE
      
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

C VARIABLES LOCALES
      CHARACTER*8  COEF,ELREFE
      CHARACTER*24 CARAC,FF
      REAL*8       POIDS,R,NX,NY,THETA,ALPHA,RBID,TPG,COORSE(18),
     &             VECTT(9)
      INTEGER      NNO,KP,NPG,ICARAC,IFF,IPOIDS,IVF,IDFDE,IGEOM,K,I,J,
     &             L,LI,IFLUX,IVERES,NSE,C(6,9),ISE,NNOP2,ITEMPS,ITEMPI
      LOGICAL      LAXI

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      CALL ELREF1(ELREFE)
      CALL JEMARQ()
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO=ZI(ICARAC)
      NPG=ZI(ICARAC+2)

      FF = '&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS=IFF
      IVF   =IPOIDS+NPG
      IDFDE =IVF   +NPG*NNO

      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PFLUXNL','L',IFLUX )
      CALL JEVECH('PRESIDU','E',IVERES)

C INITS.
      THETA  = ZR(ITEMPS+2)
      COEF   = ZK8(IFLUX)
      IF ( COEF(1:7) .EQ. '&FOZERO' ) GOTO 999
      IF ( NOMTE(3:4) .EQ. 'AX' ) THEN
        LAXI = .TRUE.
      ELSE
        LAXI = .FALSE.
      ENDIF
      CALL CONNEC ( NOMTE, ZR(IGEOM), NSE, NNOP2, C )
      DO 10 I=1,NNOP2
        VECTT(I)=0.D0
  10  CONTINUE

C --- CALCUL ISO-P2 : BOUCLE SUR LES SOUS-ELEMENTS -------

      DO 100 ISE=1,NSE

        DO 106 I=1,NNO
          DO 106 J=1,2
            COORSE(2*(I-1)+J) = ZR(IGEOM-1+2*(C(ISE,I)-1)+J)
 106    CONTINUE
        DO 101 KP=1,NPG
          K = (KP-1)*NNO
          CALL VFF2DN(NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),COORSE,
     &                NX,NY,POIDS)
          IF (LAXI) THEN
            R = 0.D0
            DO 112 I=1,NNO
              L = (KP-1)*NNO+I
              R = R + COORSE(2*(I-1)+1) * ZR(IVF+L-1)
 112        CONTINUE
            POIDS = POIDS*R
          ENDIF
          
          TPG = 0.D0
          DO 102 I=1,NNO
            L = (KP-1)*NNO+I
            TPG = TPG + ZR(ITEMPI-1+C(ISE,I)) * ZR(IVF+L-1)
 102      CONTINUE
          CALL FODERI (COEF,TPG,ALPHA,RBID)
          
CCDIR$ IVDEP
          DO 103 I=1,NNO
            LI = IVF+(KP-1)*NNO+I-1
            VECTT(C(ISE,I)) = VECTT(C(ISE,I)) - POIDS*THETA*ALPHA*ZR(LI)
 103      CONTINUE
 101    CONTINUE
 100  CONTINUE

      DO 200 I=1,NNOP2
        ZR(IVERES-1+I)=VECTT(I)
 200  CONTINUE  
 999  CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
