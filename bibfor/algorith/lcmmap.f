        SUBROUTINE LCMMAP (COMP, MOD,  IMAT,   NMAT,   TEMPD,   TEMPF,
     &   ANGMAS,PGL,MATERD,MATERF, MATCST,NBCOMM,CPMONO,NDT,NDI,NR,NVI)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/09/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C RESPONSABLE JMBHH01 J.M.PROIX
C       ----------------------------------------------------------------
C       POLYCRISTAL : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
C                    NB DE CMP DIRECTES/CISAILLEMENT , NB VAR. INTERNES
C
C       OBJETS DE STOCKAGE DES COMPORTEMENTS:
C           MATER(*,1) = E , NU , ALPHA
C           MATER(*,2) = Fractions Volumiques et angles de chaque phase
C                      + COEFFICIENT DE CHAQUE COMPORTEMENT MONOCRSITAL
C                        pour chaque famille de syst�mes de glissement
C                        � la temp�rature actuelle (MATERF)
C                       et � la temp�rature pr�c�dente (MATERD)
C           NBCOMM = indices des coefficents de chaque comportement
C                    dans MATER(*,2)
C           CPMONO = noms des diff�rentes "briques" de comportement
C
C      STRUCTURE DES OBJETS CREES
C
C           MATER(*,2) : NBMONO = Nombre de monocristaux
C                        indice debut premier monocristal
C                        indice debut deuxi�me monocristal
C..............
C                        indice debut denier monocristal
C                        indice des param�tes localisation
C                        Fv et 3 angles par phase
C           pour chaque monocristal diff�rent
C                 par famille de syst�me de glissement
C                    nb coef �coulement + coef, 
C                    nb coef �crou isot + coef,  
C                    nb coef ecou cine + coef
C                        puis 2 (ou plus) param�tres localisation
C
C           CPMONO(*) : nom de la methode de localisation
C                 puis, pour chaque mat�riau diff�rent
C                 nom du monocristal, nombre de familles SG, et,
C                    par famille de syst�me de glissement
C                       Nom de la famille
C                       Nom du materiau
C                       Nom de la loi d'�coulement
C                       Nom de la loi d'�crouissage isotrope
C                       Nom de la loi d'�crouissage cin�matique
C                       Nom de la loi d'�lasticit�
C           NBCOMM(*,3) : 
C                        Colonne 1      Colonne 2      Colonne3
C                    _____________________________________________
C
C            Ligne 1     Nb phases      Nb var.int.   Nb monocristaux
C                                                     diff�rents
C   pour chaque phase g  Num ligne g    Ind CPMONO    ind frac vol MATER
C   ..................
C   pour chaque phase 
C   pour la localisation  indice coef   nb param      0
C   phase g              nb fam g       0            NVIg
C                ... et pour chaque famille de syst�me de glissement :
C             famille 1  ind coef       ind coef      ind coef
C                        ecoulement     ecr iso       ecr cin  
C    .....   
C         (ind signifie l'indice dans MATER(*,2)            
C                    _____________________________________________
C                    VARIABLES INTERNES : 
C                    Evp(6)+Norme(Evp)+
C                       Nphase * (Betag (6) ou Evpg(6))
C                       Nphase*(Nsyst*(ALPHAsg,GAMMAsg,Psg)
C                    derni�re : indicateur
C                        ou s d�signe le SYSTEME DE GLISSEMENT
C                        ou g d�signe le "grain" ou la phase
C                    
C       ----------------------------------------------------------------
C       IN  COMP   :  GRANDEUR COMPOR
C           IMAT   :  ADRESSE DU MATERIAU CODE
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION  MAXIMUM DE MATER
C           TEMPD  :  TEMPERATURE  A T
C           TEMPF  :  TEMPERATURE  A T+DT
C      ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C       OUT MATERD :  COEFFICIENTS MATERIAU A T
C           PGL    : MATRICE DE PASSAGE GLOBAL LOCAL
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C                     MATER(*,1) = CARACTERISTIQUES   ELASTIQUES
C                     MATER(*,2) = CARACTERISTIQUES   PLASTIQUES
C           MATCST :  'OUI' SI  MATERIAU A T = MATERIAU A T+DT
C                     'NON' SINON
C           NBCOMM : POSITION DES COEF POUR CHAQUE LOI DE CHAQUE SYSTEME
C           CPMONO : NOMS DES LOIS POUR CHAQUE FAMILLE DE SYSTEME
C
C           NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
C           NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
C           NR     :  NB DE COMPOSANTES SYSTEME NL
C           NVI    :  NB DE VARIABLES INTERNES
C       ----------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
      CHARACTER*32     JEXNUM, JEXNOM, JEXATR
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C     ----------------------------------------------------------------
      INTEGER         NMAT, NDT , NDI  , NR , NVI,NBCOMM(NMAT,3)
      REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2) , TEMPD , TEMPF
      REAL*8          HYDRD , HYDRF , SECHD , SECHF,R8DGRD,HOOK(6,6)
      REAL*8          VALPAD(3), VALPAF(3),REPERE(7),XYZ(3),KOOH(6,6)
      REAL*8          EPSI,R8PREM,ANGMAS(3),PGL(3,3),R8VIDE,HOOKF(6,6)
      REAL*8          VALRES(NMAT)
      CHARACTER*8     MOD, NOM , NOMC(14) , NOMPAR(3)
      CHARACTER*2     BL2, CERR(14)
      CHARACTER*3     MATCST
      CHARACTER*16    COMP(*),NMATER,NECOUL,NECRIS,NECRCI
      CHARACTER*16    CPMONO(5*NMAT+1),PHENOM,COMPK,COMPI,COMPR
      INTEGER I, IMAT, NBFSYS, IFA,J,ICAMAS,ITAB(8),NBMONO
      INTEGER NBPHAS,ICOMPK,ICOMPI,ICOMPR,DIMK,TABICP(NMAT),NVLOC
      INTEGER INDMAT,INDCP,IMONO,NBVAL,INDLOC,INDCOM,IPHAS,NBFAM
      INTEGER NUMONO,NVINTG,IDMONO,NBVAL1,NBVAL2,NBVAL3,NBCOEF
      LOGICAL IRET
C     ----------------------------------------------------------------
C
      CALL JEMARQ()
      
      BL2 = '  '
C
C -   NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
C
C
      IF      (MOD(1:2).EQ.'3D')THEN
         NDT = 6
         NDI = 3
      ELSE IF (MOD(1:6).EQ.'D_PLAN'.OR.MOD(1:4).EQ.'AXIS')THEN
         NDT = 4
         NDI = 3
      ELSE IF (MOD(1:6).EQ.'C_PLAN')THEN
         NDT = 4
         NDI = 3
      ENDIF
      CALL R8INIR(2*NMAT, 0.D0, MATERD, 1)
      CALL R8INIR(2*NMAT, 0.D0, MATERF, 1)
            
      NOMPAR(1) = 'TEMP'
      VALPAD(1) = TEMPD
      VALPAF(1) = TEMPF
C
      READ (COMP(2),'(I16)') NVI
      READ (COMP(7),'(I16)') NBPHAS
C     LA DERNIERE VARIABLE INTERNE EST L'INDICATEUR PLASTIQUE
C           
      NR=NVI+NDT-1
      COMPK=COMP(6)(1:8)//'.CPRK'
      COMPI=COMP(6)(1:8)//'.CPRI'
      COMPR=COMP(6)(1:8)//'.CPRR'
      CALL JEVEUO(COMPK,'L',ICOMPK)
      CALL JEVEUO(COMPI,'L',ICOMPI)
      CALL JEVEUO(COMPR,'L',ICOMPR)
      DIMK=ZI(ICOMPI-1+5+3*NBPHAS)
      NVLOC=ZI(ICOMPI-1+5+3*NBPHAS+1)
      
      IF (ANGMAS(1).NE.R8VIDE()) THEN
C        PAS ENCORE PROGRAMME
         CALL UTMESS('F','LCMMAP','UTILISATION DE AFFE_CARA_ELEM '//
     &    'MASSIF PAS ENCORE DISPONIBLE POUR POLYCRISTAL')
         CALL MATROT(ANGMAS,PGL)
      ELSE
          CALL LCINVN(9,0.D0,PGL)
          PGL(1,1)=1.D0
          PGL(2,2)=1.D0
          PGL(3,3)=1.D0
      ENDIF
      
      DO 111 I=1,NMAT
      DO 111 J=1,3
         NBCOMM(I,J)=0
 111  CONTINUE
 
      NBMONO=ZI(ICOMPI-1+4)
      
      DO 112 I=1,DIMK
         CPMONO(I)=ZK16(ICOMPK-1+I)
 112  CONTINUE

C           MATER(*,2) : Nombre de monocristaux
C                        indice debut premier monocristal
C                        indice debut deuxi�me monocristal
C..............
C                        indice debut denier monocristal
C                        indice des param�tes localisation
C                        Fv et 3 angles par phase
C           pour chaque monocristal diff�rent
C                 par famille de syst�me de glissement
C                    coef �coulement, coef �crou isot, coef ecou cine
C                        puis 2 (ou plus) param�tres localisation
      MATERD(1,2)=NBMONO      
      MATERF(1,2)=NBMONO      
      INDMAT=1+NBMONO+1
      DO 113 I=1,4*NBPHAS
         MATERD(INDMAT+I,2)=ZR(ICOMPR-1+I)
         MATERF(INDMAT+I,2)=ZR(ICOMPR-1+I)
 113  CONTINUE
      INDMAT=1+NBMONO+1+4*NBPHAS
      MATERD(1+1,2)=INDMAT +1
      MATERF(1+1,2)=INDMAT +1
      INDCP=3
C     Boucle sur le nombre de monocristaux
      DO 6 IMONO=1,NBMONO
         READ (CPMONO(INDCP),'(I16)') NBFSYS
         DO 7 IFA=1,NBFSYS      
            NMATER=CPMONO(INDCP+5*(IFA-1)+2)
            NECOUL=CPMONO(INDCP+5*(IFA-1)+3) 
            NECRIS=CPMONO(INDCP+5*(IFA-1)+4) 
            NECRCI=CPMONO(INDCP+5*(IFA-1)+5) 

C           COEFFICIENTS MATERIAUX LIES A L'ECOULEMENT         
            CALL LCMAFL(NMATER,IMAT,NECOUL,NBVAL,1,NOMPAR,VALPAD,VALRES,
     &            NMAT)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 501 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 501        CONTINUE
            CALL LCMAFL(NMATER,IMAT,NECOUL,NBVAL,1,NOMPAR,VALPAF,VALRES,
     &            NMAT)
            DO 502 I=1,NBVAL
               MATERF(INDMAT+I,2)=VALRES(I)
 502        CONTINUE
            INDMAT=INDMAT+NBVAL
            
C           COEFFICIENTS MATERIAUX LIES A L'ECROUISSAGE CINEMATIQUE
            CALL LCMAEC(NMATER,IMAT,NECRCI,NBVAL,1,NOMPAR,VALPAD,VALRES,
     &            NMAT)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 503 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 503        CONTINUE
            CALL LCMAEC(NMATER,IMAT,NECRCI,NBVAL,1,NOMPAR,VALPAF,VALRES,
     &            NMAT)
            DO 504 I=1,NBVAL
               MATERF(INDMAT+I,2)=VALRES(I)
 504        CONTINUE
            INDMAT=INDMAT+NBVAL
            
C           COEFFICIENTS MATERIAUX LIES A L'ECROUISSAGE ISOTROPE
            CALL LCMAEI(NMATER,IMAT,NECRIS,NBVAL,1,NOMPAR,VALPAD,VALRES,
     &            NMAT)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 505 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 505        CONTINUE
            CALL LCMAEI(NMATER,IMAT,NECRIS,NBVAL,1,NOMPAR,VALPAF,VALRES,
     &            NMAT)
            DO 506 I=1,NBVAL
               MATERF(INDMAT+I,2)=VALRES(I)
 506        CONTINUE
            INDMAT=INDMAT+NBVAL
                           
 7       CONTINUE   
   
         TABICP(IMONO)=INDCP
         INDCP=INDCP+5*NBFSYS+1+2
C        INDICE DU DEBUT DU MONO SUIVANT DANS MATER
         MATERD(1+IMONO+1,2)=INDMAT +1
         MATERF(1+IMONO+1,2)=INDMAT +1
      
 6    CONTINUE     
C     Param�tres de la loi de localisation 
      INDLOC=INDMAT+1
      DO 118 I=1,NVLOC
         MATERD(INDMAT+I,2)=ZR(ICOMPR-1+4*NBPHAS+I)
         MATERF(INDMAT+I,2)=ZR(ICOMPR-1+4*NBPHAS+I)
 118  CONTINUE
      NBCOEF=INDMAT+NVLOC
 
C  FIN remplissage de MATER(*,2)

      CALL RCCOMA(IMAT,'ELAS',PHENOM,CERR)      
      IF (PHENOM.EQ.'ELAS') THEN
C
C -    ELASTICITE ISOTROPE
C
          NOMC(1) = 'E       '
          NOMC(2) = 'NU      '
          NOMC(3) = 'ALPHA   '
C
C -     RECUPERATION MATERIAU A TEMPD (T)
C
          CALL RCVALA (  IMAT,  ' ',  'ELAS', 1,  NOMPAR,VALPAD, 2,
     1                   NOMC(1),  MATERD(1,1),  CERR(1), 'FM' )
          CALL RCVALA (  IMAT,  ' ',  'ELAS', 1,  NOMPAR,VALPAD, 1,
     1                   NOMC(3),  MATERD(3,1),  CERR(3), BL2 )
          IF ( CERR(3) .NE. 'OK' ) MATERD(3,1) = 0.D0
          MATERD(NMAT,1)=0
C
C -     RECUPERATION MATERIAU A TEMPF (T+DT)
C
          CALL RCVALA (  IMAT, ' ',   'ELAS',  1, NOMPAR,VALPAF, 2,
     1                   NOMC(1),  MATERF(1,1),  CERR(1), 'FM' )
          CALL RCVALA (  IMAT, ' ',   'ELAS',  1, NOMPAR,VALPAF, 1,
     1                   NOMC(3),  MATERF(3,1),  CERR(3), BL2 )
          IF ( CERR(3) .NE. 'OK' ) MATERF(3,1) = 0.D0
          MATERF(NMAT,1)=0
          
      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN        
        REPERE(1)=1
        DO 21 I=1,3
           IF (ANGMAS(1).NE.R8VIDE()) THEN
               REPERE(I+1)=ANGMAS(I)
           ELSE               
               REPERE(I+1)=0.D0
           ENDIF
 21     CONTINUE
C
C -    ELASTICITE ORTHOTROPE
C -     MATRICE D'ELASTICITE ET SON INVERSE A TEMPD(T)
C
        CALL DMAT3D(IMAT,VALPAD,R8VIDE(),R8VIDE(),R8VIDE(),REPERE,XYZ,
     &              HOOK)
        CALL D1MA3D(IMAT,VALPAD,R8VIDE(),REPERE,XYZ,KOOH)        
        DO 101 I=1,6
           DO 102 J=1,6
              MATERD(6*(J-1)+I,1)=HOOK(I,J)
              MATERD(36+6*(J-1)+I,1)=KOOH(I,J)
 102       CONTINUE
 101    CONTINUE 
        MATERD(NMAT,1)=1        
        NOMC(1) = 'ALPHA_L'
        NOMC(2) = 'ALPHA_T'
        NOMC(3) = 'ALPHA_N'        
        CALL RCVALA(IMAT,' ',PHENOM,1,NOMPAR,VALPAD,3,NOMC,MATERD(73,1),
     &              CERR,' ')     
        IF (CERR(1).NE.'OK') MATERD(73,1) = 0.D0
        IF (CERR(2).NE.'OK') MATERD(74,1) = 0.D0
        IF (CERR(3).NE.'OK') MATERD(75,1) = 0.D0        
C
C -     MATRICE D'ELASTICITE ET SON INVERSE A A TEMPF (T+DT)
C
        CALL DMAT3D(IMAT,VALPAF,R8VIDE(),R8VIDE(),R8VIDE(),REPERE,XYZ,
     &              HOOKF)
     
        CALL D1MA3D(IMAT,VALPAF,R8VIDE(),REPERE,XYZ,KOOH)
     
        DO 103 I=1,6
           DO 104 J=1,6
              MATERF(6*(J-1)+I,1)=HOOKF(I,J)
              MATERF(36+6*(J-1)+I,1)=KOOH(I,J)
 104       CONTINUE
 103    CONTINUE 
        MATERF(NMAT,1)=1        
        CALL RCVALA(IMAT,' ',PHENOM,1,NOMPAR,VALPAF,3,NOMC,MATERF(73,1),
     &              CERR,' ')
        IF (CERR(1).NE.'OK') MATERF(73,1) = 0.D0
        IF (CERR(2).NE.'OK') MATERF(74,1) = 0.D0
        IF (CERR(3).NE.'OK') MATERF(75,1) = 0.D0        
      ELSE
         CALL UTMESS('F','LCMATE',PHENOM//' IMPOSSIBLE ACTUELLEMENT')
      ENDIF
         
      
C     Remplissage de NBCOMM : Boucle sur le nombre de phases
C     3 : Nombre de familles de syst�mes de glissement phase g      
C     Nb phases
      NBCOMM(1,1)=ZI(ICOMPI-1+2)
C     Nb var. int. total
      NBCOMM(1,2)=ZI(ICOMPI-1+3)
C     Nb materiaux (monocristaux) diff�rents
      NBCOMM(1,3)=ZI(ICOMPI-1+4)
C     2 : Num�ro du mat�riau phase g      
C     3 : indice fraction volumique  dans MATER     
C     Indices de la premi�re phase    dans NBCOMM  
      INDCOM=NBPHAS+1
C     Ligne pr�cisant l'indice des coef localisation
      INDCOM=INDCOM+1
      NBCOMM(INDCOM,1)=INDLOC
      NBCOMM(INDCOM,2)=NVLOC
      NBCOMM(2,1)=INDCOM+1
      INDCOM=INDCOM+1
      INDCP=1
      DO 115 IPHAS=1,NBPHAS
C         Indice de la fraction volumique dans MATER
         NBCOMM(1+IPHAS,3)=1+NBCOMM(1,3)+1+4*(IPHAS-1)+1
         NBFAM =ZI(ICOMPI-1+4+3*(IPHAS-1)+1)
         NUMONO=ZI(ICOMPI-1+4+3*(IPHAS-1)+2)
         NVINTG=ZI(ICOMPI-1+4+3*(IPHAS-1)+3)
C        Indice du monocristal dans CPMONO
         NBCOMM(1+IPHAS,2)=TABICP(NUMONO)
         NBCOMM(INDCOM,1)=NBFAM
C        Indice d�but monocristal dans CPMONO         
         NBCOMM(INDCOM,3)=NVINTG
C        Debut du monocristal         
         IDMONO=MATERD((1+NUMONO),2)
C        Indice coef ecoulement famille ifa dans MATER         
         DO 114 IFA=1,NBFAM
            NBVAL1=MATERD(IDMONO,2)
            NBCOMM(INDCOM+IFA,1)=IDMONO+1
            NBVAL2=MATERD((IDMONO+1+NBVAL1),2)
            NBCOMM(INDCOM+IFA,2)=IDMONO+1+NBVAL1+1
            NBVAL3=MATERD((IDMONO+1+NBVAL1+1+NBVAL2),2)
            NBCOMM(INDCOM+IFA,3)=IDMONO+1+NBVAL1+1+NBVAL2+1
            IDMONO=IDMONO+3+NBVAL1+NBVAL2+NBVAL3
 114     CONTINUE
         INDCOM=INDCOM+NBFAM+1
         IF (IPHAS.LT.NBPHAS) THEN
C           Indice du monocristal (phase) dans NBCOMM
            NBCOMM(1+IPHAS+1,1)=INDCOM
         ENDIF
 115  CONTINUE      
C     Nombre total de COEF
      
      IF (NBCOEF.GE.NMAT) CALL UTMESS('F','LCMMAP','AUGMENTER NMAT')
      NBCOMM(NMAT,3)=NBCOEF
C
C -   MATERIAU CONSTANT ?
C
      MATCST = 'OUI'
      EPSI=R8PREM()
      DO 30 I = 1,NMAT
        IF (ABS(MATERD(I,1)-MATERF(I,1) ).GT.EPSI*MATERD(I,1)) THEN
        MATCST = 'NON'
        GOTO 9999
        ENDIF
 30   CONTINUE
      DO 40 I = 1,NMAT
        IF (ABS(MATERD(I,2)-MATERF(I,2) ).GT.EPSI*MATERD(I,2)) THEN
        MATCST = 'NON'
        GOTO 9999
        ENDIF
 40   CONTINUE
C
 9999 CONTINUE
      CALL ASSERT(NMAT.GT.INDCOM)
      CALL ASSERT((5*NMAT+1).GT.DIMK)
      CALL ASSERT(NMAT.GT.(INDMAT+NVLOC))
      CALL JEDEMA()
      END
