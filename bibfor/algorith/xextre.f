      SUBROUTINE XEXTRE(IPTBOR,VECTN,NBFACB,JBAS,JBORL,JDIROL,JNVDIR)
      IMPLICIT NONE

      INTEGER       IPTBOR(2),NBFACB
      INTEGER       JBAS,JBORL,JDIROL,JNVDIR
      REAL*8        VECTN(12)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/03/2012   AUTEUR GENIAUT S.GENIAUT 
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
C
C           CALCUL DES VECTEURS DE PROPAGATION AUX EXTREMITES DU FOND
C           DE FISSURE
C
C     ENTREE
C       IPTBOR   : VECTEUR CONTENANT LES INDICES DU OU DES POINTS DE
C                  BORD DE LA MAILLE
C       VECTN    : VECTEUR CONTENANT LES VECTEURS NORMAUX DES FACES DE
C                  BORD DE LA MAILLE
C       NBFACB   : NOMBRE DE FACES DE BORD DANS LA MAILLE
C       JBORL    : ADRESSE DU VECTEUR PERMETTANT DE SAVOIR SI LE VECTEUR
C                  DE DIRECTION DE PROPAGATION A DEJA ETE RECALCULE OU
C                  NON AUX POINTS EXTREMITES DE FONFIS (POUR SAVOIR SI
C                  ON DOIT REMPLACER LA VALEUR EXISTANTE OU LA LUI
C                  AJOUTER)
C       JDIROL   : ADRESSE DES VECTEURS DIRECTIONS DE PROPAGATION 
C                  INITIAUX (CAD SANS MODIFICATION DES VECTEURS AUX
C                  POINTS EXTREMITES DE FONFIS)
C       JNVDIR   : ADRESSE DU VECTEUR CONTENANT 0 OU 1 AUX POINTS
C                  EXTREMITES DE FONFIS:
C                  0: LE PRODUIT SCALAIRE ENTRE LA NORMALE A LA FACE DE
C                     BORD ET LE VDIR INITIAL ESI INFERIEUR A 0
C                  1: LE PRODUIT SCALAIRE EST SUPERIEUR OU EGAL A 0
C     SORTIE
C       JBAS     : ADRESSE DU VECTEUR 'BASEFOND'
C
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
      CHARACTER*32    JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER         H,I,IND,K,NPTBOM,SIGNE
      REAL*8          DDOT,MAXI,NORM,PROJ,SENS,TEMP
      REAL*8          NORMAL(3),VDIR(3),VDIROL(3),VNOR(3)
      LOGICAL         CHANGE,VECMAX
C ----------------------------------------------------------------------
      CALL JEMARQ()

      MAXI   = 0.D0
      CHANGE = .TRUE.
      VECMAX = .FALSE.
      NPTBOM = 1
      IF(IPTBOR(2).NE.0) NPTBOM = 2

C     BOUCLE SUR LE NOMBRE DE POINTS DU FOND DE LA MAILLE
C     QUI SONT SUR UNE FACE DE BORD
C     (CAS GENERAL NPTBOM=1)
      DO 300 I=1,NPTBOM

         SENS = 1.D0

C        RECUPERATION DE L'ANCIEN VECTEUR DE DIRECTION DE PROPAGATION
         IF (.NOT. ZL(JBORL-1+IPTBOR(I))) THEN             
             ZR(JDIROL-1+1+3*(IPTBOR(I)-1))=ZR(JBAS-1+6*(IPTBOR(I)-1)+4)
             ZR(JDIROL-1+2+3*(IPTBOR(I)-1))=ZR(JBAS-1+6*(IPTBOR(I)-1)+5)
             ZR(JDIROL-1+3+3*(IPTBOR(I)-1))=ZR(JBAS-1+6*(IPTBOR(I)-1)+6)
         ENDIF

         VDIROL(1) = ZR(JDIROL-1+1+3*(IPTBOR(I)-1))
         VDIROL(2) = ZR(JDIROL-1+2+3*(IPTBOR(I)-1))
         VDIROL(3) = ZR(JDIROL-1+3+3*(IPTBOR(I)-1))

CC--     CAS 1: ON A DEUX POINTS DE BORD DANS UNE MEME MAILLE
         IF (NPTBOM.GT.1)THEN
           NORMAL(1) = VECTN(1+3*(I-1))
           NORMAL(2) = VECTN(2+3*(I-1))
           NORMAL(3) = VECTN(3+3*(I-1))
         ENDIF

CC--     CAS 2: LA MAILLE N'A QU'UNE FACE DE BORD
         IF (NBFACB.EQ.1) THEN
C          ON VERIFIE QUE LA FACE EST A PRENDRE EN COMPTE
C
C          N
           NORMAL(1) = VECTN(1)
           NORMAL(2) = VECTN(2)
           NORMAL(3) = VECTN(3)

C          N.VDIROLD
           PROJ = DDOT(3,NORMAL,1,VDIROL,1)

           IF (PROJ.LT.0) THEN
             SIGNE = 0
           ELSE
             SIGNE = 1
           ENDIF

C          NVDIR
           IF (.NOT. ZL(JBORL-1+IPTBOR(I))) THEN
              ZI(JNVDIR-1+IPTBOR(I)) = SIGNE
           ELSE
              IF (ZI(JNVDIR-1+IPTBOR(I)).LT.SIGNE) THEN
                 VECMAX = .TRUE.
                 ZI(JNVDIR-1+IPTBOR(I)) = SIGNE
              ELSEIF (ZI(JNVDIR-1+IPTBOR(I)).GT.SIGNE) THEN
                 CHANGE = .FALSE.
              ENDIF
           ENDIF

CC--     CAS 3: LA MAILLE A PLUSIEURS FACES DE BORD
         ELSEIF((NBFACB.GT.1).AND.(NPTBOM.EQ.1))THEN
C          ON CHOISIT LA BONNE NORMALE
           DO 330 H=1,NBFACB
C            N.VDIROLD
             PROJ = VECTN(1+3*(H-1))*VDIROL(1)+
     &              VECTN(2+3*(H-1))*VDIROL(2)+
     &              VECTN(3+3*(H-1))*VDIROL(3)

             IF (PROJ.GE.MAXI) THEN
                MAXI = PROJ
                IND  = H
             ENDIF

  330      CONTINUE

           NORMAL(1) = VECTN(1+3*(IND-1))
           NORMAL(2) = VECTN(2+3*(IND-1))
           NORMAL(3) = VECTN(3+3*(IND-1))
         ENDIF

C        SI ON A TROUVE UNE 'BONNE' FACE DE BORD
         IF (CHANGE) THEN
C          CALCUL DE VDIR, LE NOUVEAU VECTEUR DE DIRECTION DE
C          PROPAGATION
           VNOR(1) = ZR(JBAS-1+6*(IPTBOR(I)-1)+1)
           VNOR(2) = ZR(JBAS-1+6*(IPTBOR(I)-1)+2)
           VNOR(3) = ZR(JBAS-1+6*(IPTBOR(I)-1)+3)

           CALL PROVEC(VNOR,NORMAL,VDIR)

C          VERIFICATION QUE VDIR EST DANS LE BON SENS
           PROJ = DDOT(3,VDIR,1,VDIROL,1)

           IF (PROJ.LT.0) SENS = -1.D0

C          NORMALISATION DE VDIR
           CALL NORMEV(VDIR,NORM)

C          SI LE VECTEUR DE DIRECTION DE PROPAGATION
C          N'A PAS ENCORE ETE RECALCULE, ON LE REMPLACE DANS LA BASE
           IF ((.NOT. ZL(JBORL-1+IPTBOR(I))) .OR. (VECMAX)) THEN
             DO 340 K=1,3
               ZR(JBAS-1+6*(IPTBOR(I)-1)+K+3) = SENS*VDIR(K)
               ZL(JBORL-1+IPTBOR(I))          = .TRUE.
 340         CONTINUE
C          SINON ON L'AJOUTE (ON NORMALISE LE VECTEUR PAR LA SUITE, CE
C          QUI REVIENT A FAIRE UNE MOYENNE DES VECTEURS CALCULES)
           ELSE
             DO 350 K=1,3
               TEMP = ZR(JBAS-1+6*(IPTBOR(I)-1)+K+3)
               ZR(JBAS-1+6*(IPTBOR(I)-1)+K+3) = TEMP + SENS*VDIR(K)
 350         CONTINUE
           ENDIF
         ENDIF
 300  CONTINUE

      CALL JEDEMA()
      END
