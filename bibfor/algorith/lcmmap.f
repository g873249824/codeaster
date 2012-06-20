        SUBROUTINE LCMMAP (FAMI,KPG,KSP,COMP,MOD,IMAT,NMAT, ANGMAS,
     &       PGL,MATERD,MATERF, MATCST,NBCOMM,CPMONO,NDT,NDI,NR,NVI,
     &       NFS,NSG,NHSR,NUMHSR,HSR)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/06/2012   AUTEUR PROIX J-M.PROIX 
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
C RESPONSABLE JMBHH01 J.M.PROIX
C TOLE CRS_1404
C TOLE CRP_21 CRP_20
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
C       IN  FAMI   : FAMILLE DES POINTS DE GAUSS
C           KPG    : POINT DE GAUSS
C           KSP    : SOUS-POINT DE GAUSS
C           COMP   :  GRANDEUR COMPOR
C           IMAT   :  ADRESSE DU MATERIAU CODE
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION  MAXIMUM DE MATER
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
C     ----------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER NFS,NSG,KPG,KSP,NMAT,NDT,NDI,NR,NVI,NBCOMM(NMAT,3),NHSR
      REAL*8  MATERD(NMAT,2) ,MATERF(NMAT,2),HOOK(6,6),HSR(NSG,NSG,NHSR)
      REAL*8  REPERE(7),XYZ(3),KOOH(6,6),TBSYSG
      REAL*8  EPSI,R8PREM,ANGMAS(3),PGL(3,3),R8VIDE,HOOKF(6,6)
      REAL*8  VALRES(NMAT),MS(6),NG(3),Q(3,3),LG(3)
      CHARACTER*8     MOD , NOMC(14)
      INTEGER CERR(14),ITBINT,NBTBSY,NBSYSI,IMONOI,IMONOR,NUMHSR(NHSR)
      CHARACTER*3  MATCST
      CHARACTER*(*)FAMI
      CHARACTER*16 COMP(*),NMATER,NECOUL,NECRIS,NECRCI,NOMFAM
      CHARACTER*16 CPMONO(5*NMAT+1),PHENOM,COMPK,COMPI,COMPR,MONOI,MONOR
      INTEGER I, IMAT, NBFSYS, IFA,J,NBMONO,NBSYS,NBSYST,IDECAL
      INTEGER NBPHAS,ICOMPK,ICOMPI,ICOMPR,DIMK,TABICP(NMAT),NVLOC
      INTEGER INDMAT,INDCP,IMONO,NBVAL,INDLOC,INDCOM,IPHAS,NBFAM
      INTEGER NUMONO,NVINTG,IDMONO,NBVAL1,NBVAL2,NBVAL3,NBCOEF
      COMMON/TBSYSG/TBSYSG(900)
C     ----------------------------------------------------------------
      CALL JEMARQ()
C
C -   NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
C
      IF      (MOD(1:2).EQ.'3D')THEN
         NDT = 6
         NDI = 3
      ELSE IF (MOD(1:6).EQ.'D_PLAN'.OR.MOD(1:4).EQ.'AXIS')THEN
         NDT = 6
         NDI = 3
      ELSE IF (MOD(1:6).EQ.'C_PLAN')THEN
         NDT = 6
         NDI = 3
      ENDIF
      CALL R8INIR(2*NMAT, 0.D0, MATERD, 1)
      CALL R8INIR(2*NMAT, 0.D0, MATERF, 1)
C
      READ (COMP(2),'(I16)') NVI

C     LA DERNIERE VARIABLE INTERNE EST L'INDICATEUR PLASTIQUE
      NR=NVI+NDT-1
      COMPK=COMP(7)(1:8)//'.CPRK'
      COMPI=COMP(7)(1:8)//'.CPRI'
      COMPR=COMP(7)(1:8)//'.CPRR'
      CALL JEVEUO(COMPK,'L',ICOMPK)
      CALL JEVEUO(COMPI,'L',ICOMPI)
      CALL JEVEUO(COMPR,'L',ICOMPR)
      NBPHAS=ZI(ICOMPI-1+2)
      DIMK  =ZI(ICOMPI-1+5+3*NBPHAS)
      NVLOC =ZI(ICOMPI-1+5+3*NBPHAS+1)

      ITBINT=0

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
C        LESCTURE EVENTUELLE DE LA TABLE DE SYST. GLISS         
         MONOI=CPMONO(INDCP-1)(1:8)//'.CPRI'
         MONOR=CPMONO(INDCP-1)(1:8)//'.CPRR'
         CALL JEVEUO(MONOI,'L',IMONOI)            
         CALL ASSERT(NBFSYS.EQ.ZI(IMONOI-1+5))
         ITBINT=ZI(IMONOI-1+4)
         NBSYST=ZI(IMONOI-1+8)
         NBTBSY=0
         DO 3 IFA=1,NBFSYS
            NBSYSI=ZI(IMONOI-1+8+IFA)
            NBTBSY=NBTBSY+NBSYSI
 3       CONTINUE       
         IF (NBTBSY.NE.0) THEN
            CALL R8INIR(900, 0.D0, TBSYSG, 1)
            CALL JEVEUO(MONOR,'L',IMONOR)
C           TABLE CONTENANT LES SYSTEMES
            CALL DCOPY(6*NBTBSY+12,ZR(IMONOR),1,TBSYSG,1)
         ELSE
            TBSYSG(1)=0.D0
         ENDIF       
C        TABLE CONTENANT LA MATRICE D'INTERACTION        
         IF (ITBINT.EQ.1) THEN
            IDECAL=0
            IF (NBTBSY.EQ.0) THEN
               CALL JEVEUO(MONOR,'L',IMONOR)
            ENDIF
            IDECAL=NINT(ZR(IMONOR+1))
            DO 2 I=1,NBSYST
            DO 2 J=1,NBSYST
               HSR(I,J,IMONO)=ZR(IMONOR-2+IDECAL+NBSYST*(I-1)+J)
 2          CONTINUE 
         ENDIF

         DO 7 IFA=1,NBFSYS
            NOMFAM=CPMONO(INDCP+5*(IFA-1)+1)
            CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS,NG,LG,0,Q)
            NMATER=CPMONO(INDCP+5*(IFA-1)+2)
            NECOUL=CPMONO(INDCP+5*(IFA-1)+3)
            NECRIS=CPMONO(INDCP+5*(IFA-1)+4)
            NECRCI=CPMONO(INDCP+5*(IFA-1)+5)
C           NOMBRE DE MATRICE D'INTERACTION DIFFERENTES
C           COEFFICIENTS MATERIAUX LIES A L'ECOULEMENT
            CALL LCMAFL(FAMI,KPG,KSP,'-',NMATER,IMAT,NECOUL,NBVAL,
     &                  VALRES,NMAT,ITBINT,NFS,NSG,HSR(1,1,IMONO),NBSYS)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 501 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 501        CONTINUE
            CALL LCMAFL(FAMI,KPG,KSP,'+',NMATER,IMAT,NECOUL,NBVAL,
     &                  VALRES,NMAT,ITBINT,NFS,NSG,HSR(1,1,IMONO),NBSYS)
            DO 502 I=1,NBVAL
               MATERF(INDMAT+I,2)=VALRES(I)
 502        CONTINUE
            INDMAT=INDMAT+NBVAL
C           COEFFICIENTS MATERIAUX LIES A L'ECROUISSAGE CINEMATIQUE
            CALL LCMAEC(FAMI,KPG,KSP,'-',NMATER,IMAT,NECRCI,NBVAL,
     &                  VALRES,NMAT)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 503 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 503        CONTINUE
            CALL LCMAEC(FAMI,KPG,KSP,'+',NMATER,IMAT,NECRCI,NBVAL,
     &                  VALRES,NMAT)
            DO 504 I=1,NBVAL
               MATERF(INDMAT+I,2)=VALRES(I)
 504        CONTINUE
            INDMAT=INDMAT+NBVAL
C           COEFFICIENTS MATERIAUX LIES A L'ECROUISSAGE ISOTROPE
            CALL LCMAEI(FAMI,KPG,KSP,'-',NMATER,IMAT,NECRIS,NECOUL,
     &            NBVAL,VALRES,NMAT,ITBINT,NFS,NSG,HSR,IFA,NOMFAM,
     &            NBSYS)
            MATERD(INDMAT+1,2)=NBVAL
            MATERF(INDMAT+1,2)=NBVAL
            INDMAT=INDMAT+1
            DO 505 I=1,NBVAL
               MATERD(INDMAT+I,2)=VALRES(I)
 505        CONTINUE
            CALL LCMAEI(FAMI,KPG,KSP,'+',NMATER,IMAT,NECRIS,NECOUL,
     &            NBVAL,VALRES,NMAT,ITBINT,NFS,NSG,HSR,IFA,NOMFAM,
     &            NBSYS)
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
          CALL RCVALB (  FAMI,  KPG,     KSP, '-',
     &                   IMAT,  ' ',  'ELAS', 0,  ' ',0.D0, 2,
     &                   NOMC(1),  MATERD(1,1),  CERR(1), 1)
          CALL RCVALB (  FAMI,  KPG,     KSP, '-',
     &                   IMAT,  ' ',  'ELAS', 0,  ' ',0.D0, 1,
     &                   NOMC(3),  MATERD(3,1),  CERR(3), 0)
          IF ( CERR(3) .NE. 0 ) MATERD(3,1) = 0.D0
          MATERD(NMAT,1)=0
C
C -     RECUPERATION MATERIAU A TEMPF (T+DT)
C
          CALL RCVALB (  FAMI,  KPG,     KSP, '+',
     &                   IMAT, ' ',   'ELAS',  0, ' ',0.D0, 2,
     &                   NOMC(1),  MATERF(1,1),  CERR(1), 1)
          CALL RCVALB (  FAMI,  KPG,     KSP, '+',
     &                   IMAT, ' ',   'ELAS',  0, ' ',0.D0, 1,
     &                   NOMC(3),  MATERF(3,1),  CERR(3), 0)
          IF ( CERR(3) .NE. 0 ) MATERF(3,1) = 0.D0
          MATERF(NMAT,1)=0

      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN
        REPERE(1)=1
        DO 21 I=1,3
           REPERE(I+1)=ANGMAS(I)
 21     CONTINUE
C -    ELASTICITE ORTHOTROPE
C -     MATRICE D'ELASTICITE ET SON INVERSE A TEMPD(T)
C
        CALL DMAT3D(FAMI,IMAT,R8VIDE(),'-',KPG,KSP,REPERE,XYZ,
     &              HOOK)
        CALL D1MA3D(FAMI,IMAT,R8VIDE(),'-',KPG,KSP,REPERE,XYZ,KOOH)

C         termes  SQRT(2) qui ne sont pas mis dans DMAT3D
        DO 67 J=4,6
        DO 67 I=1,6
          HOOK(I,J) = HOOK(I,J)*SQRT(2.D0)
 67     CONTINUE
        DO 68 J=1,6
        DO 68 I=4,6
          HOOK(I,J) = HOOK(I,J)*SQRT(2.D0)
 68     CONTINUE
        DO 69 J=4,6
        DO 69 I=1,6
          KOOH(I,J) = KOOH(I,J)/SQRT(2.D0)
 69     CONTINUE
        DO 70 J=1,6
        DO 70 I=4,6
          KOOH(I,J) = KOOH(I,J)/SQRT(2.D0)
 70     CONTINUE
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
        CALL RCVALB(FAMI,KPG,KSP,'-',
     &              IMAT,' ',PHENOM,0,' ',0.D0,3,NOMC,MATERD(73,1),
     &              CERR,0)
        IF (CERR(1).NE.0) MATERD(73,1) = 0.D0
        IF (CERR(2).NE.0) MATERD(74,1) = 0.D0
        IF (CERR(3).NE.0) MATERD(75,1) = 0.D0
C
C -     MATRICE D'ELASTICITE ET SON INVERSE A A TEMPF (T+DT)
        CALL DMAT3D(FAMI,IMAT,R8VIDE(),'+',KPG,KSP,REPERE,XYZ,
     &              HOOKF)
        CALL D1MA3D(FAMI,IMAT,R8VIDE(),'+',KPG,KSP,REPERE,XYZ,KOOH)
C       termes  SQRT(2) qui ne sont pas mis dans DMAT3D
        DO 671 J=4,6
        DO 671 I=1,6
          HOOKF(I,J) = HOOKF(I,J)*SQRT(2.D0)
 671    CONTINUE
        DO 681 J=1,6
        DO 681 I=4,6
          HOOKF(I,J) = HOOKF(I,J)*SQRT(2.D0)
 681    CONTINUE
        DO 691 J=4,6
        DO 691 I=1,6
          KOOH(I,J) = KOOH(I,J)/SQRT(2.D0)
 691    CONTINUE
        DO 701 J=1,6
        DO 701 I=4,6
          KOOH(I,J) = KOOH(I,J)/SQRT(2.D0)
 701    CONTINUE
        DO 103 I=1,6
        DO 104 J=1,6
           MATERF(6*(J-1)+I,1)=HOOKF(I,J)
           MATERF(36+6*(J-1)+I,1)=KOOH(I,J)
 104    CONTINUE
 103    CONTINUE
        MATERF(NMAT,1)=1
        CALL RCVALB(FAMI,KPG,KSP,'+',IMAT,' ',PHENOM,
     &              0,' ',0.D0,3,NOMC,MATERF(73,1),CERR,0)
        IF (CERR(1).NE.0) MATERF(73,1) = 0.D0
        IF (CERR(2).NE.0) MATERF(74,1) = 0.D0
        IF (CERR(3).NE.0) MATERF(75,1) = 0.D0
      ELSE
         CALL U2MESK('F','ALGORITH4_65',1,PHENOM)
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
         NUMHSR(IPHAS)=NUMONO
         NVINTG=ZI(ICOMPI-1+4+3*(IPHAS-1)+3)
C        Indice du monocristal dans CPMONO
         NBCOMM(1+IPHAS,2)=TABICP(NUMONO)
         NBCOMM(INDCOM,1)=NBFAM
C        Indice d�but monocristal dans CPMONO
         NBCOMM(INDCOM,3)=NVINTG
C        Debut du monocristal
         IDMONO=NINT(MATERD((1+NUMONO),2))
C        Indice coef ecoulement famille ifa dans MATER
         DO 114 IFA=1,NBFAM
            NBVAL1=NINT(MATERD(IDMONO,2))
            NBCOMM(INDCOM+IFA,1)=IDMONO+1
            NBVAL2=NINT(MATERD((IDMONO+1+NBVAL1),2))
            NBCOMM(INDCOM+IFA,2)=IDMONO+1+NBVAL1+1
            NBVAL3=NINT(MATERD((IDMONO+1+NBVAL1+1+NBVAL2),2))
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
      IF (NBCOEF.GT.NMAT) THEN
          CALL U2MESS('F','COMPOR2_6')
      ENDIF
      IF (NBPHAS.GT.NMAT) THEN
          CALL U2MESS('F','COMPOR2_6')
      ENDIF
      NBCOMM(NMAT,3)=NBCOEF
C
C -   MATERIAU CONSTANT ?
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
        CALL U2MESS('F','COMPOR1_28')
        GOTO 9999
        ENDIF
 40   CONTINUE
C
 9999 CONTINUE
      CALL ASSERT(NMAT.GT.INDCOM)
      CALL ASSERT((5*NMAT+1).GT.DIMK)
      CALL ASSERT(NMAT.GT.(INDMAT+NVLOC))
      
C     ON STOCKE A LA FIN LE NOMBRE TOTAL DE COEF MATERIAU
      MATERD(NMAT,2)=NBCOMM(NMAT,3)
      MATERF(NMAT,2)=NBCOMM(NMAT,3)
      
      CALL JEDEMA()
      END
