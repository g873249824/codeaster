      SUBROUTINE TE0050 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/02/2012   AUTEUR DEVESA G.DEVESA 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'AMOR_MECA'
C                                OU 'RIGI_MECA_HYST'
C        POUR TOUS LES TYPES D'ELEMENTS (SAUF LES ELEMENTS DISCRETS)
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      INTEGER            NBRES,NBPAR
      PARAMETER         ( NBRES=2 )
      PARAMETER         ( NBPAR=3 )

      INTEGER            JGANO,IRET,NBVAL,NBDDL,IDIMGE,NPARA
      INTEGER            I,J,K,KNS,KS,MATER,IRIGI,IMASS
      INTEGER            IRESU,IMATE,IBID,INS,IRNS
      INTEGER            IDRESU(5),IDRIGI(2),IDMASS(2),IDGEO(5)
      INTEGER            IPOIDS,IVF,IDFDX,IGEOM
      INTEGER            NDIM,NNO,NNOS,NPG1,INO

      REAL*8             ALPHA,BETA,ETA,VALRES(NBRES),VALPAR(NBPAR),VXYZ

      INTEGER ICODRE(NBRES)
      CHARACTER*8        NOMRES(NBRES),NOMPAR(NBPAR)
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
C
C     -- RECUPERATION DES CHAMPS PARAMETRES ET DE LEURS LONGUEURS:
C     ------------------------------------------------------------
      INS=0
      IRNS=0
      IF (OPTION.EQ.'AMOR_MECA') THEN
C        CALL TECACH('NNO','PRIGIEL',1,IBID,INS)
        CALL TECACH('NNO','PRIGIEL',1,IDRIGI,INS)
        IF (INS .EQ. 0) THEN
          CALL TECACH('ONN','PMATUUR',5,IDRESU,IRET)
        ELSE
          CALL TECACH('NNN','PMATUNS',5,IDRESU,IRNS)
          IF (IRNS.NE.0) CALL TECACH('ONN','PMATUUR',5,IDRESU,IRET) 
        ENDIF
      ELSE IF (OPTION.EQ.'RIGI_MECA_HYST') THEN
        CALL TECACH('ONN','PMATUUC',5,IDRESU,IRET)
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
      NBVAL= IDRESU(2)
C
      NOMPAR(1)='X'
      NOMPAR(2)='Y'
      NOMPAR(3)='Z'
C
      CALL TECACH('ONN','PGEOMER',5,IDGEO,IRET)
      IGEOM=IDGEO(1)
      IDIMGE=IDGEO(2)/NNO
      CALL ASSERT(IDIMGE.EQ.2 .OR. IDIMGE.EQ.3)
      NPARA=IDIMGE
      DO 5, K=1,IDIMGE
         VXYZ=0.D0
         DO 50 INO=1,NNO
            VXYZ=VXYZ+ZR(IGEOM + IDIMGE*(INO-1) +K -1)
 50      CONTINUE
         VALPAR(K)=VXYZ/NNO
 5    CONTINUE
C
      CALL JEVECH('PMATERC','L',IMATE)
      MATER=ZI(IMATE)
C
      IF (INS .EQ. 0) THEN
        CALL TECACH('ONN','PRIGIEL',2,IDRIGI,IRET)
        CALL ASSERT(IDRIGI(2).EQ.NBVAL)
      ELSEIF (IRNS.EQ.0) THEN
        CALL TECACH('ONN','PRIGINS',2,IDRIGI,IRET)
        CALL ASSERT(IDRIGI(2).EQ.NBVAL)
      ENDIF
C
C
C     -- RECUPERATION DES COEFFICIENTS FONCTIONS DE LA GEOMETRIE :
C     -------------------------------------------------------------
C
      IF (OPTION.EQ.'AMOR_MECA') THEN
C     --------------------------------
        CALL TECACH('ONN','PMASSEL',2,IDMASS,IRET)
C
        IF (INS .EQ. 0) THEN
          CALL ASSERT (IDMASS(2).EQ.NBVAL)
        ELSEIF (IRNS.EQ.0) THEN
          NBDDL = INT(SQRT(DBLE(NBVAL)))
          CALL ASSERT (IDMASS(2).EQ. NBDDL*(NBDDL+1)/2)
        ENDIF
C
        NOMRES(1)='AMOR_ALPHA'
        NOMRES(2)='AMOR_BETA'
        VALRES(1) = 0.D0
        VALRES(2) = 0.D0
        CALL RCVALB('RIGI',1,1,'+',MATER,' ','ELAS',NPARA,NOMPAR,VALPAR,
     &                2,NOMRES,VALRES,ICODRE, 0)
C
      ELSE IF (OPTION.EQ.'RIGI_MECA_HYST') THEN
C     ------------------------------------------
        NOMRES(1)='AMOR_HYST'
        VALRES(1) = 0.D0
        CALL RCVALB('RIGI',1,1,'+',MATER,' ','ELAS',NPARA,NOMPAR,VALPAR,
     &                1,NOMRES,VALRES,ICODRE, 0)
        IF (ICODRE(1) .NE.0) THEN
          CALL RCVALB('RIGI',1,1,'+',MATER,' ','ELAS_ORTH',NPARA,
     &                NOMPAR,VALPAR,1,NOMRES,VALRES,ICODRE, 0)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C     -- CALCUL PROPREMENT DIT :
C     --------------------------
      IRESU= IDRESU(1)
      IRIGI= IDRIGI(1)
      IF (OPTION.EQ.'AMOR_MECA') THEN
        ALPHA= VALRES(1)
        BETA = VALRES(2)
        IMASS= IDMASS(1)
C
        IF (INS .EQ. 0. OR. IRNS .NE. 0) THEN
          DO 1 I=1,NBVAL
            IF (IRIGI.NE.0) THEN
              ZR(IRESU-1+I)=ALPHA*ZR(IRIGI-1+I)+BETA*ZR(IMASS-1+I)
            ELSE
              ZR(IRESU-1+I)=BETA*ZR(IMASS-1+I)
            ENDIF
 1        CONTINUE
        ELSE
C     Cas non symetrique
          DO 3 I=1,NBDDL
            KNS = (I-1)*NBDDL
            DO 4 J=1,NBDDL
              IF (J.LE.I) THEN
                KS = (I-1)*I/2+J
              ELSE
                KS = (J-1)*J/2+I
              END IF
              ZR(IRESU-1+KNS+J)=ALPHA*ZR(IRIGI-1+KNS+J)
     &                         +BETA*ZR(IMASS-1+KS)
 4          CONTINUE
 3        CONTINUE
        ENDIF
      ELSE IF (OPTION.EQ.'RIGI_MECA_HYST') THEN
        ETA  = VALRES(1)
        DO 2 I=1,NBVAL
          ZC(IRESU-1+I)=DCMPLX(ZR(IRIGI-1+I),ETA*ZR(IRIGI-1+I))
 2      CONTINUE
      END IF
C
C
      END
