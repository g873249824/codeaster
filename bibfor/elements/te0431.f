      SUBROUTINE TE0431(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/06/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          EN 2D (CPLAN ET DPLAN) ET AXI
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      CHARACTER*2 CODRES
      CHARACTER*8 NOMRES(2)
      INTEGER NNO,NPG,I,IMATUU,LGPG,LGPG1,NDIM,NNOS,JGANO
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE,ICAMAS
      INTEGER ITREF,ICONTM,IVARIM,ITEMPM,ITEMPP
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,IVARIX,IRET
      INTEGER ICACOQ,KPG,N,J,KKD,M,J1,COD(9)
      INTEGER KK,JTAB(7),JCRET
      REAL*8 DFF(2,8)
      REAL*8 ALPHA,BETA,DIR11(3),VFF(8),B(3,8),JAC,VALRES(2),SIG
      REAL*8 TEMPM,TEMPP,DEPS,TMP,RIG,DENSIT,SIGM,EPSM
      REAL*8 R8VIDE,ANGMAS(3),R8DGRD
      LOGICAL MATSYM,VECTEU,MATRIC

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      VECTEU = ((OPTION.EQ.'FULL_MECA').OR.(OPTION.EQ.'RAPH_MECA').OR.
     &        (OPTION.EQ.'FORC_NODA').OR.(OPTION.EQ.'CHAR_MECA_TEMP_R'))
      MATRIC = ((OPTION.EQ.'FULL_MECA').OR.(OPTION.EQ.'RIGI_MECA_TANG')
     &          .OR.(OPTION.EQ.'RIGI_MECA'))


C - FONCTIONS DE FORMES ET POINTS DE GAUSS

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCACOQU','L',ICACOQ)
      
      IF (OPTION.EQ.'FORC_NODA') THEN
        CALL JEVECH('PCONTMR','L',ICONTM)
      ELSE IF (OPTION.EQ.'CHAR_MECA_TEMP_R') THEN
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PTEREF','L',ITREF)
        CALL JEVECH('PTEMPSR','L',IINSTM)
        CALL JEVECH('PTEMPER','L',ITEMPM)        
      ELSE IF (OPTION.EQ.'FULL_MECA'.OR.OPTION.EQ.'RAPH_MECA'.OR.
     &         OPTION.EQ.'RIGI_MECA_TANG') THEN
        CALL JEVECH('PCONTMR','L',ICONTM)
        CALL JEVECH('PCARCRI','L',ICARCR)
        CALL JEVECH('PCOMPOR','L',ICOMPO)
        CALL JEVECH('PDEPLPR','L',IDEPLP)
        CALL JEVECH('PDEPLMR','L',IDEPLM)
        CALL JEVECH('PINSTMR','L',IINSTM)
        CALL JEVECH('PINSTPR','L',IINSTP)
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PTEREF','L',ITREF)
        CALL JEVECH('PTEMPMR','L',ITEMPM)
        CALL JEVECH('PTEMPPR','L',ITEMPP)
        CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
        LGPG1 = MAX(JTAB(6),1)*JTAB(7)
        LGPG = LGPG1
        CALL JEVECH('PVARIMR','E',IVARIM)
        CALL JEVECH('PVARIMP','L',IVARIX)
C --- ORIENTATION DU MASSIF     
        CALL TECACH('NNN','PCAMASS',1,ICAMAS,IRET)
        CALL R8INIR(3, R8VIDE(), ANGMAS ,1)
        IF (ICAMAS.GT.0) THEN
          IF (ZR(ICAMAS).GT.0.D0) THEN
           ANGMAS(1) = ZR(ICAMAS+1)*R8DGRD()
           ANGMAS(2) = ZR(ICAMAS+2)*R8DGRD()
           ANGMAS(3) = ZR(ICAMAS+3)*R8DGRD()
          ENDIF
        ENDIF
      ENDIF  


C PARAMETRES EN SORTIE

      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
        CALL JEVECH('PCODRET','E',JCRET)

C      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
        CALL R8COPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)
        
      ELSE IF (OPTION.EQ.'FORC_NODA'.OR.
     &         OPTION.EQ.'CHAR_MECA_TEMP_R') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        
      ENDIF
        
      IF (OPTION(1:9).EQ.'RIGI_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
          CALL NMTSTM(ZK16(ICOMPO),IMATUU,MATSYM)
      ENDIF


C - INITIALISATION CODES RETOURS
      DO 1955 KPG=1,NPG
         COD(KPG)=0
1955  CONTINUE


C -- LE VECTEUR NORME QUI INDIQUE LA DIRECTION D'ARMATURE
      DENSIT = ZR(ICACOQ)
      ALPHA = ZR(ICACOQ+1) * R8DGRD()
      BETA  = ZR(ICACOQ+2) * R8DGRD()
      DIR11(1) = COS(BETA)*COS(ALPHA)
      DIR11(2) = COS(BETA)*SIN(ALPHA)
      DIR11(3) = SIN(BETA)

      
C
C - CALCUL POUR CHAQUE POINT DE GAUSS : ON CALCULE D'ABORD LA
C      CONTRAINTE ET/OU LA RIGIDITE SI NECESSAIRE PUIS
C      ON JOUE AVEC B 
C
      DO 800 KPG=1,NPG

C - MISE SOUS FORME DE TABLEAU DES VALEURS DES FONCTIONS DE FORME
C   ET DES DERIVEES DE FONCTION DE FORME

        DO 11 N=1,NNO
          VFF(N)  =ZR(IVF+(KPG-1)*NNO+N-1) 
          DFF(1,N)=ZR(IDFDE+(KPG-1)*NNO*2+(N-1)*2)
          DFF(2,N)=ZR(IDFDE+(KPG-1)*NNO*2+(N-1)*2+1)
11      CONTINUE

C - CALCUL DE LA MATRICE "B" : DEPL NODAL -> EPS11 ET DU JACOBIEN

        CALL NMGRIB(NNO,ZR(IGEOM),DFF,DIR11,B,JAC)


C - RIGI_MECA : ON DONNE LA RIGIDITE ELASTIQUE

        IF (OPTION.EQ.'RIGI_MECA') THEN
          NOMRES(1) = 'E'
          CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',0.D0,1,
     &                 NOMRES,VALRES,CODRES, 'FM')
          RIG=VALRES(1)
        ENDIF
        
C - FORC_NODA : IL SUFFIT DE RECOPIER SIGMA

        IF (OPTION.EQ.'FORC_NODA') THEN

          SIG = ZR(ICONTM+KPG-1)
        
        ENDIF
        
C - CHAR_MECA_TEMP_R : SIG = SIGMA THERMIQUE

        IF (OPTION.EQ.'CHAR_MECA_TEMP_R') THEN

          TEMPM = 0.D0

          DO 9 N=1,NNO
            TEMPM = TEMPM + ZR(ITEMPM+N-1)*VFF(N)
 9        CONTINUE

          NOMRES(1) = 'ALPHA'
          NOMRES(2) = 'E'
          CALL RCVALA(ZI(IMATE),' ','ELAS',1,'TEMP',TEMPM,2,
     &                 NOMRES,VALRES,CODRES, 'FM')
     
          SIG=VALRES(1)*VALRES(2)*(TEMPM-ZR(ITREF))
          
        ENDIF          
          
C - RAPH_MECA, FULL_MECA, RIGI_MECA_ : ON PASSE PAR LA LDC 1D

        IF (OPTION.EQ.'RAPH_MECA'.OR.OPTION.EQ.'FULL_MECA'.OR.
     &      OPTION(1:10).EQ.'RIGI_MECA_') THEN
          
          SIGM = ZR(ICONTM+KPG-1)

C - CALCUL DE LA TEMPERATURE AU POINT DE GAUSS

          TEMPM = 0.D0
          TEMPP = 0.D0

          DO 10 N=1,NNO
            TEMPM = TEMPM + ZR(ITEMPM+N-1)*VFF(N)
            TEMPP = TEMPP + ZR(ITEMPP+N-1)*VFF(N)
 10       CONTINUE
 
C - CALCUL DE LA DEFORMATION DEPS11

          EPSM=0.D0
          DEPS=0.D0

          DO 20 I=1,NNO
            DO 20 J=1,3
              EPSM=EPSM+B(J,I)*ZR(IDEPLM+(I-1)*3+J-1)
              DEPS=DEPS+B(J,I)*ZR(IDEPLP+(I-1)*3+J-1)
20        CONTINUE

          CALL NMCO1D(ZI(IMATE),ZK16(ICOMPO),OPTION,
     &             EPSM,DEPS,
     &             ANGMAS,
     &             SIGM,ZR(IVARIM+(KPG-1)*LGPG),
     &             TEMPM,TEMPP,ZR(ITREF),
     &             SIG,ZR(IVARIP+(KPG-1)*LGPG),RIG,COD)
C          write (6,*) 'DEPS = ',DEPS

C - LDC 1D TEMPORAIRE (POUR TEST DE L'ELEMENT)
C   QUAND ON PASSERA AUX VRAIES LDC : PASSER COD(KPG) POUR GESTION
C   DES CODES RETOURS : CF. NMPL2D
C --- CARACTERISTIQUES ELASTIQUES A TMOINS
C
C          CALL RCVALA(ZI(IMATE),'ELAS',1,'TEMP',TEMPM,1,
C     &                'E',EM,CODRES,'FM')
C          CALL RCVALA(ZI(IMATE),'ELAS',1,'TEMP',TEMPP,1,
C     &                'ALPHA',ALPHAM,CODRES,' ')
C          IF (CODRES.NE.'OK') ALPHAM = 0.D0
C
CC --- CARACTERISTIQUES ELASTIQUES A TPLUS
C
C          CALL RCVALA(ZI(IMATE),'ELAS',1,'TEMP',TEMPP,1,
C     &                'E',EP,CODRES,'FM')
C          CALL RCVALA(ZI(IMATE),'ELAS',1,'TEMP',TEMPP,1,
C     &                'ALPHA',ALPHAP,CODRES,' ')
C          IF (CODRES.NE.'OK') ALPHAP = 0.D0
C          
C          NOMRES(1) = 'E'
C          CALL RCVALA(ZI(IMATE),' ','ELAS',0,' ',0.D0,1,
C     &                 NOMRES,VALRES,CODRET, 'FM')

C          write (6,*) 'OPTION = ',OPTION,
C     &                ' ; VIM = ',ZR(IVARIM+(KPG-1)*LGPG)
C
C          CALL NM1DIS(ZI(IMATE),TEMPM,TEMPP,ZR(ITREF),EM,EP,ALPHAM,
C     &                ALPHAP,SIGM,DEPS,ZR(IVARIM+(KPG-1)*LGPG),OPTION,
C     &                ZK16(ICOMPO),SIG,VIP,RIG)
C          write (6,*) 'RIG = ',RIG
          
          IF (OPTION.EQ.'RAPH_MECA'.OR.OPTION.EQ.'FULL_MECA') THEN
C            SIG=VALRES(1)*EPS
C            ZR(IVARIP+(KPG-1)*LGPG)=VIP
            ZR(ICONTP+KPG-1)=SIG
C          write (6,*) 'VIP = ',VIP
C          ELSEIF (OPTION(1:10).EQ.'RIGI_MECA_'.
C     &            OR.OPTION.EQ.'FULL_MECA') THEN
C            RIG=VALRES(1)
          ENDIF

        ENDIF
        
        IF (VECTEU) THEN
          DO 100 N=1,NNO
            DO 100 I=1,3
              ZR(IVECTU+(N-1)*3+I-1)=ZR(IVECTU+(N-1)*3+I-1)+B(I,N)*SIG*
     &                                ZR(IPOIDS+KPG-1)*JAC*DENSIT
100       CONTINUE
        ENDIF
        
        IF (MATRIC) THEN
          DO 200 N=1,NNO
            DO 200 I=1,3
              KKD = (3*(N-1)+I-1) * (3*(N-1)+I) /2
              DO 200 J=1,3
                DO 200 M=1,N
                  IF (M.EQ.N) THEN
                    J1 = I
                  ELSE
                    J1 = 3
                  ENDIF
C
C                 RIGIDITE ELASTIQUE
                  TMP=B(I,N)*RIG*B(J,M)*ZR(IPOIDS+KPG-1)*JAC*DENSIT
C                  write (6,*) 'I,N,J,M,B(I,N),B(J,M),TMP',
C     &                    I,N,J,M,B(I,N),B(J,M),TMP
C
C                 STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                  IF (J.LE.J1) THEN
                     KK = KKD + 3*(M-1)+J
                     ZR(IMATUU+KK-1) = ZR(IMATUU+KK-1) + TMP
                  END IF
200       CONTINUE
        ENDIF
800   CONTINUE

      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL CODERE(COD,NPG,ZI(JCRET))
      END IF
      END
