        SUBROUTINE LCRKIN(NDIM,OPT,COMP,MATERF,NBCOMM,CPMONO,NMAT,MOD,
     &                    NVI,SIGD,SIGF,VIND,VINF,NBPHAS,IRET)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/06/2012   AUTEUR PROIX J-M.PROIX 
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
C     ----------------------------------------------------------------
C     INITIALISATIONS POUR RUNGE-KUTTA 
C     ----------------------------------------------------------------
C     IN
C          NDIM   :  2 OU 3
C          OPT    :  OPTION DE CALCUL : RIGI_MECA, FULL_MECA, RAPH_MECA
C          COMP   :  NOM MODELE DE COMPORTEMENT
C          MATERF :  COEF MATERIAU
C          NBCOMM :  INDICES DES COEF MATERIAU
C          NMAT   :  DIMENSION MATER
C          MOD    :  TYPE DE MODELISATION
C          NVI    :  NOMBRE DE VARIABLES INTERNES
C          VIND   :  VARIABLES INTERNES A T
C          SIGD   :  CONTRAINTES A T
C     VAR  NVI    :  NOMBRE DE VARIABLES INTERNES
C          SIGF   :  CONTRAINTES A T+DT
C          VINF   :  VARIABLES INTERNES A T+DT
C     OUT  IRET   :  CODE RETOUR
C     ----------------------------------------------------------------
      INTEGER NDT,NVI,NMAT,NDI,NS,NBCOMM(NMAT,3),ICP,NDIM,IRET,IFL
      INTEGER INDFA,NUECOU
      INTEGER NBPHAS,IFA,INDCP,INDPHA,IPHAS,NBSYS,NSFV,NBFSYS
      REAL*8  MATERF(NMAT,2),VIND(*),VINF(*),ID(3,3),SIGD(*),SIGF(*)
      REAL*8  DSDE(6,6),MAXDOM,ENDOC,FP(3,3)
      CHARACTER*16 LOI,COMP(*),OPT,CPMONO(5*NMAT+1),NECOUL
      CHARACTER*8  MOD
      COMMON/TDIM/ NDT,NDI
      INTEGER IRR,DECIRR,NBSYST,DECAL
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL
      PARAMETER (MAXDOM=0.99D0)
      DATA ID/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/
C     ----------------------------------------------------------------

      LOI  = COMP(1)
      IRET=0
      CALL LCINMA(0.D0,DSDE)
      
      IF (MATERF(NMAT,1).EQ.0) THEN
         CALL LCOPLI('ISOTROPE',MOD,MATERF(1,1),DSDE)
      ELSEIF (MATERF(NMAT,1).EQ.1) THEN
         CALL LCOPLI('ORTHOTRO',MOD,MATERF(1,1),DSDE)
      ENDIF
      
C --    DEBUT TRAITEMENT DE VENDOCHAB --
C     ROUTINE DE DECROISSANCE DES CONTRAINTES QUAND D>MAXDOM
      IF (LOI(1:9).EQ.'VENDOCHAB') THEN
C
         IF (OPT.EQ.'RIGI_MECA_TANG') THEN
            CALL U2MESS('F','ALGORITH8_91')
         ENDIF
         IF (VIND(9).GE.MAXDOM) THEN
C
           IF (VIND(9).EQ.1.0D0) THEN
             DO 4 ICP=1,2*NDIM
               SIGF(ICP)=SIGD(ICP)*(0.01D0)
    4        CONTINUE
             MATERF(1,1)=0.01D0*MATERF(1,1)
             CALL LCOPLI('ISOTROPE',MOD,MATERF(1,1),DSDE)
           ELSE
             DO 5 ICP=1,2*NDIM
                SIGF(ICP)=SIGD(ICP)*(0.1D0)
    5        CONTINUE
             ENDOC=(1.0D0-MAX(MAXDOM,VIND(9)))*0.1D0
             MATERF(1,1)=ENDOC*MATERF(1,1)
             CALL LCOPLI('ISOTROPE',MOD,MATERF(1,1),DSDE)
             MATERF(1,1)=MATERF(1,1)/ENDOC
           ENDIF
           DO 6 ICP=1,NVI
              VINF(ICP)=VIND(ICP)
    6      CONTINUE
           VINF(9)=1.0D0
           IRET=9
           GOTO 9999
         ENDIF
      ENDIF
C --  FIN   TRAITEMENT DE VENDOCHAB --

      CALL DCOPY(NVI,VIND,1,VINF,1)
   
      IF (LOI(1:9).EQ.'VENDOCHAB') THEN
C        INITIALISATION DE VINF(8) A UNE VALEUR NON NULLE
C        POUR EVITER LES 1/0 DANS RKDVEC
         IF (VINF(8).LE.(1.0D-8)) THEN
             VINF(8)=1.0D-8
         ENDIF
      ENDIF

C     COMPTAGE       
      IRR=0
      DECIRR=0
      NBSYST=0
      DECAL=0
      IF (LOI(1:8).EQ.'MONOCRIS')  THEN
         IF (COMP(3)(1:4).EQ.'SIMO') THEN
            IF (OPT.NE.'RAPH_MECA') THEN
               CALL U2MESS('F','ALGORITH8_91')
            ENDIF
            CALL DCOPY(9,VIND(NVI-3-18+1),1,FP,1)
            CALL DAXPY(9,1.D0,ID,1,FP,1)
            CALL DCOPY(9,FP,1,VINF(NVI-3-18+1),1)
            NVI=NVI-9
         ENDIF
         IF ( (   MATERF(NBCOMM(1,1),2).EQ.4)
     &      .OR.(MATERF(NBCOMM(1,1),2).EQ.5)
     &      .OR.(MATERF(NBCOMM(1,1),2).EQ.6)
     &      .OR.(MATERF(NBCOMM(1,1),2).EQ.7)) THEN
C           KOCKS-RAUCH ET DD_CFC : VARIABLE PRINCIPALE=DENSITE DISLOC
C           UNE SEULE FAMILLE
            CALL ASSERT(NBCOMM(NMAT,2).EQ.1)
            NECOUL=CPMONO(3)
            IF (NECOUL.EQ.'MONO_DD_CC_IRRA') THEN
               IRR=1
               DECIRR=6+3*12
            ENDIF
         ENDIF
         IF (IRR.EQ.1) THEN            
            NVI = NVI-3-12
         ELSE
            NVI = NVI-3
         ENDIF
      ENDIF
      
C      POUR POLYCRISTAL
C     INITIALISATION DE NBPHAS 
      NBPHAS=NBCOMM(1,1)
      IF (LOI(1:8).EQ.'POLYCRIS')  THEN
C        RECUPERATION DU NOMBRE DE PHASES
         NBPHAS=NBCOMM(1,1)
         NSFV=7+6*NBPHAS
         DO 33 IPHAS=1,NBPHAS
            INDPHA=NBCOMM(1+IPHAS,1)
            NBFSYS=NBCOMM(INDPHA,1)
            DO 32 IFA=1,NBFSYS
C              indice de la famille IFA
               INDFA=INDPHA+IFA
               IFL=NBCOMM(INDFA,1)
               NUECOU=NINT(MATERF(IFL,2))
C              IRRADIATION   
               IF (NUECOU.EQ.7) THEN
                  IF (NINT(MATERF(IFL+21,2)).EQ.1) THEN
                     IRR=1
                  ENDIF
               ENDIF
               NBSYS=12
               NSFV=NSFV+NBSYS*3
  32        CONTINUE
  33     CONTINUE
         DECIRR=NSFV
      ENDIF
      
C  PENSER A DIMINUER NVI      
C

 9999 CONTINUE
      END
