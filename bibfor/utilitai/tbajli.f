      SUBROUTINE TBAJLI ( NOMTA, NBPAR, NOMPAR, VI, VR, VC, VK, NUME )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER                    NBPAR,         VI(*),          NUME
      REAL*8                                        VR(*)
      COMPLEX*16                                        VC(*)
      CHARACTER*(*)       NOMTA,        NOMPAR(*),          VK(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C      AJOUTER UNE LIGNE A UNE TABLE.
C ----------------------------------------------------------------------
C IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
C IN  : NBPAR  : NOMBRE DE PARAMETRES DE NOMPAR
C IN  : NOMPAR : NOMS DES PARAMETRES DE LA LIGNE
C IN  : VI     : LISTE DES VALEURS POUR LES PARAMETRES "I"
C IN  : VR     : LISTE DES VALEURS POUR LES PARAMETRES "R"
C IN  : VC     : LISTE DES VALEURS POUR LES PARAMETRES "C"
C IN  : VK     : LISTE DES VALEURS POUR LES PARAMETRES "K"
C IN  : NUME   : NUMERO DE LIGNE
C                = 0 : ON AJOUTE UNE LIGNE
C                > 0 : ON SURCHARGE UNE LIGNE
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
      INTEGER      IRET, NBPARA, NBLIGN, JTBNP, NBPM, NBPU, ISMAEM
      INTEGER      NDIM, JTBLP, I, J, JVALE, JLOGQ, KI, KR, KC, KK
      REAL*8       R8VIDE
      CHARACTER*3  TYPE
      CHARACTER*8  K8B
      CHARACTER*19 NOMTAB
      CHARACTER*24 NOMJV, NOMJVL, INPAR, JNPAR
      CHARACTER*24 VALK
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      NOMTAB = ' '
      NOMTAB = NOMTA
      CALL JEEXIN ( NOMTAB//'.TBBA', IRET )
      IF ( IRET .EQ. 0 ) THEN
         CALL U2MESS('F','UTILITAI4_64')
      ENDIF
      IF ( NOMTAB(18:19) .NE. '  ' ) THEN
         CALL U2MESS('F','UTILITAI4_68')
      ENDIF
C
      CALL JEVEUO ( NOMTAB//'.TBNP' , 'E', JTBNP )
      NBPARA = ZI(JTBNP  )
      NBLIGN = ZI(JTBNP+1)
      IF ( NBPARA .EQ. 0 ) THEN
         CALL U2MESS('F','UTILITAI4_65')
      ENDIF
      IF ( NUME .LT. 0 ) THEN
         CALL U2MESS('F','UTILITAI4_70')
      ENDIF
      IF ( NUME .GT. NBLIGN ) THEN
         CALL U2MESS('F','UTILITAI4_74')
      ENDIF
C
      CALL JEVEUO ( NOMTAB//'.TBLP' , 'L', JTBLP )
      NOMJV = ZK24(JTBLP+2)
      CALL JELIRA ( NOMJV, 'LONMAX', NBPM, K8B)
      CALL JELIRA ( NOMJV, 'LONUTI', NBPU, K8B)
C
      NDIM = NBPU + 1
      IF ( NDIM .GT. NBPM ) THEN
         NDIM = NINT((NDIM*3.D0)/2.D0)
         DO 10 I = 1 , NBPARA
            NOMJV = ZK24(JTBLP+4*(I-1)+2)
            CALL JUVECA ( NOMJV , NDIM )
            NOMJV = ZK24(JTBLP+4*(I-1)+3)
            CALL JUVECA ( NOMJV , NDIM )
 10      CONTINUE
      ENDIF
C
      IF ( NUME .EQ. 0 ) THEN
         NBLIGN = NBLIGN + 1
         ZI(JTBNP+1) = NBLIGN
C
         DO 20 I = 1 , NBPARA
            NOMJV = ZK24(JTBLP+4*(I-1)+2)
            CALL JEECRA ( NOMJV , 'LONUTI' , NBLIGN , ' ' )
 20      CONTINUE
C
         KI  = 0
         KR  = 0
         KC  = 0
         KK = 0
         DO 30 J = 1 , NBPAR
            JNPAR = NOMPAR(J)
            DO 32 I = 1 , NBPARA
               INPAR = ZK24(JTBLP+4*(I-1)  )
               IF ( JNPAR .EQ. INPAR ) THEN
                  TYPE   = ZK24(JTBLP+4*(I-1)+1)
                  NOMJV  = ZK24(JTBLP+4*(I-1)+2)
                  NOMJVL = ZK24(JTBLP+4*(I-1)+3)
                  CALL JEVEUO ( NOMJV , 'E', JVALE )
                  CALL JEVEUO ( NOMJVL, 'E', JLOGQ )
                  IF ( TYPE(1:1) .EQ. 'I' ) THEN
                     KI = KI + 1
                     IF ( VI(KI) .EQ. ISMAEM() ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZI(JVALE+NBLIGN-1) = VI(KI)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:1) .EQ. 'R' ) THEN
                     KR = KR + 1
                     IF ( VR(KR) .EQ. R8VIDE() ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZR(JVALE+NBLIGN-1) = VR(KR)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:1) .EQ. 'C' ) THEN
                     KC = KC + 1
                     IF (  DBLE(VC(KC)) .EQ. R8VIDE() .AND.
     &                    DIMAG(VC(KC)) .EQ. R8VIDE() ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZC(JVALE+NBLIGN-1) = VC(KC)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K80' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK80(JVALE+NBLIGN-1) = VK(KK)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K32' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK32(JVALE+NBLIGN-1) = VK(KK)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K24' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK24(JVALE+NBLIGN-1) = VK(KK)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K16' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK16(JVALE+NBLIGN-1) = VK(KK)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:2) .EQ. 'K8' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK8(JVALE+NBLIGN-1) = VK(KK)
                        ZI(JLOGQ+NBLIGN-1) = 1
                     ENDIF
                  ENDIF
                  GOTO 34
               ENDIF
 32         CONTINUE
            CALL U2MESK('F','TABLE0_1',1,JNPAR)
 34         CONTINUE
 30      CONTINUE
C
      ELSE
         KI = 0
         KR = 0
         KC = 0
         KK = 0
         DO 40 J = 1 , NBPAR
            JNPAR = NOMPAR(J)
            DO 42 I = 1 , NBPARA
               INPAR = ZK24(JTBLP+4*(I-1)  )
               IF ( JNPAR .EQ. INPAR ) THEN
                  TYPE   = ZK24(JTBLP+4*(I-1)+1)
                  NOMJV  = ZK24(JTBLP+4*(I-1)+2)
                  NOMJVL = ZK24(JTBLP+4*(I-1)+3)
                  CALL JEVEUO ( NOMJV , 'E', JVALE )
                  CALL JEVEUO ( NOMJVL, 'E', JLOGQ )
                  IF ( TYPE(1:1) .EQ. 'I' ) THEN
                     KI = KI + 1
                     IF ( VI(KI) .EQ. ISMAEM() ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZI(JVALE+NUME-1) = VI(KI)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:1) .EQ. 'R' ) THEN
                     KR = KR + 1
                     IF ( VR(KR) .EQ. R8VIDE() ) THEN
                        ZI(JLOGQ+NUME-1) = 0
                     ELSE
                        ZR(JVALE+NUME-1) = VR(KR)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:1) .EQ. 'C' ) THEN
                     KC = KC + 1
                     IF (  DBLE(VC(KC)) .EQ. R8VIDE() .AND.
     &                    DIMAG(VC(KC)) .EQ. R8VIDE() ) THEN
                        ZI(JLOGQ+NUME-1) = 0
                     ELSE
                        ZC(JVALE+NUME-1) = VC(KC)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K80' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK80(JVALE+NUME-1) = VK(KK)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K32' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK32(JVALE+NUME-1) = VK(KK)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K24' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK24(JVALE+NUME-1) = VK(KK)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:3) .EQ. 'K16' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK16(JVALE+NUME-1) = VK(KK)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ELSEIF ( TYPE(1:2) .EQ. 'K8' ) THEN
                     KK = KK + 1
                     IF ( VK(KK)(1:7) .EQ. '???????' ) THEN
                        ZI(JLOGQ+NBLIGN-1) = 0
                     ELSE
                        ZK8(JVALE+NUME-1) = VK(KK)
                        ZI(JLOGQ+NUME-1) = 1
                     ENDIF
                  ENDIF
                  GOTO 44
               ENDIF
 42         CONTINUE
            VALK = JNPAR
            CALL U2MESG('F', 'UTILITAI6_90',1,VALK,0,0,0,0.D0)
 44         CONTINUE
 40      CONTINUE
C
      ENDIF
C
      CALL JEDEMA()
      END
