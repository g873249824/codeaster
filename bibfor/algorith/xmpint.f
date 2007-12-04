      SUBROUTINE XMPINT(ELREFP,NDIM,IGEOM,JPINTE,IFA,TYPEM,NNO,
     &                  IPINT)
      IMPLICIT NONE 

      INTEGER       JPINTE,IFA,IGEOM,IPINT,NDIM,TYPEM,NNO
      CHARACTER*8   ELREFP

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/10/2007   AUTEUR NISTOR I.NISTOR 
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
C
C                   CALCUL DES COORDONN�ES R�ELLE POUR LES POINTS
C              D'INTERSECTION CONSTITUENT LA MAILLE DE CONTACT
C              DANS L'ELEMENT DE CONTACT HYBRIDE X-FEM
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C   ENTREE
C     ELREFP  : TYPE DE L'ELEMENT DE REF PARENT
C     NDIM    : DIMENSION DU PROBLEME
C     IGEOM   : COORDONNEES DES NOEUDS DE L'ELEMENT DE REF PARENT
C     JPINTE  : COORDONN�ES DES POINTS D'INTERSECTION DANS L'ELEM DE REF
C     IFA     : INDICE DE LA FACETTE DONT LE POINT DE CONTACT APPARTIENT
C     TYPEM   : INDICATEUR DU COTE ESCLAVE (=1) OU MAITRE (=2)
C     NNO     : NOMBRE DE NOUEDS DE L'ELEMENT DE REF PARENT
C
C   SORTIE
C     IPINT   : COORDONN�ES R�ELES DES POINTS D'INTERSECTION
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
      REAL*8          A(3),B(3)
      REAL*8          FFA(NNO),FFB(NNO)
      INTEGER         I,J,K

C ----------------------------------------------------------------------

      CALL JEMARQ()

C     COORDONN�ES DES SOMMETS DE LA FACETTE DANS LE REP�RE DE REFRENCE 
      IF (NDIM.EQ.2) THEN
C-----LA MAILLE 'PARENT' EST L'ESCLAVE
        IF (TYPEM.EQ.1) THEN
          DO 10 J=1,NDIM
            A(J)= ZR(JPINTE-1+J)
            B(J)= ZR(JPINTE-1+NDIM+J)
 10       CONTINUE
        ELSEIF (TYPEM.EQ.2) THEN
          DO 20 J=1,NDIM
            A(J)= ZR(JPINTE-1+18+J)
            B(J)= ZR(JPINTE-1+18+NDIM+J)
 20       CONTINUE
        ENDIF
      ELSEIF (NDIM.EQ.3) THEN
C----!!!!CETTE PARTIE EST � PROGRAMMER (TENIR COMPTE DE IFA)!!!!!
        WRITE(6,*)'3D PAS ENCORE IMPLEMENTE'
      ENDIF

C     PASSAGE DES COORD DES SOMMETS A ET B DANS LE REP�RE 2D R�EL

      CALL ELRFVF(ELREFP,A,NNO,FFA,NNO)
      CALL ELRFVF(ELREFP,B,NNO,FFB,NNO)

      DO 110 I=1,NDIM
        DO 120 K=1,NNO
           ZR(IPINT-1+I)     = ZR(IPINT-1+I)
     &                        +FFA(K)*ZR(IGEOM-1+NDIM*(K-1)+I)
          ZR(IPINT-1+NDIM+I)=ZR(IPINT-1+NDIM+I)
     &                        +FFB(K)*ZR(IGEOM-1+NDIM*(K-1)+I)

 120    CONTINUE
 110  CONTINUE

      CALL JEDEMA()
      END
