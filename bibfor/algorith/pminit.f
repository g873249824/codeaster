      SUBROUTINE PMINIT(IMATE ,NBVARI,NDIM  ,TYPMOD,TABLE ,
     &                  NBPAR ,IFORTA,NOMPAR,TYPPAR,ANG   ,PGL   ,
     &                  IROTA ,EPSM  ,SIGM  ,VIM   ,VIP   ,VR,
     &                  DEFIMP,COEF  ,INDIMP,FONIMP,CIMPO ,
     &                  KEL   ,SDDISC,PARCRI,PRED  ,MATREL,IMPTGT,
     &                  OPTION, NOMVI, NBVITA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/01/2012   AUTEUR FOUCAULT A.FOUCAULT 
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
C TOLE CRP_21 CRS_1404
C
      IMPLICIT NONE
C
C-----------------------------------------------------------------------
C     OPERATEUR    CALC_POINT_MAT : INITIALISATIONS
C-----------------------------------------------------------------------
C
C IN   IMATE  : ADRESSE MATERIAU CODE
C IN   NBVARI : NOMBRE DE VARIABLES INTERNES
C IN   NDIM   : 3
C OUT  TYPMOD : 3D
C OUT  TABLE  : TABLE RESULTAT
C OUT  NBPAR  : NOMBRE DE PARAMETRES DE LA TABLE RESULTAT
C OUT  NOMPAR : NOMS DES PARAMETRES DE LA TABLE RESULTAT
C OUT  ANG    : ANGLES DU MOT-CLE MASSIF
C OUT  PGL    : MATRICE DE ROTATION AUTOUR DE Z
C OUT  IROTA  : =1 SI ROTATION AUTOUR DE Z
C OUT  EPSM   : DEFORMATIONS INITIALES
C OUT  SIGM   : CONTRAINTES INITIALES
C OUT  VIM    : VARIABLES INTERNES INITIALES
C OUT  VIP    : VARIABLES INTERNES NULLES
C OUT  DEFIMP : =1 SI LES 6 CMP DE EPSI DONT DONNEES
C OUT  COEF   : COEF POUR ADIMENSIONNALISER LE PB
C OUT  INDIMP : TABLEAU D'INDICES =1 SI EPS(I) DONNE
C OUT  FONIMP : FONCTIONS IMPOSEES POUR EPSI OU SIGM
C OUT  CIMPO  : = 1 POUR LA CMP DE EPSI OU SIGM IMPOSEE
C OUT  KEL    : OPERATEUR D'ELASTICITE
C OUT  SDDISC : SD DISCRETISATION
C OUT  PARCRI : PARAMETRES DE CONVERGENCE GLOBAUX
C OUT  PRED   : TYPE DE PREDICTION = 1 SI TANGENTE
C OUT  MATREL : MATRICE TANGENTE = 1 SI ELASTIQUE
C OUT  OPTION : FULL_MECA OU RAPH_MECA
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC,CBID
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24,K24BID
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NDIM,N1,NBVARI,NBPAR,I,J,K,IMATE,KPG,KSP,NBOCC,N2
      INTEGER      IEPSI,ICONT,IGRAD,IROTA,DEFIMP,INDIMP(9),NCMP
      INTEGER      PRED,MATREL,IC1C2,IFORTA,IMPTGT,NBVITA
      INTEGER      ILIGNE,ICOLON,FONACT(28),NBCOL
      CHARACTER*4  NOMEPS(6),NOMSIG(6),NOMGRD(9),OPTGT
      CHARACTER*8  TYPMOD(2),K8B,TABLE,FONIMP(9),FONGRD(9),F0,VK8(2)
      CHARACTER*8  FONEPS(6),FONSIG(6),TYPPAR(*),VALEF,NOMVI(*)
      CHARACTER*16 OPTION,NOMPAR(*),PREDIC,MATRIC,FORTAB
      CHARACTER*19 LISINS,SDDISC,SOLVEU
      REAL*8       INSTAM,ANG(7),SIGM(6),EPSM(9),VALE,RAC2
      REAL*8       VIM(NBVARI),VIP(NBVARI),VR(*)
      REAL*8       SIGI,REP(7),R8DGRD,KEL(6,6),CIMPO(6,12)
      REAL*8       ANGD(3),ANG1,PGL(3,3),XYZGAU(3),COEF,INSTIN
      REAL*8       PARCRI(*),PARCON(9),ANGEUL(3),ID(9),DSIDEP(36)
      REAL*8       SIGINI(6),EPSINI(6)
      INTEGER      IARG

      DATA NOMEPS/'EPXX','EPYY','EPZZ','EPXY','EPXZ','EPYZ'/
      DATA NOMSIG/'SIXX','SIYY','SIZZ','SIXY','SIXZ','SIYZ'/
      DATA NOMGRD/'F11','F12','F13','F21','F22','F23','F31','F32','F33'/
      DATA ID/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/
C
C ----------------------------------------------------------------------
C
C     INITIALISATIONS
      NDIM=3
      TYPMOD(1)='3D'
      TYPMOD(2)=' '
      SOLVEU   = '&&OP0033'
      RAC2=SQRT(2.D0)

C     ----------------------------------------
C     RECUPERATION DU NOM DE LA TABLE PRODUITE
C     ----------------------------------------
      CALL GETRES(TABLE,K24BID,K24BID)

      IFORTA=0
      CALL GETVTX(' ','FORMAT_TABLE',1,IARG,1,FORTAB,N1)
      IF (N1.NE.0) THEN
         IF (FORTAB.EQ.'CMP_LIGNE') THEN
            IFORTA=1
         ENDIF
      ENDIF

      NBVITA=NBVARI
      CALL GETVIS(' ','NB_VARI_TABLE',1,IARG,1,K,N1)
      IF (N1.GT.0) NBVITA=K
      NBVITA=MIN(NBVITA,NBVARI)

      IMPTGT=0
      CALL GETVTX(' ','OPER_TANGENT',0,IARG,1,OPTGT,N1)
      IF (N1.NE.0) THEN
         IF (OPTGT.EQ.'OUI') THEN
            IMPTGT=1
         ENDIF
      ENDIF

      NCMP=6
      IGRAD=0
      CALL GETVID(' ',NOMGRD(1),1,IARG,1,FONGRD(1),N1)
      IF (N1.NE.0) THEN
         NCMP=9
         IGRAD=1
      ENDIF

C     SI LE NOMBRE DE VARIABLES INTERNES EST TROP GRAND
C     ON CHANGE DE FORMAT DE TABLE
C     NOMBRE MAXI DE COLONNES DANS UNE TABLE 9999 (CF D4.02.05)

      NBCOL=1+NCMP+6+2+NBVITA+1+36
      IF (NBCOL.GT.9999) THEN
          IFORTA=1
      ENDIF

      NOMPAR(1)='INST'

      IF (IFORTA.EQ.0) THEN
C     LA TABLE CONTIENT L'INSTANT, EPS, SIG, TRACE, VMIS, VARI, NB_ITER

          NBPAR=1+NCMP+6+2+NBVITA+1
          IF (IMPTGT.EQ.1) NBPAR=NBPAR+36
          IF (IGRAD.EQ.1) THEN
             DO 132 I=1,NCMP
                NOMPAR(1+I)=NOMGRD(I)
 132         CONTINUE
          ELSE
             DO 131 I=1,NCMP
                NOMPAR(1+I)=NOMEPS(I)
 131         CONTINUE
          ENDIF
          DO 13 I=1,6
             NOMPAR(1+NCMP+I)=NOMSIG(I)
 13       CONTINUE
          NOMPAR(1+NCMP+6+1)='TRACE'
          NOMPAR(1+NCMP+6+2)='VMIS'
          DO 11 I=1,NBVITA
             NOMPAR(1+NCMP+6+2+I)(1:1)='V'
             CALL CODENT(I,'G',NOMPAR(1+NCMP+6+2+I)(2:16))
  11      CONTINUE

          IF (IMPTGT.EQ.1) THEN
          
             DO 133 I=1,6
             DO 133 J=1,6
                K=1+NCMP+6+2+NBVARI+6*(I-1)+J
                WRITE(NOMPAR(K),'(A,I1,I1)') 'K',I,J
 133         CONTINUE

          ENDIF

          NOMPAR(NBPAR)='NB_ITER'
          DO 10 I=1,NBPAR
             TYPPAR(I)='R'
 10       CONTINUE
      ELSE
          NBPAR=4
          NOMPAR(2)='GRANDEUR'
          NOMPAR(3)='CMP'
          NOMPAR(4)='VALEUR'
          TYPPAR(1)='R'
          TYPPAR(2)='K8'
          TYPPAR(3)='K8'
          TYPPAR(4)='R'
      ENDIF


      CALL TBCRSD(TABLE,'G')
      CALL TBAJPA(TABLE,NBPAR,NOMPAR,TYPPAR)

C     ----------------------------------------
C     TRAITEMENT DES ANGLES
C     ----------------------------------------
      CALL R8INIR ( 7, 0.D0, ANG ,1 )
      CALL R8INIR ( 3, 0.D0, ANGEUL ,1 )
      CALL R8INIR(3, 0.D0, XYZGAU, 1)
      CALL GETVR8('MASSIF','ANGL_REP',1,IARG,3,ANG(1),N1)
      CALL GETVR8('MASSIF','ANGL_EULER',1,IARG,3,ANGEUL,N2)

      IF (N1.GT.0) THEN
         ANG(1) = ANG(1)*R8DGRD()
         IF ( NDIM .EQ. 3 ) THEN
            ANG(2) = ANG(2)*R8DGRD()
            ANG(3) = ANG(3)*R8DGRD()
         ENDIF
         ANG(4) = 1.D0

C     ECRITURE DES ANGLES D'EULER A LA FIN LE CAS ECHEANT
      ELSEIF (N2.GT.0) THEN
          CALL EULNAU(ANGEUL,ANGD)
          ANG(1) = ANGD(1)*R8DGRD()
          ANG(5) = ANGEUL(1)*R8DGRD()
          IF ( NDIM .EQ. 3 ) THEN
             ANG(2) = ANGD(2)*R8DGRD()
             ANG(3) = ANGD(3)*R8DGRD()
             ANG(6) = ANGEUL(2)*R8DGRD()
             ANG(7) = ANGEUL(3)*R8DGRD()
          ENDIF
          ANG(4) = 2.D0
      ENDIF
      IF (NCMP.EQ.6) THEN
         CALL R8INIR(9, 0.D0, EPSM, 1)
      ELSE
         CALL DCOPY(9,ID,1,EPSM,1)
      ENDIF
      CALL R8INIR(6, 0.D0, SIGM, 1)
      CALL R8INIR(NBVARI,0.D0, VIM, 1)
      CALL R8INIR(NBVARI,0.D0, VIP, 1)
      IROTA=0
C     ANGLE DE ROTATION
      CALL GETVR8(' ','ANGLE',1,IARG,1,ANG1,N1)
      IF ((N1.NE.0).AND.(ANG1.NE.0.D0)) THEN
C        VERIFS
         IROTA=1
         CALL R8INIR(9,0.D0, PGL, 1)
         CALL DSCAL(1,R8DGRD(),ANG1,1)
         PGL(1,1)=COS(ANG1)
         PGL(2,2)=COS(ANG1)
         PGL(1,2)=SIN(ANG1)
         PGL(2,1)=-SIN(ANG1)
         PGL(3,3)=1.D0
C VOIR GENERALISATION A 3 ANGLES AVEC CALL MATROT
      ENDIF


C     ----------------------------------------
C     ETAT INITIAL
C     ----------------------------------------
      CALL GETFAC('SIGM_INIT',NBOCC)
      IF (NBOCC.GT.0) THEN
         DO 15 I=1,6
            CALL GETVR8('SIGM_INIT',NOMSIG(I),1,IARG,1,SIGI,N1)
            IF (N1.NE.0) THEN
               SIGM(I)=SIGI
            ENDIF
  15     CONTINUE
         CALL DSCAL(3,RAC2,SIGM(4),1)
      ENDIF

      CALL GETFAC('EPSI_INIT',NBOCC)
      IF (NBOCC.GT.0) THEN
         DO 16 I=1,6
            CALL GETVR8('EPSI_INIT',NOMEPS(I),1,IARG,1,SIGI,N1)
            IF (N1.NE.0) THEN
               EPSM(I)=SIGI
            ENDIF
  16     CONTINUE
         CALL DSCAL(3,RAC2,EPSM(4),1)
      ENDIF

      CALL GETFAC('VARI_INIT',NBOCC)
      IF (NBOCC.GT.0) THEN
         CALL GETVR8('VARI_INIT','VALE',1,IARG,NBVARI,VIM,N1)
      ENDIF

      KPG=1
      KSP=1
      CALL R8INIR(7, 0.D0, REP, 1)
      REP(1)=1.D0
      CALL DCOPY(3,ANG,1,REP(2),1)

      INSTAM=0.D0

C     ----------------------------------------
C     MATRICE ELASTIQUE ET COEF POUR ADIMENSIONNALISER
C     ----------------------------------------
      CALL DMAT3D('RIGI',IMATE,INSTAM,'+',KPG,KSP,
     &                   REP,XYZGAU,KEL)
C     DMAT ECRIT MU POUR LES TERMES DE CISAILLEMENT
      COEF=MAX(KEL(1,1),KEL(2,2),KEL(3,3))
      DO 67 J=4,6
        KEL(J,J) = KEL(J,J)*2.D0
        COEF=MAX(COEF,KEL(J,J))
 67   CONTINUE

C     ----------------------------------------
C     CHARGEMENT
C     ----------------------------------------
      CALL R8INIR(6*12,0.D0, CIMPO, 1)
      ICONT=0
      IEPSI=0
      IGRAD=0
      F0='&&CPM_F0'
      CALL FOZERO(F0)
      DO 23 I=1,9
         INDIMP(I)=0
         FONIMP(I)=F0
 23   CONTINUE
      DO 14 I=1,6
         CALL GETVID(' ',NOMEPS(I),1,IARG,1,FONEPS(I),N1)
         CALL GETVID(' ',NOMSIG(I),1,IARG,1,FONSIG(I),N2)
         IF (N1.NE.0) THEN
            CIMPO(I,6+I)=1.D0
            FONIMP(I)=FONEPS(I)
            IEPSI=IEPSI+1
            INDIMP(I)=1
         ELSEIF (N2.NE.0) THEN
            CIMPO(I,I)=1.D0
            FONIMP(I)=FONSIG(I)
            ICONT=ICONT+1
            INDIMP(I)=0
         ENDIF
  14  CONTINUE
      DO 141 I=1,9
         CALL GETVID(' ',NOMGRD(I),1,IARG,1,FONGRD(I),N1)
         IF (N1.NE.0) THEN
            FONIMP(I)=FONGRD(I)
            IGRAD=IGRAD+1
            INDIMP(I)=2
         ENDIF
 141  CONTINUE
      DEFIMP=0
      IF (IEPSI.EQ.6) DEFIMP=1
      IF (IGRAD.EQ.9) DEFIMP=2
      IC1C2=0
C     TRAITEMENT DES RELATIONS LINEAIRES (MOT CLE MATR_C1)
      CALL GETFAC('MATR_C1',NBOCC)
      IF (NBOCC.NE.0) THEN
         IC1C2=1
         DO 55 I=1,NBOCC
            CALL GETVIS('MATR_C1','NUME_LIGNE',I,IARG,1,ILIGNE,N1)
            CALL GETVIS('MATR_C1','NUME_COLONNE',I,IARG,1,ICOLON,N1)
            CALL GETVR8('MATR_C1','VALE',I,IARG,1,VALE,N1)
            CIMPO(ILIGNE,ICOLON)=VALE
 55      CONTINUE
      ENDIF
      CALL GETFAC('MATR_C2',NBOCC)
      IF (NBOCC.NE.0) THEN
         IC1C2=1
         DO 56 I=1,NBOCC
            CALL GETVIS('MATR_C2','NUME_LIGNE',I,IARG,1,ILIGNE,N1)
            CALL GETVIS('MATR_C2','NUME_COLONNE',I,IARG,1,ICOLON,N1)
            CALL GETVR8('MATR_C2','VALE',I,IARG,1,VALE,N1)
            CIMPO(ILIGNE,ICOLON+6)=VALE
 56      CONTINUE
      ENDIF
      CALL GETFAC('VECT_IMPO',NBOCC)
      IF (NBOCC.NE.0) THEN
         DO 57 I=1,NBOCC
            CALL GETVIS('VECT_IMPO','NUME_LIGNE',I,IARG,1,ILIGNE,N1)
            CALL GETVID('VECT_IMPO','VALE',I,IARG,1,VALEF,N1)
            FONIMP(ILIGNE)=VALEF
 57      CONTINUE
      ENDIF
      IF (IC1C2.EQ.1) THEN
         DO 58 I=1,6
C AFFECTATION DE SIGMA_I=0. SI RIEN N'EST IMPOSE SUR LA LIGNE I
            K=0
            DO 59 J=1,12
               IF (CIMPO(I,J).NE.0.D0) THEN
                  K=1
               ENDIF
 59         CONTINUE
            IF (K.EQ.0 ) THEN
               CIMPO(I,I)=1.D0
            ENDIF
 58      CONTINUE
         DEFIMP=-1
         COEF=1.D0
      ENDIF

C     ----------------------------------------
C     ECRITURE ETAT INITIAL DANS TABLE
C     ----------------------------------------
      IF (IFORTA.EQ.0) THEN
C CONSTRUCTION DES VECTEURS DE DEFORMATION ET CONTRAINTES
C RETIRE LE TERME EN RAC2 SUR COMPOSANTES DE CISAILLEMENT
         CALL LCEQVE(EPSM,EPSINI)
         CALL LCEQVE(SIGM,SIGINI)
         CALL DSCAL(3,1.D0/RAC2,EPSINI(4),1)
         CALL DSCAL(3,1.D0/RAC2,SIGINI(4),1)
C RECOPIE DANS LA TABLE DES VECTEURS SIGINI ET EPSINI
         CALL DCOPY(NCMP,EPSINI,1,VR(2),1)
         CALL DCOPY(6,SIGINI,1,VR(NCMP+2),1)
         VR(1+NCMP+6+1)=0.D0
         VR(1+NCMP+6+2)=0.D0
         CALL DCOPY(NBVITA,VIM,1,VR(1+NCMP+6+3),1)
         VR(1)=INSTAM
C        ajout KTGT
         IF (IMPTGT.EQ.1) THEN
            CALL R8INIR(36,0.D0,DSIDEP, 1)
            CALL DCOPY(36,DSIDEP,1,VR(1+6+6+3+NBVARI),1)
         ENDIF
         VR(NBPAR)=0
         CALL TBAJLI(TABLE,NBPAR,NOMPAR,0,VR,CBID,K8B,0)
      ELSE
         VR(1)=INSTAM
         VK8(1)='EPSI'
         DO 551 I=1,NCMP
            VR(2)=EPSM(I)
            VK8(2)=NOMEPS(I)
            CALL TBAJLI(TABLE,NBPAR,NOMPAR,0,VR,CBID,VK8,0)
 551     CONTINUE
         VK8(1)='SIGM'
         DO 552 I=1,NCMP
            VR(2)=SIGM(I)
            VK8(2)=NOMSIG(I)
            CALL TBAJLI(TABLE,NBPAR,NOMPAR,0,VR,CBID,VK8,0)
 552     CONTINUE
         VK8(1)='VARI'
         DO 553 I=1,NBVITA
            VR(2)=VIM(I)
            VK8(2)(1:1)='V'
            CALL CODENT(I,'G',VK8(2)(2:8))
            NOMVI(I)=VK8(2)
            CALL TBAJLI(TABLE,NBPAR,NOMPAR,0,VR,CBID,VK8,0)
 553     CONTINUE
      ENDIF

C     ----------------------------------------
C     CREATION SD DISCRETISATION
C     ----------------------------------------
      CALL GETVID('INCREMENT','LIST_INST',1,IARG,1,LISINS,N1)
      INSTIN = 0.D0
      CALL NMCRLI(FONACT,INSTIN,LISINS,SDDISC)

C     ----------------------------------------
C     NEWTON
C     ----------------------------------------
      PRED=1
      CALL GETVTX('NEWTON','PREDICTION',1,IARG,1,PREDIC,N1)
      IF (N1.NE.0) THEN
         IF (PREDIC.EQ.'ELASTIQUE') PRED=0
      ENDIF
      MATREL=0
      OPTION='FULL_MECA'
      CALL GETVTX('NEWTON','MATRICE',1,IARG,1,MATRIC,N1)
      IF (N1.NE.0) THEN
         IF (MATRIC.EQ.'ELASTIQUE') THEN
            MATREL=1
            PRED=0
            OPTION='RAPH_MECA'
         ENDIF
      ENDIF
C     IMPL_EX N'EST PAS DISPONIBLE (FONACT : VOIR ISFONC)
      DO 99 I=1,28
         FONACT(I)=0
  99  CONTINUE
C     ----------------------------------------
C     LECTURE DES PARAMETRES DE CONVERGENCE
C     ----------------------------------------
      CALL NMDOCN(K24BID,PARCRI,PARCON)

C     SUBDIVISION AUTOMATIQUE DU PAS DE TEMPS
      CALL NMCRSU(SDDISC,LISINS,PARCRI,FONACT,SOLVEU)

      END
