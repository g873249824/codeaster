      SUBROUTINE MLTFCB(NBLOC,NCBLOC,DECAL,LGBLOC,NBSN,
     +                  SUPND, FILS,FRERE,SEQ,
     +                  LGSN,LFRONT,ADRESS,LOCAL,LGPILE,NBASS,ADPER,T1,
     +                  T2,FACTOL,FACTOU,TYPSYM,AD,NOMPIL,NMPILU,EPS,
     +                  IER,SBLOC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/01/2002   AUTEUR JFBHHUC C.ROSE 
C RESPONSABLE JFBHHUC C.ROSE
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
C TOLE CRP_21
C     VERSION MODIFIEE POUR L' APPEL A DGEMV (PRODUITS MATRICE-VECTEUR)
C     LE STOCKAGE DES COLONNES DE LA FACTORISEE EST MODIFIE, ET AINSI
C      ADPER LES COLONNES FORMENT UN BLOC RECTANGULAIRE
C
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER PMIN
      PARAMETER (PMIN=10)
      INTEGER NBLOC,NCBLOC(*),DECAL(*),LGBLOC(*)
      INTEGER NBSN,LGSN(*),LFRONT(*),TYPSYM,SUPND(*)
      INTEGER LOCAL(*),NBASS(*),LGPILE(*),FILS(*)
      INTEGER ADRESS(*),FRERE(*),SEQ(*),AD(*)
      CHARACTER*32 JEXNUM,JEXNOM
      CHARACTER*24 FACTOL,FACTOU,NOMPIL,NMPILU
C
      REAL*8 T1(*),T2(*),EPS
      INTEGER ADPER(*),IFACL,IFACU,PPERE,PFILS,IER,SBLOC,PPEREU,PFILSU
      INTEGER LG
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8,CARACI
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      COMMON /IMLTF1/SNI
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER I,J,ISND,SNI,SN,N,M,P,NL,NC,MEM,ADFACL,IB,NB,LN,L,ADFACU
      CALL JEMARQ()
      IF (SBLOC.EQ.1) THEN
C=======================================================================
C     CREATION D'UNE COLLECTION DISPERSEE
        CALL JECREC(NOMPIL,' V V R ','NO','DISPERSE','VARIABLE',NBSN)
        DO 10 I = 1,NBSN
          WRITE (CARACI,'(I8)') I
          CALL JECROC(JEXNOM(NOMPIL,CARACI))
          LG= LFRONT(I)
          LGPILE(I)=(LG*(LG+1))/2
          CALL JEECRA(JEXNOM(NOMPIL,CARACI),'LONMAX',LGPILE(I),' ')
   10   CONTINUE
        IF (TYPSYM.EQ.0) THEN
C     CREATION D'UNE AUTRE COLLECTION DISPERSEE ( CAS NON SYMETRIQUE)
          CALL JECREC(NMPILU,' V V R ','NO','DISPERSE','VARIABLE',NBSN)
          DO 20 I = 1,NBSN
            WRITE (CARACI,'(I8)') I
            CALL JECROC(JEXNOM(NMPILU,CARACI))
            CALL JEECRA(JEXNOM(NMPILU,CARACI),'LONMAX',LGPILE(I),' ')
   20     CONTINUE
        END IF
      END IF
      PRINT *,'MLTFCB '
      ISND = 0
      DO 40 IB = 1,SBLOC - 1
        DO 30 NC = 1,NCBLOC(IB)
          ISND = ISND + 1
   30   CONTINUE
   40 CONTINUE
      DO 110 IB = SBLOC,NBLOC
        DO 100 NC = 1,NCBLOC(IB)
          ISND = ISND + 1
          SNI = SEQ(ISND)
          P = LGSN(SNI)
          M = LFRONT(SNI)
          N = M + P
          IF (M.NE.0) THEN
            CALL JEVEUO(JEXNUM(NOMPIL,SNI),'E',PPERE)
            IF (TYPSYM.EQ.0) THEN
              CALL JEVEUO(JEXNUM(NMPILU,SNI),'E',PPEREU)
            END IF
          END IF
          DO 19 I=1,P
             ADPER(I) = (I-1)*N+I
 19       CONTINUE
          DO 50 I = P,N - 1
             ADPER(I+1) = 1 + (N+ (N-I+1))*I/2
 50       CONTINUE
          SN = FILS(SNI)
C     BOUCLE D ASSEMBLAGE
C------------------------------------------------------------------
C     ASSEMBLAGE POUR LA PARTIE INFERIEURE
C     C
   60     CONTINUE
          IF (SN.NE.0) THEN
            CALL JEVEUO(JEXNUM(NOMPIL,SN),'L',PFILS)
            NL = LGSN(SN)
            NB = NBASS(SN)
C     ASSEMBLAGE FILS -> PERE ( INFERIEURE)
C
            CALL MLTAFF(LFRONT(SN),NB,ADPER,ZR(PPERE),ZR(PFILS),
     +                  LOCAL(ADRESS(SN)+NL),P)
            CALL JELIBE(JEXNUM(NOMPIL,SN))
            SN = FRERE(SN)
            GO TO 60
          END IF
          IF (M.NE.0) CALL JELIBE(JEXNUM(NOMPIL,SNI))
C
          CALL JEVEUO(JEXNUM(FACTOL,IB),'E',IFACL)
          ADFACL = IFACL - 1 + DECAL(SNI)
          SN = FILS(SNI)
   70     CONTINUE
C     ASSEMBLAGE FILS -> FACTOR ( INFERIEURE)
          IF (SN.NE.0) THEN
            CALL JEVEUO(JEXNUM(NOMPIL,SN),'L',PFILS)
            NL = LGSN(SN)
            NB = NBASS(SN)
            CALL MLTAFP(LFRONT(SN),NB,ADPER,ZR(ADFACL),ZR(PFILS),
     +                  LOCAL(ADRESS(SN)+NL))
C     ON DETRUIT LA MATRICE FRONTALE QUI NE SERA PLUS UTILISEE
            CALL JEDETR(JEXNUM(NOMPIL,SN))
            SN = FRERE(SN)
            GO TO 70
          END IF
C------------------------------------------------------------------
C     ASSEMBLAGE POUR LA PARTIE SUPERIEURE
C
          IF (TYPSYM.EQ.0) THEN
            CALL JELIBE(JEXNUM(FACTOL,IB))
            SN = FILS(SNI)
   80       CONTINUE
            IF (SN.NE.0) THEN
              CALL JEVEUO(JEXNUM(NMPILU,SN),'L',PFILSU)
              NL = LGSN(SN)
              NB = NBASS(SN)
C     ASSEMBLAGE FILS -> PERE ( SUPERIEURE)
              CALL MLTAFF(LFRONT(SN),NB,ADPER,ZR(PPEREU),ZR(PFILSU),
     +                    LOCAL(ADRESS(SN)+NL),P)
              CALL JELIBE(JEXNUM(NMPILU,SN))
              SN = FRERE(SN)
              GO TO 80
            END IF
            IF (M.NE.0) CALL JELIBE(JEXNUM(NMPILU,SNI))
            CALL JEVEUO(JEXNUM(FACTOU,IB),'E',IFACU)
            ADFACU = IFACU - 1 + DECAL(SNI)
            SN = FILS(SNI)
   90       CONTINUE
            IF (SN.NE.0) THEN
              CALL JEVEUO(JEXNUM(NMPILU,SN),'L',PFILSU)
              NL = LGSN(SN)
              NB = NBASS(SN)
C     ASSEMBLAGE FILS -> FACTOR ( SUPERIEURE)
              CALL MLTAFP(LFRONT(SN),NB,ADPER,ZR(ADFACU),ZR(PFILSU),
     +                    LOCAL(ADRESS(SN)+NL))
C     ON DETRUIT LA MATRICE FRONTALE QUI NE SERA PLUS UTILISEE
              CALL JEDETR(JEXNUM(NMPILU,SN))
              SN = FRERE(SN)
              GO TO 90
            END IF
          END IF
C
C     FIN DE L'ASSEMBLAGE POUR LA PARTIE SUPERIEURE
C------------------------------------------------------------------
C
C     FACTORISATION
          IF (TYPSYM.EQ.1) THEN
            IF (M.NE.0) CALL JEVEUO(JEXNUM(NOMPIL,SNI),'E',PPERE)
            IF (P.LE.PMIN) THEN
              CALL MLTF21(P,ZR(ADFACL),ZR(PPERE),N,T1,T2,EPS,IER)
              IF (IER.NE.0) GO TO 9999
            ELSE
              CALL MLTFLM(N,P,ZR(ADFACL),ADPER,T1,AD,EPS,IER)
              IF (IER.NE.0) GO TO 9999
              CALL MLTFMJ(N,P,ZR(ADFACL),ZR(PPERE),ADPER,T1,AD)
            END IF
            IF (M.NE.0) CALL JELIBE(JEXNUM(NOMPIL,SNI))
          ELSE
            CALL JEVEUO(JEXNUM(FACTOL,IB),'E',IFACL)
            ADFACL = IFACL - 1 + DECAL(SNI)
            CALL MLNFLM(N,P,ZR(ADFACL),ZR(ADFACU),ADPER,T1,T2,AD,EPS,
     +                  IER)
            IF (IER.NE.0) GO TO 9999
            IF (M.NE.0) CALL JEVEUO(JEXNUM(NOMPIL,SNI),'E',PPERE)
            CALL MLNFMG(N,P,ZR(ADFACL),ZR(ADFACU),ZR(PPERE),ADPER,T1,AD)
            IF (M.NE.0) CALL JELIBE(JEXNUM(NOMPIL,SNI))
            IF (M.NE.0) CALL JEVEUO(JEXNUM(NMPILU,SNI),'E',PPEREU)
            CALL MLNFMG(N,P,ZR(ADFACU),ZR(ADFACL),ZR(PPEREU),ADPER,T1,
     +                  AD)
            IF (M.NE.0) CALL JELIBE(JEXNUM(NMPILU,SNI))
            CALL JELIBE(JEXNUM(FACTOU,IB))
          END IF
          CALL JELIBE(JEXNUM(FACTOL,IB))
C
C
  100   CONTINUE
  110 CONTINUE
 9999 CONTINUE
      IF(IER.NE.0) IER =IER +SUPND(SNI)-1
      CALL JEDETR(NOMPIL)
      CALL JEDEMA()
      END
