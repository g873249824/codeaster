         SUBROUTINE CABHVF(MAXFA,MAXDIM,NDIM,NNO,NNOS,NFACE,AXI,GEOM,
     &                     VOL,MFACE,DFACE,XFACE,NORMFA,UTICER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/03/2010   AUTEUR ANGELINI O.ANGELINI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C =====================================================================
C  UTICER :       PERMET DE PLACER LE POINT XK SOIT TJRS AU CENTRE DE   
C                 GRAVITE SOIT AU CENTRE DU CERCLE CIRCONSCRIT SOIT 
C                 AU CENTRE DE GRAVITE
C
C  NB :           LE PARAMETRE PERMETANT DE CONSIDER QUE LE POINT EST
C                 A L INTERIEUR DU CERCLE OU NON EST ECRIT EN DUR
C                 ET VAUT 0.1D0*SQRT(VOL)(VALEUR ARBITRAIREMENT CHOISIE)
C
C    
C NDIM :          DIMENSION D ESPACE
C NFACE :         NOMBRE DE FACES
C KINT  :         PERMEABILITE INTRINSEQUE (DIAGONALE)
C MFACE :         MESURE DES FACES
C DFACE :         DISTANCE DU CENTRE DE GRAVIT� AUX FACES 
C DFACE :         N EST PAS XG - XFACE
C XFACE(1:MAXDIM,1:MAXFA) : COORDONNES DES CENTRES DE FACES
C NORMFA(1:MAXDIM,1:MAXFA) :NORMALE SORTANTE
C MAXFA :         NOMBRE MAX DE FACES
C MAXAR :         NOMBRE MAX DE ARETES
C NOSAR(IAR ,1:2):LES DESDUS SOMMETS DE L ARETE IAR
C
C ======== OUT 
C NBNOFA(1:NFACE):NOMBRE DE SOMMETS DE LA FACE
C NOSFA(IFA :1,NFACE,J : 1,NBNOFA(IFA)) J EME SOMMET DE LA FACE IFA
C                                      (EN NUMEROTATION LOCALE)
C NARFA(IFA :1,NFACE,J : 1,NBNOFA(IFA)) J EME ARETE DE LA FACE IFA
C                                     (EN NUMEROTATION LOCALE)
C XS(1:MAXDIM,J) : COORD SOMMET J 
C T(1:MAXDIM,J) :  COORD DU VECTEUR DE L J EME ARETE
C
      IMPLICIT NONE
      INTEGER      NDIM,NNO,NNOS
      LOGICAL      AXI
      REAL*8       GEOM(1:NDIM,1:NNO)
C
      INTEGER      MAXFA,MAXDIM,MANOFA
      INTEGER      MAXFA1,MAXDI1,MAXAR
      PARAMETER   (MAXFA1=6,MAXDI1=3,MANOFA=4,MAXAR=12)       
      REAL*8       MFACE(1:MAXFA),DFACE(1:MAXFA),VOL,
     >             NORMFA(1:MAXDIM,1:MAXFA),XFACE(1:MAXDIM,1:MAXFA)
      REAL*8       DET,XG(MAXDI1)
      INTEGER      INO,IFA,I,J,NBNO,IDEB,IFIN,I1,I2
      REAL*8       PDVC2D
      INTEGER      NFACE
C   VARIABLES POUR POINT K COMME CENTRE CERCLE CIRCONSCRIT
      REAL*8       XC(3),A(3),A1VA2(3),SA,LAMBDA(3)
C
C  ARIS(IS,1) ET FAIS(IS,2) SONT LES DEUX ARETES ISSUTES DU SOMMET IS
C
      INTEGER      ARIS(3,2)      
      REAL*8       MATGEO(3,3),MATG1(3,3)
      INTEGER      JJ,II,KK,IF1,IF2
      LOGICAL      HINTR
      REAL*8       EPSILO,EPSREL
      PARAMETER   (EPSREL=0.1D0)
      LOGICAL      UTICER
C
C
      INTEGER      NBNOFA(1:MAXFA1)
      INTEGER      NOSAR(1:MAXAR,2)
      INTEGER      NOSFA(1:MAXFA1,MANOFA)
      INTEGER      NARFA(1:MAXFA1,MANOFA)
      REAL*8       XS(1:MAXDI1,MANOFA),T(1:MAXDI1,MAXAR)
      INTEGER      IDIM,IS,IAR,NS1,NS2,IRET  
C      
C 
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
      INTEGER IADZI,IAZK24,NNOGLO
      CHARACTER*8  NOMAIL
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
      CALL ASSERT(MAXFA1.EQ.MAXFA)
      CALL ASSERT(MAXDI1.EQ.MAXDIM)
      ARIS(1,1)=1 
      ARIS(1,2)=3     
      ARIS(2,1)=1 
      ARIS(2,2)=2      
      ARIS(3,1)=2 
      ARIS(3,2)=3      
      IF(UTICER .AND. NFACE.NE.3)THEN
         CALL U2MESG('F','VOLUFINI_14',1,NOMAIL,1,IFA,0,0.D0)
      ENDIF
      CALL VFNULO(MAXFA1,MAXAR,NDIM,NNOS,NFACE,
     >            NBNOFA,NOSAR,NOSFA,NARFA)
      DO 1 IDIM = 1 , NDIM
         XG(IDIM)=GEOM(IDIM,NNO)
         XC(IDIM)=0.D0
    1 CONTINUE
      IF ( NDIM.EQ.2) THEN
C  ========================================
C  ========================================
C    2D
C  ======================================== 
C  ======================================== 
         DO 2 IFA=1,NFACE
            DO 2 IDIM=1,NDIM
               XFACE(IDIM,IFA)=GEOM(IDIM,NNOS+IFA)
               T(IDIM,IFA)=GEOM(IDIM,NOSFA(IFA,2))-
     >                     GEOM(IDIM,NOSFA(IFA,1))
    2    CONTINUE
C 
         IF (NFACE.EQ.3) THEN
            VOL=ABS(PDVC2D(T(1,1),T(1,2)))/2.D0
            EPSILO=EPSREL*SQRT(VOL)
         ELSE        
            VOL=(ABS(PDVC2D(T(1,1),T(1,4)))+
     >      ABS(PDVC2D(T(1,3),T(1,2))))/2.D0
         ENDIF
C     
         SA=0.D0
         DO 3 IFA = 1 ,NFACE
             MFACE(IFA)=SQRT(T(1,IFA)**2+T(2,IFA)**2)
             NORMFA(1,IFA)=-T(2,IFA)/MFACE(IFA)
             NORMFA(2,IFA)= T(1,IFA)/MFACE(IFA)
    3    CONTINUE
C  SI ON UTILISE LE CENTRE DU CERCLE CIRCONSCRIT ET QUE NOTRE 
C  MAILLAGE EST COMPOS� DE TRIANGLE UNIQUEMENT
C    
         IF(UTICER)THEN
            DO 4 IS = 1 ,NNOS
               IF1=ARIS(IS,1)
               IF2=ARIS(IS,2)
               A1VA2(IS)=PDVC2D(T(1,IF1),T(1,IF2))/
     >             (MFACE(IF1)*MFACE(IF2))
               A(IS)=SIN(2.D0*ABS(SIN(A1VA2(IS))))
               SA=SA+A(IS)
    4       CONTINUE
C
C CALCUL DES COORDONN�ES DU CERCLE CIRCONSCRIT 
            DO  31 IDIM=1,2
               DO 32 IS=1,NNOS
                  XC(IDIM)=XC(IDIM)+GEOM(IDIM,IS)*A(IS)/SA
   32          CONTINUE
   31       CONTINUE 
C
C ON REGARDE SI LE CENTRE DU CERCLE CIRCONSCRIT EST DANS LA MAILLE
C  SI IL EST DANS LA MAILLE ALORS XG=XC SINON XG
            XC(3)=1.D0
            DO 13 JJ=1,3
               DO 14 II=1,2
                   MATGEO(II,JJ)=GEOM(II,JJ)     
   14          CONTINUE 
               MATGEO(3,JJ)=1.D0 
   13       CONTINUE     
C
            CALL VFIMAT(3,3,MATGEO,MATG1)
C
            HINTR=.TRUE.
            DO  15 II=1,3
               LAMBDA(II)=0.D0
               DO 25 JJ=1,3
                  LAMBDA(II)= LAMBDA(II)+MATG1(II,JJ)*XC(JJ)
   25          CONTINUE
               IF(LAMBDA(II).LE.EPSILO) THEN
                  HINTR=.FALSE. 
               ENDIF  
   15       CONTINUE
         ENDIF
         IF(UTICER .AND. HINTR) THEN
            DO 16 IDIM = 1 , NDIM
               XG(IDIM) = XC(IDIM)
   16       CONTINUE
         ELSE
            CALL TECAEL(IADZI,IAZK24)
            NOMAIL = ZK24(IAZK24-1+3) (1:8)
         ENDIF
         DO 17 IFA = 1 ,NFACE
            DFACE(IFA)=(XFACE(1,IFA)-XG(1))*NORMFA(1,IFA)+
     >              (XFACE(2,IFA)-XG(2))*NORMFA(2,IFA)
            IF ( DFACE(IFA).LT.0.D0) THEN
               DFACE(IFA)=-DFACE(IFA)
               NORMFA(1,IFA)=-NORMFA(1,IFA)
               NORMFA(2,IFA)=-NORMFA(2,IFA)
            ENDIF
  17     CONTINUE                
      ELSE
C  ========================================
C  ========================================
C    3D
C  ======================================== 
C  ======================================== 
         VOL = 0.D0 
         DO 10 IDIM=1,NDIM
            XG(IDIM)=0.D0
            DO 18 IS = 1 , NNOS
               XG(IDIM)=XG(IDIM)+GEOM(IDIM,IS)
   18       CONTINUE
            XG(IDIM)=XG(IDIM)/NNOS
   10    CONTINUE        
C         
         DO 20 IFA=1,NFACE
C T(DIM,IAR) : VECTEURS DES ARETES DE LA FACE
            DO 22 IAR=1,NBNOFA(IFA)
               NS1=NOSAR(NARFA(IFA,IAR),1)
               NS2=NOSAR(NARFA(IFA,IAR),2)
               DO 21 IDIM=1,NDIM
                  T(IDIM,IAR)=GEOM(IDIM,NS2)-GEOM(IDIM,NS1)
   21          CONTINUE
   22       CONTINUE
C XS(DIM,NS) : COORD DES SOMMETS DE LA FACE
            DO 23 IS=1,NBNOFA(IFA)
               DO 24 IDIM=1,NDIM
                  XS(IDIM,IS)=GEOM(IDIM,NOSFA(IFA,IS))
   24          CONTINUE
   23       CONTINUE
            CALL VFGEFA(MAXDI1,NDIM,NBNOFA(IFA),XS,T,XG,
     >                 MFACE(IFA),NORMFA(1,IFA),XFACE(1,IFA),
     >                 DFACE(IFA),IRET)
C
            IF ( IRET.NE.0) THEN
               CALL TECAEL(IADZI,IAZK24)
               NOMAIL = ZK24(IAZK24-1+3) (1:8)
               CALL U2MESG('F','VOLUFINI_13',1,NOMAIL,1,IFA,0,0.D0)
            ENDIF     
            VOL=VOL+DFACE(IFA)*MFACE(IFA)/3.D0
   20    CONTINUE
      ENDIF
      END
