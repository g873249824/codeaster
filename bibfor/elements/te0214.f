      SUBROUTINE TE0214(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT  NONE

      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE

C ......................................................................
C    - FONCTION REALISEE: CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                         POUR DES ELEMENTS MIXTES A 2 CHAMPS EN 3D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER NNO1,NNO2,NPG1,JCRET,CODRET,IRET,NNO1S,NNO2S
      INTEGER JGANO1,JGANO2
      INTEGER IPOI1,IPOI2,IVF1,IVF2,IDFDE1
      INTEGER NDIM,JTAB(7)
      INTEGER IGEOM,IMATE,ICONTM,IVARIM
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICOMPO,LGPG,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,IMATUU
      INTEGER I,N,M,KK,J,JMAX,NPG2,IDFDE2,IDIM

      REAL*8 DEPLM(3,20),DDEPL(3,20)
      REAL*8 GONFLM(1,8),DGONFL(1,8)
      REAL*8 KUU(3,20,3,20),KUA(3,20,1,8),KAA(1,8,1,8)
      REAL*8 FINTU(3,20),FINTA(1,8),DFDIM(3*27)
      REAL*8 ANGMAS(7),XYZ(3)

      CHARACTER*4 FAMI
      CHARACTER*8 ELREF2,TYPMOD(2)

C  REMARQUE :
C  DANS SIGMA : 1,2,3 : (SIGMA)D + P I
C               4,5,6 : SIGMA/SQRT(2)
C               7     : TR(SIGM) - P

C - FONCTIONS DE FORMES ET POINTS DE GAUSS
      IF (NOMTE(8:12).EQ.'TETRA') THEN
        ELREF2 = 'TE4'
      ELSE IF (NOMTE(8:11).EQ.'HEXA') THEN
        ELREF2 = 'HE8'
      ELSE IF (NOMTE(8:12).EQ.'PENTA') THEN
        ELREF2 = 'PE6'
      ELSE
        CALL U2MESK('F','DVP_4',1,NOMTE)
      END IF

      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO1,NNO1S,NPG1,IPOI1,IVF1,IDFDE1,
     &            JGANO1)

      CALL ELREF4(ELREF2,FAMI,NDIM,NNO2,NNO2S,NPG2,IPOI2,IVF2,IDFDE2,
     &            JGANO2)

      TYPMOD(1) = '3D'
      TYPMOD(2) = ' '

C PARAMETRES EN ENTREE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)
      CALL JEVECH('PCARCRI','L',ICARCR)

C - ORIENTATION DU MASSIF
C - COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )
      XYZ(1) = 0.D0
      XYZ(2) = 0.D0
      XYZ(3) = 0.D0
      DO 150 I = 1,NNO1
        DO 140 IDIM = 1,NDIM
          XYZ(IDIM) = XYZ(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO1
 140    CONTINUE
 150  CONTINUE
      CALL RCANGM ( NDIM, XYZ, ANGMAS )

C - PARAMETRES EN SORTIE
      IF (OPTION(1:9).EQ.'RIGI_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PMATUUR','E',IMATUU)
      END IF
      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
        CALL JEVECH('PCODRET','E',JCRET)
      END IF

C - REMISE EN FORME DES DONNEES
      KK = 0
      DO 20 N = 1,NNO1
        DO 10 I = 1,4
          IF (I.LE.3) THEN
            DEPLM(I,N) = ZR(IDEPLM+KK)
            DDEPL(I,N) = ZR(IDEPLP+KK)
            KK = KK + 1
          END IF
          IF (I.GE.4 .AND. N.LE.NNO2) THEN
            GONFLM(I-3,N) = ZR(IDEPLM+KK)
            DGONFL(I-3,N) = ZR(IDEPLP+KK)
            KK = KK + 1
          END IF
   10   CONTINUE
   20 CONTINUE

      IF (ZK16(ICOMPO+2) (1:6).EQ.'PETIT ') THEN
        IF (NOMTE(8:13).EQ.'TETRA4') THEN
          CALL NIPL3B(NNO1,NNO2,NPG1,IPOI1,IVF1,IVF2,
     &                IDFDE1,ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),ZR(IINSTM),
     &                ZR(IINSTP),DEPLM,DDEPL,ANGMAS,GONFLM,DGONFL,
     &                ZR(ICONTM),ZR(IVARIM),DFDIM,ZR(ICONTP),
     &                ZR(IVARIP),FINTU,FINTA,KUU,KUA,KAA,CODRET)
          ELSE
            CALL NIPL3C(NNO1,NNO2,NPG1,IPOI1,IVF1,IVF2,
     &                  IDFDE1,ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                  ZK16(ICOMPO),LGPG,ZR(ICARCR),ZR(IINSTM),
     &                  ZR(IINSTP),DEPLM,DDEPL,ANGMAS,GONFLM,DGONFL,
     &                  ZR(ICONTM),ZR(IVARIM),DFDIM,ZR(ICONTP),
     &                  ZR(IVARIP),FINTU,FINTA,KUU,KUA,KAA,CODRET)
          END IF
      ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
        CALL U2MESS('F','ELEMENTS5_9')
      ELSE
        CALL U2MESK('F','ELEMENTS3_16',1,ZK16(ICOMPO+2))
      END IF

C - REMISE EN FORME DES DONNEES DANS ZR
      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        ZI(JCRET) = CODRET
        KK = 0
        DO 40 N = 1,NNO1
          DO 30 I = 1,4
            IF (I.LE.3) THEN
              ZR(IVECTU+KK) = FINTU(I,N)
              KK = KK + 1
            END IF
            IF (I.GE.4 .AND. N.LE.NNO2) THEN
              ZR(IVECTU+KK) = FINTA(I-3,N)
              KK = KK + 1
            END IF
   30     CONTINUE
   40   CONTINUE
      END IF

      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RIGI_MECA') THEN
        KK = 0
        DO 80 N = 1,NNO1
          DO 70 I = 1,4
            DO 60 M = 1,N
              IF (M.EQ.N) THEN
                JMAX = I
              ELSE
                JMAX = 4
              END IF
              DO 50 J = 1,JMAX
                IF (I.LE.3 .AND. J.LE.3) THEN
                  ZR(IMATUU+KK) = KUU(I,N,J,M)
                  KK = KK + 1
                END IF
                IF (I.GE.4 .AND. N.LE.NNO2 .AND. J.LE.3) THEN
                  ZR(IMATUU+KK) = KUA(J,M,I-3,N)
                  KK = KK + 1
                END IF
                IF (I.LE.3 .AND. M.LE.NNO2 .AND. J.GE.4) THEN
                  ZR(IMATUU+KK) = KUA(I,N,J-3,M)
                  KK = KK + 1
                END IF
                IF (I.GE.4 .AND. N.LE.NNO2 .AND. J.GE.4 .AND.
     &              M.LE.NNO2) THEN
                  ZR(IMATUU+KK) = KAA(I-3,N,J-3,M)
                  KK = KK + 1
                END IF
   50         CONTINUE
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE
      END IF

      END
