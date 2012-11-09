      SUBROUTINE CALIR5(NOMA,LISREL,NONO2,NUNO2,JCOOR,IDECAL,JCONB,
     &                  JCOCF,JCONU)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*19 LISREL
      CHARACTER*8 NONO2,NOMA
      INTEGER NUNO2,JCONB,JCOCF,JCONU,JCOOR
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE PELLET J.PELLET
C BUT : ECRIRE LES RELATIONS LINEAIRES LIANT LES TRANSLATIONS D'UN NOEUD
C       "MASSIF" AVEC LES TRANSLATIONS ET ROTATIONS D'1 NOEUD "COQUE"
C       (AFFE_CHAR_MECA/LIAISON_MAIL + TYPE_RACCORD='MASSIF_COQUE'
C ======================================================================

      REAL*8 BETA
      CHARACTER*2 TYPLAG
      CHARACTER*4 FONREE
      CHARACTER*4 TYPCOE

      REAL*8 COEFR(29),DIRECT(3*29),COEF1
      REAL*8 A(3),N2(3),AN2(3)
      COMPLEX*16 CBID,BETAC
      CHARACTER*8 KBETA,NOEUD(28),DDL(28),NONO1,CMP
      INTEGER DIMENS(28),NBTERM,NDIM
      INTEGER N1,INO1,NUNO1,K,IDEC,IDECAL
C ----------------------------------------------------------------------

      BETA=0.0D0
      BETAC=(0.0D0,0.0D0)
      KBETA=' '
      TYPCOE='REEL'
      FONREE='REEL'
      TYPLAG='12'
      NDIM=3

C     N1 : NOMBRE DE NOEUDS DE LA MAILLE "COQUE" EN FACE DE N2
      N1=ZI(JCONB-1+NUNO2)
      CALL ASSERT(N1.GE.3 .AND. N1.LE.9)

      NBTERM=1+N1*NDIM
      CALL ASSERT(NBTERM.LE.28)


C     CALCUL DES COORDONNEES DU POINT A (COQUE) EN FACE DE N2 (MASSIF) :
C     ET DU VECTEUR AN2 :
C     ------------------------------------------------------------------
      DO 20,K=1,NDIM
        A(K)=0.D0
        DO 10,INO1=1,N1
          NUNO1=ZI(JCONU+IDECAL-1+INO1)
          COEF1=ZR(JCOCF+IDECAL-1+INO1)
          A(K)=A(K)+COEF1*ZR(JCOOR-1+3*(NUNO1-1)+K)
   10   CONTINUE
        N2(K)=ZR(JCOOR-1+3*(NUNO2-1)+K)
        AN2(K)=N2(K)-A(K)
   20 CONTINUE

      DO 30,K=1,NBTERM
        DIMENS(K)=0
   30 CONTINUE


      DO 60,K=1,NDIM
        IF (K.EQ.1)CMP='DX'
        IF (K.EQ.2)CMP='DY'
        IF (K.EQ.3)CMP='DZ'

        NOEUD(1)=NONO2
        DDL(1)=CMP
        COEFR(1)=-1.D0

        IDEC=2
        DO 40,INO1=1,N1
          NUNO1=ZI(JCONU+IDECAL-1+INO1)
          COEF1=ZR(JCOCF+IDECAL-1+INO1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUNO1),NONO1)
          NOEUD(IDEC)=NONO1
          DDL(IDEC)=CMP
          COEFR(IDEC)=COEF1
          IDEC=IDEC+1
   40   CONTINUE

        DO 50,INO1=1,N1
          NUNO1=ZI(JCONU+IDECAL-1+INO1)
          COEF1=ZR(JCOCF+IDECAL-1+INO1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUNO1),NONO1)
          NOEUD(IDEC-1+1)=NONO1
          NOEUD(IDEC-1+2)=NONO1
          IF (K.EQ.1) THEN
            DDL(IDEC-1+1)='DRY'
            DDL(IDEC-1+2)='DRZ'
            COEFR(IDEC-1+1)=+COEF1*AN2(3)
            COEFR(IDEC-1+2)=-COEF1*AN2(2)
          ELSEIF (K.EQ.2) THEN
            DDL(IDEC-1+1)='DRZ'
            DDL(IDEC-1+2)='DRX'
            COEFR(IDEC-1+1)=+COEF1*AN2(1)
            COEFR(IDEC-1+2)=-COEF1*AN2(3)
          ELSEIF (K.EQ.3) THEN
            DDL(IDEC-1+1)='DRX'
            DDL(IDEC-1+2)='DRY'
            COEFR(IDEC-1+1)=+COEF1*AN2(2)
            COEFR(IDEC-1+2)=-COEF1*AN2(1)
          ENDIF
          IDEC=IDEC+2
   50   CONTINUE
        CALL ASSERT(IDEC.EQ.NBTERM+1)

        CALL AFRELA(COEFR,CBID,DDL,NOEUD,DIMENS,DIRECT,NBTERM,BETA,
     &              BETAC,KBETA,TYPCOE,FONREE,TYPLAG,1.D-6,LISREL)
        CALL IMPREL('LIAISON_MAIL-MASSIF_COQUE',NBTERM,COEFR,DDL,NOEUD,
     &              BETA)

   60 CONTINUE



      END
