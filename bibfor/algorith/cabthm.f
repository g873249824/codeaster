      SUBROUTINE CABTHM(NDDL,NNO,NNOS,
     >               DIMDEF,NDIM,NPG,KPG,IPOIDS,IVF,IDFDE,
     &               DFDI,GEOM,POIDS,B,NMEC,YAMEC,ADDEME,YAP1,
     &               ADDEP1,YAP2,ADDEP2,YATE,ADDETE,NP1,NP2,AXI,
     >               NVOMAX,NNOMAX,NSOMAX,NBVOS,VOISIN,P2P1)

       IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2004   AUTEUR ROMEO R.FERNANDES 
C RESPONSABLE UFBHHLL C.CHAVANT
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
C TOLE CRP_20
C TOLE CRP_21
C
C     BUT:  CALCUL  DE LA MATRICE B
C     EN MECANIQUE DES MILIEUX POREUX PARTIELLEMENT SATURE
C     AVEC COUPLAGE THM 
C.......................................................................
C ARGUMENTS D'ENTREE
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NNOS    : NOMBRE DE NOEUDS SOMMET DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDN    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  DIMDEF  : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES 
C               AU POINT DE GAUSS
C IN  AXI     : VRAI SI ELEMENT APPELANT AXI
C IN  P2P1   : VRAI SI ELEMENT APPELANT P2P1
C IN VOISIN
C  POUR UN SOMMET J DE 1 A NNOS : 
C         VOISIN(1:NBVOS(J),J) =  
C                    LES NBVOS(J) NOEUDS MILIEUX VOSIN DU SOMMMET
C
C
C  POUR UN MILIEU J DE 1 A NNOS +1 A NNO: 
C         VOISIN(1:2,J) =  LES 2 NOEUDS DU SEGMENT DONT IL EST LE MILIEU
C
C
C.......................................................................
C ARGUMENTS DE SORTIE
C OUT DFDI    : DERIVEE DES FCT FORME
C OUT POIDS  : JACOBIEN AUX POINTS DE GAUSS
C.......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER      NDDL,NMEC,NP1,NP2,NDIM,NNO
      INTEGER      NNOS,NPG,KPG,DIMDEF
      INTEGER      I,N,G,KK
      REAL*8       DFDI(NNO,3)
      REAL*8       GEOM(NDIM,NNO),POIDS
      REAL*8       B(DIMDEF,NDDL*NNO)
      INTEGER      YAMEC,ADDEME,YAP1,YAP2,ADDEP1,ADDEP2,YATE,ADDETE
      REAL*8       RAC,R,RMAX
      LOGICAL AXI,P2P1
      INTEGER NVOMAX,NNOMAX,NSOMAX
      INTEGER VOISIN(NVOMAX,NNOMAX)
      INTEGER NBVOS(NSOMAX),IPOIDS,IDFDE,IVF
      
      INTEGER IDL,IDL1M,IV
C
C  CALCUL DE CONSTANTES UTILES
C
      RAC= SQRT(2.D0)
C
C        INITIALISATION DE LA MATRICE
C
         DO 100 N=1,NDDL*NNO
            DO 101 G=1,DIMDEF
               B(G,N)=0.D0
 101        CONTINUE
 100     CONTINUE
C
C      RECUPERATION DES DERIVEES DES FONCTIONS DE FORME
C
         IF (NDIM.EQ.3) THEN
            CALL DFDM3D ( NNO, KPG, IPOIDS, IDFDE,
     &                    GEOM,DFDI(1,1),DFDI(1,2),DFDI(1,3),POIDS)
         ELSE
            CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,GEOM,DFDI(1,1),
     &                  DFDI(1,2),POIDS)
            IF (AXI) THEN
              KK = (KPG-1)*NNO
              R  = 0.D0
              DO 10 N=1,NNO
                 R  = R + ZR(IVF + N + KK - 1)*GEOM(1,N) 
  10          CONTINUE

C                 DANS LE CAS OU R EGAL 0, ON A UN JACOBIEN NUL 
C                 EN UN POINT DE GAUSS, ON PREND LE MAX DU RAYON
C                 SUR L ELEMENT MULTIPLIE PAR 1E-3

              IF (R .EQ. 0.D0) THEN
                 RMAX=GEOM(1,1)
                 DO 15 N=2,NNO
                    RMAX=MAX(GEOM(1,N),RMAX)
  15             CONTINUE
                 POIDS = POIDS*1.D-03*RMAX
              ELSE
                 POIDS = POIDS*R
              ENDIF
            ENDIF
            DO 200 N=1,NNO
              DFDI(N,3)=0.D0
 200        CONTINUE
         ENDIF
C
C      REMPLISSAGE DES TERMES DE LA MATRICE B
C 
         DO 102 N=1,NNO
            IF (YAMEC.EQ.1) THEN 
               DO 103 I=1,NDIM
                  B(ADDEME-1+I,(N-1)*NDDL+I)=B(ADDEME-1+I,(N-1)*NDDL+I)
     &                 +ZR(IVF+N+(KPG-1)*NNO-1)
C
 103               CONTINUE
C
C --- CALCUL DE DEPSX, DEPSY, DEPSZ (DEPSZ INITIALISE A 0 EN 2D)
C

               DO 104 I=1,3
                  B(ADDEME+NDIM-1+I,(N-1)*NDDL+I)=
     &                    B(ADDEME+NDIM-1+I,(N-1)*NDDL+I)+DFDI(N,I)
C
 104           CONTINUE
C
C --- TERME U/R DANS EPSZ EN AXI
               IF (AXI) THEN
                  IF (R .EQ. 0.D0) THEN
                     B(ADDEME+4,(N-1)*NDDL+1)= DFDI(N,1)
                     
                  ELSE
                    KK=(KPG-1)*NNO 
                    B(ADDEME+4,(N-1)*NDDL+1)=ZR(IVF+N+KK-1)/R
                  ENDIF
               ENDIF
C

C
C CALCUL DE EPSXY
C
               B(ADDEME+NDIM+3,(N-1)*NDDL+1)=
     &                    B(ADDEME+NDIM+3,(N-1)*NDDL+1)+DFDI(N,2)/RAC
               B(ADDEME+NDIM+3,(N-1)*NDDL+2)=
     &                    B(ADDEME+NDIM+3,(N-1)*NDDL+2)+DFDI(N,1)/RAC
C
C
C CALCUL DE EPSXZ ET EPSYZ EN 3D
C
               IF(NDIM .EQ. 3) THEN
                 B(ADDEME+NDIM+4,(N-1)*NDDL+1)=
     &                    B(ADDEME+NDIM+4,(N-1)*NDDL+1)+DFDI(N,3)/RAC

                 B(ADDEME+NDIM+4,(N-1)*NDDL+3)=
     &                    B(ADDEME+NDIM+4,(N-1)*NDDL+3)+DFDI(N,1)/RAC
C
                 B(ADDEME+NDIM+5,(N-1)*NDDL+2)=
     &                    B(ADDEME+NDIM+5,(N-1)*NDDL+2)+DFDI(N,3)/RAC
                 B(ADDEME+NDIM+5,(N-1)*NDDL+3)=
     &                    B(ADDEME+NDIM+5,(N-1)*NDDL+3)+DFDI(N,2)/RAC
               ENDIF
            ENDIF
C
C
            IF (YAP1.EQ.1) THEN
               B(ADDEP1,(N-1)*NDDL+NMEC+1)=B(ADDEP1,(N-1)*NDDL+NMEC+1)
     &                 +ZR(IVF+N+(KPG-1)*NNO-1)
C
               DO 105 I=1,NDIM
                  B(ADDEP1+I,(N-1)*NDDL+NMEC+1)=
     &                    B(ADDEP1+I,(N-1)*NDDL+NMEC+1)+DFDI(N,I)
C
 105           CONTINUE
            ENDIF
C
            IF (YAP2.EQ.1) THEN
               B(ADDEP2,(N-1)*NDDL+NMEC+NP1+1)=
     &         B(ADDEP2,(N-1)*NDDL+NMEC+NP1+1)+ZR(IVF+N+(KPG-1)*NNO-1)
               DO 106 I=1,NDIM
                  B(ADDEP2+I,(N-1)*NDDL+NMEC+NP1+1)=
     &            B(ADDEP2+I,(N-1)*NDDL+NMEC+NP1+1)+DFDI(N,I)
 106           CONTINUE
            ENDIF
            IF (YATE.EQ.1) THEN
               B(ADDETE,(N-1)*NDDL+NMEC+NP1+NP2+1)=
     &     B(ADDETE,(N-1)*NDDL+NMEC+NP1+NP2+1)+ZR(IVF+N+(KPG-1)*NNO-1)
               DO 107 I=1,NDIM
                  B(ADDETE+I,(N-1)*NDDL+NMEC+NP1+NP2+1)=
     &            B(ADDETE+I,(N-1)*NDDL+NMEC+NP1+NP2+1)+DFDI(N,I)
 107           CONTINUE
            ENDIF
 102     CONTINUE
C
C  ELEMENTS P2P1
C
      IF ( P2P1) THEN
      IDL1M = NMEC+1
      IF ( YAP1.EQ.1) THEN
C
C  FONCTIONS P1 POUR NOEUDS SOMETS = UN DE MI DES P2 VOISINS
C
        DO 301 N = 1 , NNOS
         DO 302 IV = 1 , NBVOS(N)
          DO 303 I=0,NDIM
           DO 304 IDL = IDL1M,NDDL
             B(ADDEP1+I,(N-1)*NDDL+IDL)=B(ADDEP1+I,(N-1)*NDDL+IDL)+
     >               B(ADDEP1+I,(VOISIN(IV,N)-1)*NDDL+IDL)/2.D0
  304           CONTINUE
  303          CONTINUE
  302         CONTINUE
  301   CONTINUE
C
C  FONCTIONS P1 POUR NOEUDS MILIEUX = 0
C
        DO 401 N = NNOS+1 , NNO
          DO 402 I=0,NDIM
           DO 403 IDL = IDL1M,NDDL
             B(ADDEP1+I,(N-1)*NDDL+IDL)=0.D0
  403      CONTINUE
  402     CONTINUE
  401   CONTINUE
      ENDIF
C
      IF ( YAP2.EQ.1) THEN
C
C  FONCTIONS P1 POUR NOEUDS SOMETS = UN DE MI DES P2 VOISINS
C
        DO 501 N = 1 , NNOS
         DO 502 IV = 1 , NDIM
          DO 503 I=0,NDIM
           DO 504 IDL = IDL1M,NDDL
             B(ADDEP2+I,(N-1)*NDDL+IDL)=B(ADDEP2+I,(N-1)*NDDL+IDL)+
     >               B(ADDEP2+I,(VOISIN(IV,N)-1)*NDDL+IDL)/2.D0
  504           CONTINUE
  503          CONTINUE
  502         CONTINUE
  501   CONTINUE
C
C  FONCTIONS P1 POUR NOEUDS MILIEUX = 0
C
        DO 601 N = NNOS+1 , NNO
          DO 602 I=0,NDIM
           DO 603 IDL = IDL1M,NDDL
             B(ADDEP2+I,(N-1)*NDDL+IDL)=0.D0
  603      CONTINUE
  602     CONTINUE
  601   CONTINUE
      ENDIF
C
      IF ( YATE.EQ.1) THEN
C
C  FONCTIONS P1 POUR NOEUDS SOMETS = UN DE MI DES P2 VOISINS
C
        DO 701 N = 1 , NNOS
         DO 702 IV = 1 , NDIM
          DO 703 I=0,NDIM
           DO 704 IDL = IDL1M,NDDL
             B(ADDETE+I,(N-1)*NDDL+IDL)=B(ADDETE+I,(N-1)*NDDL+IDL)+
     >               B(ADDETE+I,(VOISIN(IV,N)-1)*NDDL+IDL)/2.D0
  704           CONTINUE
  703          CONTINUE
  702         CONTINUE
  701   CONTINUE
C
C  FONCTIONS P1 POUR NOEUDS MILIEUX = 0
C
        DO 801 N = NNOS+1 , NNO
          DO 802 I=0,NDIM
           DO 803 IDL = IDL1M,NDDL
             B(ADDETE+I,(N-1)*NDDL+IDL)=0.D0
  803      CONTINUE
  802     CONTINUE
  801   CONTINUE
      ENDIF
C
      ENDIF
      END 
