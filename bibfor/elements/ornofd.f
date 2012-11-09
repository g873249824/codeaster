      SUBROUTINE ORNOFD ( MAFOUR, NOMAIL, NBMA, NOEORD,
     &                    NDORIG, NDEXTR, BASE,VECORI)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER             NBMA
      CHARACTER*24 MAFOUR
      CHARACTER*8  NOMAIL, NDORIG, NDEXTR
      CHARACTER*24        NOEORD
      CHARACTER*1         BASE
      REAL*8 VECORI(3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C-----------------------------------------------------------------------
C FONCTION REALISEE:

C       ORNOFD -- ORDONNANCEMENT D'UNE LISTE DE NOEUD
C                 A PARTIR D'UN NOEUD ORIGINE
C                 UTILISE DANS DEFI_GROUP ET DEFI_FOND_FISS

C     ENTREES:
C        MAFOUR     : LISTE DES MAILLES SEG
C        NOMAIL     : NOM DU MAILLAGE
C        NBMA       : NOMBRE DE MAILLES TRAITEES
C        NOEORD     : NOM DE L'OBJET
C        NDORIG     : NOM DU NOEUD ORIGINE
C        NDEXTR     : NOM DU NOEUD EXTREMITE
C        BASE       : TYPE DE BASE DE SAUVEGARDE

C-----------------------------------------------------------------------

      REAL*8             DDOT,VECTA(3),PS1,PS2

      INTEGER       IATYMA, JTYPM, JCOUR1, JCOUR2, JMAIL
      INTEGER       IM, NID, NIG, NJONC, N, I, K, NBNO
      INTEGER       JRDM, JNOE,NTEMP,JCOOR
      CHARACTER*8     TYPM
      CHARACTER*8   NOEUD
      CHARACTER*24  CONEC, TYPP, NOMNOE
C DEB-------------------------------------------------------------------
      CALL JEMARQ()

      CONEC  = NOMAIL//'.CONNEX'
      TYPP   = NOMAIL//'.TYPMAIL'
      NOMNOE = NOMAIL//'.NOMNOE'

C     RECUPERATION DES NOEUDS DESORDONNES
      CALL JEVEUO (MAFOUR, 'L', JMAIL )

C     ------------------------------------------------------------------
C     RECUPERATION DU TYPE DE MAILLE
C     ------------------------------------------------------------------
      CALL JEVEUO ( TYPP, 'L', IATYMA )
      JTYPM = IATYMA-1+ZI(JMAIL-1 + 1)
      CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(JTYPM)),TYPM)

C     ------------------------------------------------------------------
C     CONSTRUCTION D'UN VECTEUR DE TRAVAIL LOCAL CONTENANT
C     LES NOEUDS EXTREMITES  DE CHAQUE MAILLE
C     ------------------------------------------------------------------
      CALL WKVECT('&&ORNOFD.NOEUDS_EXTREM','V V I',2*NBMA,JCOUR2)
      DO 30 IM = 1 , NBMA
         CALL I2EXTF (ZI(JMAIL-1+IM),1,CONEC(1:15),TYPP(1:16),NIG,NID)
         ZI(JCOUR2-1 +     IM) = NIG
         ZI(JCOUR2-1 +NBMA+IM) = NID
 30   CONTINUE


C     ------------------------------------------------------------------
C     --- ORDONNANCEMENT DES MAILLES EN PARTANT DU NOEUD ORIGINE
C     ------------------------------------------------------------------
      CALL JENONU ( JEXNOM(NOMNOE,NDORIG), NJONC )
      N = 1
C     ------------------------------------------------------------------
C     CONSTRUCTION D'UN VECTEUR DE TRAVAIL LOCAL POUR
C     TRIER LES NOEUDS ET CONTENANT
C     LES MAILLES, LES NOEUDS SOMMET 1 ET LES NOEUDS SOMMET 2
C     ------------------------------------------------------------------
      CALL WKVECT('&&ORNOFD.MAILLES_TRIEE','V V I',3*NBMA,JCOUR1)
C     EQUIVALENT D'UNE BOUCLE WHILE
550   CONTINUE
      DO 552 I=N,NBMA
        IF (ZI(JCOUR2-1 + I).EQ.NJONC) THEN
          ZI(JCOUR1-1 +        N)=ZI(JMAIL-1  +      I)
          ZI(JCOUR1-1 +   NBMA+N)=ZI(JCOUR2-1 +      I)
          ZI(JCOUR1-1 + 2*NBMA+N)=ZI(JCOUR2-1 + NBMA+I)
          NJONC                  =ZI(JCOUR2-1 + NBMA+I)
          GOTO 555
        ENDIF
        IF (ZI(JCOUR2-1 + NBMA+I).EQ.NJONC) THEN
          ZI(JCOUR1-1 +        N)=ZI(JMAIL-1  +      I)
          ZI(JCOUR1-1 +   NBMA+N)=ZI(JCOUR2-1 + NBMA+I)
          ZI(JCOUR1-1 + 2*NBMA+N)=ZI(JCOUR2-1 +      I)
          NJONC                  =ZI(JCOUR2-1 +      I)
          GOTO 555
        ENDIF
552   CONTINUE

555   CONTINUE
      DO 557 K=N,I-1
        ZI(JCOUR1-1 +        1+K)=ZI(JMAIL-1  +      K)
        ZI(JCOUR1-1 +   NBMA+1+K)=ZI(JCOUR2-1 +      K)
        ZI(JCOUR1-1 + 2*NBMA+1+K)=ZI(JCOUR2-1 + NBMA+K)
557   CONTINUE
      DO 558 K=I+1,NBMA
        ZI(JCOUR1-1 +        K)=ZI(JMAIL-1  +      K)
        ZI(JCOUR1-1 +   NBMA+K)=ZI(JCOUR2-1 +      K)
        ZI(JCOUR1-1 + 2*NBMA+K)=ZI(JCOUR2-1 + NBMA+K)
558   CONTINUE
      DO 559 K=N,NBMA
        ZI(JMAIL-1  +      K)=ZI(JCOUR1-1 +       K)
        ZI(JCOUR2-1 +      K)=ZI(JCOUR1-1 +  NBMA+K)
        ZI(JCOUR2-1 + NBMA+K)=ZI(JCOUR1-1 +2*NBMA+K)
559   CONTINUE
      N=N+1
      IF (N.GT.NBMA) GOTO 560
      GOTO 550


560   CONTINUE


C     ------------------------------------------------------------------
C     --- SAUVEGARDE DES NOEUDS ORDONNES DANS LA STRUCTURE DE DONNEES
C     --- AVEC RAJOUT DES NOEUDS MILIEUX SI SEG3
C     ------------------------------------------------------------------
      IF ( TYPM(1:4) .EQ. 'SEG2' ) THEN

        NBNO=NBMA+1
        CALL WKVECT(NOEORD,BASE//' V I',NBNO,JNOE)
        DO 570 I=1,NBMA
          ZI(JNOE-1 + I) = ZI(JCOUR2-1 + I)
570     CONTINUE
        ZI(JNOE-1 + NBMA+1) = ZI(JCOUR2-1 + 2*NBMA)

      ELSEIF ( TYPM(1:4) .EQ. 'SEG3' ) THEN

        NBNO=2*NBMA+1
        CALL WKVECT(NOEORD,BASE//' V I',NBNO,JNOE)
        DO 575 I=1,NBMA
          ZI(JNOE-1 + 2*I-1)   = ZI(JCOUR2-1 + I)
          CALL JEVEUO(JEXNUM(CONEC,ZI(JMAIL-1 + I)),'L',JRDM)
          ZI(JNOE-1 + 2*I) = ZI(JRDM-1 + 3)
575     CONTINUE
        ZI(JNOE-1 + 2*NBMA+1) = ZI(JCOUR2-1 + 2*NBMA)

      ELSEIF ( TYPM(1:4) .EQ. 'SEG4' ) THEN

        NBNO=3*NBMA+1
        CALL WKVECT(NOEORD,BASE//' V I',NBNO,JNOE)
        DO 580 I=1,NBMA
          ZI(JNOE-1 + 3*I-2)   = ZI(JCOUR2-1 + I)
          CALL JEVEUO(JEXNUM(CONEC,ZI(JMAIL-1 + I)),'L',JRDM)
          CALL ASSERT((ZI(JRDM-1 + 1).EQ.ZI(JCOUR2-1 + I)).OR.
     &                (ZI(JRDM-1 + 2).EQ.ZI(JCOUR2-1 + I)))
          IF (ZI(JRDM-1 + 1).EQ.ZI(JCOUR2-1 + I)) THEN
             ZI(JNOE-1 + 3*I-1) = ZI(JRDM-1 + 3)
             ZI(JNOE-1 + 3*I  ) = ZI(JRDM-1 + 4)
          ELSEIF (ZI(JRDM-1 + 2).EQ.ZI(JCOUR2-1 + I)) THEN
             ZI(JNOE-1 + 3*I-1) = ZI(JRDM-1 + 4)
             ZI(JNOE-1 + 3*I  ) = ZI(JRDM-1 + 3)
          ENDIF
580     CONTINUE
        ZI(JNOE-1 + 3*NBMA+1) = ZI(JCOUR2-1 + 2*NBMA)

      ENDIF


C     ------------------------------------------------------------------
C     --- VERIFICATION DU NOEUD EXTREMITE LORSQU'IL EST DONNE
C     --- DANS LE CAS D UNE COURBE NON FERMEE
C     ------------------------------------------------------------------
      IF (NDEXTR.NE.' ') THEN
        CALL JENUNO(JEXNUM(NOMNOE,ZI(JNOE-1 + NBNO)),NOEUD)
        IF ( NOEUD .NE. NDEXTR )CALL U2MESK('F','ELEMENTS_77',1,NDEXTR)
      ENDIF


C     -- SI VECORI EST RENSEIGNE (I.E. != 0),
C        IL FAUT EVENTUELLEMENT RETOURNER LA LISTE
C     ------------------------------------------------------------------
      PS1=DDOT(3,VECORI,1,VECORI,1)
      IF (PS1.GT.0.D0) THEN
        CALL ASSERT(NBNO.GE.3)
        CALL ASSERT(ZI(JNOE-1+1).EQ.ZI(JNOE-1+NBNO))
        CALL JEVEUO(NOMAIL//'.COORDO    .VALE','L',JCOOR)

C       PS1 : DDOT(VECORI,(1,2))/NORME((1,2))
        DO 77, K=1,3
          VECTA(K)=ZR(JCOOR-1+3*(ZI(JNOE-1+2)-1)+K)
          VECTA(K)=VECTA(K)-ZR(JCOOR-1+3*(ZI(JNOE-1+1)-1)+K)
77      CONTINUE
        PS1=DDOT(3,VECTA,1,VECORI,1)
        PS1=PS1/SQRT(DDOT(3,VECTA,1,VECTA,1))

C       PS2 : DDOT(VECORI,(N,N-1))/NORME((N,N-1))
        DO 78, K=1,3
          VECTA(K)=ZR(JCOOR-1+3*(ZI(JNOE-1+NBNO-1)-1)+K)
          VECTA(K)=VECTA(K)-ZR(JCOOR-1+3*(ZI(JNOE-1+NBNO)-1)+K)
78      CONTINUE
        PS2=DDOT(3,VECTA,1,VECORI,1)
        PS2=PS2/SQRT(DDOT(3,VECTA,1,VECTA,1))

C       -- SI PS2 > PS1 : ON RETOURNE LA LISTE :
        IF (PS2.GT.PS1) THEN
          DO 79, K=1,NBNO/2
            NTEMP=ZI(JNOE-1+K)
            ZI(JNOE-1+K)=ZI(JNOE-1+NBNO+1-K)
            ZI(JNOE-1+NBNO+1-K)=NTEMP
79        CONTINUE
        ENDIF
      ENDIF


C     -- MENAGE :
      CALL JEDETR ( '&&ORNOFD.MAILLES_TRIEE' )
      CALL JEDETR ( '&&ORNOFD.NOEUDS_EXTREM' )

      CALL JEDEMA()
      END
