      SUBROUTINE AMOGEN(MAT19)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 11/07/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*19  MAT19
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  MASSE,RAID,K8BID,LISTAM
      CHARACTER*16 NOMCMD
      CHARACTER*32 JEXNUM
      INTEGER IEXEC, NBID, NBLOC,JAMOG,IAMOG,IDIFF
      INTEGER IAMAT,N,M,M2,I,IAM,IAK,J,NBAMOR,NLIST
      INTEGER IBLO,IDESC,IALIME,IACONL,JREFA,JREFA2,IADESC,N2,N1
      REAL*8  DELTA, SUM,R8BID

      CALL JEMARQ()

      NOMCMD = 'CALC_AMOR_GENE'
      CALL GETVID(NOMCMD, 'MASS_GENE', 1,1,1,MASSE,NBID)
      CALL GETVID(NOMCMD, 'RIGI_GENE', 1,1,1,RAID,NBID)
C     CALL VERISD('MATRICE',MASSE)
C     CALL VERISD('MATRICE',RAID)
      CALL GETVR8(NOMCMD, 'AMOR_REDUIT', 1,1,0, R8BID, N1)
      CALL GETVID(NOMCMD,'LIST_AMOR',1,1,0,K8BID,N2)
      CALL JEVEUO(MASSE//'           .DESC','E',IDESC)
      N=ZI(IDESC+1)
      CALL JELIRA(MASSE//'           .VALM','LONMAX',M,K8BID)
      CALL JELIRA(RAID//'           .VALM','LONMAX',M2,K8BID)
      IF (M2.NE.M) THEN
        CALL UTDEBM('F','AMOGEN',
     &   'LES NOMBRES DE TERMES DES MATRICES RIGI ET MASSE DIFFERENT')
        CALL UTIMPI('L','CELUI DE LA MATRICE MASSE VAUT : ',1,M)
        CALL UTIMPI('L','CELUI DE LA MATRICE RIGI VAUT : ',1,M2)
        CALL UTFINM()
      END IF

      IF (N1.NE.0) THEN
        NBAMOR = -N1
      ELSE
        CALL GETVID(NOMCMD,'LIST_AMOR',1,1,1,LISTAM,NLIST)
        CALL JELIRA(LISTAM//'           .VALE','LONMAX',NBAMOR,K8BID)
      END IF

      IF (NBAMOR.GT.N) THEN

        CALL UTDEBM('A','AMOGEN',
     &          'LE NOMBRE D''AMORTISSEMENTS REDUITS EST TROP GRAND'
     &              )
        CALL UTIMPI('L','LE NOMBRE DE MODES PROPRES VAUT ',1,N)
        CALL UTIMPI('L','ET LE NOMBRE DE COEFFICIENTS : ',1,NBAMOR)
        CALL UTIMPI('L','ON NE GARDE DONC QUE LES ',1,N)
        CALL UTIMPK('S',' ',1,'PREMIERS COEFFICIENTS')
        CALL UTFINM()
        CALL WKVECT('&&AMORMA.AMORTI','V V R8',N,JAMOG)
        IF (N1.NE.0) THEN
          CALL GETVR8(NOMCMD,'AMOR_REDUIT',1,1,N,ZR(JAMOG),NBID)
        ELSE
          CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
          DO 30 I = 1,N
            ZR(JAMOG+I-1) = ZR(IAMOG+I-1)
30        CONTINUE
        END IF
      ELSE
        CALL WKVECT('&&AMORMA.AMORTI','V V R8',N,JAMOG)
        IF (N1.NE.0) THEN
          CALL GETVR8(NOMCMD,'AMOR_REDUIT',1,1,NBAMOR,ZR(JAMOG),NBID)
        ELSE
          CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
          DO 40 I = 1,NBAMOR
            ZR(JAMOG+I-1) = ZR(IAMOG+I-1)
40        CONTINUE
        ENDIF
        IF (NBAMOR.LT.N) THEN
           DO 41 I = NBAMOR+1,N
             ZR(JAMOG+I-1) = ZR(JAMOG+NBAMOR-1)
41         CONTINUE

           IDIFF = N - NBAMOR
           CALL UTDEBM('I','AMOGEN',
     &            'LE NOMBRE D''AMORTISSEMENTS REDUITS EST INSUFFISANT'
     &                 )
           CALL UTIMPI('L','IL EN MANQUE : ',1,IDIFF)
           CALL UTIMPI('L','CAR LE NOMBRE DE MODES VAUT : ',1,N)
           CALL UTIMPI('L','ON RAJOUTE ',1,IDIFF)
           CALL UTIMPK('S',' ',1,'AMORTISSEMENTS REDUITS AVEC LA')
           CALL UTIMPK('S',' ',1,'VALEUR DU DERNIER MODE PROPRE')
           CALL UTFINM()
         ENDIF
      ENDIF
      IBLO=1
      CALL JEVEUO(MASSE//'           .REFA','E',JREFA)
C
C   CREATION DES BASES DE DONNEES DE LA MATRICE A GENERER.
C   SUIVANT LE MODELE DE OP0071
C
      CALL JECREC(MAT19//'.VALM','G V R','NU','DISPERSE',
     &                     'CONSTANT',1)
      CALL JECROC(JEXNUM(MAT19//'.VALM',IBLO))
      CALL JEECRA(MAT19//'.VALM','LONMAX',M,K8BID)
      CALL WKVECT(MAT19//'.LIME','G V K8',1,IALIME)
      CALL WKVECT(MAT19//'.CONL','G V R',N,IACONL)
      CALL WKVECT(MAT19//'.REFA','G V K24',10,JREFA2)
      ZK24(JREFA2-1+1) = ZK24(JREFA-1+1)
      ZK24(JREFA2-1+2) = ZK24(JREFA-1+2)
      ZK24(JREFA2-1+9) = 'MS'
      ZK24(JREFA2-1+10) = 'GENE'
C
C ----- CREATION DU .DESC
C
      CALL WKVECT(MAT19//'.DESC','G V I',3,IADESC)
      ZI(IADESC)   = 2
      ZI(IADESC+1) = N
      ZI(IADESC+2) = 2
C
      ZK8(IALIME) = '        '
C
      DO 170 I = 1,N
        ZR(IACONL+I-1) = 1.0D0
170   CONTINUE

      IBLO=1
      CALL JEVEUO(JEXNUM(MASSE//'           .VALM',IBLO),'L',IAM)
      CALL JEVEUO(JEXNUM(RAID//'           .VALM',IBLO),'L',IAK)
      CALL JEVEUO(JEXNUM(MAT19//'.VALM',IBLO),'E',IAMAT)
      DO 180 I=1,M
         ZR(IAMAT-1+I)=0D0
180   CONTINUE
      DO 190 I=1,N
         IF (M.EQ.N*(N+1)/2) THEN
            J=I*(I+1)/2-1
         ELSEIF (M.EQ.N) THEN
            J=I-1
         ELSE
            GOTO 190
         ENDIF
         ZR(IAMAT+J)=2.0D0*ZR(JAMOG+I-1)*SQRT(ZR(IAM+J) * ZR(IAK+J))
190   CONTINUE
      CALL JEDETR('&&AMORMA.AMORTI')
9999  CONTINUE
      CALL JEDEMA()
C     CALL VERISD('MATRICE',MAT19)
      END
