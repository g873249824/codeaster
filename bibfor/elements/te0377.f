      SUBROUTINE TE0377 (OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
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
C     BUT:
C         CALCUL DE L'INDICATEUR D'ERREUR SUR UN ELEMENT 2D
C         AVEC LA METHODE DES RESIDUS EXPLICITES.
C         OPTION : 'ERRE_ELEM_SIGM'
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   OPTION : OPTION DE CALCUL
C IN   NOMTE  : NOM DU TYPE ELEMENT
C
C      SORTIE :
C-------------
C
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER NPG,IPG,NNO,NNOS,TYP,TYPV,IPOIDS,IVF,IDFDE
      INTEGER IGEOM,IBID,IAD,IFOR,IERR,IPES,IROT,IMATE,IVOIS
      INTEGER NBS,NBNA,JNO,NBCMP,ITAB(7),NDIM,JGANO,IRET
      INTEGER JTIME,NIV,IP,IR,IREF1,IREF2,IADE1,IADE2
      INTEGER IAVA1,IAVA2,IAPTM1,IAPTM2,IGD1,IGD2,IACMP
      INTEGER NCMPM1,NCMPM2,IATYMA,INO

      REAL*8 DFDX(9),DFDY(9),HE,HF,POIDS,FORX,FORY,FPX,FPY
      REAL*8 FRX(9),FRY(9),RHO,NOR,NORSIG,R8BID
      REAL*8 TER1,TER2, TER3,ERREST,SIGCAL, NUEST,COEFF
      REAL*8 SG11(3),SG22(3),SG12(3),JAC(3)
      REAL*8 NX(3),NY(3),TX(3),TY(3),CHX(3),CHY(3),ORIEN
      REAL*8 INST,INTE
      REAL*8 SIG11(3),SIG22(3),SIG12(3),DSX,DSY
      
      CHARACTER*2 CODRET,FORM,FORMV,NOEU
      CHARACTER*8 TYPEMA,TYPMAV,TOTO
      CHARACTER*16 PHENOM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      CALL ELREF1(TOTO)
C
      CALL JEVECH ('PGEOMER','L',IGEOM)
      CALL TECACH ('OOO','PCONTNO',3,ITAB,IRET)
      CALL JEVECH ('PFRVOLU','L',IFOR)
      CALL JEVECH ('PERREUR','E',IERR)
      CALL JEVECH ('PTEMPSR','L',JTIME)
      INST=ZR(JTIME-1+1)
      IAD=ITAB(1)
      NBCMP=ITAB(2)/NNO

C ----------------------------------------------------------------------
C ---------------- CALCUL DU PREMIER TERME DE L'ERREUR -----------------
C ----------------------------------------------------------------------
C
C ----- CALCUL DU DIAMETRE HE DU CERCLE CIRCONSCRIT A L'ELEMENT --------
C
      NIV=1 
      CALL UTHK(NOMTE,IGEOM,HE,NDIM,IBID,IBID,IBID,IBID,NIV,IBID)
C
C ----- CALCUL DES LA FORCES DE PESANTEUR ET DE ROTATION ---------------
C ------- INITIALISATION DES FORCES ------------------------------------
C
      FPX=0.D0
      FPY=0.D0
      CALL R8INIR(9,0.D0,FRX,1)
      CALL R8INIR(9,0.D0,FRY,1)
C
C ------- TEST D'EXISTENCE DES CARTES DE PESA ET ROTA ------------------
C
      CALL TECACH('ONN','PPESANR',1,IP,IRET)
      CALL TECACH('ONN','PROTATR',1,IR,IRET)
      IF (IP.NE.0.OR.IR.NE.0) THEN
         CALL JEVECH ('PMATERC','L',IMATE)
         CALL RCCOMA (ZI(IMATE),'ELAS',PHENOM,CODRET)
         CALL RCVALA (ZI(IMATE),' ',PHENOM,1,' ',R8BID,1,'RHO',
     &                 RHO,CODRET,'FM')
C
C ------- CALCUL DE LA FORCE DE PESANTEUR ------------------------------
C
         IF (IP.NE.0) THEN
           CALL JEVECH('PPESANR','L',IPES)
           FPX=RHO*ZR(IPES)*ZR(IPES+1)
           FPY=RHO*ZR(IPES)*ZR(IPES+2)
         ENDIF
C
C ------- CALCUL DE LA FORCE DE ROTATION AUX POINTS DE GAUSS------------
C
         IF (IR.NE.0)THEN
           CALL JEVECH('PROTATR','L',IROT)
           CALL RESROT (ZR(IROT),ZR(IGEOM),ZR(IVF),RHO,NNO,NPG,FRX,FRY)
         ENDIF
      ENDIF
C
C ----- CALCUL DU TERME D'ERREUR AVEC INTEGRATION DE GAUSS -------------
C
      TER1=0.D0
      NORSIG=0.D0
C
      DO 10 IPG=1,NPG
C
C ------- CALCUL DES DERIVEES DES FONCTIONS DE FORMES /X ET /Y ---------
C
        CALL DFDM2D (NNO,IPG,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
C
C ------- CALCUL L'ORIENTATION DE LA MAILLE ----------------------------
C
C        CALL VERIOR(NNO,IPG,IGEOM,IDFDE,ORIEN)
        CALL UTJAC(.TRUE.,IGEOM,IPG,IDFDE,0,IBID,NNO,ORIEN)
C
C ------- CALCUL DE LA DIVERGENCE ET DE LA NORME DE SIGMA --------------
C
        CALL ERE2D1(NOMTE,NNO,IPG,IGEOM,IVF,IAD,NBCMP,DFDX,DFDY,
     &              POIDS,DSX,DSY,NOR)
C
C ------- CALCUL DE L'EFFORT VOLUMIQUE ---------------------------------
C
        FORX=ZR(IFOR-1+2*(IPG-1)+1)+FPX+FRX(IPG)
        FORY=ZR(IFOR-1+2*(IPG-1)+2)+FPY+FRY(IPG)
C
C ------- CALCUL DU TERME D'ERREUR AVEC INTEGRATION DE GAUSS -----------
C
        TER1=TER1+((FORX+DSX)**2+(FORY+DSY)**2)*POIDS
C
C ------- CALCUL DE LA NORME DE SIGMA SUR L'ELEMENT --------------------
C
        NORSIG=NORSIG+NOR*POIDS
C
  10  CONTINUE
C
      TER1=HE*SQRT(TER1)
C     
C ----------------------------------------------------------------------
C ------------ FIN DU CALCUL DU PREMIER TERME DE L'ERREUR --------------
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C ----------- CALCUL DU DEUXIEME ET TROISIEME TERME DE L'ERREUR --------
C ----------------------------------------------------------------------
C
      CALL JEVECH('PFORCE','L',IREF1)
      CALL JEVECH('PPRESS','L',IREF2)
      CALL JEVECH('PVOISIN','L',IVOIS)
C
C ----- TEST SUR LE TYPE DE LA MAILLE COURANTE -------------------------
C
      TYP=ZI(IVOIS+7)
      IATYMA=ZI(IREF1+3)
      TYPEMA=ZK8(IATYMA-1+TYP)      
C
      FORM=TYPEMA(1:2)
      IF (FORM.EQ.'TR') THEN
        NBS=3
        ELSE
        NBS=4
      ENDIF
      NOEU=TYPEMA(5:5)
      IF (NOEU.EQ.'6'.OR.NOEU.EQ.'8'.OR.NOEU.EQ.'9') THEN
        NBNA=3
        ELSE
        NBNA=2
      ENDIF
C
C ----- BOUCLE SUR LES ARETES ------------------------------------------
C
      TER2=0.D0
      TER3=0.D0
      DO 20 INO=1,NBS
C
C ----- TEST DU TYPE DE VOISIN -----------------------------------------
C
        TYPV=ZI(IVOIS+7+INO)
        IF (TYPV.NE.0) THEN
          TYPMAV=ZK8(IATYMA-1+TYPV)      
          FORMV=TYPMAV(1:2)
C
C ----- CALCUL DU DIAMETRE HF DU CERCLE CIRCONSCRIT � L'ARETE ----------
C
          IF (INO.EQ.NBS) THEN
            JNO = 1
            ELSE
            JNO = INO+1
          ENDIF
          HF=SQRT((ZR(IGEOM-1+2*(INO-1)+1)-ZR(IGEOM-1+2*(JNO-1)+1))**2
     &           +(ZR(IGEOM-1+2*(INO-1)+2)-ZR(IGEOM-1+2*(JNO-1)+2))**2)
C
C ----- CALCUL DE NORMALES, TANGENTES ET JACOBIENS AUX POINTS DE L'ARETE
C
C         CALL CALNOR(INO,NBS,NBNA,IGEOM,NOMTE,ORIEN,HF,JAC,NX,NY,TX,TY)
          CALL CALNOR('2D',INO,IBID,IBID,NBS,NBNA,IBID,IGEOM,IBID,
     &                IBID,IBID,NOMTE,ORIEN,HF,
     &                JAC,NX,NY,R8BID,TX,TY)
C
C ----------------------------------------------------------------------
C --------------- CALCUL DU DEUXIEME TERME DE L'ERREUR -----------------
C ----------------------------------------------------------------------
C
          IF (FORMV.EQ.'TR'.OR.
     &        FORMV.EQ.'QU') THEN
C
C ------- CALCUL DU SAUT DE CONTRAINTE ENTRE ELEMENTS ------------------
C
            CALL ERE2D2(INO,TYPEMA,TYPMAV,IREF1,IVOIS,IAD,NBCMP,
     &                  SG11,SG22,SG12)
C
C ------- CALCUL DE L'INTEGRALE SUR LE BORD ----------------------------
C     
            CALL R8INIR(3,0.D0,CHX,1)
            CALL R8INIR(3,0.D0,CHY,1)
C
            CALL INTENC(NBNA,JAC,CHX,CHY,SG11,SG22,SG12,NX,NY,INTE)
C
C ------- CALCUL DU TERME D'ERREUR AVEC INTEGRATION DE NEWTON-COTES ----
C
            TER2=TER2+0.5D0*SQRT(HF)*SQRT(INTE)
C
C ----------------------------------------------------------------------
C --------------- CALCUL DU TROISIEME TERME DE L'ERREUR ----------------
C ----------------------------------------------------------------------
C
          ELSE IF (FORMV.EQ.'SE') THEN
C
C ------- CALCUL EFFORTS SURFACIQUES ET DES CONTRAINTES ----------------
C
            CALL ERE2D3(INO,IREF1,IREF2,IVOIS,IGEOM,IAD,TYPEMA,NBCMP,
     &                  INST,NX,NY,TX,TY,SIG11,SIG22,SIG12,CHX,CHY)
C
C ------- CALCUL DE L'INTEGRALE SUR LE BORD ----------------------------
C     
            CALL INTENC(NBNA,JAC,CHX,CHY,SIG11,SIG22,SIG12,NX,NY,INTE)
C
C ------- CALCUL DU TERME D'ERREUR AVEC INTEGRATION DE NEWTON-COTES ----
C
            TER3=TER3+SQRT(HF)*SQRT(INTE)
C
        ENDIF
C
      ENDIF
C
  20  CONTINUE
C
C ----------------------------------------------------------------------
C ------- FIN DU CALCUL DU DEUXIEME ET TROISIEME TERME DE L'ERREUR -----
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C ------------ MISE EN MEMOIRE DES DIFFERENTS TERMES DE IERR -----------
C ----------------------------------------------------------------------
C
      IF (NBNA.EQ.3) THEN
        COEFF=SQRT(96.D0)
        ELSE
        COEFF=SQRT(24.D0)
      ENDIF
C
      ERREST=(TER1+TER2+TER3)/COEFF
      SIGCAL=SQRT(NORSIG)
      NUEST=100.D0*SQRT(ERREST**2/(ERREST**2+NORSIG))
C
      ZR(IERR)=ERREST
      ZR(IERR+1)=NUEST
      ZR(IERR+2)=SIGCAL
C
      ERREST=TER1/COEFF
      NUEST=100.D0*SQRT(ERREST**2/(ERREST**2+NORSIG))
C
      ZR(IERR+3)=ERREST
      ZR(IERR+4)=NUEST
C
      ERREST=TER3/COEFF
      NUEST=100.D0*SQRT(ERREST**2/(ERREST**2+NORSIG))
C
      ZR(IERR+5)=ERREST
      ZR(IERR+6)=NUEST
C
      ERREST=TER2/COEFF
      NUEST=100.D0*SQRT(ERREST**2/(ERREST**2+NORSIG))
C
      ZR(IERR+7)=ERREST
      ZR(IERR+8)=NUEST
C
      CALL JEDEMA()
C
      END
