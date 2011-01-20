      SUBROUTINE       XPLMAT(NDIM,NFH,NFE,DDLC,DDLM,NNOS,NNOM,N,PL)

      IMPLICIT NONE
      INTEGER          NDIM,NFH,NFE,DDLC,NNOS,NNOM,N,PL,DDLM

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/01/2011   AUTEUR MASSIN P.MASSIN 
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
C
C    CADRE : X-FEM ET CONTACT CONTINU
C             CALCULE LA PLACE DU LAMBDA(N) NORMAL DANS LA MATRICE
C             DE RAIDEUR DUE AU CONTACT 
C
C IN  NDIM    : DIMENSION (=3)
C IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NNO     : NOMBRE DE NOEUDS SOMMET
C IN  NNOM    : NOMBRE DE NOEUDS MILIEU
C IN  N       : NUM�RO DU NOEUD PORTANT LE LAMBDA
C
C OUT PL      : PLACE DU LMBDA DANS LA MATRICE
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
      INTEGER       DDLS      

C ----------------------------------------------------------------------
      CALL ASSERT(N.LE.(NNOS+NNOM))

C     NOMBRE DE DDL PAR NOEUD SOMMET 
      DDLS=NDIM*(1+NFH+NFE)+DDLC

C     PLACE DU PREMIER DDL DE CONTACT POUR CHAQUE N
      IF (N.LE.NNOS) THEN
        PL=DDLS*N-DDLC+1
      ELSE
        PL=DDLS*NNOS+DDLM*(N-NNOS)-DDLC+1
      ENDIF

      END
