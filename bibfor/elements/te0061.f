       SUBROUTINE TE0061(OPTION,NOMTE)
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
C TOLE CRP_20
C     BUT: CALCUL DU SECOND MEMBRE ELEMENTAIRE EN THERMIQUE CORRESPON-
C          DANT A UN PROBLEME TRANSITOIRE
C          ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'CHAR_THER_EVOL'
C          OPTION : 'CHAR_SENS_EVOL'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       25/01/02 (OB): MODIFICATIONS POUR INSERER LES ARGUMENTS OPTION
C        NELS PERMETTANT D'UTILISER CETTE ROUTINE POUR CALCULER LA
C        SENSIBILITE PAR RAPPORT AUX CARACTERISTIQUES MATERIAU.
C        + MODIFS FORMELLES: IMPLICIT NONE, IDENTATION...
C       08/03/02 (OB): CORRECTION BUG EN STATIONNAIRE SI RHO_CP ABSENT
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

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

      INTEGER         NBRES,NBPT
      PARAMETER      ( NBRES = 4 )
      PARAMETER      ( NBPT  = 8 )
      CHARACTER*8     NOMRES(NBRES),ELREFE
      CHARACTER*2     CODRET(NBRES)
      CHARACTER*16    NOMTE,OPTION,PHENOM,PHESEN
      CHARACTER*24    CHVAL,CHCTE
      REAL*8          VALRES(NBRES),VALPAR(1),THETA,LAMBOR(3),POINT(3),
     &                DFDX(27),DFDY(27),DFDZ(27),TEM,POIDS,VECTT(NBPT),
     &                DIRE(3),ORIG(3),LAMBDA,FLUGLO(3),FLULOC(3),P(3,3),
     &                ANGL(3),PREC,CPS,LAMBS,LAMBOS(3),TRACE,DTEMPX,
     &                DTEMPY,DTEMPZ,DTEMMX,DTEMMY,DTEMMZ,FLULOS(3),
     &                FLUGLS(3),TEMS,R8PREM,ZERO,DELTAT,CP,R8DGRD,ALPHA,
     &                BETA,DTEMDX,DTEMDY,DTEMDZ
      INTEGER         IPOIDS,IVF,IDFDE,IDFDN,IDFDK,IGEOM,IMATE,IMATSE,
     &                NNO,KP,NPG1,I,ITEMP,ITPS,NBPG(10),IVAPRI,IVAPRM,
     &                TETYPS,N1,N2,JIN,NDIM,NBFPG,JVAL,IVECTT,
     &                ICAMAS,L,K,NUNO,INO
      LOGICAL         ANISO,GLOBAL,LSENS,LSTAT

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      CALL ELREF1(ELREFE)
      ZERO = 0.0D0
      PREC = R8PREM()
      CHCTE = '&INEL.'//ELREFE//'.CARACTE'
      CALL JEVETE(CHCTE,'L',JIN)
      NDIM  = ZI(JIN+1-1)
      NNO   = ZI(JIN+2-1)
      NBFPG = ZI(JIN+3-1)
      DO 10 I = 1,NBFPG
        NBPG(I) = ZI(JIN+3-1+I)
  10  CONTINUE
      NPG1 = NBPG(1)
      CHVAL = '&INEL.'//ELREFE//'.FFORMES'
      CALL JEVETE(CHVAL,'L',JVAL)
      IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      IVF    = IPOIDS + NPG1
      IDFDE  = IVF    + NPG1*NNO
      IDFDN  = IDFDE  + 1
      IDFDK  = IDFDN  + 1

C====
C 1.2 PREALABLES LIES AUX CALCULS DE SENSIBILITE
C====
C CALCUL DE SENSIBILITE PART I
      LSTAT = .FALSE.
      IF (OPTION(6:9).EQ.'SENS') THEN
        LSENS = .TRUE.
        CALL JEVECH('PMATSEN','L',IMATSE)
        CALL JEVECH('PVAPRIN','L',IVAPRI)
        CALL TECACH(.TRUE.,.FALSE.,'PVAPRMO',1,IVAPRM)
C DANS LE CAS DES DERIVEES MATERIAUX:
C L'ABSENCE DE CE CHAMP DETERMINE LE CRITERE STATIONNAIRE OU PAS
C ON "TRUANDE" ALORS DE MANIERE PEU OPTIMALE MAIS FACILE A MAINTE
C NIR: CP ET/OU CPS SONT ANNULES ET ON CREE UN CHAMP T- BIDON.
        IF (IVAPRM.EQ.0) THEN
          LSTAT = .TRUE.
          IVAPRM = IVAPRI
        ENDIF
      ELSE
        LSENS = .FALSE.
      ENDIF

C====
C 1.3 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====
      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PMATERC','L',IMATE )
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PTEMPER','L',ITEMP )
      CALL JEVECH('PTEMPSR','L',ITPS  )
      VALPAR(1) = ZR(ITPS)
      DELTAT    = ZR(ITPS+1)
      THETA     = ZR(ITPS+2)
      CALL RCCOMA ( ZI(IMATE), 'THER', PHENOM, CODRET )

C CALCUL DE SENSIBILITE PART II. TEST DE COHERENCE PHENOM STD/
C PHENOM MAT DERIVEE
      IF (LSENS) THEN
        CALL RCCOMA ( ZI(IMATSE), 'THER', PHESEN, CODRET )
        IF (PHESEN.NE.PHENOM)
     &    CALL UTMESS('F','TE0061','! PB PHESEN.NE.PHENOM !')
      ENDIF

C====
C 1.4 PREALABLES LIES A LA RECUPERATION DES DONNEES MATERIAUX
C====
      IF ( PHENOM .EQ. 'THER') THEN
        NOMRES(1) = 'LAMBDA'
        NOMRES(2) = 'RHO_CP'
        ANISO  = .FALSE.
        IF (LSTAT) THEN
C EN SENSIBILITE, CAS STATIONNAIRE OU PREMIER PAS DE TEMPS: ON A
C JUSTE BESOIN DE LAMBDA
          CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,1,
     &                NOMRES,VALRES,CODRET,'FM')
          LAMBDA = VALRES(1)
          CP     = 0.D0
        ELSE
C IDEM CAS TRANSITOIRE A PARTIR DU SECOND PAS DE TEMPS
          CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,2,
     &                NOMRES,VALRES,CODRET,'FM')
          LAMBDA = VALRES(1)
          CP     = VALRES(2)
        ENDIF

C CALCUL DE SENSIBILITE PART III (ISOTROPE)
        IF (LSENS) THEN
          IF (LSTAT) THEN
            CALL RCVALA(ZI(IMATSE),PHENOM,1,'INST',VALPAR,1,
     &                  NOMRES,VALRES,CODRET,'FM')
            LAMBS = VALRES(1)
            CPS   = 0.D0
          ELSE
            CALL RCVALA(ZI(IMATSE),PHENOM,1,'INST',VALPAR,2,
     &                  NOMRES,VALRES,CODRET,'FM')
            LAMBS = VALRES(1)
            CPS   = VALRES(2)
          ENDIF
          IF ((ABS(CPS).LT.PREC).AND.(ABS(LAMBS).LT.PREC)) THEN
C PAS DE TERME DE SENSIBILITE SUPPLEMENTAIRE, CALCUL INSENSIBLE
            TETYPS = 0
          ELSE IF (ABS(CPS).LT.PREC) THEN
C SENSIBILITE PAR RAPPORT A LAMBDA
            TETYPS = 1
          ELSE IF (ABS(LAMBS).LT.PREC) THEN
C SENSIBILITE PAR RAPPORT A CP
            TETYPS = 2
          ENDIF
        ELSE
C CALCUL STD
          TETYPS = 0
        ENDIF
      ELSEIF ( PHENOM .EQ. 'THER_ORTH') THEN
         NOMRES(1) = 'LAMBDA_L'
         NOMRES(2) = 'LAMBDA_T'
         NOMRES(3) = 'LAMBDA_N'
         NOMRES(4) = 'RHO_CP'
         ANISO     = .TRUE.
         IF (LSTAT) THEN
           CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,3,
     &                 NOMRES,VALRES,CODRET,'FM')
           LAMBOR(1) = VALRES(1)
           LAMBOR(2) = VALRES(2)
           LAMBOR(3) = VALRES(3)
           CP        = 0.D0
         ELSE
           CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,4,
     &                 NOMRES,VALRES,CODRET,'FM')
           LAMBOR(1) = VALRES(1)
           LAMBOR(2) = VALRES(2)
           LAMBOR(3) = VALRES(3)
           CP        = VALRES(4)
         ENDIF
C CALCUL DE SENSIBILITE PART III BIS (ANISOTROPE)
        IF (LSENS) THEN
          IF (LSTAT) THEN
            CALL RCVALA(ZI(IMATSE),PHENOM,1,'INST',VALPAR,3,
     &                  NOMRES,VALRES,CODRET,'FM')
            LAMBOS(1) = VALRES(1)
            LAMBOS(2) = VALRES(2)
            LAMBOS(3) = VALRES(3)
            CPS       = 0.D0
          ELSE
            CALL RCVALA(ZI(IMATSE),PHENOM,1,'INST',VALPAR,4,
     &                  NOMRES,VALRES,CODRET,'FM')
            LAMBOS(1) = VALRES(1)
            LAMBOS(2) = VALRES(2)
            LAMBOS(3) = VALRES(3)
            CPS       = VALRES(4)
          ENDIF
          TRACE = LAMBOS(1) + LAMBOS(2) + LAMBOS(3)
          IF ((ABS(CPS).LT.PREC).AND.(ABS(TRACE).LT.PREC)) THEN
            TETYPS = 0
          ELSE IF (ABS(CPS).LT.PREC) THEN
            TETYPS = 1
          ELSE IF (ABS(TRACE).LT.PREC) THEN
            TETYPS = 2
          ENDIF
        ELSE
          TETYPS = 0
        ENDIF
      ELSE
         CALL UTMESS ('F','TE0061','COMPORTEMENT NON TROUVE')
      ENDIF

C====
C 1.5 PREALABLES LIES A L'ANISOTROPIE
C====
      IF ( ANISO ) THEN
         CALL JEVECH('PCAMASS','L',ICAMAS)
         IF (ZR(ICAMAS).GT.ZERO) THEN
           GLOBAL  = .TRUE.
           ANGL(1) = ZR(ICAMAS+1)*R8DGRD()
           ANGL(2) = ZR(ICAMAS+2)*R8DGRD()
           ANGL(3) = ZR(ICAMAS+3)*R8DGRD()
           CALL MATROT ( ANGL , P )
         ELSE
           GLOBAL  = .FALSE.
           ALPHA   = ZR(ICAMAS+1)*R8DGRD()
           BETA    = ZR(ICAMAS+2)*R8DGRD()
           DIRE(1) =  COS(ALPHA)*COS(BETA)
           DIRE(2) =  SIN(ALPHA)*COS(BETA)
           DIRE(3) = -SIN(BETA)
           ORIG(1) = ZR(ICAMAS+4)
           ORIG(2) = ZR(ICAMAS+5)
           ORIG(3) = ZR(ICAMAS+6)
          ENDIF
        ENDIF

C====
C 2. CALCULS TERMES DE RIGIDITE ET DE MASSE (STD ET/OU SENSIBLE)
C    POUR LES ELEMENTS NON LUMPES
C====

      IF ((NOMTE(12:13).NE.'_D'.AND.NOMTE(11:12).NE.'_D').OR.
     +     NOMTE(6:10).EQ.'PYRAM') THEN

C ---  BOUCLE SUR LES POINTS DE GAUSS :
C      ------------------------------
        DO 20 KP=1,NPG1

          L=(KP-1)*NNO
          K=(KP-1)*NNO*3
          CALL DFDM3D( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     +                 ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS )

          TEM    = ZERO
          DTEMDX = ZERO
          DTEMDY = ZERO
          DTEMDZ = ZERO

          DO 40 I=1,NNO
C CALCUL DE T- (OU (DT/DS)- EN SENSI) ET DE SON GRADIENT
            TEM    = TEM    + ZR(ITEMP+I-1) * ZR(IVF+L+I-1)
            DTEMDX = DTEMDX + ZR(ITEMP+I-1) * DFDX(I)
            DTEMDY = DTEMDY + ZR(ITEMP+I-1) * DFDY(I)
            DTEMDZ = DTEMDZ + ZR(ITEMP+I-1) * DFDZ(I)
40        CONTINUE

C CALCUL DE SENSIBILITE PART IV
          IF (TETYPS.EQ.1) THEN
            DTEMPX = ZERO
            DTEMPY = ZERO
            DTEMPZ = ZERO
            DTEMMX = ZERO
            DTEMMY = ZERO
            DTEMMZ = ZERO
            DO 41 I=1,NNO
C CALCUL DE GRAD(T+) ET DE GRAD(T-) POUR TERME DE RIGIDITE
              DTEMPX = DTEMPX + ZR(IVAPRI+I-1) * DFDX(I)
              DTEMPY = DTEMPY + ZR(IVAPRI+I-1) * DFDY(I)
              DTEMPZ = DTEMPZ + ZR(IVAPRI+I-1) * DFDZ(I)
              DTEMMX = DTEMMX + ZR(IVAPRM+I-1) * DFDX(I)
              DTEMMY = DTEMMY + ZR(IVAPRM+I-1) * DFDY(I)
              DTEMMZ = DTEMMZ + ZR(IVAPRM+I-1) * DFDZ(I)
41          CONTINUE
          ELSE IF (TETYPS.EQ.2) THEN
            TEMS = ZERO
            DO 42 I=1,NNO
C CALCUL DE (T- - T+) POUR TERME DE MASSE
              TEMS=TEMS+(ZR(IVAPRM+I-1)-ZR(IVAPRI+I-1))*ZR(IVF+L+I-1)
42          CONTINUE
          ENDIF

          IF ( .NOT.ANISO ) THEN
            FLUGLO(1) = LAMBDA*DTEMDX
            FLUGLO(2) = LAMBDA*DTEMDY
            FLUGLO(3) = LAMBDA*DTEMDZ
C CALCUL DE SENSIBILITE PART V (SENSIBILITE / LAMBDA EN ISOTROPE)
            IF (TETYPS.EQ.1) THEN
              FLUGLS(1)=LAMBS*(THETA*DTEMPX+(1.D0-THETA)*DTEMMX)
              FLUGLS(2)=LAMBS*(THETA*DTEMPY+(1.D0-THETA)*DTEMMY)
              FLUGLS(3)=LAMBS*(THETA*DTEMPZ+(1.D0-THETA)*DTEMMZ)
            ENDIF
          ELSE
            IF (.NOT.GLOBAL) THEN
              POINT(1)= ZERO
              POINT(2)= ZERO
              POINT(3)= ZERO
              DO 30 NUNO=1,NNO
                POINT(1)=POINT(1)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-3)
                POINT(2)=POINT(2)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-2)
                POINT(3)=POINT(3)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-1)
 30           CONTINUE
              CALL UTRCYL(POINT,DIRE,ORIG,P)
            ENDIF
            FLUGLO(1) = DTEMDX
            FLUGLO(2) = DTEMDY
            FLUGLO(3) = DTEMDZ
            N1 = 1
            N2 = 3
            CALL UTPVGL ( N1, N2, P, FLUGLO, FLULOC )
            FLULOC(1) = LAMBOR(1)*FLULOC(1)
            FLULOC(2) = LAMBOR(2)*FLULOC(2)
            FLULOC(3) = LAMBOR(3)*FLULOC(3)
            N1 = 1
            N2 = 3
            CALL UTPVLG ( N1, N2, P, FLULOC, FLUGLO )
C CALCUL DE SENSIBILITE PART V BIS (SENSIBILITE / LAMBDA EN ANISOTROPE)
            IF (TETYPS.EQ.1) THEN
              FLUGLS(1) = THETA*DTEMPX+(1.D0-THETA)*DTEMMX
              FLUGLS(2) = THETA*DTEMPY+(1.D0-THETA)*DTEMMY
              FLUGLS(3) = THETA*DTEMPZ+(1.D0-THETA)*DTEMMZ
              N1 = 1
              N2 = 3
              CALL UTPVGL ( N1, N2, P, FLUGLS, FLULOS )
              FLULOS(1) = LAMBOS(1)*FLULOS(1)
              FLULOS(2) = LAMBOS(2)*FLULOS(2)
              FLULOS(3) = LAMBOS(3)*FLULOS(3)
              N1 = 1
              N2 = 3
              CALL UTPVLG ( N1, N2, P, FLULOS, FLUGLS )
            ENDIF
          ENDIF

          DO 50 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + POIDS *
     &         (CP/DELTAT*ZR(IVF+L+I-1)*TEM -
     &         (1.0D0-THETA)*(DFDX(I)*FLUGLO(1) +DFDY(I)*FLUGLO(2) +
     &                       DFDZ(I)*FLUGLO(3)))
50        CONTINUE
C CALCUL DE SENSIBILITE PART VI (SENSIBILITE / LAMBDA).
          IF (TETYPS.EQ.1) THEN
            DO 51 I=1,NNO
              ZR(IVECTT+I-1) = ZR(IVECTT+I-1) - POIDS*(DFDX(I)*
     &           FLUGLS(1)+DFDY(I)*FLUGLS(2)+DFDZ(I)*FLUGLS(3))
51          CONTINUE
C SENSIBILITE / CP
          ELSE IF (TETYPS.EQ.2) THEN
            DO 52 I=1,NNO
              ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + POIDS*CPS/DELTAT*
     &                         ZR(IVF+L+I-1)*TEMS
52          CONTINUE
          ENDIF
20      CONTINUE

      ELSE

        DO 200 INO = 1, NBPT
          VECTT(INO) = ZERO
 200    CONTINUE

C====
C 3.1 CALCULS TERMES DE RIGIDITE (STD ET/OU SENSIBLE)
C    POUR LES ELEMENTS LUMPES
C====

C ---   BOUCLE SUR LES POINTS DE GAUSS :
C       ------------------------------
        DO 210 KP=1,NPG1

          L=(KP-1)*NNO
          K=(KP-1)*NNO*3
          CALL DFDM3D( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     +                 ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS )

          DTEMDX = ZERO
          DTEMDY = ZERO
          DTEMDZ = ZERO
          DO 230 I=1,NNO
C CALCUL DE GRAD(T-) (OU GRAD((DT/DS)-) EN SENSIBILITE)
            DTEMDX = DTEMDX + ZR(ITEMP+I-1) * DFDX(I)
            DTEMDY = DTEMDY + ZR(ITEMP+I-1) * DFDY(I)
            DTEMDZ = DTEMDZ + ZR(ITEMP+I-1) * DFDZ(I)
230       CONTINUE

C CALCUL DE SENSIBILITE PART VII (SENSIBILITE / LAMBDA)
          IF (TETYPS.EQ.1) THEN
            DTEMPX = ZERO
            DTEMPY = ZERO
            DTEMPZ = ZERO
            DTEMMX = ZERO
            DTEMMY = ZERO
            DTEMMZ = ZERO
            DO 231 I=1,NNO
C CALCUL DE GRAD(T+) ET DE GRAD(T-)
              DTEMPX = DTEMPX + ZR(IVAPRI+I-1) * DFDX(I)
              DTEMPY = DTEMPY + ZR(IVAPRI+I-1) * DFDY(I)
              DTEMPZ = DTEMPZ + ZR(IVAPRI+I-1) * DFDZ(I)
              DTEMMX = DTEMMX + ZR(IVAPRM+I-1) * DFDX(I)
              DTEMMY = DTEMMY + ZR(IVAPRM+I-1) * DFDY(I)
              DTEMMZ = DTEMMZ + ZR(IVAPRM+I-1) * DFDZ(I)
231         CONTINUE
          ENDIF
          IF ( .NOT.ANISO ) THEN
            FLUGLO(1) = LAMBDA*DTEMDX
            FLUGLO(2) = LAMBDA*DTEMDY
            FLUGLO(3) = LAMBDA*DTEMDZ
C CALCUL DE SENSIBILITE PART VIII (SENSIBILITE / LAMBDA EN ISOTROPE)
            IF (TETYPS.EQ.1) THEN
              FLUGLS(1)=LAMBS*(THETA*DTEMPX+(1.D0-THETA)*DTEMMX)
              FLUGLS(2)=LAMBS*(THETA*DTEMPY+(1.D0-THETA)*DTEMMY)
              FLUGLS(3)=LAMBS*(THETA*DTEMPZ+(1.D0-THETA)*DTEMMZ)
            ENDIF
          ELSE
            IF (.NOT.GLOBAL) THEN
              POINT(1) = ZERO
              POINT(2) = ZERO
              POINT(3) = ZERO
              DO 220 NUNO=1,NNO
                POINT(1)=POINT(1)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-3)
                POINT(2)=POINT(2)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-2)
                POINT(3)=POINT(3)+ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-1)
 220          CONTINUE
              CALL UTRCYL(POINT,DIRE,ORIG,P)
            ENDIF
            FLUGLO(1) = DTEMDX
            FLUGLO(2) = DTEMDY
            FLUGLO(3) = DTEMDZ
            N1 = 1
            N2 = 3
            CALL UTPVGL ( N1, N2, P, FLUGLO, FLULOC )
            FLULOC(1) = LAMBOR(1)*FLULOC(1)
            FLULOC(2) = LAMBOR(2)*FLULOC(2)
            FLULOC(3) = LAMBOR(3)*FLULOC(3)
            N1 = 1
            N2 = 3
            CALL UTPVLG ( N1, N2, P, FLULOC, FLUGLO )
C CALCUL DE SENSIBILITE PART VIII BIS (SENSIBILITE/LAMBDA EN ANISOTROPE)
            IF (TETYPS.EQ.1) THEN
              FLUGLS(1) = THETA*DTEMPX+(1.D0-THETA)*DTEMMX
              FLUGLS(2) = THETA*DTEMPY+(1.D0-THETA)*DTEMMY
              FLUGLS(3) = THETA*DTEMPZ+(1.D0-THETA)*DTEMMZ
              N1 = 1
              N2 = 3
              CALL UTPVGL ( N1, N2, P, FLUGLS, FLULOS )
              FLULOS(1) = LAMBOS(1)*FLULOS(1)
              FLULOS(2) = LAMBOS(2)*FLULOS(2)
              FLULOS(3) = LAMBOS(3)*FLULOS(3)
              N1 = 1
              N2 = 3
              CALL UTPVLG ( N1, N2, P, FLULOS, FLUGLS )
            ENDIF
          ENDIF

C --- AFFECTATION DES TERMES DE RIGIDITE :
C     ----------------------------------
          DO 240 I=1,NNO
            VECTT(I) = VECTT(I) - POIDS *
     +         ((1.0D0-THETA)*( DFDX(I)*FLUGLO(1) + DFDY(I)*FLUGLO(2)+
     +                          DFDZ(I)*FLUGLO(3) ) )
240       CONTINUE
C CALCUL DE SENSIBILITE PART IX (SENSIBILITE / LAMBDA).
          IF (TETYPS.EQ.1) THEN
            DO 241 I=1,NNO
              VECTT(I) = VECTT(I) - POIDS*(DFDX(I)*FLUGLS(1)+DFDY(I)*
     &                   FLUGLS(2)+DFDZ(I)*FLUGLS(3))
241         CONTINUE
          ENDIF
210     CONTINUE

C====
C 3.2 CALCULS TERMES DE MASSE (STD ET/OU SENSIBLE)
C    POUR LES ELEMENTS LUMPES
C====
        NPG1   = NNO
        IVF    = JVAL
        IDFDE  = IVF    + NPG1*NNO
        IDFDN  = IDFDE  + 1
        IDFDK  = IDFDN  + 1

C ---   BOUCLE SUR LES POINTS DE GAUSS :
C       ------------------------------
        DO 250 KP=1,NPG1

          L=(KP-1)*NNO
          K=(KP-1)*NNO*3
          CALL DFDM3D( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     &                 ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS )
          TEM    = ZERO
          DO 260 I=1,NNO
C CALCUL DE T- (OU (DT/DS)- EN SENSI)
            TEM = TEM + ZR(ITEMP+I-1) * ZR(IVF+L+I-1)
260       CONTINUE
C CALCUL DE SENSIBILITE PART X (SENSIBILITE / CP).
         IF (TETYPS.EQ.2) THEN
           TEMS = ZERO
           DO 261 I=1,NNO
C CALCUL DE (T- - T+)
             TEMS=TEMS+(ZR(IVAPRM+I-1)-ZR(IVAPRI+I-1))*ZR(IVF+L+I-1)
261        CONTINUE
         ENDIF

C --- AFFECTATION DU TERME DE MASSE :
C     -----------------------------
          DO 270 I=1,NNO
            VECTT(I) = VECTT(I) + POIDS*CP/DELTAT*ZR(IVF+L+I-1)*TEM
270       CONTINUE
C CALCUL DE SENSIBILITE PART XI (SENSIBILITE / CP)
          IF (TETYPS.EQ.2) THEN
            DO 271 I=1,NNO
              VECTT(I)=VECTT(I)+POIDS*CPS/DELTAT*ZR(IVF+L+I-1)*TEMS
271         CONTINUE
          ENDIF
250     CONTINUE

C --- AFFECTATION DU VECTEUR EN SORTIE :
C     --------------------------------
        DO 280 I=1,NNO
          ZR(IVECTT+I-1) = VECTT(I)
280     CONTINUE
      ENDIF

      END
