      SUBROUTINE INTFAC(IFQ,FA,NNO,LST,LSN,NDIM,GRAD,JGLSN,JGLST,IGEOM,
     &                  M,GLN,GLT,CODRET)
      IMPLICIT NONE

      INTEGER       IFQ,FA(6,4),NNO,NDIM,JGLSN,JGLST,IGEOM,CODRET
      REAL*8        LSN(NNO),LST(NNO),M(NDIM),GLN(NDIM),GLT(NDIM)
      CHARACTER*3   GRAD

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/10/2009   AUTEUR MESSIER J.MESSIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C              TROUVER LES PTS D'INTERSECTION ENTRE LE FOND DE FISSURE
C                 ET UNE FACE POUR LES ELEMENTS EN FOND DE FISSURE
C
C     ENTREE
C  IFQ    : NUMERO LOCAL DE LA FACE DE LA MAILLE
C  FA     : COONECTIVITE DES FACES DE LA MAILLE
C  NNO    : NOMBRE DE NOEUDS DE LA MAILLE
C  LSN    : VECTEUR LOCAL DES VALEURS NODALES DE LA MAILLE POUR LSN
C  LST    : VECTEUR LOCAL DES VALEURS NODALES DE LA MAILLE POUR LST
C  NDIM   : DIMENSION DE L'ESPACE
C  GRAD   : SI 'OUI' : ON CALCULE AUSSI LES GRADIENTS AU POINT TROUVE
C  JGLSN  : ADRESSE DU VECTEUR LOCAL DES VALEURS NODALES DE GRAD DE LSN
C  JGLST  : ADRESSE DU VECTEUR LOCAL DES VALEURS NODALES DE GRAD DE LST
C  IGEOM  : ADRESSE DU VECTEUR LOCAL DES COORDONNEES DES NOEUDS
C
C     SORTIE
C  M      : POINT TROUVE
C  GLN    : GRAD DE LSN EN M (SI DEMANDE)
C  GLT    : GRAD DE LST EN M (SI DEMANDE)
C  CODRET : CODE RETOUR = 1 SI ON A BIEN TROUVE UN POINT M
C                       = 0 SI ON N'A PAS PU TROUVE UN UNIQUE POINT M
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

      INTEGER       NNOF,I,J,NNE,INO,IRET
      REAL*8        R8PREM,COORMA(8),PREC,MP(2),EPSI(2),FF(NNO),
     &              LSTA,LSNA,LSTB,LSNB   
      CHARACTER*8   ELREF,ALIAS
      LOGICAL       CHGSGN     

C ----------------------------------------------------------------------

      CALL JEMARQ()

      CALL VECINI(NDIM,0.D0,M)
      IF (GRAD.EQ.'OUI') THEN
        CALL VECINI(NDIM,0.D0,GLN)
        CALL VECINI(NDIM,0.D0,GLT)
      ENDIF

      PREC=100.D0*R8PREM()
      CODRET = 0

C     Initialisation des coordonn�es (LS) des noeuds de la face
      CALL VECINI(8,0.D0,COORMA)
      LSTA=0.D0
      LSNA=0.D0
      LSTB=0.D0
      LSNB=0.D0

C     NOMBRE DE SOMMETS DE LA FACE
      IF (FA(IFQ,4).EQ.0) THEN
        NNOF = 3
        ALIAS = 'TR3'
      ELSE
        NNOF = 4
        ALIAS='QU4'
      ENDIF
      CALL ASSERT(NNOF.LE.4)

C     NOEUDS SOMMETS DE LA FACE : FA(IFQ,1) ... FA(IFQ,NNOF)

      CHGSGN = .FALSE.        
      DO 220 I=1,NNOF
         IF (I.EQ.1) THEN
           J = NNOF
         ELSE
           J = I-1
         ENDIF
        LSTA=LST(FA(IFQ,I))
        LSNA=LSN(FA(IFQ,I))
        LSTB=LST(FA(IFQ,J))
        LSNB=LSN(FA(IFQ,J))        
        COORMA(2*I-1)=LSTA
        COORMA(2*I)=LSNA

C       On accepte tout de suite la face si le front coincide
C       avec l'un des noeuds ou un point de l'arete
        IF (((LSNA.EQ.0.D0).AND.(LSTA.EQ.0.D0)).OR.
     &(((LSNA.EQ.0.D0).AND.(LSNB.EQ.0.D0)).AND.
     &((LSTA*LSTB).LT.R8PREM()))) THEN
         CHGSGN = .TRUE.
         GOTO 220
        
        ENDIF

C     On ne conserve que les faces coupees
C     sur une seule arete par le demi-plan (lsn=0/lst<0)
C     Pour cela, on controle le signe de lst(I) ou I est le point 
C     d'intersection de l'arete avec lsn=0
C     (on a lsn(I)=lst(B)-lsn(B)*(lst(A)-lst(B))/(lsn(A)-lsn(B)))
        IF ((LSNA*LSNB).LT.PREC) THEN      

           IF (((ABS((LSNA-LSNB)).GT.R8PREM()).AND.
     &((LSTB-(LSNB*(LSTA-LSTB)/(LSNA-LSNB))).LT.PREC)).OR.
     &((ABS((LSNA-LSNB)).LE.R8PREM()).AND.
     &((LSTA*LSTB).LT.R8PREM()))) THEN

              CHGSGN = .TRUE.

            ENDIF

        ENDIF   

 220  CONTINUE

       IF (.NOT. CHGSGN) GOTO 999
       
C     ON CHERCHE SUR LA MAILLE LE POINT CORRESPONDANT � LSN=LST=0
      MP(1)=0.D0
      MP(2)=0.D0
      CALL REEREG('C',ALIAS,NNOF,COORMA,MP,2,EPSI,IRET)

      IF (IRET.EQ.1) GOTO 999
 
C     ON NE PREND PAS EN COMPTE LES POINTS QUI SORTENT DU DOMAINE
      IF (ALIAS.EQ.'QU4') THEN
        IF (ABS(EPSI(1)).GT.1.D0) GOTO 999
        IF (ABS(EPSI(2)).GT.1.D0) GOTO 999
      ELSEIF (ALIAS.EQ.'TR3') THEN
        IF (EPSI(1).LT.0.D0)         GOTO 999
        IF (EPSI(2).LT.0.D0)         GOTO 999
        IF (EPSI(1)+EPSI(2).GT.1.D0) GOTO 999
      ENDIF
          
      MP(1)=EPSI(1)
      MP(2)=EPSI(2)                    
C     ON DOIT MAINTENANT MULTIPLIER LES COORD. PARAM. DE M PAR CHACUNE
C     DES FF DES NOEUDS DE L'�L�MENT POUR OBTENIR LES COORD. CART.
      CALL ELRFVF(ALIAS,MP,NNOF,FF,NNE)
      DO 230 I=1,NDIM
        DO 240 J=1,NNOF
          INO = FA(IFQ,J)
          M(I) = M(I) + ZR(IGEOM-1+NDIM*(INO-1)+I) * FF(J)
          IF (GRAD.EQ.'OUI') THEN
            GLT(I) = GLT(I) + ZR(JGLST-1+NDIM*(INO-1)+I) * FF(J)
            GLN(I) = GLN(I) + ZR(JGLSN-1+NDIM*(INO-1)+I) * FF(J)
          ENDIF
 240    CONTINUE          
 230  CONTINUE          


C     TOUT S'EST BIEN PASSE
      CODRET = 1

999   CONTINUE

      CALL JEDEMA()
      END
