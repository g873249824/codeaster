        SUBROUTINE LCMMOP( COMP,NBCOMM,CPMONO,NMAT,NVI,VINI,  
     &                     X,  DTIME, E,NU,ALPHA,PGL2,MOD,COEFT,SIGI,
     &                     EPSD, DETOT, TPERD, DTPER, TPEREF,
     &                     COEL,NBPHAS,NBFSYM,TOUTMS,DVIN )
        IMPLICIT NONE
        INTEGER NMAT,NBCOMM(NMAT,3),NVI,NBFSYM,NBPHAS
        REAL*8 VINI(*),DVIN(*),NU,E,ALPHA,X,DTIME,COEFT(NMAT),COEL(NMAT)
        REAL*8 SIGI(6),EPSD(6),DETOT(6),TPERD,DTPER,TPEREF,PGL(3,3)
C       POUR GAGNER EN TEMPS CPU      
        REAL*8 TOUTMS(NBPHAS,NBFSYM,12,6)
        CHARACTER*16 COMP(*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C ======================================================================
C TOLE CRP_21
C ======================================================================
C       IN  COMP     :  NOM DU MODELE DE COMPORTEMENT 
C           MOD     :  TYPE DE MODELISATION
C           IMAT    :  ADRESSE DU COEFTIAU CODE
C         NBCOMM :  NOMBRE DE COEF COEFTIAU PAR FAMILLE
C         CPMONO :  NOMS DES LOIS COEFTIAU PAR FAMILLE
C           PGL   : MATRICE DE PASSAGE GLOBAL LOCAL
C           NVI     :  NOMBRE DE VARIABLES INTERNES
C           VINI    :  VARIABLES INTERNES A T
C           X       :  INTERVALE DE TEMPS ADAPTATIF
C           DTIME   :  INTERVALE DE TEMPS 
C           COEFT   :  COEFFICIENTS COEFTIAU INELASTIQUE A T
C           SIGI    :  CONTRAINTES A L'INSTANT COURANT
C           EPSD    :  DEFORMATION TOTALE A T
C           DETOT   :  INCREMENT DE DEFORMATION TOTALE
C           TPERD   :  TEMPERATURE A T
C           DTPER   :  INTERVALE DE TEMPERATURE ENTRE T+DT ET T
C           TPEREF  :  TEMPERATURE DE REFERENCE
C     OUT:
C           DVIN    :  DERIVEES DES VARIABLES INTERNES A T
C INTEGRATION DES LOIS POLYCRISTALLINES PAR UNE METHODE DE RUNGE KUTTA
C
C     CETTE ROUTINE FOURNIT LA DERIVEE DE L ENSEMBLE DES VARIABLES
C     INTERNES DU MODELE
C
C       OBJETS DE STOCKAGE DES COMPORTEMENTS:
C           COEFT(*) = Fractions Volumiques et angles de chaque phase
C                      + COEFFICIENT DE CHAQUE COMPORTEMENT MONOCRSITAL
C                        pour chaque famille de syst�mes de glissement
C                        � la temp�rature actuelle (COEFTF)
C                       et � la temp�rature pr�c�dente (COEFTD)
C           NBCOMM = indices des coefficents de chaque comportement
C                    dans COEFT(*,2)
C           CPMONO = noms des diff�rentes "briques" de comportement
C
C      STRUCTURE DES OBJETS CREES
C
C           COEFT(*) : Nombre de monocristaux
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
C
C           NBCOMM(*,3) : 
C                        Colonne 1      Colonne 2      Colonne3
C                    _____________________________________________
C
C            Ligne 1     Nb phases      Nb var.int.   Nb monocristaux
C                                                     diff�rents
C   pour chaque phase g  Num ligne g    Ind CPMONO    ind frac vol 
C   ..................
C   ...................
C   pour chaque phase 
C   pour la localisation  indice coef   nb param      0
C   phase g              nb fam g       0            NVIg
C                ... et pour chaque famille de syst�me de glissement :
C             famille 1  ind coef       ind coef      ind coef
C                        ecoulement     ecr iso       ecr cin  
C    .....   
C         (ind signifie l'indice dans COEFT(*)            
C                    _____________________________________________
C     7 variables : tenseur EVP + Norme(EVP) 
C    description des variables internes :
C    pour chaque phase 
C        6 variables : beta ou epsilonp par phase
C    pour chaque phase 
C        pour chaque systeme de glissement
C              3 variables Alpha, Gamma, P
C   1 variable : indic
C     ----------------------------------------------------------------
      CHARACTER*8 MOD
      CHARACTER*16 NOMFAM,NCOEFT,NECOUL,NECRIS,NECRCI,CPMONO(5*NMAT+1)
      CHARACTER*16 LOCA
      REAL*8 VIS(3),DT,GAMMA,EVG(6),ANG(3),PGL2(3,3),DL,DA,GAMMAS
      REAL*8 EVI(6),SIGI33(3,3),SIGG(6),RP,DEVG(6),FV,R8DGRD
      REAL*8 DEVI(6),MS(6),TAUS,DGAMMA,DALPHA,DP,SIG33(3,3),WORK(3,3)
      REAL*8 DEVGEQ,LCNRTS,DBETA,BETA,DVINEQ,GRANB(6),SQ
      INTEGER ITENS,NBFSYS,I,NUVI,IFA,ICOMPO,NBSYS,IS,IV,NUMS,NVLOC
      INTEGER INDPHA,INDFV,INDORI,DECAL,IPHAS,INDCP,NVIG,INDFA
C     ----------------------------------------------------------------
C --  VARIABLES INTERNES
C
      DO 5 ITENS=1,6
        EVI(ITENS) = VINI(ITENS)
        DEVI(ITENS) = 0.D0
    5 CONTINUE

      CALL CALSIG(EVI,MOD,E,NU,ALPHA,X,DTIME,EPSD,DETOT,
     &              TPERD,DTPER,TPEREF,NMAT,COEL,SIGI)
      
C LOCALISATION
C   RECUPERATION DU NOMBRE DE PHASES
C      NBPHAS=NBCOMM(1,1)
      LOCA=CPMONO(1)
C     CALCUL DE  B      
         DO 53 I=1,6
            GRANB(I)=0.D0
53        CONTINUE      
         DO 54 I=1,6
         DO 54 IPHAS=1,NBPHAS
            INDFV=NBCOMM(1+IPHAS,3)
            FV=COEFT(INDFV)
            GRANB(I)=GRANB(I)+FV*VINI(7+6*(IPHAS-1)+I)
54        CONTINUE      


C     DEBUT DES VARIABLES INTERNES DES SYSTEMES DE GLISSEMENT      
      NUVI=7+6*NBPHAS
      DECAL=NUVI



      DO 1 IPHAS=1,NBPHAS         
C        INDPHA indice debut phase IPHAS dans NBCOMM
         INDPHA=NBCOMM(1+IPHAS,1)
         INDFV=NBCOMM(1+IPHAS,3)
         
C         recuperer l'orientation de la phase et la proportion
C         INDORI=INDFV+1
         FV=COEFT(INDFV)
         CALL LCLOCA(COEFT,E,NU,NMAT,NBCOMM,NBPHAS,SIGI,VINI,
     &               IPHAS,GRANB,LOCA,SIGG)
         NBFSYS=NBCOMM(INDPHA,1)
         NUMS=0
         INDCP=NBCOMM(1+IPHAS,2)     
C        Nombre de variables internes de la phase (=monocristal)        
         NVIG=NBCOMM(INDPHA,3)
         DO 51 ITENS=1,6
            DEVG(ITENS) = 0.D0
            EVG(ITENS) = 0.D0
  51     CONTINUE
         
         DO 6 IFA=1,NBFSYS
            
            NOMFAM=CPMONO(INDCP+5*(IFA-1)+1)
            NECOUL=CPMONO(INDCP+5*(IFA-1)+3) 
            NECRIS=CPMONO(INDCP+5*(IFA-1)+4) 
            NECRCI=CPMONO(INDCP+5*(IFA-1)+5) 
      
            CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS)
         
C           indice de la famille IFA            
            INDFA=INDPHA+IFA
            
            DO 7 IS=1,NBSYS
               NUMS=NUMS+1
         
C              VARIABLES INTERNES DU SYST GLIS
               DO 8 IV=1,3
                  NUVI=NUVI+1
                  VIS(IV)=VINI(NUVI)
  8            CONTINUE
  
C              CALCUL DE LA SCISSION REDUITE 
C              PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
C              TAU      : SCISSION REDUITE TAU=SIG:MS
               DO 101 I=1,6
                  MS(I)=TOUTMS(IPHAS,IFA,IS,I)
 101            CONTINUE  
 
               TAUS=0.D0
               DO 10 I=1,6
                  TAUS=TAUS+SIGG(I)*MS(I)
 10            CONTINUE  
C
C              ECROUISSAGE ISOTROPE
C
C              DECAL est le d�but des systemes de glissement de la 
C              phase en cours
C              NVIG est le nombre de variables internes dela phase G
               CALL LCMMEI(COEFT,INDFA,NMAT,NBCOMM,NECRIS,
     &                  NUMS,VIS,NVIG,VINI(DECAL+1),RP,SQ)
C
C              ECOULEMENT VISCOPLASTIQUE:
C              ROUTINE COMMUNE A L'IMPLICITE (PLASTI-LCPLNL)
C              ET L'EXPLICITE (NMVPRK-GERPAS-RK21CO-RDIF01)
C              CAS IMPLCITE : IL FAUT PRENDRE EN COMPTE DTIME
C              CAS EXPLICITE : IL NE LE FAUT PAS (C'EST FAIT PAR RDIF01)
C              D'OU :
               DT=1.D0
C            
               CALL LCMMFL(TAUS,COEFT,INDFA,NMAT,NBCOMM,NECOUL,RP,
     &            NUMS,VIS,NVIG,VINI(DECAL+1),DT,DT,DGAMMA,DP,TPERD)
     
               IF (DP.GT.0.D0) THEN
C
C                 ECROUISSAGE CINEMATIQUE
C
                  CALL LCMMEC(TAUS,COEFT,INDFA,NMAT,NBCOMM,NECRCI,VIS,
     &                  DGAMMA,DP,DALPHA)
     
C                 DEVG designe ici DEPSVPG            
                  DO 9 ITENS=1,6
                     DEVG(ITENS)=DEVG(ITENS)+MS(ITENS)*DGAMMA
  9               CONTINUE
  
C                 EVG designe ici EPSVPG      
                  IF (LOCA.EQ.'BETA') THEN     
                      GAMMAS=VIS(2) 
                      DO 19 ITENS=1,6
                         EVG(ITENS)=EVG(ITENS)+MS(ITENS)*GAMMAS
  19                  CONTINUE
                  ENDIF
            
                  DVIN(NUVI-2)=DALPHA
                  DVIN(NUVI-1)=DGAMMA
                  DVIN(NUVI  )=DP
               ELSE
                  DVIN(NUVI-2)=0.D0
                  DVIN(NUVI-1)=0.D0
                  DVIN(NUVI  )=0.D0
               ENDIF  
  7        CONTINUE
  
  6      CONTINUE
  
          DECAL = NUVI
  
C         "homogenesisation" des d�formations viscoplastiques  
          DO 20 I=1,6
             DEVI(I)=DEVI(I)+FV*DEVG(I)
 20       CONTINUE
          DEVGEQ=LCNRTS(DEVG)/1.5D0
C         localisation BETA 
          IF (LOCA.EQ.'BETA') THEN
             DL=COEFT(NBCOMM((NBPHAS+2),1))
             DA=COEFT(NBCOMM((NBPHAS+2),1)+1)
             DO 21 I=1,6
                BETA=VINI(7+6*(IPHAS-1)+I)
                DBETA=DEVG(I)-DL*(BETA-DA*EVG(I))*DEVGEQ
                DVIN(7+6*(IPHAS-1)+I)=DBETA
 21          CONTINUE
          ELSE
             DO 22 I=1,6
                DVIN(7+6*(IPHAS-1)+I)=DEVG(I)
 22          CONTINUE
          
          ENDIF
 
C fin boucle sur nombre de phases  
  1    CONTINUE
C
C --    DERIVEES DES VARIABLES INTERNES
C
      DO 30 ITENS=1,6
        DVIN(ITENS)= DEVI(ITENS)
   30 CONTINUE
C     Norme de DEVP cumul�e
      DVINEQ = LCNRTS( DEVI ) / 1.5D0
      
      DVIN(7)= DVINEQ
      
      IF (DVIN(7).EQ.0.D0) THEN
         DVIN(NVI)=0
      ELSE
         DVIN(NVI)=1
      ENDIF

      END
