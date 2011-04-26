      SUBROUTINE XORIFF(NDIM,NFON,JFON,JBAS,JBORD,PFI,O,VOR,AUTO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE
      INTEGER       NFON,JFON,JBORD,JBAS,NDIM
      REAL*8        PFI(3),O(3),VOR(3)
      LOGICAL       AUTO

C ----------------------------------------------------------------------
C       ORIENTATION DES POINTS DU FOND DE FISSURE DANS LE CADRE DE XFEM
C
C  ENTRESS :
C     NDIM  :   DIMENSION DU PROBLEME
C     JFON  :   ADRESSE DES POINTS DU FOND DE FISSURE DÉSORDONNÉS
C     JBAS :    ADRESSE DES DIRECTIONS DE PROPAGATION DÉSORDONNÉS
C     JBORD :   ADRESSE DES ATTRIBUTS 'POINT DE BORD' DÉSORDONNÉS
C     NFON  :   NOMBRE DE POINTS DU FOND DE FISSURE DÉSORDONNÉS
C     PFI   :   POINT DU FOND DE FISSURE DEMANDÉ
C     O     :   POINT ORIGINE DE L'ORIENTATION
C     VOR   :   VECTEUR D'ORIENTATION
C     AUTO  :   INFO SUR L'ORIENTATION AUTOMATIQUE
C
C  SORTIES :
C     JFON  :  ADRESSE DES POINTS DU FOND DE FISSURE ORDONNÉS
C     JBAS :    ADRESSE DES DIRECTIONS DE PROPAGATION ORDONNÉS
C     JBORD :  ADRESSE DES ATTRIBUTS 'POINT DE BORD' ORDONNÉS
C
C     ------------------------------------------------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER         I,PI,J,PD,PP,K
      REAL*8          R8MAEM,M(3),D,PADIST,A(3),OA(3),NOA,AM(3),PS,DIMIN
      REAL*8          PS1,LAMBDA,H(3),OH(3),NOH,COS,THETA,TRIGOM,R3(3)
      REAL*8          R8PI,TAMPON(4),EPS,DDOT
      LOGICAL         TAMPOL,DEJA0
      INTEGER         NBBORI,NBBORD,IDPB
C ----------------------------------------------------------------------

      CALL JEMARQ()

      EPS = -1.0D-10

      IF (AUTO) THEN
C       CAS ORIENTATION AUTOMATIQUE
        PI=1
      ELSE
C       CAS ORIENTATION UTILISATEUR
C       DÉTERMINATION DU NUMÉRO DU POINT LE PLUS PROCHE DE PFON_INI : A
        PI=0
        DIMIN=R8MAEM()
        DO 500 I=1,NFON
          M(1)=ZR(JFON-1+4*(I-1)+1)
          M(2)=ZR(JFON-1+4*(I-1)+2)
          M(3)=ZR(JFON-1+4*(I-1)+3)
          D=PADIST(3,PFI,M)
          IF (D.LT.DIMIN) THEN
            DIMIN=D
            PI=I
          ENDIF
 500    CONTINUE

      ENDIF

      DO 501 I=1,3
        A(I)=ZR(JFON-1+4*(PI-1)+I)
        OA(I)=A(I)-O(I)
 501  CONTINUE

      NOA=SQRT(OA(1)*OA(1) + OA(2)*OA(2)  +  OA(3)*OA(3))
      IF (NOA.LT.1.D-6) CALL U2MESS('F','XFEM2_20')

C     BOUCLE SUR LES POINTS M DE FONFIS POUR CALCULER L'ANGLE THETA
      DO 510 I=1,NFON
        DO 511 J=1,3
          M(J)=ZR(JFON-1+4*(I-1)+J)
          AM(J)=M(J)-A(J)
 511    CONTINUE
        PS=DDOT(3,AM,1,VOR,1)
        PS1=DDOT(3,VOR,1,VOR,1)
        LAMBDA=-PS/PS1
        DO 512 J=1,3
          H(J)=M(J)+LAMBDA*VOR(J)
          OH(J)=H(J)-O(J)
 512    CONTINUE
        PS=DDOT(3,OA,1,OH,1)
        NOH=SQRT(OH(1)*OH(1) + OH(2)*OH(2)  +  OH(3)*OH(3))
        IF (NOH.EQ.0) CALL U2MESS('F','XFEM2_21')
        COS=PS/(NOA*NOH)
        THETA=TRIGOM('ACOS',COS)
C       SIGNE DE THETA (06/01/2004)
        CALL PROVEC(OA,OH,R3)
        PS=DDOT(3,R3,1,VOR,1)

        IF (PS.LT.EPS) THETA = -1.D0 * THETA + 2.D0 * R8PI()
        ZR(JFON-1+4*(I-1)+4)=THETA
 510  CONTINUE

C     TRI SUIVANT THETA CROISSANT
      DO 520 PD=1,NFON-1
        PP=PD
        DO 521 I=PP,NFON
          IF (ZR(JFON-1+4*(I-1)+4).LT.ZR(JFON-1+4*(PP-1)+4)) PP=I
 521    CONTINUE
        DO 522 K=1,4
          TAMPON(K)=ZR(JFON-1+4*(PP-1)+K)
          ZR(JFON-1+4*(PP-1)+K)=ZR(JFON-1+4*(PD-1)+K)
          ZR(JFON-1+4*(PD-1)+K)=TAMPON(K)
 522    CONTINUE
        DO 523 K=1,NDIM

          TAMPON(K)=ZR(JBAS-1+2*NDIM*(PP-1)+K)
          ZR(JBAS-1+2*NDIM*(PP-1)+K)=ZR(JBAS-1+2*NDIM*(PD-1)+K)
          ZR(JBAS-1+2*NDIM*(PD-1)+K)=TAMPON(K)

          TAMPON(K)=ZR(JBAS-1+2*NDIM*(PP-1)+K+NDIM)
          ZR(JBAS-1+2*NDIM*(PP-1)+K+NDIM)=
     &                   ZR(JBAS-1+2*NDIM*(PD-1)+K+NDIM)
          ZR(JBAS-1+2*NDIM*(PD-1)+K+NDIM)=TAMPON(K)
 523    CONTINUE

        TAMPOL=ZL(JBORD-1+PP)
        ZL(JBORD-1+PP)=ZL(JBORD-1+PD)
        ZL(JBORD-1+PD)=TAMPOL
 520  CONTINUE

C     COMPTAGE DES PTS DE BORD DEBUTANT LA LISTE DE PTFF : NBBORI
C     COMPTAGE DU NOMBRE DE POINTS DE BORD : NBBORD

      DEJA0=.FALSE.
      NBBORI=0
      NBBORD=0
      DO 530 I=1,NFON
         IF (ZL(JBORD-1+I).AND.(.NOT.DEJA0))  NBBORI=NBBORI+1
         IF (.NOT.ZL(JBORD-1+I))  DEJA0=.TRUE.
         IF (ZL(JBORD-1+I)) NBBORD=NBBORD+1
 530  CONTINUE

C     LE NOMBRE DE POINTS DE BORD DOIT ETRE PAIR
      CALL ASSERT( MOD(NBBORD,2).EQ.0 )

C     AVERTISSEMENTS SUR LE CHOIX DE PFON_INI
      IF (.NOT.AUTO) THEN
        IF (NBBORI.EQ.NFON) THEN
          CALL U2MESS('A','XFEM2_22')
        ELSEIF ((MOD(NBBORI,2).EQ.0) .AND. (NBBORI.NE.0))  THEN
          CALL U2MESS('A','XFEM2_23')
          AUTO=.TRUE.
        ELSEIF ((NBBORI.EQ.0) .AND. (NBBORD.NE.0)) THEN
          CALL U2MESS('A','XFEM2_23')
          AUTO=.TRUE.
        ENDIF
      ENDIF

C     CAS ORIENTATION AUTOMATIQUE SI NECESSAIRE

      IF (AUTO.AND.(NBBORI.NE.1).AND.(NBBORD.NE.0)) THEN

C       RECUPERATION DE L'INDICE DU DERNIER POINT DE BORD DE LA LISTE
        DO 540 I=1,NFON
          IF (ZL(JBORD-1+I)) IDPB=I
 540    CONTINUE

C       PERMUTATION CIRCULAIRE EN COMMENCANT PAR LE DERNIER POINT DE
C       BORD DE LA LISTE :
        CALL PERMLO(ZL(JBORD),IDPB,NFON)
        CALL PERMR8(ZR(JFON), 4*(IDPB-1)+1, 4*NFON)
        CALL PERMR8(ZR(JBAS), 2*NDIM*(IDPB-1)+1 ,2*NDIM*NFON)

      ENDIF

      CALL JEDEMA()
      END
