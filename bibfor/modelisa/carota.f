      SUBROUTINE CAROTA(CHAR,NOMA,IROTA,NDIM,LIGRMO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
C BUT : STOCKAGE DE LA ROTATION DANS UNE CARTE ALLOUEE SUR LE
C       LIGREL DU MODELE
C
C ARGUMENTS D'ENTREE:
C      CHAR: NOM UTILISATEUR DU RESULTAT DE CHARGE
C      NOMA : NOM DU MAILLAGE
C     IROTA : OCCURENCE DU MOT-CLE FACTEUR ROTATION
C     NDIM : DIMENSION DU PROBLEME
C     LIGRMO : NOM DU LIGREL DE MODELE
C
C ROUTINES APPELEES:
      REAL*8  ROTA(7),NORME,R8MIEM
      COMPLEX*16 CBID
      CHARACTER*8  CHAR,NOMA,LICMP(7),K8B,K8TOUT
      CHARACTER*19 CARTE
      INTEGER IOCC,IROTA, NBMAIL, NBGPMA
      INTEGER IBID, IER, JMA, JNCMP, JVALV
      INTEGER NBMA, NCMP, NDIM, NROTA,N1,N2,NBTOUT
      CHARACTER*24  MESMAI
      CHARACTER*(*) LIGRMO
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      CHARACTER*8  TYPMCL(2)
      CHARACTER*16 MOTCLE(2)
      INTEGER      IARG
C
      DO 10 IOCC = 1, IROTA

        CALL GETVR8 ('ROTATION','VITESSE',IOCC,IARG,1,ROTA(1),N1)
        CALL GETVR8 ('ROTATION','AXE',IOCC,IARG,3,ROTA(2),N2)
        CALL GETVR8 ('ROTATION','CENTRE',IOCC,IARG,3,ROTA(5),NROTA)

        IF (N1.GT.0) THEN
         CALL ASSERT(N1.EQ.1)
         CALL ASSERT(N2.EQ.3)
         NORME=SQRT( ROTA(2)*ROTA(2)+ROTA(3)*ROTA(3)+ROTA(4)*ROTA(4) )
         IF (NORME.GT.R8MIEM()) THEN
            ROTA(2)=ROTA(2)/NORME
            ROTA(3)=ROTA(3)/NORME
            ROTA(4)=ROTA(4)/NORME
         ELSE
            CALL U2MESS('F','MODELISA3_63')
         END IF
        ENDIF
        CALL GETVTX ('ROTATION','MAILLE', IOCC,IARG,1,K8B,NBMAIL)
        CALL GETVTX ('ROTATION','GROUP_MA', IOCC,IARG,1,K8B,NBGPMA)
        CALL GETVTX ('ROTATION','TOUT', IOCC,IARG,1,K8TOUT,NBTOUT)
        NBMA = NBMAIL+NBGPMA

C
C   SI NBMA = 0, ALORS IL N'Y A AUCUN MOT CLE GROUP_MA OU MAILLE ,
C   DONC LA ROTATION S'APPLIQUE A TOUT LE MODELE (VALEUR PAR DEFAUT)
C
        IF ((NBMA.EQ.0).AND.(NBTOUT.EQ.1)) THEN
C
C   UTILISATION DE LA ROUTINE MECACT (PAS DE CHANGEMENT PAR RAPPORT
C   A LA PRECEDENTE FACON DE PRENDRE EN COMPTE LA PESANTEUR)
C
          CARTE=CHAR//'.CHME.ROTAT'
          LICMP(1)='OME'
          LICMP(2)='AR'
          LICMP(3)='BR'
          LICMP(4)='CR'
          LICMP(5)='X'
          LICMP(6)='Y'
          LICMP(7)='Z'
          CALL MECACT('G',CARTE,'MAILLA',NOMA,'ROTA_R',7,LICMP,0,ROTA,
     +            CBID,' ')
C
        ELSE IF ((NBMA.NE.0).AND.(K8TOUT.EQ.'NON')) THEN
C
C   APPLICATION DE LA ROTATION AUX MAILLES OU GROUPES DE MAILLES
C   MENTIONNES. ROUTINE MODIFIEE ET CALQUEE SUR LA PRISE EN COMPTE
C   D'UNE ROTATION (CBROTA ET CAROTA)
C
          CARTE=CHAR//'.CHME.ROTAT'
          CALL ALCART ( 'G', CARTE, NOMA, 'ROTA_R')
          CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
          CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
C
C --- STOCKAGE DE FORCES NULLES SUR TOUT LE MAILLAGE
C
          NCMP = 7
          ZK8(JNCMP)='OME'
          ZK8(JNCMP+1)='AR'
          ZK8(JNCMP+2)='BR'
          ZK8(JNCMP+3)='CR'
          ZK8(JNCMP+4)='X'
          ZK8(JNCMP+5)='Y'
          ZK8(JNCMP+6)='Z'
C
          ZR(JVALV)   = 0.D0
          ZR(JVALV+1) = 0.D0
          ZR(JVALV+2) = 0.D0
          ZR(JVALV+3) = 0.D0
          ZR(JVALV+4) = 0.D0
          ZR(JVALV+5) = 0.D0
          ZR(JVALV+6) = 0.D0

          CALL NOCART (CARTE,1,' ','NOM',0,' ',0,' ',NCMP)
C
          MESMAI = '&&CAROTA.MES_MAILLES'
          MOTCLE(1) = 'GROUP_MA'
          MOTCLE(2) = 'MAILLE'
          TYPMCL(1) = 'GROUP_MA'
          TYPMCL(2) = 'MAILLE'

C
C --- STOCKAGE DANS LA CARTE
C
          ZR(JVALV)   = ROTA(1)
          ZR(JVALV+1) = ROTA(2)
          ZR(JVALV+2) = ROTA(3)
          ZR(JVALV+3) = ROTA(4)
          ZR(JVALV+4) = ROTA(5)
          ZR(JVALV+5) = ROTA(6)
          ZR(JVALV+6) = ROTA(7)

C
          CALL RELIEM(LIGRMO, NOMA, 'NO_MAILLE', 'ROTATION', IOCC, 2,
     &                                  MOTCLE, TYPMCL, MESMAI, NBMA )
          IF (NBMA.EQ.0) GOTO 10
          CALL JEVEUO ( MESMAI, 'L', JMA )
          CALL VETYMA ( NOMA,ZK8(JMA),NBMA,K8B,0,'ROTATION',NDIM,IER)
          CALL NOCART (CARTE,3,K8B,'NOM',NBMA,ZK8(JMA),IBID,' ',NCMP)
          CALL JEDETR ( MESMAI )
        ELSE IF ((NBMA.NE.0).AND.(K8TOUT.EQ.'OUI')) THEN
            CALL U2MESS('F','MODELISA3_40')
        ENDIF
 10   CONTINUE
      END
