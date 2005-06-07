      SUBROUTINE XCFACE(ELREF,LSN,JGRLSN,IGEOM,
     &                            PINTER,NINTER,AINTER,NFACE,CFACE)
      IMPLICIT NONE 

      REAL*8        LSN(*)
      INTEGER       JGRLSN,IGEOM,NINTER,NFACE,CFACE(5,3)
      CHARACTER*8   ELREF
      CHARACTER*24  PINTER,AINTER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/01/2005   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                      TROUVER LES PTS D'INTERSECTION ENTRE LES ARETES
C                      ET LE PLAN DE FISSURE ET D�COUPAGE EN FACETTES 
C                    
C     ENTREE
C       ELREF    : �L�MENT DE R�F�RENCE	 
C       LSN      : VALEURS DE LA LEVEL SET NORMALE
C       JGRLSN   : ADRESSE DU GRADIENT DE LA LEVEL SET NORMALE
C       IGEOM    : ADRESSE DES COORDONN�ES DES NOEUDS DE L'ELT PARENT
C
C     SORTIE
C       PINTER  : COORDONN�ES DES POINTS D'INTERSECTION
C       NINTER  : NOMBRE DE POINTS D'INTERSECTION
C       AINTER  : INFOS ARETE ASSOCI�E AU POINTS D'INTERSECTION
C       NFACE   : NOMBRE DE FACETTES
C       CFACE   : CONNECTIVIT� DES NOEUDS DES FACETTES
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
      REAL*8          A(3),B(3),C(3),LSNA,LSNB,PADIST,LONGAR,TAMPOR(4)
      REAL*8          ALPHA,BAR(3),OA(3),M(3),AM(3),ND(3),PS,PS1,LAMBDA
      REAL*8          H(3),OH(3),NOH,COS,NOA,TRIGOM,R3(3),THETA(6),EPS
      REAL*8          R8PI
      INTEGER         J,AR(12,2),NBAR,NTA,NTB,NA,NB,JPTINT,INS,JAINT
      INTEGER         IA,I,IPT,IBID,PP,PD,TAMPOI,NNO,K
      INTEGER         IADZI,IAZK24
      CHARACTER*8     TYPMA
C ----------------------------------------------------------------------

      CALL JEMARQ()

      EPS=-1.0D-10

      CALL ELREF4(' ','RIGI',IBID,NNO,IBID,IBID,IBID,IBID,IBID,IBID)

C     1) RECHERCHE DES POINTS D'INTERSECTION
C     --------------------------------------

C     CR�ATION DU VECTEUR DES COORDONN�ES DES POINTS D'INTERSECTION
      CALL WKVECT(PINTER,'V V R',12*3,JPTINT)

C     VECTEUR R�EL � 4 COMPOSANTES, POUR CHAQUE PT D'INTER : 
C     - NUM�RO ARETE CORRESPONDANTE         (0 SI C'EST UN NOEUD SOMMET)
C     - NUM�RO NOEUD SI NOEUD SOMMET        (0 SINON)
C     - LONGUEUR DE L'ARETE                 
C     - POSITION DU PT SUR L'ARETE          (0 SI C'EST UN NOEUD SOMMET)
      CALL WKVECT(AINTER,'V V R',12*4,JAINT)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

      IPT=0
C     COMPTEUR DE POINT INTERSECTION = NOEUD SOMMENT
      INS=0
      CALL CONARE(TYPMA,AR,NBAR)

C     BOUCLE SUR LES ARETES POUR D�TERMINER LES POINTS D'INTERSECTION
      DO 100 IA=1,NBAR                

C       NUM NO DE L'�L�MENT
        NA=AR(IA,1)
        NB=AR(IA,2)   
        LSNA=LSN(NA)
        LSNB=LSN(NB)
        DO 110 I=1,3  
          A(I)=ZR(IGEOM-1+3*(NA-1)+I)
          B(I)=ZR(IGEOM-1+3*(NB-1)+I)
 110    CONTINUE       
        LONGAR=PADIST(3,A,B)
        IF ((LSNA*LSNB).LE.0) THEN
          IF (LSNA.EQ.0) THEN
C           ON AJOUTE A LA LISTE LE POINT A
            CALL XAJPIN(JPTINT,12,IPT,INS,A,LONGAR,JAINT,0,NA,0.D0)
          ENDIF
          IF (LSNB.EQ.0) THEN
C           ON AJOUTE A LA LISTE LE POINT B
            CALL XAJPIN(JPTINT,12,IPT,INS,B,LONGAR,JAINT,0,NB,0.D0)
          ENDIF
          IF (LSNA.NE.0.AND.LSNB.NE.0) THEN
C           INTERPOLATION DES COORDONN�ES DE C
            DO 130 I=1,3          
              C(I)=A(I)-LSNA/(LSNB-LSNA)*(B(I)-A(I))            
 130        CONTINUE
C           POSITION DU PT D'INTERSECTION SUR L'ARETE
            ALPHA=PADIST(3,A,C)
C           ON AJOUTE A LA LISTE LE POINT C
            CALL XAJPIN(JPTINT,12,IPT,IBID,C,LONGAR,JAINT,IA,0,ALPHA)
          ENDIF
        ENDIF

 100  CONTINUE
      NINTER=IPT 

      IF (0.EQ.1) THEN
        WRITE(6,*)'POINTS D''INTERSECTION NON TRIES'
        DO 150 I=1,NINTER
          DO 151 J=1,3
            WRITE(6,*)' ',ZR(JPTINT-1+(I-1)*3+J)
 151      CONTINUE
 150    CONTINUE
      ENDIF

C     2) D�COUPAGE EN FACETTES TRIANGULAIRES DE LA SURFACE D�FINIE
C     ------------------------------------------------------------

C                  (BOOK IV 09/09/04)

      IF (NINTER.LT.3) GOTO 500 

      DO 200 I=1,5
        DO 201 J=1,3
          CFACE(I,J)=0 
 201    CONTINUE
 200  CONTINUE

C     NORMALE A LA FISSURE (MOYENNE DE LA NORMALE AUX NOEUDS)
      CALL LCINVN(3,0.D0,ND)
      DO 210 I=1,NNO
        DO 211 J=1,3
          ND(J)=ND(J)+ZR(JGRLSN-1+3*(I-1)+J)/NNO
 211    CONTINUE
 210  CONTINUE

C     PROJECTION ET NUMEROTATION DES POINTS COMME DANS XORIFF
      CALL LCINVN(3,0.D0,BAR)
      DO 220 I=1,NINTER
        DO 221 J=1,3
          BAR(J)=BAR(J)+ZR(JPTINT-1+(I-1)*3+J)/NINTER
 221    CONTINUE
 220  CONTINUE
      DO 230 J=1,3
        A(J)=ZR(JPTINT-1+(1-1)*3+J)
        OA(J)=A(J)-BAR(J)
 230  CONTINUE
      NOA=SQRT(OA(1)*OA(1) + OA(2)*OA(2)  +  OA(3)*OA(3))

C     BOUCLE SUR LES POINTS D'INTERSECTION POUR CALCULER L'ANGLE THETA
      DO 240 I=1,NINTER
        DO 241 J=1,3
          M(J)=ZR(JPTINT-1+(I-1)*3+J)
          AM(J)=M(J)-A(J)
 241    CONTINUE
        CALL PSCAL(3,AM,ND,PS)

        CALL PSCAL(3,ND,ND,PS1)
        LAMBDA=-PS/PS1
        DO 242 J=1,3
          H(J)=M(J)+LAMBDA*ND(J)
          OH(J)=H(J)-BAR(J)
 242    CONTINUE
        CALL PSCAL(3,OA,OH,PS)

        NOH=SQRT(OH(1)*OH(1) + OH(2)*OH(2)  +  OH(3)*OH(3))
        COS=PS/(NOA*NOH)

        THETA(I)=TRIGOM('ACOS',COS)
C       SIGNE DE THETA (06/01/2004)
        CALL PROVEC(OA,OH,R3)
        CALL PSCAL(3,R3,ND,PS)
        IF (PS.LT.EPS) THETA(I) = -1 * THETA(I) + 2 * R8PI()

 240  CONTINUE 

C     TRI SUIVANT THETA CROISSANT
      DO 250 PD=1,NINTER-1
        PP=PD
        DO 251 I=PP,NINTER
          IF (THETA(I).LT.THETA(PP)) PP=I
 251    CONTINUE
        TAMPOR(1)=THETA(PP)
        THETA(PP)=THETA(PD)
        THETA(PD)=TAMPOR(1)
        DO 252 K=1,3
          TAMPOR(K)=ZR(JPTINT-1+3*(PP-1)+K)
          ZR(JPTINT-1+3*(PP-1)+K)=ZR(JPTINT-1+3*(PD-1)+K)
          ZR(JPTINT-1+3*(PD-1)+K)=TAMPOR(K)
 252    CONTINUE
        DO 253 K=1,4
          TAMPOR(K)=ZR(JAINT-1+4*(PP-1)+K)
          ZR(JAINT-1+4*(PP-1)+K)=ZR(JAINT-1+4*(PD-1)+K)
          ZR(JAINT-1+4*(PD-1)+K)=TAMPOR(K)
 253    CONTINUE
 250  CONTINUE


 500  CONTINUE

      IF (NINTER.GT.6) THEN
        CALL UTMESS('F','XCFACE','NOMBRE DE POINTS D''INTERSECTION '//
     &                                                'IMPOSSIBLE.') 
      ELSEIF (NINTER.EQ.6) THEN
         NFACE=4
         CFACE(1,1)=1
         CFACE(1,2)=2 
         CFACE(1,3)=3
         CFACE(2,1)=1
         CFACE(2,2)=3 
         CFACE(2,3)=5 
         CFACE(3,1)=1
         CFACE(3,2)=5 
         CFACE(3,3)=6
         CFACE(4,1)=3
         CFACE(4,2)=4 
         CFACE(4,3)=5 
      ELSEIF (NINTER.EQ.5) THEN
         NFACE=3
         CFACE(1,1)=1
         CFACE(1,2)=2 
         CFACE(1,3)=3
         CFACE(2,1)=1
         CFACE(2,2)=3 
         CFACE(2,3)=4 
         CFACE(3,1)=1
         CFACE(3,2)=4 
         CFACE(3,3)=5
      ELSEIF (NINTER.EQ.4) THEN
         NFACE=2
         CFACE(1,1)=1
         CFACE(1,2)=2 
         CFACE(1,3)=3
         CFACE(2,1)=1
         CFACE(2,2)=3 
         CFACE(2,3)=4 
      ELSEIF (NINTER.EQ.3) THEN
         NFACE=1
         CFACE(1,1)=1 
         CFACE(1,2)=2 
         CFACE(1,3)=3
      ELSE
         NFACE=0         
      ENDIF

      IF (0.EQ.1) THEN
        WRITE(6,*)'CFACE '
        DO 300 I=1,NFACE
          DO 301 J=1,3
            WRITE(6,*)' ',CFACE(I,J)
 301      CONTINUE
 300    CONTINUE
      ENDIF

      CALL JEDEMA()
      END
