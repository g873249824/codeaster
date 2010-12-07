      SUBROUTINE TE0412(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16      OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/07/2009   AUTEUR LEBOUVIER F.LEBOUVIER 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C
C FONCTIONS REALISEES:
C
C      CALCUL DE LA DENSITE D'ENERGIE POTENTIELLE THERMOELASTIQUE
C      A L'EQUILIBRE POUR LES ELEMENTS DKT
C      .SOIT AUX POINTS D'INTEGRATION : OPTION 'ENEL_ELGA'
C      .SOIT AUX NOEUDS               : OPTION 'ENEL_ELNO_ELGA'
C      .SOIT L INTEGRALE PAR ELEMENT  : OPTION 'ENER_ELAS'
C
C      OPTIONS : 'ENEL_ELGA'
C                'ENEL_ELNO_ELGA'
C                'ENER_ELAS'
C
C ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C ----- DEBUT --- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      
      INTEGER    NNOMX 
      PARAMETER (NNOMX=4)
      INTEGER    NBSM,NBSIG 
      PARAMETER (NBSIG=6)
      PARAMETER (NBSM=3)
      INTEGER    NPGMX 
      PARAMETER (NPGMX=4)
      
      REAL*8   PGL(3,3)
      REAL*8   EPS(3),KHI(3)
      REAL*8   BF(3,3*NNOMX),BM(3,2*NNOMX),UM(2,NNOMX),UF(3,NNOMX)
      REAL*8   UL(6,NNOMX),QSI,ETA,XYZL(3,4),JACOB(5),POIDS,CARA(25)
      REAL*8   NMM(NBSM),NMF(NBSM),MFF(NBSM),ENELM(NPGMX),ENELF(NPGMX)
      REAL*8   ENELT(NPGMX),ENM,ENF,ENT,AUXM(NNOMX),AUXF(NNOMX)
      REAL*8   AUXT(NNOMX),ENELMF(NPGMX),DUM(2,NNOMX),DUF(3,NNOMX)
      REAL*8   DUL(6,NNOMX),EFFINT(32),EFFGT(32)
      
      INTEGER  NDIM,NNO,NNOEL,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER  JGEOM,MULTIC,IPG,K,INO,JDEPM,ISIG,JSIG,IDENER,NMCPI
      INTEGER  ICOMPO,ICACOQ,I,NCMP,ICONTP,JVARI,NBVAR,JTAB(7),IVPG
      
      CHARACTER*16 COMPOR,VALK(3)  
      LOGICAL  ELASCO,DKQ,DKG,LKIT     
      
      DKQ = .FALSE.
      DKG = .FALSE.  

      IF (NOMTE.EQ.'MEDKQU4 ') THEN
        DKQ = .TRUE.
      ELSEIF (NOMTE.EQ.'MEDKQG4 ') THEN
        DKQ = .TRUE.
        DKG = .TRUE.
      ELSEIF (NOMTE.EQ.'MEDKTR3 ') THEN
        DKQ = .FALSE.
      ELSEIF (NOMTE.EQ.'MEDKTG3 ') THEN
        DKQ = .FALSE.
        DKG = .TRUE.
      ELSE
        CALL U2MESK('F','ELEMENTS_34',1,NOMTE)
      END IF

      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOEL,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
      
      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      IF (NNO.EQ.3) THEN
         CALL DXTPGL ( ZR(JGEOM), PGL )
      ELSE IF (NNO.EQ.4) THEN
         CALL DXQPGL ( ZR(JGEOM), PGL )
      END IF
      
      LKIT = ZK16(ICOMPO)(1:7).EQ.'KIT_DDI'

      IF ( ZK16(ICOMPO)(1:4).EQ.'ELAS'   .OR. 
     &     ZK16(ICOMPO)(1:4).EQ.'ENDO'   .OR.
     &     ZK16(ICOMPO)(1:6).EQ.'MAZARS' .OR.
     &     ZK16(ICOMPO)(1:7).EQ.'GLRC_DM'.OR. 
     &     ZK16(ICOMPO)(1:11).EQ.'GLRC_DAMAGE'.OR. 
     &   (LKIT  .AND. ZK16(ICOMPO+7)(1:7).EQ.'GLRC_DM' ) 
     &   ) THEN

      
      IF(OPTION(1:4) .EQ. 'ENEL') THEN
        CALL JEVECH('PDEPLAR','L',JDEPM)
        CALL JEVECH ( 'PCONTRR', 'L', ICONTP )
      ELSE IF(OPTION(1:4) .EQ. 'ENER') THEN
        CALL JEVECH('PDEPLR','L',JDEPM)
        CALL JEVECH ( 'PCONTPR', 'L', ICONTP )
      ENDIF  

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PCACOQU','L',ICACOQ)
      
      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)

      IF ( DKQ ) THEN
         CALL GQUAD4(XYZL,CARA)
      ELSE
         CALL GTRIA3(XYZL,CARA)
      END IF
      
      IF(DKG .AND. (LKIT .OR. ZK16(ICOMPO)(1:11).EQ.'GLRC_DAMAGE')) THEN
        IF(OPTION(1:4) .EQ. 'ENEL') THEN
          CALL JEVECH('PVARIGR','L',JVARI)
        ELSE IF(OPTION(1:4) .EQ. 'ENER') THEN
          CALL JEVECH('PVARIPR','L',JVARI)
        ENDIF
      ENDIF    
      IF((.NOT. LKIT) .OR. (.NOT. DKG)) THEN  
        CALL UTPVGL(NNO,6,PGL,ZR(JDEPM),UL)
        
C       -- PARTITION DU DEPLACEMENT EN MEMBRANE/FLEXION :
C       -------------------------------------------------
        DO 30,INO = 1,NNOEL
          UM(1,INO) =  UL(1,INO)
          UM(2,INO) =  UL(2,INO)
          UF(1,INO) =  UL(3,INO)
          UF(2,INO) =  UL(5,INO)
          UF(3,INO) = -UL(4,INO)
   30   CONTINUE
      ENDIF 

C     -- CALCUL DES CONTRAINTES GENERALISEES :
C     -------------------------------------------------
      IF(DKG) THEN 
        DO 40 IPG = 1, NPG
          DO 50 ISIG = 1, NBSIG
            EFFINT((IPG-1)*NBSIG + ISIG) = 
     &               ZR(ICONTP-1 + (IPG-1)*8 + ISIG )
 50       CONTINUE  
 40     CONTINUE  
      ELSE
        CALL DXEFFI ( NOMTE, XYZL, PGL, ZR(ICONTP),NBSIG, EFFINT )
      ENDIF  
           
      CALL R8INIR(NPGMX,0.D0,ENELM,1)
      CALL R8INIR(NPGMX,0.D0,ENELF,1)
      CALL R8INIR(NPGMX,0.D0,ENELT,1)
      ENM = 0.0D0
      ENF = 0.0D0
      ENT = 0.0D0

C ---- BOUCLE SUR LES POINTS D'INTEGRATION :
C      ===================================
      DO 20 IPG = 1, NPG

        QSI = ZR(ICOOPG-1+NDIM*(IPG-1)+1)
        ETA = ZR(ICOOPG-1+NDIM*(IPG-1)+2)
        IF ( DKQ ) THEN
          CALL JQUAD4 ( XYZL, QSI, ETA, JACOB )
          POIDS = ZR(IPOIDS+IPG-1)*JACOB(1)
          CALL DXQBM ( QSI, ETA, JACOB(2), BM )
          CALL DKQBF ( QSI, ETA, JACOB(2), CARA, BF )
        ELSE
          POIDS = ZR(IPOIDS+IPG-1)*CARA(7)
          CALL DXTBM ( CARA(9), BM )
          CALL DKTBF ( QSI, ETA, CARA, BF )
        ENDIF

        IF(DKG .AND. LKIT) THEN
          READ (ZK16(ICOMPO-1+2),'(I16)') NBVAR
          IVPG = JVARI + (IPG-1)*NBVAR + 10
          DO 55 ISIG = 1, NBSM
            EPS(ISIG) = ZR(IVPG + ISIG )
            KHI(ISIG) = ZR(IVPG + ISIG + 3)
 55       CONTINUE  
        ELSE
          
C         -- CALCUL DE EPS, KHI :
C         -----------------------------------
          CALL PMRVEC('ZERO',3,2*NNOEL,BM, UM, EPS)
          CALL PMRVEC('ZERO',3,3*NNOEL,BF, UF, KHI)

          IF(ZK16(ICOMPO)(1:11).EQ.'GLRC_DAMAGE') THEN
            READ (ZK16(ICOMPO-1+2),'(I16)') NBVAR
            IVPG = JVARI + (IPG-1)*NBVAR - 1 
            DO 57 ISIG = 1, NBSM
              EPS(ISIG) = EPS(ISIG) - ZR(IVPG + ISIG )
              KHI(ISIG) = KHI(ISIG) - ZR(IVPG + ISIG + 3)
 57         CONTINUE
          ENDIF   
        ENDIF  

C  --    CALCUL DE LA DENSITE D'ENERGIE POTENTIELLE ELASTIQUE :
C        ==========================================================
         IF ((OPTION(1:4).EQ.'ENEL') .OR. (OPTION(6:9).EQ.'ELAS')) THEN

C  --      DENSITE D'ENERGIE POTENTIELLE ELASTIQUE AU POINT
C  --      D'INTEGRATION COURANT
C          ---------------------
           CALL R8INIR(NBSM,0.D0,NMM,1)
           CALL R8INIR(NBSM,0.D0,NMF,1)
           CALL R8INIR(NBSM,0.D0,MFF,1)
                     
              DO 70 ISIG = 1, NBSM
                 NMM(ISIG) = EFFINT((IPG-1)*NBSIG + ISIG)
                 MFF(ISIG) = EFFINT((IPG-1)*NBSIG + ISIG +3)
  70          CONTINUE

           DO 600 JSIG = 1, NBSM
              ENELM(IPG)  = ENELM(IPG)  + 0.5D0*NMM(JSIG)*EPS(JSIG)
              ENELF(IPG)  = ENELF(IPG)  + 0.5D0*MFF(JSIG)*KHI(JSIG)
  600      CONTINUE
           ENELT(IPG) = ENELM(IPG) + ENELF(IPG)
           
           ENM = ENM + ENELM(IPG)*POIDS
           ENF = ENF + ENELF(IPG)*POIDS
           ENT = ENT + ENELT(IPG)*POIDS

         ENDIF
C
  20  CONTINUE
C
C ---- RECUPERATION DU CHAMP DES DENSITES D'ENERGIE DE DEFORMATION
C ---- ELASTIQUE EN SORTIE
C      -------------------
      IF(OPTION(1:4) .EQ. 'ENEL') THEN
        CALL JEVECH('PENERDR','E',IDENER)
      ELSE IF(OPTION(1:4) .EQ. 'ENER') THEN
        CALL JEVECH('PENERD1','E',IDENER)
      ENDIF  
C
C --- OPTIONS ENEL_ELGA
C     ==============================
      IF (OPTION(1:9).EQ.'ENEL_ELGA') THEN
         DO 100 IPG = 1, NPG
           ZR(IDENER-1+(IPG-1)*3 +1) = ENELT(IPG)
           ZR(IDENER-1+(IPG-1)*3 +2) = ENELM(IPG)
           ZR(IDENER-1+(IPG-1)*3 +3) = ENELF(IPG)
 100     CONTINUE
C
C --- OPTION ENEL_ELNO_ELGA
C     =======================================
      ELSEIF (OPTION(1:9).EQ.'ENEL_ELNO') THEN
        IF (NPG.EQ.1) THEN
           DO 110 I = 1, NNOEL
              ZR(IDENER-1+(I-1)*3 +1) = ENELT(1)
              ZR(IDENER-1+(I-1)*3 +2) = ENELM(1)
              ZR(IDENER-1+(I-1)*3 +3) = ENELF(1)
 110       CONTINUE
        ELSE
          NCMP = 1
          CALL PPGAN2 ( JGANO, NCMP, ENELT, AUXT)
          CALL PPGAN2 ( JGANO, NCMP, ENELM, AUXM)
          CALL PPGAN2 ( JGANO, NCMP, ENELF, AUXF)
          DO 120 I = 1, NNOEL
             ZR(IDENER-1+(I-1)*3 +1) = AUXT(I)
             ZR(IDENER-1+(I-1)*3 +2) = AUXM(I)
             ZR(IDENER-1+(I-1)*3 +3) = AUXF(I)
 120      CONTINUE
        ENDIF
C
C --- OPTION ENER_ELAS
C     ================
      ELSEIF (OPTION(1:9).EQ.'ENER_ELAS') THEN
        ZR(IDENER   ) = ENT
        ZR(IDENER +1) = ENM
        ZR(IDENER +2) = ENF
      ENDIF

      ELSE
C      OPTION NON DISPONIBLE     
        VALK(1) = OPTION
        VALK(2) = NOMTE
        VALK(3) = ZK16(ICOMPO)
        CALL U2MESK('F','ELEMENTS_88',3,VALK)
      ENDIF

      END
