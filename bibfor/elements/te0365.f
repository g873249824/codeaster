      SUBROUTINE TE0365 ( OPTION, NOMTE )
      IMPLICIT   NONE
      CHARACTER*16        OPTION, NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 22/02/2010   AUTEUR DESOZA T.DESOZA 
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
C  CALCUL DES SECONDS MEMBRES DE CONTACT ET DE FROTTEMENT DE COULOMB STD
C        AVEC LA METHODE CONTINUE DE L'ECP
C  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
C           'CHAR_MECA_FROT' (CALCUL DU SECOND MEMBRE DE
C                              FROTTEMENT STANDARD )
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER      I
      INTEGER      NNE,NNM,NNL
      INTEGER      NDDL,NDIM,NBCPS,NBDM
      INTEGER      INDCO,INADH,INDASP
      INTEGER      IFROTT,IFORM,ICOMPL,IUSURE 
      INTEGER      JPCF,JGEOM,JDEPM,JDEPDE
      INTEGER      JACCM,JVITM,JVITP,JUSUP
      INTEGER      JVECT
      INTEGER      TYPBAR,TYPRAC,NDEXFR
      REAL*8       TAU1(3),TAU2(3)
      REAL*8       NORM(3),MPROJN(3,3),MPROJT(3,3)
      REAL*8       RESE(3),NRESE            
      REAL*8       XPR,YPR,XPC,YPC,HPG,JACOBI   
      REAL*8       VTMP(81)  
      REAL*8       COEFFF,LAMBDA
      REAL*8       COEFCS,COEFCP,COEFCR
      REAL*8       COEFFR,COEFFS,COEFFP
      REAL*8       JEU,JEUSUP
      REAL*8       DELTAT,BETA,GAMMA 
      REAL*8       GEOMAE(9,3),GEOMAM(9,3)       
      REAL*8       GEOMM(3),GEOME(3)
      REAL*8       DLAGRC,DLAGRF(2)
      REAL*8       DDEPLE(3),DDEPLM(3)
      REAL*8       DEPLME(3),DEPLMM(3)      
      REAL*8       ACCME(3),VITME(3),ACCMM(3),VITMM(3)
      REAL*8       VITPE(3),VITPM(3)      
      REAL*8       KAPPAN,KAPPAV,ASPERI                          
      REAL*8       JEUVIT,JEVITP
      REAL*8       PRFUSU
      CHARACTER*8  NOMMAE,NOMMAM
      LOGICAL      LFROTT,LAXIS,LCOMPL
      LOGICAL      LSTABC,LSTABF,LPENAC,LPENAF
      LOGICAL      LADHER,LGLISS
      LOGICAL      DEBUG
      REAL*8       FFE(9),DFFE(2,9),DDFFE(3,9)       
      REAL*8       FFM(9),DFFM(2,9),DDFFM(3,9)   
      REAL*8       FFL(9),DFFL(2,9),DDFFL(3,9)         
C           
      REAL*8       VECTCC(9)
      REAL*8       VECTFF(18)    
      REAL*8       VECTEE(27),VECTMM(27)  
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()         
C
C --- INITIALISATIONS
C
      CALL VECINI(81,0.D0,VTMP  )
      CALL VECINI( 9,0.D0,VECTCC)
      CALL VECINI(18,0.D0,VECTFF)
      CALL VECINI(27,0.D0,VECTEE)
      CALL VECINI(27,0.D0,VECTMM)
      LADHER = .FALSE.
      LGLISS = .FALSE.
      INDASP = 0
      INDCO  = 0
      DEBUG  = .FALSE.
C
C --- RECUPERATION DES DONNEES DU CHAM_ELEM DU CONTACT (VOIR MMCHML)
C
      CALL JEVECH('PCONFR','L',JPCF )
      XPC      =      ZR(JPCF-1+1)
      YPC      =      ZR(JPCF-1+2)
      XPR      =      ZR(JPCF-1+3)
      YPR      =      ZR(JPCF-1+4)
      TAU1(1)  =      ZR(JPCF-1+5)
      TAU1(2)  =      ZR(JPCF-1+6)
      TAU1(3)  =      ZR(JPCF-1+7)
      TAU2(1)  =      ZR(JPCF-1+8)
      TAU2(2)  =      ZR(JPCF-1+9)
      TAU2(3)  =      ZR(JPCF-1+10)
      HPG      =      ZR(JPCF-1+11)
      LAMBDA   =      ZR(JPCF-1+12)
      NDEXFR   = NINT(ZR(JPCF-1+13))
      TYPBAR   = NINT(ZR(JPCF-1+14))
      TYPRAC   = NINT(ZR(JPCF-1+15))
      IFORM    = NINT(ZR(JPCF-1+16))
      COEFCR   =      ZR(JPCF-1+17)
      COEFCS   =      ZR(JPCF-1+18)
      COEFCP   =      ZR(JPCF-1+19)
      IFROTT   = NINT(ZR(JPCF-1+20))
      COEFFF   =      ZR(JPCF-1+21)
      COEFFR   =      ZR(JPCF-1+22)
      COEFFS   =      ZR(JPCF-1+23)
      COEFFP   =      ZR(JPCF-1+24)
      ICOMPL   = NINT(ZR(JPCF-1+25))
      ASPERI   =      ZR(JPCF-1+26)
      KAPPAN   =      ZR(JPCF-1+27)
      KAPPAV   =      ZR(JPCF-1+28)
      IUSURE   = NINT(ZR(JPCF-1+29))
      JEUSUP   =      ZR(JPCF-1+32)
      DELTAT   =      ZR(JPCF-1+33)     
      BETA     =      ZR(JPCF-1+34)
      GAMMA    =      ZR(JPCF-1+35)   
      INDCO    = NINT(ZR(JPCF-1+37))
      INDASP   = NINT(ZR(JPCF-1+38))
      LCOMPL   = ICOMPL.EQ.1
C
C --- TERMES DE STABILISATION
C
      LSTABC = COEFCP.NE.0D0
      LSTABF = COEFFP.NE.0D0
C
C --- TERMES DE PENALISATION
C
      LPENAF=((COEFFR.EQ.0.D0).AND.(COEFFS.EQ.0.D0)
     &       .AND.(COEFFP.NE.0.D0))
      LPENAC=((COEFCR.EQ.0.D0).AND.(COEFCS.EQ.0.D0)
     &       .AND.(COEFCP.NE.0.D0))
C
C --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
C
      CALL JEVECH('PGEOMER','E',JGEOM )
      CALL JEVECH('PDEPL_P','E',JDEPDE)
      CALL JEVECH('PDEPL_M','L',JDEPM )
      IF (IUSURE.EQ.1) CALL JEVECH('PUSULAR','L',JUSUP )
      IF (IFORM.NE.0) THEN
        CALL JEVECH('PVITE_P','L',JVITP )
        CALL JEVECH('PVITE_M','L',JVITM )
        CALL JEVECH('PACCE_M','L',JACCM )
      ENDIF  
C
C --- INFOS SUR LA MAILLE DE CONTACT
C
      LFROTT = IFROTT.EQ.3
      CALL MMELEM(NOMTE ,LFROTT,NDIM  ,NDDL  ,NOMMAE,
     &            NNE   ,NOMMAM,NNM   ,NNL   ,NBCPS ,
     &            NBDM  ,LAXIS )        
C
C --- REACTUALISATION DE LA GEOMETRIE (MAILLAGE+DEPMOI)
C
      CALL MMREAC(NBDM  ,NDIM  ,NNE   ,NNM   ,JGEOM ,
     &            JDEPM ,GEOMAE,GEOMAM)   
C
C --- FONCTIONS DE FORMES ET DERIVEES 
C
      CALL MMFORM(NDIM  ,NOMMAE,NOMMAM,NNE   ,NNM   ,
     &            XPC   ,YPC   ,XPR   ,YPR   ,FFE   ,
     &            DFFE  ,DDFFE ,FFM   ,DFFM  ,DDFFM ,
     &            FFL   ,DFFL  ,DDFFL )
C
C --- MODIFICATIONS DES FF ET DFF POUR ELEMENTS DE BARSOUM
C
      IF (TYPBAR.NE.0) THEN
        CALL MMMFFM(NOMMAE,XPC   ,YPC   ,TYPBAR,FFE   ,
     &              DFFE  )
        CALL MMMFFM(NOMMAM,XPR   ,YPR   ,TYPBAR,FFM   ,
     &              DFFM  )
        CALL MMMFFM(NOMMAE,XPC   ,YPC   ,TYPBAR,FFL   ,
     &              DFFL  )     
      ENDIF      
C
C --- JACOBIEN POUR LE POINT DE CONTACT 
C
      CALL MMMJAC(NOMMAE,GEOMAE,FFE   ,DFFE  ,LAXIS ,
     &            NDIM  ,JACOBI)     
C
C --- CALCUL DE LA NORMALE ET DES MATRICES DE PROJECTION
C  
      CALL MMCALN(NDIM  ,TAU1  ,TAU2  ,NORM  ,MPROJN,
     &            MPROJT)  
C
C --- CALCUL DES COORDONNEES ACTUALISEES
C 
      CALL MMGEOM(NDIM  ,NNE   ,NNM   ,FFE   ,FFM   ,
     &            GEOMAE,GEOMAM,GEOME ,GEOMM ) 
C
C --- CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
C       
      CALL MMLAGM(NBDM  ,NDIM  ,NNL   ,JDEPDE,FFL   ,
     &            DLAGRC,DLAGRF) 
C
C --- MODIF. RACCORD/BARSOUM
C
      CALL MMLAG2(NDIM  ,NBDM  ,NNL   ,JDEPDE,TYPBAR,
     &            TYPRAC,DLAGRC)           
C
C --- MISE A JOUR DES CHAMPS INCONNUS INCREMENTAUX - DEPLACEMENTS
C 
      CALL MMDEPM(NBDM  ,NDIM  ,NNE   ,NNM   ,JDEPM ,
     &            JDEPDE,FFE   ,FFM   ,DDEPLE,DDEPLM ,
     &            DEPLME,DEPLMM)
C
C --- CALCUL DES VITESSES/ACCELERATIONS 
C
      IF (IFORM.EQ.2) THEN
        CALL MMVITM(NBDM  ,NDIM  ,NNE   ,NNM   ,FFE   ,
     &              FFM   ,JVITM ,JACCM ,JVITP ,VITME ,
     &              VITMM ,VITPE ,VITPM ,ACCME ,ACCMM )
      ENDIF
C 
C --- CALCUL USURE
C 
      IF (IUSURE .EQ. 1) THEN
        PRFUSU = ZR(JUSUP-1+1)   
      ELSE
        PRFUSU = 0.D0
      END IF
C
C --- CALCUL DES JEUX
C
      CALL MMMJEU(NDIM,  JEUSUP,PRFUSU,NORM  ,GEOME ,
     &            GEOMM ,DDEPLE,DDEPLM,JEU   )
C
      IF (IFORM.EQ.2) THEN
        CALL MMMJEV(NDIM  ,NORM  ,VITPE ,VITPM ,JEUVIT)
      ENDIF
C
      IF (LCOMPL) THEN
        IF (IFORM.EQ.2) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL MMMJEC(NDIM  ,NORM  ,BETA  ,GAMMA ,DELTAT,
     &              DDEPLE,DDEPLM,DEPLME,DEPLMM,VITME ,
     &              VITMM ,ACCME ,ACCMM ,JEVITP)
      ENDIF       
C
C --- CALCUL DES SECONDS MEMBRES DE CONTACT/FROTTEMENT
C
      IF (OPTION.EQ.'CHAR_MECA_CONT') THEN
        LFROTT = .FALSE.
        IF ((TYPBAR.NE.0).OR.(TYPRAC.NE.0)) THEN
          CALL MMMVEC('CONT',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)
        ELSE
          IF (INDASP.EQ.0) THEN
            CALL MMMVEC('SANS',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)
          ELSE IF (INDASP.EQ.1) THEN
            IF (INDCO.EQ.0) THEN
              CALL MMMVEC('SANS',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)          
            ELSEIF (INDCO.EQ.1) THEN
              CALL MMMVEC('CONT',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)           
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF 
          ELSE
            CALL ASSERT(.FALSE.)        
          ENDIF
        ENDIF   
      ELSE IF (OPTION.EQ.'CHAR_MECA_FROT') THEN
      
        IF (COEFFF.EQ.0.D0) INDCO = 0
        IF (LAMBDA.EQ.0.D0) INDCO = 0
        IF (.NOT.LFROTT)    INDCO = 0
        TYPBAR = 0
        TYPRAC = 0
        NDEXFR = 0    
        IF (INDCO.EQ.0) THEN
          CALL MMMVEC('SANS',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)
        ELSE IF (INDCO.EQ.1) THEN
          CALL TTPRSM(NDIM  ,DDEPLE,DDEPLM,DLAGRF,COEFFR,
     &                TAU1  ,TAU2  ,MPROJT,INADH ,RESE  ,
     &                NRESE ,COEFFP,LPENAF)
          LADHER = INADH.EQ.1
          LGLISS = INADH.EQ.0       
          CALL MMMVEC('FROT',
     &                LSTABC,LPENAC,LCOMPL,LFROTT,LSTABF,
     &                LPENAF,LADHER,LGLISS,NDIM  ,NNE   ,
     &                NNM   ,NNL   ,NBCPS ,NORM  ,TAU1  ,
     &                TAU2  ,MPROJT,HPG   ,FFE   ,FFM   ,
     &                FFL   ,JACOBI,COEFCP,COEFCR,COEFCS,
     &                COEFFP,COEFFR,COEFFS,COEFFF,JEU   ,
     &                LAMBDA,RESE  ,NRESE ,TYPBAR,TYPRAC,
     &                NDEXFR,ASPERI,KAPPAN,KAPPAV,DLAGRC,
     &                DLAGRF,DDEPLE,DDEPLM,JEVITP,VECTEE,
     &                VECTMM,VECTCC,VECTFF)
        ELSE
          CALL ASSERT(.FALSE.)
        END IF
      ELSE
        CALL ASSERT(.FALSE.) 
      END IF
C
C --- ASSEMBLAGE FINAL
C
      CALL MMMVAS(NDIM  ,NNE   ,NNM   ,NNL   ,NBDM  ,
     &            NBCPS ,VECTEE,VECTMM,VECTCC,VECTFF,
     &            VTMP)     
C
C --- RECUPERATION DES VECTEURS 'OUT' (A REMPLIR => MODE ECRITURE)
C
      CALL JEVECH('PVECTUR','E',JVECT )
C
C --- RECOPIE VALEURS FINALES
C
      DO 60 I = 1,NDDL
        ZR(JVECT-1+I) = VTMP(I)
        IF (DEBUG) THEN
          IF (VTMP(I).NE.0.D0) THEN
            WRITE(6,*) 'TE0365: ',I,VTMP(I)
          ENDIF
        ENDIF    
60    CONTINUE
C
      CALL JEDEMA()
      END
