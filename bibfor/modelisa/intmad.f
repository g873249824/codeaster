      FUNCTION INTMAD(DIME  ,NOMARL,
     &                NOMMA1,TYPEM1,CSOM1 ,NBNO1  ,CPAN1  ,
     &                CSOM2 ,NBNO2 ,ARE2  ,NARE2  ,PAN2,
     &                FA2   ,NPAN2 ,TRAVR ,TRAVI  ,TRAVL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 07/07/2008   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      REAL*8       INTMAD
      INTEGER      DIME
      CHARACTER*8  NOMARL
      CHARACTER*8  TYPEM1,NOMMA1
      INTEGER      NBNO1
      REAL*8       CSOM1(DIME,*)
      REAL*8       CPAN1(DIME+2,*)
      INTEGER      NBNO2
      REAL*8       CSOM2(DIME,*)
      INTEGER      ARE2(*),PAN2(*),FA2(*)
      INTEGER      NARE2,NPAN2
      INTEGER      TRAVI(*)
      LOGICAL      TRAVL(*)
      REAL*8       TRAVR(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C RATIO VOLUME (MAILLE INTER DOMAINE) / VOLUME (MAILLE)
C
C ----------------------------------------------------------------------
C
C
C
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NOMMA1 : NOM DE LA PREMIERE MAILLE
C IN  TYPEM1 : TYPE DE LA PREMIERE MAILLE
C IN  COORD1 : COORDONNEES DES NOEUDS DE LA PREMIERE MAILLE
C IN  NBNO1  : NOMBRE DE NOEUDS DE LA PREMIERE MAILLE
C IN  CPAN1  : PANS DE LA PREMIERE MAILLE (CF. BOITE)
C IN  COORD2 : COORDONNEES DES NOEUDS DE LA FRONTIERE DU DOMAINE
C IN  NBNO2  : NOMBRE DE NOEUDS DE LA FRONTIERE DU DOMAINE
C IN  ARE2   : CONNECTIVITE ARETES DE FRONTIERE (CF. ARFACE)
C IN  NARE2  : NOMBRE D'ARETES DE LA FRONTIERE
C IN  PAN2   : CONNECTIVITE FACES DE FRONTIERE (CF. NAFINT)
C IN  FA2    : GRAPHE FACES -> ARETES (CF. ARFACE)
C IN  NPAN2  : NOMBRE DE FACES DE LA FRONTIERE
C
C I/O TRAVR  : VECTEURS DE TRAVAIL DE REELS
C                DIME : 35*NBNO2*NHINT**2 + 66*NHINT**2 + 18*(NHINT+1)
C I/O TRAVI  : VECTEURS DE TRAVAIL D'ENTIERS
C                DIME : (NBNO2+6)*(50*NHINT**2+22*NHINT+22) +
C                         162*NBNO2*NHINT**2
C IN  TRAVL  : VECTEURS DE TRAVAIL DE BOOLEENS
C                DIME : 2*(NBNO2+6)*NHINT**2
C
C ----------------------------------------------------------------------
C
      INTEGER     ZMXARE,ZMXPAN,ZMXNOE
      PARAMETER   (ZMXARE = 48,ZMXPAN = 60,ZMXNOE = 27)
C
      REAL*8      PRECVV,PRECTR,ARLGER
      INTEGER     NHINT,NCMAX,ARLGEI
      INTEGER     NBARE,NBPAN,NBSOM
      REAL*8      PLVOL2,PLVOL3,DDOT
      INTEGER     NARE1,NPAN1,NSOM
      INTEGER     NFAC,NFAC1,NFAC2
      INTEGER     NSEG,NSEG1,NSEG2
      INTEGER     N,NC,NS,NF,NECH,NSOM2,NSOM1
      INTEGER     IFAC,ISEG
      INTEGER     ARE1(ZMXARE),PAN1(ZMXPAN)
      INTEGER     S1,S2,S3,PAS,PFS,PAF,PEQ,PZR,P,Q,I,J,K
      REAL*8      R,V0,VI,PREC,DIMH
      CHARACTER*8 TYPEM2,NOMMA2
      INTEGER     OFFSOM,OFFFAC,OFFSEG,OFFARE
      INTEGER     IFM,NIV

      INTEGER      NR,NK,NI
      PARAMETER   ( NR = 1 , NK = 2 , NI = 1)
      INTEGER      VALI(NI)
      REAL*8       VALR(NR)
      CHARACTER*24 VALK(NK)

      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='INTMAD')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- AFFICHAGE
C
      VALK(1)=NOMMA1
      VALK(2)=TYPEM1
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NI,VALI,NR,VALR,NK,VALK)
C
C --- PARAMETRES
C
      NHINT  = ARLGEI(NOMARL,'NHINT ')
      PRECVV = ARLGER(NOMARL,'PRECVV')
      NCMAX  = ARLGEI(NOMARL,'NCMAX ')
C
C --- INITIALISATIONS
C
      IF (DIME.EQ.3) NCMAX = 2*NCMAX
      N = NHINT**2
      P = NHINT + 1
      Q = NBNO2 + 6
      PFS = Q*(26*N+12*P) + 96*NBNO2*N
      PAS = Q*(38*N+18*P) + 114*NBNO2*N
      PAF = Q*(44*N+20*P) + 138*NBNO2*N
      PEQ = 21*NBNO2*N + 18*(N+P)
      PZR = 29*NBNO2*N + 66*N + 18*P
      TYPEM2 = 'FRONTIER'
      NOMMA2 = 'FRONTIER'
C
C --- VERIFICATIONS
C
      IF (NBNO1.GT.ZMXNOE) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
      IF ((DIME.LT.2).OR.(DIME.GT.3)) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- VALEUR ECHANTILLONNAGE: NHINT CAR SUIVANT SCHEMA INTEGRATION
C
      NECH   = NHINT
C
C --- ORIENTATION DE MA1
C
      CALL ORIEM2(TYPEM1,CSOM1)
C
C --- CARACTERISTIQUES MA1: NBRE ARETES/PANS
C
      NBNO1 = NBSOM(TYPEM1)
      NARE1 = NBARE(TYPEM1)
      NPAN1 = NBPAN(TYPEM1)
C
C --- CARACTERISTIQUES MA1: CONNECTIVITES ARETES/PANS
C
      CALL NOARE(TYPEM1,ARE1)
      CALL NOPAN(TYPEM1,PAN1)
C
C --- ECHANTILLONNAGE PONCTUEL
C
      CALL ARLDBG(NOMPRO,NIV,IFM,2,NI,VALI,NR,VALR,NK,VALK)
C
      P = 1
      DO 10 I = 1, NPAN1
        NS   = PAN1(P)
        DIMH = 0.D0
        DO 20 J = 1, DIME
          R    = CPAN1(J,I)
          DIMH = DIMH + R*R
 20     CONTINUE
        PREC = PRECVV/DIMH
        DO 30 J = 1, DIME
          R = PREC*CPAN1(J,I)
          DO 31 K = 1, ABS(NS)
            N = PAN1(P+K)
            CSOM1(J,N) = CSOM1(J,N) - R
 31       CONTINUE
 30     CONTINUE
        P = P + ABS(NS) + 1
 10   CONTINUE
C
C --- ECHANTILLONNAGE DE LA FRONTIERE DES MAILLES 1&2
C --- STOCKAGE DES COORDONNEES FRONTIERE DANS TRAVR
C --- POINTS AJOUTES+SOMMETS ORIGINAUX (NBNO)
C  -> TRAVR(1->DIME*NSOM1)             - COORD. FRONTIERE MAILLE 1
C  -> TRAVR(1->DIME*NSOM1,DIME*NBNO2)) - COORD. FRONTIERE MAILLE 2
C
      CALL ARLDBG(NOMPRO,NIV,IFM,3,NI,VALI,NR,VALR,NK,VALK)
C
      CALL ECHMAP(NOMMA1,TYPEM1,DIME  ,CSOM1   ,NBNO1 ,
     &            ARE1  ,NARE1 ,PAN1  ,NPAN1   ,NECH  ,
     &            TRAVR               ,NSOM1)
C
      CALL ARLDBG(NOMPRO,NIV,IFM,4,NI,VALI,NR,VALR,NK,VALK)
C
      CALL ECHMAP(NOMMA2,TYPEM2,DIME  ,CSOM2   ,NBNO2 ,
     &            ARE2  ,NARE2 ,PAN2  ,NPAN2   ,NECH  ,
     &            TRAVR(1+DIME*NSOM1) ,NSOM2)
C
C --- NOUVEAU NOMBRE DE SOMMETS (AVEC ECHANTILLONNAGE)
C
      NSOM = NSOM1 + NSOM2
C
C --- CONNECTIVITE DE L'ECHANTILLONNAGE DE LA FRONTIERE DES MAILLES 1&2
C --- STOCKAGE DES CONNECTIVITES DANS TRAVI
C
      CALL ARLDBG(NOMPRO,NIV,IFM,5,NI,VALI,NR,VALR,NK,VALK)
C
      OFFSOM = 0
      OFFSEG = 0
      OFFFAC = 0
      OFFARE = 0
C
      CALL ECHMCO(NOMMA1,TYPEM1,DIME  ,NECH  ,
     &            NBNO1 ,NARE1 ,NPAN1 ,ARE1  ,PAN1  ,
     &            OFFSOM,OFFSEG,OFFFAC,OFFARE,
     &            PFS   ,PAS   ,PAF   ,
     &            TRAVI ,NSEG1 ,NFAC1)
C
      CALL ARLDBG(NOMPRO,NIV,IFM,6,NI,VALI,NR,VALR,NK,VALK)
C
      OFFSOM = NSOM1
      OFFSEG = NSEG1
      OFFFAC = NFAC1
      OFFARE = NARE1
C
      IF (DIME.EQ.2) THEN
        CALL ECHMCO(NOMMA2,TYPEM2,DIME  ,NECH  ,
     &              NBNO2 ,NARE2 ,NPAN2 ,ARE2  ,PAN2  ,
     &              OFFSOM,OFFSEG,OFFFAC,OFFARE,
     &              PFS   ,PAS   ,PAF   ,
     &              TRAVI ,NSEG2 ,NFAC2)
      ELSE
        CALL ECHMCO(NOMMA2,TYPEM2,DIME  ,NECH  ,
     &              NBNO2 ,NARE2 ,NPAN2 ,FA2   ,PAN2  ,
     &              OFFSOM,OFFSEG,OFFFAC,OFFARE,
     &              PFS   ,PAS   ,PAF   ,
     &              TRAVI ,NSEG2 ,NFAC2)
      ENDIF
C
C --- NOMBRE D'ENTITES (SEGMENTS EN 2D, FACETTES EN 3D)
C
      IF (DIME.EQ.2) THEN
        NSEG  = NSEG1 + NSEG2
      ELSEIF (DIME.EQ.3) THEN
        NFAC  = NFAC1 + NFAC2
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- EQUATIONS DE DROITES / PLANS
C EN 2D
C  -> TRAVI(PEQ->PEQ+3*NSEG) - LES 3 COEF. DES DROITES FRONTIERES
C         (INDICEE PAR NUMERO SEGMENT)
C EN 3D
C  -> TRAVI(PEQ->PEQ+4*NFAC) - LES 4 COEF. DES PLANS FRONTIERES
C         (INDICEE PAR NUMERO FACETTE)
C
      IF (DIME.EQ.2) THEN
        CALL ARLDBG(NOMPRO,NIV,IFM,7,NI,VALI,NR,VALR,NK,VALK)
        DO 50 ISEG = 1, NSEG
          P  = PFS + 2*ISEG
          S1 = 2*TRAVI(P-2)
          S2 = 2*TRAVI(P-1)
          P  = PEQ + 3*ISEG
          TRAVR(P-3) = TRAVR(S2)   - TRAVR(S1)
          TRAVR(P-2) = TRAVR(S1-1) - TRAVR(S2-1)
          TRAVR(P-1) = TRAVR(S2-1)*TRAVR(S1) - TRAVR(S1-1)*TRAVR(S2)
 50     CONTINUE
      ELSE
        CALL ARLDBG(NOMPRO,NIV,IFM,8,NI,VALI,NR,VALR,NK,VALK)
        DO 60 IFAC = 1, NFAC
          P = PFS + 3*IFAC
          S1 = 3*TRAVI(P-3)-2
          S2 = 3*TRAVI(P-2)-2
          S3 = 3*TRAVI(P-1)-2
          P = PEQ + 4*IFAC - 4
          CALL PROVE3(TRAVR(S1),TRAVR(S2),TRAVR(S3),TRAVR(P))
          TRAVR(P+3) = -DDOT(3,TRAVR(P),1,TRAVR(S1),1)
 60     CONTINUE
      ENDIF
C
C --- VOLUME DU POLYEDRE MA1
C
      IF (DIME.EQ.2) THEN
        P = 1
        Q = PFS
        TRAVI(P) = NSOM1
        DO 62 I = 1, NSOM1
          P = P + 1
          TRAVI(P) = TRAVI(Q)
          Q = Q + 2
 62     CONTINUE
        V0 = PLVOL2(2,TRAVR,TRAVR,TRAVI,NSOM1)
        VALR(1)=V0
        CALL ARLDBG(NOMPRO,NIV,IFM,9,NI,VALI,NR,VALR,NK,VALK)
      ELSE
        V0 = PLVOL3(TRAVR,TRAVI(PFS),NFAC1)
        VALR(1)=V0
        CALL ARLDBG(NOMPRO,NIV,IFM,10,NI,VALI,NR,VALR,NK,VALK)
      ENDIF
C
C --- INTERSECTION DE LA MAILLE AVEC LE DOMAINE
C
      IF (DIME.EQ.2) THEN
        CALL ARLDBG(NOMPRO,NIV,IFM,11,NI,VALI,NR,VALR,NK,VALK)
        CALL PLINT2(TRAVR ,NSOM  ,TRAVI(PFS),TRAVR(PEQ),NCMAX ,
     &              NSEG1 ,NSEG2 ,TRAVR(PZR),TRAVI(PAS),TRAVL ,
     &              NC)
      ELSE
        CALL ARLDBG(NOMPRO,NIV,IFM,12,NI,VALI,NR,VALR,NK,VALK)
        CALL PLINT3(TRAVR ,NSOM ,TRAVI(PFS),TRAVR(PEQ),NCMAX,
     &              PRECTR,NFAC1 ,NFAC2 ,TRAVI(PAS),TRAVI(PAF),
     &              NARE1,NARE2,TRAVR(PZR),TRAVI,TRAVL,
     &              NC)
        DO 70 I = 1, NC
          PAN2(I) = TRAVI(I)
 70     CONTINUE

      ENDIF
C
C --- TROP DE COMPOSANTES CONNEXES
C
      IF (NC.GT.NCMAX) THEN
        CALL U2MESS('A','ARLEQUIN_24')
      ENDIF
C
C --- PAS D'INTERSECTION
C
      IF (NC.EQ.0) THEN
        CALL ARLDBG(NOMPRO,NIV,IFM,13,NI,VALI,NR,VALR,NK,VALK)
        INTMAD = 1.D0
        GOTO 100
      ENDIF
C
C --- VOLUME DE L'INTERSECTION
C
      VI = 0.D0
      IF (DIME.EQ.2) THEN
        DO 80 I = 1, NC
          NS  = TRAVI(PAS)
          VI  = VI + PLVOL2(2,TRAVR,TRAVR,TRAVI(PAS+1),NS)
          PAS = PAS + NS + 1
 80     CONTINUE
        VALR(1)=VI
        CALL ARLDBG(NOMPRO,NIV,IFM,14,NI,VALI,NR,VALR,NK,VALK)
      ELSE
        DO 90 I = 1, NC
          NF  = PAN2(I)
          VI  = VI + PLVOL3(TRAVR,TRAVI(PFS),NF)
          PFS = PFS + 3*NF
 90     CONTINUE
        VALR(1)=VI
        CALL ARLDBG(NOMPRO,NIV,IFM,15,NI,VALI,NR,VALR,NK,VALK)
      ENDIF
C
C --- RATIO
C
      INTMAD = VI / V0

 100  CONTINUE
C
      CALL JEDEMA()
      END
