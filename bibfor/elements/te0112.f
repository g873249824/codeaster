      SUBROUTINE TE0112 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/04/2002   AUTEUR CIBHHLV L.VIVAN 
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
C    - BUT :  CALCUL DES MATRICES DE RAIDEUR GEOMETRIQUE ELEMENTAIRES
C                          POUR LES ELEMENTS DE FOURIER
C                          OPTION : 'RIGI_MECA_GE    '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      CHARACTER*8        ELREFE
      REAL*8             A(3,3,9,9)
      REAL*8             DFDR(9),DFDZ(9),DFDT(9),POIDS,R,XH
      INTEGER            NNO,KP,NPG1,IMATUU,ICONTR,IHARMO
      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CALL JEVECH('PCONTRR','L',ICONTR)
      CALL JEVECH('PHARMON','L',IHARMO)
      NH = ZI(IHARMO)
      XH = DBLE(NH)
      CALL JEVECH('PMATUUR','E',IMATUU)
C
      DO 113 K=1,3
         DO 113 L=1,3
            DO 113 I=1,NNO
            DO 113 J=1,I
               A(K,L,I,J) = 0.D0
113   CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 KP=1,NPG1
C
        K=(KP-1)*NNO
        IC = ICONTR + (KP-1)*6
C
        CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDR,DFDZ,POIDS )
C
        R   = 0.D0
        DO 102 I=1,NNO
          R   = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
102     CONTINUE
        POIDS = POIDS*R
C
        DO 103 I=1,NNO
           DFDR(I) = DFDR(I) + ZR(IVF+K+I-1)/R
           DFDT(I) = - XH * ZR(IVF+K+I-1)/R
103     CONTINUE
C
           DO 106 I=1,NNO
             DO 107 J=1,I
C
               A(1,1,I,J) = A(1,1,I,J) + POIDS *
     &           ( ZR(IC)   * DFDR(I) * DFDR(J)
     &           + ZR(IC+1) * DFDZ(I) * DFDZ(J)
     &           + ZR(IC+2) * DFDT(I) * DFDT(J)
     &           + ZR(IC+3) * (DFDR(I) * DFDZ(J) + DFDZ(I) * DFDR(J))
     &           + ZR(IC+4) * (DFDT(I) * DFDR(J) + DFDR(I) * DFDT(J))
     &           + ZR(IC+5) * (DFDZ(I) * DFDT(J) + DFDT(I) * DFDZ(J)))
C
107            CONTINUE
106        CONTINUE
C
101   CONTINUE
C
           DO 108 I=1,NNO
              DO 109 J=1,I
             A(2,2,I,J) = A(1,1,I,J)
             A(3,3,I,J) = A(1,1,I,J)
109        CONTINUE
108        CONTINUE
C
C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)
C
      DO 111 K=1,3
         DO 111 L=1,3
            DO 111 I=1,NNO
                IK = ((3*I+K-4) * (3*I+K-3)) / 2
            DO 111 J=1,I
                IJKL = IK + 3 * (J-1) + L
                ZR(IMATUU+IJKL-1) = A(K,L,I,J)
111          CONTINUE
C
      END
