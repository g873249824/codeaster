      SUBROUTINE DKQRIG ( NOMTE, XYZL, OPTION, PGL, RIG, ENER )
      IMPLICIT  NONE
      REAL*8        XYZL(4,*), PGL(*), RIG(*), ENER(*)
      CHARACTER*16  OPTION , NOMTE
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     ------------------------------------------------------------------
C MODIF ELEMENTS  DATE 14/10/2005   AUTEUR CIBHHLV L.VIVAN 
C
C     MATRICE DE RIGIDITE DE L'ELEMENT DE PLAQUE DKQ
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES QUATRE NOEUDS
C     IN  OPTION : OPTION RIGI_MECA, RIGI_MECA_SENS* OU EPOT_ELEM_DEPL
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
C     OUT RIG    : MATRICE DE RIGIDITE
C     OUT ENER   : TERMES POUR ENER_POT (EPOT_ELEM_DEPL)
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER  NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER MULTIC, I, INT, JCOQU, JDEPG
      REAL*8 WGT
      REAL*8 DF(9),DM(9),DMF(9),DC(4),DCI(4)
      REAL*8 DF2(9),DM2(9),DMF2(9)
      REAL*8 DMC(3,2),DFC(3,2)
      REAL*8 BF(3,12),BM(3,8)
      REAL*8 XAB1(3,12),DEPL(24),CARAQ4(25),JACOB(5),QSI,ETA
      REAL*8 FLEX(144),MEMB(64),MEFL(96),T2EV(4),T2VE(4),T1VE(9)
      REAL*8 BSIGTH(24),ENERTH, EXCENT, R8GAEM, UN, CTOR
      LOGICAL ELASCO, EXCE, INDITH
C     ------------------------------------------------------------------
C
      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
C
      UN = 1.0D0
      ENERTH = 0.0D0
C
      CALL JEVECH('PCACOQU','L',JCOQU)
      CTOR   = ZR(JCOQU+3)
      EXCENT = ZR(JCOQU+4)
C
      EXCE = .FALSE.
      IF (ABS(EXCENT).GT.UN/R8GAEM()) EXCE = .TRUE.

C     ----- MISE A ZERO DES MATRICES : FLEX ,MEMB ET MEFL :
      CALL R8INIR(144,0.D0,FLEX,1)
      CALL R8INIR( 64,0.D0,MEMB,1)
      CALL R8INIR( 96,0.D0,MEFL,1)
C
C     ----- CALCUL DES MATRICES DE RIGIDITE DU MATERIAU EN FLEXION,
C           MEMBRANE ET CISAILLEMENT INVERSEE --------------------------
      CALL DXMATE(DF,DM,DMF,DC,DCI,DMC,DFC,NNO,PGL,MULTIC,.FALSE.,
     +                                         ELASCO,T2EV,T2VE,T1VE)
C     ----- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE --------
      CALL GQUAD4 ( XYZL, CARAQ4 )

      DO 10 INT = 1,NPG
        QSI = ZR(ICOOPG-1+NDIM*(INT-1)+1)
        ETA = ZR(ICOOPG-1+NDIM*(INT-1)+2)
C        ----- CALCUL DU JACOBIEN SUR LE QUADRANGLE --------------------
        CALL JQUAD4 ( XYZL, QSI, ETA, JACOB )
        WGT = ZR(IPOIDS+INT-1)*JACOB(1)

C        -- FLEXION :
        CALL DKQBF( QSI, ETA, JACOB(2), CARAQ4, BF )
C        ----- CALCUL DU PRODUIT BFT.DF.BF -----------------------------
        CALL DCOPY(9,DF,1,DF2,1)
        CALL DSCAL(9,WGT,DF2,1)
        CALL UTBTAB('CUMU',3,12,DF2,BF,XAB1,FLEX)

C        -- MEMBRANE :
        CALL DXQBM ( QSI, ETA, JACOB(2), BM )
C        ----- CALCUL DU PRODUIT BMT.DM.BM -----------------------------
        CALL DCOPY(9,DM,1,DM2,1)
        CALL DSCAL(9,WGT,DM2,1)
        CALL UTBTAB('CUMU',3,8,DM2,BM,XAB1,MEMB)

C        -- COUPLAGE :
        IF (MULTIC.EQ.2.OR.EXCE) THEN
C           ----- CALCUL DU PRODUIT BMT.DMF.BF -------------------------
          CALL DCOPY(9,DMF,1,DMF2,1)
          CALL DSCAL(9,WGT,DMF2,1)
          CALL UTCTAB('CUMU',3,12,8,DMF2,BF,BM,XAB1,MEFL)
        END IF
   10 CONTINUE

      IF ( OPTION.EQ.'RIGI_MECA'      .OR.
     +     OPTION.EQ.'RIGI_MECA_SENSI' .OR.
     +     OPTION.EQ.'RIGI_MECA_SENS_C' ) THEN
        CALL DXQLOC(FLEX,MEMB,MEFL,CTOR,RIG)
C
      ELSE IF (OPTION.EQ.'EPOT_ELEM_DEPL') THEN
        CALL JEVECH('PDEPLAR','L',JDEPG)
        CALL UTPVGL(4,6,PGL,ZR(JDEPG),DEPL)
        CALL DXQLOE(FLEX,MEMB,MEFL,CTOR,MULTIC,DEPL,ENER)
        CALL BSTHPL(NOMTE(1:8),BSIGTH,INDITH)
        IF (INDITH) THEN
          DO 20 I = 1, 24
            ENERTH = ENERTH + DEPL(I)*BSIGTH(I)
  20      CONTINUE
          ENER(1) = ENER(1) - ENERTH
        ENDIF
      END IF
C
      END
